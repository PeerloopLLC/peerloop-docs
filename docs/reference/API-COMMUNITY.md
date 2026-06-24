# API Reference: Community

Community and Stream.io activity feed endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Communities

### GET /api/communities

List communities for the current user. Public access for discovery.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `filter` | string | `mine` | `mine` (joined), `all` (public), `discover` (public not joined) |
| `search` | string | - | Search in name and description |
| `limit` | number | 20 | Items per page (max 50) |
| `offset` | number | 0 | Pagination offset |

**Response (200):**
```json
{
  "items": [
    {
      "id": "comm-system",
      "slug": "system",
      "name": "System",
      "description": "General discussion for all members",
      "icon": "🌐",
      "coverImageUrl": null,
      "isPublic": true,
      "isSystem": true,
      "memberCount": 1234,
      "postCount": 567,
      "creator": null,
      "membership": {
        "role": "member",
        "joinedAt": "2024-01-01T00:00:00Z"
      }
    }
  ],
  "total": 4,
  "limit": 20,
  "offset": 0,
  "hasMore": false
}
```

**Notes:**
- `membership` is null if user not authenticated or not a member
- `creator` is null for system communities (the System feed)
- System communities (`isSystem: true`) always appear first
- `discover` filter excludes system communities (count and items both exclude `is_system=1`)

---

### GET /api/communities/[slug]

Get community detail with members and resources.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `include` | string | `members,resources` | Comma-separated: `members`, `resources` |
| `membersLimit` | number | 20 | Max members to return (max 100) |
| `resourcesLimit` | number | 10 | Max resources to return (max 50) |

