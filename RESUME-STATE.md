# State — Conv 177 (2026-05-23 ~09:14)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 177 resolved [NPM-UP] and [DSSR-SCOPE] end-to-end. Upgraded astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, plus a coupled wrangler 4.81.1→4.94.0 to satisfy the peer dep. After two failed workaround attempts and a sequence of misleading observations, the /matttest comparison probe revealed the underlying bug was Vite's cold-start dep discovery race — not React/SSR/Cloudflare incompatibility. The crash is reproducible only on the FIRST request after fresh `.vite/` state, self-heals on the next request, and never affects production builds. Industry-wide pattern (Remix #10156, TanStack #4264, Storybook #32049, Vite #17979). Fix: `vite.optimizeDeps.entries + include: ['astro/virtual-modules/transitions.js']` in astro.config.mjs. Conv 176's stateless-primitives discipline retired. ToDoItem rewritten as controlled-or-uncontrolled hybrid. Production build clean (7.27s); preview /matt/ renders all 13 primitives. /w-codecheck: all 8 checks PASS.

## Completed

- [x] [NPM-UP] Astro stack upgrade (4 packages bumped)
- [x] [DSSR-SCOPE] root cause identified + Vite optimizeDeps fix applied
- [x] [AAP] re-tested against Astro 6.3.7 — still broken upstream, task description updated
- [x] Stateless-primitives discipline removed from DEVELOPMENT-GUIDE.md, replaced with cold-start diagnosis
- [x] ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid
- [x] PLAN.md DEV-STAGING-SSR row marked RESOLVED
- [x] api-test-helper.ts `logger` stub (Astro 6.3 APIContext addition)
- [x] HeaderBar.astro Props cast fix (astro check ts6196 hint)
- [x] CourseHeader.astro dead Button import removed (astro check ts6133 hint)
- [x] Sidebar.tsx flex-shrink-0 → shrink-0 (Tailwind v3→v4 rename)
- [x] Production build verified clean (7.27s)
- [x] /w-codecheck all 8 checks PASS

## Remaining

🔝 **Lead next-conv task** — pick based on appetite:

