# POLICIES.md

This document defines **platform behavior policies** — the rules governing user capabilities, access control, and business logic. These are product decisions that guide implementation.

For architectural/implementation decisions, see `DECISIONS.md`. For docs-repo conventions, see `DOC-DECISIONS.md`.

**Last Updated:** 2026-03-29 Conv 056 (Member search restriction)

---

## How This Document Works

- **Prescriptive:** These policies define what the code SHOULD do. If code contradicts a policy, the code is the bug.
- **Organized by Domain:** Grouped by feature area (creators, payments, etc.)
- **Dates Included:** Each policy shows when it was established and which session
- **Latest Wins:** If a newer policy contradicts an older one, only the newer policy appears here

---

## 1. Creator Access Control

### Creator Permission vs Creator State
**Date:** 2026-03-01 (Session 319)

There are two distinct concepts for "is creator":

| Concept | Source | Meaning |
|---------|--------|---------|
| **Permission** (`can_create_courses` flag) | Set by admin approval | User MAY create courses |
| **State** (has existing courses) | Derived from data | User HAS created courses |

These are used differently depending on the action:

| Action Type | Gate | Rationale |
|-------------|------|-----------|
| **Create** new course or community | Permission only (`can_create_courses = 1`) | Only users with active permission can create new resources |
| **View/manage** dashboard, course list, earnings, communities, analytics | Permission OR State (`can_create_courses = 1 OR has_courses`) | Users must be able to access their existing content regardless of current permission status |

### Creator Revocation Policy
**Date:** 2026-03-01 (Session 319)

When an admin revokes a creator's permission (`can_create_courses = 0`):

- **Blocked:** Creating new courses, creating new communities
- **Retained:** Full access to existing courses and communities — viewing, editing, managing Teachers, viewing analytics, managing earnings, managing community moderators
- **Mechanism:** Existing course/community endpoints use ownership checks (Pattern D: `creator_id = userId`), which are unaffected by the permission flag

### Admin Course Creation for Users
**Date:** 2026-03-01 (Session 319)

When admin creates a course on behalf of a user (`POST /api/admin/courses`), the target user must have `can_create_courses = 1`. The admin cannot override this — they must first grant the permission, then create the course. This is an intentional safeguard against accidentally creating content for revoked creators.

### Creator Course Limit (Future)
**Date:** 2026-03-01 (Session 319)

New creators should have a default limit on total courses they can create (proposed default: 3). Admin can adjust the limit per user. This is tracked as deferred item COURSE-LIMIT in PLAN.md.

### Client-Side Creator Gate
**Date:** 2026-03-01 (Session 320)

All creator pages (`/creating/*`) use the `useCreatorGate` hook for client-side access checks before making API calls. The hook reads `CurrentUser` global state to determine creator access (Permission OR State — Pattern C), with stale-cache refresh as a fallback. Server-side API gates (Patterns A, B, C, D) remain the authoritative security enforcement layer. The client-side gate provides fast UX gating only — it prevents unnecessary API calls and shows consistent "Creator Access Required" UI across all creator pages.

**Components using the hook:**
- `CreatorDashboard` — `/creating`
- `CreatorStudio` — `/creating/studio`
- `CreatorAnalytics` — `/creating/analytics`
- `CreatorCommunities` — `/creating/communities`
- `CreatorEarningsDetail` — `/creating/earnings`

### Analytics Empty State
**Date:** 2026-03-01 (Session 319), updated Session 320

When a creator has zero courses, the analytics page (`/creating/analytics`) shows a friendly empty state with a link to create their first course, rather than firing analytics API calls that would return empty data. The `useCreatorGate` hook's `hasCourses` flag provides this check instantly from `CurrentUser` global state — no additional API call needed.

---

## 2. Email Sending

### Verified Sending Domain
**Date:** 2026-03-01 (Session 319)

All transactional email is sent from `Peerloop <noreply@send.peerloop.com>` via Resend. The sending domain is `send.peerloop.com` (verified subdomain), not the root `peerloop.com`. The from address is centralized in `src/lib/email.ts`.

See `docs/reference/resend.md` for domain setup details and the misleading error message caveat.

---

## 3. Session Cancellation & Reschedule

**Date:** 2026-03-11 (Session 375)

