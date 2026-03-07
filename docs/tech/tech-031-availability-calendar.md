# tech-031: Availability Calendar System

**Created:** Session 289 (S-T-CALENDAR block)
**Covers:** Sessions 287-289

## Overview

The availability calendar is the scheduling backbone of Peerloop. It controls when Teachers (including Creators-as-Teacher) are bookable by students. The system has three layers:

1. **Recurring rules** — weekly patterns (e.g., "Every Monday 2-4pm for 8 weeks")
2. **Overrides** — date-specific changes (e.g., "Block March 15" or "Add 10am-2pm on March 20")
3. **Teaching toggle** — per-course on/off switch for accepting students

Students see the **merged result**: recurring rules expanded into a month, overlaid with overrides, filtered by teaching status, with existing bookings marked as conflicts.

## Data Model

### Three tables, one per concern

```
availability              Per-person recurring weekly rules
  ├─ user_id → users(id)
  ├─ day_of_week (0-6)
  ├─ start_time / end_time (HH:MM)
  ├─ start_date            First occurrence (ISO date, nullable)
  └─ repeat_weeks           Weeks to repeat (null = indefinite)

availability_overrides    Per-person date-specific changes
  ├─ user_id → users(id)
  ├─ date (ISO date)
  ├─ start_time / end_time  (null if blocking)
  └─ is_available            1 = extra hours, 0 = blocked

teacher_certifications          Per-course certification + toggle
  ├─ user_id → users(id)
  ├─ course_id → courses(id)
  ├─ is_active              Admin-controlled (certification status)
  └─ teaching_active         User-controlled (accepting students)
```

### Key design decisions

**Availability is per-person, not per-course.** A teacher sets one schedule that applies across all courses they teach. Rationale: a person can't be in two sessions simultaneously, so per-course availability adds complexity without benefit. The `teaching_active` toggle on `teacher_certifications` handles course-level opt-in/out.

**Separate tables for recurring vs overrides.** Different data shapes (day-of-week vs specific date) warranted separate tables. The merge algorithm combines them at query time.

**Two distinct "active" concepts:**
| Column | Table | Controlled By | Meaning |
|--------|-------|---------------|---------|
| `is_active` | `teacher_certifications` | Admin | Certification status (suspended/active) |
| `teaching_active` | `teacher_certifications` | User (Teacher) | Accepting students for this course |

When `is_active=0`, the toggle endpoint returns 403. When `teaching_active=0`, the Teacher's record persists but they don't appear in student booking.

## Merge Algorithm

The core function is `buildMonthView()` in `availability-utils.ts`.

```
For each date in the month:
  1. Check for overrides on this date
     ├─ If blocked override exists → day is unavailable, no slots
     ├─ If available overrides exist → use override times as slots
     │   └─ Also keep non-overlapping recurring slots
     └─ If no overrides → expand recurring rules (step 2)

  2. Expand recurring rules for this date
     ├─ Match day_of_week
     ├─ Check start_date bound (if set)
     ├─ Check repeat_weeks bound (if set)
     └─ Mark is_series_end if this is the last occurrence

  3. Attach metadata
     ├─ booked_count from bookings data
     ├─ source tag (recurring vs override)
     └─ Sort slots by start_time
```

**Override precedence:** When an override exists for a date, its time windows replace overlapping recurring slots. Non-overlapping recurring slots are preserved. A blocking override (`is_available=0`) removes all slots.

### DST-safe week counting

**Important:** Week boundaries must use calendar-day math, not millisecond math.

```typescript
// WRONG — breaks across DST transitions
const weeksDiff = Math.floor((date - start) / (7 * 24 * 60 * 60 * 1000));

// CORRECT — DST-safe
const daysDiff = Math.round((date - start) / (24 * 60 * 60 * 1000));
const weeksDiff = Math.floor(daysDiff / 7);
```

US spring forward (March 8, 2026) removes one hour from the elapsed time between two dates, causing the millisecond calculation to undercount weeks. Using `Math.round` on the day difference absorbs the ~1 hour DST shift.

This pattern is used in both `availability-utils.ts` (client-side) and `teachers/[id]/availability.ts` (server-side).

## API Contracts

### Teacher-facing (manage own availability)

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/me/availability` | GET | Get own recurring rules |
| `/api/me/availability` | PUT | Replace recurring rules (accepts `start_date`, `repeat_weeks`) |
| `/api/me/availability/overrides` | GET | List own overrides |
| `/api/me/availability/overrides` | POST | Create override (available or blocked) |
| `/api/me/availability/overrides/:id` | DELETE | Remove override (owner-verified) |
| `/api/me/teacher/:courseId/toggle` | PATCH | Toggle `teaching_active` for a course |

### Student-facing (view teacher availability for booking)

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/teachers/:id/availability` | GET | Get expanded availability slots |

