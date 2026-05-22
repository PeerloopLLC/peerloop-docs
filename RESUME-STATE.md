# State — Conv 175 (2026-05-22 ~17:08)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 175 advanced MATT-DESIGN-PUSH through Phase 3 [MATT-EXEC-PG1] and Phase 4 scope A [MATT-EXEC-PRM]. The conv started as a warm restart on an already-incremented Conv 175 with [MSH-VIZ] mid-flight; resumed and landed [MSH-VIZ] + [MSH-REFINE] + [MATT-EXEC-PG1] + [MATT-EXEC-PRM] scope A in sequence. First `/matt/course/[slug]` page rendered end-to-end with real seed data; subsequent visual-diff iteration against Matt's `Course.svg` reshaped the CourseHeader hero (two-column layout, top-right overlay cluster, includes-list on right, $X • Enroll Now pill) and added "Course Feed" + "Meet the Creator" SubNav tabs. Ended after user accepted current state with body-section visual polish deferred.

## Completed

- [x] [MSH-VIZ] — /matt/index.astro stub + HeaderBar floating-pill geometry + AppLayout slot-forwarding fix
- [x] [MSH-REFINE] — Tailwind `--breakpoint-lg: 1025px` + HeaderBar dead-fallback cleanup + docstring update
- [x] [MATT-EXEC-PG1] — first /matt/* page end-to-end: CourseHeader.astro entity primitive + /matt/course/[slug]/index.astro using existing fetchCourseTabData
- [x] [MATT-EXEC-PRM] scope A — Button.tsx (6 variants) + Card.astro + SectionTitle.astro; retrofit CourseHeader CTA + body sections; iterated against Matt's Figma

## Remaining

- [ ] [MATT-EXEC-PG2] Phase 5: remaining 12 /matt/* routes
- [ ] [MATT-EXEC-EXT] Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill) [Opus]
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] [MATT-EXEC-FLAGS] Cross-phase: verify 4 route-shape assumptions against codebase before Phase 5
- [ ] [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start
- [ ] [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder
- [ ] [RTB] Design Role Tab Bar [Opus]
- [ ] [TSV] Token Scaffolding Verification [Opus] — includes investigating Tailwind 4 `min-h-[NN]px` arbitrary-value silent failure
- [ ] [MND2] detect-machine.sh still returns "Unknown" on M4Pro despite Conv 168 fix
- [ ] [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] [MPV] Add "open Figma SVG first" step to pre-plan scaffolding for matt/* page builds — Conv 175 surfaced
- [ ] [ASF] Investigate why Astro.slots.has + && short-circuit doesn't restore child slot fallback — Conv 175 surfaced
- [ ] [MATT-EXEC-PRM-2] Remaining Phase 4 primitives — RoleTabBar / Module / SocialPost / Note / ToDoItem
- [ ] [MATT-COURSE-POLISH] Body section visual polish — user noted "items in front of the page need work" after hero refinement
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG icons (chevron, book, person, graduation-cap) should swap to a proper icon-system in Phase 6
- [ ] [MATT-CREATOR-TAB] /matt/course/[slug]/creator route — Phase 5
- [ ] [TWLG-MIN-H] Tailwind 4 arbitrary-value `min-h-[480px]` didn't take effect — suspect interaction with `--spacing-*` global override

## TodoWrite Items

- [ ] #5: [MATT-EXEC-PG2] Phase 5: remaining 12 /matt/* routes
- [ ] #6: [MATT-EXEC-EXT] Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill) [Opus]
- [ ] #7: [MATT-EXEC-GRD] Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] #8: [MATT-EXEC-FLAGS] Cross-phase: verify 4 route-shape assumptions against codebase before Phase 5
- [ ] #9: [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start
- [ ] #10: [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder
- [ ] #11: [RTB] Design Role Tab Bar [Opus]
- [ ] #12: [TSV] Token Scaffolding Verification [Opus]
- [ ] #13: [MND2] detect-machine.sh still returns "Unknown" on M4Pro despite Conv 168 fix
- [ ] #14: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #15: [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] #16: [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] #17: [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] #18: [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] #19: [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] #20: [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] #21: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #22: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #23: [MPV] Add "open Figma SVG first" step to pre-plan scaffolding for matt/* page builds
- [ ] #24: [ASF] Investigate why Astro.slots.has + && short-circuit doesn't restore child slot fallback

## Key Context

- **Branch `jfg-dev-13-matt`** still holds all Matt design work. Conv 175 will add another commit (the work uncommitted at time of /r-end) once Step 6 lands.

- **Conv 175 commits to date:** code `350bf88` (HeaderBar floating pill + AppLayout slot-forwarding ternary + bridge lg:1025px + /matt/index.astro stub), code `dca4614` (CourseHeader + course/[slug]/index.astro Phase 3 v1), docs `9825621` (slot-forwarding memory). Step 6 of this /r-end will add the Phase 4 primitives + the retrofit + hero rebuild diff.

- **Three new matt primitives** at `src/components/matt/ui/`: `Button.tsx` (6 variants per matt-design-system.md §6 Button table — primary/outlined as definitive CTAs with visible blue border; course/student/creator/default as soft pills with seamless edge), `Card.astro` (white container with padding scale + optional borderless), `SectionTitle.astro` (semantic level × visual size axes).

- **CourseHeader rebuilt** as a two-column hero (240px min-height): LEFT has title at `text-[2.5rem] font-bold leading-tight tracking-tight`, tagline, metadata row with three inline-SVG icons (person/star/grad-cap) + creator name + ★rating(count) + level. RIGHT has ✓-includes list + "$X • Enroll Now ›" white pill. Top-right overlay cluster: 40px circular white back-chevron linking to `/matt/courses` + 24px book/academic-cap glyph below. Image background uses dark gradient (0.65→0.45) over `course.thumbnail_url`.

- **`min-height: 480px` Tailwind arbitrary-value didn't work** — class appeared in HTML but no CSS rule generated. Inline `style="min-height: 240px;"` is the live workaround. Root cause unknown; suspect interaction with `--spacing-*` global override in tokens-tailwind-bridge.css. Tracked as [TWLG-MIN-H].

- **Course page structure (`/matt/course/[slug]/index.astro`)**: AppLayout(entity=course) → breadcrumb in `header-bar` slot → SubNav with 7 tabs in `sub-nav` slot → article body with CourseHeader + 4 Cards: About / What you'll learn (2-col grid) / Prerequisites / Who this is for. "Meet the Creator" is now a SubNav tab (route `/matt/course/[slug]/creator` deferred to Phase 5), no longer a body Card. "What's included" lives only in the hero overlay (no body Card).

- **Astro slot-forwarding gotcha** — `<Fragment slot="x"><slot name="y" /></Fragment>` ALWAYS suppresses the child component's `<slot name="x">FALLBACK</slot>` fallback, even when slot `y` is empty. `Astro.slots.has + &&` short-circuit DID NOT restore the fallback in our test. Durable pattern: keep slot defaults in the layout consumer (AppLayout) via ternary inside *unconditional* Fragments; primitives carry no slot fallbacks. Documented at `memory/reference_astro_slot_forwarding.md`; cross-referenced from HeaderBar.astro docstring.

- **Visual-fidelity workflow lesson** — for matt/* pages: symlink the relevant Matt Figma SVG into `public/_matt-ref/{Page-Name}.svg` and open in chrome BEFORE building, not after. Conv 175 caught this late ([MATT-EXEC-PG1] structurally complete before SVG was opened); user feedback prompted a multi-iteration retrofit. Tracked as [MPV].

- **detect-machine.sh still broken on M4Pro** — `~/.claude/.machine-name` cached as "Unknown (M4Pro.local)". Workaround: substitute `MacMiniM4Pro` manually in commits/timecards (this conv's /r-end commits will use the manual substitute). Tracked as [MND2].

- **Skipped this conv:** RoleTabBar, Module, SocialPost, Note, ToDoItem (deferred Phase 4); body-section visual polish; the Astro/Tailwind investigations.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
