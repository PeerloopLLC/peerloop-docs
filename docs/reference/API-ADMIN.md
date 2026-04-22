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
    "teachers": { "total": 3, "active": 3, "pending": 0 },
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
- Pending teachers count

**Recent Activity:** Last 10 items (enrollments + user registrations), sorted by timestamp.

---

## Stripe Diagnostics

### GET /api/admin/stripe-mode

Identify which Stripe account the platform's `STRIPE_SECRET_KEY` belongs to. Confirms the key is scoped to the correct Stripe mode for the current environment (Sandbox for staging, Live for production). Added Conv 145 [VA] as a permanent audit tool so mode alignment can be verified after any secret rotation or before go-live.

**Auth:** Admin only (`requireRole(['admin'])`)

**Response (200):**
```json
{
  "account_id": "acct_1SkSfYRu7i9fxxy0",
  "livemode": false,
  "email": "owner@example.com",
  "country": "US",
  "charges_enabled": true,
  "payouts_enabled": true
}
```

**Fields:**
| Field | Description |
|-------|-------------|
| `account_id` | Stripe platform account identifier (e.g. `acct_1SkSfYRu7i9fxxy0`) |
| `livemode` | `false` for Test mode or Sandbox; `true` for Live mode |
| `email` | Account owner email registered with Stripe |
| `country` | Account country code |
| `charges_enabled` | Whether this account can accept charges |
| `payouts_enabled` | Whether connected account payouts are enabled |

**Usage:** Compare `account_id` against the Stripe Dashboard → Sandboxes page. The account identifier is also embedded as a substring of `pk_test_` / `sk_test_` key prefixes for a quick visual cross-check.

**Errors:**
| Status | Error |
|--------|-------|
| 302 | Not authenticated (redirect to login) |
| 403 | Authenticated but not admin |
| 502 | Stripe API call failed (bad key, network error) |

**Test file:** `tests/api/admin/stripe-mode.test.ts` (4 tests: unauth 302, non-admin 403, admin success, Stripe API failure 502)

---

## Users

### GET /api/admin/users

List users with filtering, sorting, and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| search | string | Search in name, email, handle |
| role | string | Filter: admin, creator, teacher, student, moderator |
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

## Topics

### GET /api/admin/topics

List all topics with course counts. Course count = distinct courses with at least one tag under this topic (via `course_tags -> tags -> topics`).

**Response (200):**
```json
{
  "topics": [
    {
      "id": "top-001",
      "name": "AI & Product Management",
      "slug": "ai-product-management",
      "icon": "🎯",
      "display_order": 1,
      "is_active": 1,
      "course_count": 5
    }
  ]
}
```

### POST /api/admin/topics

Create new topic.

**Request:**
```json
{
  "name": "Machine Learning",
  "slug": "machine-learning",
  "icon": "🤖",
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

### GET /api/admin/topics/:id

Get topic details with course count.

### PATCH /api/admin/topics/:id

Update topic fields.

**Allowed Fields:** name, slug, icon, display_order, is_active

### DELETE /api/admin/topics/:id

Delete topic. **Blocked if topic has tags that are in use by courses or users.**

**Errors:**
| Status | Error |
|--------|-------|
| 404 | Topic not found |
| 409 | Cannot delete - tags in use |

### POST /api/admin/topics/reorder

Bulk update topic display order.

**Request:**
```json
{
  "order": ["top-003", "top-001", "top-002"]
}
```

Each topic's position in the array becomes its new `display_order`.

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
| teacher_assigned | string | Filter: yes (has Teacher), no (unassigned) |
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
  "assigned_teacher_id": "usr-xxx",
  "status": "enrolled",
  "reason": "Comp enrollment",
  "send_notification": true
}
```

### GET /api/admin/enrollments/:id

Get full enrollment details with progress, sessions, and available STs.

### PATCH /api/admin/enrollments/:id

Update enrollment status or Teacher assignment.

**Allowed Fields:** status, assigned_teacher_id

### DELETE /api/admin/enrollments/:id

Soft delete (cancel) enrollment.

### POST /api/admin/enrollments/:id/cancel

Cancel enrollment with reason.

**Request:**
```json
{ "reason": "Student requested cancellation" }
```

