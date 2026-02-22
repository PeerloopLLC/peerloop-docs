# API Reference: Users & Creators

User and creator profile endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Creator Endpoints

### GET /api/creators

List creators with optional filtering and search.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `search` | string | - | Search in name and expertise |
| `expertise` | string | - | Filter by expertise tag |
| `sort` | string | "students" | Sort by "students", "rating", "courses", "name" |
| `page` | number | 1 | Page number |
| `limit` | number | 12 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "usr-guy-rymberg",
      "handle": "guy-rymberg",
      "name": "Guy Rymberg",
      "title": "AI & Automation Expert",
      "avatar_url": null,
      "bio_short": "AI enthusiast helping people navigate...",
      "stats": {
        "courses_created": 4,
        "students_taught": 156,
        "average_rating": 4.9
      },
      "expertise": ["AI Tools", "Automation", "n8n", "Claude Code"]
    }
  ],
  "total": 2,
  "page": 1,
  "limit": 12,
  "totalPages": 1,
  "hasMore": false
}
```

---

### GET /api/creators/[handle]

Get full creator profile by handle.

**Response (200):**
```json
{
  "id": "usr-guy-rymberg",
  "handle": "guy-rymberg",
  "name": "Guy Rymberg",
  "title": "AI & Automation Expert",
  "avatar_url": null,
  "bio_full": "...",
  "bio_short": "...",
  "teaching_philosophy": "...",
  "website": "...",
  "is_creator": true,
  "is_student_teacher": false,
  "privacy_public": true,
  "stats": {
    "courses_created": 4,
    "students_taught": 156,
    "average_rating": 4.9,
    "total_reviews": 89
  },
  "expertise": [...],
  "qualifications": [...],
  "courses": [...]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Handle is required |
| 404 | Creator not found |

---

### GET /api/creators/[id]/courses

Get all courses by a creator.

**Path Parameter:** `id` - Creator ID or handle

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
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
      "...": "...",
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

### GET /api/creators/apply

Check current user's creator application status. Requires authentication.

**Response (200):**
```json
{
  "isCreator": false,
  "application": {
    "id": "uuid",
    "expertise_areas": "Web Development, Machine Learning",
    "status": "pending",
    "submitted_at": "2026-02-21T12:00:00.000Z",
    "denial_reason": null
  }
}
```

Returns `application: null` if no applications exist.

### POST /api/creators/apply

Submit a creator application. Requires authentication.

**Request Body:**
```json
{
  "expertise_areas": "Web Development, Machine Learning",
  "teaching_experience": "5 years tutoring CS students...",
  "course_ideas": "Intro to React, Advanced TypeScript...",
  "portfolio_url": "https://example.com",
  "motivation": "I want to help others learn..."
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `expertise_areas` | string | Yes | Comma-separated subject tags |
| `teaching_experience` | string | Yes | Description of teaching background |
| `course_ideas` | string | Yes | Course ideas for Peerloop |
| `portfolio_url` | string | No | Link to portfolio/website (valid URL) |
| `motivation` | string | Yes | Why they want to create on Peerloop |

**Response (201):**
```json
{
  "application": { "id": "uuid", "status": "pending", "submitted_at": "..." },
  "message": "Application submitted successfully"
}
```

**Errors:**
- `400` — Already a creator, or missing required fields, or invalid URL
- `409` — Already has a pending application

---

## User Endpoints

### GET /api/users

List users with optional role filtering, search, and pagination.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `role` | string | - | Filter by role ("admin", "creator", "student_teacher", "student", "moderator") |
| `search` | string | - | Search in name, handle, email |
| `page` | number | 1 | Page number |
| `limit` | number | 20 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "usr-guy-rymberg",
      "email": "guy-rymberg@example.com",
      "name": "Guy Rymberg",
      "handle": "guy-rymberg",
      "title": "AI & Automation Expert",
      "avatar_url": null,
      "bio_short": "AI enthusiast...",
      "capabilities": {
        "can_take_courses": true,
        "can_teach_courses": false,
        "can_create_courses": true,
        "can_moderate_courses": false,
        "is_admin": false
      },
      "is_creator": true,
      "is_student_teacher": false,
      "privacy_public": true,
      "email_verified": true,
      "stats": {
        "students_taught": 156,
        "courses_created": 4,
        "courses_completed": 0,
        "average_rating": 4.9
      },
      "created_at": "2024-01-01T00:00:00Z"
    }
  ],
  "total": 9,
  "page": 1,
  "limit": 20,
  "totalPages": 1,
  "hasMore": false
}
```

### GET /api/users/[handle]

Get user by handle with full profile details.

**Response (200):**
```json
{
  "user": {
    "id": "usr-guy-rymberg",
    "email": "guy-rymberg@example.com",
    "name": "Guy Rymberg",
    "handle": "guy-rymberg",
    "title": "AI & Automation Expert",
    "avatar_url": null,
    "bio_full": "Full bio text...",
    "bio_short": "AI enthusiast...",
    "teaching_philosophy": "The AI landscape...",
    "website": "https://peerloop.com/creators/guy-rymberg",
    "location": "Tel Aviv, Israel",
    "linkedin_url": "https://linkedin.com/in/guyrymberg",
    "twitter_url": "https://twitter.com/guyrymberg",
    "youtube_url": null,
    "capabilities": {
      "can_take_courses": true,
      "can_teach_courses": false,
      "can_create_courses": true,
      "can_moderate_courses": false,
      "is_admin": false
    },
    "is_creator": true,
    "is_student_teacher": false,
    "privacy_public": true,
    "email_verified": true,
    "stats": {
      "students_taught": 156,
      "courses_created": 4,
      "courses_completed": 0,
      "average_rating": 4.9,
      "total_reviews": 89
    },
    "expertise": ["AI Tools", "Automation", "n8n"],
    "qualifications": [
      { "id": "...", "sentence": "Heavy daily user of Claude Code", "display_order": 1 }
    ],
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-12-01T00:00:00Z"
  }
}
```

---

### GET /api/users/check-handle

Check if a handle is available (for on-blur validation during profile editing).

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `handle` | string | Yes | Handle to check availability |

**Response (200):**
```json
{
  "available": true
}
```

**Notes:**
- Requires authentication
- Excludes current user's handle from uniqueness check
- Case-insensitive comparison

---

### GET /api/users/search

Search users for messaging (new conversation).

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `q` | string | - | Search query (min 2 chars, searches name and handle) |
| `limit` | number | 10 | Max results (max 20) |

**Response (200):**
```json
{
  "users": [
    {
      "id": "usr-alice-1",
      "name": "Alice Johnson",
      "handle": "alicej",
      "avatar_url": "https://example.com/alice.jpg",
      "title": "Developer"
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Search query must be at least 2 characters |
| 401 | Unauthorized |

**Notes:**
- Requires authentication
- Excludes current user from results
- Excludes deleted/suspended users
- Results ranked by handle prefix match, then alphabetical

---

## Current User Full State Endpoint

### GET /api/me/full

Get comprehensive user state for CurrentUser initialization. Returns all data needed to populate the client-side `CurrentUser` global.

**Authentication:** Required

**Response (200):**
```json
{
  "user": {
    "id": "usr-guy-rymberg",
    "email": "guy@example.com",
    "name": "Guy Rymberg",
    "handle": "guy-rymberg",
    "title": "AI & Automation Expert",
    "avatarUrl": null,
    "bioShort": "AI enthusiast...",
    "bioFull": "Full bio text...",
    "teachingPhilosophy": "The AI landscape...",
    "website": "https://example.com",
    "location": "Tel Aviv, Israel",
    "linkedinUrl": "https://linkedin.com/in/guyrymberg",
    "twitterUrl": "https://twitter.com/guyrymberg",
    "youtubeUrl": null,
    "emailVerified": true,
    "privacyPublic": true,
    "canCreateCourses": true,
    "canTakeCourses": true,
    "canTeachCourses": true,
    "canModerateCourses": false,
    "isAdmin": false
  },
  "enrollments": [...],
  "stCertifications": [...],
  "createdCourses": [...],
  "stats": {
    "studentsTaught": 156,
    "coursesCreated": 4,
    "coursesCompleted": 2,
    "averageRating": 4.9,
    "totalReviews": 89
  },
  "expertise": ["AI Tools", "Automation", "n8n"],
  "qualifications": [
    { "id": "...", "sentence": "Certified AI instructor", "displayOrder": 1 }
  ],
  "loadedAt": "2024-12-01T00:00:00Z"
}
```

**Notes:**
- Used by `initializeCurrentUser()` on app load
- Cached in localStorage for stale-while-revalidate pattern
- See `src/lib/current-user.ts` for client-side usage

---

## Current User Profile Endpoints

### GET /api/me/profile

Get current user's profile for editing. Includes profile info, privacy settings, and email notification preferences.

**Response (200):**
```json
{
  "name": "Guy Rymberg",
  "handle": "guy-rymberg",
  "email": "guy@example.com",
  "title": "AI & Automation Expert",
  "bio_short": "Short tagline for cards",
  "bio_full": "Full bio text...",
  "teaching_philosophy": "My approach to teaching...",
  "avatar_url": null,
  "website": "https://example.com",
  "location": "New York, NY",
  "linkedin_url": "https://linkedin.com/in/example",
  "twitter_url": "https://twitter.com/example",
  "youtube_url": "https://youtube.com/@example",
  "privacy_public": true,
  "marketing_opt_out": false,
  "email_session_reminder": true,
  "email_session_booked": true,
  "email_new_message": true,
  "email_course_update": true,
  "email_certificate": true,
  "email_payment": true,
  "email_marketing": false,
  "canTeachCourses": false,
  "canCreateCourses": true,
  "isAdmin": false
}
```

**Notes:**
- `email` is read-only (displayed but not editable via this endpoint)
- `avatar_url` is read-only here; use `/api/me/avatar` for upload
- `teaching_philosophy` is typically used by S-Ts and Creators
- Email preferences can also be managed via `/api/me/settings`

---

### PATCH /api/me/profile

Update current user's profile (partial updates). Supports all profile fields plus email notification preferences.

**Request Body:**
```json
{
  "name": "New Name",
  "handle": "new-handle",
  "title": "New Title",
  "bio_short": "Short tagline",
  "bio_full": "New bio text",
  "teaching_philosophy": "My teaching approach...",
  "website": "https://newsite.com",
  "location": "San Francisco, CA",
  "linkedin_url": "https://linkedin.com/in/newprofile",
  "twitter_url": null,
  "youtube_url": null,
  "privacy_public": false,
  "marketing_opt_out": true,
  "email_session_reminder": true,
  "email_session_booked": true,
  "email_new_message": false,
  "email_course_update": true,
  "email_certificate": true,
  "email_payment": true,
  "email_marketing": false
}
```

**Field Validation:**

| Field | Rules |
|-------|-------|
| `name` | Required, max 100 chars |
| `handle` | 3-30 chars, alphanumeric + underscore + hyphen, unique |
| `title` | Max 100 chars |
| `bio_short` | Max 150 chars |
| `bio_full` | Max 2000 chars |
| `teaching_philosophy` | Max 2000 chars |
| `website`, `*_url` | Must be valid URL with http/https protocol |
| `location` | Max 100 chars |
| `privacy_public` | Boolean |
| `marketing_opt_out` | Boolean |
| `email_*` | Boolean (7 notification preference fields) |

**Response (200):**
```json
{
  "success": true,
  "message": "Profile updated",
  "updated": { "name": "New Name", "handle": "new-handle" }
}
```

**Error Response (400):**
```json
{
  "error": "Validation failed",
  "fieldErrors": [
    { "field": "handle", "message": "This handle is already taken" },
    { "field": "twitter_url", "message": "Must be a valid URL (include https://)" }
  ]
}
```

---

## Current User Settings Endpoints

### GET /api/me/settings

Get current user's notification preferences.

**Response (200):**
```json
{
  "email_session_reminder": true,
  "email_session_booked": true,
  "email_new_message": true,
  "email_course_update": true,
  "email_certificate": true,
  "email_payment": true,
  "email_marketing": false,
  "is_student_teacher": false,
  "is_creator": true
}
```

---

### PATCH /api/me/settings

Update notification preferences (partial updates).

**Request Body:**
```json
{
  "email_session_reminder": false,
  "email_marketing": true
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Settings updated",
  "updated": {
    "email_session_reminder": false,
    "email_marketing": true
  }
}
```

**Notes:**
- All fields are optional - send only what you want to change
- Boolean values only

---

## Account Management Endpoints

### DELETE /api/me/account

Permanently delete the authenticated user's account and all associated data.

**Authentication:** Required

**Cascade Deletion:**
- Notifications
- Intro sessions (as student-teacher)
- Homework submissions
- Certificates
- Enrollments
- Student-teacher records
- Courses (if creator)

**Response (200):**
```json
{
  "message": "Account deleted successfully",
  "deleted": true
}
```

**Response (401):**
```json
{
  "error": "Authentication required"
}
```

**Notes:**
- This action is irreversible
- Auth cookies are cleared after deletion
- Sessions with ON DELETE RESTRICT prevent deletion if user has active sessions

---

## Onboarding Profile Endpoints

### GET /api/me/onboarding-profile

Get the authenticated user's onboarding profile and topic interests.

**Authentication:** Required

**Response (200) — New user (no onboarding data):**
```json
{
  "profile": null,
  "topicInterests": []
}
```

**Response (200) — After onboarding:**
```json
{
  "profile": {
    "primaryGoal": "learn",
    "referralSource": "friend",
    "profession": "Software Engineer",
    "onboardingCompletedAt": "2026-02-22T16:00:00.000Z"
  },
  "topicInterests": [
    {
      "topicId": "top-001",
      "topicName": "AI Strategy",
      "categoryId": "cat-001",
      "categoryName": "AI & Product Management",
      "experienceLevel": "intermediate"
    }
  ]
}
```

---

### POST /api/me/onboarding-profile

Save or update the authenticated user's onboarding profile. Idempotent — upserts profile, replaces topic interests.

**Authentication:** Required

**Request Body:**
```json
{
  "primaryGoal": "learn",
  "referralSource": "friend",
  "profession": "Software Engineer",
  "topicInterests": [
    { "topicId": "top-001", "experienceLevel": "intermediate" },
    { "topicId": "top-005", "experienceLevel": "beginner" }
  ]
}
```

**Validation:**

| Field | Rules |
|-------|-------|
| `primaryGoal` | `learn`, `teach`, or `both` |
| `referralSource` | `search`, `social_media`, `friend`, `ad`, or `other` |
| `profession` | String, max 100 characters |
| `topicInterests[].topicId` | Must exist and be active in `topics` table |
| `topicInterests[].experienceLevel` | `beginner`, `intermediate`, or `advanced` |

**Response (200):**
```json
{ "success": true }
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Validation error (invalid goal, source, topic, level, or profession length) |
| 401 | Authentication required |

**Side effects:**
- Sets `onboarding_completed_at` on `member_profiles`
- Syncs selected topic names to `user_interests` for backward compatibility
- `CurrentUser.onboardingCompletedAt` updates on next refresh
