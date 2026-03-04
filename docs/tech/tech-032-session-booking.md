# tech-032: Session Booking Flow

**Created:** Session 325
**Status:** Current implementation + open design questions

## Overview

Session booking is the process by which a student schedules 1-on-1 tutoring sessions with their assigned Student-Teacher. The system currently handles single-session booking through a multi-step wizard.

## Current Implementation

### Booking Wizard (`SessionBooking.tsx`)

A 4-step React component:

```
Step 1: Teacher  →  Step 2: Date  →  Step 3: Time  →  Step 4: Confirm
```

**Props received from page:**
- `course` — course ID, title, slug, sessionCount
- `enrollmentId` — the student's enrollment
- `teachers` — list of eligible STs for this course
- `preSelectedTeacherId` — skips step 1 if provided

**Step flow:**
1. **Teacher** — Select from list of active STs (skipped if pre-selected)
2. **Date** — Calendar month view, pick a date with available slots
3. **Time** — Choose from available time slots on that date
4. **Confirm** — Review summary, click Confirm Booking

### Availability Data

The wizard fetches `GET /api/student-teachers/:id/availability` with a 4-week lookahead. This returns time slots generated from the teacher's recurring rules + overrides, with existing bookings marked as conflicts. See `tech-031-availability-calendar.md` for full details.

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
5. **Teacher matches enrollment's assigned ST** (Session 325 — prevents booking a different teacher)
6. Teacher is an active ST for the course
7. No teacher time conflict (409 if teacher already booked)
8. No student time conflict (409 if student already booked)

**On success:** Creates session with status `scheduled`, sends notifications and email.

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
  bbb_meeting_id TEXT,
  recording_url TEXT,
  cancelled_by TEXT → users(id),
  cancel_reason TEXT,
  created_at TEXT
)
```

### Key Relationships

```
enrollment (paid for course, assigned to ST)
  ├── student_id → users(id)
  ├── course_id → courses(id)
  ├── student_teacher_id → users(id)   ← teacher_id must match this
  └── sessions[] (1:many)
        ├── teacher_id must = enrollment.student_teacher_id
        └── student_id must = enrollment.student_id
```

## Guards & Constraints

| Guard | Where | What it prevents |
|-------|-------|-----------------|
| Teacher matches enrollment | API (POST /api/sessions) | Booking a teacher you're not assigned to |
| Teacher time conflict | API (POST /api/sessions) | Double-booking a teacher |
| Student time conflict | API (POST /api/sessions) | Double-booking yourself |
| Stale slot detection | UI (availability re-fetch) | Selecting already-booked slots |
| Confirm button disabled on error | UI (SessionBooking.tsx) | Submitting after conflict detected |

## File Map

```
src/
├── components/booking/
│   └── SessionBooking.tsx          # Multi-step booking wizard
├── pages/
│   ├── api/sessions/
│   │   └── index.ts                # GET (list) + POST (create) sessions
│   ├── api/student-teachers/[id]/
│   │   └── availability.ts         # GET expanded slots for booking
│   └── course/[slug]/book.astro    # Booking page wrapper
```

## Test Coverage

| Test File | Count | Covers |
|-----------|-------|--------|
| `tests/api/sessions/index.test.ts` | 17 | Session creation, validation, conflicts, teacher matching |
| `tests/api/student-teachers/[id]/availability.test.ts` | 15 | Availability slots, conflicts |
| `tests/integration/session-lifecycle.test.ts` | — | End-to-end session flow |

## Prior Decisions

### Schedule Later (CD-033, Dec 2024)

Students can book their first session at enrollment time OR skip and book later from their dashboard. The client stated: "They can purchase the course, get access to the course feed and find a student teacher in the feed. But they can schedule at time of payment or after."

- Feature F-SBOK-004 ("Schedule Later option") is MVP-scoped but **deferred to post-MVP** (Session 259)
- Current implementation requires booking at enrollment; "Schedule Later" not yet built

### Refund Policy (CD-033)

"The student can bail at anytime and get a refund. The pressure is on the student teacher to earn his pay." This implies sessions need clean cancellation tracking for refund calculations.

### Cancel/Reschedule — Not in Block 1 (CD-030)

Cancellation and rescheduling are **not in Block 1 MVP**. The interim workaround is "contact S-T or Creator directly." Related user stories:
- US-S013: "As a Student, I need to reschedule a session" (P1, not MVP)
- US-S014: "As a Student, I need to cancel a session" (P1, not MVP)

### Availability is Per-Person, Not Per-Course (Sessions 287-289)

A teacher has one calendar across all courses they teach. Per-course opt-in/out is handled by the `teaching_active` toggle on `student_teachers`. Rationale: a person can't be in two sessions simultaneously. See `tech-031-availability-calendar.md`.

### Session Count is Informational (Current)

`courses.session_count` tells students how many sessions are included in the course but is **not enforced** in the booking API. No hard limit prevents booking more sessions than the course specifies.

### Source Documents

| Document | Key content |
|----------|-------------|
| `research/client-docs/CD-033-slack-st-pricing-clarification.md` | Schedule Later decision, refund policy |
| `research/client-docs/CD-030-block-1-actor-stories.md` | Block 1 scope, cancel/reschedule deferred |
| `research/stories/stories-S-student.md` | US-S013 (reschedule), US-S014 (cancel) |
| `DECISIONS.md` (Sessions 287-289) | Per-person availability, teaching_active toggle |

## Open Design Questions

### 1. Booking Flow — Target Design (Session 325)

Each booked session is tied to a specific module. The booking flow presents unbooked modules in order.

**Single session booking:**
- Student selects a course from My Courses
- Teacher is already known (from enrollment) — skip teacher selection
- Go directly to availability/calendar for the next unbooked module
- Wizard shows which module is being booked (e.g., "Booking: Module 3 — Advanced Workflow Patterns")

**Multi-session booking (sequential):**
- After confirming one session, the success screen offers "Book Next Session" alongside "Done"
- "Book Next Session" advances to the next unbooked module and returns to the availability screen
- The module is obvious — it's the next one in order that hasn't been booked
- Student can keep booking until all modules are scheduled or they choose "Done"

**Module ordering:**
- Modules are presented for booking in `module_order` sequence
- Only modules without a `scheduled` or `completed` session are offered
- Cancelled sessions free up the module for rebooking

**Cancellation & refunds (future):**
- If a student is unhappy, they will be able to cancel booked sessions
- Cancellation should entitle a partial refund proportional to undelivered sessions
- Cancellation policy details (timing, refund calculation) are deferred — see CD-033 refund policy: "The student can bail at anytime and get a refund"
- Related: US-S013 (reschedule), US-S014 (cancel) — P1, not MVP

### 2. Sessions Must Link to Modules (Schema Change Required)

**Problem:** The `sessions` table has no `module_id` column. There is no way to know which module a booked session covers. This affects:
- **Students** don't know which module they're booking a session for
- **Teachers** don't know which module to teach in each session
- **Module completion** can't be gated on session completion (Mark Complete button)
- **Progress tracking** is disconnected from actual tutoring sessions

**Current schema gap:**
```
sessions table:        enrollment_id, teacher_id, student_id, scheduled_start...
                       ← NO module_id or session_number

