# Page: Community Feed

**Code:** FEED
**URL:** `/community` or `/feed`
**Access:** Authenticated
**Priority:** P0
**Status:** In Scope

---

## Purpose

X.com-style algorithmic feed showing posts from followed users, courses, and creators, enabling community engagement and content discovery.

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

| Target | Trigger | Notes |
|--------|---------|-------|
| PROF | Author name/avatar click | View poster's profile |
| CDET | Course mention click | View mentioned course |
| CPRO | Creator mention click | View creator profile |
| IFED | "View [Creator] Feed" | Instructor-specific feed |
| (Post Detail) | Post click | Expand post with replies |

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

## Sections

### Header
- Page title: "Community" or "Your Feed"
- Feed type tabs (optional): "For You" / "Following" / "Courses"

### Post Composer
- Avatar of current user
- Text input: "What's on your mind?"
- Post type selector (optional):
  - General post
  - Question (Q&A)
  - Teaching tip
  - Availability update
- Media attachment (future)
- "Post" button

### Feed
- Infinite scroll of posts
- Each post shows:
  - Author avatar, name, handle, timestamp
  - Post content (text, mentions, links)
  - Post type badge if applicable
  - Engagement bar:
    - Like button + count
    - Reply button + count
    - Repost button + count
    - Bookmark button
    - Share button
  - Reply thread preview (if replies)
- Pinned posts at top (from moderators)

### Sidebar (Desktop)
- **Suggested Follows:**
  - Users/creators to follow
  - Based on interests/courses
- **Trending Topics:**
  - Popular hashtags or themes
- **Upcoming Sessions:**
  - Next scheduled session reminder
- **Who to Follow:**
  - STs from enrolled courses

### Empty State
- New user with no follows: "Follow some creators to see posts here"
- Suggestions for who to follow

---

## User Stories Fulfilled

- US-S025: Access community feed
- US-P002: Platform provides community feed
- US-S036: View posts in algorithmic order
- US-S037: Like posts
- US-S038: Bookmark posts
- US-S039: Reply to posts
- US-S040: Repost content
- US-S041: Flag inappropriate content

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

## Mobile Considerations

- Full-width post cards
- Floating compose button (FAB)
- Hide sidebar, move to bottom sheet
- Pull-to-refresh
- Infinite scroll with loading indicator

---

## Error Handling

| Error | Display |
|-------|---------|
| Feed load fails | "Unable to load feed. [Retry]" |
| Post fails | "Unable to post. Please try again." |
| Like/action fails | Toast: "Action failed. Try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | feed_type |
| `post_created` | Post submitted | post_type, has_media |
| `post_liked` | Like clicked | post_id |
| `post_bookmarked` | Bookmark clicked | post_id |
| `post_replied` | Reply submitted | post_id |
| `post_reposted` | Repost clicked | post_id |
| `post_flagged` | Flag submitted | post_id, reason |
| `profile_clicked` | Author clicked | user_id |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `POST /api/stream/token` | Page load | Get Stream.io user token |
| `POST /api/posts` | Create post | Store in DB + publish to Stream |
| `POST /api/posts/:id/flag` | Flag content | Record flag + Stream moderation |

### Stream.io Token Generation

```typescript
// POST /api/stream/token
// Request: (authenticated user from session)
// Response:
{
  token: "eyJ...",           // Stream user token (JWT)
  user_id: "user_123",       // Stream user ID (our user.id)
  api_key: "xxx..."          // Stream public API key
}

// Backend generates token:
const token = streamClient.createUserToken(user.id);

// Token permissions:
// - Read feeds user follows
// - Read townhall feed
// - Post to allowed feeds
// - React to posts (like, bookmark)
```

### Feed Architecture (5 Feed Types)

```
Per tech-002-stream.md:

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

### Client-Side Stream Integration

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
  // New activity arrived
  updateFeed(data.new);
});

// Fetch initial activities:
const activities = await feed.get({ limit: 25 });
```

### Post Creation Flow

```
Create Post:
  1. User types post in composer
  2. POST /api/posts {
       content: "Hello world",
       feed_type: "user" | "course" | "instructor",
       feed_id: "course_123" (if course/instructor)
     }
  3. Backend:
     - Validates permissions (enrollment for course feeds)
     - Stores in posts table
     - Publishes to Stream via server-side SDK:
       streamClient.feed(feed_type, feed_id).addActivity({
         actor: user_id,
         verb: 'post',
         object: `post:${post.id}`,
         foreign_id: `post:${post.id}`,
         ...metadata
       })
  4. Stream fans out to followers
  5. Real-time update appears for subscribers
```

### Feed Access Control (Server-Side Gating)

```typescript
// When generating token, set feed permissions:
// This is done via Stream's permission system OR
// our backend validates before issuing token

// Approach: Custom backend validation
POST /api/stream/token {
  requested_feeds: ['course:123', 'instructor:456']
}

// Backend checks:
for each feed in requested_feeds:
  if feed.startsWith('course:'):
    courseId = extractId(feed)
    if not isEnrolled(user, courseId):
      remove from allowed feeds
  if feed.startsWith('instructor:'):
    instructorId = extractId(feed)
    if not hasPurchased(user, instructorId):
      remove from allowed feeds

// Token includes only allowed feeds
```

### Real-Time Updates

```
Stream handles real-time via:
- WebSocket connection from client
- Automatic fanout to followers
- Instant delivery to subscribed clients

Events:
- new: New activity added
- deleted: Activity removed
- updated: Activity edited

No need to poll - Stream pushes updates.
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   FEED      │      │  PeerLoop   │      │  Stream.io  │
│   (Client)  │      │  (Server)   │      │  (Service)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ POST /stream/token │                    │
       │───────────────────>│                    │
       │                    │ Generate token     │
       │ { token, api_key } │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ stream.connect()                        │
       │─────────────────────────────────────────>
       │                    │                    │
       │ feed.subscribe()                        │
       │─────────────────────────────────────────>
       │                    │ (WebSocket)        │
       │<─────────────────────────────────────────
       │                    │                    │
       │ POST /api/posts    │                    │
       │───────────────────>│                    │
       │                    │ Store in DB        │
       │                    │ Publish to Stream  │
       │                    │───────────────────>│
       │ { post_id }        │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ (real-time update)                      │
       │<─────────────────────────────────────────
```

### Hybrid Architecture

```
Why we use both DB + Stream:

Posts Table (our DB):
- Source of truth for content
- Moderation actions
- Analytics
- Backup if Stream unavailable

Stream.io:
- Feed fanout (following/followers)
- Real-time delivery
- Ranking/algorithms
- Reactions (likes, bookmarks)

Sync Pattern:
- Write: POST /api/posts → DB → Stream
- Read: Stream (with fallback to DB)
- Delete: DELETE /api/posts → DB → Stream
```

---

## Notes

- **Stream.io integration:** Feed infrastructure via GetStream (CD-008)
- CD-013: 5 feed types documented in tech-002-stream.md
- Token generated server-side, never expose API secret to client
- Consider "Mute" feature for noisy users
- Moderation: Flagged posts go to MODQ (Stream + our moderation)
- Real-time updates via Stream's WebSocket infrastructure
- Hybrid DB+Stream ensures data durability and fast delivery
