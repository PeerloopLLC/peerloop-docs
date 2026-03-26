# API Reference: Enrollments

Enrollment listing, progress tracking, and dashboard endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Enrollment Endpoints

### GET /api/enrollments

List enrollments with optional filtering.

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `student_id` | string | Filter by student |
| `course_id` | string | Filter by course |
| `assigned_teacher_id` | string | Filter by assigned teacher |
| `status` | string | Filter by status ("enrolled", "in_progress", "completed", "cancelled") |
| `page` | number | Page number (default: 1) |
| `limit` | number | Items per page (default: 20, max: 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "enr-sarah-ai-tools",
      "status": "completed",
      "enrolled_at": "2024-03-15T00:00:00Z",
      "completed_at": "2024-05-30T00:00:00Z",
      "cancelled_at": null,
      "cancel_reason": null,
      "student": {
        "id": "usr-sarah-miller",
        "name": "Sarah Miller",
        "handle": "sarah-miller"
      },
      "course": {
        "id": "crs-ai-tools-overview",
        "title": "AI Tools Overview",
        "slug": "ai-tools-overview"
      },
      "teacher": null
    }
  ],
  "total": 6,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "hasMore": false
}
```

---

### GET /api/me/feed-badges

Get new-post counts for each of the current user's feeds since their last visit. Single D1 query, zero Stream API calls. Part of FEED-INTEL Phase 1.

**Authentication:** Required

**Response (200):**
```json
{
  "badges": {
    "townhall:the-commons": 3,
    "community:python-devs": 1,
    "course:react-101": 5
  }
}
```

Keys are `feedType:feedId`. Only feeds with new posts are included. Empty `badges` object means no new activity.

**Implementation:** Queries `feed_activities` LEFT JOIN `feed_visits` to count activities after user's last visit per feed. User's feeds derived from `community_members` + `enrollments` + `teacher_certifications` + `courses.creator_id`.

---

### GET /api/me/enrollments

Get current authenticated user's enrollments with course and instructor details.

**Authentication:** Required

**Response (200):**
```json
{
  "items": [
    {
      "id": "enr-sarah-ai-tools",
      "status": "in_progress",
      "enrolled_at": "2024-03-15T00:00:00Z",
      "completed_at": null,
      "course": {
        "id": "crs-ai-tools-overview",
        "slug": "ai-tools-overview",
        "title": "AI Tools Overview",
        "thumbnail_url": null
      },
      "creator": {
        "id": "usr-guy-rymberg",
        "name": "Guy Rymberg",
        "avatar_url": null
      },
      "teacher": null
    }
  ],
  "total": 3,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "hasMore": false
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 503 | Database not available |

---

### GET /api/me/certificates

Get current user's certificates with course info.

**Authentication:** Required

**Response (200):**
```json
{
  "items": [
    {
      "id": "cert-001",
      "course_id": "crs-ai-tools-overview",
      "course_title": "AI Tools Overview",
      "course_slug": "ai-tools-overview",
      "course_thumbnail": null,
      "type": "completion",
      "status": "issued",
      "issued_at": "2024-06-15T00:00:00Z",
      "issuer_name": "Guy Rymberg",
      "certificate_url": "/certificates/cert-001"
    }
  ]
}
```

**Notes:**
- `type`: `completion`, `mastery`, or `teaching`
- `status`: `pending`, `issued`, or `revoked`
- Ordered by `issued_at` DESC

---

## Enrollment Progress Endpoints

### GET /api/enrollments/[id]/progress

Get module completion progress for an enrollment. Only accessible by the enrolled student.

**Path Parameter:** `id` - Enrollment ID

**Response (200):**
```json
{
  "enrollment_id": "enr-001",
  "course_id": "crs-ai-tools-overview",
  "modules": [
    {
      "module_id": "mod-001",
      "module_title": "Introduction to AI Tools",
      "module_order": 1,
      "is_complete": true,
      "completed_at": "2026-01-05T14:30:00Z"
    },
    {
      "module_id": "mod-002",
      "module_title": "LLM Deep Dive",
      "module_order": 2,
      "is_complete": false,
      "completed_at": null
    }
  ],
  "completed_count": 1,
  "total_count": 4,
  "percent_complete": 25
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not authorized to view this enrollment |
| 404 | Enrollment not found |

---

### POST /api/enrollments/[id]/progress

Mark a module as complete or incomplete. Only accessible by the enrolled student.

**Path Parameter:** `id` - Enrollment ID

**Request:**
```json
{
  "moduleId": "mod-001",
  "isComplete": true
}
```

**Response (200):**
```json
{
  "success": true,
  "module_id": "mod-001",
  "is_complete": true,
  "completed_at": "2026-01-05T14:30:00Z"
}
```

**Side Effects:**
- Updates enrollment status to "in_progress" when first module marked
- Updates enrollment status to "completed" when all modules marked complete
- Reverts to "in_progress" if a module is unmarked after completion

**Errors:**

| Status | Error |
|--------|-------|
| 400 | moduleId is required / isComplete must be boolean |
| 401 | Authentication required |
| 403 | Not authorized to update this enrollment |
| 404 | Enrollment not found / Module not found in this course |

---

## Review Endpoints

### GET /api/enrollments/[id]/review

Check if a Teacher completion review exists for this enrollment.

**Authentication:** Required (enrolled student only)

**Response (200):**
```json
{
  "has_review": false,
  "review": null,
  "can_review": true
}
```

### POST /api/enrollments/[id]/review

Submit a course completion review for the Teacher. Updates `teacher_certifications.rating`.

**Authentication:** Required (enrolled student only)
**Constraint:** Enrollment must be completed. One review per enrollment.

**Body:**
```json
{
  "rating": 5,
  "comment": "Excellent teaching, highly recommend!"
}
```

**Validation:** rating 1-5, comment required (min 10 chars).

**Errors:** 400 (not completed, invalid rating/comment), 403 (not enrolled student), 409 (already reviewed).

### GET /api/enrollments/[id]/course-review

Check if a course materials review exists for this enrollment.

**Authentication:** Required (enrolled student only)

**Response (200):**
```json
{
  "has_review": false,
  "review": null,
  "can_review": true
}
```

### POST /api/enrollments/[id]/course-review

Submit a course materials review. Updates `courses.rating` and `courses.rating_count`.

**Authentication:** Required (enrolled student only)
**Constraint:** Enrollment must be completed. One review per enrollment.

**Body:**
```json
{
  "rating": 5,
  "comment": "Excellent course materials, very well structured!",
  "clarity_rating": 5,
  "relevance_rating": 4,
  "depth_rating": 5
}
```

**Validation:** rating 1-5, comment required (min 10 chars), sub-ratings optional (1-5 if provided).

**Errors:** 400 (not completed, invalid rating/comment/sub-rating), 403 (not enrolled student), 409 (already reviewed).

---

## Expectations Endpoints

### POST /api/enrollments/[id]/expectations

Capture student learning expectations for an enrollment (post-purchase, private).

**Authentication:** Required (enrolled student only)
**Constraint:** One set of expectations per enrollment.

**Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `primary_goal` | string | Yes | `career_change`, `skill_upgrade`, `personal_interest`, `academic`, `other` |
| `timeline` | string | Yes | `under_1_month`, `1_to_3_months`, `3_to_6_months`, `no_rush` |
| `prior_experience` | string | Yes | `beginner`, `some_exposure`, `intermediate`, `advanced` |
| `referral_source` | string | Yes | `search`, `social`, `referral`, `creator_content`, `other` |
| `learning_hopes` | string | Yes | Free text (min 20 chars) |
| `additional_notes` | string | No | Optional free text |

**Response (200):**
```json
{
  "expectation": {
    "id": "...",
    "enrollment_id": "enr-...",
    "primary_goal": "career_change",
    "timeline": "1_to_3_months",
    "prior_experience": "some_exposure",
    "referral_source": "social",
    "learning_hopes": "I want to integrate AI tools into my daily workflow...",
    "additional_notes": null,
    "update_count": 0
  }
}
```

**Errors:** 400 (invalid enum, learning_hopes < 20 chars), 403 (not enrolled student), 409 (already exists).

### GET /api/enrollments/[id]/expectations

Retrieve expectations for an enrollment. Multi-role authorization.

**Authentication:** Required (enrolled student, assigned Teacher, course Creator, or admin)

**Response (200):**
```json
{
  "has_expectations": true,
  "expectation": { /* ...full expectation object or null */ }
}
```

**Errors:** 403 (unauthorized user), 404 (enrollment not found).

### PATCH /api/enrollments/[id]/expectations

Update expectations (partial). Increments `update_count`.

**Authentication:** Required (enrolled student only)

**Body:** Same fields as POST, all optional. Only provided fields are updated.

**Response (200):** Updated expectation object with incremented `update_count`.

**Errors:** 400 (invalid enum, learning_hopes < 20 chars), 403 (not enrolled student), 404 (no expectations to update).

---

## Dashboard Endpoints

### GET /api/me/creator-dashboard

Get aggregated dashboard data for the authenticated creator.

**Authentication:** Required (Creator role)

**Response (200):**

> **Note:** Identity fields (name, handle) are not included — the client sources them from `CurrentUser`. Only transactional data is returned. (Conv 033)

```json
{
  "stats": {
    "courses_count": 4,
    "total_students": 172,
    "active_teacher_count": 3
  },
  "earnings": {
    "pending_balance": 28635,
    "total_earned": 0,
    "this_month": 21165,
    "payout_threshold": 5000
  },
  "pending_counts": {
    "teacher_applications": 0,
    "cert_requests": 0,
    "homework_reviews": 0
  },
  "courses": [
    {
      "id": "crs-vibe-coding-101",
      "title": "Vibe Coding 101",
      "slug": "vibe-coding-101",
      "thumbnail_url": null,
      "is_active": true,
      "student_count": 15,
      "rating": 4.9,
      "rating_count": 12,
      "price_cents": 14900,
      "discussion_feed_enabled": true
    }
  ],
  "teaching_courses": [
    {
      "course_id": "crs-ai-tools-overview",
      "course_title": "AI Tools Overview",
      "course_slug": "ai-tools-overview",
      "active_student_count": 3
    }
  ],
  "teachers": [
    {
      "user_id": "usr-sarah-miller",
      "name": "Sarah Miller",
      "handle": "sarah-miller",
      "avatar_url": null,
      "course_id": "crs-ai-tools-overview",
      "course_title": "AI Tools Overview",
      "certified_date": "2024-06-01T00:00:00Z",
      "students_taught": 8,
      "rating": 4.9
    }
  ],
  "past_teachers": []
}
```

**Notes:**
- `earnings` values are in cents
- `pending_counts` will show items when Block 6 (Certifications) and Block 7 (TeacherManagement) are implemented
- Courses are ordered by creation date (newest first)
- `teaching_courses` lists courses where the creator is also an active Teacher (empty array if not teaching)
- `teachers` lists active certified teachers for the creator's courses (excludes the creator themselves); limited to 20
- `past_teachers` lists inactive certified teachers (same shape as `teachers`); limited to 20

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Creator access required |
| 503 | Database not available |

---

### GET /api/me/teacher-dashboard

Get aggregated dashboard data for the authenticated Teacher.

**Authentication:** Required (Teacher role)

**Response (200):**

> **Note:** Identity fields (name, handle) are not included — the client sources them from `CurrentUser`. Only transactional/role state is returned. (Conv 033)

```json
{
  "user": {
    "is_available": true
  },
  "stats": {
    "total_students": 1,
    "sessions_this_week": 1,
    "sessions_completed_month": 1,
    "average_rating": 5.0,
    "students_helped_total": 8
  },
  "earnings": {
    "pending_balance": 0,
    "total_earned": 17430,
    "this_month": 0,
    "payout_threshold": 5000
  },
  "pending_counts": {
    "cert_recommendations": 0,
    "intro_requests": 1,
    "homework_reviews": 0
  },
  "certifications": [
    {
      "course_id": "crs-ai-tools-overview",
      "course_title": "AI Tools Overview",
      "certified_date": "2024-06-01",
      "students_taught": 8,
      "is_active": true
    }
  ],
  "upcoming_sessions": [
    {
      "id": "sess-sarah-001",
      "student_name": "Jennifer Kim",
      "student_avatar": null,
      "course_title": "Intro to Claude Code",
      "scheduled_start": "2026-01-10T15:00:00Z",
      "scheduled_end": "2026-01-10T16:00:00Z",
      "status": "scheduled"
    }
  ],
  "students": [
    {
      "id": "usr-jennifer-kim",
      "name": "Jennifer Kim",
      "avatar_url": null,
      "course_id": "crs-intro-to-claude-code",
      "course_title": "Intro to Claude Code",
      "progress_percent": 0,
      "enrolled_at": "2024-04-10T00:00:00Z",
      "completed_at": null
    }
  ],
  "past_students": [
    {
      "id": "usr-marcus-thompson",
      "name": "Marcus Thompson",
      "avatar_url": null,
      "course_id": "crs-ai-tools-overview",
      "course_title": "AI Tools Overview",
      "progress_percent": 100,
      "enrolled_at": "2024-02-01T00:00:00Z",
      "completed_at": "2024-04-15T00:00:00Z"
    }
  ]
}
```

**Notes:**
- `earnings` values are in cents; teacher dashboard shows only `recipient_type = 'teacher'` splits
- `is_available` reflects the Teacher's "Available for Summon" status from `user_availability` table
- `progress_percent` calculated from `module_progress.is_complete` (AVG * 100)
- `upcoming_sessions` limited to next 5 scheduled sessions
- `students` limited to 20, includes only `enrolled` or `in_progress` enrollments
- `past_students` limited to 20, includes only `completed` enrollments; `completed_at` is always set
- `stats.total_students` counts both current and past students

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Teacher access required |
| 503 | Database not available |

---

## Teacher Management Endpoints

### GET /api/me/availability

Get the authenticated Teacher's weekly availability pattern.

**Authentication:** Required (Teacher role)

**Response (200):**
```json
{
  "slots": [
    {
      "id": "avail-001",
      "day_of_week": 1,
      "start_time": "09:00",
      "end_time": "12:00"
    },
    {
      "id": "avail-002",
      "day_of_week": 1,
      "start_time": "14:00",
      "end_time": "17:00"
    }
  ],
  "timezone": "America/New_York",
  "buffer_minutes": 15
}
```

**Notes:**
- `day_of_week`: 0 = Sunday, 1 = Monday, etc.
- `start_time` and `end_time` are in 24-hour HH:MM format
- `buffer_minutes` is padding between sessions (default: 15)

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Teacher access required |

---

### PUT /api/me/availability

Replace all availability slots for the authenticated Teacher.

**Authentication:** Required (Teacher role)

**Request:**
```json
{
  "slots": [
    { "day_of_week": 1, "start_time": "09:00", "end_time": "12:00" },
    { "day_of_week": 1, "start_time": "14:00", "end_time": "17:00" },
    { "day_of_week": 2, "start_time": "10:00", "end_time": "16:00" }
  ],
  "timezone": "America/New_York",
  "buffer_minutes": 15
}
```

**Validation:**
- Each slot must be at least 1 hour (60 minutes)
- Slots cannot overlap within the same day
- `day_of_week` must be 0-6
- Times must be valid HH:MM format

**Response (200):**
```json
{
  "success": true,
  "message": "Availability updated",
  "slot_count": 3
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Invalid slots / Overlapping slots / Slot too short |
| 401 | Authentication required |
| 403 | Teacher access required |

---

### GET /api/me/teacher-earnings

Get comprehensive earnings data for the authenticated Teacher.

**Authentication:** Required (Teacher role)

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `period` | string | Time period filter: "this_month", "last_month", "this_year", "all_time" (default) |

**Response (200):**
```json
{
  "summary": {
    "available_balance": 52500,
    "pending_balance": 10430,
    "period_earnings": 21000,
    "lifetime_earnings": 174300
  },
  "by_course": [
    {
      "course_id": "crs-ai-tools-overview",
      "course_title": "AI Tools Overview",
      "students_taught": 8,
      "sessions_completed": 24,
      "gross_revenue": 89600,
      "teacher_share": 62720
    }
  ],
  "recent_transactions": [
    {
      "id": "split-001",
      "type": "session",
      "description": "Session with Jennifer Kim",
      "amount": 5250,
      "created_at": "2026-01-15T14:00:00Z",
      "status": "available"
    }
  ],
  "payout_history": [
    {
      "id": "payout-001",
      "amount": 50000,
      "status": "completed",
      "requested_at": "2026-01-01T10:00:00Z",
      "processed_at": "2026-01-02T09:00:00Z"
    }
  ],
  "stripe_status": {
    "connected": true,
    "payouts_enabled": true,
    "details_submitted": true
  }
}
```

**Notes:**
- All amounts are in cents
- Teacherearns 70% of session/enrollment revenue
- `available_balance` is ready for payout; `pending_balance` is processing
- `period_earnings` reflects the selected period filter

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Teacher access required |

---

### GET /api/me/creator-earnings

Get comprehensive royalty earnings data for the authenticated Creator.

**Authentication:** Required (Creator role - must have at least one course)

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `period` | string | Time period filter: "this_month", "last_month", "this_year", "all_time" (default: "this_month") |

**Response (200):**
```json
{
  "summary": {
    "available_balance": 7500,
    "pending_release": 2200,
    "this_period": 3000,
    "lifetime": 25000,
    "payout_threshold": 5000
  },
  "by_course": [
    {
      "course_id": "crs-ai-tools-overview",
      "course_title": "AI Tools Overview",
      "course_slug": "ai-tools-overview",
      "enrollments": 45,
      "gross_revenue": 134000,
      "your_share": 20100,
      "status": "active"
    }
  ],
  "recent_transactions": [
    {
      "id": "split-cr-001",
      "date": "2026-01-15T14:00:00Z",
      "student_name": "Jennifer Kim",
      "student_id": "usr-jennifer",
      "course_title": "AI Tools Overview",
      "course_id": "crs-ai-tools-overview",
      "teacher_name": "Alex Chen",
      "teacher_id": "usr-alex",
      "gross_amount": 7500,
      "your_share": 1125,
      "status": "paid"
    }
  ],
  "payout_history": [
    {
      "id": "payout-cr-001",
      "amount": 5000,
      "status": "completed",
      "requested_at": "2026-01-01T10:00:00Z",
      "paid_at": "2026-01-02T09:00:00Z",
      "stripe_transfer_id": "tr_abc123"
    }
  ],
  "stripe_status": {
    "connected": true,
    "payouts_enabled": true,
    "status": "complete"
  },
  "period": "this_month",
  "period_label": "This Month",
  "share_percentage": 15
}
```

**Notes:**
- All amounts are in cents
- Creator earns 15% royalty when Teachers teach their courses
- `teacher_name` and `teacher_id` indicate which Teacher generated the royalty
- `share_percentage` is always 15 for creators

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Creator access required (no courses) |

---

### GET /api/me/teacher-students

Get the authenticated Teacher's assigned students with filtering and pagination.

**Authentication:** Required (Teacher role)

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `course_id` | string | Filter by course |
| `status` | string | Filter by enrollment status: "enrolled", "in_progress", "completed" |
| `search` | string | Search student name |
| `sort` | string | Sort field: "name", "enrolled", "progress", "last_session" (default) |
| `order` | string | Sort order: "asc", "desc" (default) |
| `page` | number | Page number (default: 1) |
| `limit` | number | Items per page (default: 20, max: 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "enr-001",
      "student_id": "usr-jennifer-kim",
      "student_name": "Jennifer Kim",
      "student_avatar": null,
      "course_id": "crs-intro-to-claude-code",
      "course_title": "Intro to Claude Code",
      "enrolled_at": "2026-01-10T00:00:00Z",
      "status": "in_progress",
      "progress_percent": 25,
      "modules_completed": 1,
      "modules_total": 4,
      "sessions_count": 2,
      "last_session_at": "2026-01-18T15:00:00Z",
      "is_certified": false
    }
  ],
  "total": 15,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "hasMore": false
}
```

**Notes:**
- `progress_percent` calculated from module_progress table
- `is_certified` indicates if student completed and is certified to teach
- Students are only included if assigned to this Teacher

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Teacher access required |

---

### POST /api/me/payouts/request

Request a payout of available earnings.

**Authentication:** Required (Teacher role)

**Request:**
```json
{
  "amount": 50000
}
```

**Validation:**
- Amount must be at least $50 (5000 cents)
- Amount cannot exceed available balance
- Stripe Connect account must be connected and payouts enabled

**Response (200):**
```json
{
  "success": true,
  "payout_id": "payout-123",
  "amount": 50000,
  "status": "pending",
  "message": "Payout request submitted for admin processing"
}
```

**Notes:**
- Payout is created with "pending" status
- Admin must process via `/api/admin/payouts/[id]/process`
- Stripe transfer is not automatic (admin review required)

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Amount required / Minimum $50 / Exceeds available balance |
| 401 | Authentication required |
| 403 | Teacher access required / Stripe Connect not set up |

---

## Creator Course Management Endpoints

### GET /api/me/courses

Get the authenticated creator's courses with stats.

**Authentication:** Required (Creator role)

**Response (200):**
```json
{
  "courses": [
    {
      "id": "crs-ai-tools-overview",
      "title": "AI Tools Overview",
      "slug": "ai-tools-overview",
      "tagline": "Master AI-powered tools...",
      "thumbnail_url": "/api/storage/courses/crs-ai-tools-overview/thumbnail/1705...",
      "category_id": "cat-001",
      "category_name": "AI & Machine Learning",
      "level": "beginner",
      "price_cents": 45000,
      "student_count": 45,
      "rating": 4.8,
      "is_active": true,
      "is_retired": false,
      "module_count": 5,
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2026-01-15T00:00:00Z"
    }
  ],
  "stats": {
    "total_courses": 3,
    "published": 2,
    "draft": 1,
    "retired": 0,
    "total_students": 156
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Creator access required |
| 503 | Database not available |

---

### POST /api/me/courses

Create a new course (as draft). Requires a progression to place the course in.

**Authentication:** Required (Creator role, `can_create_courses`)

**Request:**
```json
{
  "title": "Introduction to Machine Learning",
  "category_id": "cat-001",
  "progression_id": "prog-xxxxxxxx",
  "level": "beginner"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | Yes | Course title |
| `category_id` | string | Yes | Category ID |
| `progression_id` | string | Yes | Progression to place course in (must be owned by creator, not archived) |
| `level` | string | No | `beginner` (default), `intermediate`, `advanced` |

**Response (201):**
```json
{
  "course": {
    "id": "crs-xxxxxxxx",
    "title": "Introduction to Machine Learning",
    "slug": "introduction-to-machine-learning",
    "level": "beginner",
    "category_id": "cat-001",
    "progression_id": "prog-xxxxxxxx",
    "progression_position": 1,
    "is_active": false,
    "..."
  }
}
```

**Notes:**
- Course created in draft state (`is_active = false`)
- Slug auto-generated from title (unique suffix added if conflict)
- Default price: $450 (45000 cents)
- `progression_position` auto-calculated as MAX(existing) + 1
- Progression `course_count` incremented after insert
- Badge auto-updates: progression badge set to `learning_path` when `course_count >= 2`

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Title is required / Category is required / Progression is required |
| 401 | Authentication required |
| 403 | Creator access required |
| 404 | Category not found / Progression not found |

---

### GET /api/me/courses/[id]

Get course details for editing.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "course": {
    "id": "crs-ai-tools-overview",
    "title": "AI Tools Overview",
    "slug": "ai-tools-overview",
    "tagline": "Master AI-powered tools",
    "description": "Full course description...",
    "duration": "4 weeks",
    "level": "beginner",
    "price_cents": 45000,
    "thumbnail_url": "/api/storage/...",
    "category_id": "cat-001",
    "category_name": "AI & Machine Learning",
    "is_active": true,
    "is_retired": false,
    "lifetime_access": true,
    "has_certificate": true,
    "certificate_name": "Certificate of Completion",
    "modules": [
      {
        "id": "mod-001",
        "title": "Introduction",
        "description": "...",
        "duration": "1 hour",
        "module_order": 1
      }
    ],
    "tags": ["AI", "Tools", "Productivity"]
  },
  "categories": [
    { "id": "cat-001", "name": "AI & Machine Learning", "slug": "ai-ml" }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not authorized to edit this course |
| 404 | Course not found |

---

### PUT /api/me/courses/[id]

Update course details.

**Authentication:** Required (Creator role, must own course)

**Request (partial update):**
```json
{
  "title": "Updated Title",
  "description": "Updated description...",
  "price_cents": 39900,
  "tags": ["tag1", "tag2"]
}
```

**Response (200):**
```json
{
  "course": { ... }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Invalid level / Slug format invalid |
| 401 | Authentication required |
| 403 | Not authorized to edit this course |
| 404 | Course not found / Category not found |
| 409 | Slug already exists |

---

### DELETE /api/me/courses/[id]

Delete a draft course (soft delete).

**Authentication:** Required (Creator role, must own course)

**Restrictions:**
- Only unpublished courses (`is_active = false`)
- Only courses with no enrolled students

**Response (200):**
```json
{
  "success": true,
  "message": "Course deleted"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Cannot delete published course / Cannot delete course with students |
| 401 | Authentication required |
| 403 | Not authorized to delete this course |
| 404 | Course not found |

---

### GET /api/me/courses/[id]/curriculum

Get course modules.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "modules": [
    {
      "id": "mod-001",
      "course_id": "crs-...",
      "title": "Introduction",
      "description": "Overview of the course",
      "duration": "1 hour",
      "module_order": 1,
      "session_number": 1,
      "learning_objectives": "- Understand basics\n- Setup environment",
      "topics_covered": "- Topic 1\n- Topic 2",
      "hands_on_exercise": "Build a simple project",
      "video_url": "https://youtube.com/...",
      "document_url": "https://docs.google.com/..."
    }
  ]
}
```

---

### POST /api/me/courses/[id]/curriculum

Add a new module.

**Authentication:** Required (Creator role, must own course)

**Request:**
```json
{
  "title": "Getting Started",
  "description": "Module description",
  "duration": "45 min",
  "session_number": 1,
  "learning_objectives": "- Objective 1\n- Objective 2",
  "topics_covered": "- Topic 1\n- Topic 2",
  "hands_on_exercise": "Exercise description",
  "video_url": "https://youtube.com/...",
  "document_url": "https://docs.google.com/..."
}
```

**Response (201):**
```json
{
  "module": { ... }
}
```

**Notes:**
- Module automatically assigned next `module_order` value
- Course `module_count` updated

---

### GET /api/me/courses/[id]/curriculum/[moduleId]

Get a single module with its lessons.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "module": {
    "id": "mod-001",
    "title": "Module Title",
    "duration": "1 hour",
    "module_order": 1,
    "lessons": [...]
  }
}
```

---

### PUT /api/me/courses/[id]/curriculum/[moduleId]

Update a module.

**Authentication:** Required (Creator role, must own course)

**Request (partial update):**
```json
{
  "title": "Updated Title",
  "duration": "1.5 hours"
}
```

**Response (200):**
```json
{
  "module": { ... }
}
```

---

### DELETE /api/me/courses/[id]/curriculum/[moduleId]

Delete a module.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "success": true,
  "message": "Module deleted"
}
```

**Notes:**
- Remaining modules reordered automatically
- Course `module_count` updated

---

### POST /api/me/courses/[id]/curriculum/reorder

Reorder modules.

**Authentication:** Required (Creator role, must own course)

**Request:**
```json
{
  "module_ids": ["mod-003", "mod-001", "mod-002"]
}
```

**Response (200):**
```json
{
  "modules": [ ... ]
}
```

**Notes:**
- Array must contain all module IDs (no additions/removals)
- `module_order` updated for each module

---

### PUT /api/me/courses/[id]/publish

Publish a course.

**Authentication:** Required (Creator role, must own course)

**Validation Checklist:**
- Title present
- Description present (minimum 50 characters)
- Thumbnail uploaded
- Category selected
- At least one module
- Duration specified

**Response (200) - Success:**
```json
{
  "success": true,
  "checklist": {
    "title": true,
    "description": true,
    "thumbnail": true,
    "category": true,
    "price": true,
    "modules": true,
    "duration": true
  },
  "message": "Course published successfully"
}
```

**Response (400) - Validation Failed:**
```json
{
  "success": false,
  "checklist": {
    "title": true,
    "description": false,
    "thumbnail": false,
    "category": true,
    "price": true,
    "modules": true,
    "duration": true
  },
  "missing": ["description (minimum 50 characters)", "thumbnail image"],
  "message": "Course cannot be published until all requirements are met"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Already published / Validation failed / Course is retired |
| 401 | Authentication required |
| 403 | Not authorized to publish this course |
| 404 | Course not found |

---

### PUT /api/me/courses/[id]/unpublish

Unpublish a course (return to draft).

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "success": true,
  "message": "Course unpublished and returned to draft state.",
  "had_students": true,
  "student_count": 15
}
```

**Notes:**
- Enrolled students retain access
- Warning returned if course has students

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Course is not published / Course is retired |
| 401 | Authentication required |
| 403 | Not authorized to unpublish this course |
| 404 | Course not found |

---

### POST /api/me/courses/[id]/thumbnail

Upload course thumbnail.

**Authentication:** Required (Creator role, must own course)

**Request:** `multipart/form-data` with `file` field

**Allowed Types:** image/jpeg, image/png, image/webp, image/gif

**Max Size:** 5MB

**Response (200):**
```json
{
  "success": true,
  "thumbnail_url": "/api/storage/courses/crs-.../thumbnail/1705...",
  "key": "courses/crs-.../thumbnail/1705..."
}
```

**Notes:**
- Uploaded to R2 storage
- Old thumbnail deleted automatically
- URL format: `/api/storage/{key}`

**Errors:**

| Status | Error |
|--------|-------|
| 400 | No file provided / Invalid file type / File too large |
| 401 | Authentication required |
| 403 | Not authorized to edit this course |
| 404 | Course not found |
| 503 | Storage not available |

---

### GET /api/me/courses/[id]/homework

List homework assignments for a course (creator view).

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "course_id": "crs-...",
  "course_title": "Course Name",
  "assignments": [
    {
      "id": "hw-...",
      "title": "Week 1 Assignment",
      "description": "Brief description",
      "instructions": "Detailed instructions...",
      "module_id": "mod-...",
      "module_title": "Module 1",
      "due_within_days": 7,
      "is_required": true,
      "max_points": 100,
      "is_active": true,
      "submission_count": 5,
      "pending_count": 2,
      "created_at": "2026-01-22T...",
      "updated_at": "2026-01-22T..."
    }
  ],
  "total": 1
}
```

---

### POST /api/me/courses/[id]/homework

Create a new homework assignment.

**Authentication:** Required (Creator role, must own course)

**Request Body:**
```json
{
  "title": "Week 1 Assignment",
  "description": "Brief description",
  "instructions": "Detailed instructions...",
  "module_id": "mod-...",
  "due_within_days": 7,
  "is_required": true,
  "max_points": 100
}
```

**Response (201):** Returns created assignment object

---

### GET /api/me/courses/[id]/homework/[assignmentId]

Get a single homework assignment.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "assignment": {
    "id": "hw-001",
    "title": "Week 1 Assignment",
    "description": "Brief description",
    "instructions": "Detailed instructions...",
    "module_id": "mod-001",
    "due_within_days": 7,
    "is_required": true,
    "max_points": 100
  }
}
```

---

### PUT /api/me/courses/[id]/homework/[assignmentId]

Update a homework assignment.

**Authentication:** Required (Creator role, must own course)

**Request Body:** Same fields as POST (all optional except at least one change required)

**Response (200):** Returns updated assignment object

---

### DELETE /api/me/courses/[id]/homework/[assignmentId]

Soft delete a homework assignment (sets is_active = 0).

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "success": true,
  "message": "Assignment deleted"
}
```

---

### GET /api/me/courses/[id]/resources

List resources for a course (creator view).

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "course_id": "crs-...",
  "course_title": "Course Name",
  "resources": [
    {
      "id": "res-...",
      "type": "document",
      "name": "Lecture Notes.pdf",
      "description": "Week 1 lecture notes",
      "r2_key": "courses/crs-.../resources/res-.../...",
      "external_url": null,
      "module_id": "mod-...",
      "module_title": "Module 1",
      "size_bytes": 1024000,
      "mime_type": "application/pdf",
      "is_public": false,
      "download_count": 10,
      "created_at": "2026-01-22T...",
      "updated_at": "2026-01-22T..."
    }
  ],
  "total": 1
}
```