### POST /api/admin/enrollments/:id/reassign-teacher

Reassign teacher.

**Request:**
```json
{
  "assigned_teacher_id": "usr-xxx",
  "notify_old_teacher": true,
  "notify_new_teacher": true,
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

## Teachers

### GET /api/admin/teachers

List teacher certifications with filtering and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| search | string | Search in Teacher name/email, course title |
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

### GET /api/admin/teachers/:id

Get Teacher certification detail with teaching stats, recent students, and recent sessions.

### DELETE /api/admin/teachers/:id

Revoke Teacher certification. **Blocked if active students assigned.**

**Errors:**
| Status | Error |
|--------|-------|
| 404 | Teacher certification not found |
| 400 | Cannot revoke - N active students assigned |

### POST /api/admin/teachers/:id/activate

Enable Teacher to accept new student assignments.

### POST /api/admin/teachers/:id/deactivate

Disable Teacher from accepting new students. Existing student assignments remain.

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
      "recipient_type": "teacher",
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
      "recipient_type": "teacher",
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
          "recipient_type": "teacher",
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
    "recipient_type": "teacher",
    "amount_cents": 31500,
    "status": "completed",
    "stripe_transfer_id": "tr_xxx",
    "approved_by_user_id": "usr-admin",
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
      "recipient_type": "teacher",
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

Update session admin notes or status. When `status: "completed"` is set, uses the shared `completeSession()` function to properly freeze `module_id` (same logic as BBB webhook and manual completion endpoint).

**Request:**
```json
{
  "admin_notes": "Reviewed and approved",
  "status": "completed"
}
```

**Response (200) — status change to completed:**
```json
{
  "success": true,
  "message": "Session completed",
  "session_id": "ses-001",
  "status": "completed",
  "module_id": "cur-003",
  "module_title": "Introduction to Variables",
  "ended_at": "2026-03-15T15:05:00Z",
  "already_completed": false
}
```

**Response (200) — other updates:**
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

### POST /api/admin/sessions/cleanup

Batch scan for no-show, orphaned-participant, and stale in-progress sessions. Orchestrated by `runSessionCleanup()` in `src/lib/cleanup.ts` (also called by the cron Worker). 4-stage narrowing cascade:

1. **No-show detection** (`detectNoShows()`): `status='scheduled'` AND `scheduled_end < now` AND no attendance records → `status='no_show'`.
2. **Orphaned participant detection** (`detectOrphanedParticipants()`): `status='in_progress'` AND `scheduled_end < now` AND ≥1 open `session_attendance` row AND BBB says room inactive → force-closes open rows, calls `completeSession()`. *(Conv 142)*
3. **Stale in-progress detection** (`detectStaleInProgress()`): `status='in_progress'` AND `scheduled_end + 1 hour < now` → `completeSession()` (DB-only backstop when BBB is unreachable).
4. **BBB reconcile** (`reconcileBBBSessions()`): queries BBB for sessions not yet completed; backfills recording URLs.

**Response (200):**
```json
{
  "summary": { "no_shows": 2, "orphaned_completed": 1, "auto_completed": 1, "errors": 0 },
  "no_shows": [
    { "session_id": "sess-1", "course": "AI Tools Overview", "scheduled_start": "2026-03-20T10:00:00Z" }
  ],
  "orphaned_completed": [
    { "session_id": "sess-3", "course": "AI Tools Overview", "scheduled_start": "2026-03-20T12:00:00Z", "open_rows_closed": 1 }
  ],
  "auto_completed": [
    { "session_id": "sess-2", "course": "AI Tools Overview", "scheduled_start": "2026-03-20T14:00:00Z", "module": "Module 1" }
  ],
  "errors": []
}
```

**Idempotent:** Running twice returns zero results on the second pass — already-processed sessions no longer match the filters.

*Added Conv 025. `orphaned_completed` + 4-stage cascade added Conv 142.*

---

## Moderation

Content moderation queue for reviewing flagged content.

**Auth:** Two-tier moderation access via `requireModerationAccess`:
- **Tier 1 (Global):** Admin or platform moderator (JWT roles) — full access to all flags
- **Tier 2 (Community):** Community moderators (DB-backed via `community_moderators` table) — scoped to flags with matching `community_id`

| Action | Tier 1 (Admin/Moderator) | Tier 2 (Community Mod) |
|--------|:------------------------:|:----------------------:|
| List flags | All flags | Own community flags only |
| View flag detail | All flags | Own community flags only (404 for out-of-scope) |
| Update priority | All flags | Own community flags only |
| Dismiss | All flags | Own community flags only |
| Remove content | All flags | Own community flags only |
| Warn user | Yes | **No** (403) |
| Suspend user | Yes (permanent = admin only) | **No** (403) |

### GET /api/admin/moderation

List flagged content with filtering, sorting, and pagination. Community moderators (Tier 2) see only flags where `community_id` matches their communities. Flags with null `community_id` (townhall, profile) are excluded from Tier 2 views.

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
    "reviewed_by_user_id": null,
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

Mark flag as not a violation. Community moderators can dismiss flags within their scope (returns 404 for out-of-scope).

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

Remove flagged content from platform (deletes from Stream.io). Community moderators can remove content within their scope (returns 404 for out-of-scope). Uses stored `feed_group` and `community_id` to route Stream deletion to the correct feed.

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

Issue warning to the user who created the flagged content. **Tier 1 only** — community moderators receive 403.

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

Suspend the user who created the flagged content. **Tier 1 only** — community moderators receive 403. Permanent suspensions require admin role.

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

## Certificates

### GET /api/admin/certificates

List certificates with filtering, sorting, and pagination.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| search | string | Search in user name, email, or course title |
| course_id | string | Filter by course |
| status | string | Filter: pending, issued, revoked |
| type | string | Filter: completion, mastery, teaching |
| sort | string | Sort by: created_at, issued_at, user_name, course_title, type, status (default: created_at) |
| order | string | asc or desc (default: desc) |
| page | number | Page number (default: 1) |
| limit | number | Items per page (default: 20) |

**Response (200):** Paginated certificate list with stats
```json
{
  "items": [
    {
      "id": "cert-xxx",
      "user_id": "usr-xxx",
      "user_name": "Jane Smith",
      "user_email": "[email protected]",
      "user_handle": "janesmith",
      "user_avatar_url": null,
      "course_id": "crs-xxx",
      "course_title": "Intro to ML",
      "course_slug": "intro-to-ml",
      "type": "completion",
      "status": "issued",
      "issued_at": "2026-01-15T10:00:00Z",
      "issued_by_user_id": "usr-admin",
      "issuer_name": "Admin User",
      "recommended_by_user_id": "usr-teacher",
      "recommender_name": "Teacher Name",
      "recommended_at": "2026-01-14T10:00:00Z",
      "revoked_at": null,
      "revoked_reason": null,
      "certificate_url": "https://peerloop.com/certificates/cert-xxx",
      "created_at": "2026-01-10T10:00:00Z"
    }
  ],
  "total": 25,
  "page": 1,
  "limit": 20,
  "totalPages": 2,
  "stats": {
    "total": 25,
    "pending": 5,
    "issued": 18,
    "revoked": 2
  }
}
```

### POST /api/admin/certificates

Manually issue a certificate. If a pending certificate already exists for the user/course/type combination, updates it to issued. Otherwise creates a new issued certificate.

**Request:**
```json
{
  "user_id": "usr-xxx",
  "course_id": "crs-xxx",
  "type": "completion"
}
```

**Valid types:** `completion`, `mastery`, `teaching`

**Response (201):**
```json
{
  "certificate": {
    "id": "cert-xxx",
    "user_id": "usr-xxx",
    "course_id": "crs-xxx",
    "type": "completion",
    "status": "issued",
    "issued_at": "2026-01-15T10:00:00Z"
  }
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Missing required field (user_id, course_id, type) |
| 400 | Invalid certificate type |
| 404 | User not found |
| 404 | Course not found |
| 409 | Certificate already issued for this user/course/type |

### GET /api/admin/certificates/:id

Get full certificate detail with user and course joins.

**Response (200):**
```json
{
  "certificate": {
    "id": "cert-xxx",
    "user_id": "usr-xxx",
    "user_name": "Jane Smith",
    "user_email": "[email protected]",
    "user_handle": "janesmith",
    "course_id": "crs-xxx",
    "course_title": "Intro to ML",
    "course_slug": "intro-to-ml",
    "type": "completion",
    "status": "issued",
    "issued_at": "2026-01-15T10:00:00Z",
    "issued_by_user_id": "usr-admin",
    "issuer_name": "Admin User",
    "recommended_by_user_id": "usr-teacher",
    "recommender_name": "Teacher Name",
    "recommended_at": "2026-01-14T10:00:00Z",
    "revoked_at": null,
    "revoked_reason": null,
    "certificate_url": "https://peerloop.com/certificates/cert-xxx",
    "created_at": "2026-01-10T10:00:00Z"
  }
}
```

### DELETE /api/admin/certificates/:id

Permanently delete a certificate.

**Response (200):**
```json
{ "message": "Certificate deleted successfully" }
```

### POST /api/admin/certificates/:id/reject

Reject a pending certificate (deletes it). Only works on certificates with `status: "pending"`.

**Request (optional):**
```json
{ "reason": "Student did not meet requirements" }
```

**Response (200):**
```json
{
  "message": "Certificate rejected",
  "reason": "Student did not meet requirements"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Certificate is not in pending status |

---

## Courses

### GET /api/admin/courses/:id

Get course detail with full stats including creator info, enrollment counts, curriculum, and objectives.

**Response (200):**
```json
{
  "course": {
    "id": "crs-xxx",
    "title": "Intro to ML",
    "slug": "intro-to-ml",
    "tagline": "Learn the basics of machine learning",
    "description": "Full course description...",
    "duration": "8 weeks",
    "duration_weeks": 8,
    "level": "beginner",
    "price_cents": 24900,
    "badge": "popular",
    "is_active": true,
    "is_retired": false,
    "thumbnail_url": "https://example.com/thumb.jpg",
    "creator_name": "John Doe",
    "creator_handle": "johndoe",
    "creator_email": "[email protected]",
    "enrollment_count": 42,
    "active_enrollment_count": 12,
    "completed_enrollment_count": 28,
    "teacher_count": 5,
    "curriculum": [
      { "id": "cur-001", "title": "Introduction", "order": 1 },
      { "id": "cur-002", "title": "Linear Regression", "order": 2 }
    ],
    "objectives": [
      { "id": "obj-001", "text": "Understand ML fundamentals", "order": 1 }
    ],
    "created_at": "2025-12-01T10:00:00Z",
    "updated_at": "2026-01-10T10:00:00Z"
  }
}
```

### PATCH /api/admin/courses/:id

Update course fields.

**Allowed Fields:** title, slug, tagline, description, duration, duration_weeks, level, price_cents, badge, is_active, is_retired, thumbnail_url

**Request:**
```json
{
  "title": "Updated Course Title",
  "level": "intermediate",
  "badge": "featured"
}
```

**Validation:**
- Slug: unique across courses if changed
- Level: must be one of `beginner`, `intermediate`, `advanced`
- Badge: must be one of `popular`, `new`, `bestseller`, `featured`, or `null`

**Response (200):** Updated course object

### DELETE /api/admin/courses/:id

Soft delete a course. **Blocked if course has any enrollments.**

**Response (200):**
```json
{ "success": true }
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Cannot delete course with existing enrollments |

### POST /api/admin/courses/:id/badge

Set or clear a promotional badge on a course.

**Request:**
```json
{ "badge": "featured" }
```

**Valid values:** `popular`, `new`, `bestseller`, `featured`, `null` (clears badge)

**Response (200):**
```json
{
  "course": {
    "id": "crs-xxx",
    "title": "Intro to ML",
    "badge": "featured"
  },
  "message": "Badge updated to featured"
}
```

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
    "teacher": 315000
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
    { "name": "Became Teacher", "value": 45 }
  ],
  "distribution": [
    { "name": "Students", "value": 650 },
    { "name": "Teachers", "value": 45 },
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
  "by_topic": [
    { "name": "Programming", "value": 180000 }
  ]
}
```

### GET /api/admin/analytics/teachers

Get Teacher pipeline and flywheel metrics.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| period | string | 7d, 30d, 90d, 1y, all (default: 30d) |

**Response (200):**
```json
{
  "period": "30d",
  "growth": [
    { "date": "2026-01-01", "new_teachers": 2, "cumulative": 45 }
  ],
  "funnel": [
    { "name": "Completed", "value": 300 },
    { "name": "Recommended", "value": 120 },
    { "name": "Certified", "value": 60 },
    { "name": "Active", "value": 45 }
  ],
  "flywheel": {
    "new_students": 100,
    "new_teachers": 12,
    "rate": 12.0
  },
  "top_teachers": [
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

---

## Intel

Admin intel endpoints provide lightweight attention metrics overlaid on member-facing pages. Used by `AdminCourseTab`, `AdminCommunityTab`, `AdminMemberSummary`, `AdminBadge`, and `AdminDashboardCard` components in `src/components/admin-intel/`.

### GET /api/admin/intel/course/:id

Get comprehensive admin intelligence for a single course.

**Response (200):**
```json
{
  "intel": {
    "pendingCertRequests": 2,
    "flaggedContent": 1,
    "enrollmentIssues": 0,
    "recentCancellations": 0,
    "totalRevenue": 500,
    "activeStudents": 8,
    "recentFlags": [
      { "id": "flag-1", "reason": "inappropriate", "created_at": "2026-03-29T10:00:00Z" }
    ]
  }
}
```

**Errors:** `400` (missing ID), `404` (course not found), `503` (DB unavailable)

### GET /api/admin/intel/community/:id

Get admin intelligence for a single community: flagged posts, member count, inactive moderators, recent flags.

**Response (200):**
```json
{
  "intel": {
    "flaggedPosts": 3,
    "memberCount": 45,
    "pendingModeratorInvites": 1,
    "recentFlags": []
  }
}
```

**Note:** `pendingModeratorInvites` counts `community_moderators WHERE is_active = 0` (inactive/revoked moderators), not `moderator_invites` which is global/email-based. See Conv 057 decision.

**Errors:** `400` (missing ID), `404` (community not found), `503` (DB unavailable)

### GET /api/admin/intel/user/:id

Get admin intelligence for a single user: account status, roles, enrollment count, courses created, students taught, pending flags, earnings.

**Response (200):**
```json
{
  "intel": {
    "status": "active",
    "roles": ["creator", "teacher"],
    "enrollmentCount": 3,
    "coursesCreated": 2,
    "studentsTaught": 15,
    "pendingFlags": 0,
    "totalEarnings": 1200
  }
}
```

**Errors:** `400` (missing ID), `404` (user not found), `503` (DB unavailable)

### GET /api/admin/intel/courses

Batch endpoint returning lightweight badge data (pending count) for multiple courses. Used by `/discover/courses` list view to overlay `AdminBadge` on each card.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| ids | string | Comma-separated course IDs (max 50) |

**Response (200):**
```json
{
  "intel": {
    "course-id-1": { "pendingCount": 3 },
    "course-id-2": { "pendingCount": 0 }
  }
}
```

**Errors:** `400` (missing `ids`, or > 50 IDs), `503` (DB unavailable)

### GET /api/admin/intel/communities

Batch endpoint returning lightweight badge data (pending count) for multiple communities. Used by `/discover/communities` list view to overlay `AdminBadge` on each card. Unlike the courses batch endpoint, does not filter by `deleted_at` (communities table has no soft-delete column).

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| ids | string | Comma-separated community IDs (max 50) |

**Response (200):**
```json
{
  "intel": {
    "community-id-1": { "communityId": "community-id-1", "pendingCount": 3 },
    "community-id-2": { "communityId": "community-id-2", "pendingCount": 0 }
  }
```

**Pending count includes:** flagged posts (`content_flags` with `status = 'pending'`) + inactive moderators (`community_moderators` with `is_active = 0`).

**Errors:** `400` (missing `ids`, or > 50 IDs), `503` (DB unavailable)

### GET /api/admin/intel/dashboard

Platform-wide attention metrics for the admin dashboard.

**Response (200):**
```json
{
  "intel": {
    "pendingFlags": 5,
    "pendingCreatorApps": 1,
    "suspendedUsers": 0,
    "disputedEnrollments": 2,
    "inactiveCertifications": 3
  }
}
```

**Errors:** `503` (DB unavailable)
