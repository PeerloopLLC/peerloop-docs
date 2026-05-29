# State — Conv 217 (2026-05-29 ~14:37)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Completed `[PRIM-REGISTRY]` W3 `[PRIM-STAMP]`: stamped a 3-value `data-prov` runtime
provenance attribute on all **59** vetted primitives' outermost rendered element (35
matt-sourced + 24 matt-inspired), retired the unreferenced `data-matt` precursor
entirely (user decision B), wired the §12c conformity gate (registry⟺marker⟺stamp)
into `npm run prov:sweep`, and built a new DOM page-conformity report
`npm run prov:page-report`. All five gates green (tsc 0 · astro check 1293 0/0/0 ·
lint · test 6456/6456 · build) + prov-sweep consistent + tailwind. The only PRIM-REGISTRY
work left is W4 `[PROFILE-PRIM-SWEEP]` (#22). Conv ended cleanly after cleanup
(dev server killed, /tmp scratch removed).

## Completed

- [x] [PRIM-STAMP] (#21) — stamped all 59 primitives; §12c gate in prov:sweep; new prov:page-report; edge cases resolved (conditional branches, UserIcon roleDot wrapper, Input override forwarding for PasswordInput/SearchInput, _SocialPostDemo wrapped); matt-provenance.md §12 + PLAN.md updated; all gates green
- [x] Retired `data-matt` entirely (decision B) — kept the distinct `data-matt-preview` in the dev showcase

## Remaining

- [ ] [PROFILE-PRIM-SWEEP] (#22) — W4: re-skin the 5 `/profile/*` legacy settings islands (105 legacy-token usages, 0 Matt) to vetted primitives, incl. extracting a shared Matt `<Switch>` that ThemeToggle + the island toggles compose; = former [PROF-TAB-REDESIGN]. Run `PROV_COOKIE=<session> npm run prov:page-report /profile …` to generate the worklist [Opus]
- [ ] [PRIM-COURSES-DISMISS] (#23) — /courses raw "Dismiss recommendations" button is an uncovered interactive (not wrapped in a vetted primitive); re-skin to Button or accept + document
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
- [ ] #22: [PROFILE-PRIM-SWEEP] Re-skin /profile/* legacy settings islands to vetted primitives [Opus]
- [ ] #23: [PRIM-COURSES-DISMISS] /courses "Dismiss recommendations" button is unvetted (uncovered interactive)

## Key Context

- **`data-prov` stamp (now live):** 3-value `matt-sourced|matt-inspired|legacy` + `data-prov-name` (+`data-prov-node` for sourced) on each vetted primitive's outermost element. `document.querySelectorAll('[data-prov="legacy"]')` = one-line unvetted-UI query.
- **Two gates:** `npm run prov:sweep` = STATIC registry⟺marker⟺stamp gate (hard fail; bundled in /w-codecheck). `npm run prov:page-report` = DOM report (informational, exits 0; `PROV_BASE`/`PROV_COOKIE` env; per-route sourced/inspired counts + legacy list + uncovered-interactive worklist).
- **Composing-wrapper pattern:** `Input.tsx` accepts an optional `data-prov`/`data-prov-name` override and spreads it onto its root div AFTER its literal default; `PasswordInput`/`SearchInput` pass their own identity so the DOM-root reports the wrapper, not Input. The agents' first attempt put it on the `<Input>` JSX → landed on the inner `<input>` via `{...rest}`, NOT the root (latent DOM bug, fixed).
- **W4 worklist generation:** `/profile/*` is auth-gated → fetch with a session cookie. The 5 legacy islands are NOT yet stamped `legacy` — they'll show in the report as **uncovered interactive** until W4 stamps/re-skins them.
- **Spec:** `docs/as-designed/matt-provenance.md §12` (W3 ✅; §12b "Edge cases resolved at W3" documents all 4 edge-case decisions). Two registries unchanged: `scripts/matt-sourced-registry.generated.ts` (35, `npm run gen:registries`) + `scripts/matt-inspired-registry.ts` (24).
- **No dev server running** (killed at conv end). `cd ../Peerloop && npm run dev` to restart for the report.
- **Conv 203 ordering directive still nominally stands** for RTMIG ([PREFLIP-M4PRO] then [STANDIN-MATT]) though both are now complete; the live RTMIG work is #3 [RTMIG-4].

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
