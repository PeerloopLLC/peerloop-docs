# Component Tests

React component tests using Vitest and React Testing Library.

**Last Updated:** 2026-03-16 (Session 390 — reconciled counts)

**Total:** 74 test files

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

## Booking/Sessions Components (5 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| SessionBooking | `tests/components/booking/SessionBooking.test.tsx` | 32 |
| SessionCompletedView | `tests/components/booking/SessionCompletedView.test.tsx` | 40 |
| SessionJoinableView | `tests/components/booking/SessionJoinableView.test.tsx` | 13 |
| SessionParticipantCard | `tests/components/booking/SessionParticipantCard.test.tsx` | 7 |
| SessionRoom | `tests/components/booking/SessionRoom.test.tsx` | 26 |

---

## Community/Feeds Components (3 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CourseFeed | `tests/components/community/CourseFeed.test.tsx` | 22 |
| FeedActivityCard | `tests/components/community/FeedActivityCard.test.tsx` | 26 |
| TownHallFeed | `tests/components/community/TownHallFeed.test.tsx` | 21 |

---

## Context Actions Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ContextActionsPanel | `tests/components/context-actions/ContextActionsPanel.test.tsx` | 11 |

---

## Course Components (5 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CourseTabs | `tests/components/courses/CourseTabs.test.tsx` | 11 |
| EnrollButton | `tests/components/courses/EnrollButton.test.tsx` | 13 |
| LearnTab | `tests/components/courses/LearnTab.test.tsx` | 18 |
| ModuleAccordion | `tests/components/courses/ModuleAccordion.test.tsx` | 11 |
| MyCourses | `tests/components/courses/MyCourses.test.tsx` | 7 |

---

## Creator Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CreatorApplicationForm | `tests/components/creator/CreatorApplicationForm.test.tsx` | 15 |
| CreatorStudio | `tests/components/creator/CreatorStudio.test.tsx` | 41 |

---

## Dashboard Components (5 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CreatorDashboard | `tests/components/dashboard/CreatorDashboard.test.tsx` | 20 |
| CreatorTeacherList | `tests/components/dashboard/CreatorTeacherList.test.tsx` | 21 |
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
| Messages | `tests/components/messages/Messages.test.tsx` | 19 |

---

## Moderation Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ModeratorQueue | `tests/components/mod/ModeratorQueue.test.tsx` | 61 |

---

## Notifications Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| NotificationsList | `tests/components/notifications/NotificationsList.test.tsx` | 35 |

---

## Onboarding Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| OnboardingProfile | `tests/components/onboarding/OnboardingProfile.test.tsx` | 28 |

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
| Booking | 5 | 114 |
| Community | 3 | 69 |
| Context Actions | 1 | 11 |
| Courses | 5 | 60 |
| Creator | 2 | 56 |
| Dashboard | 5 | 89 |
| Invite | 1 | 36 |
| Leaderboard | 1 | 35 |
| Learning | 1 | 18 |
| Marketing | 9 | 389 |
| Messages | 1 | 19 |
| Moderation | 1 | 61 |
| Notifications | 1 | 35 |
| Onboarding | 1 | 28 |
| Recommendations | 2 | 20 |
| Settings | 4 | 126 |
| Stories | 1 | 43 |
| Teaching | 4 | 154 |
| Testimonials | 1 | 53 |
| **Total** | **74** | **2,060** |

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-PAGES.md](TEST-PAGES.md) - Page-level tests
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands
