# State — Conv 278 (2026-06-13 ~09:43)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Shipped **FEED-U3d** (PromoteNudge workspace card) — the final FEED-U3 sub-task — plus **all four feed-group cleanups**. U3d: a configurable `promo_nudge_min_engagement` dial (admin-tunable), eligibility data on `promotable-entities`, and a self-gating `PromoteNudge.tsx` island mounted on `/creating`+`/teaching` that expands the already-built `EntityPromoComposer` (closing U3b's deferred mount). A Premise-Check trace found the literal "per-post (server canPromote)" surface already exists (`PromoteButton`), so the genuinely-new *attention-drawing* per-post nudge was deferred (user-chosen) to `[U3D-POST]`. Cleanups: `[SYS-GET-GATE]` (gate townhall comments GET), `[PROMOTE-IDEMP]` (concurrent UNIQUE-race → graceful), `[API-DISC-DOC]`+`[DISC-RAILS-DOC]` (documented `GET /api/discovery/rails`), `[SYS-NAMING]` (verified already done). 5 gates green (test **6694**), browser-verified.

## Completed

- [x] /r-start (Conv 277→278); 37 tasks transferred; memory mirror→live applied (0-diff)
- [x] U3d decisions (with user): engagement gate = configurable dial; scope = both surfaces (per-post later deferred)
- [x] `promo_nudge_min_engagement` dial — config.ts + seed (0002) + admin endpoint (parseCount) + PromotionSettingsAdmin third card
- [x] `GET /api/feeds/promotable-entities` extended with per-entity `engagementCount` + top-level `minEngagement`
- [x] `src/components/promotion/PromoteNudge.tsx` (new) — self-gating island, expands EntityPromoComposer; mounted /creating + /teaching overview
- [x] Tests: PromoteNudge.test.tsx (+6), promotion-config.test.ts (+1); 5 gates green (test 6693); browser-verified (guy-rymberg creator, brian admin)
- [x] `[SYS-GET-GATE]` — canParticipate gate on townhall comments GET + test (non-admin GET → 403)
- [x] `[PROMOTE-IDEMP]` — promote.ts catches concurrent UNIQUE-index violation → graceful `{alreadyPromoted}`
- [x] `[API-DISC-DOC]` + `[DISC-RAILS-DOC]` — `GET /api/discovery/rails` documented in API-COMMUNITY.md; route-mapping + API-REFERENCE index updated (docs agent)
- [x] `[SYS-NAMING]` — verified already satisfied (consistent "The Commons"; folded into U1)
- [x] 5 gates re-verified after cleanups (test **6694**, build 0)
- [x] 2 decisions → decision-log.md (+ 10-admin.md/INDEX via agent); plan + API-ADMIN/API-COMMUNITY/TEST-COVERAGE/TEST-COMPONENTS updated; 1 TIMELINE entry

## Remaining

**Feed group (canonical plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md`; U3 effectively complete):**
- [ ] [U3D-POST] #41 — DEFERRED: attention-drawing per-post promote nudge (entity-promo model + engagement floor). Needs spec: placement (entity-feed cards vs home feed), copy, one-time-vs-persistent. Mechanical per-post affordance already exists (`PromoteButton`, server `canPromote`).
- [ ] [COMM-TAG-FILTER] #6 · [SUCCESS-COMMUNITY-VERIFY] #7 — PARKED (needs-spec)

**Other backlog:**
- [ ] [ROLE-STUDIOS] #9 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #10 [Opus] · [SSR-LOADER-DEAD] #11 · [CT-RESTYLE] #12 · [PRIM-MATCH-INDEX] #13 · [TXTBTN] #14 · [PROFILE-PRIM-SWEEP] #15 (PAUSED)
- [ ] [ICN-NS] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [SHOWMORE] #19 · [PREFLIP-WT] #20 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #21 [Opus] · [MEM-CAP] #22 (MEMORY.md 89% → /r-prune-memory) · [DOCGEN-SPEC] #23 · [OLD-PORTED-CLEANUP] #24
- [ ] [LEARN-ISLAND-RESTYLE] #25 · [CREATE-ISLAND-RESTYLE] #26 · [TEACH-ISLAND-RESTYLE] #27 · [TRIAGE-RESTYLE] #28
- [ ] [V217-WATCH] #29 · [COURSEDETAIL-DEAD] #30 · [NUDGE-CACHE-FLASH] #31 · [NUDGE-TC-V2] #32 · [TW-V4] #33 (incl. StickySignupBar.astro `backdrop-blur-sm`, SuggestionCard.tsx `flex-shrink-0`) · [TEST-FILE-COUNT] #34 · [PLAN-RENUM] #35
- [ ] [COMMONS-DATE] #36 · [DISCCARD-DEL] #37

## TodoWrite Items

- [ ] #6 [COMM-TAG-FILTER] PARKED · #7 [SUCCESS-COMMUNITY-VERIFY] PARKED · #41 [U3D-POST] (deferred, needs spec)
- [ ] #9 [ROLE-STUDIOS] [Opus] (BLOCKED) · #10 [RTMIG-4] [Opus] · #11–#20 · #21 [TZ-AUDIT] [Opus] · #22–#37

## Key Context

- **FEED-U3 status:** U3a/b/c/d ✅ COMPLETE. Group "effectively complete" — only deferred `[U3D-POST]` + parked #6/#7 remain. SoT = `plan/home-feed-merge/REASSEMBLY-CONV271.md` (updated this conv).
- **New code (will be committed Step 6):** `src/components/promotion/PromoteNudge.tsx` + `tests/components/promotion/PromoteNudge.test.tsx` (new); changes to `src/lib/promotion/config.ts`, `src/pages/api/admin/promotion-config.ts`, `src/components/admin/PromotionSettingsAdmin.tsx`, `src/pages/api/feeds/promotable-entities.ts`, `src/pages/api/feeds/promote.ts`, `src/pages/api/feeds/townhall/comments.ts`, `src/pages/{creating,teaching}/[...tab].astro`, `migrations/0002_seed_core.sql`; tests `promotion-config.test.ts`, `townhall/comments.test.ts`.
- **Dial model:** `promo_nudge_min_engagement` (default 3) lives in `platform_stats` like the other promo dials; gates *nudging* not *promoting* (composer lists all entities); 0 = always nudge; engagement = course `student_count` / community `member_count`. Admin Promotion Settings page now edits all 3 dials.
- **PROMOTE-IDEMP gotcha:** the UNIQUE guard is a **separate** `CREATE UNIQUE INDEX idx_post_promotions_unique` (0001_schema.sql:1361), NOT inline in the table def — grep both forms when checking constraints.
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro 0-0-1hint / lint / test **6694** / build).
- **Local D1 (dev):** re-seeded fresh this conv (`db:setup:local:dev`); `promo_nudge_min_engagement`=3 seeded; the dev server started for browser-verify was killed.
- **MEMORY.md ~89%** of the SessionStart byte cap → `[MEM-CAP]` #22 (`/r-prune-memory`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Next FEED-U3 work** = either spec + build `[U3D-POST]` (the attention-drawing per-post nudge) or move to other backlog (RTMIG-4 is the main loop; ROLE-STUDIOS blocked by client).
