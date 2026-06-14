# Plan — Finish the Feed / Promotion / Discovery group (reassembled by cohesion)

## Context

Planning in this group has repeatedly "missed something fundamental." The deeper cause — surfaced
by the user — is **the task decomposition itself**. The group was split into ~14 pseudo-isolated,
seemingly-serializable tasks, but again and again **one task needed a part of another**
(CommunityAnchor needs pipeline metadata that "belongs" to a different task; the FeedPost swap needs
both; entity-promo needs the anchors; three seed tasks all rewrite the same file). When a split
produces fragments that each need a slice of a sibling, the isolation is fake — it adds coordination
cost and buys no independence. That is the bug to fix.

This plan **reassembles** the fragments into a small number of **cohesive vertical units**, each
owning its full stack, so the only remaining dependencies are **whole-unit → whole-unit and
unidirectional**.

## The isolation principle (the crux — applies to the whole regroup)

A unit is correctly isolated only if:
1. **It owns every layer it touches** — data pipeline, schema, component, render, seed, tests — so it
   can be built *and verified* end-to-end without reaching into an unfinished sibling.
2. **Its dependencies are whole prior units, not pieces of a peer.** "U3 needs U2 (done)" is fine;
   "Step-4 needs the anchor-half of a task whose render-half is still open" is the failure mode.
3. **Dependencies are unidirectional.** No two units may each need a piece of the other.
4. **It has a standalone done-test** (a thing you can run/see that proves the slice works).

If a proposed unit violates any of these, merge it with the unit it leaks into.

## Reassembly — how the 14 fragments collapse into 3 units + cleanups

| Old fragmented tasks | → Cohesive unit | Why they're actually one thing |
|---|---|---|
| #38 SEED-STREAM-FIDELITY, #33 DISC-SEED, #31 SYS-NAMING (+ feed_public bug) | **U1 · Seed Foundation** | All rewrite the same seed/re-seed flow; splitting them = 3 collisions on one file |
| #3 ENTITY-ANCHOR, #39 COMMUNITY-ANCHOR, #30 RECO-UNIFY, #36 FEEDSHUB-ORPHAN (+ the pipeline-metadata work that had no task) | **U2 · Discovery Rendering** | One vertical: "discovered entities render with real anchors." Anchor + the metadata feeding it + the renderer using it are inseparable |
| #28 PROMOTE-PIPELINE (Steps 4+7), #34 PROMO-LIFECYCLE, #29 ADMIN-FEED-UI | **U3 · Promotion System** | One delivery system sharing schema, the lane, and the admin surface |
| #35 SYS-GET-GATE, #32 API-DISC-DOC, promote idempotency-race | **Cleanups** (genuinely independent one-offs — correct isolation) | No shared surface; each is a self-contained diff |
| #5 COMM-TAG-FILTER, #16 SUCCESS-COMMUNITY-VERIFY | **Parked (needs-spec)** | No recoverable intent; excluded from closure |

On approval, TodoWrite is restructured to match: the fragment IDs are merged into U1/U2/U3
parent tasks (old codes preserved as sub-checklists inside each unit), cleanups stay as-is, #5/#16
marked parked.

## Locked decisions (Conv 271)

- **Seed = Consolidate (durable):** `seed-feeds.mjs` becomes the single canonical feed seed; SQL
  seed's `feed_activities` INSERTs removed; script wired into standard setup.
- **SYS-NAMING = display strings only:** keep slug `the-commons`; fix labels + DB `community.name`.
- **Parked:** #5, #16 (do not gate group closure).

---

## U1 · Seed Foundation  ✅ DONE (Conv 271 data layer + Conv 272 close)  *(no dependencies)*

**✅ CLOSED Conv 272.** Data layer done Conv 271 (canonical `seed-feeds.mjs`, 19/19 real Stream UUIDs).
This conv closed the **density half**: the discovery rails were only 2/6 populated because the rail
compute applies time-windows (`new` <30d, `trending` velocity <7d) but the rail-source rows
(courses/communities/enrollments) carried fixed historical dates that never satisfy those windows.
Per user directive — *"we built a way to make feeds relative to the date at which they were seeded"* —
extended the seed's existing **"TIMESTAMP FRESHNESS"** mechanism with a new **PART C: DISCOVERY RAILS
FRESHNESS** in `migrations-dev/0001_seed_dev.sql` (+34 lines): id-targeted post-INSERT
`strftime('%Y-%m-%dT%H:%M:%fZ', 'now', '-N days')` UPDATEs on the rail-source tables (new/course +
new/community + its full dependent tree + trending/course + trending/community), **inversion-safe**
(freshen whole dependent sub-trees in step so a completed-2024 enrollment can't predate a 6-day-old
course). Re-seeded local D1 → **all 6 rails populate**; home marketing feed re-screenshotted full &
varied. Integrity check: no new timeline inversions (the only inversions are 10 pre-existing
the-commons join-before-founding rows, excluded from rails → tracked `[COMMONS-DATE]` #38). **5-gate
green** (tsc/astro 0-0-0 · lint · test 6634 · build). Code `87dfe2b3`.

**➡ U2 · Discovery Rendering ✅ DONE (Conv 273) — U3 now UNBLOCKED.** U1's done-test (real Stream IDs
+ all 6 rails full + home feed full & varied) was the verify-enabler U2/U3 depend on.

**One cohesive seed pass** (doing these separately = three re-seed churns + collisions on one file):
- **Consolidate** (`scripts/seed-feeds.mjs`): port the SQL seed's feed content into the script
  (same communities/courses; posts + replies), **remove** the 28 `feed_activities` INSERTs from
  `migrations-dev/0001_seed_dev.sql:~932-972`, wire the script into `db:setup:local:dev` so the
  standard command ends with **real Stream IDs**. (Safe: nothing references `stream-fa-*`/`fa-0NN`;
  `content_flags` use separate mocks.)
- **Broaden** (#33): add more public courses/communities (today only 3 public communities + 6
  courses → rails render ~half-full) to the script's entity + post sets.
- **Naming** (#31, display-only): fix "The Commons" labels (`FeedPost.tsx`, `_FeedPostDemo.tsx:191`,
  `src/pages/api/feeds/townhall.ts:164`) + core-seed `community.name`; keep slug.
- **Latent-bug fix:** `src/lib/discovery-rails/compute.ts:85` add `AND c.feed_public = 1` to
  `COURSE_BASE` (communities already gate `is_public`; courses leak members-only into public
  discovery). Test already expects it (`discovery-rails.test.ts:96`).

**Done-test:** `db:setup:local:dev` → real Stream IDs in `feed_activities`; `/api/discovery/rails`
+ home marketing feed render full & varied with real post bodies (browser). Unlocks real
browser-verify for U2/U3.

---

## U2 · Discovery Rendering  ✅ DONE (Conv 273)  *(depended on: U1 for verify only — built/unit-tested alone)*

**✅ CLOSED Conv 273.** One-shot full build of the discovery-rendering vertical (code `9379a85a`).
`enrichment.ts` `fetchDiscoveryAnchors` threads real anchor metadata onto `discoveryContext.anchor`
(course `{creator via creator_id→users, level, formatted rating}` + community `{icon, member_count,
14d vitality}`); NEW `@matt-inspired` `CommunityAnchor.tsx` (neutral palette — no `entity-community`
tokens; emoji-or-group glyph; members + vitality chips; primary Join CTA; mirrors `CourseAnchor`, no
shared base per Conv-184); `CourseAnchor.tsx` `ratingLabel` made optional with the chip hidden at 0
reviews. **🔴 Plan-premise corrected:** the "no rating system in schema → omit `ratingLabel`" note
(line below) was WRONG — research found real `courses.rating`/`rating_count` (fed by `course_reviews`)
with an established `X.X (N reviews)` label format; revised to source the real rating and hide the
chip ONLY at 0 reviews (honest-orphan). `SmartFeed.tsx` sample-post→`FeedPost` swap with a dismiss
wrapper persisting via `/api/feeds/smart/dismiss`; member-post stays `FeedActivityCard` (live
reactions preserved). Removed superseded `getDiscoveryCandidates` (+ `index.ts` re-export) and
deleted orphan `FeedsHubPanel.tsx`. **Done-test met (browser, authed):** both anchors render with
correct chips + direct CTAs + dismiss; 28 live member-post reaction controls intact. **5 gates green**
(tsc/astro 0-0-0 · lint · test **6643** · build). Follow-up: `DiscoveryCard` now orphaned (kept +
flagged) — delete in a cleanup once U2 is client-vetted.

