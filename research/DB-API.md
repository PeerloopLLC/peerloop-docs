# PeerLoop - Database API (Internal Endpoints)

**Version:** v2
**Last Updated:** 2025-12-26
**Primary Source:** Page documentation, API.md v2

> This document defines all internal API endpoints that interact with the database. For external service integrations (Stripe, Stream, PlugNmeet, Resend), see [REMOTE-API.md](REMOTE-API.md).

---

## Overview

All endpoints follow REST conventions:
- `GET` - Read data
- `POST` - Create new records
- `PUT` - Full update
- `PATCH` - Partial update
- `DELETE` - Remove records

**DB-SCHEMA Reference:** Each endpoint links to relevant tables in [DB-SCHEMA.md](DB-SCHEMA.md).

---

## Authentication

### POST /api/auth/signup

| Field | Value |
|-------|-------|
| **Purpose** | Create new user account |
| **Auth** | Public |
| **Tables** | `users` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/auth/login

| Field | Value |
|-------|-------|
| **Purpose** | Authenticate user |
| **Auth** | Public |
| **Tables** | `users` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/auth/forgot-password

| Field | Value |
|-------|-------|
| **Purpose** | Request password reset |
| **Auth** | Public |
| **Tables** | `users`, `password_reset_tokens` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |
| **External** | Sends email via Resend |

---

### GET /api/auth/reset-token/:token

| Field | Value |
|-------|-------|
| **Purpose** | Validate reset token |
| **Auth** | Public |
| **Tables** | `password_reset_tokens` |

---

### POST /api/auth/reset-password

| Field | Value |
|-------|-------|
| **Purpose** | Set new password |
| **Auth** | Public (with valid token) |
| **Tables** | `users`, `password_reset_tokens` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/auth/verify-email

| Field | Value |
|-------|-------|
| **Purpose** | Verify email address |
| **Auth** | Public (with valid token) |
| **Tables** | `users`, `email_verification_tokens` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

## Users

### GET /api/users/me

