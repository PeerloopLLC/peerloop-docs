# Conversation Index

Continuation of SESSION-INDEX.md (Sessions 0–393). Conv numbering starts at 001.

## Conv 001
- Date: 2026-03-15
- Machine: MacMiniM4-Pro
- Summary: Retire duplicate w-* skills, consolidate r-docs, Conv terminology cleanup

## Conv 002
- Date: 2026-03-15
- Machine: MacMiniM4-Pro
- Summary: Fix session timezone bug — UTC normalization for all session times

## Conv 003
- Date: 2026-03-16
- Machine: MacMiniM4-Pro
- Summary: Timezone-safe test infrastructure + clock abstraction

## Conv 004
- Date: 2026-03-16
- Machine: MacMiniM4-Pro
- Summary: Session Invite feature — teacher-initiated instant booking, RFC CD-037 cleanup

## Conv 005
- Date: 2026-03-17
- Machine: MacMiniM4
- Summary: Conv system alignment on MacMiniM4, skill portability (portable paths via $CLAUDE_PROJECT_DIR), sync-gaps fix

## Conv 006
- Date: 2026-03-18
- Machine: MacMiniM4
- Summary: Add Fraser Gorrie seed user for email testing, rename DB setup scripts to additive pattern (db:setup:{target}:{level})

## Conv 007
- Date: 2026-03-18
- Machine: MacMiniM4-Pro
- Summary: Seed data completeness audit — all 59 tables now seeded. Added avatars, Gabriel Stripe/availability, last_login, availability_overrides, social URLs, session_invites, moderator_invites. Fixed MyStudents test (snake_case→camelCase mock data). Added 3 deferred PLAN blocks: CERT-APPROVAL PDF gen, FILE-UPLOADS avatar, RECORDING-PERSIST.

## Conv 008
- Date: 2026-03-18
- Machine: MacMiniM4-Pro
- Summary: ENROLL-AVAIL block — enrollment guards (creator/teacher self-enrollment, no-teachers block + notifications), re-enrollment after completion (partial unique index, retake dialog), pre-purchase teacher availability preview (public endpoint, CourseAvailabilityPreview component, configurable 30-day window). 15 files changed, 4 new. 5839 tests passing.

## Conv 009
- Date: 2026-03-18
- Machine: MacMiniM4-Pro
- Summary: Documentation cleanup from Conv 008 (ENROLL-AVAIL). Updated 4 stale docs: COMPONENTS.md (added CourseAvailabilityPreview + EnrollButton), DB-API.md (availability-summary endpoint, /api/me/full, enrollment guards on admin endpoint), DEVELOPMENT-GUIDE.md (enrollment guards pattern, availability window, teaching_active), API-REFERENCE.md (index update). Also fixed 2 CLI-QUICKREF gaps (db:seed:booking:staging, route-matrix).

## Conv 010
- Date: 2026-03-18
- Machine: MacMiniM4
- Summary: Teaching/Creating dashboard improvements. Fixed seed data (assigned_teacher_id on Guy's enrollments). Added role-specific earnings labels (Teaching Earnings / Creator Earnings). Added Current/Past tabbed lists for students on Teacher dashboard and teachers on Creator dashboard. Established DATE-FORMAT decision — canonical UTC ISO 8601 with Z for all timestamps, standardized formatters in timezone.ts (formatDateUTC, formatDateTimeUTC, toUTCISOString). Fixed /r-resume false-positive stale context warning. Created global ~/.claude/CLAUDE.md for cross-session directives. 5 new component/test files, 240 dashboard tests passing.

## Conv 011
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: DATE-FORMAT migration — full 5-phase execution across 130+ files. Phase 1: 66 schema defaults to strftime ISO 8601 with %f milliseconds. Phase 2: seed data normalized. Phase 3: 49 files migrated from SQL datetime('now') to parameterized toUTCISOString(), 17 files migrated from now() to toUTCISOString(), now() deprecated. Phase 4: 58 components migrated from raw toLocaleDateString() to formatDateUTC()/formatDateTimeUTC(). Phase 5: 5901 tests passing, 1 test regex fix. Zero regressions.

## Conv 012
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: Workflow infrastructure — RESUME-STATE.md becomes transparent TodoWrite persistence (r-start Step 7 auto-transfers tasks, deletes file). Fixed EnrollButton.tsx TS error (type assertion on res.json()). Documented postinstall npm script and 9 undocumented API routes in CLI-QUICKREF.md (session-invites, reviews response, materials-feedback, teachers reviews, availability-summary, expectations, db-test, debug/db-env).

## Conv 013
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: CURRENTUSER-OPTIMIZE Phase 1 — version polling for CurrentUser freshness. Added data_version counter on users table, bumpUserDataVersion() helper, GET /api/me/version endpoint, client-side 30s polling. 31 mutation endpoints now bump version. Updated "summary vs. detail" principle to "consume what's loaded". Created seed data verification E2E tests (14 tests, 5 users). Redundancy analysis: /api/me/enrollments ~95% redundant, teacher/creator dashboards ~60-65%. Decided to keep teacher/creator dashboard endpoints as-is (operational data), only refactor StudentDashboard (Phase 2). Added CURRENTUSER-OPTIMIZE block to PLAN.md (5 phases). 5901 Vitest + 14 E2E tests passing.
