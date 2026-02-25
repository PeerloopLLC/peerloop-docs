# CURRENT-BLOCK-PLAN.md — S-T-CALENDAR Block

**Block:** S-T-CALENDAR (Availability Calendar & Creator-as-ST)
**Created:** 2026-02-25 Session 287
**Status:** ✅ COMPLETE (40/40 items — 6 of 6 sub-blocks complete)
**Last updated:** 2026-02-25 Session 289

> Delete this file when the full S-T-CALENDAR block is complete and update PLAN.md status.

---

## Progress

| Sub-block | Done | Remaining |
|-----------|------|-----------|
| MONTH-VIEW | 8/8 | Complete |
| RECURRING | 6/6 | Complete |
| OVERRIDES | 6/6 | Complete |
| CREATOR-TOGGLE | 7/7 | Complete |
| BOOKING-INTEGRATION | 4/4 | Complete |
| TESTING | 9/9 | Complete |

---

## Design Decisions (Session 287)

**Decision 1: Month calendar is the primary (and only) interface.**
The old weekly grid editor (`AvailabilityEditor.tsx`) is replaced by a month-view calendar. No separate weekly/monthly tabs — everything happens on one calendar. Recurring patterns are set within the same flow (see interaction modes below).

**Decision 2: react-day-picker v9 installed but custom grid used.**
Installed react-day-picker v9.13.2 for potential future use, but the calendar uses a custom 7-column grid instead of DayPicker's component. Reason: our cells need rich availability indicators (time ranges, recurring dots, override highlights, series-end badges, booking counts) that are simpler to render inline than via DayPicker's `components.Day` override. Original rationale for choosing the library still valid for future needs.

**Decision 3: Separate `availability_overrides` table for date-specific changes.**
Recurring rules stay in `availability` (day_of_week based). Specific date changes go in `availability_overrides` (date-based). Different data shapes → separate tables. Calendar render logic: expand recurring rules for visible month → overlay overrides → show merged result.

**Decision 4: Per-course `teaching_active` toggle for Creator-as-ST.**
Add `teaching_active INTEGER DEFAULT 1` to `student_teachers` table. Per-course because `student_teachers` is already one-row-per-course. UI toggle on "My Teaching" card (Creator Dashboard). When toggled off, Creator's ST record stays but doesn't appear in booking.

---

## Interaction Model

**Two calendar interaction modes:**

| Mode | Interaction | Then |
|------|------------|------|
| **Ad hoc** | Click one day | Set time range (start/end) → Mark Available or Unavailable |
| **Multi-select** | Click multiple days | Set time range → Mark Available or Unavailable for all selected |

**Recurring option — offered after marking days:**
After selecting day(s) and setting the time range, prompt: "Just this [Tuesday]" / "Every [Tuesday] for [N] weeks"

- Multi-day recurring: select Mon + Wed + Fri → "Repeat for 8 weeks" → creates 3 rules, all ending the same week
- Each recurring day has a start/end time range (e.g., "Every Tuesday 2:00pm–4:00pm")

**Overrides within a recurring series:**
Click any day that's part of a recurring series → override just that day (change times, block it, add extra hours) without breaking the rest of the series.

---

## Cell Indicators

Each date cell is rendered inline in the AvailabilityCalendar grid:

