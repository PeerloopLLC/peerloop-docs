# State — Conv 119 (2026-04-14 ~21:18)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 119 shipped COMMUNITY-RESOURCES Phase 7 (3 new test files, 50 tests passing — full auth matrix across all 6 endpoints). Research into a UI gate mismatch ([UI-ADMIN-GATE]) uncovered widespread role drift: `community_members.member_role='teacher'` is permitted by schema and seeded in dev, but no application code writes it — yet 20+ UI/type/API sites consume it. Decision: kill it (option a), re-derive "Communities where I'm teaching" from `teacher_certifications JOIN courses ON community_id` (option B). Sequencing Z: pause COMMUNITY-RESOURCES P8/P9 + #26 minimum fix, do the kill first next conv. Filed tasks #28 (COMMUNITY-TEACHER-KILL) and #29 (ROLE-AUDIT).

## Completed

- [x] COMMUNITY-RESOURCES Phase 7 — 3 test files, 50 tests passing, auth matrix + validation for all 6 endpoints
- [x] Role-model audit — confirmed `CurrentUser.isAdmin` is clean; identified `community_members.member_role='teacher'` as dead code

## Remaining

### Next conv — COMMUNITY-TEACHER-KILL first (blocks #18, #19, #26)

- [ ] #28 COMMUNITY-TEACHER-KILL — retire `member_role='teacher'` across schema + seed + types + 6 Astro + 4 components + docs + tests; re-derive "teaching communities" from `teacher_certifications`

### After the kill

- [ ] #18 COMMUNITY-RESOURCES Phase 8 (PLATO `upload-community-resources` step)
- [ ] #19 COMMUNITY-RESOURCES Phase 9 (Docs — DB-API + r2-storage.md + downloadUrl pattern)
- [ ] #32 Phase 7 follow-up — multipart file-upload happy-path tests
- [ ] #29 ROLE-AUDIT — systematic sweep for non-CurrentUser role checks (depends on #28)

### Carried forward

- [ ] #1 [IN] gh CLI on MacMiniM4-Pro
- [ ] #2 [EM] email notification for session invites
- [ ] #3 [AS] auth-sessions.md refresh-token-as-fallback docs
- [ ] #4 [CSS] /discover/members bottom-row clipping
- [ ] #5 [AD] Auth docs drift check
- [ ] #6 [DGH] DEPLOYMENT.GHACTIONS
- [ ] #7 [DP] DEPLOYMENT.PROD
- [ ] #8 [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #9 [RS] reset-d1.js orphan-table drop
- [ ] #10 [DS] dev:staging adapter 13 regression
- [ ] #11 [PE] platform_stats environment marker
- [ ] #12 [SG] sync-gaps.sh .astro/ exclusion
- [ ] #13 [BL] /course/[slug]/certificate broken link
- [ ] #14 [TL] no-paste-tokens-in-chat rule
- [ ] #15 [GI] .claude/scheduled_tasks.lock in gitignore
- [ ] #16 [CD] Bash cwd drift — git -C enforcement
- [ ] #20 [COURSE-RES-AUTH] past-student download check
- [ ] #21 [BKC-NEXT] SessionBooking next-month upper bound
- [ ] #22 [BKC-FETCH] SessionBooking 4-week fetch horizon
- [ ] #23 [DBSCHEMA-CRES] _DB-SCHEMA.md community_resources stale
- [ ] #24 [NAV-DISABLED-AUDIT] AppNavbar.tsx Conv 110 disabled items
- [ ] #25 [PLATO-FLYWHEEL-CREATOR-GAP] creator-lifecycle audit
- [ ] #27 [CODECHECK-SQL] /w-codecheck schema-aware SQL column-name lint
- [ ] #30 [SG2] sync-gaps.sh false-negative — missed 3 new test files this conv
- [ ] #31 [API-COMM-REVIEW] API-COMMUNITY.md review for Conv 118 endpoint changes

### Absorbed — do not close separately

