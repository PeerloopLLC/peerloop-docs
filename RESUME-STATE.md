# State — Conv 204 (2026-05-27 ~11:57)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 204 retrofitted `/courses` (the first [STANDIN-MATT] page — over-marked; made public; stale SubNav removed), built a new `/r-quiet-mode` skill (log-file-as-state, with r-end Step-0 guard + r-start leftover detection + a mandatory OFF issue-raising checkpoint), and — inside quiet mode — executed **DISC-DROP Stage 1**: scaffolded `/courses` to absorb the legacy `/old/discover/courses`, added role tabs + a conservative filter row (level pills + topic dropdown + text search + Clear) wired to a role-lens catalog, fixed a loader bug (`primary_topic_id`), and initialized the current-user singleton shell-wide (`CurrentUserInit` in AppLayout). All gates green except full `npm test`/`build` (not run).

## Completed

- [x] [PREFLIP-M4PRO] verified on MacMiniM4Pro (worktree @608346a, env, D1 seed, alias, :4331)
- [x] [STANDIN-MATT] `/courses` retrofit — stand-in marker + stale top-level SubNav removed; made PUBLIC (middleware); middleware tests updated (85/85); browser-verified
- [x] `/r-quiet-mode` skill built — log-IS-state; r-end Step 0 guard; r-start Step 5.8 leftover detection; round-trip + guard tested; OFF augmented to a mandatory issue-raising pause
- [x] DISC-DROP Stage 1 — scaffold slots; CoursesRoleTabs + CoursesCatalog (role-lens filter) wired via `courses:tabchange`; CoursesFilters (level pills/topic dropdown/search/Clear) via `courses:filterchange`; loader `primary_topic_id` fix; shell-wide CurrentUserInit
- [x] [CUI-VERIFY] in-flight guard on initializeCurrentUser + Home single-fetch (was 2) + comment fix — browser-confirmed 1 `/api/me/full` call

## Remaining

**Active block — STANDIN-MATT (#2):**
- [ ] [STANDIN-MATT] [Opus] Retrofit remaining @stand-in pages — `login`+`signup` (shared AuthModal), `onboarding`, `teachers/[handle]`; `profile` DEFERRED (complex; legacy /profile=301→/@me; may be simplified). `course/[slug]/[...tab]` EXCLUDED (goes via tab tasks). Counter: `grep -rl '@stand-in' src/pages`.

**DISC-DROP (new, supersedes DISC-UNIFY):**
- [ ] [DISC-DROP] [Opus] Stages 2-4 + Stage-1 finish — Stage 2: RecommendedCourses + OnboardingNudgeBanner into slots; Stage 3: Sidebar homes for 8 discover destinations (nav-chrome); Stage 4: retire /old/discover/*. Cleanup: remove DEV SCAFFOLD slot backgrounds/labels from courses.astro; Matt-restyle ExploreTabBar + CoursesFilters; consolidate duplicated role/ratingLabel logic; decide search/pagination + topic dropdown-vs-pills; resolve tab-badge-vs-filtered-count wrinkle.
- [ ] [DISC-RTB-RECONCILE] [Opus] Reconcile discover role-tabs (explore-tabs) vs Matt role-tab-bar slot ([RTB]).
- [ ] [AICODING-SEED] AI Coding topic shows 3 (both DBs) vs expected 2 — seed mis-assignment on a Q-System course, or acceptable? Inspect migrations-dev/0001_seed_dev.sql.
- [ ] [DISC-UNIFY] superseded by DISC-DROP — keep as pointer until Stage 4 retires /old/discover/*.

**Baseline:**
- [ ] [FULLBASE-204] Run full `npm test` + `npm run build` (only targeted tests + tsc/check/lint were run this conv).

**Carried-forward backlog (unchanged):**
- [ ] [RTMIG-4] [Opus] / [E2E-MIG] / [E2E-GATE] [Opus] / [PREFLIP-WT]
- [ ] [MATT-EXEC-PG2] [Opus] / [MATT-EXEC-EXT] [Opus] / [RTB] [Opus] / [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] [MMP-PH5] / [MATT-EXEC-GRD] / [MMP-PH3] / [SHOWMORE] / [CH-VARIANTS] / [ICN-NS] [Opus] / [HOWTOREG-ICN]
- [ ] [ASSET-SWEEP-GATE] / [MFRD-LOOKUP] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [TXTBTN] / [MEM-CAP-WATCH] / [DTUNE-WATCH]

## TodoWrite Items

- [ ] #2 [STANDIN-MATT] [Opus]
- [ ] #3 [RTMIG-4] [Opus] / #4 [E2E-MIG] / #5 [E2E-GATE] [Opus] / #6 [PREFLIP-WT]
- [ ] #7 [DISC-UNIFY] (superseded) / #8 [MATT-EXEC-PG2] [Opus] / #9 [MATT-EXEC-EXT] [Opus] / #10 [RTB] [Opus] / #11 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #12 [MMP-PH5] / #13 [MATT-EXEC-GRD] / #14 [MMP-PH3] / #15 [SHOWMORE] / #16 [CH-VARIANTS] / #17 [ICN-NS] [Opus] / #18 [HOWTOREG-ICN]
- [ ] #19 [ASSET-SWEEP-GATE] / #20 [MFRD-LOOKUP] / #21 [ESOT-STRUCTURE] / #22 [BROWSER-FALLBACK] / #23 [TXTBTN] / #24 [MEM-CAP-WATCH] / #25 [DTUNE-WATCH]
- [ ] #26 [DISC-DROP] [Opus] / #27 [DISC-RTB-RECONCILE] [Opus] / #29 [AICODING-SEED] / #30 [FULLBASE-204]

## Key Context

- **DISC-DROP plan** (supersedes DISC-UNIFY #7): drop `/discover`, fold into `/courses` in 4 stages. Stage 1 done. `/courses` islands: `CoursesRoleTabs` + `CoursesCatalog` + `CoursesFilters` (src/components/courses/), comms via window CustomEvents `courses:tabchange` / `courses:filterchange` (history.replaceState fires no hashchange — gotcha).
- **DEV SCAFFOLD still in courses.astro:** slot backgrounds (bg-*-50) + uppercase labels are temporary — remove before DISC-DROP done.
- **CurrentUserInit** (src/components/auth/, mounted in AppLayout) now inits the current-user singleton shell-wide; `initializeCurrentUser` has an in-flight guard. Reusable headless-init pattern.
- **Loader fix:** fetchCourseBrowseData now selects authoritative `courses.primary_topic_id` (was hardcoded null). Shared loader — benefits any consumer.
- **/courses is now PUBLIC** (removed from middleware PROTECTED_EXACT).
- **r-quiet-mode:** `.scratch/quiet-mode-log.md` IS the state; OFF processes + deletes it; r-end blocks while it exists; r-start surfaces leftovers. OFF now raises issues and pauses.
- **Baseline:** tsc / astro check / lint / targeted tests (135) green THIS conv; full test + build NOT run (#30). Treat as hypothesis per CLAUDE.md.
- **Reference env:** `:4331` preflip worktree live on M4Pro ([PREFLIP-WT] tears down later).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
