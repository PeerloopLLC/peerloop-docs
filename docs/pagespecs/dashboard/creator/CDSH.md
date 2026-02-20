# Page: Creator Dashboard

**Code:** CDSH
**URL:** `/dashboard` (role-aware, same URL as SDSH/TDSH)
**Access:** Authenticated (Creator role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Central hub for Creators to manage their courses, track earnings, approve Student-Teachers, monitor course performance, and handle creator-specific workflows.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | Successful login (Creator role) | Default post-login |
| Nav | "Dashboard" link | Global navigation |
| STUD | "Dashboard" link | From Creator Studio |
| CPRO | "Dashboard" link | From own profile |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| STUD | "Creator Studio" / "Manage Courses" | Course management |
| CPRO | "View Public Profile" | See public creator profile |
| PROF | "Edit Profile" | Edit profile settings |
| CDET | Course card click | View course detail |
| (ST Approval) | "Review Application" | ST approval flow |
| (Cert Approval) | "Review Certification" | Certification approval |
| (Payout) | "Request Payout" | Initiate payout |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | id, title, student_count, rating, is_active | Course list |
| enrollments | course_id, status | Enrollment counts |
| student_teachers | course_id, user_id, is_active | ST management |
| certificates | course_id, user_id, type, recommended_by | Pending certifications |
| payment_splits | amount_cents, status (where creator) | Earnings |
| payouts | amount_cents, status, paid_at | Payout history |
| users (students) | count | Total students |
| homework_submissions | id, status, student_id, assignment_id | Pending homework reviews |
| homework_assignments | id, title, course_id | Assignment context |

---

## Sections

### Header Bar
- Greeting: "Welcome, Creator [Name]!"
- Quick stats: X courses, Y total students, Z STs

### Earnings Overview
- **Royalty Balance:** Pending creator royalties (15% per CD-020)
- **Total Earned:** Lifetime royalties
- **This Month:** Current month earnings
- "View Earnings Details" → breakdown by course
- "Request Payout" button

### Pending Approvals
- **Badge count** showing total pending items
- **ST Applications:**
  - Students requesting to become STs for your courses
  - Each shows: name, course, qualifications
  - "Approve" / "Decline" buttons
  - Source: US-P063
- **Certification Requests:**
  - ST recommendations awaiting creator approval
  - Each shows: student name, course, recommended by
  - "Issue Certificate" / "Decline" buttons
  - Source: US-P062
- **Homework Reviews:**
  - Student homework submissions awaiting review
  - Each shows: student name, assignment title, course, submitted date
  - "Review" button → expands to show submission + feedback form
  - Quick actions: "Approve", "Request Resubmit"
  - Feedback text field + optional points
  - Source: Brian Review 2025-12-26
- Empty state: "No pending approvals"

### Course Performance
- Grid/list of creator's courses
- Each course shows:
  - Title + thumbnail
  - Active students count
  - Completion rate
  - Average rating
  - Revenue generated
  - "Manage" → STUD (course edit)
  - "View" → CDET
- Sort by: Students, Revenue, Rating

### Student-Teacher Overview
- List of STs certified for creator's courses
- Each shows:
  - Name, avatar
  - Course(s) certified for
  - Students taught
  - Performance rating
  - "View Profile" → STPR
- "View All STs" if many

### Recent Activity
- Timeline of recent events:
  - New enrollments
  - Course completions
  - ST certifications
  - Reviews received
- Last 10 items

### Quick Actions
- "Create New Course" → STUD
- "View All Courses" → STUD
- "Update Profile" → PROF

---

## User Stories Fulfilled

- US-P003: Creator dashboard for course management
- US-C033: View course analytics
- US-P062: Approve student certifications
- US-P063: Approve ST applications
- US-P064: Approve payouts (via request)
- US-C035: View earnings and royalties

---

## States & Variations

| State | Description |
|-------|-------------|
| New Creator | No courses yet, prominent "Create Course" CTA |
| Active Creator | Courses live, students enrolled |
| Pending Actions | Badge on Pending Approvals, highlight needed |
| Payout Available | Highlight royalty balance |
| Multi-Role | May also show learning sections |

---

## Mobile Considerations

- Earnings summary at top
- Pending approvals with swipe actions
- Course cards stack vertically
- Collapsible sections

---

## Error Handling

| Error | Display |
|-------|---------|
| Data load fails | "Unable to load dashboard. [Retry]" |
| Approval fails | "Unable to process. Please try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | courses_count, pending_count |
| `approve_st` | ST approved | st_id, course_id |
| `approve_cert` | Cert issued | student_id, course_id |
| `view_course` | Course clicked | course_id |
| `request_payout` | Payout clicked | amount |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/creators/me/dashboard` | Page load | Aggregated dashboard data |
| `GET /api/creators/me/earnings` | Earnings section | Detailed earnings breakdown |
| `GET /api/creators/me/courses` | Course list | Creator's courses with stats |
| `GET /api/creators/me/pending-approvals` | Pending section | ST apps + cert requests + homework |
| `POST /api/student-teachers/:id/approve` | Approve ST | Approve ST application |
| `POST /api/certificates/:id/issue` | Issue cert | Issue certification |
| `POST /api/payouts/request` | Request payout | Initiate payout |
| `GET /api/homework/:id/submissions` | Review homework | Get submission details |
| `POST /api/submissions/:id/review` | Submit review | Review homework submission |

### Dashboard Data Aggregation

```typescript
// GET /api/creators/me/dashboard
{
  earnings: {
    pending_balance: 45000,     // cents (from payment_splits)
    total_earned: 250000,       // lifetime
    this_month: 15000,
    payout_threshold: 5000,     // minimum for payout
    last_payout: { ... }
  },
  pending_counts: {
    st_applications: 3,
    cert_requests: 5
  },
  courses: [
    {
      id, title, thumbnail_url,
      student_count, completion_rate, rating,
      revenue: 125000  // Creator's 15% share
    }
  ],
  recent_activity: [...]
}
```

### Earnings Calculation (15% Royalty)

```typescript
// Payment split logic (per CD-020, CD-033):
// When S-T teaches a session:
//   Platform: 15%
//   Creator: 15%    ← This is what CDSH displays
//   S-T: 70%

// Query for creator earnings:
SELECT SUM(amount_cents) FROM payment_splits
WHERE recipient_id = :creator_id
  AND recipient_type = 'creator'
  AND status IN ('pending', 'paid')
GROUP BY status
```

### Pending Approvals Flow

```
ST Application Approval:
  1. GET /api/creators/me/pending-approvals
  2. Display list of pending ST applications
  3. Creator clicks "Approve" or "Decline"
  4. POST /api/student-teachers/:id/approve { approved: true }
  5. Backend:
     - Updates student_teachers.is_active = true
     - Sends email to approved ST (Resend)
     - Creates notification

Certificate Issuance:
  1. ST recommends student (via TDSH)
  2. Creator sees in pending-approvals
  3. Creator clicks "Issue Certificate"
  4. POST /api/certificates/:id/issue
  5. Backend:
     - Updates certificate.status = 'issued'
     - Generates PDF certificate (if applicable)
     - Sends email to student (Resend)
```

### Payout Request Flow

```
Request Payout:
  1. Creator clicks "Request Payout"
  2. POST /api/payouts/request { amount: <balance> }
  3. Backend:
     - Validates: balance >= threshold
     - Validates: stripe_payouts_enabled = true
     - Creates Stripe Transfer to creator's Express account
     - Records in payouts table
  4. Webhook: transfer.paid
     - Updates payout.status = 'paid'
     - Clears pending balance

Stripe Transfer:
  stripe.transfers.create({
    amount: balance_cents,
    currency: 'usd',
    destination: creator.stripe_account_id,
    transfer_group: 'payout-{creator_id}-{date}'
  })
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   CDSH      │      │  PeerLoop   │      │   Stripe    │
│   (Client)  │      │  (Server)   │      │  (Connect)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /dashboard     │                    │
       │───────────────────>│                    │
       │                    │ Query DB for:      │
       │                    │ - payment_splits   │
       │                    │ - courses          │
       │                    │ - pending approvals│
       │ { aggregated data }│                    │
       │<───────────────────│                    │
       │                    │                    │
       │ POST /payouts/     │                    │
       │   request          │                    │
       │───────────────────>│                    │
       │                    │ Create Transfer    │
       │                    │───────────────────>│
       │                    │ transfer_id        │
       │                    │<───────────────────│
       │ { payout_pending } │                    │
       │<───────────────────│                    │
       │                    │                    │
       │                    │ Webhook:           │
       │                    │ transfer.paid      │
       │                    │<───────────────────│
       │                    │ Update payout      │
```

---

## Notes

- CD-020: Creator gets 15% royalty (calculated in payment_splits)
- Creators may also be Students/STs (multi-role dashboard)
- Email notifications for pending approvals via Resend
- Payout requires active Stripe Connect (see SETT)
- Analytics could expand significantly (CANA page for detailed analytics)
