# HOME-FEED-MERGE — merge SmartFeed into Home + public/visitor feed mode

**Status:** 🗣️ DESIGN DISCUSSION (Conv 258) — deferring decisions; threads captured as we go. No code beyond the Sidebar removal yet.
**Task:** `[HOME-FEED-MERGE]` #30 · **Parent context:** ROLE-STUDIOS Home rework (was the Conv-256 "keep TriageStrip + merge /feed" note — now superseded by this).
**Code refs:** `src/pages/index.astro` (Home), `src/pages/feed.astro` (/feed), `src/components/feed/SmartFeed.tsx`, `src/lib/smart-feed/` (`index.ts` orchestrator, `candidates.ts`, `scoring.ts`, `enrichment.ts`), `src/pages/api/feeds/smart/index.ts` (401-gated), `src/components/Sidebar.tsx`.

---

## Client directive (Conv 258)
1. Merge the `/feed` (SmartFeed) content into Home (`/`).
2. Of existing Home content, keep **only the Nudges** — BOTH `OnboardingNudgeBanner` AND `ProgressionNudge` (user confirmed "both"). Remove `TriageStrip`, quick-start ActionCards, and the "Your Feeds"/Recent-Activity block.
3. `/feed` route is **kept** but **removed from the Sidebar** — ✅ DONE Conv 258 (mirrors the Conv-250 `/feeds` removal: route kept, link dropped). NAV + COLLAPSED_NAV both updated.
4. The feed should **not be auth-gated** — a visitor must see a real (marketing) feed. Primary purpose: **conversion hook / sign-up bait.**

## 🔴 Key finding (Conv 258) — the smart feed is 100% personalized
Naively un-gating `/api/feeds/smart` (passing a null user) yields an **empty feed** for visitors, not a public one. Every source in `getSmartFeed()` is keyed on the user:
- **Member posts** (`getMemberCandidates`) need the user's joined feeds → visitor `feedList=[]` → 0 posts.
- **Discovery** (`getDiscoveryCandidates`) is gated on `user_tags` (topic match) → visitor has no tags → `topic_id IN ()` → 0 candidates.
- **Scoring** (`loadScoringContext`) is all `userId`-keyed (teachers/creators/peers/tags/affinity) → no signal.

So a real visitor experience needs a **new de-personalized candidate path**, not a config flip. Public flags already exist to build from: `communities.is_public=1` (+ `is_archived=0`), `courses.feed_public=1` (+ `discussion_feed_enabled=1`, `is_active=1`), `feed_activities.created_at` (recency), and the existing 14-day **vitality** count pattern (trending).

---

## Architecture (agreed direction)
**Two aggregators, not one un-gated one:**
- **Member aggregator** = the existing SmartFeed = "the real feeds you're signed up to" (The Commons + your course feeds + your community feeds). **Stays auth-gated, unchanged.**
- **Marketing aggregator** = NEW = content from feeds you're **not** signed up to. Powers BOTH the visitor conversion hook AND the cold-start experience for brand-new signed-in users (whose member feed is still empty). "Feeds you don't belong to."

### 3 content sources for the Home aggregator
Each source is present-or-empty depending on viewer state; the interleaver must handle any being empty.

| Source | What it is | Selection key |
|--------|-----------|---------------|
| **1 — Your feeds** | posts from feeds you're in + The Commons | membership (communities/enrollments/taught/created) |
| **2 — Topic suggestions** | courses & communities matching your interests (+ sample posts from each) | `user_tags` (personalized) |
| **3 — Visitor samples** | de-personalized public courses/communities (+ sample posts) | generic public / trending |

### Who sees which sources
| Viewer | S1 (your feeds) | S2 (topic suggestions) | S3 (visitor samples) |
|--------|----|----|----|
| Visitor | — | — | ✅ everything |
| New signup, onboarded | — (no feeds yet) | ✅ (has tags) | backfill |
| New signup, skipped onboarding | — | — (no tags) | ✅ |
| Established user | ✅ backbone | ✅ spice | rarely |

