# State — Conv 249 (2026-06-07 ~21:03)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Docs/planning conv (zero code changes). Closed the **MATT-DESIGN-PUSH** block (archived to `plan/COMPLETED.md` #71) after establishing that its Phase 5 "remaining routes" were all stale — `/matt/` dissolved at ROUTE-FLIP (Conv 197), `/login` already `@matt-inspired`, `/teacher/*`+`/certification/[id]` belong to legacy-migration — and that Phases 6/7 are retired/dropped under the Conv-239 Matt phase-out. Removed the MATT-EXEC trio (#3/#4/#5) from tasks. Then generated the **RTMIG-4 porting backlog** (52 legacy `/old/*` routes with no root `@matt` port) into a new living checklist `plan/route-migration/README.md`, cross-linked from PLAN.md. NEXT CONV begins the cluster-by-cluster instruction + tiering pass ([RTMIG-TIER] #6).

## Completed

- [x] r-start cross-machine reconciliation — pull fast-forwarded past Convs 247–248 (M4Pro); reconciled the 27→21 conv-tasks shrink against git history (8 codes resolved, **recovered DOCGEN-SPEC** #22 which had silently dropped). SKILL.md self-update (Step 2.5) handled.
- [x] Examined MATT-EXEC-PG2/EXT/GRD → they are Phases 5/6/7 of MATT-DESIGN-PUSH (sequential, not redundant).
- [x] Confirmed `/matt/` is a dead routing remnant (dissolved Conv 197); PG2's 5 "pending routes" all stale → Phase 5 effectively complete.
- [x] Removed tasks #3/#4/#5 (MATT-EXEC trio) from TodoWrite (`status: deleted`).
- [x] **Closed MATT-DESIGN-PUSH** → `plan/COMPLETED.md` #71 (honest: Phases 1–5 done, 6 RETIRED, 7 DROPPED). Reconciled PLAN.md (ACTIVE row removed + intro bullet) + `plan/matt/README.md` (status header + phase table).
- [x] Generated 52-route RTMIG-4 backlog (97 legacy = 44 ported · 1 dropped · 52 remaining; `/members` supersedes discover people-pages).
- [x] Created `plan/route-migration/README.md` (living checklist) + PLAN.md cross-links; pointed [RTMIG-4] #7 at it as SoT.

## Remaining

**NEXT CONV — start here:**
- [ ] [RTMIG-TIER] #6 [Opus] — cluster-by-cluster pass through `plan/route-migration/README.md`: user gives per-route instructions per cluster → CC fills the Notes column + assigns tier/porting-order. Likely start cluster 1 (admin, 14). Resolve cluster-6 redirect-vs-port (`/teachers`,`/creators`→`/members`); confirm cluster-8 (marketing, 15) stays out of the RTMIG-4 count.

**Carried backlog:**
- [ ] [COMM-TAG-FILTER] #1 [Opus] · [CT-RESTYLE] #2 (Tier-2 community restyle)
- [ ] [RTMIG-4] #7 [Opus] (execution — SoT `plan/route-migration/README.md`)
- [ ] [PRIM-MATCH-INDEX] #8 · [TXTBTN] #9 (watch, <3) · [PROFILE-PRIM-SWEEP] #10 (PAUSED)
- [ ] [ICN-NS] #11 [Opus] · [E2E-MIG] #12 · [E2E-GATE] #13
- [ ] [SHOWMORE] #14 · [ADMIN-REDIRECT-BLANK] #15 [Opus] · [SETTINGS-WATCHER] #16
- [ ] [PREFLIP-WT] #17 (KEEP until RTMIG-4 done) · [STG-SEED] #18 (watch) · [TZ-AUDIT] #19 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #20 (browser-verify) · [MEM-CAP] #21 (prune MEMORY.md, 80% byte cap) · [DOCGEN-SPEC] #22

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] [Opus] · #2 [CT-RESTYLE] · #6 [RTMIG-TIER] [Opus] · #7 [RTMIG-4] [Opus] · #8 [PRIM-MATCH-INDEX]
- [ ] #9 [TXTBTN] · #10 [PROFILE-PRIM-SWEEP] · #11 [ICN-NS] [Opus] · #12 [E2E-MIG] · #13 [E2E-GATE]
- [ ] #14 [SHOWMORE] · #15 [ADMIN-REDIRECT-BLANK] [Opus] · #16 [SETTINGS-WATCHER] · #17 [PREFLIP-WT] · #18 [STG-SEED]
- [ ] #19 [TZ-AUDIT] [Opus] · #20 [SUCCESS-COMMUNITY-VERIFY] · #21 [MEM-CAP] · #22 [DOCGEN-SPEC]

## Key Context

- **RTMIG-4 backlog SoT = `plan/route-migration/README.md`** (52 routes, 8 clusters, living checklist w/ ⬜/✅/🔁/🗑️ Status + Notes column). True app-port count ≈ 35 once PUBLIC-PAGES (15) + redirect-candidates (2) are set aside. TodoWrite stays thin — spin up per-cluster tasks (`[RTMIG-ADMIN]` etc.) only when a cluster goes active.
- **Backlog clusters:** admin(14), creating(7), teaching(7), learning(2), public-profiles(3), people-listings(2 → redirect candidates), misc(2: reset-password, verify/[id]), marketing(15 = separate PUBLIC-PAGES block).
- **MATT-DESIGN-PUSH closed** — don't reopen. Phases 6/7 are retired/dropped, NOT unfinished (Conv-239 phase-out). Sibling MATT-CUTOVER stays open (PROV-MATCH-AUTO). The `phase-5-pg2.md:181` / `phase-6-ext.md:64` / `phase-7-grd.md:21` stale checkboxes are intentionally left (archived detail under a closed block).
- **MEM-CAP #21:** MEMORY.md at 80% of byte cap; run `/r-prune-memory` (NOT /r-prune-claude) before it crosses. User declined twice (Convs 248, 249).
- Zero code changes this conv → drift baseline unchanged; Step 5c route-doc regen no-op (no route source touched).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
