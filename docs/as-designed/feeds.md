# Feeds Architecture

**Status:** Phase 1 Complete
**Created:** 2026-03-19 (Conv 016)
**Related:** `docs/reference/stream.md`, `PLAN.md` (FEEDS-HUB, FEED-INTEL blocks)

---

## Overview

Feeds are a primary learning surface (~50% of learning per client directive). Students take courses for focused learning but ask questions and get answers in feeds. The feed system combines Stream.io for content storage with a D1 metadata index for cross-feed navigation queries.

---

## Feed Surfaces

| Surface | URL | Purpose | Data Source |
|---------|-----|---------|-------------|
| **Feeds Hub** | `/feeds` | Feed directory — choose where to post/browse | `useCurrentUser().getFeeds()` + badge API |
| **Home Feed** | `/feed` | Aggregated timeline (all sources) | Stream.io timeline feed |
| **Community Feed** | `/community/[slug]` | Individual community feed | Stream.io community feed |
| **Course Discussion** | `/course/[slug]/feed` | Course discussion feed (creator opt-in) | Stream.io course feed |
| **The Commons** | `/community/the-commons` | Platform-wide townhall | Stream.io townhall feed |
| **My Communities** | `/community` | Communities hub (communities only) | Own API call |

### Navigation Links

- Navbar "My Feeds" → `/feeds`
- MyFeeds dashboard card "See All" → `/feeds`
- `/community` hub "All Feeds" → `/feeds`
- FeedsHub cards → individual feed pages

---

## Content Storage: Stream.io

Stream.io is the durable content store for all feed activity (posts, reactions, comments, threading). See `docs/reference/stream.md` for Stream-specific API details, SDK setup, and caveats.

### Stream Data Model

Stream has two fundamentally different data types:

**Activities** are top-level posts. When someone writes "Can anyone help with React hooks?" in The Commons, that's an activity. Activities live **in a specific feed** (e.g., `townhall:main`, `community:python-devs`). They're added via `feed.addActivity()` and retrieved via `feed.get()`.

**Reactions** are everything else — comments, replies to comments, likes, love, celebrate. Reactions are **attached to an activity by its ID**, not stored in the feed. This is a critical distinction:

```
Activity "abc123" (lives in community:python-devs)
  ├── Reaction {kind: "like", user_id: "guy"}
  ├── Reaction {kind: "comment", id: "r1", data: {text: "Try useCallback..."}}
  │     └── Child Reaction {kind: "comment", parent: "r1", data: {text: "Thanks!"}}
  └── Reaction {kind: "celebrate", user_id: "alice"}
```

- **Comments** are reactions with `kind: 'comment'` and `data: {text: "..."}`.
- **Replies to comments** are **child reactions** — a reaction whose `parent` field points to another reaction's ID. Stream supports up to 3 levels of nesting.
- **Likes/love/celebrate** are reactions with the appropriate `kind` and no data payload.
- **Reactions are global** — they're keyed by activity ID, not by feed. A like on a post is the same object regardless of which feed surface the user is viewing it from.

When fetching a feed, `withReactionCounts: true` returns aggregate counts per activity (`{like: 3, comment: 5}`), and `withOwnReactions: true` tells you which reactions the current user has already made (for toggling filled/empty icons in the UI).

```
Stream.io
├── Feeds (organized by group:id)
│   ├── townhall:main          → [Activity, Activity, ...]
│   ├── community:python-devs  → [Activity, Activity, ...]
│   ├── course:react-101       → [Activity, Activity, ...]
│   └── timeline:user-david    → [aggregated from followed feeds]
│
└── Reactions (global, keyed by activity ID)
    ├── activity "abc123" → [like, like, comment, comment-reply, celebrate]
    └── activity "def456" → [comment, like]
```

This architecture means Stream excels at within-feed operations but **cannot answer cross-feed questions** like "how many new posts across all of David's 8 feeds since he last visited each one?" — which is why the D1 activity index exists (see below).

### Feed Groups (configured in Stream Dashboard)

