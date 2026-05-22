# State — Conv 174 (2026-05-22 ~12:08)

**Conv:** ended
**Machine:** MacMiniM4Pro (note: detect-machine.sh returned "Unknown" — see [MND2])
**Branch:** code: `jfg-dev-13-matt` (NEW this conv, branched from `jfg-dev-12`), docs: `main`

## Summary

Conv 174 executed Phases 1 + 2 of the MATT-DESIGN-PUSH execution sequence on a new coexistence branch `jfg-dev-13-matt`. Phase 1 [MATT-EXEC-TKN] landed the 3-file Matt token scaffold (primitives + semantics + Tailwind bridge); the bridge spacing override was committed per user choice B, accepting a global `p-N` utility shift across 572 legacy callsites in exchange for `/matt/*` utility ergonomics. Phase 2 [MATT-EXEC-SHL] landed all 5 layout-shell components (MattLayout + Sidebar + HeaderBar + ControlBar + SubNav) under `src/{layouts,components}/matt/`; bridge color/typography utilities now emit to built CSS. No /matt/* page exists yet — next conv intent is to look at the responsive shell in a browser (likely requires the [MSH-VIZ] stub page first) before committing to Phase 3 scope.

## Completed

→ See PLAN.md MATT-DESIGN-PUSH block (`[MATT-EXEC-TKN]` and `[MATT-EXEC-SHL]` marked complete Conv 174).

## Remaining

- [ ] [MSH-VIZ] Add minimal /matt/index.astro stub for browser-view of Phase 2 layout shell — Conv 174 user-requested follow-up; gates next-conv visual review
- [ ] [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start (pending Brian's paid Figma access)
- [ ] [MSH-REFINE] MattLayout shell refinements deferred from Phase 2 (tablet HeaderBar top:48px positioning; tablet main pt-clearance; Tailwind lg: 1px shift) [Phase 3 visual gate or [TSV]]
- [ ] [MATT-EXEC-PG1] Phase 3: first /matt/* page end-to-end (rec: /matt/course/[slug]) [Opus]
- [ ] [MATT-EXEC-PRM] Phase 4: remaining primitives (Button variants, Card, Module, RoleTabBar) [Opus]
- [ ] [MATT-EXEC-PG2] Phase 5: remaining 12 /matt/* routes
- [ ] [MATT-EXEC-EXT] Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill) [Opus]
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] [MATT-EXEC-FLAGS] Cross-phase: verify 4 route-shape assumptions against codebase before Phase 5
- [ ] [RTB] Design Role Tab Bar [Opus] — bundled into Phase 4
- [ ] [TSV] Token Scaffolding Verification [Opus] — runs parallel with Phases 4–6
- [ ] [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder (229-file source export)
- [ ] [MND2] detect-machine.sh still returns "Unknown" on M4Pro despite Conv 168 fix
- [ ] [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state (external-blocked)
- [ ] [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter (external-blocked, upstream Astro)
- [ ] [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings (watch task)

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
- [ ] #10: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #11: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #12: [RTB] Design Role Tab Bar [Opus]
- [ ] #13: [TSV] Token Scaffolding Verification [Opus]
- [ ] #16: [MATT-EXEC-PG1] Phase 3: first /matt/* page end-to-end (rec: /matt/course/[slug]) [Opus]
- [ ] #17: [MATT-EXEC-PRM] Phase 4: remaining primitives (Button variants, Card, Module, RoleTabBar) [Opus]
- [ ] #18: [MATT-EXEC-PG2] Phase 5: remaining 12 /matt/* routes
- [ ] #19: [MATT-EXEC-EXT] Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill) [Opus]
- [ ] #20: [MATT-EXEC-GRD] Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] #21: [MATT-EXEC-FLAGS] Cross-phase: verify 4 route-shape assumptions against codebase before Phase 5
- [ ] #22: [MND2] detect-machine.sh still returns "Unknown" on M4Pro despite Conv 168 fix
- [ ] #23: [MSH-REFINE] MattLayout shell refinements deferred from Phase 2
- [ ] #24: [MSH-VIZ] Add minimal /matt/index.astro stub for browser-view of Phase 2 layout shell

## Key Context

- **Branch `jfg-dev-13-matt` is NEW this conv** — created off `jfg-dev-12` per matt-pre-plan.md §1. Holds all `/matt/*` coexistence work until the future flip block. Pushed in Conv 174 /r-end Step 7 — origin tracking branch created. Existing app on `jfg-dev-12` and earlier branches unaffected.

- **Tailwind 4 spacing override is GLOBAL on this branch** — Conv 174 user choice B locked it in. `--spacing-N` in `tokens-tailwind-bridge.css @theme` overrides Tailwind defaults for N ∈ {4, 8, 12, 16, 20, 24, 32, 40, 48, 64}. Effect: `p-4` is now 4px (was 16px), `p-16` is 16px (was 64px), etc. Non-overridden N (1, 2, 3, 5, 6, 7, 9, 10, 11...) still use multiplicative `calc(0.25rem * N)` so `p-1=4px`, `p-2=8px`, `p-5=20px`. 572 legacy `p-4` callsites + many more `m-N`/`gap-N`/`px-N`/`py-N` have visually shrunk on this branch — that's expected. When visually reviewing non-`/matt/*` pages on `jfg-dev-13-matt`, factor this in.

- **Matt cascade is preserved (load-bearing)** — `tokens-semantic.css` uses `var()` chains for 2-layer + 3-layer cascade: `--Student-Primary: var(--Primary-Default)` NOT flattened to `var(--americana-blue)`. Future tuning of `--Primary-Default` propagates automatically. Don't flatten when extending.

- **Bridge `@theme` color/typography tokens emit on-demand** — Tailwind 4 only ships tokens to production CSS when a utility class consumes them. Phase 2 components first triggered emission of `--color-text-default`, `--color-entity-primary`, `--text-body-default`, etc. Future bridge token additions need a consumer somewhere to actually appear in `dist/`.

- **No `/matt/*` page exists yet** — Phase 2 landed the layout/component shell, but no `src/pages/matt/*.astro` file uses MattLayout. To browser-view the responsive design (user's stated next-conv intent), need to add at minimum a thin stub at `src/pages/matt/index.astro` (tracked as [MSH-VIZ] #24). That unblocks visual review BEFORE Phase 3 [MATT-EXEC-PG1] which builds the first real page.

- **3 deferred Phase 2 refinements** — Tablet portrait HeaderBar should be positioned at `top: 48px` (not `top-0`); tablet main panel padding-top likely needs ~72px clearance (currently sm:pt-32); Tailwind `lg:` boundary is 1024px vs Matt's 1025px (1px shift). All non-blocking; resolve at Phase 3 visual gate or as [TSV] sub-tasks. Code-comment'd in MattLayout.astro + HeaderBar.astro.

- **`detect-machine.sh` is broken on M4Pro** — `~/.claude/.machine-name` cached as "Unknown (M4Pro.local)" despite Conv 168 [MND] fix. Bare hostname is `M4Pro`. Affects all skills that read machine name from cache file. Workaround: substitute `MacMiniM4Pro` manually in commits/timecards. Tracked as [MND2].

- **Phase progression after this conv:** [MSH-VIZ] stub (browser-view of layout) → user reviews responsive shell → then Phase 3 [MATT-EXEC-PG1] (first real /matt/course/[slug] page). Don't skip [MSH-VIZ] — user explicitly wants to validate Phase 2 visually before committing to Phase 3 scope.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