**➡ U3 · Promotion System is now UNBLOCKED (next).** U3b (entity-promo render) depends on U2 whole,
which is now complete; build order U3a → U3b → U3c → U3d.

**One vertical slice** — "discovered (non-member) entities render with real anchors." Owns the
pipeline, the component, and the renderer together (the split that previously leaked):
- **Pipeline metadata** (`src/lib/smart-feed/enrichment.ts` ~298-322; `marketing.ts`
  `MarketingCandidate`; `scoring.ts` `ScoredCandidate`; `index.ts` `EnrichedCandidate`): thread the
  fields anchors need — community `icon`/`member_count`/14d-vitality; course `creator` name (via
  `creator_id`→`users`), `level` — plus a per-item **`ctaUrl`** computed once
  (`src/lib/smart-feed/cta.ts buildDiscoveryCtaUrl`) so the render swap can't regress the Phase-6
  visitor `/signup?redirect=…` flow. (No rating system in schema → `ratingLabel` omitted/placeholder.)
- **CommunityAnchor** (`src/components/entity/CommunityAnchor.tsx`): mirror `CourseAnchor.tsx`
  (no shared base — Conv-184); consume the metadata; accept `ctaHref` override.
- **FeedPost render swap** (`SmartFeed.tsx` ~327-337): sample-post `DiscoveryCard` → `FeedPost`
  with `embed={<Course/CommunityAnchor ctaHref={item.ctaUrl}/>}`. Member-post stays `FeedActivityCard`
  (FeedPost is display-only; using it for member posts regresses live reactions).
- **Remove superseded path:** delete `getDiscoveryCandidates` (`candidates.ts:208-365` + export
  `index.ts:44`) — zero callers/tests. **Delete** orphan `FeedsHubPanel.tsx` — zero consumers.

**Done-test:** on U1 data, visitor + authed home feed shows entity anchors with correct CTAs
(visitor → signup-redirect; authed → entity); reactions still live on member posts (DOM-verify).

---

## U3 · Promotion System  ✅ DONE (a Conv 274 · b Conv 274 · c Conv 276–277 · d Conv 278–279)  *(depended on: U2 whole — for entity-promo render; U1 for verify)*

