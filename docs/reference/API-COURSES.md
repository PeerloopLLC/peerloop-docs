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
  "student_teachers": [...]
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

Get completed sessions for the current enrolled student. Used for "Past Sessions" in the Resources tab.

**Path Parameter:** `id` - Course ID

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `status` | string | `completed` | Filter by session status |

**Response (200):**
```json
{
  "sessions": [
    {
      "id": "ses-001",
      "scheduled_start": "2026-03-10T14:00:00Z",
      "recording_url": "https://bbb.example.com/playback/...",
      "teacher_name": "Jane Smith",
      "duration_minutes": 55
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Not enrolled in this course |

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
