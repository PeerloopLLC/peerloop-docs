# IFED - Instructor Feed

| Field | Value |
|-------|-------|
| Route | `/@:handle/feed` or `/instructors/:handle/feed` |
| Access | Authenticated (users who have purchased any course from this instructor) |
| Priority | P1 |
| Status | 📋 Spec Only |
| Block | 5 |
| JSON Spec | `src/data/pages/community/[instructor].json` |
| Astro Page | `src/pages/community/[instructor].astro` |

---

## Purpose

Exclusive feed for current and former students of an instructor, showing posts across all of that instructor's courses and enabling deeper community engagement.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S070 | As a Student, I need to access instructor-specific feeds so that I can engage with that creator's community | P1 | 📋 |
| US-C037 | As a Creator, I need a dedicated feed for my students so that I can build community | P1 | 📋 |
| US-C038 | As a Creator, I need my posts to reach my students so that I can communicate effectively | P1 | 📋 |
| US-P084 | As a Platform, I need to track instructor followers for feed access so that gating works correctly | P1 | 📋 |
| US-P085 | As a Platform, I need to support post promotion with points so that users can boost content | P2 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CPRO | "View Feed" link | From creator profile |
| SDSH | Instructor feed link | Dashboard quick access |
| NOTF | Notification about instructor post | Direct to feed |
| CDET | "Instructor Feed" link | From course detail |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CPRO | Instructor name/avatar click | View instructor profile | 📋 |
| CDET | Course mention click | View course | 📋 |
| PROF | Other student name click | View their profile | 📋 |
| FEED | "Main Feed" nav | Return to main community feed | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users (instructor) | id, name, avatar, handle | Instructor info |
| instructor_followers | instructor_id, follower_id | Access control |
| posts | id, author_id, course_id, content, created_at | Feed content |
| courses | id, title (where creator_id = instructor) | Course context |
| post_interactions | post_id, type, count | Engagement |
| promoted_posts | post_id, points_spent | Promoted content |

---

## Features

### Feed Content
- [ ] Posts from instructor directly `[US-C038]`
- [ ] Posts from students in instructor's courses `[US-S070]`
- [ ] Course tag on course-specific posts `[US-S070]`
- [ ] Engagement bar (like, reply, repost, bookmark) `[US-S070]`
- [ ] Promoted badge on boosted posts `[US-P085]`

### Header
- [ ] Instructor avatar + name `[US-S070]`
- [ ] "@[handle]'s Feed" title `[US-S070]`
- [ ] Follower count `[US-S070]`
- [ ] "Back to Profile" link → CPRO `[US-S070]`

### Post Composer
- [ ] Text input `[US-S070]`
- [ ] Course selector: "Post to [Course] or General" `[US-S070]`
- [ ] "Promote to Main Feed" option (uses goodwill points) `[US-P085]`
- [ ] Post button `[US-S070]`

### Sidebar (Desktop)
- [ ] Instructor mini profile card `[US-S070]`
- [ ] Courses list `[US-S070]`
- [ ] "View Full Profile" link → CPRO `[US-S070]`
- [ ] Course filter dropdown `[US-S070]`
- [ ] Active students display `[US-S070]`

---

## Sections (from Plan)

### Header
- Instructor avatar + name
- "@[handle]'s Feed"
- Follower count
- "Back to Profile" → CPRO

### Feed Content
- Posts from instructor and students
- Course tags
- Engagement bars
- Promoted badges

### Post Composer
- Text input
- Course selector
- Promote option
- Post button

### Sidebar (Desktop)
| Section | Content |
|---------|---------|
| Instructor Info | Mini profile, courses |
| Course Filter | Filter by specific course |
| Active Students | Who's online |
| Promote Feature | Boost explanation |

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/instructors/:id/feed/access` | GET | Verify user has access | 📋 |
| `/api/stream/token` | POST | Get Stream token with instructor feed | 📋 |
| `/api/posts` | POST | Store + publish to instructor feed | 📋 |
| `/api/posts/:id/promote` | POST | Use points to boost to main feed | 📋 |

**Access Control:**
```typescript
// Page load flow:
GET /api/instructors/:handle/feed/access
// Backend checks instructor_followers table:
SELECT 1 FROM instructor_followers
WHERE instructor_id = :instructor_id
  AND follower_id = :current_user_id

// If no record → 403: "Enroll in a course to access"
// If record exists → 200: { has_access: true, instructor: {...} }
```

**Stream Token with Instructor Feed:**
```typescript
POST /api/stream/token {
  requested_feeds: ['instructor:456']
}

// Response:
{
  token: "eyJ...",
  user_id: "user_123",
  api_key: "xxx...",
  feed_id: "instructor:456"
}
```

**Post Promotion Flow:**
```
1. User clicks "Promote" on their post
2. Show cost (e.g., 50 goodwill points)
3. POST /api/posts/:id/promote {
     points_to_spend: 50
   }
4. Backend:
   - Validates user owns post
   - Deducts points from user.goodwill_points
   - Records in promoted_posts table
   - Copies activity to townhall feed
5. Post appears in main community feed (FEED)
```

---

## States & Variations

| State | Description |
|-------|-------------|
| Active | Posts flowing from instructor and students |
| Quiet | Few posts, "Be the first to post" prompt |
| Filtered | Viewing posts from specific course |
| Promoting | User is promoting a post |
| No Access | Not enrolled, "Enroll to access" |

---

## Error Handling

| Error | Display |
|-------|---------|
| No access | "Enroll in one of [Name]'s courses to access this feed." |
| Post fails | "Unable to post. Try again." |
| Promote fails | "Unable to promote. Try again." |
| Load fails | "Unable to load feed. [Retry]" |

---

## Mobile Considerations

- Feed is main view
- Sidebar becomes tabs or bottom sheet
- Instructor header is collapsible
- Promote option in post composer

---

## Implementation Notes

- CD-024: Instructor feed access granted on first enrollment
- Access persists indefinitely (perpetual community access)
- Promotion uses goodwill points (Block 2+ feature)
- Uses Stream.io `instructor` feed group
- Token permissions scoped to specific instructor feed
- Course filtering via Stream activity metadata
- Instructor followers table populated on enrollment trigger