**Response (200):**
```json
{
  "community": {
    "id": "comm-ai-tools",
    "slug": "ai-tools",
    "name": "AI Tools & Strategy",
    "description": "Navigate the AI tool landscape",
    "icon": "🤖",
    "coverImageUrl": null,
    "isPublic": true,
    "isSystem": false,
    "memberCount": 156,
    "postCount": 89,
    "createdAt": "2024-03-01T00:00:00Z",
    "creator": {
      "id": "usr-guy_rymberg",
      "name": "Guy Rymberg",
      "handle": "guy_rymberg",
      "avatarUrl": null
    }
  },
  "membership": {
    "role": "member",
    "joinedAt": "2024-04-15T00:00:00Z",
    "joinedVia": "enrollment"
  },
  "canManageModerators": false,
  "moderatorUserIds": ["usr-mod-1", "usr-mod-2"],
  "members": [
    {
      "id": "usr-guy_rymberg",
      "name": "Guy Rymberg",
      "handle": "guy_rymberg",
      "avatarUrl": null,
      "title": "AI & Automation Expert",
      "role": "creator",
      "joinedAt": "2024-03-01T00:00:00Z"
    }
  ],
  "resources": [
    {
      "id": "res-ai-landscape",
      "title": "AI Tools Landscape 2026",
      "description": "Curated map of AI tools",
      "type": "document",
      "downloadUrl": "/api/community-resources/res-ai-landscape/download",
      "r2Key": "communities/comm-ai-for-you/resources/res-ai-landscape/ai-tools-landscape-2026.pdf",
      "externalUrl": null,
      "sizeBytes": 1048576,
      "mimeType": "application/pdf",
      "downloadCount": 234,
      "isPinned": true,
      "createdAt": "2024-03-01T00:00:00Z",
      "uploadedBy": {
        "id": "usr-guy_rymberg",
        "name": "Guy Rymberg",
        "handle": "guy_rymberg",
        "role": "creator"
      }
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 404 | Community not found |
| 401 | Authentication required (private community) |
| 403 | Not a member of this community |

**Notes:**
- Members sorted by role: creator → member (COMMUNITY-TEACHER-KILL, Conv 120 — `'teacher'` retired from `community_members.member_role`)
- Resources sorted by: pinned first, then by date
- `membership` is null if not authenticated or not a member
- Member `role` values: `creator`, `member` (teaching status is derived server-side via `MeFullResponse.teachingCommunityIds` — see API-USERS.md `/api/me/full`)
- Resource `type` values: `document`, `image`, `audio`, `video_link`, `other` (aligned with `session_resources`)
- Resource storage is one of: R2-backed file (`r2Key` set, `downloadUrl` → `/api/community-resources/[id]/download`) or external link (`externalUrl` set, `downloadUrl` = `externalUrl` passthrough)
- `canManageModerators`: true if current user is the community creator or an admin
- `moderatorUserIds`: array of active community moderator user IDs (for UI badge display)

---

### GET /api/communities/[slug]/progressions

Get progressions with courses for a community. System communities (the System feed) return empty progressions array.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `includeArchived` | boolean | `false` | Include archived progressions |

**Response (200):**
```json
{
  "community": {
    "id": "comm-ai-tools",
    "slug": "ai-tools",
    "name": "AI Tools & Strategy",
    "isSystem": false
  },
  "progressions": [
    {
      "id": "prog-ai-fundamentals",
      "name": "AI Fundamentals",
      "slug": "ai-fundamentals",
      "description": "Master the AI landscape...",
      "thumbnailUrl": null,
      "badge": "learning_path",
      "courseCount": 2,
      "totalDurationMinutes": 360,
      "studentCount": 119,
      "displayOrder": 1,
      "isActive": true,
      "createdAt": "2024-03-01T00:00:00Z",
      "courses": [
        {
          "id": "crs-ai-tools-overview",
          "slug": "ai-tools-overview",
          "title": "AI Tools Overview",
          "tagline": "Navigate the AI landscape...",
          "description": "Master the AI tool landscape...",
          "level": "beginner",
          "priceCents": 24900,
          "currency": "USD",
          "thumbnailUrl": null,
          "rating": 4.9,
          "ratingCount": 34,
          "studentCount": 67,
          "sessionCount": 2,
          "totalDuration": "3 hours",
          "badge": "featured",
          "position": 1
        },
        {
          "id": "crs-intro-to-claude-code",
          "slug": "intro-to-claude-code",
          "title": "Intro to Claude Code",
          "position": 2
        }
      ]
    }
  ]
}
```

**Response (200) - System community:**
```json
{
  "community": {
    "id": "comm-system",
    "slug": "system",
    "name": "System",
    "isSystem": true
  },
  "progressions": [],
  "message": "System communities do not have progressions"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 404 | Community not found |

**Notes:**
- Progressions sorted by `display_order`
- Courses within progressions sorted by `progression_position`
- `badge` values: `learning_path` (multi-course), `standalone` (single course)
- System communities (the System feed) always return empty progressions array

---

### POST /api/communities/[slug]/join

Join a community. Creates membership record and establishes Stream follow for aggregated timeline.

**Response (200):**
```json
{
  "message": "Joined community",
  "membership": {
    "id": "mem-123",
    "role": "member",
    "communityId": "comm-ai-tools",
    "communitySlug": "ai-tools",
    "communityName": "AI Tools & Strategy",
    "joinedAt": "2026-02-05T12:00:00Z"
  }
}
```

**Response (200) - Already a member:**
```json
{
  "message": "Already a member",
  "membership": {
    "role": "member",
    "communityId": "comm-ai-tools",
    "communitySlug": "ai-tools"
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | This community is private |
| 404 | Community not found |

**Notes:**
- Creates `community_members` record with `joined_via: 'self'`
- Updates community `member_count`
- Establishes Stream follow: `timeline:{userId}` follows `community:{slug}`
- Posts from this community will appear in the user's aggregated Home (`/`) smart feed

---

### DELETE /api/communities/[slug]/join

Leave a community. Removes membership and Stream follow.

**Response (200):**
```json
{
  "message": "Left community",
  "communitySlug": "ai-tools"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Not a member of this community |
| 400 | Cannot leave system communities |
| 400 | Creators cannot leave their own community |
| 401 | Authentication required |
| 404 | Community not found |

**Notes:**
- Removes Stream follow for this community
- Cannot leave the System feed (system community)
- Creators must transfer ownership before leaving

---

## Creator Community Management

Creator-facing CRUD endpoints for managing communities and progressions. Uses `/api/me/communities` namespace (matches `/api/me/courses` pattern).

### GET /api/me/communities

List the authenticated creator's communities with stats.

**Authentication:** Required (`can_create_courses`)

**Response (200):**
```json
{
  "communities": [
    {
      "id": "comm-xxxxxxxx",
      "name": "Web Dev Academy",
      "slug": "web-dev-academy",
      "description": "Learn web development",
      "icon": null,
      "cover_image_url": null,
      "is_public": true,
      "is_system": false,
      "member_count": 5,
      "post_count": 0,
      "progression_count": 2,
      "course_count": 3,
      "created_at": "...",
      "updated_at": "..."
    }
  ],
  "stats": { "total": 1 }
}
```

### POST /api/me/communities

Create a new community. Atomically creates the community, a default "General" progression (`badge='standalone'`), and creator membership.

**Request:**
```json
{
  "name": "Web Dev Academy",
  "description": "Learn web development",
  "icon": "🌐",
  "is_public": true
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | Yes | — | Community name |
| `description` | string | No | `null` | Description |
| `icon` | string | No | `null` | Emoji or icon name |
| `is_public` | boolean | No | `true` | Public visibility |

**Response (201):** Returns created community + default progression.

**Notes:**
- Slug auto-generated from name (unique suffix added if conflict)
- Creator auto-joined as `community_members` with `role = 'creator'`
- Stream timeline follow established (non-fatal)

### PATCH /api/me/communities/[slug]

Update community settings. If name changes, slug is regenerated.

**Request:** Any subset of `{ name, description, icon, is_public, cover_image_url }`.

**Errors:** 400 (empty name, no changes), 403 (not owner), 404 (not found)

### DELETE /api/me/communities/[slug]

Archive community (soft-delete). Sets `is_archived = 1`.

**Guards:**
- Cannot archive system communities (`is_system = 1`)
- Cannot archive communities with active enrollments (`status IN ('enrolled', 'in_progress')`)

**Errors:** 400 (system community, active enrollments), 403 (not owner), 404 (not found)

### GET /api/me/communities/[slug]/members

List members of a community owned by the authenticated creator. Returns user details joined from the users table.

**Auth:** JWT required, must be community creator.

**Response (200):**
```json
{
  "members": [
    {
      "id": "cmem-1",
      "user_id": "usr-1",
      "role": "creator",
      "joined_via": "system",
      "joined_at": "2026-01-01T00:00:00",
      "name": "Jane Creator",
      "handle": "janecreator",
      "avatar_url": "https://example.com/avatar.jpg"
    }
  ]
}
```

**Sort order:** Role priority (creator → member), then joined_at ascending. (COMMUNITY-TEACHER-KILL, Conv 120 — `'teacher'` branch removed from ORDER BY CASE.)

**Errors:** 400 (missing slug), 401 (not authenticated), 403 (not owner), 404 (community not found)

---

## Community Resources

File and link resources scoped to a community. See `docs/reference/DB-GUIDE.md` §Community Resources for the storage model. R2-backed files are streamed via a separate download endpoint; external links are passed through on the SSR response (`downloadUrl` field).

**Upload auth (MVP):** community creator OR platform admin (`users.is_admin=1`) only. Moderators and regular members cannot upload. Enforced in Astro pages via `canUploadCommunityResources(membership, isAdmin)` from `src/lib/permissions.ts` (Conv 120, COMMUNITY-TEACHER-KILL — also closed the [UI-ADMIN-GATE] bug where admins were silently locked out).

**UI entry point:** `src/components/community/AddCommunityResourceModal.tsx` — tab-toggle modal (Upload file / Add link) wired to the community Resources tab. Added Conv 118. Handles MIME auto-sensing, type-override dropdown, pin toggle, 50 MB file guard.

**Download auth:** any authenticated community member, plus creator and platform admin. Public vs private community does not affect download auth — non-members get 403.

**SQL gotcha — `is_archived`, not `deleted_at`:** The `communities` table uses `is_archived = 0` for active-record filtering. It has **no `deleted_at` column**. Endpoint auth helpers (`resolveAndAuthorize`) must filter on `is_archived = 0`, not `deleted_at IS NULL`. The original Conv 117 endpoints used `deleted_at IS NULL` which caused all POST/PUT/DELETE resource mutations to 500; fixed in Conv 118.

### GET /api/me/communities/[slug]/resources

List all resources in a community (creator/admin view, includes ordering metadata).

**Auth:** JWT required; caller must be the community's creator OR platform admin.

**Response (200):**
```json
{
  "community_id": "comm-ai-for-you",
  "community_slug": "ai-for-you",
  "resources": [
    {
      "id": "cres-abc12345",
      "community_id": "comm-ai-for-you",
      "uploaded_by_user_id": "usr-guy_rymberg",
      "title": "AI Tools Landscape 2026",
      "description": "Curated map of AI tools",
      "type": "document",
      "r2_key": "communities/comm-ai-for-you/resources/cres-abc12345/guide.pdf",
      "external_url": null,
      "size_bytes": 1048576,
      "mime_type": "application/pdf",
      "download_count": 0,
      "is_pinned": true,
      "display_order": 1,
      "created_at": "2026-04-14T00:00:00.000Z",
      "updated_at": "2026-04-14T00:00:00.000Z"
    }
  ],
  "total": 1
}
```

**Sort order:** `is_pinned DESC, display_order ASC, created_at DESC`.

**Errors:** 400 (missing slug), 401, 403 (not creator/admin), 404 (community not found), 503 (DB unavailable).

### POST /api/me/communities/[slug]/resources

Create a new resource. Two modes, distinguished by request `Content-Type`:

**Mode A — File upload (`multipart/form-data`):**

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `file` | File | yes | Validated via `isAllowedFileType` + `isFileSizeAllowed` (MAX_FILE_SIZE in `@lib/r2`) |
| `title` | string | no | Defaults to `file.name` |
| `description` | string | no | |
| `type` | string | no | Override auto-detect; one of `document/image/audio/video_link/other` |
| `is_pinned` | "true"/"false" | no | |

Auto-type-detect from `file.type` MIME: `image/*` → `image`, `audio/*` → `audio`, else → `document`. Creator may override via the `type` field.

File is uploaded to R2 at `communities/{communityId}/resources/{resourceId}/{originalName}` (via `generateCommunityResourceKey` in `@lib/r2`).

**Mode B — External link (`application/json`):**

```json
{
  "title": "Prompt Engineering Guide",
  "description": "Open-source guide",
  "type": "other",
  "external_url": "https://www.promptingguide.ai",
  "is_pinned": false
}
```

Required: `title`, `external_url` (parsed via `new URL()` for format validation). Optional: `description`, `type` (defaults to `other`), `is_pinned`.

**Response (201):** `{ "resource": {…same shape as GET row…} }`

**Errors:** 400 (invalid file type, file too large, missing title/url, invalid URL), 401, 403, 404, 503 (R2/DB unavailable), 500.

### GET /api/me/communities/[slug]/resources/[resourceId]

Fetch a single resource (creator/admin view).

**Auth:** JWT required; community creator OR platform admin.

**Response (200):** `{ "resource": {…} }` (same row shape as list).

**Errors:** 400, 401, 403, 404, 503.

### PUT /api/me/communities/[slug]/resources/[resourceId]

Update metadata on an existing resource. Body (JSON) accepts any subset of: `title`, `description`, `type`, `is_pinned`, `display_order`. File body and R2 key are immutable via PUT — to replace a file, DELETE and re-POST.

**Response (200):** `{ "resource": {…} }`

**Errors:** 400, 401, 403, 404, 503.

### DELETE /api/me/communities/[slug]/resources/[resourceId]

Delete a resource and (for R2-backed rows) remove the underlying R2 object.

**Response (200):** `{ "deleted": true }`

**Errors:** 400, 401, 403, 404, 503.

---

### GET /api/community-resources/[id]/download

Stream the R2-backed file for a community resource.

**Auth:** JWT required. Authorization checks run in order (creator → admin → member), short-circuiting on first match:

1. Community creator (`communities.creator_id = userId`)
2. Platform admin (`users.is_admin = 1`)
3. Community member (`community_members` row exists)

Non-members get 403 even on public communities. Link-type resources (r2_key IS NULL, external_url set) return **400** — clients should use the `externalUrl`/`downloadUrl` passthrough from the community SSR response directly instead of hitting this endpoint.

**Response (200):** Streamed R2 object body with `Content-Type` = stored `mime_type`, `Content-Disposition: attachment; filename="…"` derived from the r2_key. Increments `download_count` on success.

**Errors:** 400 (missing id, link-type resource), 401, 403 (non-member), 404 (resource not found / R2 object missing), 503 (DB/R2 unavailable), 500.

---

## Creator Progression Management

Progression CRUD nested under community slug: `/api/me/communities/[slug]/progressions`.

### GET /api/me/communities/[slug]/progressions

List progressions with nested courses. Creator view includes archived progressions and draft courses.

**Response (200):**
```json
{
  "progressions": [
    {
      "id": "prog-xxxxxxxx",
      "name": "General",
      "slug": "web-dev-academy-general",
      "badge": "standalone",
      "display_order": 0,
      "is_archived": false,
      "courses": [
        { "id": "crs-xxx", "title": "Intro to JS", "is_active": true, "progression_position": 1 }
      ]
    }
  ]
}
```

### POST /api/me/communities/[slug]/progressions

Create a new progression. `display_order` auto-calculated as MAX(existing) + 1.

**Request:** `{ "name": "Advanced Track", "description": "For experienced devs" }`

**Response (201):** Returns created progression with `badge = 'standalone'`.

### PATCH /api/me/communities/[slug]/progressions/[id]

Update progression fields.

**Request:** Any subset of `{ name, description, thumbnail_url, badge }`.

**Notes:** `badge` must be `'standalone'` or `'learning_path'` if provided.

### DELETE /api/me/communities/[slug]/progressions/[id]

Archive progression (sets `is_archived = 1`). Does NOT cascade to courses.

### PATCH /api/me/communities/[slug]/progressions/reorder

Reorder progressions within a community.

**Request:** `{ "order": ["prog-id-2", "prog-id-1", "prog-id-3"] }`

**Notes:**
- `order` array must contain exactly all non-archived progression IDs for the community
- Rejects extra, missing, or invalid IDs

---

## Community Moderators (Tier 2)

Community moderators are creator-appointed, scoped to one community and its course feeds (via the community → progression → course chain). See also: Tier 1 (Global Moderators) at `/api/admin/moderators`.

### GET /api/communities/[slug]/moderators

List active community moderators with user details.

**Auth:** Required (any authenticated user)

**Response (200):**

```json
{
  "communityId": "comm-123",
  "communitySlug": "web-dev",
  "moderators": [
    {
      "id": "cmmod-1",
      "userId": "usr-456",
      "userName": "Jane Doe",
      "userHandle": "janedoe",
      "userAvatar": "https://...",
      "appointedAt": "2026-02-23T12:00:00.000Z",
      "appointedByName": "Creator Name",
      "notes": "Trusted member"
    }
  ]
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 404 | Community not found |

### POST /api/communities/[slug]/moderators

Appoint a community member as a moderator.

**Auth:** Community creator or admin

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `userId` | string | Yes | User to appoint |
| `notes` | string | No | Internal notes about appointment |

**Response (200):**

```json
{
  "message": "Moderator appointed",
  "moderator": {
    "id": "cmmod-1",
    "userId": "usr-456",
    "userName": "Jane Doe",
    "userHandle": "janedoe",
    "communityId": "comm-123",
    "communitySlug": "web-dev",
    "appointedBy": "Creator Name"
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | userId is required |
| 400 | User must be a community member |
| 400 | Cannot appoint the community creator as a moderator |
| 401 | Authentication required |
| 403 | Only the community creator or an admin can appoint moderators |
| 404 | Community not found |
| 404 | User not found |
| 409 | User is already a moderator for this community |

**Notes:**
- Re-appointment of a revoked moderator reactivates the existing row (returns "Moderator reactivated")
- Target must be a current community member
- Community creator cannot be appointed (they already have full authority)

### DELETE /api/communities/[slug]/moderators/[userId]

Revoke a community moderator (soft-revoke: sets `is_active=0`).

**Auth:** Community creator or admin

**Request Body (optional):**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `reason` | string | No | Reason for revocation |

**Response (200):**

```json
{
  "message": "Moderator revoked",
  "communitySlug": "web-dev",
  "userId": "usr-456"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Only the community creator or an admin can revoke moderators |
| 404 | Community not found |
| 404 | Active moderator not found |

**Notes:**
- Soft revoke preserves history (`revoked_by_user_id`, `revoked_at`, `revoke_reason`)
- Revoked moderators can be reappointed via POST

---

## Feed Discovery

### GET /api/feeds/discover

Surfaces active public feeds worth joining. Visitor-accessible (no auth required).

**Auth:** Optional. Authenticated users get topic-matched results; visitors get popularity-ranked results.

**Response (200):**
```json
{
  "feeds": [
    {
      "feedType": "community",
      "feedId": "ai-tools",
      "feedName": "AI Tools & Strategy",
      "feedIcon": "🤖",
      "memberCount": 45,
      "vitality": 12,
      "matchReason": "topic_match",
      "latestPost": {
        "text": "",
        "userName": "Jane Creator",
        "createdAt": "2026-03-27T10:00:00Z"
      },
      "ctaType": "join_community",
      "ctaUrl": "/discover/community/ai-tools?via=discover-feeds"
    },
    {
      "feedType": "course",
      "feedId": "intro-to-ai",
      "feedName": "Introduction to AI",
      "feedIcon": null,
      "memberCount": 120,
      "vitality": 8,
      "matchReason": "topic_match",
      "latestPost": null,
      "ctaType": "view_course",
      "ctaUrl": "/discover/course/intro-to-ai?via=discover-feeds"
    }
  ]
}
```

**Behavior:**
- **Authenticated:** Returns community and course feeds matching user's tag interests (via `user_tags` -> `course_tags` overlap), excluding joined communities, enrolled/teaching courses, and own courses. Ranked by vitality (14-day activity count).
- **Visitor:** Returns all public community and course feeds, ranked by vitality only.
- Feeds with zero vitality are included but ranked last (vitality is a ranking signal, not an inclusion gate — Conv 052). This avoids the cold-start problem where new feeds with no activity are invisible.
- Each feed includes `ctaType` and `ctaUrl` directing users to the parent entity's discover page.
- Results are merged (community + course) and sorted by vitality descending. Max 10 per feed type.

**Notes:**
- Follows the Smart Feed discovery pipeline concept (tag-overlap vitality ranking) but queries directly rather than calling the Smart Feed library. (The former `getDiscoveryCandidates()` helper this once mirrored was removed in Conv 273 / FEED-U2.)
- `latestPost.text` is always empty string (post content not fetched for performance); only author name and timestamp are returned.

### GET /api/discovery/rails

Serves the global **Discovery Rails** blob — up to 6 rails, `{trending, popular, new} × {course, community}` (DISCOVERY-RAILS block, Conv 261). The payload is **un-personalized** (identical for every viewer); clients apply a personalization lens via each entity's `topicIds`. Drives the visitor / cold-start marketing surface.

**Auth:** None (public).

**Serving strategy (two-tier):**
- **PROD:** read a precomputed blob from the `DISCOVERY_CACHE` KV namespace, written daily by the cron Worker (zero per-request aggregation).
- **Fallback** (dev / cold cache / stale-schema / missing KV binding): compute on demand from D1. The active source is reported in the `X-Discovery-Source: kv | compute` response header.

Response carries `Cache-Control: public, max-age=300` (global + un-personalized → briefly edge-cacheable).

**Response (200):**
```json
{
  "generatedAt": "2026-06-13T09:00:00.000Z",
  "version": 1,
  "windows": { "newWindowDays": 30, "trendingWindowDays": 7, "topN": 12 },
  "rails": [
    {
      "kind": "trending",
      "entityType": "course",
      "items": [
        {
          "entityType": "course",
          "id": "course-id",
          "slug": "course-slug",
          "title": "Course Title",
          "description": "Tagline or null",
          "imageUrl": "https://… or null",
          "icon": null,
          "topicIds": ["topic-1", "topic-2"],
          "memberCount": 67,
          "createdAt": "2026-05-01T00:00:00.000Z",
          "reason": "trending",
          "score": 14
        }
      ]
    }
  ]
}
```

**Per-rail / per-item notes:**
- `rails` always lists every populated combination; **empty rails are still present** (kind/entityType with an empty `items` array).
- `windows` echoes the dials actually used (from `loadRailsConfig`) for transparency + client display.
- `RailEntity.memberCount` = students (course) or members (community); `RailEntity.score` is the parent rail's ranking signal as a number — trending → recent-window velocity (count), popular → magnitude, new → `createdAt` epoch ms.
- `icon` is `communities.icon` (always `null` for courses); `title`/`description`/`imageUrl` map to the course/community columns noted in `RailEntity`.

**Errors:**
| Status | Error |
|--------|-------|
| 500 | Failed to compute discovery rails |
| 503 | Database not available |

---

## Timeline Feed

### GET /api/feeds/timeline

Get user's aggregated timeline combining posts from all followed sources (communities and courses).

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | number | 25 | Activities per page |
| `offset` | number | 0 | Pagination offset |
| `source` | string | - | Filter by source type: `community` or `course` |

**Response (200):**
```json
{
  "activities": [
    {
      "id": "abc123...",
      "actor": "user:usr-123",
      "verb": "post",
      "object": "post:1705678901234",
      "text": "Post content",
      "userName": "User Name",
      "userImage": null,
      "time": "2026-02-05T12:00:00.000Z",
      "communityId": "comm-ai-tools",
      "communitySlug": "ai-tools",
      "communityName": "AI Tools & Strategy",
      "reaction_counts": { "like": 5 },
      "own_reactions": {}
    }
  ],
  "next": ""
}
```

**Notes:**
- Requires authentication
- Timeline aggregates posts from feeds the user follows
- Follows are established when user joins communities or enrolls in courses
- Filter with `source=community` or `source=course` for specific feed types

---

## Smart Feed

### GET /api/feeds/smart

Ranked, personalized feed with discovery. Surfaces important posts from the user's feeds + discoverable content from public feeds they haven't joined. Replaces the chronological timeline.

> **HOME-FEED-MERGE rework (Conv 266–268):** the orchestrator returns a unified 3-kind item stream (`member-post` / `sample-post` / `suggestion-card`) with an opaque `(created_at,id)` cursor. **The endpoint is auth-aware, not auth-gated (Conv 267, Phase 3):** visitors get a marketing-only stream (`userId = null`, `public, max-age=60` + `Vary: Cookie`); authenticated callers get the personalized stream (`private, no-store`). All three item kinds are served — **`suggestion-card` filtering was removed in Phase 4** so clients render the full stream. **Phase 6 (Conv 268)** made discovery `ctaUrl` values auth-branched server-side (`src/lib/smart-feed/cta.ts`): the field/shape is unchanged, but a visitor's `ctaUrl` is `/signup?redirect=<encoded entity>` (intent-preserving; `?via=` preserved inside the redirect) while an authed caller's is the direct entity link. Build phases: `plan/home-feed-merge/README.md`.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | number | 20 | Activities per page (max 50) |
| `before` | string | - | Opaque `(created_at,id)` cursor from `nextCursor` of the previous page (Option-A floor — not a plain timestamp) |

**Response (200):**
```json
{
  "activities": [
    {
      "kind": "member-post",
      "activity": { "id": "abc123", "actor": "user:usr-123", "text": "Post content", "reaction_counts": { "like": 5 } },
      "activityId": "abc123",
      "createdAt": "2026-03-18T14:22:00.000Z",
      "smartScore": 0.87,
      "surfaceReason": "teacher_post",
      "feedType": "community",
      "feedId": "python-devs"
    }
  ],
  "nextCursor": "...",
  "viewerAuthenticated": false
}
```

**Item kinds:** `member-post` (ranked post from a feed the user belongs to), `sample-post` (de-personalized public sample post), `suggestion-card` (entity/discovery card — served, no longer filtered). Each item carries `kind`, `activityId`, and `createdAt` (cursor keys).

**`viewerAuthenticated` (Conv 270):** top-level boolean baked server-side (`true` for an authed caller, constant `false` for all visitors). Lets the prop-less `client:load` `SmartFeed` island adapt without a first-paint `localStorage` auth guess — it hides member-only filter tabs and shows discovery-framed copy for visitors. Constant-`false` for visitors keeps the visitor response cacheable.

**`sample-post` discovery anchor (Conv 273 / FEED-U2):** each `sample-post` item carries a `discoveryContext.anchor` object that the client renders as an embedded entity anchor below the post. Populated server-side by `enrichment.ts` `fetchDiscoveryAnchors`: for a **course** — creator (via `creator_id`→`users`), level, and a formatted `X.X (N reviews)` rating sourced from `courses.rating`/`rating_count` (omitted when 0 reviews); for a **community** — icon, member count, and 14-day vitality. Additive enrichment — no change to the existing response contract.

**Surface Reasons:** `teacher_post`, `creator_post`, `high_engagement`, `unseen`, `topic_match`, `recent`

**Notes:**
- Auth-aware, not auth-gated: visitors receive a marketing-only stream; the response varies by session (cache `public, max-age=60` + `Vary: Cookie` for visitors, `private, no-store` for authed callers)
- Discovery rails (suggestion cards) read via the shared `loadDiscoveryRailsBlob` two-tier KV + compute-fallback reader; degrades to no cards on failure
- Uses opaque cursor-based pagination (not offset); the cursor is the oldest backbone `(created_at,id)` in the page
- Scoring weights tunable via `platform_stats` rows with `smart_feed_*` prefix

### POST /api/feeds/smart/dismiss

Dismiss a discovery feed from the smart feed ("Not Interested").

**Request Body:**
```json
{
  "feedType": "community",
  "feedId": "django-masters"
}
```

**Validation:**
- `feedType` must be `"community"` or `"course"`
- `feedId` is required

**Response (200):**
```json
{ "success": true }
```

**Notes:**
- Requires authentication
- Idempotent — duplicate dismissals succeed silently
- Dismissed feeds excluded from future smart feed responses

### POST /api/announcements/dismiss

Dismiss a platform announcement from the home smart feed ("Got it" / X). Platform announcements are authored by admins (see `POST /api/admin/announcements` in [API-ADMIN.md](API-ADMIN.md)) and pinned atop the smart feed at read time. Because delivery is read-time fan-out (no per-user row), this dismissal is the only per-user state — the announcement won't appear in this user's feed again (FEED-U3c④, Conv 277).

**Request Body:**
```json
{ "announcementId": "..." }
```

**Validation:**
- `announcementId` is required

**Response (200):**
```json
{ "success": true }
```

**Notes:**
- Requires authentication
- Idempotent — duplicate dismissals succeed silently (writes an `announcement_dismissals` row)

---

## System Feed

> **Admin-only (SYS-RENAME, Conv 259 display/enum; Conv 280 full value/route rename):** The System feed (formerly The Commons / townhall) is the domain of Admins only. `GET`/`POST /api/feeds/system` (and comments/reactions) require admin — non-admins receive `403 Forbidden`. As of Conv 280 the route path is `/api/feeds/system`, the community is `id: comm-system` / `slug: system` / `name: System`, and the React component is `SystemFeed`. The Stream feed *group* remains `townhall` (Stream groups are dashboard-declared, not write-creatable — kept behind the documented `SYSTEM_STREAM_GROUP` constant in `src/lib/system-feed.ts`); the D1 `feed_type` enum value is `'system'`.
>
> **Participation gating (VISITOR-GATING, Conv 264):** The mutating reaction/comment endpoints now enforce this admin-only rule through the shared `canParticipate({type:'system'})` predicate (`src/lib/feed-participation.ts`) rather than ad-hoc checks. `GET /api/feeds/system/comments` now applies the same `canParticipate({type:'system'})` gate (SYS-GET-GATE, Conv 278) — non-admins receive `403 Forbidden`.

### GET /api/feeds/system

Get system feed activities with reaction data. **Admin-only** (403 for non-admins).

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | number | 25 | Activities per page |
| `offset` | number | 0 | Pagination offset |

**Response (200):**
```json
{
  "activities": [
    {
      "id": "abc123...",
      "actor": "user:usr-guy_rymberg",
      "verb": "post",
      "object": "post:1705678901234",
      "text": "This is my first system feed post",
      "userName": "Guy Rymberg",
      "userImage": null,
      "time": "2026-01-19T18:53:00.000Z",
      "reaction_counts": {
        "like": 5,
        "love": 2,
        "celebrate": 1
      },
      "own_reactions": {
        "like": [{ "id": "reaction-id", "kind": "like" }]
      }
    }
  ],
  "next": ""
}
```

### POST /api/feeds/system

Add activity to system feed.

**Request:**
```json
{
  "text": "Hello community!"
}
```

**Response (200):**
```json
{
  "activity": {
    "id": "abc123...",
    "actor": "user:usr-123",
    "verb": "post",
    "object": "post:1705678901234",
    "text": "Hello community!",
    "userName": "User Name",
    "userImage": null,
    "time": "2026-01-19T19:00:00.000Z"
  }
}
```

### POST /api/feeds/system/reactions

Add reaction to an activity.

**Request:**
```json
{
  "activityId": "abc123...",
  "type": "like"
}
```

Valid types: `like`, `love`, `celebrate`

**Response (200):**
```json
{
  "success": true,
  "reaction": {
    "id": "reaction-id",
    "kind": "like",
    "activity_id": "abc123..."
  }
}
```

**Error (409):** Already reacted with this type

### DELETE /api/feeds/system/reactions

Remove reaction from an activity.

**Request:**
```json
{
  "activityId": "abc123...",
  "type": "like"
}
```

**Response (200):**
```json
{
  "success": true
}
```

**Error (404):** Reaction not found

---

## Comments

### GET /api/feeds/system/comments

Get comments for an activity or replies for a comment. **Admin-only** (SYS-GET-GATE, Conv 278): the `canParticipate({type:'system'})` gate applies to reads too — non-admins receive `403 Forbidden`.

**Query Parameters:**
- `activityId` - Activity ID to get top-level comments (required if no parentId)
- `parentId` - Parent comment ID to get replies (required if no activityId)

**Response (200):**
```json
{
  "comments": [
    {
      "id": "9e7d31bf-...",
      "activityId": "6c71fb50-...",
      "userId": "usr-guy_rymberg",
      "text": "Great post!",
      "userName": "Guy Rymberg",
      "userImage": null,
      "createdAt": "2026-01-20T15:02:30.834981Z",
      "isOwn": true,
      "replyCount": 2
    }
  ]
}
```

### POST /api/feeds/system/comments

Add a comment or reply.

**Request (top-level comment):**
```json
{
  "activityId": "6c71fb50-...",
  "text": "Great post!"
}
```

**Request (reply):**
```json
{
  "parentId": "9e7d31bf-...",
  "text": "Thanks!"
}
```

**Response (200):**
```json
{
  "success": true,
  "comment": {
    "id": "new-comment-id",
    "activityId": "6c71fb50-...",
    "parentId": "9e7d31bf-...",
    "userId": "usr-guy_rymberg",
    "text": "Thanks!",
    "userName": "Guy Rymberg",
    "userImage": null,
    "createdAt": "2026-01-20T15:10:00.000Z",
    "isOwn": true,
    "replyCount": 0
  }
}
```

**Notes:**
- Threading supports up to 3 levels of nesting (Stream.io limit)
- Maximum comment length: 2000 characters

### DELETE /api/feeds/system/comments

Delete a comment (and all its replies).

**Request:**
```json
{
  "commentId": "9e7d31bf-..."
}
```

**Response (200):**
```json
{
  "success": true
}
```

**Error (404):** Comment not found

---

## Community Feed

Per-community feeds where members can post and discuss. Each community has its own isolated feed using Stream.io pattern `community:{communityId}`.

> **Participation gating (VISITOR-GATING, Conv 264):** All mutating community-feed endpoints (`POST`/`DELETE` on `/reactions` and `/comments`) now enforce membership via the shared `canParticipate` predicate (`src/lib/feed-participation.ts`), applied after input validation. Non-members receive `403 Forbidden`; a missing community yields `404`. `GET` (read) remains open per posture A.

### GET /api/feeds/community/[slug]

Get community feed activities with reaction data.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | number | 25 | Activities per page |
| `offset` | number | 0 | Pagination offset |

**Response (200):**
```json
{
  "community": {
    "id": "comm-ai-tools",
    "slug": "ai-tools",
    "name": "AI Tools & Strategy",
    "isPublic": true,
    "isSystem": false
  },
  "activities": [
    {
      "id": "abc123...",
      "actor": "user:usr-123",
      "verb": "post",
      "object": "post:1705678901234",
      "text": "Discussion post content",
      "userName": "User Name",
      "userImage": null,
      "userRole": "member",
      "time": "2026-02-05T12:00:00.000Z",
      "communityId": "comm-ai-tools",
      "communitySlug": "ai-tools",
      "communityName": "AI Tools & Strategy",
      "reaction_counts": { "like": 5 },
      "own_reactions": {}
    }
  ],
  "next": "",
  "canPost": true,
  "canPromote": false,
  "postPromoteFloor": 3,
  "userRole": "member"
}
```

`canPromote` (PROMOTE-PIPELINE, Conv 265) is `true` when the viewer may escalate a post from this feed up the chain — the role check (admin / community creator / certified teacher). A community always promotes into System, so the flag is purely role-based; the System feed itself is top-of-chain and is never promotable (`false`). It gates the per-post Promote affordance so the client avoids a 403-after-click.

`postPromoteFloor` (U3D-POST, Conv 279) is the per-post engagement floor (reactions + comments) at or above which the client highlights a post's Promote affordance as "hot". It is the `promo_post_min_engagement` admin dial (see `POST /api/admin/promotion-config`), loaded **only when `canPromote` is `true`** — for non-promoters the field is `undefined` (omitted), since they never see the affordance. `0` = always highlight.

**Access Control:**

| Community Type | View | Post |
|----------------|------|------|
| Public | Anyone authenticated | Members only |
| Private | Members only | Members only |

**Errors:**

| Status | Error |
|--------|-------|
| 403 | Not a member of this private community |
| 404 | Community not found |
| 503 | Stream service not configured |

---

### POST /api/feeds/community/[slug]

Add activity to community feed. Requires membership.

**Request:**
```json
{
  "text": "Discussion post content"
}
```

**Response (200):**
```json
{
  "activity": {
    "id": "abc123...",
    "actor": "user:usr-123",
    "verb": "post",
    "object": "post:1705678901234",
    "text": "Discussion post content",
    "userName": "User Name",
    "userImage": null,
    "userRole": "member",
    "time": "2026-02-05T12:00:00.000Z",
    "communityId": "comm-ai-tools",
    "communitySlug": "ai-tools",
    "communityName": "AI Tools & Strategy"
  }
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Text is required |
| 401 | Authentication required |
| 403 | Not a member - join to participate |
| 404 | Community not found |

---

### POST /api/feeds/community/[slug]/reactions

Add reaction to a community feed activity. Same interface as system feed reactions.

**Request:**
```json
{
  "activityId": "abc123...",
  "type": "like"
}
```

Valid types: `like`, `love`, `celebrate`

### DELETE /api/feeds/community/[slug]/reactions

Remove reaction from a community feed activity.

**Request:**
```json
{
  "activityId": "abc123...",
  "type": "like"
}
```

---

### GET /api/feeds/community/[slug]/comments

Get comments for a community feed activity. Same interface as system feed comments.

**Query Parameters:**
- `activityId` - Activity ID to get top-level comments
- `parentId` - Parent comment ID to get replies

### POST /api/feeds/community/[slug]/comments

Add comment or reply to a community feed activity.

**Request (top-level):**
```json
{
  "activityId": "abc123...",
  "text": "Great discussion!"
}
```

**Request (reply):**
```json
{
  "parentId": "comment-id...",
  "text": "Thanks!"
}
```

### DELETE /api/feeds/community/[slug]/comments

Delete a comment from a community feed activity.

**Request:**
```json
{
  "commentId": "comment-id..."
}
```

---

## Course Feed

> **Participation gating (VISITOR-GATING, Conv 264):** All mutating course-feed endpoints (`POST`/`DELETE` on `/reactions` and `/comments`) enforce enrollment/creator/admin/teacher rights via the shared `canParticipate` predicate (`src/lib/feed-participation.ts`), applied after input validation. Ineligible users receive `403 Forbidden`; a missing/feed-disabled course yields `404`. `GET` (read) remains open per posture A.

### GET /api/feeds/course/[slug]

Get course discussion feed. Public access for viewing, but posting requires enrollment.

**Query Parameters:**
- `limit` (optional, default: 25) - Number of activities to return
- `offset` (optional, default: 0) - Pagination offset

**Response (200):**
```json
{
  "course": { "id": "...", "slug": "...", "title": "...", "thumbnail_url": "..." },
  "creator": { "id": "...", "name": "...", "handle": "...", "avatar_url": "..." },
  "activities": [...],
  "next": "",
  "canPost": true,
  "canPromote": false,
  "postPromoteFloor": 3,
  "userRole": "student",
  "feedEnabled": true
}
```

`canPromote` (PROMOTE-PIPELINE, Conv 265) is `true` when the viewer may escalate a post from this course feed up to its parent community — requiring **both** the promote role (admin / course creator / certified teacher) **and** a resolvable target. A course with no progression has no parent community, so it is never promotable (`false`). It gates the per-post Promote affordance so the client avoids a 403-after-click.

`postPromoteFloor` (U3D-POST, Conv 279) is the per-post engagement floor (reactions + comments) at or above which the client highlights a post's Promote affordance as "hot". It is the `promo_post_min_engagement` admin dial (see `POST /api/admin/promotion-config`), loaded **only when `canPromote` is `true`** — for non-promoters the field is `undefined` (omitted). `0` = always highlight.

**Response (404) - Feed not enabled:**
```json
{
  "error": "Discussion not available",
  "message": "The discussion feed has not been enabled for this course.",
  "course": { "id": "...", "slug": "...", "title": "..." },
  "feedEnabled": false
}
```

---

### POST /api/feeds/course/[slug]

Post to course discussion feed. Requires enrollment or creator/Teacher role.

**Request:**
```json
{
  "text": "Discussion post content"
}
```

**Response (200):**
```json
{
  "activity": {...}
}
```

**Error (403):** Not enrolled

---

### GET /api/feeds/course/[slug]/comments

Get comments for an activity or replies to a comment. Same interface as community comments.

**Query params:** `activityId` or `parentId` (one required)

**Authentication:** Required

---

### POST /api/feeds/course/[slug]/comments

Add a comment to an activity or reply to a comment. Dual-writes to `feed_activities` for badge counts.

**Request:**
```json
{
  "activityId": "stream-activity-id",
  "text": "Comment text"
}
```

Or for replies:
```json
{
  "parentId": "parent-comment-id",
  "text": "Reply text"
}
```

**Authentication:** Required

---

### DELETE /api/feeds/course/[slug]/comments

Remove a comment. Body: `{ "commentId": "reaction-id" }`.

**Authentication:** Required (must be comment author)

---

### POST /api/feeds/course/[slug]/reactions

Add a reaction (like, love, celebrate) to a course feed activity.

**Request:**
```json
{
  "activityId": "stream-activity-id",
  "type": "like"
}
```

**Authentication:** Required

---

### DELETE /api/feeds/course/[slug]/reactions

Remove a reaction. Same body as POST.

**Authentication:** Required

---

## Stream.io Token

### POST /api/stream/token

Generate a Stream.io user token for the authenticated user. Required for client-side initialization of Stream feeds.

**Authentication:** Required

**Request:** No body required (uses session from cookies).

**Response (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "apiKey": "stream-api-key",
  "appId": "stream-app-id",
  "userId": "usr-uuid"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 500 | Stream.io credentials not configured |

**Notes:**
- Token is short-lived; client should request a new one if Stream returns an auth error
- Used by all feed components (SystemFeed, CourseFeed, community feeds) for client-side initialization
- Requires `STREAM_API_KEY` and `STREAM_API_SECRET` environment variables

---

## Content Flagging

### POST /api/flags

Submit a flag for content moderation review. Authenticated users only.

**Request:**
```json
{
  "content_type": "post",
  "stream_activity_id": "abc123...",
  "reason": "harassment",
  "reason_details": "Optional additional context",
  "community_id": "comm-ai-tools",
  "feed_group": "community"
}
```

**Content Types:**
| Type | Required Field | Description |
|------|----------------|-------------|
| `post` | `stream_activity_id` | Flag a feed post |
| `comment` | `stream_reaction_id` | Flag a comment |
| `profile` | `target_user_id` | Flag a user profile |

**Optional Community Scoping:**
| Field | Type | Description |
|-------|------|-------------|
| `community_id` | string | Community the content belongs to (null for system feed/profile) |
| `feed_group` | string | Feed type: `system`, `community`, `course` (null for profile). Note: the D1 `feed_group` enum value is `'system'`; the underlying Stream feed *group* remains `townhall` (see SYSTEM_STREAM_GROUP). |

**Valid Reasons:** `spam`, `harassment`, `inappropriate`, `misinformation`, `other`

**Response (200):**
```json
{
  "success": true,
  "flag_id": "flg-123...",
  "message": "Content has been flagged for review"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Invalid content_type, missing required field |
| 400 | Invalid reason |
| 400 | Cannot flag own profile |
| 404 | Target user not found (profile flags) |
| 409 | Already flagged this content |

**Notes:**
- Content snapshot is cached at flag time for audit trail
- Priority is auto-calculated based on flag count and reason
- Harassment flags are automatically marked as urgent
- `community_id` and `feed_group` are stored for community-scoped moderation (Tier 2 moderators see only flags in their communities)
- Profile flags always have null `community_id` and `feed_group`

---

## Promotion (PROMOTE-PIPELINE; FEED-U3, Conv 274)

Two promotion paths, both gated behind the same single shared admin-set password (see `POST /api/admin/promotion-password` in [API-ADMIN.md](API-ADMIN.md)):

1. **Escalate** (`POST /api/feeds/promote`) — moves an *existing* post UP the feed chain (**Course → Community → System**), per the reference-lane model ① below.
2. **Entity-promo / A2 author-direct** (`POST /api/feeds/promote-entity`, FEED-U3b) — an author publishes a *new* promotional post for one of their own public courses/communities, surfaced to non-members via the home smart-feed discovery query (`GET /api/feeds/promotable-entities` is the composer's picker).

**Delivery model ① — reference lane (Conv 263–265).** Promoting does **NOT** copy the post or write a second Stream activity. It records **one** `post_promotions` row referencing the **canonical source activity** plus the target feed; the post stays in its origin feed, and every higher-feed appearance is assembled at read time by the lane (`src/lib/promotion/lane.ts`). Engagement is never split across copies. Lineage lives solely in the `post_promotions` event table — there is no `feed_activities` lineage column. Implemented in `src/lib/promotion/`.

### POST /api/feeds/promote

Promote a source post one level up the chain. Resolves the target feed (course's parent community via `courses.progression_id → progressions.community_id`; community's parent System feed), checks the promoter's role, validates the password, and records **one** `post_promotions` row referencing the canonical source activity + the target feed. No Stream write — the lane assembles the higher-feed appearance at read time (model ①).

The body identifies the post by its **Stream activity id** (`streamActivityId`) — the id the client holds everywhere (reactions, comments). The endpoint resolves it to the canonical `feed_activities` row via the UNIQUE `stream_activity_id` index; the internal FK / lane stay keyed on `feed_activities.id`.

**Request:**
```json
{
  "streamActivityId": "stream-activity-id",
  "password": "shared-promotion-password"
}
```

**Gating order:** auth → source exists → target exists → `canPromote` (role matrix: admin / creator / certified teacher) → already-promoted? (idempotent early-return) → gate configured → password valid → promote.

**Idempotent:** promoting the same post into the same target feed twice returns the existing promotion (`{ ..., "alreadyPromoted": true }`, 200) rather than writing a duplicate row. The check runs **before** the password gate, so a re-clicker isn't re-challenged for a no-op. Backed by the UNIQUE `(source_activity_id, to_feed_type, to_feed_id)` index on `post_promotions`. Two near-simultaneous promotes can both clear the pre-check; the INSERT then catches the UNIQUE-index violation and returns the same graceful `{ ..., "alreadyPromoted": true }` (200) instead of a 500 (PROMOTE-IDEMP, Conv 278).

**Response (200):** No copied activity is returned (model ①) — only the recorded promotion event, which references the canonical source activity. The already-promoted response carries an extra `"alreadyPromoted": true`.
```json
{
  "promotion": {
    "id": "promotion-event-id",
    "sourceActivityId": "feed-activities-row-id",
    "from": { "feedType": "course", "feedId": "course-slug" },
    "to": { "feedType": "community", "feedId": "community-slug" }
  }
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | `streamActivityId` required / feed cannot be promoted further |
| 401 | Authentication required |
| 403 | No permission to promote (role matrix) / promotion not enabled (no password configured) / invalid promotion password |
| 404 | Source post not found |
| 503 | Database unavailable |

**Authentication:** Required (must pass the role matrix AND the password gate)

---

### GET /api/feeds/promoted

Return the promotions targeted at a given feed (most recent first), enriched with content from Stream. This is the "Promoted" lane source for the home feed / rails. Under model ① each entry references the **canonical source** activity (no copy), so the enriched `activity` carries the original post's engagement.

**Query parameters:**
| Param | Required | Description |
|-------|----------|-------------|
| `feedType` | yes | `community` or `course` only |
| `feedId` | yes | Target feed slug |
| `limit` | no | Max entries |
| `sinceDays` | no | Restrict to promotions within N days |

**Scope:** community + course feeds only. The System/Commons feed is admin-only (SYS-RENAME); member-facing System content is delivered via Announcements ([ADMIN-FEED-UI] #32), so `feedType=system` is rejected with `400`.

**Response (200):**
```json
{
  "promoted": [
    {
      "promotionId": "promotion-event-id",
      "promoterId": "usr-uuid",
      "promotedFrom": { "feedType": "course", "feedId": "course-slug" },
      "createdAt": "2026-06-10T21:00:00.000Z",
      "activity": { "id": "stream-activity-id", "...": "..." }
    }
  ]
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | `feedType` and `feedId` required / unsupported `feedType` (System delivered via Announcements) |
| 401 | Authentication required |
| 503 | Database unavailable |

**Notes:**
- Stream enrichment is best-effort — on Stream failure the lane metadata is still returned with `activity: null`.
- Per-post visibility within the community/course is applied by the consumer (home feed / rails), not this endpoint.

**Authentication:** Required

---

### POST /api/feeds/promote-entity

Create a **new** entity-promo post advertising one of the author's own courses/communities (FEED-U3b, "A2 author-direct" path, Conv 274). Distinct from `POST /api/feeds/promote`, which escalates an *existing* post up the chain — this authors a brand-new promotional post.

**Placement (Option A, Conv 274):** the promo post is authored into the **promoted entity's own public feed**; the home smart feed surfaces it to non-members via the marketing/discovery query (no lane consumer needed). Only **public** entities are promotable — a private feed's posts never enter discovery, so the promo would be invisible. Backed by `createEntityPromo` (`src/lib/promotion/create.ts`): one Stream post (custom fields `postKind:'entity_promo'` + `promoEntityType` + `promoEntityId`), an `indexFeedActivity` row, and a `post_promotions` row (from = to = the entity's own feed).

**Request:**
```json
{
  "entityType": "course",
  "entityId": "entity-slug",
  "blurb": "promotional copy (≤1000 chars)",
  "password": "shared-promotion-password"
}
```

**Gating order:** auth → entity exists + is public → `canPromote` (role matrix: admin / creator / certified teacher) → gate configured → password valid → create.

**Response (200):**
```json
{
  "ok": true,
  "promotion": { "id": "promotion-event-id", "entityType": "course", "entityId": "entity-slug" },
  "streamActivityId": "stream-activity-id",
  "feedActivityId": "feed-activities-row-id"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | `entityType` must be `course`/`community` / `entityId` required / blurb required / blurb too long (>1000) |
| 401 | Authentication required |
| 403 | No permission to promote (role matrix) / promotion not enabled (no password configured) / invalid promotion password |
| 404 | Entity not found, or not public |
| 500 | Server configuration error / create failed |
| 503 | Database unavailable / Stream not configured |

**Authentication:** Required (must pass the role matrix AND the password gate)

---

### GET /api/feeds/promotable-entities

Return the public courses + communities the authenticated user may promote — the A2 composer's entity picker (FEED-U3b, Conv 274). Mirrors the `canPromote` role matrix as a **list**: an entity is promotable when the user is its creator OR a certified teacher of/within it, AND the entity is public. (Admins may promote any entity but the picker still lists only the user's own creator/teacher entities — a pure-admin promo posts the slug directly.)

Each entity carries an `engagementCount` (course `student_count` / community `member_count`) and the response carries the `minEngagement` floor from the promotion config (FEED-U3d, Conv 278). The composer ignores both and lists everything; the workspace `PromoteNudge` uses them to self-gate (it surfaces only when the user owns ≥1 entity whose `engagementCount ≥ minEngagement`).

**Response (200):**
```json
{
  "entities": [
    { "type": "course", "slug": "entity-slug", "title": "Entity Title", "engagementCount": 42 }
  ],
  "minEngagement": 3
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 500 | Server configuration error / load failed |
| 503 | Database unavailable |

**Authentication:** Required
