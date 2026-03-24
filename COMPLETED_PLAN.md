# COMPLETED_PLAN.md

Terse archive of completed blocks. For detailed task lists and session notes, see `docs/sessions/`.

## Completion Sequence

| Order | Block | Name | Completed |
|-------|-------|------|-----------|
| 1 | 0 | Foundation | 2026-01-07 |
| 2 | 1 | Course Display | 2026-01-07 |
| 3 | 1.8 | Marketing Content & Data Sync | 2026-01-07 |
| 4 | 2 | Enrollment & Payments | 2026-01-07 |
| 5 | 3 | Course Content | 2026-01-07 |
| 6 | 3.5 | Homework System | 2026-01-07 |
| 7 | VIDEO | Video Sessions | 2026-01-20 |
| 8 | TEACHING | S-T Management | 2026-01-21 |
| 9 | ADMIN | Admin Tools | 2026-01-23 |
| 10 | CERTS | Certifications | 2026-01-21 |
| 11 | COMMUNITY | Community Feed | 2026-01-23 |
| 12 | MESSAGING | Private Messaging | 2026-01-22 |
| 13 | NOTIFY | Notifications | 2026-01-23 |
| 14 | CREATOR | Creator Studio | 2026-01-23 |
| 15 | ACCOUNT | Settings | 2026-01-23 |
| 16 | NAVIGATION | Inter-page Connectivity | 2026-01-23 |
| 17 | ONBOARDING | Member Onboarding Profile | 2026-02-22 |
| 18 | MODERATION | Two-Tier Moderator Model | 2026-02-23 |
| 19 | CREATOR-SETUP | Creator Content Setup | 2026-02-23 |
| 20 | BBB | Video Sessions (Post-Enrollment Flow) | 2026-02-24 |
| 21 | S-T-CALENDAR | Availability Calendar & Creator-as-ST | 2026-02-25 |
| 22 | RATINGS | Ratings & Feedback System | 2026-02-26 |
| 23 | TESTING | Test Coverage Expansion (E2E) | 2026-02-27 |
| 24 | E2E-TESTING | Comprehensive E2E Test Coverage | 2026-02-27 |
| 25 | STORY-REMAP | Realign User Stories to Current Routes | 2026-02-27 |
| 26 | BROKENLINKS | Fix Broken Navigation Links | 2026-03-01 |
| 27 | RESEND-DOMAIN | Resend Domain Verification | 2026-03-01 |
| 28 | CREATOR-GATE | Creator Access Gate Hook + Client-Side Cleanup | 2026-03-01 |
| 29 | CERT-AUDIT | ST Certification ID Audit Trail | 2026-03-04 |
| 30 | BOOKING-MODULES | Positional Module Assignment | 2026-03-05 |
| 31 | BOOKING-FOLLOW-UPS | Booking Guardrails & Policies | 2026-03-05 |
| 32 | MESSAGING-UX | Messaging & Notifications UX | 2026-03-05 |
| 33 | MSG-ACCESS | Messaging Access Control | 2026-03-05 |
| 34 | TERMINOLOGY | Platform Terminology Standardization | 2026-03-07 |
| 35 | SKILLS-MIGRATE | Skills 2 Migration | 2026-03-10 |
| 36 | BOOKING | Session Booking Flow | 2026-03-12 |
| 37 | COURSE-PAGE-MERGE | Merge /learn Into Course Detail Page | 2026-03-12 |
| 38 | TERMINOLOGY-CLEANUP | ST Prefix Rename | 2026-03-16 |
| 39 | UTC-TIMES | UTC Timezone Normalization | 2026-03-17 |
| 40 | SESSION-INVITE | Instant Session Booking ("Book Now") | 2026-03-17 |
| 41 | ENROLL-AVAIL | Course Enrollment Guards + Pre-Purchase Availability Preview | 2026-03-18 |
| 42 | DATE-FORMAT | Canonical Date/Time Storage & Display | 2026-03-19 |
| 43 | CURRENTUSER-OPTIMIZE | CurrentUser Optimization (5 phases) | 2026-03-19 |
| 44 | FEEDS-HUB | Feeds Hub + FEED-INTEL Phase 1 | 2026-03-19 |
| 45 | SMART-FEED | Smart Feed — Ranked Personalized Feed with Discovery | 2026-03-19 |
| 46 | IMAGES-DISPLAY | Entity Image Display — unified fallbacks, community covers, feed images | 2026-03-20 |
| 47 | CURRENTUSER | Global User State Management | 2026-03-24 |

