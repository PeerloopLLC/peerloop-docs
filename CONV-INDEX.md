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

## Conv 014
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: CURRENTUSER-OPTIMIZE Phases 2-4. Phase 2: enriched UserEnrollment (hasReview, courseDuration, courseSessionCount), refactored StudentDashboard from fetch to useCurrentUser(). Phase 3: folded community_count into creator-dashboard, removed /api/me/communities fetch. Phase 4: UserCommunityMembership type, getCommunityMemberships()/isMemberOf()/getTownhall(), discussionFeedEnabled on CourseMetadata, UserFeedLink + getFeeds(). Created FEEDS-HUB block in PLAN.md. 5930 Vitest + 14 E2E tests passing.

## Conv 015
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: CURRENTUSER-OPTIMIZE Phase 5 (block complete) + FEEDS-HUB PAGE/NAVIGATION + FEED-INTEL Phase 1. Phase 5: MyFeeds dashboard card on 3 dashboards, FeedSlidePanel refactored (2 API calls → 0). FEEDS-HUB: /feeds page with FeedsHub component, navbar "My Feeds" changed from slideout to /feeds link, community hub cross-link. FEED-INTEL: D1 activity index alongside Stream.io (CQRS hybrid) — feed_visits + feed_activities tables, dual-write in 3 post endpoints, visit recording, GET /api/me/feed-badges endpoint, badge counts on FeedsHub + MyFeeds card. 5941 Vitest + 10 E2E tests passing.

