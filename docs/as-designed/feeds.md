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
| **Feeds Discover** | `/feeds` | Public Matt discover destination — discovery grid + role-aware "Your Feeds" directory | `/api/feeds/discover` + `useCurrentUser().getFeeds()` + badge API |
| **Home Feed** | `/feed` | Aggregated timeline (all sources) | Stream.io timeline feed |
| **Community Feed** | `/community/[slug]` | Individual community feed | Stream.io community feed |
| **Course Discussion** | `/course/[slug]/feed` | Course discussion feed (creator opt-in) | Stream.io course feed |
| **The Commons** | `/community/the-commons` | Platform-wide townhall | Stream.io townhall feed |
| **My Communities** | `/community` | Communities hub (communities only) | Own API call |

### Navigation Links

- Matt DiscoverSlidePanel "Feeds" → `/feeds` (Conv 224; was `/discover/feeds`)
- MyFeeds dashboard card "See All" → `/feeds`
- `/community` hub "All Feeds" → `/feeds`
- Feeds Discover cards → individual feed pages

> **`/feeds` identity (Conv 224):** `/feeds` is the **public Matt discover destination** (auth-optional), a sibling of `/communities` + `/members`. It mounts `FeedsDiscoveryGrid` (discovery cards) + `FeedsDirectory` (role-aware "Your Feeds" directory, server-gated). It was removed from `PROTECTED_EXACT` in `src/middleware.ts`. The legacy auth-required **`FeedsHub` composite** (`src/components/feed/FeedsHub.tsx`) is *not* on `/feeds` — it is unmounted and destined for the `/` landing page per Matt (tracked as `[HOME-FEEDSHUB]`). The legacy `/old/feeds` page still self-guards.

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

> **D1 enum vs Stream group decoupled (SYS-RENAME, Conv 259):** The D1 `feed_type` enum value for the System/Commons feed was renamed `'townhall' → 'system'`, but the **Stream feed group stays `townhall`** (`townhall:main`) and the route path stays `/api/feeds/townhall` pending the cosmetic [SYS-NAMING] rename. They share the name but address different things — the D1 enum was renameable independently as long as all D1 sites agree. Stream group / route / `TownHallFeed` component / labels are unchanged.

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
  feed_type TEXT NOT NULL,        -- 'system' | 'community' | 'course'  (SYS-RENAME, Conv 259: 'townhall' → 'system')
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
-- 1:1 Stream-id invariant + the Promote endpoint's resolve-by-Stream-id lookup (Conv 269)
CREATE UNIQUE INDEX idx_feed_activities_stream ON feed_activities(stream_activity_id);
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

**Fire-and-forget:** `indexFeedActivity()` catches errors silently. A failed INSERT means a badge count is off by one, not a broken feature. The D1 index is supplementary — rebuildable from Stream. `indexFeedActivity()` returns the inserted row id. (Under promotion model ① it no longer takes a lineage param — promotion writes no target activity; see Promotion below.)

### Promotion (PROMOTE-PIPELINE, Conv 262–265)

Promotion escalates an existing post **up the feed chain** — `Course → Community → System`. It is free but gated behind a single shared admin-set password (one global password, entered per-promotion).

**Delivery model ① — reference lane (Conv 263–265).** Promoting does **not** copy the post or write a second Stream activity. It records **one** `post_promotions` row referencing the **canonical source** activity + the target feed; the original stays in place, and every higher-feed appearance is assembled at read time by the lane (`src/lib/promotion/lane.ts`). Engagement is never split across copies.

