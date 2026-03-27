# Session Booking Flow

**Created:** Session 325
**Updated:** Session 334 (session completion healing — shared completeSession(), manual complete endpoint)
**Status:** Implemented — booking, module assignment, session limits all live

## Overview

Session booking is the process by which a student schedules 1-on-1 tutoring sessions with their assigned Teacher. The system currently handles single-session booking through a multi-step wizard.

## Current Implementation

### Booking Wizard (`SessionBooking.tsx`)

A 4-step React component:

```
Step 1: Teacher  →  Step 2: Date  →  Step 3: Time  →  Step 4: Confirm
```

**Props received from page:**
- `course` — course ID, title, slug, sessionCount
- `enrollmentId` — the student's enrollment
- `teachers` — list of eligible Teachers for this course
- `preSelectedTeacherId` — skips step 1 if provided

**Step flow:**
1. **Teacher** — Select from list of active Teachers (skipped if pre-selected)
2. **Date** — Calendar month view, pick a date with available slots
3. **Time** — Choose from available time slots on that date
4. **Confirm** — Review summary, click Confirm Booking

### Availability Data

The wizard fetches `GET /api/teachers/:id/availability` with a 4-week lookahead. This returns time slots generated from the teacher's recurring rules + overrides, with existing bookings marked as conflicts. See `docs/as-designed/availability-calendar.md` for full details.

**Availability re-fetches when:**
- Teacher is selected (step 1 → 2)
- User navigates back to the date step (Session 325 fix)

### Session Creation API

`POST /api/sessions` validates and creates the session.

**Validation chain:**
1. Authentication required
2. Required fields: `enrollment_id`, `teacher_id`, `scheduled_start`, `scheduled_end`
3. Date validation (not in past, end after start)
4. Enrollment exists and belongs to the user
5. **Teacher matches enrollment's assigned Teacher** (Session 325 — prevents booking a different teacher)
6. Teacher is an active Teacher for the course
7. **Session limit** — 422 if `completed + scheduled >= module count` (Session 331)
8. No teacher time conflict (409 if teacher already booked)
9. No student time conflict (409 if student already booked)

**On success:** Creates session with status `scheduled`, sends notifications and email. Response includes computed module info (which module the new session will cover).

### Conflict Handling

If the API returns a 409 conflict at confirm time (race condition between users), the error displays and the Confirm button is disabled. The user must click Back to re-select a time slot, which triggers a fresh availability fetch.

## Data Model

### Sessions Table

```sql
sessions (
  id TEXT PRIMARY KEY,
  enrollment_id TEXT NOT NULL → enrollments(id),
  teacher_id TEXT NOT NULL → users(id),
  student_id TEXT NOT NULL → users(id),
  scheduled_start TEXT NOT NULL,
  scheduled_end TEXT NOT NULL,
  started_at TEXT,
  ended_at TEXT,
  duration_minutes INTEGER,
  status TEXT ('scheduled', 'in_progress', 'completed', 'cancelled', 'no_show'),
  module_id TEXT → course_curriculum(id),   -- nullable: NULL while scheduled/in_progress, set on completion
  bbb_meeting_id TEXT,
  recording_url TEXT,
  cancelled_by_user_id TEXT → users(id),
  cancel_reason TEXT,
  created_at TEXT
)
```

### Key Relationships

```
enrollment (paid for course, assigned to Teacher)
  ├── student_id → users(id)
  ├── course_id → courses(id)
  ├── assigned_teacher_id → users(id)   ← teacher_id must match this
  └── sessions[] (1:many)
        ├── teacher_id must = enrollment.assigned_teacher_id
        └── student_id must = enrollment.student_id
```

## Guards & Constraints

| Guard | Where | What it prevents |
|-------|-------|-----------------|
| Teacher matches enrollment | API (POST /api/sessions) | Booking a teacher you're not assigned to |
| Session limit (422) | API (POST /api/sessions) | Booking more sessions than course modules |
| Teacher time conflict (409) | API (POST /api/sessions) | Double-booking a teacher |
| Student time conflict (409) | API (POST /api/sessions) | Double-booking yourself |
| Sequential completion | `completeSession()` in booking.ts | Out-of-order completion skips module_id |
| Manual completion (healing) | API (POST /api/sessions/:id/complete) | Teacher/creator bypass for failed webhook |
| Premature completion | API (POST /api/sessions/:id/complete) | Cannot complete before scheduled_end |
| Stale slot detection | UI (availability re-fetch) | Selecting already-booked slots |
| Confirm button disabled on error | UI (SessionBooking.tsx) | Submitting after conflict detected |

