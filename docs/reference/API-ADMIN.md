# API Reference: Admin

Admin CRUD operations (requires admin role). Part of [API Reference](API-REFERENCE.md).

All admin endpoints require authentication with `is_admin = true`. Uses `requireRole(cookies, jwtSecret, ['admin'])` from `@lib/auth`.

---

## Dashboard

### GET /api/admin/dashboard

Get aggregated platform metrics, alerts, and recent activity for the admin dashboard.

**Response (200):**
```json
{
  "stats": {
    "users": { "total": 9, "active": 9, "suspended": 0, "newThisWeek": 0 },
    "courses": { "total": 4, "published": 4, "draft": 0, "featured": 1 },
    "enrollments": { "total": 8, "active": 1, "completed": 5, "newThisWeek": 2 },
    "studentTeachers": { "total": 3, "active": 3, "pending": 0 },
    "revenue": { "totalRevenue": 0, "thisMonth": 0, "pendingPayouts": 0 }
  },
  "alerts": [
    {
      "id": "suspended-users",
      "type": "warning",
      "title": "Suspended Users",
      "message": "1 user(s) currently suspended",
      "link": "/admin/users?status=suspended",
      "count": 1
    }
  ],
  "recentActivity": [
    {
      "id": "enrollment-123",
      "type": "enrollment",
      "description": "Jennifer Kim enrolled in \"Intro to n8n\"",
      "timestamp": "2026-01-08T10:00:00Z",
      "link": "/admin/enrollments?search=123"
    }
  ]
}
```

**Alerts:** Generated dynamically based on:
- Suspended users count
- Draft courses count
- Pending student-teachers count

**Recent Activity:** Last 10 items (enrollments + user registrations), sorted by timestamp.

---

## Users

### GET /api/admin/users

List users with filtering, sorting, and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| search | string | Search in name, email, handle |
| role | string | Filter: admin, creator, student_teacher, student, moderator |
| status | string | Filter: active, suspended, unverified |
| sort | string | Sort by: created_at, name, email, handle (default: created_at) |
| order | string | asc or desc (default: desc) |
| page | number | Page number (default: 1) |
| limit | number | Items per page (default: 20, max: 50) |

**Response (200):** Paginated user list with stats

### POST /api/admin/users

Create new user (manual admin creation).

