# HOME-FEED-MERGE — merge SmartFeed into Home + public/visitor feed mode

**Status:** ✅ ADOPTED — BUILD (client signed off Conv 259: participatory townhall retired / "The Commons" → **System** community, its feed admin-only + un-named; promotion policy approved — **free at launch, password-gated**, see [PROMOTE-PIPELINE]). Design complete; the build phases below are now active. **Foundation `[SYS-RENAME]` #30 ✅ DONE Conv 259** (enum rename + admin-only lockdown — see § SYS-RENAME below). **`[POST-MATT]` #35 🔨 BUILT Conv 260** (boundary B — display-only `FeedPost` adapter + `SocialPost.feedLink`; component-only, not yet live-wired — see § post-format-matt.md). **`[DISCOVERY-RAILS]` #31 ✅ STAGING-COMPLETE Conv 262** (Phases 1/2/4 built + Phase 3 deployed/verified on **staging** Conv 261; prod deploy **folded into MVP-GOLIVE** Conv 262 — premature prod cron reverted; only downstream consumers remain — see § DISCOVERY-RAILS below). **`[PROMOTE-PIPELINE]` #32 🔨 BACKEND-BUILT Conv 262 + ✅ DESIGN COMPLETE Conv 263 + Steps 1–3 BUILT Conv 265/269** (4 password clarifications RESOLVED + schema/lib/endpoints/tests for the promotion foundation + Promoted-lane read-side built Conv 262; **the full delivery-system design — Model ① reference+teaser-lane, posture-A gating, moderation, lifecycle, templates, promote-nudges, 7-step build sequence — was locked Conv 263**; see § Delivery model + lifecycle / § Templates / § Promote-nudges / § Build sequence below. **Conv 265 built Steps 1–2:** Step 1 foundation correction (`promote.ts` copy→reference Model ①, dropped `target_activity_id` + orphaned `promoted_from_activity_id`) + Step 2 `canPromote` feed-GET flag (+11 tests); lane rendering folds into #28/#30. **Conv 269 built Step 3** — per-post Promote button (endpoint Stream-id contract + idempotent early-return + 2 UNIQUE indexes + shared `PromoteButton` + `SocialPost` actions slot; both live renderers; 8 tests; browser-verified; suite 6626/6626); **Steps 4–7 remain**.). Remaining build tasks: `[PROMOTE-PIPELINE]` #32 (epic build remainder, per the 7-step sequence) · `[PROMO-LIFECYCLE]` #37 (NEW Conv 263) · `[ADMIN-FEED-UI]` #33 · `[RECO-UNIFY]` #34 · `[SYS-NAMING]` #36 · `[VISITOR-GATING]` #29 ✅ SERVER-SIDE DONE Conv 264 (posture-A gating across 6 endpoints via shared `feed-participation.ts`; +23 tests, suite 6570/6570; client "Join to participate" CTA folded into #28; follow-up `[SYS-GET-GATE]` #37 — see § Build sequence cross-cutting line) · live wiring (#28 phase 4).
**Anchor status (Conv 268):** `[HOME-FEED-MERGE]` #28 **ALL build phases (1–7) BUILT** (1–2 Conv 266; 3–5 + 7 Conv 267; **6 Conv 268** — intent-preserving signup: home-feed discovery CTAs route a visitor through `/signup?redirect=<entity>` and return them to that exact entity, via NEW shared `src/lib/smart-feed/cta.ts` `buildDiscoveryCtaUrl` used by both ctaUrl sites; authed unchanged; server-side branch so the cards stay dumb; suite **6618/6618**, all 5 gates green). **Block functionally complete.** Remaining = NON-core: deferred cosmetic polish (FeedPost teaser restyle · visitor-aware copy/tabs · mobile sticky-bar) + the distinct `[VISITOR-GATING]` authed "Join to participate" 403-CTA. Follow-up `[FEEDSHUB-ORPHAN]` #37, `[TW-V4]` #38. See § Phase 6 (+ 3/4/5/7) below.

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
1. ✅ **DONE Conv 266** — `getMarketingCandidates` builder (`src/lib/smart-feed/marketing.ts` + `tests/lib/smart-feed-marketing.test.ts`). See § Phase 1 below.
2. ✅ **DONE Conv 266** — orchestrator rework: Option-A cursor + mode-selected backbone + cascade/interleave + unified 3-kind stream. See § Phase 2 below.
3. ✅ **DONE Conv 267** — un-gate `/api/feeds/smart` (auth-aware: member path empty without session) + visitor-branch caching + wire the real rails blob (KV-read w/ compute fallback) into `getSmartFeed`. See § Phase 3 below.
4. ✅ **DONE Conv 267** — `SmartFeed.tsx` renders all 3 kinds + stop filtering cards at the endpoint + "caught up → discover" boundary card. See § Phase 4 below. (Matt `FeedPost` restyle + quiet-CTA + sticky bar deferred to Phase 5 — see note.)
5. ✅ **DONE Conv 267** — Home recomposition (strip to nudges; mount feed; auth-conditional thin-orienting-line / breadcrumb; sticky sign-up bar for visitors) + `/feed` redirect-visitor-→-`/`. See § Phase 5 below.
6. ✅ **DONE Conv 268** — intent-preserving signup hook: the home feed's discovery CTAs (sample-post + suggestion-card) route a visitor through `/signup?redirect=<entity>` and return them to that exact entity after signup; authed viewers still get the direct entity link. Shared `buildDiscoveryCtaUrl` helper used by both ctaUrl sites. See § Phase 6 below.
7. ✅ **DONE Conv 267** (authed + visitor browser-verified; cold-start by unit test + shared path) — see § Phase 7 below.

## Phase 1 — getMarketingCandidates (DONE Conv 266)