## File Map

```
src/
├── lib/
│   └── booking.ts                  # resolveModuleAssignments() + completeSession() — shared logic
├── components/booking/
│   └── SessionBooking.tsx          # Multi-step booking wizard
├── pages/
│   ├── api/sessions/
│   │   ├── index.ts                # GET (list) + POST (create) with session limit
│   │   ├── [id]/index.ts           # GET (detail) with computed module info
│   │   └── [id]/complete.ts        # POST — manual completion healing (teacher/creator)
│   ├── api/webhooks/
│   │   └── bbb.ts                  # room_ended → calls completeSession()
│   ├── api/admin/sessions/
│   │   └── [id].ts                 # PATCH status=completed → calls completeSession()
│   ├── api/teachers/[id]/
│   │   └── availability.ts         # GET expanded slots for booking
│   └── course/[slug]/book.astro    # Booking page wrapper
```

## Test Coverage

| Test File | Count | Covers |
|-----------|-------|--------|
| `tests/lib/booking.test.ts` | 25 | Positional algorithm, reflow, eligibility, backfill, enrollment completion, post-session actions |
| `tests/api/sessions/index.test.ts` | 17 | Session creation, validation, conflicts, session limits |
| `tests/api/webhooks/bbb.test.ts` | 14 | BBB events, module_id on completion, sequential validation |
| `tests/api/teachers/[id]/availability.test.ts` | 15 | Availability slots, conflicts |
| `tests/integration/session-lifecycle.test.ts` | 15 | End-to-end session flow |

## Prior Decisions

### Schedule Later (CD-033, Dec 2024)

Students can book their first session at enrollment time OR skip and book later from their dashboard. The client stated: "They can purchase the course, get access to the course feed and find a student teacher in the feed. But they can schedule at time of payment or after."

- Feature F-SBOK-004 ("Schedule Later option") is MVP-scoped but **deferred to post-MVP** (Session 259)
- Current implementation requires booking at enrollment; "Schedule Later" not yet built

### Refund Policy (CD-033)

"The student can bail at anytime and get a refund. The pressure is on the student teacher to earn his pay." This implies sessions need clean cancellation tracking for refund calculations.

### Cancel/Reschedule — Not in Block 1 (CD-030)

Cancellation and rescheduling are **not in Block 1 MVP**. The interim workaround is "contact Teacher or Creator directly." Related user stories:
- US-S013: "As a Student, I need to reschedule a session" (P1, not MVP)
- US-S014: "As a Student, I need to cancel a session" (P1, not MVP)

### Availability is Per-Person, Not Per-Course (Sessions 287-289)

A teacher has one calendar across all courses they teach. Per-course opt-in/out is handled by the `teaching_active` toggle on `teacher_certifications`. Rationale: a person can't be in two sessions simultaneously. See `docs/as-designed/availability-calendar.md`.

### Session Limit Now Enforced (Session 331)

`POST /api/sessions` rejects 422 when `completed + scheduled >= course curriculum count`. The limit is derived from `course_curriculum` rows (not `courses.session_count`), so it's always in sync with actual modules. Cancelled sessions free slots.

### Source Documents

| Document | Key content |
|----------|-------------|
| `docs/requirements/client-docs/CD-033-slack-st-pricing-clarification.md` | Schedule Later decision, refund policy |
| `docs/requirements/client-docs/CD-030-block-1-actor-stories.md` | Block 1 scope, cancel/reschedule deferred |
| `docs/requirements/stories/stories-S-student.md` | US-S013 (reschedule), US-S014 (cancel) |
| `docs/DECISIONS.md` (Sessions 287-289) | Per-person availability, teaching_active toggle |

## Positional Module Assignment (Implemented — Session 331-332)

### How It Works

Modules are NOT stored at booking time. Instead, module assignment is **computed positionally** from the chronological order of sessions against the course curriculum.

**Core rule:** Sort an enrollment's non-cancelled sessions by `scheduled_start ASC`. The Nth session teaches the Nth module (by `module_order`). Sessions with a non-null `module_id` are "frozen" (historical); all others are computed dynamically.

**Lifecycle:**
1. **Booking** — session created with `module_id = NULL`, computed module shown in response
2. **In progress** — `module_id` still NULL, positionally computed at read time
3. **Completion** — `completeSession()` writes computed `module_id` to the row (frozen). Triggered by: BBB `room_ended` webhook, teacher/creator manual complete (`POST /api/sessions/:id/complete`), or admin PATCH
4. **Cancellation** — remaining scheduled sessions reflow automatically

