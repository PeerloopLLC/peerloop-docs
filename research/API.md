# PeerLoop - API Quick Reference

**Version:** v3
**Last Updated:** 2025-12-26

> Quick lookup of all API endpoints organized by HTTP method. For detailed documentation:
> - **Internal/DB endpoints:** [DB-API.md](DB-API.md)
> - **External service endpoints:** [REMOTE-API.md](REMOTE-API.md)

---

## GET Endpoints

| Endpoint | Purpose | Doc |
|----------|---------|-----|
| `GET /api/activity` | User's recent activity | DB |
| `GET /api/admin/analytics` | Platform analytics | DB |
| `GET /api/admin/categories` | List categories | DB |
| `GET /api/admin/certificates` | List certificates | DB |
| `GET /api/admin/certificates/pending` | Pending certificates | DB |
| `GET /api/admin/certificates/:id` | Certificate detail | DB |
| `GET /api/admin/certificates/:id/pdf` | Download certificate PDF | DB |
| `GET /api/admin/courses` | List all courses | DB |
| `GET /api/admin/courses/:id` | Course detail | DB |
| `GET /api/admin/dashboard` | Admin dashboard metrics | DB |
| `GET /api/admin/enrollments` | List enrollments | DB |
| `GET /api/admin/enrollments/:id` | Enrollment detail | DB |
| `GET /api/admin/enrollments/export` | Export enrollments CSV | DB |
| `GET /api/admin/flags/count` | Flagged content count | DB |
| `GET /api/admin/payouts` | All payouts | DB |
| `GET /api/admin/payouts/pending` | Pending payouts | DB |
| `GET /api/admin/payouts/:id` | Payout detail | DB |
| `GET /api/admin/sessions` | List sessions | DB |
| `GET /api/admin/sessions/:id` | Session detail | DB |
| `GET /api/admin/sessions/:id/recording` | Get recording URL | DB |
| `GET /api/admin/sessions/stats` | Session statistics | DB |
| `GET /api/admin/sessions/upcoming` | Upcoming sessions | DB |
| `GET /api/admin/users` | List all users | DB |
| `GET /api/admin/users/:id` | User detail | DB |
| `GET /api/admin/users/export` | Export users CSV | DB |
| `GET /api/auth/reset-token/:token` | Validate reset token | DB |
| `GET /api/categories` | List all categories | DB |
| `GET /api/certificates` | User's certificates | DB |
| `GET /api/communities/:slug` | Sub-community details | DB |
| `GET /api/communities/:slug/feed` | Sub-community feed | DB |
| `GET /api/conversations` | List conversations | DB |
| `GET /api/conversations/:id` | Conversation with messages | DB |
| `GET /api/courses` | List courses | DB |
| `GET /api/courses/featured` | Featured courses | DB |
| `GET /api/courses/:id` | Course details | DB |
| `GET /api/courses/:id/chat/helpers` | Available helpers in chat | DB |
| `GET /api/courses/:id/chat/messages` | Chat messages | DB |
| `GET /api/courses/:id/chat/room` | Chat room info | DB |
| `GET /api/courses/:id/curriculum` | Course modules | DB |
| `GET /api/courses/:id/helpers/available` | Available helpers count | DB |
| `GET /api/courses/:id/sts` | Student-Teachers for course | DB |
| `GET /api/courses/:slug` | Course by slug | DB |
| `GET /api/creators` | List creators | DB |
| `GET /api/creators/featured` | Featured creators | DB |
| `GET /api/creators/:handle` | Creator profile | DB |
| `GET /api/creators/:handle/courses` | Creator's courses | DB |
| `GET /api/creators/me/analytics` | Analytics summary | DB |
| `GET /api/creators/me/analytics/courses` | Course performance | DB |
| `GET /api/creators/me/analytics/enrollments` | Enrollment trends | DB |
| `GET /api/creators/me/analytics/export` | Export analytics | DB |
| `GET /api/creators/me/analytics/funnel` | Conversion funnel | DB |
| `GET /api/creators/me/analytics/progress` | Progress distribution | DB |
| `GET /api/creators/me/analytics/sessions` | Session metrics | DB |
| `GET /api/creators/me/analytics/st-performance` | ST performance | DB |
| `GET /api/creators/me/courses` | Creator's courses list | DB |
| `GET /api/creators/me/dashboard` | Creator dashboard | DB |
| `GET /api/creators/me/earnings` | Earnings summary | DB |
| `GET /api/creators/me/payouts` | Payout history | DB |
| `GET /api/creators/me/pending-approvals` | Pending approvals | DB |
| `GET /api/creators/me/sessions` | Session history | DB |
| `GET /api/creators/me/sessions/:id` | Session detail | DB |
| `GET /api/creators/me/sessions/stats` | Session statistics | DB |
| `GET /api/creators/me/sessions/upcoming` | Upcoming sessions | DB |
| `GET /api/creators/me/student-teachers` | Creator's STs | DB |
| `GET /api/creators/me/students` | Students list | DB |
| `GET /api/creators/me/students/:id` | Student detail | DB |
| `GET /api/creators/me/students/export` | Export students CSV | DB |
| `GET /api/creators/me/transactions` | Transaction history | DB |
| `GET /api/enrollments` | User's enrollments | DB |
| `GET /api/enrollments/:id/progress` | Enrollment progress | DB |
| `GET /api/enrollments/:id/sessions` | Sessions for enrollment | DB |
| `GET /api/helpers/available` | Available helpers | DB |
| `GET /api/instructors/:id/feed/access` | Check feed access | DB |
| `GET /api/leaderboard` | Get leaderboard | DB |
| `GET /api/leaderboard/me` | User's position | DB |
| `GET /api/moderation/history` | Moderation history | DB |
| `GET /api/moderation/queue` | Moderation queue | DB |
| `GET /api/moderation/queue/:id` | Flag detail | DB |
| `GET /api/moderation/stats` | Moderation stats | DB |
| `GET /api/newsletters` | Creator's newsletters | DB |
| `GET /api/newsletters/subscribers` | Newsletter subscribers | DB |
| `GET /api/newsletters/tiers` | Newsletter tiers | DB |
| `GET /api/notifications` | Get notifications | DB |
| `GET /api/notifications/count` | Unread count | DB |
| `GET /api/payments/connect/status` | Stripe account status | REMOTE |
| `GET /api/sessions/:id` | Session details | DB |
| `GET /api/sessions/:id/recording` | Session recording URL | DB |
| `GET /api/sts/:id/availability` | ST's availability | DB |
| `GET /api/sts/:id/bookings` | ST's existing bookings | DB |
| `GET /api/student-teachers` | List STs | DB |
| `GET /api/student-teachers/me/dashboard` | ST dashboard | DB |
| `GET /api/student-teachers/me/earnings` | ST earnings | DB |
| `GET /api/student-teachers/me/sessions` | ST's sessions | DB |
| `GET /api/student-teachers/me/students` | ST's students | DB |
| `GET /api/users/me` | Current user profile | DB |
| `GET /api/users/me/availability` | User availability | DB |
| `GET /api/users/me/follows/:user_id` | Check if following | DB |
| `GET /api/users/me/goodwill` | Goodwill points | DB |
| `GET /api/users/me/payouts` | Payout history | DB |
| `GET /api/users/me/rewards` | Rewards breakdown | DB |
| `GET /api/users/me/settings` | User settings | DB |
| `GET /api/users/search` | Search users | DB |
| `GET /api/users/:handle` | User public profile | DB |
| `GET /api/users/:handle/availability` | User availability | DB |
| `GET /api/users/:handle/certificates` | User's certificates | DB |
| `GET /api/users/:handle/followers` | User's followers | DB |
| `GET /api/users/:handle/following` | Who user follows | DB |
| `GET /api/users/:handle/reviews` | User reviews | DB |
| `GET /api/users/:handle/st-info` | ST info | DB |
| `GET /api/users/:handle/stats` | User statistics | DB |