## Conv 016
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: FEEDS-HUB block complete (#44). FEED-INTEL Phase 1 follow-ups: verified VALUES SQL on D1, added comment dual-write (5 endpoints total), fixed enrollments.student_id bug in feed-badges, deleted FeedSlidePanel, created course comments/reactions endpoints, auto-routing FeedActivityCard via deriveFeedApiBasePath(). Created docs/as-designed/feeds.md (Stream data model + CQRS architecture). Stripped tech-NNN: prefixes from 7 architecture docs. 7 new API integration tests, 2 E2E tests. SMART-FEED concept captured in PLAN.md for next conv.

## Conv 017
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: SMART-FEED design + implementation. Detailed design discussion (scoring signals, discovery cards, access control, feed privacy). Plan Mode verification caught hybrid query strategy correction (simple D1 selection + app-side scoring vs 7-JOIN CTE), missing idx_feed_activities_actor index, reusable recommendation queries for discovery. Built all 5 phases: schema (feed_public, smart_feed_dismissals, 12 platform_stats params), backend (5 modules in src/lib/smart-feed/), API (GET /api/feeds/smart, POST /api/feeds/smart/dismiss), frontend (SmartFeed.tsx, DiscoveryCard.tsx, feed.astro wired), tests (27 across 3 files). Added getActivitiesByIds() to Stream client. FEED-PRIVACY deferred block added. 339 test files, 5975 tests, zero regressions.

## Conv 018
- Date: 2026-03-19
- Machine: MacMiniM4
- Summary: Smart feed E2E tests + feed seed script. Built scripts/seed-feeds.mjs (14 Stream activities + 17 reactions + D1 dual-write). Added db:seed:feeds:local/staging and db:setup:local:feeds/staging pipeline levels. 6 E2E tests (auth redirect, seeded content, discovery cards, filters, CTA nav, dismiss persistence). SMART-FEED block completed (#45), FEED-INTEL marked complete.

## Conv 019
- Date: 2026-03-20
- Machine: MacMiniM4
- Summary: Added conv-based timecard selection (`conv=NNN`) to /w-timecard-dual skill as alternative to count-based `cNdN`. Uses `git log --grep` to find commits by conv number. Generated 4 retroactive timecards for Conv 010-018. Documented grep false-match caveat (body text mentioning adjacent convs).

## Conv 020
- Date: 2026-03-20
- Machine: MacMiniM4
- Summary: Smart Feed card visual system — source-type color differentiation (primary/secondary/indigo), right-side source image strip, username→profile links, course badge→course links, "Visit feed" action button, "in {feed}" context links. Dashboard navigation ("View Smart Feed" on /learning, /teaching, /creating via MyFeeds). Hydration fixes (client:only="react" for /feeds, /learning). Fixed infinite loop in discovery interleaving when member posts exhausted + discovery cap reached. Stream API 10s timeout. Feed seed script enriched with images (picsum.photos for users/courses/communities), fixed townhall feed_id mismatch. Smart feed page size now admin-tunable via platform_stats. Added IMAGE-MGMT to PLAN (#35). Regenerated page-connections.md with /feeds in AppNavbar.

## Conv 021
- Date: 2026-03-20
- Machine: MacMiniM4
- Summary: Added TodoWrite-gap reminders to /r-eos and /r-docs skill files. Embedded CRITICAL callout in /r-docs Action Plan section and rule in /r-eos Rules section. Added "TodoWrite-Gap Reminders Embedded in Skill Chain" entry to DOC-DECISIONS.md § 3.

## Conv 022
- Date: 2026-03-20
- Machine: MacMiniM4
- Summary: Documentation carryover tasks. (1) Added 0004_feed_activity_index.sql to migrations.md. (2) Fixed sync-gaps.sh — 3 bugs causing 93% false positive rate (index.ts literal matching, regex bracket interpretation, missing route mappings). Added 12 route prefix mappings + 15 two-level me/* sub-route mappings. Documented 15 truly undocumented API endpoints across 5 API docs (admin certificates, admin courses, certificate verification, course homework/discussion-feed, me/certificates, notifications management, session invites). 225/225 routes now pass gap detection. Added sync-gaps and public-endpoint-routing decisions to DOC-DECISIONS.md.

## Conv 023
- Date: 2026-03-20
- Machine: MacMiniM4
- Summary: IMAGES-DISPLAY block — show entity images across all UI. Phase 1: Unified avatar fallback pattern (gradient+initial), eliminated all 15 placehold.co references, added `xs` size to UserAvatar. Phase 2: Community cover images rendered on detail pages, index, discover, creator dashboard, FeedsHub. Phase 3: FeedsHub images via UserFeedLink.imageUrl, /api/me/full extended with community cover_image_url. Additional: feed avatar enrichment on read (enrichActivitiesWithAvatars), course session teacher avatars, community courses tab thumbnails, MyFeeds dashboard images. Seed data cleanup: image URLs inlined in INSERTs, The Commons cover moved to core seed. 24 source + 3 test + 2 seed files.

## Conv 024
- Date: 2026-03-24
- Machine: MacMiniM4-Pro
- Summary: Planning conv. Completed CURRENTUSER block (archived as #47). Created SESSION-FIX block with 14 sub-blocks covering session lifecycle gaps: no-show detection, auto-complete stale sessions, BBB room cleanup, post-session actions, module backfill, enrollment completion tracking, stale cleanup endpoint, recording R2 replication, teacher invite UX, post-session navigation, instant-booking sessions visibility bug, BBB "both Leave" scenario, BBB learning analytics. Created separate TEACHER-COURSE-VIEW block for teacher course detail page. Added avatar/image fallback pattern to DEVELOPMENT-GUIDE.md. Added inline-doc-update rule to DOC-DECISIONS.md.

## Conv 025
- Date: 2026-03-24
- Machine: MacMiniM4-Pro
- Summary: SESSION-FIX implementation — 4 sub-blocks completed. SESSIONS-BUG: CourseTabs missing `in_progress`/`no_show` status rendering (API was correct, UI silently dropped them); added session progress bar with booked/unbooked counts. BBB-LEAVE: empty-room detection in webhook handler (`detectEmptyRoomAndComplete()`), role-specific UX guidance banners. NO-SHOW: `detectNoShows()` + `notifySessionNoShow()` + `session_no_show` notification type + admin cleanup endpoint. AUTO-COMPLETE: `detectStaleInProgress()` wired into cleanup endpoint + client-side "Complete Session Now" (teacher) / "Message teacher" (student) + `getInitialState()` fix for `in_progress` status + timer race condition fix. Bonus: linkified URLs in MessageThread, CRON-CLEANUP deferred block. Added Solution Quality override to CLAUDE.md (present durable options, not just simplest).