### Why Positional (Not Stored at Booking)

If a student cancels session 2 of 3, sessions shift which module they cover — maintaining sequential order automatically. Storing `module_id` at booking time would go stale on every cancellation.

### Session Limits (Implemented)

`POST /api/sessions` enforces: `completed + scheduled >= course curriculum count` → 422. Cancelled sessions free slots.

### Sequential Completion (Implemented — Session 332)

`completeSession()` checks for earlier `scheduled` sessions before writing `module_id`:
- **In order** → `module_id` written (frozen)
- **Out of order** (earlier sessions still scheduled) → session marked `completed` but `module_id = NULL` (warning logged)

This preserves the positional invariant. The guard only affects whether `module_id` gets frozen — the session is always marked completed.

### Session Completion Healing (Implemented — Session 334)

All session completion flows use the shared `completeSession(db, sessionId, endedAt?)` function in `src/lib/booking.ts`. This function is idempotent and handles sequential completion checks, module_id freezing, and timestamp writing.

**Three callers:**
1. **BBB webhook** (`room_ended` event) — automatic, real-time
2. **Manual endpoint** (`POST /api/sessions/:id/complete`) — teacher or course creator, after `scheduled_end` has passed
3. **Admin PATCH** (`PATCH /api/admin/sessions/:id` with `status: "completed"`) — admin override

**Why needed:** BBB webhooks are inherently unreliable (network failures, service outages). Without a fallback, sessions stuck in `in_progress` block module completion and future bookings.

### Key Functions in `src/lib/booking.ts`

**`resolveModuleAssignments()`** — Single source of truth for all module-to-session mappings. Used by:
- Booking API (session limit + next module in response)
- Session detail/list endpoints (module context)
- `completeSession()` (freeze module_id on completion)
- Booking wizard (show next module, remaining slots)

**Returns:** `ModuleAssignmentSummary` with sessions (each with module info + `is_frozen`), counts, and `next_module`.

**`completeSession()`** — Shared idempotent function for all session completion paths. Handles status transition, sequential completion check, module_id freezing, ended_at timestamp, module backfill, enrollment completion check, and post-session actions. Returns `CompleteSessionResult` with `already_completed` flag for safe concurrent calls.

**`backfillModuleIds()`** — After a session completes in order, scans for later completed sessions with `module_id = NULL` (from out-of-order completion) and resolves their modules. Only backfills when all earlier sessions are completed/cancelled/no_show. (Conv 026)

**`checkEnrollmentCompletion()`** — Checks if all modules have a completed session with a frozen `module_id`. If so, sets `enrollment.status = 'completed'`, `completed_at`, and `progress_percent = 100`. Returns `true` if just completed (not if already completed). (Conv 026)

**`triggerPostSessionActions()`** — Non-blocking post-completion actions: sends `session_completed` notifications to both participants, increments `sessions_completed` in `user_stats` for both, and on enrollment completion: increments `courses_completed` (student) + `students_taught` (teacher) + sends `enrollment_completed` notifications. (Conv 026)

### Module Backfill (Implemented — Conv 026)

When session 2 completes before session 1 (out of order), session 2 gets `module_id = NULL` (sequential guard). When session 1 later completes, `backfillModuleIds()` detects session 2's NULL and resolves the correct module positionally.

**Trigger:** Called automatically inside `completeSession()` after freezing the current session's module_id.

**Guard:** Only backfills a session when ALL earlier sessions (by `scheduled_start`) are in a terminal state (`completed`, `cancelled`, `no_show`). This prevents premature assignment.

### Enrollment Auto-Completion (Implemented — Conv 026)

When the final session of a course completes, the enrollment is automatically marked `completed`:

1. `completeSession()` freezes module_id (+ backfills any NULL modules)
2. `checkEnrollmentCompletion()` counts distinct `module_id` values on completed sessions
3. If count >= total modules in curriculum → `enrollment.status = 'completed'`
4. `triggerPostSessionActions()` increments `courses_completed` / `students_taught` stats and sends `enrollment_completed` notifications

**Notifications:** Both student and teacher receive in-app `enrollment_completed` notification with a link to the course page.

### Post-Session Actions (Implemented — Conv 026)