---

## POST Endpoints

| Endpoint | Purpose | Doc |
|----------|---------|-----|
| `POST /api/admin/categories` | Create category | DB |
| `POST /api/admin/categories/:id/merge` | Merge categories | DB |
| `POST /api/admin/categories/reorder` | Reorder categories | DB |
| `POST /api/admin/certificates` | Issue certificate | DB |
| `POST /api/admin/certificates/:id/approve` | Approve certificate | DB |
| `POST /api/admin/certificates/:id/reinstate` | Reinstate certificate | DB |
| `POST /api/admin/certificates/:id/reject` | Reject certificate | DB |
| `POST /api/admin/certificates/:id/revoke` | Revoke certificate | DB |
| `POST /api/admin/courses/:id/feature` | Feature course | DB |
| `POST /api/admin/courses/:id/suspend` | Suspend course | DB |
| `POST /api/admin/courses/:id/transfer` | Transfer ownership | DB |
| `POST /api/admin/courses/:id/unsuspend` | Unsuspend course | DB |
| `POST /api/admin/enrollments` | Create enrollment | DB |
| `POST /api/admin/enrollments/:id/cancel` | Cancel enrollment | DB |
| `POST /api/admin/enrollments/:id/force-complete` | Force complete | DB |
| `POST /api/admin/enrollments/:id/reassign-st` | Reassign ST | DB |
| `POST /api/admin/enrollments/:id/refund` | Process refund | DB |
| `POST /api/admin/payouts/:id/approve` | Approve payout | DB |
| `POST /api/admin/payouts/:id/process` | Process payout | DB |
| `POST /api/admin/payouts/:id/retry` | Retry payout | DB |
| `POST /api/admin/payouts/batch` | Batch process | DB |
| `POST /api/admin/payouts/batch-approve` | Batch approve | DB |
| `POST /api/admin/sessions/:id/credit` | Credit session | DB |
| `POST /api/admin/sessions/:id/resolve` | Resolve dispute | DB |
| `POST /api/admin/sessions/:id/warn` | Warn user | DB |
| `POST /api/admin/users` | Create user | DB |
| `POST /api/admin/users/:id/reset-password` | Send reset email | DB |
| `POST /api/admin/users/:id/suspend` | Suspend user | DB |
| `POST /api/admin/users/:id/unsuspend` | Unsuspend user | DB |
| `POST /api/admin/users/:id/verify-email` | Verify email | DB |
| `POST /api/auth/forgot-password` | Request reset | DB |
| `POST /api/auth/login` | Authenticate | DB |
| `POST /api/auth/resend-verification` | Resend verification | REMOTE |
| `POST /api/auth/reset-password` | Set new password | DB |
| `POST /api/auth/signup` | Create account | DB |
| `POST /api/auth/verify-email` | Verify email | DB |
| `POST /api/certificates/:id/issue` | Issue certificate | DB |
| `POST /api/certificates/recommend` | Recommend for cert | DB |
| `POST /api/checkout/session` | Create checkout | REMOTE |
| `POST /api/communities/:slug/invite` | Invite to community | DB |
| `POST /api/communities/:slug/join` | Join community | DB |
| `POST /api/communities/:slug/posts` | Post to community | DB |
| `POST /api/conversations` | Start conversation | DB |
| `POST /api/conversations/:id/messages` | Send message | DB |
| `POST /api/courses` | Create course | DB |
| `POST /api/courses/:id/chat/messages` | Send chat message | DB |
| `POST /api/courses/:id/curriculum` | Add module | DB |
| `POST /api/courses/:id/thumbnail` | Upload thumbnail | DB |
| `POST /api/enrollments/:id/flag` | Flag student | DB |
| `POST /api/enrollments/:id/progress` | Update progress | DB |
| `POST /api/follows` | Follow user | DB |
| `POST /api/goodwill/award` | Award points | DB |
| `POST /api/help/:id/complete` | Complete help | DB |
| `POST /api/help/request` | Request help | DB |
| `POST /api/moderation/queue/:id/ban` | Ban user | DB |
| `POST /api/moderation/queue/:id/dismiss` | Dismiss flag | DB |
| `POST /api/moderation/queue/:id/remove` | Remove content | DB |
| `POST /api/moderation/queue/:id/warn` | Warn user | DB |
| `POST /api/newsletters` | Create newsletter | DB |
| `POST /api/newsletters/:id/send` | Send newsletter | REMOTE |
| `POST /api/payments/connect/dashboard` | Get dashboard link | REMOTE |
| `POST /api/payments/connect/onboard` | Start onboarding | REMOTE |
| `POST /api/payouts/request` | Request payout | REMOTE |
| `POST /api/posts` | Create post | REMOTE |
| `POST /api/posts/:id/flag` | Flag post | REMOTE |
| `POST /api/posts/:id/promote` | Promote post | REMOTE |
| `POST /api/sessions` | Book session | DB |
| `POST /api/sessions/:id/accept` | Accept session | DB |
| `POST /api/sessions/:id/feedback` | Submit feedback | DB |
| `POST /api/stream/token` | Get Stream token | REMOTE |
| `POST /api/student-teachers/:id/approve` | Approve ST | DB |
| `POST /api/users/me/avatar` | Upload avatar | DB |
| `POST /api/video/token` | Get video token | REMOTE |
| `POST /api/webhooks/plugnmeet` | PlugNmeet webhook | REMOTE |
| `POST /api/webhooks/resend` | Resend webhook | REMOTE |
| `POST /api/webhooks/stripe` | Stripe webhook | REMOTE |