**Query params:** `course_id`, `start_date`, `end_date`, `weeks` (default 2, booking UI uses 4).

**Response shape:**
```json
{
  "teacher": { "id", "name", "handle", "avatar_url", "timezone" },
  "weekly_availability": [{ "day_of_week", "day_name", "start_time", "end_time", "timezone" }],
  "slots": [{ "date", "start_time", "end_time", "available", "conflict_session_id?" }],
  "date_range": { "start", "end" },
  "teaching_paused": true  // only present when teaching_active=0
}
```

**Filtering chain:**
1. Teacher must exist and be an active Teacher or Creator
2. If `course_id` provided: teacher must teach it with `is_active=1`
3. If `teaching_active=0` for the course: return empty slots + `teaching_paused: true`
4. Slots generated from recurring rules, overlaid with overrides, conflicts marked

## Calendar UI

### Component: `AvailabilityCalendar.tsx`

Location: `src/components/teachers/workspace/AvailabilityCalendar.tsx`

**Interaction modes:**
| Mode | Trigger | Then |
|------|---------|------|
| Ad hoc | Click one day | Set time range → Mark Available or Unavailable |
| Multi-select | Click multiple days | Set time range for all selected |

**Recurring prompt:** After marking days, user chooses "Just this day" / "Every [day] for N weeks" / "Indefinite". Multi-day selections (e.g., Mon+Wed+Fri) create one rule per day-of-week, sharing the same repeat duration.

**Cell indicators:**
| Indicator | Meaning |
|-----------|---------|
| Time range text | Available hours (e.g., "2-4pm") |
| Light shade + repeat icon | Recurring rule |
| Solid shade | Override |
| End badge | Last occurrence of a series |
| Student icon/count | Has bookings |
| Red/strikethrough | Blocked |

### Component: `CreatorTeachingSummary.tsx`

Shows per-course toggle switches on the Creator Dashboard "My Teaching" card. Calls `PATCH /api/me/teacher/:courseId/toggle` and updates UI optimistically.

### Component: `SessionBooking.tsx`

Student booking wizard. Fetches `GET /api/teachers/:id/availability` with 4-week lookahead. Shows teacher and student timezones side by side. Teachers with `teaching_active=0` are excluded from the teacher list at the page level (`book.astro` query).

## File Map

```
src/
├── components/
│   ├── teachers/workspace/
│   │   ├── AvailabilityCalendar.tsx    # Month-view calendar UI
│   │   └── availability-utils.ts       # Merge algorithm, time helpers
│   ├── dashboard/
│   │   ├── CreatorTeachingSummary.tsx   # Per-course toggle UI
│   │   └── CreatorDashboard.tsx        # Consumes teaching_courses data
│   └── booking/
│       └── SessionBooking.tsx          # Student booking wizard
├── pages/
│   ├── api/me/
│   │   ├── availability.ts             # GET/PUT own recurring rules
│   │   ├── availability/overrides.ts   # GET/POST overrides
│   │   ├── availability/overrides/[id].ts  # DELETE override
│   │   ├── teacher/[courseId]/toggle.ts  # PATCH toggle
│   │   ├── creator-dashboard.ts        # Returns teaching_active
│   │   └── teacher-dashboard.ts        # Returns teaching_active
│   ├── api/teachers/[id]/
│   │   └── availability.ts             # GET expanded slots for booking
│   ├── teaching/availability.astro     # Calendar page wrapper
│   └── course/[slug]/book.astro        # Booking page (filters by teaching_active)
└── lib/db/types.ts                     # TeacherCertification, Availability, AvailabilityOverride

migrations/
└── 0001_schema.sql                     # availability, availability_overrides, teacher_certifications

tests/
├── unit/availability-utils.test.ts     # 26 tests: merge, duration, series-end, edge cases
└── api/me/teacher/toggle.test.ts  # 9 tests: toggle, filtering, conflicts
```

## Test Coverage

| Test File | Count | Covers |
|-----------|-------|--------|
| `tests/unit/availability-utils.test.ts` | 26 | Merge algorithm, recurring duration, series-end detection, override precedence, multi-day recurring, edge cases |
| `tests/api/me/teacher/toggle.test.ts` | 9 | Toggle auth/validation/behavior, availability filtering by teaching_active, booking conflict with overrides |
| `tests/api/teachers/[id]/availability.test.ts` | 15 | Availability endpoint: auth, validation, slots, conflicts (pre-existing) |
| `tests/api/me/availability.test.ts` | — | Recurring rules CRUD (pre-existing) |

## References

- **react-day-picker:** `docs/tech/tech-030-react-day-picker.md` (installed but custom grid used)
- **Design decisions:** `CURRENT-BLOCK-PLAN.md` Decisions 1-8 (temporary file; decisions preserved here)
- **DB schema:** `research/DB-SCHEMA.md`