---

### POST /api/me/courses/[id]/resources

Upload a file or add an external link.

**Authentication:** Required (Creator role, must own course)

**File Upload:** `multipart/form-data`
- `file`: The file to upload
- `name`: Display name (optional, defaults to filename)
- `description`: Brief description (optional)
- `module_id`: Link to module (optional)
- `is_public`: "true" or "false" (optional)

**Allowed Types:** PDF, Word, Excel, PowerPoint, images, audio, archives
**Max Size:** 50MB

**External Link:** `application/json`
```json
{
  "name": "Introduction Video",
  "description": "Watch this first",
  "type": "video_link",
  "external_url": "https://youtube.com/watch?v=...",
  "module_id": "mod-...",
  "is_public": false
}
```

**Response (201):** Returns created resource object

---

### GET /api/me/courses/[id]/resources/[resourceId]

Get a single resource.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "resource": {
    "id": "res-001",
    "name": "Introduction Video",
    "description": "Watch this first",
    "type": "video_link",
    "external_url": "https://youtube.com/watch?v=...",
    "module_id": "mod-001",
    "is_public": false
  }
}
```

---

### PUT /api/me/courses/[id]/resources/[resourceId]

Update resource metadata.

**Authentication:** Required (Creator role, must own course)

**Request Body:**
```json
{
  "name": "Updated Name",
  "description": "Updated description",
  "module_id": "mod-...",
  "external_url": "https://...",
  "is_public": true
}
```

**Response (200):** Returns updated resource object

---

### DELETE /api/me/courses/[id]/resources/[resourceId]

Delete a resource (removes from R2 if file-based).

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "success": true,
  "message": "Resource deleted"
}
```