### The gradient + backfill principle
The mix is **not** a fixed 1:1:1 — it's a gradient driven by how much higher-value content exists. A power user sees mostly S1 with occasional S2; a visitor sees pure S3; everyone in between slides along that curve. **S3 is a backfill, not a peer** of S2: S2 ("discovery for people we know something about") is strictly better than S3 ("discovery for people we know nothing about"), so S3 only fills space S1+S2 leave empty. This stops a generic "trending community" item from ever pushing down a real post from a feed you're actually in.

### Reuse
The existing engine already interleaves S1+S2 — `interleaveDiscovery` ("N member posts, then 1 discovery item, capped at M/page") + a diversity cap (1 per feed for discovery). We extend it: de-personalize S2 into the S3 fallback, and make it degrade gracefully when S1/S2 are empty.

---

## Presentation

### Card vs. sample-post (per discoverable entity — emit exactly ONE)
Driven by whether the entity has content to show:

| | Active feed (recent posts) | New / no posts |
|---|---|---|
| **Community** | sample **post** + **"Join"** CTA | suggestion **card** + "Join" |
| **Course** | sample **post** + **"Take Course"** CTA | suggestion **card** + "Take Course" |

- "Active" is a **recency** call, not "has ≥1 post" — a community whose newest post is 8 months old should be a **card** (sampling a stale post makes the platform look dead, the opposite of the goal). Use the existing 14-day vitality window (exact window TBD — 14d? 30d?).
- **One representative per entity** (diversity cap already enforces 1/feed for discovery) — no community appears as both a sample post and a card. Which post represents an active feed: **most-engaged** (Stream reaction/comment counts, already available via enrichment) beats freshest for conversion. (TBD)
- New render variant: **sample-post-with-CTA** — a member-post body wrapped with a "not joined" affordance. (Today the feed has only: member post, discovery card.)

