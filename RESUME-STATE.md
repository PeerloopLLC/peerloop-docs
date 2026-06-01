# State — Conv 228 (2026-05-31 ~21:10)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 228 did two substantive code deliverables in the RoleTabBar cluster plus three housekeeping items. **(1) [RTB-HOOK] (#34) DONE** — extracted `src/components/useRoleTabs.ts` (owns the duplicated role-tab mechanics: hash-init state, hash-sync + `<entity>:tabchange` dispatch, reset-on-logout, map→RoleTab[]); CoursesRoleTabs + CommunitiesRoleTabs now consume it, keeping only their entity-specific derivation `useMemo` (−57 net lines). Feeds excluded by structure. **(2) [ROLE-AWARE] (#25) DONE** — restored the admin-intel attention badge dropped by the Conv 205/221 filter-only ports: opt-in `adminBadgeCount` prop → `<AdminBadge>` on CourseCatalogCard + CommunityCatalogCard, fed by an admin-gated batch fetch (visible-page IDs) in CoursesCatalog + CommunitiesCatalog. Detail-page "Admin" tab deferred to RTMIG-4 (detail pages not ported). All 6 gates green both times (tests 6458/6458). **Housekeeping:** mirror-term memory rule; split the 4572-line DECISIONS.md into `docs/decisions/` (11 topic chunks + log + footnotes + INDEX, root→pointer); conv-tasks.md live-sync rule (`*DONE*` prefix, never delete) + /r-start Step 7.5 template update.

## Completed

- [x] [RTB-HOOK] (#34) — `useRoleTabs` extracted; Courses/Communities adapters consume it; 6 gates green
- [x] [ROLE-AWARE] (#25) — admin-intel attention badge restored on both catalog listings; 6 gates green
- [x] DECISIONS.md split → `docs/decisions/` (396 decisions preserved; root is a pointer)
- [x] Memory: `feedback_mirror_term_annotation.md`, `feedback_conv_tasks_live_sync.md` + MEMORY.md pointers
- [x] `/r-start` Step 7.5 template: `*DONE*` legend + live-sync instruction

## Remaining

- [ ] [DEC-SKILL-SYNC] (#35) — retarget the 4 skills (r-end, w-post-fix, w-sync-docs, r-commit) + `.claude/config.json` + r-end refs that still name DECISIONS.md as a write target → route new decisions to `docs/decisions/NN-*.md` chunks + decision-log.md + INDEX.md. Interim manual-routing rule lives in the pointer + INDEX.
- [ ] [DISC-DROP] (#5) — leaderboard is the lone unported discover destination; decide port-or-drop before closing the umbrella.
- [ ] All other pending blocks below — unchanged (RTMIG-4 ports, MATT-EXEC-*, ICN-NS, PROFILE-PRIM-SWEEP, etc.)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [DISC-DROP] Discover-destination migration umbrella — leaderboard port-or-drop remains
- [ ] #6: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #7: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #8: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #9: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #10: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] #11: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #12: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] #13: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] #14: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #15: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #16: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (Figma 597:6504 / 685:13240)
- [ ] #17: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #18: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #19: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #20: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #21: [TXTBTN] Extract TextButton primitive on Rule-of-Three (TopicPicker Select-All = instance 1)
- [ ] #22: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #23: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #24: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #26: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] #27: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #28: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #29: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #30: [HOME-FEEDSHUB] Mount FeedsHub composite on "/" landing page (Matt directive) [Opus]
- [ ] #31: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #32: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] #33: [GARBLE-WATCH] Re-test TERM-GARBLE when upstream changelog fixes parallel tool-result delivery
- [ ] #35: [DEC-SKILL-SYNC] Update skills/config that write to DECISIONS.md → target decisions/ chunks

## Key Context

- **`useRoleTabs` (`src/components/useRoleTabs.ts`)** is now the shared home for discover role-tab mechanics. API: `useRoleTabs({validTabs, eventName, visibleTabs})` → `{activeTab, onTabChange, tabs}`. The hook OWNS state/hash-sync/event/reset/mapping; each adapter computes `visibleTabs: RoleTabConfig<T>[]` in its own `useMemo` and passes it in (so the hook never calls useCurrentUser, and adapter memos stay lint-clean). FeedsDirectory is intentionally NOT a consumer (renders catalog inline, no sibling-island event). [RTB-HOOK] cluster is now complete.
- **Admin attention badge** is restored on the LISTING cards only (`adminBadgeCount` opt-in prop → `<AdminBadge>` top-right; admin-gated batch fetch keyed to the visible "all"-page IDs via the existing `/api/admin/intel/{courses,communities}` endpoints). The detail-page "Admin" extra-tab was NOT restored — it belongs to RTMIG-4 detail-page ports (cards are 404-honest to `/course/[slug]`, `/community/[slug]`).
- **DECISIONS.md is now a pointer.** New decisions go to `docs/decisions/NN-*.md` (topic chunk) + `docs/decisions/decision-log.md` (append at BOTTOM) + `docs/decisions/INDEX.md` (title). DOC-DECISIONS.md (docs-repo topics) is unchanged. **[DEC-SKILL-SYNC] (#35)** tracks updating the skills/config that still write to the old path — until done, route their decision-writes manually.
- **conv-tasks.md live-sync rule** (`feedback_conv_tasks_live_sync.md`): on TaskUpdate→completed, prepend `*DONE* ` to the row's meaning column (never delete); on TaskCreate, add a row. Markers fall off next conv (regen from pending-only set).
- Conv 228 commits made in Step 6 (pre-commit snapshot). Code branch `jfg-dev-13-matt`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