---

### POST /api/me/courses/[id]/teachers

Certify a user as a Teacher for a course. Supports creator self-certification.

**Authentication:** Required (Creator role, must own course)

**Request Body:**
```json
{
  "user_id": "usr-001"
}
```

**Creator Self-Certification:** When `user_id` matches the authenticated creator, the enrollment-completion requirement is skipped. The creator can certify themselves as Teacherfor their own course without having completed it as a student.

**Side Effects:**
- Auto-sets `can_teach_courses = 1` on the certified user (enables "Teaching" nav item)

**Response (201):**
```json
{
  "teacher": {
    "id": "st-abc12345",
    "user_id": "usr-001",
    "certified_date": "2026-02-25",
    "students_taught": 0,
    "is_active": true,
    "user_name": "Guy Rymberg",
    "user_email": "guy@example.com",
    "user_handle": "guy-rymberg",
    "user_avatar_url": null,
    "active_student_count": 0,
    "completed_student_count": 0,
    "session_count": 0
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | User must complete the course before becoming a Teacher (non-creator) |
| 400 | User ID required |
| 401 | Authentication required |
| 403 | Not authorized to manage this course |
| 404 | Course not found |
| 409 | User is already a Teacher for this course |

---

### GET /api/me/courses/[id]/teachers

List teachers assigned to a course.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "teachers": [
    {
      "id": "st-001",
      "user_id": "usr-001",
      "is_active": true,
      "students_taught": 5,
      "certified_date": "2024-01-15",
      "user": {
        "id": "usr-001",
        "name": "Jane Doe",
        "handle": "janedoe"
      }
    }
  ]
}
```

---

### GET /api/me/courses/[id]/teachers/[teacherId]

Get a single teacher's details.

**Authentication:** Required (Creator role, must own course)

**Response (200):**
```json
{
  "id": "st-001",
  "user_id": "usr-001",
  "is_active": true,
  "students_taught": 5,
  "certified_date": "2024-01-15",
  "user": {
    "id": "usr-001",
    "name": "Jane Doe",
    "handle": "janedoe"
  }
}
```

---

### PUT /api/me/courses/[id]/teachers/[teacherId]

Update a teacher (activate/deactivate).

**Authentication:** Required (Creator role, must own course)

**Request Body:**
```json
{
  "is_active": false
}
```

**Response (200):**
```json
{
  "success": true,
  "is_active": false
}
```

---

## Creator Analytics Endpoints

Endpoints for the Creator Analytics dashboard (CANA). All endpoints require creator authentication and return data scoped to the creator's courses.

### GET /api/me/creator-analytics

Summary metrics for the creator analytics dashboard.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period: `7d`, `30d`, `90d`, `1y`, `all` |
| `courseId` | string | (all) | Filter to specific course |

**Response (200):**
```json
{
  "period": "30d",
  "metrics": {
    "total_revenue": 125000,
    "revenue_change": 15.5,
    "new_enrollments": 12,
    "enrollment_change": 8.3,
    "completion_rate": 68.5,
    "total_completions": 45,
    "average_rating": 4.7,
    "total_ratings": 89,
    "active_st_count": 5
  }
}
```