| Group | Purpose | Example Feeds |
|-------|---------|---------------|
| `townhall` | System community feeds | `townhall:main` (The Commons) |
| `community` | User communities | `community:{communityId}` |
| `course` | Course discussions | `course:{courseId}` |
| `timeline` | Aggregated home feed | `timeline:{userId}` |
| `notification` | User notifications | `notification:{userId}` |

### API Endpoints (Stream-backed)

| Endpoint | Methods | Purpose |
|----------|---------|---------|
| `/api/feeds/townhall` | GET, POST | The Commons feed |
| `/api/feeds/community/[slug]` | GET, POST | Community feeds |
| `/api/feeds/course/[slug]` | GET, POST | Course discussion feeds |
| `/api/feeds/timeline` | GET | Home feed (aggregated) |
| `/api/feeds/townhall/comments` | GET, POST, DELETE | Townhall comments |
| `/api/feeds/townhall/reactions` | POST, DELETE | Townhall reactions |
| `/api/feeds/community/[slug]/comments` | GET, POST, DELETE | Community comments |
| `/api/feeds/community/[slug]/reactions` | POST, DELETE | Community reactions |
| `/api/feeds/course/[slug]/comments` | GET, POST, DELETE | Course discussion comments |
| `/api/feeds/course/[slug]/reactions` | POST, DELETE | Course discussion reactions |
| `/api/stream/token` | GET | Client-side Stream JWT |

### Edge Compatibility

The Stream.io Node.js SDK is incompatible with Cloudflare Workers. `src/lib/stream.ts` implements a custom REST API client with JWT generation that runs on the edge.

---

## Activity Index: CQRS with D1

### Problem

Stream.io flat feeds are a chronological append log. They cannot answer:
- "How many new posts since this user last visited?"
- "Show recent activity across ALL my feeds ranked by relevance"
- "Count unread items per feed in a single query"

Stream's flat feeds don't support unread/unseen tracking (only notification feeds do), activity count since a timestamp, cross-feed aggregation, or server-side date filtering on ranked feeds.

### Solution: Stream as write model, D1 as read model

Stream stores content durably. D1 gets a thin metadata index (~150 bytes/row) that answers navigation questions: "what happened since I last looked?"

### Schema

```sql
-- When did user last visit each feed?
CREATE TABLE feed_visits (
  user_id TEXT NOT NULL REFERENCES users(id),
  feed_type TEXT NOT NULL,        -- 'townhall' | 'community' | 'course'
  feed_id TEXT NOT NULL,          -- community slug or course slug
  last_visited_at TEXT NOT NULL,  -- ISO timestamp
  PRIMARY KEY (user_id, feed_type, feed_id)
);

-- Lightweight index of recent feed activity (content stays in Stream)
CREATE TABLE feed_activities (
  id TEXT PRIMARY KEY,
  feed_type TEXT NOT NULL,
  feed_id TEXT NOT NULL,
  actor_id TEXT NOT NULL REFERENCES users(id),
  activity_type TEXT NOT NULL,     -- 'post' | 'reply'
  stream_activity_id TEXT,         -- links back to Stream for full content
  created_at TEXT NOT NULL
);
CREATE INDEX idx_feed_activities_feed ON feed_activities(feed_type, feed_id, created_at);
CREATE INDEX idx_feed_activities_created ON feed_activities(created_at);
```

### How It Works

**Post/comment creation (write-time indexing):**
1. Existing: call `stream.addActivity()` → content stored in Stream
2. New: INSERT one row into `feed_activities` → index updated
3. No polling needed — every post flows through our API endpoints

**Badge counts on `/feeds` hub:**
```sql
SELECT fa.feed_type, fa.feed_id, COUNT(*) as new_count
FROM feed_activities fa
LEFT JOIN feed_visits fv
  ON fa.feed_type = fv.feed_type AND fa.feed_id = fv.feed_id AND fv.user_id = ?
WHERE (fa.feed_type, fa.feed_id) IN (VALUES (?, ?), ...)
  AND fa.created_at > COALESCE(fv.last_visited_at, '1970-01-01')
GROUP BY fa.feed_type, fa.feed_id
```
Single D1 query, zero Stream API calls.

**Feed visit (badge clearing):**
1. User navigates to `/community/python-devs`
2. Upsert `feed_visits` with `last_visited_at = NOW()` (only on offset=0, not pagination)
3. Badge clears on next `/feeds` hub load

