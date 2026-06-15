# Component Tests

React component tests using Vitest and React Testing Library.

**Last Updated:** 2026-06-15 (Conv 286 — two changes: [TESTCOMP-DRIFT] reconciled the doc against on-disk via a verified `vitest run` (removed stale `booking/SessionJoinableView.test.tsx`; corrected 5 drifted per-file counts: SessionBooking 32→31, EnrollButton 13→17, CreatorTeacherList 21→18, Messages 19→17, ModeratorQueue 61→59), then [NUDGE-TC-V2] added a new Progression category `progression/ProgressionNudge.test.tsx` (15). Net: 93→95 files / 2,262→2,498 cases.)
**Prev:** 2026-06-14 (Conv 285 — [LIST-1COL] added new Layout category with `layout/ListingShell.test.ts` (9, source-assertion test for the single-column listing shell, CD-039))

**Total:** 95 test files

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
| CertificateDetailContent | `tests/components/admin/CertificateDetailContent.test.tsx` | 31 |
| CertificatesAdmin | `tests/components/admin/CertificatesAdmin.test.tsx` | 27 |
| CourseDetailContent | `tests/components/admin/CourseDetailContent.test.tsx` | 42 |
| CoursesAdmin | `tests/components/admin/CoursesAdmin.test.tsx` | 26 |
| CreatorApplicationsAdmin | `tests/components/admin/CreatorApplicationsAdmin.test.tsx` | 15 |
| EnrollmentDetailContent | `tests/components/admin/EnrollmentDetailContent.test.tsx` | 36 |
| EnrollmentsAdmin | `tests/components/admin/EnrollmentsAdmin.test.tsx` | 30 |
| ModerationAdmin | `tests/components/admin/ModerationAdmin.test.tsx` | 38 |
| ModerationDetailContent | `tests/components/admin/ModerationDetailContent.test.tsx` | 70 |
| PayoutDetailContent | `tests/components/admin/PayoutDetailContent.test.tsx` | 37 |
| PayoutsAdmin | `tests/components/admin/PayoutsAdmin.test.tsx` | 28 |
| SessionDetailContent | `tests/components/admin/SessionDetailContent.test.tsx` | 53 |
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
| SessionBooking | `tests/components/booking/SessionBooking.test.tsx` | 31 |
| SessionCompletedView | `tests/components/booking/SessionCompletedView.test.tsx` | 40 |
| SessionParticipantCard | `tests/components/booking/SessionParticipantCard.test.tsx` | 7 |
| SessionRoom | `tests/components/booking/SessionRoom.test.tsx` | 26 |

---

## Community/Feeds Components (7 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CourseFeed | `tests/components/community/CourseFeed.test.tsx` | 22 |
| FeedActivityCard | `tests/components/community/FeedActivityCard.test.tsx` | 35 |
| SystemFeed | `tests/components/community/SystemFeed.test.tsx` | 21 |
| FeedPost | `tests/components/feed/FeedPost.test.tsx` | 8 |
| SmartFeed | `tests/components/feed/SmartFeed.test.tsx` | 3 |
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

## Dashboard Components (5 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CreatorDashboard | `tests/components/dashboard/CreatorDashboard.test.tsx` | 20 |
| CreatorTeacherList | `tests/components/dashboard/CreatorTeacherList.test.tsx` | 18 |
| EarningsOverview | `tests/components/dashboard/EarningsOverview.test.tsx` | 13 |
| TeacherDashboard | `tests/components/dashboard/TeacherDashboard.test.tsx` | 14 |
| TeacherStudentList | `tests/components/dashboard/TeacherStudentList.test.tsx` | 21 |

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

## Learning Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ModuleContent | `tests/components/learning/ModuleContent.test.tsx` | 18 |

---

## Layout Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ListingShell | `tests/components/layout/ListingShell.test.ts` | 9 |

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

## Messages Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| Messages | `tests/components/messages/Messages.test.tsx` | 17 |

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

## Teaching Components (4 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| EarningsDetail | `tests/components/teaching/EarningsDetail.test.tsx` | 38 |
| MyStudents | `tests/components/teaching/MyStudents.test.tsx` | 43 |
| SessionHistory | `tests/components/teaching/SessionHistory.test.tsx` | 42 |
| TeacherAnalytics | `tests/components/teaching/TeacherAnalytics.test.tsx` | 31 |

---

## Testimonials Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| TestimonialsBrowse | `tests/components/testimonials/TestimonialsBrowse.test.tsx` | 53 |

---

## Summary by Category

| Category | Files | Tests |
|----------|------:|------:|
| Admin | 19 | 693 |
| Analytics | 9 | 152 |
| Auth | 1 | 11 |
| Booking | 4 | 104 |
| Community | 7 | 98 |
| Context Actions | 1 | 11 |
| Courses | 7 | 85 |
| Creator | 2 | 56 |
| Entity | 1 | 5 |
| Explore | 8 | 146 |
| Dashboard | 5 | 86 |
| Invite | 1 | 36 |
| Leaderboard | 1 | 35 |
| Learning | 1 | 18 |
| Layout | 1 | 9 |
| Marketing | 9 | 389 |
| Messages | 1 | 17 |
| Moderation | 1 | 59 |
| Notifications | 1 | 35 |
| Onboarding | 2 | 42 |
| Progression | 1 | 15 |
| Recommendations | 2 | 20 |
| Settings | 4 | 126 |
| Stories | 1 | 43 |
| Teaching | 4 | 154 |
| Testimonials | 1 | 53 |
| **Total** | **94** | **2,483** |

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-PAGES.md](TEST-PAGES.md) - Page-level tests
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands
