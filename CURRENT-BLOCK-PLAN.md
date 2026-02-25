# CURRENT-BLOCK-PLAN.md — S-T-CALENDAR Block

**Block:** S-T-CALENDAR (Availability Calendar & Creator-as-ST)
**Created:** 2026-02-25 Session 287
**Status:** 🔄 IN PROGRESS

> Delete this file when the full S-T-CALENDAR block is complete and update PLAN.md status.

---

## Progress

| Sub-block | Done | Remaining |
|-----------|------|-----------|
| MONTH-VIEW | 8/8 | Complete |
| RECURRING | 6/6 | Complete |
| OVERRIDES | 6/6 | Complete |
| CREATOR-TOGGLE | 0/7 | teaching_active column, toggle API, dashboard UI, booking filter |
| BOOKING-INTEGRATION | 0/4 | Wire overrides + toggle to student booking, extend lookahead |
| TESTING | 0/9 | Override merge, recurring duration, toggle, month expansion, edge cases |

---

## Design Decisions (Session 287)

**Decision 1: Month calendar is the primary (and only) interface.**
The old weekly grid editor (`AvailabilityEditor.tsx`) is replaced by a month-view calendar. No separate weekly/monthly tabs — everything happens on one calendar. Recurring patterns are set within the same flow (see interaction modes below).

**Decision 2: react-day-picker v9 as the calendar engine.**
Chosen for: full `Day` component replacement (custom cell rendering), built-in `mode="multiple"` for non-contiguous multi-select, headless/unstyled (Tailwind-native), ~22 kB bundle, 10.6M weekly downloads, MIT license, actively maintained. Other packages evaluated and rejected: FullCalendar (no non-contiguous multi-select, opinionated CSS), react-calendar (can't replace cell structure), react-big-calendar (massive bundle, wrong tool), @schedule-x (event-level only).

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

Each date cell is a custom `Day` component (react-day-picker v9 component override):

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

- [ ] Add `teaching_active INTEGER DEFAULT 1` to `student_teachers` table
- [ ] `PATCH /api/me/student-teacher/:courseId/toggle` — Toggle `teaching_active`
- [ ] UI toggle on Creator Dashboard "My Teaching" card: per-course on/off switch
- [ ] When toggled off: Creator's ST record stays, doesn't appear in booking availability
- [ ] When toggled on: Creator appears as bookable S-T alongside other S-Ts
- [ ] Update `GET /api/student-teachers/[id]/availability` to return empty when `teaching_active = 0`
- [ ] Update `SessionBooking.tsx` teacher selection to filter by `teaching_active = 1`

## BOOKING-INTEGRATION
*Ensure calendar changes flow to student booking*

- [ ] Overrides reflected in student booking calendar immediately
- [ ] Creator-as-ST toggle reflected in teacher picker immediately
- [ ] Extend lookahead window from 2 weeks to 4 weeks (month-view requires it)
- [ ] Time zone display: show S-T's timezone + student's timezone side by side in booking

## TESTING

- [ ] Override merge tests: recurring + override = correct available slots
- [ ] Override removal tests: delete override → recurring slot reappears
- [ ] Recurring duration tests: slots generated only within `start_date` to `start_date + repeat_weeks`
- [ ] Series-end display tests: last occurrence correctly identified
- [ ] Creator-as-ST toggle tests: toggled off → not bookable, toggled on → bookable
- [ ] Month-view expansion tests: recurring rules correctly fill month grid
- [ ] Booking conflict tests: override on date with existing booking → warn/block
- [ ] Multi-day recurring tests: Mon+Wed+Fri for 8 weeks creates correct rules
- [ ] Edge cases: S-T changes timezone mid-week; override on a day with no recurring slot; multi-select across month boundary
