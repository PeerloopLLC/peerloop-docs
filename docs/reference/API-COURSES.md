# API Reference: Courses

Course listing, details, reviews, curriculum, and resources. Part of [API Reference](API-REFERENCE.md).

---

## Course Endpoints

### GET /api/courses

List courses with optional filtering, search, and pagination.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `category` | string | - | Filter by category slug (e.g., "ai-automation") |
| `level` | string | - | Filter by level ("beginner", "intermediate", "advanced") |
| `search` | string | - | Search in title and description |
| `sort` | string | "popular" | Sort by "popular", "rating", "newest", "price" |
| `page` | number | 1 | Page number |
| `limit` | number | 12 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "crs-ai-tools-overview",
      "slug": "ai-tools-overview",
      "title": "AI Tools Overview",
      "tagline": "Navigate the AI landscape with confidence",
      "thumbnail_url": null,
      "price_cents": 24900,
      "currency": "USD",
      "rating": 4.9,
      "rating_count": 34,
      "student_count": 67,
      "badge": "featured",
      "level": "beginner",
      "session_count": 2,
      "total_duration": "3 hours",
      "duration_weeks": 2,
      "category_id": "cat-001",
      "creator": {
        "name": "Guy Rymberg",
        "avatar_url": null
      }
    }
  ],
  "total": 4,
  "page": 1,
  "limit": 12,
  "totalPages": 1,
  "hasMore": false
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 503 | Database not available |
| 500 | Failed to fetch courses |

---

### GET /api/courses/[slug]

Get full course details by slug.

**Response (200):**
```json
{
  "id": "crs-ai-tools-overview",
  "slug": "ai-tools-overview",
  "title": "AI Tools Overview",
  "tagline": "...",
  "description": "...",
  "price_cents": 24900,
  "currency": "USD",
  "level": "beginner",
  "rating": 4.9,
  "...": "...",
  "creator": {
    "id": "usr-guy-rymberg",
    "handle": "guy-rymberg",
    "name": "Guy Rymberg",
    "title": "AI & Automation Expert",
    "avatar_url": null,
    "bio_short": "...",
    "teaching_philosophy": "..."
  },
  "objectives": [...],
  "includes": [...],
  "prerequisites": [...],
  "target_audience": [...],
  "curriculum": [...],
  "testimonials": [...],
  "tags": [...],
  "teachers": [...]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Slug is required |
| 404 | Course not found |

---

### GET /api/courses/[id]/reviews

Get student reviews for a course (public listing from `course_reviews` table).

**Path Parameter:** `id` - Course ID or slug

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | number | 1 | Page number |
| `limit` | number | 10 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "cr-sarah-ai",
      "enrollment_id": "enr-sarah-ai-tools",
      "reviewer_id": "usr-sarah-miller",
      "course_id": "crs-ai-tools-overview",
      "rating": 5,
      "comment": "The course materials are incredibly well-structured...",
      "clarity_rating": 5,
      "relevance_rating": 5,
      "depth_rating": 4,
      "created_at": "2024-05-30T00:00:00Z",
      "reviewer_name": "Sarah Miller",
      "reviewer_avatar": "/avatars/sarah.jpg",
      "response": {
        "responder_name": "Guy Rymberg",
        "response": "Thank you for the kind review!",
        "created_at": "2024-06-01T00:00:00Z"
      }
    }
  ],
  "total": 5,
  "page": 1,
  "limit": 10,
  "totalPages": 1,
  "hasMore": false
}
```

---

### GET /api/courses/[id]/curriculum

Get all curriculum modules for a course. Public endpoint.

**Path Parameter:** `id` - Course ID