---

## PUT Endpoints

| Endpoint | Purpose | Doc |
|----------|---------|-----|
| `PUT /api/communities/:slug` | Update community | DB |
| `PUT /api/conversations/:id/read` | Mark as read | DB |
| `PUT /api/courses/:id` | Update course | DB |
| `PUT /api/courses/:id/curriculum/:module_id` | Update module | DB |
| `PUT /api/courses/:id/curriculum/reorder` | Reorder modules | DB |
| `PUT /api/courses/:id/publish` | Publish course | DB |
| `PUT /api/courses/:id/unpublish` | Unpublish course | DB |
| `PUT /api/enrollments/:id/notes` | Update notes | DB |
| `PUT /api/newsletters/:id` | Update newsletter | DB |
| `PUT /api/notifications/:id/read` | Mark as read | DB |
| `PUT /api/notifications/read-all` | Mark all read | DB |
| `PUT /api/users/me` | Update profile | DB |
| `PUT /api/users/me/availability` | Update availability | DB |

---

## PATCH Endpoints

| Endpoint | Purpose | Doc |
|----------|---------|-----|
| `PATCH /api/admin/categories/:id` | Update category | DB |
| `PATCH /api/admin/courses/:id` | Update course | DB |
| `PATCH /api/admin/enrollments/:id` | Update enrollment | DB |
| `PATCH /api/admin/sessions/:id` | Update session | DB |
| `PATCH /api/admin/users/:id` | Update user | DB |
| `PATCH /api/users/me/settings` | Update settings | DB |

