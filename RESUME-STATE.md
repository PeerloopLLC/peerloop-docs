# State — Conv 229 (2026-06-01 ~07:31)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 229 was decision-system housekeeping + a task closure, no MATT/RTMIG code work. **(1) [DEC-SKILL-SYNC] (#33) DONE** — finished the Conv-228 `DECISIONS.md` → `docs/decisions/` migration on the *writer* side: repointed 10 skill/config/ref files off the dead pointer to the 3-step write-path (chunk `01`–`11` + `decision-log.md` + `INDEX.md`), retargeted `w-sync-docs` Audit 5.1, and added `docs/decisions/` to the timecard `routineStrip`/`docPathsExclude` + a doc-registry pattern entry (billing-leak fix). **(2) INDEX integrity** — investigated whether the split orphaned decisions: **0 orphaned decisions**, but found + fixed **22 malformed anchor links** (the split's INDEX-generator stripped underscores GitHub keeps) + 1 bad cross-ref; 391/391 resolve. Added a "Finding a decision (read-path)" section to INDEX. **(3) [DISC-DROP] (#5) DONE** — Leaderboard dropped (not ported), umbrella closed; decision recorded via the just-fixed write-path (first clean dogfood); archived to plan/COMPLETED.md. **(4) GARBLE-WATCH / /w-garble-check** — assessed (precondition unmet, CLI still 2.1.159, carried forward unchanged); built a transcript-based garble detector, calibration against canonical Conv 226 **FAILED** (symptom leaves no recoverable transcript trace), so the `/w-garble-check` wishlist item was **dropped** with the negative finding recorded to memory.

## Completed

- [x] [DEC-SKILL-SYNC] (#33) — 10 files repointed off DECISIONS.md; audit + billing/registry fixes; verified (JSON valid, registry resolves, 0 stray refs)
- [x] INDEX anchor repair — 22 anchors + 1 See-ref fixed; 391/391 resolve; 0 orphaned decisions confirmed
- [x] INDEX read-path section added
- [x] [DISC-DROP] (#5) — leaderboard dropped, umbrella closed + archived; decision recorded in docs/decisions/
- [x] GARBLE-WATCH assessed (carried forward); /w-garble-check evaluated + dropped (calibration failed; negative finding in memory)

## Remaining

- [ ] All pending blocks/tasks below — unchanged this conv (no MATT/RTMIG work). Big active threads: [RTMIG-4] (#6) ~89-page /old/* → root migration loop; [MATT-EXEC-PG2] (#10) / [MMP-PH5] (#13) MATT Phase 5; [PROFILE-PRIM-SWEEP] (#23, PAUSED).

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #6: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #7: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #8: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #9: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #10: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] #11: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #12: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] #13: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] #14: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #15: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #16: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (Figma 597:6504 / 685:13240)
- [ ] #17: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #18: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #19: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #20: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #21: [TXTBTN] Extract TextButton primitive on Rule-of-Three (TopicPicker Select-All = instance 1)
- [ ] #22: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #23: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #24: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #25: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] #26: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #27: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #28: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #29: [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page (Matt directive) [Opus]
- [ ] #30: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #31: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] #32: [GARBLE-WATCH] Re-test TERM-GARBLE when upstream changelog fixes parallel tool-result delivery

## Key Context

- **Decision write-path is now skill-default.** New decisions: matching `docs/decisions/NN-*.md` chunk (latest-wins) + dated entry at the bottom of `docs/decisions/decision-log.md` + title in `docs/decisions/INDEX.md`. `docs/DECISIONS.md` is a pointer; `DOC-DECISIONS.md` (docs-repo/cc-workflow/dual-repo/obsidian topics) is a SEPARATE root file, unchanged. The r-end learn-decide agent + fmt-learn-decide.md now target this directly. INDEX has both a write-path and a read-path section.
- **INDEX anchor discipline:** write anchors as the GitHub slug of the heading (KEEP underscores — `preview_urls` not `previewurls`). The Conv-228 generator's underscore-stripping was a one-shot artifact; decisions are hand-authored now so no recurrence risk. `w-sync-docs` Audit 5.1 now cross-checks INDEX↔chunk coverage.
- **TERM-GARBLE detection is NOT buildable from the transcript** (Conv 229 finding, in `reference_term_garble_upstream_bug.md`): symptom leaves no recoverable JSONL trace (payload + narration scans both clean on canonical Conv 226); risk is constant (every Opus-4.8/≤2.1.159 parallel-batch conv exposed, already captured by GARBLE-WATCH); detection is human + out-of-band only. **Do NOT re-attempt a transcript scanner.** GARBLE-WATCH (#32) stays armed for the upstream version fix.
- **conv-tasks.md no-shrink rule:** r-start Step 7.5 backstop fires EVERY start by design (`*DONE*` rows stay while TaskList carries only pending); verify `oldRows − #*DONE* == TaskList`, only halt on mismatch.
- **DISC-DROP closed:** discover-destination umbrella complete (courses/communities/members/feeds ported; leaderboard dropped). Archived in plan/COMPLETED.md #69; removed from PLAN.md (DISC-ROLE-VIEWS section folded). Two cleanup debts folded into ROUTE-MIGRATION block. Legacy /old leaderboard page+API+component retained per /old-retention rule.
- Conv 229 commits made in Step 6 (pre-commit snapshot). Code branch `jfg-dev-13-matt`; **code repo had ZERO changes this conv** (docs-only).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