**Request:**
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "handle": "johndoe",
  "password": "SecurePassword123!",
  "capabilities": { "can_take_courses": true, "can_create_courses": false },
  "send_welcome_email": true
}
```

**Validation:**
- Email: required, valid format, unique
- Name: required
- Handle: required, unique, alphanumeric + underscores
- Password: **required** (see note below)
- Capabilities: optional object with permission flags

**Password Requirement:** Admin-created users must have a password. This is a design decision for MVP - admin shares credentials during onboarding. See [DECISIONS.md](../../DECISIONS.md) "Admin User Creation Requires Password".

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Missing required field (email, name, handle, password) |
| 400 | Password is required |
| 400 | Invalid capability specified |
| 409 | Email already exists |
| 409 | Handle already exists |

### GET /api/admin/users/:id

Get full user details with enrollments and certifications.

### PATCH /api/admin/users/:id

Update user fields.

**Allowed Fields:**
- name, handle, title, bio_short, bio_full
- location, website, linkedin_url, twitter_url, youtube_url
- can_take_courses, can_teach_courses, can_create_courses, can_moderate_courses, is_admin
- privacy_public, email_verified

### DELETE /api/admin/users/:id

Soft delete user (sets `deleted_at`). Blocked if user has active enrollments.

### POST /api/admin/users/:id/suspend

Suspend user account.

**Request:**
```json
{ "reason": "Violation of terms" }
```

### POST /api/admin/users/:id/unsuspend

Restore suspended user account.

---

## Categories

### GET /api/admin/categories

List all categories with course counts.

**Response (200):**
```json
{
  "categories": [
    {
      "id": "cat-001",
      "name": "Machine Learning",
      "slug": "machine-learning",
      "display_order": 1,
      "course_count": 5
    }
  ]
}
```

### POST /api/admin/categories

Create new category.

**Request:**
```json
{
  "name": "Machine Learning",
  "slug": "machine-learning",
  "display_order": 1
}
```

**Validation:**
- Name: required
- Slug: required, lowercase, alphanumeric + hyphens only
- Display order: auto-assigned if not provided

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Name/slug required, invalid slug format |
| 409 | Slug already exists |

### GET /api/admin/categories/:id

Get category details with course count.

### PATCH /api/admin/categories/:id

Update category fields.

**Allowed Fields:** name, slug, display_order

### DELETE /api/admin/categories/:id

Delete category. **Blocked if courses are assigned to it.**

**Errors:**
| Status | Error |
|--------|-------|
| 404 | Category not found |
| 409 | Cannot delete - courses assigned |

### POST /api/admin/categories/reorder

Bulk update category display order.

**Request:**
```json
{
  "order": ["cat-003", "cat-001", "cat-002"]
}
```

Each category's position in the array becomes its new `display_order`.

---

## Enrollments

### GET /api/admin/enrollments

List enrollments with filtering, sorting, and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| search | string | Search in student name/email, course title |
| course_id | string | Filter by course |
| student_id | string | Filter by student |
| status | string | Filter: enrolled, in_progress, completed, cancelled |
| st_assigned | string | Filter: yes (has ST), no (unassigned) |
| date_from | string | Enrollment date range start |
| date_to | string | Enrollment date range end |
| sort | string | Sort by: enrolled_at, status, student_name, course_title |
| order | string | asc or desc (default: desc) |
| page | number | Page number (default: 1) |
| limit | number | Items per page (default: 20) |

**Response (200):** Paginated enrollment list with stats (total, active, completed, cancelled)

### POST /api/admin/enrollments

Create manual/comp enrollment (admin bypass of payment).

**Request:**
```json
{
  "student_id": "usr-xxx",
  "course_id": "crs-xxx",
  "student_teacher_id": "usr-xxx",
  "status": "enrolled",
  "reason": "Comp enrollment",
  "send_notification": true
}
```

### GET /api/admin/enrollments/:id

Get full enrollment details with progress, sessions, and available STs.

### PATCH /api/admin/enrollments/:id

Update enrollment status or ST assignment.

**Allowed Fields:** status, student_teacher_id

### DELETE /api/admin/enrollments/:id

Soft delete (cancel) enrollment.

### POST /api/admin/enrollments/:id/cancel

Cancel enrollment with reason.

**Request:**
```json
{ "reason": "Student requested cancellation" }
```

### POST /api/admin/enrollments/:id/reassign-st

Reassign student-teacher.

**Request:**
```json
{
  "student_teacher_id": "usr-xxx",
  "notify_old_st": true,
  "notify_new_st": true,
  "notify_student": true
}
```

### POST /api/admin/enrollments/:id/force-complete

Mark enrollment as completed (admin override).

**Request:**
```json
{ "reason": "Completed via alternative assessment" }
```

### POST /api/admin/enrollments/:id/refund

Process refund via Stripe.

**Request:**
```json
{
  "amount_cents": 12450,
  "reason": "Partial refund - attended 50% of sessions"
}
```

- Omit `amount_cents` for full refund
- Requires transaction record in database (created by checkout webhook)
- Stripe webhook updates enrollment to cancelled on full refund

**Response (200):**
```json
{
  "success": true,
  "refund": {
    "id": "re_xxx",
    "amount_cents": 12450,
    "status": "succeeded",
    "type": "partial"
  },
  "message": "Partial refund of $124.50 processed successfully"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 404 | No payment found (comp enrollment or legacy) |
| 400 | Already fully refunded, amount exceeds payment |

---

## Student-Teachers

### GET /api/admin/student-teachers

List student-teacher certifications with filtering and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| search | string | Search in ST name/email, course title |
| course_id | string | Filter by course |
| status | string | Filter: active, inactive |
| sort | string | Sort by: certified_date, user_name, course_title, students_taught |
| order | string | asc or desc (default: desc) |
| page | number | Page number (default: 1) |
| limit | number | Items per page (default: 20) |

**Response (200):**
```json
{
  "items": [...],
  "total": 15,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "stats": {
    "totalActive": 12,
    "totalStudentsTaught": 156,
    "avgRating": 4.7
  }
}
```

### GET /api/admin/student-teachers/:id

Get ST certification detail with teaching stats, recent students, and recent sessions.

### DELETE /api/admin/student-teachers/:id

Revoke ST certification. **Blocked if active students assigned.**

**Errors:**
| Status | Error |
|--------|-------|
| 404 | ST certification not found |
| 400 | Cannot revoke - N active students assigned |

### POST /api/admin/student-teachers/:id/activate

Enable ST to accept new student assignments.

### POST /api/admin/student-teachers/:id/deactivate

Disable ST from accepting new students. Existing student assignments remain.

**Note:** Deactivation with active students shows confirmation warning but is allowed.

---

## Creator Applications

### GET /api/admin/creator-applications

List creator applications with filtering, sorting, and pagination.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | number | 1 | Page number |
| `limit` | number | 20 | Items per page |
| `search` | string | - | Search by name, email, or expertise areas |
| `status` | string | - | Filter: `pending`, `approved`, `denied` |
| `sort` | string | `submitted_at` | Sort column |
| `order` | string | `DESC` | Sort order: `asc` or `desc` |

**Response (200):** Paginated list with stats.
```json
{
  "items": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "user_name": "Jane Smith",
      "user_email": "[email protected]",
      "user_handle": "janesmith",
      "user_avatar_url": null,
      "expertise_areas": "Web Development, UX Design",
      "teaching_experience": "...",
      "course_ideas": "...",
      "portfolio_url": "https://example.com",
      "motivation": "...",
      "status": "pending",
      "submitted_at": "2026-02-21T12:00:00.000Z",
      "reviewed_at": null,
      "reviewer_name": null,
      "admin_notes": null,
      "denial_reason": null
    }
  ],
  "total": 5,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "stats": { "total": 5, "pending": 2, "approved": 2, "denied": 1 }
}
```

### GET /api/admin/creator-applications/:id

Get full creator application detail with applicant info and reviewer info.

### POST /api/admin/creator-applications/:id/approve

Approve a pending creator application. Atomically updates application status and sets `users.can_create_courses = 1`. Sends notification and email to applicant.

**Errors:**
- `400` — Application is not in `pending` status
- `404` — Application not found

### POST /api/admin/creator-applications/:id/deny

Deny a pending creator application with optional reason and admin notes.

**Request Body (optional):**
```json
{
  "denial_reason": "User-facing feedback for the applicant",
  "admin_notes": "Internal admin notes (not shared)"
}
```

**Errors:**
- `400` — Application is not in `pending` status
- `404` — Application not found

---

## Payouts

### GET /api/admin/payouts

List payouts with filtering, sorting, and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| status | string | Filter: created, processing, completed, failed |
| recipient_id | string | Filter by recipient user ID |
| sort | string | Sort by: created_at, amount_cents (default: created_at) |
| order | string | asc or desc (default: desc) |
| page | number | Page number (default: 1) |
| limit | number | Items per page (default: 20) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "pay-xxx",
      "recipient_id": "usr-xxx",
      "recipient_type": "student_teacher",
      "recipient": { "name": "John Doe", "email": "...", "avatar_url": "..." },
      "amount_cents": 31500,
      "status": "created",
      "stripe_transfer_id": null,
      "created_at": "2026-01-08T10:00:00Z",
      "split_count": 3
    }
  ],
  "total": 5,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "stats": {
    "pending": { "amount_cents": 45000, "count": 2 },
    "processing": { "amount_cents": 0, "count": 0 },
    "paidThisMonth": { "amount_cents": 31500, "count": 1 },
    "paidAllTime": { "amount_cents": 125000, "count": 8 }
  }
}
```

### POST /api/admin/payouts

Create payout from pending splits for a recipient.

**Request:**
```json
{
  "recipient_id": "usr-xxx"
}
```

**Validation:**
- Recipient must have Stripe Connect account with payouts enabled
- Total pending splits must be ≥ $50 (minimum threshold)
- Aggregates all pending payment_splits for recipient into one payout

**Response (201):**
```json
{
  "payout": {
    "id": "pay-xxx",
    "recipient_id": "usr-xxx",
    "amount_cents": 31500,
    "status": "created",
    "split_count": 3
  }
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 404 | No pending splits for recipient |
| 400 | Stripe Connect not set up |
| 400 | Below minimum threshold ($50) |

### GET /api/admin/payouts/pending

Get pending payment splits grouped by recipient.

**Response (200):**
```json
{
  "recipients": [
    {
      "user": { "id": "usr-xxx", "name": "John Doe", "email": "...", "avatar_url": "...", "handle": "@johndoe" },
      "recipient_type": "student_teacher",
      "pending_amount_cents": 31500,
      "split_count": 3,
      "stripe_ready": true,
      "stripe_account_status": "verified",
      "splits": [
        {
          "id": "split-xxx",
          "transaction_id": "txn-xxx",
          "amount_cents": 10500,
          "percentage": 70,
          "recipient_type": "student_teacher",
          "course_title": "Intro to ML",
          "student_name": "Jane Smith",
          "created_at": "2026-01-08T10:00:00Z"
        }
      ]
    }
  ],
  "summary": {
    "total_pending_cents": 76500,
    "recipient_count": 3
  }
}
```

### GET /api/admin/payouts/:id

Get payout details with included splits.

**Response (200):**
```json
{
  "payout": {
    "id": "pay-xxx",
    "recipient_id": "usr-xxx",
    "recipient_type": "student_teacher",
    "amount_cents": 31500,
    "status": "completed",
    "stripe_transfer_id": "tr_xxx",
    "approved_by": "usr-admin",
    "approved_at": "2026-01-08T10:30:00Z",
    "paid_at": "2026-01-08T10:31:00Z",
    "failure_reason": null,
    "created_at": "2026-01-08T10:00:00Z"
  },
  "recipient": {
    "id": "usr-xxx",
    "name": "John Doe",
    "email": "john@example.com",
    "avatar_url": "...",
    "stripe_account_id": "acct_xxx",
    "stripe_payouts_enabled": true
  },
  "splits": [
    {
      "id": "split-xxx",
      "amount_cents": 10500,
      "percentage": 70,
      "recipient_type": "student_teacher",
      "course_title": "Intro to ML",
      "student_name": "Jane Smith",
      "created_at": "2026-01-08T10:00:00Z"
    }
  ]
}
```

### DELETE /api/admin/payouts/:id

Cancel pending payout. Returns splits to pool.

**Validation:** Only payouts with status `created` can be cancelled.

**Response (200):**
```json
{
  "success": true,
  "message": "Payout cancelled, 3 splits returned to pending"
}
```

### POST /api/admin/payouts/:id/process

Execute Stripe transfer for payout.

**Request:** None (payout ID in URL)

**Validation:**
- Payout must have status `created`
- Recipient must have Stripe payouts enabled

**Response (200):**
```json
{
  "success": true,
  "payout": {
    "id": "pay-xxx",
    "status": "completed",
    "stripe_transfer_id": "tr_xxx",
    "paid_at": "2026-01-08T10:31:00Z"
  }
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Payout not in created status |
| 400 | Recipient Stripe payouts not enabled |
| 500 | Stripe transfer failed (moves to failed status) |

### POST /api/admin/payouts/:id/retry

Retry failed payout (reset to created status).

**Validation:** Only payouts with status `failed` can be retried.

**Response (200):**
```json
{
  "success": true,
  "payout": {
    "id": "pay-xxx",
    "status": "created",
    "failure_reason": null
  }
}
```

### POST /api/admin/payouts/batch

Batch process all pending payouts.

**Request:** None

**Response (200):**
```json
{
  "success": true,
  "processed": 3,
  "failed": 1,
  "results": [
    { "payout_id": "pay-001", "success": true },
    { "payout_id": "pay-002", "success": true },
    { "payout_id": "pay-003", "success": false, "error": "Stripe payouts not enabled" }
  ]
}
```

---

## Sessions

### GET /api/admin/sessions

List sessions with filtering, sorting, and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| `search` | string | Search by student/teacher name or course title |
| `course_id` | string | Filter by course |
| `status` | string | Filter: scheduled, in_progress, completed, cancelled |
| `has_recording` | boolean | Filter by recording availability |
| `has_issues` | boolean | Filter sessions with low ratings or disputes |
| `date_from` | string | Start of date range (ISO 8601) |
| `date_to` | string | End of date range (ISO 8601) |
| `page` | number | Page number (default: 1) |
| `limit` | number | Items per page (default: 20) |
| `sort` | string | Sort by: scheduled_start, created_at, status |
| `order` | string | asc or desc (default: desc) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "ses-123",
      "scheduled_start": "2026-01-20T14:00:00Z",
      "scheduled_end": "2026-01-20T15:00:00Z",
      "status": "completed",
      "duration_minutes": 60,
      "has_recording": true,
      "course": { "id": "crs-456", "title": "Course Title", "slug": "course-slug" },
      "teacher": { "id": "usr-789", "name": "Teacher Name", "avatar_url": null },
      "student": { "id": "usr-abc", "name": "Student Name", "avatar_url": null },
      "ratings": { "student": 5, "teacher": 4, "average": 4.5 },
      "has_issues": false
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 20,
  "totalPages": 5,
  "stats": {
    "total": 100,
    "today": 5,
    "this_week": 25,
    "completed": 80,
    "cancelled": 5,
    "with_recording": 60
  }
}
```

---

### GET /api/admin/sessions/:id

Get session detail with assessments and attendance records.

**Response (200):**
```json
{
  "session": {
    "id": "ses-123",
    "enrollment_id": "enr-456",
    "scheduled_start": "2026-01-20T14:00:00Z",
    "scheduled_end": "2026-01-20T15:00:00Z",
    "started_at": "2026-01-20T14:02:00Z",
    "ended_at": "2026-01-20T14:58:00Z",
    "status": "completed",
    "bbb_meeting_id": "abc123",
    "has_recording": true,
    "recording_url": "https://bbb.example.com/playback/...",
    "admin_notes": "Session went well",
    "has_issues": false,
    "course": { "id": "crs-456", "title": "Course Title", "slug": "course-slug" },
    "teacher": { "id": "usr-789", "name": "Teacher", "email": "t@example.com", "avatar_url": null },
    "student": { "id": "usr-abc", "name": "Student", "email": "s@example.com", "avatar_url": null }
  },
  "assessments": [
    {
      "id": "asm-1",
      "assessor": { "id": "usr-abc", "name": "Student", "role": "student" },
      "assessee": { "id": "usr-789", "name": "Teacher", "role": "teacher" },
      "rating": 5,
      "comment": "Great session!",
      "created_at": "2026-01-20T15:00:00Z"
    }
  ],
  "attendance": [
    {
      "id": "att-1",
      "user_id": "usr-abc",
      "user_name": "Student",
      "role": "student",
      "joined_at": "2026-01-20T14:00:00Z",
      "left_at": "2026-01-20T14:58:00Z",
      "duration_seconds": 3480
    }
  ]
}
```

---

### PATCH /api/admin/sessions/:id

Update session admin notes or status.

**Request:**
```json
{
  "admin_notes": "Reviewed and approved",
  "status": "completed"
}
```

**Response (200):**
```json
{ "success": true, "message": "Session updated" }
```

---

### GET /api/admin/sessions/:id/recording

Fetch recording URL from BBB. Caches URL in sessions table for subsequent requests.

**Response (200):**
```json
{
  "recording": {
    "id": "rec-123",
    "url": "https://bbb.example.com/playback/...",
    "duration_seconds": 3480,
    "created_at": "2026-01-20T15:05:00Z",
    "source": "bbb"
  }
}
```

**Response (404):** No recording available
**Response (200 with message):** Recording still processing

---

### DELETE /api/admin/sessions/:id/recording

Delete recording from BBB and clear cached URL.

**Response (200):**
```json
{ "success": true, "message": "Deleted 1 recording(s)" }
```

---

### POST /api/admin/sessions/:id/resolve

Apply dispute resolution to a session.

**Request:**
```json
{
  "resolution_type": "credit_student",
  "resolution_notes": "Student credited due to technical issues",
  "credit_sessions": 1
}
```

**Valid resolution_type values:**
- `no_action` - No action taken
- `warning_student` - Warning issued to student
- `warning_teacher` - Warning issued to teacher
- `warning_both` - Warning issued to both
- `credit_student` - Free session credit to student
- `credit_teacher` - Free session credit to teacher
- `refund` - Mark for refund (use enrollment refund API)

**Response (200):**
```json
{
  "success": true,
  "message": "Dispute resolved successfully",
  "actions": [
    "Session marked as resolved with type: credit_student",
    "Credited 1 free session(s) to student"
  ]
}
```

---

## Moderation

Content moderation queue for reviewing flagged content.

### GET /api/admin/moderation

List flagged content with filtering, sorting, and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| `search` | string | Search in content, reporter name, target user |
| `status` | string | Filter: pending, dismissed, actioned, all (default: pending) |
| `reason` | string | Filter: spam, harassment, inappropriate, misinformation, other |
| `content_type` | string | Filter: post, comment, profile |
| `priority` | string | Filter: low, normal, high, urgent |
| `date_from` | string | Start of date range (ISO 8601) |
| `date_to` | string | End of date range (ISO 8601) |
| `page` | number | Page number (default: 1) |
| `limit` | number | Items per page (default: 20) |
| `sort` | string | Sort by: created_at, priority (default: created_at) |
| `order` | string | asc or desc (default: desc) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "flg-123",
      "content_type": "post",
      "content_preview": "Truncated content text...",
      "reason": "harassment",
      "status": "pending",
      "priority": "high",
      "created_at": "2026-01-21T10:00:00Z",
      "flagger": { "id": "usr-xxx", "name": "Reporter", "avatar_url": null },
      "target_user": { "id": "usr-yyy", "name": "Target", "avatar_url": null, "handle": "target" },
      "flag_count": 3
    }
  ],
  "total": 15,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "stats": {
    "total": 50,
    "pending": 15,
    "resolved_today": 5,
    "urgent_pending": 2,
    "by_reason": { "spam": 10, "harassment": 5, "inappropriate": 3, "misinformation": 1, "other": 1 }
  }
}
```

---

### GET /api/admin/moderation/:id

Get full flag details with related flags and action history.

**Response (200):**
```json
{
  "flag": {
    "id": "flg-123",
    "content_type": "post",
    "stream_activity_id": "abc123...",
    "content_snapshot": { "text": "Full content", "author_name": "Author", "posted_at": "..." },
    "reason": "harassment",
    "reason_details": "Additional context",
    "status": "pending",
    "priority": "high",
    "reviewed_by": null,
    "reviewed_at": null,
    "created_at": "2026-01-21T10:00:00Z"
  },
  "flagger": { "id": "...", "name": "...", "email": "...", "avatar_url": null, "handle": "...", "created_at": "..." },
  "target_user": {
    "id": "...", "name": "...", "email": "...", "avatar_url": null, "handle": "...",
    "suspended_at": null, "created_at": "...",
    "previous_violations": 2, "warning_count": 1
  },
  "related_flags": [
    { "id": "flg-124", "reason": "spam", "status": "pending", "created_at": "...", "flagger_name": "Other Reporter" }
  ],
  "actions": [
    { "id": "act-1", "action_type": "warn_user", "performed_by": { "id": "...", "name": "Admin" }, "notes": "...", "created_at": "..." }
  ]
}
```

---

### PATCH /api/admin/moderation/:id

Update flag priority.

**Request:**
```json
{ "priority": "urgent" }
```

**Response (200):**
```json
{ "success": true, "message": "Flag updated" }
```

---

### POST /api/admin/moderation/:id/dismiss

Mark flag as not a violation.

**Request:**
```json
{ "notes": "Optional internal notes" }
```

**Response (200):**
```json
{ "success": true, "message": "Flag dismissed", "action_id": "act-xxx" }
```

---

### POST /api/admin/moderation/:id/remove

Remove flagged content from platform (deletes from Stream.io).

**Request:**
```json
{ "notes": "Optional internal notes" }
```

**Response (200):**
```json
{ "success": true, "message": "Content removed from platform", "action_id": "act-xxx", "stream_deleted": true }
```

**Note:** Only works for `post` and `comment` content types. Profile flags cannot use this action.

---

### POST /api/admin/moderation/:id/warn

Issue warning to the user who created the flagged content.

**Request:**
```json
{
  "message": "Warning message to user (required)",
  "notes": "Optional internal notes"
}
```

**Response (200):**
```json
{ "success": true, "message": "Warning issued to user", "action_id": "act-xxx", "warning_id": "wrn-xxx" }
```

---

### POST /api/admin/moderation/:id/suspend

Suspend the user who created the flagged content.

**Request:**
```json
{
  "duration": "7d",
  "reason": "Suspension reason (required)",
  "notes": "Optional internal notes"
}
```

**Valid durations:** `1d`, `7d`, `30d`, `permanent`

**Response (200):**
```json
{
  "success": true,
  "message": "User suspended for 7d",
  "action_id": "act-xxx",
  "duration": "7d",
  "suspension_end": "2026-01-28T10:00:00Z"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Flag already processed |
| 400 | No target user to suspend |
| 400 | User already suspended |
| 400 | Missing duration or reason |

---

## Moderator Invites

### POST /api/admin/moderators/invite

Create and send a moderator invitation. Sends email via Resend.

**Request:**
```json
{
  "email": "newmod@example.com",
  "expires_in_days": 7
}
```

**Validation:**
- Email: required, valid format
- `expires_in_days`: 1-30 (default: 7)
- Cannot invite existing moderator
- Cannot duplicate pending invite for same email

**Response (200):**
```json
{
  "success": true,
  "invite_id": "inv-xxx",
  "email": "newmod@example.com",
  "invite_url": "https://peerloop.com/invite/mod/abc123",
  "expires_at": "2026-01-28T10:00:00Z",
  "expires_in_days": 7,
  "email_sent": true,
  "email_error": null
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Invalid email address |
| 400 | User is already a moderator |
| 400 | Pending invitation already exists |

**Note:** If `RESEND_API_KEY` is not configured, invite is created but `email_sent` will be false with an error message.

---

### GET /api/admin/moderators

List moderators or invites (dual-view). Auto-expires stale pending invites.

**Query Params:**

| Param | Type | Description |
|-------|------|-------------|
| view | string | `moderators` (default) or `invites` |
| search | string | Search name/email/handle (moderators) or email (invites) |
| status | string | Invite status filter: pending, accepted, declined, expired |
| sort | string | Sort column (default: name ASC for moderators, created_at DESC for invites) |
| order | string | asc or desc |
| page | number | Page number (default: 1) |
| limit | number | Items per page (default: 20, max: 100) |

**Response (200):**
```json
{
  "items": [...],
  "total": 5,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "stats": {
    "total_moderators": 3,
    "pending_invites": 2,
    "accepted_invites": 5,
    "declined_invites": 1
  }
}
```

Stats are always returned regardless of `view`.

---

### POST /api/admin/moderators/:id/revoke

Revoke (cancel) a pending moderator invitation.

**Validation:**
- Invite must exist and have status `pending`

**Response (200):**
```json
{
  "success": true,
  "message": "Invitation to user@example.com has been revoked"
}
```

---

### POST /api/admin/moderators/:id/resend

Resend a pending moderator invitation email. Resets expiration to 7 days.

**Validation:**
- Invite must exist and have status `pending`

**Response (200):**
```json
{
  "success": true,
  "message": "Invitation resent to user@example.com",
  "expires_at": "2026-02-18T...",
  "email_sent": true,
  "email_error": null
}
```

---

### POST /api/admin/moderators/:id/remove

Remove moderator role from a user. Sets `can_moderate_courses = 0`.

**Validation:**
- User must exist and currently be a moderator

**Response (200):**
```json
{
  "success": true,
  "message": "Moderator role removed from User Name"
}
```

---

## Moderator Invite Tokens (Public)

These endpoints are accessible without admin authentication - the token itself is the credential.

### GET /api/moderator-invites/:token

Validate invite token and get details.

**Response (200 - valid):**
```json
{
  "valid": true,
  "status": "pending",
  "email_masked": "n***@example.com",
  "email": "newmod@example.com",
  "invited_by": "Admin Name",
  "expires_at": "2026-01-28T10:00:00Z",
  "days_remaining": 7,
  "invite_id": "inv-xxx"
}
```

**Response (404/410 - invalid):**
```json
{
  "valid": false,
  "error": "invalid_token | expired | already_used",
  "message": "Human-readable error message"
}
```

---

### POST /api/moderator-invites/:token/accept

Accept a moderator invitation. Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "message": "Welcome to the moderation team!",
  "redirect": "/mod"
}
```

**Response (401 - not authenticated):**
```json
{
  "requires_auth": true,
  "return_url": "/invite/mod/abc123",
  "message": "Please log in or create an account to accept this invitation."
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 403 | Email mismatch (logged in as different user than invitee) |
| 410 | Invitation expired or already used |

---

### POST /api/moderator-invites/:token/decline

Decline a moderator invitation. No authentication required.

**Response (200):**
```json
{
  "success": true,
  "message": "Invitation declined. Thank you for your response."
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 404 | Invalid invite token |
| 410 | Invitation already accepted/declined/expired |

---

## Analytics

Platform-wide analytics for admin dashboard. All analytics endpoints support period filtering.

### GET /api/admin/analytics

Get executive summary KPIs.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| period | string | 7d, 30d, 90d, 1y, all (default: 30d) |

**Response (200):**
```json
{
  "period": "30d",
  "kpis": {
    "total_revenue": 450000,
    "revenue_change": 12.5,
    "platform_take": 67500,
    "platform_take_change": 12.5,
    "active_users": 850,
    "active_users_change": 8.2,
    "completion_rate": 72.5,
    "completion_rate_change": 2.1,
    "flywheel_rate": 14.2,
    "flywheel_rate_change": 1.5
  }
}
```

### GET /api/admin/analytics/revenue

Get revenue trends and distribution.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| period | string | 7d, 30d, 90d, 1y, all (default: 30d) |

**Response (200):**
```json
{
  "period": "30d",
  "trend": [
    { "date": "2026-01-01", "revenue": 15000 }
  ],
  "distribution": {
    "platform": 67500,
    "creator": 67500,
    "st": 315000
  },
  "metrics": {
    "gross_revenue": 450000,
    "avg_order_value": 45000,
    "total_payouts": 280000,
    "pending_payouts": 85000
  }
}
```

### GET /api/admin/analytics/users

Get user growth and funnel data.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| period | string | 7d, 30d, 90d, 1y, all (default: 30d) |

**Response (200):**
```json
{
  "period": "30d",
  "growth": [
    { "date": "2026-01-01", "signups": 12, "cumulative": 850 }
  ],
  "funnel": [
    { "name": "Signups", "value": 1000 },
    { "name": "Enrolled", "value": 400 },
    { "name": "Completed", "value": 300 },
    { "name": "Became S-T", "value": 45 }
  ],
  "distribution": [
    { "name": "Students", "value": 650 },
    { "name": "Student-Teachers", "value": 45 },
    { "name": "Creators", "value": 12 }
  ]
}
```

### GET /api/admin/analytics/courses

Get course and creator performance metrics.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| period | string | 7d, 30d, 90d, 1y, all (default: 30d) |

**Response (200):**
```json
{
  "period": "30d",
  "trend": [
    { "date": "2026-01-01", "new_courses": 2, "cumulative": 45 }
  ],
  "top_courses": [
    {
      "id": "crs-xxx",
      "title": "Course Title",
      "creator_name": "John Doe",
      "revenue": 85000,
      "enrollments": 42,
      "completion_rate": 78.5,
      "rating": 4.8
    }
  ],
  "top_creators": [
    {
      "id": "usr-xxx",
      "name": "John Doe",
      "avatar_url": "...",
      "courses": 3,
      "revenue": 125000,
      "students": 85,
      "avg_rating": 4.7
    }
  ],
  "by_category": [
    { "name": "Programming", "value": 180000 }
  ]
}
```

### GET /api/admin/analytics/student-teachers

Get S-T pipeline and flywheel metrics.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| period | string | 7d, 30d, 90d, 1y, all (default: 30d) |

**Response (200):**
```json
{
  "period": "30d",
  "growth": [
    { "date": "2026-01-01", "new_sts": 2, "cumulative": 45 }
  ],
  "funnel": [
    { "name": "Completed", "value": 300 },
    { "name": "Recommended", "value": 120 },
    { "name": "Certified", "value": 60 },
    { "name": "Active", "value": 45 }
  ],
  "flywheel": {
    "new_students": 100,
    "new_sts": 12,
    "rate": 12.0
  },
  "top_sts": [
    {
      "id": "st-xxx",
      "name": "Jane Smith",
      "avatar_url": "...",
      "course_title": "Course Title",
      "students": 18,
      "sessions": 45,
      "rating": 4.9,
      "revenue": 42000
    }
  ]
}
```

### GET /api/admin/analytics/engagement

Get session and engagement metrics.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| period | string | 7d, 30d, 90d, 1y, all (default: 30d) |

**Response (200):**
```json
{
  "period": "30d",
  "sessions": {
    "total": 450,
    "completed": 380,
    "cancelled": 70,
    "completion_rate": 84.4,
    "avg_duration": 52,
    "total_hours": 329
  },
  "session_trend": [
    { "date": "2026-01-01", "completed": 12, "cancelled": 2 }
  ],
  "progress_distribution": [
    { "name": "Not Started", "value": 50 },
    { "name": "1-25%", "value": 80 },
    { "name": "25-50%", "value": 120 },
    { "name": "50-75%", "value": 95 },
    { "name": "75-99%", "value": 55 },
    { "name": "Completed", "value": 300 }
  ],
  "avg_completion_days": 42
}
