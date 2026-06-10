# State — Conv 257 (2026-06-09 ~21:05)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built ROLE-STUDIOS **Phase 4 — the flywheel progression-nudge layer**, completing **all 5 placements** (not just the planned "simplest two"). Created `ProgressionNudge` (Matt-native self-gating client island; transitions student-to-teacher / teacher-to-creator; variants card/banner/inline; reads the client current-user store and renders null when ineligible). Ported the two apply destinations to root — `/creating/apply` (MOVE from /old, `@stand-in`, auth-gated) and `/become-a-teacher` (mounts the orphaned `BecomeATeacherPage`, public LandingLayout) — which also repaired 7 previously-dangling root links. Placements: ① S→T card on the live course `about` tab, ③ S→T banner on Home; ④ T→C card on `/teaching` overview, ⑤ T→C inline on the taught course. Placement ② retired (its target `CourseDetail.tsx` was orphaned dead code → its live equivalent IS ①, which was pulled forward). All 5 baseline gates green this conv (tsc 0 / astro-check 0-0-0 / lint / test 6479-6479 / build). T→C verified in-browser via D1 user-classification + manual login (the /chrome bridge proved unreliable for client-gated islands).

## Completed

- [x] `ProgressionNudge` component — Matt-native self-gating island, 2 transitions, 3 variants (`src/components/progression/ProgressionNudge.tsx`)
- [x] `/creating/apply` ported to root (MOVE from /old, `@stand-in`, AppLayout, auth-gated)
- [x] `/become-a-teacher` wired to root (mounts orphaned `BecomeATeacherPage`, public) + deleted /old stub
- [x] All 5 nudge placements live: ①③ S→T (course about + home), ④⑤ T→C (/teaching overview + taught course); ② retired
- [x] Repaired 7 dangling root links (AppNavbar, notifications, 2 emails, Footer, StoriesBrowse, 2 marketing sections)
- [x] 5-gate baseline green this conv (tsc / astro-check / lint / test 6479-6479 / build) + routes smoke-tested + T→C confirmed in-browser
- [x] [NUDGE-BUILD] #24 done; design doc `plan/role-studios/phase-4-nudges.md` updated (build outcome, dead-② finding, verification, seed eligibility map); `url-routing.md` corrected

## Remaining

- [ ] [ROLE-STUDIOS] #1 [Opus] — multi-conv. Phase 4 ✅. Remaining: Phase 3 retirement of UnifiedDashboard (🔴 BLOCKED on client old-vs-new comparison) + `AppNavbar.tsx:97` fix; Phase 5 cleanup; per-workspace admin model-A deep-links. SoT PLAN.md § ROLE-STUDIOS.
- [ ] [NUDGE-TC] #26 [Opus] — **next conv.** ROLE-STUDIOS Phase 4 remainder: (1) T→C **v2 progression-gap** — gate ⑤ on "taught the last course in a progression with no follow-on" (`progression_position === course_count`); needs a data signal + a **semantics decision** first (what counts as "no follow-on"). (2) Finish render-checks: S→T (amanda.lee/jennifer.kim → ③ home + ① course `/course/vibe-coding-101`|`/course/intro-to-claude-code`) + negative (guy-rymberg → nothing). (3) Optional 2nd S→T on course My-Sessions tab. SoT `plan/role-studios/phase-4-nudges.md`.
- [ ] [COURSEDETAIL-DEAD] #28 — delete orphaned `src/components/courses/CourseDetail.tsx` (no imports, last touched Conv 050).
- [ ] [BRIDGE-MEM] #27 — add memory: /chrome bridge live-DOM can diverge from served HTML for client-gated islands; D1-classify + manual login is the reliable method. Grep memory dir first.
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13
- [ ] [PREFLIP-WT] #14 (KEEP until client-vet) · [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16
- [ ] [MEM-CAP] #17 (MEMORY.md ~83% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #25

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] [Opus] · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #25 [V217-WATCH] · #26 [NUDGE-TC] [Opus] · #27 [BRIDGE-MEM] · #28 [COURSEDETAIL-DEAD]

## Key Context

- **Phase 4 design SoT:** `plan/role-studios/phase-4-nudges.md` — now reflects all-5-live, the dead-② finding, verification status, and the seed eligibility map.
- **`ProgressionNudge` is self-gating** — reads `useCurrentUser()`, renders null when ineligible. So placements are 2-edit drop-ins (import + tag), no prop threading. S→T gates `isStudent && !isTeacher && completed` (courseId for per-course, else `completedCourseCount>0`); T→C gates `isTeacher && !isCreator` (v1). Mount `client:only="react"` (home) or `client:load` (course/teaching pages in the Astro shell).
- **Seed eligibility map (local D1, password `Peerloop2`):** S→T → amanda.lee, jennifer.kim · T→C → marcus.t, sarah.miller · none → guy-rymberg (teacher+creator), gabriel-rymberg (creator), david.r (enrolled, 0 completed). Sarah is teacher+student so Home (S→T only) correctly shows nothing for her; her nudges are on `/teaching` + `/teaching/courses/crs-ai-tools-overview`.
- **`isActiveTeacher` keys on cert `is_active=1`** (DB) → `cert.isActive` (store). `teacher_certifications.user_id` (not teacher_id); `enrollments.student_id`.
- **/chrome bridge caveat:** its live DOM diverged from served HTML for client-gated islands (View-Transition/hydration). For nudge/island visual verification prefer D1-classify + manual login or curl of served HTML. (→ [BRIDGE-MEM] #27.)
- **MOVE rule applied:** both /old apply pages deleted (Conv-250 RTMIG-4 = MOVE; zero inbound links; client-comparison hold is dashboard-only).
- Code committed in Step 6 (pre-commit HEAD; new untracked `src/components/progression/` + `src/pages/{become-a-teacher,creating/apply}.astro`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
