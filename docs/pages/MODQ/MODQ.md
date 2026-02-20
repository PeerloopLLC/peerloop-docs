# MODQ - Moderator Queue

| Field | Value |
|-------|-------|
| Route | `/moderate` |
| Access | Authenticated (Moderator role) |
| Priority | P1 |
| Status | 📋 Spec Only |
| Block | 8 |
| JSON Spec | `src/data/pages/mod/index.json` |
| Astro Page | `src/pages/mod/index.astro` |

---

## Purpose

Content moderation dashboard for reviewing flagged content, taking action on violations, and maintaining community standards.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-M001 | As a Moderator, I need access to the moderation queue so that I can review flagged content | P1 | 📋 |
| US-M002 | As a Moderator, I need to review flagged content so that I can assess violations | P1 | 📋 |
| US-M003 | As a Moderator, I need to take action on violations so that I can enforce guidelines | P1 | 📋 |
| US-M004 | As a Moderator, I need to dismiss false flags so that innocent content stays | P1 | 📋 |
| US-M005 | As a Moderator, I need to warn or ban users so that repeat offenders are handled | P1 | 📋 |
| US-M009 | As a Moderator, I need to track moderation history so that I have audit trail | P1 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Moderation Queue" link | From admin dashboard |
| Nav | "Moderation" link | Moderator navigation |
| NOTF | Moderation notification | New flagged content alert |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| FEED | Post context link | View post in context | 📋 |
| PROF | User profile link | View reported user | 📋 |
| ADMN | "Admin Dashboard" | Back to admin (if admin+mod) | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| content_flags | id, post_id, flagged_by, reason, status, created_at | Flag queue |
| posts | id, author_id, content, course_id, is_pinned, created_at | Post content |
| users (author) | id, name, avatar, handle | Author info |
| users (flagger) | id, name | Who flagged |
| moderation_actions | id, moderator_id, action_type, target_id, notes, created_at | Action history |

---

## Features

### Queue Header
- [ ] "Moderation Queue" title `[US-M001]`
- [ ] Pending count: "X items pending review" `[US-M001]`

### Filter Bar
- [ ] Status filter: Pending / Reviewed / All `[US-M001]`
- [ ] Type filter: Posts / Messages / Profiles `[US-M001]`
- [ ] Priority filter: High / Medium / Low `[US-M001]`
- [ ] Date range filter `[US-M001]`

### Flagged Content List
- [ ] List of flagged items, newest first `[US-M002]`
- [ ] Content preview (truncated) `[US-M002]`
- [ ] Author name + avatar `[US-M002]`
- [ ] Flag reason `[US-M002]`
- [ ] Flagged by (name) + date `[US-M002]`
- [ ] Quick actions: Dismiss, Remove, Warn, Ban `[US-M003]`

### Item Detail View
- [ ] Full post text + media `[US-M002]`
- [ ] Author info with account age + previous violations `[US-M002]`
- [ ] All flags on this content `[US-M002]`
- [ ] "View in Feed" context link `[US-M002]`
- [ ] Surrounding conversation (if reply) `[US-M002]`
- [ ] Action buttons `[US-M003]`
- [ ] Moderator notes field `[US-M009]`

### Moderator Actions
- [ ] Dismiss: Mark reviewed, no action `[US-M004]`
- [ ] Remove Content: Delete post, author notified `[US-M003]`
- [ ] Warn User: Send warning notification `[US-M005]`
- [ ] Temp Ban: 1/7/30 day ban options `[US-M005]`
- [ ] Permanent Ban: With confirmation `[US-M005]`

### Action History
- [ ] Log of moderator actions `[US-M009]`
- [ ] Who did what, when `[US-M009]`
- [ ] Reversible within time window `[US-M009]`

### Statistics
- [ ] Flags this week `[US-M001]`
- [ ] Resolution rate `[US-M001]`
- [ ] Most common violation types `[US-M001]`

---

## Sections (from Plan)

### Queue Header
- Title with pending count
- Filter options

### Filter Bar
- Status, Type, Priority, Date Range

### Flagged Content List
- Item cards with preview
- Quick actions

### Item Detail View
- Full content
- Author info
- All flags
- Action buttons
- Notes field

### Action History
- Past actions log

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/moderation/queue` | GET | Flagged content list | 📋 |
| `/api/moderation/queue/:id` | GET | Full flag details | 📋 |
| `/api/moderation/queue/:id/dismiss` | POST | Mark not violation | 📋 |
| `/api/moderation/queue/:id/remove` | POST | Delete content | 📋 |
| `/api/moderation/queue/:id/warn` | POST | Issue user warning | 📋 |
| `/api/moderation/queue/:id/ban` | POST | Suspend user | 📋 |
| `/api/moderation/history` | GET | Past actions | 📋 |
| `/api/moderation/stats` | GET | Queue metrics | 📋 |

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

## States & Variations

| State | Description |
|-------|-------------|
| Queue | Viewing pending items |
| Item Detail | Reviewing specific item |
| Taking Action | Action confirmation |
| Empty Queue | No pending items |
| Filtered | Viewing filtered subset |

---

## Error Handling

| Error | Display |
|-------|---------|
| Action fails | "Unable to complete action. Try again." |
| Content already actioned | "This content was already reviewed." |
| Load fails | "Unable to load queue. [Retry]" |

---

## Mobile Considerations

- List view primary
- Swipe actions for quick dismiss/remove
- Detail view as full screen
- Ban confirmation requires extra steps

---

## Implementation Notes

- CD-010: Community Moderator is distinct role from Creator
- Consider escalation path to admin for severe cases
- Appeal process for banned users (future)
- Auto-flag based on keywords/patterns (future)
- Moderator training/guidelines document needed
- Multiple flags on same content should be grouped
