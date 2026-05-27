# State — Conv 201 (2026-05-26 ~20:32)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 201 spawned the **ROUTE-MIGRATION** block. Triggered by a user question about whether `/old` flows are E2E-tested, the conv uncovered that Conv 197's ROUTE-FLIP left routing infra (middleware, redirect targets, ~30 hrefs, the auth-modal host) pointing at pre-relocation root paths — breaking auth app-wide. Per the user's forward-migration strategy, built and **browser-verified Phases 1–3 + signup**: login/logout/signup/home/onboarding wired to root, `/earnings`+`/profile` stubbed, zero 404s across the nav. All bugs fixed were string-valued route refs invisible to `tsc`. Remaining is `[RTMIG-4]` (per-page `/old`→root conversion) + the E2E gate work.

## Completed

- [x] [RTMIG-1] Wire login/logout/signup + home at root — browser-verified
- [x] [RTMIG-2] Stub /earnings + /profile main-nav routes — browser-verified
- [x] [RTMIG-3] Verify minimal app works (zero 404s, full auth loop + returnUrl)
- [x] [RTMIG-LOGOUT] Logout button wired into /profile — verified
- [x] [RTMIG-SIGNUP] Promote /onboarding to root; signup happy-path verified
- [x] Code committed 6ae1085d + 912b75ab; docs a6be4e5 + 2c2ec76; ROUTE-MIGRATION block in PLAN.md; docs agent synced url-routing.md §8 + auth-sessions.md + regenerated route docs

## Remaining

**Route migration (next major work):**
- [ ] [RTMIG-4] Convert /old/* pages → new routes one at a time [Opus] — the large ongoing phase (course/discover/teaching/creating/admin/community/settings/session families); each conversion also updates middleware PROTECTED_PREFIXES, hrefs, repoints the e2e spec, retires the /old version; `/profile`→/@me once /@handle routes migrate
- [ ] [E2E-MIG] Re-point e2e to new routes incrementally as /old converts (+ Phase-1 login/home smoke)
- [ ] [E2E-GATE] Structural-change tier + goto-target resolver check [Opus] — prototype at `.scratch/e2e-route-map.mjs`

**Matt design-system build (Opus):**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (+primary_topic_id) [Opus]
- [ ] [MATT-EXEC-PG2] Enroll/Session families [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 extrapolation primitives + live-hero→MattIcon residual [Opus]
- [ ] [RTB] Role Tab Bar design [Opus] — greenfield (not yet drawn by Matt)
- [ ] [ADMIN-REDIRECT-BLANK] non-admin /admin/* blank-200 instead of 302 [Opus]
- [ ] [MMP-PH5] Roll-forward 11 Phase-5 pages
- [ ] [MATT-EXEC-GRD] Graduation
- [ ] [MMP-PH3] Verify status
- [ ] [SHOWMORE] Show-more behavior
- [ ] [CH-VARIANTS] Card/component variants
- [ ] [ICN-NS] Legacy→MattIcon convergence — 204 non-/old files [Opus]
- [ ] [HOWTOREG-ICN] Harvest how_to_reg — BLOCKED (not in live Components file)

**Infra / tooling / watches:**
- [ ] [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] gate the deferred PROV-MATCH automation
- [ ] [MFRD-LOOKUP] permanent Ready-for-Dev drift lookup maintenance
- [ ] [ESOT-STRUCTURE] external source-of-truth structure
- [ ] [BROWSER-FALLBACK] document Playwright chromium fallback when Chrome MCP disconnects
- [ ] [TXTBTN] watch for inline text-styled action button across Phase 5 routes
- [ ] [MEM-CAP-WATCH] MEMORY.md at byte cap (81%) — prune or offload before truncation
- [ ] [DTUNE-WATCH] validate /r-end docs-agent produces fewer doc tasks — Conv 201 data point: 4 edits, all justified (no vendor/prose over-maintenance)

## TodoWrite Items

- [ ] #1 [DISC-UNIFY] [Opus] / #2 [MATT-EXEC-PG2] [Opus] / #3 [MATT-EXEC-EXT] [Opus] / #4 [RTB] [Opus] / #5 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #6 [MMP-PH5] / #7 [MATT-EXEC-GRD] / #8 [MMP-PH3] / #9 [SHOWMORE] / #10 [CH-VARIANTS]
- [ ] #11 [ICN-NS] [Opus] / #12 [HOWTOREG-ICN]
- [ ] #13 [ASSET-SWEEP-GATE]/[FIGMA-MCP-DOC-HARVEST] / #14 [MFRD-LOOKUP] / #15 [ESOT-STRUCTURE] / #16 [BROWSER-FALLBACK] / #17 [TXTBTN] / #18 [MEM-CAP-WATCH] / #19 [DTUNE-WATCH]
- [ ] #20 [E2E-MIG] / #21 [E2E-GATE] [Opus] / #25 [RTMIG-4] [Opus]

## Key Context

- **ROUTE-MIGRATION is the new active thread.** /old = conversion source (being dismantled), root = the app being built. NO redirect layer (user's explicit choice) — unbuilt root routes 404 by design.
- **The recurring bug class:** ROUTE-FLIP moved pages but left route *references* (middleware prefixes, redirect literals `/dashboard`/`/login`/`/onboarding`, ~30 component hrefs, the AuthModalRenderer mount in legacy AppNavbar) pointing at old paths. All invisible to tsc/astro check — only browser/runtime catches them. Expect more of this class during RTMIG-4.
- **New shell vs legacy:** root uses `AppLayout.astro` + `Sidebar` (`src/components/Sidebar.tsx`); /old uses `layouts/old/AppLayout.astro` + `AppNavbar`. The new shell does NOT carry AppNavbar's global concerns — this conv re-homed AuthModalRenderer into AppLayout; logout went onto /profile.
- **Verification mandate:** this whole conv reaffirmed that tsc-green ≠ working for route changes. `[E2E-GATE]` (prototype `.scratch/e2e-route-map.mjs` classifies every e2e goto target vs the route tree) is the durable fix; `[E2E-MIG]` repoints specs as pages convert.
- **Dev server** left running on :4321 (logged out). **Test account** rtmig201@example.com in local D1 (throwaway).
- **Baseline this conv:** astro check (1276 files) + tsc both 0 errors after all edits; full vitest suite NOT re-run (no test files changed). Treat as hypothesis per CLAUDE.md.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