**Notes:**
- `total_revenue` is in cents
- `revenue_change` and `enrollment_change` are percentage change vs previous period
- `completion_rate` is all-time for stability

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Creator access required |
| 503 | Database not available |

---

### GET /api/me/creator-analytics/enrollments

Time series data for enrollments and revenue trends.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period: `7d`, `30d`, `90d`, `1y`, `all` |
| `courseId` | string | (all) | Filter to specific course |

**Response (200):**
```json
{
  "period": "30d",
  "data": [
    {
      "date": "2026-01-01",
      "enrollments": 2,
      "revenue": 90000
    },
    {
      "date": "2026-01-02",
      "enrollments": 1,
      "revenue": 45000
    }
  ]
}
```

**Notes:**
- Data is grouped by day (7d, 30d), week (90d), or month (1y, all)
- Missing dates are filled with zeros for continuous charts
- Revenue is in cents

---

### GET /api/me/creator-analytics/courses

Course performance table data.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period for period-based metrics |
| `sort` | string | `revenue` | Sort by: `revenue`, `enrollments`, `completion`, `rating` |
| `order` | string | `desc` | Sort order: `asc`, `desc` |

**Response (200):**
```json
{
  "period": "30d",
  "courses": [
    {
      "id": "crs-ai-tools",
      "title": "AI Tools Overview",
      "slug": "ai-tools-overview",
      "thumbnail_url": "/api/storage/...",
      "is_active": true,
      "price_cents": 45000,
      "rating": 4.8,
      "rating_count": 25,
      "period_revenue": 180000,
      "period_enrollments": 4,
      "total_enrollments": 45,
      "completed_count": 32,
      "completion_rate": 71.1,
      "active_teacher_count": 3
    }
  ]
}
```