---

## DELETE Endpoints

| Endpoint | Purpose | Doc |
|----------|---------|-----|
| `DELETE /api/admin/categories/:id` | Delete category | DB |
| `DELETE /api/admin/courses/:id` | Delete course | DB |
| `DELETE /api/admin/courses/:id/feature` | Unfeature course | DB |
| `DELETE /api/admin/enrollments/:id` | Delete enrollment | DB |
| `DELETE /api/admin/payouts/:id` | Cancel payout | DB |
| `DELETE /api/admin/users/:id` | Delete user | DB |
| `DELETE /api/communities/:slug/leave` | Leave community | DB |
| `DELETE /api/courses/:id` | Delete course | DB |
| `DELETE /api/courses/:id/curriculum/:module_id` | Delete module | DB |
| `DELETE /api/follows/:id` | Unfollow user | DB |
| `DELETE /api/newsletters/:id` | Delete newsletter | DB |
| `DELETE /api/notifications/:id` | Delete notification | DB |

---

## Summary

| Method | Count |
|--------|-------|
| GET | 108 |
| POST | 73 |
| PUT | 13 |
| PATCH | 6 |
| DELETE | 12 |
| **Total** | **212** |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v1 | 2025-12-23 | Initial API surface |
| v2 | 2025-12-26 | Added service provider contracts |
| v3 | 2025-12-26 | Converted to quick reference index; detailed docs split to DB-API.md + REMOTE-API.md |
