# State — Conv 216 (2026-05-29 ~13:12)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built the overlay-free `/visitor` account surface + a shared `<ThemeToggle>` (reachable logged-out and logged-in, no popover — client rejected the legacy slide-out submenu), then opened the `[PRIM-REGISTRY]` initiative: two vetted-primitive registries (Matt-sourced generated from `@matt-source` markers = 35; Matt-inspired hand-maintained) + a `matt-provenance.md §12` spec for a 3-value `data-prov` runtime conformity stamp. Stamping (W3) and the `/profile` re-skin (W4) are deferred + tracked. All work committed + pushed; everything browser-verified or gate-green.

## Completed

- [x] [VISITOR-SURFACE] `/visitor` page + shared `ThemeToggle` + Sidebar visitor chip `/login`→`/visitor` + `/profile` toggle swap; browser-verified (chip routing, authed bounce, toggle round-trip both pages); committed `be1d4347`/`adcfdd0`
- [x] Latent bug: backfilled `lock.svg` `icon-provenance.ts` entry (Conv-212 miss; Conv-212 "prov-sweep green" was wrong/not-run)
- [x] [PRIM-REGISTRY] W1 — `matt-provenance.md §12` spec (registries + `data-prov` + conformity gate)
- [x] [PRIM-REGISTRY] W2 — `matt-inspired-registry.ts` (renamed from `prov-candidates.ts`; re-export shim) + `matt-sourced-registry.generated.ts` (35, generated) + `gen-registries.ts` + `npm run gen:registries`; committed `4226ba5b`/`e9d25ef`
- [x] Decision: `/profile` stays the permanent private hub; public profile = separate `/@handle` (+`/@me` alias) — dropped the "redirect /profile→/@me" plan note

## Remaining

- [ ] [PRIM-STAMP] (#21) — W3: stamp `data-prov` (matt-sourced/matt-inspired/legacy + name + node) on the ~66 vetted primitives' outermost elements + build the §12c conformity sweep/gate (registry ⟺ marker ⟺ stamp) + DOM page-conformity report [Opus]
- [ ] [PROFILE-PRIM-SWEEP] (#22) — W4: re-skin the 5 `/profile/*` legacy settings islands (105 legacy-token usages, 0 Matt) to vetted primitives, incl. extracting a shared Matt `<Switch>` that ThemeToggle + the island toggles compose; = the former [PROF-TAB-REDESIGN] [Opus]
- [ ] (standing block backlog — see TodoWrite Items below)

## TodoWrite Items

- [ ] #1: [DISC-DROP] Finish discover-page migration Stages 3+4 [Opus]
- [ ] #2: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar slot [Opus]
- [ ] #3: [RTMIG-4] Per-page /old→root conversion via Matt-shell loop [Opus]
- [ ] #4: [E2E-MIG] Re-point e2e to new routes incrementally
- [ ] #5: [E2E-GATE] Structural-change tier + goto-target resolver check [Opus]
- [ ] #6: [PREFLIP-WT] Remove pre-flip reference worktree when RTMIG-4 inspection done
- [ ] #7: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll/Session families + 5 routes) [Opus]
- [ ] #8: [MATT-EXEC-EXT] Phase 6 extrapolation primitives (build lazily per page) [Opus]
- [ ] #9: [RTB] Design the Role Tab Bar component (design-spec doc) [Opus]
- [ ] #10: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* yields blank 200 instead of redirect [Opus]
- [ ] #11: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via MCP (machine-pinned M4) [Opus]
- [ ] #12: [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] #13: [SHOWMORE] Show-More affordance for Teachers + Reviews tabs
- [ ] #14: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (597:6504 / 685:13240)
- [ ] #15: [ICN-NS] 204-file legacy→MattIcon convergence
- [ ] #16: [HOWTOREG-ICN] How-to-register-icon doc
- [ ] #17: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #18: [MFRD-LOOKUP] Matt frames-ready-for-dev lookup
- [ ] #19: [TXTBTN] Watch — TextButton primitive if 3+ inline-text-button instances appear in Phase 5
- [ ] #20: [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro
- [ ] #21: [PRIM-STAMP] Stamp data-prov on ~66 primitives + build conformity sweep/gate [Opus]
- [ ] #22: [PROFILE-PRIM-SWEEP] Re-skin /profile/* legacy settings islands to vetted primitives [Opus]

## Key Context

- **`[PRIM-REGISTRY]` is the new umbrella block** (PLAN.md): W1 spec ✅ + W2 registries ✅ this conv; W3 `[PRIM-STAMP]` (#21) + W4 `[PROFILE-PRIM-SWEEP]` (#22) are the remaining work. Spec is `docs/as-designed/matt-provenance.md §12`.
- **Two registries:** `scripts/matt-sourced-registry.generated.ts` (GENERATED via `npm run gen:registries` = `scripts/gen-registries.ts`; the `@matt-source` markers stay SoT — DON'T hand-edit the generated file) + `scripts/matt-inspired-registry.ts` (hand-maintained SoT; `prov-candidates.ts` is now a thin re-export of it).
- **`data-prov` stamp (W3, not yet applied):** 3-value `matt-sourced|matt-inspired|legacy` + `data-prov-name` (+ `data-prov-node` for sourced) on each primitive's outermost element. `[data-prov="legacy"]` makes unvetted UI a one-line DOM query.
- **All of `/profile/*` is un-swept for primitive conformity** — the 5 embedded settings islands are legacy UI (105 legacy-token usages, 0 Matt). W4 fixes this.
- **`<ThemeToggle>` (`src/components/ui/ThemeToggle.tsx`)** is the shared light/dark switch on `/visitor` + `/profile`; registered in `matt-inspired-registry.ts`. A shared Matt `<Switch>` should be extracted from it + the NotificationSettings private `Toggle` during W4.
- **Open question (offered, user didn't request):** whether to eventually strip the `@matt-source` markers and make the registry the literal SoT. Markers stay SoT for now.
- **Dev server** was left running on :4321 (background). **`/r-start` ordering directive from Conv 203 still stands** for RTMIG: [PREFLIP-M4PRO] then [STANDIN-MATT] — though STANDIN-MATT is now complete and its tab-redesign folded into [PROFILE-PRIM-SWEEP].

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
