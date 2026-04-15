# State — Conv 120 (2026-04-15 ~08:38)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main` (uncommitted changes will be committed in Step 6)

## Summary

Conv 120 landed COMMUNITY-TEACHER-KILL end-to-end: schema CHECK narrowed (`community_members.member_role` now `'creator' | 'member'`), `'teacher'` value retired across schema, seed, types, server, CurrentUser, 3 React sites, 6 Astro pages, and tests. Replaced the dead `member_role='teacher'` signal with server-derived `MeFullResponse.teachingCommunityIds` (joined `teacher_certifications → courses → progressions`). Created `src/lib/permissions.ts` helper `canUploadCommunityResources(membership, isAdmin)` and refactored 6 Astro pages to use it — silently fixed [UI-ADMIN-GATE] (admins were previously locked out of upload buttons). Full test suite green: 371 files / 6447 tests. COMMUNITY-RESOURCES P8/P9 now unblocked.

## Completed

- [x] **COMMUNITY-TEACHER-KILL — full block** (#1)
  - Schema CHECK narrowed to `('creator','member')` + 4-line explanatory comment
  - 5 dev seed rows: `'teacher'` → `'member'`
  - 3 union type narrowings (`db/types.ts`, `current-user.ts`, `api/me/full.ts`)
  - New `fetchTeachingCommunityIds()` server query
  - `MeFullResponse.teachingCommunityIds: string[]` (optional for cache compat)
  - `CurrentUser.getTeachingCommunityIds()` + `isTeachingIn()` + `getFeeds()` re-derives `'teacher'` role
  - 3 React sites: ExploreCommunities, CommunityRolePillFilters, CommunityTeachingTab
  - CommunityManagement.tsx member badge no longer branches on teacher
  - 6 Astro pages → `canUploadCommunityResources(membership, isAdmin)` helper
  - New `src/lib/permissions.ts` + 5 unit tests
  - 2 ORDER BY CASE cleanups (members.ts, communities.ts SSR loader)
  - 3 test fixture updates (community-feeds, members.test.ts, RolePillFilters mock)
  - DECISIONS.md retirement entry with derivation SQL + UI-ADMIN-GATE fix note
  - Local D1 reset + reseed verified clean (CHECK accepts no `'teacher'`)
  - [UI-ADMIN-GATE] silently fixed (admins now see upload control)

## Remaining

### Now unblocked by COMMUNITY-TEACHER-KILL completion

- [ ] #2 COMMUNITY-RESOURCES Phase 8 — PLATO `upload-community-resources` step
- [ ] #3 COMMUNITY-RESOURCES Phase 9 — Docs (DB-API + r2-storage.md + downloadUrl pattern)
- [ ] #5 ROLE-AUDIT — sweep non-CurrentUser role checks
- [ ] #4 Phase 7 follow-up — multipart file-upload happy-path tests

### Discovered this conv

- [ ] #31 [CRES-TEST-PATH] — pre-existing tsc error in `tests/api/community-resources/[id]/download.test.ts:29` (off-by-one `../`; vitest aliases hide at runtime)
- [ ] #32 [TC-LIB-COUNT] — TEST-COVERAGE.md "Lib Tests (7 files)" header stale (table has 13 rows)
- [ ] #33 [TC-LIB-SUBDIR] — Lib Tests table includes `tests/lib/video/bbb.test.ts` from subdirectory while header scopes to flat `tests/lib/`
- [ ] #34 [DBSCHEMA-MR] — `_DB-SCHEMA.md` may need member_role CHECK narrowing reflected (related to #25)

### Carried forward

- [ ] #6 [IN] gh CLI on MacMiniM4-Pro
- [ ] #7 [EM] Email notification for session invites
- [ ] #8 [AS] auth-sessions.md refresh-token-as-fallback docs
- [ ] #9 [CSS] /discover/members bottom-row clipping
- [ ] #10 [AD] Auth docs drift check
- [ ] #11 [DGH] DEPLOYMENT.GHACTIONS
- [ ] #12 [DP] DEPLOYMENT.PROD
- [ ] #13 [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #14 [RS] reset-d1.js orphan-table drop
- [ ] #15 [DS] dev:staging adapter 13 regression
- [ ] #16 [PE] platform_stats environment marker
- [ ] #17 [SG] sync-gaps.sh .astro/ exclusion
- [ ] #18 [BL] /course/[slug]/certificate broken link
- [ ] #19 [TL] no-paste-tokens-in-chat rule
- [ ] #20 [GI] .claude/scheduled_tasks.lock in gitignore
- [ ] #21 [CD] Bash cwd drift — git -C enforcement
- [ ] #22 [COURSE-RES-AUTH] past-student download check
- [ ] #23 [BKC-NEXT] SessionBooking next-month upper bound
- [ ] #24 [BKC-FETCH] SessionBooking 4-week fetch horizon
- [ ] #25 [DBSCHEMA-CRES] _DB-SCHEMA.md community_resources stale
- [ ] #26 [NAV-DISABLED-AUDIT] AppNavbar.tsx Conv 110 disabled items
- [ ] #27 [PLATO-FLYWHEEL-CREATOR-GAP] creator-lifecycle audit
- [ ] #28 [CODECHECK-SQL] schema-aware SQL column-name lint
- [ ] #29 [SG2] sync-gaps.sh false-negative — confirmed live this conv (only flagged 1 of 6 modified test files)
- [ ] #30 [API-COMM-REVIEW] API-COMMUNITY.md review for Conv 118 changes (note: agent updated parts of API-COMMUNITY.md this conv but full review still needed)

## TodoWrite Items

All 33 pending tasks captured in Remaining above. See TaskList in conv for IDs.

## Key Context

### COMMUNITY-TEACHER-KILL — what landed and what to know

**Source of truth for "teaching communities":**
```sql
teacher_certifications tc
  JOIN courses c ON tc.course_id = c.id
  JOIN progressions p ON c.progression_id = p.id
WHERE tc.user_id = ? AND tc.is_active = 1
  AND p.is_active = 1 AND p.deleted_at IS NULL
  AND c.is_active = 1 AND c.deleted_at IS NULL
```

The result is exposed as:
- `MeFullResponse.teachingCommunityIds: string[]` (optional — `?? []` fallback in CurrentUser constructor for cached payloads)
- `CurrentUser.getTeachingCommunityIds(): string[]`
- `CurrentUser.isTeachingIn(communityId): boolean`
- `getFeeds()` pushes `'teacher'` role when `teachingCommunityIds.has(communityId)` — preserves prior role-annotation behavior

**Edge case:** A teacher cert for a course without `progression_id` yields no teaching community (matches platform semantics — unstructured courses don't belong to community feeds).

### Pre-release schema mutability is now a documented decision

User confirmed in Conv 120: "we are still pre-release and we can change schema as we need and propogate that to staging without worry." This collapses the rigorous "incremental migration" option for CHECK narrowings and similar operations until a release-candidate flag flips. Defer migration ceremony.

### Loader-exposes-flags + pure-helper composition pattern

New pattern landed via `src/lib/permissions.ts` + `fetchCommunityDetailData.isAdmin`:
- SSR loader returns raw flags (e.g., `isAdmin: boolean`)
- Pure helper composes the gating logic (e.g., `canUploadCommunityResources(membership, isAdmin)`)
- Astro pages call the helper, keeping JSX declarative

If this pattern accretes a 2nd use site, document it in `docs/reference/DEVELOPMENT-GUIDE.md`. Premature now.

### COMMUNITY-TEACHER-KILL caveats for follow-up work

**For PLATO Phase 8 (#2):**
- Scenario seeds must use `'creator' | 'member'` only — schema CHECK rejects `'teacher'`
- Role-derived UI checkpoints must read teaching status from `currentUser.getTeachingCommunityIds()` or backend equivalents, NOT from any `member_role === 'teacher'` filter

**For Phase 9 docs (#3):**
- DB-API.md community resources upload section should reference `src/lib/permissions.ts::canUploadCommunityResources`
- The access-gate copy needs to describe the 3-rule model: admin OR creator (no teacher leg)
- r2-storage.md should describe the `downloadUrl` SSR pre-compute pattern

**For ROLE-AUDIT (#5):**
- Already swept: `community_members.member_role`. Remaining sweep targets: any code reading roles from raw DB rows instead of `CurrentUser` methods. Memory notes `currentuser_role_lookup` are relevant context.
- The 3 React sites this kill touched (`memberRole === 'teacher'` reads) are the template for what to look for in other role values.

### Test workflow reminders

- Full test suite is the only complete coverage check for schema CHECK changes — targeted runs miss test-only seed drift (Conv 120 caught one such test only on full suite)
- `npm run db:reset:local && npm run db:setup:local:dev` is exhaustive proof that no rows of a retired CHECK value survive in seed
- Pre-existing tsc-only errors (#31) are gated behind `npx tsc --noEmit` but not `npm test` because vitest path aliases differ from tsc resolution

### Session files

- `docs/sessions/2026-04/20260415_0834 Extract.md` — pruned (Learnings + Decisions extracted)
- `docs/sessions/2026-04/20260415_0834 Learnings.md`
- `docs/sessions/2026-04/20260415_0834 Decisions.md`

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
