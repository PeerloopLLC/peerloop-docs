# State — Conv 224 (2026-05-31 ~13:25)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 224 completed **[DRV-C]** — the `/feeds` root port (DISC-ROLE-VIEWS / DISC-DROP), **Option A**: `/feeds` is now the Matt **discover destination** (discovery grid + role-aware "Your Feeds" directory), a clean sibling of `/communities` + `/members`. Resolved the identity fork: the pre-existing `FeedsHub` *composite* is **NOT** on `/feeds` — per Matt it's destined for the `/` landing page (tracked as new **[HOME-FEEDSHUB]**). Built `feeds.astro` + 4 `@matt-inspired` components (`FeedsDirectory`, `FeedsRoleTabs`, `FeedDirectoryCard`, `FeedsDiscoveryGrid`), repointed the slide panel, made `/feeds` public in middleware. Partial **[DRV-DOC]**: registered the 4 components in `scripts/matt-inspired-registry.ts` + regenerated route docs. 4 gates green (tsc/astro/lint/build); browser-verified. NOTE: severe terminal-render garble this conv faked tool successes — re-verified all writes via clean `git status` before commit.

## Completed

- [x] [DRV-C] /feeds root port (Option A — discover destination, not the composite)
- [x] 4 @matt-inspired components + feeds.astro (single-island design; no cross-island bus)
- [x] DiscoverSlidePanel feeds href /discover/feeds → /feeds
- [x] middleware /feeds made public (removed from PROTECTED_EXACT)
- [x] 4 gates green (tsc/astro/lint/build); bug-class greps clean; browser-verified (logged-in)
- [x] [DRV-DOC partial] registered 4 feeds components in scripts/matt-inspired-registry.ts + route-doc regen (route-api-map.md/.tsv, route-map.generated.ts)
- [x] Corrected project_feeds_hub.md memory; feeds.md /feeds row corrected (docs agent)

## Remaining

- [ ] [DRV-DOC] Phase D remainder — Conv-222 component set registration in matt-inspired-registry.ts; rewrite the DISC-DROP "Tier-1 recipe"; migrate `~/.claude/plans/humble-wondering-turtle.md` → PLAN.md DISC-ROLE-VIEWS block
- [ ] [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page (visitor + personalized-logged-in variants); confirm "/" composition with user/Matt first [Opus]
- [ ] [BAK-ARTIFACT] Track down what creates stray .bak files in the code repo (appeared during garble; gitignore or remove the source)
- [ ] [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference (real scripts: `route-matrix` + `route-api-map`)
- [ ] [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] All other pending blocks below — unchanged this conv (RTMIG-4, MATT-EXEC-*, ICN-NS, PROFILE-PRIM-SWEEP, etc.)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [DISC-DROP] Discover-destination migration umbrella (communities/feeds/members → Matt root)
- [ ] #6: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar [Opus]
- [ ] #7: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #8: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #9: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #10: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #11: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] #12: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #13: [RTB] Author Role Tab Bar design-spec doc [Opus]
- [ ] #14: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] #15: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] #16: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #17: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #18: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (Figma 597:6504 / 685:13240)
- [ ] #19: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #20: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #21: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #22: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #23: [TXTBTN] Extract TextButton primitive on Rule-of-Three (TopicPicker Select-All = instance 1)
- [ ] #24: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #25: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #26: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #27: [TERM-GARBLE] Mitigate recurring CC terminal-render garble (severe this conv — faked tool successes, dropped results)
- [ ] #28: [ROLE-AWARE] Make pages role-aware as the role-aware tab bar rolls out [Opus]
- [ ] #29: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route exists yet)
- [ ] #31: [DRV-DOC] Phase D: Conv-222 set registration + Tier-1 recipe rewrite + humble-wondering-turtle.md → PLAN.md (registry + route-regen for feeds DONE Conv 224)
- [ ] #32: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #33: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #34: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #35: [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page (Matt directive) [Opus]
- [ ] #36: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #37: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference

## Key Context

- **/feeds = discover destination (Option A).** `feeds.astro` mounts `FeedsDiscoveryGrid` (client:load) + `FeedsDirectory` (client:only). FeedsDirectory is ONE self-contained island (role-tab bar is a controlled child) — distinct from /communities' 3-island event-bus shell and /members' API-driven island. New components in `src/components/feed/directory/`.
- **FeedsHub composite → `/` landing (NOT /feeds).** Matt's directive. `[HOME-FEEDSHUB]` (#35). See corrected memory `project_feeds_hub.md`.
- **Registry is at `scripts/matt-inspired-registry.ts`** (NOT src/lib — a garbled read misled this conv). 4 feeds entries added.
- **`*/` comment gotcha:** never write `*/` (e.g. Tailwind `secondary-*/primary-*`) inside a `/* */` doc-comment — it terminates the comment early (cost 137 phantom astro errors this conv).
- **Route regen = TWO scripts** (`node scripts/route-matrix.mjs` + `node scripts/route-api-map.mjs`), NOT `npm run docs:routes` (doesn't exist). Writes both repos.
- **TERM-GARBLE was severe** — re-verify tool side-effects via clean `git status` before any destructive step when garble is active.
- A background dev server may still be running on **:4322** (spawned this conv).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