- [ ] **[MATT-EXEC-FLAGS]** Verify 4 route-shape assumptions against codebase before Phase 5 (gating task for Phase 5)
- [ ] **[MATT-EXEC-PG2] [Opus]** Phase 5: remaining 12 /matt/* routes — the next major chunk of MATT-DESIGN-PUSH

**MATT-DESIGN-PUSH Phase 5 onward:**

- [ ] **[MATT-EXEC-PG2] [Opus]** Phase 5: remaining 12 /matt/* routes
- [ ] **[MATT-EXEC-FLAGS]** Verify 4 route-shape assumptions against codebase before Phase 5
- [ ] **[MATT-EXEC-EXT] [Opus]** Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill)
- [ ] **[MATT-EXEC-GRD]** Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] **[MATT-COURSE-POLISH]** Body section visual polish on /matt/course/[slug]
- [ ] **[MATT-CREATOR-TAB]** /matt/course/[slug]/creator route (Phase 5 sub-task)
- [ ] **[MATT-ICON-SWAP]** Hero overlay inline-SVG icons → icon-system in Phase 6
- [ ] **[MATT-INVENTORY-CLEANUP]** Triage `.scratch/matt-figma/` (actual dir is `.scratch/matt-main/`)
- [ ] **[MATT-MCP-RETRY]** ⏸️ ON HOLD — Figma MCP setup blocked externally
- [ ] **[MATT-RT-DOC]** Triage /matt/* route documentation in url-routing.md

**Design / token work:**

- [ ] **[RTB]** Design Role Tab Bar — finalize design-spec doc (component shipped Conv 176)
- [ ] **[TSV]** Token Scaffolding Verification
- [ ] **[NOTE-YELLOW]** Add `--note-yellow` token to tokens-primitives.css
- [ ] **[CASCADE-BROKEN] [Opus]** `.entity-*` multi-mode cascade not propagating through Tailwind `bg-entity-background`

**Tools / infra / pending upstream:**

- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in ClientRouter — UPSTREAM-BLOCKED, re-tested Conv 177 still broken
- [ ] **[TWLG-MIN-H]** Tailwind 4 arbitrary-value `min-h-[480px]` didn't take effect
- [ ] **[ASF]** Investigate Astro.slots.has + && short-circuit not restoring child slot fallback
- [ ] **[MPV]** Add "open Figma SVG first" + qlmanage SVG→PNG step to pre-plan scaffolding for matt/* page builds
- [ ] **[MND2]** detect-machine.sh still returns "Unknown" on M4Pro despite Conv 168 fix
- [ ] **[TDS-DRIFT]** tech-doc-sweep returned "no recent changes" despite matt/* additions
- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references → correct to `.scratch/matt-main/`
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings
- [ ] **[MEM-CAP]** Schedule `/r-prune-claude` pass
- [ ] **[MEM-IDX-SLOT]** Add MEMORY.md index entry for `reference_astro_slot_forwarding.md`

**BBB / Production:**

- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min empty-but-published recording state
- [ ] **[BR-STATUS] [Opus]** Add sessions.recording_status enum column
- [ ] **[DB-SYNC-04] [Opus]** Apply 0004_feed_activity_index.sql to prod D1
- [ ] **[DB-SYNC-03] [Opus]** Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] **[DB-SYNC-02-RENAME] [Opus]** Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] **[PROD-PW-APPLY] [Opus]** Execute deferred Peerloop2 rotation against prod admin
- [ ] **[DB-SYNC-VERIFY]** Final prod D1 convergence check

## TodoWrite Items

- [ ] #2: [MATT-EXEC-PG2] Phase 5: remaining 12 /matt/* routes [Opus]
- [ ] #3: [MATT-EXEC-EXT] Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill) [Opus]
- [ ] #4: [MATT-EXEC-GRD] Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] #5: [MATT-EXEC-FLAGS] Verify 4 route-shape assumptions against codebase before Phase 5
- [ ] #6: [MATT-MCP-RETRY] ⏸️ ON HOLD — Figma MCP setup blocked externally
- [ ] #7: [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder
- [ ] #8: [RTB] Design Role Tab Bar — finalize design-spec doc
- [ ] #9: [TSV] Token Scaffolding Verification
- [ ] #10: [MND2] detect-machine.sh still returns "Unknown" on M4Pro
- [ ] #11: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #12: [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] #13: [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] #14: [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL [Opus]
- [ ] #15: [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations [Opus]
- [ ] #16: [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] #17: [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] #18: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter (Conv 177 re-test: still broken in 6.3.7)
- [ ] #19: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #20: [MPV] Add "open Figma SVG first" + qlmanage SVG→PNG step to pre-plan scaffolding
- [ ] #21: [ASF] Investigate Astro.slots.has + && short-circuit doesn't restore child slot fallback
- [ ] #22: [MATT-COURSE-POLISH] Body section visual polish on /matt/course/[slug]
- [ ] #23: [MATT-ICON-SWAP] Hero overlay inline-SVG icons → icon-system in Phase 6
- [ ] #24: [MATT-CREATOR-TAB] /matt/course/[slug]/creator route — Phase 5
- [ ] #25: [TWLG-MIN-H] Tailwind 4 arbitrary-value min-h-[480px] didn't take effect
- [ ] #27: [NOTE-YELLOW] Add --note-yellow token to tokens-primitives.css
- [ ] #28: [CASCADE-BROKEN] `.entity-*` multi-mode cascade not propagating through Tailwind `bg-entity-background` [Opus]
- [ ] #29: [TDS-DRIFT] tech-doc-sweep returned "no recent changes" despite matt/* additions
- [ ] #30: [INV-PATH-FIX] Sweep `.scratch/matt-figma/` references → correct to `.scratch/matt-main/`
- [ ] #31: [MEM-CAP] Schedule `/r-prune-claude` pass
- [ ] #32: [MATT-RT-DOC] Triage /matt/* route documentation in url-routing.md
- [ ] #33: [MEM-IDX-SLOT] Add MEMORY.md index entry for `reference_astro_slot_forwarding.md`

## Key Context

- **Branch `jfg-dev-13-matt`** holds all Matt design work + the [NPM-UP] + [DSSR-SCOPE] resolution. Conv 177's commit (created in Step 6 of /r-end) bundles the 4 package upgrades, the astro.config.mjs Vite fix, 4 small source-file fixes (HeaderBar/CourseHeader/Sidebar/api-test-helper), and the ToDoItem hybrid rewrite. Docs commit has PLAN.md + DEVELOPMENT-GUIDE.md updates.

- **astro.config.mjs Vite block** now has the cold-start fix:
  ```js
  optimizeDeps: {
    entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro'],
    include: ['astro/virtual-modules/transitions.js'],
  },
  ```
  If new Astro features get added (e.g., new virtual modules), watch dev log for `✨ new dependencies optimized: <name>` after a cold start — any new name needs to be added to `optimizeDeps.include`.

- **Stateless-primitives discipline retired.** matt/* primitives can use hooks freely now. ToDoItem.tsx is the canonical example of the controlled-or-uncontrolled hybrid pattern.

- **Production build clean** in 7.27s with all 13 primitive markers rendering in preview. Cold-start crash does NOT affect production — it's a Vite dev-mode artifact.

- **All 8 /w-codecheck gates PASS.** tsc clean, eslint clean, astro check 0/0/0, Tailwind v4-clean, datetime/setError/locals.runtime/deleted_at all clean.

- **[AAP] re-tested in Conv 177** against Astro 6.3.7 — still broken upstream. Verification probe: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` returns absolute filesystem path. Re-run after every Astro upgrade.

- **8 tasks tagged [Opus] this conv** for next-time judgment (see TodoWrite Items list).

- **`@astrojs/cloudflare@13.5.4` now depends on `@cloudflare/vite-plugin` directly** (didn't before). Our case is now structurally identical to the cloudflare/workers-sdk #11825 setup. Worth knowing when searching for Astro+Cloudflare SSR issues.

- **Diagnostic pattern for SSR hook crashes** (Learning #1): does it persist on 2nd request? If yes → duplicate React copies (#11825 class, fix via dedupe). If no → cold-start race (our class, fix via optimizeDeps.entries+include).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