## Completed Blocks

### Block 0: Foundation ✓
Project scaffolding, auth, DB schema, navigation shell. Sessions: 0-22

### Block 1: Course Display ✓
Homepage, course browse, creator profiles. Sessions: 23-30

### Block 1.8: Marketing Content & Data Sync ✓
Testimonials, success stories, platform stats, schema consistency. Sessions: 28-30

### Block 2: Enrollment & Payments ✓
Stripe integration, checkout flow, enrollment creation. Sessions: 31-38

### Block 3: Course Content ✓
Content delivery, progress tracking, R2 file storage. Sessions: 39-42

### Block 3.5: Homework System ✓
Assignment creation, student submissions, instructor feedback. Sessions: 42-44

### VIDEO: Video Sessions ✓
VideoProvider/BBB, booking, session room. Sessions: 45-58 (2026-01-20)

### TEACHING: S-T Management ✓
Dashboard, availability, earnings, students, sessions, analytics. Sessions: 59-63 (2026-01-21)

### ADMIN: Admin Tools ✓
13 admin sections: dashboard, users, courses, enrollments, payouts, sessions, moderation, analytics. Sessions: 28-65 (2026-01-23)

### CERTS: Certifications ✓
Certificate issuance, verification, S-T approval. Sessions: 60-62 (2026-01-21)

### COMMUNITY: Community Feed ✓
Stream.io feeds, posts, reactions, threading. MVP complete (real-time deferred). Sessions: 54-58

### MESSAGING: Private Messaging ✓
1:1 messaging via D1. Sessions: 66-67 (2026-01-22)

### NOTIFY: Notifications ✓
Email (Resend) + in-app notifications. MVP complete. Sessions: 55-65

### CREATOR: Creator Studio ✓
Course creation, editing, publishing. Phase 1-2 complete. Sessions: 66-68

### ACCOUNT: Settings ✓
User settings and preferences. Sessions: ~68-69

### NAVIGATION: Inter-page Connectivity ✓
Dynamic sidepanels, component links, user journey verification. Session: 69 (2026-01-23)

### ONBOARDING: Member Onboarding Profile ✓
Schema (topics, member_profiles, user_topic_interests), API endpoints, OnboardingProfile + TopicPicker UI, nav integration, personalized recommendations (courses + communities), 44 recommendation tests. Sessions: 252-259 (2026-02-22)

### MODERATION: Two-Tier Moderator Model ✓
Global (Tier 1) + community-scoped (Tier 2) moderation. Schema (`community_moderators`, `content_flags` community_id/feed_group), `requireModerationAccess` auth helper, 6 endpoint refactors with scope checks, community moderator UI in CommunityTabs, 69 moderation tests. Sessions: 265-268 (2026-02-23)

### CREATOR-SETUP: Creator Content Setup ✓
Community/progression CRUD API (30+23+17 tests), Studio UI (community list page, detail page with settings/members/progressions), CreateCourseModal community/progression picker, CreatorStudio first-time flow, CreatorDashboard community stats. Sessions: 270-273 (2026-02-23)

### BBB: Video Sessions (Post-Enrollment Flow) ✓
BBB adapter bug fixes (!-encoding, URL normalization), Blindside Networks managed hosting, `/session/[id]` page, SessionRoom with `window.open()` + polling, booking CTA, past sessions in Resources tab, attendance display (fetch-on-expand), no-show auto-detection, cancel/reschedule email notifications, recording endpoint, reschedule with conflict detection, upcoming sessions in StudentDashboard, BBB adapter unit tests (48), session API tests (27), session lifecycle integration test (15), manual testing checklist. Sessions: 276-279 (2026-02-24)

### S-T-CALENDAR: Availability Calendar & Creator-as-ST ✓
Month-view calendar replacing weekly grid editor, custom calendar grid with cell indicators (time ranges, recurring dots, override highlights, series-end badges, booking counts), recurring availability rules with `start_date`/`repeat_weeks` duration, `availability_overrides` table for date-specific changes, per-course `teaching_active` toggle on `student_teachers`, override merge algorithm (overrides replace overlapping recurring slots), DST-safe week counting fix, PATCH toggle endpoint, availability filtering by teaching_active, 4-week booking lookahead, timezone display in booking, 26 unit tests + 9 API tests, comprehensive system doc (tech-031). Sessions: 287-289 (2026-02-25)

