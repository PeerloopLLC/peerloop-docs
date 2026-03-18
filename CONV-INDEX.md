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
