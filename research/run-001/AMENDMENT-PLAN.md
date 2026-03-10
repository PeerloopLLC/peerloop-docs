# RUN-001 Amendment Plan

**Created:** 2025-12-26
**Purpose:** Incorporate service API research into RUN-001 architecture documents

---

## Context

During the 2025-12-26 session, we resolved critical technology decisions and researched the API surfaces of our external services:

| Decision | Resolved To | Research Doc |
|----------|-------------|--------------|
| Video Platform | PlugNmeet | `docs/vendors/plugnmeet.md` |
| Activity Feeds | Stream.io (feeds only) | `docs/vendors/stream.md` |
| Payments | Stripe Connect (separate charges + transfers) | `docs/vendors/stripe.md` |
| Email | Resend + React Email | `docs/vendors/resend.md` |
| Calendar | Custom built + Google/Apple export | (in hosting decisions) |
| Recording Storage | PlugNmeet + R2 replication | (in hosting decisions) |

This knowledge has implications for:
- Server architecture (not yet documented)
- Database schema (needs new tables/fields)
- API surface (needs webhook endpoints, token endpoints)
- Page specifications (need implementation details)
- Page flows (service-specific redirects and callbacks)

---

## Amendment Sequence

### Step 1: Server Architecture (New Document)

**Output:** `SERVER.md` at root level

**Contents:**
- Cloudflare stack overview (Workers, Pages, D1, R2, KV)
- Route structure (`/api/*` endpoints)
- Middleware (auth, rate limiting, validation)
- Service integration layer (adapter pattern)
- Environment configuration

**Why First:** Everything else depends on understanding how the server works.

---

### Step 2: Service Adapter Contracts

**Output:** New section in `API.md` or separate `ADAPTERS.md`

**Define interfaces:**
```typescript
VideoProvider    → PlugNmeetAdapter
FeedProvider     → StreamAdapter
PaymentProvider  → StripeAdapter
EmailProvider    → ResendAdapter
```

**For each adapter:**
- Interface methods
- Implementation mapping to service API
- Error handling patterns
- Configuration requirements

**Why:** Maintains abstraction layer from RUN-001 while documenting concrete implementations.

---

### Step 3: Webhook Architecture

**Output:** Section in `SERVER.md` or separate `WEBHOOKS.md`

**Document for each service:**

| Service | Endpoint | Events | DB Impact |
|---------|----------|--------|-----------|
| PlugNmeet | `/api/webhooks/plugnmeet` | participant_joined/left, room_finished, recording_proceeded | session_attendance, sessions |
| Stripe | `/api/webhooks/stripe` | checkout.session.completed, charge.refunded, transfer.paid, account.updated | enrollments, transactions, payment_splits, users |
| Resend | `/api/webhooks/resend` | email.bounced, email.complained, email.failed | users (email status) |
| Stream | `/api/webhooks/stream` | (if needed) | TBD |

**Include:**
- Signature verification pattern
- Idempotency handling
- Error/retry behavior
- Webhook event → handler → DB update flow

---

### Step 4: DB-SCHEMA.md Update

**Add new tables:**

```sql
-- Session attendance tracking (from PlugNmeet webhooks)
session_attendance (
  id, session_id, user_id, joined_at, left_at, duration_seconds
)

-- Payment splits (from Stripe transfers)
payment_splits (
  id, enrollment_id, transaction_id, recipient_id, recipient_type,
  amount_cents, stripe_transfer_id, status, created_at, paid_at
)
```

**Add new fields to existing tables:**

```sql
-- users
stripe_account_id, stripe_account_status, stripe_payouts_enabled

-- sessions
plugnmeet_room_id, plugnmeet_room_sid
```

---

### Step 5: API.md Update

**Add new endpoints:**

| Endpoint | Purpose |
|----------|---------|
| `POST /api/webhooks/plugnmeet` | PlugNmeet event handler |
| `POST /api/webhooks/stripe` | Stripe event handler |
| `POST /api/webhooks/resend` | Resend event handler |
| `POST /api/stream/token` | Generate Stream user token |
| `POST /api/video/room` | Create PlugNmeet room (proxy) |
| `POST /api/video/join` | Get PlugNmeet join token (proxy) |
| `POST /api/payments/connect/onboard` | Start Stripe Connect onboarding |
| `GET /api/payments/connect/status` | Check Connect account status |

**Expand existing endpoint documentation with service-specific details.**

---

### Step 6: Page-by-Page Review

**Process:** For each of the 38 page files in `runs/run-001/pages/`:

1. Does the data flow change based on service APIs?
2. Are there new UI elements needed (loading states, error handling)?
3. Are there new page states (waiting for webhook, pending verification)?
4. How does the page connect to server endpoints?
5. Are there service-specific redirects or callbacks?

**Priority pages (High Impact):**
- `page-SROM-session-room.md` - PlugNmeet join flow
- `page-SBOK-session-booking.md` - Custom calendar
- `page-STAV-st-availability.md` - Availability picker
- `page-CDSH-creator-dashboard.md` - Earnings display (85% or 15%)
- `page-STDH-st-dashboard.md` - Teacher earnings (70%)
- `page-PSET-payout-settings.md` - Stripe Connect onboarding
- `page-FEED-community-feed.md` - Stream token flow
- `page-CFED-course-feed.md` - Gated feed access

**Add to each affected page:**
- "Server Integration" section
- Service-specific notes
- Redirect/callback flows

---

### Step 7: Page Flow Review

**Output:** Updated flow diagrams or new `FLOWS.md`

**Key flows to document:**

1. **Session Booking Flow**
   ```
   Course Detail → Select Teacher → View Availability →
   Select Time → Checkout → Confirmation →
   (Webhook: enrollment created) → Calendar Export
   ```

2. **Session Join Flow**
   ```
   Dashboard → Upcoming Session → Join Button →
   API: Get PlugNmeet Token → Redirect to PlugNmeet →
   (Webhook: participant_joined) → Session →
   (Webhook: room_finished) → Recording Available
   ```

3. **Payout Setup Flow**
   ```
   Settings → Payout Setup → Start Onboarding →
   Redirect to Stripe → Complete KYC →
   Return URL → (Webhook: account.updated) →
   Payouts Enabled
   ```

4. **Feed Access Flow**
   ```
   Page Load → Check Enrollment (our DB) →
   If Enrolled: Fetch Stream Token → Connect to Stream →
   Render Feed
   ```

---

## Tracking

| Step | Status | Output |
|------|--------|--------|
| 1. Server Architecture | ✅ Complete | `SERVER.md` |
| 2. Service Adapters | ✅ Complete | `API.md` (v2) |
| 3. Webhook Architecture | ✅ Complete | `SERVER.md` + `API.md` |
| 4. DB-SCHEMA Update | ✅ Complete | `DB-SCHEMA.md` (v2) |
| 5. API.md Update | ✅ Complete | (Merged into Step 2) |
| 6. Page Review | ✅ Complete | 7 priority pages updated |
| 7. Flow Review | ✅ Complete | `FLOWS.md` (5 user journeys) |

---

## Notes

- This is an **amendment** to RUN-001, not a new RUN
- RUN-001's WHAT (features, stories, page purposes) remains unchanged
- We are adding HOW (implementation details from service research)
- The VideoProvider abstraction remains - PlugNmeet implements it
- Pages may gain "Server Integration" sections but core specs stay

---

## Session Reference

Research completed 2025-12-26:
- PlugNmeet API surface (rooms, tokens, recordings, webhooks)
- Stream.io token generation and permission model
- Stripe Connect separate charges + transfers pattern
- Resend API and React Email integration
