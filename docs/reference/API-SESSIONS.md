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
      "module": { "id": "cur-001", "title": "Module 1: Basics", "module_order": 1 },
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
  "scheduled_end": "2026-01-25T15:00:00Z",
  "reschedule_session_id": "old-session-uuid"
}
```

**Optional field:** `reschedule_session_id` — when provided, the endpoint checks if the old session was cancelled within the last 30 minutes. If so, sends "Session Rescheduled" notifications (with old→new time) instead of "Session Booked"/"Session Confirmed" notifications. Both student and teacher receive in-app notifications and emails.

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
    "student": { "id": "...", "name": "...", "avatar_url": null },
    "module": { "id": "cur-001", "title": "Module 1: Basics", "module_order": 1 }
  }
}
```

The `module` field is computed positionally — the Nth session (by `scheduled_start`) teaches the Nth module (by `module_order`). See `src/lib/booking.ts` for the algorithm.

**Availability validation (Conv 088):** After verifying teacher certification, the endpoint calls `isSlotWithinAvailability()` from `src/lib/availability.ts` to check that the requested time falls within the teacher's recurring availability rules (day-of-week, time window, timezone conversion) and is not blocked by an override. Returns 400 with a descriptive reason if the slot is outside availability.

**Teacher assignment backfill (Session 389):** If the enrollment's `assigned_teacher_id` is NULL (student enrolled without selecting a teacher), the first booking assigns the selected teacher by backfilling `assigned_teacher_id` and `teacher_certification_id` on the enrollment. Subsequent bookings enforce the teacher match.

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Missing required fields, invalid dates, past date, teacher not active for course, booking time outside teacher availability |
| 403 | Teacher does not match enrollment's assigned teacher (ignored if NULL — first booking assigns teacher), or enrollment not active (completed/cancelled/disputed) |
| 404 | Enrollment not found |
| 409 | Teacher or student has conflicting session |
| 422 | All sessions already booked (completed + scheduled >= module count) |

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
    "can_reschedule": true,
    "user_role": "student",
    "course": {...},
    "teacher": {...},
    "student": {...},
    "module": { "id": "cur-001", "title": "Module 1: Basics", "module_order": 1 }
  }
}
```

---

### DELETE /api/sessions/[id]

Cancel a session. Sends cancellation email and in-app notifications to both student and teacher. Late cancellations (< 24h before start) require a reason and set the `is_late_cancel` flag.

**Authentication:** Required (participant only)

**Request:**
```json
{
  "reason": "Schedule conflict",
  "reschedule": false
}
```

**Fields:**
- `reason` — **Required** when cancelling < 24 hours before session start. Optional otherwise.
- `reschedule` — When `true`, suppresses in-app cancel notifications (the subsequent POST `/api/sessions` will send "Session Rescheduled" notifications instead). Cancellation emails are still sent regardless. Late-cancel penalty still applies.

**Response (200):**
```json
{
  "message": "Session cancelled",
  "session_id": "...",
  "is_late_cancel": false
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Cannot cancel completed session, session already cancelled, reason required for late cancellation (< 24h) |
| 403 | Not authorized (not a participant) |
| 404 | Session not found |

---

### PATCH /api/sessions/[id]

Reschedule a session to a new date/time. Sends reschedule email to both parties via Resend. Maximum 2 reschedules per session.

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
| 422 | Reschedule limit reached (max 2 per session) |

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
    "recording_r2_key": "sessions/sess-123/recording.webm",
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

### POST /api/sessions/[id]/complete

Manually mark a session as completed. Healing endpoint for when BBB `room_ended` webhook fails to fire. Uses the shared `completeSession()` function (same as BBB webhook and admin PATCH).

**Authentication:** Required (session's teacher or course creator)

**Guards:**
- Session must be `in_progress` or `scheduled`
- Session's `scheduled_end` must be in the past
- Caller must be `teacher_id` or course `creator_id`

**Idempotent:** Returns success with `already_completed: true` if session was already completed.

**Response (200):**
```json
{
  "success": true,
  "session_id": "ses-001",
  "status": "completed",
  "module_id": "cur-003",
  "module_title": "Introduction to Variables",
  "ended_at": "2026-03-15T15:05:00Z",
  "already_completed": false,
  "completed_by": "teacher"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not the session teacher or course creator |
| 404 | Session not found |
| 422 | Session before scheduled end time, or cannot be completed (cancelled/no_show) |

---

## Teacher Availability

### GET /api/teachers/[id]/availability

Get Teacher's available time slots for booking.

**Authentication:** Required

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `course_id` | string | - | Filter by course |
| `start_date` | string | today | Start of date range (YYYY-MM-DD) |
| `end_date` | string | +2 weeks | End of date range (YYYY-MM-DD) |
| `weeks` | number | 2 | Weeks ahead (alternative to end_date) |
| `exclude_session_id` | string | - | Exclude this session from conflict checks (used during reschedule) |

**Response (200):**
```json
{
  "teacher": { "id": "...", "name": "...", "handle": "...", "timezone": "UTC" },
  "weekly_availability": [
    { "day_of_week": 1, "day_name": "Monday", "start_time": "09:00", "end_time": "17:00", "timezone": "UTC" }
  ],
  "slots": [
    { "date": "2026-01-25", "start_time": "2026-01-25T14:00:00.000Z", "end_time": "2026-01-25T15:00:00.000Z", "available": true },
    { "date": "2026-01-25", "start_time": "2026-01-25T15:00:00.000Z", "end_time": "2026-01-25T16:00:00.000Z", "available": false, "conflict_session_id": "..." }
  ],
  "date_range": { "start": "2026-01-20", "end": "2026-02-03" }
}
```

**Notes:**
- Slot `start_time` and `end_time` are **UTC ISO 8601 strings** (Conv 002). The `date` field is the teacher-local date for calendar grouping
- Teacher-local availability times (HH:MM) are converted to UTC using the teacher's `timezone` from the availability table
- Slots now respect `start_date` and `repeat_weeks` on recurring rules
- Date-specific overrides take precedence: if an override exists for a date, it replaces recurring slots
- Blocked overrides (`is_available=0`) produce no slots for that date

---

## Teacher Reviews

### GET /api/teachers/[id]/reviews

Get enrollment reviews received by a Teacher (public listing).

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

Submit a response to a review. Teachers respond to enrollment reviews, Creators respond to course reviews.

**Authentication:** Required

**URL Parameters:**
- `type`: `enrollment` or `course`
- `id`: Review ID

**Request Body:**
```json
{ "response": "Thank you for your feedback! (min 10 chars)" }
```

**Authorization:**
- `enrollment` type: must be the assigned Teacher for the enrollment
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

### PATCH /api/me/teacher/:courseId/toggle

Toggle `teaching_active` for a specific course. When off, the Teacher's record stays but they don't appear in student booking.

**Authentication:** Required (must have Teacher certification for the course)

**Response (200):**
```json
{ "success": true, "teaching_active": false }
```

**Error Responses:**
- `404` — No Teacher certification for this course
- `403` — Teacher certification is suspended (`is_active=0`)

**Notes:**
- `teaching_active` is user-controlled (pause/resume accepting students)
- `is_active` is admin-controlled (certification status) — cannot toggle while suspended
- When `teaching_active=0`: availability endpoint returns empty slots with `teaching_paused: true`
- Per-course: toggling one course doesn't affect others

**See:** `docs/as-designed/availability-calendar.md`

---

## Teacher Session History

### GET /api/me/teacher-sessions

Get session history for current Teacher.

**Authentication:** Required (Teacher only)

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
| 403 | Teacher access required |

---

## Teacher Course Detail

### GET /api/teaching/courses/[courseId]

Get per-course dashboard data for a certified Teacher.

**Authentication:** Required (Teacher with active certification for this course)

**Response (200):**
```json
{
  "course": { "id": "crs-uuid", "title": "Course Name", "slug": "course-name", "thumbnail_url": null, "level": "beginner", "session_count": 10 },
  "certification": { "id": "st-uuid", "certified_date": "2024-01-01", "students_taught": 67, "rating": 4.9, "rating_count": 34, "is_active": true, "teaching_active": true },
  "stats": { "active_students": 5, "completed_students": 12, "sessions_completed": 45, "average_rating": 4.9, "rating_count": 34, "earnings_this_month": 15000, "total_earnings": 120000 },
  "students": [{ "id": "usr-uuid", "name": "Jane Smith", "handle": "janesmith", "avatar_url": null, "enrollment_id": "enr-uuid", "enrollment_status": "in_progress", "progress_percent": 65, "enrolled_at": "2024-01-15T10:00:00Z", "completed_at": null }],
  "sessions": {
    "upcoming": [{ "id": "ses-uuid", "student_id": "usr-uuid", "student_name": "Jane Smith", "student_avatar": null, "scheduled_start": "...", "scheduled_end": "...", "status": "scheduled", "duration_minutes": null, "recording_url": null, "module": { "title": "Module 1", "module_order": 1 } }],
    "completed": [],
    "cancelled": []
  },
  "reviews": [{ "id": "sa-uuid", "session_id": "ses-uuid", "assessor_id": "usr-uuid", "assessor_name": "Jane Smith", "assessor_avatar": null, "rating": 5, "comment": "Great session!", "teacher_rating": 5, "interaction_rating": 5, "materials_rating": 4, "created_at": "..." }]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 403 | Teacher certification required for this course |
| 404 | Course not found |

### GET /api/teaching/courses/[courseId]/resources

Get course materials for a certified Teacher. Dedicated endpoint (separate from student resources API) to allow independent evolution.

**Authentication:** Required (Teacher with active certification for this course)

**Response (200):**
```json
{
  "course_id": "crs-uuid",
  "resources": [{ "id": "res-uuid", "module_id": "mod-uuid", "type": "document", "name": "Lesson Notes", "description": "...", "download_url": "/api/resources/res-uuid/download", "external_url": null, "size_display": "1.2 MB", "mime_type": "application/pdf", "is_public": false, "download_count": 42, "created_at": "..." }],
  "module_groups": [{ "module": { "id": "mod-uuid", "title": "Module 1", "module_order": 1 }, "resources": [] }],
  "course_wide": [],
  "total_count": 5
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 403 | Teacher certification required for this course |

---

## Session Invites

### POST /api/session-invites

Teacher creates an instant session invite.

**Authentication:** Required (assigned teacher or course creator)

**Request Body:**
```json
{
  "enrollment_id": "enr-uuid"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `enrollment_id` | string | Yes | Enrollment to invite the student for |

**Response (201):**
```json
{
  "invite": {
    "id": "inv-uuid",
    "status": "pending",
    "expires_at": "2026-03-20T15:30:00Z",
    "mode": "new",
    "module_title": "Introduction to AI Tools"
  }
}
```

**Notes:**
- Validates enrollment is active, caller is assigned teacher or course creator
- No existing pending invite may exist for the enrollment
- Determines mode (`new` or `reschedule`) from booking eligibility
- Creates invite with 30-minute expiry
- Sends in-app notification to student; fire-and-forget email to student via `SessionInviteEmail` (uses `session_booked` preference type)

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not the assigned teacher or course creator, or enrollment inactive |
| 409 | Pending invite already exists for this enrollment |
| 422 | No bookable modules remaining |

---

### GET /api/session-invites

List recent invites for an enrollment. Returns pending invites, accepted invites (last hour), and recently-expired invites (last 5 minutes).

**Authentication:** Required (student, teacher, or creator for the enrollment)

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `enrollment_id` | string | Yes | Enrollment to list invites for |

**Response (200):**
```json
{
  "invites": [
    {
      "id": "inv-uuid",
      "status": "pending",
      "expires_at": "2026-03-20T15:30:00Z",
      "accepted_session_id": null,
      "teacher_name": "Jane Smith"
    }
  ]
}
```

**Notes:**
- Caller must be the student, assigned teacher, or course creator for the enrollment
- Lazily expires stale invites (past `expires_at`) before returning results
- Returns: pending (active), accepted (within last hour, includes `accepted_session_id`), recently expired (within last 5 minutes)
- `teacher_name` is joined from the users table

---

### POST /api/session-invites/[id]/accept

Student accepts a session invite. Creates a session booking from the invite and notifies the teacher.

**Path Parameter:** `id` - Invite ID

**Authentication:** Required (enrollment's student only)

**Response (200):**
```json
{
  "session": {
    "id": "ses-uuid",
    "scheduled_start": "...",
    "scheduled_end": "..."
  }
}
```

**Notes:**
- Sends in-app notification to teacher; fire-and-forget email to teacher via `SessionInviteAcceptedEmail` (uses `session_booked` preference type)

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not the enrollment's student |
| 404 | Invite not found |
| 422 | Invite is not in pending status |

---

### POST /api/session-invites/[id]/decline

Student declines a session invite.

**Path Parameter:** `id` - Invite ID

**Authentication:** Required (enrollment's student only)

**Response (200):**
```json
{
  "status": "declined"
}
```

**Notes:**
- Sends in-app notification to teacher and fire-and-forget email to teacher via `SessionInviteDeclinedEmail` (uses `session_booked` preference type). Prior to Conv 130, this endpoint had no notification or email to the teacher.

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not the enrollment's student |
| 404 | Invite not found |
| 422 | Invite is not in pending status |

---

## BBB Webhooks

### `POST /api/webhooks/bbb`

Receives BBB event webhooks (`meeting-ended`, `user-joined`, `user-left`, `rap-publish-ended`). Set via `meta_endCallbackUrl` on room creation. Returns 200 always (prevents BBB retry).

**Authentication:** URL-embedded HMAC-SHA256 token (`?token=<hex>`, generated at room creation in `join.ts`, verified against roomId). See `src/lib/webhook-auth.ts`. (Conv 075)

### `POST /api/webhooks/bbb-analytics`

Receives BBB Learning Analytics callback after meeting ends. Set via `meta_analytics-callback-url` on room creation. Stores per-attendee engagement data (talk time, chat count, attendance duration, polls) in `session_analytics` table.

**Authentication:** JWT Bearer token (HS512 signed with `BBB_SECRET`)

**Response (200):**
```json
{
  "status": "processed",
  "session_id": "sess-xxx"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Missing or invalid JWT |
| 503 | Database or BBB_SECRET not configured |
