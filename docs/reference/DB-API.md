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

> **Detailed contracts** (request body, response shape, error codes, side effects) live in [API-AUTH.md](API-AUTH.md). This section is the structural/auth/tables index only.

### POST /api/auth/register

| Field | Value |
|-------|-------|
| **Purpose** | Create new email/password account; auto-generate handle from name; auto-join The Commons |
| **Auth** | Public |
| **Tables** | `users` (insert), `community_members` (auto-join), `notifications` (welcome ×2) |
| **Side effects** | Sets `peerloop_access` + `peerloop_refresh` cookies |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [community_members](DB-SCHEMA.md#community_members), [notifications](DB-SCHEMA.md#notifications) |

---

### POST /api/auth/login

| Field | Value |
|-------|-------|
| **Purpose** | Authenticate with email + password |
| **Auth** | Public |
| **Tables** | `users` (select + `last_login` update via `recordLogin()`) |
| **Side effects** | Sets `peerloop_access` + `peerloop_refresh` cookies |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/auth/logout

| Field | Value |
|-------|-------|
| **Purpose** | Clear auth cookies |
| **Auth** | Public (idempotent — does not require valid session) |
| **Tables** | None |
| **Side effects** | Clears `peerloop_access` + `peerloop_refresh` cookies |

---

### GET /api/auth/session

| Field | Value |
|-------|-------|
| **Purpose** | Return current authenticated user (or `{authenticated:false, user:null}`) |
| **Auth** | Public (read cookie; no error on missing session) |
| **Tables** | `users` (select to hydrate full user row) |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/auth/reset-password

| Field | Value |
|-------|-------|
| **Purpose** | Request password reset email (stubbed — always returns 200 to prevent email enumeration) |
| **Auth** | Public |
| **Tables** | None *(full flow deferred to Block 9 Notifications — token is a JWT via `createPasswordResetToken`, not a DB-backed `password_reset_tokens` table)* |
| **DB-SCHEMA** | N/A — stateless JWT token |

---

### POST /api/auth/dev-login

| Field | Value |
|-------|-------|
| **Purpose** | Passwordless login by email for PLATO walkthroughs (dev only) |
| **Auth** | Public (gated on `import.meta.env.DEV` — returns 404 in production) |
| **Tables** | `users` (select + `last_login` update via `recordLogin()`) |
| **Side effects** | Sets `peerloop_access` + `peerloop_refresh` cookies |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/auth/google

| Field | Value |
|-------|-------|
| **Purpose** | Initiate Google OAuth 2.0 flow (302 redirect to Google consent) |
| **Auth** | Public |
| **Tables** | None |
| **External** | Google OAuth 2.0 (via `arctic`) |
| **Side effects** | Sets `peerloop_oauth_state` + `peerloop_oauth_verifier` cookies (10 min TTL, PKCE) |

---

### GET /api/auth/google/callback

| Field | Value |
|-------|-------|
| **Purpose** | Handle Google OAuth callback; create or match user; issue auth cookies |
| **Auth** | Public (validates `state` cookie) |
| **Tables** | `users` (select by email; insert if new) |
| **External** | Google OAuth 2.0 + `openidconnect.googleapis.com/v1/userinfo` |
| **Side effects** | Sets `peerloop_access` + `peerloop_refresh`; clears OAuth state/verifier; 302 to `/` or `/onboarding` (if `onboarding_completed_at IS NULL`) |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### GET /api/auth/github

| Field | Value |
|-------|-------|
| **Purpose** | Initiate GitHub OAuth 2.0 flow (302 redirect to GitHub consent) |
| **Auth** | Public |
| **Tables** | None |
| **External** | GitHub OAuth 2.0 (via `arctic`) |
| **Side effects** | Sets `peerloop_oauth_state` cookie (10 min TTL; GitHub flow does not use PKCE) |

---

### GET /api/auth/github/callback

| Field | Value |
|-------|-------|
| **Purpose** | Handle GitHub OAuth callback; create or match user; issue auth cookies |
| **Auth** | Public (validates `state` cookie) |
| **Tables** | `users` (select by primary verified email; insert if new) |
| **External** | GitHub OAuth 2.0 + `api.github.com/user`, `api.github.com/user/emails` |
| **Side effects** | Same as `/google/callback` |
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

### GET /api/me/full

| Field | Value |
|-------|-------|
| **Purpose** | Full user state for client-side `CurrentUser` class (roles, enrollments, capabilities, unread counts) |
| **Auth** | Authenticated |
| **Tables** | `users`, `user_roles`, `enrollments`, `teacher_certifications`, `courses`, `sessions`, `notifications`, `conversations` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [enrollments](DB-SCHEMA.md#enrollments), [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |
| **Added** | CURRENTUSER block; `teaching_active` field added Conv 008; course-level stats added Conv 041 |

**Notes:**
- Returns everything needed to hydrate `CurrentUser` class on the client
- Teacher certifications include `teaching_active` (boolean) — user-controlled toggle for pausing student acceptance
- Teacher certifications include course-level stats: `courseRating`, `courseRatingCount`, `teacherCount`, `nextSessionAt` — 3 subqueries on `courses`, `teacher_certifications`, `sessions` (Conv 041)
- Enrollment Map uses priority logic: active enrollments preferred over completed
- Includes `unreadNotificationCount` and `unreadMessageCount`
- Cached client-side in localStorage with stale-while-revalidate pattern

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
| **Purpose** | Update availability slots (supports start_date, repeat_weeks) |
| **Auth** | Authenticated (Teacher/Creator) |
| **Tables** | `availability` |
| **DB-SCHEMA** | [availability](DB-SCHEMA.md#availability) |

---

### GET /api/me/availability/overrides

| Field | Value |
|-------|-------|
| **Purpose** | List date-specific availability overrides |
| **Auth** | Authenticated (Teacher/Creator) |
| **Tables** | `availability_overrides` |
| **DB-SCHEMA** | [availability_overrides](DB-SCHEMA.md#availability_overrides) |
| **Added** | Session 288 |

---

### POST /api/me/availability/overrides

| Field | Value |
|-------|-------|
| **Purpose** | Create override (change times or block a date) |
| **Auth** | Authenticated (Teacher/Creator) |
| **Tables** | `availability_overrides` |
| **DB-SCHEMA** | [availability_overrides](DB-SCHEMA.md#availability_overrides) |
| **Added** | Session 288 |

---

### DELETE /api/me/availability/overrides/:id

| Field | Value |
|-------|-------|
| **Purpose** | Remove override (revert to recurring) |
| **Auth** | Authenticated (owner only) |
| **Tables** | `availability_overrides` |
| **DB-SCHEMA** | [availability_overrides](DB-SCHEMA.md#availability_overrides) |
| **Added** | Session 288 |

---

### PATCH /api/me/teacher/:courseId/toggle

| Field | Value |
|-------|-------|
| **Purpose** | Toggle teaching_active for a specific course (pause/resume accepting students) |
| **Auth** | Authenticated (must have Teacher certification for the course) |
| **Tables** | `teacher_certifications` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |
| **Added** | Session 289 |

---

### GET /api/users/me/availability/

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
| **Tables** | `courses`, `users` (creators), `course_tags`, `tags`, `topics` |
| **Query** | `q`, `level`, `tag`, `page`, `limit` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses), [topics](DB-SCHEMA.md#topics) |

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

### GET /api/courses/:id/teachers

| Field | Value |
|-------|-------|
| **Purpose** | Get Teachers for course |
| **Auth** | Public |
| **Tables** | `teacher_certifications`, `users` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |

---

### POST /api/courses/:slug/follow

| Field | Value |
|-------|-------|
| **Purpose** | Follow a course (subscribe to updates without enrolling) |
| **Auth** | Authenticated |
| **Tables** | `course_follows`, `courses` |
| **DB-SCHEMA** | [course_follows](DB-SCHEMA.md#course_follows) |
| **Side effects** | Stream timeline follow (non-blocking) |

---

### DELETE /api/courses/:slug/follow

| Field | Value |
|-------|-------|
| **Purpose** | Unfollow a course |
| **Auth** | Authenticated |
| **Tables** | `course_follows`, `courses` |
| **DB-SCHEMA** | [course_follows](DB-SCHEMA.md#course_follows) |
| **Side effects** | Stream timeline unfollow (non-blocking) |

---

### GET /api/me/course-follows

| Field | Value |
|-------|-------|
| **Purpose** | List courses the current user follows |
| **Auth** | Authenticated |
| **Tables** | `course_follows`, `courses`, `users` |
| **DB-SCHEMA** | [course_follows](DB-SCHEMA.md#course_follows) |

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
| **Tables** | `courses.status`, `course_tags` (read — validates ≥1 tag assigned) |
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

### GET /api/courses/:id/availability-summary

| Field | Value |
|-------|-------|
| **Purpose** | Teacher availability preview for enrollment decisions |
| **Auth** | Public (optional auth for self-exclusion) |
| **Tables** | `courses`, `teacher_certifications`, `users`, `teacher_availability`, `sessions`, `platform_stats` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications), [teacher_availability](DB-SCHEMA.md#teacher_availability) |
| **Added** | Conv 008 (ENROLL-AVAIL) |

**Response:**
```json
{
  "availabilityWindowDays": 30,
  "teachers": [
    {
      "userId": "...", "name": "...", "handle": "...", "avatarUrl": "...",
      "rating": 4.8, "ratingCount": 12, "studentsTaught": 5,
      "slotsAvailable": 7, "nextAvailable": "2026-03-20"
    }
  ],
  "totalSlots": 7,
  "teacherCount": 1,
  "hasAvailability": true
}
```

**Notes:**
- `availabilityWindowDays` read from `platform_stats` (default 30, admin-configurable)
- If the requesting user is authenticated, they are excluded from the teacher list (teachers don't see themselves)
- Teachers with `teaching_active=0` appear but show 0 slots
- Uses `countAvailableSlots()` from `src/lib/availability.ts` to compute per-teacher slot counts

---

## Tags

### GET /api/tags

| Field | Value |
|-------|-------|
| **Purpose** | Get all active tags grouped by topic |
| **Auth** | Public |
| **Tables** | `tags`, `topics` |
| **DB-SCHEMA** | [tags](DB-SCHEMA.md#tags), [topics](DB-SCHEMA.md#topics) |

---

## Enrollments

### GET /api/enrollments

| Field | Value |
|-------|-------|
| **Purpose** | Get current user's enrollments |
| **Auth** | Authenticated |
| **Tables** | `enrollments`, `courses`, `teacher_certifications`, `users` |
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
| **Auth** | Authenticated (Teacher) |
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

### GET /api/teachers/:id/availability

| Field | Value |
|-------|-------|
| **Purpose** | Get Teacher's availability slots |
| **Auth** | Authenticated |
| **Tables** | `availability` |
| **DB-SCHEMA** | [availability](DB-SCHEMA.md#availability) |

---

### GET /api/teachers/:id/bookings

| Field | Value |
|-------|-------|
| **Purpose** | Get Teacher's existing bookings |
| **Auth** | Authenticated |
| **Tables** | `sessions` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### POST /api/session-invites

| Field | Value |
|-------|-------|
| **Purpose** | Teacher creates an instant session invite for a student |
| **Auth** | Teacher (assigned to enrollment) or Creator |
| **Body** | `{ enrollment_id }` |
| **Tables** | `session_invites`, `enrollments`, `courses`, `notifications` |
| **Notes** | Creates 30-min expiry invite. Sends notification to student. Rejects if pending invite already exists for enrollment. Returns mode: `new` (bookable module available) or `reschedule` (all modules booked, will reschedule next upcoming session). |

### GET /api/session-invites

| Field | Value |
|-------|-------|
| **Purpose** | List active invites for an enrollment |
| **Auth** | Student, Teacher, or Creator on the enrollment |
| **Query** | `enrollment_id` (required) |
| **Tables** | `session_invites`, `enrollments`, `users` |
| **Notes** | Lazily expires stale invites (updates `pending` → `expired` where `expires_at` has passed). Returns only pending invites. |

### POST /api/session-invites/:id/accept

| Field | Value |
|-------|-------|
| **Purpose** | Student accepts a session invite, creating a session at now+5min |
| **Auth** | Student on the enrollment |
| **Tables** | `session_invites`, `sessions`, `enrollments`, `notifications` |
| **Notes** | If `bookable_count > 0`: creates new session. If all modules booked: cancels next upcoming scheduled session, creates new one (reschedule). Runs teacher + student conflict checks. Returns `redirect_url` to session room. Returns 410 if invite expired. |

### POST /api/session-invites/:id/decline

| Field | Value |
|-------|-------|
| **Purpose** | Student declines a session invite |
| **Auth** | Student on the enrollment |
| **Tables** | `session_invites` |
| **Notes** | Updates invite status to `declined`. |

---

## Teachers

### GET /api/teachers

| Field | Value |
|-------|-------|
| **Purpose** | List Teachers |
| **Auth** | Public |
| **Tables** | `teacher_certifications`, `users`, `courses` |
| **Query** | `course`, `available` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |

---

### GET /api/teachers/me/dashboard

| Field | Value |
|-------|-------|
| **Purpose** | Teacher dashboard data |
| **Auth** | Authenticated (Teacher) |
| **Tables** | `sessions`, `payment_splits`, `enrollments`, `users` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions), [payment_splits](DB-SCHEMA.md#payment_splits) |

---

### GET /api/teachers/me/sessions

| Field | Value |
|-------|-------|
| **Purpose** | Teacher's teaching sessions |
| **Auth** | Authenticated (Teacher) |
| **Tables** | `sessions`, `users`, `courses` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions) |

---

### GET /api/teachers/me/students

| Field | Value |
|-------|-------|
| **Purpose** | Teacher's assigned students |
| **Auth** | Authenticated (Teacher) |
| **Tables** | `enrollments`, `users`, `module_progress` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |

---

### GET /api/teachers/me/earnings

| Field | Value |
|-------|-------|
| **Purpose** | Teacher's earnings |
| **Auth** | Authenticated (Teacher) |
| **Tables** | `payment_splits`, `payouts` |
| **DB-SCHEMA** | [payment_splits](DB-SCHEMA.md#payment_splits), [payouts](DB-SCHEMA.md#payouts) |

---

### POST /api/teachers/:id/approve

| Field | Value |
|-------|-------|
| **Purpose** | Approve Teacher application |
| **Auth** | Authenticated (creator) |
| **Tables** | `teacher_certifications`, `certificates` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications), [certificates](DB-SCHEMA.md#certificates) |

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
| **Query** | `course_id`, `teacher_id`, `status`, `from`, `to`, `page`, `limit` |
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

### GET /api/creators/me/teachers

| Field | Value |
|-------|-------|
| **Purpose** | Creator's Teachers |
| **Auth** | Authenticated (creator) |
| **Tables** | `teacher_certifications`, `users` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |

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
| **Purpose** | Pending Teacher applications, certificates |
| **Auth** | Authenticated (creator) |
| **Tables** | `certificates`, `teacher_certifications` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates), [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |

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
| **Tables** | `course_views`, `enrollments`, `module_progress`, `teacher_certifications` |
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

### GET /api/creators/me/analytics/teacher-performance

| Field | Value |
|-------|-------|
| **Purpose** | Teacher performance table |
| **Auth** | Authenticated (creator) |
| **Tables** | `teacher_certifications`, `sessions`, `session_assessments` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications), [session_assessments](DB-SCHEMA.md#session_assessments) |

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
| **Auth** | Authenticated (Teacher) |
| **Tables** | `certificates` |
| **DB-SCHEMA** | [certificates](DB-SCHEMA.md#certificates) |

---

### POST /api/certificates/:id/issue

| Field | Value |
|-------|-------|
| **Purpose** | Issue certificate |
| **Auth** | Authenticated (creator) |
| **Tables** | `certificates`, `teacher_certifications` |
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
| **Auth** | Authenticated (enrolled or creator/Teacher) |
| **Tables** | `homework_assignments`, `course_curriculum` |
| **DB-SCHEMA** | [homework_assignments](DB-SCHEMA.md#homework_assignments) |

---

### GET /api/homework/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get homework assignment detail |
| **Auth** | Authenticated (enrolled or creator/Teacher) |
| **Tables** | `homework_assignments`, `homework_submissions` |
| **DB-SCHEMA** | [homework_assignments](DB-SCHEMA.md#homework_assignments) |

---

### POST /api/courses/:id/homework

| Field | Value |
|-------|-------|
| **Purpose** | Create homework assignment |
| **Auth** | Authenticated (creator or Teacher for course) |
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
| **Auth** | Authenticated (creator or Teacher for course) |
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
| **Auth** | Authenticated (creator or Teacher for course) |
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
| **Auth** | Authenticated (enrolled or creator/Teacher) |
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
| **Auth** | Authenticated (creator or Teacher) |
| **Tables** | `session_resources` |
| **Storage** | Cloudflare R2 |
| **DB-SCHEMA** | [session_resources](DB-SCHEMA.md#session_resources) |

---

### GET /api/resources/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get resource download URL |
| **Auth** | Authenticated (enrolled or creator/Teacher) |
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
| **Tables** | `users`, `teacher_certifications` |
| **Query** | `course_id` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |

---

### GET /api/courses/:id/helpers/available

| Field | Value |
|-------|-------|
| **Purpose** | Get available helpers count |
| **Auth** | Authenticated |
| **Tables** | `users`, `teacher_certifications` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |

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
| **Tables** | `users`, `teacher_certifications` |
| **DB-SCHEMA** | [teacher_certifications](DB-SCHEMA.md#teacher_certifications) |

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

## Communities

Endpoints for discovery, membership, moderation (Tier 2), and creator-side management. Split across two URL namespaces:
- `/api/communities/*` — public / member-facing reads and join flow.
- `/api/me/communities/*` — creator/owner-side management (CRUD, members, progressions).

> Resources (files + external links) for a community live under `/api/me/communities/:slug/resources/*` and `/api/community-resources/:id/download` — see **§Community Resources** below.

### GET /api/communities

| Field | Value |
|-------|-------|
| **Purpose** | List communities for the current user; filter modes `mine \| all \| discover` |
| **Auth** | Public (anonymous returns `all`/`discover` scope without membership flags) |
| **Tables** | `communities`, `community_members` |
| **Query** | `filter=mine\|all\|discover`, `search`, `limit` (≤50), `offset` |
| **Note** | Thin wrapper around `fetchCommunityListData` (`src/lib/ssr/loaders/communities.ts`); SSR pages call the loader directly, this endpoint exists for client-side React fetches |
| **DB-SCHEMA** | [communities](DB-SCHEMA.md#communities), [community_members](DB-SCHEMA.md#community_members) |

---

### GET /api/communities/:slug

| Field | Value |
|-------|-------|
| **Purpose** | Get community details + caller's membership state |
| **Auth** | Public (membership badges only populated when authenticated) |
| **Tables** | `communities`, `community_members` |
| **DB-SCHEMA** | [communities](DB-SCHEMA.md#communities) |

---

### POST /api/communities/:slug/join

| Field | Value |
|-------|-------|
| **Purpose** | Join a community (or rejoin after leaving) |
| **Auth** | Authenticated |
| **Tables** | `community_members` (insert or reactivate) |
| **DB-SCHEMA** | [community_members](DB-SCHEMA.md#community_members) |

---

### DELETE /api/communities/:slug/join

| Field | Value |
|-------|-------|
| **Purpose** | Leave community (DELETE on the same `/join` route — there is no separate `/leave`) |
| **Auth** | Authenticated (member) |
| **Tables** | `community_members` |
| **DB-SCHEMA** | [community_members](DB-SCHEMA.md#community_members) |

---

### GET /api/communities/:slug/progressions

| Field | Value |
|-------|-------|
| **Purpose** | List progressions (with nested course lists) for a community |
| **Auth** | Public |
| **Tables** | `progressions`, `progression_courses`, `courses` |
| **Query** | `includeArchived` (default `false`) |
| **Note** | Thin wrapper around `fetchCommunityProgressionsData` (`src/lib/ssr/loaders/communities.ts`) |
| **DB-SCHEMA** | [progressions](DB-SCHEMA.md#progressions), [progression_courses](DB-SCHEMA.md#progression_courses) |

---

### GET /api/communities/:slug/moderators

| Field | Value |
|-------|-------|
| **Purpose** | List active Tier-2 (community-scoped) moderators |
| **Auth** | Authenticated |
| **Tables** | `community_moderators`, `users`, `communities` |
| **DB-SCHEMA** | [community_moderators](DB-SCHEMA.md#community_moderators) |

---

### POST /api/communities/:slug/moderators

| Field | Value |
|-------|-------|
| **Purpose** | Appoint a community moderator (Tier 2) |
| **Auth** | Authenticated — community creator OR platform admin |
| **Tables** | `community_moderators` (insert), `users` (membership + admin check), `community_members`, `communities` |
| **Body** | `{ userId: string, notes?: string }` |
| **DB-SCHEMA** | [community_moderators](DB-SCHEMA.md#community_moderators) |

---

### DELETE /api/communities/:slug/moderators/:userId

| Field | Value |
|-------|-------|
| **Purpose** | Revoke a community moderator |
| **Auth** | Authenticated — community creator OR platform admin |
| **Tables** | `community_moderators` (update `is_active = 0`), `communities`, `users` |
| **Body** | `{ reason?: string }` |
| **DB-SCHEMA** | [community_moderators](DB-SCHEMA.md#community_moderators) |

---

### GET /api/me/communities

| Field | Value |
|-------|-------|
| **Purpose** | List communities the authenticated user **creates/owns** (with roll-up stats: member_count, progression_count, course_count, post_count) |
| **Auth** | Authenticated |
| **Tables** | `communities`, `community_members`, `progressions`, `progression_courses`, `posts` (aggregates) |
| **DB-SCHEMA** | [communities](DB-SCHEMA.md#communities) |

---

### POST /api/me/communities

| Field | Value |
|-------|-------|
| **Purpose** | Create a new community (auto-creates default progression + creator membership) |
| **Auth** | Authenticated (typically Creator role) |
| **Tables** | `communities` (insert), `progressions` (default insert), `community_members` (creator row) |
| **External** | Stream.io (feed group provisioning) |
| **DB-SCHEMA** | [communities](DB-SCHEMA.md#communities), [progressions](DB-SCHEMA.md#progressions), [community_members](DB-SCHEMA.md#community_members) |

---

### PATCH /api/me/communities/:slug

| Field | Value |
|-------|-------|
| **Purpose** | Update community settings (name, description, icon, cover, is_public) |
| **Auth** | Authenticated — community creator |
| **Tables** | `communities` |
| **DB-SCHEMA** | [communities](DB-SCHEMA.md#communities) |

---

### DELETE /api/me/communities/:slug

| Field | Value |
|-------|-------|
| **Purpose** | Archive community (soft delete — sets `is_archived = 1`) |
| **Auth** | Authenticated — community creator |
| **Tables** | `communities` |
| **DB-SCHEMA** | [communities](DB-SCHEMA.md#communities) |

---

### GET /api/me/communities/:slug/members

| Field | Value |
|-------|-------|
| **Purpose** | List members of a creator-owned community (with user name/handle/avatar + `joined_via`) |
| **Auth** | Authenticated — community creator |
| **Tables** | `community_members`, `users`, `communities` |
| **DB-SCHEMA** | [community_members](DB-SCHEMA.md#community_members) |

---

### GET /api/me/communities/:slug/progressions

| Field | Value |
|-------|-------|
| **Purpose** | List all progressions (including archived) for a creator-owned community, with nested course arrays |
| **Auth** | Authenticated — community creator |
| **Tables** | `progressions`, `progression_courses`, `courses` |
| **DB-SCHEMA** | [progressions](DB-SCHEMA.md#progressions) |

---

### POST /api/me/communities/:slug/progressions

| Field | Value |
|-------|-------|
| **Purpose** | Create a new progression in a creator-owned community |
| **Auth** | Authenticated — community creator |
| **Tables** | `progressions` (insert) |
| **DB-SCHEMA** | [progressions](DB-SCHEMA.md#progressions) |

---

### PATCH /api/me/communities/:slug/progressions/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update progression metadata (name, description, thumbnail, badge, display_order) |
| **Auth** | Authenticated — community creator |
| **Tables** | `progressions` |
| **DB-SCHEMA** | [progressions](DB-SCHEMA.md#progressions) |

---

### DELETE /api/me/communities/:slug/progressions/:id

| Field | Value |
|-------|-------|
| **Purpose** | Archive progression (soft delete — sets `is_archived = 1`) |
| **Auth** | Authenticated — community creator |
| **Tables** | `progressions` |
| **DB-SCHEMA** | [progressions](DB-SCHEMA.md#progressions) |

---

### PATCH /api/me/communities/:slug/progressions/reorder

| Field | Value |
|-------|-------|
| **Purpose** | Reorder progressions — accepts array of progression IDs in desired order |
| **Auth** | Authenticated — community creator |
| **Tables** | `progressions` (batch update of `display_order`) |
| **DB-SCHEMA** | [progressions](DB-SCHEMA.md#progressions) |

---

### Proposed (Block 2+ — not yet implemented)

The following endpoints are speculative and **do not exist in code**. They are retained here as design intent, not as documentation of current behavior.

#### GET /api/communities/:slug/feed *(proposed)*

| Field | Value |
|-------|-------|
| **Purpose** | Get community feed (posts timeline) |
| **Auth** | Authenticated (member) |
| **External** | Stream.io |
| **Status** | Not implemented — current feed is read directly from Stream.io via the client SDK |

#### POST /api/communities/:slug/posts *(proposed)*

| Field | Value |
|-------|-------|
| **Purpose** | Create a post in the community feed |
| **Auth** | Authenticated (member) |
| **Status** | Not implemented — posts flow through Stream.io client SDK today |

#### POST /api/communities/:slug/invite *(proposed)*

| Field | Value |
|-------|-------|
| **Purpose** | Invite a user to a community |
| **Auth** | Authenticated (creator or admin) |
| **Status** | Not implemented — no `community_invites` table exists in the current schema |

---

## Community Resources

Community-scoped files and external links, distinct from `session_resources` (which is course/session-scoped). Two storage backends share one table — files live in R2 keyed by community + resource id; links store the URL in `external_url`. See `docs/as-designed/r2-storage.md` for the storage model, access-gate matrix, and the SSR `downloadUrl` pre-compute pattern.

### GET /api/me/communities/:slug/resources

| Field | Value |
|-------|-------|
| **Purpose** | List all resources in a community (admin/curation surface) |
| **Auth** | Community creator OR platform admin (`is_admin=1`) |
| **Tables** | `community_resources`, `communities`, `users` |
| **Order** | `is_pinned DESC, display_order ASC, created_at DESC` |
| **DB-SCHEMA** | [community_resources](DB-SCHEMA.md#community_resources) |

> **Note:** The member-facing list is delivered via SSR through `fetchCommunityDetailData` (`src/lib/ssr/loaders/communities.ts`), not this endpoint. This endpoint exists for the management UI.

---

### POST /api/me/communities/:slug/resources

| Field | Value |
|-------|-------|
| **Purpose** | Upload a file (multipart) OR add an external link (JSON) |
| **Auth** | Community creator OR platform admin — see `src/lib/permissions.ts::canUploadCommunityResources` |
| **Tables** | `community_resources` (insert), `communities` (lookup), `users` (admin check) |
| **Storage** | Cloudflare R2 (multipart path only) |
| **Discriminant** | `Content-Type: multipart/form-data` → file path; otherwise JSON link path |
| **File limits** | MIME allow-list + 50 MB max (`isAllowedFileType`, `MAX_FILE_SIZE`) |
| **Type** | Auto-derived from MIME (`image/audio/document`); creator may override via form field. JSON link path defaults to `'other'`. |
| **DB-SCHEMA** | [community_resources](DB-SCHEMA.md#community_resources) |

**Multipart fields:** `file` (required), `title` (defaults to file name), `description`, `is_pinned` (`'true'`/`'false'`), `type` (override).

**JSON body:** `{ title, external_url, description?, type?, is_pinned? }`.

---

### GET /api/me/communities/:slug/resources/:resourceId

| Field | Value |
|-------|-------|
| **Purpose** | Fetch a single resource (management surface) |
| **Auth** | Community creator OR platform admin |
| **Tables** | `community_resources` |
| **DB-SCHEMA** | [community_resources](DB-SCHEMA.md#community_resources) |

---

### PUT /api/me/communities/:slug/resources/:resourceId

| Field | Value |
|-------|-------|
| **Purpose** | Update resource metadata (title, description, type, pin, order, external_url) |
| **Auth** | Community creator OR platform admin |
| **Tables** | `community_resources` |
| **Note** | Body is a partial — only supplied fields are updated. The underlying R2 object is **not** replaced; this is metadata-only. |
| **DB-SCHEMA** | [community_resources](DB-SCHEMA.md#community_resources) |

---

### DELETE /api/me/communities/:slug/resources/:resourceId

| Field | Value |
|-------|-------|
| **Purpose** | Hard-delete resource row; best-effort R2 object cleanup if `r2_key` set |
| **Auth** | Community creator OR platform admin |
| **Tables** | `community_resources` (delete) |
| **Storage** | Cloudflare R2 (best-effort delete; failure logged but does not block DB delete) |
| **DB-SCHEMA** | [community_resources](DB-SCHEMA.md#community_resources) |

---

### GET /api/community-resources/:id/download

| Field | Value |
|-------|-------|
| **Purpose** | Stream a community resource file from R2 |
| **Auth** | Authenticated community member, OR community creator, OR platform admin (any one) |
| **Tables** | `community_resources`, `communities`, `community_members`, `users` |
| **Storage** | Cloudflare R2 (streamed via `r2.get()`; not signed URLs) |
| **Side effect** | Increments `download_count` (fire-and-forget) |
| **Headers** | `Content-Type` from stored `mime_type` (fallback `application/octet-stream`); `Content-Disposition: attachment; filename="<title>"`; `Cache-Control: private, max-age=3600` |
| **400** | Returned when the resource is link-only (`r2_key IS NULL`) — client should follow `external_url` directly |
| **403** | Community membership is required even for public communities (the `is_public` flag does NOT bypass this gate) |
| **DB-SCHEMA** | [community_resources](DB-SCHEMA.md#community_resources) |

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
| **Tables** | `courses`, `users`, `course_tags`, `tags`, `topics` |
| **Query** | `q`, `tag_id`, `status`, `level`, `featured`, `page`, `limit` |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses) |

---

### GET /api/admin/courses/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get course detail |
| **Auth** | Admin |
| **Tables** | `courses`, `users`, `enrollments`, `teacher_certifications`, `transactions` |
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
| **Tables** | `enrollments`, `users`, `courses`, `teacher_certifications` |
| **Query** | `q`, `course_id`, `status`, `teacher_assigned`, `from`, `to`, `page`, `limit` |
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
| **Purpose** | Create manual enrollment (bypasses payment, runs enrollment guards) |
| **Auth** | Admin |
| **Tables** | `enrollments`, `courses`, `teacher_certifications` |
| **DB-SCHEMA** | [enrollments](DB-SCHEMA.md#enrollments) |
| **Guards** | Creator self-enrollment blocked; duplicate active enrollment check relaxed (admin override); uses `checkEnrollmentGuards()` from `src/lib/enrollment-guards.ts` (Conv 008) |

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

### POST /api/admin/enrollments/:id/reassign-teacher

| Field | Value |
|-------|-------|
| **Purpose** | Reassign Teacher |
| **Auth** | Admin |
| **Tables** | `enrollments.assigned_teacher_id`, `enrollments.teacher_certification_id` |
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

### GET /api/admin/topics

| Field | Value |
|-------|-------|
| **Purpose** | List topics with tag counts |
| **Auth** | Admin |
| **Tables** | `topics`, `tags` (count) |
| **DB-SCHEMA** | [topics](DB-SCHEMA.md#topics), [tags](DB-SCHEMA.md#tags) |

---

### POST /api/admin/topics

| Field | Value |
|-------|-------|
| **Purpose** | Create topic |
| **Auth** | Admin |
| **Tables** | `topics` |
| **DB-SCHEMA** | [topics](DB-SCHEMA.md#topics) |

---

### GET /api/admin/topics/:id

| Field | Value |
|-------|-------|
| **Purpose** | Get topic details with tag count |
| **Auth** | Admin |
| **Tables** | `topics`, `tags` |
| **DB-SCHEMA** | [topics](DB-SCHEMA.md#topics) |

---

### PATCH /api/admin/topics/:id

| Field | Value |
|-------|-------|
| **Purpose** | Update topic |
| **Auth** | Admin |
| **Tables** | `topics` |
| **DB-SCHEMA** | [topics](DB-SCHEMA.md#topics) |

---

### DELETE /api/admin/topics/:id

| Field | Value |
|-------|-------|
| **Purpose** | Delete topic (only if no tags are in use) |
| **Auth** | Admin |
| **Tables** | `topics`, `tags` |
| **DB-SCHEMA** | [topics](DB-SCHEMA.md#topics) |

---

### POST /api/admin/topics/reorder

| Field | Value |
|-------|-------|
| **Purpose** | Reorder topics |
| **Auth** | Admin |
| **Tables** | `topics.display_order` |
| **DB-SCHEMA** | [topics](DB-SCHEMA.md#topics) |

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
