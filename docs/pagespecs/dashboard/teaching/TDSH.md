# Page: Student-Teacher Dashboard

**Code:** TDSH
**URL:** `/dashboard` (role-aware, same URL as SDSH)
**Access:** Authenticated (Student-Teacher role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Central hub for Student-Teachers to manage their teaching schedule, track earnings, view their students, and handle teaching-related tasks.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | Successful login (ST role) | Default post-login |
| Nav | "Dashboard" link | Global navigation |
| SROM | "Back to Dashboard" | After teaching session |
| PROF | "Dashboard" link | From profile |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SROM | "Join Session" | Join teaching session |
| STPR | "View My Profile" | See public ST profile |
| PROF | "Edit Profile" | Edit profile settings |
| SETT | "Availability" | Manage teaching schedule |
| MSGS | "Message Student" | Contact a student |
| CDET | Course title click | View course info |
| (Payout) | "Request Payout" | Initiate payout (future) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| sessions | id, scheduled_start, student_id, course_id, status | Teaching schedule |
| student_teachers | course_id, students_taught, is_active | Certification status |
| payment_splits | amount_cents, status | Earnings tracking |
| payouts | amount_cents, status, paid_at | Payout history |
| enrollments | student_id, course_id | My students list |
| users (students) | name, avatar | Student display |
| courses | id, title | Course info |
| certificates | user_id, course_id, type, recommended_by | Pending recommendations |
| homework_submissions | id, status, student_id, assignment_id | Pending homework reviews |
| homework_assignments | id, title, course_id | Assignment context |

---

## Sections

### Header Bar
- Greeting: "Welcome, Teacher [Name]!"
- Availability toggle: "Available for Summon" (if goodwill enabled)
- Quick stats: X students, Y sessions this week

### Earnings Overview
- **Pending Balance:** Amount awaiting payout
- **Total Earned:** Lifetime earnings
- **This Month:** Current month earnings
- "View Earnings Details" → detailed breakdown
- "Request Payout" button (if eligible)

### Upcoming Teaching Sessions
- Next 5 scheduled sessions
- Each shows:
  - Date/time
  - Student name + avatar
  - Course title
  - "Join" button (active near start time) → SROM
  - "Reschedule" option
- Empty state: "No sessions scheduled"

### My Students
- List of students currently learning from this ST
- Each shows:
  - Avatar + name
  - Course enrolled in
  - Progress percentage
  - "Message" → MSGS
  - "View Progress" → detailed view
- Grouped by course if teaching multiple

### Pending Actions
- **Certification Recommendations:**
  - Students ready for completion certificate
  - "Recommend for Certification" button
- **Intro Session Requests** (per CD-029):
  - Pending free intro sessions
  - Accept/decline options
- **Homework Reviews:**
  - Student homework submissions awaiting review
  - Each shows: student name, assignment title, course, submitted date
  - "Review" button → expands to show submission + feedback form
  - Quick actions: "Approve", "Request Resubmit"
  - Feedback text field + optional points
  - Source: Brian Review 2025-12-26
- Empty state: "No pending actions"

### Availability Quick View
- Weekly calendar showing available slots
- "Edit Availability" → SETT

### Teaching Stats
- Sessions completed this month
- Average session rating
- Students helped

---

## User Stories Fulfilled

- US-T013: Access ST-specific dashboard
- US-T023: View teaching earnings
- US-P061: Recommend students for certification

---

## States & Variations

| State | Description |
|-------|-------------|
| New ST | Just certified, no sessions yet, onboarding tips |
| Active ST | Sessions scheduled, students assigned |
| Session Starting | "Join Now" prominently displayed |
| Payout Available | Highlight pending balance, enable payout |
| Multi-Role | Combined with student sections (unified dashboard) |

---

## Mobile Considerations

- Earnings summary at top (primary concern for STs)
- Sessions list scrollable
- Sticky "Join Session" if imminent
- Quick toggle for availability

---

## Error Handling

| Error | Display |
|-------|---------|
| Data load fails | "Unable to load dashboard. [Retry]" |
| Payout request fails | "Unable to process. Please try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | sessions_count, earnings_pending |
| `join_session` | Join clicked | session_id |
| `recommend_cert` | Recommend clicked | student_id, course_id |
| `view_earnings` | Earnings detail clicked | - |
| `request_payout` | Payout clicked | amount |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/student-teachers/me/dashboard` | Page load | Aggregated dashboard data |
| `GET /api/student-teachers/me/sessions` | Sessions section | Upcoming teaching sessions |
| `GET /api/student-teachers/me/students` | Students section | Assigned students |
| `GET /api/student-teachers/me/earnings` | Earnings section | Earnings breakdown |
| `POST /api/certificates/recommend` | Recommend cert | Recommend student for certification |
| `POST /api/sessions/:id/accept` | Accept intro | Accept intro session request |
| `POST /api/payouts/request` | Request payout | Initiate payout |
| `GET /api/homework/:id/submissions` | Review homework | Get submission details |
| `POST /api/submissions/:id/review` | Submit review | Review homework submission |

### Dashboard Data Aggregation

```typescript
// GET /api/student-teachers/me/dashboard
{
  earnings: {
    pending_balance: 70000,      // cents (ST's 70% share)
    total_earned: 420000,        // lifetime
    this_month: 28000,
    payout_threshold: 5000
  },
  upcoming_sessions: [
    {
      id, scheduled_start, scheduled_end,
      student: { id, name, avatar },
      course: { id, title },
      can_join: true  // within join window
    }
  ],
  students: [
    {
      id, name, avatar,
      course_id, course_title,
      progress_percent,
      sessions_completed
    }
  ],
  pending_actions: {
    cert_recommendations: [ ... ],  // Students ready to recommend
    intro_requests: [ ... ]         // Pending intro session requests (CD-029)
  },
  stats: {
    sessions_this_month: 12,
    average_rating: 4.8,
    students_helped: 24
  }
}
```

### Earnings Calculation (70% Share)

```typescript
// Payment split logic (per CD-020, CD-033):
// When S-T teaches a session:
//   Platform: 15%
//   Creator: 15%
//   S-T: 70%     ← This is what TDSH displays

// Query for ST earnings:
SELECT SUM(amount_cents) FROM payment_splits
WHERE recipient_id = :st_user_id
  AND recipient_type = 'student_teacher'
  AND status IN ('pending', 'paid')
GROUP BY status
```

### Certification Recommendation Flow

```
Recommend Student for Certification:
  1. ST identifies student ready for completion
  2. Click "Recommend for Certification"
  3. POST /api/certificates/recommend {
       student_id, course_id, notes
     }
  4. Backend:
     - Creates certificate record (status: 'recommended')
     - Notifies Creator (appears in CDSH pending)
  5. Creator approves → certificate issued
```

### Intro Session Request Flow (CD-029)

```
Trust-Building Intro Sessions:
  1. Student requests free intro with specific ST
  2. Appears in ST's pending_actions.intro_requests
  3. ST clicks "Accept" or "Decline"
  4. POST /api/sessions/:id/accept { accepted: true }
  5. Backend:
     - Updates session.status = 'scheduled' (or rejected)
     - Sends email to student (Resend)
     - Intro sessions: no payment split (free)
```

### Session Join Flow

```
Upcoming Session Card:
  - If within 15min of scheduled_start:
    can_join: true
  - "Join" button visible
  - Click "Join" → SROM page
  - Token generation happens on SROM page (not here)
```

### Payout Request Flow

Same as Creator (CDSH), but recipient_type = 'student_teacher':

```
POST /api/payouts/request
→ Stripe Transfer to ST's Express account
→ Webhook: transfer.paid updates status
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   TDSH      │      │  PeerLoop   │      │ External    │
│   (Client)  │      │  (Server)   │      │ Services    │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /st/me/        │                    │
       │   dashboard        │                    │
       │───────────────────>│                    │
       │                    │ Query DB for:      │
       │                    │ - sessions         │
       │                    │ - payment_splits   │
       │                    │ - students         │
       │ { dashboard data } │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ POST /certificates/│                    │
       │   recommend        │                    │
       │───────────────────>│                    │
       │                    │ Create certificate │
       │                    │ Notify creator     │
       │                    │ (Resend email)     │
       │                    │───────────────────>│
       │ { recommended }    │                    │
       │<───────────────────│                    │
```

### Real-time Updates

```
New Session Booking:
  - When student books via SBOK
  - Notification sent to ST (in-app + email)
  - Dashboard shows updated upcoming_sessions

Consider:
  - WebSocket for real-time session notifications
  - Or: polling /api/notifications every 30s
```

---

## Notes

- Multi-role users: May see both learning + teaching sections
- CD-033: ST gets 70% when teaching Creator's course content
- CD-033: ST gets 85% when teaching their own content (no Creator)
- Consider combining SDSH + TDSH into unified role-aware dashboard
- Real-time notification for new session bookings
- Payout requires active Stripe Connect (see SETT)
