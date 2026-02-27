# LEAD - Leaderboard

| Field | Value |
|-------|-------|
| Route | `/community/leaderboard` |
| Access | Authenticated |
| Priority | P3 |
| Status | 📋 Spec Only (Post-MVP) |
| Block | - |
| JSON Spec | `src/data/pages/leaderboard.json` |
| Astro Page | `src/pages/leaderboard.astro` |

---

## Purpose

Display community rankings based on goodwill points, helping users see their standing and motivating engagement.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-P053 | As a Platform, I need to display leaderboards so that community standing is transparent | P3 | 📋 |
| US-P082 | As a Platform, I need to unlock rewards at point thresholds so that goodwill points have value | P3 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| FEED | "Leaderboard" link/tab | Community navigation |
| PROF | "View Leaderboard" link | From profile stats |
| SDSH | "Community Standing" widget | Dashboard link |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| STPR | Click on user name | View user profile | 📋 |
| FEED | Back/breadcrumb | Return to feed | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | id, name, avatar, goodwill_points | User rankings |
| goodwill_transactions | points, created_at | Points history |
| user_badges | badge_type, earned_at | Achievement display |
| leaderboard_entries | user_id, rank, points, category, period | Cached rankings |

---

## Features

### Your Ranking
- [ ] Current user's position highlighted `[US-P053]`
- [ ] Points total `[US-P053]`
- [ ] Rank change indicator (↑↓) `[US-P053]`
- [ ] Percentile (top X%) `[US-P053]`

### Rankings Table
- [ ] Rank position number `[US-P053]`
- [ ] User avatar + name `[US-P053]`
- [ ] Points total `[US-P053]`
- [ ] Badge icons earned `[US-P053]`
- [ ] Rank movement since last period `[US-P053]`

### Filters
- [ ] Time period filter (All Time, This Month, This Week) `[US-P053]`
- [ ] Category tabs (Overall, Helpers, Teachers, Contributors) `[US-P053]`

### Rewards Tiers
- [ ] Visual display of point thresholds (500, 1000, 2500, 5000) `[US-P082]`
- [ ] What unlocks at each tier `[US-P082]`
- [ ] User's progress toward next tier `[US-P082]`

---

## Sections (from Plan)

### Header
- Page title: "Community Leaderboard"
- Time period filter (All Time, This Month, This Week)

### Your Ranking
- Current position
- Points total
- Rank change indicator
- Percentile display

### Top Rankings Table

| Column | Content |
|--------|---------|
| Rank | Position number |
| User | Avatar + name |
| Points | Goodwill points total |
| Badges | Badge icons earned |
| Change | Rank movement |

### Leaderboard Categories (Tabs)
- **Overall** - Total goodwill points
- **Helpers** - Points from helping others
- **Teachers** - S-T session ratings
- **Contributors** - Content creation points

### Rewards Tiers
- Tier visualization with thresholds
- Progress bar to next tier
- Unlock information

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/leaderboard` | GET | Get rankings | 📋 |
| `/api/leaderboard/me` | GET | User's rank | 📋 |
| `/api/users/me/rewards` | GET | User's unlocked rewards | 📋 |

**Query Parameters:**
- `category` - overall, helpers, teachers, contributors
- `period` - week, month, all_time

**Leaderboard Response:**
```typescript
GET /api/leaderboard?category=overall&period=month
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

**Rewards Response:**
```typescript
GET /api/users/me/rewards
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
```

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Showing overall leaderboard |
| Category | Filtered to specific category |
| Time Period | Filtered to week/month/all-time |
| Loading | Fetching rankings |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load leaderboard. [Retry]" |
| No data | "Leaderboard updates daily" (if new) |

---

## Mobile Considerations

- Simplified table for mobile (hide some columns)
- Swipeable category tabs
- Sticky "Your Ranking" section at top

---

## Implementation Notes

- **Feature Flag:** `leaderboard` - check with `canAccess('leaderboard')`
- **Dependencies:** Requires `goodwill_points` feature enabled
- Anti-gaming: Rate limits on point awards, monitoring for suspicious patterns
- Privacy: Users can opt-out (excluded from rankings)
- Cache rankings hourly (not real-time) for performance via KV
- CD-023 defines point thresholds: 500, 1000, 2500, 5000
- Rankings stored in leaderboard_entries table for historical tracking
- Cron job (Cloudflare Scheduled Worker) recalculates hourly