### RATINGS: Ratings & Feedback System ✓
Multi-level rating & feedback: session sub-ratings (teacher/interaction/materials), course materials reviews (clarity/relevance/depth), enrollment expectations (POST/GET/PATCH + UI), 3-review minimum threshold display, review response endpoint (ST responds to enrollment reviews, Creator responds to course reviews), ReviewCard/ReviewList components, ST reviews API, materials feedback Creator analytics, sub-rating columns in ST performance table. 6 sub-blocks: SCHEMA, SESSION-FEEDBACK, MATERIALS, EXPECTATIONS, DISPLAY, TESTING. Tech doc: `docs/as-designed/ratings-feedback.md`. Sessions: 290-295 (2026-02-26)

### TESTING: Test Coverage Expansion (E2E) ✓
3 Playwright E2E flows: Browse→Enroll (course browse, detail, enroll redirect, success page), Auth→Dashboard (login via UI modal, student dashboard, enrollment verification), Admin Overview (admin login, dashboard, users list, sidebar navigation). Fixed `window.__peerloop` race condition between `auth-modal.ts` and `current-user.ts` that prevented login modal from rendering. Updated existing homepage tests for sidebar layout. Webhooks deferred. 19 E2E tests total, 5,424 unit tests passing. Session: 298 (2026-02-27)

### E2E-TESTING: Comprehensive E2E Test Coverage ✓
Expanded Playwright E2E from 4 files/19 tests to 24 files/94 tests across 5 tiers: Core Dashboards (profiles, course-detail, creator/teaching dashboards, course-learning), Settings/Admin/Discovery (settings, admin-crud, discovery, signup), Boundary Testing (session-booking, community-pages, creator-application), Webhooks (session-completed, earnings, admin-webhookstate), Feeds with route interception (community-feed, course-feed, home-feed). Shared `login()` + `mockFeedApi()` helpers, mock feed fixtures. All 94 tests passing. Reference: `docs/reference/TEST-E2E.md`. Sessions: 300-303 (2026-02-27)

### STORY-REMAP: Realign User Stories to Current Routes ✓
Mapped all 402 user stories to current routes (ROUTE-STORIES.md), produced gap analysis (zero P0/P1 gaps), created translation table (OLD-CODE-TO-NEW-ROUTE.md), archived and deleted 249 dead PageSpec files (72 JSON specs, 5 components, 9 scripts, 61 page-tests, 100 page metadata files), cleaned up 11 live docs with stale references. Sessions: 306-308 (2026-02-27)

### BROKENLINKS: Fix Broken Navigation Links ✓
Fixed 42 stale `/dashboard/*` and `/workspace` route references across 15 source files + 5 test files (9 assertions). Created 20 new pages: custom 404, `/verify/[id]` certificate verification (using existing SSR loader), 17 placeholder pages for Footer/marketing links (legal, company, marketing, support, browse). Route scanner broken targets reduced from 26 to 4 (remaining are dynamic route + scanner phantoms). Session: 317 (2026-03-01)

---

### RESEND-DOMAIN: Resend Domain Verification ✓
Verified sending domain `send.peerloop.com` in Resend. Updated `from` address to `noreply@send.peerloop.com` across centralized `sendEmail()` and 2 moderator endpoints. Updated tech doc with domain setup details and misleading error caveat. Session: 319 (2026-03-01)

---

### CREATOR-GATE: Creator Access Gate Hook + Client-Side Cleanup ✓
Created `useCreatorGate` hook for client-side creator access gating (Pattern C: permission OR state). Applied to 5 creator page components, replacing scattered 403-handling and a redundant `/api/me/courses` pre-fetch. Added 29 new tests (hook unit tests, Pattern C API gate tests, component gate-state tests). Sessions: 319-320 (2026-03-01)

---

### CERT-AUDIT: ST Certification ID Audit Trail ✓
Added `st_certification_id` column (FK to `student_teachers.id`) to enrollments table, storing which ST certification was active when a student enrolled. Populated on enrollment creation (from Stripe metadata) and admin reassign-ST. Sessions table skipped — one JOIN from `enrollment_id`. Session: 328 (2026-03-04)

