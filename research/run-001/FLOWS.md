# User Journey Flows

**Created:** 2025-12-26
**Purpose:** Document key user journeys with service-specific integration details.

---

## Overview

These flows show how users interact with PeerLoop and how external services (PlugNmeet, Stream.io, Stripe, Resend) are integrated at each step.

| Flow | Primary Services | Key Pages |
|------|------------------|-----------|
| Session Booking | Stripe, Resend | CDET → SBOK → SDSH |
| Session Join | PlugNmeet | SDSH/TDSH → SROM |
| Payout Setup | Stripe Connect | SETT |
| Feed Access | Stream.io | FEED, IFED |
| Enrollment | Stripe, Resend, Stream | CDET → Checkout → SDSH |

---

## 1. Session Booking Flow

**Goal:** Student books a 1-on-1 tutoring session with a Student-Teacher.

### Happy Path

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SESSION BOOKING FLOW                            │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   CDET   │     │   SBOK   │     │   SBOK   │     │   SBOK   │
│  Course  │────>│ Select   │────>│ Select   │────>│ Select   │
│  Detail  │     │   S-T    │     │   Date   │     │   Time   │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     │                │                │                │
     v                v                v                v
  "Book a         GET /api/        GET /api/        User picks
  Session"        courses/:id/     sts/:id/         time slot
  clicked         sts              availability
                                   + bookings

                                                        │
                                                        v
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   SDSH   │     │  (Email) │     │   SBOK   │     │   SBOK   │
│Dashboard │<────│  Resend  │<────│ Success  │<────│ Confirm  │
│          │     │          │     │          │     │          │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     ^                ^                ^                │
     │                │                │                │
     │                │                │                v
  Shows new      Confirmation     Session         POST /api/
  upcoming       email sent       created         sessions
  session        to both                          (validates slot)
```

### Detailed Steps

| Step | Page | Action | API Call | Service |
|------|------|--------|----------|---------|
| 1 | CDET | Click "Book a Session" | - | - |
| 2 | SBOK | View available S-Ts | `GET /api/courses/:id/sts` | - |
| 3 | SBOK | Select S-T | - | - |
| 4 | SBOK | View calendar | `GET /api/sts/:id/availability` | - |
| 5 | SBOK | See booked slots | `GET /api/sts/:id/bookings` | - |
| 6 | SBOK | Select date + time | - | - |
| 7 | SBOK | Confirm booking | `POST /api/sessions` | - |
| 8 | Server | Validate slot available | DB transaction | - |
| 9 | Server | Create session record | DB insert | - |
| 10 | Server | Send confirmation | `resend.emails.send()` | **Resend** |
| 11 | SBOK | Show success | - | - |
| 12 | SBOK | Export to calendar | `GET /api/sessions/:id/calendar-export` | - |
| 13 | SDSH | View upcoming session | - | - |

### With Payment (Per-Session Pricing)

```
After Step 7 (Confirm):
  ┌──────────────────────────────────────────────────────┐
  │                 PAYMENT BRANCH                        │
  └──────────────────────────────────────────────────────┘

  SBOK ──> POST /api/checkout/session
       │
       v
  Stripe Checkout (redirect)
       │
       v
  User completes payment
       │
       v
  Webhook: checkout.session.completed
       │
       v
  Server: session.status = 'scheduled'
       │
       v
  Continue to Step 10 (Resend confirmation)
```

### "Schedule Later" Variant

```
After Step 3 (Select S-T):

  User clicks "Schedule Later"
       │
       v
  POST /api/enrollments/:id/deferred
       │
       v
  SDSH: "Schedule when ready" card shown
       │
       v
  User can book anytime from dashboard
```

---

## 2. Session Join Flow

**Goal:** Participant joins scheduled video session via PlugNmeet.

### Happy Path

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          SESSION JOIN FLOW                              │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│SDSH/TDSH │     │   SROM   │     │   SROM   │     │ PlugNmeet│
│Dashboard │────>│ Pre-Join │────>│  Video   │────>│  Room    │
│          │     │  Screen  │     │  Room    │     │          │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     │                │                │                │
     v                v                v                v
  "Join"          GET /api/       POST /api/       Iframe or
  clicked         sessions/:id    video/token      redirect
  (15min                          ───────────────────>
  before)                              │
                                       v
                                  PlugNmeet API:
                                  - createRoom()
                                  - getJoinToken()

                                                        │
                                                        v
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   SROM   │     │  Server  │     │ PlugNmeet│     │ PlugNmeet│
│ Feedback │<────│ Webhooks │<────│ Webhooks │<────│  Session │
│  Modal   │     │ Handler  │     │          │     │   Ends   │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     │                │                │                │
     v                v                v                v
  User rates     DB updates:      participant_     room_finished
  session        - attendance     joined/left      event
                 - session.status
                 - recording_url
```

