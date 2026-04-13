# API Reference: Users, Creators & Members

User, creator, and member directory endpoints. Part of [API Reference](API-REFERENCE.md).

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
      "id": "usr-guy_rymberg",
      "handle": "guy_rymberg",
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
  "id": "usr-guy_rymberg",
  "handle": "guy_rymberg",
  "name": "Guy Rymberg",
  "title": "AI & Automation Expert",
  "avatar_url": null,
  "bio_full": "...",
  "bio_short": "...",
  "teaching_philosophy": "...",
  "website": "...",
  "is_creator": true,
  "is_teacher": false,
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

## Member Directory Endpoint

### GET /api/members

Unified member directory with server-side search, multi-role filtering, and optional admin extras. Added Conv 111, replacing separate creator/teacher/student browse pages.

**Authentication:** Optional (admin/mod callers get extra fields)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `search` | string | - | Search name and handle (+ email for admin/mod) |
| `roles` | string | - | Comma-separated role filter: `creator`, `teacher`, `student`, `moderator`, `admin`. OR logic (shows members matching any). |
| `sort` | string | `name` | Sort by `name`, `newest`, `activity`, `rating`, `students` |
| `page` | number | 1 | Page number |
| `limit` | number | 20 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "usr-alice-1",
      "handle": "alice",
      "name": "Alice Johnson",
      "avatar_url": null,
      "bio_short": "Learning enthusiast",
      "title": "Developer",
      "is_admin": false,
      "is_moderator": false,
      "is_teacher": true,
      "can_create_courses": true,
      "hasEnrollment": true,
      "hasActiveCourses": true,
      "studentsCount": 12,
      "averageRating": 4.8,
      "coursesCreated": 2,
      "expertise": ["React", "TypeScript"],
      "adminExtras": null
    }
  ],
  "total": 45,
  "page": 1,
  "limit": 20,
  "totalPages": 3,
  "hasMore": true
}
```

**Admin/Mod extras:** When the caller has admin or moderator role, each item includes:
```json
{
  "adminExtras": {
    "email": "alice@example.com",
    "status": "active",
    "updated_at": "2026-04-10T14:00:00.000Z"
  }
}
```

**Privacy:** Members with `privacy_public = 0` are excluded for non-admin/non-mod callers.

**Role derivation:** "Student" = has ≥1 enrollment (not capability-based). "Monitoring" = no roles (derived client-side, not in API response).

**Used by:** `/discover/members` page (`MemberDirectory` component)

---

## User Endpoints

### GET /api/users

List users with optional role filtering, search, and pagination.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `role` | string | - | Filter by role ("admin", "creator", "teacher", "student", "moderator") |
| `search` | string | - | Search in name, handle, email |
| `page` | number | 1 | Page number |
| `limit` | number | 20 | Items per page (max 50) |

**Response (200):**
```json
{
  "items": [
    {
      "id": "usr-guy_rymberg",
      "email": "guy_rymberg@example.com",
      "name": "Guy Rymberg",
      "handle": "guy_rymberg",
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
      "is_teacher": false,
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
    "id": "usr-guy_rymberg",
    "email": "guy_rymberg@example.com",
    "name": "Guy Rymberg",
    "handle": "guy_rymberg",
    "title": "AI & Automation Expert",
    "avatar_url": null,
    "bio_full": "Full bio text...",
    "bio_short": "AI enthusiast...",
    "teaching_philosophy": "The AI landscape...",
    "website": "https://peerloop.com/creators/guy_rymberg",
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
    "is_teacher": false,
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

### POST /api/users/[handle]/follow

Follow a user. Requires authentication.

**Path Parameter:** `handle` - Target user's handle

**Response (201):**
```json
{
  "follow": {
    "id": "flw-abc123",
    "follower_id": "usr-current",
    "followed_id": "usr-target",
    "created_at": "2026-03-31T14:00:00.000Z"
  }
}
```

**Response (200):** Already following — returns `{ "message": "Already following this user" }`

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Handle is required |
| 400 | Cannot follow yourself |
| 401 | Authentication required |
| 404 | User not found |

---

### DELETE /api/users/[handle]/follow

Unfollow a user. Idempotent — no error if not following. Requires authentication.

**Path Parameter:** `handle` - Target user's handle

**Response (200):**
```json
{
  "message": "Unfollowed successfully"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Handle is required |
| 401 | Authentication required |
| 404 | User not found |

---

## Current User Full State Endpoint

### GET /api/me/full

Get comprehensive user state for CurrentUser initialization. Returns all data needed to populate the client-side `CurrentUser` global.

**Authentication:** Required

**Response (200):**
```json
{
  "user": {
    "id": "usr-guy_rymberg",
    "email": "guy@example.com",
    "name": "Guy Rymberg",
    "handle": "guy_rymberg",
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
    "isAdmin": false,
    "onboardingCompletedAt": "2024-12-01T00:00:00Z",
    "stripeAccountId": "acct_1234567890",
    "stripeStatus": "active",
    "stripePayoutsEnabled": true
  },
  "enrollments": [...],
  "teacherCertifications": [
    {
      "courseId": "crs-ai-tools-overview",
      "courseTitle": "AI Tools Overview",
      "courseSlug": "ai-tools-overview",
      "courseRating": 4.8,
      "courseRatingCount": 12,
      "teacherCount": 3,
      "nextSessionAt": "2026-04-01T14:00:00.000Z",
      "activeStudents": 5,
      "isActive": true,
      "teachingActive": true
    }
  ],
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
  "communityMemberships": [
    { "communityId": "comm-the-commons", "communitySlug": "the-commons", "communityName": "The Commons", "communityIcon": "🌐", "memberRole": "member", "isSystem": true }
  ],
  "communityModerations": [],
  "communityModeratedCourseIds": [],
  "interestTopicIds": ["topic-ai-ml", "topic-automation", "topic-data-science"],
  "unreadNotificationCount": 3,
  "unreadMessageCount": 1,
  "dataVersion": 47,
  "loadedAt": "2024-12-01T00:00:00Z"
}
```

**Notes:**
- Used by `initializeCurrentUser()` on app load
- Cached in localStorage for stale-while-revalidate pattern
- **This endpoint is the server source of truth for user state.** The client-side `CurrentUser` is a read-only cache of this data — see `docs/as-designed/state-management.md`
- `unreadNotificationCount` and `unreadMessageCount` are included to eliminate separate badge-count API calls (added Session 385)
- `dataVersion` is the user's monotonic version counter for client-side polling (added Conv 013, CURRENTUSER-OPTIMIZE)
- Enrollments include enrichment fields: `hasReview`, `courseDuration`, `courseSessionCount` (Conv 014, Phase 2)
- All course relationship types include `discussionFeedEnabled` (Conv 014, Phase 4)
- Teacher certifications include course-level stats: `courseRating`, `courseRatingCount`, `teacherCount`, `nextSessionAt` (Conv 041, EXPLORE-COURSES)
- `communityMemberships` lists all communities the user belongs to, including `isSystem` flag for The Commons (Conv 014, Phase 4)
- `interestTopicIds` derived from user_tags → tags → topics (DISTINCT topic_id). Used by "My Interests" course filter for synchronous multi-topic matching (Conv 054, TAG-TAXONOMY)
- See `src/lib/current-user.ts` for client-side usage

### GET /api/me/version

Ultra-lightweight endpoint for version polling. Returns the user's `data_version` counter. Client polls every 30 seconds; triggers `refreshCurrentUser()` when server version exceeds locally cached version.

**Authentication:** Required

**Response (200):**
```json
{ "version": 47 }
```

**Notes:**
- Single `SELECT data_version FROM users WHERE id = ?` — ~1ms on D1, ~20 byte response
- Used by `startVersionPolling()` in `src/lib/current-user.ts`
- Mutation endpoints call `bumpUserDataVersion()` to increment the counter
- See `docs/as-designed/state-management.md` (Version Polling section)
- Added Conv 013 (CURRENTUSER-OPTIMIZE Phase 1)

---

## Current User Profile Endpoints

### GET /api/me/profile

Get current user's profile for editing. Includes profile info, privacy settings, and email notification preferences.

**Response (200):**
```json
{
  "name": "Guy Rymberg",
  "handle": "guy_rymberg",
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
- `teaching_philosophy` is typically used by Teachers and Creators
- Email preferences can also be managed via `/api/me/settings`

---

### PATCH /api/me/profile

Update current user's profile (partial updates). Supports all profile fields plus email notification preferences.

**Request Body:**
```json
{
  "name": "New Name",
  "handle": "newhandle",
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
| `handle` | 3-20 chars, must start with a letter, letters/numbers/underscores only, unique. Single source of truth: `validateHandle()` in `src/lib/auth/index.ts` |
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
  "updated": { "name": "New Name", "handle": "newhandle" }
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

## Notification Endpoints

### DELETE /api/me/notifications/[id]

Delete a single notification for the current user.

**Path Parameter:** `id` - Notification ID

**Authentication:** Required

**Response (200):**
```json
{
  "success": true
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 404 | Notification not found or not owned by user |

---

### PATCH /api/me/notifications/read-all

Mark all notifications as read. Bumps user data version.

**Authentication:** Required

**Response (200):**
```json
{
  "success": true,
  "marked_count": 5
}
```

**Notes:**
- Bumps `data_version` so client-side polling detects the change
- Only marks unread notifications; `marked_count` reflects how many were updated

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
  "is_teacher": false,
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
- Intro sessions (as teacher)
- Homework submissions
- Certificates
- Enrollments
- Teacher certification records
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

Get the authenticated user's onboarding profile and tag selections.

**Authentication:** Required

**Response (200) — New user (no onboarding data):**
```json
{
  "profile": null,
  "tags": []
}
```

**Response (200) — After onboarding:**
```json
{
  "profile": {
    "goalLearn": true,
    "goalTeach": false,
    "referralSource": "friend",
    "profession": "Software Engineer",
    "onboardingCompletedAt": "2026-02-22T16:00:00.000Z"
  },
  "tags": [
    {
      "tagId": "tag-001",
      "tagName": "AI Strategy",
      "topicId": "top-001",
      "topicName": "AI & Product Management",
      "level": "beginner"
    }
  ]
}
```

**Notes:**
- Tags are read from `user_tags` joined with `tags` and `topics`
- Ordered by topic `display_order`, then tag `display_order`
- `level` is the user's self-assessed proficiency (`beginner`, `intermediate`, or `advanced`)

---

### POST /api/me/onboarding-profile

Save or update the authenticated user's onboarding profile. Idempotent — upserts profile, replaces tag selections in `user_tags`.

**Authentication:** Required

**Request Body (new format):**
```json
{
  "goalLearn": true,
  "goalTeach": false,
  "referralSource": "friend",
  "profession": "Software Engineer",
  "tags": [
    { "tagId": "tag-001", "level": "beginner" },
    { "tagId": "tag-005", "level": "intermediate" }
  ]
}
```

**Request Body (legacy format — still accepted):**
```json
{
  "goalLearn": true,
  "goalTeach": false,
  "referralSource": "friend",
  "profession": "Software Engineer",
  "tagIds": ["tag-001", "tag-005", "tag-012"]
}
```

When using legacy `tagIds` format, all tags default to `level: 'beginner'`.

**Validation:**

| Field | Rules |
|-------|-------|
| `goalLearn` | Boolean — user wants to learn |
| `goalTeach` | Boolean — user wants to teach |
| `referralSource` | `search`, `social_media`, `friend`, `ad`, or `other` |
| `profession` | String, max 100 characters |
| `tags` | Array of `{ tagId, level }` objects; each tagId must exist and be active; level must be `beginner`, `intermediate`, or `advanced` |
| `tagIds` | (Legacy) Array of tag IDs; each must exist and be active in `tags` table |

**Response (200):**
```json
{ "success": true }
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Validation error (invalid source, tag IDs, or profession length) |
| 401 | Authentication required |

**Side effects:**
- Sets `onboarding_completed_at` on `member_profiles`
- Deletes and re-inserts `user_tags` rows for the user
- `CurrentUser.onboardingCompletedAt` updates on next refresh
