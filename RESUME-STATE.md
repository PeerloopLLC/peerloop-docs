# State — Conv 256 (2026-06-09 ~19:43)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built ROLE-STUDIOS **Phase 2 `/creating` + `/teaching`** workspaces (the last two of three performing-role workspaces — Phase 2 workspaces now COMPLETE), each `@matt-inspired` `[...tab].astro` + `_<role>-tabs.ts` + gated WORKSPACES sidebar entry + a detail sub-route (`creating/communities/[slug]`, `teaching/courses/[courseId]` with its SSR teacher_certification authorization preserved verbatim). Then **Phase 3 (partial)**: harvested PriorityHeader + NeedsAttention into a new thin `TriageStrip` island, light-mounted on Home `/` — but **did NOT retire UnifiedDashboard** (client requested a side-by-side comparison). Then **Phase 4 design-first**: wrote `plan/role-studios/phase-4-nudges.md` with locked decisions, deferred the build to Conv 257. All builds 5-gate-green + authed-SSR-verified.

## Completed

- [x] ROLE-STUDIOS Phase 2 `/creating` workspace (`[...tab].astro` + `_creating-tabs.ts` + `communities/[slug]` detail + `isCreator` sidebar gating)
- [x] ROLE-STUDIOS Phase 2 `/teaching` workspace (`[...tab].astro` + `_teaching-tabs.ts` + `courses/[courseId]` detail w/ preserved SSR cert-check authz + `isTeacher` sidebar gating) — **Phase 2 performing workspaces COMPLETE**
- [x] ROLE-STUDIOS Phase 3 (partial) — `TriageStrip` island harvested + light-mounted on Home `/`
- [x] ROLE-STUDIOS Phase 4 DESIGN (`plan/role-studios/phase-4-nudges.md`, decisions A/B/C/D locked) — build deferred to Conv 257
- [x] Each build verified: 5-gate codecheck (tsc/lint/tailwind/astro/build) + authed SSR (routes/tabs/detail/redirects/role-gating, both directions)
- [x] PLAN + memory (`project_role_studios_deconstruct_nudges` + MEMORY.md) updated with progress + client-comparison hold; `url-routing.md` (driftCheck) updated by docs agent

## Remaining

- [ ] [ROLE-STUDIOS] #1 [Opus] — multi-conv. Phase 2 workspaces ✅. Next: **Phase 4 build** ([NUDGE-BUILD] #24); then Phase 3 retirement (🔴 BLOCKED on client comparison) + `AppNavbar.tsx:97` fix; Phase 5 cleanup; per-workspace admin model-A deep-links. SoT PLAN.md § ROLE-STUDIOS.
- [ ] [NUDGE-BUILD] #24 — **ROLE-STUDIOS Phase 4 build (Conv 257).** SoT `plan/role-studios/phase-4-nudges.md`. Build `ProgressionNudge` island + port apply destinations (`/creating/apply` real; `/become-a-teacher` = wire orphaned `BecomeATeacherPage`, was a stub) + wire placements ② CourseDetail upgrade + ③ home strip. T→C gate v1 = `isTeacher && !isCreator`.
- [ ] [TRIAGE-RESTYLE] #23 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [LEARN-ISLAND-RESTYLE] #20 — faithful Matt restyle of scaffolded/harvested island internals (styling only, behavior preserved). TRIAGE-RESTYLE: coordinate with the coming Home rework (keep strip on top + merge full `/feed` beneath).
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13
- [ ] [PREFLIP-WT] #14 (KEEP until client-vet) · [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16
- [ ] [MEM-CAP] #17 (MEMORY.md OVER byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [V217-WATCH] #25 — watch whether v2.1.170 keeps dropping next-step/end offers at phase boundaries; reinforce CLAUDE.md if persistent.

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] [Opus] · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [NUDGE-BUILD] · #25 [V217-WATCH]

## Key Context

- **Phase 2 workspace template (now set by 3 examples):** `<role>/[...tab].astro` (`@matt-inspired`, `noNav=true`) + `_<role>-tabs.ts` SubNav config + AppLayout shell (header-bar breadcrumb + sub-nav slots) + gated WORKSPACES sidebar entry + reuse the existing role island. Detail sub-routes (`communities/[slug]`, `courses/[courseId]`) are MORE-specific routes that Astro resolves ahead of the `[...tab]` catch-all; bare parent → unknown-tab redirect.
- **`teaching/courses/[courseId]` carries real SSR authorization** (per-course `teacher_certification` check → redirect if not certified) — preserved verbatim from legacy; do NOT drop it on any restyle. The negative cert-check is the load-bearing test.
- **Sidebar gating:** `isCreator`/`isTeacher` added to `SidebarUser`; `AppLayout` already SELECTed `is_creator`/`is_teacher` (one-field wiring). Entries in flywheel order Learning→Teaching→Creating. Gated entries live in JSX (not the static COLLAPSED_NAV which is ungated-only).
- **🔴 Client comparison hold:** do NOT delete `UnifiedDashboard`/`Merged*`/`/old/dashboard.astro` — client wants old-vs-new side-by-side. Blocks Phase 3 retirement + `AdminDashboardCard` drop + Phase 5 orphan-tree removal until sign-off.
- **Home rework coming (user):** keep `TriageStrip` on top + merge the full `/feed` page contents beneath it, dropping today's quick-start cards + Your Feeds. Coordinate `[TRIAGE-RESTYLE]` with that.
- **Phase 4 SoT = `plan/role-studios/phase-4-nudges.md`** (decisions A/B/C/D locked; nudge gates already exist in `current-user.ts`: `isStudent`/`isTeacher`/`isCreator`/`hasCompletedCourse`). `/become-a-teacher` is a STUB; the real `BecomeATeacherPage` is orphaned — wire it.
- **Verification recipe:** `.scratch/verify-creating.sh` + `verify-teaching.sh` (login → capture `peerloop_access` Set-Cookie [Secure, so curl over http won't jar it — pass as explicit `Cookie:` header] → fetch routes → assert). Avoid inline `for` loops in Bash (sandbox breaks them) — run from a script file.
- **MEM-CAP now OVER cap** — this conv's memory edits pushed MEMORY.md past the byte cap; `/r-prune-memory` (#17) increasingly due.
- Code committed in Step 6 (pre-commit HEAD; new untracked `src/pages/{creating,teaching}/` + `TriageStrip.tsx`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
