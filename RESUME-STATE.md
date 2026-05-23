# State — Conv 176 (2026-05-22 ~20:58)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 176 advanced MATT-DESIGN-PUSH through **Phase 4 scope B [MATT-EXEC-PRM-2]**: 5 new primitives (RoleTabBar / Module / Note / SocialPost / ToDoItem) plus one internal showcase wrapper (_SocialPostDemo.tsx), all wired into `/matt/index.astro` and rendering correctly with Matt token colors. Three substantive architectural findings surfaced + got tracked: (1) [DEV-STAGING-SSR] broader scope than PLAN documented — any stateful React component crashes the full page body, not just the failed island; (2) Astro `.astro` expression-block parser doesn't accept inline HTML JSX — only Component references; (3) Matt's `.entity-*` cascade doesn't propagate through Tailwind `bg-entity-background` despite logically correct CSS chain. End-of-conv web research identified the canonical workaround for (1) (`resolve.dedupe` + `ssr.noExternal` for React) and a plausible reason Conv 122's earlier attempt failed (@astrojs/cloudflare 13.5.4 added optimizeDeps-forwarding to SSR env). Lead task for next conv is **[NPM-UP] Upgrade Astro stack + retry React-SSR workaround**.

## Completed

- [x] [MATT-EXEC-PRM-2] Phase 4 scope B primitives — 5 primitive files + 1 internal demo wrapper, showcase wired into /matt/index.astro, all rendering correctly with Matt token colors, tsc + astro check clean
- [x] [MATT-MCP-RETRY] put on hold (user-driven; external Figma seat blocker)

## Remaining

🔝 **Lead next-conv task:**

- [ ] **[NPM-UP] [Opus]** Upgrade Astro stack (`astro` 6.1.5 → 6.3.7, `@astrojs/cloudflare` 13.1.8 → 13.5.4, `@astrojs/react` 5.0.3 → 5.0.5) THEN apply `resolve.dedupe: ["react","react-dom"]` + `ssr.noExternal: ["react","react-dom"]` Vite config workaround THEN verify by reverting ToDoItem to its hybrid form (with `useState`) and confirming SSR doesn't crash. If workaround works, relax stateless-primitives discipline; if it fails, file a minimal repro under Astro #16529. Also reassess [TWLG-MIN-H] + [AAP] against Astro 6.3.7.

**MATT-DESIGN-PUSH Phase 5 onward:**

- [ ] **[MATT-EXEC-PG2] [Opus]** Phase 5: remaining 12 /matt/* routes
- [ ] **[MATT-EXEC-FLAGS]** Verify 4 route-shape assumptions against codebase before Phase 5
- [ ] **[MATT-EXEC-EXT] [Opus]** Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill)
- [ ] **[MATT-EXEC-GRD]** Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] **[MATT-COURSE-POLISH]** Body section visual polish on /matt/course/[slug]
- [ ] **[MATT-CREATOR-TAB]** /matt/course/[slug]/creator route (Phase 5 sub-task)
- [ ] **[MATT-ICON-SWAP]** Hero overlay inline-SVG icons should swap to proper icon-system in Phase 6
- [ ] **[MATT-INVENTORY-CLEANUP]** Triage `.scratch/matt-figma/` (actual dir is `.scratch/matt-main/`)
- [ ] **[MATT-MCP-RETRY]** ⏸️ ON HOLD — Figma MCP setup blocked externally
- [ ] **[MATT-RT-DOC]** Triage /matt/* route documentation in url-routing.md (defer until graduation OR add scaffold section now)

**Conv 176 architectural findings (deferred):**

- [ ] **[DSSR-SCOPE]** Update PLAN.md DEV-STAGING-SSR entry — affects plain dev mode on M4 too, symptom is page-body cutoff not graceful fallback. Becomes obsolete if [NPM-UP] resolves the underlying bug.
- [ ] **[CASCADE-BROKEN] [Opus]** `.entity-*` multi-mode cascade not propagating through Tailwind `bg-entity-background` — pattern doc misleading
- [ ] **[NOTE-YELLOW]** Add `--note-yellow` token to tokens-primitives.css (currently arbitrary `#FFF1B8` in Note.tsx)

**Tokens / infra:**

- [ ] **[TSV] [Opus]** Token Scaffolding Verification — includes investigating Tailwind 4 `min-h-[NN]px` arbitrary-value silent failure
- [ ] **[TWLG-MIN-H]** Tailwind 4 arbitrary-value `min-h-[480px]` didn't take effect — may resolve via Astro 6.3.7
- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in ClientRouter — may resolve via Astro 6.3.7
- [ ] **[ASF]** Investigate Astro.slots.has + && short-circuit not restoring child slot fallback
- [ ] **[MPV]** Add "open Figma SVG first" + qlmanage SVG→PNG step to pre-plan scaffolding for matt/* page builds
- [ ] **[RTB]** Finalize Role Tab Bar design-spec doc (component shipped Conv 176)
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings
- [ ] **[MND2]** detect-machine.sh still returns "Unknown" on M4Pro despite Conv 168 fix
- [ ] **[TDS-DRIFT]** Investigate why tech-doc-sweep returned "no recent changes" despite matt/* additions Conv 176
- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references across PLAN + tasks → correct to `.scratch/matt-main/`
- [ ] **[MEM-CAP]** Schedule `/r-prune-claude` pass within next 5–10 convs (currently 59% / 57% of caps)
- [ ] **[MEM-IDX-SLOT]** Add MEMORY.md index entry for `reference_astro_slot_forwarding.md`

**BBB / Production:**

- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min empty-but-published recording state
- [ ] **[BR-STATUS] [Opus]** Add sessions.recording_status enum column
- [ ] **[DB-SYNC-04] [Opus]** Apply 0004_feed_activity_index.sql to prod D1
- [ ] **[DB-SYNC-03]** Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] **[DB-SYNC-02-RENAME]** Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] **[PROD-PW-APPLY] [Opus]** Execute deferred Peerloop2 rotation against prod admin
- [ ] **[DB-SYNC-VERIFY]** Final prod D1 convergence check

## TodoWrite Items

- [ ] #1: [MATT-EXEC-PG2] Phase 5: remaining 12 /matt/* routes [Opus]
- [ ] #2: [MATT-EXEC-EXT] Phase 6: extrapolation primitives (form inputs, skeleton, modal, status pill) [Opus]
- [ ] #3: [MATT-EXEC-GRD] Phase 7: doc graduation (flip 🚧 banner; archive matt-pre-plan.md)
- [ ] #4: [MATT-EXEC-FLAGS] Verify 4 route-shape assumptions against codebase before Phase 5
- [ ] #5: [MATT-MCP-RETRY] ⏸️ ON HOLD — Figma MCP setup blocked externally; proceeding without it
- [ ] #6: [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder (actual dir is `.scratch/matt-main/`)
- [ ] #7: [RTB] Design Role Tab Bar — finalize design-spec doc (component shipped Conv 176)
- [ ] #8: [TSV] Token Scaffolding Verification [Opus]
- [ ] #9: [MND2] detect-machine.sh still returns "Unknown" on M4Pro despite Conv 168 fix
- [ ] #10: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #11: [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] #12: [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] #13: [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] #14: [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] #15: [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] #16: [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] #17: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #18: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #19: [MPV] Add "open Figma SVG first" step to pre-plan scaffolding for matt/* page builds
- [ ] #20: [ASF] Investigate why Astro.slots.has + && short-circuit doesn't restore child slot fallback
- [ ] #22: [MATT-COURSE-POLISH] Body section visual polish
- [ ] #23: [MATT-ICON-SWAP] Hero overlay inline-SVG icons should swap to proper icon-system in Phase 6
- [ ] #24: [MATT-CREATOR-TAB] /matt/course/[slug]/creator route — Phase 5
- [ ] #25: [TWLG-MIN-H] Tailwind 4 arbitrary-value min-h-[480px] didn't take effect
- [ ] #26: [DSSR-SCOPE] DEV-STAGING-SSR also affects plain `npm run dev` on M4 — update PLAN.md note
- [ ] #27: [NOTE-YELLOW] Add --note-yellow token to tokens-primitives.css [TSV]
- [ ] #28: [CASCADE-BROKEN] `.entity-*` multi-mode cascade not propagating through Tailwind `bg-entity-background` [Opus]
- [ ] #29: [NPM-UP] 🔝 NEXT CONV — Upgrade Astro stack + retry React-SSR workaround for [DSSR-SCOPE] [Opus]
- [ ] #30: [TDS-DRIFT] tech-doc-sweep returned "no recent changes" despite matt/* additions
- [ ] #31: [INV-PATH-FIX] Sweep `.scratch/matt-figma/` references → correct to `.scratch/matt-main/`
- [ ] #32: [MEM-CAP] Schedule `/r-prune-claude` pass
- [ ] #33: [MATT-RT-DOC] Triage `/matt/*` route documentation in url-routing.md
- [ ] #34: [MEM-IDX-SLOT] Add MEMORY.md index entry for `reference_astro_slot_forwarding.md`

## Key Context

- **Branch `jfg-dev-13-matt`** still holds all Matt design work. Conv 176's commit will be the latest. Existing course page (`/matt/course/intro-to-claude-code`) still works; Conv 175's [MATT-COURSE-POLISH] task is still open.

- **5 new primitive files** at `~/projects/Peerloop/src/components/matt/ui/`: `Module.tsx`, `Note.tsx`, `SocialPost.tsx`, `ToDoItem.tsx`, plus `_SocialPostDemo.tsx` (internal showcase wrapper for the Course embed). Plus `~/projects/Peerloop/src/components/matt/RoleTabBar.tsx` (one level up because it's a Peerloop extension, not a Matt primitive).

- **Stateless matt/* primitive discipline:** until [NPM-UP] verifies the upstream workaround, NO `useState`/`useEffect` in matt/* primitives. Parent owns state; primitives are fully controlled. Internal demo wrappers (`_*.tsx`) can use hooks since they're mounted in isolation.

- **Direct entity utilities pattern:** matt/* primitives use direct `bg-{student,course,creator}-background` keyed by the `entity` prop — NOT the `.entity-*` cascade. Matches `Button.tsx`. Tracked as [CASCADE-BROKEN] task #28 for eventual root-cause and decision (fix cascade vs. retire pattern in doc).

- **qlmanage SVG→PNG workflow:** `qlmanage -t -s 1200 -o /tmp file.svg` produces a Read-tool-viewable PNG. Used Conv 176 to inspect Matt's Figma SVGs visually. Should be folded into the [MPV] workflow doc.

- **Symlinks at `public/_matt-ref/`** for the [MPV] workflow: `Module.svg`, `Note.svg`, `SocialPost.svg`, `ToDoItem.svg` link into `~/projects/peerloop-docs/.scratch/matt-main/components/*.svg`. Add to .gitignore if not already; otherwise the commit will track the symlinks (they're useful, so leaving them tracked is OK).

- **Astro `.astro` expression-block parser constraint:** `{<Comp />}` works, `{<div className="…" />}` does NOT. Component references only. Documented Astro design, not a bug. Workaround: extract rich JSX into `_Demo.tsx` files and mount them as single component references. Now documented in `docs/reference/DEVELOPMENT-GUIDE.md` (Astro Patterns section, added Conv 176).

- **[NPM-UP] (next conv) — full procedure:** see task #29 description. Sequence is critical: (1) upgrade three packages, (2) apply Vite dedupe+noExternal workaround, (3) verify by re-introducing useState to ToDoItem and confirming SSR doesn't crash. Conv 122 attempted (2) without (1), which is why it failed.

- **Dev server:** stopped at end of Conv 176. Restart via `cd ~/projects/Peerloop && npm run dev`. Should still be at HTTP 200 on /matt/ with all 5 primitives rendering.

- **Web research sources** (full citations in Conv 176 transcript): Cloudflare workers-sdk #11825 (closed-with-workaround Jan 2026), Astro #16529 (open), @astrojs/cloudflare CHANGELOG entries for 13.2.0–13.5.4 (13.5.4 added optimizeDeps forwarding to SSR env — the likely missing piece).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
