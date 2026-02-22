# API Reference: Payments

Checkout, Stripe Connect, and webhook endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Checkout Endpoints

### POST /api/checkout/create-session

Create a Stripe Checkout session for course enrollment.

**Authentication:** Required

**Request:**
```json
{
  "courseId": "crs-ai-tools-overview",
  "studentTeacherId": "usr-sarah-miller"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `courseId` | string | Yes | Course ID to enroll in |
| `studentTeacherId` | string | No | Optional S-T for guided learning |

**Response (200):**
```json
{
  "sessionId": "cs_test_...",
  "url": "https://checkout.stripe.com/c/pay/cs_test_..."
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Course ID is required |
| 401 | Authentication required |
| 404 | Course not found |
| 409 | Already enrolled in this course |
| 400 | Creator has not connected their Stripe account |
| 400 | Invalid student-teacher specified |
| 500 | Failed to create checkout session |

**Notes:**
- Creates Stripe Checkout Session with course metadata
- Redirects to Stripe hosted payment page
- Success URL: `/courses/[slug]/success`
- Cancel URL: `/courses/[slug]`

---

## Stripe Connect Endpoints

### POST /api/stripe/connect

Create a Stripe Express connected account for a creator or student-teacher.

**Authentication:** Required (must be creator or student-teacher)

**Request:**
```json
{
  "type": "creator"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | string | No | Account type: "creator" or "student_teacher" (default: "creator") |

**Response (200):**
```json
{
  "accountId": "acct_...",
  "accountLinkUrl": "https://connect.stripe.com/setup/..."
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | Must be a creator or student-teacher to connect Stripe |
| 409 | Stripe account already connected |
| 500 | Failed to create Stripe account |

**Notes:**
- Creates Stripe Express account with platform-managed payouts
- Returns onboarding URL for immediate redirect
- Account ID stored in `users.stripe_account_id`

---

### GET /api/stripe/connect-link

Get Stripe Connect onboarding or dashboard URL.

**Authentication:** Required

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `type` | string | "onboarding" | Link type: "onboarding" or "dashboard" |

**Response (200) - Onboarding:**
```json
{
  "url": "https://connect.stripe.com/setup/...",
  "type": "onboarding"
}
```

**Response (200) - Dashboard:**
```json
{
  "url": "https://connect.stripe.com/express/...",
  "type": "dashboard"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 404 | No Stripe account connected |
| 500 | Failed to create account link |

---

### GET /api/stripe/connect-status

Check connected account status and requirements. Self-healing: derives status from Stripe's live API data and syncs the database if the stored status has drifted (e.g., missed webhook).

**Authentication:** Required

**Response (200) - Not Connected:**
```json
{
  "connected": false,
  "accountId": null
}
```

**Response (200) - Connected:**
```json
{
  "connected": true,
  "accountId": "acct_...",
  "chargesEnabled": true,
  "payoutsEnabled": true,
  "detailsSubmitted": true,
  "status": "active",
  "requirements": {
    "currentlyDue": [],
    "eventuallyDue": [],
    "pastDue": []
  }
}
```

**Status Values:**

| Status | Meaning |
|--------|---------|
| `active` | Account fully functional, can receive payments |
| `pending` | Onboarding incomplete, details not yet submitted |
| `restricted` | Some requirements pending, limited functionality |

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 500 | Failed to fetch account status |

---

## Webhook Endpoints

### POST /api/webhooks/stripe

Handle Stripe webhook events for payment processing.

**Authentication:** Stripe signature verification (webhook secret)

**Headers:**
```
stripe-signature: t=...,v1=...,v0=...
```

**Handled Events:**

| Event | Action |
|-------|--------|
| `checkout.session.completed` | Creates enrollment, transaction, payment splits, initiates transfers (with idempotency keys), sends enrollment confirmation email (transactional, always sends) |
| `charge.refunded` | Cancels enrollment (full) or updates transaction (partial), reverses transfers |
| `account.updated` | Syncs connected account status to users table |
| `transfer.created` | Updates payment_splits status to 'paid' with timestamp (safety net) |
| `charge.dispute.created` | Freezes enrollment (status → 'disputed'), marks transaction, notifies admin |
| `charge.dispute.closed` | Restores enrollment if won; cancels + reverses transfers if lost |
| `payout.failed` | Updates payout status, creates notification for affected user |

**Response (200):**
```json
{
  "received": true
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Missing stripe-signature header |
| 400 | Webhook signature verification failed |
| 500 | Webhook processing error |

**Notes:**
- Requires `STRIPE_WEBHOOK_SECRET` environment variable
- Use `npm run stripe:listen` for local testing (forwards to localhost:4321)
- Enrollment metadata stored in checkout session
- Transfers use idempotency keys (`transfer_{group}_{recipientType}_{recipientId}`) to prevent duplicates on retry
- `payout.failed` is handled in the default switch block (not in Stripe SDK type union; requires "Connected accounts" webhook context for staging/production)
- `transfer.created` and dispute events are proper `case` statements in the switch block
- Dispute handlers freeze/restore enrollments and reverse transfers on loss — see tech-003-stripe.md for full event context documentation

---

### POST /api/webhooks/bbb

Handle BigBlueButton webhook events for session tracking.

**Authentication:** None (BBB server callback)

**Handled Events:**

| Event | Action |
|-------|--------|
| `meeting-started` | Mark session as `in_progress` |
| `meeting-ended` | Mark session as `completed` |
| `user-joined` | Create attendance record |
| `user-left` | Update attendance duration |
| `rap-publish-ended` | Store recording URL |

**Response (200):**
```json
{
  "status": "processed",
  "event_type": "meeting-ended",
  "session_id": "..."
}
```
