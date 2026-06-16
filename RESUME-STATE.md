# State — Conv 290 (2026-06-15 ~21:15)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Planning conv (no code shipped). Created code branch `jfg-dev-14` from `jfg-dev-13-matt`. Reviewed the RTMIG-4 route-migration backlog: reconciled it against the live `src/pages` tree (the Conv-249 README's "53 remaining" was materially stale) and **decomposed RTMIG-4 into route-group homes**. Genuinely-remaining port work is small — public profiles (3), misc app (2), admin Tier-1 (14 @stand-in). Created 6 home tasks, folded 8 thin route-bugs into their homes, wired deps; rewrote `plan/route-migration/README.md` into the route-group-home structure. 29 → 27 tasks.

## Completed

- [x] Created code branch `jfg-dev-14` from `jfg-dev-13-matt`
- [x] Reconciled RTMIG-4 backlog against the live `src/pages` tree (Conv-290)
- [x] Decomposed RTMIG-4 into route-group homes; 6 new home tasks created
- [x] Folded 8 thin bug tasks into their group homes; deleted them (29 → 27)
- [x] Wired deps: RTMIG-4 ← ADMIN/PROFILES/MISC; RTMIG-PROFILES ← ROLE-SEMANTICS
- [x] Rewrote `plan/route-migration/README.md` into route-group-home structure
- [x] Re-synced `.scratch/conv-tasks.md`; PLAN.md ROUTE-MIGRATION status cell updated

## Remaining

**RG-0/1/2/3 — Route-migration umbrella & port homes:**
- [ ] [RTMIG-4] Route-migration umbrella (route-group homes); blocked by #30/#31/#32
- [ ] [RTMIG-ADMIN] Tier-1 Matt port of /admin/* (14 @stand-in bodies; shell already Matt, island/body-only; low priority)
- [ ] [RTMIG-PROFILES] [Opus] Port public-profile hub+spoke (/@[handle], /teacher, /creator); folds SSR-LOADER-DEAD + ENTITY-ANCHOR; **blocked by [ROLE-SEMANTICS]**
- [ ] [RTMIG-MISC] Port /reset-password + /verify/[id] (standalone shells; inline StatusBadge, defer extract to Tier-2)
- [ ] [ROLE-SEMANTICS] [Opus] Canonical creator/teacher detection predicate; **blocks [RTMIG-PROFILES]**
- [ ] [OLD-PORTED-CLEANUP] Delete ~43 stale /old copies of ported routes
- [ ] [PREFLIP-WT] Teardown pre-flip worktree (keep until client-vet)

**RG-4 — Role workspaces (home [ROLE-STUDIOS]):**
- [ ] [ROLE-STUDIOS] [Opus] ⛔ BLOCKED BY CLIENT — workspaces + triage + nudge layer; folds NUDGE-CACHE-FLASH + creating/apply
- [ ] [LEARN-ISLAND-RESTYLE] · [CREATE-ISLAND-RESTYLE] · [TEACH-ISLAND-RESTYLE] · [TRIAGE-RESTYLE]

**RG-5 — Own profile Tier-2 cluster (PAUSED):**
- [ ] [CT-RESTYLE] · [PRIM-MATCH-INDEX] · [TXTBTN] · [PROFILE-PRIM-SWEEP]

**RG-6/7/8 — Ported-route fixes:**
- [ ] [COURSEDETAIL-DEAD] Course route dead code
- [ ] [COMMUNITY-FIX] Community/Commons bucket (folds COMM-TAG-FILTER [deferred] + COMMONS-DATE)
- [ ] [FEEDS-FIX] Discover/Feeds bucket (folds DISCCARD-DEL + FEED-LANE-RENDER + STREAM-PURGE + SHOWMORE [held])

**Cross-cutting / infra:**
- [ ] [E2E-MIG] residual ~45 UI-structure-drift failures; [E2E-GATE] transitively blocked
- [ ] [ICN-NS] (held client-vet) · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH]
- [ ] [MEM-PRUNE] MEMORY.md at 80% of SessionStart auto-load cap; run /r-prune-memory
- [ ] [LAYOUT-SG] foundation residuals (substrate under every route-group port)

## TodoWrite Items

- [ ] #2 [ROLE-STUDIOS] [Opus] · #3 [RTMIG-4] · #5 [CT-RESTYLE] · #6 [PRIM-MATCH-INDEX] · #7 [TXTBTN] · #8 [PROFILE-PRIM-SWEEP] · #9 [ICN-NS] · #10 [E2E-MIG] · #11 [E2E-GATE] · #13 [PREFLIP-WT] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [OLD-PORTED-CLEANUP] · #17 [LEARN-ISLAND-RESTYLE] · #18 [CREATE-ISLAND-RESTYLE] · #19 [TEACH-ISLAND-RESTYLE] · #20 [TRIAGE-RESTYLE] · #21 [V217-WATCH] · #22 [COURSEDETAIL-DEAD] · #28 [MEM-PRUNE] · #29 [LAYOUT-SG] · #30 [RTMIG-ADMIN] · #31 [RTMIG-PROFILES] [Opus] · #32 [RTMIG-MISC] · #33 [ROLE-SEMANTICS] [Opus] · #34 [COMMUNITY-FIX] · #35 [FEEDS-FIX]

## Key Context

- **RTMIG-4 is now route-group-organized.** Durable SoT: `plan/route-migration/README.md` (rewritten this conv) — summary table maps RG → routes → port-state → TodoWrite code. The genuinely-unported RTMIG work is just: admin Tier-1 (14 @stand-in), public profiles (3, blocked on ROLE-SEMANTICS), misc app (2). Everything else is already-ported maintenance, ROLE-STUDIOS-owned, or deferred PUBLIC-PAGES.
- **8 thin bugs were folded into group-home task descriptions and deleted** (COMM-TAG-FILTER, SSR-LOADER-DEAD, SHOWMORE, NUDGE-CACHE-FLASH, COMMONS-DATE, DISCCARD-DEL, FEED-LANE-RENDER, STREAM-PURGE). Their content lives in the home tasks (#31, #34, #35, #2). Do not recreate them as standalone tasks.
- **Tier-1 = do now** (Matt shell+SubNav+tokens+existing-primitive swaps); **Tier-2 = deferred** new-primitive extraction (cross-cutting Rule-of-Three pass), NOT a per-cluster phase. `11-new-routing.md:445`.
- **Cleanest unblocked start:** [RTMIG-ADMIN] (shell already Matt, island/body-only, no deps). [RTMIG-PROFILES] needs [ROLE-SEMANTICS] settled first.
- **/dashboard is retired** (deconstructed by ROLE-STUDIOS), not ported — supersedes README cluster-0 "decision A".
- Code repo on new branch `jfg-dev-14`, no commits this conv. Docs README rewrite committed by this /r-end.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