**Response (200):**
```json
{
  "course_id": "crs-ai-tools-overview",
  "course_title": "AI Tools Overview",
  "modules": [
    {
      "id": "mod-001",
      "course_id": "crs-ai-tools-overview",
      "session_number": 1,
      "title": "Introduction to AI Tools",
      "description": "Overview of the AI landscape...",
      "duration": "45 min",
      "learning_objectives": "[\"Understand AI categories\", \"...\"]",
      "topics_covered": "[\"LLMs\", \"Image generation\", \"...\"]",
      "hands_on_exercise": "Try 3 AI tools and compare...",
      "video_url": "https://youtube.com/watch?v=...",
      "document_url": null,
      "module_order": 1
    }
  ],
  "total_modules": 4
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Course ID is required |
| 404 | Course not found |

---

### GET /api/courses/[id]/resources

Get all downloadable resources for a course. Requires authentication and enrollment.

**Path Parameter:** `id` - Course ID

**Response (200):**
```json
{
  "course_id": "crs-ai-tools-overview",
  "enrollment_id": "enr-001",
  "resources": [
    {
      "id": "res-001",
      "module_id": "mod-001",
      "type": "document",
      "name": "AI Tools Cheat Sheet.pdf",
      "description": "Quick reference for all tools covered",
      "download_url": "/api/resources/res-001/download",
      "external_url": null,
      "size_display": "2.4 MB",
      "mime_type": "application/pdf",
      "is_public": false
    }
  ],
  "by_module": {
    "mod-001": [...]
  },
  "course_wide": [...],
  "total_count": 5
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not enrolled in this course |
| 404 | Course not found |

---

### GET /api/courses/[id]/sessions

Get sessions for the current enrolled student. Used by the Resources tab (completed only) and the Sessions tab (all statuses).

**Path Parameter:** `id` - Course ID

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `status` | string | `completed` | Filter by session status. Use `all` to return all statuses. |

**Response (200):**
```json
{
  "sessions": [
    {
      "id": "ses-001",
      "scheduled_start": "2026-03-10T14:00:00Z",
      "scheduled_end": "2026-03-10T15:00:00Z",
      "status": "completed",
      "recording_url": "https://bbb.example.com/playback/...",
      "teacher_name": "Jane Smith",
      "teacher_id": "usr-123",
      "teacher_avatar_url": "https://example.com/avatar.jpg",
      "module_title": "Introduction to AI",
      "module_order": 1,
      "duration_minutes": 55
    }
  ]
}
```

**Notes:**
- Results ordered by `scheduled_start ASC`
- Module info comes from `course_curriculum` join via `session.module_id`
- `module_title` and `module_order` are null if session has no linked module

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not enrolled in this course |

---

### GET /api/courses/[id]/availability-summary

Public endpoint (no auth required). Returns teacher availability summary for a course — slot counts and next-available dates within a configurable window. Used by `CourseAvailabilityPreview` component on the course detail page.

**Path Parameter:** `id` - Course ID

**Authentication:** Optional. If authenticated, the requesting user is excluded from the teacher list (teachers don't see themselves).

**Response (200):**
```json
{
  "availabilityWindowDays": 30,
  "teachers": [
    {
      "userId": "usr-xxx",
      "name": "Jane D.",
      "handle": "janed",
      "avatarUrl": "...",
      "rating": 4.8,
      "ratingCount": 12,
      "studentsTaught": 15,
      "slotsAvailable": 12,
      "nextAvailable": "2026-03-19"
    }
  ],
  "totalSlots": 15,
  "teacherCount": 2,
  "hasAvailability": true
}
```

**Notes:**
- Shows slot COUNTS and next-available DATES only (not exact times)
- Availability window is admin-configurable via `platform_stats.availability_window_days` (default 30)
- Teachers with `teaching_active=0` get 0 slots
- Ordered by `students_taught DESC`

**Errors:**

| Status | Error |
|--------|-------|
| 404 | Course not found or inactive |

---

### GET /api/courses/[id]/homework

Get all homework assignments for a course. Requires authentication — only enrolled students can access.

**Path Parameter:** `id` - Course ID

**Authentication:** Required (enrolled student)

**Response (200):**
```json
{
  "course_id": "crs-ai-tools-overview",
  "course_title": "AI Tools Overview",
  "enrollment_id": "enr-sarah-ai-tools",
  "assignments": [
    {
      "id": "hw-001",
      "title": "AI Tool Comparison",
      "description": "Compare three AI tools...",
      "instructions": "Select 3 tools from the list...",
      "module_id": "mod-001",
      "due_within_days": 7,
      "is_required": true,
      "max_points": 100,
      "created_at": "2024-04-01T00:00:00Z",
      "submission": null
    },
    {
      "id": "hw-002",
      "title": "Automation Workflow",
      "description": "Build a simple automation...",
      "instructions": "Using n8n, create a workflow...",
      "module_id": "mod-002",
      "due_within_days": 14,
      "is_required": true,
      "max_points": 150,
      "created_at": "2024-04-01T00:00:00Z",
      "submission": {
        "id": "sub-001",
        "status": "submitted",
        "points": null,
        "submitted_at": "2024-04-10T12:00:00Z"
      }
    }
  ],
  "total": 2
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not enrolled in this course |
| 404 | Course not found |

---

### GET /api/courses/[slug]/discussion-feed

Get discussion feed status for a course. Creator only.

**Path Parameter:** `slug` - Course slug

**Authentication:** Required (course creator)

**Response (200):**
```json
{
  "enabled": true,
  "createdAt": "2024-06-01T00:00:00Z",
  "feedId": "course:ai-tools-overview"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not the course creator |

---

### POST /api/courses/[slug]/discussion-feed

Enable or disable discussion feed for a course. Creator only.

**Path Parameter:** `slug` - Course slug

**Authentication:** Required (course creator)

**Request Body:**
```json
{
  "action": "enable"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `action` | string | Yes | `"enable"` or `"disable"` |

**Response (200):**
```json
{
  "success": true,
  "enabled": true,
  "createdAt": "2024-06-01T00:00:00Z",
  "feedId": "course:ai-tools-overview",
  "message": "Discussion feed enabled"
}
```

**Notes:**
- On first enable: creates Stream feed with system activity
- Disable: sets flag to 0 but preserves Stream data
- `createdAt` and `feedId` only included when enabling

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not the course creator |

---

## Resource Endpoints

### GET /api/resources/[id]/download

Download a resource file from R2 storage. Streams the file directly.

**Path Parameter:** `id` - Resource ID

**Response (200):**
- Content-Type: Based on file mime type
- Content-Disposition: `attachment; filename="..."`
- Body: File stream

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Resource is not downloadable (external link only) |
| 401 | Authentication required (for non-public resources) |
| 403 | Not enrolled in course |
| 404 | Resource not found / File not found in storage |
