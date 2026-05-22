# State — Conv 171 (2026-05-21 ~21:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 171 was a strategic/design-system foundation conv. No source-code changes. Created `docs/as-designed/matt-design-system.md` (graduated mid-conv from `.scratch/matt-devmode-form.md`) as the authoritative design-system spec for the Matt design push. Captured strategic context (Matt's 80/20 Pareto brief on student → teacher flywheel; calibration-set vs extrapolation-test framing), architectural findings (no global header, 2-panel layout, entity-color-coded headers, role-perspective Control Bar), existing-app context (URL routing, role-aware components, schema mapping), and progressed [MDM] (Batch 1 typography fully measured via Figma Dev Mode; Batch 2/4/5 partial). Key insight surfaced: the role-perspective Control Bar pattern Matt designed already exists in code as `ExploreTabBar` (Conv 042-044), so /matt/* is purely visual re-skin, not architecture work.

## Completed

- [x] /r-start (npm install + memory sync + RESUME-STATE transfer of 12 tasks → TodoWrite)
- [x] [MDM] Batch 1 Typography — Inter, sizes 12/14/16/20/24/32, regular=400, medium=500, headers=500/600, body=400/500/600, line-height normal for headers + 150% for body Medium/Large + letter-spacing -0.352px on body Medium/Large
- [x] [MDM] Batch 2 Desktop (partial) — sidebar 220/70, page padding 16, sidebar-main gutter 16, Header Bar identified as ~40-48px breadcrumb strip, Control Bar visibility rule resolved
- [x] [MDM] Batch 4 — page layout confirmed 2-column (Sidebar + Main Panel); inner grid TBD
- [x] [MDM] Batch 5 — Control Bar visibility rule + position resolved (role-perspective tabs, only when user has >1 role for entity); height TBD
- [x] Color primitives — 12 hex codes extracted from Color Guide overview PNG
- [x] Architectural findings persisted — no global top header (sidebar-only branding), Header Bar = breadcrumb strip, entity-color-coded headers, Sub Nav vertical-left, Control Bar = role tabs above content
- [x] Existing-app context captured — URL routing conventions, course routes to mirror, role-aware components (ExploreTabBar / RoleBadge / etc., Conv 042-044), CurrentUser singleton, schema role flag mapping, `?via=` breadcrumb pattern, page auth tiers, UI primitives, file-path index, historical context
- [x] Form graduation — `.scratch/matt-devmode-form.md` → `docs/as-designed/matt-design-system.md` (restructured: Strategic Context → Architectural Findings → Existing App Context → Open Questions → Color Primitives → Token Extraction working section)
- [x] [MDM] task #13 description updated with new path + Batch progress status
- [x] [MATT-PRE-PLAN] task #10 description updated with strategic context, new primary input, deliverables (g) Extrapolation enumeration + (h) Doc graduation
- [x] `docs/INDEX.md` updated with matt-design-system entry under "How Should It Look/Work?" section

## Remaining

### Matt design push (NEXT CONV main thrust)

