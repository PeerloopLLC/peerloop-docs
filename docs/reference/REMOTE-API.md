# PeerLoop - Remote API (External Services)

**Version:** v1
**Last Updated:** 2026-03-27 (Conv 037 — webhook status audit, BBB replaces PlugNmeet)
**Primary Source:** API.md v2, Service Research Docs

> This document defines all API endpoints that interact with external services (Stripe, Stream.io, BigBlueButton, Resend). For internal database endpoints, see [DB-API.md](DB-API.md).

---

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    External Service Integrations                 │
├─────────────────────────────────────────────────────────────────┤
│  Stripe Connect     Stream.io      BBB (Blindside)  Resend      │
│  ──────────────     ─────────      ───────────────   ──────      │
│  checkout           token          join              verification│
│  onboard            posts          room mgmt         password    │
│  transfers          feeds          recording         newsletter  │
│  webhooks ✅        (no webhooks)  webhooks ✅        bounce      │
│                                    analytics cb ✅                │
└─────────────────────────────────────────────────────────────────┘
```

### Webhook Status by Vendor (Conv 037)

| Vendor | Webhooks Used? | URL Configuration | Endpoint |
|--------|:-:|---|---|
| **Stripe** | ✅ Yes | Hardcoded in Stripe Dashboard (separate prod/staging URLs) | `POST /api/webhooks/stripe` |
| **BBB (Blindside)** | ✅ Yes | Per-meeting, auto-set from `request.origin` | `POST /api/webhooks/bbb` |
| **BBB Analytics** | ✅ Yes | Per-meeting via `meta_analytics-callback-url` | `POST /api/webhooks/bbb-analytics` |
| **Stream.io** | ❌ No | Available but not used — real-time handled client-side | — |
| **Resend** | ❌ No | Available (bounce/complaint tracking) — not configured | — |

---

## Service Provider Summary

| Provider | Purpose | Research Doc | Interface |
|----------|---------|--------------|-----------|
| **Stripe Connect** | Payments, payouts | `docs/reference/stripe.md` | PaymentProvider |
| **Stream.io** | Activity feeds | `docs/reference/stream.md` | FeedProvider |
| **BigBlueButton** | Video sessions | `docs/reference/bigbluebutton.md` | VideoProvider |
| **Resend** | Transactional email | `docs/reference/resend.md` | EmailProvider |

---

## Stripe Connect Endpoints

### POST /api/payments/connect/onboard

Start Stripe Connect Express onboarding for creators/STs.

| Field | Value |
|-------|-------|
| **Purpose** | Create Express account and onboarding link |
| **Auth** | Authenticated (creator or Teacher role) |
| **External Call** | `stripe.accounts.create()`, `stripe.accountLinks.create()` |
| **DB Tables** | `users.stripe_account_id`, `users.stripe_account_status` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

**Request:** None (uses authenticated user)

**Response:**
```json
{
  "onboarding_url": "https://connect.stripe.com/express/...",
  "account_id": "acct_xxx"
}
```

---

### GET /api/payments/connect/status

Check Stripe Connect account status.

| Field | Value |
|-------|-------|
| **Purpose** | Get current onboarding/payout status |
| **Auth** | Authenticated (creator or Teacher role) |
| **External Call** | `stripe.accounts.retrieve()` |
| **DB Tables** | `users.stripe_account_id`, `users.stripe_account_status`, `users.stripe_payouts_enabled` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

**Response:**
```json
{
  "connected": true,
  "account_id": "acct_xxx",
  "status": "active",
  "payouts_enabled": true,
  "details_submitted": true
}
```

---

### POST /api/payments/connect/dashboard

Get Stripe Express dashboard link.

| Field | Value |
|-------|-------|
| **Purpose** | Generate login link to Stripe Express dashboard |
| **Auth** | Authenticated (creator or Teacher role) |
| **External Call** | `stripe.accounts.createLoginLink()` |
| **DB Tables** | `users.stripe_account_id` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

**Response:**
```json
{
  "dashboard_url": "https://connect.stripe.com/express/..."
}
```

---

### POST /api/checkout/session

Create Stripe Checkout session for course enrollment.

| Field | Value |
|-------|-------|
| **Purpose** | Initiate payment for course enrollment |
| **Auth** | Authenticated |
| **External Call** | `stripe.checkout.sessions.create()` |
| **DB Tables** | `courses`, `users`, `enrollments` (created after webhook) |
| **DB-SCHEMA** | [courses](DB-SCHEMA.md#courses), [enrollments](DB-SCHEMA.md#enrollments) |

**Request:**
```json
{
  "course_id": "uuid",
  "st_id": "uuid (optional)"
}
```

**Response:**
```json
{
  "checkout_url": "https://checkout.stripe.com/...",
  "session_id": "cs_xxx"
}
```

---

### POST /api/payouts/request

Request payout of pending earnings.

| Field | Value |
|-------|-------|
| **Purpose** | Initiate transfer to creator/Teacher Stripe account |
| **Auth** | Authenticated (creator or Teacher role) |
| **External Call** | `stripe.transfers.create()` |
| **DB Tables** | `payment_splits`, `payouts`, `users.stripe_account_id` |
| **DB-SCHEMA** | [payment_splits](DB-SCHEMA.md#payment_splits), [payouts](DB-SCHEMA.md#payouts) |

**Request:**
```json
{
  "amount_cents": 50000
}
```

**Response:**
```json
{
  "payout_id": "uuid",
  "transfer_id": "tr_xxx",
  "amount_cents": 50000,
  "status": "pending"
}
```

---

### POST /api/webhooks/stripe

Stripe webhook receiver.

| Field | Value |
|-------|-------|
| **Purpose** | Process Stripe events |
| **Auth** | Stripe signature verification |
| **External Call** | N/A (receives from Stripe) |
| **DB Tables** | `enrollments`, `transactions`, `payment_splits`, `payouts`, `users` |

**Events Handled:**

| Event | Action | DB Update |
|-------|--------|-----------|
| `checkout.session.completed` | Create enrollment, split payments | `enrollments`, `transactions`, `payment_splits` |
| `account.updated` | Sync payout status | `users.stripe_account_status`, `users.stripe_payouts_enabled` |
| `transfer.paid` | Mark split as paid | `payment_splits.status`, `payment_splits.paid_at` |
| `charge.refunded` | Process refund | `transactions.status`, `payment_splits.status` |

---

## Stream.io Endpoints

### POST /api/stream/token

Generate Stream.io user token for client-side feed access.

| Field | Value |
|-------|-------|
| **Purpose** | Create JWT for Stream client SDK |
| **Auth** | Authenticated |
| **External Call** | `streamClient.createUserToken()` |
| **DB Tables** | `users`, `enrollments` (for feed access validation) |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users), [enrollments](DB-SCHEMA.md#enrollments) |

**Request:**
```json
{
  "requested_feeds": ["course:123", "instructor:456"]
}
```

**Response:**
```json
{
  "token": "eyJ...",
  "user_id": "user_123",
  "api_key": "xxx...",
  "allowed_feeds": ["course:123", "townhall:main", "user:*"]
}
```

**Access Control:** Server validates enrollment before granting course/instructor feed access.

---

### POST /api/posts

Create post in feed (stored locally + published to Stream).

| Field | Value |
|-------|-------|
| **Purpose** | Create post in feed |
| **Auth** | Authenticated |
| **External Call** | `streamClient.feed().addActivity()` |
| **DB Tables** | `posts` |
| **DB-SCHEMA** | [posts](DB-SCHEMA.md#posts) |

**Request:**
```json
{
  "content": "Hello world",
  "feed_type": "user | course | instructor",
  "feed_id": "course_123"
}
```

---

### POST /api/posts/:id/flag

Flag post for moderation.

| Field | Value |
|-------|-------|
| **Purpose** | Report inappropriate content |
| **Auth** | Authenticated |
| **External Call** | Stream moderation API (optional) |
| **DB Tables** | `content_flags`, `posts` |
| **DB-SCHEMA** | [content_flags](DB-SCHEMA.md#content_flags), [posts](DB-SCHEMA.md#posts) |

---

### POST /api/posts/:id/promote

Promote post to main feed using goodwill points.

| Field | Value |
|-------|-------|
| **Purpose** | Boost post visibility |
| **Auth** | Authenticated (post owner) |
| **External Call** | `streamClient.feed('townhall').addActivity()` |
| **DB Tables** | `posts`, `promoted_posts`, `users.goodwill_points` |
| **DB-SCHEMA** | [posts](DB-SCHEMA.md#posts), [promoted_posts](DB-SCHEMA.md#promoted_posts) |

---

## BigBlueButton (Blindside Networks) Endpoints

### POST /api/sessions/:id/join

Get BBB join URL for a video session. Creates the BBB meeting on-demand if it does not already exist.

| Field | Value |
|-------|-------|
| **Purpose** | Get join URL to enter video room |
| **Auth** | Authenticated (session participant) |
| **External Call** | BBB `create` (if needed) + `join` via checksum-authenticated GET |
| **DB Tables** | `sessions`, `session_attendance` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions), [session_attendance](DB-SCHEMA.md#session_attendance) |

**Request:** None (session ID is in URL path)

**Response:**
```json
{
  "join_url": "https://peerloop.api.rna1.blindsidenetworks.com/bigbluebutton/api/join?...",
  "room_created": true
}
```

**Flow:**
1. Verify user is session participant
2. Create BBB meeting if not exists (`create` API with checksum auth)
   - Sets `meta_endCallbackUrl` for meeting-ended webhook
   - Sets `meta_analytics-callback-url` for post-meeting analytics
   - Callback URLs derived from `request.url.origin` (self-configuring per environment)
3. Build signed join URL with role-appropriate password (moderator for Teacher, attendee for Student)
4. Return join URL — client opens in new tab via `window.open()` (iframe blocked by Blindside)

**BBB Authentication:** All API calls use checksum-based auth: `SHA1(apiName + queryString + BBB_SECRET)` appended as `&checksum=` parameter. No API key headers.

**Environment Variables:**
- `BBB_URL` — `https://peerloop.api.rna1.blindsidenetworks.com/bigbluebutton/api/`
- `BBB_SECRET` — 88-char shared secret from Blindside Networks

