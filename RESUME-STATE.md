# State — Conv 286 (2026-06-15 ~08:13)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Backlog-cleanup sweep — closed **8 tasks** across the conv (3 commit-pairs): TESTCOMP-DRIFT, codecheck fixes, TW-V4, TOWNHALL-TEST, ROUTEMAP-LIT, NUDGE-TC-V2 (built the deferred v2 progression-gap), TEST-FILE-COUNT, PLAN-RENUM, plus TESTDOC-DRIFT closed as subsumed. Also revived the dead e2e login helper (a real `[E2E-MIG]` enabler). 5-gate baseline verified green this conv (tsc / astro 0-0-0 / lint / test **401 files · 6742 cases** / build). 27 tasks remain.

## Completed

- [x] [TESTCOMP-DRIFT] #35 — TEST-COMPONENTS.md reconciled to 94/2483 (commit `d67a5aa`)
- [x] codecheck — 2 Tailwind v4 renames + 2 Astro hints (commit `4c61f525`)
- [x] [TW-V4] #25 — both v3→v4 candidates fixed; PLAN note marked done
- [x] [TOWNHALL-TEST] #32 — 62 townhall/commons refs reconciled; e2e login helper revived (commit `36670f04`)
- [x] [ROUTEMAP-LIT] #31 — subsumed by [OLD-PORTED-CLEANUP] #16 (legacy /old/discover dead href)
- [x] [NUDGE-TC-V2] #24 — BUILT v2 progression-gap (decision A path-capstone): `lib/progression/capstone.ts` + `ProgressionNudge` `capstone?` prop + host wiring + 20 tests
- [x] [TEST-FILE-COUNT] #26 — TEST-COVERAGE.md + TEST-PAGES.md + TEST-COMPONENTS.md reconciled vs disk + vitest 401/6742
- [x] [PLAN-RENUM] #27 — stripped 33 volatile code-adjacent `#N` task-ids from PLAN.md
- [x] [TESTDOC-DRIFT] #30 — closed as subsumed by #35 + #26

## Remaining

- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production
- [ ] [ROLE-STUDIOS] #2 [Opus] — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off)
- [ ] [RTMIG-4] #3 [Opus] — port ~89 legacy /old/* → root
- [ ] [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #5 · [PRIM-MATCH-INDEX] #6 · [TXTBTN] #7 · [PROFILE-PRIM-SWEEP] #8 (PAUSED profile cluster)
- [ ] [ICN-NS] #9 · [SHOWMORE] #12 · [PREFLIP-WT] #13 (KEEP until client-vet)
- [ ] [E2E-MIG] #10 — broad e2e data-model + UI-structure drift; login helper FIXED this conv (suite 0→10/14 on seed-data-verification), residual = re-derive membership/enrollment counts (post-Conv-280 no-auto-join) + dashboard headings (post-ROLE-STUDIOS) across the specs
- [ ] [E2E-GATE] #11 — add e2e to the baseline gate (the reason this drift hid)
- [ ] [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [OLD-PORTED-CLEANUP] #16 (now also clears the ROUTEMAP-LIT dead href on regen)
- [ ] [LEARN-ISLAND-RESTYLE] #17 · [CREATE-ISLAND-RESTYLE] #18 · [TEACH-ISLAND-RESTYLE] #19 · [TRIAGE-RESTYLE] #20
- [ ] [V217-WATCH] #21 · [COURSEDETAIL-DEAD] #22 · [NUDGE-CACHE-FLASH] #23
- [ ] [COMMONS-DATE] #28 · [DISCCARD-DEL] #29 · [FEED-LANE-RENDER] #33 · [STREAM-PURGE] #34

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] · #2 [ROLE-STUDIOS] [Opus] · #3 [RTMIG-4] [Opus] · #4 [SSR-LOADER-DEAD] · #5 [CT-RESTYLE] · #6 [PRIM-MATCH-INDEX] · #7 [TXTBTN] · #8 [PROFILE-PRIM-SWEEP] · #9 [ICN-NS] · #10 [E2E-MIG] · #11 [E2E-GATE] · #12 [SHOWMORE] · #13 [PREFLIP-WT] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [OLD-PORTED-CLEANUP] · #17 [LEARN-ISLAND-RESTYLE] · #18 [CREATE-ISLAND-RESTYLE] · #19 [TEACH-ISLAND-RESTYLE] · #20 [TRIAGE-RESTYLE] · #21 [V217-WATCH] · #22 [COURSEDETAIL-DEAD] · #23 [NUDGE-CACHE-FLASH] · #28 [COMMONS-DATE] · #29 [DISCCARD-DEL] · #33 [FEED-LANE-RENDER] · #34 [STREAM-PURGE]

## Key Context

- **Baseline VERIFIED this conv:** tsc / astro check (0-0-0) / eslint / npm test (**401 files / 6742 cases**) / npm run build — all green. Re-verify in next conv before any fresh baseline claim.
- **NUDGE-TC-V2 build:** v2 gap = decision A path-capstone (`progression_position === course_count AND badge='learning_path'`). `isProgressionCapstone(db, courseId)` in `lib/progression/capstone.ts`; `ProgressionNudge` gains `capstone?` prop — overview placement ④ stays v1 (`isTeacher && !isCreator`), per-course placement ⑤ gains the gap. Server-computed in `teaching/courses/[courseId].astro`, passed as prop (no current-user store change → no test ripple).
- **e2e login helper FIXED** (`e2e/helpers.ts`): was dead at `getByLabel('Password')` (ambiguous with the "Show password" toggle aria-label) + `waitForURL('**/dashboard')` (Conv-201 retargeted login→`/`). Now password-by-placeholder + leave-/login wait. This unblocked the WHOLE e2e suite. Residual e2e failures are data-model/UI drift → [E2E-MIG] #10.
- **e2e is NOT in the `npm test` gate** (`vitest.config` excludes `e2e/`) — this is why it rotted silently; [E2E-GATE] #11.
- **New memory this conv:** `feedback_fix_docs_inline_not_rend.md` — don't rely on /r-end to scrub stale doc refs; fix inline + don't TaskCreate trivial doc-cleanups.
- **PLAN.md #N policy (DOC-DECISIONS):** don't annotate PLAN.md prose with volatile TodoWrite task-ids; use stable `[CODE]` refs.
- **Changes committed at r-end (Step 6):** #24 build + #26/#27 doc reconciliation — not yet a separate hash at write time.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
