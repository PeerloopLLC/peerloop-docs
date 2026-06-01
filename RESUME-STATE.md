# State — Conv 230 (2026-06-01 ~09:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Two threads. (1) Conv-lifecycle tooling (pre-`/compact`): added r-end **Step 4d pre-commit checkpoint**, rewrote Step 9 to display-and-stop, added the **Step 2 conv-scoped-note glob**, and built the new **`/r-checkpoint`** skill + `.scratch/README.md` convention. (2) **[HOME-FEEDSHUB] (#28)**: ported the legacy FeedsHub composite to a new Matt `FeedsHubPanel` mounted on `/` (logged-in only, SSR-gated; visitor keeps current behaviour). This conv's `/r-end` was also a deliberate **checkpoint-completeness test** — the ingestion path passed (the pre-compact slice reached the Extract only via `conv-230-checkpoint.md` + the Step 2 glob). At the Step 4d checkpoint, fixed **#33 [ROUTE-AUTH-HEURISTIC]** (route scanner now treats getSession-without-redirect as "Public (adapts)").

## Completed

- [x] #28 [HOME-FEEDSHUB] — FeedsHubPanel mounted on `/` (logged-in), SSR-gated, all 5 gates + prov:sweep green
- [x] #33 [ROUTE-AUTH-HEURISTIC] — route scanner `detectAuth` fix; `/`, `/communities`, `/feeds` reclassified to "Public (adapts)"
- [x] r-end Step 4d checkpoint + Step 9 rewrite + Step 2 scratch-glob (pre-compact)
- [x] New `/r-checkpoint` skill + `.scratch/README.md` convention (pre-compact)

## Remaining

- [ ] [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12
- [ ] [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (Figma 597:6504 / 685:13240)
- [ ] [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] [TXTBTN] Extract TextButton primitive on Rule-of-Three (TopicPicker Select-All = instance 1)
- [ ] [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] [GARBLE-WATCH] Re-test TERM-GARBLE when upstream changelog fixes parallel tool-result delivery
- [ ] [HOME-FEEDSHUB-VIS] Visitor/public variant of FeedsHub on `/` (deferred sub-scope of #28)
- [ ] [REND-DEDUP-GUARD] r-end Step 2 must dedup scratch notes vs un-compacted history (found by this conv's checkpoint test)

## TodoWrite Items

(Same 32 items as Remaining above — all pending tasks from TaskList, codes preserved.)

## Key Context

- **FeedsHubPanel** (`src/components/feed/FeedsHubPanel.tsx`) = standalone Matt port of legacy FeedsHub (no role tabs), mirrors `FeedsDirectory`'s `AllTabContent` WITHOUT shared code (option B). Reuses `FeedDirectoryCard` + `SearchInput`. New @matt-inspired components MUST be added to `scripts/matt-inspired-registry.ts` or prov:sweep errors UNTRACKED.
- **Visitor variant deferred** (#32): FeedsHubPanel returns null logged-out; `/` shows Recent Activity to visitors. SSR gate in `index.astro` via `getSession`.
- **Route auth heuristic** (`scripts/route-matrix.mjs` `detectAuth`): getSession + no `Astro.redirect` ⇒ "Public (adapts)". Route-doc regen writes BOTH repos (`route-matrix.mjs` + `route-api-map.mjs`).
- **#34 [REND-DEDUP-GUARD]**: r-end Step 2 folds scratch notes "alongside" the live-history scan with no dedup rule → checkpoints written after the last `/compact` could double in the Extract. Only didn't this conv because the collector merged by hand. Fix Step 2 action 3 wording.
- Changes are committed in Step 6 of this conv's r-end (pre-commit state).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