### BOOKING-MODULES: Positional Module Assignment ✓
Positional module-to-session mapping: modules computed by chronological order (not stored at booking). Schema (`module_id` on sessions), `resolveModuleAssignments()` helper, session limit enforcement (422), BBB webhook freezes `module_id` on completion with sequential guard, booking wizard module banner + fully-booked state, teacher dashboard module titles. 17 new tests (13 unit + 4 API). Sessions: 331-332 (2026-03-05)

### BOOKING-FOLLOW-UPS: Booking Guardrails & Policies ✓
Five follow-up items from BOOKING-MODULES: (1) rebooking guard — 403 if enrollment not active, (2) "Book Next Session" button on success screen, (3) Mark Complete gated on session completion status, (4) cancellation policy — always allowed, < 24h requires reason + S-T notification, (5) reschedule limit — max 2 per session. Schema additions: `cancelled_at`, `is_late_cancel`, `reschedule_count`, `session_cancelled` notification type. 7 new tests. Session: 333 (2026-03-05)

### MESSAGING-UX: Messaging & Notifications UX ✓
Messages badge in AppNavbar (mirroring notification badge), `/api/me/messages/count` + `/api/me/messages/read-all` endpoints, All/Unread filter tabs + "Mark all read" in ConversationList. Notifications UI verified at parity. 29 new tests (8 count + 7 read-all + 14 integration lifecycle). Session: 339 (2026-03-05)

### MSG-ACCESS: Messaging Access Control ✓
Relationship-gated messaging across all UI surfaces. Phase 1: `canMessage()` library + API gates on 3 endpoints + 20 policy tests (Session 341). `useCanMessage` hook + `/api/me/can-message/[userId]` endpoint + profile button visibility (Session 344). Phase 2: Inherently valid surfaces — session views, teacher dashboards, 6 admin panels (Session 344). Phase 3: Conditional surfaces — CourseSTList, SessionBooking, CourseHero, CommunityTabs with per-pair `useCanMessage` checks via extracted sub-components (Session 345). Sessions: 338-345 (2026-03-05)

### TERMINOLOGY: Platform Terminology Standardization ✓
Standardized all platform terminology via GLOSSARY.md as source of truth. Phase 1: Created GLOSSARY.md — identity hierarchy, domain terms, naming conventions (Sessions 346+348). Phase 2: Table rename `student_teachers` → `teacher_certifications` + component/route renames, 246 files (Session 349). Phase 3A-E: Schema column renames — ambiguous FKs, `_by` → `_by_user_id`, enum values, SQL sweep finding 2 real bugs, 15 TS status unions; ~370 files (Sessions 351-354). Phase 4A: UI text, TS variables, API response keys, test assertions; 262 files, 1270 replacements (Session 355). Phase 4B: Living documentation — 83 files across docs/reference, docs/tech, research/, DECISIONS.md (with footnotes), SITE-MAP.md, USER-STORIES.md, etc. (Session 356). Total: ~960 files, ~5000 replacements, 0 regressions. Sessions: 346-356 (2026-03-05 to 2026-03-07)

---

### TESTX: Skills 2 Migration Smoke Test ✓
Verified q-dump and q-update-plan Skills 2 conversions via test block in PLAN.md. Sessions: 366-367 (2026-03-10)

---

### SKILLS-MIGRATE: Skills 2 Migration ✓
Converted all 11 q-* skills from paired global/local commands to Skills 2 format. Includes q-docs (with 5 helper scripts + marker-anchored detection), q-dump, q-update-plan, q-learn-decide, q-eos, q-commit (with auto-timing from session hook), q-codecheck (with Tailwind v3→v4 table), q-prune-claude, q-git-history, q-timecard, q-timecard-dual (new — merged dual-repo timecards with compact c2d3 syntax). Also: cross-machine session sync via git pull --ff-only in hook, skills-system.md architecture doc, skills-canon repo for portable templates. Sessions: 364-369 (2026-03-10)

---

### BOOKING: Session Booking Flow ✓
Full purchase-to-booking UX: reschedule slot release, teacher availability badges, assigned teacher auto-advance, clickable step indicator, module context banner, booking seed script, notification URL fix, notification action_label UX overhaul, welcome notifications, seed data URL audit, session room links on all views, `/learning/sessions` + `/teaching/sessions` grouped pages, reschedule flow fix (teacher pre-selected, old session cancelled, slot released), notification overhaul (both parties for all events, 30-min reschedule threshold), date timezone fix, reschedule button styling, Sessions tab on course detail page, MyCourses session banners, API extension for `status=all`. Sessions: 370-377 (2026-03-11 to 2026-03-12)