### Dual-Write Implementation

The `indexFeedActivity()` function in `src/lib/feed-activity.ts` is called after every successful Stream write:

| Endpoint | Activity Type | Feed Context |
|----------|--------------|--------------|
| `POST /api/feeds/townhall` | `post` | `townhall:the-commons` |
| `POST /api/feeds/community/[slug]` | `post` | `{community\|townhall}:{slug}` (based on `is_system`) |
| `POST /api/feeds/course/[slug]` | `post` | `course:{slug}` |
| `POST /api/feeds/townhall/comments` | `reply` | `townhall:the-commons` |
| `POST /api/feeds/community/[slug]/comments` | `reply` | `{community\|townhall}:{slug}` |
| `POST /api/feeds/course/[slug]/comments` | `reply` | `course:{slug}` |

**Fire-and-forget:** `indexFeedActivity()` catches errors silently. A failed INSERT means a badge count is off by one, not a broken feature. The D1 index is supplementary — rebuildable from Stream.

### Badge API

`GET /api/me/feed-badges` — server-side endpoint that:
1. Queries the user's community memberships and course enrollments
2. Calls `getFeedBadgeCounts()` with the full feed list
3. Returns `{ badges: { "feedType:feedId": count } }`

### Visit Recording

Feed GET endpoints (community, course, townhall) call `recordFeedVisit()` on offset=0 only. Pagination scroll does not reset the badge — only the first page load does.

---

## UI Components

| Component | Location | Purpose |
|-----------|----------|---------|
| `FeedsHub` | `src/components/feed/FeedsHub.tsx` | Full-page `/feeds` directory with badge counts |
| `MyFeeds` | `src/components/dashboard/MyFeeds.tsx` | Dashboard card showing feeds with badge dots |
| `FeedActivityCard` | `src/components/community/FeedActivityCard.tsx` | Individual activity card (reactions, comments) |
| `CommentSection` | `src/components/community/CommentSection.tsx` | Threaded comments with `commentsApiBasePath` prop |
| `CommunityFeed` | `src/components/community/CommunityFeed.tsx` | Community feed page component |
| `CourseFeed` | `src/components/community/CourseFeed.tsx` | Course discussion feed component |
| `TownHallFeed` | `src/components/community/TownHallFeed.tsx` | The Commons feed component |
| `SmartFeed` | `src/components/feed/SmartFeed.tsx` | Ranked smart feed — member posts + discovery cards (primary) |
| `DiscoveryCard` | `src/components/feed/DiscoveryCard.tsx` | Preview card for non-member public feeds (CTA + dismiss) |
| `HomeFeed` | `src/components/feed/HomeFeed.tsx` | Chronological timeline (deprecated — replaced by SmartFeed) |

---

## Data Lifecycle

- **Retention:** Future pruning cron for `feed_activities` (retention period TBD — observing real data growth first)
- **Pruning is safe:** D1 index is metadata only. Thread content lives in Stream forever. A pruned row just means an old post won't count as "new" (correct behavior).
- **Replies to old posts:** A reply is a new `feed_activities` row (fresh timestamp). Parent post fetched from Stream when user opens the thread.
- **D1 storage at Genesis scale:** ~80 users x ~10 posts/day x 150 bytes = ~45KB/month. Negligible.
- **Rebuild:** If D1 index is lost, rebuildable from Stream (fetch recent activities per feed). No data loss scenario.

---

## SMART-FEED: Ranked Feed with Discovery (FEED-INTEL Phases 2-3)

**Status:** Designed (Conv 017), ready to build
**Full spec:** See PLAN.md → SMART-FEED block

### Overview

SMART-FEED replaces the chronological home timeline (`/feed`) with a ranked, personalized feed. It combines two content streams:

1. **Member posts** — ranked posts from feeds the user belongs to (communities, courses, townhall)
2. **Discovery posts** — preview cards from public feeds the user hasn't joined, matched by tag-overlap scoring

This drives the flywheel: visibility → engagement → enrollment → teaching.

### Architecture: Hybrid Ranking