- [ ] #26 [UI-ADMIN-GATE] — absorbed into #28; closes when kill lands

## TodoWrite Items

All 29 pending tasks captured in Remaining above. See TaskList in conv for IDs.

## Key Context

### Role-model ground truth (from GLOSSARY §1 + `CurrentUser`)

| Concept | DB source | CurrentUser method | Scope |
|---|---|---|---|
| Admin | `users.is_admin` | `isAdmin` (flag) | platform |
| Teacher | `teacher_certifications` | `isTeacherFor(courseId)` | **course** |
| Creator | `can_create_courses` + `courses` | `isCreatorFor(courseId)` / `hasCreatedCourses()` | **course** |
| Platform Moderator | `users.can_moderate_courses` | `canModerateCourses` | platform |
| Community Moderator | `community_moderators` | `isCommunityModeratorFor(communityId)` | **community** |

`/api/me/full` (`src/pages/api/me/full.ts`, 635 lines) is the single source — SSR can call the loader directly without HTTP round-trip.

### COMMUNITY-TEACHER-KILL scope map

**Schema + seed:**
- `migrations/0001_schema.sql:222` — `CHECK (member_role IN ('creator','teacher','member'))` → narrow to `('creator','member')`
- `migrations-dev/0001_seed_dev.sql:387-409` — 7+ rows with `'teacher'` → change to `'member'`

**Types:**
- `src/lib/db/types.ts:156` — narrow union
- `src/lib/current-user.ts:150` — narrow union
- `src/pages/api/me/full.ts:552` — type cast narrowing

**UI consumers (6 Astro + 4 components):**
- 6 Astro `canUploadResources` gates: `community/[slug]/{index,courses,members,resources}.astro`, `discover/community/[slug]/{index,[...tab]}.astro`
- `CommunityTabs.tsx` — consume `useCurrentUser()` for `isAdmin`
- `CommunityRolePillFilters.tsx:47` — "Teaching" pill
- `components/discover/ExploreCommunities.tsx:92` — `teachingCount` badge
- `components/discover/tabs/CommunityTeachingTab.tsx` — entire tab (rewrite per option B)
- `components/creators/communities/CommunityManagement.tsx:352-356` — badge rendering

**Re-derivation (option B) for "teaching communities":**
Source is `teacher_certifications JOIN courses ON community_id`. `CurrentUser` already has `teacherCertifications` Map — consider adding `getTeachingCommunityIds()` or similar derived getter. This replaces the data source for `CommunityTeachingTab`, teaching pill, and teachingCount badge.

**Docs:** GLOSSARY.md (retirement note), DB-GUIDE.md (schema change), POLICIES.md (if role tables mention it).

**Tests:** The 3 new test files this conv use only `'creator'` and `'member'` seeds — they survive the CHECK narrowing unchanged. Verify existing community tests don't depend on `'teacher'` seed values.

### Phase 7 test file notes (for #28 executor)

- `tests/api/me/communities/[slug]/resources/index.test.ts` — auth matrix via `mockSessionResult` + `vi.mock('@/lib/auth')`
- `tests/api/me/communities/[slug]/resources/[resourceId].test.ts` — `vi.mock('@/lib/r2')` stubs `deleteFromR2` + `getR2Optional`; DELETE test asserts `deleteFromR2` called with specific r2_key
- `tests/api/community-resources/[id]/download.test.ts` — R2 mock returns `ReadableStream` + size; distinct auth model (any member, not just creator/admin)

All mock paths use relative `../../../../../../src/...` — double-check when adding new test files at different depths.

### What's NOT broken (good news)

- `CurrentUser.isAdmin` flow: `users.is_admin` → `/api/me/full` → `CurrentUser.isAdmin` — clean, course-independent.
- `canModerateFor(courseId)` correctly combines admin + creator + platform-mod (can_moderate_courses) + community-mod (community_moderators).
- No drift in moderator state. Teacher drift is isolated to `member_role='teacher'`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