### COURSE-PAGE-MERGE: Merge /learn Into Course Detail Page ✓
Merged standalone `/course/{slug}/learn` into course detail page as enrolled-only "Learn" tab with accordion modules. Retired CourseLearning.tsx (579 lines) + ModuleSidebar.tsx (110 lines). Created LearnTab.tsx + ModuleAccordion.tsx. Enrolled students default to Learn tab; visitors see About. Removed Curriculum tab, About tab session card. Added Teachers tab assigned-teacher booking gating with "Your Teacher" badge. Refactored ModuleContent action buttons into extensible flex-wrap row. Sessions: 378-379 (2026-03-12)

---

### TERMINOLOGY-CLEANUP: ST Prefix Rename ✓
Removed all deprecated "ST" (Student-Teacher) prefix abbreviations from code identifiers, DB enum values, route codes, and docs. 38 files, ~75 renames: 7 interfaces, 20+ variables, 2 DB enums (st_application→teacher_application, st_certification→teacher_certification), property names (new_sts→new_teachers, top_sts→top_teachers, st_id/st_name→teacher_id/teacher_name/cert_id), route codes (STDR→TDIR, STPR→TPRO), comments, and docs. Follow-up to TERMINOLOGY block (Sessions 346-356). Sessions: 391 (2026-03-16)

---

### UTC-TIMES: UTC Timezone Normalization ✓
Fixed session timezone bug where bare datetime strings caused "Session time has passed" for on-time users (Workers=UTC, browser=local). Created `src/lib/timezone.ts` (`localToUTC`, `formatLocalTime`), fixed availability slot generation to convert teacher-local times to UTC, updated booking to pass UTC ISO strings, added Z-suffix validation on session endpoints, migration `0003_fix_session_times.sql` for existing data, 23 new tests including full timezone chain integration test. Remaining: per-user timezone in emails (deferred to EMAIL-TZ). Conv: 002 (2026-03-17)

---

### SESSION-INVITE: Instant Session Booking ("Book Now") ✓
Teacher-initiated session invites via notification system. `session_invites` table, 3 API endpoints (create, accept, decline + GET list), `notifySessionInvite()` + `notifySessionInviteAccepted()` helpers, BoltIcon button in MyStudents teacher UI, `invite-confirm` step in SessionBooking student UI, lazy 30-min expiry, auto-reschedule of next upcoming session when all modules booked. 14 integration tests (11 mocked + 3 unmocked notification verification). RFC: CD-037. Conv: 004 (2026-03-17)

---

### ENROLL-AVAIL: Course Enrollment Guards + Pre-Purchase Availability Preview ✓
Enrollment guards (creator self-enrollment, active teacher self-enrollment, duplicate active, no teachers → block + notify), re-enrollment after completion (new row, partial unique index, retake confirmation dialog), pre-purchase teacher availability preview (public endpoint with slot counts, CourseAvailabilityPreview component), admin-configurable availability window via platform_stats. Schema: partial unique index on enrollments, `course_no_teachers` notification type. Backend: `enrollment-guards.ts`, `availability.ts` shared lib, `GET /api/courses/[id]/availability-summary`. UI: EnrollButton 4 new states, CourseAvailabilityPreview, CourseTabs integration. 15 files changed, 4 new. 5839 tests passing. Conv: 008 (2026-03-18)

---

### DATE-FORMAT: Canonical Date/Time Storage & Display ✓
Migrated all date/time storage and display to UTC ISO 8601 with Z suffix across 130+ files. Schema: 66 defaults changed from `datetime('now')` to `strftime('%Y-%m-%dT%H:%M:%fZ', 'now')`. Seed: 6 occurrences normalized. App writes: 49 files migrated from SQL `datetime('now')` to parameterized `toUTCISOString()`, 17 files migrated from `now()` to `toUTCISOString()`, `now()` deprecated. Display: 58 components migrated from raw `toLocaleDateString()` to `formatDateUTC()`/`formatDateTimeUTC()`. 5901 tests passing. Conv: 010-011 (2026-03-18 to 2026-03-19)

---

### CURRENTUSER-OPTIMIZE: CurrentUser Optimization ✓
Version polling for freshness (Phase 1), enrollment enrichment + StudentDashboard refactor (Phase 2), CreatorDashboard community count fold (Phase 3), community memberships + feed index with `getFeeds()` (Phase 4), MyFeeds dashboard card + FeedSlidePanel refactor to zero API calls (Phase 5). 5 phases across 3 convs. 5941 tests passing. Conv: 013-015 (2026-03-19)

