# API Reference: Sessions

Video session booking, joining, and availability endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Session Endpoints (Video/Booking)

### GET /api/sessions

List user's tutoring sessions.

**Authentication:** Required

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `status` | string | - | Filter by status (scheduled, completed, cancelled) |
| `upcoming` | boolean | false | Only future scheduled sessions |
| `role` | string | - | Filter by user role (student, teacher) |

**Response (200):**
```json
{
  "sessions": [
    {
      "id": "session-uuid",
      "scheduled_start": "2026-01-25T14:00:00Z",
      "scheduled_end": "2026-01-25T15:00:00Z",
      "status": "scheduled",
      "recording_url": null,
      "course": { "title": "AI Tools Overview", "slug": "ai-tools-overview" },
      "teacher": { "id": "usr-123", "name": "John Doe", "avatar_url": null },
      "student": { "id": "usr-456", "name": "Jane Smith", "avatar_url": null },
      "user_role": "student"
    }
  ]
}
```

---

### POST /api/sessions

Create a new session booking.

**Authentication:** Required

**Request:**
```json
{
  "enrollment_id": "enr-uuid",
  "teacher_id": "usr-teacher-uuid",
  "scheduled_start": "2026-01-25T14:00:00Z",
  "scheduled_end": "2026-01-25T15:00:00Z"
}
```

