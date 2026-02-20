# FEED - Community Feed

| Field | Value |
|-------|-------|
| Route | `/community` or `/feed` |
| Access | Authenticated |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 5 |
| JSON Spec | `src/data/pages/community/index.json` |
| Astro Page | `src/pages/community/index.astro` |

---

## Purpose

X.com-style algorithmic feed showing posts from followed users, courses, and creators, enabling community engagement and content discovery.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S025 | As a Student, I need to access the community feed so that I can engage with peers | P0 | 📋 |
| US-P002 | As a Platform, I need to provide a community feed so that users can connect | P0 | 📋 |
| US-S036 | As a Student, I need to view posts in algorithmic order so that I see relevant content | P1 | 📋 |
| US-S037 | As a Student, I need to like posts so that I can show appreciation | P0 | 📋 |
| US-S038 | As a Student, I need to bookmark posts so that I can save content | P1 | 📋 |
| US-S039 | As a Student, I need to reply to posts so that I can engage in discussions | P0 | 📋 |
| US-S040 | As a Student, I need to repost content so that I can share with my followers | P1 | 📋 |
| US-S041 | As a Student, I need to flag inappropriate content so that the community stays safe | P0 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Community" / "Feed" link | Global navigation |
| SDSH | "Community" quick action | From dashboard |
| NOTF | Notification about post | Direct to specific post |
| (External) | Direct URL | `/community` |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| PROF | Author name/avatar click | View poster's profile | 📋 |
| CDET | Course mention click | View mentioned course | 📋 |
| CPRO | Creator mention click | View creator profile | 📋 |
| IFED | "View [Creator] Feed" | Instructor-specific feed | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| posts | id, author_id, content, post_type, created_at, is_pinned | Feed content |
| users | id, name, avatar, handle | Author display |
| follows | follower_id, followed_id | Who user follows |
| course_follows | user_id, course_id | Course subscriptions |
| post_interactions | post_id, type, count | Like/bookmark counts |
| (Stream API) | feed data | External feed service |

**Note:** Feed is powered by Stream.io (per CD-008, tech-002)

---

## Features

### Feed Display
- [ ] Infinite scroll of posts `[US-S025]`
- [ ] Author avatar, name, handle, timestamp on each post `[US-S025]`
- [ ] Post content with mentions and links `[US-S025]`
- [ ] Post type badge (General, Question, Teaching tip, etc.) `[US-S025]`
- [ ] Pinned posts at top (from moderators) `[US-S025]`
- [ ] Reply thread preview `[US-S039]`

### Engagement Actions
- [ ] Like button + count `[US-S037]`
- [ ] Reply button + count `[US-S039]`
- [ ] Repost button + count `[US-S040]`
- [ ] Bookmark button `[US-S038]`
- [ ] Share button `[US-S025]`
- [ ] Flag content action `[US-S041]`

### Post Composer
- [ ] Avatar of current user `[US-S025]`
- [ ] Text input: "What's on your mind?" `[US-S025]`
- [ ] Post type selector (General, Question, Teaching tip, Availability) `[US-S025]`
- [ ] "Post" button `[US-S025]`

### Feed Tabs
- [ ] "For You" tab (algorithmic) `[US-S036]`
- [ ] "Following" tab `[US-S025]`
- [ ] "Courses" tab `[US-S025]`

### Sidebar (Desktop)
- [ ] Suggested follows (users/creators) `[US-S025]`
- [ ] Trending topics/hashtags `[US-S025]`
- [ ] Upcoming sessions reminder `[US-S025]`
- [ ] Who to follow (STs from enrolled courses) `[US-S025]`

---

## Sections (from Plan)

### Header
- Page title: "Community" or "Your Feed"
- Feed type tabs (optional): "For You" / "Following" / "Courses"

### Post Composer
- Avatar + text input
- Post type selector
- Post button

### Feed
- Infinite scroll post cards
- Each post: author info, content, engagement bar
- Reply previews

### Sidebar (Desktop)
| Section | Content |
|---------|---------|
| Suggested Follows | Users/creators based on interests |
| Trending Topics | Popular hashtags |
| Upcoming Sessions | Next session reminder |

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/stream/token` | POST | Get Stream.io user token | 📋 |
| `/api/posts` | POST | Create post | 📋 |
| `/api/posts/:id/flag` | POST | Flag content | 📋 |

**Stream.io Token Response:**
```typescript
POST /api/stream/token
{
  token: "eyJ...",           // Stream user token (JWT)
  user_id: "user_123",       // Stream user ID (our user.id)
  api_key: "xxx..."          // Stream public API key
}
```

**Feed Architecture (5 Feed Types):**
```
1. townhall (flat)     → Public announcements, anyone can read
2. user (flat)         → Individual user's posts
3. course (flat)       → Per-course activity (gated by enrollment)
4. instructor (flat)   → Per-instructor posts (gated by purchase)
5. notification (nf)   → User's notification feed

Feed Groups:
- timeline:user_123    → User's aggregated feed (follows)
- townhall:main        → Platform-wide feed
- course:course_456    → Course-specific feed
- instructor:user_789  → Instructor-specific feed
```

**Client-Side Stream Integration:**
```javascript
// On page load:
const tokenResponse = await fetch('/api/stream/token');
const { token, user_id, api_key } = await tokenResponse.json();

// Initialize Stream client:
const client = stream.connect(api_key, token, app_id);

// Get user's timeline feed:
const feed = client.feed('timeline', user_id);

// Subscribe to real-time updates:
feed.subscribe((data) => {
  updateFeed(data.new);
});

// Fetch initial activities:
const activities = await feed.get({ limit: 25 });
```

**Post Creation Flow:**
```
1. User types post in composer
2. POST /api/posts {
     content: "Hello world",
     feed_type: "user" | "course" | "instructor",
     feed_id: "course_123" (if course/instructor)
   }
3. Backend:
   - Validates permissions (enrollment for course feeds)
   - Stores in posts table
   - Publishes to Stream via server-side SDK
4. Stream fans out to followers
5. Real-time update appears for subscribers
```

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Algorithmic feed of followed content |
| Empty | No follows, show suggestions |
| Filtered | Viewing specific category (courses, following) |
| Composing | Post composer expanded |
| Loading | Skeleton posts while fetching |

---

## Error Handling

| Error | Display |
|-------|---------|
| Feed load fails | "Unable to load feed. [Retry]" |
| Post fails | "Unable to post. Please try again." |
| Like/action fails | Toast: "Action failed. Try again." |

---

## Mobile Considerations

- Full-width post cards
- Floating compose button (FAB)
- Hide sidebar, move to bottom sheet
- Pull-to-refresh
- Infinite scroll with loading indicator

---

## Implementation Notes

- **Stream.io integration:** Feed infrastructure via GetStream (CD-008)
- CD-013: 5 feed types documented in tech-002-stream.md
- Token generated server-side, never expose API secret to client
- Consider "Mute" feature for noisy users
- Moderation: Flagged posts go to MODQ (Stream + our moderation)
- Real-time updates via Stream's WebSocket infrastructure
- Hybrid DB+Stream ensures data durability and fast delivery
