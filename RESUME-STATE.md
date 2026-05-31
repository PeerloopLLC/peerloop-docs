# State — Conv 221 (2026-05-30 ~21:29)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 221 advanced the discover-destination migration (ROUTE-MIGRATION / DISC-DROP). Added Communities/Feeds/Members as flat top-level Sidebar nav items ([SBAR-DISC] — nav-first, honest 404s; committed `ce26cbe1`), then built the `/communities` Matt page ([DISC-COMM] — courses-parity Tier-1 port of `/old/discover/communities`): new CommunityCatalogCard + CommunitiesRoleTabs + CommunitiesCatalog + CommunitiesFilters islands, Matt-restyled RecommendedCommunities, registered the card. Reframed DISC-DROP as the discover-destination umbrella; created [ROLE-AWARE]/[CAT-SORT]/[MW-COMMUNITY-STALE] follow-ups; recorded the /old-no-delete-until-vetted rule to memory. All 6 gates green incl. full suite 6456/6456.

## Completed

- [SBAR-DISC] (#28) — Communities/Feeds/Members added to Sidebar.tsx NAV + COLLAPSED_NAV (committed `ce26cbe1`)
- [DISC-COMM] (#29) CORE BUILD — /communities page + 4 new components + Matt-restyled RecommendedCommunities + registry entry; tsc 0, astro check 1299/0/0/0, lint, prov:sweep, build ✓, full suite 6456/6456
- Task reorganization (DISC-DROP umbrella; DISC-RTB-RECONCILE Rule-of-Three annotation; RTMIG-4 excludes discover destinations)
- Endpoint-parity check (one admin-intel diff, accepted = A)
- Memory: `project_old_pages_no_delete_until_vetted` + MEMORY.md pointer

## Remaining

- [ ] [DISC-COMM] (#29) remaining: repoint inbound `/discover/communities` hrefs → `/communities` (leave /old in place); browser-verify logged-in role tabs vs :4331. Then feeds + members ports mirror this (under [DISC-DROP]).
- [ ] All other pending blocks below — unchanged this conv (RTMIG-4, DISC-DROP feeds/members, MATT-EXEC-*, ICN, etc.)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12 (ErrorRetryCard precedent)
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [DISC-DROP] Discover-destination migration umbrella (communities/feeds/members → Matt root). Stage 3 ✅; communities ✅ core; feeds + members pending; "retire /old" = repoint hrefs ONLY, never delete until all-converted + client-vetted
- [ ] #6: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar [Opus] — Rule-of-Three: CoursesRoleTabs #1, CommunitiesRoleTabs #2, members #3 → extract shared RoleTabBar (Tier-2)
- [ ] #7: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus] — discover destinations tracked under DISC-DROP (no double-count)
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
- [ ] #29: [DISC-COMM] Port /old/discover/communities → /communities — CORE DONE; remaining: inbound href repoint + role-tab browser-verify vs :4331
- [ ] #30: [ROLE-AWARE] Make pages role-aware as the role-aware tab bar rolls out [Opus] — blocked by #6, #13; absorbs admin-intel badge restoration (communities + /courses) + role-aware feature audit
- [ ] #31: [CAT-SORT] Add Matt sort control (members/posts/newest) to community + course catalogs — client-side, deliberate courses-parity omission
- [ ] #32: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route exists yet)

## Key Context

- **DISC-COMM build will be committed in Step 6** (code: src/components/communities/*, src/pages/communities.astro, RecommendedCommunities.tsx, matt-inspired-registry.ts, RecommendedCommunities.test.tsx, + regenerated route docs in BOTH repos incl. tests/plato/route-map.generated.ts). Sidebar.tsx already committed `ce26cbe1` this conv.
- **Discover-destination Tier-1 port recipe** (validated by DISC-COMM): mirror /courses — Matt AppLayout shell + inline breadcrumb + SectionTitle + OnboardingNudgeBanner(context) + Matt-restyled recommendations + inline-Matt role tabs (do NOT mutate legacy ExploreTabBar) + Matt catalog card + search filter; forward-link to root detail routes (404-honest). Feeds + members are next, same recipe.
- **/old pages: NEVER delete** until all-converted + client-vetted (memory `project_old_pages_no_delete_until_vetted`). "Retire" = repoint hrefs only.
- **404-honesty is the vetting gate** — forward links can't surface unvetted content until that content's route is deliberately built. /community/[slug] has no root route → cards 404 (confirmed).
- **/communities is courses-parity** — it intentionally drops admin-intel badges (→ #30) and sort (→ #31), matching /courses' own omissions. Not bugs.
- Branch `jfg-dev-13-matt`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