### Cancellation Policy

Per CD-033 ("The student can bail at anytime and get a refund"), session cancellation is **always allowed** for both students and Teachers. There is no hard block at any time.

**Notifications:** Both student and teacher receive in-app notifications and cancellation emails for every cancellation.

**Late cancellation (< 24 hours before session start):**
- A **reason is required** — the API returns 400 if no reason is provided
- The session is flagged with `is_late_cancel = 1` for admin visibility
- In-app notifications include "Late cancellation:" prefix
- `cancelled_at` timestamp is always recorded

**Normal cancellation (>= 24 hours before session start):**
- Reason is optional
- Both parties still receive in-app notifications and emails

**Who can cancel:** Student, Teacher, or Admin (any session participant).

### Reschedule Policy

The primary reschedule flow is **cancel-and-rebook**: the old session is cancelled, then a new one is booked. This resets the session identity (new session ID, fresh reschedule count).

**Reschedule vs cancellation (30-minute threshold):**
- If a new session is booked within **30 minutes** of cancelling the old one → treated as a **reschedule** → both parties receive "Session Rescheduled" notifications (showing old→new time)
- If no rebook within 30 minutes → treated as a standalone **cancellation**
- Detection: `POST /api/sessions` checks `cancelled_at` on the old session via `reschedule_session_id`

**Late-cancel penalty still applies to reschedules:** The unbooking part of a reschedule is subject to the same late-cancellation rules (< 24h → `is_late_cancel = 1`, reason required). The notification type changes ("rescheduled" vs "cancelled") but the penalty flag is set regardless.

**PATCH reschedule (legacy):**
- Maximum **2 reschedules per session** — the API returns 422 on the 3rd attempt
- `reschedule_count` is tracked per session
- The `can_reschedule` flag in `GET /api/sessions/:id` reflects whether the session can still be rescheduled (status = scheduled AND reschedule_count < 2)
- The booking UI uses cancel-and-rebook instead, which has no reschedule limit

### Rebooking Guard

Students cannot book new sessions for enrollments that are no longer active. `POST /api/sessions` returns 403 if `enrollment.status` is not `enrolled` or `in_progress` (i.e., rejects `completed`, `cancelled`, `disputed`).

### Module Completion Gating

The "Mark Complete" button on the Learn page is **disabled until the module's tutoring session is completed**. This prevents students from self-reporting module completion without attending the session.

**Button states:**
- No session booked → disabled, shows "Book a session first" (linked to booking page)
- Session scheduled → disabled, shows "Session scheduled for [date]"
- Session completed → enabled

See `docs/as-designed/session-booking.md` for implementation details.

### Session Completion Healing

If the BBB `room_ended` webhook fails to fire, sessions can be manually marked complete:

**Who can complete a session:**
- The session's **teacher** (`teacher_id`)
- The course **creator** (`creator_id`)
- An **admin** (via admin PATCH endpoint)

**Guards:**
- Session must be `in_progress` or `scheduled`
- Session's `scheduled_end` must be in the past (no premature completion)
- Idempotent — safe to call if session is already completed

**What happens on completion:**
- Status set to `completed`, `ended_at` timestamp written
- `module_id` frozen via positional module assignment (same logic as BBB webhook)
- Sequential completion enforced: if earlier sessions are still scheduled, `module_id` is set to NULL

**Students cannot complete sessions** — this would let a no-show student get `completed` status (with module credit) instead of `no_show`. Students who encounter a stuck session see an inline message form to notify their teacher. *(Conv 025 decision)*

**Batch cleanup:** `POST /api/admin/sessions/cleanup` (admin) runs `detectNoShows()` + `detectStaleInProgress()` to catch sessions missed by all other paths. *(Conv 025)*

**Endpoint:** `POST /api/sessions/[id]/complete` (teacher/creator), `PATCH /api/admin/sessions/[id]` (admin), `POST /api/admin/sessions/cleanup` (admin batch)

**See:** `src/lib/booking.ts` (`completeSession`, `detectNoShows`, `detectStaleInProgress`)

---

## 4. Direct Messaging

**Date:** 2026-03-05 (Session 338)

### Principle

