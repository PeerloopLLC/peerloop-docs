# State — Conv 298 (2026-06-18 ~08:37)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Verified **RG-COURSES** genuinely complete (full course-detail SubNav audit), shipped **[HOME-RPANEL]** (a Home-only right-side light-blue "coming soon" panel, bespoke in `index.astro` — kills the dead left gutter, client-driven), and stood up **[TYPO-FDN]** — a typography + spacing foundation sibling to PALETTE-FDN. TYPO-FDN Phase 1 is done (minted `text-body-default-prose` 14px/lh-1.5 to fill the gap where Matt's scale offers 14px only as a caption; wrote style-guide §09-typography). Phase 2/3 underway: built `plan/typo-fdn/migration-ledger.md` (component-level SoT, 23 rows), locked the unified card spec into §9.4a, migrated **3/23** Home cards. All committed (9 commits this conv); banked mid-migration on the ledger.

## Completed

- [x] Verified RG-COURSES genuinely complete (SubNav: all in-scope tabs swept; Prepare/Join→RG-SESSIONS + Certificate→no-route are out-of-scope by design)
- [x] [HOME-RPANEL] Home-only right "coming soon" panel, bespoke in index.astro, DOM-verified (committed `86325970`)
- [x] Fixed stale `project_feeds_hub.md` memory (FeedsHub unmounted from Home Conv 267) (committed `2af37ca`)
- [x] [TYPO-FDN] Phase 1: minted `text-body-default-prose` + bridge + §09-typography doc (committed `973ea1a2`/`88d3114`)
- [x] [TYPO-FDN] Phase 2/3 start: migration ledger + §9.4a unified card spec + 3 Home cards migrated (committed `3d3b0dae`/`8578d03`)

## Remaining

**[TYPO-FDN] #32 (IN PROGRESS — resume from `plan/typo-fdn/migration-ledger.md`):**
- [ ] [TYPO-FDN] migrate the remaining 20 ledger rows (FeedActivityCard heavy+shared, CourseAnchor/CommunityAnchor heavy+shared, FeedPost, SmartFeed, OnboardingNudgeBanner, ProgressionNudge, StickySignupBar, + /courses: SectionTitle, CoursesFilters, RecommendedCourses, 5 course-cards, CoursesRoleTabs, CoursesCatalog)
- [ ] [TYPO-FDN] resolve open decisions 2 (off-scale-px snap-or-flag: `gap-[10px]`/`gap-[6px]`/`mt-[2px]`/`m-[76px]`) + 3 (CourseAnchor/CommunityAnchor shared-scope)
- [ ] [SPACING-4PX-SWEEP] #33 — sweep legacy `h-4 w-4`/`p-4` (NAV-RETROFIT 4px collapse; DiscoveryCard precedent)

**Route sweep (RTMIG-4 umbrella — 13 RG groups):**
- [ ] [RTMIG-4] · [RG-ADMIN] (cleanest unblocked start) · [RG-AUTH] · [RG-PROFILE] · [RG-COMMS] · [RG-DISCOVER]
- [ ] [RG-PUBPROF] [Opus] (blocked by [ROLE-SEMANTICS]) · [ROLE-SEMANTICS] [Opus] · [RG-WORKSPACES] [Opus] ⛔client
- [ ] [RG-MESSAGES] · [RG-NOTIFS] · [RG-SESSIONS] · [RG-MOD] · [RG-PUBLIC]

**Follow-ups / debt:**
- [ ] [STALE-TESTS] 5 pre-existing test failures (4 Conv-292 ephemeral-dismiss + 1 ListingShell mobile-contract)
- [ ] [COURSES-FIXES] (open: [FILTERS-RESPONSIVE], [TYPO-REVIEW]) · [HOME-FIXES] · [PROV-STAMP-GAPS] (5 untracked)
- [ ] [PALETTE-FDN] migration tail (FeedActivityCard recolor — overlaps TYPO-FDN ledger; per-route colour migration; retire legacy ramps)
- [ ] [OLD-PORTED-CLEANUP] · [PREFLIP-WT] · [E2E-MIG] · [E2E-GATE] (blocked by E2E-MIG) · [ICN-NS] · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG] · [M4-ZGUARD]

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-PROFILE] · #10 [RG-COMMS] · #11 [RG-DISCOVER] · #12 [E2E-MIG] · #13 [E2E-GATE] · #14 [ICN-NS] · #15 [TZ-AUDIT] [Opus] · #16 [DOCGEN-SPEC] · #17 [V217-WATCH] · #18 [MEM-PRUNE] · #19 [LAYOUT-SG] · #20 [RG-MESSAGES] · #21 [RG-NOTIFS] · #22 [RG-SESSIONS] · #23 [RG-MOD] · #24 [RG-PUBLIC] · #25 [PROV-STAMP-GAPS] · #26 [HOME-FIXES] · #27 [COURSES-FIXES] · #28 [M4-ZGUARD] · #29 [PALETTE-FDN] · #30 [STALE-TESTS] · #32 [TYPO-FDN] (in_progress) · #33 [SPACING-4PX-SWEEP]

## Key Context

- **TYPO-FDN resume point is the ledger** — `plan/typo-fdn/migration-ledger.md`: component-level rows (SoT), route completion derived, per-axis Type/Spacing/Colour checkboxes. 3/23 ☑ (AnnouncementCard, SuggestionCard, DiscoveryCard). Open decisions 2 & 3 still need a call before the heavy/shared components.
- **The lh:1 is NOT a bug** — it's Matt's documented two-regime design (dense lh-1.0 / prose lh-1.5). The fix was minting a 14px prose token + a usage discipline (§09-typography), not changing token values.
- **Unified card spec (LOCKED §9.4a):** `p-16` + `rounded-12` + title `text-body-medium-bold` / body `text-body-default-prose` / label+meta `text-body-small(-medium)`; rhythm `mt-4`/`mt-8`/`gap-12`. No arbitrary `[Npx]` for margin/padding/gap.
- **🔴 NAV-RETROFIT 4px collapse** ([SPACING-4PX-SWEEP] #33): the Conv-174 bridge override makes legacy `p-4`/`h-4 w-4` render at 4px (not 16px). DiscoveryCard fixed; likely affects other legacy components.
- **HOME-RPANEL** recorded in `plan/route-migration/README.md` RG-HOME row (not a standalone block); it closes part of [HOME-FIXES] which stays open. Panel growth caps at AppLayout's 1248px content-card (accepted).
- **MEMORY.md ~85%** of SessionStart cap → [MEM-PRUNE] #18 still live.
- Code repo on `jfg-dev-14`. 9 commits this conv (code: `86325970`, `973ea1a2`, `3d3b0dae`; docs: `2af37ca`, `88d3114`, `8578d03` + start + the r-end close commit).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
