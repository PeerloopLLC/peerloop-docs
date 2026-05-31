# State — Conv 226 (2026-05-31 ~16:00)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 226 closed out **[DRV-DOC]** (Phase D housekeeping of the DISC-ROLE-VIEWS sub-block). What read as "register some components" became closing real latent debt: registered 11 `@matt-inspired` components, and the mandated `prov:sweep` + full test suite each surfaced a distinct **latent Conv-224 gate-skip bug** — 2 registered-but-unstamped feeds primitives, and a stale `/feeds` middleware test (Conv 224 had run only 4 of the gates). Both fixed; all 6 gates green; both repos committed (`d066513f` code, `dcc1ac7` docs) + pushed. **Next conv is dedicated to the [TERM-GARBLE] root cause** (#27).

## Completed

- [x] [DRV-DOC] (#30) — registered 11 components in `scripts/matt-inspired-registry.ts` PHASE6_EXTRAPOLATION_CANDIDATES (Conv-222 set: 4 course role-cards + ProgressBar + CommunityRoleFallbackCard; Conv-223 set: MemberCard, MembersDirectory, CatalogPagination; + 2 adjacent gaps: CoursesRoleTabs, CommunitiesRoleTabs)
- [x] Fixed 5 unstamped components via prov:sweep — incl. 2 latent Conv-224 gaps (FeedsRoleTabs, FeedsDirectory); stamped all outermost render roots (FeedsDirectory both branches per §12b)
- [x] Fixed latent Conv-224 `/feeds` middleware test (moved protected→public-browsable); full suite 6458/6458
- [x] PLAN.md [DRV-DOC] marked COMPLETE; Conv-221 filter-only recipe flagged SUPERSEDED; retired migrated plan file `humble-wondering-turtle.md`
- [x] All 6 gates green (tsc 0 / astro check 0 / lint 0 / build / 6458 tests / prov:sweep consistent)

## Remaining

- [ ] [TERM-GARBLE] (#27) — **NEXT CONV DEDICATED.** Web-research first (GitHub issues/changelogs/forums; do NOT search "garbled"); if nothing found, build a reproducible test + isolate config levers. Characterization seed in #27 description.
- [ ] All other pending blocks below — unchanged (RTMIG-4, MATT-EXEC-*, DISC-DROP umbrella, ICN-NS, PROFILE-PRIM-SWEEP, etc.)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [DISC-DROP] Discover-destination migration umbrella (communities/feeds/members → Matt root)
- [ ] #6: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar [Opus]
- [ ] #7: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #8: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #9: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #10: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #11: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] #12: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #13: [RTB] Author Role Tab Bar design-spec doc [Opus]
- [ ] #14: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] #15: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] #16: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #17: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #18: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (Figma 597:6504 / 685:13240)
- [ ] #19: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #20: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #21: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #22: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #23: [TXTBTN] Extract TextButton primitive on Rule-of-Three (TopicPicker Select-All = instance 1)
- [ ] #24: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #25: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #26: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #27: [TERM-GARBLE] Dedicated next-conv investigation — research + reproducible test [Opus]
- [ ] #28: [ROLE-AWARE] Make pages role-aware as the role-aware tab bar rolls out [Opus]
- [ ] #29: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] #31: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #32: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #33: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #34: [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page (Matt directive) [Opus]
- [ ] #35: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #36: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference

## Key Context

- **Registry = `scripts/matt-inspired-registry.ts`** (code repo). Schema `ComponentCandidate` (`path`/`name`/`figmaMatchNames`/`note`); new entries go in `PHASE6_EXTRAPOLATION_CANDIDATES`. Registration is NOT complete until `npm run prov:sweep` passes — the §12c consistency triangle requires the matching `data-prov`/`data-prov-name` runtime stamp on the component's outermost render root (conditional branches each stamped per matt-provenance §12b).
- **Latent-bug lesson (recurring):** Conv 224 ran only 4 of the gates (skipped prov:sweep + test suite), leaving 2 bugs that surfaced in Conv 226. Prefer the full `/w-codecheck` 5-gate bundle + prov:sweep, not an inline subset.
- **[TERM-GARBLE] (#27) is the next-conv focus.** This session had recurring intermittent blank/partial tool-output renders that cleared on the next turn (and once I *narrated* a garble that didn't happen — fabricating a failure). User: working has "become unreliable, though you have recovered well." Plan + characterization seed data live in #27's description. Mitigation that worked: re-verify every write via clean `git status`/grep.
- Conv 226 commits (pushed): code `d066513f`, docs `dcc1ac7`. Counter-start commit `45191e3`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
