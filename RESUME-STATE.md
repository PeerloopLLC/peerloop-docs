# State — Conv 252 (2026-06-08 ~20:35)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Design + foundation conv for the role architecture. **Decided [ROLE-STUDIOS]:** deconstruct the unified `/dashboard` into per-role workspaces (`/learning`, `/teaching` + tools, `/creating` + Creator Studio) + a thin cross-role triage strip on home `/` + a **must-have** flywheel progression-nudge layer; oversight roles (admin/moderator) keep combined consoles (`/admin`, `/mod`) connected via admin-only contextual deep-links (model A). Wrote a 7-phase build plan. **Decided + built [ROLE-SEMANTICS] foundation:** two-axis rule (capability `canX` gates actions / identity `isX` behavioral gates nav/display/nudges) — added canonical getters to `current-user.ts` + server SQL fragments to `roles.ts`, deduped 6 inline-SQL sites, 15 tests. Ran a 3-agent blast-radius audit → **Decision A:** split each Tier-1 hybrid site by purpose (access→`canCreateCourses`, identity→`isCreator`) — the naive flip would have 403'd approved-but-0-course creators. All 5 baseline gates green.

## Completed

- [x] [ROLE-STUDIOS] design exploration → deconstruct decision + 7-phase build plan in PLAN.md; performing-vs-oversight model + model A; route-migration README cluster 0/2/3/4 realigned
- [x] [ROLE-SEMANTICS] two-axis rule decided + foundation built: `isCreator/isTeacher/isStudent/isModerator` getters (`current-user.ts`), `isCreatorSubquery/isTeacherSubquery` fragments (`roles.ts`), 6 inline-SQL sites deduped (zero behavior change), 15 tests
- [x] Blast-radius audit (3 parallel Explore sweeps) + Decision A (split by purpose) + security rule + revoke edge — recorded in PLAN.md § ROLE-SEMANTICS
- [x] All 5 baseline gates green this conv: tsc / astro check 0·0·0 / lint / full test 6472/6472 / build

## Remaining

- [ ] [RS-HYBRID-FLIP] #24 [Opus] — split Tier-1 hybrid sites by purpose: access→`canCreateCourses`, identity→`isCreator`. Sites: server `me/creator-dashboard.ts:96`, `me/courses/index.ts:82`, `me/communities/index.ts:64` + client `useCreatorGate.ts:41` (shadows the getter) + `ContextActionsPanel.tsx:80`. Tier-2 (DashboardLinks/UnifiedDashboard) evaporates with Phase-3. **Blocks #1.** Coupled to /creating port. Decide granted-but-0-courses routing (Decision A = keep access via capability). SoT: PLAN.md § ROLE-SEMANTICS blast-radius audit.
- [ ] [RS-SQL-SWEEP] #25 — mechanical zero-behavior swap of remaining ~15 pure-behavioral inline is_creator/is_teacher SQL → `roles.ts` fragments. Low priority; rides along with ports.
- [ ] [ROLE-STUDIOS] #1 [Opus] — build the deconstruction (Phases 0/2b/3/4/5; owns triage strip, nudge layer, `/mod` console, cleanup). Blocked by #2 + #24. `/mod` is a dead link today.
- [ ] [ROLE-SEMANTICS] #2 [Opus] — umbrella; foundation done, remainder = #24/#25.
- [ ] [RTMIG-4] #3 [Opus] — main porting loop; hosts Phase-2 workspace ports; role ports wait on #24.
- [ ] [ENTITY-ANCHOR] #4 · [SSR-LOADER-DEAD] #5 · [PORTED-AUDIT] #6
- [ ] [COMM-TAG-FILTER] #7 · [CT-RESTYLE] #8 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #9 · [TXTBTN] #10 (watch) · [PROFILE-PRIM-SWEEP] #11 (PAUSED)
- [ ] [ICN-NS] #12 · [E2E-MIG] #13 · [E2E-GATE] #14
- [ ] [SHOWMORE] #15 · [SETTINGS-WATCHER] #16
- [ ] [PREFLIP-WT] #17 (KEEP until client-vet) · [STG-SEED] #18 (watch) · [TZ-AUDIT] #19 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #20 · [MEM-CAP] #21 (MEMORY.md ~80% byte cap) · [DOCGEN-SPEC] #22 · [OLD-PORTED-CLEANUP] #23

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] [Opus] · #2 [ROLE-SEMANTICS] [Opus] · #3 [RTMIG-4] [Opus] · #4 [ENTITY-ANCHOR] · #5 [SSR-LOADER-DEAD]
- [ ] #6 [PORTED-AUDIT] · #7 [COMM-TAG-FILTER] · #8 [CT-RESTYLE] · #9 [PRIM-MATCH-INDEX] · #10 [TXTBTN]
- [ ] #11 [PROFILE-PRIM-SWEEP] · #12 [ICN-NS] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [SHOWMORE]
- [ ] #16 [SETTINGS-WATCHER] · #17 [PREFLIP-WT] · #18 [STG-SEED] · #19 [TZ-AUDIT] [Opus] · #20 [SUCCESS-COMMUNITY-VERIFY]
- [ ] #21 [MEM-CAP] · #22 [DOCGEN-SPEC] · #23 [OLD-PORTED-CLEANUP] · #24 [RS-HYBRID-FLIP] [Opus] · #25 [RS-SQL-SWEEP]

## Key Context

- **The capability/identity rule (banked):** `canX` (permission flags) gates ACTIONS; `isX` (behavioral) gates NAV / display / nudges. Canonical getters on `CurrentUser` (`current-user.ts`) + server SQL fragments (`isCreatorSubquery`/`isTeacherSubquery` in `roles.ts`). Anti-pattern: re-inlining the is_creator/is_teacher subquery, or using `canCreateCourses` for an identity purpose.
- **Decision A (granted-but-0-courses creator):** ACCESS stays on `canCreateCourses` (they enter an empty-state `/creating`); IDENTITY is behavioral (no Creator badge yet, nudge fires). So RS-HYBRID-FLIP = "split each site by purpose," NOT "flip to behavioral" (that 403's approved creators).
- **Security rule:** `getUserRoles()` bakes permission-based roles into the JWT; `requireRole` only checks admin/moderator today (assigned → safe). NEVER `requireRole(['creator'/'teacher'])` until `getUserRoles` is behavioral.
- **Performing vs oversight:** deconstruct only the performing roles (student/teacher/creator); oversight roles (admin/moderator) keep combined consoles (`/admin` already is one; `/mod` is greenfield — dead link at `AdminDashboard.tsx:71`).
- **Progression nudges = MUST-HAVE** (user-elevated): student→teacher at the course Certificate gate + CourseDetail; teacher→creator in `/teaching` + on the taught course. Nudges on SOURCE-role surfaces, never the target hub.
- **`roles.ts userRoles()` is still permission-based** (Sidebar label / badges) — Tier-3 of RS-HYBRID-FLIP; behavior-changing.
- Code committed in Step 6 (pre-commit HEADs not yet final). Foundation diff = 8 files + 2 test files; all 5 gates green this conv.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
