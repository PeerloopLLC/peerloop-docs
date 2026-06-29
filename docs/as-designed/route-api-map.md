# Route ↔ API Map

> **Auto-generated** by `scripts/route-api-map.mjs` — do not edit manually.
> Last generated: 2026-06-29
>
> Run: `cd ../Peerloop && node scripts/route-api-map.mjs`

---

## Quick Stats

- **Pages scanned:** 62
- **API endpoints found in UI:** 206
- **Routes reachable from navbar:** 48
- **Unreachable routes:** 31

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

**`/admin/announcements`** (src/pages/admin/announcements.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/announcements` | src/components/admin/AnnouncementsAdmin.tsx |
| POST | `/api/admin/announcements` | src/components/admin/AnnouncementsAdmin.tsx |
| POST | `/api/admin/announcements/[param]/remove` | src/components/admin/AnnouncementsAdmin.tsx |

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
| GET | `/api/admin/moderation/promotions` | src/components/admin/SystemPromotionsModeration.tsx |
| POST | `/api/admin/moderation/promotions/[param]/remove` | src/components/admin/SystemPromotionsModeration.tsx |

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

**`/admin/promotion-settings`** (src/pages/admin/promotion-settings.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/admin/promotion-config` | src/components/admin/PromotionSettingsAdmin.tsx |
| POST | `/api/admin/promotion-config` | src/components/admin/PromotionSettingsAdmin.tsx |
| GET | `/api/admin/promotion-password` | src/components/admin/PromotionSettingsAdmin.tsx |
| POST | `/api/admin/promotion-password` | src/components/admin/PromotionSettingsAdmin.tsx |

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

**`/reset-password`** (src/pages/reset-password.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/auth/reset-password` | src/components/auth/PasswordResetForm.tsx |

**`/signup`** — *no API calls detected*

### Community

**`/community/[slug]/[...tab]`** (src/pages/community/[slug]/[...tab].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| DELETE | `/api/communities/[param]/join` | src/pages/community/[slug]/[...tab].astro |
| POST | `/api/communities/[param]/moderators` | src/components/community/CommunityMembersTab.tsx |
| DELETE | `/api/communities/[param]/moderators/[param]` | src/components/community/CommunityMembersTab.tsx |
| GET | `/api/courses` | src/components/community/SystemFeed.tsx |
| POST | `/api/feeds/community/[param]` | src/components/community/CommunityFeed.tsx |
| POST | `/api/feeds/system` | src/components/community/SystemFeed.tsx |
| GET | `/api/feeds/system` | src/components/community/SystemFeed.tsx |
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
| POST | `/api/feeds/promote` | src/components/feed/PromoteButton.tsx |

**`/course/[slug]/book`** (src/pages/course/[slug]/book.astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| POST | `/api/session-invites/[param]/accept` | src/components/booking/SessionBooking.tsx |
| POST | `/api/session-invites/[param]/decline` | src/components/booking/SessionBooking.tsx |
| POST | `/api/sessions` | src/components/booking/SessionBooking.tsx |
| DELETE | `/api/sessions/[param]` | src/components/booking/SessionBooking.tsx |
| GET | `/api/teachers/[param]/availability` | src/components/booking/SessionBooking.tsx |

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
| GET | `/api/feeds/promotable-entities` | src/components/promotion/PromoteNudge.tsx |
| POST | `/api/feeds/promote-entity` | src/components/feed/EntityPromoComposer.tsx |
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
| POST | `/api/announcements/dismiss` | src/components/feed/SmartFeed.tsx |
| GET | `/api/feeds/smart` | src/components/feed/SmartFeed.tsx |
| POST | `/api/feeds/smart/dismiss` | src/components/feed/SmartFeed.tsx |

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

**`/old/about`** — *no API calls detected*

**`/old/blog`** — *no API calls detected*

**`/old/careers`** — *no API calls detected*

**`/old/contact`** — *no API calls detected*

**`/old/cookies`** — *no API calls detected*

**`/old/faq`** — *no API calls detected*

**`/old/for-creators`** — *no API calls detected*

**`/old/help`** — *no API calls detected*

**`/old/how-it-works`** — *no API calls detected*

**`/old/pricing`** — *no API calls detected*

**`/old/privacy`** — *no API calls detected*

**`/old/stories`** — *no API calls detected*

**`/old/terms`** — *no API calls detected*

**`/old/testimonials`** — *no API calls detected*

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

**`/verify/[id]`** — *no API calls detected*

### Profile

**`/@[handle]`** (src/pages/@[handle].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/me/can-message/[param]` | src/lib/useCanMessage.ts |
| GET | `/api/users/[param]` | src/components/profile/PublicProfile.tsx |

**`/creator/[handle]`** — *no API calls detected*

**`/teacher/[handle]`** — *no API calls detected*

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
| GET | `/api/feeds/promotable-entities` | src/components/promotion/PromoteNudge.tsx |
| POST | `/api/feeds/promote-entity` | src/components/feed/EntityPromoComposer.tsx |
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
| GET | `/api/sessions/[param]/attendance` | src/components/teachers/workspace/TeacherSessionsList.tsx |

**`/teaching/courses/[courseId]`** (src/pages/teaching/courses/[courseId].astro)

| Method | API Endpoint | Component |
|--------|-------------|-----------|
| GET | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| POST | `/api/feeds/course/[param]` | src/components/community/CourseFeed.tsx |
| GET | `/api/homework/[param]/submissions` | src/components/teachers/workspace/HomeworkGradingPanel.tsx |
| PATCH | `/api/homework/[param]/submissions/[param]` | src/components/teachers/workspace/HomeworkGradingPanel.tsx |
| GET | `/api/teaching/courses/[param]` | src/components/teachers/workspace/TeacherCourseView.tsx |
| GET | `/api/teaching/courses/[param]/homework` | src/components/teachers/workspace/HomeworkGradingPanel.tsx |
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
| `DELETE /api/communities/[param]/moderators/[param]` | `/community/[slug]/[...tab]` |
| `DELETE /api/me/account` | `/profile/[...tab]` |
| `DELETE /api/me/availability/overrides/[param]` | `/teaching/[...tab]` |
| `DELETE /api/me/communities/[param]` | `/creating/communities/[slug]` |
| `DELETE /api/me/communities/[param]/progressions/[param]` | `/creating/communities/[slug]` |
| `DELETE /api/me/courses/[param]/teachers/[param]` | `/creating/[...tab]` |
| `DELETE /api/me/notifications` | `/notifications` |
| `DELETE /api/me/notifications/[param]` | `/notifications` |
| `DELETE /api/sessions/[param]` | `/course/[slug]/book`, `/session/[id]` |
| `GET /api/admin/analytics` | `/admin/analytics` |
| `GET /api/admin/analytics/courses` | `/admin/analytics` |
| `GET /api/admin/analytics/engagement` | `/admin/analytics` |
| `GET /api/admin/analytics/revenue` | `/admin/analytics` |
| `GET /api/admin/analytics/teachers` | `/admin/analytics` |
| `GET /api/admin/analytics/users` | `/admin/analytics` |
| `GET /api/admin/announcements` | `/admin/announcements` |
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
| `GET /api/admin/intel/communities` | `/communities` |
| `GET /api/admin/intel/courses` | `/courses` |
| `GET /api/admin/moderation` | `/admin/moderation`, `/mod` |
| `GET /api/admin/moderation/[param]` | `/admin/moderation`, `/mod` |
| `GET /api/admin/moderation/promotions` | `/admin/moderation` |
| `GET /api/admin/moderators` | `/admin/moderators` |
| `GET /api/admin/payouts` | `/admin/payouts` |
| `GET /api/admin/payouts/[param]` | `/admin/payouts` |
| `GET /api/admin/payouts/pending` | `/admin/payouts` |
| `GET /api/admin/promotion-config` | `/admin/promotion-settings` |
| `GET /api/admin/promotion-password` | `/admin/promotion-settings` |
| `GET /api/admin/sessions` | `/admin/sessions` |
| `GET /api/admin/sessions/[param]` | `/admin/sessions` |
| `GET /api/admin/sessions/[param]/recording` | `/admin/sessions` |
| `GET /api/admin/teachers` | `/admin/teachers` |
| `GET /api/admin/teachers/[param]` | `/admin/teachers` |
| `GET /api/admin/topics` | `/admin/topics` |
| `GET /api/admin/users` | `/admin/users` |
| `GET /api/admin/users/[param]` | `/admin/users` |
| `GET /api/conversations` | `/messages` |
| `GET /api/conversations/[param]` | `/messages` |
| `GET /api/courses` | `/admin/certificates`, `/admin/enrollments`, `/admin/teachers`, `/community/[slug]/[...tab]` |
| `GET /api/courses/[param]/availability-summary` | `/course/[slug]/[...tab]` |
| `GET /api/creators/apply` | `/creating/apply` |
| `GET /api/enrollments/[param]/expectations` | `/session/[id]` |
| `GET /api/feeds/course/[param]` | `/course/[slug]/[...tab]`, `/teaching/courses/[courseId]` |
| `GET /api/feeds/promotable-entities` | `/creating/[...tab]`, `/teaching/[...tab]` |
| `GET /api/feeds/smart` | `/` |
| `GET /api/feeds/system` | `/community/[slug]/[...tab]` |
| `GET /api/homework/[param]/submissions` | `/teaching/courses/[courseId]` |
| `GET /api/me/availability` | `/teaching/[...tab]` |
| `GET /api/me/availability/overrides` | `/teaching/[...tab]` |
| `GET /api/me/can-message/[param]` | `/@[handle]`, `/community/[slug]/[...tab]` |
| `GET /api/me/certificates` | `/learning/[...tab]` |
| `GET /api/me/communities` | `/creating/[...tab]`, `/creating/communities/[slug]` |
| `GET /api/me/communities/[param]/members` | `/creating/communities/[slug]` |
| `GET /api/me/communities/[param]/progressions` | `/creating/[...tab]`, `/creating/communities/[slug]` |
| `GET /api/me/courses` | `/creating/[...tab]` |
| `GET /api/me/courses/[param]` | `/creating/[...tab]` |
| `GET /api/me/courses/[param]/teachers` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics/courses` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics/enrollments` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics/funnel` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics/materials-feedback` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics/progress` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics/sessions` | `/creating/[...tab]` |
| `GET /api/me/creator-analytics/teacher-performance` | `/creating/[...tab]` |
| `GET /api/me/creator-dashboard` | `/creating/[...tab]` |
| `GET /api/me/creator-earnings` | `/creating/[...tab]` |
| `GET /api/me/feed-badges` | `/creating/[...tab]`, `/learning/[...tab]`, `/teaching/[...tab]` |
| `GET /api/me/notifications` | `/notifications` |
| `GET /api/me/onboarding-profile` | `/onboarding`, `/profile/[...tab]` |
| `GET /api/me/profile` | `/profile/[...tab]` |
| `GET /api/me/settings` | `/profile/[...tab]` |
| `GET /api/me/teacher-analytics` | `/teaching/[...tab]` |
| `GET /api/me/teacher-analytics/earnings` | `/teaching/[...tab]` |
| `GET /api/me/teacher-analytics/sessions` | `/teaching/[...tab]` |
| `GET /api/me/teacher-analytics/students` | `/teaching/[...tab]` |
| `GET /api/me/teacher-dashboard` | `/teaching/[...tab]` |
| `GET /api/me/teacher-earnings` | `/teaching/[...tab]` |
| `GET /api/me/teacher-sessions` | `/teaching/[...tab]` |
| `GET /api/me/teacher-students` | `/teaching/[...tab]` |
| `GET /api/members` | `/members` |
| `GET /api/recommendations/communities` | `/communities` |
| `GET /api/recommendations/courses` | `/courses` |
| `GET /api/session-invites` | `/teaching/[...tab]` |
| `GET /api/sessions` | `/learning/[...tab]` |
| `GET /api/sessions/[param]` | `/session/[id]` |
| `GET /api/sessions/[param]/attendance` | `/teaching/[...tab]` |
| `GET /api/stripe/connect-link` | `/profile/[...tab]` |
| `GET /api/stripe/connect-status` | `/profile/[...tab]` |
| `GET /api/tags` | `/onboarding`, `/profile/[...tab]` |
| `GET /api/teachers/[param]/availability` | `/course/[slug]/book` |
| `GET /api/teaching/courses/[param]` | `/teaching/courses/[courseId]` |
| `GET /api/teaching/courses/[param]/homework` | `/teaching/courses/[courseId]` |
| `GET /api/teaching/courses/[param]/resources` | `/teaching/courses/[courseId]` |
| `GET /api/topics` | `/admin/courses`, `/creating/[...tab]` |
| `GET /api/users/[param]` | `/@[handle]` |
| `GET /api/users/check-handle` | `/profile/[...tab]` |
| `GET /api/users/search` | `/messages` |
| `PATCH /api/admin/sessions/[param]` | `/admin/sessions` |
| `PATCH /api/admin/topics/[param]` | `/admin/topics` |
| `PATCH /api/admin/users/[param]` | `/admin/users` |
| `PATCH /api/enrollments/[param]/expectations` | `/session/[id]` |
| `PATCH /api/homework/[param]/submissions/[param]` | `/teaching/courses/[courseId]` |
| `PATCH /api/me/communities/[param]` | `/creating/communities/[slug]` |
| `PATCH /api/me/communities/[param]/progressions/[param]` | `/creating/communities/[slug]` |
| `PATCH /api/me/communities/[param]/progressions/reorder` | `/creating/communities/[slug]` |
| `PATCH /api/me/messages/read-all` | `/messages` |
| `PATCH /api/me/notifications/[param]/read` | `/notifications` |
| `PATCH /api/me/notifications/read-all` | `/notifications` |
| `PATCH /api/me/profile` | `/profile/[...tab]` |
| `PATCH /api/me/settings` | `/profile/[...tab]` |
| `PATCH /api/me/teacher/[param]/toggle` | `/creating/[...tab]` |
| `POST /api/admin/announcements` | `/admin/announcements` |
| `POST /api/admin/announcements/[param]/remove` | `/admin/announcements` |
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
| `POST /api/admin/moderation/promotions/[param]/remove` | `/admin/moderation` |
| `POST /api/admin/moderators/[param]/remove` | `/admin/moderators` |
| `POST /api/admin/moderators/[param]/resend` | `/admin/moderators` |
| `POST /api/admin/moderators/[param]/revoke` | `/admin/moderators` |
| `POST /api/admin/moderators/invite` | `/admin/moderators` |
| `POST /api/admin/payouts` | `/admin/payouts` |
| `POST /api/admin/payouts/[param]/process` | `/admin/payouts` |
| `POST /api/admin/payouts/[param]/retry` | `/admin/payouts` |
| `POST /api/admin/payouts/batch` | `/admin/payouts` |
| `POST /api/admin/promotion-config` | `/admin/promotion-settings` |
| `POST /api/admin/promotion-password` | `/admin/promotion-settings` |
| `POST /api/admin/sessions/[param]/resolve` | `/admin/sessions` |
| `POST /api/admin/sessions/cleanup` | `/admin` |
| `POST /api/admin/teachers/[param]/activate` | `/admin/teachers` |
| `POST /api/admin/teachers/[param]/deactivate` | `/admin/teachers` |
| `POST /api/admin/topics` | `/admin/topics` |
| `POST /api/admin/topics/reorder` | `/admin/topics` |
| `POST /api/admin/users/[param]/suspend` | `/admin/users` |
| `POST /api/admin/users/[param]/unsuspend` | `/admin/users` |
| `POST /api/announcements/dismiss` | `/` |
| `POST /api/auth/logout` | `/profile/[...tab]` |
| `POST /api/auth/reset-password` | `/reset-password` |
| `POST /api/checkout/create-session` | `/course/[slug]/[...tab]` |
| `POST /api/communities/[param]/moderators` | `/community/[slug]/[...tab]` |
| `POST /api/conversations` | `/messages`, `/session/[id]` |
| `POST /api/conversations/[param]/messages` | `/messages` |
| `POST /api/courses/[param]/discussion-feed` | `/creating/[...tab]` |
| `POST /api/creators/apply` | `/creating/apply` |
| `POST /api/enrollments/[param]/expectations` | `/course/[slug]/success` |
| `POST /api/feeds/community/[param]` | `/community/[slug]/[...tab]` |
| `POST /api/feeds/course/[param]` | `/course/[slug]/[...tab]`, `/course/[slug]/success`, `/teaching/courses/[courseId]` |
| `POST /api/feeds/promote` | `/course/[slug]/[...tab]` |
| `POST /api/feeds/promote-entity` | `/creating/[...tab]`, `/teaching/[...tab]` |
| `POST /api/feeds/smart/dismiss` | `/` |
| `POST /api/feeds/system` | `/community/[slug]/[...tab]` |
| `POST /api/me/availability/overrides` | `/teaching/[...tab]` |
| `POST /api/me/communities` | `/creating/[...tab]` |
| `POST /api/me/communities/[param]/progressions` | `/creating/communities/[slug]` |
| `POST /api/me/communities/[param]/resources` | `/community/[slug]/[...tab]` |
| `POST /api/me/courses` | `/creating/[...tab]` |
| `POST /api/me/courses/[param]/teachers` | `/creating/[...tab]` |
| `POST /api/me/courses/[param]/thumbnail` | `/creating/[...tab]` |
| `POST /api/me/onboarding-profile` | `/onboarding`, `/profile/[...tab]` |
| `POST /api/me/payouts/request` | `/creating/[...tab]`, `/teaching/[...tab]` |
| `POST /api/reviews/course/[param]/response` | `/creating/[...tab]` |
| `POST /api/session-invites` | `/teaching/[...tab]` |
| `POST /api/session-invites/[param]/accept` | `/course/[slug]/book` |
| `POST /api/session-invites/[param]/decline` | `/course/[slug]/book` |
| `POST /api/sessions` | `/course/[slug]/book` |
| `POST /api/sessions/[param]/complete` | `/session/[id]` |
| `POST /api/sessions/[param]/join` | `/session/[id]` |
| `POST /api/sessions/[param]/rating` | `/session/[id]` |
| `POST /api/stripe/connect` | `/profile/[...tab]` |
| `PUT /api/conversations/[param]/read` | `/messages` |
| `PUT /api/me/availability` | `/teaching/[...tab]` |
| `PUT /api/me/courses/[param]` | `/creating/[...tab]` |
| `PUT /api/me/courses/[param]/publish` | `/creating/[...tab]` |
| `PUT /api/me/courses/[param]/teachers/[param]` | `/creating/[...tab]` |
| `PUT /api/me/courses/[param]/unpublish` | `/creating/[...tab]` |

---

## 3. Navigation Paths (Sidebar → Page)

How does a user reach each page starting from the sidebar navigation?
Used by PLATO browser-runs to follow real user navigation instead of direct URL entry.

### Unreachable (no path from navbar)

- `/404` — ℹ️ no-nav by design
- `/admin/announcements` — ⚠️ no discovered path
- `/admin/promotion-settings` — ⚠️ no discovered path
- `/admin/recordings` — ℹ️ no-nav by design
- `/become-a-teacher` — ℹ️ no-nav by design
- `/community/[slug]/[...tab]` — ℹ️ no-nav by design
- `/course/[slug]/[...tab]` — ℹ️ no-nav by design
- `/creating/[...tab]` — ℹ️ no-nav by design
- `/creating/apply` — ⚠️ no discovered path
- `/creating/communities/[slug]` — ⚠️ no discovered path
- `/dev/primitives` — ℹ️ no-nav by design
- `/dev/saved` — ℹ️ no-nav by design
- `/dev/todo` — ℹ️ no-nav by design
- `/learning/[...tab]` — ℹ️ no-nav by design
- `/old/about` — ℹ️ no-nav by design
- `/old/blog` — ℹ️ no-nav by design
- `/old/careers` — ℹ️ no-nav by design
- `/old/contact` — ℹ️ no-nav by design
- `/old/cookies` — ℹ️ no-nav by design
- `/old/faq` — ℹ️ no-nav by design
- `/old/for-creators` — ℹ️ no-nav by design
- `/old/help` — ⚠️ no discovered path
- `/old/how-it-works` — ℹ️ no-nav by design
- `/old/pricing` — ℹ️ no-nav by design
- `/old/privacy` — ℹ️ no-nav by design
- `/old/stories` — ℹ️ no-nav by design
- `/old/terms` — ℹ️ no-nav by design
- `/old/testimonials` — ℹ️ no-nav by design
- `/profile/[...tab]` — ℹ️ no-nav by design
- `/reset-password` — ⚠️ no discovered path
- `/teaching/[...tab]` — ℹ️ no-nav by design

### 1 click (direct navbar link)

- `/` — Click "Home" in sidebar
- `/admin` — Click "Admin" in sidebar
- `/communities` — Click "Communities" in sidebar
- `/courses` — Click "Courses" in sidebar
- `/members` — Click "Members" in sidebar
- `/messages` — Click "Messages" in sidebar
- `/mod` — Click "Moderation" in sidebar
- `/notifications` — Click "Notifications" in sidebar

### 2 clicks

- `/@[handle]` — Click "Home" in sidebar → Link on /
- `/admin/courses` — Click "Admin" in sidebar → Link on /admin
- `/admin/enrollments` — Click "Admin" in sidebar → Link on /admin
- `/admin/teachers` — Click "Admin" in sidebar → Link on /admin
- `/admin/users` — Click "Admin" in sidebar → Link on /admin
- `/course/[slug]/book` — Click "Courses" in sidebar → Link on /courses
- `/creator/[handle]` — Click "Courses" in sidebar → Link on /courses
- `/login` — Click "Messages" in sidebar → Link on /messages
- `/onboarding` — Click "Home" in sidebar → Link on /
- `/signup` — Click "Home" in sidebar → Link on /
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
- `/course/[slug]/success` — Click "Home" in sidebar → Link on / → Success (post-checkout redirect) tab/link on /course/[slug]
- `/session/[id]` — Click "Courses" in sidebar → Link on /courses → Link on /course/[slug]/book
- `/teacher/[handle]` — Click "Home" in sidebar → Link on / → Link on /@[handle]

### 4 clicks

- `/verify/[id]` — Click "Admin" in sidebar → Admin sidebar navigation → Click "Certificates" in admin sidebar → Link on /admin/certificates

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
// → [{ from: "[Sidebar]", to: "/courses", via: "Click \"Courses\"" },
//     { from: "/courses", to: "/course/[slug]", via: "Link on /courses" },
//     { from: "/course/[slug]", to: "/course/[slug]/book", via: "Link on /course/[slug]" }]
```

### Browser-run navigation rules

1. **Same-page link:** If the target route has a link/button on the current page, click it
2. **Different page:** Start from the Sidebar, follow the `navPath` steps
3. **Multiple options:** If `routesForApi()` returns multiple routes, choose the one
   closest to the current page (fewest nav steps) or ask the user