course_curriculum:     session_number, module_order, title...
                       ← NOT referenced by sessions
```

**Required change:** Add `module_id TEXT REFERENCES course_curriculum(id)` to `sessions`.

**Impact across the system:**

| Area | Change needed |
|------|--------------|
| **Schema** | Add `module_id` to `sessions` table |
| **Booking wizard** | Show which module is being booked ("Book Session for Module 1: Automation Fundamentals") |
| **Booking API** | Accept and validate `module_id`, prevent duplicate booking for same module |
| **Session room** | Show module title so teacher knows what to teach |
| **Teacher dashboard** | Show module info for upcoming sessions |
| **Learn page** | Gate Mark Complete on module's session being `completed` |
| **Progress sidebar** | Show which modules have sessions booked vs completed vs not yet booked |

**Ties into:** Open questions 1 (multi-session booking), 3 (rescheduling), and 5 (session limits).

### 3. Session Limits per Enrollment (renumbered)

No current guard prevents booking unlimited sessions against one enrollment. The `session_count` on the course is not enforced.

**Questions:**
- Should the API reject bookings when `sessions_booked >= course.session_count`?
- How to count: all sessions, or only `scheduled` + `completed` (excluding `cancelled`)?

### 4. Rescheduling Flow

Currently there is no explicit reschedule flow. A student would need to cancel a session and then book a new one.

**Questions:**
- Should there be a dedicated reschedule action (cancel + rebook in one flow)?
- Cancellation policy — how close to the scheduled time can a student cancel?
- Should cancelled sessions count toward the session limit?

### 5. Rebooking After Course Completion

No guard currently prevents booking sessions after the enrollment is marked `completed`.

**Questions:**
- Should the API reject bookings for completed enrollments?
- What about enrollments with status `cancelled` or `dropped`?

### 6. Mark Complete Gated on Session Completion

The "Mark Complete" button on the Learn page currently allows students to self-report module completion at any time (per CD-030: "Progress tracking: Self-reported checkboxes"). Once `module_id` is added to `sessions`, Mark Complete should be **disabled until the module's session is completed**.

**Dependency:** Requires open question #2 (sessions link to modules) to be implemented first.

**UI behavior:**
- Module has no session booked → Mark Complete disabled, hint: "Book a session first"
- Module has session `scheduled` → Mark Complete disabled, hint: "Session scheduled for [date]"
- Module has session `completed` → Mark Complete enabled
- Module has session `cancelled` → Mark Complete disabled, student must rebook

## Session 325 Fixes

1. **Stale availability bug** — `useEffect` dependency array was missing `step`, so availability wasn't re-fetched when navigating back. Fixed by adding `step` to deps.
2. **Confirm button active on error** — Confirm button remained clickable after a conflict error. Fixed by disabling when `error` is set.
3. **Teacher mismatch guard** — API had no check that `teacher_id` matched `enrollment.student_teacher_id`. Added 403 guard.

## References

- `docs/tech/tech-031-availability-calendar.md` — Availability system (rules, overrides, merge algorithm)
- `research/run-001/features/features-block-4.md` — Block 4 feature specs (SBOK, SROM)
- `DECISIONS.md` — Session 292 (rating tiers), Session 324 (enrollment FK)