| Field | Value |
|-------|-------|
| **Purpose** | Get current user profile |
| **Auth** | Authenticated |
| **Tables** | `users`, `user_stats` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [user_stats](DB-SCHEMA.md#user_stats) |

---

### PUT /api/users/me

| Field | Value |
|-------|-------|
| **Purpose** | Update current user profile |
| **Auth** | Authenticated |
| **Tables** | `users`, `user_qualifications`, `user_expertise` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [user_qualifications](DB-SCHEMA.md#user_qualifications) |

---

### POST /api/users/me/avatar

| Field | Value |
|-------|-------|
| **Purpose** | Upload avatar image |
| **Auth** | Authenticated |
| **Tables** | `users.avatar_url` |
| **Storage** | Cloudflare R2 |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/users/:handle

| Field | Value |
|-------|-------|
| **Purpose** | Get user public profile |
| **Auth** | Public (respects privacy_public) |
| **Tables** | `users`, `user_qualifications`, `user_expertise`, `user_stats` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [user_stats](DB-SCHEMA.md#user_stats) |

---

### GET /api/users/:handle/stats

| Field | Value |
|-------|-------|
| **Purpose** | Get user statistics |
| **Auth** | Public |
| **Tables** | `user_stats`, `enrollments`, `sessions`, `certificates` |
| **DB-SCHEMA** | [user_stats](DB-SCHEMA.md#user_stats) |

---

### GET /api/users/:handle/certificates

| Field | Value |
|-------|-------|
| **Purpose** | Get user's certificates |
| **Auth** | Public |
| **Tables** | `certificates`, `courses` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### GET /api/users/:handle/followers

| Field | Value |
|-------|-------|
| **Purpose** | Get user's followers |
| **Auth** | Public |
| **Tables** | `follows`, `users` |
| **DB-SCHEMA** | [follows](DB-SCHEMA.md#follows) |

---

### GET /api/users/:handle/following

| Field | Value |
|-------|-------|
| **Purpose** | Get who user follows |
| **Auth** | Public |
| **Tables** | `follows`, `users` |
| **DB-SCHEMA** | [follows](DB-SCHEMA.md#follows) |

---

### GET /api/users/me/follows/:user_id

| Field | Value |
|-------|-------|
| **Purpose** | Check if current user follows target |
| **Auth** | Authenticated |
| **Tables** | `follows` |
| **DB-SCHEMA** | [follows](DB-SCHEMA.md#follows) |

---

### POST /api/follows

| Field | Value |
|-------|-------|
| **Purpose** | Follow a user |
| **Auth** | Authenticated |
| **Tables** | `follows` |
| **DB-SCHEMA** | [follows](DB-SCHEMA.md#follows) |

---

### DELETE /api/follows/:id

| Field | Value |
|-------|-------|
| **Purpose** | Unfollow a user |
| **Auth** | Authenticated |
| **Tables** | `follows` |
| **DB-SCHEMA** | [follows](DB-SCHEMA.md#follows) |

---

### GET /api/users/search

| Field | Value |
|-------|-------|
| **Purpose** | Search users by name/handle |
| **Auth** | Authenticated |
| **Tables** | `users` |
| **Query** | `q` - search term |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/users/me/settings

| Field | Value |
|-------|-------|
| **Purpose** | Get user settings |
| **Auth** | Authenticated |
| **Tables** | `users`, `notification_preferences` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### PATCH /api/users/me/settings

| Field | Value |
|-------|-------|
| **Purpose** | Update user settings |
| **Auth** | Authenticated |
| **Tables** | `users`, `notification_preferences` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/users/me/availability

| Field | Value |
|-------|-------|
| **Purpose** | Get user availability slots |
| **Auth** | Authenticated |
| **Tables** | `availability` |
| **DB-SCHEMA** | [availability](DB-SCHEMA.md#availability) |

---

### PUT /api/users/me/availability

| Field | Value |
|-------|-------|
| **Purpose** | Update availability slots |
| **Auth** | Authenticated (ST/Creator) |
| **Tables** | `availability` |
| **DB-SCHEMA** | [availability](DB-SCHEMA.md#availability) |

---

### GET /api/users/me/goodwill

| Field | Value |
|-------|-------|
| **Purpose** | Get goodwill points balance |
| **Auth** | Authenticated |
| **Tables** | `users.goodwill_points`, `goodwill_transactions` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [goodwill_transactions](DB-SCHEMA.md#goodwill_transactions) |

---

### GET /api/users/me/rewards

| Field | Value |
|-------|-------|
| **Purpose** | Get rewards/points breakdown |
| **Auth** | Authenticated |
| **Tables** | `goodwill_transactions` |
| **DB-SCHEMA** | [goodwill_transactions](DB-SCHEMA.md#goodwill_transactions) |

---

### POST /api/goodwill/award

| Field | Value |
|-------|-------|
| **Purpose** | Award goodwill points (system) |
| **Auth** | System/Admin |
| **Tables** | `users.goodwill_points`, `goodwill_transactions` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [goodwill_transactions](DB-SCHEMA.md#goodwill_transactions) |

---

## Courses

### GET /api/courses

| Field | Value |
|-------|-------|
| **Purpose** | List courses with filtering |
| **Auth** | Public |
| **Tables** | `courses`, `users` (creators), `categories` |
| **Query** | `q`, `level`, `category`, `page`, `limit` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses), [categories](DB-SCHEMA.md#categories) |

---

### GET /api/courses/featured

| Field | Value |
|-------|-------|
| **Purpose** | Get featured courses |
| **Auth** | Public |
| **Tables** | `courses` (where is_featured = true) |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### GET /api/courses/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get course details |
| **Auth** | Public |
| **Tables** | `courses`, `course_objectives`, `course_includes`, `course_prerequisites`, `course_target_audience`, `users` (creator), `course_tags` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses), [course_objectives](DB-SCHEMA.md#course_objectives) |

---

### GET /api/courses/:slug

| Field | Value |
|-------|-------|
| **Purpose** | Get course by slug |
| **Auth** | Public |
| **Tables** | Same as GET /api/courses/:id |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### GET /api/courses/:id/curriculum

| Field | Value |
|-------|-------|
| **Purpose** | Get course modules |
| **Auth** | Public (titles only) or Enrolled (full) |
| **Tables** | `course_modules` |
| **DB-SCHEMA** | [course_modules](DB-SCHEMA.md#course_modules) |

---

### GET /api/courses/:id/sts

| Field | Value |
|-------|-------|
| **Purpose** | Get Student-Teachers for course |
| **Auth** | Public |
| **Tables** | `student_teachers`, `users` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers) |

---

### POST /api/courses

| Field | Value |
|-------|-------|
| **Purpose** | Create new course |
| **Auth** | Authenticated (Creator) |
| **Tables** | `courses`, `course_objectives`, `course_includes`, etc. |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### PUT /api/courses/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update course |
| **Auth** | Authenticated (course owner) |
| **Tables** | `courses`, related tables |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### DELETE /api/courses/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete course |
| **Auth** | Authenticated (course owner) |
| **Tables** | `courses` (soft delete if enrollments exist) |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### PUT /api/courses/:id/publish

| Field | Value |
|-------|-------|
| **Purpose** | Publish course |
| **Auth** | Authenticated (course owner) |
| **Tables** | `courses.status` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### PUT /api/courses/:id/unpublish

| Field | Value |
|-------|-------|
| **Purpose** | Unpublish course |
| **Auth** | Authenticated (course owner) |
| **Tables** | `courses.status` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### POST /api/courses/:id/thumbnail

| Field | Value |
|-------|-------|
| **Purpose** | Upload course thumbnail |
| **Auth** | Authenticated (course owner) |
| **Tables** | `courses.thumbnail_url` |
| **Storage** | Cloudflare R2 |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### POST /api/courses/:id/curriculum

| Field | Value |
|-------|-------|
| **Purpose** | Add module to course |
| **Auth** | Authenticated (course owner) |
| **Tables** | `course_modules` |
| **DB-SCHEMA** | [course_modules](DB-SCHEMA.md#course_modules) |

---

### PUT /api/courses/:id/curriculum/:module_id

| Field | Value |
|-------|-------|
| **Purpose** | Update module |
| **Auth** | Authenticated (course owner) |
| **Tables** | `course_modules` |
| **DB-SCHEMA** | [course_modules](DB-SCHEMA.md#course_modules) |

---

### PUT /api/courses/:id/curriculum/reorder

| Field | Value |
|-------|-------|
| **Purpose** | Reorder modules |
| **Auth** | Authenticated (course owner) |
| **Tables** | `course_modules.module_order` |
| **DB-SCHEMA** | [course_modules](DB-SCHEMA.md#course_modules) |

---

### DELETE /api/courses/:id/curriculum/:module_id

| Field | Value |
|-------|-------|
| **Purpose** | Delete module |
| **Auth** | Authenticated (course owner) |
| **Tables** | `course_modules` |
| **DB-SCHEMA** | [course_modules](DB-SCHEMA.md#course_modules) |

---

## Categories

### GET /api/categories

| Field | Value |
|-------|-------|
| **Purpose** | List all categories |
| **Auth** | Public |
| **Tables** | `categories` |
| **DB-SCHEMA** | [categories](DB-SCHEMA.md#categories) |

---

## Enrollments

### GET /api/enrollments

| Field | Value |
|-------|-------|
| **Purpose** | Get current user's enrollments |
| **Auth** | Authenticated |
| **Tables** | `enrollments`, `courses`, `student_teachers`, `users` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/enrollments/:id/progress

| Field | Value |
|-------|-------|
| **Purpose** | Get enrollment progress |
| **Auth** | Authenticated (enrolled student) |
| **Tables** | `module_progress`, `course_modules` |
| **DB-SCHEMA** | [module_progress](DB-SCHEMA.md#module_progress), [course_modules](DB-SCHEMA.md#course_modules) |

---

### POST /api/enrollments/:id/progress

| Field | Value |
|-------|-------|
| **Purpose** | Update module progress |
| **Auth** | Authenticated (enrolled student) |
| **Tables** | `module_progress` |
| **DB-SCHEMA** | [module_progress](DB-SCHEMA.md#module_progress) |

---

### GET /api/enrollments/:id/sessions

| Field | Value |
|-------|-------|
| **Purpose** | Get sessions for enrollment |
| **Auth** | Authenticated |
| **Tables** | `sessions`, `users` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### PUT /api/enrollments/:id/notes

| Field | Value |
|-------|-------|
| **Purpose** | Update creator notes on enrollment |
| **Auth** | Authenticated (creator) |
| **Tables** | `enrollments.creator_notes` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### POST /api/enrollments/:id/flag

| Field | Value |
|-------|-------|
| **Purpose** | Flag student as at-risk |
| **Auth** | Authenticated (creator) |
| **Tables** | `enrollments.is_at_risk` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

## Sessions

### GET /api/sessions/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get session details |
| **Auth** | Authenticated (participant) |
| **Tables** | `sessions`, `users`, `courses` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### POST /api/sessions

| Field | Value |
|-------|-------|
| **Purpose** | Book a session |
| **Auth** | Authenticated (enrolled student) |
| **Tables** | `sessions`, `availability` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions), [availability](DB-SCHEMA.md#availability) |
| **External** | Creates PlugNmeet room, sends confirmation email |

---

### POST /api/sessions/:id/feedback

| Field | Value |
|-------|-------|
| **Purpose** | Submit session feedback |
| **Auth** | Authenticated (participant) |
| **Tables** | `session_assessments` |
| **DB-SCHEMA** | [session_assessments](DB-SCHEMA.md#session_assessments) |

---

### POST /api/sessions/:id/accept

| Field | Value |
|-------|-------|
| **Purpose** | Accept intro session request |
| **Auth** | Authenticated (ST) |
| **Tables** | `sessions.status` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/sessions/:id/recording

| Field | Value |
|-------|-------|
| **Purpose** | Get session recording URL |
| **Auth** | Authenticated (participant or creator) |
| **Tables** | `sessions.recording_url` |
| **Storage** | Cloudflare R2 (signed URL) |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/sts/:id/availability

| Field | Value |
|-------|-------|
| **Purpose** | Get ST's availability slots |
| **Auth** | Authenticated |
| **Tables** | `availability` |
| **DB-SCHEMA** | [availability](DB-SCHEMA.md#availability) |

---

### GET /api/sts/:id/bookings

| Field | Value |
|-------|-------|
| **Purpose** | Get ST's existing bookings |
| **Auth** | Authenticated |
| **Tables** | `sessions` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

## Student-Teachers

### GET /api/student-teachers

| Field | Value |
|-------|-------|
| **Purpose** | List Student-Teachers |
| **Auth** | Public |
| **Tables** | `student_teachers`, `users`, `courses` |
| **Query** | `course`, `available` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers) |

---

### GET /api/student-teachers/me/dashboard

| Field | Value |
|-------|-------|
| **Purpose** | ST dashboard data |
| **Auth** | Authenticated (ST) |
| **Tables** | `sessions`, `payment_splits`, `enrollments`, `users` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions), [payment_splits](DB-SCHEMA.md#payment_splits) |

---

### GET /api/student-teachers/me/sessions

| Field | Value |
|-------|-------|
| **Purpose** | ST's teaching sessions |
| **Auth** | Authenticated (ST) |
| **Tables** | `sessions`, `users`, `courses` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/student-teachers/me/students

| Field | Value |
|-------|-------|
| **Purpose** | ST's assigned students |
| **Auth** | Authenticated (ST) |
| **Tables** | `enrollments`, `users`, `module_progress` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/student-teachers/me/earnings

| Field | Value |
|-------|-------|
| **Purpose** | ST's earnings |
| **Auth** | Authenticated (ST) |
| **Tables** | `payment_splits`, `payouts` |
| **DB-SCHEMA** | [payment_splits](DB-SCHEMA.md#payment_splits), [payouts](DB-SCHEMA.md#payouts) |

---

### POST /api/student-teachers/:id/approve

| Field | Value |
|-------|-------|
| **Purpose** | Approve ST application |
| **Auth** | Authenticated (creator) |
| **Tables** | `student_teachers`, `certificates` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers), [certificates](DB-SCHEMA.md#certificates) |

---

## Creators

### GET /api/creators

| Field | Value |
|-------|-------|
| **Purpose** | List creators |
| **Auth** | Public |
| **Tables** | `users` (where is_creator = true), `user_stats` |
| **Query** | `q`, `expertise` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [user_stats](DB-SCHEMA.md#user_stats) |

---

### GET /api/creators/featured

| Field | Value |
|-------|-------|
| **Purpose** | Get featured creators |
| **Auth** | Public |
| **Tables** | `users`, `user_stats` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/creators/:handle

| Field | Value |
|-------|-------|
| **Purpose** | Get creator profile |
| **Auth** | Public |
| **Tables** | `users`, `user_qualifications`, `user_stats`, `courses` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/creators/:handle/courses

| Field | Value |
|-------|-------|
| **Purpose** | Get creator's courses |
| **Auth** | Public |
| **Tables** | `courses` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### GET /api/creators/me/dashboard

| Field | Value |
|-------|-------|
| **Purpose** | Creator dashboard data |
| **Auth** | Authenticated (creator) |
| **Tables** | `courses`, `enrollments`, `payment_splits`, `sessions` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses), [enrollments](DB-SCHEMA.md#enrollments), [payment_splits](DB-SCHEMA.md#payment_splits) |

---

### GET /api/creators/me/courses

| Field | Value |
|-------|-------|
| **Purpose** | Creator's courses list |
| **Auth** | Authenticated (creator) |
| **Tables** | `courses` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### GET /api/creators/me/students

| Field | Value |
|-------|-------|
| **Purpose** | Creator's students list |
| **Auth** | Authenticated (creator) |
| **Tables** | `enrollments`, `users`, `module_progress`, `sessions` |
| **Query** | `q`, `course_id`, `status`, `sort`, `page`, `limit` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/creators/me/students/:id

| Field | Value |
|-------|-------|
| **Purpose** | Student detail |
| **Auth** | Authenticated (creator) |
| **Tables** | `enrollments`, `users`, `module_progress`, `sessions`, `certificates` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/creators/me/students/export

| Field | Value |
|-------|-------|
| **Purpose** | Export students to CSV |
| **Auth** | Authenticated (creator) |
| **Tables** | `enrollments`, `users` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/creators/me/sessions

| Field | Value |
|-------|-------|
| **Purpose** | Creator's session history |
| **Auth** | Authenticated (creator) |
| **Tables** | `sessions`, `users`, `courses` |
| **Query** | `course_id`, `st_id`, `status`, `from`, `to`, `page`, `limit` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/creators/me/sessions/:id

| Field | Value |
|-------|-------|
| **Purpose** | Session detail |
| **Auth** | Authenticated (creator) |
| **Tables** | `sessions`, `session_assessments`, `users` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions), [session_assessments](DB-SCHEMA.md#session_assessments) |

---

### GET /api/creators/me/sessions/stats

| Field | Value |
|-------|-------|
| **Purpose** | Session statistics |
| **Auth** | Authenticated (creator) |
| **Tables** | `sessions`, `session_assessments` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/creators/me/student-teachers

| Field | Value |
|-------|-------|
| **Purpose** | Creator's STs |
| **Auth** | Authenticated (creator) |
| **Tables** | `student_teachers`, `users` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers) |

---

### GET /api/creators/me/earnings

| Field | Value |
|-------|-------|
| **Purpose** | Creator earnings summary |
| **Auth** | Authenticated (creator) |
| **Tables** | `payment_splits`, `transactions`, `payouts` |
| **DB-SCHEMA** | [payment_splits](DB-SCHEMA.md#payment_splits), [payouts](DB-SCHEMA.md#payouts) |

---

### GET /api/creators/me/transactions

| Field | Value |
|-------|-------|
| **Purpose** | Transaction history |
| **Auth** | Authenticated (creator) |
| **Tables** | `transactions`, `enrollments`, `payment_splits` |
| **DB-SCHEMA** | [transactions](DB-SCHEMA.md#transactions) |

---

### GET /api/creators/me/payouts

| Field | Value |
|-------|-------|
| **Purpose** | Payout history |
| **Auth** | Authenticated (creator) |
| **Tables** | `payouts` |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### GET /api/creators/me/pending-approvals

| Field | Value |
|-------|-------|
| **Purpose** | Pending ST applications, certificates |
| **Auth** | Authenticated (creator) |
| **Tables** | `certificates`, `student_teachers` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates), [student_teachers](DB-SCHEMA.md#student_teachers) |

---

### GET /api/creators/me/analytics

| Field | Value |
|-------|-------|
| **Purpose** | Analytics summary |
| **Auth** | Authenticated (creator) |
| **Tables** | `enrollments`, `transactions`, `sessions`, `payment_splits` |
| **Query** | `period`, `from`, `to`, `course_id` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments), [transactions](DB-SCHEMA.md#transactions) |

---

### GET /api/creators/me/analytics/enrollments

| Field | Value |
|-------|-------|
| **Purpose** | Enrollment trends |
| **Auth** | Authenticated (creator) |
| **Tables** | `enrollments`, `transactions` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/creators/me/analytics/courses

| Field | Value |
|-------|-------|
| **Purpose** | Course performance |
| **Auth** | Authenticated (creator) |
| **Tables** | `courses`, `enrollments`, `transactions` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses), [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/creators/me/analytics/funnel

| Field | Value |
|-------|-------|
| **Purpose** | Conversion funnel |
| **Auth** | Authenticated (creator) |
| **Tables** | `course_views`, `enrollments`, `module_progress`, `student_teachers` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/creators/me/analytics/progress

| Field | Value |
|-------|-------|
| **Purpose** | Student progress distribution |
| **Auth** | Authenticated (creator) |
| **Tables** | `module_progress`, `enrollments` |
| **DB-SCHEMA** | [module_progress](DB-SCHEMA.md#module_progress) |

---

### GET /api/creators/me/analytics/sessions

| Field | Value |
|-------|-------|
| **Purpose** | Session metrics |
| **Auth** | Authenticated (creator) |
| **Tables** | `sessions`, `session_assessments` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/creators/me/analytics/st-performance

| Field | Value |
|-------|-------|
| **Purpose** | ST performance table |
| **Auth** | Authenticated (creator) |
| **Tables** | `student_teachers`, `sessions`, `session_assessments` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers), [session_assessments](DB-SCHEMA.md#session_assessments) |

---

### GET /api/creators/me/analytics/export

| Field | Value |
|-------|-------|
| **Purpose** | Export analytics CSV/PDF |
| **Auth** | Authenticated (creator) |
| **Tables** | Multiple |

---

## Certificates

### GET /api/certificates

| Field | Value |
|-------|-------|
| **Purpose** | Get user's certificates |
| **Auth** | Authenticated |
| **Tables** | `certificates`, `courses` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/certificates/recommend

| Field | Value |
|-------|-------|
| **Purpose** | Recommend student for certificate |
| **Auth** | Authenticated (ST) |
| **Tables** | `certificates` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/certificates/:id/issue

| Field | Value |
|-------|-------|
| **Purpose** | Issue certificate |
| **Auth** | Authenticated (creator) |
| **Tables** | `certificates`, `student_teachers` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

## Conversations & Messages

### GET /api/conversations

| Field | Value |
|-------|-------|
| **Purpose** | List conversations |
| **Auth** | Authenticated |
| **Tables** | `conversations`, `conversation_participants`, `messages` |
| **DB-SCHEMA** | [conversations](DB-SCHEMA.md#conversations), [messages](DB-SCHEMA.md#messages) |

---

### GET /api/conversations/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get conversation with messages |
| **Auth** | Authenticated (participant) |
| **Tables** | `conversations`, `messages`, `users` |
| **DB-SCHEMA** | [conversations](DB-SCHEMA.md#conversations), [messages](DB-SCHEMA.md#messages) |

---

### POST /api/conversations

| Field | Value |
|-------|-------|
| **Purpose** | Start new conversation |
| **Auth** | Authenticated |
| **Tables** | `conversations`, `conversation_participants`, `messages` |
| **DB-SCHEMA** | [conversations](DB-SCHEMA.md#conversations) |

---

### POST /api/conversations/:id/messages

| Field | Value |
|-------|-------|
| **Purpose** | Send message |
| **Auth** | Authenticated (participant) |
| **Tables** | `messages` |
| **DB-SCHEMA** | [messages](DB-SCHEMA.md#messages) |

---

### PUT /api/conversations/:id/read

| Field | Value |
|-------|-------|
| **Purpose** | Mark conversation as read |
| **Auth** | Authenticated (participant) |
| **Tables** | `conversation_participants.last_read_at` |
| **DB-SCHEMA** | [conversations](DB-SCHEMA.md#conversations) |

---

## Notifications

### GET /api/notifications

| Field | Value |
|-------|-------|
| **Purpose** | Get notifications |
| **Auth** | Authenticated |
| **Tables** | `notifications` |
| **Query** | `unread`, `type`, `page`, `limit` |
| **DB-SCHEMA** | [notifications](DB-SCHEMA.md#notifications) |

---

### GET /api/notifications/count

| Field | Value |
|-------|-------|
| **Purpose** | Get unread count |
| **Auth** | Authenticated |
| **Tables** | `notifications` |
| **DB-SCHEMA** | [notifications](DB-SCHEMA.md#notifications) |

---

### PUT /api/notifications/:id/read

| Field | Value |
|-------|-------|
| **Purpose** | Mark notification as read |
| **Auth** | Authenticated |
| **Tables** | `notifications.is_read` |
| **DB-SCHEMA** | [notifications](DB-SCHEMA.md#notifications) |

---

### PUT /api/notifications/read-all

| Field | Value |
|-------|-------|
| **Purpose** | Mark all as read |
| **Auth** | Authenticated |
| **Tables** | `notifications` |
| **DB-SCHEMA** | [notifications](DB-SCHEMA.md#notifications) |

---

### DELETE /api/notifications/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete notification |
| **Auth** | Authenticated |
| **Tables** | `notifications` |
| **DB-SCHEMA** | [notifications](DB-SCHEMA.md#notifications) |

---

## Activity

### GET /api/activity

| Field | Value |
|-------|-------|
| **Purpose** | Get user's recent activity |
| **Auth** | Authenticated |
| **Tables** | `activity_log` or derived from multiple tables |
| **Query** | `limit` |

---

## Homework

### GET /api/courses/:id/homework

| Field | Value |
|-------|-------|
| **Purpose** | List homework assignments for course |
| **Auth** | Authenticated (enrolled or creator/ST) |
| **Tables** | `homework_assignments`, `course_curriculum` |
| **DB-SCHEMA** | [homework_assignments](DB-SCHEMA.md#homework_assignments) |

---

### GET /api/homework/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get homework assignment detail |
| **Auth** | Authenticated (enrolled or creator/ST) |
| **Tables** | `homework_assignments`, `homework_submissions` |
| **DB-SCHEMA** | [homework_assignments](DB-SCHEMA.md#homework_assignments) |

---

### POST /api/courses/:id/homework

| Field | Value |
|-------|-------|
| **Purpose** | Create homework assignment |
| **Auth** | Authenticated (creator or ST for course) |
| **Tables** | `homework_assignments` |
| **DB-SCHEMA** | [homework_assignments](DB-SCHEMA.md#homework_assignments) |

---

### PUT /api/homework/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update homework assignment |
| **Auth** | Authenticated (assignment creator) |
| **Tables** | `homework_assignments` |
| **DB-SCHEMA** | [homework_assignments](DB-SCHEMA.md#homework_assignments) |

---

### DELETE /api/homework/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete homework assignment |
| **Auth** | Authenticated (assignment creator or course owner) |
| **Tables** | `homework_assignments`, `homework_submissions` |
| **DB-SCHEMA** | [homework_assignments](DB-SCHEMA.md#homework_assignments) |

---

### GET /api/homework/:id/submissions

| Field | Value |
|-------|-------|
| **Purpose** | List submissions for assignment |
| **Auth** | Authenticated (creator or ST for course) |
| **Tables** | `homework_submissions`, `users` |
| **Query** | `status`, `page`, `limit` |
| **DB-SCHEMA** | [homework_submissions](DB-SCHEMA.md#homework_submissions) |

---

### GET /api/homework/:id/submissions/me

| Field | Value |
|-------|-------|
| **Purpose** | Get my submission for assignment |
| **Auth** | Authenticated (enrolled student) |
| **Tables** | `homework_submissions` |
| **DB-SCHEMA** | [homework_submissions](DB-SCHEMA.md#homework_submissions) |

---

### POST /api/homework/:id/submit

| Field | Value |
|-------|-------|
| **Purpose** | Submit homework |
| **Auth** | Authenticated (enrolled student) |
| **Tables** | `homework_submissions` |
| **Storage** | Cloudflare R2 (if file attached) |
| **DB-SCHEMA** | [homework_submissions](DB-SCHEMA.md#homework_submissions) |

---

### PUT /api/submissions/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update submission (before reviewed) |
| **Auth** | Authenticated (submission owner) |
| **Tables** | `homework_submissions` |
| **DB-SCHEMA** | [homework_submissions](DB-SCHEMA.md#homework_submissions) |

---

### POST /api/submissions/:id/review

| Field | Value |
|-------|-------|
| **Purpose** | Review submission |
| **Auth** | Authenticated (creator or ST for course) |
| **Tables** | `homework_submissions` |
| **DB-SCHEMA** | [homework_submissions](DB-SCHEMA.md#homework_submissions) |

---

## Session Resources

### GET /api/sessions/:id/resources

| Field | Value |
|-------|-------|
| **Purpose** | Get session resources (recordings, files) |
| **Auth** | Authenticated (session participant or creator) |
| **Tables** | `session_resources` |
| **DB-SCHEMA** | [session_resources](DB-SCHEMA.md#session_resources) |

---

### GET /api/courses/:id/resources

| Field | Value |
|-------|-------|
| **Purpose** | Get course-level resources |
| **Auth** | Authenticated (enrolled or creator/ST) |
| **Tables** | `session_resources` |
| **Query** | `type`, `page`, `limit` |
| **DB-SCHEMA** | [session_resources](DB-SCHEMA.md#session_resources) |

---

### POST /api/sessions/:id/resources

| Field | Value |
|-------|-------|
| **Purpose** | Upload session resource |
| **Auth** | Authenticated (session teacher or creator) |
| **Tables** | `session_resources` |
| **Storage** | Cloudflare R2 |
| **DB-SCHEMA** | [session_resources](DB-SCHEMA.md#session_resources) |

---

### POST /api/courses/:id/resources

| Field | Value |
|-------|-------|
| **Purpose** | Upload course resource |
| **Auth** | Authenticated (creator or ST) |
| **Tables** | `session_resources` |
| **Storage** | Cloudflare R2 |
| **DB-SCHEMA** | [session_resources](DB-SCHEMA.md#session_resources) |

---

### GET /api/resources/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get resource download URL |
| **Auth** | Authenticated (enrolled or creator/ST) |
| **Tables** | `session_resources` |
| **Storage** | Cloudflare R2 (signed URL) |
| **DB-SCHEMA** | [session_resources](DB-SCHEMA.md#session_resources) |

---

### DELETE /api/resources/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete resource |
| **Auth** | Authenticated (resource creator or course owner) |
| **Tables** | `session_resources` |
| **Storage** | Cloudflare R2 |
| **DB-SCHEMA** | [session_resources](DB-SCHEMA.md#session_resources) |

---

## Help Requests (Block 2+)

### POST /api/help/request

| Field | Value |
|-------|-------|
| **Purpose** | Request help (Summon Help) |
| **Auth** | Authenticated |
| **Tables** | `help_requests` |
| **DB-SCHEMA** | [help_requests](DB-SCHEMA.md#help_requests) |

---

### POST /api/help/:id/complete

| Field | Value |
|-------|-------|
| **Purpose** | Complete help request |
| **Auth** | Authenticated (helper) |
| **Tables** | `help_requests`, `users.goodwill_points` |
| **DB-SCHEMA** | [help_requests](DB-SCHEMA.md#help_requests) |

---

### GET /api/helpers/available

| Field | Value |
|-------|-------|
| **Purpose** | Get available helpers for course |
| **Auth** | Authenticated |
| **Tables** | `users`, `student_teachers` |
| **Query** | `course_id` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers) |

---

### GET /api/courses/:id/helpers/available

| Field | Value |
|-------|-------|
| **Purpose** | Get available helpers count |
| **Auth** | Authenticated |
| **Tables** | `users`, `student_teachers` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers) |

---

## Course Chat (Custom WebSocket)

### GET /api/courses/:id/chat/room

| Field | Value |
|-------|-------|
| **Purpose** | Get chat room info |
| **Auth** | Authenticated (enrolled) |
| **Tables** | `chat_rooms` |
| **DB-SCHEMA** | [chat_rooms](DB-SCHEMA.md#chat_rooms) |

---

### GET /api/courses/:id/chat/messages

| Field | Value |
|-------|-------|
| **Purpose** | Get chat messages |
| **Auth** | Authenticated (enrolled) |
| **Tables** | `chat_messages`, `users` |
| **DB-SCHEMA** | [chat_messages](DB-SCHEMA.md#chat_messages) |

---

### POST /api/courses/:id/chat/messages

| Field | Value |
|-------|-------|
| **Purpose** | Send chat message |
| **Auth** | Authenticated (enrolled) |
| **Tables** | `chat_messages` |
| **DB-SCHEMA** | [chat_messages](DB-SCHEMA.md#chat_messages) |

---

### GET /api/courses/:id/chat/helpers

| Field | Value |
|-------|-------|
| **Purpose** | Get available helpers in chat |
| **Auth** | Authenticated (enrolled) |
| **Tables** | `users`, `student_teachers` |
| **DB-SCHEMA** | [student_teachers](DB-SCHEMA.md#student_teachers) |

---

## Leaderboard (Block 2+)

### GET /api/leaderboard

| Field | Value |
|-------|-------|
| **Purpose** | Get leaderboard |
| **Auth** | Authenticated |
| **Tables** | `leaderboard_entries`, `users` |
| **DB-SCHEMA** | [leaderboard_entries](DB-SCHEMA.md#leaderboard_entries) |
| **Cache** | Cloudflare KV |

---

### GET /api/leaderboard/me

| Field | Value |
|-------|-------|
| **Purpose** | Get user's leaderboard position |
| **Auth** | Authenticated |
| **Tables** | `leaderboard_entries` |
| **DB-SCHEMA** | [leaderboard_entries](DB-SCHEMA.md#leaderboard_entries) |

---

## Sub-Communities (Block 2+)

### GET /api/communities/:slug

| Field | Value |
|-------|-------|
| **Purpose** | Get sub-community details |
| **Auth** | Authenticated (member or public) |
| **Tables** | `sub_communities`, `sub_community_members` |
| **DB-SCHEMA** | [sub_communities](DB-SCHEMA.md#sub_communities) |

---

### GET /api/communities/:slug/feed

| Field | Value |
|-------|-------|
| **Purpose** | Get sub-community feed |
| **Auth** | Authenticated (member) |
| **Tables** | `posts`, `sub_community_posts` |
| **External** | Stream.io |
| **DB-SCHEMA** | [sub_communities](DB-SCHEMA.md#sub_communities), [posts](DB-SCHEMA.md#posts) |

---

### POST /api/communities/:slug/join

| Field | Value |
|-------|-------|
| **Purpose** | Join sub-community |
| **Auth** | Authenticated |
| **Tables** | `sub_community_members` |
| **DB-SCHEMA** | [sub_community_members](DB-SCHEMA.md#sub_community_members) |

---

### DELETE /api/communities/:slug/leave

| Field | Value |
|-------|-------|
| **Purpose** | Leave sub-community |
| **Auth** | Authenticated (member) |
| **Tables** | `sub_community_members` |
| **DB-SCHEMA** | [sub_community_members](DB-SCHEMA.md#sub_community_members) |

---

### PUT /api/communities/:slug

| Field | Value |
|-------|-------|
| **Purpose** | Update sub-community |
| **Auth** | Authenticated (admin) |
| **Tables** | `sub_communities` |
| **DB-SCHEMA** | [sub_communities](DB-SCHEMA.md#sub_communities) |

---

### POST /api/communities/:slug/invite

| Field | Value |
|-------|-------|
| **Purpose** | Invite to sub-community |
| **Auth** | Authenticated (admin) |
| **Tables** | `sub_community_invites` |

---

### POST /api/communities/:slug/posts

| Field | Value |
|-------|-------|
| **Purpose** | Post to sub-community |
| **Auth** | Authenticated (member) |
| **Tables** | `posts`, `sub_community_posts` |
| **DB-SCHEMA** | [posts](DB-SCHEMA.md#posts) |

---

## Newsletters (Block 2+)

### GET /api/newsletters

| Field | Value |
|-------|-------|
| **Purpose** | Get creator's newsletters |
| **Auth** | Authenticated (creator) |
| **Tables** | `newsletters` |
| **DB-SCHEMA** | [newsletters](DB-SCHEMA.md#newsletters) |

---

### POST /api/newsletters

| Field | Value |
|-------|-------|
| **Purpose** | Create newsletter |
| **Auth** | Authenticated (creator) |
| **Tables** | `newsletters` |
| **DB-SCHEMA** | [newsletters](DB-SCHEMA.md#newsletters) |

---

### PUT /api/newsletters/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update newsletter |
| **Auth** | Authenticated (creator) |
| **Tables** | `newsletters` |
| **DB-SCHEMA** | [newsletters](DB-SCHEMA.md#newsletters) |

---

### DELETE /api/newsletters/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete newsletter |
| **Auth** | Authenticated (creator) |
| **Tables** | `newsletters` |
| **DB-SCHEMA** | [newsletters](DB-SCHEMA.md#newsletters) |

---

### GET /api/newsletters/subscribers

| Field | Value |
|-------|-------|
| **Purpose** | Get newsletter subscribers |
| **Auth** | Authenticated (creator) |
| **Tables** | `newsletter_subscribers`, `users` |
| **DB-SCHEMA** | [newsletter_subscribers](DB-SCHEMA.md#newsletter_subscribers) |

---

### GET /api/newsletters/tiers

| Field | Value |
|-------|-------|
| **Purpose** | Get newsletter tiers |
| **Auth** | Authenticated (creator) |
| **Tables** | `newsletter_tiers` |
| **DB-SCHEMA** | [newsletter_tiers](DB-SCHEMA.md#newsletter_tiers) |

---

## Instructor Feed Access

### GET /api/instructors/:id/feed/access

| Field | Value |
|-------|-------|
| **Purpose** | Check instructor feed access |
| **Auth** | Authenticated |
| **Tables** | `instructor_followers` |
| **DB-SCHEMA** | [instructor_followers](DB-SCHEMA.md#instructor_followers) |

---

## Admin Endpoints

### GET /api/admin/dashboard

| Field | Value |
|-------|-------|
| **Purpose** | Admin dashboard metrics |
| **Auth** | Admin |
| **Tables** | `users`, `courses`, `enrollments`, `transactions`, `payment_splits`, `content_flags` |

---

### GET /api/admin/users

| Field | Value |
|-------|-------|
| **Purpose** | List all users |
| **Auth** | Admin |
| **Tables** | `users`, `enrollments`, `sessions` |
| **Query** | `q`, `role`, `status`, `from`, `to`, `page`, `limit` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/admin/users/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get user detail |
| **Auth** | Admin |
| **Tables** | `users`, `enrollments`, `sessions`, `certificates`, `audit_log` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/admin/users

| Field | Value |
|-------|-------|
| **Purpose** | Create user manually |
| **Auth** | Admin |
| **Tables** | `users` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### PATCH /api/admin/users/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update user |
| **Auth** | Admin |
| **Tables** | `users`, `audit_log` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### DELETE /api/admin/users/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete user |
| **Auth** | Admin |
| **Tables** | `users` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/admin/users/:id/suspend

| Field | Value |
|-------|-------|
| **Purpose** | Suspend user |
| **Auth** | Admin |
| **Tables** | `users.status`, `audit_log` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/admin/users/:id/unsuspend

| Field | Value |
|-------|-------|
| **Purpose** | Unsuspend user |
| **Auth** | Admin |
| **Tables** | `users.status`, `audit_log` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/admin/users/:id/reset-password

| Field | Value |
|-------|-------|
| **Purpose** | Send password reset |
| **Auth** | Admin |
| **Tables** | `users`, `password_reset_tokens` |
| **External** | Resend email |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/admin/users/:id/verify-email

| Field | Value |
|-------|-------|
| **Purpose** | Manually verify email |
| **Auth** | Admin |
| **Tables** | `users.email_verified` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/admin/users/export

| Field | Value |
|-------|-------|
| **Purpose** | Export users CSV |
| **Auth** | Admin |
| **Tables** | `users` |

---

### GET /api/admin/courses

| Field | Value |
|-------|-------|
| **Purpose** | List all courses |
| **Auth** | Admin |
| **Tables** | `courses`, `users`, `categories` |
| **Query** | `q`, `category_id`, `status`, `level`, `featured`, `page`, `limit` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### GET /api/admin/courses/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get course detail |
| **Auth** | Admin |
| **Tables** | `courses`, `users`, `enrollments`, `student_teachers`, `transactions` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### PATCH /api/admin/courses/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update course |
| **Auth** | Admin |
| **Tables** | `courses`, `audit_log` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### DELETE /api/admin/courses/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete course |
| **Auth** | Admin |
| **Tables** | `courses` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### POST /api/admin/courses/:id/feature

| Field | Value |
|-------|-------|
| **Purpose** | Feature course |
| **Auth** | Admin |
| **Tables** | `courses.is_featured` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### DELETE /api/admin/courses/:id/feature

| Field | Value |
|-------|-------|
| **Purpose** | Unfeature course |
| **Auth** | Admin |
| **Tables** | `courses.is_featured` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### POST /api/admin/courses/:id/suspend

| Field | Value |
|-------|-------|
| **Purpose** | Suspend course |
| **Auth** | Admin |
| **Tables** | `courses.status` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### POST /api/admin/courses/:id/unsuspend

| Field | Value |
|-------|-------|
| **Purpose** | Unsuspend course |
| **Auth** | Admin |
| **Tables** | `courses.status` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### POST /api/admin/courses/:id/transfer

| Field | Value |
|-------|-------|
| **Purpose** | Transfer course ownership |
| **Auth** | Admin |
| **Tables** | `courses.creator_id` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### GET /api/admin/enrollments

| Field | Value |
|-------|-------|
| **Purpose** | List enrollments |
| **Auth** | Admin |
| **Tables** | `enrollments`, `users`, `courses`, `student_teachers` |
| **Query** | `q`, `course_id`, `status`, `st_assigned`, `from`, `to`, `page`, `limit` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/admin/enrollments/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get enrollment detail |
| **Auth** | Admin |
| **Tables** | `enrollments`, `users`, `courses`, `module_progress`, `sessions`, `transactions` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### POST /api/admin/enrollments

| Field | Value |
|-------|-------|
| **Purpose** | Create manual enrollment |
| **Auth** | Admin |
| **Tables** | `enrollments` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### PATCH /api/admin/enrollments/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update enrollment |
| **Auth** | Admin |
| **Tables** | `enrollments` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### DELETE /api/admin/enrollments/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete enrollment |
| **Auth** | Admin |
| **Tables** | `enrollments` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### POST /api/admin/enrollments/:id/reassign-st

| Field | Value |
|-------|-------|
| **Purpose** | Reassign ST |
| **Auth** | Admin |
| **Tables** | `enrollments.student_teacher_id` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### POST /api/admin/enrollments/:id/cancel

| Field | Value |
|-------|-------|
| **Purpose** | Cancel enrollment |
| **Auth** | Admin |
| **Tables** | `enrollments.status` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### POST /api/admin/enrollments/:id/refund

| Field | Value |
|-------|-------|
| **Purpose** | Process refund |
| **Auth** | Admin |
| **Tables** | `transactions`, `payment_splits`, `enrollments` |
| **External** | Stripe refund |
| **DB-SCHEMA** | [transactions](DB-SCHEMA.md#transactions), [payment_splits](DB-SCHEMA.md#payment_splits) |

---

### POST /api/admin/enrollments/:id/force-complete

| Field | Value |
|-------|-------|
| **Purpose** | Force complete enrollment |
| **Auth** | Admin |
| **Tables** | `enrollments.status`, `enrollments.completed_at` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/admin/enrollments/export

| Field | Value |
|-------|-------|
| **Purpose** | Export enrollments CSV |
| **Auth** | Admin |
| **Tables** | `enrollments`, `users`, `courses` |

---

### GET /api/admin/sessions

| Field | Value |
|-------|-------|
| **Purpose** | List sessions |
| **Auth** | Admin |
| **Tables** | `sessions`, `users`, `courses` |
| **Query** | `q`, `course_id`, `status`, `from`, `to`, `has_dispute`, `low_rating`, `page`, `limit` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/admin/sessions/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get session detail |
| **Auth** | Admin |
| **Tables** | `sessions`, `users`, `courses`, `session_assessments` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions), [session_assessments](DB-SCHEMA.md#session_assessments) |

---

### PATCH /api/admin/sessions/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update session |
| **Auth** | Admin |
| **Tables** | `sessions` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/admin/sessions/:id/recording

| Field | Value |
|-------|-------|
| **Purpose** | Get recording URL |
| **Auth** | Admin |
| **Tables** | `sessions.recording_url` |
| **Storage** | Cloudflare R2 |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### POST /api/admin/sessions/:id/resolve

| Field | Value |
|-------|-------|
| **Purpose** | Resolve dispute |
| **Auth** | Admin |
| **Tables** | `sessions`, `session_disputes`, `users` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### POST /api/admin/sessions/:id/credit

| Field | Value |
|-------|-------|
| **Purpose** | Credit free session |
| **Auth** | Admin |
| **Tables** | `session_credits` |

---

### POST /api/admin/sessions/:id/warn

| Field | Value |
|-------|-------|
| **Purpose** | Warn user |
| **Auth** | Admin |
| **Tables** | `user_warnings` |

---

### GET /api/admin/sessions/upcoming

| Field | Value |
|-------|-------|
| **Purpose** | Upcoming sessions |
| **Auth** | Admin |
| **Tables** | `sessions` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/admin/sessions/stats

| Field | Value |
|-------|-------|
| **Purpose** | Session statistics |
| **Auth** | Admin |
| **Tables** | `sessions`, `session_assessments` |

---

### GET /api/admin/payouts/pending

| Field | Value |
|-------|-------|
| **Purpose** | Pending payouts |
| **Auth** | Admin |
| **Tables** | `payment_splits`, `users` |
| **DB-SCHEMA** | [payment_splits](DB-SCHEMA.md#payment_splits) |

---

### GET /api/admin/payouts

| Field | Value |
|-------|-------|
| **Purpose** | All payouts |
| **Auth** | Admin |
| **Tables** | `payouts`, `users` |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### GET /api/admin/payouts/:id

| Field | Value |
|-------|-------|
| **Purpose** | Payout detail |
| **Auth** | Admin |
| **Tables** | `payouts`, `payment_splits`, `users` |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### POST /api/admin/payouts/:id/approve

| Field | Value |
|-------|-------|
| **Purpose** | Approve payout |
| **Auth** | Admin |
| **Tables** | `payouts`, `payment_splits` |
| **External** | Stripe transfer |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### POST /api/admin/payouts/:id/process

| Field | Value |
|-------|-------|
| **Purpose** | Process payout |
| **Auth** | Admin |
| **Tables** | `payouts` |
| **External** | Stripe transfer |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### POST /api/admin/payouts/:id/retry

| Field | Value |
|-------|-------|
| **Purpose** | Retry failed payout |
| **Auth** | Admin |
| **Tables** | `payouts` |
| **External** | Stripe transfer |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### DELETE /api/admin/payouts/:id

| Field | Value |
|-------|-------|
| **Purpose** | Cancel payout |
| **Auth** | Admin |
| **Tables** | `payouts` |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### POST /api/admin/payouts/batch-approve

| Field | Value |
|-------|-------|
| **Purpose** | Batch approve payouts |
| **Auth** | Admin |
| **Tables** | `payouts`, `payment_splits` |
| **External** | Stripe transfers |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### POST /api/admin/payouts/batch

| Field | Value |
|-------|-------|
| **Purpose** | Batch process payouts |
| **Auth** | Admin |
| **Tables** | `payouts` |
| **External** | Stripe transfers |
| **DB-SCHEMA** | [payouts](DB-SCHEMA.md#payouts) |

---

### GET /api/admin/certificates

| Field | Value |
|-------|-------|
| **Purpose** | List certificates |
| **Auth** | Admin |
| **Tables** | `certificates`, `users`, `courses` |
| **Query** | `q`, `course_id`, `type`, `status`, `from`, `to`, `page`, `limit` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### GET /api/admin/certificates/pending

| Field | Value |
|-------|-------|
| **Purpose** | Pending certificates |
| **Auth** | Admin |
| **Tables** | `certificates`, `users`, `courses` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### GET /api/admin/certificates/:id

| Field | Value |
|-------|-------|
| **Purpose** | Certificate detail |
| **Auth** | Admin |
| **Tables** | `certificates`, `users`, `courses` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/admin/certificates

| Field | Value |
|-------|-------|
| **Purpose** | Issue certificate |
| **Auth** | Admin |
| **Tables** | `certificates` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/admin/certificates/:id/approve

| Field | Value |
|-------|-------|
| **Purpose** | Approve pending cert |
| **Auth** | Admin |
| **Tables** | `certificates.status` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/admin/certificates/:id/reject

| Field | Value |
|-------|-------|
| **Purpose** | Reject pending cert |
| **Auth** | Admin |
| **Tables** | `certificates.status` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/admin/certificates/:id/revoke

| Field | Value |
|-------|-------|
| **Purpose** | Revoke certificate |
| **Auth** | Admin |
| **Tables** | `certificates.status` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/admin/certificates/:id/reinstate

| Field | Value |
|-------|-------|
| **Purpose** | Reinstate certificate |
| **Auth** | Admin |
| **Tables** | `certificates.status` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### GET /api/admin/certificates/:id/pdf

| Field | Value |
|-------|-------|
| **Purpose** | Download certificate PDF |
| **Auth** | Admin |
| **Tables** | `certificates` |

---

### GET /api/admin/categories

| Field | Value |
|-------|-------|
| **Purpose** | List categories |
| **Auth** | Admin |
| **Tables** | `categories`, `courses` (count) |
| **DB-SCHEMA** | [categories](DB-SCHEMA.md#categories) |

---

### POST /api/admin/categories

| Field | Value |
|-------|-------|
| **Purpose** | Create category |
| **Auth** | Admin |
| **Tables** | `categories` |
| **DB-SCHEMA** | [categories](DB-SCHEMA.md#categories) |

---

### PATCH /api/admin/categories/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update category |
| **Auth** | Admin |
| **Tables** | `categories` |
| **DB-SCHEMA** | [categories](DB-SCHEMA.md#categories) |

---

### DELETE /api/admin/categories/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete category |
| **Auth** | Admin |
| **Tables** | `categories` |
| **DB-SCHEMA** | [categories](DB-SCHEMA.md#categories) |

---

### POST /api/admin/categories/reorder

| Field | Value |
|-------|-------|
| **Purpose** | Reorder categories |
| **Auth** | Admin |
| **Tables** | `categories.display_order` |
| **DB-SCHEMA** | [categories](DB-SCHEMA.md#categories) |

---

### POST /api/admin/categories/:id/merge

| Field | Value |
|-------|-------|
| **Purpose** | Merge categories |
| **Auth** | Admin |
| **Tables** | `categories`, `courses.category_id` |
| **DB-SCHEMA** | [categories](DB-SCHEMA.md#categories) |

---

### GET /api/admin/analytics

| Field | Value |
|-------|-------|
| **Purpose** | Platform analytics |
| **Auth** | Admin |
| **Tables** | Multiple |

---

### GET /api/admin/flags/count

| Field | Value |
|-------|-------|
| **Purpose** | Flagged content count |
| **Auth** | Admin |
| **Tables** | `content_flags` |
| **DB-SCHEMA** | [content_flags](DB-SCHEMA.md#content_flags) |

---

## Moderator Invites

### GET /api/admin/moderator-invites

| Field | Value |
|-------|-------|
| **Purpose** | List moderator invites |
| **Auth** | Admin |
| **Tables** | `moderator_invites`, `users` |
| **Query** | `status`, `page`, `limit` |
| **DB-SCHEMA** | [moderator_invites](DB-SCHEMA.md#moderator_invites) |

---

### POST /api/admin/moderator-invites

| Field | Value |
|-------|-------|
| **Purpose** | Send moderator invite (Step 1) |
| **Auth** | Admin |
| **Tables** | `moderator_invites` |
| **External** | Resend (invite email) |
| **DB-SCHEMA** | [moderator_invites](DB-SCHEMA.md#moderator_invites) |

**Note:** Creates pending invite, generates unique token, sends email with invite link.

---

### GET /api/moderator-invites/:token

| Field | Value |
|-------|-------|
| **Purpose** | Validate invite token (public) |
| **Auth** | Public |
| **Tables** | `moderator_invites` |
| **DB-SCHEMA** | [moderator_invites](DB-SCHEMA.md#moderator_invites) |

**Note:** Returns invite status and basic info (email masked). Used to show accept/decline UI.

---

### POST /api/moderator-invites/:token/accept

| Field | Value |
|-------|-------|
| **Purpose** | Accept moderator invite (Step 2) |
| **Auth** | Public (with valid token) or Authenticated |
| **Tables** | `moderator_invites`, `users` |
| **DB-SCHEMA** | [moderator_invites](DB-SCHEMA.md#moderator_invites), [users](DB-SCHEMA.md#users) |

**Note:**
- If authenticated user: sets `is_moderator=true` on existing account
- If not authenticated: redirects to signup flow with token preserved, then sets `is_moderator=true` on new account

---

### POST /api/moderator-invites/:token/decline

| Field | Value |
|-------|-------|
| **Purpose** | Decline moderator invite |
| **Auth** | Public (with valid token) |
| **Tables** | `moderator_invites` |
| **DB-SCHEMA** | [moderator_invites](DB-SCHEMA.md#moderator_invites) |

---

### DELETE /api/admin/moderator-invites/:id

| Field | Value |
|-------|-------|
| **Purpose** | Revoke/cancel invite |
| **Auth** | Admin |
| **Tables** | `moderator_invites` |
| **DB-SCHEMA** | [moderator_invites](DB-SCHEMA.md#moderator_invites) |

---

### POST /api/admin/moderator-invites/:id/resend

| Field | Value |
|-------|-------|
| **Purpose** | Resend invite email |
| **Auth** | Admin |
| **Tables** | `moderator_invites` |
| **External** | Resend (invite email) |
| **DB-SCHEMA** | [moderator_invites](DB-SCHEMA.md#moderator_invites) |

---

## Moderation Endpoints

### GET /api/moderation/queue

| Field | Value |
|-------|-------|
| **Purpose** | Get moderation queue |
| **Auth** | Moderator |
| **Tables** | `content_flags`, `posts`, `users` |
| **Query** | `status`, `type`, `priority`, `from`, `to`, `page`, `limit` |
| **DB-SCHEMA** | [content_flags](DB-SCHEMA.md#content_flags), [posts](DB-SCHEMA.md#posts) |

---

### GET /api/moderation/queue/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get flag detail |
| **Auth** | Moderator |
| **Tables** | `content_flags`, `posts`, `users` |
| **DB-SCHEMA** | [content_flags](DB-SCHEMA.md#content_flags) |

---

### POST /api/moderation/queue/:id/dismiss

| Field | Value |
|-------|-------|
| **Purpose** | Dismiss flag |
| **Auth** | Moderator |
| **Tables** | `content_flags.status`, `moderation_actions` |
| **DB-SCHEMA** | [content_flags](DB-SCHEMA.md#content_flags) |

---

### POST /api/moderation/queue/:id/remove

| Field | Value |
|-------|-------|
| **Purpose** | Remove content |
| **Auth** | Moderator |
| **Tables** | `posts`, `content_flags`, `moderation_actions` |
| **DB-SCHEMA** | [posts](DB-SCHEMA.md#posts), [content_flags](DB-SCHEMA.md#content_flags) |

---

### POST /api/moderation/queue/:id/warn

| Field | Value |
|-------|-------|
| **Purpose** | Warn user |
| **Auth** | Moderator |
| **Tables** | `user_warnings`, `content_flags`, `moderation_actions` |

---

### POST /api/moderation/queue/:id/ban

| Field | Value |
|-------|-------|
| **Purpose** | Ban user |
| **Auth** | Moderator |
| **Tables** | `users.status`, `content_flags`, `moderation_actions` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [content_flags](DB-SCHEMA.md#content_flags) |

---

### GET /api/moderation/history

| Field | Value |
|-------|-------|
| **Purpose** | Moderation action history |
| **Auth** | Moderator |
| **Tables** | `moderation_actions` |

---

### GET /api/moderation/stats

| Field | Value |
|-------|-------|
| **Purpose** | Moderation statistics |
| **Auth** | Moderator |
| **Tables** | `content_flags`, `moderation_actions` |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v1 | 2025-12-26 | Split from API.md - internal database endpoints with DB-SCHEMA references |
| v2 | 2025-12-26 | Brian Review updates: Homework endpoints (11), Session Resources endpoints (6), Moderator Invites endpoints (7) |
