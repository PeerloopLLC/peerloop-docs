# State — Conv 254 (2026-06-09 ~09:24)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Closed the **ROLE-SEMANTICS centralization** via `[RS-MOD-FRAG]` (new `isCommunityModeratorSubquery` fragment in `roles.ts`; both `members/index` `community_moderators` sites — EXISTS filter + COUNT(*)>0 projection — centralized onto it). Then shipped **ROLE-STUDIOS Phase 2b**: the `/mod` moderator console (`mod.astro` on AppLayout + a middleware moderation-access gate reusing `requireModerationAccess`, mirroring the `/admin` gate per the blank-200 rule), resolving two prior dead links (admin quick-action + moderator-invite redirect). Added `[MOD-NAV]` (persistent moderator Sidebar entry, `isModerator && !isAdmin`). Fully verified — gate across all 3 tiers (unauth→login, non-mod→/, community-mod→200), ModeratorQueue island hydration with Tier-2 scoping (1 row), and per-role nav. Also ran a conv-tasks.md integrity pass: dropped 3 stranded tasks, relabeled 12 verified-anchored thin rows to "⚠️ Thin - Stub". All gates green (tsc 0 / astro check 0·0·0 / lint; members tests 26/26).

## Completed

- [x] [RS-MOD-FRAG] #23 — `isCommunityModeratorSubquery` + 2 `members/index` sites centralized; ROLE-SEMANTICS centralization fully closed
- [x] ROLE-STUDIOS Phase 2b — `/mod` console (page + middleware gate); 2 dead links resolved; fully verified
- [x] [MOD-NAV] #24 — persistent moderator Sidebar entry (`isModerator && !isAdmin`; signal = `can_moderate_courses OR isCommunityModeratorSubquery`)
- [x] conv-tasks.md integrity pass — 3 stranded tasks dropped, 12 thin rows → "⚠️ Thin - Stub"
- [x] All gates green this conv

## Dropped

- [~] [PORTED-AUDIT] — stranded: no definition in PLAN.md, plan/, memory dir, git commit messages, OR any historical RESUME-STATE version (born as a bare bundled code). Dropped Conv 254. Re-create from scratch if the intent resurfaces.
- [~] [SETTINGS-WATCHER] — stranded (same as above; only ever a bare code). Dropped Conv 254. NOTE: distinct from the live [SETTINGS-GUARD]/[GUARD-VERIFY] work, which lives in `memory/project_settings_tier_local_control.md`.
- [~] [STG-SEED] — stranded (only ever a `(watch)` parenthetical; no real definition anywhere). Dropped Conv 254. Staging-integration work proper is tracked in `memory/project_staging_integration_plan.md`.

## Remaining

- [ ] [ROLE-STUDIOS] #1 [Opus] — multi-conv. Phase 0 ✅ / Phase 1 ✅ (ROLE-SEMANTICS) / **Phase 2b ✅ (this conv)**. Remaining: **Phase 2** (the headline `/creating` + `/teaching` workspace builds — the actual deconstruction, hosted under RTMIG-4), **Phase 3** (triage strip onto `/` + retire `UnifiedDashboard` + drop `AdminDashboardCard` + fix `AppNavbar.tsx:97` `/dashboard` link), **Phase 4** (progression-nudge layer), **Phase 5** (cleanup). SoT: PLAN.md § ROLE-STUDIOS. **Recommended next: the Phase-2 workspace build conv.**
- [ ] [RTMIG-4] #2 [Opus] — legacy /old/* → root porting loop; hosts the Phase-2 workspace ports + ROLE-SEMANTICS deliverable-4 call-site migration. SoT: plan/route-migration/README.md.
- [ ] [ENTITY-ANCHOR] #3 · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #6 · [CT-RESTYLE] #7 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #8 · [TXTBTN] #9 (watch) · [PROFILE-PRIM-SWEEP] #10 (PAUSED)
- [ ] [ICN-NS] #11 · [E2E-MIG] #12 · [E2E-GATE] #13 · [SHOWMORE] #14
- [ ] [PREFLIP-WT] #16 (KEEP until client-vet) · [TZ-AUDIT] #18 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #19
- [ ] [MEM-CAP] #20 (MEMORY.md ~82% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #21 · [OLD-PORTED-CLEANUP] #22

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] [Opus] · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] · #4 [SSR-LOADER-DEAD]
- [ ] #6 [COMM-TAG-FILTER] · #7 [CT-RESTYLE] · #8 [PRIM-MATCH-INDEX] · #9 [TXTBTN] · #10 [PROFILE-PRIM-SWEEP]
- [ ] #11 [ICN-NS] · #12 [E2E-MIG] · #13 [E2E-GATE] · #14 [SHOWMORE] · #16 [PREFLIP-WT]
- [ ] #18 [TZ-AUDIT] [Opus] · #19 [SUCCESS-COMMUNITY-VERIFY] · #20 [MEM-CAP] · #21 [DOCGEN-SPEC] · #22 [OLD-PORTED-CLEANUP]

## Key Context

- **ROLE-SEMANTICS centralization is now fully closed.** Three server fragments in `roles.ts` are the single definition for behavioral identity: `isCreatorSubquery`, `isTeacherSubquery`, `isCommunityModeratorSubquery`. NEVER re-inline any of these; NEVER conflate `isCommunityModeratorSubquery` (community_moderators table, behavioral) with the `can_moderate_courses` permission that drives the Moderator role LABEL.
- **`/mod` access gate:** lives in `middleware.ts` (NOT the page) — a redirect from inside AppLayout yields a blank 200 (Conv-250 [ADMIN-REDIRECT-BLANK]). It reuses `requireModerationAccess` (admin/platform-mod JWT OR Tier-2 community_moderators). Same pattern as the `/admin` gate. Any future role-gated AppLayout page must follow this.
- **[MOD-NAV] signal:** AppLayout computes `isModerator = can_moderate_courses === 1 || is_community_moderator === 1`; Sidebar shows `/mod` only when `isModerator && !isAdmin` (admins use `/admin`). Verified: Sarah(community-mod)→/mod, David(non-mod)→none, Brian(admin)→/admin only.
- **Phase 2 is the recommended next block** — the actual `/creating` + `/teaching` workspace deconstruction (net-new build, hosted under RTMIG-4). This is what "route building + dashboard deconstruction" refers to; Phase 2b/4 were the dependency-free satellites.
- **conv-tasks.md marker convention (new):** "⚠️ Thin - Stub" = code terse but PLAN/plan anchor verified (leave lazy). Genuinely-stranded codes (no def anywhere) are dropped, not carried. See the Dropped section above.
- Code will be committed in Step 6 (pre-commit HEAD; no hash yet). `mod.astro` is a new untracked file.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