Direct messaging requires **authentication** plus a **platform relationship** between the two users. Unrestricted open messaging is deferred post-MVP (requires abuse prevention design per US-S017).

### Messaging Relationships (Who Can Message Whom)

| Sender Role | Can Message | Relationship Check |
|-------------|------------|-------------------|
| Student | Their assigned Teacher | `enrollments.assigned_teacher_id` matches recipient, enrollment active |
| Student | Course creator | Active enrollment in a course where `courses.creator_id` = recipient |
| Student | Any Admin | Recipient has `is_admin = 1` (support channel, US-S018) |
| Teacher | Their assigned students | `enrollments.assigned_teacher_id` matches sender, enrollment active |
| Teacher | Course creator (certifier) | `teacher_certifications` row for a course where `courses.creator_id` = recipient |
| Teacher | Any Admin | Recipient has `is_admin = 1` |
| Creator | Their Teachers | Active `teacher_certifications` row for a course owned by sender |
| Creator | Enrolled students | Active enrollment in a course owned by sender |
| Creator | Any Admin | Recipient has `is_admin = 1` |
| Admin | Anyone | No relationship required |
| Global Moderator | Anyone | No relationship required (moderation support) |

**Blocked for MVP:**
- Student <-> Student (US-S017, P2 -- "tricky, needs abuse prevention design")
- Any user -> unrelated user with no platform relationship

### Enforcement Layers

**Layer 1 -- UX (visibility):** "Message" buttons only appear where a valid relationship exists. This is UX polish, not a security boundary.

**Layer 2 -- API (authoritative):** Three endpoints enforce the policy server-side:

| Endpoint | Enforcement |
|----------|-------------|
| `GET /api/users/search` | Return only users the requester has a messaging relationship with |
| `POST /api/conversations` | Validate relationship before creating; return 403 if none exists |
| `POST /api/conversations/:id/messages` | Validate active relationship before sending; return 403 if ended |

**Layer 2 is the security boundary.** If layers disagree, Layer 2 wins.

### Existing Conversations

If a relationship ends (enrollment cancelled, Teacher deactivated), existing conversations **remain readable** but new messages **cannot be sent**. `POST /api/conversations/:id/messages` returns 403 with message "Messaging relationship no longer active."

### Self-Messaging

Users cannot create conversations with themselves. `POST /api/conversations` returns 400. (Already implemented.)

### Rate Limiting (Deferred)

Deferred for MVP. Genesis Cohort (60-80 students) is small enough that abuse is manageable through admin oversight. Post-MVP: implement per-user message rate limits and consider student-to-student messaging (US-S017).

**See:** `docs/as-designed/messaging.md` for implementation surface catalog and phased rollout plan.

---

## 5. Enrollment Access Control

### Enrollment Guards

The checkout flow (`POST /api/checkout/create-session`) enforces these guards before creating a Stripe session:

| Guard | Action | Rationale |
|-------|--------|-----------|
| Creator self-enrollment | **Block** (400) | Creator cannot pay themselves |
| Active teacher self-enrollment | **Block** (400) | Teacher already has course access |
| Duplicate active enrollment | **Block** (400) | One active enrollment per student+course |
| Zero teachers for course | **Block** (400) + notify creator & admins | Nobody to teach the student |
| Teachers exist but no availability in window | **Warn only** (allow enrollment) | Availability is dynamic — may change |

"Active teacher" means `is_active=1` AND `teaching_active=1`. Deactivated or paused teachers are treated as regular students and **can** enroll.

### Re-Enrollment After Completion

Students can retake a completed course. The completed enrollment row is retained as history; a new enrollment row is created. The EnrollButton shows a "Retake Course" button with a confirmation dialog showing the completion date.

A partial unique index on `enrollments(student_id, course_id) WHERE status IN ('enrolled', 'in_progress')` enforces at most one active enrollment at the database level.

### No-Teachers Notification

When a student is blocked from enrolling because a course has zero active teachers, the system sends `course_no_teachers` notifications to:
1. The course creator
2. All platform admins

### Pre-Purchase Availability Preview

