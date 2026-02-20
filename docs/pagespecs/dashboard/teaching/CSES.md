# Page: Session History (Creator)

**Code:** CSES
**URL:** `/studio/sessions`
**Access:** Authenticated (Creator role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Allow Creators to view all tutoring sessions across their courses, monitor ST performance, access recordings, and handle session-related issues.

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

| Target | Trigger | Notes |
|--------|---------|-------|
| PROF | Student/ST name click | View profile |
| SROM | "View Recording" | If recording exists |
| MSGS | "Message" button | Contact participant |
| CDET | Course name click | View course |
| CDSH | Back/breadcrumb | Return to dashboard |

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

## Sections

### Header
- Page title: "Session History"
- Stats: "X total sessions, Y this week"
- Date range selector

### Filters
- **Course:** All / specific course
- **ST:** All / specific Student-Teacher
- **Student:** Search by name
- **Status:** All / Completed / Scheduled / Cancelled / No-show
- **Date range:** Preset (Today, This week, This month) or custom

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
When clicking a session:
- Full session info
- Student feedback (rating + comment)
- ST feedback (rating + comment)
- Recording player (if available)
- Session notes
- Dispute resolution (if flagged)

### Upcoming Sessions Tab
- Calendar view of scheduled sessions
- Quick view: who, when, which course
- No direct intervention (STs manage their own)

### Session Metrics Summary
- Average session duration
- Completion rate
- Average rating
- No-show rate
- By ST breakdown

---

## User Stories Fulfilled

- US-C043: View session history
- US-C044: Access session recordings
- US-C045: Monitor ST performance via sessions
- US-C046: Handle session disputes

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

## Mobile Considerations

- Card list instead of table
- Swipe for actions
- Recording plays in modal
- Calendar view simplified

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load sessions. [Retry]" |
| Recording unavailable | "Recording not available" |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | session_count, filter_state |
| `session_viewed` | Detail opened | session_id |
| `recording_played` | Play clicked | session_id |
| `filter_applied` | Filter changed | filter_type, value |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/creators/me/sessions` | Page load | Session list |
| `GET /api/creators/me/sessions/:id` | Detail open | Session detail |
| `GET /api/creators/me/sessions/upcoming` | Calendar tab | Upcoming sessions |
| `GET /api/creators/me/sessions/stats` | Metrics | Aggregate stats |
| `GET /api/sessions/:id/recording` | Play recording | Signed URL |
| `GET /api/creators/me/courses` | Filter dropdown | Course options |
| `GET /api/creators/me/student-teachers` | Filter dropdown | ST options |

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

## Notes

- Recordings stored in R2, streamed via signed URLs
- Creator cannot join live sessions (ST-student only)
- Consider flagging sessions with low ratings for review