**Notes:**
- `period_revenue` and `period_enrollments` are filtered by selected period
- `total_enrollments` and `completion_rate` are all-time

---

### GET /api/me/creator-analytics/funnel

Conversion funnel data showing student journey.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `courseId` | string | (all) | Filter to specific course |

**Response (200):**
```json
{
  "funnel": [
    {
      "name": "Page Views",
      "value": null,
      "placeholder": true,
      "placeholderText": "Coming soon"
    },
    {
      "name": "Enrollments",
      "value": 156,
      "rate": null
    },
    {
      "name": "Completions",
      "value": 98,
      "rate": 62.8
    },
    {
      "name": "Became Teacher",
      "value": 12,
      "rate": 12.2
    }
  ]
}
```

**Notes:**
- `rate` is conversion rate from previous step (percentage)
- Page Views shows placeholder until analytics tracking is implemented
- Enrollments rate is null (no page views to calculate against)

---

### GET /api/me/creator-analytics/progress

Student progress distribution by completion stage.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `courseId` | string | (all) | Filter to specific course |

**Response (200):**
```json
{
  "distribution": [
    { "name": "Not Started", "value": 12, "color": "#e5e7eb" },
    { "name": "1-25%", "value": 8, "color": "#fef3c7" },
    { "name": "25-50%", "value": 15, "color": "#fde68a" },
    { "name": "50-75%", "value": 22, "color": "#fcd34d" },
    { "name": "75-99%", "value": 18, "color": "#a3e635" },
    { "name": "Completed", "value": 45, "color": "#22c55e" }
  ],
  "total": 120
}
```