**Conv 017 verification correction:** D1 does simple candidate selection (proven tuple-matching pattern), app code loads relationship metadata in parallel and scores in TypeScript, Stream provides engagement data. No complex multi-table JOINs in SQL.

1. **D1 selects candidates** — simple query on `feed_activities` with `feed_visits` LEFT JOIN for unseen flag. Uses tuple-matching `(feed_type, feed_id) IN (VALUES ...)` pattern from `getFeedBadgeCounts()`. Returns ~100 raw candidates (over-fetch for scoring headroom).
2. **App scores candidates** — loads relationship metadata (teacher certs, creators, shared communities, topic interests, feed affinity) via 4-5 parallel D1 queries. Scores each candidate in TypeScript using `platform_stats` weights.
3. **Stream enriches content** — batch fetch via `GET /enrich/activities/?ids=...` with reaction counts. Single HTTP call. Merges engagement signal into scores, re-ranks.
4. **Server assembles response** — applies feed diversity cap, interleaves discovery cards, trims to limit, computes cursor.

### Scoring Signals

| Signal | Source | Purpose |
|--------|--------|---------|
| Recency | D1 `created_at` | Time decay — recent posts rank higher |
| Relationship | App-side (parallel D1 metadata queries) | Teacher/creator posts boosted |
| Unseen | D1 `feed_visits` | Posts since last visit get priority |
| Engagement | Stream `reaction_counts` | Social proof — popular posts surface |
| Tag overlap | `user_tags` → `course_tags` via `tags.topic_id` | Graduated weighted overlap with topic affinity bonus |
| Feed affinity | D1 `feed_activities` GROUP BY actor | User's posting frequency per feed |
| Topic affinity | Feed → course/community → course_tags → tags.topic_id | Activity in related topics (derived from tags) |
| Feed vitality | D1 recent activity count | Dead feeds excluded from discovery |

All weights stored in `platform_stats` as tunable parameters. Algorithm isolated in `src/lib/smart-feed/scoring.ts` — swappable without changing the rest of the pipeline.

#### Scoring Parameters (Admin-tunable via `platform_stats`)

| Key | Default | Description |
|-----|---------|-------------|
| `smart_feed_weight_recency` | 0.30 | Weight for time decay (exponential, half-life = `decay_hours`) |
| `smart_feed_weight_relationship` | 0.25 | Weight for teacher/creator/peer signal |
| `smart_feed_weight_unseen` | 0.15 | Weight for posts since last feed visit |
| `smart_feed_weight_engagement` | 0.10 | Weight for reaction/comment counts (from Stream) |
| `smart_feed_weight_tag_affinity` | 0.10 | Weight for graduated tag-overlap scoring (replaces topic_match + category_affinity) |
| `smart_feed_weight_feed_affinity` | 0.05 | Weight for user's posting frequency in the feed |
| `smart_feed_decay_hours` | 72 | Recency half-life in hours |
| `smart_feed_candidate_limit` | 100 | Max D1 candidates per query |
| `smart_feed_diversity_cap` | 3 | Max posts from a single feed per page |
| `smart_feed_discovery_frequency` | 7 | Insert 1 discovery card after every N member posts |
| `smart_feed_discovery_max` | 3 | Max discovery cards per page |

Discovery cards use different weights: engagement 0.40, tag affinity 0.25, recency 0.15, feed vitality 0.10 (relationship/unseen/feed affinity ignored).

### Discovery Cards

Discovery surfaces content from public feeds the user hasn't joined:

- **Public communities** (`is_public = 1`, user not a member)
- **Public course feeds** (`discussion_feed_enabled = 1`, `feed_public = 1`, user not enrolled/teaching/creating)
- **Preview only** — truncated text, engagement counts visible, no reactions/comments until membership
- **CTA** — "Join Community" or "View Course"
- **Dismissable** — "Not Interested" suppresses that feed via `smart_feed_dismissals` table
- **Interleaved** — max 2-3 per page, inserted after every ~7 regular posts

### Module Structure

```
src/lib/smart-feed/
├── candidates.ts      ← D1 queries for member + discovery candidates
├── scoring.ts         ← Scoring algorithm (stable interface, swappable internals)
├── enrichment.ts      ← Stream batch fetch
├── discovery.ts       ← Access checks, vitality, dismiss filtering
└── index.ts           ← Orchestrator
```