### Detailed Steps

| Step | Page | Action | API Call | Service |
|------|------|--------|----------|---------|
| 1 | SDSH/TDSH | Click "Join Session" | - | - |
| 2 | SROM | Load pre-join screen | `GET /api/sessions/:id` | - |
| 3 | SROM | Device check | Browser APIs | - |
| 4 | SROM | Click "Join" | `POST /api/video/token` | - |
| 5 | Server | Create room if needed | `plugnmeet.createRoom()` | **PlugNmeet** |
| 6 | Server | Get join token | `plugnmeet.getJoinToken()` | **PlugNmeet** |
| 7 | SROM | Enter video room | Redirect/iframe | **PlugNmeet** |
| 8 | PlugNmeet | Participant joins | Webhook: `participant_joined` | **PlugNmeet** |
| 9 | Server | Record attendance | `INSERT session_attendance` | - |
| 10 | PlugNmeet | Session in progress | - | **PlugNmeet** |
| 11 | PlugNmeet | Participant leaves | Webhook: `participant_left` | **PlugNmeet** |
| 12 | Server | Update attendance | `UPDATE session_attendance.left_at` | - |
| 13 | PlugNmeet | Room ends | Webhook: `room_finished` | **PlugNmeet** |
| 14 | Server | Complete session | `UPDATE sessions.status = 'completed'` | - |
| 15 | SROM | Show feedback modal | - | - |
| 16 | SROM | Submit feedback | `POST /api/sessions/:id/feedback` | - |
| 17 | PlugNmeet | Recording processed | Webhook: `recording_proceeded` | **PlugNmeet** |
| 18 | Server | Store recording | Download → R2 upload | **R2** |

### Webhook Timeline

```
Session Lifecycle (via webhooks):

Time ─────────────────────────────────────────────────────────────>

     ┌─────────────┐         ┌─────────────┐         ┌─────────────┐
     │ participant │         │ participant │         │   room      │
     │   _joined   │         │    _left    │         │  _finished  │
     └──────┬──────┘         └──────┬──────┘         └──────┬──────┘
            │                       │                       │
            v                       v                       v
     session_attendance      duration_seconds         sessions.status
     .joined_at = NOW()      calculated               = 'completed'
                                                           │
                                                           v
                                                    ┌─────────────┐
                                                    │  recording  │
                                                    │ _proceeded  │
                                                    └──────┬──────┘
                                                           │
                                                           v
                                                    Download to R2
                                                    Update recording_url
```

---

## 3. Payout Setup Flow

**Goal:** ST or Creator connects Stripe account to receive payouts.

### Happy Path

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         PAYOUT SETUP FLOW                               │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   SETT   │     │  Server  │     │  Stripe  │     │  Stripe  │
│ Payment  │────>│  Create  │────>│  Create  │────>│ Onboard  │
│ Settings │     │ Express  │     │  Account │     │   Page   │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     │                │                │                │
     v                v                v                v
  "Connect        POST /api/       stripe.          User does
  Stripe"         payments/        accounts.        KYC, adds
  clicked         connect/         create()         bank account
                  onboard          ───────────────────>
                                       │
                                       v
                                  stripe.
                                  accountLinks.
                                  create()

                                                        │
                                                        v
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   SETT   │     │  Server  │     │  Stripe  │     │  Stripe  │
│ Shows    │<────│ Webhook  │<────│ Webhook  │<────│ Complete │
│Connected │     │ Handler  │     │ account. │     │          │
└──────────┘     └──────────┘     │ updated  │     └──────────┘
     │                │           └──────────┘          │
     │                │                                 │
     v                v                                 v
  Badge:          DB updates:                      Return to
  "Payouts        stripe_account_status            /settings/
  Enabled"        stripe_payouts_enabled           payment