---

### FEEDS-HUB: Feeds Hub + FEED-INTEL Phase 1 ✓
Composite `/feeds` page as primary learning surface with badge counts. FeedsHub component (The Commons pinned, communities, course discussions, search/filter, responsive layout). Navbar "My Feeds" → `/feeds`. FEED-INTEL Phase 1: CQRS pattern with D1 `feed_activities` + `feed_visits` tables alongside Stream.io. Dual-write in all 5 post/comment endpoints. Badge API (`GET /api/me/feed-badges`). Auto-routing `FeedActivityCard` derives correct API path from activity metadata. Course comments/reactions endpoints added. FeedSlidePanel deleted. Bug fix: `enrollments.user_id` → `student_id` in badge query. 18 unit/integration tests, 12 E2E tests passing. Architecture doc: `docs/as-designed/feeds.md`. Pruning cron deferred (observing data growth). Conv: 014-016 (2026-03-19)

### SMART-FEED: Smart Feed — Ranked Personalized Feed with Discovery ✓
Hybrid ranking pipeline: D1 candidate selection → app-side scoring → Stream enrichment → diversity cap → discovery interleaving. 5 backend modules (`src/lib/smart-feed/`), 2 API endpoints (`GET /api/feeds/smart`, `POST /api/feeds/smart/dismiss`), 2 React components (`SmartFeed.tsx`, `DiscoveryCard.tsx`), `feed.astro` page. 13 scoring parameters tunable via `platform_stats` (including `smart_feed_page_size`, Conv 020). Discovery cards from public non-member feeds matched by topic/category with dismiss persistence. Feed seed script (`scripts/seed-feeds.mjs`) creates 14 Stream activities + 17 reactions + D1 dual-write for E2E testing. Setup pipeline level `db:setup:local:feeds`. 27 unit/integration tests (Conv 017) + 6 E2E tests (Conv 018). Stream `GET /enrich/activities/?ids=...` verified. Conv 020: Card visual system (source-type color differentiation, right-side image strip, username→profile links, course badge→course links, "Visit feed" action, "in {feed}" context links), dashboard navigation (MyFeeds "View Smart Feed" link on /learning, /teaching, /creating), hydration fixes (`client:only="react"` for /feeds, /learning), infinite loop fix in discovery interleaving, Stream API 10s timeout, seed data images (picsum.photos for users/courses/communities). Conv: 017-020 (2026-03-19 to 2026-03-20)

### IMAGES-DISPLAY: Entity Image Display ✓
Unified avatar fallback pattern (gradient+initial, eliminated placehold.co dependency), community cover images rendered across all pages (`/community`, `/community/[slug]`, `/discover/communities`, creator dashboard, FeedsHub), FeedsHub feed cards show course thumbnails and community covers via `UserFeedLink.imageUrl`, feed avatar enrichment on read (`enrichActivitiesWithAvatars` in `feed-activity.ts`), course sessions teacher avatars, community courses tab thumbnails. Added `xs` size to `UserAvatar`. Seed data cleanup: image URLs inlined in INSERTs, The Commons cover image moved to core seed. 24 source files + 3 test files + 2 seed files modified. Conv: 023 (2026-03-20)

### CURRENTUSER: Global User State Management ✓
TypeScript types and `CurrentUser` class, `/api/me/full` endpoint with unread notification/message counts, AppNavbar + AdminNavbar integration, localStorage caching with stale-while-revalidate, two-global architecture on `window.__peerloop`, permission model audit (13 methods), cache structural guard (`isValidCachedData`), component migration (EnrollButton, Messages, ContextActionsPanel → `getCurrentUser()`), pub/sub listener system (`subscribeToUserChange`) + `useCurrentUser()` hook, dead `SessionUser` types removed. 62+ tests (17 cache, 14 listener/hook/unread, 11 ContextActionsPanel, 13 EnrollButton, 7 fetchUnreadMessageCount). Deferred: `totalEarningsCents`/`pendingPayoutCents` (schema gaps → SEEDDATA/POLISH). PUBLIC items migrated to PUBLIC-PAGES block (#29). Sessions: 261, 362, 385-386; Conv: 024 close-out (2026-03-24)

---

*Last Updated: 2026-03-24 Conv 024 (CURRENTUSER completed)*
