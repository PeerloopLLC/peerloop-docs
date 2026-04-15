# State — Conv 124 (2026-04-15 ~14:55)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main` (uncommitted Conv-124 changes will be committed in Step 6 of /r-end)

## Summary

Conv 124 closed COMMUNITY-RESOURCES (Phase 8 PLATO step landed) and drained two ROLE-AUDIT follow-ups: [RA-CLI] migrated `MyCourses.tsx` to `useCurrentUser()` and uncovered + deleted dead `UserProfile.tsx` (299 LOC + 385 test); [RA-API] then deleted the now-orphaned `/api/me/enrollments` endpoint (+ its 458-line test) and confirmed `/api/me/stats` never existed (phantom URL absorbed by `.catch(() => null)` in the dead component). All baselines green throughout: full test suite 369/369 files / 6392/6392 tests at the close.

## Completed

- [x] [P8] COMMUNITY-RESOURCES Phase 8 — PLATO `upload-community-resources` step (closes COMMUNITY-RESOURCES block)
- [x] [RA-CLI] MyCourses → useCurrentUser; UserProfile.tsx + test deleted (dead code)
- [x] [RA-API] /api/me/enrollments deleted (endpoint + test); /api/me/stats confirmed never existed

## Remaining

### Substantial blocks (need prioritization)
- [ ] #2 [EM] Email notification for session invites
- [ ] #3 [DGH] DEPLOYMENT.GHACTIONS
- [ ] #4 [DP] DEPLOYMENT.PROD
- [ ] #5 [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #6 [PFC] PLATO-FLYWHEEL-CREATOR-GAP — creator-lifecycle audit
- [ ] #7 [CCS] CODECHECK-SQL — schema-aware SQL column-name lint (would have caught Conv-117 regression)
- [ ] #8 [ACR] API-COMM-REVIEW — API-COMMUNITY.md review for Conv 118 changes
- [ ] #9 [DSA] DBAPI-SUBCOM-AUDIT — full §Communities + §Authentication audit
- [ ] #11 [RA-SSR] Collapse course/[slug]/*.astro SSR queries into fetchCourseDetailData loader (~3-4 hr)
- [ ] #12 [RA-JWT] Decision: embed isAdmin in JWT claims (do NOT implement without explicit approval — security/product call)
- [ ] #22 [ADR] Auth-doc review — confirm Conv 123 ROLE-AUDIT changes propagated (4 docs flagged by tech-doc-sweep)

### Medium
- [ ] #13 [MPT] Multipart file-upload happy-path tests (R2 mocking required)
- [ ] #14 [BKN] BKC-NEXT — SessionBooking next-month upper bound (design call)
- [ ] #15 [BKF] BKC-FETCH — SessionBooking 4-week fetch horizon (design call)
- [ ] #16 [CRE] COURSE-RES-AUTH-EDGE — disputed + soft-deleted enrollment gate (pending product call)

### Small / housekeeping
- [ ] #17 [CLM-RS] CLAUDE.md §Known issue update — note reset-d1 automation (manual recovery as fallback)
- [ ] #18 [IN] Install gh CLI on MacMiniM4-Pro
- [ ] #19 [CSS] /discover/members bottom-row clipping fix (root-caused; needs browser verification)
- [ ] #20 [CTR] CommunityTabs.Resource.uploadedBy.role — drop unused field

### Conv-124 micro-discoveries
- [ ] #23 [ASTRO-CT] Note astro-check file count includes generated content.d.ts files in dev guide
- [ ] #24 [HMP] Canonicalize hook-mock test pattern in DEVELOPMENT-GUIDE.md (used in TeacherDashboard, MyCourses, etc.)

## TodoWrite Items

All 21 pending tasks above will be transferred to TodoWrite by `/r-start` in Conv 125.

## Key Context

### Conv 124 artifacts (fresh, load-bearing)

- **`tests/plato/steps/upload-community-resources.step.ts`** — new PLATO step. Two important design points:
  - Uses JSON-link path (no R2 mocking). Multipart file-upload tests are the separate `[MPT]` task.
  - Uses **discovery GET pattern** for cross-step state: first action is `GET /api/me/communities` with `provides: { communitySlug: 'communities.findBy(name,$persona.communityName).slug' }`. PLATO context is per-step, not per-scenario — `$context.createCommunity.communitySlug` from the prior step is NOT visible.
- **`src/components/courses/MyCourses.tsx`** — now reads enrollments from `user.getEnrollments()` (UserEnrollment type, flat shape). Healing path triggers `refreshCurrentUser()` after `healPendingSessions()` returns `true`. Loading state gates on `authStatus === 'loading' || (authStatus === 'authenticated' && user === null)`.
- **`tests/components/courses/MyCourses.test.tsx`** — canonical example of hook-mocked component test (mocks `@/lib/current-user` with module-scoped `let mockEnrollments/mockAuthStatus/mockUserPresent` reset in `beforeEach`). See task `[HMP]` to canonicalize this pattern.

### Discoveries that should not need re-finding

- `/api/me/stats` **never existed** as a `src/pages/api/me/stats.ts` file. UserProfile.tsx was hitting a phantom URL silently absorbed by `.catch(() => null)`. Don't waste time looking for it again.
- `UserProfile.tsx` (now deleted) was unreachable — zero callers across `src/`, `.astro`, dynamic imports. The Conv-123 audit's classification of it as a "shared profile component" was based on its own doc comment, not actual call graph. Reachability check should precede migration recommendations.
- ROLE-AUDIT report (`docs/reference/role-audit-2026-04-15.md`) — A.1 marked migrated, A.2 marked deleted (component dead), [RA-API] follow-up actioned. Three [RA-*] follow-ups remain pending.

### Patterns named this conv

- **PLATO cross-step discovery GET** — formalized via `upload-community-resources.step.ts` mirroring `add-modules.step.ts`. Pattern is documented in `tests/plato/PLATO-GUIDE.md` §"Discovery GET Pattern" (line 191) — this conv adds a second downstream consumer.
- **Audit reachability check** — every UI component in an audit report should be classified REACHABLE / DEAD via grep before recommending migration work. Dead → delete; reachable → migrate.

### Commits this conv (pre-/r-end)

- Docs: `d6fd476` (Conv 124 start), `10ef35f` (RESUME-STATE.md delete). Uncommitted: `route-api-map.md` regen + Conv-124 docs/sessions files (will be committed in /r-end Step 6).
- Code: `0323a3b` (PLATO Phase 8), `7f326ce` (MyCourses → useCurrentUser + UserProfile delete). Uncommitted: endpoint + test deletions + StudentDashboard test cleanup + route-map regen (will be committed in /r-end Step 6).

### Notable non-issues (verified this conv)

- `/api/me/profile` and `/api/me/version` are still legitimately used (ProfileSettings, SecuritySettings, version polling) — only `/api/me/enrollments` was deletable.
- Lint baseline: 1 pre-existing error in `MemberDirectory.tsx` (react-hooks/exhaustive-deps rule not found — config issue, not introduced by Conv 124).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
