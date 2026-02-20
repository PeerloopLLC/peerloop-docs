# SBOK - Session Booking

| Field | Value |
|-------|-------|
| Route | `/book/:st_id` or `/courses/:course_id/book` |
| Access | Authenticated (enrolled students) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 4 |
| JSON Spec | `src/data/pages/courses/[slug]/book.json` |
| Astro Page | `src/pages/courses/[slug]/book.astro` |

---

## Purpose

Enable students to select a Student-Teacher and schedule a tutoring session for their enrolled course.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S044 | As a Student, I need to book sessions with STs so that I can get tutoring | P0 | 📋 |
| US-S045 | As a Student, I need to view available time slots so that I can pick a convenient time | P0 | 📋 |
| US-S046 | As a Student, I need to receive booking confirmation so that I know it's scheduled | P0 | 📋 |
| US-P006 | As a Platform, I need to enable session booking so that tutoring can happen | P0 | 📋 |
| US-P020 | As a Platform, I need calendar-based scheduling so that booking is intuitive | P0 | 📋 |
| US-P024 | As a Platform, I need session reminders so that attendance is high | P0 | 📋 |
| US-S084 | As a Student, I need to access ST calendars during enrollment so that I can plan | P0 | 📋 |
| US-S085 | As a Student, I need a "Schedule Later" option so that I don't have to book immediately | P0 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CDET | "Book a Session" CTA | Course detail page |
| CDET | ST card "Book with [Name]" | Pre-selected ST |
| SDSH | "Book Session" on course card | From dashboard |
| STPR | "Book Session" button | Pre-selected ST |
| STDR | "Book Session" on ST card | Pre-selected ST |
| CCNT | "Schedule Session" | From course content |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SDSH | After successful booking | Return to dashboard | 📋 |
| STPR | ST name/avatar click | View ST profile | 📋 |
| CDET | Back/cancel | Return to course | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| student_teachers | user_id, course_id, is_active | Available STs |
| users (STs) | name, avatar, timezone | ST display |
| availability | day_of_week, start_time, end_time, timezone | Available slots |
| sessions | scheduled_start, teacher_id | Existing bookings (to exclude) |
| enrollments | student_id, course_id | Verify enrollment |
| courses | title, session_count | Course context |

---

## Features

### Step 1: Select Student-Teacher
- [ ] ST cards with avatar, name, students taught, rating `[US-S044]`
- [ ] "Select" button for each ST `[US-S044]`
- [ ] "Schedule Later" option (skip ST/time selection) `[US-S085]`

### Step 2: Select Date
- [ ] Month calendar navigation `[US-S045]`
- [ ] Days with availability highlighted `[US-S045]`
- [ ] Past dates disabled `[US-S045]`
- [ ] "Next Available" shortcut `[US-S045]`
- [ ] "This Week" filter `[US-S045]`

### Step 3: Select Time
- [ ] Available time slots for selected date `[US-S045]`
- [ ] Times shown in user's timezone `[US-S045]`
- [ ] Duration indicated (e.g., "60 min") `[US-S045]`
- [ ] Timezone note and settings link `[US-S045]`

### Step 4: Confirm Booking
- [ ] Summary: Course, ST, Date, Time, Duration `[US-S046]`
- [ ] Reminders checkbox `[US-P024]`
- [ ] Optional notes field for ST `[US-S044]`
- [ ] "Book Session" button `[US-S044]`

### Confirmation Screen
- [ ] Success message `[US-S046]`
- [ ] Session details `[US-S046]`
- [ ] "Add to Calendar" button (Google, Apple, Outlook) `[US-S046]`
- [ ] "Back to Dashboard" link `[US-S046]`
- [ ] "Book Another Session" link `[US-S044]`

### "Schedule Later" Flow
- [ ] Confirmation text explaining deferred scheduling `[US-S085]`
- [ ] "Continue to Dashboard" CTA `[US-S085]`

---

## Sections (from Plan)

### Header
- Page title: "Book a Session"
- Course context: "for [Course Title]"
- Back link

### Step 1: Select Student-Teacher
- ST cards grid
- "Schedule Later" option

### Step 2: Select Date
- Calendar view
- Quick options

### Step 3: Select Time
- Time slot list
- Timezone display

### Step 4: Confirm
- Summary card
- Options
- Confirm button

### Confirmation Screen
- Success message
- Session details
- Calendar export
- Navigation options

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/courses/:id/sts` | GET | Available STs for course | 📋 |
| `/api/sts/:id/availability` | GET | ST's available time slots | 📋 |
| `/api/sts/:id/bookings` | GET | Existing bookings (to exclude) | 📋 |
| `/api/sessions` | POST | Create session in DB | 📋 |
| `/api/enrollments/:id/deferred` | POST | Record "Schedule Later" | 📋 |
| `/api/sessions/:id/calendar-export` | GET | Generate .ics file | 📋 |

**Booking Flow:**
```
1. GET /api/courses/:id → verify enrollment
2. GET /api/courses/:id/sts → list of available STs
3. GET /api/sts/:id/availability → weekly pattern
4. GET /api/sts/:id/bookings?from=&to= → existing sessions
5. Client computes available slots

POST /api/sessions {
  course_id, st_id, student_id,
  scheduled_start, scheduled_end,
  timezone
}

Backend:
- Validates slot still available (race condition check)
- Creates session record (status: 'scheduled')
- Triggers email confirmation (Resend)

Response: { session_id, confirmation }
```

**Timezone Handling:**
```typescript
// Client sends times in user's local timezone
POST /api/sessions {
  scheduled_start: "2025-01-15T10:00:00",
  timezone: "America/New_York"
}

// Server stores in UTC
// Display: Always convert to viewer's timezone
```

**Email Notifications (Resend):**
| Trigger | Template | Recipients |
|---------|----------|------------|
| Booking confirmed | `session-booked` | Student + ST |
| 24h before | `session-reminder-24h` | Student + ST |
| 1h before | `session-reminder-1h` | Student + ST |
| 15min before | `session-reminder-15m` | Student + ST |

---

## States & Variations

| State | Description |
|-------|-------------|
| ST Pre-selected | Skip step 1, show ST info |
| Choose ST | Multiple STs available, show selection |
| No STs Available | "No Student-Teachers available. Try later." |
| Date Selected | Show time slots for that date |
| Slot Selected | Show confirmation |
| Booking | Loading state during booking |
| Success | Confirmation screen |
| Schedule Later | Alternative flow, skips ST/time |

---

## Error Handling

| Error | Display |
|-------|---------|
| Not enrolled | "You must be enrolled to book. [Enroll now]" |
| ST unavailable | "This time is no longer available. Select another." |
| Booking conflict | "You have another session at this time." |
| Booking fails | "Unable to book. Please try again." |

---

## Mobile Considerations

- Wizard-style flow (one step per screen)
- Calendar is swipeable
- Time slots are large touch targets
- Sticky "Confirm" button at bottom

---

## Implementation Notes

- CD-033: "Schedule Later" is key option for flexible enrollment
- Buffer time: 15min between sessions (configurable per ST)
- Timezone handling: All times stored UTC, displayed in user's timezone
- VideoProvider room created on-demand at session time (not at booking)
- Email confirmation with calendar invite via Resend + React Email
- Race condition: Double-booking prevented via DB constraint + validation
