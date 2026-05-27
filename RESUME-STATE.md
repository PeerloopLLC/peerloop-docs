# State — Conv 202 (2026-05-26 ~21:31)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 202 stood up a **pre-flip git-worktree reference environment** (`~/projects/Peerloop-preflip`, commit `608346a2` = `846bab9f^`, before ROUTE-FLIP) serving the legacy app at root + Matt's `/matt` WIP on **:4331** — and on that basis **retired** the three proposed `/old` deep-link fixes (the live branch stays honest: deep `/old` links 404 by design, the RTMIG verification signal). Toured the legacy app logged-in via /chrome, aliased the env (`peerloop-ref`), added it to the VS Code workspace, and wrote a committed bootstrap script for M4Pro reproduction. Then attempted to start RTMIG-4, discovered the scope (~90 `/old` pages, only 9 Matt-designed and already at root), and **deferred RTMIG-4 for rescoping** next conv.

## Completed

- [x] Pre-flip reference worktree on :4331 (worktree + npm install + D1 seed + dev server)
- [x] Logged-in browser tour of legacy app (Dashboard/Discover/Course/Messages/Learning/Admin)
- [x] `peerloop-ref` alias added to `~/.zshrc`
- [x] `peerloop.code-workspace` — added named folder `Peerloop-preflip (:4331 ref)`
- [x] `scripts/setup-preflip-ref.sh` — idempotent M4Pro bootstrap (committed this conv)
- [x] `memory/project_preflip_worktree_reference.md` + MEMORY.md index line
- [x] RTMIG-4 gap analysis (~90 /old pages missing at root; 9 Matt-designed already at root)
- [x] docs agent closed SCRIPTS.md gap (25/25 scripts documented)

## Remaining

**Route migration (next major work — RESCOPE FIRST):**
- [ ] [RTMIG-4] [Opus] **RESCOPE NEEDED** — decompose the 90-page /old→root migration AND resolve the methodology fork before any code: A) port legacy body INTO Matt shell (consistent nav, some rework discarded on later redesign) [CC recommended]; B) port legacy as-is with legacy shell (two navbars at root, least throwaway); C) migrate only the 9 Matt-designed, defer rest. Reference env :4331. Per-page loop: build in Matt shell → update middleware PROTECTED_PREFIXES + hrefs → repoint e2e → browser-verify vs :4331 → retire /old copy.
- [ ] [E2E-MIG] Re-point e2e to new routes incrementally as /old converts (+ Phase-1 login/home smoke)
- [ ] [E2E-GATE] [Opus] Structural-change tier + goto-target resolver check — prototype `.scratch/e2e-route-map.mjs`
- [ ] [PREFLIP-WT] Remove pre-flip reference worktree when RTMIG-4 inspection done (kill :4331, `git -C ~/projects/Peerloop worktree remove ~/projects/Peerloop-preflip`)

**Matt design-system build (Opus):**
- [ ] [DISC-UNIFY] [Opus] Migrate /discover/courses onto fetchCourseBrowseData (+primary_topic_id)
- [ ] [MATT-EXEC-PG2] [Opus] Enroll/Session families
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6 extrapolation primitives + live-hero→MattIcon residual
- [ ] [RTB] [Opus] Role Tab Bar design — greenfield (not yet drawn by Matt)
- [ ] [ADMIN-REDIRECT-BLANK] [Opus] non-admin /admin/* blank-200 instead of 302
- [ ] [MMP-PH5] Roll-forward 11 Phase-5 pages
- [ ] [MATT-EXEC-GRD] Graduation
- [ ] [MMP-PH3] Verify status
- [ ] [SHOWMORE] Show-more behavior
- [ ] [CH-VARIANTS] Card/component variants
- [ ] [ICN-NS] [Opus] Legacy→MattIcon convergence — 204 non-/old files
- [ ] [HOWTOREG-ICN] Harvest how_to_reg — BLOCKED (not in live Components file)

**Infra / tooling / watches:**
- [ ] [ASSET-SWEEP-GATE]/[FIGMA-MCP-DOC-HARVEST] gate the deferred PROV-MATCH automation
- [ ] [MFRD-LOOKUP] permanent Ready-for-Dev drift lookup maintenance
- [ ] [ESOT-STRUCTURE] external source-of-truth structure
- [ ] [BROWSER-FALLBACK] document Playwright chromium fallback when Chrome MCP disconnects
- [ ] [TXTBTN] watch for inline text-styled action button across Phase 5 routes
- [ ] [MEM-CAP-WATCH] MEMORY.md at byte cap (~82%) — prune or offload before truncation
- [ ] [DTUNE-WATCH] validate /r-end docs-agent produces fewer doc tasks — Conv 202 data point: 1 edit (SCRIPTS.md gap close), justified

## TodoWrite Items

- [ ] #1 [RTMIG-4] [Opus] / #2 [E2E-MIG] / #3 [E2E-GATE] [Opus] / #23 [PREFLIP-WT]
- [ ] #4 [DISC-UNIFY] [Opus] / #5 [MATT-EXEC-PG2] [Opus] / #6 [MATT-EXEC-EXT] [Opus] / #7 [RTB] [Opus] / #8 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #9 [MMP-PH5] / #10 [MATT-EXEC-GRD] / #11 [MMP-PH3] / #12 [SHOWMORE] / #13 [CH-VARIANTS]
- [ ] #14 [ICN-NS] [Opus] / #15 [HOWTOREG-ICN]
- [ ] #16 [ASSET-SWEEP-GATE]/[FIGMA-MCP-DOC-HARVEST] / #17 [MFRD-LOOKUP] / #18 [ESOT-STRUCTURE] / #19 [BROWSER-FALLBACK] / #20 [TXTBTN] / #21 [MEM-CAP-WATCH] / #22 [DTUNE-WATCH]

## Key Context

- **RTMIG-4 must be rescoped before any code.** ~90 /old pages have no root equivalent; Matt designed only 9 (already at root via ROUTE-FLIP). So RTMIG-4 = routing migration of LEGACY pages, NOT build-to-Matt-design. The unresolved fork (which shell legacy bodies land in: A/B/C above) governs all ~90 conversions.
- **Reference environment (NEW, durable):** `peerloop-ref` alias → worktree `~/projects/Peerloop-preflip` (commit `608346a2`) on :4331. Legacy app at root, Matt WIP at /matt. Machine-LOCAL (M4 only); recreate on M4Pro via `bash ~/projects/Peerloop/scripts/setup-preflip-ref.sh`. Login modal, admin `brian@peerloop.com` / `Peerloop2`. Full details in `memory/project_preflip_worktree_reference.md`.
- **Deep-link fix RETIRED:** no client-side rewrite / basePath prop / middleware fallback. Live-branch `/old` deep links 404 by design — keep them honest.
- **Two dev servers may be running:** :4321 (live branch, this conv left it up) + :4331 (worktree reference). /chrome bridge drives either by port.
- **M4Pro propagation:** workspace change travels via git (pull); worktree + alias recreated by the bootstrap script. All committed this conv.
- **Baseline:** NOT verified this conv (no app code changed — only a bootstrap script + docs/workspace). Treat any prior baseline as hypothesis per CLAUDE.md.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