| Indicator | Visual | Meaning |
|-----------|--------|---------|
| Time range | Text: "2–4pm" | When they're available that day |
| Recurring | Lighter shade + repeat icon | Generated from a weekly recurring rule |
| Override | Solid shade | Explicitly set, different from recurring pattern |
| Series-end | End badge/dot | Last occurrence of a repeating series |
| Booked | Student icon or count | Slot has a booking (can't be removed) |
| Unavailable | Red/strikethrough | Explicitly blocked |

---

## Schema Changes

> **Session 288 decision:** Availability is per-person (`user_id`), not per-course. No `course_id` on availability tables.
> `user_id` references `users(id)` matching the existing `availability` table pattern.
> See CERT-AUDIT in PLAN.md for future `st_id` audit trail work.

**Existing table — extend `availability` with recurring duration:**

| Column | Type | Notes |
|--------|------|-------|
| `id` | TEXT PK | Existing |
| `user_id` | TEXT FK → users(id) | Existing |
| `day_of_week` | INTEGER | 0–6, existing |
| `start_time` | TEXT | "14:00", existing |
| `end_time` | TEXT | "16:00", existing |
| `timezone` | TEXT | Existing |
| `is_recurring` | INTEGER DEFAULT 1 | Existing |
| `start_date` | TEXT | **New** — first occurrence date (ISO) |
| `repeat_weeks` | INTEGER | **New** — number of weeks to repeat (NULL = indefinite) |

**New table — `availability_overrides`:**

| Column | Type | Notes |
|--------|------|-------|
| `id` | TEXT PK | Generated ID |
| `user_id` | TEXT FK → users(id) | The person |
| `date` | TEXT | Specific date (ISO, e.g., "2026-03-15") |
| `start_time` | TEXT | NULL if marking unavailable |
| `end_time` | TEXT | NULL if marking unavailable |
| `is_available` | INTEGER | 1 = extra availability, 0 = blocked |
| `created_at` | TEXT | ISO timestamp |

**Extend `student_teachers` — add teaching toggle:**

| Column | Type | Notes |
|--------|------|-------|
| `teaching_active` | INTEGER DEFAULT 1 | **New** — 1 = bookable, 0 = hidden from booking |

## Implementation Notes (Session 288)

**Decision 5: Availability is per-person (`user_id`), not per-course.**
The block plan assumed `st_id` and `course_id` on availability tables, but the existing schema uses `user_id` with no course scoping. Analysis confirmed the entire codebase is person-centric for scheduling (availability, sessions, enrollments, payments all key on `user_id`). A teacher can't teach two courses at once, so per-course availability adds complexity without benefit. The `teaching_active` toggle on `student_teachers` (per-course) is sufficient for course-level opt-in/out.

**Decision 6: CERT-AUDIT deferred as separate block.**
The `student_teachers.id` (certification ID) vs `users.id` (person ID) distinction matters for authorization auditing but is out of scope for S-T-CALENDAR. Added as priority 14 in PLAN.md deferred list.

**Files created:**
- `src/components/student-teachers/workspace/availability-utils.ts` — Merge logic, time helpers, shared constants
- `src/components/student-teachers/workspace/AvailabilityCalendar.tsx` — Full month-view calendar (~900 lines)
- `src/pages/api/me/availability/overrides.ts` — GET/POST overrides
- `src/pages/api/me/availability/overrides/[id].ts` — DELETE override

**Files modified:**
- `migrations/0001_schema.sql` — `start_date`, `repeat_weeks` on availability; new `availability_overrides` table
- `src/lib/db/types.ts` — Updated `Availability`, added `AvailabilityOverride`
- `src/pages/api/me/availability.ts` — Accept/store/return recurring fields
- `src/pages/api/student-teachers/[id]/availability.ts` — Recurring bounds + override merge
- `src/pages/teaching/availability.astro` — Swapped to AvailabilityCalendar
- `src/components/student-teachers/workspace/index.ts` — Added export

## Implementation Notes (Session 289)

**Decision 7: Two distinct "active" concepts for student-teachers.**
- `is_active` (admin-controlled) = certification status (suspended/active)
- `teaching_active` (user-controlled) = per-course teaching availability (accepting students/paused)
When `is_active=0`, toggle endpoint returns 403. When `teaching_active=0`, ST still has their record but doesn't appear in booking.

**Decision 8: DST-safe week counting.**
Fixed a DST bug in `availability-utils.ts` and the availability API endpoint. The original code used millisecond-based week calculation (`msPerWeek = 7 * 24 * 60 * 60 * 1000`) which fails across DST transitions (e.g., US spring forward March 8). Fixed to use `Math.round(daysDiff / msPerDay)` then divide by 7.

**Files created:**
- `src/pages/api/me/student-teacher/[courseId]/toggle.ts` — PATCH toggle endpoint
- `tests/unit/availability-utils.test.ts` — 26 unit tests for merge logic
- `tests/api/me/student-teacher/toggle.test.ts` — 9 API tests for toggle + filtering

**Files modified:**
- `migrations/0001_schema.sql` — Added `teaching_active` to `student_teachers`
- `migrations-dev/0001_seed_dev.sql` — Added `teaching_active` column to seed INSERT
- `src/lib/db/types.ts` — Added `teaching_active` to `StudentTeacher` interface
- `src/pages/api/me/creator-dashboard.ts` — Return `teaching_active` in teaching_courses
- `src/pages/api/me/teacher-dashboard.ts` — Return `teaching_active` in certifications
- `src/pages/api/student-teachers/[id]/availability.ts` — Filter by `teaching_active`, DST fix
- `src/pages/course/[slug]/book.astro` — Filter teacher list by `teaching_active=1`
- `src/components/dashboard/CreatorDashboard.tsx` — Updated interface for `teaching_active`
- `src/components/dashboard/CreatorTeachingSummary.tsx` — Added per-course toggle switch UI
- `src/components/booking/SessionBooking.tsx` — Extended lookahead to 4 weeks, added timezone display
- `src/components/student-teachers/workspace/availability-utils.ts` — DST-safe week counting

---

## MONTH-VIEW
*Replace weekly editor with month calendar (react-day-picker v9)*

- [x] Install `react-day-picker` v9 dependency (v9.13.2 — used for future DayPicker needs; current calendar uses custom grid)
- [x] Build custom `AvailabilityDay` cell rendering with cell indicators (inlined in AvailabilityCalendar)
- [x] Build `AvailabilityCalendar` wrapper component with ad hoc + multi-select modes
- [x] Time range picker sub-component (start/end time for selected day(s))
- [x] Action panel: after selecting day(s) → "Available" / "Unavailable" / "Cancel"
- [x] Navigate between months (next/previous) + "Today" shortcut
- [x] Replace `AvailabilityEditor.tsx` usage with new calendar component (in availability.astro)
- [x] Calendar render logic: expand recurring rules for visible month → overlay overrides → display merged (availability-utils.ts)

## RECURRING
*Recurring availability rules with duration*

- [x] Add `start_date` and `repeat_weeks` columns to `availability` table (schema + Availability type)
- [x] Recurring prompt after marking days: "Just this day" / "Every [day] for N weeks" / "Indefinite"
- [x] Multi-day recurring: selecting different days of week creates one rule per day, all sharing the same repeat duration
- [x] Series-end badge: when a recurring series ends within the visible month, show "end" indicator (already in availability-utils.ts)
- [x] Refactor `PUT /api/me/availability` to accept and store `start_date` and `repeat_weeks`
- [x] Update `GET /api/student-teachers/[id]/availability` expansion logic to respect `start_date` and `repeat_weeks` bounds

## OVERRIDES
*Date-specific availability changes*

- [x] Create `availability_overrides` table in `0001_schema.sql` + `AvailabilityOverride` type
- [x] `GET/POST /api/me/availability/overrides` — List & create overrides (available with time range, or blocked)
- [x] `DELETE /api/me/availability/overrides/:id` — Remove override (owner-verified)
- [x] Update `GET /api/student-teachers/[id]/availability` to merge overrides on top of expanded recurring slots
- [x] UI: "Override Day" button when selected day has recurring slots → change times via override
- [x] Bulk overrides: "Block Days" on multi-select → creates one override per date; "Remove Overrides" to revert

## CREATOR-TOGGLE
*Per-course teaching availability toggle*

- [x] Add `teaching_active INTEGER DEFAULT 1` to `student_teachers` table
- [x] `PATCH /api/me/student-teacher/:courseId/toggle` — Toggle `teaching_active`
- [x] UI toggle on Creator Dashboard "My Teaching" card: per-course on/off switch
- [x] When toggled off: Creator's ST record stays, doesn't appear in booking availability
- [x] When toggled on: Creator appears as bookable S-T alongside other S-Ts
- [x] Update `GET /api/student-teachers/[id]/availability` to return empty when `teaching_active = 0`
- [x] Update `SessionBooking.tsx` teacher selection to filter by `teaching_active = 1`

## BOOKING-INTEGRATION
*Ensure calendar changes flow to student booking*

- [x] Overrides reflected in student booking calendar immediately (availability endpoint already merges overrides)
- [x] Creator-as-ST toggle reflected in teacher picker immediately (book.astro + availability endpoint filter)
- [x] Extend lookahead window from 2 weeks to 4 weeks (month-view requires it)
- [x] Time zone display: show S-T's timezone + student's timezone side by side in booking

## TESTING

- [x] Override merge tests: recurring + override = correct available slots
- [x] Override removal tests: delete override → recurring slot reappears
- [x] Recurring duration tests: slots generated only within `start_date` to `start_date + repeat_weeks`
- [x] Series-end display tests: last occurrence correctly identified
- [x] Creator-as-ST toggle tests: toggled off → not bookable, toggled on → bookable
- [x] Month-view expansion tests: recurring rules correctly fill month grid
- [x] Booking conflict tests: override on date with existing booking → warn/block
- [x] Multi-day recurring tests: Mon+Wed+Fri for 8 weeks creates correct rules
- [x] Edge cases: override on a day with no recurring slot; blocking override with no recurring; multiple overrides same day