**Response (201):**
```json
{
  "session": {
    "id": "session-uuid",
    "scheduled_start": "...",
    "scheduled_end": "...",
    "status": "scheduled",
    "course": { "title": "...", "slug": "..." },
    "teacher": { "id": "...", "name": "...", "avatar_url": null },
    "student": { "id": "...", "name": "...", "avatar_url": null }
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Missing required fields, invalid dates, past date |
| 404 | Enrollment not found |
| 409 | Teacher or student has conflicting session |

---

### GET /api/sessions/[id]

Get session details.

**Authentication:** Required (participant only)

**Response (200):**
```json
{
  "session": {
    "id": "...",
    "scheduled_start": "...",
    "scheduled_end": "...",
    "status": "scheduled",
    "recording_url": null,
    "can_join": true,
    "can_cancel": true,
    "user_role": "student",
    "course": {...},
    "teacher": {...},
    "student": {...}
  }
}
```

---

### DELETE /api/sessions/[id]

Cancel a session. Sends cancellation email to both parties via Resend.

**Authentication:** Required (participant only)

**Request (optional):**
```json
{
  "reason": "Schedule conflict"
}
```

**Response (200):**
```json
{
  "message": "Session cancelled",
  "session_id": "..."
}
```

---

### PATCH /api/sessions/[id]

Reschedule a session to a new date/time. Sends reschedule email to both parties via Resend.

**Authentication:** Required (participant only)

**Request:**
```json
{
  "scheduled_start": "2026-03-15T14:00:00Z",
  "scheduled_end": "2026-03-15T15:00:00Z",
  "reason": "Schedule conflict"
}
```

**Response (200):**
```json
{
  "message": "Session rescheduled",
  "session": {
    "id": "...",
    "scheduled_start": "2026-03-15T14:00:00Z",
    "scheduled_end": "2026-03-15T15:00:00Z",
    "rescheduled_by": "usr-..."
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Only scheduled sessions can be rescheduled, invalid dates |
| 409 | Teacher or student has conflicting session |

---

### POST /api/sessions/[id]/join

Get BBB join URL for a session.

**Authentication:** Required (participant only)

Creates BBB room on-demand if not already created.

**Response (200):**
```json
{
  "join_url": "https://bbb.example.com/?access_token=...",
  "room_created": true,
  "session": { "id": "...", "course_title": "...", "scheduled_start": "...", "scheduled_end": "..." },
  "participant": { "name": "John Doe", "role": "teacher", "is_moderator": true }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Session not yet joinable, session ended |
| 503 | Video service not configured |

---

### POST /api/sessions/[id]/rating

Rate a completed session.

**Authentication:** Required (participant only)

**Request:**
```json
{
  "rating": 5,
  "comment": "Great session!"
}
```

**Response (200):**
```json
{
  "assessment": {
    "id": "asmt-uuid",
    "session_id": "...",
    "rating": 5,
    "comment": "...",
    "assessee_id": "..."
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Rating must be 1-5, session not completed |
| 409 | Already rated this session |

---

### GET /api/sessions/[id]/recording

Get recording URL for a completed session.

**Authentication:** Required (participant or admin)

**Response (200):**
```json
{
  "recording": {
    "session_id": "...",
    "course_title": "Intro to Python",
    "recording_url": "https://bbb.example.com/playback/...",
    "completed_at": "2026-03-15T15:05:00Z"
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Session not completed yet |
| 404 | Recording not available (still processing) |

---

### GET /api/sessions/[id]/attendance

Get attendance records for a session (who joined, when, how long).

**Authentication:** Required (participant or admin)

**Response (200):**
```json
{
  "attendance": [
    {
      "id": "att-001",
      "user_id": "usr-teacher",
      "user_name": "Jane Smith",
      "role": "teacher",
      "joined_at": "2026-03-15T14:02:00Z",
      "left_at": "2026-03-15T15:01:00Z",
      "duration_seconds": 3540
    },
    {
      "id": "att-002",
      "user_id": "usr-student",
      "user_name": "John Doe",
      "role": "student",
      "joined_at": "2026-03-15T14:05:00Z",
      "left_at": "2026-03-15T15:00:00Z",
      "duration_seconds": 3300
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 403 | Not authorized (not a participant) |
| 404 | Session not found |

---

## Student-Teacher Availability

### GET /api/student-teachers/[id]/availability

Get ST's available time slots for booking.

**Authentication:** Required

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `course_id` | string | - | Filter by course |
| `start_date` | string | today | Start of date range (YYYY-MM-DD) |
| `end_date` | string | +2 weeks | End of date range (YYYY-MM-DD) |
| `weeks` | number | 2 | Weeks ahead (alternative to end_date) |

**Response (200):**
```json
{
  "teacher": { "id": "...", "name": "...", "handle": "...", "timezone": "UTC" },
  "weekly_availability": [
    { "day_of_week": 1, "day_name": "Monday", "start_time": "09:00", "end_time": "17:00", "timezone": "UTC" }
  ],
  "slots": [
    { "date": "2026-01-25", "start_time": "09:00", "end_time": "10:00", "available": true },
    { "date": "2026-01-25", "start_time": "10:00", "end_time": "11:00", "available": false, "conflict_session_id": "..." }
  ],
  "date_range": { "start": "2026-01-20", "end": "2026-02-03" }
}
```

---

## S-T Session History

### GET /api/me/st-sessions

Get session history for current Student-Teacher.

**Authentication:** Required (S-T only)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `course_id` | string | - | Filter by course |
| `student_id` | string | - | Filter by student |
| `status` | string | - | Filter by status (scheduled, completed, cancelled, no_show) |
| `date_from` | string | - | Filter sessions from date (YYYY-MM-DD) |
| `date_to` | string | - | Filter sessions to date (YYYY-MM-DD) |
| `sort` | string | scheduled_start | Sort field (scheduled_start, duration, status) |
| `order` | string | desc | Sort order (asc, desc) |
| `page` | number | 1 | Page number |
| `limit` | number | 20 | Items per page (max 50) |

**Response (200):**
```json
{
  "sessions": [
    {
      "id": "session-uuid",
      "enrollment_id": "enr-uuid",
      "student_id": "usr-uuid",
      "student_name": "Jane Smith",
      "student_handle": "janesmith",
      "student_avatar_url": null,
      "course_id": "course-uuid",
      "course_title": "AI Tools Overview",
      "course_slug": "ai-tools-overview",
      "scheduled_start": "2026-01-25T14:00:00Z",
      "scheduled_end": "2026-01-25T15:00:00Z",
      "actual_start": "2026-01-25T14:02:00Z",
      "actual_end": "2026-01-25T14:58:00Z",
      "duration_minutes": 56,
      "status": "completed",
      "recording_url": "https://...",
      "notes": "Covered module 3",
      "cancel_reason": null,
      "student_rating": 5,
      "student_comment": "Great session!",
      "teacher_rating": 5,
      "teacher_comment": "Engaged student",
      "created_at": "2026-01-20T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "total_pages": 3
  },
  "courses": [
    { "id": "course-uuid", "title": "AI Tools Overview", "session_count": 30 }
  ],
  "students": [
    { "id": "usr-uuid", "name": "Jane Smith", "handle": "janesmith", "avatar_url": null, "session_count": 15 }
  ],
  "stats": {
    "total_sessions": 45,
    "completed_sessions": 40,
    "scheduled_sessions": 3,
    "cancelled_sessions": 1,
    "no_show_sessions": 1,
    "avg_rating": 4.8,
    "total_duration_minutes": 2400,
    "sessions_this_week": 5
  },
  "filters": {
    "course_id": null,
    "student_id": null,
    "status": null,
    "date_from": null,
    "date_to": null,
    "sort": "scheduled_start",
    "order": "desc"
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 403 | Student-Teacher access required |
