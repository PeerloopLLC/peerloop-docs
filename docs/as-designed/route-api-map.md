# Route ↔ API Map

> **Auto-generated** by `scripts/route-api-map.mjs` — do not edit manually.
> Last generated: 2026-04-13
>
> Run: `cd ../Peerloop && node scripts/route-api-map.mjs`

---

## Quick Stats

- **Pages scanned:** 96
- **API endpoints found in UI:** 195
- **Routes reachable from navbar:** 89
- **Unreachable routes:** 13

## 1. Route → API Endpoints

Which API calls does each page make?

### Admin

**`/admin`** (src/pages/admin/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/dashboard` | src/components/admin/AdminDashboard.tsx |
| POST | `/api/admin/sessions/cleanup` | src/components/admin/AdminDashboard.tsx |

**`/admin/analytics`** (src/pages/admin/analytics.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/analytics` | src/components/analytics/AdminAnalytics.tsx |
| GET | `/api/admin/analytics/courses` | src/components/analytics/AdminAnalytics.tsx |
| GET | `/api/admin/analytics/engagement` | src/components/analytics/AdminAnalytics.tsx |
| GET | `/api/admin/analytics/revenue` | src/components/analytics/AdminAnalytics.tsx |
| GET | `/api/admin/analytics/teachers` | src/components/analytics/AdminAnalytics.tsx |
| GET | `/api/admin/analytics/users` | src/components/analytics/AdminAnalytics.tsx |

**`/admin/certificates`** (src/pages/admin/certificates.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/certificates` | src/components/admin/CertificatesAdmin.tsx |
| GET | `/api/admin/certificates/[param]` | src/components/admin/CertificatesAdmin.tsx |
| POST | `/api/admin/certificates/[param]/approve` | src/components/admin/CertificatesAdmin.tsx |
| POST | `/api/admin/certificates/[param]/reject` | src/components/admin/CertificatesAdmin.tsx |
| POST | `/api/admin/certificates/[param]/revoke` | src/components/admin/CertificatesAdmin.tsx |
| GET | `/api/courses` | src/components/admin/CertificatesAdmin.tsx |

**`/admin/courses`** (src/pages/admin/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/courses` | src/components/admin/CoursesAdmin.tsx |
| GET | `/api/admin/courses/[param]` | src/components/admin/CoursesAdmin.tsx |
| DELETE | `/api/admin/courses/[param]` | src/components/admin/CoursesAdmin.tsx |
| POST | `/api/admin/courses/[param]/badge` | src/components/admin/CoursesAdmin.tsx |
| GET | `/api/admin/courses/[param]/feature` | src/components/admin/CoursesAdmin.tsx |
| POST | `/api/admin/courses/[param]/suspend` | src/components/admin/CoursesAdmin.tsx |
| POST | `/api/admin/courses/[param]/unsuspend` | src/components/admin/CoursesAdmin.tsx |
| GET | `/api/topics` | src/components/admin/CoursesAdmin.tsx |

**`/admin/creator-applications`** (src/pages/admin/creator-applications.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/creator-applications` | src/components/admin/CreatorApplicationsAdmin.tsx |
| GET | `/api/admin/creator-applications/[param]` | src/components/admin/CreatorApplicationsAdmin.tsx |
| POST | `/api/admin/creator-applications/[param]/approve` | src/components/admin/CreatorApplicationsAdmin.tsx |
| POST | `/api/admin/creator-applications/[param]/deny` | src/components/admin/CreatorApplicationsAdmin.tsx |

**`/admin/enrollments`** (src/pages/admin/enrollments.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/enrollments` | src/components/admin/EnrollmentsAdmin.tsx |
| GET | `/api/admin/enrollments/[param]` | src/components/admin/EnrollmentsAdmin.tsx |
| POST | `/api/admin/enrollments/[param]/cancel` | src/components/admin/EnrollmentsAdmin.tsx |
| POST | `/api/admin/enrollments/[param]/force-complete` | src/components/admin/EnrollmentsAdmin.tsx |
| POST | `/api/admin/enrollments/[param]/reassign-teacher` | src/components/admin/EnrollmentsAdmin.tsx |
| POST | `/api/admin/enrollments/[param]/refund` | src/components/admin/EnrollmentsAdmin.tsx |
| GET | `/api/courses` | src/components/admin/EnrollmentsAdmin.tsx |

**`/admin/moderation`** (src/pages/admin/moderation.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/moderation` | src/components/admin/ModerationAdmin.tsx |
| GET | `/api/admin/moderation/[param]` | src/components/admin/ModerationAdmin.tsx |
| POST | `/api/admin/moderation/[param]/dismiss` | src/components/admin/ModerationAdmin.tsx |
| POST | `/api/admin/moderation/[param]/remove` | src/components/admin/ModerationAdmin.tsx |
| POST | `/api/admin/moderation/[param]/suspend` | src/components/admin/ModerationAdmin.tsx |
| POST | `/api/admin/moderation/[param]/warn` | src/components/admin/ModerationAdmin.tsx |

**`/admin/moderators`** (src/pages/admin/moderators.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/moderators` | src/components/admin/ModeratorsAdmin.tsx |
| POST | `/api/admin/moderators/[param]/remove` | src/components/admin/ModeratorsAdmin.tsx |
| POST | `/api/admin/moderators/[param]/resend` | src/components/admin/ModeratorsAdmin.tsx |
| POST | `/api/admin/moderators/[param]/revoke` | src/components/admin/ModeratorsAdmin.tsx |
| POST | `/api/admin/moderators/invite` | src/components/admin/ModeratorsAdmin.tsx |

**`/admin/payouts`** (src/pages/admin/payouts.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/payouts` | src/components/admin/PayoutsAdmin.tsx |
| POST | `/api/admin/payouts` | src/components/admin/PayoutsAdmin.tsx |
| GET | `/api/admin/payouts/[param]` | src/components/admin/PayoutsAdmin.tsx |
| DELETE | `/api/admin/payouts/[param]` | src/components/admin/PayoutsAdmin.tsx |
| POST | `/api/admin/payouts/[param]/process` | src/components/admin/PayoutsAdmin.tsx |
| POST | `/api/admin/payouts/[param]/retry` | src/components/admin/PayoutsAdmin.tsx |
| POST | `/api/admin/payouts/batch` | src/components/admin/PayoutsAdmin.tsx |
| GET | `/api/admin/payouts/pending` | src/components/admin/PayoutsAdmin.tsx |

**`/admin/sessions`** (src/pages/admin/sessions.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/courses` | src/components/admin/SessionsAdmin.tsx |
| GET | `/api/admin/sessions` | src/components/admin/SessionsAdmin.tsx |
| GET | `/api/admin/sessions/[param]` | src/components/admin/SessionsAdmin.tsx |
| PATCH | `/api/admin/sessions/[param]` | src/components/admin/SessionsAdmin.tsx |
| GET | `/api/admin/sessions/[param]/recording` | src/components/admin/SessionsAdmin.tsx |
| DELETE | `/api/admin/sessions/[param]/recording` | src/components/admin/SessionsAdmin.tsx |
| POST | `/api/admin/sessions/[param]/resolve` | src/components/admin/SessionsAdmin.tsx |

**`/admin/teachers`** (src/pages/admin/teachers.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/teachers` | src/components/admin/TeachersAdmin.tsx |
| GET | `/api/admin/teachers/[param]` | src/components/admin/TeachersAdmin.tsx |
| DELETE | `/api/admin/teachers/[param]` | src/components/admin/TeachersAdmin.tsx |
| POST | `/api/admin/teachers/[param]/activate` | src/components/admin/TeachersAdmin.tsx |
| POST | `/api/admin/teachers/[param]/deactivate` | src/components/admin/TeachersAdmin.tsx |
| GET | `/api/courses` | src/components/admin/TeachersAdmin.tsx |

**`/admin/topics`** (src/pages/admin/topics.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/topics` | src/components/admin/TopicsAdmin.tsx |
| POST | `/api/admin/topics` | src/components/admin/TopicsAdmin.tsx |
| PATCH | `/api/admin/topics/[param]` | src/components/admin/TopicsAdmin.tsx |
| DELETE | `/api/admin/topics/[param]` | src/components/admin/TopicsAdmin.tsx |
| POST | `/api/admin/topics/reorder` | src/components/admin/TopicsAdmin.tsx |

**`/admin/users`** (src/pages/admin/users.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/users` | src/components/admin/UsersAdmin.tsx |
| GET | `/api/admin/users/[param]` | src/components/admin/UsersAdmin.tsx |
| DELETE | `/api/admin/users/[param]` | src/components/admin/UsersAdmin.tsx |
| PATCH | `/api/admin/users/[param]` | src/components/admin/UsersAdmin.tsx |
| POST | `/api/admin/users/[param]/suspend` | src/components/admin/UsersAdmin.tsx |
| POST | `/api/admin/users/[param]/unsuspend` | src/components/admin/UsersAdmin.tsx |

### Auth

**`/login`** — *no API calls detected*

**`/onboarding`** (src/pages/onboarding.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/onboarding-profile` | src/components/onboarding/OnboardingProfile.tsx |
| POST | `/api/me/onboarding-profile` | src/components/onboarding/OnboardingProfile.tsx |
| GET | `/api/tags` | src/components/onboarding/OnboardingProfile.tsx |

**`/reset-password`** (src/pages/reset-password.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/auth/reset-password` | src/components/auth/PasswordResetForm.tsx |

**`/signup`** — *no API calls detected*

### Community

**`/community`** — *no API calls detected*

**`/community/[slug]`** (src/pages/community/[slug]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |

**`/community/[slug]/courses`** (src/pages/community/[slug]/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |

**`/community/[slug]/members`** (src/pages/community/[slug]/members.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |

**`/community/[slug]/resources`** (src/pages/community/[slug]/resources.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |

### Course

**`/course/[slug]`** (src/pages/course/[slug]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/curriculum` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/resources` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| POST | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/course/[slug]/book`** (src/pages/course/[slug]/book.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/session-invites/[param]/accept` | src/components/booking/SessionBooking.tsx |
| POST | `/api/session-invites/[param]/decline` | src/components/booking/SessionBooking.tsx |
| POST | `/api/sessions` | src/components/booking/SessionBooking.tsx |
| DELETE | `/api/sessions/[param]` | src/components/booking/SessionBooking.tsx |
| GET | `/api/teachers/[param]/availability` | src/components/booking/SessionBooking.tsx |

**`/course/[slug]/feed`** (src/pages/course/[slug]/feed.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/curriculum` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/resources` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| POST | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/course/[slug]/learn`** (src/pages/course/[slug]/learn.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/curriculum` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/resources` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| POST | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/course/[slug]/resources`** (src/pages/course/[slug]/resources.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/curriculum` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/resources` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| POST | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/course/[slug]/sessions`** (src/pages/course/[slug]/sessions.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/curriculum` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/resources` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| POST | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/course/[slug]/success`** (src/pages/course/[slug]/success.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/enrollments/[param]/expectations` | src/components/learning/ExpectationsForm.tsx |

**`/course/[slug]/teachers`** (src/pages/course/[slug]/teachers.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/curriculum` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/resources` | src/components/courses/LearnTab.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| POST | `/api/enrollments/[param]/progress` | src/components/courses/LearnTab.tsx |
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

### Creating

**`/creating`** (src/pages/creating/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/courses/[param]/discussion-feed` | src/components/dashboard/CreatorCourseCard.tsx |
| GET | `/api/me/creator-dashboard` | src/components/dashboard/CreatorDashboard.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| PATCH | `/api/me/teacher/[param]/toggle` | src/components/dashboard/CreatorTeachingSummary.tsx |

**`/creating/analytics`** (src/pages/creating/analytics.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/creator-analytics` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/courses` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/enrollments` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/funnel` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/materials-feedback` | src/components/analytics/MaterialsFeedbackView.tsx |
| GET | `/api/me/creator-analytics/progress` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/sessions` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/teacher-performance` | src/components/analytics/CreatorAnalytics.tsx |
| POST | `/api/reviews/course/[param]/response` | src/components/analytics/MaterialsFeedbackView.tsx |

**`/creating/apply`** (src/pages/creating/apply.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/creators/apply` | src/components/creator/CreatorApplicationForm.tsx |
| POST | `/api/creators/apply` | src/components/creator/CreatorApplicationForm.tsx |

**`/creating/communities`** (src/pages/creating/communities/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/communities` | src/components/creators/communities/CreatorCommunities.tsx |
| POST | `/api/me/communities` | src/components/creators/communities/CreateCommunityModal.tsx |

**`/creating/communities/[slug]`** (src/pages/creating/communities/[slug].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/communities` | src/components/creators/communities/CommunityManagement.tsx |
| PATCH | `/api/me/communities/[param]` | src/components/creators/communities/CommunitySettings.tsx |
| DELETE | `/api/me/communities/[param]` | src/components/creators/communities/CommunitySettings.tsx |
| GET | `/api/me/communities/[param]/members` | src/components/creators/communities/CommunityManagement.tsx |
| GET | `/api/me/communities/[param]/progressions` | src/components/creators/communities/CommunityManagement.tsx |
| POST | `/api/me/communities/[param]/progressions` | src/components/creators/communities/CreateProgressionModal.tsx |
| DELETE | `/api/me/communities/[param]/progressions/[param]` | src/components/creators/communities/CommunityManagement.tsx |
| PATCH | `/api/me/communities/[param]/progressions/[param]` | src/components/creators/communities/CommunityManagement.tsx |
| PATCH | `/api/me/communities/[param]/progressions/reorder` | src/components/creators/communities/CommunityManagement.tsx |

**`/creating/earnings`** (src/pages/creating/earnings.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/creator-earnings` | src/components/creators/workspace/CreatorEarningsDetail.tsx |
| POST | `/api/me/payouts/request` | src/components/creators/workspace/CreatorEarningsDetail.tsx |

**`/creating/studio`** (src/pages/creating/studio.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/communities` | src/components/creators/studio/CreatorStudio.tsx |
| GET | `/api/me/communities/[param]/progressions` | src/components/creators/studio/CreateCourseModal.tsx |
| GET | `/api/me/courses` | src/components/creators/studio/CreatorStudio.tsx |
| POST | `/api/me/courses` | src/components/creators/studio/CreateCourseModal.tsx |
| GET | `/api/me/courses/[param]` | src/components/creators/studio/CourseEditor.tsx |
| PUT | `/api/me/courses/[param]` | src/components/creators/studio/CourseEditor.tsx |
| PUT | `/api/me/courses/[param]/publish` | src/components/creators/studio/CourseEditor.tsx |
| GET | `/api/me/courses/[param]/teachers` | src/components/creators/studio/CourseEditor.tsx |
| POST | `/api/me/courses/[param]/teachers` | src/components/creators/studio/CourseEditor.tsx |
| PUT | `/api/me/courses/[param]/teachers/[param]` | src/components/creators/studio/CourseEditor.tsx |
| DELETE | `/api/me/courses/[param]/teachers/[param]` | src/components/creators/studio/CourseEditor.tsx |
| POST | `/api/me/courses/[param]/thumbnail` | src/components/creators/studio/CourseEditor.tsx |
| PUT | `/api/me/courses/[param]/unpublish` | src/components/creators/studio/CourseEditor.tsx |
| GET | `/api/topics` | src/components/creators/studio/CreateCourseModal.tsx |

### Discover

**`/discover`** — *no API calls detected*

**`/discover/communities`** (src/pages/discover/communities.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/intel/communities` | src/components/discover/tabs/CommunityAllTab.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |
| GET | `/api/recommendations/communities` | src/components/recommendations/RecommendedCommunities.tsx |

**`/discover/community/[slug]`** (src/pages/discover/community/[slug]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |

**`/discover/community/[slug]/[...tab]`** (src/pages/discover/community/[slug]/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |

**`/discover/course/[slug]`** (src/pages/discover/course/[slug]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/me/courses/[param]` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/me/courses/[param]/teachers` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |
| GET | `/api/teaching/courses/[param]` | src/components/discover/detail-tabs/TeacherTabContent.tsx |

**`/discover/course/[slug]/[...tab]`** (src/pages/discover/course/[slug]/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/me/courses/[param]` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/me/courses/[param]/teachers` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |
| GET | `/api/teaching/courses/[param]` | src/components/discover/detail-tabs/TeacherTabContent.tsx |

**`/discover/courses`** (src/pages/discover/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/intel/courses` | src/components/discover/tabs/ExploreAllTab.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |
| GET | `/api/recommendations/courses` | src/components/recommendations/RecommendedCourses.tsx |

**`/discover/creators`** — *no API calls detected*

**`/discover/feeds`** (src/pages/discover/feeds.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/discover` | src/components/discover/DiscoverFeedsGrid.tsx |
| GET | `/api/me/feed-badges` | src/components/discover/ExploreFeeds.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |

**`/discover/leaderboard`** (src/pages/discover/leaderboard.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/leaderboard` | src/components/leaderboard/Leaderboard.tsx |

**`/discover/members`** (src/pages/discover/members.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/users` | src/components/discover/DiscoverMembers.tsx |

**`/discover/students`** — *no API calls detected*

**`/discover/teachers`** — *no API calls detected*

### General

**`/`** (src/pages/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/full` | src/pages/index.astro |
| GET | `/api/me/version` | src/lib/current-user.ts |

**`/dashboard`** (src/pages/dashboard.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/creator-dashboard` | src/components/dashboard/unified/UnifiedDashboard.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/teacher-dashboard` | src/components/dashboard/unified/UnifiedDashboard.tsx |
| GET | `/api/me/version` | src/lib/current-user.ts |
| GET | `/api/sessions` | src/components/dashboard/unified/UnifiedDashboard.tsx |

**`/help`** — *no API calls detected*

### Other

**`/404`** — *no API calls detected*

**`/about`** — *no API calls detected*

**`/become-a-teacher`** — *no API calls detected*

**`/blog`** — *no API calls detected*

**`/careers`** — *no API calls detected*

**`/contact`** — *no API calls detected*

**`/cookies`** — *no API calls detected*

**`/creators`** — *no API calls detected*

**`/faq`** — *no API calls detected*

**`/for-creators`** — *no API calls detected*

**`/how-it-works`** — *no API calls detected*

**`/pricing`** — *no API calls detected*

**`/privacy`** — *no API calls detected*

**`/stories`** — *no API calls detected*

**`/teachers`** — *no API calls detected*

**`/terms`** — *no API calls detected*

**`/testimonials`** — *no API calls detected*

**`/verify/[id]`** — *no API calls detected*

### Profile

**`/@[handle]`** (src/pages/@[handle].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/users/[param]` | src/components/profile/PublicProfile.tsx |

**`/creator/[handle]`** (src/pages/creator/[handle]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |

**`/profile`** — *no API calls detected*

**`/teacher/[handle]`** (src/pages/teacher/[handle]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |

### Session

**`/session/[id]`** (src/pages/session/[id].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/conversations` | src/components/booking/SessionRoom.tsx |
| GET | `/api/enrollments/[param]/expectations` | src/components/booking/SessionCompletedView.tsx |
| PATCH | `/api/enrollments/[param]/expectations` | src/components/booking/SessionCompletedView.tsx |
| GET | `/api/sessions/[param]` | src/components/booking/SessionRoom.tsx |
| DELETE | `/api/sessions/[param]` | src/components/booking/SessionRoom.tsx |
| POST | `/api/sessions/[param]/complete` | src/components/booking/SessionRoom.tsx |
| POST | `/api/sessions/[param]/join` | src/components/booking/SessionRoom.tsx |
| POST | `/api/sessions/[param]/rating` | src/components/booking/SessionRoom.tsx |

### Settings

**`/settings`** — *no API calls detected*

**`/settings/interests`** (src/pages/settings/interests.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/onboarding-profile` | src/components/settings/InterestsSettings.tsx |
| POST | `/api/me/onboarding-profile` | src/components/settings/InterestsSettings.tsx |
| GET | `/api/tags` | src/components/settings/InterestsSettings.tsx |

**`/settings/notifications`** (src/pages/settings/notifications.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/settings` | src/components/settings/NotificationSettings.tsx |
| PATCH | `/api/me/settings` | src/components/settings/NotificationSettings.tsx |

**`/settings/payments`** (src/pages/settings/payments.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/stripe/connect` | src/components/settings/StripeConnectSettings.tsx |
| GET | `/api/stripe/connect-link` | src/components/settings/StripeConnectSettings.tsx |
| GET | `/api/stripe/connect-status` | src/components/settings/StripeConnectSettings.tsx |

**`/settings/profile`** (src/pages/settings/profile.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/profile` | src/components/settings/ProfileSettings.tsx |
| PATCH | `/api/me/profile` | src/components/settings/ProfileSettings.tsx |
| GET | `/api/users/check-handle` | src/components/settings/ProfileSettings.tsx |

**`/settings/security`** (src/pages/settings/security.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/auth/logout` | src/components/settings/SecuritySettings.tsx |
| DELETE | `/api/me/account` | src/components/settings/SecuritySettings.tsx |
| GET | `/api/me/profile` | src/components/settings/SecuritySettings.tsx |

### Social

**`/feed`** (src/pages/feed.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/smart` | src/components/feed/SmartFeed.tsx |
| POST | `/api/feeds/smart/dismiss` | src/components/feed/DiscoveryCard.tsx |
| GET | `/api/me/full` | src/lib/current-user.ts |
| GET | `/api/me/version` | src/lib/current-user.ts |

**`/feeds`** (src/pages/feeds.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/feed-badges` | src/components/feed/FeedsHub.tsx |

**`/messages`** (src/pages/messages.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/conversations` | src/components/messages/Messages.tsx |
| POST | `/api/conversations` | src/components/messages/NewConversationModal.tsx |
| GET | `/api/conversations/[param]` | src/components/messages/MessageThread.tsx |
| POST | `/api/conversations/[param]/messages` | src/components/messages/MessageThread.tsx |
| PUT | `/api/conversations/[param]/read` | src/components/messages/MessageThread.tsx |
| PATCH | `/api/me/messages/read-all` | src/components/messages/ConversationList.tsx |
| GET | `/api/users/search` | src/components/messages/NewConversationModal.tsx |

**`/notifications`** (src/pages/notifications.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| DELETE | `/api/me/notifications` | src/components/notifications/NotificationsList.tsx |
| GET | `/api/me/notifications` | src/components/notifications/NotificationsList.tsx |
| DELETE | `/api/me/notifications/[param]` | src/components/notifications/NotificationsList.tsx |
| PATCH | `/api/me/notifications/[param]/read` | src/components/notifications/NotificationsList.tsx |
| PATCH | `/api/me/notifications/read-all` | src/components/notifications/NotificationsList.tsx |

### Student

**`/courses`** (src/pages/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/enrollments` | src/components/courses/MyCourses.tsx |
| GET | `/api/sessions` | src/components/courses/MyCourses.tsx |
| POST | `/api/stripe/verify-checkout` | src/components/courses/MyCourses.tsx |

**`/learning`** (src/pages/learning.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/certificates` | src/components/dashboard/CertificatesSection.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| GET | `/api/sessions` | src/components/dashboard/StudentDashboard.tsx |

**`/learning/sessions`** (src/pages/learning/sessions.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/sessions` | src/components/learning/StudentSessionsList.tsx |

### Teaching

**`/teaching`** (src/pages/teaching/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/availability` | src/components/teachers/workspace/AvailabilityQuickView.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| GET | `/api/me/teacher-dashboard` | src/components/dashboard/TeacherDashboard.tsx |

**`/teaching/analytics`** (src/pages/teaching/analytics.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/teacher-analytics` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/earnings` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/sessions` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/students` | src/components/analytics/TeacherAnalytics.tsx |

**`/teaching/availability`** (src/pages/teaching/availability.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/availability` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| PUT | `/api/me/availability` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| GET | `/api/me/availability/overrides` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| POST | `/api/me/availability/overrides` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| DELETE | `/api/me/availability/overrides/[param]` | src/components/teachers/workspace/AvailabilityCalendar.tsx |

**`/teaching/courses/[courseId]`** (src/pages/teaching/courses/[courseId].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/teaching/courses/[param]` | src/components/teachers/workspace/TeacherCourseView.tsx |
| GET | `/api/teaching/courses/[param]/resources` | src/components/teachers/workspace/TeacherCourseView.tsx |

**`/teaching/earnings`** (src/pages/teaching/earnings.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/me/payouts/request` | src/components/teachers/workspace/EarningsDetail.tsx |
| GET | `/api/me/teacher-earnings` | src/components/teachers/workspace/EarningsDetail.tsx |

**`/teaching/sessions`** (src/pages/teaching/sessions.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/teacher-sessions` | src/components/teachers/workspace/TeacherSessionsList.tsx |

**`/teaching/students`** (src/pages/teaching/students.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/teacher-students` | src/components/teachers/workspace/MyStudents.tsx |
| POST | `/api/session-invites` | src/components/teachers/workspace/MyStudents.tsx |
| GET | `/api/session-invites` | src/components/teachers/workspace/MyStudents.tsx |

---

## 2. API Endpoint → Routes

Which pages call each API endpoint? Use this to find the UI for a given API action.

| API Endpoint | Routes |
|-------------|--------|
| `DELETE /api/admin/courses/[param]` | `/admin/courses` |
| `DELETE /api/admin/payouts/[param]` | `/admin/payouts` |
| `DELETE /api/admin/sessions/[param]/recording` | `/admin/sessions` |
| `DELETE /api/admin/teachers/[param]` | `/admin/teachers` |
| `DELETE /api/admin/topics/[param]` | `/admin/topics` |
| `DELETE /api/admin/users/[param]` | `/admin/users` |
| `DELETE /api/communities/[param]/moderators/[param]` | `/community/[slug]`, `/community/[slug]/courses`, `/community/[slug]/members`, `/community/[slug]/resources`, `/discover/community/[slug]`, `/discover/community/[slug]/[...tab]` |
| `DELETE /api/me/account` | `/settings/security` |
| `DELETE /api/me/availability/overrides/[param]` | `/teaching/availability` |
| `DELETE /api/me/communities/[param]` | `/creating/communities/[slug]` |
| `DELETE /api/me/communities/[param]/progressions/[param]` | `/creating/communities/[slug]` |
| `DELETE /api/me/courses/[param]/teachers/[param]` | `/creating/studio` |
| `DELETE /api/me/notifications` | `/notifications` |
| `DELETE /api/me/notifications/[param]` | `/notifications` |
| `DELETE /api/sessions/[param]` | `/course/[slug]/book`, `/session/[id]` |
| `GET /api/admin/analytics` | `/admin/analytics` |
| `GET /api/admin/analytics/courses` | `/admin/analytics` |
| `GET /api/admin/analytics/engagement` | `/admin/analytics` |
| `GET /api/admin/analytics/revenue` | `/admin/analytics` |
| `GET /api/admin/analytics/teachers` | `/admin/analytics` |
| `GET /api/admin/analytics/users` | `/admin/analytics` |
| `GET /api/admin/certificates` | `/admin/certificates` |
| `GET /api/admin/certificates/[param]` | `/admin/certificates` |
| `GET /api/admin/courses` | `/admin/courses`, `/admin/sessions` |
| `GET /api/admin/courses/[param]` | `/admin/courses` |
| `GET /api/admin/courses/[param]/feature` | `/admin/courses` |
| `GET /api/admin/creator-applications` | `/admin/creator-applications` |
| `GET /api/admin/creator-applications/[param]` | `/admin/creator-applications` |
| `GET /api/admin/dashboard` | `/admin` |
| `GET /api/admin/enrollments` | `/admin/enrollments` |
| `GET /api/admin/enrollments/[param]` | `/admin/enrollments` |
| `GET /api/admin/intel/communities` | `/discover/communities` |
| `GET /api/admin/intel/courses` | `/discover/courses` |
| `GET /api/admin/moderation` | `/admin/moderation` |
| `GET /api/admin/moderation/[param]` | `/admin/moderation` |
| `GET /api/admin/moderators` | `/admin/moderators` |
| `GET /api/admin/payouts` | `/admin/payouts` |
| `GET /api/admin/payouts/[param]` | `/admin/payouts` |
| `GET /api/admin/payouts/pending` | `/admin/payouts` |
| `GET /api/admin/sessions` | `/admin/sessions` |
| `GET /api/admin/sessions/[param]` | `/admin/sessions` |
| `GET /api/admin/sessions/[param]/recording` | `/admin/sessions` |
| `GET /api/admin/teachers` | `/admin/teachers` |
| `GET /api/admin/teachers/[param]` | `/admin/teachers` |
| `GET /api/admin/topics` | `/admin/topics` |
| `GET /api/admin/users` | `/admin/users`, `/discover/members` |
| `GET /api/admin/users/[param]` | `/admin/users` |
| `GET /api/conversations` | `/messages` |
| `GET /api/conversations/[param]` | `/messages` |
| `GET /api/courses` | `/admin/certificates`, `/admin/enrollments`, `/admin/teachers`, `/community/[slug]`, `/community/[slug]/courses`, `/community/[slug]/members`, `/community/[slug]/resources` |
| `GET /api/courses/[param]/availability-summary` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers` |
| `GET /api/courses/[param]/curriculum` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers` |
| `GET /api/courses/[param]/resources` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers` |
| `GET /api/courses/[param]/sessions` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers`, `/discover/course/[slug]`, `/discover/course/[slug]/[...tab]` |
| `GET /api/creators/apply` | `/creating/apply` |
| `GET /api/enrollments/[param]/expectations` | `/session/[id]` |
| `GET /api/enrollments/[param]/progress` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers` |
| `GET /api/feeds/course/[param]` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers`, `/teaching/courses/[courseId]` |
| `GET /api/feeds/discover` | `/discover/feeds` |
| `GET /api/feeds/smart` | `/feed` |
| `GET /api/feeds/townhall` | `/community/[slug]`, `/community/[slug]/courses`, `/community/[slug]/members`, `/community/[slug]/resources` |
| `GET /api/leaderboard` | `/discover/leaderboard` |
| `GET /api/me/availability` | `/teaching`, `/teaching/availability` |
| `GET /api/me/availability/overrides` | `/teaching/availability` |
| `GET /api/me/certificates` | `/learning` |
| `GET /api/me/communities` | `/creating/communities`, `/creating/communities/[slug]`, `/creating/studio` |
| `GET /api/me/communities/[param]/members` | `/creating/communities/[slug]` |
| `GET /api/me/communities/[param]/progressions` | `/creating/communities/[slug]`, `/creating/studio` |
| `GET /api/me/courses` | `/creating/studio` |
| `GET /api/me/courses/[param]` | `/creating/studio`, `/discover/course/[slug]`, `/discover/course/[slug]/[...tab]` |
| `GET /api/me/courses/[param]/teachers` | `/creating/studio`, `/discover/course/[slug]`, `/discover/course/[slug]/[...tab]` |
| `GET /api/me/creator-analytics` | `/creating/analytics` |
| `GET /api/me/creator-analytics/courses` | `/creating/analytics` |
| `GET /api/me/creator-analytics/enrollments` | `/creating/analytics` |
| `GET /api/me/creator-analytics/funnel` | `/creating/analytics` |
| `GET /api/me/creator-analytics/materials-feedback` | `/creating/analytics` |
| `GET /api/me/creator-analytics/progress` | `/creating/analytics` |
| `GET /api/me/creator-analytics/sessions` | `/creating/analytics` |
| `GET /api/me/creator-analytics/teacher-performance` | `/creating/analytics` |
| `GET /api/me/creator-dashboard` | `/creating`, `/dashboard` |
| `GET /api/me/creator-earnings` | `/creating/earnings` |
| `GET /api/me/enrollments` | `/courses` |
| `GET /api/me/feed-badges` | `/creating`, `/dashboard`, `/discover/feeds`, `/feeds`, `/learning`, `/teaching` |
| `GET /api/me/full` | `/`, `/creator/[handle]`, `/dashboard`, `/discover/communities`, `/discover/community/[slug]`, `/discover/community/[slug]/[...tab]`, `/discover/course/[slug]`, `/discover/course/[slug]/[...tab]`, `/discover/courses`, `/discover/feeds`, `/feed`, `/teacher/[handle]` |
| `GET /api/me/notifications` | `/notifications` |
| `GET /api/me/onboarding-profile` | `/onboarding`, `/settings/interests` |
| `GET /api/me/profile` | `/settings/profile`, `/settings/security` |
| `GET /api/me/settings` | `/settings/notifications` |
| `GET /api/me/teacher-analytics` | `/teaching/analytics` |
| `GET /api/me/teacher-analytics/earnings` | `/teaching/analytics` |
| `GET /api/me/teacher-analytics/sessions` | `/teaching/analytics` |
| `GET /api/me/teacher-analytics/students` | `/teaching/analytics` |
| `GET /api/me/teacher-dashboard` | `/dashboard`, `/teaching` |
| `GET /api/me/teacher-earnings` | `/teaching/earnings` |
| `GET /api/me/teacher-sessions` | `/teaching/sessions` |
| `GET /api/me/teacher-students` | `/teaching/students` |
| `GET /api/me/version` | `/`, `/creator/[handle]`, `/dashboard`, `/discover/communities`, `/discover/community/[slug]`, `/discover/community/[slug]/[...tab]`, `/discover/course/[slug]`, `/discover/course/[slug]/[...tab]`, `/discover/courses`, `/discover/feeds`, `/feed`, `/teacher/[handle]` |
| `GET /api/recommendations/communities` | `/discover/communities` |
| `GET /api/recommendations/courses` | `/discover/courses` |
| `GET /api/session-invites` | `/teaching/students` |
| `GET /api/sessions` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers`, `/courses`, `/dashboard`, `/learning`, `/learning/sessions` |
| `GET /api/sessions/[param]` | `/session/[id]` |
| `GET /api/stripe/connect-link` | `/settings/payments` |
| `GET /api/stripe/connect-status` | `/settings/payments` |
| `GET /api/tags` | `/onboarding`, `/settings/interests` |
| `GET /api/teachers/[param]/availability` | `/course/[slug]/book` |
| `GET /api/teaching/courses/[param]` | `/discover/course/[slug]`, `/discover/course/[slug]/[...tab]`, `/teaching/courses/[courseId]` |
| `GET /api/teaching/courses/[param]/resources` | `/teaching/courses/[courseId]` |
| `GET /api/topics` | `/admin/courses`, `/creating/studio` |
| `GET /api/users/[param]` | `/@[handle]` |
| `GET /api/users/check-handle` | `/settings/profile` |
| `GET /api/users/search` | `/messages` |
| `PATCH /api/admin/sessions/[param]` | `/admin/sessions` |
| `PATCH /api/admin/topics/[param]` | `/admin/topics` |
| `PATCH /api/admin/users/[param]` | `/admin/users` |
| `PATCH /api/enrollments/[param]/expectations` | `/session/[id]` |
| `PATCH /api/me/communities/[param]` | `/creating/communities/[slug]` |
| `PATCH /api/me/communities/[param]/progressions/[param]` | `/creating/communities/[slug]` |
| `PATCH /api/me/communities/[param]/progressions/reorder` | `/creating/communities/[slug]` |
| `PATCH /api/me/messages/read-all` | `/messages` |
| `PATCH /api/me/notifications/[param]/read` | `/notifications` |
| `PATCH /api/me/notifications/read-all` | `/notifications` |
| `PATCH /api/me/profile` | `/settings/profile` |
| `PATCH /api/me/settings` | `/settings/notifications` |
| `PATCH /api/me/teacher/[param]/toggle` | `/creating` |
| `POST /api/admin/certificates/[param]/approve` | `/admin/certificates` |
| `POST /api/admin/certificates/[param]/reject` | `/admin/certificates` |
| `POST /api/admin/certificates/[param]/revoke` | `/admin/certificates` |
| `POST /api/admin/courses/[param]/badge` | `/admin/courses` |
| `POST /api/admin/courses/[param]/suspend` | `/admin/courses` |
| `POST /api/admin/courses/[param]/unsuspend` | `/admin/courses` |
| `POST /api/admin/creator-applications/[param]/approve` | `/admin/creator-applications` |
| `POST /api/admin/creator-applications/[param]/deny` | `/admin/creator-applications` |
| `POST /api/admin/enrollments/[param]/cancel` | `/admin/enrollments` |
| `POST /api/admin/enrollments/[param]/force-complete` | `/admin/enrollments` |
| `POST /api/admin/enrollments/[param]/reassign-teacher` | `/admin/enrollments` |
| `POST /api/admin/enrollments/[param]/refund` | `/admin/enrollments` |
| `POST /api/admin/moderation/[param]/dismiss` | `/admin/moderation` |
| `POST /api/admin/moderation/[param]/remove` | `/admin/moderation` |
| `POST /api/admin/moderation/[param]/suspend` | `/admin/moderation` |
| `POST /api/admin/moderation/[param]/warn` | `/admin/moderation` |
| `POST /api/admin/moderators/[param]/remove` | `/admin/moderators` |
| `POST /api/admin/moderators/[param]/resend` | `/admin/moderators` |
| `POST /api/admin/moderators/[param]/revoke` | `/admin/moderators` |
| `POST /api/admin/moderators/invite` | `/admin/moderators` |
| `POST /api/admin/payouts` | `/admin/payouts` |
| `POST /api/admin/payouts/[param]/process` | `/admin/payouts` |
| `POST /api/admin/payouts/[param]/retry` | `/admin/payouts` |
| `POST /api/admin/payouts/batch` | `/admin/payouts` |
| `POST /api/admin/sessions/[param]/resolve` | `/admin/sessions` |
| `POST /api/admin/sessions/cleanup` | `/admin` |
| `POST /api/admin/teachers/[param]/activate` | `/admin/teachers` |
| `POST /api/admin/teachers/[param]/deactivate` | `/admin/teachers` |
| `POST /api/admin/topics` | `/admin/topics` |
| `POST /api/admin/topics/reorder` | `/admin/topics` |
| `POST /api/admin/users/[param]/suspend` | `/admin/users` |
| `POST /api/admin/users/[param]/unsuspend` | `/admin/users` |
| `POST /api/auth/logout` | `/settings/security` |
| `POST /api/auth/reset-password` | `/reset-password` |
| `POST /api/checkout/create-session` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers` |
| `POST /api/communities/[param]/moderators` | `/community/[slug]`, `/community/[slug]/courses`, `/community/[slug]/members`, `/community/[slug]/resources`, `/discover/community/[slug]`, `/discover/community/[slug]/[...tab]` |
| `POST /api/conversations` | `/messages`, `/session/[id]` |
| `POST /api/conversations/[param]/messages` | `/messages` |
| `POST /api/courses/[param]/discussion-feed` | `/creating` |
| `POST /api/creators/apply` | `/creating/apply` |
| `POST /api/enrollments/[param]/expectations` | `/course/[slug]/success` |
| `POST /api/enrollments/[param]/progress` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers` |
| `POST /api/feeds/community/[param]` | `/community/[slug]`, `/community/[slug]/courses`, `/community/[slug]/members`, `/community/[slug]/resources` |
| `POST /api/feeds/course/[param]` | `/course/[slug]`, `/course/[slug]/feed`, `/course/[slug]/learn`, `/course/[slug]/resources`, `/course/[slug]/sessions`, `/course/[slug]/teachers`, `/teaching/courses/[courseId]` |
| `POST /api/feeds/smart/dismiss` | `/feed` |
| `POST /api/feeds/townhall` | `/community/[slug]`, `/community/[slug]/courses`, `/community/[slug]/members`, `/community/[slug]/resources` |
| `POST /api/me/availability/overrides` | `/teaching/availability` |
| `POST /api/me/communities` | `/creating/communities` |
| `POST /api/me/communities/[param]/progressions` | `/creating/communities/[slug]` |
| `POST /api/me/courses` | `/creating/studio` |
| `POST /api/me/courses/[param]/teachers` | `/creating/studio` |
| `POST /api/me/courses/[param]/thumbnail` | `/creating/studio` |
| `POST /api/me/onboarding-profile` | `/onboarding`, `/settings/interests` |
| `POST /api/me/payouts/request` | `/creating/earnings`, `/teaching/earnings` |
| `POST /api/reviews/course/[param]/response` | `/creating/analytics` |
| `POST /api/session-invites` | `/teaching/students` |
| `POST /api/session-invites/[param]/accept` | `/course/[slug]/book` |
| `POST /api/session-invites/[param]/decline` | `/course/[slug]/book` |
| `POST /api/sessions` | `/course/[slug]/book` |
| `POST /api/sessions/[param]/complete` | `/session/[id]` |
| `POST /api/sessions/[param]/join` | `/session/[id]` |
| `POST /api/sessions/[param]/rating` | `/session/[id]` |
| `POST /api/stripe/connect` | `/settings/payments` |
| `POST /api/stripe/verify-checkout` | `/courses` |
| `PUT /api/conversations/[param]/read` | `/messages` |
| `PUT /api/me/availability` | `/teaching/availability` |
| `PUT /api/me/courses/[param]` | `/creating/studio` |
| `PUT /api/me/courses/[param]/publish` | `/creating/studio` |
| `PUT /api/me/courses/[param]/teachers/[param]` | `/creating/studio` |
| `PUT /api/me/courses/[param]/unpublish` | `/creating/studio` |

---

## 3. Navigation Paths (AppNavbar → Page)

How does a user reach each page starting from the sidebar navigation?
Used by PLATO browser-runs to follow real user navigation instead of direct URL entry.

### Unreachable (no path from navbar)

- `/404` — ⚠️ no discovered path
- `/about` — ⚠️ no discovered path
- `/blog` — ⚠️ no discovered path
- `/careers` — ⚠️ no discovered path
- `/contact` — ⚠️ no discovered path
- `/cookies` — ⚠️ no discovered path
- `/faq` — ⚠️ no discovered path
- `/how-it-works` — ⚠️ no discovered path
- `/pricing` — ⚠️ no discovered path
- `/privacy` — ⚠️ no discovered path
- `/stories` — ⚠️ no discovered path
- `/terms` — ⚠️ no discovered path
- `/testimonials` — ⚠️ no discovered path

### 1 click (direct navbar link)

- `/admin` — Click "Admin" in sidebar
- `/community` — Click "My Communities" in sidebar
- `/courses` — Click "My Courses" in sidebar
- `/creating` — Click "Creating" in sidebar
- `/creating/apply` — Click "Become a Creator" in sidebar
- `/dashboard` — Click "Dashboard" in sidebar
- `/feeds` — Click "My Feeds" in sidebar
- `/learning` — Click "Learning" in sidebar
- `/messages` — Click "Messages" in sidebar
- `/notifications` — Click "Notifications" in sidebar
- `/onboarding` — Click "Complete Profile" in sidebar
- `/teaching` — Click "Teaching" in sidebar

### 2 clicks

- `/` — Click "Complete Profile" in sidebar → Link on /onboarding
- `/@[handle]` — Click "Messages" in sidebar → Link on /messages
- `/admin/courses` — Click "Admin" in sidebar → Link on /admin
- `/admin/enrollments` — Click "Admin" in sidebar → Link on /admin
- `/admin/teachers` — Click "Admin" in sidebar → Link on /admin
- `/admin/users` — Click "Admin" in sidebar → Link on /admin
- `/community/[slug]` — Click "My Communities" in sidebar → Link on /community
- `/course/[slug]` — Click "My Courses" in sidebar → Link on /courses
- `/course/[slug]/book` — Click "My Courses" in sidebar → Link on /courses
- `/course/[slug]/learn` — Click "My Courses" in sidebar → Link on /courses
- `/course/[slug]/sessions` — Click "My Courses" in sidebar → Link on /courses
- `/creating/analytics` — Click "Creating" in sidebar → Link on /creating
- `/creating/communities` — Click "Creating" in sidebar → Link on /creating
- `/creating/earnings` — Click "Creating" in sidebar → Earnings tab tab/link on /creating
- `/creating/studio` — Click "Creating" in sidebar → Link on /creating
- `/creator/[handle]` — Click "My Courses" in sidebar → Link on /courses
- `/discover/communities` — Click "My Communities" in sidebar → Link on /community
- `/discover/courses` — Click "My Courses" in sidebar → Link on /courses
- `/discover/creators` — Click "Discover" in sidebar → Open Discover panel → Click "Creators"
- `/discover/feeds` — Click "My Feeds" in sidebar → Discover Feeds link tab/link on /feeds
- `/discover/leaderboard` — Click "Discover" in sidebar → Open Discover panel → Click "Leaderboard"
- `/discover/students` — Click "Discover" in sidebar → Open Discover panel → Click "Students"
- `/discover/teachers` — Click "Discover" in sidebar → Open Discover panel → Click "Teachers"
- `/feed` — Click "My Feeds" in sidebar → Link on /feeds
- `/help` — Click avatar/user menu → Open user menu → Click "Help"
- `/learning/sessions` — Click "Learning" in sidebar → Link on /learning
- `/login` — Click "Messages" in sidebar → Link on /messages
- `/profile` — Click "Creating" in sidebar → Link on /creating
- `/session/[id]` — Click "Learning" in sidebar → Link on /learning
- `/settings` — Click avatar/user menu → Open user menu → Click "Settings"
- `/teaching/analytics` — Click "Teaching" in sidebar → Link on /teaching
- `/teaching/availability` — Click "Teaching" in sidebar → Link on /teaching
- `/teaching/courses/[courseId]` — Click "Teaching" in sidebar → Click course card tab/link on /teaching
- `/teaching/earnings` — Click "Teaching" in sidebar → Earnings tab tab/link on /teaching
- `/teaching/sessions` — Click "Teaching" in sidebar → Link on /teaching
- `/teaching/students` — Click "Teaching" in sidebar → Link on /teaching
- `/verify/[id]` — Click "Learning" in sidebar → Link on /learning

### 3 clicks

- `/admin/analytics` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Analytics" in admin sidebar
- `/admin/certificates` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Certificates" in admin sidebar
- `/admin/creator-applications` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Creator Applications" in admin sidebar
- `/admin/moderation` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Moderation" in admin sidebar
- `/admin/moderators` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Moderators" in admin sidebar
- `/admin/payouts` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Payouts" in admin sidebar
- `/admin/sessions` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Sessions" in admin sidebar
- `/admin/topics` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Topics" in admin sidebar
- `/become-a-teacher` — Click "Discover" in sidebar → Open Discover panel → Click "Teachers" → Link on /discover/teachers
- `/community/[slug]/courses` — Click "My Communities" in sidebar → Link on /community → Courses tab/link on /community/[slug]
- `/community/[slug]/members` — Click "My Communities" in sidebar → Link on /community → Members tab/link on /community/[slug]
- `/community/[slug]/resources` — Click "My Communities" in sidebar → Link on /community → Resources tab/link on /community/[slug]
- `/course/[slug]/feed` — Click "My Courses" in sidebar → Link on /courses → Feed tab/link on /course/[slug]
- `/course/[slug]/resources` — Click "My Courses" in sidebar → Link on /courses → Resources tab/link on /course/[slug]
- `/course/[slug]/success` — Click "My Courses" in sidebar → Link on /courses → Success (post-checkout redirect) tab/link on /course/[slug]
- `/course/[slug]/teachers` — Click "My Courses" in sidebar → Link on /courses → Teachers tab/link on /course/[slug]
- `/creating/communities/[slug]` — Click "My Communities" in sidebar → Link on /community → Link on /community/[slug]
- `/creators` — Click "My Courses" in sidebar → Link on /courses → Link on /creator/[handle]
- `/discover` — Click "Complete Profile" in sidebar → Link on /onboarding → Link on /
- `/discover/community/[slug]` — Click "My Communities" in sidebar → Link on /community → Click community card tab/link on /discover/communities
- `/discover/course/[slug]` — Click "My Courses" in sidebar → Link on /courses → Click course card tab/link on /discover/courses
- `/for-creators` — Click "Discover" in sidebar → Open Discover panel → Click "Creators" → Link on /discover/creators
- `/settings/interests` — Click avatar/user menu → Open user menu → Click "Settings" → Link on /settings
- `/settings/notifications` — Click avatar/user menu → Open user menu → Click "Settings" → Link on /settings
- `/settings/payments` — Click "Teaching" in sidebar → Earnings tab tab/link on /teaching → Link on /teaching/earnings
- `/settings/profile` — Click "My Courses" in sidebar → Link on /courses → Link on /creator/[handle]
- `/settings/security` — Click avatar/user menu → Open user menu → Click "Settings" → Link on /settings
- `/signup` — Click "My Courses" in sidebar → Link on /courses → Link on /course/[slug]
- `/teacher/[handle]` — Click "My Courses" in sidebar → Link on /courses → Link on /course/[slug]

### 4 clicks

- `/discover/community/[slug]/[...tab]` — Click "My Communities" in sidebar → Link on /community → Click community card tab/link on /discover/communities → Click tab tab/link on /discover/community/[slug]
- `/discover/course/[slug]/[...tab]` — Click "My Courses" in sidebar → Link on /courses → Click course card tab/link on /discover/courses → Click tab tab/link on /discover/course/[slug]
- `/discover/members` — Click "Complete Profile" in sidebar → Link on /onboarding → Link on / → Link on /discover
- `/reset-password` — Click avatar/user menu → Open user menu → Click "Settings" → Link on /settings → Link on /settings/security
- `/teachers` — Click "My Courses" in sidebar → Link on /courses → Link on /course/[slug] → Link on /teacher/[handle]

---

## 4. PLATO Integration

### Using the TypeScript lookup

```typescript
import { routeMap, routesForApi, navPathTo, apisOnRoute } from './route-map.generated';

// Find which pages have the "book session" API call
const bookingPages = routesForApi('POST', '/api/sessions');
// → ['/course/[slug]/book']

// Get navigation instructions to reach the booking page
const path = navPathTo('/course/[slug]/book');
// → [{ from: "[AppNavbar]", to: "/courses", via: "Click \"My Courses\"" },
//     { from: "/courses", to: "/course/[slug]", via: "Link on /courses" },
//     { from: "/course/[slug]", to: "/course/[slug]/book", via: "Link on /course/[slug]" }]
```

### Browser-run navigation rules

1. **Same-page link:** If the target route has a link/button on the current page, click it
2. **Different page:** Start from AppNavbar, follow the `navPath` steps
3. **Multiple options:** If `routesForApi()` returns multiple routes, choose the one
   closest to the current page (fewest nav steps) or ask the user
