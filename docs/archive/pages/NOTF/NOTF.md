# NOTF - Notifications

| Field | Value |
|-------|-------|
| Route | `/notifications` |
| Access | Authenticated |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 9 |
| JSON Spec | `src/data/pages/notifications.json` |
| Astro Page | `src/pages/notifications.astro` |

---

## Purpose

Display all user notifications in one place, allowing users to view, mark as read, and act on notifications.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-P017 | As a Platform, I need to display notifications so that users stay informed | P0 | 📋 |
| US-P018 | As a Platform, I need notification preferences so that users control what they receive | P0 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | Notification bell icon | Global navigation |
| Any page | Bell with badge | Unread indicator click |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SROM | Session notification click | Join upcoming session | 📋 |
| MSGS | Message notification click | View message thread | 📋 |
| SDSH/TDSH/CDSH | Approval notification click | View pending items | 📋 |
| CDET | Course notification click | View course | 📋 |
| PROF | Follower notification click | View who followed | 📋 |
| SETT | "Notification Settings" | Manage preferences | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| notifications | id, type, title, body, action_url, is_read, created_at | Notification list |
| users (related) | name, avatar | For follow/message notifications |

---

## Features

### Header
- [ ] Page title: "Notifications" `[US-P017]`
- [ ] "Mark All as Read" button `[US-P017]`
- [ ] "Settings" link → SETT `[US-P018]`

### Filter/Tabs
- [ ] All / Unread tabs `[US-P017]`
- [ ] By type filter: Sessions, Messages, Courses, Social `[US-P017]`

### Notification List
- [ ] Chronological list, newest first `[US-P017]`
- [ ] Icon by notification type `[US-P017]`
- [ ] Title (bold if unread) `[US-P017]`
- [ ] Body text preview `[US-P017]`
- [ ] Relative timestamp ("2 hours ago") `[US-P017]`
- [ ] Unread indicator (dot) `[US-P017]`
- [ ] Click → navigate to action_url `[US-P017]`
- [ ] Swipe to mark read/delete (mobile) `[US-P017]`

### Empty State
- [ ] "No notifications yet" message `[US-P017]`
- [ ] "You're all caught up!" when all read `[US-P017]`

### Pagination
- [ ] Infinite scroll or "Load More" `[US-P017]`

---

## Sections (from Plan)

### Header
- Page title
- Mark All as Read
- Settings link

### Filter Tabs
- All / Unread
- Type filters

### Notification List
- Chronological with icons
- Unread indicators
- Click to navigate

### Notification Types

| Type | Icon | Example |
|------|------|---------|
| session_reminder | Calendar | "Your session starts in 15 minutes" |
| session_booked | Calendar+ | "[Student] booked a session with you" |
| new_message | Message | "New message from [Name]" |
| course_update | Book | "[Course] has new content" |
| certificate_earned | Award | "You earned a certificate!" |
| st_application | User+ | "[Name] applied to be an ST" |
| cert_request | Clipboard | "[ST] recommends [Student] for certification" |
| new_follower | User | "[Name] started following you" |
| payment | Dollar | "Payout of $X processed" |
| system | Info | Platform announcements |

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/notifications` | GET | List notifications | 📋 |
| `/api/notifications/:id/read` | PUT | Mark single as read | 📋 |
| `/api/notifications/read-all` | PUT | Mark all as read | 📋 |
| `/api/notifications/:id` | DELETE | Remove notification | 📋 |
| `/api/notifications/count` | GET | Unread count for badge | 📋 |

**Query Parameters:**
- `unread` - Boolean, filter unread only
- `type` - Filter by notification type
- `page`, `limit` - Pagination

**Notifications Response:**
```typescript
GET /api/notifications
{
  notifications: [{
    id, type, title, body,
    action_url: string,  // Where to navigate on click
    is_read: boolean,
    created_at: string,
    related_user?: { id, name, avatar }  // For social notifications
  }],
  pagination: { page, limit, total, has_more }
}
```

**Count Response:**
```typescript
GET /api/notifications/count
{ unread: number }
```

---

## States & Variations

| State | Description |
|-------|-------------|
| Has Unread | Unread items highlighted, badge in nav |
| All Read | No badge, items in normal style |
| Empty | No notifications, encouraging message |
| Filtered | Showing specific type only |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load notifications. [Retry]" |
| Mark read fails | Toast: "Unable to update. Try again." |

---

## Mobile Considerations

- Full-screen list
- Pull-to-refresh
- Swipe gestures for mark read / delete
- Notification bell in bottom nav

---

## Implementation Notes

- Real-time updates: New notifications appear without refresh
- Push notification bridge: In-app notifications mirror push
- Consider notification grouping (3 new followers → "3 people followed you")
- Retention: Consider auto-delete notifications older than 30 days
- Unread count badge updates via WebSocket or polling
