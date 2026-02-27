# ASES - Admin Sessions

| Field | Value |
|-------|-------|
| Route | `/admin/sessions` |
| Access | Authenticated (Admin role) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 8 |
| JSON Spec | `src/data/pages/admin/sessions.json` |
| Astro Page | `src/pages/admin/sessions.astro` |

---

## Purpose

View and manage all tutoring sessions - monitor activity, access recordings, resolve disputes, and handle session issues.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A011 | As an Admin, I need to view all sessions so that I can monitor platform activity | P1 | ⏳ |
| US-A012 | As an Admin, I need to access session recordings so that I can review disputes | P1 | ⏳ |
| US-A013 | As an Admin, I need to resolve disputes so that I can handle conflicts | P0 | ⏳ |
| US-A014 | As an Admin, I need to credit sessions so that I can compensate for issues | P1 | ⏳ |

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

## Features

### Viewing & Browsing
- [ ] Session listing with sortable columns `[US-A011]`
- [ ] Search by student/ST name `[US-A011]`
- [ ] Filter by course `[US-A011]`
- [ ] Filter by status (scheduled/completed/cancelled/no-show) `[US-A011]`
- [ ] Filter by date range `[US-A011]`
- [ ] Filter by disputes/low ratings `[US-A011]`
- [ ] Session stats (today, this week) `[US-A011]`
- [ ] Session detail panel `[US-A011]`

### Session Actions
- [ ] View recording `[US-A012]`
- [ ] Download recording `[US-A012]`
- [ ] Flag for review `[US-A013]`
- [ ] Credit session (give free session) `[US-A014]`
- [ ] Warn user (student or ST) `[US-A013]`

### Dispute Resolution
- [ ] View dispute reason and statements `[US-A013]`
- [ ] Resolve: dismiss, warn student, warn ST, refund, credit `[US-A013]`
- [ ] Resolution notes `[US-A013]`

### Calendar View
- [ ] Upcoming sessions view `[US-A011]`

---

## Sections (from Plan)

### Header
- Screen title: "Session Management"
- Stats: "X sessions today, Y this week"
- Date range selector

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
- Resolution options
- Resolution notes
- Resolve button

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/sessions` | GET | Paginated, filterable list | ⏳ |
| `/api/admin/sessions/:id` | GET | Full session data | ⏳ |
| `/api/admin/sessions/:id` | PATCH | Update status, notes | ⏳ |
| `/api/admin/sessions/:id/recording` | GET | Signed URL for playback | ⏳ |
| `/api/admin/sessions/:id/resolve` | POST | Apply dispute resolution | ⏳ |
| `/api/admin/sessions/:id/credit` | POST | Give free session | ⏳ |
| `/api/admin/sessions/:id/warn` | POST | Issue warning | ⏳ |
| `/api/admin/sessions/upcoming` | GET | Upcoming sessions | ⏳ |
| `/api/admin/sessions/stats` | GET | Session statistics | ⏳ |

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

## Implementation Notes

- Admin monitors but doesn't participate in sessions
- Recordings have retention period (30 days)
- Low rating threshold for auto-flagging (≤2 stars)
- Dispute resolution should notify affected parties
- Uses shared admin components
