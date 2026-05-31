# State — Conv 227 (2026-05-31 ~19:35)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 227 did two substantive things. **(1) [TERM-GARBLE] (#27) root-caused** — the Conv-226 intermittent blank/partial tool-output renders + fabricated-failure narration are a known OPEN upstream Claude Code bug cluster (parallel-tool cascade-cancel #22264 → empty/late/out-of-order results #63966/#63859/#63797 + model confabulation #63538), strongly correlated with Opus 4.8 + parallel batches + any sibling failing (incl. our `guard-dangerous-bash.sh` PreToolUse hook). Not a Peerloop bug; unfixed as of CLI **2.1.159** (user's "2.1.59" was a dropped digit). Mitigations captured in memory; succeeded by watch task [GARBLE-WATCH] (#36). **(2) [DISC-RTB-RECONCILE] (#6) + [RTB] (#13) DONE** — converged the 3 discover role-tab islands onto the shared `RoleTabBar` primitive, **favouring Matt's §5 palette** (teacher→blue, moderator→neutral, role-colored active tab); generalized the tab model (id vs role); deleted FeedsRoleTabs; deregistered 3 from the prov registry; spec finalized in 02-architecture.md. 6 gates green (tests 6458/6458, zero edits); user browser-confirmed.

## Completed

- [x] [TERM-GARBLE] (#27) — root-caused as upstream CC bug cluster; mitigations in memory (`reference_term_garble_upstream_bug.md` + carve-out in `feedback_no_tool_call_spam_loops.md`)
- [x] [DISC-RTB-RECONCILE] (#6) — 3 role-tab islands → shared RoleTabBar (Matt-§5 palette); 6 gates green; browser-confirmed
- [x] [RTB] (#13) — Role Tab Bar spec finalized in `docs/as-designed/matt-design-system/02-architecture.md`; stale §2.7 code ref fixed

## Remaining

- [ ] [DISC-DROP] (#5) — umbrella substantially complete; **leaderboard** is the lone unported discover destination (excluded Conv 221) — decide port-or-drop before closing
- [ ] [ROLE-AWARE] (#28) [Opus] — gate now clear (blockedBy #6+#13, both done); restore admin-intel badge (communities + /courses) + role-aware feature audit
- [ ] [RTB-HOOK] (#37) [Opus] — extract shared `useRoleTabs` hook (Courses/Communities still duplicate visibleTabs-derivation + hash-sync)
- [ ] [GARBLE-WATCH] (#36) — re-test TERM-GARBLE when an upstream changelog explicitly fixes parallel tool-result delivery (currently 2.1.159, all issues OPEN)
- [ ] All other pending blocks below — unchanged (RTMIG-4, MATT-EXEC-*, ICN-NS, PROFILE-PRIM-SWEEP, etc.)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [DISC-DROP] Discover-destination migration umbrella (substantially complete; leaderboard port-or-drop remains)
- [ ] #7: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #8: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #9: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #10: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #11: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] #12: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
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
- [ ] #28: [ROLE-AWARE] Make pages role-aware as the role-aware tab bar rolls out [Opus] (blockedBy #6+#13, both done)
- [ ] #29: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] #30: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #31: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #32: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #33: [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page (Matt directive) [Opus]
- [ ] #34: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #35: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] #36: [GARBLE-WATCH] Re-test TERM-GARBLE when an upstream changelog explicitly fixes parallel tool-result delivery (2.1.159, all issues OPEN)
- [ ] #37: [RTB-HOOK] Extract shared visible-tab derivation hook for Courses/Communities role tabs [Opus]

## Key Context

- **RoleTabBar is now THE canonical role-tab strip** (`src/components/RoleTabBar.tsx`). API: `tabs: RoleTab[]` (`{id: string, role: RoleKey|null, label, count?, href?, icon?}`), `activeId: string`, `onChange?(id)`. `role: null` = neutral "All" tab (no dot, Text-Default active). Matt-§5 palette: teacher→`--Primary-Default` blue, creator→`--Creator-Primary`, student→`--Student-Primary`, moderator/admin→`--Text-Default` neutral. CoursesRoleTabs + CommunitiesRoleTabs are now stateful ADAPTERS (keep visibleTabs/hash/event logic, delegate rendering) — deregistered from `scripts/matt-inspired-registry.ts`. FeedsRoleTabs DELETED (FeedsDirectory renders RoleTabBar directly). Spec: `02-architecture.md` "### Role Tab Bar → Implemented (Conv 227)".
- **[RTB-HOOK] (#37)** is the natural next step in this cluster: Courses/Communities still each carry ~20 lines of near-identical visibleTabs-from-currentUser + hash-sync + reset-on-logout → extract `useRoleTabs(roleSourceFn, eventName)`. Feeds is a controlled child, out of scope.
- **[ROLE-AWARE] (#28)** now unblocked (gate #6+#13 cleared); scope = restore admin-intel attention badge dropped during the filter-only ports + role-aware feature audit.
- **[TERM-GARBLE] mitigations are live behavioral guidance** (see `reference_term_garble_upstream_bug.md`): on a suspicious-empty tool result verify out-of-band (`wc -c`/`git status`), never re-spam, never narrate un-received output; prefer narrower parallel batches when a hook-guarded/flaky-MCP call is in the mix. We are on CLI 2.1.159 — assume still exposed.
- Conv 227 commits will be made in Step 6 (this is the pre-commit snapshot). Code branch `jfg-dev-13-matt`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
