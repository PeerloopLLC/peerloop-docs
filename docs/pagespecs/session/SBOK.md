# Page: Session Booking

**Code:** SBOK
**URL:** `/book/:st_id` or `/courses/:course_id/book`
**Access:** Authenticated (enrolled students)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Enable students to select a Student-Teacher and schedule a tutoring session for their enrolled course.

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

| Target | Trigger | Notes |
|--------|---------|-------|
| SDSH | After successful booking | Return to dashboard |
| STPR | ST name/avatar click | View ST profile |
| CDET | Back/cancel | Return to course |
| (Payment) | If session requires payment | Payment flow |

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

## Sections

### Header
- Page title: "Book a Session"
- Course context: "for [Course Title]"
- Back link → CDET or previous page

### Step 1: Select Student-Teacher (if not pre-selected)
- **ST Cards:**
  - Avatar, name
  - Students taught count
  - Rating (if available)
  - "Select" button
- **Or:** "Schedule Later" option per CD-033
  - Skips ST selection
  - Platform assigns ST when student is ready
  - Goes to "Schedule Later" confirmation

### Step 2: Select Date
- **Calendar View:**
  - Month calendar navigation
  - Days with availability highlighted
  - Past dates disabled
  - Select a date to see times
- **Quick Options:**
  - "Next Available" shortcut
  - "This Week" filter

### Step 3: Select Time
- **Time Slots:**
  - Available slots for selected date
  - Shown in user's timezone
  - Duration indicated (e.g., "60 min")
  - "Select" to choose slot
- **Timezone Note:**
  - "Times shown in [Your Timezone]"
  - Link to change timezone in settings

### Step 4: Confirm Booking
- **Summary:**
  - Course: [Title]
  - Student-Teacher: [Name] + avatar
  - Date: [Full date]
  - Time: [Start] - [End] [Timezone]
  - Duration: [X minutes]
- **Reminders:** Checkbox to enable session reminders
- **Notes field:** Optional message to ST
- **Confirm button:** "Book Session"

### "Schedule Later" Flow (per CD-033)
- Instead of selecting ST/time:
  - Show confirmation: "We'll notify you when you're ready to schedule"
  - "You can schedule anytime from your dashboard"
  - CTA: "Continue to Dashboard"

### Confirmation Screen
- Success message: "Session Booked!"
- Session details
- "Add to Calendar" button (Google, Apple, Outlook)
- "Back to Dashboard" → SDSH
- "Book Another Session"

---

## User Stories Fulfilled

- US-S044: Book session with Student-Teacher
- US-S045: View available time slots
- US-S046: Receive booking confirmation
- US-P006: Platform enables session booking
- US-P020: Calendar-based scheduling
- US-P024: Session reminders
- US-S084: Access ST calendar during enrollment
- US-S085: "Schedule Later" option

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

## Mobile Considerations

- Wizard-style flow (one step per screen)
- Calendar is swipeable
- Time slots are large touch targets
- Sticky "Confirm" button at bottom

---

## Error Handling

| Error | Display |
|-------|---------|
| Not enrolled | "You must be enrolled to book. [Enroll now]" |
| ST unavailable | "This time is no longer available. Select another." |
| Booking conflict | "You have another session at this time." |
| Booking fails | "Unable to book. Please try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | course_id, st_preselected |
| `st_selected` | ST chosen | st_id |
| `date_selected` | Date chosen | date |
| `time_selected` | Slot chosen | time, st_id |
| `booking_attempted` | Confirm clicked | course_id, st_id, datetime |
| `booking_success` | Booking confirmed | session_id |
| `booking_failed` | Booking failed | error_type |
| `schedule_later` | Schedule later chosen | course_id |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/courses/:id/sts` | Page load | Get available Student-Teachers for course |
| `GET /api/sts/:id/availability` | ST selected | Get ST's available time slots |
| `GET /api/sts/:id/bookings` | Date selected | Get existing bookings (to exclude) |
| `POST /api/sessions` | Confirm booking | Create session in DB |
| `POST /api/checkout/session` | If payment required | Create Stripe checkout |

### Booking Flow (Custom Calendar)

```
Page Load:
  1. GET /api/courses/:id → verify enrollment
  2. GET /api/courses/:id/sts → list of available STs
  3. If ST pre-selected: skip to availability

ST Selection:
  1. User selects ST (or "Schedule Later")
  2. "Schedule Later" → POST /api/enrollments/:id/deferred → back to SDSH

Date Selection:
  1. GET /api/sts/:id/availability → weekly pattern
  2. GET /api/sts/:id/bookings?from=&to= → existing sessions
  3. Client computes available slots (availability - bookings)
  4. Display calendar with available dates highlighted

Time Selection:
  1. User selects date
  2. Client shows time slots for that day
  3. User selects time slot

Booking Confirmation:
  1. POST /api/sessions {
       course_id, st_id, student_id,
       scheduled_start, scheduled_end
     }
  2. Backend:
     - Validates slot still available (race condition check)
     - Creates session record (status: 'scheduled')
     - Triggers email confirmation (Resend)
  3. Response: { session_id, confirmation }
```

### Timezone Handling

```typescript
// Client sends times in user's local timezone
POST /api/sessions {
  scheduled_start: "2025-01-15T10:00:00",  // User's local time
  timezone: "America/New_York"              // User's timezone
}

// Server stores in UTC
sessions.scheduled_start: "2025-01-15T15:00:00Z"

// Display: Always convert to viewer's timezone
// ST sees in their timezone, Student sees in their timezone
```

### Calendar Export

After successful booking:
```
POST /api/sessions/:id/calendar-export?format=ics

Returns: .ics file content for:
- Google Calendar (webcal:// link)
- Apple Calendar (direct .ics download)
- Outlook (direct .ics download)
```

### Email Notifications (Resend)

| Trigger | Template | Recipients |
|---------|----------|------------|
| Booking confirmed | `session-booked` | Student + ST |
| 24h before | `session-reminder-24h` | Student + ST |
| 1h before | `session-reminder-1h` | Student + ST |
| 15min before | `session-reminder-15m` | Student + ST |

### Payment Integration (If Applicable)

For courses with per-session pricing:
```
POST /api/checkout/session {
  session_id: string,
  return_url: "/booking/confirmation?session={session_id}"
}

→ Stripe Checkout Session created
→ Redirect to Stripe
→ Webhook: checkout.session.completed
→ Session status: 'paid' → 'scheduled'
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   SBOK      │      │  PeerLoop   │      │  Resend     │
│   (Client)  │      │  (Server)   │      │  (Email)    │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /sts/:id/      │                    │
       │   availability     │                    │
       │───────────────────>│                    │
       │ weekly pattern     │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ POST /sessions     │                    │
       │───────────────────>│                    │
       │                    │ Send confirmation  │
       │                    │───────────────────>│
       │ { session_id }     │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ GET /sessions/:id/ │                    │
       │   calendar-export  │                    │
       │───────────────────>│                    │
       │ .ics content       │                    │
       │<───────────────────│                    │
```

---

## Notes

- CD-033: "Schedule Later" is key option for flexible enrollment
- Buffer time: 15min between sessions (configurable per ST)
- Timezone handling: All times stored UTC, displayed in user's timezone
- VideoProvider room created on-demand at session time (not at booking)
- Email confirmation with calendar invite via Resend + React Email
- Race condition: Double-booking prevented via DB constraint + validation
