# Page: Leaderboard

**Code:** LEAD
**URL:** `/leaderboard`
**Access:** Public (user rank requires auth)
**Priority:** P3
**Status:** ✅ Implemented (user_stats based, goodwill pending)

---

## Purpose

Display community rankings based on goodwill points, helping users see their standing and motivating engagement.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| FEED | "Leaderboard" link/tab | Community navigation |
| PROF | "View Leaderboard" link | From profile stats |
| SDSH | "Community Standing" widget | Dashboard link |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| STPR | Click on user name | View user profile |
| FEED | Back/breadcrumb | Return to feed |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | id, name, avatar, goodwill_points | User rankings |
| goodwill_transactions | points, created_at | Points history |
| user_badges | badge_type, earned_at | Achievement display |

---

## Sections

### Header
- Page title: "Community Leaderboard"
- Time period filter (All Time, This Month, This Week)

### Your Ranking
- Current user's position highlighted
- Points total
- Rank change indicator (↑↓)

### Top Rankings Table

| Column | Content |
|--------|---------|
| Rank | Position number |
| User | Avatar + name |
| Points | Goodwill points total |
| Badges | Badge icons earned |
| Change | Rank movement since last period |

### Leaderboard Categories (Tabs)
- **Overall** - Total goodwill points
- **Helpers** - Points from helping others
- **Teachers** - S-T session ratings
- **Contributors** - Content creation points

### Rewards Tiers
- Visual display of point thresholds (500, 1000, 2500, 5000)
- What unlocks at each tier
- User's progress toward next tier

---

## User Stories Fulfilled

- US-P053: As a System, I need to display leaderboards/rankings so that community standing is transparent
- US-P082: As a System, I need to unlock rewards at point thresholds (500, 1000, 2500, 5000) so that goodwill points have tangible value

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Showing overall leaderboard |
| Category | Filtered to specific category |
| Time Period | Filtered to week/month/all-time |
| Loading | Fetching rankings |

---

## Mobile Considerations

- Simplified table for mobile (hide some columns)
- Swipeable category tabs
- Sticky "Your Ranking" section at top

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load leaderboard. [Retry]" |
| No data | "Leaderboard updates daily" (if new) |

---

## Analytics Events

| Event | Trigger |
|-------|---------|
| leaderboard_viewed | Page load |
| leaderboard_category_changed | Category tab switch |
| leaderboard_user_clicked | Click on user row |

---

## Server Integration

### Feature Flag
```typescript
// Requires: canAccess('leaderboard')
// Depends on: goodwill_points
```

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/leaderboard` | Page load | Get rankings |
| `GET /api/leaderboard/me` | Page load | User's rank |
| `GET /api/users/me/rewards` | Rewards section | User's unlocked rewards |

### Leaderboard Data

```typescript
// GET /api/leaderboard?category=overall&period=month
{
  period: 'month',
  category: 'overall',
  rankings: [
    {
      rank: 1,
      user: { id, name, avatar },
      points: 2500,
      badges: ['top_helper', 'certified_st'],
      change: +2  // rank change since last period
    }
  ],
  user_rank: {
    rank: 47,
    points: 150,
    change: -3,
    percentile: 85  // top 15%
  }
}
```

### Categories

```typescript
// Different leaderboard views:
overall:     SUM(all goodwill_transactions)
helpers:     SUM(transactions WHERE reason IN ('chat_help', 'summon_help'))
teachers:    AVG(session_ratings) * session_count
contributors: SUM(transactions WHERE reason = 'content_contribution')
```

### Period Filtering

```typescript
// Periods supported:
week:     WHERE created_at > NOW() - 7 days
month:    WHERE created_at > NOW() - 30 days
all_time: No date filter

// Data stored in leaderboard_entries for performance
// Updated by cron job (hourly)
```

### Rewards/Tiers

```typescript
// GET /api/users/me/rewards
{
  current_points: 750,
  current_tier: { name: 'Helper', threshold: 500 },
  next_tier: { name: 'Champion', threshold: 1000, points_needed: 250 },
  unlocked_rewards: [
    { id, name: 'Custom Avatar Frame', unlocked_at }
  ],
  available_rewards: [
    { id, name: 'Profile Badge', threshold: 1000 }
  ]
}

// Tier thresholds (CD-023):
// 500   - Helper
// 1000  - Champion
// 2500  - Expert
// 5000  - Legend
```

### Caching Strategy

```typescript
// Leaderboard computed hourly, stored in KV:
KV: leaderboard:{category}:{period} → JSON rankings

// User rank computed on-demand but cached:
KV: user_rank:{user_id}:{category}:{period} → rank data (TTL: 5 min)

// Cron job (Cloudflare Scheduled Worker):
// Every hour: recalculate all leaderboards, update KV
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   LEAD      │      │  PeerLoop   │      │   KV Cache  │
│   (Client)  │      │  (Server)   │      │             │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /leaderboard   │                    │
       │───────────────────>│                    │
       │                    │ Check KV cache     │
       │                    │───────────────────>│
       │                    │ cached rankings    │
       │                    │<───────────────────│
       │ { rankings }       │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ GET /leaderboard/me│                    │
       │───────────────────>│                    │
       │                    │ Calculate rank     │
       │ { user_rank }      │ (or from cache)    │
       │<───────────────────│                    │

Hourly Cron Job:
  Scheduled Worker
       │
       │ Query goodwill_transactions
       │ Aggregate by user
       │ Sort and rank
       │ Store in leaderboard_entries (D1)
       │ Update KV cache
```

---

## Notes

- **Current Implementation:** Uses `user_stats` table (students_taught, courses_completed, average_rating)
- **Future:** Add goodwill_points category when CD-023 is implemented
- Privacy: Only shows users with `privacy_public = 1`
- Minimum 3 reviews required for "Highest Rated" category
- CD-023 defines point thresholds: 500, 1000, 2500, 5000 (for future goodwill system)

## Implementation Status

| Feature | Status |
|---------|--------|
| Top Teachers category | ✅ |
| Top Learners category | ✅ |
| Highest Rated category | ✅ |
| User's own rank display | ✅ |
| Category tabs | ✅ |
| Goodwill Points category | ⏳ Pending CD-023 |
| Time period filtering | ⏳ Pending |
| Rewards/Tiers section | ⏳ Pending CD-023 |
