# State — Conv 225 (2026-05-31 ~13:40)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 225 was a **post-r-end correction** of one Conv-224 miss: terminal-render garble had faked a "success" for registering the 4 `/feeds` `@matt-inspired` components, so they were never actually in the registry (Conv-224's commit/RESUME over-claimed it). This conv registered them correctly in `scripts/matt-inspired-registry.ts` (`PHASE6_EXTRAPOLATION_CANDIDATES`, proper `ComponentCandidate` schema), verified via grep + node-parse + tsc (all clean). The `/feeds` port itself (Conv 224) was already real, gate-verified, and pushed — only the registry bookkeeping was outstanding.

## Completed

- [x] Registered FeedDirectoryCard, FeedsRoleTabs, FeedsDirectory, FeedsDiscoveryGrid in scripts/matt-inspired-registry.ts (corrects Conv-224 garble-faked registration)
- [x] Verified: 4 entries present (grep), node parse exit 0, tsc --noEmit exit 0

## Remaining

- [ ] [DRV-DOC] Phase D remainder — register the Conv-222 + Conv-223 component sets (MemberCard/MembersDirectory/CommunityCatalogCard etc. are ALSO absent from the registry); rewrite the DISC-DROP "Tier-1 recipe"; migrate `~/.claude/plans/humble-wondering-turtle.md` → PLAN.md DISC-ROLE-VIEWS block
- [ ] [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page; confirm "/" composition with user/Matt first [Opus]
- [ ] [BAK-ARTIFACT] Track down what creates stray .bak files in the code repo
- [ ] [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] All other pending blocks below — unchanged (RTMIG-4, MATT-EXEC-*, ICN-NS, PROFILE-PRIM-SWEEP, etc.)

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
- [ ] #27: [TERM-GARBLE] Mitigate recurring CC terminal-render garble (severe Conv 224 — faked tool successes incl. the registry edit)
- [ ] #28: [ROLE-AWARE] Make pages role-aware as the role-aware tab bar rolls out [Opus]
- [ ] #29: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route exists yet)
- [ ] #31: [DRV-DOC] Phase D: Conv-222/223 set registration + Tier-1 recipe rewrite + humble-wondering-turtle.md → PLAN.md (feeds registration DONE Conv 225; route-regen DONE Conv 224)
- [ ] #32: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #33: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #34: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #35: [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page (Matt directive) [Opus]
- [ ] #36: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #37: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference

## Key Context

- **Registry lives at `scripts/matt-inspired-registry.ts`** — schema is `ComponentCandidate` (`path`/`name`/`figmaMatchNames`/`note`) in arrays `COMPONENT_CANDIDATES` / `PHASE6_EXTRAPOLATION_CANDIDATES`. NOT a `{conv,purpose,family}` flat list (that was a garbled hallucination Conv 224).
- **Conv-222 + Conv-223 components are ALSO unregistered** (MemberCard, MembersDirectory, CommunityCatalogCard…) — discovered Conv 225; folded into [DRV-DOC] #31.
- **/feeds = discover destination** (Conv 224). FeedsHub composite → `/` landing ([HOME-FEEDSHUB] #35). Components in `src/components/feed/directory/`.
- **TERM-GARBLE** ([#27]) was severe Conv 224 — it faked a registry-edit "success" against a non-existent path; always re-verify writes via clean `git status`/grep when garble is active.
- A background dev server may still be running on **:4322**.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