- **Target resolution** (`src/lib/promotion/target.ts`): a course's parent community is found via `courses.progression_id → progressions.community_id` (nullable — a course with no progression is not promotable); a community promotes to the System feed. D1 keys feeds by slug; Stream keys by id, so target resolution returns both keyings.
- **Permission** (`permissions.ts`): `canPromote` is a role matrix (admin / creator / certified teacher) — deliberately distinct from `canPost`, since promotion lets a promoter escalate INTO a feed they couldn't normally post to (notably the admin-only System feed). The shared password is the anti-spam control pre-payment.
- **Lineage storage**: the `post_promotions` event table is the sole durable home for each promotion (canonical source activity, promoter, from/to feeds) — for audit + future payment + the read-time lane JOIN. Under model ① there is no copied target activity, so no `feed_activities` lineage column (`promoted_from_activity_id` and `post_promotions.target_activity_id` were dropped in Conv 265).
- **Endpoints**: `POST /api/feeds/promote` (escalate, gated), `GET /api/feeds/promoted?feedType=&feedId=` (Promoted-lane read-side, community/course only — System is delivered via Announcements), `GET|POST /api/admin/promotion-password` (admin set/rotate/status; bcrypt hash in `platform_stats.promotion_gate_password_hash`). See [API-COMMUNITY.md](../reference/API-COMMUNITY.md) § Promotion + [API-ADMIN.md](../reference/API-ADMIN.md) § Promotion Password.
- **Module**: `src/lib/promotion/` (target / permissions / gate / promote / lane + barrel), mirroring the `src/lib/discovery-rails/` structure.

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
| `FeedsDirectory` | `src/components/feed/directory/FeedsDirectory.tsx` | `@matt-inspired` role-aware "Your Feeds" directory on `/feeds` (single self-contained island; folds legacy ExploreFeeds + FeedAllTab + FeedRoleTab) |
| `FeedsRoleTabs` | `src/components/feed/directory/FeedsRoleTabs.tsx` | Matt underline role-tab bar (controlled child of FeedsDirectory) |
| `FeedDirectoryCard` | `src/components/feed/directory/FeedDirectoryCard.tsx` | Feed card + prominent townhall variant |
| `FeedsDiscoveryGrid` | `src/components/feed/directory/FeedsDiscoveryGrid.tsx` | Discovery grid on `/feeds` (port of DiscoverFeedsGrid) |
| `FeedsHub` | `src/components/feed/FeedsHub.tsx` | Legacy full-page directory with badge counts — **unmounted**, destined for `/` landing (`[HOME-FEEDSHUB]`), no longer on `/feeds` |
| `MyFeeds` | `src/components/dashboard/MyFeeds.tsx` | Dashboard card showing feeds with badge dots |
| `FeedActivityCard` | `src/components/community/FeedActivityCard.tsx` | Individual activity card (interactive — reactions, comments). Used in native feeds (community/course/system). |
| `FeedPost` | `src/components/feed/FeedPost.tsx` | `@matt-inspired` **display-only** Activity→`SocialPost` adapter for the Home **aggregated** feed (Conv 260). Non-interactive reaction/comment pills as social proof; embedded entity anchor below (CourseAnchor or CommunityAnchor) with direct CTA, plus "in {feed}" header link → source feed. Native-feed interactivity stays on `FeedActivityCard`. |
| `CommentSection` | `src/components/community/CommentSection.tsx` | Threaded comments with `commentsApiBasePath` prop |
| `CommunityFeed` | `src/components/community/CommunityFeed.tsx` | Community feed page component |
| `CourseFeed` | `src/components/community/CourseFeed.tsx` | Course discussion feed component |
| `TownHallFeed` | `src/components/community/TownHallFeed.tsx` | The Commons feed component |
| `SmartFeed` | `src/components/feed/SmartFeed.tsx` | Ranked smart feed (primary) — member posts (`FeedActivityCard`) + discovery sample-posts (`FeedPost` + embedded entity anchor, FEED-U2) with a dismiss wrapper |
| `DiscoveryCard` | `src/components/feed/DiscoveryCard.tsx` | Preview card for non-member public feeds (CTA + dismiss). **Orphaned since FEED-U2 (Conv 273)** — SmartFeed now uses `FeedPost`+anchor; kept pending client-vet, slated for cleanup |
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

