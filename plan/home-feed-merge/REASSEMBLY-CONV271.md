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

**➡ U2 · Discovery Rendering is now UNBLOCKED (next).** U1's done-test (real Stream IDs + all 6 rails
full + home feed full & varied) is the verify-enabler U2/U3 depend on.

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

## U2 · Discovery Rendering  *(depends on: U1 for verify only — buildable/unit-testable alone)*

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

## U3 · Promotion System  *(depends on: U2 whole — for entity-promo render; U1 for verify)*

**One delivery system.** May cleave into the sub-slices below **only at clean whole-unit seams**
(each sub-slice owns its layer + a done-test; deps are whole-prior-slices, never a peer's half).
This is the multi-conv core.

- **U3a · Backend substrate** *(no U2 dep — self-contained)*: add promotion lifecycle to schema
  (`post_promotions` `expires_at` or computed; `platform_stats` dials `promo_active_duration_days`=14,
  `promo_retention_days`=60, mirroring `discovery_%`); cron retention-purge in
  `workers/cron/src/index.ts` (**SQLite rule: `strftime('%Y-%m-%dT%H:%M:%fZ',…)`, never `datetime()`**);
  **Announcement data model** (net-new table + types). *Done-test:* cron purges expired rows; dials
  read/write.
- **U3b · Entity-promo content** *(needs U2 + U3a)*: add `entity-promo` kind to the smart-feed union
  + render path (else entity-promo posts are silently dropped) via `FeedPost.embed`→Anchor; seed
  entity-promo posts into U1's canonical script; composer UI. *Stream custom fields confirmed
  feasible* (seed script already posts+reads them). **Decide composer mount point at start.**
- **U3c · Admin surface** *(needs U3a)*: password set/rotate UI (API exists
  `api/admin/promotion-password.ts`); lifecycle-dial UI; System-promotion moderation view (wire the
  lane into `admin/moderation.astro`); Announcement author + fan-out (on U3a's model).
- **U3d · PromoteNudge** *(needs U3b — promote works end-to-end)*: mirror `ProgressionNudge`
  (self-gating island); per-post (server `canPromote`) + workspace card in `/creating`+`/teaching`.
  **Decide engagement threshold at start.** Built LAST.

**Done-test (group):** promote a real seed post Course→Community→System end-to-end in browser;
it appears in the higher feed via the lane; expires per dial; admin can moderate; nudge surfaces.

---

## Cleanups  *(genuinely independent — slot anytime; this IS correct isolation)*

- **#35 SYS-GET-GATE:** add `canParticipate()` to townhall comments GET
  (`api/feeds/townhall/comments.ts:104`, ~6-line copy from POST) — membership-gate the admin-only
  System feed on read.
- **#32 API-DISC-DOC:** re-run `route-api-map.mjs` to document `GET /api/discovery/rails`; note
  `/api/feeds/smart` is now auth-aware (no longer 401).
- **Promote idempotency-race:** `promote.ts:130` can 500 on a concurrent UNIQUE violation → catch →
  graceful `{ alreadyPromoted: true }`.

## Parked (needs-spec — excluded from closure)
- #5 COMM-TAG-FILTER · #16 SUCCESS-COMMUNITY-VERIFY — no recoverable intent; spec later as their own task.

---

## Unit dependency graph (whole-unit, unidirectional — no leaks)

```
U1 (Seed) ──────────────► [verify-enabler for U2 + U3]
U2 (Discovery Rendering) ─────────────► U3b (entity-promo render)
U3a (substrate) ─► U3c (admin) ;  U3a+U2 ─► U3b ─► U3d (nudge)
Cleanups: independent (no deps)
```
**Build order:** U1 → U2 → U3 (a → b → c → d). Cleanups anytime. If time-boxed, U3d drops first.
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