```

### Detailed Steps

| Step | Page | Action | API Call | Service |
|------|------|--------|----------|---------|
| 1 | SETT | Click "Connect Stripe" | `POST /api/payments/connect/onboard` | - |
| 2 | Server | Create Express account | `stripe.accounts.create()` | **Stripe** |
| 3 | Server | Store account ID | `UPDATE users.stripe_account_id` | - |
| 4 | Server | Create onboarding link | `stripe.accountLinks.create()` | **Stripe** |
| 5 | SETT | Redirect to Stripe | Browser redirect | **Stripe** |
| 6 | Stripe | User completes KYC | - | **Stripe** |
| 7 | Stripe | User adds bank account | - | **Stripe** |
| 8 | Stripe | User accepts terms | - | **Stripe** |
| 9 | Stripe | Redirect back | Return URL | - |
| 10 | Stripe | Account updated | Webhook: `account.updated` | **Stripe** |
| 11 | Server | Update status | `UPDATE users.stripe_account_status` | - |
| 12 | Server | Check payouts enabled | `UPDATE users.stripe_payouts_enabled` | - |
| 13 | Server | Send notification | `resend.emails.send()` | **Resend** |
| 14 | SETT | Show connected status | `GET /api/payments/connect/status` | - |

### Stripe Connect States

```
State Machine:

  ┌─────────────────┐
  │  Not Connected  │ stripe_account_id = null
  └────────┬────────┘
           │ "Connect Stripe" clicked
           v
  ┌─────────────────┐
  │   Onboarding    │ stripe_account_id set
  │   In Progress   │ stripe_account_status = 'pending'
  └────────┬────────┘
           │ Webhook: account.updated (charges_enabled=true)
           v
  ┌─────────────────┐
  │    Connected    │ stripe_account_status = 'active'
  │ (Payouts OFF)   │ stripe_payouts_enabled = false
  └────────┬────────┘
           │ Webhook: account.updated (payouts_enabled=true)
           v
  ┌─────────────────┐
  │  Fully Active   │ stripe_account_status = 'active'
  │                 │ stripe_payouts_enabled = true
  └─────────────────┘
```

### Payout Request (After Setup)

```
When user requests payout:

  CDSH/TDSH: "Request Payout" clicked
       │
       v
  POST /api/payouts/request { amount: balance }
       │
       v
  Server validates:
  - balance >= threshold
  - stripe_payouts_enabled = true
       │
       v
  stripe.transfers.create({
    amount: balance_cents,
    destination: stripe_account_id
  })
       │
       v
  Record in payouts table (status: 'pending')
       │
       v
  Webhook: transfer.paid
       │
       v
  UPDATE payouts.status = 'paid'
  UPDATE payment_splits.status = 'paid'
```

---

## 4. Feed Access Flow

**Goal:** User accesses community or instructor feed with proper permissions.

### Community Feed (FEED)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      COMMUNITY FEED ACCESS FLOW                         │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   Nav    │     │   FEED   │     │  Server  │     │ Stream   │
│ "Feed"   │────>│  Page    │────>│  Token   │────>│  Client  │
│ clicked  │     │  Load    │     │ Generate │     │ Connect  │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     │                │                │                │
     v                v                v                v
  Navigate        POST /api/      Generate         stream.
  to /feed        stream/token    user token       connect()
                                  with perms
                                       │
                                       v
                                  Allowed feeds:
                                  - timeline:user_id
                                  - townhall:main
                                  - followed feeds

                                                        │
                                                        v
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   FEED   │<────│ Stream   │<────│ Stream   │<────│ Stream   │
│  Render  │     │  Real-   │     │  Feed    │     │Subscribe │
│  Posts   │     │  time    │     │  Data    │     │          │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     │                │                │                │
     v                v                v                v
  Display         WebSocket        feed.get()      feed.
  activities      updates          { limit: 25 }   subscribe()
```

### Instructor Feed (IFED) - Gated Access

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    INSTRUCTOR FEED ACCESS FLOW                          │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────┐     ┌──────────┐     ┌──────────┐
│   CPRO   │     │   IFED   │     │  Server  │
│ Creator  │────>│  Page    │────>│  Check   │
│ Profile  │     │  Load    │     │  Access  │
└──────────┘     └──────────┘     └──────────┘
     │                │                │
     v                v                v
  "View Feed"     GET /api/       Query:
  clicked         instructors/    instructor_followers
                  :id/feed/       WHERE follower = user
                  access
                                       │
                          ┌────────────┴────────────┐
                          v                         v
                    ┌──────────┐             ┌──────────┐
                    │  Access  │             │    No    │
                    │ Granted  │             │  Access  │
                    └────┬─────┘             └────┬─────┘
                         │                        │
                         v                        v
                   POST /api/               403 Error:
                   stream/token             "Enroll in a
                   { feeds:                 course to
                     ['instructor:X'] }     access"
                         │
                         v
                   Token with
                   instructor:X
                   permission
                         │
                         v
                   stream.connect()
                   instructorFeed.get()
                   instructorFeed.subscribe()