### API

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/feeds/smart` | GET | Smart feed — ranked member posts + discovery cards |
| `/api/feeds/smart/dismiss` | POST | Dismiss a discovery feed |

### Schema Additions

- `smart_feed_dismissals` table (user_id, feed_type, feed_id, dismissed_at)
- `courses.feed_public` column (INTEGER DEFAULT 1) — controls discovery visibility
- `platform_stats` rows for scoring parameters (~10-15 keys)

### Deferred Capabilities

Not in scope for initial SMART-FEED but unlocked by the architecture:

- **Engagement analytics:** Posting patterns, peak hours, most active feeds from `feed_activities`
- **Real-time badges via SSE:** Push badge updates instead of polling
- **Semantic topic matching:** Embedding-based similarity (requires vector store or external API)

---

## Test Coverage

| Test File | Type | Tests | What It Covers |
|-----------|------|-------|----------------|
| `tests/lib/feed-activity.test.ts` | Unit | 11 | `indexFeedActivity`, `recordFeedVisit`, `getFeedBadgeCounts` |
| `tests/api/me/feed-badges.test.ts` | Integration | 7 | HTTP endpoint with auth, community/course/townhall badge counts, visit clearing |
| `e2e/feeds-hub.spec.ts` | E2E | 6 | `/feeds` page rendering, search, navigation links |
| `e2e/my-feeds-card.spec.ts` | E2E | 4 | MyFeeds dashboard card on all dashboards |
| `e2e/feed-badges.spec.ts` | E2E | 2 | Badge display after posting, badge clearing after visit |

---

## Comment & Reaction Routing

`FeedActivityCard` derives the correct API base path from activity metadata via `deriveFeedApiBasePath()`:
- Activity has `communitySlug` → `/api/feeds/community/{slug}`
- Activity has `courseSlug` (no `communitySlug`) → `/api/feeds/course/{slug}`
- Neither → `/api/feeds/townhall`

This ensures comments and reactions from any surface (including the aggregated home timeline at `/feed`) route to the correct feed-specific endpoint and trigger the correct dual-write. Components can still override with an explicit `feedApiBasePath` prop if needed.

---

## Card Visual System (Conv 020)

`FeedActivityCard` visually differentiates cards by source type using color and imagery:

### Source-Type Colors

| Source | Detection | Background | Left Accent |
|--------|-----------|------------|-------------|
| **The Commons** (townhall) | `isSystemCommunity === true` or slug fallback | `bg-primary-50` | `border-l-4 border-l-primary-400` |
| **Community** | `communitySlug` present, not system | `bg-white` | `border-l-4 border-l-secondary-300` |
| **Course** | `courseSlug` present | `bg-indigo-50/50` | `border-l-4 border-l-indigo-400` |

Note: `indigo` is used for courses instead of `blue` because the project's custom `primary` is sky-blue — visually indistinguishable from standard Tailwind blue at light tint levels.

### Source Image Strip

Right-side vertical strip (`w-20`, `object-cover`, `rounded-r-lg`). Priority: course `thumbnail_url` > community `cover_image_url` > community `icon` (emoji in colored block) > nothing (strip not rendered).

### Activity Fields for Visual System

These optional fields are stored in Stream activities at creation time (Conv 020):

| Field | Source | Used For |
|-------|--------|----------|
| `courseThumbnailUrl` | `courses.thumbnail_url` | Right image strip (course posts) |
| `communityImageUrl` | `communities.cover_image_url` | Right image strip (community posts) |
| `communityIcon` | `communities.icon` | Emoji fallback strip |
| `isSystemCommunity` | `communities.is_system` | Townhall detection |
| `activityType` | `'post'` or `'reply'` | Reply indicator (future-ready) |
| `userHandle` | `users.handle` | Username → profile link |

Old activities lacking these fields degrade gracefully to slug-based source detection and no image strip.

### Navigation Links

When `showFeedLink` is true (Smart Feed context):
- Username links to `/@{handle}` (when `userHandle` available)
- Course badge links to `/course/{slug}`
- "in {feedLabel}" links to feed page
- "Visit feed" button in action bar links to feed page