**One delivery system.** May cleave into the sub-slices below **only at clean whole-unit seams**
(each sub-slice owns its layer + a done-test; deps are whole-prior-slices, never a peer's half).
This is the multi-conv core.

- **U3a · Backend substrate** *(no U2 dep — self-contained)* — ✅ **DONE Conv 274.** Promotion
  lifecycle is **computed, not stored** (decision Conv 274): no `expires_at` column — "active" =
  `created_at` within the `promo_active_duration_days` dial (the lane already filters by a
  `created_at` window; `expires_at` deferred until paid variable durations are real, per the schema's
  "avoid half-built columns" stance). Shipped: 2 `platform_stats` dials (`promo_active_duration_days`=14,
  `promo_retention_days`=60) seeded in `0002_seed_core.sql`; `loadPromotionConfig` (`src/lib/promotion/config.ts`,
  mirrors `loadRailsConfig`; **escaped `LIKE 'promo\_%'` so it can't swallow the
  `promotion_gate_password_hash` key**); `purgeExpiredPromotions` (`src/lib/promotion/retention.ts`,
  shared-fn cleanup.ts pattern, `strftime` + non-positive-retention no-op guard); cron purge wired
  into `workers/cron/src/index.ts` isolated like the rails refresh; `promoted.ts` defaults the lane
  window to the active-duration dial (explicit `?sinceDays=` overrides). Tests: `promotion-config.test.ts`,
  `promotion-retention.test.ts`. **Announcement data model DEFERRED to U3c** (decision Conv 274): it
  has no done-test in U3a and the substrate already exists (System-feed activities + `notifications`
  'system' + the deferred smart-feed Announcements lane), so the model is defined alongside its
  author+fan-out in U3c where its real columns become knowable. *Done-test (met):* cron purges expired
  rows; dials read/write.
- **U3b · Entity-promo content** *(needs U2 + U3a)* — **backbone ✅ DONE Conv 274; A2 composer IN PROGRESS.**
  Composer-mount was NOT an open gate — it's pre-decided (README §A2, Conv 263: dedicated
  "Promote a course/community" composer, author-direct-at-target). Render model (resolved from SoT +
  code trace Conv 274): the promoted-lane UI consumer is entirely unbuilt, so the render path lands in
  the **home smart feed** by mirroring U2's discovery-anchor seam keyed on `promoEntityId`, NOT the
  post's home feed. **Backbone shipped:** `enrichment.ts` `readPromoFields` + `promoContext` (anchor
  resolved from `promoEntityType:promoEntityId` via a reuse of `fetchDiscoveryAnchors`); `SmartFeed.tsx`
  entity-promo render branch (FeedPost + Anchor, "Take Course"/"Join Community" CTA, no dismiss),
  checked BEFORE discovery; kept `kind='sample-post'` so the orchestrator's injection logic can't
  silently drop them; `seed-feeds.mjs` posts `postKind:'entity_promo'` custom fields + 2 seed promos;
  orchestrator tests. 5 gates green (6651 tests).
  - **A2 composer ✅ DONE Conv 274.** Placement = **Option A** (decided Conv 274): author into the PROMOTED
    entity's OWN public feed; the home backbone surfaces it via discovery — no unbuilt lane consumer needed.
    Shipped: `createEntityPromo` (`src/lib/promotion/create.ts` — Stream post w/ custom fields + `feed_activities`
    + a `post_promotions` row, from=to=entity's feed); `POST /api/feeds/promote-entity` (gating: auth → entity
    exists+public → `canPromote` → gate configured → password); `GET /api/feeds/promotable-entities` (the
    picker's creator/teacher+public list); `EntityPromoComposer.tsx` (`@matt-inspired` island). **Mount DEFERRED
    to U3d** (decided Conv 274) — the composer's home is the `/creating`+`/teaching` workspace prompt that U3d
    builds; until then it's unit-tested in isolation. 5 gates green (6660 tests). **U3b fully complete.**
- **U3c · Admin surface** *(needs U3a)* — **PARTIAL: Promotion Settings page ✅ DONE Conv 276; moderation + announcements remain.**
  U3c is four independent sub-verticals (clean seams, no inter-dep); the Conv-276 cut (user-chosen) shipped the first two:
  - **✅ Settings page (①+② · Conv 276):** new `/admin/promotion-settings` (`@matt-inspired`, `PromotionSettingsAdmin.tsx`)
    with two cards — **password set/rotate** (drives the existing `GET/POST /api/admin/promotion-password`) and
    **lifecycle-dial editing** (active-duration + retention). New write path: `savePromotionConfig` (`config.ts`,
    batched ON-CONFLICT upsert mirroring the gate, canonical seed-row shape self-heal) behind a NEW admin-gated
    `GET/POST /api/admin/promotion-config` (positive-int [1,3650] validation + the `retention ≥ active` invariant).
    Nav: new "Settings" section in `AdminNavbar`. Tests: +4 `savePromotionConfig` cases in `promotion-config.test.ts`.
    5 gates green (tsc / astro 0-0-0 / lint / test **6664** / build). **Browser-verified Conv 276** (Chrome bridge,
    admin=brian): page renders + nav-active; password Set→Configured (DOM + API) + button→Rotate; dials Edit 7→21/30→90
    (DOM card + DB both updated); backend invariant + range validation exercised via API (retention<active / non-int /
    0 / >3650 all 400, no mutation). Local D1 dials reset to 14/60; gate left configured (re-seed clears).
  - **✅ ③ System-promotion moderation view (Conv 276):** admins review + take down posts escalated into the
    admin-only System feed via the gate (threat: `canPromote` lets a community creator/certified-teacher push
    Community→System). New `src/lib/promotion/moderation.ts` (`listSystemPromotions` join promoter+author names,
    scoped `to_feed_type='system'`; `removeSystemPromotion` scope-guarded delete of the `post_promotions` row only —
    model ① keeps the source post). Endpoints: `GET /api/admin/moderation/promotions` (admin-gated, best-effort Stream
    content preview) + `POST …/promotions/:id/remove`. UI: new `SystemPromotionsModeration.tsx` + thin `ModerationPage.tsx`
    tab shell ("Flagged Content" | "System Promotions") so `ModerationAdmin` stayed untouched; `moderation.astro` mounts
    the shell. No `moderation_actions` audit row (its `flag_id` is NOT NULL→content_flags; a promotion isn't a flag).
    Tests: +7 in `promotion-moderation.test.ts`. 5 gates green (tsc / astro 0-0-0 / lint / test **6671** / build).
    **Browser-verified Conv 276:** tab switch works; seeded promotion renders with promoter/author/origin/when + real
    Stream content preview; Remove→confirm→gone (DOM empty-state + API 0 + D1: promo row deleted, source post intact).
  - **✅ ④ Announcement author + fan-out (Conv 277).** Architecture decided with the user (CLAUDE.md §Critical Rule):
    **A+B model** — every announcement renders in the home smart feed at READ time (read-time fan-out, mirroring
    promotion delivery model ①), and an optional "also notify" fans out a per-user 'system' notification for urgent
    ones. **D1-only storage** (decision: authored fresh, no Stream activity / reactions needed) + an optional admin-set
    `active_until` (the one stored-expiry divergence — a maintenance window has a real end-time a dial can't express;
    NULL falls back to an `announcement_active_duration_days` dial). Shipped: `announcements` + `announcement_dismissals`
    tables (+ 2 lifecycle dials); `src/lib/announcements/{config,create,query,dismiss,retention}.ts` + `getAllActiveUserIds`;
    orchestrator pins active announcements atop the feed (first-page-only, never in the cursor) + `AnnouncementCard.tsx`;
    `/admin/announcements` page + `AnnouncementsAdmin.tsx` (compose + manage) + AdminNavbar entry; endpoints
    `GET/POST /api/admin/announcements`, `POST …/:id/remove`, `POST /api/announcements/dismiss`; cron purge wired.
    15 tests; 5 gates green (tsc / astro 0-0-1hint / lint / test **6686** / build). **Browser-verified Conv 277**
    (Chrome bridge, admin=brian): create (API + form, notify fan-out=11) → pins at feed `activities[0]` (cursor keys
    off a sample-post) → renders with CTA → dismiss removes + persists (gone from API) → admin list Active badge +
    inline-confirm remove (2→1). **U3c COMPLETE.**
- **U3d · PromoteNudge** *(needs U3b — promote works end-to-end)* — **✅ FULLY DONE (workspace card Conv 278; per-post `[U3D-POST]` Conv 279).**
  Decisions (Conv 278, with user): engagement gate = **configurable dial** (`promo_nudge_min_engagement`,
  default 3, admin-editable in the existing Promotion Settings page) — gates *nudging*, not *promoting*;
  both surfaces requested, but a **premise correction** during the build (Premise-Check Gate) found the
  per-post *post-escalation* affordance **already exists** (`PromoteButton` → `POST /api/feeds/promote`,
  server `canPromote`, on every eligible entity-feed post), so the literal "per-post (server canPromote)"
  is already shipped. The genuinely-new per-post work — an *attention-drawing* nudge (ProgressionNudge-style,
  entity-promo model) — was **deferred** (user-chosen) to a scoped follow-up (`[U3D-POST]`) pending a tighter
  spec → **shipped Conv 279 (below).** **Workspace card shipped Conv 278:** `promo_nudge_min_engagement` dial
  (`config.ts` + `0002_seed_core.sql` + `api/admin/promotion-config.ts` + `PromotionSettingsAdmin.tsx`);
  `GET /api/feeds/promotable-entities` extended with per-entity `engagementCount` + top-level `minEngagement`;
  new self-gating `src/components/promotion/PromoteNudge.tsx` (fetches eligibility, renders nothing unless the
  viewer owns ≥1 entity clearing the floor, expands `EntityPromoComposer` inline) mounted on `/creating` +
  `/teaching` overview. Tests: `PromoteNudge.test.tsx` (+6) + `promotion-config.test.ts` (+1). 5 gates green
  (test **6693**); browser-verified Conv 278 (creator=guy-rymberg, admin=brian). **EntityPromoComposer is now
  mounted — U3b's deferred mount is closed.**
  - **`[U3D-POST]` per-post attention nudge ✅ DONE Conv 279.** Spec grounded by reading the existing promotion
    model: the deferral note framed it as "entity-promo model + engagement floor," but the code revealed it's the
    **per-post** model (`PromoteButton` + Stream `reaction_counts`), entirely distinct from the *entity* PromoteNudge
    model — they share only the verb "promote." Decisions (user, 3 pickers): **(1) new dedicated dial** (not reuse
    the entity dial — post reactions/comments vs entity members are different units); **(2) persist until promoted**
    (stateless — highlight computed every render from live engagement, no localStorage, sidesteps the
    `[NUDGE-CACHE-FLASH]` class); **(3) elevate the in-card PromoteButton** (accented state owned *inside* the shared
    leaf component so the highlight can't drift across the two render paths). The affordance only renders where
    `canPromote` is true (course + community feeds; SmartFeed/HomeFeed/TownHallFeed don't set it → out of scope).
    **Shipped:** new `promo_post_min_engagement` dial (default 3, `stat-promo-004`) in `lib/promotion/config.ts`
    (interface + default + `DIAL_ROWS.postMinEngagement` + loader + save batch), seeded in `0002_seed_core.sql`,
    validated (`parseCount`) in `api/admin/promotion-config.ts`, surfaced as a 4th card (grid → 2×2) in
    `PromotionSettingsAdmin.tsx`; NEW pure `lib/promotion/engagement.ts` (`postEngagement` sums all reaction kinds +
    comments; `isPromoteHot(counts, floor)` — undefined floor → never hot; no D1 import → client-bundle-safe);
    `PromoteButton` gains a `hot` prop owning the accented HOT_TRIGGER state (indigo pill, flame icon, "Resonating —
    promote" cue), with `ml-auto` moved to a wrapper span in `FeedActivityCard` since hot mode discards the caller
    className; `postPromoteFloor` threaded parallel to `canPromote` (course/community GETs return it when `canPromote`
    → CourseFeed/CommunityFeed/MattCourseFeed → FeedActivityCard → PromoteButton). Tests: NEW `promotion-engagement.test.ts`
    (+8), extended `promotion-config.test.ts` (4-dial round-trip/seed-shape/upsert-count), +5 `FeedActivityCard`
    promote-state tests. **5 gates green** (tsc / astro 0-0-1hint / lint / test **6707** / build).
    **Browser-verified Conv 279** (Chrome bridge, DOM-truth, creator=guy-rymberg, admin=brian): bracketed a fixed
    0-engagement post — floor=0 → button renders "Resonating — promote" + HOT_TRIGGER class + flame SVG; floor=5 →
    quiet "Promote" (transparent, fw400). Both branches confirmed; also exercised the admin POST/GET round-trip +
    `loadPromotionConfig` default fallback. Local dial restored to 3. **U3d FULLY COMPLETE.**

**Done-test (group):** promote a real seed post Course→Community→System end-to-end in browser;
it appears in the higher feed via the lane; expires per dial; admin can moderate; nudge surfaces.

---

## Cleanups  *(genuinely independent — slot anytime; this IS correct isolation)*  **— ✅ ALL DONE Conv 278**

- **#35 SYS-GET-GATE ✅ Conv 278:** added the `canParticipate({ type: 'system' })` gate to the townhall
  comments **GET** (`api/feeds/townhall/comments.ts`), mirroring POST/DELETE — a non-admin can no longer
  enumerate System-feed comments (it was previously only auth-gated). The test file's standing
  `[SYS-GET-GATE]` NOTE was replaced with a real "GET returns 403 for a non-admin" assertion.
- **#32 API-DISC-DOC ✅ Conv 278:** documented `GET /api/discovery/rails` in `docs/reference/API-COMMUNITY.md`
  (full blob shape: 6 rails × RailEntity, two-tier KV/compute serving, `X-Discovery-Source` header). The
  `/api/feeds/smart` auth-aware note was already documented (Conv 267). The route-map regen is automated at
  r-end (DOCGEN). **Subsumes the duplicate `[DISC-RAILS-DOC]` backlog task.**
- **Promote idempotency-race ✅ Conv 278 (`[PROMOTE-IDEMP]`):** `promote.ts` now wraps `recordPromotion`
  in try/catch — a concurrent double-promote (both pass the read-side idempotency check, then race on the
  `idx_post_promotions_unique` index) converts the loser's UNIQUE violation into the same graceful
  `{ alreadyPromoted: true }` the sequential path returns, instead of a 500. (Premise confirmed: the
  UNIQUE guard is a separate `CREATE UNIQUE INDEX`, not inline in the table def.)
- **`[SYS-NAMING]` — already satisfied (folded into U1, Convs 271–272):** the system community is
  consistently "The Commons" across the core seed (`community.name` + slug `the-commons`) and every src
  display string; no stray "Town Hall"/"Townhall" display strings remain. No work needed Conv 278.

## Parked / follow-ups (excluded from group closure)
- **#16 SUCCESS-COMMUNITY-VERIFY — ✅ VERIFIED Conv 280.** The "no recoverable intent" note
  was stale: this was the un-run verification of `[SUCCESS-COMMUNITY]` (the milestone composer
  on `/course/[slug]/success`, shipped Conv 243). Conv 280 ran the full A–E browser sweep
  (Chrome bridge, DOM-truth, enrolled=sarah.miller / non-enrolled=jennifer.kim on `intro-to-n8n`):
  composer renders CTA-less → Post dual-writes D1 `feed_activities` + a **real Stream UUID** →
  composer collapses to the "Shared with the community!" confirmation → post renders in the Course
  Feed → non-enrolled POST = 403. Closed the no-test gap with a new component regression test
  (`tests/components/course/MilestoneComposer.test.tsx`, 6 cases). tsc/lint clean.
- **#5 COMM-TAG-FILTER — ⏸ DEFERRED post-production (Conv 280; was parked).** Has a locked,
  build-ready design at [plan/comm-tag-filter/README.md](../comm-tag-filter/README.md) (channels
  model + `community_channels` table, decisions LOCKED Conv 238) — NOT "no recoverable intent."
  **Decision Conv 280 (user):** retire as a port-artifact — the legacy chips were decorative `?tag=`
  port residue; channels only pay off at feed volume + modal variety, and the System feed is now
  admin-only / low-volume, so the member-town-hall premise that justified them is gone. No MVP need
  at genesis-cohort scale (60–80 students). The design doc is retained as a "revisit-if-volume" note.

---

## Unit dependency graph (whole-unit, unidirectional — no leaks)

```
U1 (Seed) ──────────────► [verify-enabler for U2 + U3]
U2 (Discovery Rendering) ─────────────► U3b (entity-promo render)
U3a (substrate) ─► U3c (admin) ;  U3a+U2 ─► U3b ─► U3d (nudge)
Cleanups: independent (no deps)
```
**Build order:** ~~U1~~ ✅ → ~~U2~~ ✅ → ~~U3~~ ✅ (~~a~~ ✅ → ~~b~~ ✅ → ~~c~~ ✅ [settings ✅ · moderation ✅ · announcements ✅ Conv 277] → ~~d~~ ✅ **workspace card Conv 278; per-post nudge `[U3D-POST]` ✅ Conv 279**). ~~Cleanups~~ ✅ all done Conv 278. **U3 COMPLETE.** All build units (U1/U2/U3) + all Cleanups done. `[SUCCESS-COMMUNITY-VERIFY]` #16 ✅ verified Conv 280 (browser A–E + new regression test). Only `[COMM-TAG-FILTER]` #5 remains parked (build-ready design at `plan/comm-tag-filter/README.md`, net-new feature); it does not gate closure.
Each arrow is "whole prior unit complete," satisfying the isolation principle.

## Premise-Check Gate (the planning-process fix — run before building each unit)
1. Trace the real code path end-to-end (read, don't assume).
2. Confirm the data/schema/infra it needs exists; if not, **that missing piece is part of THIS
   unit's scope** (the whole point of cohesive units — no mid-build surprises).
3. Validate external-service assumptions (Stream/KV/cron) against working code or a probe.
4. Material scope change → surface before coding (CLAUDE.md §Critical Rule).

## Sizing / closure
Multi-conv: U1 ≈ 1 conv; U2 ≈ 1-2; U3 ≈ 2-3 (one per sub-slice). This plan file is the SoT.
Each unit premise-checks, builds, and **browser-verifies (real post-U1)**. Group closes with a full
5-gate `/w-codecheck` (`tsc --noEmit` · `npm run check` · `npm run lint` · `npm test` · `npm run build`)
+ an end-to-end promote browser sweep. Parked #5/#16 do not gate closure.