### Framing — visible "you're missing this" (DECIDED Conv 258)
Lean into it: sample posts wear an open badge ("from [X] · not joined", "Happening in [X] →") + the Join/Take-Course CTA. This is both better bait AND the honest path (consistent with `@stand-in` / 404-honesty values — don't disguise non-member content as yours). Spend engagement data as social-proof fuel ("23 learners discussing this", "active today").

### One loud ask + a quiet stream (DECIDED Conv 258)
Per-post CTAs go **quiet** (small badge + low-key ghost/text CTA, not a filled block) — **one** repeatable treatment that works at any density (no quiet-when-dense / loud-when-sparse switching). Rarity makes it pop for an established user; a calm stream of them reads as browsable, not a wall of ads, for a visitor.

Because the per-post asks are quiet, the **conversion pressure is concentrated in ONE loud slot**, swapped by auth state:
- **Visitor:** a single **sticky bottom bar** (DECIDED Conv 258) — "Join Peerloop to follow these feeds…" — that rides the scroll over the quiet stream. The feed does the credibility work; one persistent thing asks. It's **page chrome** (Home mounts it when unauthenticated), NOT part of the feed island.
- **Signed-in:** that loud slot is the `ProgressionNudge` instead. Same position in the hierarchy, swapped by auth.

Discovery framing should be **its own, quieter visual language**, distinct from `ProgressionNudge` (which is rare + high-intent, with role-accent tints). Discovery is frequent + ambient → must not look the same.

### Sample-post CTA — keep, intent-preserving (DECIDED Conv 258 — option A)
A per-post Join/Take-Course CTA does two different jobs by viewer:
- **Authed:** performs the action (one-click join/enroll from discovery). Stays, unambiguous.
- **Visitor:** can't act → routes to signup. Kept **only because it carries intent**: "Take Course: X" → signup → **return them to X**. Captures the visitor at peak interest in a *specific* thing (highest-converting moment + instant cold-start), where the sticky bar is only the generic catch-all. Without intent-preservation the per-post CTAs would be N redundant copies of the sticky bar → rejected.
- **Dependency:** signup must accept a post-signup destination/action ("sign up, then join X / take Y"). This is the **same machinery `[VISITOR-GATING]` #31 builds** — the home feed's sample-post CTAs are its first consumer. Build them together / consistently.

---

## API / assembly architecture (proposed Conv 258)

**Recommendation: ONE auth-aware endpoint, server-side interleaving.** Keep a single `GET /api/feeds/smart` (drop the blanket 401); it returns one typed, paginated stream. The "two aggregators" are **internal modules**, not two HTTP endpoints:

- `getMemberCandidates` (existing) — runs only with a session; a visitor naturally yields `[]`. So the **member aggregator "stays gated" by data**, not by a 401 on the endpoint.
- `getMarketingCandidates` (NEW) — de-personalized public candidates (S3), + the topic-personalized discovery (S2) when a session/tags exist. Applies the card-vs-post (vitality) rule so candidates arrive **pre-typed**.

**Pipeline (server, in `getSmartFeed`):**
1. Resolve viewer = session or null.
2. Build candidates: S1 (member, authed-only) + S2 (topic, authed-with-tags) + S3 (marketing, always). Each item carries a `kind`: `member-post` | `sample-post` | `suggestion-card`, plus entity type (community/course) for the CTA.
3. Score: personalized for authed; recency × 14-day-vitality for marketing.
4. Enrich via Stream (engagement counts → social-proof on sample posts).
5. Interleave (extend `interleaveDiscovery`): S1 backbone + S2 injected at frequency, **S3 backfills S2 slots**; when S1 empty (visitor/cold-start) the stream IS the discovery items ranked.
6. Paginate (single cursor).

**Why one endpoint (not two):** interleaving + scoring + diversity already live server-side; one place owns the gradient/backfill. Two endpoints would force the established-user case to **merge two paginated streams client-side** (two cursors) — the classic painful path. The client stays a dumb prop-less island fetching one URL, just learning to render 3 `kind`s.

**Two wrinkles to design for:**
- **Pagination cursor.** Today's cursor = last *member* post's `time`. An all-discovery stream (visitor) has no member posts → needs a discovery-compatible cursor (offset- or rank-based). Must unify so one `?before=` works for both modes.
- **Caching.** The visitor stream is identical for all logged-out users → highly cacheable (edge/KV, short TTL) — important since visitors hit the public landing at volume. One auth-aware endpoint makes caching auth-varying; mitigate by caching only the visitor branch (vary on session presence) or memoizing marketing-candidate building. The cacheability edge is the **one** argument for a separate public `/api/feeds/marketing` endpoint (quick alt) — weigh later; not worth the client-merge cost up front.

### Cursor design (DECIDED Conv 258 — Option A)
**Reframe:** separate *what paginates* from *what's injected*.
- **Posts paginate** — member posts AND sample posts are both `feed_activities` rows with real `created_at`; chronologically orderable.
- **Cards don't** — a suggestion card represents a feed (no posts, ranked by vitality, no timestamp). Cards are **never** in the cursor: front-loaded, capped, injected per page.

**Two mechanics regardless of approach:**
- **Marketing posts use a GLOBAL chronological query**, not the per-feed-top-3 discovery shape: "recent posts across all public feeds the viewer isn't in, `ORDER BY created_at DESC`, per-feed diversity cap." (The per-feed-top-3 shape is for *suggesting feeds*, and doesn't paginate.)
- **Tiebreaker fix:** `WHERE (created_at, id) < (?, ?)` — `created_at < ?` alone skips/dupes on equal timestamps (common in seed/bulk data).

**DECISION = A (single timestamp, mode-selected backbone).** Backbone = member posts if the viewer has any, else marketing posts; cursor = one `(created_at,id)` into that backbone stream. Discovery (samples/cards) is injected front-loaded, NOT deeply paginated. A thin-member-feed user scrolls their member posts, then hits an explicit **"You're all caught up — discover more →" boundary card** (itself a conversion nudge) rather than silently sliding into strangers' posts. Visitors paginate the marketing-post backbone deeply (infinite scroll preserved).
- **Rejected for now: B (composite opaque cursor** `{m,k,c}`**)** — would blend member+marketing posts into one seamless infinite scroll with no boundary. The cursor is opaque to the client, so A→B is a server-only swap later if we ever want established users to habitually scroll past their own content into discovery. Not needed now.

**Client (`SmartFeed.tsx`):** unchanged fetch/cursor loop; add rendering for the 3 item `kind`s (member-post plain; sample-post = quiet badge + Join/Take-Course ghost CTA; suggestion-card = card + CTA). **Sticky sign-up bar is page-level** (Home mounts it when `!isAuthenticated`), not in the island.

---

## Home layout & S2 architecture (DECIDED Conv 258)

### S2 extraction = generalize, not rip-and-rebuild
The gated member feed becomes **pure S1** (your feeds only); **S2 + S3 collapse into one personalization-aware discovery builder.** S2 and S3 are the same concept ("feeds you're not in"), differing only by whether we can personalize:
- `getMemberCandidates` → S1, pure (no discovery cards interleaved into it anymore).
- `getMarketingCandidates` → **generalize the existing `getDiscoveryCandidates`** (it already does topic-match + per-feed fetch): personalization is a *parameter* — user+tags → prefer topic-matched (S2); no tags/visitor → generic public + new-entity announcements (S3). Emits posts-or-cards-or-announcements.

One discovery path, no redundancy (avoids today's risk of non-member content showing via both S2-in-feed and a parallel S3). Reuses the existing query chain. Lines up with the cursor decision: backbone = member posts (authed) or marketing posts (visitor/cold-start); generalized discovery feeds the injected layer either way.

### Layout: feed-leads, auth-conditional chrome
No big "Welcome to Peerloop" hero. The feed leads. Chrome swaps by auth.

**Authenticated stack:**
1. minimal `Home` breadcrumb (header-bar slot)
2. **loud slot** = `OnboardingNudgeBanner` (if not onboarded) / `ProgressionNudge` (if eligible)
3. feed (member backbone + injected discovery)

**Visitor stack:**
1. **thin orienting line** (DECIDED = option A) — one quiet sentence, e.g. "Peerloop — learn from peers, teach what you know." No CTA (so it doesn't compete with the sticky bar).
2. feed (marketing — the credibility/FOMO engine)
3. **sticky sign-up bar** (fixed bottom) = the one loud ask. Both nudges render null for visitors, so nothing up top competes with it.

### `/feed` route (DECIDED Conv 258 — option B)
**Keep `/feed` auth-only**; it reverts to its original meaning — the **personal** smart feed (focused, chrome-free, member content), for signed-in users arriving via deep-links/bookmarks/in-app links (it's off the Sidebar now). Home (`/`) is the **sole public marketing surface** — un-gating `/feed` too would duplicate content (SEO canonicalization mess) and require replicating Home's whole visitor chrome (sticky bar + orienting line) for no gain.
**Change from status quo:** an unauthenticated hit on `/feed` redirects to **`/`** (the public feed), NOT `/login?redirect=/feed` (a wall). A visitor who asked for "the feed" lands on the public feed, not a login gate. (Middleware `PROTECTED_EXACT` keeps `/feed`; just change the redirect target for the feed case, or special-case it.)

---

## Marketing candidate quality (DECIDED Conv 258)

**Signals are split across two stores** (shapes the pipeline into a 2-stage funnel):
- `feed_activities` (D1) is thin: `id, feed_type, feed_id, actor_id, activity_type ('post'|'reply'), stream_activity_id, created_at`. **Post text + engagement live in Stream** (via `stream_activity_id`).
- **D1 cheap pre-filter:** post-vs-reply, recency, publicness, actor, moderation state (`content_flags` + `moderation_actions` tables exist).
- **Stream enrichment rank/filter:** engagement (reaction/comment counts), substance (text length → drop empties), media.

**Hard filters (D1, non-negotiable):**
- `activity_type = 'post'` — **exclude replies** (biggest free quality lever; a reply has no standalone context for a stranger).
- Recency window (14d/30d — TBD).
- Public (`is_public`/`feed_public`) + not the viewer's joined feeds.
- **Not flagged** — join `content_flags`/`moderation_actions`; nothing pending/actioned reaches a logged-out first impression. Brand safety absolute.
- Diversity cap (1–2 per feed).

**Soft ranking (Stream enrichment):** engagement (social proof) + substance; optional minor actor-authority weight (creator/teacher posts read as showcase).

**SUPPLY PHILOSOPHY = always-full (DECIDED).** Accept lower-quality over a sparse page — an empty marketing feed is the worst marketing, and it matters most when the platform is youngest (Genesis: 60–80 users, 4–5 courses). Implement as a **tiered fallback cascade**, drawing until the page is full:
1. recent top-level posts ranked by engagement
2. recent top-level posts, any engagement
3. **new-entity announcements** (see below)
4. popular public-feed suggestion cards
5. **The Commons anchor** — everyone's auto-joined, so it's the highest-traffic feed AND a "feed you're not in" for a visitor; least-niche, always-on content source.

**Early-vs-mature weight:** while supply is thin, lead with **recency** (alive *now*); shift weight toward **engagement** as data accumulates. Same pipeline, tunable weight.

**New courses/communities are first-class announcements (DECIDED).** Newness is a *positive* signal, not a gap-filler — a brand-new course/community is prime FOMO bait ("New course just launched →", "be an early member"; low member count becomes a feature). This:
- Adds a candidate source: query **recently-created** public courses/communities (`created_at`), independent of whether they have any `feed_activities`.
- **Resolves the empty-shell problem by age:** new + postless → **announce** (recency-boosted); old + dead → **suppress** (true ghost town). "Is it new?" overrides "has it got posts?".

**`reason` field drives both ranking weight AND badge copy** (extends existing `matchReason`): `'new_course' | 'new_community' | 'trending' | 'topic_match' | 'popular'`. Marketing card sub-sources:

| Sub-source | Item | Signal | Badge (reason) |
|---|---|---|---|
| Active public feeds | sample **post** | engagement × recency | "Happening in X" |
| Recently-created courses/communities | **card** | newness | new_course / new_community |
| Popular public feeds (unsampled) | card | vitality | trending / popular |
| The Commons | post | always-on anchor | (broad) |

**Good-card bar:** a card needs description/cover (+ ≥ some members) UNLESS it qualifies as `new_*` (newness exempts it from the maturity floor).

---

## Visitor action-gating model (raised Conv 258 — needs verification)
The whole visitor strategy rests on: **browse freely, gate at the action.** A visitor can *view* community pages and course pages, but **joining a community or taking a course requires signing up.** That gate must be:
1. **Enforced** — every join/enroll/post action redirects an unauthenticated user to signup (not a silent failure or a 500).
2. **Clear** — the UI should signal "sign up to do this" *before* the click, not surprise them after.

⚠️ **Open concern (user):** is this browse-vs-act gating **consistent and clear across the whole site**, or does it vary per surface? Candidate for a dedicated audit — see `[VISITOR-GATING]` (proposed). Initial probe Conv 258 (see conv notes).

---

## Open threads
**Resolved Conv 258:** loud-ask = sticky bar · cursor = Option A · marketing candidate quality (always-full + new-entity announcements) · Home layout = feed-leads + visitor thin-orienting-line (A) · S2 extraction = generalize discovery builder, member feed pure S1 · `/feed` route = keep auth-only, redirect visitor → `/` (option B) · sample-post CTA = keep, intent-preserving (option A).

**Design COMPLETE Conv 258.** Remaining before build:
- "Active" recency window (14d vs 30d) + which post represents an active feed (most-engaged vs freshest) — minor tuning, fold into build.
- Site-wide visitor action-gating consistency → `[VISITOR-GATING]` #31 (and the intent-preserving signup it builds is a dependency of the sample-post CTAs).

## Build phases (proposed)
1. `getMarketingCandidates` builder (generalize `getDiscoveryCandidates`: de-personalized path + new-entity announcements + posts/cards/announcements with `reason`) + global chronological marketing-post query.
2. Cursor rework (Option A, `(created_at,id)` tiebreaker, mode-selected backbone) + always-full fallback cascade in the orchestrator/interleaver.
3. Un-gate `/api/feeds/smart` (auth-aware: member path empty without session) + visitor-branch caching.
4. `SmartFeed.tsx` 3 render variants (member-post · sample-post w/ quiet intent CTA · suggestion/announcement card) + "caught up → discover" boundary card.
5. Home recomposition (strip to nudges; mount feed; auth-conditional thin-orienting-line / breadcrumb; sticky sign-up bar for visitors) + `/feed` redirect-visitor-→-`/`.
6. Intent-preserving signup hook (shared with `[VISITOR-GATING]`).
7. Browser-verify authed + visitor + cold-start paths (D1-classify + dev-login per `reference_chrome_bridge_island_stale_cache`).

## Done so far (Conv 258)
- ✅ `/feed` removed from Sidebar NAV + COLLAPSED_NAV (route + page kept).
