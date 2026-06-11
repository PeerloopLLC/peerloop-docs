# Route ↔ API Map

> **Auto-generated** by `scripts/route-api-map.mjs` — do not edit manually.
> Last generated: 2026-06-11
>
> Run: `cd ../Peerloop && node scripts/route-api-map.mjs`

---

## Quick Stats

- **Pages scanned:** 124
- **API endpoints found in UI:** 199
- **Routes reachable from navbar:** 59
- **Unreachable routes:** 96

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

**`/admin/recordings`** (src/pages/admin/recordings.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/bbb/recordings` | src/components/admin/RecordingsAdmin.tsx |

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

**`/signup`** — *no API calls detected*

### Community

**`/community/[slug]/[...tab]`** (src/pages/community/[slug]/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| DELETE | `/api/communities/[param]/join` | src/pages/community/[slug]/[...tab].astro |
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityMembersTab.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityMembersTab.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| POST | `/api/me/communities/[param]/resources` | src/components/community/AddCommunityResourceModal.tsx |

### Course

**`/course/[slug]/[...tab]`** (src/pages/course/[slug]/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |
| GET | `/api/feeds/course/[param]` | src/components/course/MattCourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/lib/feeds.ts |

**`/course/[slug]/book`** (src/pages/course/[slug]/book.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/session-invites/[param]/accept` | src/components/booking/SessionBooking.tsx |
| POST | `/api/session-invites/[param]/decline` | src/components/booking/SessionBooking.tsx |
| POST | `/api/sessions` | src/components/booking/SessionBooking.tsx |
| DELETE | `/api/sessions/[param]` | src/components/booking/SessionBooking.tsx |
| GET | `/api/teachers/[param]/availability` | src/components/booking/SessionBooking.tsx |

**`/course/[slug]/precheckout`** (src/pages/course/[slug]/precheckout.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/checkout/create-session` | src/components/courses/EnrollButton.tsx |
| GET | `/api/courses/[param]/availability-summary` | src/components/courses/EnrollButton.tsx |

**`/course/[slug]/success`** (src/pages/course/[slug]/success.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/enrollments/[param]/expectations` | src/components/learning/ExpectationsForm.tsx |
| POST | `/api/feeds/course/[param]` | src/lib/feeds.ts |

### Creating

**`/creating/[...tab]`** (src/pages/creating/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/courses/[param]/discussion-feed` | src/components/dashboard/CreatorCourseCard.tsx |
| GET | `/api/me/communities` | src/components/creators/studio/CreatorStudio.tsx |
| POST | `/api/me/communities` | src/components/creators/communities/CreateCommunityModal.tsx |
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
| GET | `/api/me/creator-analytics` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/courses` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/enrollments` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/funnel` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/materials-feedback` | src/components/analytics/MaterialsFeedbackView.tsx |
| GET | `/api/me/creator-analytics/progress` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/sessions` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-analytics/teacher-performance` | src/components/analytics/CreatorAnalytics.tsx |
| GET | `/api/me/creator-dashboard` | src/components/dashboard/CreatorDashboard.tsx |
| GET | `/api/me/creator-earnings` | src/components/creators/workspace/CreatorEarningsDetail.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| POST | `/api/me/payouts/request` | src/components/creators/workspace/CreatorEarningsDetail.tsx |
| PATCH | `/api/me/teacher/[param]/toggle` | src/components/dashboard/CreatorTeachingSummary.tsx |
| POST | `/api/reviews/course/[param]/response` | src/components/analytics/MaterialsFeedbackView.tsx |
| GET | `/api/topics` | src/components/creators/studio/CreateCourseModal.tsx |

**`/creating/apply`** (src/pages/creating/apply.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/creators/apply` | src/components/creator/CreatorApplicationForm.tsx |
| POST | `/api/creators/apply` | src/components/creator/CreatorApplicationForm.tsx |

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

### General

**`/`** (src/pages/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/smart` | src/components/feed/SmartFeed.tsx |
| POST | `/api/feeds/smart/dismiss` | src/components/feed/DiscoveryCard.tsx |

### Other

**`/404`** — *no API calls detected*

**`/become-a-teacher`** — *no API calls detected*

**`/communities`** (src/pages/communities.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/intel/communities` | src/components/communities/CommunitiesCatalog.tsx |
| GET | `/api/recommendations/communities` | src/components/recommendations/RecommendedCommunities.tsx |

**`/dev/primitives`** — *no API calls detected*

**`/dev/saved`** — *no API calls detected*

**`/dev/todo`** — *no API calls detected*

**`/learning/[...tab]`** (src/pages/learning/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/certificates` | src/components/dashboard/CertificatesSection.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| GET | `/api/sessions` | src/components/dashboard/StudentDashboard.tsx |

**`/members`** (src/pages/members.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/members` | src/components/members/MembersDirectory.tsx |

**`/mod`** (src/pages/mod.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/moderation` | src/components/moderation/ModeratorQueue.tsx |
| GET | `/api/admin/moderation/[param]` | src/components/moderation/ModeratorQueue.tsx |
| POST | `/api/admin/moderation/[param]/dismiss` | src/components/moderation/ModeratorQueue.tsx |
| POST | `/api/admin/moderation/[param]/remove` | src/components/moderation/ModeratorQueue.tsx |
| POST | `/api/admin/moderation/[param]/suspend` | src/components/moderation/ModeratorQueue.tsx |
| POST | `/api/admin/moderation/[param]/warn` | src/components/moderation/ModeratorQueue.tsx |

**`/old`** (src/pages/old/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/full` | src/pages/old/index.astro |

**`/old/@[handle]`** (src/pages/old/@[handle].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/users/[param]` | src/components/profile/PublicProfile.tsx |

**`/old/about`** — *no API calls detected*

**`/old/blog`** — *no API calls detected*

**`/old/careers`** — *no API calls detected*

**`/old/community`** — *no API calls detected*

**`/old/community/[slug]`** (src/pages/old/community/[slug]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| POST | `/api/me/communities/[param]/resources` | src/components/community/AddCommunityResourceModal.tsx |

**`/old/community/[slug]/courses`** (src/pages/old/community/[slug]/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| POST | `/api/me/communities/[param]/resources` | src/components/community/AddCommunityResourceModal.tsx |

**`/old/community/[slug]/members`** (src/pages/old/community/[slug]/members.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| POST | `/api/me/communities/[param]/resources` | src/components/community/AddCommunityResourceModal.tsx |

**`/old/community/[slug]/resources`** (src/pages/old/community/[slug]/resources.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |
| GET | `/api/courses` | src/components/community/TownHallFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/feeds/townhall` | src/components/community/TownHallFeed.tsx |
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| POST | `/api/me/communities/[param]/resources` | src/components/community/AddCommunityResourceModal.tsx |

**`/old/contact`** — *no API calls detected*

**`/old/cookies`** — *no API calls detected*

**`/old/course/[slug]`** (src/pages/old/course/[slug]/index.astro)

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
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/old/course/[slug]/[tab]`** (src/pages/old/course/[slug]/[tab].astro)

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
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/old/course/[slug]/book`** (src/pages/old/course/[slug]/book.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/session-invites/[param]/accept` | src/components/booking/SessionBooking.tsx |
| POST | `/api/session-invites/[param]/decline` | src/components/booking/SessionBooking.tsx |
| POST | `/api/sessions` | src/components/booking/SessionBooking.tsx |
| DELETE | `/api/sessions/[param]` | src/components/booking/SessionBooking.tsx |
| GET | `/api/teachers/[param]/availability` | src/components/booking/SessionBooking.tsx |

**`/old/course/[slug]/feed`** (src/pages/old/course/[slug]/feed.astro)

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
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/old/course/[slug]/learn`** (src/pages/old/course/[slug]/learn.astro)

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
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/old/course/[slug]/resources`** (src/pages/old/course/[slug]/resources.astro)

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
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/old/course/[slug]/sessions`** (src/pages/old/course/[slug]/sessions.astro)

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
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/old/course/[slug]/success`** (src/pages/old/course/[slug]/success.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/enrollments/[param]/expectations` | src/components/learning/ExpectationsForm.tsx |

**`/old/course/[slug]/teachers`** (src/pages/old/course/[slug]/teachers.astro)

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
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/sessions` | src/components/courses/LearnTab.tsx |

**`/old/courses`** (src/pages/old/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/sessions` | src/components/courses/MyCourses.tsx |
| POST | `/api/stripe/verify-checkout` | src/components/courses/MyCourses.tsx |

**`/old/creating`** (src/pages/old/creating/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/courses/[param]/discussion-feed` | src/components/dashboard/CreatorCourseCard.tsx |
| GET | `/api/me/creator-dashboard` | src/components/dashboard/CreatorDashboard.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| PATCH | `/api/me/teacher/[param]/toggle` | src/components/dashboard/CreatorTeachingSummary.tsx |

**`/old/creating/analytics`** (src/pages/old/creating/analytics.astro)

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

**`/old/creating/communities`** (src/pages/old/creating/communities/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/communities` | src/components/creators/communities/CreatorCommunities.tsx |
| POST | `/api/me/communities` | src/components/creators/communities/CreateCommunityModal.tsx |

**`/old/creating/communities/[slug]`** (src/pages/old/creating/communities/[slug].astro)

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

**`/old/creating/earnings`** (src/pages/old/creating/earnings.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/creator-earnings` | src/components/creators/workspace/CreatorEarningsDetail.tsx |
| POST | `/api/me/payouts/request` | src/components/creators/workspace/CreatorEarningsDetail.tsx |

**`/old/creating/studio`** (src/pages/old/creating/studio.astro)

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

**`/old/creator/[handle]`** — *no API calls detected*

**`/old/dashboard`** (src/pages/old/dashboard.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/creator-dashboard` | src/components/dashboard/unified/UnifiedDashboard.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| GET | `/api/me/teacher-dashboard` | src/components/dashboard/unified/UnifiedDashboard.tsx |
| GET | `/api/sessions` | src/components/dashboard/unified/UnifiedDashboard.tsx |

**`/old/discover`** — *no API calls detected*

**`/old/discover/communities`** (src/pages/old/discover/communities.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/intel/communities` | src/components/discover/tabs/CommunityAllTab.tsx |
| GET | `/api/recommendations/communities` | src/components/recommendations/RecommendedCommunities.tsx |

**`/old/discover/community/[slug]`** (src/pages/old/discover/community/[slug]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |

**`/old/discover/community/[slug]/[...tab]`** (src/pages/old/discover/community/[slug]/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityTabs.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityTabs.tsx |

**`/old/discover/course/[slug]`** (src/pages/old/discover/course/[slug]/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/courses/[param]/follow` | src/components/courses/CourseFollowButton.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/me/courses/[param]` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/me/courses/[param]/teachers` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/teaching/courses/[param]` | src/components/discover/detail-tabs/TeacherTabContent.tsx |

**`/old/discover/course/[slug]/[...tab]`** (src/pages/old/discover/course/[slug]/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/courses/[param]/follow` | src/components/courses/CourseFollowButton.tsx |
| GET | `/api/courses/[param]/sessions` | src/components/courses/CourseTabs.tsx |
| GET | `/api/me/courses/[param]` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/me/courses/[param]/teachers` | src/components/discover/detail-tabs/CreatorTabContent.tsx |
| GET | `/api/teaching/courses/[param]` | src/components/discover/detail-tabs/TeacherTabContent.tsx |

**`/old/discover/courses`** (src/pages/old/discover/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/intel/courses` | src/components/discover/tabs/ExploreAllTab.tsx |
| GET | `/api/recommendations/courses` | src/components/recommendations/RecommendedCourses.tsx |

**`/old/discover/creators`** — *no API calls detected*

**`/old/discover/feeds`** (src/pages/old/discover/feeds.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/discover` | src/components/discover/DiscoverFeedsGrid.tsx |
| GET | `/api/me/feed-badges` | src/components/discover/ExploreFeeds.tsx |

**`/old/discover/leaderboard`** (src/pages/old/discover/leaderboard.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/leaderboard` | src/components/leaderboard/Leaderboard.tsx |

**`/old/discover/members`** (src/pages/old/discover/members.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/members` | src/components/discover/MemberDirectory.tsx |

**`/old/discover/students`** — *no API calls detected*

**`/old/discover/teachers`** — *no API calls detected*

**`/old/faq`** — *no API calls detected*

**`/old/feed`** (src/pages/old/feed.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/smart` | src/components/feed/SmartFeed.tsx |
| POST | `/api/feeds/smart/dismiss` | src/components/feed/DiscoveryCard.tsx |

**`/old/feeds`** (src/pages/old/feeds.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/feed-badges` | src/components/feed/FeedsHub.tsx |

**`/old/for-creators`** — *no API calls detected*

**`/old/help`** — *no API calls detected*

**`/old/how-it-works`** — *no API calls detected*

**`/old/learning`** (src/pages/old/learning.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/certificates` | src/components/dashboard/CertificatesSection.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| GET | `/api/sessions` | src/components/dashboard/StudentDashboard.tsx |

**`/old/learning/sessions`** (src/pages/old/learning/sessions.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/sessions` | src/components/learning/StudentSessionsList.tsx |

**`/old/login`** — *no API calls detected*

**`/old/messages`** (src/pages/old/messages.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/conversations` | src/components/messages/Messages.tsx |
| POST | `/api/conversations` | src/components/messages/NewConversationModal.tsx |
| GET | `/api/conversations/[param]` | src/components/messages/MessageThread.tsx |
| POST | `/api/conversations/[param]/messages` | src/components/messages/MessageThread.tsx |
| PUT | `/api/conversations/[param]/read` | src/components/messages/MessageThread.tsx |
| PATCH | `/api/me/messages/read-all` | src/components/messages/ConversationList.tsx |
| GET | `/api/users/search` | src/components/messages/NewConversationModal.tsx |

**`/old/notifications`** (src/pages/old/notifications.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| DELETE | `/api/me/notifications` | src/components/notifications/NotificationsList.tsx |
| GET | `/api/me/notifications` | src/components/notifications/NotificationsList.tsx |
| DELETE | `/api/me/notifications/[param]` | src/components/notifications/NotificationsList.tsx |
| PATCH | `/api/me/notifications/[param]/read` | src/components/notifications/NotificationsList.tsx |
| PATCH | `/api/me/notifications/read-all` | src/components/notifications/NotificationsList.tsx |

**`/old/onboarding`** (src/pages/old/onboarding.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/onboarding-profile` | src/components/onboarding/OnboardingProfile.tsx |
| POST | `/api/me/onboarding-profile` | src/components/onboarding/OnboardingProfile.tsx |
| GET | `/api/tags` | src/components/onboarding/OnboardingProfile.tsx |

**`/old/pricing`** — *no API calls detected*

**`/old/privacy`** — *no API calls detected*

**`/old/profile`** — *no API calls detected*

**`/old/reset-password`** (src/pages/old/reset-password.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/auth/reset-password` | src/components/auth/PasswordResetForm.tsx |

**`/old/session/[id]`** (src/pages/old/session/[id].astro)

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

**`/old/settings`** — *no API calls detected*

**`/old/settings/interests`** (src/pages/old/settings/interests.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/onboarding-profile` | src/components/settings/InterestsSettings.tsx |
| POST | `/api/me/onboarding-profile` | src/components/settings/InterestsSettings.tsx |
| GET | `/api/tags` | src/components/settings/InterestsSettings.tsx |

**`/old/settings/notifications`** (src/pages/old/settings/notifications.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/settings` | src/components/settings/NotificationSettings.tsx |
| PATCH | `/api/me/settings` | src/components/settings/NotificationSettings.tsx |

**`/old/settings/payments`** (src/pages/old/settings/payments.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/stripe/connect` | src/components/settings/StripeConnectSettings.tsx |
| GET | `/api/stripe/connect-link` | src/components/settings/StripeConnectSettings.tsx |
| GET | `/api/stripe/connect-status` | src/components/settings/StripeConnectSettings.tsx |

**`/old/settings/profile`** (src/pages/old/settings/profile.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/profile` | src/components/settings/ProfileSettings.tsx |
| PATCH | `/api/me/profile` | src/components/settings/ProfileSettings.tsx |
| GET | `/api/users/check-handle` | src/components/settings/ProfileSettings.tsx |

**`/old/settings/security`** (src/pages/old/settings/security.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/auth/logout` | src/components/settings/SecuritySettings.tsx |
| DELETE | `/api/me/account` | src/components/settings/SecuritySettings.tsx |
| GET | `/api/me/profile` | src/components/settings/SecuritySettings.tsx |

**`/old/signup`** — *no API calls detected*

**`/old/stories`** — *no API calls detected*

**`/old/teacher/[handle]`** — *no API calls detected*

**`/old/teaching`** (src/pages/old/teaching/index.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/availability` | src/components/teachers/workspace/AvailabilityQuickView.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| GET | `/api/me/teacher-dashboard` | src/components/dashboard/TeacherDashboard.tsx |

**`/old/teaching/analytics`** (src/pages/old/teaching/analytics.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/teacher-analytics` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/earnings` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/sessions` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/students` | src/components/analytics/TeacherAnalytics.tsx |

**`/old/teaching/availability`** (src/pages/old/teaching/availability.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/availability` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| PUT | `/api/me/availability` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| GET | `/api/me/availability/overrides` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| POST | `/api/me/availability/overrides` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| DELETE | `/api/me/availability/overrides/[param]` | src/components/teachers/workspace/AvailabilityCalendar.tsx |

**`/old/teaching/courses/[courseId]`** (src/pages/old/teaching/courses/[courseId].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/teaching/courses/[param]` | src/components/teachers/workspace/TeacherCourseView.tsx |
| GET | `/api/teaching/courses/[param]/resources` | src/components/teachers/workspace/TeacherCourseView.tsx |

**`/old/teaching/earnings`** (src/pages/old/teaching/earnings.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/me/payouts/request` | src/components/teachers/workspace/EarningsDetail.tsx |
| GET | `/api/me/teacher-earnings` | src/components/teachers/workspace/EarningsDetail.tsx |

**`/old/teaching/sessions`** (src/pages/old/teaching/sessions.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/teacher-sessions` | src/components/teachers/workspace/TeacherSessionsList.tsx |

**`/old/teaching/students`** (src/pages/old/teaching/students.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/teacher-students` | src/components/teachers/workspace/MyStudents.tsx |
| POST | `/api/session-invites` | src/components/teachers/workspace/MyStudents.tsx |
| GET | `/api/session-invites` | src/components/teachers/workspace/MyStudents.tsx |

**`/old/terms`** — *no API calls detected*

**`/old/testimonials`** — *no API calls detected*

**`/old/verify/[id]`** — *no API calls detected*

**`/profile/[...tab]`** (src/pages/profile/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/auth/logout` | src/pages/profile/[...tab].astro |
| DELETE | `/api/me/account` | src/components/settings/SecuritySettings.tsx |
| GET | `/api/me/onboarding-profile` | src/components/settings/InterestsSettings.tsx |
| POST | `/api/me/onboarding-profile` | src/components/settings/InterestsSettings.tsx |
| GET | `/api/me/profile` | src/components/settings/ProfileSettings.tsx |
| PATCH | `/api/me/profile` | src/components/settings/ProfileSettings.tsx |
| GET | `/api/me/settings` | src/components/settings/NotificationSettings.tsx |
| PATCH | `/api/me/settings` | src/components/settings/NotificationSettings.tsx |
| POST | `/api/stripe/connect` | src/components/settings/StripeConnectSettings.tsx |
| GET | `/api/stripe/connect-link` | src/components/settings/StripeConnectSettings.tsx |
| GET | `/api/stripe/connect-status` | src/components/settings/StripeConnectSettings.tsx |
| GET | `/api/tags` | src/components/settings/InterestsSettings.tsx |
| GET | `/api/users/check-handle` | src/components/settings/ProfileSettings.tsx |

**`/visitor`** — *no API calls detected*

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

### Social

**`/feed`** (src/pages/feed.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/smart` | src/components/feed/SmartFeed.tsx |
| POST | `/api/feeds/smart/dismiss` | src/components/feed/DiscoveryCard.tsx |

**`/feeds`** (src/pages/feeds.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/discover` | src/components/feed/directory/FeedsDiscoveryGrid.tsx |
| GET | `/api/me/feed-badges` | src/components/feed/directory/FeedsDirectory.tsx |

**`/messages`** (src/pages/messages.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/conversations` | src/components/messages/matt/MessagesCenter.tsx |
| POST | `/api/conversations` | src/components/messages/matt/NewConversationModal.tsx |
| GET | `/api/conversations/[param]` | src/components/messages/matt/MessageThread.tsx |
| POST | `/api/conversations/[param]/messages` | src/components/messages/matt/MessageThread.tsx |
| PUT | `/api/conversations/[param]/read` | src/components/messages/matt/MessageThread.tsx |
| PATCH | `/api/me/messages/read-all` | src/components/messages/matt/ConversationList.tsx |
| GET | `/api/users/search` | src/components/messages/matt/NewConversationModal.tsx |

**`/notifications`** (src/pages/notifications.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| DELETE | `/api/me/notifications` | src/components/notifications/NotificationCenter.tsx |
| GET | `/api/me/notifications` | src/components/notifications/NotificationCenter.tsx |
| DELETE | `/api/me/notifications/[param]` | src/components/notifications/NotificationCenter.tsx |
| PATCH | `/api/me/notifications/[param]/read` | src/components/notifications/NotificationCenter.tsx |
| PATCH | `/api/me/notifications/read-all` | src/components/notifications/NotificationCenter.tsx |

### Student

**`/courses`** (src/pages/courses.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/intel/courses` | src/components/courses/CoursesCatalog.tsx |
| GET | `/api/recommendations/courses` | src/components/recommendations/RecommendedCourses.tsx |

### Teaching

**`/teaching/[...tab]`** (src/pages/teaching/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/availability` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| PUT | `/api/me/availability` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| GET | `/api/me/availability/overrides` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| POST | `/api/me/availability/overrides` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| DELETE | `/api/me/availability/overrides/[param]` | src/components/teachers/workspace/AvailabilityCalendar.tsx |
| GET | `/api/me/feed-badges` | src/components/dashboard/MyFeeds.tsx |
| POST | `/api/me/payouts/request` | src/components/teachers/workspace/EarningsDetail.tsx |
| GET | `/api/me/teacher-analytics` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/earnings` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/sessions` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-analytics/students` | src/components/analytics/TeacherAnalytics.tsx |
| GET | `/api/me/teacher-dashboard` | src/components/dashboard/TeacherDashboard.tsx |
| GET | `/api/me/teacher-earnings` | src/components/teachers/workspace/EarningsDetail.tsx |
| GET | `/api/me/teacher-sessions` | src/components/teachers/workspace/TeacherSessionsList.tsx |
| GET | `/api/me/teacher-students` | src/components/teachers/workspace/MyStudents.tsx |
| POST | `/api/session-invites` | src/components/teachers/workspace/MyStudents.tsx |
| GET | `/api/session-invites` | src/components/teachers/workspace/MyStudents.tsx |

**`/teaching/courses/[courseId]`** (src/pages/teaching/courses/[courseId].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/teaching/courses/[param]` | src/components/teachers/workspace/TeacherCourseView.tsx |
| GET | `/api/teaching/courses/[param]/resources` | src/components/teachers/workspace/TeacherCourseView.tsx |

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
| `DELETE /api/communities/[param]/join` | `/community/[slug]/[...tab]` |
| `DELETE /api/communities/[param]/moderators/[param]` | `/community/[slug]/[...tab]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources`, `/old/discover/community/[slug]`, `/old/discover/community/[slug]/[...tab]` |
| `DELETE /api/me/account` | `/old/settings/security`, `/profile/[...tab]` |
| `DELETE /api/me/availability/overrides/[param]` | `/old/teaching/availability`, `/teaching/[...tab]` |
| `DELETE /api/me/communities/[param]` | `/creating/communities/[slug]`, `/old/creating/communities/[slug]` |
| `DELETE /api/me/communities/[param]/progressions/[param]` | `/creating/communities/[slug]`, `/old/creating/communities/[slug]` |
| `DELETE /api/me/courses/[param]/teachers/[param]` | `/creating/[...tab]`, `/old/creating/studio` |
| `DELETE /api/me/notifications` | `/notifications`, `/old/notifications` |
| `DELETE /api/me/notifications/[param]` | `/notifications`, `/old/notifications` |
| `DELETE /api/sessions/[param]` | `/course/[slug]/book`, `/old/course/[slug]/book`, `/old/session/[id]`, `/session/[id]` |
| `GET /api/admin/analytics` | `/admin/analytics` |
| `GET /api/admin/analytics/courses` | `/admin/analytics` |
| `GET /api/admin/analytics/engagement` | `/admin/analytics` |
| `GET /api/admin/analytics/revenue` | `/admin/analytics` |
| `GET /api/admin/analytics/teachers` | `/admin/analytics` |
| `GET /api/admin/analytics/users` | `/admin/analytics` |
| `GET /api/admin/bbb/recordings` | `/admin/recordings` |
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
| `GET /api/admin/intel/communities` | `/communities`, `/old/discover/communities` |
| `GET /api/admin/intel/courses` | `/courses`, `/old/discover/courses` |
| `GET /api/admin/moderation` | `/admin/moderation`, `/mod` |
| `GET /api/admin/moderation/[param]` | `/admin/moderation`, `/mod` |
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
| `GET /api/admin/users` | `/admin/users` |
| `GET /api/admin/users/[param]` | `/admin/users` |
| `GET /api/conversations` | `/messages`, `/old/messages` |
| `GET /api/conversations/[param]` | `/messages`, `/old/messages` |
| `GET /api/courses` | `/admin/certificates`, `/admin/enrollments`, `/admin/teachers`, `/community/[slug]/[...tab]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources` |
| `GET /api/courses/[param]/availability-summary` | `/course/[slug]/[...tab]`, `/course/[slug]/precheckout`, `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers` |
| `GET /api/courses/[param]/curriculum` | `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers` |
| `GET /api/courses/[param]/follow` | `/old/discover/course/[slug]`, `/old/discover/course/[slug]/[...tab]` |
| `GET /api/courses/[param]/resources` | `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers` |
| `GET /api/courses/[param]/sessions` | `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers`, `/old/discover/course/[slug]`, `/old/discover/course/[slug]/[...tab]` |
| `GET /api/creators/apply` | `/creating/apply` |
| `GET /api/enrollments/[param]/expectations` | `/old/session/[id]`, `/session/[id]` |
| `GET /api/enrollments/[param]/progress` | `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers` |
| `GET /api/feeds/course/[param]` | `/course/[slug]/[...tab]`, `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers`, `/old/teaching/courses/[courseId]`, `/teaching/courses/[courseId]` |
| `GET /api/feeds/discover` | `/feeds`, `/old/discover/feeds` |
| `GET /api/feeds/smart` | `/`, `/feed`, `/old/feed` |
| `GET /api/feeds/townhall` | `/community/[slug]/[...tab]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources` |
| `GET /api/leaderboard` | `/old/discover/leaderboard` |
| `GET /api/me/availability` | `/old/teaching`, `/old/teaching/availability`, `/teaching/[...tab]` |
| `GET /api/me/availability/overrides` | `/old/teaching/availability`, `/teaching/[...tab]` |
| `GET /api/me/can-message/[param]` | `/community/[slug]/[...tab]`, `/old/@[handle]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources`, `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers` |
| `GET /api/me/certificates` | `/learning/[...tab]`, `/old/learning` |
| `GET /api/me/communities` | `/creating/[...tab]`, `/creating/communities/[slug]`, `/old/creating/communities`, `/old/creating/communities/[slug]`, `/old/creating/studio` |
| `GET /api/me/communities/[param]/members` | `/creating/communities/[slug]`, `/old/creating/communities/[slug]` |
| `GET /api/me/communities/[param]/progressions` | `/creating/[...tab]`, `/creating/communities/[slug]`, `/old/creating/communities/[slug]`, `/old/creating/studio` |
| `GET /api/me/courses` | `/creating/[...tab]`, `/old/creating/studio` |
| `GET /api/me/courses/[param]` | `/creating/[...tab]`, `/old/creating/studio`, `/old/discover/course/[slug]`, `/old/discover/course/[slug]/[...tab]` |
| `GET /api/me/courses/[param]/teachers` | `/creating/[...tab]`, `/old/creating/studio`, `/old/discover/course/[slug]`, `/old/discover/course/[slug]/[...tab]` |
| `GET /api/me/creator-analytics` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-analytics/courses` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-analytics/enrollments` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-analytics/funnel` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-analytics/materials-feedback` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-analytics/progress` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-analytics/sessions` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-analytics/teacher-performance` | `/creating/[...tab]`, `/old/creating/analytics` |
| `GET /api/me/creator-dashboard` | `/creating/[...tab]`, `/old/creating`, `/old/dashboard` |
| `GET /api/me/creator-earnings` | `/creating/[...tab]`, `/old/creating/earnings` |
| `GET /api/me/feed-badges` | `/creating/[...tab]`, `/feeds`, `/learning/[...tab]`, `/old/creating`, `/old/dashboard`, `/old/discover/feeds`, `/old/feeds`, `/old/learning`, `/old/teaching`, `/teaching/[...tab]` |
| `GET /api/me/full` | `/old` |
| `GET /api/me/notifications` | `/notifications`, `/old/notifications` |
| `GET /api/me/onboarding-profile` | `/old/onboarding`, `/old/settings/interests`, `/onboarding`, `/profile/[...tab]` |
| `GET /api/me/profile` | `/old/settings/profile`, `/old/settings/security`, `/profile/[...tab]` |
| `GET /api/me/settings` | `/old/settings/notifications`, `/profile/[...tab]` |
| `GET /api/me/teacher-analytics` | `/old/teaching/analytics`, `/teaching/[...tab]` |
| `GET /api/me/teacher-analytics/earnings` | `/old/teaching/analytics`, `/teaching/[...tab]` |
| `GET /api/me/teacher-analytics/sessions` | `/old/teaching/analytics`, `/teaching/[...tab]` |
| `GET /api/me/teacher-analytics/students` | `/old/teaching/analytics`, `/teaching/[...tab]` |
| `GET /api/me/teacher-dashboard` | `/old/dashboard`, `/old/teaching`, `/teaching/[...tab]` |
| `GET /api/me/teacher-earnings` | `/old/teaching/earnings`, `/teaching/[...tab]` |
| `GET /api/me/teacher-sessions` | `/old/teaching/sessions`, `/teaching/[...tab]` |
| `GET /api/me/teacher-students` | `/old/teaching/students`, `/teaching/[...tab]` |
| `GET /api/members` | `/members`, `/old/discover/members` |
| `GET /api/recommendations/communities` | `/communities`, `/old/discover/communities` |
| `GET /api/recommendations/courses` | `/courses`, `/old/discover/courses` |
| `GET /api/session-invites` | `/old/teaching/students`, `/teaching/[...tab]` |
| `GET /api/sessions` | `/learning/[...tab]`, `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers`, `/old/courses`, `/old/dashboard`, `/old/learning`, `/old/learning/sessions` |
| `GET /api/sessions/[param]` | `/old/session/[id]`, `/session/[id]` |
| `GET /api/stripe/connect-link` | `/old/settings/payments`, `/profile/[...tab]` |
| `GET /api/stripe/connect-status` | `/old/settings/payments`, `/profile/[...tab]` |
| `GET /api/tags` | `/old/onboarding`, `/old/settings/interests`, `/onboarding`, `/profile/[...tab]` |
| `GET /api/teachers/[param]/availability` | `/course/[slug]/book`, `/old/course/[slug]/book` |
| `GET /api/teaching/courses/[param]` | `/old/discover/course/[slug]`, `/old/discover/course/[slug]/[...tab]`, `/old/teaching/courses/[courseId]`, `/teaching/courses/[courseId]` |
| `GET /api/teaching/courses/[param]/resources` | `/old/teaching/courses/[courseId]`, `/teaching/courses/[courseId]` |
| `GET /api/topics` | `/admin/courses`, `/creating/[...tab]`, `/old/creating/studio` |
| `GET /api/users/[param]` | `/old/@[handle]` |
| `GET /api/users/check-handle` | `/old/settings/profile`, `/profile/[...tab]` |
| `GET /api/users/search` | `/messages`, `/old/messages` |
| `PATCH /api/admin/sessions/[param]` | `/admin/sessions` |
| `PATCH /api/admin/topics/[param]` | `/admin/topics` |
| `PATCH /api/admin/users/[param]` | `/admin/users` |
| `PATCH /api/enrollments/[param]/expectations` | `/old/session/[id]`, `/session/[id]` |
| `PATCH /api/me/communities/[param]` | `/creating/communities/[slug]`, `/old/creating/communities/[slug]` |
| `PATCH /api/me/communities/[param]/progressions/[param]` | `/creating/communities/[slug]`, `/old/creating/communities/[slug]` |
| `PATCH /api/me/communities/[param]/progressions/reorder` | `/creating/communities/[slug]`, `/old/creating/communities/[slug]` |
| `PATCH /api/me/messages/read-all` | `/messages`, `/old/messages` |
| `PATCH /api/me/notifications/[param]/read` | `/notifications`, `/old/notifications` |
| `PATCH /api/me/notifications/read-all` | `/notifications`, `/old/notifications` |
| `PATCH /api/me/profile` | `/old/settings/profile`, `/profile/[...tab]` |
| `PATCH /api/me/settings` | `/old/settings/notifications`, `/profile/[...tab]` |
| `PATCH /api/me/teacher/[param]/toggle` | `/creating/[...tab]`, `/old/creating` |
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
| `POST /api/admin/moderation/[param]/dismiss` | `/admin/moderation`, `/mod` |
| `POST /api/admin/moderation/[param]/remove` | `/admin/moderation`, `/mod` |
| `POST /api/admin/moderation/[param]/suspend` | `/admin/moderation`, `/mod` |
| `POST /api/admin/moderation/[param]/warn` | `/admin/moderation`, `/mod` |
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
| `POST /api/auth/logout` | `/old/settings/security`, `/profile/[...tab]` |
| `POST /api/auth/reset-password` | `/old/reset-password` |
| `POST /api/checkout/create-session` | `/course/[slug]/[...tab]`, `/course/[slug]/precheckout`, `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers` |
| `POST /api/communities/[param]/moderators` | `/community/[slug]/[...tab]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources`, `/old/discover/community/[slug]`, `/old/discover/community/[slug]/[...tab]` |
| `POST /api/conversations` | `/messages`, `/old/messages`, `/old/session/[id]`, `/session/[id]` |
| `POST /api/conversations/[param]/messages` | `/messages`, `/old/messages` |
| `POST /api/courses/[param]/discussion-feed` | `/creating/[...tab]`, `/old/creating` |
| `POST /api/creators/apply` | `/creating/apply` |
| `POST /api/enrollments/[param]/expectations` | `/course/[slug]/success`, `/old/course/[slug]/success` |
| `POST /api/enrollments/[param]/progress` | `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers` |
| `POST /api/feeds/community/[param]` | `/community/[slug]/[...tab]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources` |
| `POST /api/feeds/course/[param]` | `/course/[slug]/[...tab]`, `/course/[slug]/success`, `/old/course/[slug]`, `/old/course/[slug]/[tab]`, `/old/course/[slug]/feed`, `/old/course/[slug]/learn`, `/old/course/[slug]/resources`, `/old/course/[slug]/sessions`, `/old/course/[slug]/teachers`, `/old/teaching/courses/[courseId]`, `/teaching/courses/[courseId]` |
| `POST /api/feeds/smart/dismiss` | `/`, `/feed`, `/old/feed` |
| `POST /api/feeds/townhall` | `/community/[slug]/[...tab]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources` |
| `POST /api/me/availability/overrides` | `/old/teaching/availability`, `/teaching/[...tab]` |
| `POST /api/me/communities` | `/creating/[...tab]`, `/old/creating/communities` |
| `POST /api/me/communities/[param]/progressions` | `/creating/communities/[slug]`, `/old/creating/communities/[slug]` |
| `POST /api/me/communities/[param]/resources` | `/community/[slug]/[...tab]`, `/old/community/[slug]`, `/old/community/[slug]/courses`, `/old/community/[slug]/members`, `/old/community/[slug]/resources` |
| `POST /api/me/courses` | `/creating/[...tab]`, `/old/creating/studio` |
| `POST /api/me/courses/[param]/teachers` | `/creating/[...tab]`, `/old/creating/studio` |
| `POST /api/me/courses/[param]/thumbnail` | `/creating/[...tab]`, `/old/creating/studio` |
| `POST /api/me/onboarding-profile` | `/old/onboarding`, `/old/settings/interests`, `/onboarding`, `/profile/[...tab]` |
| `POST /api/me/payouts/request` | `/creating/[...tab]`, `/old/creating/earnings`, `/old/teaching/earnings`, `/teaching/[...tab]` |
| `POST /api/reviews/course/[param]/response` | `/creating/[...tab]`, `/old/creating/analytics` |
| `POST /api/session-invites` | `/old/teaching/students`, `/teaching/[...tab]` |
| `POST /api/session-invites/[param]/accept` | `/course/[slug]/book`, `/old/course/[slug]/book` |
| `POST /api/session-invites/[param]/decline` | `/course/[slug]/book`, `/old/course/[slug]/book` |
| `POST /api/sessions` | `/course/[slug]/book`, `/old/course/[slug]/book` |
| `POST /api/sessions/[param]/complete` | `/old/session/[id]`, `/session/[id]` |
| `POST /api/sessions/[param]/join` | `/old/session/[id]`, `/session/[id]` |
| `POST /api/sessions/[param]/rating` | `/old/session/[id]`, `/session/[id]` |
| `POST /api/stripe/connect` | `/old/settings/payments`, `/profile/[...tab]` |
| `POST /api/stripe/verify-checkout` | `/old/courses` |
| `PUT /api/conversations/[param]/read` | `/messages`, `/old/messages` |
| `PUT /api/me/availability` | `/old/teaching/availability`, `/teaching/[...tab]` |
| `PUT /api/me/courses/[param]` | `/creating/[...tab]`, `/old/creating/studio` |
| `PUT /api/me/courses/[param]/publish` | `/creating/[...tab]`, `/old/creating/studio` |
| `PUT /api/me/courses/[param]/teachers/[param]` | `/creating/[...tab]`, `/old/creating/studio` |
| `PUT /api/me/courses/[param]/unpublish` | `/creating/[...tab]`, `/old/creating/studio` |

---

## 3. Navigation Paths (AppNavbar → Page)

How does a user reach each page starting from the sidebar navigation?
Used by PLATO browser-runs to follow real user navigation instead of direct URL entry.

### Unreachable (no path from navbar)

- `/404` — ℹ️ no-nav by design
- `/admin/recordings` — ℹ️ no-nav by design
- `/become-a-teacher` — ℹ️ no-nav by design
- `/community/[slug]/[...tab]` — ℹ️ no-nav by design
- `/course/[slug]/[...tab]` — ℹ️ no-nav by design
- `/course/[slug]/precheckout` — ℹ️ no-nav by design
- `/creating/[...tab]` — ℹ️ no-nav by design
- `/creating/communities/[slug]` — ⚠️ no discovered path
- `/dev/primitives` — ℹ️ no-nav by design
- `/dev/saved` — ℹ️ no-nav by design
- `/dev/todo` — ℹ️ no-nav by design
- `/learning/[...tab]` — ℹ️ no-nav by design
- `/members` — ℹ️ no-nav by design
- `/mod` — ℹ️ no-nav by design
- `/old` — ⚠️ no discovered path
- `/old/@[handle]` — ⚠️ no discovered path
- `/old/about` — ℹ️ no-nav by design
- `/old/blog` — ℹ️ no-nav by design
- `/old/careers` — ℹ️ no-nav by design
- `/old/community` — ⚠️ no discovered path
- `/old/community/[slug]` — ⚠️ no discovered path
- `/old/community/[slug]/courses` — ⚠️ no discovered path
- `/old/community/[slug]/members` — ⚠️ no discovered path
- `/old/community/[slug]/resources` — ⚠️ no discovered path
- `/old/contact` — ℹ️ no-nav by design
- `/old/cookies` — ℹ️ no-nav by design
- `/old/course/[slug]` — ⚠️ no discovered path
- `/old/course/[slug]/[tab]` — ℹ️ no-nav by design
- `/old/course/[slug]/book` — ⚠️ no discovered path
- `/old/course/[slug]/feed` — ⚠️ no discovered path
- `/old/course/[slug]/learn` — ⚠️ no discovered path
- `/old/course/[slug]/resources` — ⚠️ no discovered path
- `/old/course/[slug]/sessions` — ⚠️ no discovered path
- `/old/course/[slug]/success` — ⚠️ no discovered path
- `/old/course/[slug]/teachers` — ⚠️ no discovered path
- `/old/courses` — ⚠️ no discovered path
- `/old/creating` — ⚠️ no discovered path
- `/old/creating/analytics` — ⚠️ no discovered path
- `/old/creating/communities` — ⚠️ no discovered path
- `/old/creating/communities/[slug]` — ⚠️ no discovered path
- `/old/creating/earnings` — ⚠️ no discovered path
- `/old/creating/studio` — ⚠️ no discovered path
- `/old/creator/[handle]` — ⚠️ no discovered path
- `/old/dashboard` — ⚠️ no discovered path
- `/old/discover` — ⚠️ no discovered path
- `/old/discover/communities` — ⚠️ no discovered path
- `/old/discover/community/[slug]` — ⚠️ no discovered path
- `/old/discover/community/[slug]/[...tab]` — ⚠️ no discovered path
- `/old/discover/course/[slug]` — ⚠️ no discovered path
- `/old/discover/course/[slug]/[...tab]` — ⚠️ no discovered path
- `/old/discover/courses` — ⚠️ no discovered path
- `/old/discover/creators` — ℹ️ no-nav by design
- `/old/discover/feeds` — ⚠️ no discovered path
- `/old/discover/leaderboard` — ⚠️ no discovered path
- `/old/discover/members` — ⚠️ no discovered path
- `/old/discover/students` — ℹ️ no-nav by design
- `/old/discover/teachers` — ℹ️ no-nav by design
- `/old/faq` — ℹ️ no-nav by design
- `/old/feed` — ⚠️ no discovered path
- `/old/feeds` — ⚠️ no discovered path
- `/old/for-creators` — ℹ️ no-nav by design
- `/old/help` — ⚠️ no discovered path
- `/old/how-it-works` — ℹ️ no-nav by design
- `/old/learning` — ⚠️ no discovered path
- `/old/learning/sessions` — ⚠️ no discovered path
- `/old/login` — ⚠️ no discovered path
- `/old/messages` — ⚠️ no discovered path
- `/old/notifications` — ⚠️ no discovered path
- `/old/onboarding` — ⚠️ no discovered path
- `/old/pricing` — ℹ️ no-nav by design
- `/old/privacy` — ℹ️ no-nav by design
- `/old/profile` — ⚠️ no discovered path
- `/old/reset-password` — ⚠️ no discovered path
- `/old/session/[id]` — ⚠️ no discovered path
- `/old/settings` — ⚠️ no discovered path
- `/old/settings/interests` — ⚠️ no discovered path
- `/old/settings/notifications` — ⚠️ no discovered path
- `/old/settings/payments` — ⚠️ no discovered path
- `/old/settings/profile` — ⚠️ no discovered path
- `/old/settings/security` — ⚠️ no discovered path
- `/old/signup` — ⚠️ no discovered path
- `/old/stories` — ℹ️ no-nav by design
- `/old/teacher/[handle]` — ⚠️ no discovered path
- `/old/teaching` — ⚠️ no discovered path
- `/old/teaching/analytics` — ⚠️ no discovered path
- `/old/teaching/availability` — ⚠️ no discovered path
- `/old/teaching/courses/[courseId]` — ⚠️ no discovered path
- `/old/teaching/earnings` — ⚠️ no discovered path
- `/old/teaching/sessions` — ⚠️ no discovered path
- `/old/teaching/students` — ⚠️ no discovered path
- `/old/terms` — ℹ️ no-nav by design
- `/old/testimonials` — ℹ️ no-nav by design
- `/old/verify/[id]` — ⚠️ no discovered path
- `/profile/[...tab]` — ℹ️ no-nav by design
- `/teaching/[...tab]` — ℹ️ no-nav by design
- `/visitor` — ℹ️ no-nav by design

### 1 click (direct navbar link)

- `/admin` — Click "Admin" in sidebar
- `/courses` — Click "My Courses" in sidebar
- `/creating/apply` — Click "Become a Creator" in sidebar
- `/feeds` — Click "My Feeds" in sidebar
- `/messages` — Click "Messages" in sidebar
- `/notifications` — Click "Notifications" in sidebar
- `/onboarding` — Click "Complete Profile" in sidebar

### 2 clicks

- `/` — Click "My Courses" in sidebar → Link on /courses
- `/admin/courses` — Click "Admin" in sidebar → Link on /admin
- `/admin/enrollments` — Click "Admin" in sidebar → Link on /admin
- `/admin/teachers` — Click "Admin" in sidebar → Link on /admin
- `/admin/users` — Click "Admin" in sidebar → Link on /admin
- `/communities` — Click "My Feeds" in sidebar → Link on /feeds
- `/course/[slug]/book` — Click "My Courses" in sidebar → Link on /courses
- `/feed` — Click "My Feeds" in sidebar → Link on /feeds
- `/login` — Click "Messages" in sidebar → Link on /messages
- `/teaching/courses/[courseId]` — Click "Teaching" in sidebar → Click course card tab/link on /teaching

### 3 clicks

- `/admin/analytics` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Analytics" in admin sidebar
- `/admin/certificates` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Certificates" in admin sidebar
- `/admin/creator-applications` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Creator Applications" in admin sidebar
- `/admin/moderation` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Moderation" in admin sidebar
- `/admin/moderators` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Moderators" in admin sidebar
- `/admin/payouts` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Payouts" in admin sidebar
- `/admin/sessions` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Sessions" in admin sidebar
- `/admin/topics` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Topics" in admin sidebar
- `/course/[slug]/success` — Click "My Courses" in sidebar → Link on /courses → Success (post-checkout redirect) tab/link on /course/[slug]
- `/session/[id]` — Click "My Courses" in sidebar → Link on /courses → Link on /course/[slug]/book
- `/signup` — Click "My Courses" in sidebar → Link on /courses → Link on /

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
