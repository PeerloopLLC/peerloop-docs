# State — Conv 203 (2026-05-27 ~09:01)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 203 resolved the **RTMIG-4 methodology fork = approach A** (port legacy `/old`
bodies into the Matt `AppLayout` shell) and executed the first pilot: **recreated
Home (`/`) from the legacy `/old` dashboard** in Matt style. Built the Home-slice
of MATT-EXEC-EXT (EmptyState + ActionCard primitives, harvested `clock` icon,
restyled OnboardingNudgeBanner). Hardened route honesty — deleted 6 placeholder
pages so their links 404 by design, archived the primitives showcase to
`/dev/primitives` (+ `/dev/saved`, `/dev/todo` sandbox), trimmed the Sidebar. Marked
7 legacy-rehost pages with a new transient `@stand-in` provenance comment. Fixed a
latent prov-sweep bug. All gates green; Home browser-verified.

## Completed

- [x] RTMIG-4 fork resolved = A; Home recreated from /old (RTMIG-4 pilot)
- [x] MATT-EXEC-EXT Home slice: EmptyState + ActionCard primitives (unmarked=ours, in prov-candidates PHASE6); clock icon harvested; OnboardingNudgeBanner restyled to Matt
- [x] Archived showcase → /dev/primitives; built /dev/saved + /dev/todo; trimmed dev subnav to Overview/Saved/To-Do
- [x] Deleted 6 placeholder routes (saved, todo, teachers, earnings, notifications, messages) → links 404 by design
- [x] Removed Peer Teachers + Earnings from Sidebar
- [x] @stand-in marker on 7 pages (login, signup, onboarding, profile, courses, course/[slug]/[...tab], teachers/[handle])
- [x] Fixed prov-sweep 4c bug (untracked-note check now unions PHASE6 candidates)
- [x] Saved memory project_route_404_honesty_standin.md
- [x] Regenerated route docs (route-api-map.md, page-connections.md, route-map.generated.ts); url-routing.md reconciled by docs agent

## Remaining

**DO FIRST / DO SECOND next conv (user ordering directive):**
- [ ] [PREFLIP-M4PRO] Retrofit MacMiniM4Pro with the pre-flip reference worktree + `peerloop-ref` alias — run `bash ~/projects/Peerloop/scripts/setup-preflip-ref.sh` on M4Pro (worktree @608346a2 + .dev.vars + .env symlink + npm install + db:setup:local:dev + :4331 dev + append alias). Machine-local; makes the :4331 reference env reproducible on M4Pro.
- [ ] [STANDIN-MATT] [Opus] Retrofit all @stand-in pages into proper Matt-style designs — RTMIG-4 approach A applied to the 7 stand-in pages. Per page: design+build in Matt style → REMOVE @stand-in marker → set correct provenance (register new primitives in prov-candidates). `grep -rl '@stand-in' src/pages` = remaining counter. NOTE: this is RTMIG-4-in-action on this batch, not a separate effort.

**Route migration (ongoing):**
- [ ] [RTMIG-4] [Opus] Migrate ~89 remaining /old pages → root via approach A (per-page loop: Matt shell → middleware PROTECTED_PREFIXES + hrefs → repoint e2e → browser-verify vs :4331 → retire /old)
- [ ] [E2E-MIG] Re-point e2e to new routes incrementally as /old converts
- [ ] [E2E-GATE] [Opus] Structural-change tier + goto-target resolver — prototype `.scratch/e2e-route-map.mjs`
- [ ] [PREFLIP-WT] Remove pre-flip reference worktree when RTMIG-4 inspection done

**Matt design-system build (Opus):**
- [ ] [DISC-UNIFY] [Opus] Migrate /discover/courses onto fetchCourseBrowseData
- [ ] [MATT-EXEC-PG2] [Opus] Enroll/Session families
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6 extrapolation — remaining primitives (form inputs, skeleton, modal, status pill) + live-hero→MattIcon (Home slice done Conv 203)
- [ ] [RTB] [Opus] Role Tab Bar design — greenfield
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
- [ ] [MEM-CAP-WATCH] MEMORY.md near byte cap (~84%) — prune or offload before truncation
- [ ] [DTUNE-WATCH] validate /r-end docs-agent produces fewer doc tasks (Conv 203: docs agent touched 4 route docs — justified, they were stale from the mid-conv commit)

## TodoWrite Items

- [ ] #24 [PREFLIP-M4PRO] / #25 [STANDIN-MATT] [Opus] — DO FIRST / SECOND
- [ ] #1 [RTMIG-4] [Opus] / #2 [E2E-MIG] / #3 [E2E-GATE] [Opus] / #4 [PREFLIP-WT]
- [ ] #5 [DISC-UNIFY] [Opus] / #6 [MATT-EXEC-PG2] [Opus] / #7 [MATT-EXEC-EXT] [Opus] / #8 [RTB] [Opus] / #9 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #10 [MMP-PH5] / #11 [MATT-EXEC-GRD] / #12 [MMP-PH3] / #13 [SHOWMORE] / #14 [CH-VARIANTS] / #15 [ICN-NS] [Opus] / #16 [HOWTOREG-ICN]
- [ ] #17 [ASSET-SWEEP-GATE] / #18 [MFRD-LOOKUP] / #19 [ESOT-STRUCTURE] / #20 [BROWSER-FALLBACK] / #21 [TXTBTN] / #22 [MEM-CAP-WATCH] / #23 [DTUNE-WATCH]

## Key Context

- **RTMIG-4 fork = A (settled Conv 203).** Legacy `/old` bodies → Matt `AppLayout` shell, rebuilt with Matt primitives + extrapolations. Home was the pilot. [STANDIN-MATT] is the same loop applied to the 7 @stand-in pages.
- **@stand-in marker:** transient header comment on legacy-rehost pages (not Matt, not ours-extrapolation) until properly redesigned. NOT formalized in matt-provenance.md/prov-sweep (transient by design; avoids "UNMARKED" string). `grep -rl '@stand-in' src/pages` enumerates them (7 currently). See memory/project_route_404_honesty_standin.md.
- **404-honesty rule:** unconverted pages must 404 — no resolving placeholder stubs. Dangling chrome links (ControlBar + page subnavs → deleted routes) are accepted; rebuilt when nav chrome's turn comes.
- **New primitives:** `EmptyState.astro`, `ActionCard.astro` (both ui/, unmarked=ours, registered in scripts/prov-candidates.ts PHASE6_EXTRAPOLATION_CANDIDATES). `clock.svg` (icon-provenance source: ours).
- **Baseline:** tsc / astro check / prov:sweep all green this conv; route map regenerated (109 routes). Full lint/test/build NOT run (no runtime-logic changes beyond additive primitives + page rebuild). Treat as hypothesis per CLAUDE.md.
- **Reference env:** `:4331` worktree may still be running (machine-local M4). [PREFLIP-WT] tears it down when RTMIG-4 inspection done.
- **Batch-concerns ledger:** `.scratch/conv-203-batch-concerns.md` — all items dispositioned.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