1. **Member posts** — ranked posts from feeds the user belongs to (communities, courses). Since SYS-RENAME (Conv 259) the System community (`is_system=1`) is **excluded** from member candidates (`candidates.ts` filters `is_system=0`) — the System feed is admin-only.
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
├── candidates.ts      ← D1 queries for member candidates (discovery path `getDiscoveryCandidates` removed Conv 273)
├── scoring.ts         ← Scoring algorithm (stable interface, swappable internals)
├── enrichment.ts      ← Stream batch fetch + `fetchDiscoveryAnchors` (anchor metadata onto sample-post discoveryContext, Conv 273)
├── discovery.ts       ← Access checks, vitality, dismiss filtering
├── marketing.ts       ← getMarketingCandidates: de-personalized sample-posts + rails-backed cards (HOME-FEED-MERGE, Conv 266)
├── cta.ts             ← buildDiscoveryCtaUrl: visitor→/signup?redirect= vs authed→entity (HOME-FEED-MERGE Phase 6, Conv 268)
└── index.ts           ← Orchestrator
```

> **HOME-FEED-MERGE rework (Conv 266–268):** Phases 1–2 reworked the orchestrator into a unified 3-kind stream (`member-post` / `sample-post` / `suggestion-card`) with an opaque `(created_at,id)` cursor (oldest-backbone floor). The orchestrator now calls `getMarketingCandidates` (`marketing.ts`) instead of `getDiscoveryCandidates` (removed in Conv 273 — see FEED-U2 note below). **Phase 3 (Conv 267) un-gated `/api/feeds/smart`** — it is now **auth-aware, not 401-gated**: a visitor gets the de-personalized marketing backbone (member path empty without a session = gated by data). The real Discovery Rails blob is wired in via the shared two-tier reader `src/lib/discovery-rails/serve.ts` (`loadDiscoveryRailsBlob`, KV-read with compute fallback; a rails failure degrades to no cards). Caching varies on session presence — visitor `public, max-age=60` + `Vary: Cookie`, authed `private, no-store`. **Phase 4 (Conv 267)** then taught the client (`SmartFeed.tsx`) to render all 3 kinds via a `kind`-discriminated union — member-post (`FeedActivityCard`, interactive) · sample-post (`DiscoveryCard`) · **suggestion-card (new `SuggestionCard.tsx`** entity card) — plus a "caught up → discover" boundary card; the endpoint **no longer filters cards** (full unified stream served). **Phase 5 (Conv 267)** recomposed Home (`/`) as the merged feed-leads surface (`SmartFeed` mounted; hero/quick-start/FeedsHubPanel/TriageStrip removed, nudges kept; auth-conditional visitor chrome + new `StickySignupBar.astro`) and changed the `/feed` visitor redirect `/login` → `/` (member-only route; visitors land on the public Home feed). **Phase 6 (Conv 268)** made the discovery CTAs intent-preserving: the server-built `ctaUrl` now branches on viewer auth via the shared `cta.ts` `buildDiscoveryCtaUrl` helper (threaded as `viewerAuthenticated = Boolean(userId)` from `index.ts` into both `cardToItem` suggestion-cards and `enrichment.ts` sample-post `discoveryContext`) — a visitor gets `/signup?redirect=<entity>` (intent carried via `signup.astro → AutoOpenAuthModal → handleAuthSuccess` round-trip; `?via=` preserved inside), an authed viewer gets the direct entity link. Branching lives server-side (cards stay prop-less; visitor `ctaUrl` is identical for all visitors so caching stays valid). Destination-level intent only (no auto-perform). All build phases (1–7) complete. **Conv 270 close** added the residual visitor polish: (a) `/api/feeds/smart` now returns a **top-level `viewerAuthenticated` boolean** (constant `false` for visitors) which the prop-less `SmartFeed` island reads to hide member-only filter tabs + show discovery-framed copy — extending the Phase-6 server-knows-auth pattern from `ctaUrl` to client chrome without a first-paint `localStorage` guess; (b) `DiscoveryCard` restyled to Matt tokens with a ghost `outlined` Button CTA (ctaUrl preserved); (c) `StickySignupBar` mobile stack→row; (d) participation gating reached the UI — `FeedActivityCard` gained a `canParticipate` prop (default `true`), threaded from `CommunityFeed` as `canParticipate={canPost}`; when `false` the react/comment action row is replaced by a "Join to participate" link to the source entity (`deriveJoinUrl`: course→`/course/{slug}`, community→`/community/{slug}`, System→hidden), turning the posture-A 403 (Conv 264) into a flywheel conversion. The Matt `FeedPost` teaser restyle (full FeedPost+CommunityAnchor migration) remains deferred to `[RECO-UNIFY]` / `[COMMUNITY-ANCHOR]`. Full build-phase tracking lives in `plan/home-feed-merge/README.md`. **FEED-U2 (Conv 273)** then landed the deferred migration: `SmartFeed` now renders sample-posts through `FeedPost` (display-only) with a real **entity anchor** embedded below — `CourseAnchor` for courses, new `CommunityAnchor.tsx` (`src/components/entity/`, `@matt-inspired`, neutral palette, members + 14-day-vitality chips, primary Join CTA) for communities — replacing the prior `DiscoveryCard`-only render. Anchor metadata is threaded server-side: `enrichment.ts` `fetchDiscoveryAnchors` populates `discoveryContext.anchor` (course → creator via `creator_id`→`users`, level, formatted `X.X (N reviews)` rating sourced from `courses.rating`/`rating_count`, hidden at 0 reviews; community → icon, member_count, 14-day vitality) — no `/api/feeds/smart` contract change. Dismiss is preserved via a `SmartFeed` wrapper (`/api/feeds/smart/dismiss`). `getDiscoveryCandidates` (`candidates.ts`) and `FeedsHubPanel.tsx` were removed as orphans; `DiscoveryCard.tsx` is now orphaned (kept pending client-vet, slated for cleanup).

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
| `tests/lib/promotion.test.ts` | Unit | 19 | `resolvePromotionTarget`, `canPromote` role matrix, bcrypt password gate, `recordPromotion` (PROMOTE-PIPELINE) |
| `tests/lib/promotion-lane.test.ts` | Unit | 5 | `getPromotedActivities` Promoted-lane read-side (PROMOTE-PIPELINE) |
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