```

### Detailed Steps (IFED)

| Step | Page | Action | API Call | Service |
|------|------|--------|----------|---------|
| 1 | CPRO | Click "View Feed" | - | - |
| 2 | IFED | Check access | `GET /api/instructors/:id/feed/access` | - |
| 3 | Server | Query followers | `SELECT FROM instructor_followers` | - |
| 4a | - | If no access | Return 403 | - |
| 4b | IFED | If access granted | `POST /api/stream/token` | - |
| 5 | Server | Validate feeds requested | Check instructor_followers | - |
| 6 | Server | Generate scoped token | `streamClient.createUserToken()` | **Stream** |
| 7 | IFED | Connect to Stream | `stream.connect()` | **Stream** |
| 8 | IFED | Get feed data | `instructorFeed.get()` | **Stream** |
| 9 | IFED | Subscribe real-time | `instructorFeed.subscribe()` | **Stream** |
| 10 | IFED | Render posts | - | - |

### Access Grant Trigger

```
When user enrolls in course:

  CDET: "Enroll" clicked
       │
       v
  Checkout complete (Stripe webhook)
       │
       v
  Server: INSERT enrollment
       │
       v
  Trigger: Check instructor_followers
       │
       ├── IF NOT EXISTS follower record
       │         │
       │         v
       │   INSERT INTO instructor_followers
       │   (instructor_id, follower_id, created_at)
       │   VALUES (course.creator_id, user.id, NOW())
       │
       └── Access now granted for IFED
```

---

## 5. Enrollment Flow (Bonus)

**Goal:** Student enrolls in a course (combines payment, email, feed access).

### Happy Path

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         ENROLLMENT FLOW                                 │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   CDET   │     │  Stripe  │     │  Stripe  │     │  Server  │
│ "Enroll" │────>│ Checkout │────>│ Payment  │────>│ Webhook  │
│ clicked  │     │ Redirect │     │ Complete │     │ Handler  │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     v                v                v                v
  POST /api/      stripe.          User pays       checkout.
  checkout/       checkout.                        session.
  session         sessions.                        completed
                  create()

                                                        │
                                                        v
                                                  ┌─────────────────────┐
                                                  │ Server Processing:  │
                                                  │                     │
                                                  │ 1. Create enrollment│
                                                  │ 2. Create payment   │
                                                  │    splits (15/15/70)│
                                                  │ 3. Grant instructor │
                                                  │    feed access      │
                                                  │ 4. Send welcome     │
                                                  │    email (Resend)   │
                                                  └──────────┬──────────┘
                                                             │
                                                             v
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│   SDSH   │<────│  (Email) │<────│  Server  │<────│  Return  │
│Dashboard │     │  Resend  │     │  Finish  │     │   URL    │
│          │     │          │     │          │     │          │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     v                v                v                v
  Shows new      Welcome email    Processing       Redirect
  enrollment     with course      complete         to /dashboard
                 access info
```

### Payment Split Creation

```
On checkout.session.completed:

  Course price: $100
       │
       v
  Platform: 15% = $15  ──> payment_splits (recipient_type: 'platform')
  Creator:  15% = $15  ──> payment_splits (recipient_type: 'creator')
  S-T Pool: 70% = $70  ──> Held until sessions taught
       │
       v
  When S-T teaches session:
  - S-T gets $70 ──> payment_splits (recipient_type: 'student_teacher')
  - Status: 'pending' until payout requested
```

---

## Service Integration Summary

| Service | Events We Receive | Actions We Take |
|---------|-------------------|-----------------|
| **PlugNmeet** | participant_joined, participant_left, room_finished, recording_proceeded | Update attendance, session status, store recordings |
| **Stripe** | checkout.session.completed, transfer.paid, account.updated, charge.refunded | Create enrollments, update payouts, update Connect status |
| **Stream.io** | (real-time via WebSocket) | Render feeds, update UI |
| **Resend** | email.bounced, email.complained, email.failed | Update user email status |

---

## Error Flows

### Session Booking Failures

```
Slot no longer available:
  POST /api/sessions → 409 Conflict
  └── Show: "This time is no longer available. Select another."

Payment failed:
  Stripe Checkout → Payment declined
  └── Show: "Payment failed. Please try again."

Booking service error:
  POST /api/sessions → 500
  └── Show: "Unable to book. Please try again."
```

### Session Join Failures

```
Not authorized:
  GET /api/sessions/:id → 403
  └── Show: "You're not part of this session."

PlugNmeet unavailable:
  POST /api/video/token → 503
  └── Show: "Video service unavailable. Try again."

Token generation failed:
  PlugNmeet API error
  └── Show: "Unable to connect. [Retry]"
```

### Payout Failures

```
Balance below threshold:
  POST /api/payouts/request → 400
  └── Show: "Minimum balance not reached."

Stripe not connected:
  POST /api/payouts/request → 400
  └── Show: "Connect Stripe account first."

Transfer failed:
  Stripe API error
  └── Show: "Unable to process. Please try again."
```
