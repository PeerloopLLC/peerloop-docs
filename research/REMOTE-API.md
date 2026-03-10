# PeerLoop - Remote API (External Services)

**Version:** v1
**Last Updated:** 2025-12-26
**Primary Source:** API.md v2, Service Research Docs

> This document defines all API endpoints that interact with external services (Stripe, Stream.io, PlugNmeet, Resend). For internal database endpoints, see [DB-API.md](DB-API.md).

---

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    External Service Integrations                 │
├─────────────────────────────────────────────────────────────────┤
│  Stripe Connect     Stream.io      PlugNmeet       Resend       │
│  ──────────────     ─────────      ─────────       ──────       │
│  checkout           token          token           verification │
│  onboard            posts          room            password     │
│  transfers          feeds          recording       newsletter   │
│  webhooks           webhooks       webhooks        bounce       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Service Provider Summary

| Provider | Purpose | Research Doc | Interface |
|----------|---------|--------------|-----------|
| **Stripe Connect** | Payments, payouts | `docs/vendors/stripe.md` | PaymentProvider |
| **Stream.io** | Activity feeds | `docs/vendors/stream.md` | FeedProvider |
| **PlugNmeet** | Video sessions | `docs/vendors/plugnmeet.md` | VideoProvider |
| **Resend** | Transactional email | `docs/vendors/resend.md` | EmailProvider |

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

## PlugNmeet Endpoints

### POST /api/video/token

Generate PlugNmeet join token for video session.

| Field | Value |
|-------|-------|
| **Purpose** | Get token to join video room |
| **Auth** | Authenticated (session participant) |
| **External Call** | PlugNmeet `POST /auth/room/getJoinToken` |
| **DB Tables** | `sessions`, `session_attendance` |
| **DB-SCHEMA** | [sessions](DB-SCHEMA.md#sessions), [session_attendance](DB-SCHEMA.md#session_attendance) |

**Request:**
```json
{
  "session_id": "uuid"
}
```

**Response:**
```json
{
  "join_url": "https://plugnmeet.peerloop.com/...",
  "token": "jwt-token-here",
  "room_id": "peerloop-session-{session_id}"
}
```

**Flow:**
1. Verify user is session participant
2. Create room if not exists (`POST /auth/room/create`)
3. Generate join token (`POST /auth/room/getJoinToken`)
4. Return join URL

---

### POST /api/webhooks/plugnmeet

PlugNmeet webhook receiver.

| Field | Value |
|-------|-------|
| **Purpose** | Process video session events |
| **Auth** | PlugNmeet signature verification |
| **DB Tables** | `sessions`, `session_attendance` |

**Events Handled:**

| Event | Action | DB Update |
|-------|--------|-----------|
| `participant_joined` | Track attendance start | `session_attendance.joined_at` |
| `participant_left` | Track attendance end | `session_attendance.left_at`, calculate duration |
| `room_finished` | Mark session complete | `sessions.status = 'completed'`, `sessions.ended_at` |
| `recording_proceeded` | Replicate to R2 | `sessions.recording_url` |

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

### VideoProvider (PlugNmeet)

```typescript
interface VideoProvider {
  createRoom(options: CreateRoomOptions): Promise<Room>;
  deleteRoom(roomId: string): Promise<void>;
  getJoinToken(roomId: string, participant: Participant): Promise<JoinToken>;
  getRoomStatus(roomId: string): Promise<RoomStatus>;
}
```

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
