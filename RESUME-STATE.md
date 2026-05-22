# State — Conv 173 (2026-05-22 ~11:09)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 173 authored `docs/as-designed/matt-pre-plan.md` (~510 lines, 12 sections) — the execution plan for the `/matt/*` re-skin: route map (31 Matt screens → 13 routes), file structure, Tailwind 4 wiring, page assembly pattern, extrapolation enumeration, 7-phase execution sequence (`[MATT-EXEC-TKN]` → `[MATT-EXEC-GRD]`). Walked through 8 §4 blocking decisions one-at-a-time with user; all 8 recommendations stood (units = hybrid; primitives = kebab-case; Tailwind = bridge file; primary = coexist; `/matt/` = member-only; Sidebar = rebuild; HeaderBar = slot-based; footer = omit). PLAN.md updated: `[MATT-PRE-PLAN]` marked complete with Conv 171 Control Bar misattribution correction; 8 new MATT-EXEC-* phase tasks added. Ready to start phase 1 (`[MATT-EXEC-TKN]` — token files) next conv.

## Completed

→ See PLAN.md `[MATT-PRE-PLAN]` line marked `[x]` Conv 173 + new "MATT-DESIGN-PUSH Execution Phases" section.

## Remaining

- [ ] [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state (external-blocked from prior conv)
- [ ] [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start
- [ ] [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder
- [ ] [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter (external-blocked, upstream Astro)
- [ ] [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings (watch-only)
- [ ] [RTB] Design Role Tab Bar [Opus] — Peerloop extension (multi-role perspective switcher); now bundled into `[MATT-EXEC-PRM]` Phase 4
- [ ] [TSV] Token Scaffolding Verification [Opus] — runs parallel with Phases 4–6
- [ ] [MATT-EXEC-TKN] **Next major thrust** — Phase 1: 3 token files + global.css import chain ([Opus])
- [ ] [MATT-EXEC-SHL] Phase 2: layout shell (MattLayout + Sidebar + HeaderBar + ControlBar + SubNav) ([Opus])
- [ ] [MATT-EXEC-PG1] Phase 3: first /matt/* page end-to-end (rec: /matt/course/[slug]) ([Opus])
- [ ] [MATT-EXEC-PRM] Phase 4: remaining primitives (Button variants, Card, Module, RoleTabBar) ([Opus])
- [ ] [MATT-EXEC-PG2] Phase 5: remaining 12 /matt/* routes
- [ ] [MATT-EXEC-EXT] Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill) ([Opus])
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] [MATT-EXEC-FLAGS] Cross-phase: verify 4 route-shape assumptions against codebase before Phase 5

## TodoWrite Items

- [ ] #1: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state — external-blocked, recording investigation
- [ ] #2: [BR-STATUS] Add sessions.recording_status enum column [Opus] — schema addition for recording status tracking
- [ ] #3: [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus] — prod migration apply
- [ ] #4: [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL — d1_migrations row insert
- [ ] #5: [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations — migration table rename
- [ ] #6: [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus] — password rotation with seed + UPDATE
- [ ] #7: [DB-SYNC-VERIFY] Final prod D1 convergence check — verify after DB-SYNC-02/03/04 + PROD-PW-APPLY
- [ ] #8: [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start — automation pending client access
- [ ] #9: [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder — 229-file source export cleanup
- [ ] #11: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter — external-blocked, upstream Astro 6.3.6 bug
- [ ] #12: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings — watch task
- [ ] #13: [RTB] Design Role Tab Bar [Opus] — Peerloop extension (multi-role perspective switcher)
- [ ] #14: [TSV] Token Scaffolding Verification [Opus] — verify scaffolded values against Matt's design across token types

## Key Context

- **matt-pre-plan.md** at `docs/as-designed/` is the authoritative execution blueprint for the `/matt/*` re-skin. 12 sections, ~510 lines, paired with `matt-design-system.md` as Companion docs (matt-design-system = *what*; matt-pre-plan = *how*).
- **All 8 §4 decisions resolved Conv 173** — see matt-pre-plan.md §4 Resolution-summary table:
  1. **C** — Hybrid units (rem for type+spacing, px for borders+hairlines)
  2. **B** — kebab-case for primitives; semantics keep `Title-Case/with-slash`
  3. **C** — Hybrid Tailwind bridge file (`tokens-tailwind-bridge.css`)
  4. **B** — Coexist with existing `--color-primary-*` sky-blue scale
  5. **A** — `/matt/` = `/dashboard` analog (member-only); visitors → `/matt/login`
  6. **B** — Rebuild Sidebar as new `Sidebar.tsx` (reuse hooks/utilities, fresh skeleton)
  7. **C** — Slot-based HeaderBar (named slots `header-left/center/right`); same pattern for SubNav
  8. **A** — Omit footer entirely from `MattLayout`
- **Conv 171 Control Bar misattribution corrected in PLAN.md** — Matt's Control Bar = primary-nav bottom-pill at tablet/mobile (NOT a role switcher); Role Tab Bar = Peerloop extension = ExploreTabBar re-skin.
- **File structure locked in matt-pre-plan.md §3:** tokens at `src/styles/tokens-primitives.css` + `tokens-semantic.css` + `tokens-tailwind-bridge.css` → all imported into `global.css`. Layout at `src/layouts/matt/AppLayout.astro`. Components at `src/components/matt/{,entity,ui}/`. Pages at `src/pages/matt/`. Naming principle: future-default identity — `matt/` subdirectories are temporary disambiguators; files take the names they'll have after the flip.
- **Coexistence principle:** existing app routes/components/styles stay untouched. `/matt/*` runs in parallel on branch `jfg-dev-13-matt` (not active this conv — branch unchanged). Future flip block will consolidate.
- **Active block has shifted into execution mode** — MATT-DESIGN-PUSH planning is done; next conv starts `[MATT-EXEC-TKN]` (Phase 1, token files). Estimated 8–11 convs to complete all 7 phases.
- **Code repo (`Peerloop`):** `package-lock.json` modified cosmetically (npm peer:true annotations from /r-start npm install). No package version changes. Committed in /r-end.
- **Branch:** `jfg-dev-12` (code, unchanged this conv), `main` (docs). Conv 173 commit will be the docs-repo end-of-conv landing.
- **Will be committed in Step 6 of /r-end:** matt-pre-plan.md (NEW), matt-design-system.md (Companion cross-reference), PLAN.md (Conv 173 updates + 8 phase tasks), RESUME-STATE.md (this file), package-lock.json (code repo).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
