# Test Coverage

Index of all test files organized by category. For testing commands, see [CLI-TESTING.md](CLI-TESTING.md).

**Last Updated:** 2026-07-12 (Conv 392 — [ORPHAN-PURGE]/[ORPHAN-BACKLOG]: deleted 14 orphaned test files whose components were removed as dead-legacy (unreachable from any route). 13 component tests — Course −5 (`CourseTabs`/`LearnTab`/`ModuleAccordion`/`MyCourses`/`course-tabs/ResourcesTabContent`), Explore −5 (`RoleBadge`/`ExploreTabBar`/`RolePillFilters`/`ExploreCommunityCard`/`CommunityRolePillFilters`), Learning −1 (`ModuleContent`), Messages −1 (`Messages`), Notifications −1 (`NotificationsList`, category emptied) → Components 104→91 — plus 1 page test (`pages/courses/CourseDetail.test.tsx`, 56) → Pages 10→9. Vitest Total 423→409, All Test Files 451→437. Per-category component case deltas are in TEST-COMPONENTS.md.)
**Prev:** 2026-07-12 (Conv 390 — [CERT-MASTERY-UI]: +1 **new** component test file `components/teachers/RecommendCertButton.test.tsx` (4) → Components 103→104, Vitest Total 422→423, All Test Files 450→451. Per-file component case deltas (new **Teachers** category; Admin 695→692 as `CertificateDetailContent` 31→29 + `CertificatesAdmin` 27→26 shed retired `completion`/`mastery` cert-type cases) are in TEST-COMPONENTS.md. Also refreshed `tests/api/me/teacher-students.test.ts` 16→18 (+2 `hasPendingCertRecommendation` cases, modified in place — API summary is by-file, so no totals change).)
**Prev:** 2026-07-12 (Conv 389 — [DIPLOMA]: +1 test file `tests/api/me/diplomas.test.ts` (2 — `GET /api/me/diplomas` returns the caller's completed-enrollment Diplomas). API Endpoints 241→242, Vitest Total 421→422, All Test Files 449→450. The ~7 certificate test files + `tests/api/enrollments/[id]/progress.test.ts` were modified in place for the teaching-only `certificates.type` + Diploma-award side-effects — no file-count change.)
**Prev:** 2026-07-11 (Conv 387 — [CAF] availability filter + admin window config: +3 test files. `tests/api/admin/availability-config.test.ts` (12 — admin GET/POST window, `it.each` validation range), `tests/api/courses/availability-batch.test.ts` (6 — public batch boolean map, frozen clock, cap/inactive/no-teacher → false), `tests/lib/availability-config.test.ts` (6 — loader default/clamp + upsert self-heal). API Endpoints 239→241 (Admin 68→69, Courses 8→9), Lib 30→31, Vitest Total 418→421, All Test Files 446→449. Also refreshed `tests/unit/journey-loop-tabs.test.ts` 16→19 ([HW-SUBMIT-UI] +3 enrolled Homework-tab cases, modified in place — no file-count change).)
**Prev:** 2026-07-11 (Conv 386 — [XTZ] cross-timezone fix + regression suite. +2 **new** component test files: `components/dashboard/cross-timezone-day-of.test.tsx` (2 — teacher LA/PDT vs student Tokyo/JST, same instant, day+hour diverge) and `components/messages/message-timezone.test.ts` (4 — `formatMessageTime`/`formatDateHeader`/`groupMessagesByDate` per viewer stored tz) → Components 101→103, Vitest Total 416→418, All Test Files 444→446. Per-file case counts are in TEST-COMPONENTS.md. The 3 other timezone test files touched this conv (`unit/timezone.test.ts` +`formatSessionRelativeWhen`, `integration/session-timezone.test.ts`, `api/sessions/index.test.ts` per-recipient email) were modified in place, not added, so no file-count change.)
**Prev:** 2026-07-11 (Conv 385 — [PLATO-SEQ] Phase 4a/4b: +2 PLATO unit-test files under `tests/plato/lib/` — `waypoint-graph.test.ts` (6 — DAG derivation, transitive-closure source hash, validation, topo-sort, transitive-staleness proof) and `waypoint-status.test.ts` (4 — FRESH/STALE/MISSING computation, `descendantsOf`, `planWaypointRun`) — for the new waypoint dependency-graph + registry + provenance foundation. PLATO summary 1→3, Vitest Total 414→416, All Test Files 442→444. Also enumerated the 3 new lib infra files (`waypoint-graph.ts`/`waypoint-provenance.ts`/`waypoint-status.ts`) + the committed `manifest.generated.json` registry in PLATO Infrastructure. No `src/` changes.)
**Prev:** 2026-07-10 (Conv 380 — [PLATO-SEQ]: decomposed the flywheel's fused `complete-course` step into `book-sessions` (pure-UI → `wp-booked`) + `complete-sessions` (BBB `room_ended`, CUT-3 → `wp-completed`), so the `flywheel` scenario is now **15 steps** (the headline had lagged at 12) and steps registered 25→27. Registered 3 more waypoint producers — `flywheel-pre-12`/`-14`/`-15` (`wp-enrolled`/`wp-booked`/`wp-completed`) — adding their rows to the PLATO Scenarios + Instances enumeration and bumping enumerated instances 9→12. Not gated as `Instance:` describe blocks — run on-demand via `plato:restore`/dynamic runner — so the PLATO suite stays **13** and no `*.test.ts` totals change (Vitest Total 414, All Test Files 442 unchanged).)
**Prev:** 2026-07-10 (Conv 379 — [PLATO-SEQ]: registered the `flywheel-pre-11` waypoint (split of `flywheel` at step 11 / enroll-student → steps 1-10 through self-cert + set-availability = `wp-creator-ready`). Added its rows to the PLATO Scenarios + Instances enumeration tables and to the file-summary line (enumerated instances 8→9). Not gated as an `Instance:` describe block — runs on-demand via `plato:restore`/dynamic runner — so the PLATO suite stays **13** and no `*.test.ts` totals change (Vitest Total 414, All Test Files 442 unchanged). Sibling `flywheel-pre-9` treated identically.)
**Prev:** 2026-07-09 (Conv 378 — [TEST-PAGE-COUNTS]: resolved the page-test case-count drift the Conv-377 note left for separate handling. Reconciled the embedded Page-Tests table to on-disk `tests/pages/` truth (vitest JSON reporter, 355 cases / 10 files): LoginForm 20→21, SignupForm 23→24, CreatorDashboard 48→46, StudentDashboard 29→28, TeacherDashboard 62→48. Sibling TEST-PAGES.md reconciled in lockstep (Auth subtotal 70→72). Page-Tests table has no case subtotal, so no total row changed; file-count roll-ups unchanged.)
**Prev:** 2026-07-09 (Conv 377 — [TZ-BROWSER-AUTO]: +2 component test files (`components/dashboard/TeacherUpcomingSessions.test.tsx`, `components/learning/StudentSessionsList.test.tsx`) for the jsdom viewer-tz display suite → Components 99→101, Vitest Total 412→414, All Test Files 440→442. Also corrected the stale detail-section header "Component Tests (96 files)"→101 (had lagged since Conv 362). Per-file *case* counts for the 3 modified component files + the StudentDashboard page test are in TEST-COMPONENTS.md; the embedded Page-Tests case counts here (StudentDashboard/CreatorDashboard/TeacherDashboard/LoginForm) carry pre-existing drift that disagrees with TEST-PAGES.md and on-disk — left for a separate page-test count reconciliation.)
**Prev:** 2026-07-08 (Conv 375 — [SESSION-REMIND]/[TZ-TESTS]: +4 test files. `tests/lib/session-reminders.test.ts` (6 — session-reminder cron), `tests/unit/period-dates.test.ts` (3), `tests/unit/expiry-helpers.test.ts` (4), `tests/unit/is-valid-timezone.test.ts` (5) → Lib 29→30, Unit 14→17, Vitest Total 408→412, All Test Files 436→440. Also refreshed two files modified this conv: `tests/api/auth/register.test.ts` 26→29 (+Timezone Capture block), `tests/api/admin/sessions/cleanup.test.ts` 12→18 (+UTC-day-boundary no-show test; row had been stale since Conv 142). API summary is by-file (test column `—`), so those two count fixes don't change any total.)
**Prev:** 2026-07-07 (Conv 371 — [TZ-AUDIT]: `tests/unit/timezone.test.ts` grew 15→20 — added a `localToUTC — DST transition boundaries (regression, Conv 371)` describe block (5 tests: NY/Sydney wall→UTC across spring-forward/fall-back, verifying the fixpoint offset correction). No new test *file*, so all Summary file counts (Unit 14, Vitest Total 408, All Test Files 436) unchanged.)
**Prev:** 2026-07-06 (Conv 369 — [E2E-DOCS]: reconciled the E2E drift the Conv-363 note flagged for separate handling. Disk truth = **28** `e2e/*.spec.ts` / **125** tests. Summary E2E file count 30→28, All Test Files 438→436, detailed-table header "(30 files)"→"(28 files)". The detailed E2E table's per-file counts were already accurate (incl. `feed-badges`=2). Sibling `TEST-E2E.md` lifted from its stale 25-file/105-test Session-390 snapshot: added `feed-badges` (2), `my-feeds-card` (4), `seed-data-verification` (14).)
**Prev:** 2026-07-04 (Conv 363 — [VBAR]/[THEME-CS]: added 3 component test files — `components/feed/SignupCtaCard.test.tsx` (2), `components/Sidebar.test.tsx` (2), `components/ui/ThemeToggle.test.tsx` (2) — plus SmartFeed.test.tsx grew 3→5 for the visitor CTA interleave → Components 96→99, Vitest Total 405→408, All Test Files 435→438. Note: the E2E row (30) is a **pre-existing drift** — 28 `.spec.ts` on disk, TEST-E2E.md still at 25 — left untouched here for a separate reconciliation.)
**Prev:** 2026-07-04 (Conv 362 — [MOBUP]: added `tests/components/ui/MobileUpNav.test.ts` (8 — Astro source-level up-chevron: `@matt-inspired` marker, `lg:hidden` mobile contract, parent href/label props, deterministic up-anchor never `history.back()`, AppLayout `mobile-upnav` slot) → Components 95→96, Vitest Total 404→405, All Test Files 434→435. [MOBNAV]: `ControlBar.test.tsx` now asserts 5 Arrangement-A shortcuts (Members added), test-case count unchanged (4).)
**Prev:** 2026-07-03 (Conv 361 — [MOBNAV]: added `tests/unit/nav/ControlBar.test.tsx` (4 — 4 Arrangement-A shortcuts + hrefs, dropped dead `/saved`+`/todo` links, active `aria-current`, Home exact-match) and `tests/unit/nav/mobile-nav-drawer.test.tsx` (7 — `nav:open` dispatch, drawer open/close, Sidebar drawer variant) for the mobile/tablet nav drawer → Unit 12→14, Vitest Total 402→404, All Test Files 432→434. Also restored the missing `tests/unit/timezone.test.ts` row (15) that had left the Unit detail table 1 behind its count.)
**Prev:** 2026-06-28 (Conv 347 — [E2E-GATE/instanceFile-gate]: statically gated 3 walkthrough instances (`activities`, `ecosystem`, `member-directory`) as `Instance:` describe blocks in `plato-scenarios.api.test.ts` so their file-level `verify` runs in `npm test` — PLATO suite 10→13. Instance enumeration 6→8 (added `activities`, `ecosystem`).)

---

## Quick Reference

| Document | Location | Description |
|----------|----------|-------------|
| [TEST-COMPONENTS.md](TEST-COMPONENTS.md) | `tests/components/` | React component tests |
| [TEST-PAGES.md](TEST-PAGES.md) | `tests/pages/` | Page-level tests |
| [TEST-UNIT.md](TEST-UNIT.md) | `tests/lib/`, `tests/unit/`, `tests/integration/`, `tests/ssr/` | Lib, unit, integration, SSR tests |
| [TEST-E2E.md](TEST-E2E.md) | `e2e/` | Playwright E2E tests (flows, setup, patterns) |

---

## Test Runners

| Runner | Command | Purpose |
|--------|---------|---------|
| Vitest | `npm run test` | Unit, component, API, integration tests |
| Playwright | `npm run test:e2e` | End-to-end tests |

---

## Summary

| Category | Files | Test Cases | Location |
|----------|:-----:|:----------:|----------|
| API Endpoints | 242 | — | `tests/api/` |
| Components | 91 | — | `tests/components/` |
| Pages | 9 | — | `tests/pages/` |
| Lib | 31 | — | `tests/lib/` |
| Integration | 10 | — | `tests/integration/` |
| SSR | 3 | — | `tests/ssr/` |
| Unit | 17 | — | `tests/unit/` |
| Middleware | 1 | — | `tests/` (root) |
| PLATO | 3 | — | `tests/plato/` |
| Src (co-located) | 2 | — | `src/__tests__/` |
| **Vitest Total** | **409** | — | |
| E2E (Playwright) | 28 | — | `e2e/` |
| **All Test Files** | **437** | — | |

---

## Test Infrastructure

| File | Purpose |
|------|---------|
| `tests/helpers/index.ts` | Test utilities (describeWithTestDB, describeWithBBB, getTestDB, getRawTestDB, seedCoreTestDB) |
| `tests/helpers/bbb.ts` | BBB credential loader + test client (canUseBBB, getBBBTestClient) |
| `tests/helpers/dates.ts` | UTC-safe date helpers (utcDate, futureUTC, pastUTC, nextDayOfWeekUTC, toDateStringUTC) |
| `tests/helpers/mock-astro-middleware.ts` | Mock for `astro:middleware` (aliased in vitest.config.ts) |
| `tests/helpers/mock-astro-navigate.ts` | Mock for `astro:transitions/client` (aliased in vitest.config.ts) |
| `tests/api/helpers/index.ts` | API context helpers (createAPIContext, createMockRequest) |
| `vitest.config.ts` | Vitest configuration with path aliases |
| `vitest.global-setup.ts` | Global test setup (database initialization) |
| `vitest.setup.ts` | Per-file test setup |
| `playwright.config.ts` | Playwright configuration |
| `e2e/helpers.ts` | E2E shared helpers (login, mockFeedApi) |
| `e2e/fixtures/mock-feed-data.ts` | Mock Stream.io feed responses for Playwright route interception |

### Path Aliases

Test files use path aliases instead of deep relative imports:

| Alias | Resolves To |
|-------|-------------|
| `@/` | `src/` |
| `@api-helpers` | `tests/api/helpers` |
| `@test-helpers` | `tests/helpers` |

---

## API Tests — `tests/api/` (241 files)

Tests mirror the API route structure with 1:1 file mapping:

```
tests/api/
├── resource/
│   ├── index.test.ts        # GET/POST collection
│   └── [id]/
│       ├── index.test.ts    # GET/PATCH/DELETE item
│       └── action.test.ts   # POST action endpoints
```

### Admin — `tests/api/admin/` (69 files)

| Area | File | Tests |
|------|------|:-----:|
| Dashboard | `tests/api/admin/dashboard.test.ts` | 30 |
| **Stripe Diagnostics** | | |
| | `tests/api/admin/stripe-mode.test.ts` | 4 |
| **Analytics** | | |
| | `tests/api/admin/analytics/index.test.ts` | 12 |
| | `tests/api/admin/analytics/courses.test.ts` | 5 |
| | `tests/api/admin/analytics/engagement.test.ts` | 5 |
| | `tests/api/admin/analytics/revenue.test.ts` | 5 |
| | `tests/api/admin/analytics/teachers.test.ts` | 5 |
| | `tests/api/admin/analytics/users.test.ts` | 5 |
| **Topics** (admin) | | |
| | `tests/api/admin/topics/index.test.ts` | 15 |
| | `tests/api/admin/topics/[id]/index.test.ts` | 10 |
| | `tests/api/admin/topics/reorder.test.ts` | 7 |
| **Certificates** | | |
| | `tests/api/admin/certificates/index.test.ts` | 24 |
| | `tests/api/admin/certificates/[id]/index.test.ts` | 5 |
| | `tests/api/admin/certificates/[id]/approve.test.ts` | 6 |
| | `tests/api/admin/certificates/[id]/reject.test.ts` | 6 |
| | `tests/api/admin/certificates/[id]/revoke.test.ts` | 7 |
| **Courses** | | |
| | `tests/api/admin/courses/index.test.ts` | 43 |
| | `tests/api/admin/courses/[id]/index.test.ts` | 19 |
| | `tests/api/admin/courses/[id]/badge.test.ts` | 12 |
| | `tests/api/admin/courses/[id]/feature.test.ts` | 5 |
| | `tests/api/admin/courses/[id]/suspend.test.ts` | 8 |
| | `tests/api/admin/courses/[id]/unsuspend.test.ts` | 8 |
| **Creator Applications** | | |
| | `tests/api/admin/creator-applications/index.test.ts` | 15 |
| | `tests/api/admin/creator-applications/[id].test.ts` | 5 |
| | `tests/api/admin/creator-applications/[id]/approve.test.ts` | 9 |
| | `tests/api/admin/creator-applications/[id]/deny.test.ts` | 8 |
| **Enrollments** | | |
| | `tests/api/admin/enrollments/index.test.ts` | 46 |
| | `tests/api/admin/enrollments/[id]/index.test.ts` | 29 |
| | `tests/api/admin/enrollments/[id]/cancel.test.ts` | 9 |
| | `tests/api/admin/enrollments/[id]/force-complete.test.ts` | 10 |
| | `tests/api/admin/enrollments/[id]/reassign-teacher.test.ts` | 10 |
| | `tests/api/admin/enrollments/[id]/refund.test.ts` | 14 |
| **Moderation** | | |
| | `tests/api/admin/moderation/index.test.ts` | 19 |
| | `tests/api/admin/moderation/[id]/index.test.ts` | 9 |
| | `tests/api/admin/moderation/[id]/dismiss.test.ts` | 10 |
| | `tests/api/admin/moderation/[id]/remove.test.ts` | 10 |
| | `tests/api/admin/moderation/[id]/suspend.test.ts` | 12 |
| | `tests/api/admin/moderation/[id]/warn.test.ts` | 9 |
| **Moderators** | | |
| | `tests/api/admin/moderators/index.test.ts` | 15 |
| | `tests/api/admin/moderators/invite.test.ts` | 17 |
| | `tests/api/admin/moderators/[id]/remove.test.ts` | 8 |
| | `tests/api/admin/moderators/[id]/resend.test.ts` | 12 |
| | `tests/api/admin/moderators/[id]/revoke.test.ts` | 9 |
| **Payouts** | | |
| | `tests/api/admin/payouts/index.test.ts` | 35 |
| | `tests/api/admin/payouts/batch.test.ts` | 10 |
| | `tests/api/admin/payouts/pending.test.ts` | 11 |
| | `tests/api/admin/payouts/[id]/index.test.ts` | 10 |
| | `tests/api/admin/payouts/[id]/process.test.ts` | 14 |
| | `tests/api/admin/payouts/[id]/retry.test.ts` | 10 |
| **Sessions** | | |
| | `tests/api/admin/sessions/index.test.ts` | 23 |
| | `tests/api/admin/sessions/[id]/index.test.ts` | 21 |
| | `tests/api/admin/sessions/[id]/recording.test.ts` | 15 |
| | `tests/api/admin/sessions/[id]/resolve.test.ts` | 13 |
| | `tests/api/admin/sessions/cleanup.test.ts` | 18 |
| **Teachers** | | |
| | `tests/api/admin/teachers/index.test.ts` | 35 |
| | `tests/api/admin/teachers/[id]/index.test.ts` | 30 |
| | `tests/api/admin/teachers/[id]/activate.test.ts` | 8 |
| | `tests/api/admin/teachers/[id]/deactivate.test.ts` | 9 |
| **Users** | | |
| | `tests/api/admin/users/index.test.ts` | 53 |
| | `tests/api/admin/users/[id]/index.test.ts` | 29 |
| | `tests/api/admin/users/[id]/suspend.test.ts` | 10 |
| | `tests/api/admin/users/[id]/unsuspend.test.ts` | 9 |
| **Intel** | | |
| | `tests/api/admin/intel/course/[id].test.ts` | — |
| | `tests/api/admin/intel/community/[id].test.ts` | — |
| | `tests/api/admin/intel/user/[id].test.ts` | — |
| | `tests/api/admin/intel/communities-batch.test.ts` | 6 |
| | `tests/api/admin/intel/courses-batch.test.ts` | 6 |
| | `tests/api/admin/intel/dashboard-intel.test.ts` | 3 |
| **Availability** | | |
| | `tests/api/admin/availability-config.test.ts` | 12 |

### Auth — `tests/api/auth/` (10 files)

| File | Tests |
|------|:-----:|
| `tests/api/auth/dev-login.test.ts` | 10 |
| `tests/api/auth/login.test.ts` | 14 |
| `tests/api/auth/logout.test.ts` | 4 |
| `tests/api/auth/register.test.ts` | 29 |
| `tests/api/auth/reset-password.test.ts` | 8 |
| `tests/api/auth/session.test.ts` | 10 |
| `tests/api/auth/github/index.test.ts` | 12 |
| `tests/api/auth/github/callback.test.ts` | 10 |
| `tests/api/auth/google/index.test.ts` | 17 |
| `tests/api/auth/google/callback.test.ts` | 12 |

### Certificates — `tests/api/certificates/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/certificates/[id]/verify.test.ts` | 11 |

### Checkout — `tests/api/checkout/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/checkout/create-session.test.ts` | 14 |

### Communities — `tests/api/communities/` (6 files)

| File | Tests |
|------|:-----:|
| `tests/api/communities/index.test.ts` | 11 |
| `tests/api/communities/[slug]/index.test.ts` | 14 |
| `tests/api/communities/[slug]/join.test.ts` | 15 |
| `tests/api/communities/[slug]/progressions.test.ts` | 11 |
| `tests/api/communities/[slug]/moderators/index.test.ts` | 16 |
| `tests/api/communities/[slug]/moderators/[userId].test.ts` | 7 |

### Community Resources — `tests/api/community-resources/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/community-resources/[id]/download.test.ts` | 11 |

### Conversations — `tests/api/conversations/` (4 files)

| File | Tests |
|------|:-----:|
| `tests/api/conversations/index.test.ts` | 14 |
| `tests/api/conversations/[id]/index.test.ts` | 11 |
| `tests/api/conversations/[id]/messages.test.ts` | 11 |
| `tests/api/conversations/[id]/read.test.ts` | 7 |

### Courses — `tests/api/courses/` (9 files)

| File | Tests |
|------|:-----:|
| `tests/api/courses/index.test.ts` | 22 |
| `tests/api/courses/availability-batch.test.ts` | 6 |
| `tests/api/courses/[slug].test.ts` | 15 |
| `tests/api/courses/[slug]/discussion-feed.test.ts` | 19 |
| `tests/api/courses/[id]/curriculum.test.ts` | 9 |
| `tests/api/courses/[id]/homework.test.ts` | 12 |
| `tests/api/courses/[id]/resources.test.ts` | 11 |
| `tests/api/courses/[id]/reviews.test.ts` | 11 |
| `tests/api/courses/[id]/sessions.test.ts` | 28 |

### Creators — `tests/api/creators/` (4 files)

| File | Tests |
|------|:-----:|
| `tests/api/creators/index.test.ts` | 15 |
| `tests/api/creators/apply.test.ts` | 20 |
| `tests/api/creators/[handle].test.ts` | 10 |
| `tests/api/creators/[id]/courses.test.ts` | 13 |

### Debug — `tests/api/debug/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/debug/db-env.test.ts` | 7 |

### Enrollments — `tests/api/enrollments/` (5 files)

| File | Tests |
|------|:-----:|
| `tests/api/enrollments/index.test.ts` | 13 |
| `tests/api/enrollments/[id]/course-review.test.ts` | 24 |
| `tests/api/enrollments/[id]/expectations.test.ts` | 35 |
| `tests/api/enrollments/[id]/progress.test.ts` | 18 |
| `tests/api/enrollments/[id]/review.test.ts` | 20 |

### Feeds — `tests/api/feeds/` (15 files)

| File | Tests |
|------|:-----:|
| `tests/api/feeds/timeline.test.ts` | 8 |
| `tests/api/feeds/system.test.ts` | 14 |
| `tests/api/feeds/system/comments.test.ts` | 23 |
| `tests/api/feeds/system/reactions.test.ts` | 17 |
| `tests/api/feeds/course/[slug].test.ts` | 23 |
| `tests/api/feeds/community/[slug]/index.test.ts` | 14 |
| `tests/api/feeds/community/[slug]/comments.test.ts` | 15 |
| `tests/api/feeds/smart/dismiss.test.ts` | 7 |
| `tests/api/feeds/smart/index.test.ts` | 6 | GET /api/feeds/smart auth-aware: visitor marketing stream (no 401) + auth-varying cache headers + 3-kind serving (suggestion-card no longer filtered) + `viewerAuthenticated` flag baked per session (HOME-FEED-MERGE Phase 3–4, Conv 270) |
| `tests/api/feeds/community/[slug]/reactions.test.ts` | 12 |
| `tests/api/feeds/course/[slug]/comments.test.ts` | 6 |
| `tests/api/feeds/course/[slug]/reactions.test.ts` | 7 |
| `tests/api/feeds/discover.test.ts` | 7 |
| `tests/api/feeds/promote.test.ts` | 8 | POST /api/feeds/promote: Stream-id resolution (400 missing / 404 no match), role-matrix 403, gate-not-configured 403, invalid-password 403, course→community promote (200, one row), idempotent re-promote writes no duplicate (PROMOTE-PIPELINE Step 3) |
| `tests/api/feeds/promote-entity.test.ts` | 6 | POST /api/feeds/promote-entity (A2 author-direct): auth/validation 400s, non-public entity 404, role-matrix 403, gate/password 403, public course/community create (200, Stream post + `post_promotions` row) (FEED-U3b, Conv 274) |

### Health — `tests/api/health/` (2 files)

| File | Tests |
|------|:-----:|
| `tests/api/health/db.test.ts` | 5 |
| `tests/api/health/r2.test.ts` | 7 |

### Homework — `tests/api/homework/` (6 files)

| File | Tests |
|------|:-----:|
| `tests/api/homework/[id]/index.test.ts` | 8 |
| `tests/api/homework/[id]/submit.test.ts` | 15 |
| `tests/api/homework/[id]/submissions/index.test.ts` | 9 |
| `tests/api/homework/[id]/submissions/me.test.ts` | 9 |
| `tests/api/homework/[id]/submissions/[subId].test.ts` | 13 |
| `tests/api/homework/submissions/[id]/download.test.ts` | 13 |

### Me — `tests/api/me/` (63 files)

| Area | File | Tests |
|------|------|:-----:|
| **Profile/Account** | | |
| | `tests/api/me/account.test.ts` | 12 |
| | `tests/api/me/full.test.ts` | 25 |
| | `tests/api/me/version.test.ts` | 7 |
| | `tests/api/me/feed-badges.test.ts` | 7 |
| | `tests/api/me/onboarding-profile.test.ts` | 9 |
| | `tests/api/me/profile.test.ts` | 30 |
| | `tests/api/me/settings.test.ts` | 21 |
| **Enrollments/Certificates** | | |
| | `tests/api/me/certificates.test.ts` | 7 |
| | `tests/api/me/certificates/recommend.test.ts` | 13 |
| | `tests/api/me/diplomas.test.ts` | 2 |
| **Teacher** | | |
| | `tests/api/me/availability.test.ts` | 22 |
| | `tests/api/me/availability/overrides.test.ts` | 16 |
| | `tests/api/me/availability/overrides/[id].test.ts` | 6 |
| | `tests/api/me/teacher-dashboard.test.ts` | 12 |
| | `tests/api/me/teacher-earnings.test.ts` | 14 |
| | `tests/api/me/teacher-sessions.test.ts` | 15 |
| | `tests/api/me/teacher-students.test.ts` | 18 |
| | `tests/api/me/teacher/[courseId]/toggle.test.ts` | 9 |
| | `tests/api/me/teacher-analytics/index.test.ts` | 2 |
| | `tests/api/me/teacher-analytics/earnings.test.ts` | 4 |
| | `tests/api/me/teacher-analytics/sessions.test.ts` | 4 |
| | `tests/api/me/teacher-analytics/students.test.ts` | 4 |
| **Creator** | | |
| | `tests/api/me/creator-dashboard.test.ts` | 13 |
| | `tests/api/me/creator-earnings.test.ts` | 12 |
| | `tests/api/me/creator-analytics.test.ts` | 5 |
| | `tests/api/me/creator-analytics/index.test.ts` | 9 |
| | `tests/api/me/creator-analytics/courses.test.ts` | 10 |
| | `tests/api/me/creator-analytics/enrollments.test.ts` | 7 |
| | `tests/api/me/creator-analytics/funnel.test.ts` | 7 |
| | `tests/api/me/creator-analytics/materials-feedback.test.ts` | 11 |
| | `tests/api/me/creator-analytics/progress.test.ts` | 7 |
| | `tests/api/me/creator-analytics/sessions.test.ts` | 7 |
| | `tests/api/me/creator-analytics/teacher-performance.test.ts` | 7 |
| **Communities** | | |
| | `tests/api/me/communities/index.test.ts` | 16 |
| | `tests/api/me/communities/[slug]/index.test.ts` | 15 |
| | `tests/api/me/communities/[slug]/members.test.ts` | 11 |
| | `tests/api/me/communities/[slug]/progressions.test.ts` | 23 |
| | `tests/api/me/communities/[slug]/resources/index.test.ts` | 29 |
| | `tests/api/me/communities/[slug]/resources/[resourceId].test.ts` | 21 |
| **Courses (Creator)** | | |
| | `tests/api/me/courses/index.test.ts` | 17 |
| | `tests/api/me/courses/[id]/index.test.ts` | 16 |
| | `tests/api/me/courses/[id]/publish.test.ts` | 8 |
| | `tests/api/me/courses/[id]/unpublish.test.ts` | 5 |
| | `tests/api/me/courses/[id]/thumbnail.test.ts` | 4 |
| | `tests/api/me/courses/[id]/teachers.test.ts` | 9 |
| | `tests/api/me/courses/[id]/teachers/[teacherId].test.ts` | 5 |
| | `tests/api/me/courses/[id]/curriculum/index.test.ts` | 7 |
| | `tests/api/me/courses/[id]/curriculum/[moduleId].test.ts` | 7 |
| | `tests/api/me/courses/[id]/curriculum/reorder.test.ts` | 4 |
| | `tests/api/me/courses/[id]/homework/index.test.ts` | 5 |
| | `tests/api/me/courses/[id]/homework/[assignmentId].test.ts` | 5 |
| | `tests/api/me/courses/[id]/resources/index.test.ts` | 5 |
| | `tests/api/me/courses/[id]/resources/[resourceId].test.ts` | 4 |
| **Messages** | | |
| | `tests/api/me/can-message/[userId].test.ts` | 7 |
| | `tests/api/me/full-unread-messages.test.ts` | 7 |
| | `tests/api/me/messages/count.test.ts` | 8 |
| | `tests/api/me/messages/read-all.test.ts` | 7 |
| **Notifications** | | |
| | `tests/api/me/notifications/index.test.ts` | 13 |
| | `tests/api/me/notifications/count.test.ts` | 6 |
| | `tests/api/me/notifications/edge-cases.test.ts` | 11 |
| | `tests/api/me/notifications/read-all.test.ts` | 5 |
| | `tests/api/me/notifications/[id]/index.test.ts` | 6 |
| | `tests/api/me/notifications/[id]/read.test.ts` | 6 |
| **Payouts** | | |
| | `tests/api/me/payouts/request.test.ts` | 12 |

### Members — `tests/api/members/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/members/index.test.ts` | 24 |

### Moderator Invites — `tests/api/moderator-invites/` (3 files)

| File | Tests |
|------|:-----:|
| `tests/api/moderator-invites/[token]/index.test.ts` | 9 |
| `tests/api/moderator-invites/[token]/accept.test.ts` | 9 |
| `tests/api/moderator-invites/[token]/decline.test.ts` | 8 |

### Recommendations — `tests/api/recommendations/` (2 files)

| File | Tests |
|------|:-----:|
| `tests/api/recommendations/communities.test.ts` | 11 |
| `tests/api/recommendations/courses.test.ts` | 13 |

### Resources — `tests/api/resources/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/resources/[id]/download.test.ts` | 10 |

### Reviews — `tests/api/reviews/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/reviews/[type]/[id]/response.test.ts` | 19 |

### Sessions — `tests/api/sessions/` (7 files)

| File | Tests |
|------|:-----:|
| `tests/api/sessions/index.test.ts` | 26 |
| `tests/api/sessions/[id]/index.test.ts` | 45 |
| `tests/api/sessions/[id]/join.test.ts` | 14 |
| `tests/api/sessions/[id]/attendance.test.ts` | 10 |
| `tests/api/sessions/[id]/rating.test.ts` | 23 |
| `tests/api/sessions/[id]/complete.test.ts` | 12 |
| `tests/api/sessions/[id]/recording.test.ts` | 10 |

### Stories — `tests/api/stories/` (2 files)

| File | Tests |
|------|:-----:|
| `tests/api/stories/index.test.ts` | 14 |
| `tests/api/stories/[id].test.ts` | 8 |

### Stream — `tests/api/stream/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/stream/token.test.ts` | 6 |

### Stripe — `tests/api/stripe/` (4 files)

| File | Tests |
|------|:-----:|
| `tests/api/stripe/connect.test.ts` | 12 |
| `tests/api/stripe/connect-link.test.ts` | 10 |
| `tests/api/stripe/connect-status.test.ts` | 8 |
| `tests/api/stripe/verify-checkout.test.ts` | 9 |

### Submissions — `tests/api/submissions/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/submissions/[id]/index.test.ts` | 11 |

### Teachers — `tests/api/teachers/` (3 files)

| File | Tests |
|------|:-----:|
| `tests/api/teachers/index.test.ts` | 12 |
| `tests/api/teachers/[id]/availability.test.ts` | 15 |
| `tests/api/teachers/[id]/reviews.test.ts` | 13 |

### Teaching — `tests/api/teaching/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/teaching/courses/[courseId]/homework.test.ts` | 9 |

### Topics — `tests/api/topics/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/topics/index.test.ts` | 7 |

### Users — `tests/api/users/` (4 files)

| File | Tests |
|------|:-----:|
| `tests/api/users/index.test.ts` | 26 |
| `tests/api/users/[handle].test.ts` | 17 |
| `tests/api/users/check-handle.test.ts` | 13 |
| `tests/api/users/search.test.ts` | 20 |

### Webhooks — `tests/api/webhooks/` (3 files)

| File | Tests |
|------|:-----:|
| `tests/api/webhooks/bbb.test.ts` | 24 |
| `tests/api/webhooks/bbb-analytics.test.ts` | 8 | BBB Learning Analytics callback (JWT, storage, upsert) |
| `tests/api/webhooks/stripe.test.ts` | 19 |

### Top-Level — `tests/api/` root (8 files)

| File | Tests |
|------|:-----:|
| `tests/api/contact.test.ts` | 13 |
| `tests/api/db-test.test.ts` | 5 |
| `tests/api/faq.test.ts` | 13 |
| `tests/api/flags.test.ts` | 20 |
| `tests/api/leaderboard.test.ts` | 17 |
| `tests/api/stats.test.ts` | 6 |
| `tests/api/team.test.ts` | 8 |
| `tests/api/testimonials.test.ts` | 18 |

### Discovery — `tests/api/discovery/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/discovery/rails.test.ts` | 2 |

`GET /api/discovery/rails` serving endpoint — KV-read path + on-demand D1 compute fallback (DISCOVERY-RAILS Phase 2).

---

## Lib Tests — `tests/lib/` recursive (31 files: 30 in `tests/lib/`, 1 in `tests/lib/video/`)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/lib/auth-modal.test.ts` | 32 | Auth modal state management, initialEmail threading for session expiry |
| `tests/lib/availability-config.test.ts` | 6 | `loadAvailabilityWindowDays` (default 14, clamps bad/absent values, `[1, MAX]`) + `saveAvailabilityWindowDays` (ON-CONFLICT upsert of the `availability_window_days` `platform_stats` dial, seed-row self-heal) — shared window loader for the /courses "Available soon" filter + course-detail preview (CAF, Conv 387) |
| `tests/lib/booking.test.ts` | 31 | Booking: positional assignment, reflow, eligibility, backfill, enrollment completion, post-session actions, detectOrphanedParticipants |
| `tests/lib/current-user-cache.test.ts` | 27 | Cache structural guard, stale-while-revalidate, lifecycle, expired identity storage |
| `tests/lib/current-user-community-feeds.test.ts` | 14 | Community memberships (getCommunityMemberships, isMemberOf, getSystemFeed), feed index (getFeeds) |
| `tests/lib/current-user-listeners.test.ts` | 15 | Change listeners (subscribe/unsubscribe/notify), useCurrentUser hook, unread counts, setCurrentUser dedup (id+dataVersion guard) |
| `tests/lib/current-user-role-identity.test.ts` | 12 | Canonical account-level identity getters `isCreator`/`isTeacher`/`isStudent`/`isModerator` (behavioral; moderator/admin assigned) — capability/identity axis |
| `tests/lib/roles-sql.test.ts` | 3 | Canonical `isCreatorSubquery`/`isTeacherSubquery` SQL fragment builders (pure strings, client-bundle-safe) |
| `tests/lib/roles-labels.test.ts` | 7 | Role-label axis rule: `userRoles`/`describeRoles` derive Creator/Teacher from behavioral `is_creator`/`is_teacher`; granted-but-0-course creator reads as Student |
| `tests/lib/feed-activity.test.ts` | 11 | Feed activity D1 index: indexFeedActivity, recordFeedVisit, getFeedBadgeCounts (FEED-INTEL Phase 1) |
| `tests/lib/smart-feed-scoring.test.ts` | 11 | Smart feed scoring: weight application, signal combination, member/discovery profiles, reason determination, recency decay |
| `tests/lib/smart-feed-candidates.test.ts` | 9 | Smart feed candidates: getUserFeedList, getDismissedFeeds, getMemberCandidates (cursor, unseen, own-post exclusion) |
| `tests/lib/smart-feed-marketing.test.ts` | 19 | getMarketingCandidates: de-personalized sample-post pool (recency window, public-only, viewer/flag exclusion, per-feed diversity) + rails-backed cards (reason mapping, good-card bar, cross-rail + sample dedupe, lens ordering), `smart_feed_dismissals` filtering both pools (HOME-FEED-MERGE Phase 1) |
| `tests/lib/smart-feed-orchestrator.test.ts` | 13 | getSmartFeed unified 3-kind stream: visitor/member modes, suggestion-card inclusion, Option-A `(created_at,id)` cursor, cold-start, empty, viewer-auth-branched ctaUrl threading (HOME-FEED-MERGE Phases 2+6) + entity-promo posts kept as `sample-post` kind so orchestrator injection can't drop them (FEED-U3b, Conv 274) |
| `tests/lib/smart-feed-cta.test.ts` | 6 | buildDiscoveryCtaUrl: visitor → `/signup?redirect=<encoded entity>` (course/community, `?via=` preserved inside), authed → direct entity link, fail-safe visitor default (HOME-FEED-MERGE Phase 6) |
| `tests/lib/discovery-rails.test.ts` | 18 | Discovery rails aggregation: 6-rail compute (trending/popular/new × course/community) from D1, `platform_stats` `discovery_%` dials, JS-computed window cutoffs, refresh writer (DISCOVERY-RAILS Phases 1+3) |
| `tests/lib/discovery-rails-client.test.ts` | 14 | Discovery rails client: loadDiscoveryRails (localStorage cache + TTL/version freshness + stale-fallback), clearDiscoveryRailsCache, applyPersonalizationLens (boost/filter by topicIds) (DISCOVERY-RAILS Phase 4) |
| `tests/lib/promotion.test.ts` | 19 | Promotion module: resolvePromotionTarget (course→community via progression, community→system, null when un-promotable), canPromote role matrix, bcrypt password gate over `platform_stats`, recordPromotion event writer (PROMOTE-PIPELINE) |
| `tests/lib/promotion-lane.test.ts` | 5 | Promoted-lane read-side: getPromotedActivities (target-feed query, recency order, limit/sinceDays, lineage fields) (PROMOTE-PIPELINE) |
| `tests/lib/promotion-config.test.ts` | 9 | loadPromotionConfig: `platform_stats` `promo_%` dials (active-duration/retention/`nudge_min_engagement`/`post_min_engagement`), escaped `LIKE 'promo\_%'` won't swallow the gate-password key, defaults when dials absent, `nudgeMinEngagement`/`postMinEngagement` override incl. `0` (FEED-U3a/U3d/U3D-POST) + savePromotionConfig: batched ON-CONFLICT upsert of all four dials, seed-row self-heal (FEED-U3c, Conv 276; U3d dial Conv 278; post-engagement dial Conv 279) |
| `tests/lib/promotion-engagement.test.ts` | 7 | Pure per-post promote-highlight helpers (client-bundle-safe, no D1): `postEngagement` (sums every reaction kind + comments, defensive on missing/NaN) + `isPromoteHot` (≥ floor → hot, `0` always-highlight, `undefined` floor → quiet default) (U3D-POST, Conv 279) |
| `tests/lib/promotion-retention.test.ts` | 3 | purgeExpiredPromotions: strftime ISO window delete on `promo_retention_days`, non-positive-retention no-op guard (FEED-U3a, Conv 274) |
| `tests/lib/promotion-moderation.test.ts` | 7 | listSystemPromotions (join promoter+author, `to_feed_type='system'` scope) + removeSystemPromotion (scope-guarded delete — can't remove a community/course promotion) (FEED-U3c, Conv 276) |
| `tests/lib/announcements.test.ts` | 15 | Platform announcements (D1-only): createAnnouncement (insert + `notify` system-notification fan-out to ACTIVE users only), getAnnouncementCandidates active-window (dial fallback, explicit `active_until` override, per-user dismissal filter, visitor null-userId path, cap/newest-first), dismissAnnouncement idempotency, listAnnouncements/removeAnnouncement (cascade dismissals), purgeExpiredAnnouncements (retention + still-active guard, non-positive no-op), smart-feed integration (pinned atop first page, absent on page 2) (FEED-U3c④, Conv 277) |
| `tests/lib/messaging.test.ts` | 20 | canMessage policy rules, getMessageableFlags, SQL search |
| `tests/lib/notifications.test.ts` | 39 | Notification processing and display |
| `tests/lib/session-reminders.test.ts` | 6 | `sendSessionReminders` cron — partition-band windows (24h advance / 1h imminent) stamp `reminder_24h_sent_at`/`reminder_1h_sent_at`, per-recipient-tz email copy, ≤24h window filter (skips far-future/past), dedup (no re-send of a stamped slot), skips non-`scheduled` sessions, always-on in-app notif + email-pref-gated send (SESSION-REMIND, Conv 375) |
| `tests/lib/permissions.test.ts` | 5 | `canUploadCommunityResources` gating — creator/admin allow, member/null deny, retired `'teacher'` never grants (COMMUNITY-TEACHER-KILL) |
| `tests/lib/progression-capstone.test.ts` | 5 | `isProgressionCapstone` — learning-path last course → true; mid-path / standalone-at-last / no-progression / unknown-id → false (ROLE-STUDIOS v2 progression-gap, decision A, NUDGE-TC-V2 Conv 286) |
| `tests/lib/r2-recording.test.ts` | 16 | R2 recording replication: parseBlindsideCaptureUrl, generateRecordingKey, replicateRecordingToR2 |
| `tests/lib/video/bbb.test.ts` | 48 | BBB video provider integration |

---

## Integration Tests — `tests/integration/` (10 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/integration/bbb-connectivity.test.ts` | 4 | BBB server connectivity |
| `tests/integration/database.test.ts` | 0 | Database connectivity (empty) |
| `tests/integration/message-lifecycle.test.ts` | 13 | Send → count → read → multi-conversation |
| `tests/integration/notification-lifecycle.test.ts` | 21 | Full notification lifecycle |
| `tests/integration/session-invite.test.ts` | 15 | Session invite create, accept, decline, reschedule, expiry, version bump, accepted invite listing |
| `tests/integration/session-invite-notifications.test.ts` | 3 | Unmocked notification verification for invites |
| `tests/integration/session-invite-two-user.test.ts` | 9 | Two-user notification isolation: teacher creates invite → student badge, acceptance → teacher notification, mark-as-read, lifecycle |
| `tests/integration/enrollment-guards.test.ts` | 11 | Creator/teacher self-enrollment, duplicate, re-enrollment, no-teachers, partial unique index |
| `tests/integration/session-lifecycle.test.ts` | 15 | Session booking → completion lifecycle |

---

## SSR Tests — `tests/ssr/` (3 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/ssr/about.test.ts` | 7 | About page SSR rendering |
| `tests/ssr/courses.test.ts` | 20 | Course pages SSR (+ Conv 165 [CRT-1] role flags on `fetchCourseTabData`) |
| `tests/ssr/static.test.ts` | 14 | Static page generation |

---

## Unit Tests — `tests/unit/` (17 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/unit/admin-intel/admin-badge.test.tsx` | 12 | AdminBadge counts, 99+, sizes, colors, tooltips, aria |
| `tests/unit/admin-intel/admin-community-tab.test.tsx` | 6 | AdminCommunityTab full/compact rendering, flags, member count |
| `tests/unit/admin-intel/admin-course-tab.test.tsx` | 6 | AdminCourseTab full/compact rendering, flags, stat cards |
| `tests/unit/admin-intel/admin-dashboard-card.test.tsx` | 7 | AdminDashboardCard pending items, links, all-clear state, loading/error |
| `tests/unit/admin-intel/admin-links.test.ts` | 10 | All admin-links URL mappings |
| `tests/unit/admin-intel/admin-member-summary.test.tsx` | 5 | AdminMemberSummary full/compact rendering, status, roles |
| `tests/unit/admin-intel/bidirectional-links.test.tsx` | 9 | Bidirectional links hrefs and admin red styling in detail components |
| `tests/unit/availability-utils.test.ts` | 26 | Calendar merge algorithm, overrides, recurring |
| `tests/unit/example.test.ts` | 8 | Example/template test |
| `tests/unit/expiry-helpers.test.ts` | 4 | Moderation/moderator-invite expiry helpers — `getSuspensionEndDate` + `getExpiresAt` advance by exactly N×24h in UTC (not host-local wall clock) across a DST transition; 1d/permanent + invite/resend +14d (TZ-TESTS, Conv 375) |
| `tests/unit/is-valid-timezone.test.ts` | 5 | `isValidTimezone` IANA validation gate — accepts valid zones, rejects malformed/empty/non-string, narrows the type (type guard) at the register/profile boundary (TZ-TESTS, Conv 375) |
| `tests/unit/journey-loop-tabs.test.ts` | 19 | Course nav builders `buildCourseExploreTabs` / `buildCourseJourney` / `buildCourseSessionActions` + `isSessionsContext` — Explore tabs, Journey funnel gates + meter + Certificate gate, Sessions actions cluster; enrolled-only Homework tab appended iff `isEnrolled` (HW-SUBMIT-UI, Conv 387) |
| `tests/unit/period-dates.test.ts` | 3 | Earnings `getPeriodDates` — month/year boundary uses the UTC month/year for an instant that has rolled over in UTC but not in Toronto; `all_time` fixed epoch floor→now (TZ-TESTS, Conv 375) |
| `tests/unit/ratings.test.ts` | 13 | Rating calculations |
| `tests/unit/timezone.test.ts` | 20 | `localToUTC` (EDT/EST/UTC/Tokyo) + DST-transition boundary regression (NY/Sydney spring-forward/fall-back fixpoint correction, Conv 371) + `formatLocalTime` |
| `tests/unit/nav/ControlBar.test.tsx` | 4 | Mobile bottom bar — 5 Arrangement-A shortcuts + hrefs (Home·Courses·Communities·Members·Messages), no dead `/saved`+`/todo` links, active `aria-current="page"`, Home exact-match only |
| `tests/unit/nav/mobile-nav-drawer.test.tsx` | 7 | NavMenuButton `nav:open` dispatch; NavDrawer open (role-aware Sidebar) / close (X, Escape); Sidebar `variant="drawer"` close-X vs collapse control |

---

## Middleware Tests — `tests/` root (1 file)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/middleware.test.ts` | 88 | Auth guard middleware — public routes, public-browsable, protected prefixes, protected exact-match, redirect with return URL; `/feed` visitor special-case (unauth → `/`, not `/login`) (Conv 267 [HOME-FEED-MERGE]) |

---

## Page Tests — `tests/pages/` (9 files)

See [TEST-PAGES.md](TEST-PAGES.md) for details.

| Area | File | Tests |
|------|------|:-----:|
| **Auth** | | |
| | `tests/pages/auth/LoginForm.test.tsx` | 21 |
| | `tests/pages/auth/PasswordResetForm.test.tsx` | 27 |
| | `tests/pages/auth/SignupForm.test.tsx` | 24 |
| **Creators** | | |
| | `tests/pages/creators/CreatorProfile.test.tsx` | 40 |
| **Dashboard** | | |
| | `tests/pages/dashboard/CreatorDashboard.test.tsx` | 46 |
| | `tests/pages/dashboard/StudentDashboard.test.tsx` | 28 |
| | `tests/pages/dashboard/TeacherDashboard.test.tsx` | 48 |
| **Onboarding** | | |
| | `tests/pages/onboarding/onboarding.test.ts` | 7 |
| **Teachers** | | |
| | `tests/pages/teachers/TeacherProfile.test.tsx` | 58 |

---

## PLATO Tests — `tests/plato/` (3 test files)

PLATO is an API-level user journey testing framework using Model B (sequential DB-accumulation). Each "step" models a page visit with button presses that trigger API calls. Steps compose into scenarios — independent, goal-driven chains with their own persona sets and DB verifications. See `docs/as-designed/plato.md` for design rationale and `docs/reference/PLATO-GUIDE.md` for the practical guide.

| File | Scenarios / Instances | Coverage |
|------|:---------------------:|----------|
| `tests/plato/api/plato-scenarios.api.test.ts` | 7 scenarios + 12 instances + dynamic | Flywheel (15 steps) + Ecosystem (18 steps) + Activities (8 steps) + Seed-dev (53 steps) + Flywheel-to-enrollment + Session-invite (12 steps) + Member-directory (1 step) + New-user-pair instance (8 BrowserIntents) + Flywheel instance (14 BrowserIntents) + Flywheel-pre-9 instance + Flywheel-pre-11 instance (snapshot) + Flywheel-pre-12 instance (snapshot) + Flywheel-pre-14 instance (snapshot) + Flywheel-pre-15 instance (snapshot) + Seed-dev instance (snapshot) + Session-invite instance (6 BrowserIntents, snapshot) + Member-directory instance (8 BrowserIntents) + Activities instance (snapshot) + Ecosystem instance (snapshot) + dynamic PLATO_INSTANCE runner |
| `tests/plato/lib/waypoint-graph.test.ts` | unit (6 tests) | Waypoint DAG builder — node/edge derivation from `snapshot`/`capturesTo`/`restoreFrom`, transitive-closure source hash, validation (dangling-restoreFrom/no-producer/cycle), topo-sort, transitive-staleness proof (editing a chain-only step marks the right downstream waypoints STALE) |
| `tests/plato/lib/waypoint-status.test.ts` | unit (4 tests) | FRESH/STALE/MISSING computation, `descendantsOf` traversal, pure `planWaypointRun` |

### PLATO Scenarios

| File | Purpose |
|------|---------|
| `tests/plato/scenarios/flywheel.scenario.ts` | Genesis flywheel — 15 steps, single course, learn-teach-earn cycle (`complete-course` decomposed into `book-sessions` + `complete-sessions`) |
| `tests/plato/scenarios/ecosystem.scenario.ts` | Multi-course/multi-student — 2 courses, 3 students, 7 DB verifications |
| `tests/plato/scenarios/activities.scenario.ts` | Atomic steps — tests all 8 atomic steps (session, message, follow, homework, availability, browse-members) |
| `tests/plato/scenarios/seed-dev.scenario.ts` | Seed scenario — 53 chain steps, 14 verifications, 10 actors, 6 courses (used by `db:seed:plato`) |
| `tests/plato/scenarios/flywheel-to-enrollment.scenario.ts` | Derived from flywheel — steps 1-9 + set-availability, stops before booking (snapshot bridge point) |
| `tests/plato/scenarios/flywheel-pre-9.scenario.ts` | Promoted split Pre-segment — steps 1-8, `wp-published` checkpoint (before CUT-1; creator + published course + student, no teacher) |
| `tests/plato/scenarios/flywheel-pre-11.scenario.ts` | Promoted split Pre-segment — steps 1-10 (through self-cert + set-availability), `wp-creator-ready` checkpoint before enroll-student |
| `tests/plato/scenarios/flywheel-pre-12.scenario.ts` | Promoted split Pre-segment — steps 1-11 (through enroll-student), `wp-enrolled` checkpoint after CUT-2 (the old `flywheel-to-enrollment` end-state) |
| `tests/plato/scenarios/flywheel-pre-14.scenario.ts` | Promoted split Pre-segment — steps 1-13 (through book-sessions), `wp-booked` checkpoint (3 sessions scheduled, before CUT-3) |
| `tests/plato/scenarios/flywheel-pre-15.scenario.ts` | Promoted split Pre-segment — steps 1-14 (through complete-sessions), `wp-completed` checkpoint after CUT-3 (3 sessions completed, enrollment completed) |
| `tests/plato/scenarios/session-invite.scenario.ts` | Session invite — 12-step chain from register through accept-invite |
| `tests/plato/scenarios/member-directory.scenario.ts` | Standalone member directory — 1 step with SQL top-up for privacy_public |
| `tests/plato/scenarios/seed-dev-topup.ts` | 36 SqlTopUp enrichment steps — reviews, transactions, certificates, moderation, notifications, expertise, etc. |
| `tests/plato/scenarios/index.ts` | Scenario registry and loader |

### PLATO Steps

| File | Purpose |
|------|---------|
| `tests/plato/steps/register-creator.step.ts` | Register creator account via auth API |
| `tests/plato/steps/grant-creator-role.step.ts` | Admin grants creator role |
| `tests/plato/steps/create-community.step.ts` | Creator creates a community |
| `tests/plato/steps/upload-community-resources.step.ts` | Creator uploads community resources (external links, JSON path — no R2) |
| `tests/plato/steps/create-course.step.ts` | Creator creates a course in the community |
| `tests/plato/steps/add-modules.step.ts` | Creator adds modules/lessons to course |
| `tests/plato/steps/publish-course.step.ts` | Creator publishes the course |
| `tests/plato/steps/register-student.step.ts` | Register student account via auth API |
| `tests/plato/steps/self-certify-creator.step.ts` | Stripe Connect + creator self-certifies as teacher |
| `tests/plato/steps/add-teacher-cert.step.ts` | Per-course teacher certification (no Stripe Connect) |
| `tests/plato/steps/enroll-student.step.ts` | Course discovery, checkout, Stripe webhook enrollment (supports `findBy` for multi-course) |
| `tests/plato/steps/complete-course.step.ts` | 3x (book session + BBB webhook) → enrollment auto-complete (shared step; unchanged, used by ecosystem/seed-dev) |
| `tests/plato/steps/book-sessions.step.ts` | Flywheel split of `complete-course` — books 3 sessions (pure-UI, `POST /api/sessions` ×3), before CUT-3 → `wp-booked` |
| `tests/plato/steps/complete-sessions.step.ts` | Flywheel split of `complete-course` — discovers scheduled sessions (`GET`), fires 3 BBB `room_ended` webhooks (CUT-3 bridge) → `wp-completed`, enrollment auto-completes |
| `tests/plato/steps/certify-teacher.step.ts` | Creator certifies student → flywheel closes (uses `$actor.student.userId` directly) |
| `tests/plato/steps/book-complete-session.step.ts` | Atomic book + complete session (single session cycle) |
| `tests/plato/steps/cancel-session.step.ts` | Atomic book + cancel session |
| `tests/plato/steps/send-message.step.ts` | Create conversation + send messages |
| `tests/plato/steps/follow-user.step.ts` | Follow creator via handle discovery |
| `tests/plato/steps/create-homework.step.ts` | Creator creates homework assignment |
| `tests/plato/steps/submit-homework.step.ts` | Student submits homework |
| `tests/plato/steps/set-availability.step.ts` | Teacher sets weekly availability |
| `tests/plato/steps/submit-expectations.step.ts` | Student submits learning expectations post-enrollment |
| `tests/plato/steps/complete-onboarding.step.ts` | Complete onboarding profile (goal + tags) |
| `tests/plato/steps/send-session-invite.step.ts` | Teacher discovers enrollment, sends session invite, verifies pending status |
| `tests/plato/steps/accept-session-invite.step.ts` | Student discovers enrollment, lists invites, accepts, verifies session created |
| `tests/plato/steps/browse-members.step.ts` | Read-only step exercising GET /api/members with 4 query variations (default, role filter, search, pagination) |
| `tests/plato/steps/_chain.ts` | Fixed ordered list of steps (legacy, used by flywheel scenario) |
| `tests/plato/steps/index.ts` | Step loader (27 steps registered) |

### PLATO Infrastructure

| File | Purpose |
|------|---------|
| `tests/plato/PLATO-REGISTRY.md` | Manifest of all PLATO assets, lineage, derivation notes, and snapshot chains |
| `tests/plato/lib/types.ts` | Type definitions (PlatoStep, PlatoScenario, StepRef, ChainEntry, PlatoInstance, PlatoInstanceFile, BrowserIntent, NavClick, etc.) — includes `snapshot?: boolean` |
| `tests/plato/lib/navigation-helper.ts` | Navigation helpers — `suggestNavigation()` and `suggestNavigationToRoute()` using same-page-first/navbar-fallback rules |
| `tests/plato/route-map.generated.ts` | Auto-generated TypeScript lookup — `routeMap`, `apiToRoutes`, `routesForApi()`, `navPathTo()`, `apisOnRoute()` |
| `tests/plato/lib/api-runner.ts` | PlatoRunner class — `executeScenario()`, `executeInstanceFile()`, `applyActorBindings()`, `applyStepOverrides()`, `when` guard evaluation |
| `tests/plato/lib/reporter.ts` | Console progress reporter with scenario, instance, and page-visit output |
| `tests/plato/lib/mock-registry.ts` | Service mock factories (Stripe, Stream, R2, email, video) — unique Stripe account IDs per call |
| `tests/plato/lib/waypoint-graph.ts` | Waypoint DAG builder (PLATO-SEQ Phase 4a) — derives nodes/edges from `snapshot`/`capturesTo`/`restoreFrom`, transitive-closure source hash, validation (dangling-restoreFrom/no-producer/cycle), topo-sort, graph-wide `graphSourceHash` |
| `tests/plato/lib/waypoint-provenance.ts` | Gitignored JSON sidecar I/O (`writeProvenance`/`readProvenance`/`currentGitRev`) — per-waypoint run-state, keeps the `.sqlite` byte-clean for the row-identity diff |
| `tests/plato/lib/waypoint-status.ts` | Shared FRESH/STALE/MISSING computation + `descendantsOf` + pure `planWaypointRun` (used by both `plato:graph status` and `plato:run`) |
| `tests/plato/snapshots/manifest.generated.json` | Committed static waypoint graph — the "known place" registry (`generatedAt`/`gitRev`/`graphSourceHash` + per-waypoint `sourceHash`, topo order); generated by `plato:graph generate` |
| `tests/plato/personas/genesis.ts` | Flywheel persona set (Mara Chen creator, Alex Rivera student, admin) |
| `tests/plato/personas/ecosystem.ts` | Ecosystem persona set (Mara 2 courses, Sarah/Marcus/Jennifer students, admin) |
| `tests/plato/personas/seed-full.ts` | Seed persona set (10 actors, 6 courses — full dev environment) |
| `tests/plato/personas/new-user-alice.ts` | Alice persona (skip onboarding) |
| `tests/plato/personas/new-user-bob.ts` | Bob persona (with onboarding goal + tags) |
| `tests/plato/personas/index.ts` | Persona set loader |

### PLATO Instances

| File | Purpose |
|------|---------|
| `tests/plato/instances/new-user-pair.instance.ts` | Two-user registration with conditional onboarding + 8 BrowserIntents |
| `tests/plato/instances/flywheel.instance.ts` | Full creator-to-student-to-teacher flywheel — 14 BrowserIntents with structured navigation |
| `tests/plato/instances/flywheel-pre-9.instance.ts` | Promoted split Pre-segment — enrollment-ready checkpoint (snapshot: true) |
| `tests/plato/instances/flywheel-pre-11.instance.ts` | Promoted split Pre-segment — `wp-creator-ready` checkpoint, steps 1-10 (snapshot: true) |
| `tests/plato/instances/ecosystem.instance.ts` | Multi-course multi-student scenario — 22 BrowserIntents across 8 phases |
| `tests/plato/instances/activities.instance.ts` | Session/homework/social activities — 18 BrowserIntents across 8 phases (includes member directory) |
| `tests/plato/instances/seed-dev.instance.ts` | Seed-dev instance — snapshot: true, runs full seed-dev scenario for local D1 seeding |
| `tests/plato/instances/session-invite.instance.ts` | Session invite browser walkthrough — 6 BrowserIntents, snapshot mode |
| `tests/plato/instances/member-directory.instance.ts` | Standalone member directory walkthrough — 8 BrowserIntents with SQL top-up |
| `tests/plato/instances/index.ts` | Instance file loader |

---

## E2E Tests — `e2e/` (28 files)

See [TEST-E2E.md](TEST-E2E.md) for details.

| File | Tests | Coverage |
|------|:-----:|----------|
| `e2e/admin-crud.spec.ts` | 6 | Admin CRUD operations |
| `e2e/admin-overview.spec.ts` | 5 | Admin dashboard overview |
| `e2e/admin-webhookstate.spec.ts` | 5 | Webhook state management |
| `e2e/auth-dashboard.spec.ts` | 4 | Auth → dashboard flow |
| `e2e/browse-enroll.spec.ts` | 5 | Browse → enrollment flow |
| `e2e/community-feed.spec.ts` | 3 | Community feed interactions |
| `e2e/community-pages.spec.ts` | 3 | Community page rendering |
| `e2e/course-detail.spec.ts` | 5 | Course detail page |
| `e2e/course-feed.spec.ts` | 3 | Course feed interactions |
| `e2e/course-learning.spec.ts` | 4 | Learning flow |
| `e2e/creator-application.spec.ts` | 3 | Creator application flow |
| `e2e/creator-dashboard.spec.ts` | 5 | Creator dashboard |
| `e2e/discovery.spec.ts` | 4 | Discovery/browse pages |
| `e2e/earnings.spec.ts` | 5 | Earnings display |
| `e2e/feed-badges.spec.ts` | 2 | Feed badge counts: display after posting, clearing after visit |
| `e2e/home-feed.spec.ts` | 3 | Home feed (chronological timeline, deprecated) |
| `e2e/homepage.spec.ts` | 5 | Homepage rendering |
| `e2e/my-feeds-card.spec.ts` | 4 | MyFeeds dashboard card on Student/Teacher/Creator dashboards |
| `e2e/notifications.spec.ts` | 9 | Notification system |
| `e2e/profiles.spec.ts` | 5 | User profiles |
| `e2e/seed-data-verification.spec.ts` | 14 | Seed data → CurrentUser pipeline verification (5 users × 3 dashboards) |
| `e2e/session-booking-flow.spec.ts` | 1 | Full booking flow |
| `e2e/session-booking.spec.ts` | 3 | Session booking UI |
| `e2e/session-completed.spec.ts` | 4 | Session completion |
| `e2e/session-completion-flow.spec.ts` | 1 | Full completion flow |
| `e2e/settings.spec.ts` | 5 | Settings pages |
| `e2e/signup-flow.spec.ts` | 4 | Signup flow |
| `e2e/teaching-dashboard.spec.ts` | 5 | Teaching dashboard |

---

## Component Tests — `tests/components/` (91 files)

See [TEST-COMPONENTS.md](TEST-COMPONENTS.md) for the full breakdown by category.

---

## Related Documentation

- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail
- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference
