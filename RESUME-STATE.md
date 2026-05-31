# State — Conv 222 (2026-05-31 ~08:05)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 222 created the **DISC-ROLE-VIEWS** block: re-skinning the legacy per-role discover views into Matt-inspired versions after discovering the Conv-205/221 `/courses` + `/communities` "ports" had silently collapsed five distinct per-role components into a single filter-only catalog (dropping per-role rendering fidelity). Did the DISC-COMM href repoint (7 links → `/communities`, user-verified), then Phase A (communities per-role dispatcher) and Phase B (courses per-role views + a content-parity pass making `CourseCatalogCard` host-aware). 5 gates green twice (tests 6456/6456). Saved two governing memories. **Stopped mid-sweep with an open All-tab functionality question to re-ask FIRST next conv.**

## Completed

- [x] [DISC-COMM] href repoint — 7 `/discover/communities` links → `/communities` (DiscoverSlidePanel, DiscoverFeedsGrid, FeedAllTab×2, FeedsHub×2, HomeFeed) + user browser-verified `/communities`
- [x] [DRV-A] Communities per-role Matt dispatcher (`CommunitiesCatalog` rewrite) + new `CommunityRoleFallbackCard`
- [x] [DRV-PROG] `ProgressBar` @matt-inspired primitive
- [x] [DRV-B] Courses per-role Matt views: `CourseProgressCard`/`CourseTeachingCard`/`CourseCreatedCard`/`CourseModerationCard` + `CoursesCatalog` dispatcher + SegmentedPills sub-filters
- [x] Content-parity pass: host-aware `CourseCatalogCard` (`context="catalog"`) + student/created/moderation card field adds
- [x] 5 gates green twice (tsc 0 / astro 0/0/0 / lint / build / tests 6456/6456); route docs regenerated (both repos)
- [x] Memories: `feedback_read_legacy_source_before_conclusion`, `feedback_port_functionality_and_styling`

## Remaining

- [ ] **[DRV-B2] RE-ASK THIS QUESTION FIRST next conv** (full context in `.scratch/next-conv-first-step.md`): All-tab page-level functionality parity — legacy `ExploreAllTab` has duration filter, sort (#30), pagination, result count, active-filter pills, CTA that the new `/courses` All omits. Verbatim 👉: *"Apply the 'restore now' set (duration filter, result count, active-filter pills, pagination) — and for Sort + CTA, restore or keep as flagged?"* Same audit applies to `CommunityAllTab` (read it FULL first).
- [ ] [DRV-C] Phase C — `/feeds` + `/members` fresh root ports with the per-role dispatcher recipe (inventory legacy structure first) [Opus]
- [ ] [DRV-DOC] Phase D — register 7 new @matt-inspired components in matt-inspired-registry.ts + prov sweep; rewrite DISC-DROP "Tier-1 recipe" (currently encodes the wrong filter-only pattern); migrate plan `~/.claude/plans/humble-wondering-turtle.md` into PLAN.md
- [ ] All other pending blocks below — unchanged this conv (RTMIG-4, MATT-EXEC-*, ICN, etc.)

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
- [ ] #29: [ROLE-AWARE] Make pages role-aware as the role-aware tab bar rolls out [Opus]
- [ ] #30: [CAT-SORT] Add Matt sort control (members/posts/newest) to community + course catalogs
- [ ] #31: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route exists yet)
- [ ] #35: [DRV-C] Phase C: Feeds + Members fresh root ports with per-role recipe [Opus]
- [ ] #36: [DRV-DOC] Phase D: rewrite Tier-1 recipe + provenance registration + PLAN.md migration
- [ ] #37: [DRV-B2] All-tab page-level functionality parity (courses + communities) — RE-ASK FIRST next conv

## Key Context

- **FIRST ACTION next conv:** re-ask the [DRV-B2] All-tab functionality disposition question verbatim (see `.scratch/next-conv-first-step.md` for the table + the exact 👉). User directive Conv 222.
- **DISC-ROLE-VIEWS plan:** `~/.claude/plans/humble-wondering-turtle.md` (A–D breakdown; full sweep authorized). Phases A+B ✅; B2 (open question), C (feeds/members), D (housekeeping) remain.
- **Corrected Tier-1 recipe** (supersedes the old filter-only one): keep the 3-island shell; make the Catalog island a **per-role dispatcher** — `all` → Matt grid; role tabs → re-skinned legacy per-role view. **Build-new** Matt components; NEVER mutate legacy `/old` tabs (`tabs/*Tab.tsx`) or shared dashboard cards (`EnrollmentCard`/`CreatorCourseCard`).
- **Governing principle (memory):** a port = faithful functionality+content transfer AND full Matt styling, co-equal (`feedback_port_functionality_and_styling`). Read the full legacy source before concluding (`feedback_read_legacy_source_before_conclusion`).
- **Deferred (user):** other-role badges → #13/#6; admin-intel badge → #29/#30.
- **7 new @matt-inspired components** to register in `scripts/matt-inspired-registry.ts` (Phase D): ProgressBar, CommunityRoleFallbackCard, CourseProgressCard, CourseTeachingCard, CourseCreatedCard, CourseModerationCard (+ host-aware change to CourseCatalogCard).
- Branch `jfg-dev-13-matt`. Code changes will be committed in Step 6.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