**Notes:**
- All six buckets are always returned (with value 0 if empty)
- Colors are Tailwind CSS color values for chart display

---

### GET /api/me/creator-analytics/sessions

Video session analytics for creator's courses.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period: `7d`, `30d`, `90d`, `1y`, `all` |
| `courseId` | string | (all) | Filter to specific course |

**Response (200):**
```json
{
  "period": "30d",
  "metrics": {
    "total_sessions": 85,
    "completed_sessions": 78,
    "cancelled_sessions": 5,
    "completion_rate": 91.8,
    "avg_duration_minutes": 52,
    "total_duration_hours": 67.6
  },
  "sessions_by_day": [
    { "name": "Sun", "value": 8 },
    { "name": "Mon", "value": 15 },
    { "name": "Tue", "value": 18 },
    { "name": "Wed", "value": 14 },
    { "name": "Thu", "value": 16 },
    { "name": "Fri", "value": 12 },
    { "name": "Sat", "value": 2 }
  ]
}
```

**Notes:**
- `sessions_by_day` shows session distribution by day of week for pattern analysis
- `avg_duration_minutes` only includes completed sessions with recorded duration

---

### GET /api/me/creator-analytics/teacher-performance

Teacher performance leaderboard.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period for period-based metrics |
| `courseId` | string | (all) | Filter to specific course |
| `sort` | string | `revenue` | Sort by: `revenue`, `students`, `rating`, `sessions` |
| `limit` | number | 10 | Max results (1-50) |