---

### POST /api/webhooks/bbb

BBB webhook receiver (meeting lifecycle events).

| Field | Value |
|-------|-------|
| **Purpose** | Process video session lifecycle events |
| **Auth** | Unauthenticated (BBB does not sign `meta_endCallbackUrl` callbacks) |
| **DB Tables** | `sessions`, `session_attendance` |

**Events Handled:**

| Event | Action | DB Update |
|-------|--------|-----------|
| `meeting-ended` | Mark session complete | `sessions.status = 'completed'`, `sessions.ended_at` |
| `user-joined` | Track attendance start | `session_attendance.joined_at` |
| `user-left` | Track attendance end | `session_attendance.left_at`, calculate duration |
| `rap-publish-ended` | Store recording URL | `sessions.recording_url` |

**Webhook healing:** If `meeting-ended` fails to fire, Teachers/Creators can manually complete via `POST /api/sessions/:id/complete`. All completion paths share `completeSession()` in `src/lib/booking.ts`.

---

### POST /api/webhooks/bbb-analytics

BBB analytics callback receiver (post-meeting engagement data).

| Field | Value |
|-------|-------|
| **Purpose** | Receive per-attendee engagement metrics after meeting ends |
| **Auth** | JWT Bearer token (HS512, verified with `BBB_SECRET`) |
| **DB Tables** | `session_analytics` |

