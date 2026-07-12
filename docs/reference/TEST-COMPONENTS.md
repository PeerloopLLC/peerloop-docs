# Component Tests

React component tests using Vitest and React Testing Library.

**Last Updated:** 2026-07-12 (Conv 390 — [CERT-MASTERY-UI]: +1 **new** file `teachers/RecommendCertButton.test.tsx` (4 — confirm→POST teaching-cert recommend, optimistic "Recommended" pill, compact/labeled variants) → new **Teachers** category (1 file / 4). Two Admin files shed cases for the retired `completion`/`mastery` cert types: `admin/CertificateDetailContent.test.tsx` 31→29, `admin/CertificatesAdmin.test.tsx` 27→26 (dropped the single-option type-filter test) → Admin 695→692. Grand total files **103→104**, cases **2,522→2,523**.)
**Prev:** 2026-07-11 (Conv 386 — [XTZ] cross-timezone regression suite. Two **new** files: `dashboard/cross-timezone-day-of.test.tsx` (2 — same instant rendered teacher LA/PDT vs student Tokyo/JST, day AND hour diverge) → Dashboard 6→7 files / 88→90, and `messages/message-timezone.test.ts` (4 — `formatMessageTime`/`formatDateHeader`/`groupMessagesByDate` per viewer stored tz, null→`" UTC"` label) → Messages 1→2 files / 17→21. Grand total files **101→103**, cases **2,516→2,522**.)
**Prev:** 2026-07-09 (Conv 377 — [TZ-BROWSER-AUTO] jsdom viewer-tz display regression suite across 6 islands (+12 tests). Two **new** files: `dashboard/TeacherUpcomingSessions.test.tsx` (2) → Dashboard 5→6 files / 86→88, and `learning/StudentSessionsList.test.tsx` (2) → Learning 1→2 files / 18→20. Three files gained +2 each: `admin/SessionDetailContent.test.tsx` 53→55 (Admin 693→695), `booking/SessionBooking.test.tsx` 31→33 (Booking 106→108), `teaching/TeacherSessionsList.test.tsx` 32→34 (Teaching 144→146). Grand total files **99→101**, cases **2,506→2,516**. The 6th island `pages/dashboard/StudentDashboard.test.tsx` (+2) is a page test — see TEST-PAGES.md.)
**Prev:** 2026-07-09 (Conv 376 — [TZ-LINT-SCAN2] SessionRoom viewer-tz fix added +2 render tests to `booking/SessionRoom.test.tsx` (26→28 — mock `useUserTimezone`, asserting viewer-tz session time + `" UTC"` null fallback with `{exact:false}`) → Booking 104→106 cases, grand total **2,504→2,506**. No new test *file*, so file count stays **99** and TEST-COVERAGE.md summary totals are unchanged.)
**Prev:** 2026-07-04 (Conv 363 — [VBAR] added `feed/SignupCtaCard.test.tsx` (2, dismissable in-feed visitor CTA) → Community 7→8 files / 98→102 cases (also SmartFeed 3→5 for the visitor-CTA interleave) and `Sidebar.test.tsx` (2, visitor Sign up/Log in affordance) → Layout 1→2 / 9→11; [THEME-CS] added `ui/ThemeToggle.test.tsx` (2, `comingSoon` disabled+badge) → UI 1→2 / 8→10. Grand total files **96→99**, cases **2,496→2,504**.)
**Prev:** 2026-07-04 (Conv 362 [MOBUP]: added new UI category `ui/MobileUpNav.test.ts` (8 — Astro source-level: `@matt-inspired` marker, `lg:hidden` mobile contract, parent href/label props, deterministic up-anchor never `history.back()`, arrow-left MattIcon, AppLayout `mobile-upnav` slot wiring) → files **95→96**, cases **2,488→2,496**.)
**Prev:** 2026-06-27 (Conv 340 [TEST-FILE-COUNT]: corrected the stale grand-total row — files **94→95**, cases **2,473→2,488** — to match the category-row sums, the on-disk `tests/components/` count (95), and the header + TEST-COVERAGE.md (both already 95). The per-category rows were correct; only the total row was left un-resummed after the Conv-339 swap.)
**Prev:** 2026-06-26 (Conv 339 — [SESSHIST]/[OLD-PORTED-CLEANUP] retired `teaching/SessionHistory.test.tsx` (42) and added `teaching/TeacherSessionsList.test.tsx` (32); Teaching cases 154→144, file count unchanged (4).)
**Prev:** 2026-06-15 (Conv 286 — two changes: [TESTCOMP-DRIFT] reconciled the doc against on-disk via a verified `vitest run` (removed stale `booking/SessionJoinableView.test.tsx`; corrected 5 drifted per-file counts: SessionBooking 32→31, EnrollButton 13→17, CreatorTeacherList 21→18, Messages 19→17, ModeratorQueue 61→59), then [NUDGE-TC-V2] added a new Progression category `progression/ProgressionNudge.test.tsx` (15). Net: 93→95 files / 2,262→2,498 cases.)

