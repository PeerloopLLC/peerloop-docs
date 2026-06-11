# HOME-FEED-MERGE — merge SmartFeed into Home + public/visitor feed mode

**Status:** ✅ ADOPTED — BUILD (client signed off Conv 259: participatory townhall retired / "The Commons" → **System** community, its feed admin-only + un-named; promotion policy approved — **free at launch, password-gated**, see [PROMOTE-PIPELINE]). Design complete; the build phases below are now active. **Foundation `[SYS-RENAME]` #30 ✅ DONE Conv 259** (enum rename + admin-only lockdown — see § SYS-RENAME below). **`[POST-MATT]` #35 🔨 BUILT Conv 260** (boundary B — display-only `FeedPost` adapter + `SocialPost.feedLink`; component-only, not yet live-wired — see § post-format-matt.md). **`[DISCOVERY-RAILS]` #31 🔨 CODE-COMPLETE Conv 261** (Phases 1/2/4 built, Phase 3 deployed + verified on staging; prod deploy + consumers remain — see § DISCOVERY-RAILS below). Remaining build tasks: `[PROMOTE-PIPELINE]` #32 · `[ADMIN-FEED-UI]` #33 · `[RECO-UNIFY]` #34 · `[SYS-NAMING]` #36 · live wiring (#28 phase 4).
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

---

## Build tasks (promoted Conv 259 on client adoption)
Both adoption gates cleared Conv 259 → the 5 reserved codes are now live TodoWrite tasks, plus a foundation rename + a cosmetic-rename follow-up:

| # | Task | Scope |
|---|------|-------|
| #30 | `[SYS-RENAME]` ✅ DONE Conv 259 | `feed_type` enum `'townhall'→'system'` (boundary C) + admin-only System lockdown (boundary A); announcements deferred to #33. See § SYS-RENAME below. |
| #31 | `[DISCOVERY-RAILS]` 🔨 CODE-COMPLETE Conv 261 (prod deploy + consumers remain) | daily discovery-data service (the marketing-candidate / Discovery Rails source). Phases 1 (lib) + 2 (endpoint) + 4 (client cache/lens) built; Phase 3 (KV+cron) deployed + verified on **staging** — prod deploy + downstream consumers (#28, #34) remain. See § DISCOVERY-RAILS below. |
| #32 | `[PROMOTE-PIPELINE]` | promotion epic — **free + password-gated** at launch (Stripe payment deferred). Password-gate policy **RESOLVED Conv 262** (see clarifications below): one global password · per-promotion · bcrypt in `platform_stats` · every step gated. |
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
- **Lib** `src/lib/promotion/`: `resolvePromotionTarget` (Course→Community via `courses.progression_id → progressions.community_id`; Community→System `the-commons`; System→null; course-without-progression→null), `canPromote` role matrix (admin / creator / certified-teacher at both levels — a capability **separate from** `canPost`, deliberately bypassing the admin-only System rule), the password `gate` (bcrypt hash in `platform_stats` key `promotion_gate_password_hash`, **fail-closed** when unconfigured), `recordPromotion`. `indexFeedActivity` extended to return the row id + accept `promotedFromActivityId`.
- **Endpoints**: `POST /api/feeds/promote` (auth → source exists → target exists → `canPromote` → gate configured → password valid → copy source text up via Stream + index with lineage + record event) · `GET|POST /api/admin/promotion-password` (admin set/rotate + status; never returns the hash).
- **Tests**: `tests/lib/promotion.test.ts` (19) — target resolution, role matrix at both levels, gate set/verify/rotate/fail-closed, lineage + event recording. Plus feed-activity regression (11).

**Still to build (later convs):** the "Promote" button in `FeedPost` with a per-promotion password prompt — **wait for `[HOME-FEED-MERGE]` #28 phase-4 live-wiring** to avoid rework; promote-a-course/community templates; the **Promoted lane** in the feed/rails; promote-nudges; the `/admin` password UI (folds into `[ADMIN-FEED-UI]` #33). Document the 2 new endpoints (route maps auto-regen at r-end; add an API-REFERENCE row).

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
| **3** | `DISCOVERY_CACHE` KV namespace + wire the daily job into the existing `workers/cron/` Worker. | ✅ STAGING (Conv 261) — namespaces created, deployed + verified live; **prod deploy pending** |
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

### DISCOVERY-RAILS status after Conv 261
Code-complete (Phases 1, 2, 4 ✅; Phase 3 deployed + verified on **staging** ✅). The endpoint serves real data via the compute-fallback AND the precomputed daily KV blob (both paths verified live on staging), and the client consumes it — so the feature is **functional now**. Remaining: the **prod deploy** (`npm run deploy:cron:prod` + `npm run deploy:prod`; prod KV id already wired) and the downstream consumers (`[HOME-FEED-MERGE]` #28 home marketing texture + `[RECO-UNIFY]` #34 reco bands).

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