**Activation:** Set `meta_analytics-callback-url` on the BBB `create` call. Blindside Networks POSTs analytics JSON after recording processing completes.

**Payload (key fields):**
```json
{
  "meeting_id": "session-uuid",
  "internal_meeting_id": "bbb-internal-id",
  "data": {
    "duration": 3196,
    "attendees": [{
      "ext_user_id": "user-uuid",
      "name": "Jane Doe",
      "moderator": true,
      "duration": 3171.0,
      "engagement": {
        "chats": 3,
        "talks": 318,
        "talk_time": 1746
      }
    }]
  }
}
```

**Response:** `200 OK` or `202 Accepted` (empty body). Return `410 Gone` if session was deleted.

**Status:** Endpoint built (`src/pages/api/webhooks/bbb-analytics.ts`), not yet activated in production. See `docs/reference/bigbluebutton.md` for setup steps.

---

## Resend Endpoints

### Email Sending (Internal)

These are internal functions called by other endpoints, not direct API routes:

| Function | Trigger | Template |
|----------|---------|----------|
| `sendVerificationEmail()` | POST /api/auth/signup | `email-verification` |
| `sendPasswordResetEmail()` | POST /api/auth/forgot-password | `password-reset` |
| `sendSessionReminder()` | Cron job (24h, 1h, 15m before) | `session-reminder` |
| `sendBookingConfirmation()` | POST /api/sessions | `session-booked` |
| `sendPayoutNotification()` | Stripe transfer.paid webhook | `payout-complete` |
| `sendNewsletter()` | POST /api/newsletters/:id/send | User-defined |

---

### POST /api/auth/resend-verification

Resend email verification.

| Field | Value |
|-------|-------|
| **Purpose** | Resend verification email |
| **Auth** | Public (with email) |
| **External Call** | Resend `emails.send()` |
| **DB Tables** | `users`, `email_verification_tokens` |
| **DB-SCHEMA** | [users](DB-SCHEMA.md#users) |

---

### POST /api/newsletters/:id/send

Send newsletter to subscribers.

| Field | Value |
|-------|-------|
| **Purpose** | Bulk send newsletter |
| **Auth** | Authenticated (creator) |
| **External Call** | Resend `batch.send()` or Broadcast API |
| **DB Tables** | `newsletters`, `newsletter_subscribers` |
| **DB-SCHEMA** | [newsletters](DB-SCHEMA.md#newsletters), [newsletter_subscribers](DB-SCHEMA.md#newsletter_subscribers) |

---

### POST /api/webhooks/resend

Resend webhook receiver.

| Field | Value |
|-------|-------|
| **Purpose** | Process email delivery events |
| **Auth** | Resend signature verification |
| **DB Tables** | `users` |

**Events Handled:**

| Event | Action | DB Update |
|-------|--------|-----------|
| `email.bounced` | Mark email invalid | `users.email_status = 'bounced'` |
| `email.complained` | Opt out of marketing | `users.marketing_opt_out = true` |

---

## Provider Interface Contracts

### VideoProvider (BigBlueButton)

```typescript
interface VideoProvider {
  readonly name: string;
  createRoom(options: CreateRoomOptions): Promise<Room>;
  endRoom(roomId: string): Promise<void>;
  getJoinUrl(roomId: string, participant: Participant, options?: CreateRoomOptions): Promise<JoinInfo>;
  getRoomInfo(roomId: string): Promise<RoomInfo>;
  isRoomActive(roomId: string): Promise<boolean>;
  getRecordings(roomId: string): Promise<Recording[]>;
  deleteRecording(recordingId: string): Promise<void>;
  parseWebhook(payload: unknown, signature?: string): WebhookEvent | null;
}
```

> **Implementation:** `src/lib/video/bbb.ts` (`BBBProvider` class). Types in `src/lib/video/types.ts`. Uses checksum-based API auth (SHA1), not API key headers. See `docs/reference/bigbluebutton.md` for integration details.

### FeedProvider (Stream.io)

```typescript
interface FeedProvider {
  generateToken(userId: string, validitySeconds?: number): string;
  addActivity(feedGroup: string, feedId: string, activity: FeedActivity): Promise<string>;
  getActivities(feedGroup: string, feedId: string, options?: FeedOptions): Promise<FeedActivity[]>;
  follow(feedGroup: string, feedId: string, targetGroup: string, targetId: string): Promise<void>;
  unfollow(feedGroup: string, feedId: string, targetGroup: string, targetId: string): Promise<void>;
}
```

### PaymentProvider (Stripe Connect)

```typescript
interface PaymentProvider {
  createCheckoutSession(options: CheckoutOptions): Promise<CheckoutResult>;
  createConnectedAccount(userId: string, email: string, role: string): Promise<string>;
  createOnboardingLink(accountId: string, returnUrl: string, refreshUrl: string): Promise<string>;
  createTransfer(options: TransferOptions): Promise<string>;
  reverseTransfer(transferId: string): Promise<void>;
  getAccountStatus(accountId: string): Promise<AccountStatus>;
}
```

### EmailProvider (Resend)

```typescript
interface EmailProvider {
  sendEmail(options: EmailOptions): Promise<string>;
  sendBatch(emails: EmailOptions[]): Promise<string[]>;
}
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v1 | 2025-12-26 | Split from API.md - external service endpoints |
