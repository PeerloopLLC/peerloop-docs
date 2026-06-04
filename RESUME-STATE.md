# State — Conv 238 (2026-06-03 ~18:28)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Feed-surface conv. Re-scoped + shipped [FEED-DETAIL] (legacy `/feed` is a single SmartFeed page, not a `/feed/[slug]` family → ported `/old/feed` → root `src/pages/feed.astro`, `@matt-inspired`), wired **"My Feed" → /feed** into the Sidebar with a harvested `sparkles` MattIcon, and repaired stale post-flip `/discover/*` links the route-flip/Conv-222 missed (discover.ts CTAs, smart-feed enrichment, DiscoverSlidePanel Feeds+Courses). Designed [COMM-TAG-FILTER] (found to be a net-new feature, not a wiring task) with both decisions LOCKED. Also reconciled the Conv-237 task under-capture at /r-start (37+5=42 tasks restored). 5 gates green (suite 6460); browser+curl verified.

## Completed

- [x] /r-start backlog reconciliation: 37 Conv-235 backlog + 5 COMM-DETAIL follow-ups = 42 restored; [MW-COMMUNITY-STALE] marked done (investigated Conv 237, guard deliberate)
- [x] [FEED-DETAIL] `/old/feed` → root `/feed.astro` (@matt-inspired, Matt shell + SmartFeed island, auth-gated); ~7 dead `/feed` links + middleware now resolve
- [x] [FEED-DETAIL] link-honesty: `discover.ts:222/250` + `enrichment.ts:179/180` `/discover/{community,course}` → root
- [x] "My Feed" → /feed Sidebar NAV+COLLAPSED_NAV + harvested `sparkles` MattIcon (provenance tracked); active-state verified both ways
- [x] DiscoverSlidePanel Feeds→/feeds + Courses→/courses (stale `/discover/*` fixed)
- [x] [COMM-TAG-FILTER] design written (`plan/comm-tag-filter/README.md`); decisions LOCKED = channels model + `community_channels` table; build-ready, deferred to own conv
- [x] 5 gates green (tsc / astro check 0/0/0 1327 / lint / suite 6460/6460 / build); route docs + url-routing.md updated

## Remaining

Feed-area follow-ups + new debts (this conv):
- [ ] [COMM-TAG-FILTER] Build the feature per plan/comm-tag-filter/README.md (schema→composer→API→UI→backfill); decisions locked, only a courtesy Matt check remains [Opus]
- [ ] [CT-RESTYLE] Tier-2 Matt-token restyle of CommunityMembersTab + CommunityResourcesTab
- [ ] [COMM-LEAVE] Wire the community "Leave" button (dead in legacy)
- [ ] [MOD-TOGGLE] Click-test the moderator toggle with a creator/admin session
- [ ] [PROV-SWEEP-DEBT] Fix 6 pre-existing prov:sweep errors (verified.svg entry, 3 UNTRACKED Astro stamps, CourseHeader NODE-MISMATCH); not in 5-gate baseline
- [ ] [DASH-COURSES-LINK] StudentDashboard "browse courses" → stale /discover/courses (repoint → /courses + test)