The course detail page shows an availability summary for all active teachers within a configurable window (default 30 days, stored in `platform_stats.availability_window_days`). Shows slot counts and next-available dates. Authenticated users are excluded from the teacher list (teachers don't see themselves). The endpoint is public — no auth required.

---

## 6. Video Session Recordings

### Webcam Storage
**Date:** 2026-03-27 (Conv 037, CD-038)

Blindside Networks stores only the **instructor's (Teacher's) webcam** in session recordings. Student webcams are not recorded.

| Setting | Value | Rationale |
|---------|-------|-----------|
| Webcam storage | Instructor-only | Student privacy — students may include minors; reduces file size |
| Configured by | Blindside Networks (account-level setting) | Not an API parameter — must be requested from vendor |

**Action required:** Contact Blindside Networks to enable instructor-only webcam storage on the Peerloop account.

### Recording Persistence
**Date:** 2026-03-27 (Conv 037, CD-038)

Recordings are downloaded from Blindside Networks and persisted to Cloudflare R2. BBB recordings on Blindside's servers are treated as ephemeral — R2 is the long-term store.

| Policy | Value | Rationale |
|--------|-------|-----------|
| Format | `.m4v` (MPEG-4 Video) | Provided by Blindside Networks |
| Max file size | No limit | Instructor-only webcam keeps files small (~50–200MB/hour); R2 has no per-object limit |
| Download strategy | Best-effort, async | Triggered by `rap-publish-ended` webhook; BBB URL remains as fallback on failure |
| Retention | Indefinite (R2) | No automatic deletion; admin can manage manually |

### Recording Monitoring
**Date:** 2026-03-27 (Conv 037)

Recording file sizes are stored in `sessions.recording_size_bytes` for admin monitoring. Admins can query total storage usage and identify failed downloads across sessions.

---

## 7. Page Authentication
**Date:** 2026-03-29 (Conv 053)

### Route Classification

All pages fall into one of four tiers:

| Tier | Auth Required | Examples |
|------|:------------:|---------|
| **Public-static** | No | `/login`, `/register`, `/forgot-password` |
| **Public-browsable** | No (optional auth enhances UX) | `/discover/*`, `/course/[slug]`, `/community/[slug]`, `/@[handle]` |
| **Member-only** | Yes | `/dashboard`, `/learning`, `/teaching`, `/admin/*`, `/settings/*`, `/community` (index), `/courses` (index) |
| **Role-gated** | Yes + role check | `/admin/*` (admin), `/creating/*` (creator permission/state) |

### Enforcement

**Middleware** (`src/middleware.ts`) enforces **authentication** for member-only and role-gated routes. Unauthenticated visitors are redirected to `/login?redirect=<original-path>`.

**Pages and API endpoints** enforce **authorization** (role checks, enrollment verification, ownership). The middleware never queries the database.

### Onboarding

Onboarding is a UX concern, not a security concern:
- OAuth callbacks redirect fresh users to `/onboarding` as a first-touch nudge
- Middleware does **not** enforce onboarding completion
- Users who skip onboarding get a degraded experience (no personalized recommendations)
- Pages using interests should show component-level nudges with a link to `/settings/interests`

### Client-Side State Tampering

Tampering with `window.__peerloop.currentUser` in the browser console is **cosmetic only, not a security risk**:
- httpOnly JWT cookies are inaccessible to JavaScript
- Every API call validates auth via the JWT cookie, not client state
- Client-side defenses (hashing, checksums) are bypassable by the browser and provide no real security
- The security perimeter is the server, not the client

---

## 8. Member Search & Discovery
**Date:** 2026-03-29 (Conv 056)

### Member-to-Member Search Restriction

**Client directive:** Members cannot search for other members at launch. There is no member search or member directory accessible to non-admin users.

| Actor | Can Search Members? | Mechanism |
|-------|:------------------:|-----------|
| Admin | Yes | `/discover/members` — admin-only page with role filters and name search |
| Non-admin member | No | Page hidden from navigation; route requires admin role |
| Visitor | No | Route requires authentication + admin role |

### Rationale

The client has explicitly prohibited member-to-member search for launch. This is a privacy/safety decision — members interact through structured relationships (enrollments, communities, teaching assignments), not open discovery. Admin retains full member visibility for platform operations.

### Future Consideration

Post-MVP, member discovery may be opened with appropriate safeguards (abuse prevention, opt-in visibility). See also §4 Direct Messaging for the related messaging relationship policy.