**Response (200):**
```json
{
  "period": "30d",
  "teacher_certifications": [
    {
      "rank": 1,
      "id": "st-001",
      "user_id": "usr-sarah",
      "name": "Sarah Miller",
      "avatar_url": "/api/storage/...",
      "course_id": "crs-ai-tools",
      "course_slug": "ai-tools-overview",
      "course_title": "AI Tools Overview",
      "rating": 4.9,
      "rating_count": 18,
      "is_active": true,
      "certified_at": "2025-06-01T00:00:00Z",
      "period_revenue": 52500,
      "period_sessions": 12,
      "active_students": 8,
      "completed_students": 5,
      "completion_rate": 62.5,
      "sub_ratings": {
        "teacher": 4.8,
        "interaction": 4.6,
        "materials": 4.7,
        "count": 12
      }
    }
  ]
}
```

**Notes:**
- Teachers ranked by selected sort field (descending)
- `period_revenue` and `period_sessions` are filtered by period
- `completion_rate` is percentage of their students who completed
- `sub_ratings` from session assessments (teacher/interaction/materials averages)

---

### GET /api/me/creator-analytics/materials-feedback

Paginated course reviews for the Creator's courses with sub-rating breakdown.

**Authentication:** Required (Creator role)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `courseId` | string | (all) | Filter to specific course |
| `page` | number | 1 | Page number |
| `limit` | number | 10 | Items per page (max 100) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "rev-1",
      "course_id": "crs-1",
      "course_title": "AI Tools Overview",
      "rating": 4,
      "comment": "Great course content",
      "sub_ratings": { "clarity": 4.0, "relevance": 5.0, "depth": 3.5 },
      "created_at": "2026-02-20T10:00:00Z",
      "reviewer_name": "Jennifer Kim",
      "reviewer_avatar": "/avatars/jen.jpg",
      "response": {
        "responder_name": "Guy Rymberg",
        "response": "Thank you for your feedback!",
        "created_at": "2026-02-21T08:00:00Z"
      }
    }
  ],
  "total": 25,
  "page": 1,
  "limit": 10,
  "totalPages": 3,
  "hasMore": true
}
```

**Notes:**
- Returns all course reviews across Creator's courses, or filtered by `courseId`
- `response` is null if the Creator hasn't responded yet
- Sub-ratings (clarity/relevance/depth) may be null if reviewer didn't provide them

---

## TeacherAnalytics Endpoints

Personal analytics for Teachers.

### GET /api/me/teacher-analytics

Summary KPIs for Teacherdashboard.

**Authentication:** Required (Teacherrole)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period: `7d`, `30d`, `90d`, `1y`, `all` |

**Response (200):**
```json
{
  "period": "30d",
  "earnings": {
    "current": 52500,
    "previous": 48000,
    "currency": "USD"
  },
  "sessions": {
    "current": 24,
    "previous": 20
  },
  "active_students": {
    "current": 8,
    "previous": 6
  },
  "rating": {
    "current": 4.8,
    "count": 45
  }
}
```

**Notes:**
- `earnings` in cents
- `previous` values are from the equivalent prior period for comparison
- `rating.current` is overall average, not period-specific

---

### GET /api/me/teacher-analytics/earnings

Earnings time series for charts.

**Authentication:** Required (Teacherrole)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period: `7d`, `30d`, `90d`, `1y`, `all` |

**Response (200):**
```json
{
  "period": "30d",
  "data": [
    { "date": "2026-01-01", "earnings": 2500 },
    { "date": "2026-01-02", "earnings": 3000 },
    { "date": "2026-01-03", "earnings": 0 }
  ],
  "total": 52500
}
```

**Notes:**
- `earnings` in cents per day
- Dates filled with 0 for days with no earnings
- Grouping varies by period: daily (7d/30d), weekly (90d), monthly (1y/all)

---

### GET /api/me/teacher-analytics/sessions

Session metrics and day-of-week patterns.

**Authentication:** Required (Teacherrole)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period: `7d`, `30d`, `90d`, `1y`, `all` |

**Response (200):**
```json
{
  "period": "30d",
  "summary": {
    "total_sessions": 24,
    "completed_sessions": 22,
    "cancelled_sessions": 2,
    "completion_rate": 91.7,
    "avg_duration_minutes": 48,
    "total_duration_hours": 17.6
  },
  "sessions_by_day": [
    { "name": "Sun", "value": 2 },
    { "name": "Mon", "value": 5 },
    { "name": "Tue", "value": 6 },
    { "name": "Wed", "value": 4 },
    { "name": "Thu", "value": 4 },
    { "name": "Fri", "value": 3 },
    { "name": "Sat", "value": 0 }
  ]
}
```

**Notes:**
- `sessions_by_day` helps Teachers identify their most active teaching days
- `avg_duration_minutes` only includes completed sessions

---

### GET /api/me/teacher-analytics/students

Student progress distribution.

**Authentication:** Required (Teacherrole)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `period` | string | `30d` | Time period: `7d`, `30d`, `90d`, `1y`, `all` |

**Response (200):**
```json
{
  "period": "30d",
  "distribution": [
    { "name": "Just Started", "value": 3, "fill": "#e0e0e0" },
    { "name": "Making Progress", "value": 4, "fill": "#90caf9" },
    { "name": "Almost Done", "value": 2, "fill": "#4caf50" },
    { "name": "Completed", "value": 5, "fill": "#2e7d32" }
  ],
  "total": 14
}
```

**Notes:**
- Progress buckets: 0-25% (Just Started), 26-75% (Making Progress), 76-99% (Almost Done), 100% (Completed)
- `fill` colors provided for direct use in PieChart components
- `total` is sum of all distribution values