**Total:** 104 test files

---

## Overview

Component tests validate:
- Rendering with various props
- User interactions (clicks, form inputs)
- API call mocking and response handling
- Loading, error, and empty states
- Accessibility (roles, labels)

All components use mocked API responses via `vi.mock()`.

---

## Admin Components (19 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| AdminDashboard | `tests/components/admin/AdminDashboard.test.tsx` | 39 |
| CategoriesAdmin | `tests/components/admin/CategoriesAdmin.test.tsx` | 47 |
| CertificateDetailContent | `tests/components/admin/CertificateDetailContent.test.tsx` | 29 |
| CertificatesAdmin | `tests/components/admin/CertificatesAdmin.test.tsx` | 26 |
| CourseDetailContent | `tests/components/admin/CourseDetailContent.test.tsx` | 42 |
| CoursesAdmin | `tests/components/admin/CoursesAdmin.test.tsx` | 26 |
| CreatorApplicationsAdmin | `tests/components/admin/CreatorApplicationsAdmin.test.tsx` | 15 |
| EnrollmentDetailContent | `tests/components/admin/EnrollmentDetailContent.test.tsx` | 36 |
| EnrollmentsAdmin | `tests/components/admin/EnrollmentsAdmin.test.tsx` | 30 |
| ModerationAdmin | `tests/components/admin/ModerationAdmin.test.tsx` | 38 |
| ModerationDetailContent | `tests/components/admin/ModerationDetailContent.test.tsx` | 70 |
| PayoutDetailContent | `tests/components/admin/PayoutDetailContent.test.tsx` | 37 |
| PayoutsAdmin | `tests/components/admin/PayoutsAdmin.test.tsx` | 28 |
| SessionDetailContent | `tests/components/admin/SessionDetailContent.test.tsx` | 55 |
| SessionsAdmin | `tests/components/admin/SessionsAdmin.test.tsx` | 48 |
| TeacherDetailContent | `tests/components/admin/TeacherDetailContent.test.tsx` | 37 |
| TeachersAdmin | `tests/components/admin/TeachersAdmin.test.tsx` | 34 |
| UserDetailContent | `tests/components/admin/UserDetailContent.test.tsx` | 31 |
| UsersAdmin | `tests/components/admin/UsersAdmin.test.tsx` | 24 |

---

## Analytics Components (9 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| AdminAnalytics | `tests/components/analytics/AdminAnalytics.test.tsx` | 20 |
| CoursePerformanceTable | `tests/components/analytics/CoursePerformanceTable.test.tsx` | 19 |
| CreatorAnalytics | `tests/components/analytics/CreatorAnalytics.test.tsx` | 37 |
| EnrollmentTrendsChart | `tests/components/analytics/EnrollmentTrendsChart.test.tsx` | 13 |
| FunnelAnalysis | `tests/components/analytics/FunnelAnalysis.test.tsx` | 11 |
| MetricsRow | `tests/components/analytics/MetricsRow.test.tsx` | 11 |
| ProgressDistribution | `tests/components/analytics/ProgressDistribution.test.tsx` | 9 |
| SessionAnalytics | `tests/components/analytics/SessionAnalytics.test.tsx` | 14 |
| TeacherPerformanceTable | `tests/components/analytics/TeacherPerformanceTable.test.tsx` | 18 |

---

## Auth Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| useCreatorGate | `tests/components/auth/useCreatorGate.test.ts` | 11 |

---

## Booking/Sessions Components (4 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| SessionBooking | `tests/components/booking/SessionBooking.test.tsx` | 33 |
| SessionCompletedView | `tests/components/booking/SessionCompletedView.test.tsx` | 40 |
| SessionParticipantCard | `tests/components/booking/SessionParticipantCard.test.tsx` | 7 |
| SessionRoom | `tests/components/booking/SessionRoom.test.tsx` | 28 |

