# State — Conv 188 (2026-05-24 ~17:48)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 188 advanced MATT-DESIGN-PUSH on two fronts: shipped the course **SubNav routing skeleton** (`/matt/course/[slug]/[...tab].astro` + a most-specific-match active-state fix in SubNav.astro), then began **PG2 tab bodies** under Option A (per-tab `.astro` components + a `tab ===` switch). Built **ResourcesTab** (empty state; harvested `folder.svg`) and **TeachersTab** (bio card, role-based entity palette). A role-color request led to an opt-in `roleDot` on UserIcon, which surfaced and fixed a real app-wide bug: cascade-driven entity tokens were declared under plain `@theme` (flattened at `:root`) — moved to `@theme inline`. Resolved the Modules data model (Session↔Module 1:1; Matt's "Module" = Sub-Module). All 5 baseline gates green; nothing pushed yet (Step 6 commits this state).

## Completed

- [x] [MATT-SUBNAV-ROUTING] SubNav most-specific active-state + `[...tab].astro` route (curl-verified)
- [x] [RESTAB] ResourcesTab empty state + `folder.svg` harvest (42nd icon)
- [x] [TCHTAB] TeachersTab bio-card composite (role palette by user_id===creatorId)
- [x] [MOD-SCHEMA] resolved — Session↔Module 1:1; Matt "Module" = Sub-Module (memory saved)
- [x] [ENTITY-CASCADE-BUG] fixed — entity tokens moved to `@theme inline`; EntityPill/Link/initials now cascade correctly
- [x] Routing demonstrated live (`.scratch/screenshots/matt-subnav-routing.gif`)
- [x] Role-color corner dot (`roleDot` opt-in on UserIcon)

## Remaining

**Lead candidates — PG2 course tabs (Option A: per-tab `.astro` in `src/components/matt/course/`, `tab ===` switch in `[...tab].astro`):**
- [ ] [CRTTAB] Build CreatorTab — probe frame `552:13664` first (unprobed); bio-card family ≈ Teachers; reconcile with Conv 184/185 creator-trio
- [ ] [RVWTAB] Build ReviewsTab — heaviest; header + ReviewCard (UserIcon + stars + body + embedded CourseAnchor + reaction pills), frame `534:11206`
- [ ] [MODTAB] Build ModulesTab — frame `497:12795`; per MOD-SCHEMA: session = Module (1:1), inner "N Sub-Modules" count; verify course_curriculum/lesson_count mapping
- [ ] [SHOWMORE] Decide + build the "Show More" expand affordance (Teachers + Reviews) — mechanism choice (CSS / `<details>` / island); cross-cutting

**Matt visual fidelity (from Conv 188 review):**
- [ ] [SNV-ICONS] Course SubNav items missing leading icons. Mapping: About→info, Course Feed→feed, Modules→work-together, Meet the Creator→creator, Teachers→student-teacher, Reviews→review, Resources→resource. Pass `icon` in courseTabs (both index.astro + [...tab].astro; dedupe array)
- [ ] [MNV-STYLE] Sidebar/MainNav emoji icons + type (tracking/size/weight) differ from Matt's Layout frames (81:1483 / 516:17113 / 517:8867) + Main Nav 108:4468
- [ ] [ENTITY-VIS-AUDIT] Eyeball entity-heavy pages after the `@theme inline` fix (rendering changed app-wide)
- [ ] [MATT-COURSE-POLISH] Body polish on /matt/course/[slug]
- [ ] [CH-VARIANTS] CourseHeader Enrolled (597:6504) + Scheduled (685:13240)
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon system (Phase 6)

**Bigger Matt blocks:**
- [ ] [MATT-EXEC-PG2] parent — course tabs decomposed above; Enroll family (rows 9-10), Choose Teacher (11), Session `/matt/session/[id]` (13-15) still under this parent
- [ ] [MMP-PH5] Phase 5 graduation — promote scratch + Content/Happy/Home re-render
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6 extrapolation primitives + CourseInFeed Mobile (502:12958)
- [ ] [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] [MMP-PH3] parent (substantially advanced)
- [ ] [RTB] [Opus] Role Tab Bar design-spec

**Asset harvests (premature until their frames are deep-probed):**
- [ ] [HOWTOREG-ICN] / [VIDEO-COMMENT-ICN] / [PLAY-CIRCLE-ICN]

**Tooling + docs:**
- [ ] [ASSET-SWEEP-GATE] Figma-URL grep guard in /w-codecheck
- [ ] [FIGMA-MCP-DOC-HARVEST] asset-harvest discipline section in figma-mcp.md
- [ ] [MFRD-GRADUATE] graduate matt-frames-ready-for-dev.md to docs/reference/
- [ ] [ESOT-STRUCTURE] "probe before claiming structure" rule
- [ ] [BROWSER-FALLBACK] document Playwright fallback
- [ ] [MEM-ICON-COUNT] MEMORY.md Icon System: 42 SVGs / MattIcon.tsx (was 39/.astro) — fix alongside next icon harvest

**Watch / permanent:**
- [ ] [MFRD-LOOKUP] maintain Ready-for-Dev drift lookup (permanent)
- [ ] [TXTBTN] watch inline text-styled action button pattern
- [ ] [LH-VERIFY] verify Figma lineHeight:100 = ratio 1.0
- [ ] [MEM-CAP-WATCH] monitor MEMORY.md cap; prune by Conv 190

## TodoWrite Items

All pending tasks above carry their mnemonic codes (preserved for cross-conv reference). `[Opus]` on: [MATT-EXEC-EXT], [RTB].

## Key Context

- **`@theme inline` rule (Conv 188):** cascade-driven Tailwind tokens (`--color-entity-*`) MUST live in `@theme inline`, not plain `@theme`, or the use-site `.entity-*` cascade is flattened against `:root`. The fix changed entity-component rendering app-wide → see [ENTITY-VIS-AUDIT]. Documented in matt-design-system.md §5 + DEVELOPMENT-GUIDE.md.
- **Role palette by role:** `.entity-creator` = purple (#E0E8FF/#584DF4 = Creator tokens), `.entity-student-teacher` = blue (aliases Student). TeachersTab picks per `teacher.user_id === creatorId`.
- **`[...tab].astro` switch:** Resources + Teachers branches built; others fall through to "coming soon" placeholder. Add new tabs as `tab === 'x'` branches. `courseTabs` array is duplicated in index.astro + [...tab].astro (Option A; dedupe when [SNV-ICONS] touches it).
- **Module model:** Session↔Module 1:1; Matt's nested "Modules" = Sub-Modules. No session→many-modules schema. (`memory/project_module_submodule_model.md`.)
- **Matt frame probes this conv:** Modules 497:12795, Resources 537:12144 (empty state), Reviews 534:11206, Teachers 537:12780. Lookup rows 3-8 corrected. Creator 552:13664 NOT yet probed.
- **All 5 gates green this conv:** tsc, astro check 1258/0/0/0, lint, build 6.30s, test 6453 passed (371 files).
- **Branch `jfg-dev-13-matt`** retained.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
