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
      "id": "comm-the-commons",
      "slug": "the-commons",
      "name": "The Commons",
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
- `creator` is null for system communities (The Commons)
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
      "id": "usr-guy-rymberg",
      "name": "Guy Rymberg",
      "handle": "guy-rymberg",
      "avatarUrl": null
    }
  },
  "membership": {
    "role": "member",
    "joinedAt": "2024-04-15T00:00:00Z",
    "joinedVia": "enrollment"
  },
  "members": [
    {
      "id": "usr-guy-rymberg",
      "name": "Guy Rymberg",
      "handle": "guy-rymberg",
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
      "type": "file",
      "url": "/resources/ai-tools-landscape-2026.pdf",
      "fileSize": null,
      "mimeType": null,
      "downloadCount": 234,
      "isPinned": true,
      "createdAt": "2024-03-01T00:00:00Z",
      "uploadedBy": {
        "id": "usr-guy-rymberg",
        "name": "Guy Rymberg",
        "handle": "guy-rymberg",
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
- Members sorted by role: creator → student_teacher → member
- Resources sorted by: pinned first, then by date
- `membership` is null if not authenticated or not a member
- Member `role` values: `creator`, `student_teacher`, `member`
- Resource `type` values: `file`, `link`, `video`

---

### GET /api/communities/[slug]/progressions

Get progressions with courses for a community. System communities (The Commons) return empty progressions array.

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
    "id": "comm-the-commons",
    "slug": "the-commons",
    "name": "The Commons",
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
- System communities (The Commons) always return empty progressions array

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
- Posts from this community will appear in user's `/feed` aggregated timeline

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
- Cannot leave The Commons (system community)
- Creators must transfer ownership before leaving

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
- Soft revoke preserves history (`revoked_by`, `revoked_at`, `revoke_reason`)
- Revoked moderators can be reappointed via POST

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
- New users auto-follow The Commons at registration
- Filter with `source=community` or `source=course` for specific feed types

---

## Townhall Feed

### GET /api/feeds/townhall

Get townhall feed activities with reaction data.

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
      "actor": "user:usr-guy-rymberg",
      "verb": "post",
      "object": "post:1705678901234",
      "text": "This is my first townhall post",
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

### POST /api/feeds/townhall

Add activity to townhall feed.

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

### POST /api/feeds/townhall/reactions

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

### DELETE /api/feeds/townhall/reactions

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

### GET /api/feeds/townhall/comments

Get comments for an activity or replies for a comment.

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
      "userId": "usr-guy-rymberg",
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

### POST /api/feeds/townhall/comments

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
    "userId": "usr-guy-rymberg",
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

### DELETE /api/feeds/townhall/comments

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
  "userRole": "member"
}
```

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

Add reaction to a community feed activity. Same interface as townhall reactions.

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

Get comments for a community feed activity. Same interface as townhall comments.

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
  "userRole": "student",
  "feedEnabled": true
}
```

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

Post to course discussion feed. Requires enrollment or creator/ST role.

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

## Content Flagging

### POST /api/flags

Submit a flag for content moderation review. Authenticated users only.

**Request:**
```json
{
  "content_type": "post",
  "stream_activity_id": "abc123...",
  "reason": "harassment",
  "reason_details": "Optional additional context"
}
```

**Content Types:**
| Type | Required Field | Description |
|------|----------------|-------------|
| `post` | `stream_activity_id` | Flag a feed post |
| `comment` | `stream_reaction_id` | Flag a comment |
| `profile` | `target_user_id` | Flag a user profile |

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