**Scope decision (Conv 266):** user chose **Phase 1 only** this conv (completable durable cut; phases 2–3 next conv) + **rails-backed cards** for the card/announcement source (reuse Conv-261 Discovery Rails rather than rebuilding trending/popular/new queries — the redundancy `[RECO-UNIFY]` #34 is meant to remove anyway; only the sample-POST query is net-new).

**Built:** `src/lib/smart-feed/marketing.ts` — `getMarketingCandidates(db, opts)` returns a structured **two-pool** result `{ samplePosts, cards }` (NOT pre-merged — the always-full cascade + interleave is phase-2 orchestrator policy, deliberately left unbaked here). Dependency-injected (db for posts, blob for cards) → fully unit-testable without Stream/KV.
- **samplePosts** = a NEW global-chronological `feed_activities` query: `activity_type='post'` only (excludes replies — the biggest free quality lever), recency-windowed (default 30d, JS-computed ISO cutoff — no SQL `datetime()`), public-feed-only (`PUBLIC_FEED_PREDICATE`: public+live community / `feed_public` live course), `(created_at,id)` before-cursor (tiebreaker-correct for equal seed timestamps), viewer-feed-excluded (tuple `NOT IN`, omitted for visitors), flag-excluded (`content_flags` status `pending`/`actioned`), per-feed diversity cap (default 2) applied in JS over the globally-ordered set.
- **cards** = mapped from the injected `DiscoveryRailsBlob`: rail kind → `reason` (`new`→`new_course`/`new_community`, `trending`, `popular`); good-card bar (description/cover + ≥1 member, **new_\* exempt**); cross-rail dedupe keeping the strongest reason (new > trending > popular); dedupe vs sample posts (one representative per entity); viewer-feed exclusion; ordered lens-hits-first → reason-priority → rail score. `reason` drives both ranking weight and badge copy. Personalization is a **lens** (`topicMatched` flag via `viewerTopicIds` overlap), not a query branch — works with zero tags.
- **`MarketingCandidate` type** carries `kind` (`sample-post`|`suggestion-card`) + `reason` + feed ref + (post: activityId/actorId/streamActivityId/createdAt) | (card: entity display fields + topicIds + railScore) + `topicMatched`. Phase 2 threads it into the orchestrator + scoring.

**Tier-5 "The Commons anchor" retired as a dead premise (Conv 266 — user confirmed, A stands).** The Conv-258 cascade (§ Marketing candidate quality, tier 5) justified the anchor *solely* by "everyone's auto-joined, so it's the highest-traffic always-on feed" (design line 175). **SYS-RENAME (Conv 259) retired `autoJoinTheCommons` AND made the System feed admin-only** — deleting that premise 7 convs ago; the cascade line was simply never updated. So this is doc/code reconciliation, not an override of a live decision. `getMarketingCandidates` excludes `feed_type='system'` entirely (`PUBLIC_FEED_PREDICATE` matches community/course only); cascade is now tiers 1–4. **No always-on anchor sub-task** — tiers 1–4 already draw globally from *all* public posts + new/popular public entities, so always-full holds to the extent any showable content exists; the anchor was only ever the last-ditch tier that auto-join made free. Member-facing System content reaches users via Announcements (`[ADMIN-FEED-UI]` #30), not the marketing feed.

**Recency window** still default 30d (the 14d-vs-30d "active" tuning + most-engaged-vs-freshest representative selection remain phase-2/scoring concerns — engagement isn't known until Stream enrichment, so phase-1 orders sample posts by recency only).

## Phase 2 — orchestrator rework (DONE Conv 266)

**Scope decision (Conv 266):** keep `/api/feeds/smart` **401-gated** until Phase 3 (no observable change mid-build); rework `getSmartFeed`'s internals + signature only.

**Built** (`src/lib/smart-feed/index.ts` rewrite + `tests/lib/smart-feed-orchestrator.test.ts`, 6 tests):
- **Unified 3-kind stream** — `getSmartFeed` now returns `FeedItem[]` = `EnrichedCandidate` (`kind: 'member-post' | 'sample-post'`) ∪ `SuggestionCardItem` (`kind: 'suggestion-card'`). Matches the design's "one stream, 3 kinds." `isDiscovery` retained on posts for client back-compat. `EnrichedCandidate` gained `kind` + `activityId` + `createdAt` (cursor keys).
- **Mode-selected backbone (Cursor Option A)** — backbone = member posts if the viewer has feeds, else marketing sample posts (visitor/cold-start). `getDiscoveryCandidates` replaced by `getMarketingCandidates`; sample posts join the existing score/enrich path (mapped to `RawCandidate` `isDiscovery=true`); cards become injected `suggestion-card` items (no Stream).
- **Opaque `(created_at, id)` cursor** — `encodeCursor`/`decodeCursor` (`~` sep, legacy created_at-only tolerated). `nextCursor` = the **oldest backbone post in the page** (true floor), so the next page is strictly older regardless of in-page score ordering. Cards are never in the cursor (front-loaded, capped, injected). 🟢 **Fixes a latent bug:** the old cursor used the *last interleaved* member post's `time`, which after score-sorting wasn't the oldest → could skip/dupe across pages; Option A is correct. `getMemberCandidates` gained an optional `beforeId` for the tiebreaker (back-compatible — existing callers pass created_at only) and now `ORDER BY created_at DESC, id DESC`.
- **Always-full cascade / interleave** — generalized `interleave(backbone, injectables, …)`: backbone-first batches, inject one discovery item per `frequency`, capped at `discoveryMax`; injectables = sample posts (S2, preferred) then cards (S3 backfill); when the backbone is empty the injectables carry the page.
- **Mode-aware diversity cap** — sample posts pre-capped in `getMarketingCandidates` at `perFeedCap = hasMemberFeeds ? 1 (injection diversity) : diversityCap (richer visitor backbone)`; orchestrator `applyDiversityCap` now caps member posts only.
- **Dismissals preserved** — `smart_feed_dismissals` were honored by the old `getDiscoveryCandidates`; wired `dismissedFeedKeys` into `getMarketingCandidates` (both pools) so a "not interested" feed stays hidden (would otherwise have regressed). +2 marketing tests.
- **Visitor-aware** — `getSmartFeed` accepts `userId: string | null` + empty scoring context for visitors (forward-prep for Phase 3; endpoint still passes a real `session.userId`).

**Endpoint (`src/pages/api/feeds/smart/index.ts`):** still 401-gated; passes `railsBlob: null` and **filters out `suggestion-card` items** (client can't render them until Phase 4; no-op while blob is null). Phase 3 wires the real blob + drops the 401; Phase 4 stops filtering cards + adds the render variants.

**Behavior change for authed users (intended):** the discovery *injection* switches from topic-matched per-feed-top-3 (`getDiscoveryCandidates`) to global-recency sample posts with a topic **lens**; cold-start users (feeds but no posts) now get sample posts instead of an empty feed. `getDiscoveryCandidates` retained + still tested; its removal is `[RECO-UNIFY]` #31.

## Phase 3 — un-gate `/api/feeds/smart` + wire rails blob + visitor caching (DONE Conv 267)

The smart feed becomes the **public Home marketing surface** — auth-aware, not auth-gated. Three changes, all server-side (the client `SmartFeed.tsx` is untouched until Phase 4):

- **Un-gated, auth-aware** (`src/pages/api/feeds/smart/index.ts`): dropped the blanket 401. `getSession` → `userId = session?.userId ?? null`; a visitor (or invalid session) flows through as `userId: null`. The member path yields `[]` without a session, so the gate is **by data, not by a 401** — a visitor gets the marketing sample-post backbone. Middleware already lists `/api/` under `PUBLIC_PREFIXES` (API routes self-enforce auth), so the endpoint is the correct and only gate — no middleware change needed. (`/feed`'s `PROTECTED_EXACT` visitor→`/` redirect is **Phase 5**, not here.)
- **Real rails blob wired** — extracted the two-tier read (KV with on-demand-compute fallback) out of `/api/discovery/rails` into a shared **`src/lib/discovery-rails/serve.ts`** (`loadDiscoveryRailsBlob(db, kv?)` + `getDiscoveryRailsKV()`), so both the rails endpoint and the smart feed share ONE implementation and can't drift. The smart endpoint now passes the real blob (no longer `railsBlob: null`); a rails-load failure **degrades to no cards** (sample posts don't need the blob) rather than failing the whole feed. `/api/discovery/rails` refactored onto the shared reader — behavior identical (`X-Discovery-Source` preserved), its inline two-tier logic deleted.
- **Visitor-branch caching** (vary on session presence): authed → `Cache-Control: private, no-store` (personalized, never cached); visitor → `Cache-Control: public, max-age=60` + `Vary: Cookie` (identical across all logged-out viewers → safe to cache). We never emit `public` for a personalized response, so an authed payload can't be cached and served to a visitor.

**Card filter stays** until Phase 4 — the endpoint still filters out `suggestion-card` items (the client can't render them yet). With the real blob now producing cards, this is a live filter (was a no-op under `railsBlob: null` in Phase 2): cards are computed and discarded server-side until Phase 4 stops the filter + adds the render variants.

**Tests:** `tests/api/feeds/smart/index.test.ts` (NEW, 4) — visitor gets 200 not 401 · visitor cache headers (`public, max-age=60` + `Vary: Cookie`) · authed cache header (`private, no-store`) · cards filtered out (seeds a public course so the compute fallback produces a card, asserts it's not served). `tests/api/discovery/rails.test.ts` unchanged + still green (the refactor is behavior-preserving). Full suite **6610/6610**; tsc + astro (0/0/0) + lint + build all green THIS conv.

🟠 **API-doc drift (folds into `[API-DISC-DOC]` #33):** `/api/feeds/smart` is no longer 401-gated — any API-reference doc describing it as auth-required is now stale. Bundled with the already-tracked discovery-endpoint documentation gap.

## Phase 4 — client renders the 3-kind stream + stop filtering + boundary card (DONE Conv 267)

The client (`SmartFeed.tsx`) learns the unified stream, and the endpoint stops filtering cards — so the full member-post · sample-post · suggestion-card stream now renders end-to-end.

**Key finding that shaped the cut:** the Matt `FeedPost` (POST-MATT, Conv 260) is **display-only** — its reaction/comment pills are non-interactive social proof. Wiring it as the *member-post* renderer would **regress** live reactions/comments on the home feed; the POST-MATT design itself keeps interactive native-feed posts on `FeedActivityCard`. So "full Phase 4" is **not** a big FeedPost rebuild. The functional, completable cut taken this conv:

- **member-post** → `FeedActivityCard` (interactive — unchanged).
- **sample-post** → `DiscoveryCard` (already a sample-post-with-intent-CTA + dismiss — unchanged).
- **suggestion-card** → **NEW `src/components/feed/SuggestionCard.tsx`** (sibling of DiscoveryCard): entity card with a reason badge (`New course` / `New community` / `Trending` / `Popular` / `Matches your interests`), title + description (`line-clamp-2`) + optional image, member-count social proof (hidden at 0), a Join/View-Course CTA, and the same feed-key `/api/feeds/smart/dismiss` "Not interested" action.

**`SmartFeed.tsx` changes:** the local item type became a **discriminated union** (`PostFeedItem` `kind: 'member-post'|'sample-post'` ∪ `SuggestionCardFeedItem` `kind: 'suggestion-card'`) with an `isPostItem` guard. The render map checks `kind === 'suggestion-card'` **first** (narrows the rest to posts), then the existing sample-post / member-post branches. `handleActivityUpdate` guards to posts (cards have no Stream activity); `handleDismiss` now removes a dismissed feed whether it surfaced as a sample-post OR a card. The non-'all' filter tabs (`teachers`/`trending`/`unseen`) are member-post-only views — cards + sample-posts drop out via the guard.

- **Boundary card ("caught up → discover"):** when `!hasMore` and the stream contains any `member-post` (an authed member who exhausted their own posts), the end-of-feed marker becomes a tappable card → `/feeds` (the public Discover destination), itself a conversion nudge (Cursor Option A). A visitor/cold-start viewer (no member posts) is already in discovery, so they get the plain quiet end marker.
- **Endpoint:** dropped the `suggestion-card` filter in `src/pages/api/feeds/smart/index.ts` — the full `result` is served (cache-header split unchanged). The Phase-3 endpoint test's card-filtered assertion was inverted to assert a card **is** served (a seeded public course → a served course card, proving the path end-to-end).

**Deferred to Phase 5 (cosmetic / page-chrome, not functional):** the Matt `FeedPost` restyle of teaser posts (sample-posts → `FeedPost` for the "quiet badge + ghost CTA" look) and the visitor **sticky sign-up bar** are page-chrome that ride with Phase 5's Home recomposition — the functional sample-post-with-CTA already exists via `DiscoveryCard`, so this is a look-and-feel pass, not a missing capability.

**Tests:** `tests/api/feeds/smart/index.test.ts` updated (card-served assertion). No `SmartFeed`/`DiscoveryCard` component tests exist (existing convention — the render logic is declarative; the endpoint test covers the card data path), so `SuggestionCard` follows suit. Full suite **6610/6610**; tsc + astro (0/0/0) + lint + build all green THIS conv.

`SmartFeed` is currently mounted at `/feed` (`src/pages/feed.astro`); Phase 5 mounts it on Home (`/`) with the auth-conditional chrome.

## Phase 5 — Home recomposition + `/feed` visitor redirect (DONE Conv 267)

Home (`/`) becomes the merged feed surface AND the sole public marketing page; the feed LEADS, chrome swaps by auth.

**`src/pages/index.astro` recompose** — per the Conv-258 directive, of the prior dashboard content **only the nudges remain**. Removed: the "Welcome to Peerloop" hero, the quick-start `ActionCard`s, the "Your Feeds" `FeedsHubPanel`, the Recent-Activity `EmptyState`, AND the Conv-256 cross-role `TriageStrip`. Mounted `SmartFeed` (`max-w-2xl`, mirroring `/feed`). Chrome:
- **Authenticated:** minimal breadcrumb + loud slot (`OnboardingNudgeBanner` if not onboarded, else `ProgressionNudge` S→T) + feed. (Both nudges are self-gating client islands → null for visitors.)
- **Visitor:** one thin orienting line ("Peerloop — learn from peers, teach what you know." — no CTA, so it doesn't compete) + feed + the **sticky sign-up bar**. An `sr-only` `<h1>Home</h1>` keeps the heading for a11y without a visible hero.

**`src/components/marketing/StickySignupBar.astro` (NEW)** — the one loud conversion ask for visitors (`<Button href="/signup">` + Matt Card surface tokens). Implemented as a **`sticky`** (not `fixed`) bar inside the content column: it auto-aligns to the content width with no Sidebar-overlap / width-hardcoding, and clears the mobile `ControlBar` (`lg:hidden`, fixed-bottom) via `bottom-[76px]` dropping to `bottom-6` at ≥lg. Mounted by Home only when `!isAuthenticated` (page chrome, not in the feed island).

**`/feed` visitor redirect (design Option B):** an unauthenticated `/feed` hit now redirects to `/` (the public feed), NOT `/login?redirect=/feed` — a visitor who asked for "the feed" lands on the public feed, not a wall. `/feed` stays auth-only for signed-in users (the focused, chrome-free personal feed). Implemented in **both** `src/middleware.ts` (a `pathname === '/feed'` special-case in the no-session branch — every other protected route keeps the login-with-returnUrl redirect) and `src/pages/feed.astro` (page-level defense-in-depth redirect → `/`).

**TriageStrip note (adjacency to the BLOCKED `[ROLE-STUDIOS]`):** the Conv-258 directive to drop `TriageStrip` from `/` **supersedes** its Conv-256 placement (the plan §4 note already records this). It does **not** conflict with the ROLE-STUDIOS client-comparison block — that block is about not retiring `/old/dashboard` + `UnifiedDashboard`; `TriageStrip` is a separate component (kept in the codebase for `[TRIAGE-RESTYLE]`, just unmounted from Home). 🟠 `FeedsHubPanel` is now orphaned (no consumer) — tracked as `[FEEDSHUB-ORPHAN]` #37 (not deleted — directive removed it from Home, not the codebase).

**Tests:** `tests/middleware.test.ts` — `/feed` removed from the unauth→`/login` loop + a new `/feed → /` redirect test (88 pass); authed-pass-through for `/feed` unchanged. Full suite **6610/6610**; tsc + astro (0/0/0) + lint(src) + build all green THIS conv.

**Deferred polish (not blocking):** the Matt `FeedPost` teaser restyle of sample-posts (still `DiscoveryCard`), the visitor-aware SmartFeed copy/filter-tabs (the member-oriented "From Teachers / Trending / Unseen" tabs show empty for a visitor), and a mobile sticky-bar refinement — all cosmetic. Remaining block work: **Phase 6** (intent-preserving signup, shared with `[VISITOR-GATING]`).

## Phase 7 — browser-verify (DONE Conv 267)

Verified the live Phase 3–5 result against a local dev server (the changes are committed locally, not deployed — so verification is local, not staging) via the Chrome bridge + curl. A pre-existing stale Astro dev server (corrupted `.vite/deps_ssr` → `jsxDEV is not a function` on every page) was restarted + cache-cleared first; **not a code defect** (API routes were unaffected).

**Server-side (curl):**
- `GET /api/feeds/smart` unauthenticated → **200** (not 401) + `Cache-Control: public, max-age=60` + `Vary: Cookie`. Authed → `private, no-store`.
- `GET /feed` unauthenticated → **302 → `/`** (not `/login`).
- Visitor payload: 10 sample-post + 3 suggestion-card, `nextCursor` present.

**Authenticated (browser, dev-login `guy-rymberg@example.com`):** feed = 9 member-post + 2 sample-post + 1 suggestion-card; member posts render via `FeedActivityCard` (reactions + "Visit feed"), the `SuggestionCard` shows its "Popular" badge, and the **"caught up → Discover" boundary card renders** (member has posts). Visitor chrome (orienting line, sticky bar) correctly **absent**.

**Visitor (browser, after logout):** orienting line "Peerloop — learn from peers, teach what you know." + the **sticky sign-up bar** (visible, `Join Peerloop` → `/signup`) both render; feed = 10 sample-post + 3 suggestion-card (marketing-only, no member-posts); the plain end marker shows and the member boundary card is correctly **absent**.

**Cold-start** (authed user with no feeds → marketing backbone): not run as a separate browser case — it shares the exact marketing-backbone code path the visitor case browser-verified, and the `hasMemberFeeds === false` branch is covered by `tests/lib/smart-feed-orchestrator.test.ts`.

**`[HOME-FEED-MERGE]` is now functionally complete through Phase 5 + verified (Phase 7);** only Phase 6 (intent-preserving signup, shared with `[VISITOR-GATING]`) + the deferred cosmetic polish remain.

## Phase 6 — intent-preserving signup (DONE Conv 268)

The home feed's discovery CTAs now **carry the visitor's intent through signup** — a visitor who clicks "Take Course: X" / "Join: Y" on a sample-post or suggestion-card is routed to signup and returned to **that exact entity** afterward, instead of dead-ending at a 401 or landing on a generic page. This captures the visitor at peak interest in a specific thing (the Conv-258 design rationale, option A).

**Key finding — the signup machinery already existed; only the feed's consumption of it was missing.** `signup.astro` already reads `?redirect=`/`?returnUrl=` → `AutoOpenAuthModal` → `handleAuthSuccess` fires the returnUrl after signup; `EnrollButton.tsx` already used this exact pattern (`/signup?redirect=/course/{slug}`). So Phase 6 is **not** new signup plumbing — it's making the home feed's `DiscoveryCard`/`SuggestionCard` CTAs use the proven pattern. (The "signup accepts a post-signup destination" dependency from the design was already satisfied.)

**Where the branch lives = the server (not the client).** The cards are deliberately "dumb" (`<a href={ctaUrl}>`) and don't know viewer auth; the server that **builds `ctaUrl` already knows** (`getSmartFeed(db, client, userId, …)`). So the auth branch is baked into `ctaUrl` server-side — no client change, no auth prop threaded into the island, no `localStorage` user-cache read (dodges the `[NUDGE-CACHE-FLASH]` class of first-paint staleness bug entirely).

**Built:**
- **NEW `src/lib/smart-feed/cta.ts`** — `buildDiscoveryCtaUrl(feedType, feedId, via, viewerAuthenticated)`: authed → direct entity link (`/course/:slug?via=…` | `/community/:slug?via=…`, today's behavior); visitor → `/signup?redirect=<encoded entity>` (the `?via=` tracking param is preserved **inside** the redirect target so post-signup origin analytics survive). One helper used by **both** ctaUrl sites so the branch can't drift (same anti-drift reasoning as Phase 3's shared `serve.ts`).
- **`src/lib/smart-feed/index.ts`** — `getSmartFeed` computes `viewerAuthenticated = Boolean(userId)` once; threads it into `cardToItem` (suggestion-card, `via=home-discovery`) and `enrichCandidates` (sample-post path).
- **`src/lib/smart-feed/enrichment.ts`** — `enrichCandidates` + `toEnrichedCandidate` take `viewerAuthenticated` (defaults to `false` = visitor, fail-safe); the `discoveryContext.ctaUrl` (sample-post, `via=smart-feed-discovery`) now goes through the helper.

**CTA label is unchanged for visitors** — a visitor still sees "Join Community" / "View Course" (the label expresses intent; clicking routes to signup). Honesty comes from the sample-post's "from X · not joined" framing (Conv-258 decision), not from softening the label. No client component edit needed.

**Caching unaffected** (Phase 3): the visitor `ctaUrl` (`/signup?redirect=…`) is identical for all logged-out viewers → the `public, max-age=60` + `Vary: Cookie` visitor branch stays cacheable; the authed direct-entity `ctaUrl` only ever rides the `private, no-store` branch, so it can't be cached and served to a visitor.

**Scope = destination-level intent ("return them to X"), not auto-perform.** This matches the design's core phrasing AND the established `EnrollButton` pattern (so per §Critical Rule it's not a novel decision). **Action-level** ("auto-join / auto-enroll after signup") was deliberately NOT built: it's asymmetric (course enroll → Stripe checkout; auto-redirecting a fresh signup to a payment page is hostile) and the "one-click join/enroll from discovery" for *authed* users (design line 85) is itself a future enhancement — today authed users navigate to the entity page where the now-authed action button waits.

**Tests:** NEW `tests/lib/smart-feed-cta.test.ts` (6 — authed/visitor × course/community + redirect round-trip + fall-through) + 2 new orchestrator tests (`tests/lib/smart-feed-orchestrator.test.ts` — visitor card+sample-post CTAs are signup links; authed card+sample-post CTAs are direct entity links) + the existing card-injection test's visitor assertion updated to the signup-link shape. Full suite **6618/6618** (+8); all 5 gates green THIS conv (tsc · astro 0/0/0 · lint · test · build).

**Browser-verified (Conv 268, local dev `:4321`, DOM-truth):** curl + Chrome-bridge DOM read, both auth states. **Visitor:** all 13 home discovery CTAs render `href="/signup?redirect=<encoded entity>"`, labels preserved ("View Course" / "Join Community"), visitor chrome (orienting line + sticky bar) present; navigating one signup link lands on the signup surface with the modal open and `?redirect=` decoding to the exact entity (`/course/intro-to-n8n?via=smart-feed-discovery`) — intent carried (no account created). **Authed** (dev-login): the 3 injected discovery CTAs are all direct entity links, zero signup links, visitor chrome absent.

**Still on the block (NOT Phase 6 core):**
- **Deferred cosmetic polish** (Conv-258/267): Matt `FeedPost` teaser restyle of sample-posts (still `DiscoveryCard`); visitor-aware SmartFeed copy + filter-tabs (the member-oriented "From Teachers / Trending / Unseen" tabs render empty for a visitor); mobile sticky-bar refinement.
- **`[VISITOR-GATING]` "Join to participate" 403-CTA** (folded into #28 at Conv 264): surfaces the posture-A 403 when an *authed non-participant* tries to react/comment. This is a distinct concern from visitor signup (the viewer is already authed) and is entangled with the Phase-4 decision that `FeedActivityCard` (not the display-only `FeedPost`) stays the interactive member renderer — so where it lives needs a fresh call.

## Done so far (Conv 258)
- ✅ `/feed` removed from Sidebar NAV + COLLAPSED_NAV (route + page kept).

---

## Build tasks (promoted Conv 259 on client adoption)
Both adoption gates cleared Conv 259 → the 5 reserved codes are now live TodoWrite tasks, plus a foundation rename + a cosmetic-rename follow-up:

| # | Task | Scope |
|---|------|-------|
| #30 | `[SYS-RENAME]` ✅ DONE Conv 259 | `feed_type` enum `'townhall'→'system'` (boundary C) + admin-only System lockdown (boundary A); announcements deferred to #33. See § SYS-RENAME below. |
| #31 | `[DISCOVERY-RAILS]` ✅ STAGING-COMPLETE Conv 262 (consumers remain) | daily discovery-data service (the marketing-candidate / Discovery Rails source). Phases 1 (lib) + 2 (endpoint) + 4 (client cache/lens) built; Phase 3 (KV+cron) deployed + verified on **staging** (Conv 261). **Prod deploy folded into MVP-GOLIVE Conv 262** (premature prod cron reverted — see § DISCOVERY-RAILS status); only downstream consumers (#28, #34) remain. See § DISCOVERY-RAILS below. |
| #32 | `[PROMOTE-PIPELINE]` 🔨 BACKEND-BUILT Conv 262 + Steps 1–3 BUILT Conv 265/269 (epic continues) | promotion epic — **free + password-gated** at launch (Stripe payment deferred). Password-gate policy **RESOLVED Conv 262** (one global password · per-promotion · bcrypt in `platform_stats` · every step gated) + **backend foundation BUILT** (schema/lib/endpoints/tests + Promoted-lane read-side; see § Promotion clarifications below). **Conv 265 built Steps 1–2** of the § Build sequence: Step 1 foundation correction (copy→reference Model ①) + Step 2 `canPromote` flag. **Conv 269 built Step 3** — per-post **Promote button** (endpoint Stream-id contract + idempotent early-return + 2 UNIQUE schema indexes + shared `PromoteButton` + `SocialPost` actions slot; wired on both live feed renderers; 8 endpoint tests; browser-verified). **Remaining (Steps 4–7):** promote-a-course/community templates · promote-nudges · `/admin` password UI (folds into #33). |
| #33 | `[ADMIN-FEED-UI]` | admin console — incl. the **Announcement data model + member/visitor fan-out** (deferred here from SYS-RENAME boundary A) AND the promotion-password admin UI (`/admin/*`). |
| #34 | `[RECO-UNIFY]` | unify reco bands onto Discovery Rails + Promotion. |
| #35 | `[POST-MATT]` 🔨 BUILT Conv 260 | post/feed-item Matt design (ungated; boundary B). **Primitives already existed** (SocialPost/AnalyticCount/CourseAnchor); built `FeedPost` display-only adapter + `SocialPost.feedLink` + `_FeedPostDemo` on `/dev/primitives` + `FeedPost.test.tsx` (8 tests). 5 gates green, browser-verified. Display-only model + green=Course-variant resolved — see § post-format-matt.md "Resolved build model". Live wiring is `[HOME-FEED-MERGE]` #28 phase 4. **2 follow-ups:** (a) FeedPost relative-time ("2h") — currently `formatDateTimeUTC` (full datetime) to avoid new TZ logic; relative formatter deferred (TZ-sensitive, ties to `[TZ-AUDIT]`); (b) `[SHOWMORE]` #13 folded into FeedPost as a char-based v1 for the aggregated post only — **native feeds still untruncated** (still pending there). |
| #36 | `[SYS-NAMING]` | cosmetic `townhall→system` rename of routes / Stream feed group / components / labels + local D1 re-seed (split out from SYS-RENAME; the D1-enum rename only touched the token, not these surfaces). |

### Promotion launch gate (DECIDED Conv 259 — strategic)
Promotion is **free to everyone** but gated behind a **stored shared password**, changeable only by Admins via an `/admin/*` interface. Stripe payment deferred to a later phase. Lightweight launch access-control (admins distribute/rotate the password to trusted promoters) without building payment first. Recorded on `[PROMOTE-PIPELINE]` #32; the password admin UI folds into `[ADMIN-FEED-UI]` #33.

**4 clarifications — RESOLVED Conv 262:**
1. **Scope:** ONE global shared password (not per-level) — simplest to distribute/rotate to trusted promoters.
2. **Frequency:** entered PER-PROMOTION (not per-session) — each promote is a deliberate gated action; no session-gate state/expiry to build; the shared secret is never cached in the session.
3. **Storage + hashing:** bcrypt hash (`hashPassword`/`verifyPassword` from `src/lib/auth/password.ts`) stored in `platform_stats` under key `promotion_password_hash`; admin-rotatable via `/admin` (rotation UI folds into `[ADMIN-FEED-UI]` #33). Matches the `discovery_%`/`smart_feed_%` settings pattern — no new table/migration/infra.
4. **Gated levels:** EVERY escalation step (Course→Community AND Community→System) — without payment the password is the sole anti-spam control, so no step is left ungated.

**Build-ready:** with these resolved, the **password-gate** sub-part of #32 is unblocked. (The broader epic — escalation mechanic, promote-a-course/community templates, promotion lineage, the Promoted lane, and promote-nudges — remains its own build under the adopted model.)

**Backend foundation — BUILT Conv 262 (scope 1A · 2A · 3A; all 5 gates green, full suite 6542/6542):**
- **Schema** (`migrations/0001_schema.sql`): `post_promotions` event table (source/target activity, promoter, from/to feed; `price_cents`/`payment_id` deferred to the payment phase) + `feed_activities.promoted_from_activity_id` lineage column + indexes (incl. a `to_feed` index for the future Promoted-lane query).
- **Lib** `src/lib/promotion/`: `resolvePromotionTarget` (Course→Community via `courses.progression_id → progressions.community_id`; Community→System `the-commons`; System→null; course-without-progression→null), `canPromote` role matrix (admin / creator / certified-teacher at both levels — a capability **separate from** `canPost`, deliberately bypassing the admin-only System rule), the password `gate` (bcrypt hash in `platform_stats` key `promotion_gate_password_hash`, **fail-closed** when unconfigured), `recordPromotion`, and the Promoted-lane read-side `getPromotedActivities` (promotions into a target feed, newest-first, with `limit` + `sinceDays` window). `indexFeedActivity` extended to return the row id + accept `promotedFromActivityId`.
- **Endpoints**: `POST /api/feeds/promote` (auth → source exists → target exists → `canPromote` → gate configured → password valid → copy source text up via Stream + index with lineage + record event) · `GET|POST /api/admin/promotion-password` (admin set/rotate + status; never returns the hash) · `GET /api/feeds/promoted` (the Promoted lane for community/course feeds, Stream-enriched; **System feedType rejected** — member-facing System content is delivered via Announcements `[ADMIN-FEED-UI]` #32, not leaked here).
- **Tests**: `tests/lib/promotion.test.ts` (19) — target resolution, role matrix, gate, lineage + event · `tests/lib/promotion-lane.test.ts` (5) — Promoted-lane ordering / limit / `sinceDays` window / feed-scoping. Plus feed-activity regression (11). Full suite 6547/6547.

**Still to build (later convs):** the "Promote" button in `FeedPost` with a per-promotion password prompt — **wait for `[HOME-FEED-MERGE]` #28 phase-4 live-wiring** to avoid rework; promote-a-course/community templates (which give the Promoted lane its *entity* rail entries, vs the post entries it serves now); promote-nudges; the `/admin` password UI (folds into `[ADMIN-FEED-UI]` #33). Document the 3 new endpoints (route maps auto-regen at r-end; add API-REFERENCE rows).

### Delivery model + lifecycle (DECIDED Conv 263)

**Stream-write model = ① "Reference + teaser lane" — NO Stream write.** A promoted post is never copied or re-homed in Stream; it lives in its origin Stream feed (course/community) for its entire life. Promotion writes a **single D1 `post_promotions` row** (canonical activity + target feed). Every higher-feed appearance (Community/System feed views, Home, rails) is assembled **at read time**: lane query (D1) → original `stream_activity_id` → `getActivitiesByIds` enrich → render as a **display-only teaser** ("Promoted from X · View Post →" to the source feed).

- **Why ①, not ② (TO-target) or ③ (copy):** promotion is *cross-membership-boundary delivery*, which feed-level access control exists to block. **Push** (Stream fanout) only works in-boundary; **②** breaks at Course→…→**System** because SYS-RENAME made the System feed admin-only AND retired `autoJoinTheCommons` (severed the follow graph) → fanout reaches *only admins*. **③** is the shipped `promote.ts` — duplicates the activity and **splits engagement** (copy starts at 0 reactions). **①** is pull (query-on-read): the query decides who sees it, independent of Stream feed access — the SAME pattern SmartFeed already uses, and the same one the Announcement model (`[ADMIN-FEED-UI]`) will reuse.
- **Backend consequence:** the shipped copy-based `promote.ts` becomes a **rewrite-to-simpler** — drop the target Stream activity + the `target_activity_id` it created; `post_promotions` references the **canonical** source activity + target feed; the lane reads the source activity by id. No new Stream activity at any level.

**Inbound-visitor permission = posture A** (read-only source feeds; "join/enroll to participate"). The promoted teaser's CTA is **"Visit Feed"** (B-1, DECIDED Conv 263 — honest label: it lands on the source *feed* page `/course/{slug}/feed` or `/community/{slug}`, **not** a focused post; no per-post permalink is built — that stays a latent `[ENTITY-ANCHOR]` / notifications-`action_url` need). It takes the promoted-to viewer to the **source feed**, where they may *view* but not react/comment/post unless they join/enroll. Handed to **`[VISITOR-GATING]` (PRIORITIZED)** — it closes a 🔴 pre-existing gap (reactions/comments are auth-only today, no membership check) across 6 feed endpoints via one shared `canParticipate` predicate + a "Join to participate" UI CTA + 403 tests. ① bonus: **moderate-at-source cascades** — flagging/removing the source post (via `content_flags`/`moderation_actions`) removes it from *all* promoted appearances (enrich-by-id), and **revoke = one D1 delete**.

**Moderation = A (auto-live + post-hoc takedown).** The password gate is the sole anti-spam control (Conv 262 decision) — no approval queue. Admins see System-level promotions by **injecting the lane into the admin System feed view** and take a promotion down by deleting its `post_promotions` row. (Folds into `[ADMIN-FEED-UI]`.)

**Lifecycle = two admin-configurable durations (`[PROMO-LIFECYCLE]`):**
- **Active duration — default 14 days.** A promotion shows in the lane for this long, then is auto-removed from active display. (Display can be enforced query-time via the existing `getPromotedActivities` `sinceDays` param so correctness doesn't depend on cron timing.)
- **D1 retention — default 60 days.** The `post_promotions` row persists this long (history/audit/re-promote), then is purged by cron.
- Both are `platform_stats` dials (mirrors the `discovery_%` dials + the bcrypt password gate — **no migration**); cron auto-remove extends the existing `workers/cron/` Worker; the two admin duration controls fold into `[ADMIN-FEED-UI]`.

### Templates — promote-a-course / promote-a-community (DECIDED Conv 263)

A "template" = a normal feed post whose Stream activity carries entity-promo custom fields: `postKind:'entity_promo'`, `promoEntityType:'course'|'community'`, `promoEntityId`. Body = the author's blurb. At render, the lane reads those fields → resolves the entity's display data **from D1** → drops a `CourseAnchor` / (new) `CommunityAnchor` into `FeedPost`'s existing `embed` slot with a "Take Course" / "Join" CTA. Rides the **same ① pipeline** (a `post_promotions` row + the lane). Template posts are the lane's **entity entries**; escalated discussion posts are its **post entries** — one mechanism, two payload shapes. Minimal new machinery: `FeedPost.embed` + `CourseAnchor` already exist; "entity ref in Stream custom fields" is the established pattern.

- **A1 storage = reference-only (DECIDED):** custom fields carry only `promoEntityType` + `promoEntityId`; title/creator/rating/level resolve from D1 at render (fresh, no staleness, no migration). NOT a frozen display snapshot.
- **A2 = author-direct-at-target (DECIDED Conv 263):** a dedicated "Promote a course/community" composer — pick entity → pick target level (gated by `canPromote` + password) → write blurb → creates the entity-promo post **and** its promotion in one action (a promo has no natural "source conversation," so it isn't authored-then-escalated). Result: promotion has **TWO entry points** — (1) escalate an existing discussion post (the Promote button), (2) author a new entity-promo (the template composer) — both converging on `post_promotions` + the lane.
- **New primitive needed:** `CommunityAnchor` (parallel to `CourseAnchor`; 9 entity anchors exist in `src/components/entity/`, none for community).
- **CTA semantics:** actionable for members (enroll/join); intent-preserving signup for visitors (shares the `[VISITOR-GATING]` signup machinery).
- **Scope:** the authoring *composer* is UI that rides on `[HOME-FEED-MERGE]` #28's FeedPost live-wiring; the **content-type + render + seed** are buildable independently (seeded backbone promos need no composer).

### Promote-nudges (DECIDED Conv 263 — build both surfaces, sequenced LAST)

A new `PromoteNudge` sibling following `ProgressionNudge`'s self-gating client-island pattern (**not** a new `ProgressionNudge` transition — promote is an *action*, not a role change). Two surfaces (decision = both):
1. **Per-post prompt** — on the eligible user's OWN post past an **engagement threshold**, in a feed they can promote: "promote this post →" → the escalate-existing-post flow. **Gated on a server `canPromote` signal the feed GET must add** (alongside `canPost`) — it can't be purely client-self-gated like ProgressionNudge because `canPromote` is feed-specific + D1-backed; a client-only guess risks a 403-after-click (posture-A surprise anti-goal).
2. **Workspace prompt** — a standing card in `/creating` + `/teaching`: "promote your course/community →" → the template composer (A2). Self-gates client-side on `isCreator`/`isTeacher` (coarse is fine here).

Anti-fatigue: per-post fires only on own-posts past an engagement threshold (rare); workspace is one standing card — keeps nudges in the rare+high-intent lane POST-MATT reserved. **Build order = LAST:** nudges are the encouragement layer atop the Promote button (#28) + template composer; they can't precede the actions.

### Build sequence (PROMOTE-PIPELINE remainder, Conv 263)
1. **Foundation correction** ✅ **DONE Conv 265** — rewrote `promote.ts` copy→reference (0 Stream writes); dropped `post_promotions.target_activity_id` (+ its index); `lane.ts` joins `source_activity_id` (`PromotedEntry.targetActivityId`→`sourceActivityId`); endpoint `promote.ts` now records ONE D1 row (removed the Stream-fetch/`addActivity`/`indexFeedActivity` copy block). **Also dropped the now-orphaned `feed_activities.promoted_from_activity_id`** (+ index + `indexFeedActivity` param) — Model ① creates no target row, so nothing writes it (user-approved Conv 265). Tests `promotion.test.ts` + `promotion-lane.test.ts` rewritten to the reference shape.
2. **`canPromote` flag** ✅ **DONE Conv 265** — community + course feed GET responses now return `canPromote` (role-allowed AND a resolvable target AND not the top-of-chain System feed, so the per-post PromoteNudge never offers a promote that 403s). +11 endpoint tests. **Lane *injection* (rendering) folded out (user decision Conv 265 = option A):** the lane read-side already exists (`getPromotedActivities` + `/api/feeds/promoted`, Conv 262); the actual teaser *rendering* belongs to the surfaces that own those renderers — **Home + community-page FeedPost teasers → `[HOME-FEED-MERGE]` #28** (whose `getSmartFeed` rewrite IS the Home injection point), **admin System moderation view → `[ADMIN-FEED-UI]` #30**. No durable server-only injection exists that isn't redundant with the existing endpoint or sitting in #28's rewrite path.
3. **Promote button** ✅ **DONE Conv 269** (escalate-existing entry point) — the `canPromote` feed-level flag (Step 2) now drives a per-post **Promote** action in `FeedActivityCard`, gated by the shared promotion password, on the single-feed surfaces (`CommunityFeed` + `CourseFeed`). See § Step 3 below.
4. **Templates** — entity-promo content-type + `CommunityAnchor` + render + seed; template composer (*needs #28*).
5. **`[PROMO-LIFECYCLE]`** #36 — durations (14d/60d) + cron purge + dials.
6. **`[ADMIN-FEED-UI]`** #31 — password UI + duration dials + System-promotion moderation view.
7. **Promote-nudges** (`PromoteNudge`) — per-post + workspace — LAST.
Cross-cutting: **`[VISITOR-GATING]` #29 (PRIORITIZED)** — posture-A gating — independent; runs first. **🔨 SERVER-SIDE BUILT Conv 264:** new `src/lib/feed-participation.ts` (`canParticipate` predicate + `checkCourseParticipation`/`checkCommunityParticipation`) is now the single source of truth; the 6 mutating reaction/comment endpoints ({community,course,townhall}×{reactions,comments}) gate POST/DELETE on participation (community→member · course→creator/admin/teacher/enrolled · system→admin-only); GET (read) stays open per posture-A. `course/[slug].ts` + `community/[slug].ts` refactored to consume the same helper (deleted their inline `checkPostingRights`/membership-query copies). +23 gate/403 tests (2 new course test files); baseline green (6570/6570). **#29 server-side = DONE; folded out the client CTA (Conv 264 decision):** the **"Join to participate" UI CTA** is **absorbed into `[HOME-FEED-MERGE]` #28** — it surfaces the 403s in the FeedPost component #28 wires and shares #28/#30's intent-preserving-signup machinery (lines 281/287), so building it now (in the soon-replaced FeedActivityCard) would be throwaway. Follow-up `[SYS-GET-GATE]` #37: townhall *comments GET* is still auth-only though the System feed is admin-only to view (latent, low-risk).

## Step 3 — Promote button (DONE Conv 269)

The escalate-existing-post entry point. A per-post **Promote** action in `FeedActivityCard`, shown only where the viewer can promote, opening a shared-password prompt that calls `POST /api/feeds/promote`. Surfaces on the single-feed pages (`CommunityFeed` + `CourseFeed`) where the GET computes the feed-level `canPromote`; the home SmartFeed computes no `canPromote`, so it's deliberately out of scope here.

**ID contract decision (user, Conv 269) = the endpoint speaks Stream id.** The client addresses posts by their **Stream activity id** everywhere (reactions/comments POST `activityId: activity.id`), but the promote endpoint was built (Conv 262) keying on `feed_activities.id` — the FK the lane resolves from. Rather than thread the D1 id onto every activity on the read path (and repeat that join for every future promote surface), the endpoint now **resolves the Stream id to the canonical row** via `stream_activity_id`. The internal FK / `recordPromotion` / lane stay on `feed_activities.id`; only the HTTP input changed. This scales free to the future home-feed/nudge promote surfaces (they also only hold Stream ids).

**Built:**
- **Schema** (`migrations/0001_schema.sql`, pre-launch edits): `UNIQUE INDEX idx_feed_activities_stream` on `feed_activities(stream_activity_id)` — makes the new lookup an index hit + enforces the 1:1 indexing invariant (SQLite permits multiple NULLs for legacy rows); `UNIQUE INDEX idx_post_promotions_unique` on `(source_activity_id, to_feed_type, to_feed_id)` — the idempotency backstop.
- **Endpoint** (`src/pages/api/feeds/promote.ts`): body `{ streamActivityId, password }` (was `sourceActivityId`); resolves the source row `WHERE stream_activity_id = ?`; dropped the now-dead "no Stream activity" guard (the lookup key is non-null by construction); added an **idempotent early-return** — if the post is already promoted into the resolved target, return the existing promotion `{ alreadyPromoted: true }` (before the password gate, so a double-click isn't re-challenged) instead of writing a duplicate.
- **Client** — shared **`src/components/feed/PromoteButton.tsx`** (quiet up-arrow trigger → `FormModal` password prompt → idempotent POST → "Promoted ✓" flip; `className`-themed per surface). `FormModal` gained a `'password'` field type (masked). `SocialPost` gained an optional `actions` footer slot (stays display-only). Wired on **both** live renderers: `FeedActivityCard` (community feed, in its reaction bar) + `MattCourseFeed`→`SocialPost.actions` (course feed). `canPromote` flows from the feed GET into `CommunityFeed`/`MattCourseFeed` state (legacy `CourseFeed.tsx` also updated, though it's no longer the live course renderer).
- **Tests** — NEW `tests/api/feeds/promote.test.ts` (8): auth, missing id, unknown id (404), no-permission (403), gate-unconfigured (403), bad-password (403), success (200 → community target, one row), idempotent re-promote (200 `alreadyPromoted`, still one row). The Conv-262 lib tests (`promotion.test.ts` / `promotion-lane.test.ts`) are unchanged — `recordPromotion` + the FK still key on `feed_activities.id`.

**Browser-verified (Conv 269, local `:4321`, DOM-truth + real round-trip):**
- **Community feed** (`/community/automation-majors/feed`, admin promoter): the **Promote button renders** alongside the reaction/Comment bar (FeedActivityCard is the live renderer here); clicking opens the "Promote this post" password modal; a wrong/seed lookup surfaces the endpoint error inline ("Source post not found"). ✅
- **Real round-trip:** posted a fresh course post via the live `POST /api/feeds/course/intro-to-n8n` (dual-writes the **real** Stream id), then `POST /api/feeds/promote` → **200**, target correctly resolved to the parent community `automation-majors`; a **second** promote → **200 `alreadyPromoted:true`, same id**; D1 holds **exactly one** `post_promotions` row. Idempotency + Model-① reference confirmed end-to-end. ✅

**Both live feed surfaces wired (the browser check found the second one).** The unit tests were green but couldn't see *which* island the live route mounts:
- **Community feed** = `CommunityFeed` → `FeedActivityCard` (legacy island under the Matt shell).
- **Course feed** = `MattCourseFeed` → Matt `SocialPost` (the `@matt-source` redesign, Conv 260) — **not** the legacy `CourseFeed.tsx` originally edited.

To avoid duplicating the modal+fetch logic across both, it was **extracted into a shared `src/components/feed/PromoteButton.tsx`** (button + password `FormModal` + idempotent POST + "Promoted" flip), themed per surface via a `className` prop. `FeedActivityCard` renders it in its reaction bar; `MattCourseFeed` renders it via a new optional **`actions` slot on `SocialPost`** (the primitive stays display-only — it just renders the node; interactivity lives in the child). Both browser-verified end-to-end (Conv 269): **course feed** UI round-trip (post → click Promote → password → "Promoted", one D1 row, intro-to-n8n→automation-majors) + **community feed** button renders post-refactor.

**🟠 Seed-data caveat (not a code bug):** the dev seed's `feed_activities.stream_activity_id` are placeholders (`stream-fa-NNN`), which never match the real Stream activity ids the live feed returns — so the button 404s on **seed** posts. Posts created through the app (real dual-write) promote correctly (verified). A future seed-fidelity fix (real-shaped stream ids) would let the button work on seeded posts too.

**Step 3 COMPLETE.** The per-post button is the *action*; the **PromoteNudge** (Step 7) that points users at it is built LAST.

---

## SYS-RENAME #30 ✅ DONE (Conv 259)
Foundation for the adopted model: "The Commons" → **System** community, its feed admin-only + un-named. Executed in two boundaries (C then A), announcements deferred.

**Decision (Conv 259):** boundary **C (mechanical enum rename)** first, then **A (admin-only lockdown)**; the Announcement data model + member/visitor fan-out **deferred to `[ADMIN-FEED-UI]` #33** (it genuinely belongs there; avoids a half-built `is_announcement` column). Cosmetic route/Stream/label rename split to `[SYS-NAMING]` #36.

**Key learning — enum and Stream group are decoupled:** D1 `feed_type` (`townhall`/`community`/`course`, with `feed_id='the-commons'`) is independent of the Stream feed group `('townhall','main')`. They share the name but address different things → the D1 enum could be renamed `'townhall'→'system'` while the Stream group stays `'townhall'`, keeping reads/writes consistent as long as all D1 sites agree. This made C a clean enum-only rename and deferred the Stream/route rename to the cosmetic #36 follow-up.

**Boundary C (enum rename, no behavior change):** schema `feed_type` CHECK `'townhall'→'system'` (`0001_schema.sql`, `0004_feed_activity_index.sql`); dev seed 6 rows; `getTownhall→getSystemFeed`; FeedActivityCard style keys; ~21 source files + affected tests retokenized. Excluded the 3 Stream-group sites. Gates green (tsc/astro/lint/build + 164 affected tests).

**Boundary A (admin-only lockdown):** `getFeeds` admin-gated; member candidate query + badges exclude System (`is_system=0`); `/community/the-commons` 404s non-admins; `/communities` System pin removed; GET/POST `/api/feeds/townhall` require admin (+403 regression test); `autoJoinTheCommons` retired (3 callers + `onboarding.ts` deleted). All 5 gates green incl. full suite **6481/6481**.

**New pattern:** System community is admin-only — gate at `getFeeds` (isAdmin), member candidate query (`is_system=0`), badge query (`is_system=0`), community detail page (404), and feed API endpoints (isUserAdmin).

**Interim consequence:** members get NO System broadcast until `[ADMIN-FEED-UI]` #33 ships the Announcement model. Acceptable pre-launch.

🟠 **Local D1 follow-up (folded into `[SYS-NAMING]` #36):** local D1 still carries old `feed_type='townhall'` rows + the pre-rename CHECK — needs `npm run db:setup:local:dev` before the dev server reflects the renamed schema (D1 CHECK is not retroactively enforced, so existing rows won't error, but reads keyed on `'system'` won't match them).

---

## DISCOVERY-RAILS — daily discovery-data layer

**Scope (client-meeting RESOLVED 2026-06-10):** a precomputed, global, daily-refreshed dataset of **6 rails** = {trending, popular, new} × {communities, courses}, top-N each. Global (un-personalized) so it computes once; clients apply a personalization lens via each entity's `topicIds`. The general discovery-data layer — reused by the home marketing feed texture, and (via `[RECO-UNIFY]` #34) the `/communities`+`/courses` recommendation bands, replacing the per-request `getDiscoveryCandidates` aggregation.

**Signals:** *popular* = magnitude (`student_count`/`member_count`, cumulative); *new* = `created_at` within window; *trending* = velocity = trailing-window count of `enrollments.enrolled_at` / `community_members.joined_at` (a rate, not absolute — a true prior-window delta is a future tuning refinement, robust enough at Genesis scale).

**Architecture (client-decided):** daily scheduled job (Cloudflare Cron Trigger → Worker) → KV JSON blob → one API endpoint serves the blob → client localStorage cache (version/date stamp + freshness check) → client-side personalization lens.

**Build = 4 phases. User chose scope C (Conv 261) = full block across convs.**

| Phase | What | Status |
|------|------|--------|
| **1** | Aggregation lib `src/lib/discovery-rails/` (`types.ts` · `config.ts` · `compute.ts` · `index.ts`) — 6 rails from D1, `platform_stats` `discovery_%` runtime dials (code-defaulted, no migration), full unit tests. | ✅ Conv 261 |
| **2** | Serving endpoint `GET /api/discovery/rails` — two-tier: KV-read (prod) with **on-demand-compute fallback** (dev/cold/stale/missing binding). Un-gated. | ✅ Conv 261 |
| **3** | `DISCOVERY_CACHE` KV namespace + wire the daily job into the existing `workers/cron/` Worker. | ✅ STAGING (Conv 261) — namespaces created, deployed + verified live; **prod deploy folded into MVP-GOLIVE** (Conv 262 — premature prod cron reverted) |
| **4** | Client localStorage cache + freshness check + topic_id personalization lens (data layer). | ✅ Conv 261 |

### Conv 261 — Phase 3 DEPLOYED + VERIFIED on staging (prod deploy pending)

All code + config is in place; KV namespaces created and wired; deployed + verified live on staging. Only the prod deploy remains:

**New/changed (code repo):**
- `src/lib/discovery-rails/refresh.ts` — `refreshDiscoveryRails(db, kv)` = compute blob → `kv.put`. Kept separate from `compute.ts` so the pure aggregation has no KV dependency.
- `src/lib/discovery-rails/types.ts` — added shared `DISCOVERY_RAILS_KV_KEY = 'discovery-rails'` (writer + reader can't drift); endpoint now imports it instead of a local const.
- `workers/cron/src/index.ts` — `Env.DISCOVERY_CACHE?: KVNamespace` (optional) + a guarded daily refresh call in `scheduled()`, in its own try/catch so a rails failure never fails session cleanup. Skipped entirely until the binding exists.
- `wrangler.toml` (×3 stanzas: top-level, production, staging) + `workers/cron/wrangler.toml` (×2: staging, production) — `DISCOVERY_CACHE` binding (scaffolded with placeholder ids, **now wired to the real ids** created below). Cron build dry-run validated (69 KiB, bindings recognized, `@lib` chain resolves).

**DONE on staging (Conv 261):**
- **KV namespaces created** — prod `5fb43d64e4d94cf881b9cbeb349733f1`, staging `d4f010e271b64adcb4bf392d8e6e16bf` (titles `DISCOVERY_CACHE` / `DISCOVERY_CACHE_staging`). Both ids wired into `wrangler.toml` (top-level + production = prod id; staging block = staging id) and `workers/cron/wrangler.toml` (same per env — writer + reader share storage).
- **Deployed to staging** — `npm run deploy:cron:staging` (cron writer) + `npm run deploy:staging` (main-app reader). Both workers report the `DISCOVERY_CACHE` binding on the staging id.
- **Verified live:** `GET https://peerloop-staging.brian-1dc.workers.dev/api/discovery/rails` → first `X-Discovery-Source: compute` (cold KV), then after the :45 cron tick → `X-Discovery-Source: kv` (6 rails, 9 items, `generatedAt` = tick time). compute-fallback AND precomputed-KV paths both confirmed end-to-end.

**PROD deploy — remaining (when ready):** `npm run deploy:cron:prod` + `npm run deploy:prod` (the prod KV id is already wired). Note: prod cron runs every 30 min, so the first `kv` flip lags up to 30 min.

**Note:** the refresh runs on every cron tick (cheap + idempotent), not a dedicated daily trigger — keeps the blob fresh between the heavier daily aggregations without a second schedule.

### Conv 261 — Phase 4 BUILT (client data layer)

`src/lib/discovery-rails/client.ts` (browser; imports type-only + the version constant from `./types`, **never the index barrel**, so server compute/D1 never enters the client bundle):
- `loadDiscoveryRails(opts)` — fetch `GET /api/discovery/rails`, cache in `localStorage['peerloop_discovery_rails']` with `{fetchedAt, version, blob}`; freshness = TTL (default 6h) + version-match; on fetch failure (non-ok or throw) falls back to a stale cache, else throws; storage/fetch/now all injectable.
- `clearDiscoveryRailsCache(storage?)` — drop the cache (logout / cold re-fetch).
- `applyPersonalizationLens(blob, {viewerTopicIds, filterToInterests})` — pure; visitor (no interests) → global as-is; otherwise interest-overlapping entities float to the top of each rail (stable for ties), optional hard-filter. Caller supplies interests; the blob stays global + shared (one cache entry).
- Tests: `tests/lib/discovery-rails-client.test.ts` (14) — cache hit/miss/TTL/version/force/stale-fallback/no-storage + lens visitor/boost/rank/filter.

**Consumers wire it in later:** `[HOME-FEED-MERGE]` #28 (home marketing texture) + `[RECO-UNIFY]` #33 (`/communities`+`/courses` bands). This phase ships the data layer only — no rail UI.

### DISCOVERY-RAILS status after Conv 262 — STAGING-COMPLETE, prod folded into MVP-GOLIVE
Code-complete (Phases 1, 2, 4 ✅; Phase 3 deployed + verified on **staging** ✅). The endpoint serves real data via the compute-fallback AND the precomputed daily KV blob (both paths verified live on staging), and the client consumes it — so the feature is **functional now** on staging.

**Conv 262 prod-deploy re-scope:** RESUME-STATE framed #30's remaining step as a "prod deploy"; taken literally it ran `deploy:cron:prod`, which deployed the `peerloop-cron` Worker to **production from the unmerged `jfg-dev-13-matt` dev branch** before any launch readiness. This was reverted the same conv (`wrangler delete --env production`) — prod is back to not-deployed. **Rule recorded** (`feedback_staging_is_deploy_target_prod_gated`): for all feature work the deploy target is **staging**; production has never been launched (MVP-GOLIVE ⏸️ DEFERRED — no prod secrets, prod D1 unmigrated). The discovery-rails prod deploy is therefore **folded into MVP-GOLIVE § CRON-CLEANUP** (one `peerloop-cron` Worker runs both BBB cleanup + discovery refresh; the main-app prod deploy serves `/api/discovery/rails`) — it lands at the launch event, NOT as a standalone feature deploy. Prod KV id (`5fb43d64e4d94cf881b9cbeb349733f1`) stays wired in `wrangler.toml` ×3 + `workers/cron/wrangler.toml`.

**Remaining for DISCOVERY-RAILS:** only the downstream consumers (`[HOME-FEED-MERGE]` #28 home marketing texture + `[RECO-UNIFY]` #34 reco bands). The prod deploy is no longer tracked here — it is MVP-GOLIVE's.

### Conv 261 — Phases 1+2 BUILT

**Key infra findings (from exploration):**
- **Cron is NOT net-new** — a standalone cron Worker already exists at `workers/cron/` (`scheduled()` handler + `workers/cron/wrangler.toml`, prod every 30 min, currently `runSessionCleanup`). The main Astro app is Workers-SSR and can't host its own `scheduled()` handler, so this separate worker IS the established pattern → Phase 3 extends it.
- **KV is the one real gap** — only the adapter-managed `SESSION` namespace exists (JWT-cookie sessions; app code doesn't touch KV). Phase 3 must **create a new `DISCOVERY_CACHE` namespace** (`wrangler kv namespace create`) — a remote, guarded op needing the CF account; CC can't do it autonomously.

**New files (code repo):**
- `src/lib/discovery-rails/{types,config,compute,index}.ts` — the aggregation layer.
- `src/pages/api/discovery/rails.ts` — the serving endpoint (KV tier inert until P3; computes on demand).
- `tests/lib/discovery-rails.test.ts` (17 at Phase 1; +1 refresh test added at Phase 3 → 18) + `tests/api/discovery/rails.test.ts` (2).

**Design notes carried to P3/P4:**
- Blob shape = `DiscoveryRailsBlob { generatedAt, version, windows, rails[] }`; `DISCOVERY_RAILS_VERSION = 1` — the endpoint's KV tier ignores a stale-version blob so a bump self-invalidates without a manual purge. P4 client stamps against the same version.
- Endpoint KV access is a type-safe optional probe (`cfEnv.DISCOVERY_CACHE` cast through `Record`) — lights up automatically when P3 declares the binding; no endpoint edit needed.
- `platform_stats` `discovery_%` dials (`discovery_new_window_days`=30, `discovery_trending_window_days`=7, `discovery_top_n`=12, `discovery_popular_min_count`=0) are code-defaulted — seeding rows is optional (admin-visibility, `[ADMIN-FEED-UI]`/`[RECO-UNIFY]` territory).
- Course-entity gate mirrors recommendations (`is_active=1 AND deleted_at IS NULL AND is_archived=0 AND is_retired=0 AND suspended_at IS NULL`); community gate = `is_public=1 AND is_system=0 AND is_archived=0`. Community `topicIds` derive through `progression → courses → course_tags → tags.topic_id` (communities have no direct tags).
- Cutoffs computed in JS via `getNow()` (mockable, ISO-string param) — no SQL `datetime()` (dodges the §SQLite Datetime pitfall).

**Baseline (Conv 261):** tsc 0 · astro 0/0/0 · lint clean · suite **6508/6508** (377 files) · build ✓.