---

## Community/Feeds Components (8 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CourseFeed | `tests/components/community/CourseFeed.test.tsx` | 22 |
| FeedActivityCard | `tests/components/community/FeedActivityCard.test.tsx` | 35 |
| SystemFeed | `tests/components/community/SystemFeed.test.tsx` | 21 |
| FeedPost | `tests/components/feed/FeedPost.test.tsx` | 8 |
| SmartFeed | `tests/components/feed/SmartFeed.test.tsx` | 5 |
| SignupCtaCard | `tests/components/feed/SignupCtaCard.test.tsx` | 2 |
| EntityPromoComposer | `tests/components/feed/EntityPromoComposer.test.tsx` | 3 |
| PromoteNudge | `tests/components/promotion/PromoteNudge.test.tsx` | 6 |

---

## Context Actions Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ContextActionsPanel | `tests/components/context-actions/ContextActionsPanel.test.tsx` | 11 |

---

## Explore Components (8 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| role-utils | `tests/components/discover/role-utils.test.ts` | 37 |
| RoleBadge | `tests/components/discover/RoleBadge.test.tsx` | 21 |
| ExploreTabBar | `tests/components/discover/ExploreTabBar.test.tsx` | 7 |
| RolePillFilters | `tests/components/discover/RolePillFilters.test.tsx` | 8 |
| community-role-utils | `tests/components/discover/community-role-utils.test.ts` | 24 |
| ExploreCommunityCard | `tests/components/discover/ExploreCommunityCard.test.tsx` | 16 |
| CommunityRolePillFilters | `tests/components/discover/CommunityRolePillFilters.test.tsx` | 11 |
| feed-role-utils | `tests/components/discover/feed-role-utils.test.ts` | 22 |

---

## Course Components (7 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CourseTabs | `tests/components/courses/CourseTabs.test.tsx` | 19 |
| EnrollButton | `tests/components/courses/EnrollButton.test.tsx` | 17 |
| LearnTab | `tests/components/courses/LearnTab.test.tsx` | 18 |
| MilestoneComposer | `tests/components/course/MilestoneComposer.test.tsx` | 6 |
| ModuleAccordion | `tests/components/courses/ModuleAccordion.test.tsx` | 11 |
| MyCourses | `tests/components/courses/MyCourses.test.tsx` | 7 |
| ResourcesTabContent | `tests/components/courses/course-tabs/ResourcesTabContent.test.tsx` | 7 |

---

## Creator Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CreatorApplicationForm | `tests/components/creator/CreatorApplicationForm.test.tsx` | 15 |
| CreatorStudio | `tests/components/creator/CreatorStudio.test.tsx` | 41 |

---

## Entity Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CommunityAnchor | `tests/components/entity/CommunityAnchor.test.tsx` | 5 |

---

## Dashboard Components (7 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CreatorDashboard | `tests/components/dashboard/CreatorDashboard.test.tsx` | 20 |
| CreatorTeacherList | `tests/components/dashboard/CreatorTeacherList.test.tsx` | 18 |
| EarningsOverview | `tests/components/dashboard/EarningsOverview.test.tsx` | 13 |
| TeacherDashboard | `tests/components/dashboard/TeacherDashboard.test.tsx` | 14 |
| TeacherStudentList | `tests/components/dashboard/TeacherStudentList.test.tsx` | 21 |
| TeacherUpcomingSessions | `tests/components/dashboard/TeacherUpcomingSessions.test.tsx` | 2 |
| Cross-TZ day-of (XTZ) | `tests/components/dashboard/cross-timezone-day-of.test.tsx` | 2 |

---

## Invite Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ModeratorInvite | `tests/components/invite/ModeratorInvite.test.tsx` | 36 |

---

## Leaderboard Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| Leaderboard | `tests/components/leaderboard/Leaderboard.test.tsx` | 35 |

---

## Learning Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ModuleContent | `tests/components/learning/ModuleContent.test.tsx` | 18 |
| StudentSessionsList | `tests/components/learning/StudentSessionsList.test.tsx` | 2 |

---

## Layout Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ListingShell | `tests/components/layout/ListingShell.test.ts` | 9 |
| Sidebar | `tests/components/Sidebar.test.tsx` | 2 |

---

