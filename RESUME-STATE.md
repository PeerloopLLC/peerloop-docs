# State — Conv 279 (2026-06-14 ~07:00)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Shipped **[U3D-POST]** — the attention-drawing per-post promote nudge, and the final deferred FEED-U3 sub-task. A new admin-tunable `promo_post_min_engagement` dial (4th `promo_%` dial, default 3) sets the per-post engagement floor; `PromoteButton` gains a stateless `hot` state (accented HOT_TRIGGER pill + flame + "Resonating — promote") owned internally so both feed render paths match; a pure `lib/promotion/engagement.ts` helper computes engagement (reactions + comments) and `isPromoteHot`; the floor threads parallel to `canPromote` through the course/community GETs → CourseFeed/CommunityFeed/MattCourseFeed → FeedActivityCard. 5 gates green (test **6707**), browser-verified both branches via DOM truth (floor=0 → flame; floor=5 → quiet). The FEED-U3 / home-feed-merge group is now build-complete — only the two PARKED needs-spec items remain.

## Completed

- [x] /r-start (Conv 278→279); 32 tasks transferred (37→32 reconciled, all losses explained); memory mirror→live 0-diff
- [x] [U3D-POST] spec — 3 decisions surfaced + user-picked (new dial / persist-until-promoted / elevate-in-card)
- [x] `promo_post_min_engagement` dial — config.ts + seed `stat-promo-004` (0002) + admin endpoint (parseCount) + PromotionSettingsAdmin 4th card (grid 2×2)
- [x] `lib/promotion/engagement.ts` (new) — `postEngagement` + `isPromoteHot`, pure/client-bundle-safe
- [x] `PromoteButton` `hot` state (HOT_TRIGGER + flame + cue); `ml-auto`→wrapper-span layout fix in FeedActivityCard
- [x] `postPromoteFloor` threaded: course/community GETs (loaded only when canPromote) → CourseFeed/CommunityFeed/MattCourseFeed → FeedActivityCard
- [x] Tests: promotion-engagement.test.ts (new, 7), promotion-config.test.ts (4-dial round-trip/seed-shape/upsert), FeedActivityCard promote-state (+5)
- [x] 5 gates green (tsc / astro 0-err / lint / test **6707** / build)
- [x] Browser-verified via Chrome bridge DOM truth (Guy creator @ /community/ai-for-you/feed): floor=0 → flame "Resonating — promote"; floor=5 → quiet "Promote"; local dial restored to 3
- [x] 2 decisions → decision-log.md + chunk 05 + INDEX (agent); 1 TIMELINE entry; PLAN + REASSEMBLY-CONV271 updated; 4 API/test docs synced (agent)

## Remaining

**Feed group (canonical: `plan/home-feed-merge/REASSEMBLY-CONV271.md`; build-complete):**
- [ ] [COMM-TAG-FILTER] #2 · [SUCCESS-COMMUNITY-VERIFY] #3 — PARKED (needs-spec)

**Other backlog:**
- [ ] [ROLE-STUDIOS] #4 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #5 [Opus] · [SSR-LOADER-DEAD] #6 · [CT-RESTYLE] #7 · [PRIM-MATCH-INDEX] #8 · [TXTBTN] #9 · [PROFILE-PRIM-SWEEP] #10 (PAUSED)
- [ ] [ICN-NS] #11 · [E2E-MIG] #12 · [E2E-GATE] #13 · [SHOWMORE] #14 · [PREFLIP-WT] #15 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #16 [Opus] · [MEM-CAP] #17 (MEMORY.md 89% → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27 · [TW-V4] #28 (incl. StickySignupBar.astro `backdrop-blur-sm`, SuggestionCard.tsx `flex-shrink-0`) · [TEST-FILE-COUNT] #29 · [PLAN-RENUM] #30
- [ ] [COMMONS-DATE] #31 · [DISCCARD-DEL] #32 · [TESTDOC-DRIFT] #33 (reconcile TEST-COVERAGE.md Summary vs disk — pre-existing drift)

## TodoWrite Items

- [ ] #2 [COMM-TAG-FILTER] PARKED · #3 [SUCCESS-COMMUNITY-VERIFY] PARKED
- [ ] #4 [ROLE-STUDIOS] [Opus] (BLOCKED) · #5 [RTMIG-4] [Opus] · #6–#15 · #16 [TZ-AUDIT] [Opus] · #17–#33

## Key Context

- **FEED-U3 status:** U3a/b/c/d ✅ COMPLETE. [U3D-POST] (per-post nudge) shipped this conv. Group build-complete — only PARKED #2/#3 remain. SoT = `plan/home-feed-merge/REASSEMBLY-CONV271.md` (updated this conv).
- **New code (committed Step 6):** `src/lib/promotion/engagement.ts` + `tests/lib/promotion-engagement.test.ts` (new); changes to `lib/promotion/config.ts`, `api/admin/promotion-config.ts`, `components/admin/PromotionSettingsAdmin.tsx`, `api/feeds/{course,community}/[slug].ts`, `components/feed/PromoteButton.tsx`, `components/community/FeedActivityCard.tsx`, `components/community/{CourseFeed,CommunityFeed}.tsx`, `components/course/MattCourseFeed.tsx`, `migrations/0002_seed_core.sql`; tests `promotion-config.test.ts`, `FeedActivityCard.test.tsx`.
- **Dial model:** `promo_post_min_engagement` (default 3, `stat-promo-004`) gates the per-post *highlight* (reactions + comments ≥ floor), distinct unit from `promo_nudge_min_engagement` (entity members). 0 = always highlight. Admin Promotion Settings now edits 4 dials (2×2 grid). Missing seed row → `loadPromotionConfig` default fallback of 3 (verified).
- **Render scope:** the per-post Promote affordance only renders where `canPromote` is true (course + community feeds) via two paths — `FeedActivityCard` and `MattCourseFeed`→`SocialPost`. SmartFeed/HomeFeed/TownHallFeed do NOT set canPromote (out of scope).
- **Hot state is stateless:** computed every render; vanishes on promote (button flips to "Promoted") or when engagement cools — no localStorage, sidesteps the [NUDGE-CACHE-FLASH] bug class.
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro 0-err-1hint / lint / test **6707** / build exit 0).
- **Local D1 (dev):** dial restored to 3 after browser-verify; dev server stopped. A leftover browser tab (545380893) from the verify may remain open.
- **MEMORY.md ~89%** of the SessionStart byte cap → `[MEM-CAP]` #17 (`/r-prune-memory`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Next** = the FEED group is build-complete; RTMIG-4 (#5) is the main unblocked loop, [MEM-CAP] (#17) is quick housekeeping, or pick from the backlog (ROLE-STUDIOS blocked by client).