Restored Conv-235 backlog (full set, carried forward):
- [ ] [MATT-EXEC-PG2] Phase 5 remaining pages — Session family + ~5 routes (active Matt-push head)
- [ ] [MATT-EXEC-EXT] Phase 6 lazy primitive extrapolation · [MMP-PH5] Phase 5 graduation via Figma MCP · [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] [CH-VARIANTS] CourseHeader Scheduled variant · [SUCCESS-COMMUNITY] success page Phase 2 composer
- [ ] [MFRD-LOOKUP] Ready-for-Dev frame lookup · [PRECHECKOUT-MATT-CONFIRM] · [ENROLL-NAV-MATT-CONFIRM] (Matt sign-offs)
- [ ] [RTMIG-TIER] Tier-1/2 strategy · [RTMIG-4] ~89 /old/* pages → root
- [ ] [PRIM-MATCH-INDEX] · [PRIM-DOC] · [PRIM-ORPHAN-ACK] · [TXTBTN] · [PROFILE-PRIM-SWEEP] (PAUSED) · [PRIM-COURSES-DISMISS]
- [ ] [ICN-NS] icon convergence · [HOWTOREG-ICN] · [ASSET-SWEEP-GATE]
- [ ] [E2E-MIG] · [E2E-GATE]
- [ ] [SHOWMORE] · [SELECT-AUDIT]
- [ ] [ADMIN-REDIRECT-BLANK] non-admin /admin/* blank 200 [Opus] · [SETTINGS-WATCHER] · [BAK-ARTIFACT]
- [ ] [PREFLIP-WT] · [REND-DEDUP-GUARD] · [MEM-CAP] (MEMORY.md 81% — run /r-prune-memory) · [GARBLE-WATCH]
- [ ] [API-USERS-DRIFT] · [DOCS-ROUTES-STALE] · [PREPLAN-CHECKOUT-NOTE]
- [ ] [HOME-FEEDSHUB-VIS] · [DOM-FIRST]

## TodoWrite Items

- [ ] #1: [COMM-TAG-FILTER] Wire real Commons tag filtering [Opus] — designed + locked, build deferred to own conv
- [ ] #3: [CT-RESTYLE] · #4: [COMM-LEAVE] · #5: [MOD-TOGGLE] — COMM-DETAIL follow-ups
- [ ] #6: [MATT-EXEC-PG2] · #7: [MATT-EXEC-EXT] · #8: [MMP-PH5] · #9: [MATT-EXEC-GRD] · #10: [CH-VARIANTS] · #11: [SUCCESS-COMMUNITY] · #12: [MFRD-LOOKUP] · #13: [PRECHECKOUT-MATT-CONFIRM] · #14: [ENROLL-NAV-MATT-CONFIRM]
- [ ] #15: [RTMIG-TIER] · #16: [RTMIG-4]
- [ ] #17: [PRIM-MATCH-INDEX] · #18: [PRIM-DOC] · #19: [PRIM-ORPHAN-ACK] · #20: [TXTBTN] · #21: [PROFILE-PRIM-SWEEP] · #22: [PRIM-COURSES-DISMISS]
- [ ] #23: [ICN-NS] · #24: [HOWTOREG-ICN] · #25: [ASSET-SWEEP-GATE]
- [ ] #26: [E2E-MIG] · #27: [E2E-GATE]
- [ ] #28: [SHOWMORE] · #29: [SELECT-AUDIT]
- [ ] #30: [ADMIN-REDIRECT-BLANK] [Opus] · #31: [SETTINGS-WATCHER] · #32: [BAK-ARTIFACT]
- [ ] #33: [PREFLIP-WT] · #34: [REND-DEDUP-GUARD] · #35: [MEM-CAP] · #41: [GARBLE-WATCH]
- [ ] #36: [API-USERS-DRIFT] · #37: [DOCS-ROUTES-STALE] · #38: [PREPLAN-CHECKOUT-NOTE]
- [ ] #39: [HOME-FEEDSHUB-VIS] · #40: [DOM-FIRST]
- [ ] #43: [PROV-SWEEP-DEBT] · #44: [DASH-COURSES-LINK]

## Key Context

- **Three feed surfaces (recurring confusion):** `/feed` (singular personal SmartFeed — NOW BUILT, @matt-inspired) · `/feeds` (plural Discover directory — built Conv 224) · `/community/[slug]/feed` + `/course/[slug]/feed` (per-entity tabs). FeedsHub "My Feeds" composite still destined for `/` ([HOME-FEEDSHUB-VIS] #39).
- **`/feed` is `noNav`** (scanner only sees legacy AppNavbar) but IS a Matt Sidebar item ("My Feed"). `matchHref`'s `+ '/'` guard prevents `/feed`↔`/feeds` cross-activation.
- **`sparkles` MattIcon** = harvested Material `auto_awesome`, `source: 'ours'`. Icon registry auto-registers from `svg/`.
- **[COMM-TAG-FILTER] is a net-new feature**, NOT a wiring task: no tag column on `feed_activities`, no Stream tag field, legacy chips hardcoded. Decisions LOCKED = channels + `community_channels` table. Design: `plan/comm-tag-filter/README.md`.
- **prov:sweep is RED (6 pre-existing errors)** and is NOT in the 5-gate baseline → [PROV-SWEEP-DEBT] #43.
- **Branch state (pre-commit):** code + docs changes committed in Step 6; code on `jfg-dev-13-matt`.
- Decision routed to `docs/decisions/11-new-routing.md` (FEED-DETAIL) + `02-database.md` (COMM-TAG-FILTER schema).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