## Marketing Page Components (9 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| AboutPage | `tests/components/marketing/AboutPage.test.tsx` | 31 |
| BecomeATeacherPage | `tests/components/marketing/BecomeATeacherPage.test.tsx` | 49 |
| ContactPage | `tests/components/marketing/ContactPage.test.tsx` | 57 |
| FaqPage | `tests/components/marketing/FaqPage.test.tsx` | 40 |
| ForCreatorsPage | `tests/components/marketing/ForCreatorsPage.test.tsx` | 42 |
| HowItWorksPage | `tests/components/marketing/HowItWorksPage.test.tsx` | 34 |
| PricingPage | `tests/components/marketing/PricingPage.test.tsx` | 38 |
| PrivacyPolicyPage | `tests/components/marketing/PrivacyPolicyPage.test.tsx` | 51 |
| TermsOfServicePage | `tests/components/marketing/TermsOfServicePage.test.tsx` | 47 |

---

## Messages Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| Messages | `tests/components/messages/Messages.test.tsx` | 17 |
| Message time (viewer-tz, XTZ) | `tests/components/messages/message-timezone.test.ts` | 4 |

---

## Moderation Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ModeratorQueue | `tests/components/mod/ModeratorQueue.test.tsx` | 59 |

---

## Notifications Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| NotificationsList | `tests/components/notifications/NotificationsList.test.tsx` | 35 |

---

## Onboarding Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| OnboardingNudgeBanner | `tests/components/onboarding/OnboardingNudgeBanner.test.tsx` | 14 |
| OnboardingProfile | `tests/components/onboarding/OnboardingProfile.test.tsx` | 28 |

---

## Progression Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ProgressionNudge | `tests/components/progression/ProgressionNudge.test.tsx` | 15 |

---

## Recommendations Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| RecommendedCommunities | `tests/components/recommendations/RecommendedCommunities.test.tsx` | 11 |
| RecommendedCourses | `tests/components/recommendations/RecommendedCourses.test.tsx` | 9 |

---

## Settings Components (4 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| NotificationSettings | `tests/components/settings/NotificationSettings.test.tsx` | 28 |
| ProfileSettings | `tests/components/settings/ProfileSettings.test.tsx` | 33 |
| SecuritySettings | `tests/components/settings/SecuritySettings.test.tsx` | 29 |
| StripeConnectSettings | `tests/components/settings/StripeConnectSettings.test.tsx` | 36 |

---

## Stories Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| StoriesBrowse | `tests/components/stories/StoriesBrowse.test.tsx` | 43 |

---

## Teachers Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| RecommendCertButton | `tests/components/teachers/RecommendCertButton.test.tsx` | 4 |

---

## Teaching Components (4 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| EarningsDetail | `tests/components/teaching/EarningsDetail.test.tsx` | 38 |
| MyStudents | `tests/components/teaching/MyStudents.test.tsx` | 43 |
| TeacherAnalytics | `tests/components/teaching/TeacherAnalytics.test.tsx` | 31 |
| TeacherSessionsList | `tests/components/teaching/TeacherSessionsList.test.tsx` | 34 |

---

## Testimonials Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| TestimonialsBrowse | `tests/components/testimonials/TestimonialsBrowse.test.tsx` | 53 |

---

## UI Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| MobileUpNav | `tests/components/ui/MobileUpNav.test.ts` | 8 |
| ThemeToggle | `tests/components/ui/ThemeToggle.test.tsx` | 2 |

---

## Summary by Category

| Category | Files | Tests |
|----------|------:|------:|
| Admin | 19 | 692 |
| Analytics | 9 | 152 |
| Auth | 1 | 11 |
| Booking | 4 | 108 |
| Community | 8 | 102 |
| Context Actions | 1 | 11 |
| Courses | 7 | 85 |
| Creator | 2 | 56 |
| Entity | 1 | 5 |
| Explore | 8 | 146 |
| Dashboard | 7 | 90 |
| Invite | 1 | 36 |
| Leaderboard | 1 | 35 |
| Learning | 2 | 20 |
| Layout | 2 | 11 |
| Marketing | 9 | 389 |
| Messages | 2 | 21 |
| Moderation | 1 | 59 |
| Notifications | 1 | 35 |
| Onboarding | 2 | 42 |
| Progression | 1 | 15 |
| Recommendations | 2 | 20 |
| Settings | 4 | 126 |
| Stories | 1 | 43 |
| Teachers | 1 | 4 |
| Teaching | 4 | 146 |
| Testimonials | 1 | 53 |
| UI | 2 | 10 |
| **Total** | **104** | **2,523** |

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-PAGES.md](TEST-PAGES.md) - Page-level tests
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands
