# Component Tests

React component tests using Vitest and React Testing Library.

**Last Updated:** 2026-03-01 (Session 320)

**Total:** 69 test files

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

## Admin Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| AdminDashboard | `tests/components/admin/AdminDashboard.test.tsx` | Dashboard metrics, alerts |
| CategoriesAdmin | `tests/components/admin/CategoriesAdmin.test.tsx` | Category CRUD |
| CertificateDetailContent | `tests/components/admin/CertificateDetailContent.test.tsx` | Certificate details, actions |
| CertificatesAdmin | `tests/components/admin/CertificatesAdmin.test.tsx` | Certificate list, filtering |
| CourseDetailContent | `tests/components/admin/CourseDetailContent.test.tsx` | Course details, actions |
| CoursesAdmin | `tests/components/admin/CoursesAdmin.test.tsx` | Course list, filtering |
| EnrollmentDetailContent | `tests/components/admin/EnrollmentDetailContent.test.tsx` | Enrollment details, actions |
| EnrollmentsAdmin | `tests/components/admin/EnrollmentsAdmin.test.tsx` | Enrollment list, filtering |
| ModerationAdmin | `tests/components/admin/ModerationAdmin.test.tsx` | Moderation queue |
| ModerationDetailContent | `tests/components/admin/ModerationDetailContent.test.tsx` | Flag details, actions |
| PayoutDetailContent | `tests/components/admin/PayoutDetailContent.test.tsx` | Payout details, processing |
| PayoutsAdmin | `tests/components/admin/PayoutsAdmin.test.tsx` | Payout list, batch processing |
| SessionDetailContent | `tests/components/admin/SessionDetailContent.test.tsx` | Session details, recording |
| SessionsAdmin | `tests/components/admin/SessionsAdmin.test.tsx` | Session list, filtering |
| TeacherDetailContent | `tests/components/admin/TeacherDetailContent.test.tsx` | Teacher details, activation |
| TeachersAdmin | `tests/components/admin/TeachersAdmin.test.tsx` | Teacher list, filtering |
| UserDetailContent | `tests/components/admin/UserDetailContent.test.tsx` | User details, suspend/unsuspend |
| UsersAdmin | `tests/components/admin/UsersAdmin.test.tsx` | User list, filtering |
| CreatorApplicationsAdmin | `tests/components/admin/CreatorApplicationsAdmin.test.tsx` | Creator application queue, filtering, approve/deny |

**Subtotal:** 19 files

---

## Auth Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| useCreatorGate | `tests/components/auth/useCreatorGate.test.ts` | Creator access gate hook: instant cache check, stale refresh, hasCourses flag |

**Subtotal:** 1 file

---

## Analytics Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| AdminAnalytics | `tests/components/analytics/AdminAnalytics.test.tsx` | Platform analytics charts |
| CreatorAnalytics | `tests/components/analytics/CreatorAnalytics.test.tsx` | Creator dashboard analytics |

**Subtotal:** 2 files

---

## Booking/Sessions Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| SessionBooking | `tests/components/booking/SessionBooking.test.tsx` | Session booking flow |
| SessionCompletedView | `tests/components/booking/SessionCompletedView.test.tsx` | Completed session UI |
| SessionJoinableView | `tests/components/booking/SessionJoinableView.test.tsx` | Session join UI |
| SessionParticipantCard | `tests/components/booking/SessionParticipantCard.test.tsx` | Participant display |
| SessionRoom | `tests/components/booking/SessionRoom.test.tsx` | BBB session room |

**Subtotal:** 5 files

---

## Community/Feeds Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| CourseFeed | `tests/components/community/CourseFeed.test.tsx` | Course discussion feed |
| FeedActivityCard | `tests/components/community/FeedActivityCard.test.tsx` | Activity card, reactions |
| InstructorFeed | `tests/components/community/InstructorFeed.test.tsx` | Instructor announcement feed |
| TownHallFeed | `tests/components/community/TownHallFeed.test.tsx` | Platform-wide feed |

**Subtotal:** 4 files

---

## Dashboard Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| CreatorDashboard | `tests/components/dashboard/CreatorDashboard.test.tsx` | Creator dashboard stats, earnings, courses, gate states |
| TeacherDashboard | `tests/components/dashboard/TeacherDashboard.test.tsx` | Teacher dashboard, students, sessions |

**Subtotal:** 2 files

---

## Creator Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| CreatorApplicationForm | `tests/components/creator/CreatorApplicationForm.test.tsx` | Creator application form, validation, reapply flow |
| CreatorStudio | `tests/components/creator/CreatorStudio.test.tsx` | Course creation/editing |

