# Screen: Admin Sessions

**Code:** ASES
**URL:** `/admin/sessions` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

View and manage all tutoring sessions - monitor activity, access recordings, resolve disputes, and handle session issues.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Sessions" nav item | Admin sidebar |
| AUSR | "View Sessions" on user | Filtered to user |
| ACRS | "View Sessions" on course | Filtered to course |
| AENR | "View Sessions" on enrollment | Filtered to enrollment |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | Student/ST name click | View user |
| ACRS | Course name click | View course |
| AENR | Enrollment link | View enrollment |
| (Recording) | "View Recording" | Playback (if available) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| sessions | All fields | Session records |
| users (students) | id, name | Student info |
| users (STs) | id, name | ST info |
| courses | id, title | Course info |
| enrollments | id | Enrollment link |
| session_assessments | rating, comment | Feedback |

---

## Sections

### Header
- Screen title: "Session Management"
- Stats: "X sessions today, Y this week"
- Date range selector

### Filters
- **Search:** Student/ST name
- **Course filter:** All / specific course
- **Status filter:** All / Scheduled / Completed / Cancelled / No-show
- **Date filter:** Date range
- **Issues filter:** With disputes / Low ratings

### Sessions Table

| Column | Content |
|--------|---------|
| Date/Time | Session datetime |
| Course | Course title |
| Student | Student name |
| ST | ST name |
| Duration | Planned / Actual |
| Status | Scheduled / Completed / Cancelled / No-show |
| Ratings | Student → ST, ST → Student |
| Recording | Available / Not available |
| Actions | View, Resolve |

### Session Detail Panel

**Session Info:**
- Date, time, duration
- Course + enrollment info
- Student info (link to AUSR)
- ST info (link to AUSR)
- Video room URL/ID

**Status & Outcomes:**
- Status (with timestamps)
- Student rating + comment
- ST rating + comment
- Recording link (if available)

**Dispute Resolution (if flagged):**
- Flag reason
- Both party statements
- Resolution options:
  - Dismiss (no action)
  - Warn student
  - Warn ST
  - Refund session
  - Credit session
- Resolution notes
- Resolve button

### Actions

| Action | Description |
|--------|-------------|
| View Recording | Play session recording |
| Download Recording | Download for review |
| Flag for Review | Mark session for follow-up |
| Credit Session | Give student free session credit |
| Warn User | Issue warning to student or ST |

### Upcoming Sessions View
- Calendar/list of scheduled sessions
- For monitoring, not intervention
- Identify scheduling issues

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/sessions` | Page load | Paginated, filterable list |
| `GET /api/admin/sessions/:id` | Detail open | Full session data |
| `PATCH /api/admin/sessions/:id` | Save changes | Update status, notes |
| `GET /api/admin/sessions/:id/recording` | View recording | Signed URL for playback |
| `POST /api/admin/sessions/:id/resolve` | Resolve dispute | Apply resolution |
| `POST /api/admin/sessions/:id/credit` | Credit session | Give free session |
| `POST /api/admin/sessions/:id/warn` | Warn user | Issue warning |
| `GET /api/admin/sessions/upcoming` | Calendar view | Upcoming sessions |
| `GET /api/admin/sessions/stats` | Metrics | Session statistics |

**Query Parameters:**
- `q` - Search student/ST name
- `course_id` - Filter by course
- `status` - scheduled, completed, cancelled, no_show
- `from`, `to` - Date range
- `has_dispute` - true/false
- `low_rating` - true (≤2 stars)
- `page`, `limit` - Pagination

**Session Response:**
```typescript
GET /api/admin/sessions/:id
{
  session: { ...all fields... },
  student: { id, name },
  st: { id, name },
  course: { id, title },
  feedback: {
    student: { rating, comment } | null,
    st: { rating, comment } | null
  },
  dispute: { reason, status, statements } | null,
  recording_available: boolean
}
```

**Resolve Dispute:**
```typescript
POST /api/admin/sessions/:id/resolve
{
  action: 'dismiss' | 'warn_student' | 'warn_st' | 'refund' | 'credit',
  notes: string
}
```

---

## States & Variations

| State | Description |
|-------|-------------|
| List | Default session list |
| Filtered | By course, user, date |
| Detail | Session panel open |
| Resolving | Dispute resolution active |
| Calendar | Upcoming sessions view |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load sessions. [Retry]" |
| Recording unavailable | "Recording not available or expired" |
| Resolution fails | "Unable to save resolution. [Retry]" |

---

## Notes

- Admin monitors but doesn't participate in sessions
- Recordings have retention period (30 days?)
- Low rating threshold for auto-flagging (e.g., ≤2 stars)
- Dispute resolution should notify affected parties
