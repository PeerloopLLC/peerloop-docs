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

Rate a completed session. Both student and teacher can rate each other.

**Authentication:** Required (participant only)

**Request:**
```json
{
  "rating": 5,
  "comment": "Great session!",
  "teacher_rating": 5,
  "interaction_rating": 4,
  "materials_rating": 5
}
```

Sub-ratings (`teacher_rating`, `interaction_rating`, `materials_rating`) are optional, 1-5 if provided. Only stored for student→teacher direction; ignored when teacher rates student.

**Response (200):**
```json
{
  "assessment": {
    "id": "asmt-uuid",
    "session_id": "...",
    "rating": 5,
    "comment": "...",
    "assessee_id": "...",
    "teacher_rating": 5,
    "interaction_rating": 4,
    "materials_rating": 5
  }
}
```

Sub-rating fields only included in response for student→teacher direction.

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Rating must be 1-5, session not completed, sub-rating out of range |
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

**Notes:**
- Slots now respect `start_date` and `repeat_weeks` on recurring rules
- Date-specific overrides take precedence: if an override exists for a date, it replaces recurring slots
- Blocked overrides (`is_available=0`) produce no slots for that date

---

## Student-Teacher Reviews

### GET /api/student-teachers/[id]/reviews

Get enrollment reviews received by a Student-Teacher (public listing).

**Authentication:** Not required (public endpoint)

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | number | 1 | Page number |
| `limit` | number | 10 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "review-1",
      "rating": 5,
      "comment": "Excellent teaching experience",
      "created_at": "2026-02-20T10:00:00Z",
      "reviewer_name": "Jennifer Kim",
      "reviewer_avatar": "/avatars/jen.jpg",
      "sub_ratings": {
        "teacher_rating": 5,
        "interaction_rating": 4,
        "materials_rating": 5
      },
      "response": {
        "responder_name": "Alex Johnson",
        "response": "Thank you for your kind words!",
        "created_at": "2026-02-21T08:00:00Z"
      }
    }
  ],
  "total": 15,
  "page": 1,
  "limit": 10,
  "totalPages": 2,
  "hasMore": true
}
```

---

## Review Responses

### POST /api/reviews/[type]/[id]/response

Submit a response to a review. STs respond to enrollment reviews, Creators respond to course reviews.

**Authentication:** Required

**URL Parameters:**
- `type`: `enrollment` or `course`
- `id`: Review ID

**Request Body:**
```json
{ "response": "Thank you for your feedback! (min 10 chars)" }
```

**Authorization:**
- `enrollment` type: must be the assigned ST for the enrollment
- `course` type: must be the course creator

**Response (200):**
```json
{
  "response": {
    "id": "resp-1",
    "review_type": "enrollment",
    "review_id": "rev-1",
    "responder_id": "usr-st-1",
    "response": "Thank you for your feedback!",
    "created_at": "2026-02-26T10:00:00Z"
  }
}
```

**Errors:** 400 (invalid type, missing/short text), 401 (unauthenticated), 403 (wrong role), 404 (review not found), 409 (response already exists)

### GET /api/reviews/[type]/[id]/response

Fetch the response for a review (public, no auth required).

**Response (200):**
```json
{
  "response": {
    "id": "resp-1",
    "review_type": "enrollment",
    "review_id": "rev-1",
    "responder_id": "usr-st-1",
    "response": "Thank you for your feedback!",
    "created_at": "2026-02-26T10:00:00Z",
    "responder_name": "Alex Johnson",
    "responder_avatar": "/avatars/alex.jpg"
  }
}
```

Returns `{ "response": null }` if no response exists.

---

## Availability Overrides

### GET /api/me/availability/overrides

List current user's date-specific availability overrides.

**Authentication:** Required (teacher)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `start_date` | string | - | Filter from date (YYYY-MM-DD) |
| `end_date` | string | - | Filter to date (YYYY-MM-DD) |

**Response (200):**
```json
{
  "overrides": [
    { "id": "override-...", "user_id": "...", "date": "2026-03-15", "start_time": "10:00", "end_time": "14:00", "is_available": 1, "created_at": "..." },
    { "id": "override-...", "user_id": "...", "date": "2026-03-20", "start_time": null, "end_time": null, "is_available": 0, "created_at": "..." }
  ]
}
```

### POST /api/me/availability/overrides

Create a date-specific override.

**Authentication:** Required (teacher)

**Request Body:**
```json
{
  "date": "2026-03-15",
  "is_available": true,
  "start_time": "10:00",
  "end_time": "14:00"
}
```

- If `is_available=true`: `start_time` and `end_time` required (min 1 hour)
- If `is_available=false`: times are ignored (day is blocked)

**Response (201):**
```json
{ "success": true, "message": "Override added for 2026-03-15", "override": { ... } }
```

### DELETE /api/me/availability/overrides/:id

Remove an override (reverts to recurring pattern).

**Authentication:** Required (owner only)

**Response (200):**
```json
{ "success": true, "message": "Override removed for 2026-03-15" }
```

---

## Teaching Toggle

### PATCH /api/me/student-teacher/:courseId/toggle

Toggle `teaching_active` for a specific course. When off, the S-T's record stays but they don't appear in student booking.

**Authentication:** Required (must have ST record for the course)

**Response (200):**
```json
{ "success": true, "teaching_active": false }
```

**Error Responses:**
- `404` — No ST record for this course
- `403` — ST certification is suspended (`is_active=0`)

**Notes:**
- `teaching_active` is user-controlled (pause/resume accepting students)
- `is_active` is admin-controlled (certification status) — cannot toggle while suspended
- When `teaching_active=0`: availability endpoint returns empty slots with `teaching_paused: true`
- Per-course: toggling one course doesn't affect others

**See:** `docs/tech/tech-031-availability-calendar.md`

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