- [ ] [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start after Brian's paid Figma seat provisions
- [ ] [MATT-INVENTORY-CLEANUP] Triage remaining `.scratch/matt-figma/` items (mostly superseded by curated matt-main)
- [ ] [MATT-PRE-PLAN] [Opus] Plan /matt/* route map + tokens + components + MattLayout — read `matt-design-system.md` first (primary input); resolve 6 open questions in §4; address typo "Exertise" → "Expertise"; read 3 deferred docs (orig-pages-map.md, GLOSSARY.md, DECISIONS.md)
- [ ] [MDM] Continue token extraction — Batch 2 Tablet/Mobile sections, Batch 3 spacing scale, Batch 4 inner grid dims, Batch 5 Control Bar height measurement

### DEPLOYMENT.DB-SYNC (carry-forward; apply when DEPLOYMENT block is actively worked)

- [ ] [DB-SYNC-04] [Opus] Apply `migrations/0004_feed_activity_index.sql` to prod D1 via `wrangler d1 execute peerloop-db --remote --file migrations/0004_feed_activity_index.sql`
- [ ] [DB-SYNC-03] Insert tracker row for `0003_fix_session_times.sql` without running SQL (data already converged)
- [ ] [DB-SYNC-02-RENAME] Rename stale `0002_seed.sql` → `0002_seed_core.sql` in prod `d1_migrations`
- [ ] [PROD-PW-APPLY] [Opus] Execute deferred Peerloop2 rotation against prod admin — 3 steps: hash edit in 0002_seed_core.sql:172, wrangler d1 execute UPDATE, verify login
- [ ] [DB-SYNC-VERIFY] Final prod D1 convergence check

### BBB-RECORDING (carry-forward, external-blocked)

- [ ] [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state (needs fresh BBB test session)
- [ ] [BR-STATUS] [Opus] Add `sessions.recording_status` column with enum (awaits BR-ZERO-REPRO + Blindside follow-up)

### External-blocked / watch-only

- [ ] [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter — waiting upstream Astro fix post-6.3.6
- [ ] [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings (self-resolved Conv 165, investigate only if recurs)

## TodoWrite Items

- [ ] #1: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #2: [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] #3: [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] #4: [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] #5: [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] #6: [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] #7: [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] #8: [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start
- [ ] #9: [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder
- [ ] #10: [MATT-PRE-PLAN] Plan /matt/* route map + tokens + components + MattLayout [Opus]
- [ ] #11: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #12: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #13: [MDM] Extract design token values from Figma Dev Mode (5 batches)

## Key Context

**Pre-commit state (will be committed in Step 6):**
- **Docs repo:** `docs/as-designed/matt-design-system.md` (new — 650+ lines, the graduated design-system doc), `docs/INDEX.md` (+1 line entry), `RESUME-STATE.md` (re-created this step), session files (Extract pruned to 246 lines after manifest prune, Learnings.md, Decisions.md authored by agents). Plus PLAN.md updates from update-plan agent (added Conv 171 Items section with 3 [x] + 4 new deferred tasks). Plus DECISIONS.md (§5 UI/UX 2 entries) + DOC-DECISIONS.md (1 entry) + TIMELINE.md (4 entries) from learn-decide agent.
- **Code repo:** `package-lock.json` only (incidental npm install reformatting at /r-start; no functional code changes).

**Baseline state:** No source code touched this conv. Last verified Conv 168 (5-gate baseline green + 6453/6453 tests). Carry-forward safe — no `src/` changes since.

**Primary artifact:** `docs/as-designed/matt-design-system.md` — graduated mid-conv from `.scratch/matt-devmode-form.md` (deleted). Now git-tracked, propagates to M4Pro on next sync, discoverable from `docs/INDEX.md`. 6 sections:
1. Strategic Context (Matt brought in late deliberately, Pareto brief on student → teacher flywheel, user's 3-part job, calibration-set vs extrapolation-test framing, North Star tiebreaker, authority split)
2. Architectural Findings (2-panel layout, no global header, Header Bar = breadcrumb, entity-color-coded headers, Sub Nav vertical-left, Control Bar = role tabs, layout shell ASCII diagram, 6 roles, component implications)
3. Existing App Context (URL routing, course routes, role-aware components, CurrentUser singleton, schema mapping, layout shell mapping, breadcrumb pattern, auth tiers, UI primitives, files to read, historical context)
4. Open Questions (6 items: Visitor flow on Member-only pages, Account dropdown placement, Footer presence, Inner column grid, Featured-course-card variant, Free Teacher badge component + typo "Exertise")
5. Color Primitives (12 hex codes + semantic aliases + naming convention)
6. Token Extraction (working section with Batches 1-5; Batch 1 complete, Batch 2/4/5 partial, Batch 3 untouched)

**Key file paths for next conv:**
- Primary doc: `~/projects/peerloop-docs/docs/as-designed/matt-design-system.md`
- Curated build set: `~/projects/peerloop-docs/.scratch/matt-main/` (83 files, 85 MB)
- Full source: `~/projects/peerloop-docs/.scratch/matt-figma/` (229 files, 137 MB)
- Existing role components to re-skin: `~/projects/Peerloop/src/components/discover/` (ExploreTabBar, RoleBadge, RolePillFilters, ExploreCourseTabs, etc.)
- Existing layout to re-skin: `~/projects/Peerloop/src/layouts/AppLayout.astro` + `~/projects/Peerloop/src/components/AppNavbar.*`
- Existing breadcrumb (Header Bar pattern): `~/projects/Peerloop/src/components/ui/Breadcrumbs.astro`
- Dynamic role-tab catch-all: `~/projects/Peerloop/src/pages/course/[slug]/[tab].astro` (Conv 165-166)

**Coordination required for next-conv work:**
- [MATT-PRE-PLAN] [Opus] is the main thrust — multi-dimension design work (tokens + layout shell + component primitives + extrapolation strategy). Pair on this before starting.
- DEPLOYMENT.DB-SYNC bundle ([Opus] on #3, #6) — touches live prod D1 + admin auth. Pair before running.

**External-blocked / waiting:** [BR-ZERO-REPRO], [BR-STATUS] [Opus] (BBB), [AAP] (upstream Astro), [VITE-DEPS-WATCH] (watch-only), [MATT-MCP-RETRY] (Brian's Figma seat).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Next conv main thrust:** [MATT-PRE-PLAN] [Opus] — read `docs/as-designed/matt-design-system.md` first (everything needed for planning is there), then plan /matt/* route map, token files, layout shell, component primitives, and extrapolation strategy.
