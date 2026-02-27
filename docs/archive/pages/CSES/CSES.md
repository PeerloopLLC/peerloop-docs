# CSES - Session History

| Field | Value |
|-------|-------|
| Route | `/studio/sessions` |
| Access | Authenticated (Creator role) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 3 |
| JSON Spec | `src/data/pages/dashboard/teaching/sessions.json` |
| Astro Page | `src/pages/dashboard/teaching/sessions.astro` |

---

## Purpose

Allow Creators to view all tutoring sessions across their courses, monitor ST performance, access recordings, and handle session-related issues.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-C043 | As a Creator, I need to view session history so that I can monitor course activity | P0 | 📋 |
| US-C044 | As a Creator, I need to access session recordings so that I can review teaching quality | P1 | 📋 |
| US-C045 | As a Creator, I need to monitor ST performance via sessions so that I can ensure quality | P0 | 📋 |
| US-C046 | As a Creator, I need to handle session disputes so that I can resolve student issues | P1 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CDSH | "View Sessions" link | From dashboard |
| STUD | "Sessions" tab | From Creator Studio |
| CMST | "View Sessions" on student | Filtered to student |
| Nav | "Sessions" link | Creator navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| PROF | Student/ST name click | View profile | 📋 |
| SROM | "View Recording" | If recording exists | 📋 |
| MSGS | "Message" button | Contact participant | 📋 |
| CDET | Course name click | View course | 📋 |
| CDSH | Back/breadcrumb | Return to dashboard | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| sessions | All fields | Session records |
| users (students) | id, name, avatar | Student info |
| users (STs) | id, name, avatar | ST info |
| courses | id, title (where creator_id = current user) | Course filter |
| enrollments | id, course_id, student_id | Enrollment context |
| session_assessments | rating, comment | Feedback data |

---

## Features

### Viewing & Browsing
- [ ] Sessions table with date/time, course, student, ST, duration `[US-C043]`
- [ ] Status column: Completed / Cancelled / No-show `[US-C043]`
- [ ] Rating column (stars if rated) `[US-C043]`
- [ ] Recording indicator icon `[US-C044]`
- [ ] Header stats: "X total sessions, Y this week" `[US-C043]`

### Filters
- [ ] Course filter (All / specific course) `[US-C043]`
- [ ] ST filter (All / specific Student-Teacher) `[US-C045]`
- [ ] Student search by name `[US-C043]`
- [ ] Status filter (All / Completed / Scheduled / Cancelled / No-show) `[US-C043]`
- [ ] Date range filter (presets + custom) `[US-C043]`
- [ ] Pagination controls `[US-C043]`

### Session Actions
- [ ] View session detail → slide-out panel `[US-C043]`
- [ ] Play recording (if available) `[US-C044]`
- [ ] Message participant → MSGS `[US-C043]`

### Session Detail Panel
- [ ] Full session info `[US-C043]`
- [ ] Student feedback (rating + comment) `[US-C043]`
- [ ] ST feedback (rating + comment) `[US-C043]`
- [ ] Recording player (if available) `[US-C044]`
- [ ] Session notes `[US-C043]`
- [ ] Dispute resolution (if flagged) `[US-C046]`

### Upcoming Sessions Tab
- [ ] Calendar view of scheduled sessions `[US-C043]`
- [ ] Quick view: who, when, which course `[US-C043]`

### Session Metrics Summary
- [ ] Average session duration `[US-C045]`
- [ ] Completion rate `[US-C045]`
- [ ] Average rating `[US-C045]`
- [ ] No-show rate `[US-C045]`
- [ ] By ST breakdown `[US-C045]`

---

## Sections (from Plan)

### Header
- Page title: "Session History"
- Stats: "X total sessions, Y this week"
- Date range selector

### Sessions Table

| Column | Content |
|--------|---------|
| Date/Time | Session datetime |
| Course | Course title |
| Student | Avatar + name |
| ST | Avatar + name |
| Duration | Actual duration |
| Status | Completed / Cancelled / No-show |
| Rating | Stars (if rated) |
| Recording | Play icon (if available) |
| Actions | View, Message |

### Session Detail Panel
**View Mode:**
- Full session info
- Student feedback (rating + comment)
- ST feedback (rating + comment)
- Recording player (if available)
- Session notes
- Dispute info (if flagged)

### Upcoming Sessions Tab
- Calendar view
- Quick session cards

### Metrics Summary
- Stats cards at top
- By-ST breakdown table

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/creators/me/sessions` | GET | Session list | 📋 |
| `/api/creators/me/sessions/:id` | GET | Session detail | 📋 |
| `/api/creators/me/sessions/upcoming` | GET | Upcoming sessions | 📋 |
| `/api/creators/me/sessions/stats` | GET | Aggregate stats | 📋 |
| `/api/sessions/:id/recording` | GET | Signed recording URL | 📋 |
| `/api/creators/me/courses` | GET | Course options | 📋 |
| `/api/creators/me/student-teachers` | GET | ST options | 📋 |

**Query Parameters:**
- `course_id` - Filter by course
- `st_id` - Filter by Student-Teacher
- `student_q` - Search student name
- `status` - completed, scheduled, cancelled, no_show
- `from`, `to` - Date range
- `page`, `limit` - Pagination

**Sessions Response:**
```typescript
GET /api/creators/me/sessions
{
  sessions: [{
    id, scheduled_start, actual_duration, status,
    course: { id, title },
    student: { id, name, avatar },
    st: { id, name, avatar },
    rating: number | null,
    has_recording: boolean
  }],
  pagination: { page, limit, total, has_more }
}
```

**Session Detail Response:**
```typescript
GET /api/creators/me/sessions/:id
{
  id, scheduled_start, scheduled_end,
  actual_start, actual_end, status,
  course: { id, title },
  student: { id, name, avatar },
  st: { id, name, avatar },
  student_feedback: { rating, comment } | null,
  st_feedback: { rating, comment } | null,
  notes: string,
  has_recording: boolean,
  recording_url: string | null,  // Signed URL if available
  dispute: { status, reason } | null
}
```

**Stats Response:**
```typescript
GET /api/creators/me/sessions/stats?from=...&to=...
{
  total_sessions: number,
  completed: number,
  cancelled: number,
  no_show: number,
  avg_duration: number,      // minutes
  avg_rating: number,
  completion_rate: number,   // percent
  by_st: [{
    st: { id, name },
    sessions: number,
    avg_rating: number
  }]
}
```

**Recording URL:**
```typescript
GET /api/sessions/:id/recording
{
  url: string,  // Signed R2 URL, expires in 1 hour
  expires_at: string
}
```

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Recent sessions, all courses |
| Filtered | By course, ST, student, or date |
| Detail Open | Session detail panel visible |
| Calendar View | Upcoming sessions in calendar |
| Empty | No sessions yet |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load sessions. [Retry]" |
| Recording unavailable | "Recording not available" |

---

## Mobile Considerations

- Card list instead of table
- Swipe for actions
- Recording plays in modal
- Calendar view simplified

---

## Implementation Notes

- Recordings stored in R2, streamed via signed URLs
- Creator cannot join live sessions (ST-student only)
- Consider flagging sessions with low ratings for review
- Signed URLs expire in 1 hour for security
