# State — Conv 223 (2026-05-31 ~09:40)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 223 advanced the DISC-ROLE-VIEWS block: completed **[DRV-B2]** (full legacy All-tab functionality parity for `/courses` + `/communities` — duration filter, sort, result count, pagination, removable active-filter pills, per-card CTA; filter islands made tab-aware; new shared `ui/CatalogPagination` primitive), **[CAT-SORT]**, and **[DRV-C] Members** (`/members` Matt root port — new server-driven `MembersDirectory` + `MemberCard`, deliberately NOT the per-role dispatcher because members are entity-role/multi-select/server-driven). Fixed a real bug in `/api/members` (moderator filter now derives from `community_moderators`, not the `can_moderate_courses` flag; +2 regression tests) and the app-wide `Select` double-caret (`@tailwindcss/forms` chevron suppressed via `bg-none border-0`). 5 gates green (6456→6458). DRV-C Feeds remains (blocked on the `/feeds` identity decision).

## Completed

- [x] [DRV-B2] /courses + /communities All-tab functionality parity (option A — restore everything incl. Sort + CTA)
- [x] [CAT-SORT] Matt sort control on both catalogs
- [x] [DRV-C] /members Matt root port (page + MembersDirectory + MemberCard); DiscoverSlidePanel repointed; Sidebar already linked /members
- [x] Moderator API fix → community_moderators (filter clause + role-sort + isModerator badge); dropped dead can_moderate_courses; +2 regression tests
- [x] Select primitive double-caret fix (bg-none border-0 suppresses @tailwindcss/forms chevron+border) — browser-verified
- [x] 5 gates green (tsc/astro/lint/build + tests 6456→6458); route docs regenerated both repos

## Remaining

- [ ] [DRV-C] Phase C — **/feeds root port** (Members done; Feeds remaining). FIRST resolve the `/feeds` identity question: (a) discover-feeds destination port [DiscoverFeedsGrid + ExploreFeeds role directory], (b) FeedsHub composite, or (c) merge — FEEDS-HUB memory says client wants a composite. Inventory legacy + read source fully first. [Opus]
- [ ] [DRV-DOC] Phase D housekeeping: register new @matt-inspired components (CatalogPagination, MembersDirectory, MemberCard + the Conv-222 set) in matt-inspired-registry.ts + prov sweep; rewrite DISC-DROP "Tier-1 recipe"; migrate `~/.claude/plans/humble-wondering-turtle.md` into PLAN.md (create the DISC-ROLE-VIEWS block).
- [ ] [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md (pre-existing drift: nested roles/stats shape, sort params, limit defaults)
- [ ] [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report (memory)
- [ ] [SELECT-AUDIT] Spot-check Select instances render single caret post-forms-fix
- [ ] All other pending blocks below — unchanged this conv (RTMIG-4, MATT-EXEC-*, ICN-NS, etc.)

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
- [ ] #27: [TERM-GARBLE] Mitigate recurring CC terminal-render garble
- [ ] #28: [ROLE-AWARE] Make pages role-aware as the role-aware tab bar rolls out [Opus]
- [ ] #30: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route exists yet)
- [ ] #31: [DRV-C] Phase C — /feeds root port (Members ✅ Conv 223; Feeds remaining) [Opus]
- [ ] #32: [DRV-DOC] Phase D: rewrite Tier-1 recipe + provenance registration + PLAN.md migration
- [ ] #34: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #35: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #36: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix

## Key Context

- **DISC-ROLE-VIEWS recipe (confirmed):** keep the 3-island shell; Catalog island = per-role dispatcher (all → Matt grid; role tabs → re-skinned per-role view). Build-new Matt components; NEVER mutate legacy `/old` tabs or shared dashboard cards. BUT `/members` is the exception — it's a server-driven directory (entity-role + multi-select + GET /api/members + Load-More), so it conforms the Matt *visual grammar* (search/sort/count/card grid) without the dispatcher.
- **New shared primitive:** `src/components/ui/CatalogPagination.tsx` (@matt-inspired) — used by /courses + /communities All-tabs. Needs registry entry (DRV-DOC).
- **Select fix gotcha:** `@tailwindcss/forms` (`@plugin` in global.css) paints every `<select>` with a chevron `background-image` + border. Custom select wrappers must use `bg-none border-0` (NOT just `appearance-none`) — appearance:none can't clear a background-image.
- **/feeds not yet ported** — link in DiscoverSlidePanel still `/discover/feeds`. `/@handle` public profile also not at root (only /old) — MemberCard links 404-honest to `/@handle`.
- **Branch `jfg-dev-13-matt`** — changes committed in Step 6.
- Plan still lives at `~/.claude/plans/humble-wondering-turtle.md` (A–D breakdown); migration to PLAN.md is [DRV-DOC].

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
