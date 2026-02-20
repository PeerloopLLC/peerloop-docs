# Page: Moderator Queue

**Code:** MODQ
**URL:** `/moderate`
**Access:** Authenticated (Moderator role)
**Priority:** P1
**Status:** In Scope

---

## Purpose

Content moderation dashboard for reviewing flagged content, taking action on violations, and maintaining community standards.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Moderation Queue" link | From admin dashboard |
| Nav | "Moderation" link | Moderator navigation |
| NOTF | Moderation notification | New flagged content alert |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| FEED | Post context link | View post in context |
| PROF | User profile link | View reported user |
| ADMN | "Admin Dashboard" | Back to admin (if admin+mod) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| content_flags | id, post_id, flagged_by, reason, status, created_at | Flag queue |
| posts | id, author_id, content, course_id, is_pinned, created_at | Post content |
| users (author) | id, name, avatar, handle | Author info |
| users (flagger) | id, name | Who flagged |

---

## Sections

### Queue Header
- "Moderation Queue"
- Pending count: "X items pending review"
- Filter options

### Filter Bar
- **Status:** Pending / Reviewed / All
- **Type:** All / Posts / Messages / Profiles
- **Priority:** All / High / Medium / Low
- **Date Range:** Filter by flag date

### Flagged Content List
- List of flagged items, newest first
- Each item shows:
  - **Content Preview:**
    - Post content (truncated)
    - Author name + avatar
    - Post date
  - **Flag Info:**
    - Reason for flag
    - Flagged by (name)
    - Flag date
  - **Quick Actions:**
    - "Dismiss" (not a violation)
    - "Remove" (delete content)
    - "Warn" (warn user)
    - "Ban" (ban user)

### Item Detail View (Expanded/Modal)
- **Full Content:**
  - Complete post text
  - Any media attachments
  - Course context (if course-specific)
- **Author Info:**
  - Name, handle, avatar
  - Account age
  - Previous violations count
  - "View Profile" → PROF
- **Flag Details:**
  - All flags on this content (may be multiple)
  - Each: reason, flagger, date
- **Context:**
  - "View in Feed" → FEED
  - Surrounding conversation (if reply)
- **Actions:**
  - Dismiss flag (not violation)
  - Remove content only
  - Remove + warn user
  - Remove + temp ban
  - Remove + permanent ban
- **Notes:**
  - Add moderator notes
  - Internal documentation

### Moderator Actions Panel
- **Dismiss:**
  - Mark as reviewed, no action
  - Content remains
- **Remove Content:**
  - Delete post/message
  - Author sees "Content removed for violation"
- **Warn User:**
  - Send warning notification
  - Track warning count
- **Temp Ban:**
  - Duration selector (1 day, 7 days, 30 days)
  - User cannot post during ban
- **Permanent Ban:**
  - Requires confirmation
  - User account suspended

### Action History
- Log of moderator actions
- Who did what, when
- Reversible within time window

### Statistics (Optional)
- Flags this week
- Resolution rate
- Most common violation types

---

## User Stories Fulfilled

- US-M001: Access moderation queue
- US-M002: Review flagged content
- US-M003: Take action on violations
- US-M004: Dismiss false flags
- US-M005: Warn or ban users
- US-M009: Track moderation history

---

## States & Variations

| State | Description |
|-------|-------------|
| Queue | Viewing pending items |
| Item Detail | Reviewing specific item |
| Taking Action | Action confirmation |
| Empty Queue | No pending items |
| Filtered | Viewing filtered subset |

---

## Mobile Considerations

- List view primary
- Swipe actions for quick dismiss/remove
- Detail view as full screen
- Ban confirmation requires extra steps

---

## Error Handling

| Error | Display |
|-------|---------|
| Action fails | "Unable to complete action. Try again." |
| Content already actioned | "This content was already reviewed." |
| Load fails | "Unable to load queue. [Retry]" |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | pending_count |
| `item_reviewed` | Item opened | flag_id |
| `action_taken` | Mod action completed | flag_id, action_type |
| `flag_dismissed` | Dismissed as not violation | flag_id |
| `user_warned` | Warning issued | user_id |
| `user_banned` | Ban issued | user_id, duration |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/moderation/queue` | Page load | Flagged content list |
| `GET /api/moderation/queue/:id` | Detail open | Full flag details |
| `POST /api/moderation/queue/:id/dismiss` | Dismiss | Mark not violation |
| `POST /api/moderation/queue/:id/remove` | Remove | Delete content |
| `POST /api/moderation/queue/:id/warn` | Warn | Issue user warning |
| `POST /api/moderation/queue/:id/ban` | Ban | Suspend user |
| `GET /api/moderation/history` | History tab | Past actions |
| `GET /api/moderation/stats` | Statistics | Queue metrics |

**Query Parameters:**
- `status` - pending, reviewed
- `type` - post, message, profile
- `priority` - high, medium, low
- `from`, `to` - Date range
- `page`, `limit` - Pagination

**Queue Response:**
```typescript
GET /api/moderation/queue
{
  items: [{
    id,
    content: { id, type, text, author_id },
    author: { id, name, avatar, handle },
    flags: [{
      reason, flagged_by: { name }, flagged_at
    }],
    priority: 'high' | 'medium' | 'low'
  }],
  pagination: { page, limit, total }
}
```

**Flag Detail Response:**
```typescript
GET /api/moderation/queue/:id
{
  content: { id, type, full_text, media_urls, course_id },
  author: {
    id, name, handle, avatar,
    account_age_days: number,
    previous_violations: number
  },
  flags: [...],
  context: {
    feed_url: string,
    surrounding_posts?: [...]
  }
}
```

**Moderation Actions:**
```typescript
POST /api/moderation/queue/:id/dismiss
{ notes?: string }

POST /api/moderation/queue/:id/remove
{ notes?: string, warn?: boolean }

POST /api/moderation/queue/:id/warn
{ message: string, notes?: string }

POST /api/moderation/queue/:id/ban
{
  duration: 'temp_1d' | 'temp_7d' | 'temp_30d' | 'permanent',
  reason: string,
  notes?: string
}
```

---

## Notes

- CD-010: Community Moderator is distinct role from Creator
- Consider escalation path to admin for severe cases
- Appeal process for banned users (future)
- Auto-flag based on keywords/patterns (future)
- Moderator training/guidelines document needed
