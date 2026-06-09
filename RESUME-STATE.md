# State — Conv 253 (2026-06-09 ~08:10)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Closed the **ROLE-SEMANTICS core** in three landed pieces: `[RS-HYBRID-FLIP]` (5 Tier-1 hybrid creator gates split by purpose — access→capability, identity→behavioral; + removed dead `is_creator`/`is_teacher` registry pass-throughs); `[RS-SQL-SWEEP]` (40 inline `is_creator`/`is_teacher` SQL predicates across 29 files → `roles.ts` fragments — 24 scalar projections + 16 EXISTS filters); and the **Tier-3 display-axis fix** (Sidebar label `userRoles`/`describeRoles` + AppLayout SQL now behavioral, fixing a live Sidebar↔profile-header disagreement; JWT `getUserRoles` deliberately left permission-based since `requireRole` only gates `['admin']`). `[ROLE-SEMANTICS]` #2 marked complete (core closed; tails delegated). All gates green: tsc / astro check 0·0·0 / lint / full test 6479/6479.

## Completed

- [x] [RS-HYBRID-FLIP] #24 — 5 Tier-1 hybrid gates split by purpose + dead-field removal + 4 tests flipped to revoked-ex-creator-403 contract
- [x] [RS-SQL-SWEEP] #25 — 40 inline identity-SQL instances (24 projections + 16 EXISTS filters) across 29 files → fragments, zero behavior change
- [x] Tier-3 axis fix — Sidebar label behavioral; JWT permission-based + documented; new tests/lib/roles-labels.test.ts (7 tests)
- [x] [ROLE-SEMANTICS] #2 — umbrella core closed (PLAN status → ✅ CORE CLOSED)
- [x] All 5 gates green this conv

## Remaining

- [ ] [ROLE-STUDIOS] #1 [Opus] — build the dashboard deconstruction (Phases 0/2b/3/4/5; triage strip, nudge layer, /mod console). **Now fully UNBLOCKED** (both #2 + #24 done). SoT: PLAN.md § ROLE-STUDIOS.
- [ ] [RTMIG-4] #3 [Opus] — main legacy /old/* → root porting loop; hosts ROLE-SEMANTICS deliverable-4 incremental call-site migration (~93/68/55 canX refs, absorbed per-surface).
- [ ] [RS-MOD-FRAG] #26 — add isModeratorSubquery to roles.ts + centralize 2 inline community_moderators sites (members/index:121,180). Low priority, rides with Tier-3 follow-on.
- [ ] [ENTITY-ANCHOR] #4 · [SSR-LOADER-DEAD] #5 · [PORTED-AUDIT] #6
- [ ] [COMM-TAG-FILTER] #7 · [CT-RESTYLE] #8 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #9 · [TXTBTN] #10 (watch) · [PROFILE-PRIM-SWEEP] #11 (PAUSED)
- [ ] [ICN-NS] #12 · [E2E-MIG] #13 · [E2E-GATE] #14
- [ ] [SHOWMORE] #15 · [SETTINGS-WATCHER] #16
- [ ] [PREFLIP-WT] #17 (KEEP until client-vet) · [STG-SEED] #18 (watch) · [TZ-AUDIT] #19 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #20 · [MEM-CAP] #21 (MEMORY.md ~82% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #22 · [OLD-PORTED-CLEANUP] #23

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] [Opus] · #3 [RTMIG-4] [Opus] · #4 [ENTITY-ANCHOR] · #5 [SSR-LOADER-DEAD] · #6 [PORTED-AUDIT]
- [ ] #7 [COMM-TAG-FILTER] · #8 [CT-RESTYLE] · #9 [PRIM-MATCH-INDEX] · #10 [TXTBTN] · #11 [PROFILE-PRIM-SWEEP]
- [ ] #12 [ICN-NS] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [SHOWMORE] · #16 [SETTINGS-WATCHER]
- [ ] #17 [PREFLIP-WT] · #18 [STG-SEED] · #19 [TZ-AUDIT] [Opus] · #20 [SUCCESS-COMMUNITY-VERIFY]
- [ ] #21 [MEM-CAP] · #22 [DOCGEN-SPEC] · #23 [OLD-PORTED-CLEANUP] · #26 [RS-MOD-FRAG]

## Key Context

- **ROLE-SEMANTICS axis rule (banked):** `canX` (permission) gates ACTIONS; `isX` (behavioral) gates NAV/display/labels/nudges. Server fragments `isCreatorSubquery`/`isTeacherSubquery` in `roles.ts` are now the single definition — 30+ sites consume them. NEVER re-inline the identity subquery; NEVER use a `canX` for an identity purpose.
- **Decision A edge (live):** a revoked ex-creator with live courses now 403s on /creating + reads "Student" (not "Creator") in the Sidebar — explicitly accepted (PLAN line 115).
- **JWT exception:** `getUserRoles` (db/types.ts) stays PERMISSION-based on purpose — `requireRole` only gates `['admin']` (audited), and behavioral-in-JWT would be a stale login snapshot. NEVER `requireRole(['creator'/'teacher'])` without first making it behavioral.
- **No `isModeratorSubquery` yet** — 2 community_moderators sites left inline (RS-MOD-FRAG #26).
- **Next:** ROLE-STUDIOS #1 is the recommended next block (fully unblocked). Deliverable-4 call-site migration rides with RTMIG-4/ROLE-STUDIOS ports, not standalone.
- Code committed mid-conv (RS-HYBRID-FLIP: code a7bdd146 / docs 67d6681); RS-SQL-SWEEP + Tier-3 committed in this /r-end Step 6.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