Every `completeSession()` call triggers `triggerPostSessionActions()` asynchronously (non-blocking — failures don't break completion):

1. **Completion notifications** — `session_completed` to both student and teacher (prompts rating)
2. **Stats update** — `user_stats.sessions_completed` incremented for both participants (upsert)
3. **Enrollment completion** (conditional) — if `checkEnrollmentCompletion()` returned true:
   - `user_stats.courses_completed` incremented for student
   - `user_stats.students_taught` incremented for teacher
   - `enrollment_completed` notifications to both

### Decision Reference

See `docs/DECISIONS.md` → "Positional Module Assignment for Sessions" for rationale.

---

## Instant Session Invites (Teacher-Initiated)

Teachers can bypass the traditional booking wizard by sending an instant session invite from `/teaching/students`. The invite creates a session starting 5 minutes from acceptance, with the join window immediately open.

**Full details:** See `docs/architecture/session-room.md` → "Session Invites" section, including a step-by-step walkthrough from both teacher and student perspectives.

### Course Sessions Tab Display (Conv 025)

The `/course/{slug}/sessions` tab (`course-tabs/SessionsTabContent.tsx`) renders sessions grouped by status:

| Section | Statuses | Style |
|---------|----------|-------|
| **In Progress** | `in_progress` | Green border, pulsing video icon, "Rejoin" button |
| **Upcoming** | `scheduled` | Join/Details button (join enabled 15min before start) |
| **Completed** | `completed` | Green check, optional recording link |
| **Cancelled** | `cancelled` | Dimmed, "Cancelled" label |
| **Missed** | `no_show` | Amber warning icon, dimmed |

All five schema-defined statuses are handled. Sessions from both the booking wizard and instant invites appear identically — the display is status-driven, not creation-method-driven.

---

## Open Design Questions

### 1. Multi-Session Sequential Booking (Future)

After confirming one session, offer "Book Next Session" alongside "Done". The next module is already computed by `resolveModuleAssignments()`. Small UI-only change on the success screen.

### 2. Mark Complete Gated on Session Completion (Future)

Mark Complete on the Learn page should be disabled until the module's session is `completed`. The backend data (`resolveModuleAssignments`) already supports this query.

**UI behavior:**
- Module has no session booked → Mark Complete disabled, hint: "Book a session first"
- Module has session `scheduled` → Mark Complete disabled, hint: "Session scheduled for [date]"
- Module has session `completed` → Mark Complete enabled
- Module has session `cancelled` → Mark Complete disabled, student must rebook

### 3. Rebooking Guards for Completed/Dropped Enrollments (Future)

~~No guard prevents booking sessions after enrollment status = `completed` or `dropped`.~~ **Resolved (Session 333):** `POST /api/sessions` rejects if `enrollment.status` not in `('enrolled', 'in_progress')` → 403.

### 4. ~~Rescheduling Flow (P1, not MVP)~~ — Resolved (Session 333)

**Cancellation Policy (US-S014):**
- Cancellation always allowed (per CD-033: "bail at anytime")
- `cancelled_at` timestamp saved on every cancellation
- Late cancellation (< 24h before start) requires a reason → 400 if missing
- Late cancellations flagged with `is_late_cancel = 1` for admin visibility
- Teacher receives in-app notification with the student's reason

**Reschedule Policy (US-S013):**
- `PATCH /api/sessions/:id` reschedules (already existed)
- Max 2 reschedules per session (`reschedule_count` tracked) → 422 on 3rd attempt
- `can_reschedule` flag returned in GET session detail

**Schema additions:** `cancelled_at TEXT`, `is_late_cancel INTEGER DEFAULT 0`, `reschedule_count INTEGER DEFAULT 0` on `sessions` table. `session_cancelled` notification type added.

## Session 325 Fixes

1. **Stale availability bug** — `useEffect` dependency array was missing `step`, so availability wasn't re-fetched when navigating back. Fixed by adding `step` to deps.
2. **Confirm button active on error** — Confirm button remained clickable after a conflict error. Fixed by disabling when `error` is set.
3. **Teacher mismatch guard** — API had no check that `teacher_id` matched `enrollment.assigned_teacher_id`. Added 403 guard.

## References

- `docs/as-designed/availability-calendar.md` — Availability system (rules, overrides, merge algorithm)
- `docs/as-designed/run-001/_features-block-4.md` — Block 4 feature specs (SBOK, SROM)
- `docs/DECISIONS.md` — Session 292 (rating tiers), Session 324 (enrollment FK), Session 331-332 (positional module assignment), Session 334 (completion healing)
