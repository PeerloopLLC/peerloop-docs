# API Reference: Platform

Platform stats, categories, testimonials, stories, marketing, and health check endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Platform Endpoints

### GET /api/stats

Get platform statistics for homepage display.

**Response (200):**
```json
{
  "stats": [
    {
      "id": "stat-001",
      "key": "students_count",
      "value": "150+",
      "label": "Students learning this month",
      "display_order": 1,
      "updated_at": "2024-12-01T00:00:00Z"
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 503 | Database not available |
| 500 | Failed to fetch platform stats |

---

### GET /api/categories

Get all course categories.

**Response (200):**
```json
{
  "categories": [
    {
      "id": "cat-001",
      "name": "AI & Automation",
      "slug": "ai-automation",
      "description": "Learn to leverage AI tools and build automations",
      "icon": "🤖",
      "display_order": 1
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 503 | Database not available |
| 500 | Failed to fetch categories |

---

### GET /api/topics

Get all active topics grouped by parent category. Used for onboarding interest picker and future course filtering.

**Authentication:** Not required (public)

**Response (200):**
```json
{
  "categories": [
    {
      "id": "cat-001",
      "name": "AI & Product Management",
      "slug": "ai-product-management",
      "icon": "🎯",
      "topics": [
        { "id": "top-001", "name": "AI Strategy", "slug": "ai-strategy" },
        { "id": "top-002", "name": "Product Roadmaps", "slug": "product-roadmaps" }
      ]
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 503 | Database not available |
| 500 | Failed to fetch topics |

**Notes:**
- Topics are curated subtopics (~3-5 per category, ~55 total)
- Only returns topics where both topic and parent category have `is_active = 1`
- Ordered by category `display_order`, then topic `display_order`

---

### GET /api/testimonials

Get testimonials. Default mode returns featured testimonials for homepage. With `featured=false`, returns all testimonials with filtering and pagination.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `featured` | string | "true" | "true" for featured only, "false" for browse mode |
| `category` | string | - | Filter by category ID (browse mode only) |
| `course` | string | - | Filter by course ID (browse mode only) |
| `page` | number | 1 | Page number (browse mode only) |
| `limit` | number | 3/12 | Number of testimonials (max 10 for featured, 50 for browse) |

**Response (200) - Featured Mode (default):**
```json
{
  "testimonials": [
    {
      "quote": "I was drowning in AI tool announcements...",
      "name": "Sarah M.",
      "role": "Marketing Manager",
      "course": "AI Tools Overview",
      "avatar": null
    }
  ]
}
```

**Response (200) - Browse Mode (`?featured=false`):**
```json
{
  "items": [
    {
      "id": "tst-001",
      "quote": "The personalized tutoring made all the difference...",
      "studentName": "Maria Santos",
      "studentRole": "Junior Developer",
      "isFeatured": true,
      "createdAt": "2025-12-01T00:00:00.000Z",
      "course": {
        "id": "crs-ai-tools-overview",
        "title": "AI Tools Overview",
        "slug": "ai-tools-overview"
      },
      "category": {
        "id": "cat-001",
        "name": "AI & Automation"
      }
    }
  ],
  "total": 15,
  "page": 1,
  "limit": 12,
  "totalPages": 2,
  "hasMore": true
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 503 | Database not available |
| 500 | Failed to fetch testimonials |

---

## Leaderboard Endpoints

### GET /api/leaderboard

Get community leaderboard rankings. Categories are based on user_stats (students_taught, courses_completed, average_rating). Future: Add goodwill_points when CD-023 is implemented.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `category` | string | "teachers" | "teachers", "learners", or "rated" |
| `limit` | number | 50 | Number of users to return (max 100) |

**Response (200):**
```json
{
  "category": "teachers",
  "rankings": [
    {
      "rank": 1,
      "user_id": "usr-001",
      "name": "Sarah Chen",
      "handle": "sarahchen",
      "avatar_url": "https://...",
      "score": 45,
      "is_teacher": true,
      "is_creator": true
    }
  ],
  "user_rank": {
    "rank": 12,
    "score": 15,
    "total_users": 50,
    "percentile": 76
  }
}
```

**Categories:**

| Category | Metric | Filter |
|----------|--------|--------|
| `teachers` | students_taught | Teachers only |
| `learners` | courses_completed | All users |
| `rated` | average_rating | Min 3 reviews |

**Notes:**
- `user_rank` is only included if the user is authenticated and has a non-zero score
- Only users with `privacy_public = 1` appear in rankings
- Score is integer for teachers/learners, decimal (rounded to 1 place) for rated

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Invalid category |
| 503 | Database not available |
| 500 | Failed to fetch leaderboard |

---

## Marketing Endpoints

### GET /api/team

Get active team members for the About page.

**Response (200):**
```json
{
  "team": [
    {
      "id": "tm-001",
      "name": "Sarah Chen",
      "role": "Founder & CEO",
      "bio": "Former education tech lead at Khan Academy...",
      "avatar_url": "https://images.unsplash.com/...",
      "linkedin_url": "https://linkedin.com/in/sarahchen",
      "display_order": 1,
      "is_active": 1,
      "created_at": "2026-01-08 01:57:51"
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 503 | Database not available |
| 500 | Failed to fetch team members |

### GET /api/faq

Get FAQ entries with optional category filtering.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `category` | string | - | Filter by category: general, students, teachers, creators, payments, technical |

**Response (200):**
```json
{
  "faq": [
    {
      "id": "faq-gen-001",
      "question": "What is Peerloop?",
      "answer": "Peerloop is a peer-to-peer learning platform...",
      "category": "general",
      "display_order": 1,
      "is_published": 1,
      "created_at": "2026-01-08 01:57:51",
      "updated_at": "2026-01-08 01:57:51"
    }
  ],
  "grouped": {
    "general": [...],
    "students": [...],
    "teachers": [...],
    "creators": [...],
    "payments": [...],
    "technical": [...]
  },
  "categories": ["general", "students", "teachers", "creators", "payments", "technical"]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Invalid category (if category param is invalid) |
| 503 | Database not available |
| 500 | Failed to fetch FAQ entries |

### POST /api/contact

Submit a contact form message.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "category": "general",
  "subject": "Question about courses",
  "message": "I'd like to know more about..."
}
```

**Validation:**

| Field | Requirements |
|-------|--------------|
| name | Required, min 2 characters |
| email | Required, valid email format |
| category | Required, one of: general, support, billing, partnership, press, creator, other |
| subject | Required, min 5 characters |
| message | Required, min 20 characters |

**Response (200):**
```json
{
  "success": true,
  "message": "Your message has been received. We will get back to you within 24 hours.",
  "id": "cont-1767837917474-e38dipe"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Validation failed (with errors array) |
| 503 | Database not available |
| 500 | Failed to submit contact form |

---

## Stories Endpoints

### GET /api/stories

List success stories with optional type filtering and pagination.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `type` | string | - | Filter by story type ("student", "teacher", "creator") |
| `featured` | string | - | "true" to show featured stories only |
| `page` | number | 1 | Page number |
| `limit` | number | 12 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "story-001",
      "type": "student",
      "name": "Maria Santos",
      "location": "Manila, Philippines",
      "photoUrl": "/images/stories/maria.jpg",
      "headline": "From unemployed to software developer in 6 months",
      "shortQuote": "The personalized tutoring made all the difference...",
      "fullStory": "I was laid off during the pandemic...",
      "stats": {
        "before": "Unemployed, no tech experience",
        "after": "Junior Developer at $45K/year"
      },
      "courseId": null,
      "videoUrl": null,
      "isFeatured": true,
      "publishedAt": "2025-11-29T00:00:00.000Z"
    }
  ],
  "total": 5,
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
| 500 | Failed to fetch stories |

---

### GET /api/stories/[id]

Get a single success story by ID.

**Response (200):**
```json
{
  "story": {
    "id": "story-001",
    "type": "student",
    "name": "Maria Santos",
    "location": "Manila, Philippines",
    "photoUrl": "/images/stories/maria.jpg",
    "headline": "From unemployed to software developer in 6 months",
    "shortQuote": "The personalized tutoring made all the difference...",
    "fullStory": "I was laid off during the pandemic...",
    "stats": {
      "before": "Unemployed, no tech experience",
      "after": "Junior Developer at $45K/year"
    },
    "courseId": null,
    "videoUrl": null,
    "isFeatured": true,
    "publishedAt": "2025-11-29T00:00:00.000Z"
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Story ID is required |
| 404 | Story not found |
| 503 | Database not available |
| 500 | Failed to fetch story |

---

## Certificate Verification

### GET /api/certificates/[id]/verify

Verify a certificate's validity. **Public endpoint — no authentication required.**

Returns whether the certificate is valid (issued and not revoked) along with public certificate data. Excludes sensitive information (user email, internal IDs).

**Response (200):**
```json
{
  "valid": true,
  "certificate": {
    "id": "cert_1234567890_abc1234",
    "recipient_name": "Maria Santos",
    "recipient_handle": "maria",
    "recipient_avatar_url": "/images/avatars/maria.jpg",
    "course_title": "Introduction to Python",
    "course_slug": "intro-python",
    "creator_name": "John Smith",
    "creator_handle": "jsmith",
    "type": "completion",
    "status": "issued",
    "issued_at": "2025-12-15T10:30:00.000Z",
    "issuer_name": "Admin User",
    "revoked_at": null,
    "revoked_reason": null
  }
}
```

A revoked certificate returns `"valid": false` with `revoked_at` and `revoked_reason` populated.

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Certificate ID required |
| 404 | Certificate not found (`valid: false`) |
| 503 | Database not available |
| 500 | Failed to verify certificate |

---

## Health Endpoints

### GET /api/health/db

Check D1 database connectivity.

**Response (200) - Connected:**
```json
{
  "status": "ok",
  "timestamp": "2025-12-29T17:30:00.000Z",
  "latency_ms": 12,
  "tables": 25
}
```

**Response (503) - Not Connected:**
```json
{
  "status": "error",
  "timestamp": "2025-12-29T17:30:00.000Z",
  "error": "D1 database binding not available"
}
```

**Use Cases:**
- Startup verification before testing
- CI/CD health checks
- Debugging connectivity issues

---

### GET /api/health/r2

Check R2 storage connectivity by performing write/read/delete test.

**Response (200) - Connected:**
```json
{
  "status": "ok",
  "message": "R2 bucket is working",
  "bucket": "peerloop-storage",
  "binding": "STORAGE",
  "tests": {
    "write": "pass",
    "read": "pass",
    "delete": "pass"
  },
  "duration_ms": 33
}
```

**Response (503) - Not Connected:**
```json
{
  "status": "error",
  "message": "R2 STORAGE binding not available",
  "binding": "STORAGE"
}
```

**Use Cases:**
- Verify R2 bucket creation and binding
- Debug file storage issues
- CI/CD health checks

---

### GET /api/health/kv

Check KV namespace connectivity by performing write/read/delete test.

**Auth:** None required

**Response (200):**
```json
{
  "status": "ok",
  "message": "KV namespace is working",
  "binding": "SESSION",
  "tests": {
    "write": "pass",
    "read": "pass",
    "delete": "pass"
  },
  "duration_ms": 20
}
```

**Response (503):**
```json
{
  "status": "error",
  "message": "KV SESSION binding not available",
  "binding": "SESSION"
}
```

**Use Cases:**
- Verify KV namespace provisioning and binding
- Debug session storage issues
- CI/CD health checks

---

## Debug Endpoints

Development-only endpoints for debugging database connectivity. These should be removed or protected before production launch.

### GET /api/db-test

Return database connection status and sample data from core tables.

**Authentication:** None (development only)

**Response (200):**
```json
{
  "status": "connected",
  "database": "peerloop-db",
  "data": {
    "categories": { "count": 5, "sample": [...] },
    "users": { "count": 5, "sample": [...] },
    "features": { "count": 3, "sample": [...] }
  }
}
```

**Use Cases:**
- Verify D1 database binding is working
- Quick check of table data during development

---

### GET /api/debug/db-env

Identify which D1 database environment (staging vs production) the deployment is connected to.

**Authentication:** None (development only — TODO: remove or protect before launch)

**Response (200):**
```json
{
  "success": true,
  "environment": "staging",
  "userCount": 142,
  "timestamp": "2026-03-12T12:00:00Z",
  "hint": "✅ Connected to STAGING database (peerloop-db-staging)"
}
```

**Use Cases:**
- Verify correct database binding after deployment
- Confirm staging vs production environment during debugging