**Subtotal:** 2 files

---

## Invite Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| ModeratorInvite | `tests/components/invite/ModeratorInvite.test.tsx` | Moderator invite flow |

**Subtotal:** 1 file

---

## Leaderboard Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| Leaderboard | `tests/components/leaderboard/Leaderboard.test.tsx` | Rankings display |

**Subtotal:** 1 file

---

## Learning Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| CourseLearning | `tests/components/learning/CourseLearning.test.tsx` | Course learning view |

**Subtotal:** 1 file

---

## Marketing Page Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| AboutPage | `tests/components/marketing/AboutPage.test.tsx` | About page content |
| BecomeATeacherPage | `tests/components/marketing/BecomeATeacherPage.test.tsx` | Teacher recruitment page |
| ContactPage | `tests/components/marketing/ContactPage.test.tsx` | Contact form |
| FaqPage | `tests/components/marketing/FaqPage.test.tsx` | FAQ accordion |
| ForCreatorsPage | `tests/components/marketing/ForCreatorsPage.test.tsx` | Creator benefits page |
| HowItWorksPage | `tests/components/marketing/HowItWorksPage.test.tsx` | Platform explainer |
| PricingPage | `tests/components/marketing/PricingPage.test.tsx` | Pricing tiers |
| TermsOfServicePage | `tests/components/marketing/TermsOfServicePage.test.tsx` | Terms, TOC navigation |

**Subtotal:** 8 files

---

## Messages Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| Messages | `tests/components/messages/Messages.test.tsx` | Conversations, messaging |

**Subtotal:** 1 file

---

## Moderation Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| ModeratorQueue | `tests/components/mod/ModeratorQueue.test.tsx` | Mod queue view |

**Subtotal:** 1 file

---

## Notifications Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| NotificationsList | `tests/components/notifications/NotificationsList.test.tsx` | Notification list, actions |

**Subtotal:** 1 file

---

## Onboarding Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| OnboardingProfile | `tests/components/onboarding/OnboardingProfile.test.tsx` | Interests & preferences form |

**Subtotal:** 1 file

---

## Recommendations Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| RecommendedCourses | `tests/components/recommendations/RecommendedCourses.test.tsx` | Personalized course band (fetch, dismiss, skeleton, error) |
| RecommendedCommunities | `tests/components/recommendations/RecommendedCommunities.test.tsx` | Personalized community band (fetch, dismiss, skeleton, error) |

**Subtotal:** 2 files

---

## Settings Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| NotificationSettings | `tests/components/settings/NotificationSettings.test.tsx` | Notification preferences |
| ProfileSettings | `tests/components/settings/ProfileSettings.test.tsx` | Profile editing |
| SecuritySettings | `tests/components/settings/SecuritySettings.test.tsx` | Password, 2FA |
| StripeConnectSettings | `tests/components/settings/StripeConnectSettings.test.tsx` | Stripe Connect onboarding |

**Subtotal:** 4 files

---

## Stories Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| StoriesBrowse | `tests/components/stories/StoriesBrowse.test.tsx` | Success stories listing |

**Subtotal:** 1 file

---

## Teaching Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| EarningsDetail | `tests/components/teaching/EarningsDetail.test.tsx` | Teacher earnings breakdown |
| MyStudents | `tests/components/teaching/MyStudents.test.tsx` | Teacher student list |
| SessionHistory | `tests/components/teaching/SessionHistory.test.tsx` | Teacher session history |
| TeacherAnalytics | `tests/components/teaching/TeacherAnalytics.test.tsx` | Teacher performance analytics |

**Subtotal:** 4 files

---

## Testimonials Components

| Component | Test File | Coverage |
|-----------|-----------|----------|
| TestimonialsBrowse | `tests/components/testimonials/TestimonialsBrowse.test.tsx` | Testimonials listing |

**Subtotal:** 1 file

---

## Summary by Category

| Category | Files |
|----------|------:|
| Admin | 19 |
| Auth | 1 |
| Analytics | 2 |
| Booking | 5 |
| Community | 4 |
| Creator | 2 |
| Dashboard | 2 |
| Invite | 1 |
| Leaderboard | 1 |
| Learning | 1 |
| Marketing | 8 |
| Messages | 1 |
| Moderation | 1 |
| Notifications | 1 |
| Onboarding | 1 |
| Recommendations | 2 |
| Settings | 4 |
| Stories | 1 |
| Teaching | 4 |
| Testimonials | 1 |
| **Total** | **62** |

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-PAGES.md](TEST-PAGES.md) - Page-level tests
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands
