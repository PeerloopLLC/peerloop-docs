# State — Conv 205 (2026-05-27 ~14:23)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 205 finished the Matt `/courses` page (DISC-DROP). Completed Stage 2 (mounted OnboardingNudgeBanner + RecommendedCourses), then did a full Matt restyle: built a new `CourseCatalogCard` from Matt primitives (Matt has no catalog/browse card — all his course cards are feed-embed rows), tiled it in a responsive grid, Matt-restyled the role tabs (dropped shared legacy ExploreTabBar) and RecommendedCourses, removed all DEV scaffold. Added course images (`thumbnail_url`) via two card variants — `stacked` (16:9 thumb top, grid) and `overlay` (image backdrop + scrim, recommended band) — dropped the redundant course icon, and replaced the per-card CTA with a whole-card stretched-link + hover/focus. All five gates green (tsc/check/lint/build + 6452/6452 tests). Page called DONE. Stages 3-4 remain blocked on building Matt pages for the 7 other discover destinations.

## Completed

- [x] DISC-DROP Stage 2 — OnboardingNudgeBanner + RecommendedCourses mounted into /courses slots
- [x] /courses full Matt restyle — scaffold removed, Matt role tabs, Matt-restyled recommendations
- [x] New `CourseCatalogCard` (Matt primitives) — stacked + overlay variants, images, no icon, no CTA, stretched-link card-click
- [x] [FULLBASE-204] full gate set green this conv (tsc/check/lint/build + 6452 tests)

## Remaining

**Active / next:**
- [ ] [STANDIN-MATT] [Opus] Retrofit remaining @stand-in pages (login+signup/AuthModal, onboarding, teachers/[handle]) — PLUS build Matt pages for the 7 discover destinations (communities, members, leaderboard, feeds, creators, students, teachers); user AUTHORIZED breaking 404-honesty for these. Building them unblocks DISC-DROP Stages 3-4. Counter: `grep -rl '@stand-in' src/pages`.
- [ ] [DISC-DROP] [Opus] /courses page DONE. Remaining: Stages 3 (sidebar homes for discover dests — blocked on above) + Stage 4 (retire /old/discover/*). Cleanup debts: shared role/ratingLabel helper across the 3 islands; RecommendedCourses light skeleton vs dark overlay cards; search/pagination for large catalogs; tab-badge-vs-filtered-count wrinkle.
- [ ] [DISC-RTB-RECONCILE] [Opus] Reconcile discover role-tabs (explore-tabs) vs Matt role-tab-bar slot ([RTB]). The /courses tabs are now Matt-styled inline (not the legacy ExploreTabBar).

**Carried-forward backlog (unchanged):**
- [ ] [AICODING-SEED] AI Coding topic shows 3 vs expected 2 — inspect migrations-dev/0001_seed_dev.sql
- [ ] [DISC-UNIFY] superseded by DISC-DROP (pointer until Stage 4 retires /old/discover/*)
- [ ] [RTMIG-4] [Opus] / [E2E-MIG] / [E2E-GATE] [Opus] / [PREFLIP-WT]
- [ ] [MATT-EXEC-PG2] [Opus] / [MATT-EXEC-EXT] [Opus] / [RTB] [Opus] / [ADMIN-REDIRECT-BLANK]
- [ ] [MMP-PH5] / [MATT-EXEC-GRD] / [MMP-PH3] / [SHOWMORE] / [CH-VARIANTS] / [ICN-NS] [Opus] / [HOWTOREG-ICN]
- [ ] [ASSET-SWEEP-GATE] / [MFRD-LOOKUP] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [TXTBTN] / [MEM-CAP-WATCH] / [DTUNE-WATCH]

## TodoWrite Items

- [ ] #1 [STANDIN-MATT] [Opus] / #2 [DISC-DROP] [Opus] / #3 [DISC-RTB-RECONCILE] [Opus]
- [ ] #4 [AICODING-SEED] / #5 [DISC-UNIFY]
- [ ] #7 [RTMIG-4] [Opus] / #8 [E2E-MIG] / #9 [E2E-GATE] [Opus] / #10 [PREFLIP-WT]
- [ ] #11 [MATT-EXEC-PG2] [Opus] / #12 [MATT-EXEC-EXT] [Opus] / #13 [RTB] [Opus] / #14 [ADMIN-REDIRECT-BLANK]
- [ ] #15 [MMP-PH5] / #16 [MATT-EXEC-GRD] / #17 [MMP-PH3] / #18 [SHOWMORE] / #19 [CH-VARIANTS] / #20 [ICN-NS] [Opus] / #21 [HOWTOREG-ICN]
- [ ] #22 [ASSET-SWEEP-GATE] / #23 [MFRD-LOOKUP] / #24 [ESOT-STRUCTURE] / #25 [BROWSER-FALLBACK] / #26 [TXTBTN] / #27 [MEM-CAP-WATCH] / #28 [DTUNE-WATCH]

## Key Context

- **`/courses` is DONE + Matt-compatible.** Islands: `CoursesRoleTabs` + `CoursesFilters` + `CoursesCatalog` (src/components/courses/), comms via window CustomEvents `courses:tabchange` / `courses:filterchange`.
- **`CourseCatalogCard.tsx`** (NEW, ours): vertical Matt browse card. `variant='stacked'` (grid, 16:9 thumb top) | `'overlay'` (band, image backdrop + dark scrim, trimmed). Image = `thumbnail_url` (picsum placeholders in dev). No course icon, no CTA — whole card is a stretched-link (title `<a>` + `after:inset-0`), hover lift-shadow/ring. Fallback bg `#1f2937`.
- **Matt has NO catalog/browse card** — all his course cards (CourseEmbedCard/CourseAnchor/CourseInFeed) are horizontal feed-embed rows. CourseCatalogCard is composed-from-primitives (user decision B).
- **CoursesRoleTabs** now renders Matt inline underline tabs (dropped shared legacy `ExploreTabBar`, still used by /old/discover); role-color dots kept; `bg-[#f1f5f9]` arbitrary for the one neutral Matt hasn't tokenized.
- **RecommendedCourses** Matt-restyled; legacy `CourseCard` left untouched (used by 5 other surfaces).
- **Stages 3-4 blocked:** 7 discover destinations have no Matt pages (only /old/discover/*); Matt sidebar links only Home + Courses. User will explicitly break 404-honesty to build them (folds into STANDIN-MATT).
- **Baseline:** ALL 5 gates green THIS conv (tsc/check/lint/build + 6452/6452 tests, 371 files).
- Route docs regenerated both repos (route-api-map + route-matrix); navbar-reachable count 52→44.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
