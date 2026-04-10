# tech-003: Stripe Connect

**Type:** Payment Processing & Marketplace Payouts
**Status:** ✅ SELECTED (DIR-004)
**Research Date:** 2025-12-26
**Source:** https://stripe.com/connect

---

## Overview

Stripe Connect enables platforms to process payments and distribute funds to multiple recipients. PeerLoop uses Connect to handle course payments and split revenue between Platform, Creator, and Teacher.

## PeerLoop Payment Splits

| Scenario | Platform | Creator | Teacher |
|----------|----------|---------|---------|
| Creator teaches | 15% | 85% | - |
| Teacher teaches | 15% | 15% | 70% |

**Example ($450 course):**
- Creator teaches: Platform $67.50, Creator $382.50
- Teacher teaches: Platform $67.50, Creator $67.50, Teacher $315.00

---

## Stripe Connect Charge Types

### 1. Direct Charges
- Payment created on connected account directly
- Platform earns via application fees
- Best for: SaaS platforms (Shopify, Thinkific)
- **Not ideal for PeerLoop** - we need to split to multiple recipients

### 2. Destination Charges
- Charge on platform, immediate transfer to ONE connected account
- Single recipient per charge
- Best for: Ridesharing, rentals
- **Not ideal for PeerLoop** - can't split to Creator AND Teacher

### 3. Separate Charges and Transfers ✅ RECOMMENDED
- Charge on platform, separate transfers to MULTIPLE accounts
- Full control over split amounts and timing
- Best for: Marketplaces splitting between multiple parties (DoorDash)
- **Ideal for PeerLoop** - supports Creator + Teacher + Platform split

---

## API Reference

### Server-Side SDK Setup

**Package:** `stripe` (SDK v20.x — major bump to v22 deferred to PACKAGE-UPDATES Phase 2a)
**Pinned apiVersion:** `2026-02-25.clover` (bumped from `2025-12-15.clover` in Conv 100 / PACKAGE-UPDATES Phase 1)

**Directive (Conv 100):** Application code must NOT instantiate `new Stripe()` directly. Use the centralized helper in `src/lib/stripe.ts`:

```typescript
import { getStripe, getStripeFromLocals } from '@lib/stripe';

// In API routes with access to locals:
const stripe = getStripeFromLocals(locals);

// Elsewhere:
const stripe = getStripe();
```

The helper delegates to `requireEnv(locals, 'STRIPE_SECRET_KEY')` and centralizes the `apiVersion` pin — a single choke-point for future upgrades. Note: admin payout endpoints (`/api/admin/payouts/[id]/process.ts`, `/api/admin/payouts/batch.ts`) were consolidated onto `getStripe()` in Conv 100 and no longer import `Stripe` directly.

### Account Types

| Type | Onboarding | Dashboard | Best For |
|------|------------|-----------|----------|
| **Express** ✅ | Stripe-hosted | Limited (Stripe-managed) | PeerLoop - simple, compliant |
| Standard | Stripe-hosted | Full Stripe dashboard | Not needed |
| Custom | Platform-built | Platform-built | Complex needs |

### Create Connected Account (Express)

```typescript
// Create Express account for Creator or Teacher
const account = await stripe.accounts.create({
  type: 'express',
  country: 'US',
  email: user.email,
  capabilities: {
    card_payments: { requested: true },
    transfers: { requested: true },
  },
  business_type: 'individual',
  metadata: {
    peerloop_user_id: user.id,
    role: 'creator' // or 'teacher'
  }
});

// Store account.id in our database
await db.users.update({
  where: { id: user.id },
  data: { stripeAccountId: account.id }
});
```

### Generate Onboarding Link

```typescript
const accountLink = await stripe.accountLinks.create({
  account: stripeAccountId,
  refresh_url: `${baseUrl}/settings/payments?refresh=true`,
  return_url: `${baseUrl}/settings/payments?success=true`,
  type: 'account_onboarding',
});

// Redirect user to accountLink.url
```

### Create Checkout Session

```typescript
const session = await stripe.checkout.sessions.create({
  mode: 'payment',
  line_items: [{
    price_data: {
      currency: 'usd',
      product_data: {
        name: course.title,
        description: `Course enrollment with ${instructor.name}`,
      },
      unit_amount: course.priceCents, // 45000 for $450
    },
    quantity: 1,
  }],
  payment_intent_data: {
    transfer_group: `enrollment_${enrollmentId}`, // Links charge to transfers
  },
  metadata: {
    enrollment_id: enrollmentId,
    course_id: courseId,
    student_id: studentId,
    instructor_type: 'teacher', // or 'creator'
    creator_id: creatorId,
    assigned_teacher_id: teacherId, // null if creator teaches
  },
  success_url: `${baseUrl}/courses/${courseId}/success?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${baseUrl}/courses/${courseId}`,
});
```

### Create Transfers (After Payment)

```typescript
// Called after checkout.session.completed webhook

async function createPaymentSplits(enrollment: Enrollment, charge: Stripe.Charge) {
  const amountCents = charge.amount; // 45000
  const transferGroup = `enrollment_${enrollment.id}`;

  // Calculate splits
  const platformCents = Math.round(amountCents * 0.15); // $67.50

  if (enrollment.instructorType === 'creator') {
    // Creator teaches: 85% to Creator
    const creatorCents = amountCents - platformCents; // $382.50

    await stripe.transfers.create({
      amount: creatorCents,
      currency: 'usd',
      destination: enrollment.creator.stripeAccountId,
      transfer_group: transferGroup,
      source_transaction: charge.id, // Wait for funds to settle
      metadata: {
        enrollment_id: enrollment.id,
        recipient_type: 'creator_as_instructor',
        recipient_id: enrollment.creatorId,
      }
    });
  } else {
    // Teacher teaches: 15% Creator, 70% Teacher
    const creatorCents = Math.round(amountCents * 0.15); // $67.50
    const teacherCents = amountCents - platformCents - creatorCents; // $315.00

    // Transfer to Creator
    await stripe.transfers.create({
      amount: creatorCents,
      currency: 'usd',
      destination: enrollment.creator.stripeAccountId,
      transfer_group: transferGroup,
      source_transaction: charge.id,
      metadata: {
        enrollment_id: enrollment.id,
        recipient_type: 'creator_as_author',
        recipient_id: enrollment.creatorId,
      }
    });

    // Transfer to Teacher
    await stripe.transfers.create({
      amount: teacherCents,
      currency: 'usd',
      destination: enrollment.teacher.stripeAccountId,
      transfer_group: transferGroup,
      source_transaction: charge.id,
      metadata: {
        enrollment_id: enrollment.id,
        recipient_type: 'teacher',
        recipient_id: enrollment.teacherId,
      }
    });
  }

  // Platform keeps the remainder (15%) automatically
}
```

### Handle Refunds

```typescript
async function processRefund(enrollment: Enrollment, chargeId: string) {
  // 1. Create refund (debits platform balance)
  const refund = await stripe.refunds.create({
    charge: chargeId,
  });

  // 2. Reverse transfers to recover funds from recipients
  const transfers = await stripe.transfers.list({
    transfer_group: `enrollment_${enrollment.id}`,
  });

  for (const transfer of transfers.data) {
    await stripe.transfers.createReversal(transfer.id, {
      // Full reversal - or specify amount for partial
    });
  }

  // 3. Update enrollment status
  await db.enrollments.update({
    where: { id: enrollment.id },
    data: { status: 'refunded' }
  });
}
```

---

## Webhooks

### Architecture: One Endpoint, All Events

PeerLoop uses a **single webhook endpoint** at `POST /api/webhooks/stripe` that receives ALL Stripe events. The endpoint routes internally based on event type:

```
                    Stripe Cloud
                        │
          ┌─────────────┼──────────────────┐
          │             │             │     │
    Payment succeeds  Refund      Account  Transfer/Payout
          │           issued      changes   status
          │             │             │     │
          ▼             ▼             ▼     ▼
    checkout.session  charge.     account. transfer.created
    .completed        refunded    updated  payout.failed
          │             │             │     │
          └─────────────┼──────────────────┘
                        │
              Single HTTPS POST to:
         /api/webhooks/stripe
                        │
                        ▼
              ┌─────────────────┐
              │  switch(event.  │
              │    type) {...}  │
              └─────────────────┘
              Routes internally
              to handler functions
```

**Why one endpoint?** Stripe allows multiple endpoints, but a single endpoint is simpler to manage — one URL to register, one secret to configure, one handler to test. The `switch` statement dispatches to focused handler functions, each responsible for one event type. Unhandled events are logged and acknowledged with 200 (Stripe expects a 2xx response even for events you don't process).

**How Stripe delivers events:**
- Stripe maintains a queue of events per registered webhook endpoint
- When an event occurs (payment, refund, etc.), Stripe POSTs a signed JSON payload to your URL
- The payload is signed with your endpoint's `whsec_` secret — your handler verifies this via `stripe.webhooks.constructEvent()` to prevent spoofing
- If your endpoint returns non-2xx, Stripe retries with exponential backoff for up to **72 hours**
- Events may arrive **out of order** — handlers must be idempotent

### Events Handled

| Event | Handler | Purpose | Added |
|-------|---------|---------|-------|
| `checkout.session.completed` | `handleCheckoutCompleted` | Create enrollment, transaction, payment_splits, initiate transfers, Stream follow | Session 93 (Jan 5) |
| `charge.refunded` | `handleChargeRefunded` | Cancel enrollment (full) or note partial refund, reverse transfers, Stream unfollow | Session 93 (Jan 5) |
| `account.updated` | `handleAccountUpdated` | Sync connected account status (`pending`/`active`/`restricted`) to users table | Session 93 (Jan 5) |
| `transfer.created` | `handleTransferCreated` | Mark `payment_splits` row as `paid` with timestamp (safety net — checkout handler already marks as paid) | Session 223→224 |
| `charge.dispute.created` | `handleDisputeCreated` | Freeze enrollment (status → 'disputed'), mark transaction as disputed, notify admin | Session 224 (Feb 18) |
| `charge.dispute.closed` | `handleDisputeClosed` | If won: restore enrollment. If lost: cancel enrollment, mark transaction as 'dispute_lost'. Notify admin. | Session 224 (Feb 18) |
| `payout.failed` | `handlePayoutFailed` | Update payout status, create notification for affected creator/Teacher | Session 223 (Feb 18) |

### Webhook Event Contexts: Platform vs Connected Accounts

Stripe Connect splits webhook events into two delivery contexts. This determines which checkbox to select when creating a webhook endpoint in the Stripe Dashboard:

- **"Your account"** — Events about resources owned by the Peerloop platform account (checkouts, transfers, refunds)
- **"Connected and v2 accounts"** — Events about resources inside creators' connected accounts (their bank payouts)

#### PeerLoop Scenarios and Which Context They Fire In

| Scenario | What Happens in Stripe | Who Owns It | Event | Context |
|----------|----------------------|-------------|-------|---------|
| Student buys Guy's course ($249) | Peerloop creates a Checkout Session using platform API keys. Student pays. | Peerloop — it created the session | `checkout.session.completed` | **Your account** |
| Peerloop splits payment to Guy | Peerloop calls `stripe.transfers.create()` to send Guy his 85% from the platform balance | Peerloop — it's moving money from its own balance | `transfer.created` | **Your account** |
| Admin refunds a student | Peerloop calls `stripe.refunds.create()` on the original charge | Peerloop — it processed the original payment | `charge.refunded` | **Your account** |
| Guy completes Stripe onboarding | Guy submits identity verification. Stripe verifies and updates his account status. | Stripe notifies Peerloop about its connected account | `account.updated` | **Your account** |
| Guy's bank rejects his payout | Guy's connected account has a $211.65 balance. Stripe automatically pays it to Guy's bank. Bank says "account closed". | Guy's connected account — the money moves from *his* Stripe balance to *his* bank. Peerloop never touches this. | `payout.failed` | **Connected accounts** |

**The pattern:** If Peerloop initiates or owns the resource (checkout, transfer, refund), the event fires on "Your account." If the action happens entirely within a creator's connected account (like their automatic bank payout), it fires on "Connected accounts."

#### Implications for Webhook Registration

- **4 of 5 events** fire under "Your account" — these are registered as a single webhook endpoint
- **`payout.failed`** fires under "Connected accounts" — would require a separate webhook endpoint
- **Decision (Session 224):** Register only "Your account" events for now. The `payout.failed` handler is a courtesy in-app notification; Stripe already emails creators directly about failed payouts and holds their funds safely. A "Connected accounts" endpoint can be added later if in-app notifications are needed.

**Why `stripe listen` masks this distinction:** The Stripe CLI forwards ALL events regardless of context. Locally, `payout.failed` arrives just like any other event. This discrepancy only surfaces when registering dashboard webhook endpoints.

### Self-Healing Status Sync (Session 223 Decision)

The `GET /api/stripe/connect-status` endpoint supplements the `account.updated` webhook. Each time the Payment Settings page loads, it:

1. Fetches live status from Stripe's API (`charges_enabled`, `payouts_enabled`, `details_submitted`)
2. Derives the correct status (`active` if all three flags are true)
3. Compares with the database — if they differ, updates the DB automatically

This means the system works **with or without webhooks running**. Webhooks provide real-time updates, but if they're missed (e.g., `stripe listen` not running locally), the next page load self-corrects the status.

**Decision rationale:** Discovered during manual testing (Session 223) that after completing Stripe Express onboarding, the status showed "pending" because `stripe listen` wasn't running and the `account.updated` webhook never arrived. Rather than making webhooks a hard dependency, we made the status endpoint self-healing.

### Self-Healing Enrollment Creation (Session 324)

Extends the self-healing pattern to enrollment creation. When the webhook is missed, enrollment is created on-demand via two surfaces:

1. **Success page SSR** (`/course/[slug]/success.astro`): If enrollment not found but `session_id` exists in the URL, retrieves the Stripe checkout session and calls `createEnrollmentFromCheckout()` directly.
2. **`/courses` dashboard** (`MyCourses.tsx`): Checks localStorage for pending Stripe session IDs (stored by `EnrollButton.tsx` before Stripe redirect) and calls `POST /api/stripe/verify-checkout` on mount.

The enrollment creation logic was extracted from the webhook handler into a shared module (`src/lib/enrollment.ts`) so both the webhook and self-healing paths use identical, idempotent logic.

**Also fixed:** Stripe metadata now carries both `teacher_certification_id` (st-xxx, for webhook JOINs) and `assigned_teacher_id` (usr-xxx, for enrollment FK). The previous code inserted `teacher_certifications.id` into a column with `REFERENCES users(id)`, causing FK violations when a Teacher was selected.

### Idempotency (Session 223 Decision)

**Enrollment creation:** The `checkout.session.completed` handler checks for an existing enrollment before creating one. If the webhook is retried, the duplicate is skipped.

**Transfer creation:** `stripe.transfers.create()` calls include an `idempotencyKey` to prevent duplicate transfers on webhook retry:
```typescript
stripe.transfers.create({ ... }, {
  idempotencyKey: `transfer_${transferGroup}_${recipientType}_${recipientId}`,
});
```

**Decision rationale:** Without idempotency keys on transfers, a Stripe webhook retry could create duplicate payouts to creators/Teachers. This was identified as a medium-severity risk and fixed in Session 223.

### Per-Environment Webhook Configuration

| Environment | Delivery Method | Webhook URL | Secret Source | Events Context | Status |
|-------------|----------------|-------------|---------------|---------------|--------|
| **Local dev** | Stripe CLI (`stripe listen`) | `localhost:4321/api/webhooks/stripe` | Stripe CLI outputs `whsec_...` → stored in `.dev.vars` | All (CLI forwards everything) | Working |
| **Preview/staging** | Direct from Stripe Cloud | `staging.peerloop.pages.dev/api/webhooks/stripe` | Own `whsec_...` in CF Dashboard Preview secrets | "Your account" (6 events) | Active (Session 224) |
| **Production** | Direct from Stripe Cloud | Not registered | Deferred until go-live (env-vars-secrets) | TBD | Not active |

#### Local Development

The Stripe CLI acts as a bridge between Stripe's event queue and your localhost:

```
Stripe Cloud  →  WebSocket  →  Stripe CLI  →  HTTP POST  →  localhost:4321
                               (your machine)
```

**Setup:**
```bash
# Terminal 1: Start dev server
npm run dev

# Terminal 2: Start webhook forwarding
npm run stripe:listen
# (alias for: stripe listen --forward-to localhost:4321/api/webhooks/stripe)
```

The CLI outputs a webhook signing secret (`whsec_...`). This must match the `STRIPE_WEBHOOK_SECRET` in `.dev.vars`. The secret is stable across sessions on the same machine — it only changes if you re-authenticate (`stripe login`).

**Prerequisites:** Stripe CLI installed and authenticated (`stripe login`). Verified by `scripts/check-env.sh` at session startup.

#### Preview/Staging (Active — Session 224)

While per-commit deployments get dynamic URLs (`https://<hash>.peerloop.pages.dev`), the `staging` branch has a **stable** URL at `https://staging.peerloop.pages.dev`. This is fixed enough for Stripe webhooks.

**Configuration:**
1. **Stripe Dashboard** (test mode) → Webhooks → endpoint for `staging.peerloop.pages.dev/api/webhooks/stripe`
   - Events (6): `checkout.session.completed`, `charge.refunded`, `account.updated`, `transfer.created`, `charge.dispute.created`, `charge.dispute.closed` ("Your account" context)
   - `payout.failed` excluded — requires separate "Connected accounts" endpoint (deferred, see Webhook Event Contexts above)
2. **Cloudflare Dashboard** → Pages → peerloop → Settings → Environment Variables → Preview
   - `STRIPE_WEBHOOK_SECRET` = the `whsec_...` signing secret from the Stripe endpoint above

**What works:** Checkout → enrollment creation, refunds, account status sync, transfer tracking.

**What doesn't:** `payout.failed` notifications (Stripe emails creators directly as fallback).

**Important:** The Preview `STRIPE_WEBHOOK_SECRET` is different from the local dev secret in `.dev.vars`. Each Stripe webhook endpoint has its own signing secret. The two environments are completely independent.

#### Production (Decision: Defer Until Go-Live)

Per env-vars-secrets.md, production Stripe secrets are intentionally withheld from Cloudflare until go-live to prevent accidental real charges.

**Go-live checklist:**
1. Add `STRIPE_SECRET_KEY` (live mode `sk_live_...`) to CF Dashboard Production secrets
2. Register webhook endpoint in Stripe Dashboard (live mode):
   - URL: `https://peerloop.com/api/webhooks/stripe` (exact domain TBD)
   - Events: `checkout.session.completed`, `charge.refunded`, `account.updated`, `transfer.created`, `charge.dispute.created`, `charge.dispute.closed`, `payout.failed`
3. Copy the generated `whsec_...` secret to CF Dashboard Production secrets as `STRIPE_WEBHOOK_SECRET`
4. Test with a real $1 charge, verify webhook arrives, refund immediately
5. Add `STRIPE_PUBLISHABLE_KEY` (live mode `pk_live_...`) to CF Dashboard or `wrangler.toml`

### Webhook Handler Code

**File:** `src/pages/api/webhooks/stripe.ts`

```typescript
// POST /api/webhooks/stripe
export const POST: APIRoute = async ({ request, locals }) => {
  const payload = await request.text();
  const signature = request.headers.get('stripe-signature');

  // Verify signature (prevents spoofing)
  const event = constructWebhookEvent(stripe, payload, signature, webhookSecret);

  switch (event.type) {
    case 'checkout.session.completed':
      await handleCheckoutCompleted(db, stripe, session, locals);
      break;
    case 'charge.refunded':
      await handleChargeRefunded(db, stripe, charge, locals);
      break;
    case 'account.updated':
      await handleAccountUpdated(db, account);
      break;
    default:
      // transfer.created, payout.failed handled here
      // (not in Stripe SDK's TypeScript union type)
  }

  return Response.json({ received: true });
};
```

### Testing

**Unit tests:** `tests/api/webhooks/stripe.test.ts` (11 tests)
- Signature verification (missing header, invalid signature)
- `checkout.session.completed` (enrollment creation, idempotency)
- `charge.refunded` (full refund cancels enrollment, partial keeps active)
- `account.updated` (status sync to DB)
- `transfer.created` (payment_split marked as paid)
- `payout.failed` (notification created for affected user)
- Error handling (DB unavailable, missing secret)

**E2E testing:** Run locally with `stripe listen` + dev server. Verified in Sessions 94 and 223.

---

## Database Schema Additions

```sql
-- Track Stripe accounts for payouts
ALTER TABLE users ADD COLUMN stripe_account_id TEXT;
ALTER TABLE users ADD COLUMN stripe_account_status TEXT; -- 'pending', 'active', 'restricted'
ALTER TABLE users ADD COLUMN stripe_payouts_enabled BOOLEAN DEFAULT FALSE;

-- Track payment splits
CREATE TABLE payment_splits (
  id TEXT PRIMARY KEY,
  enrollment_id TEXT REFERENCES enrollments(id),
  transaction_id TEXT REFERENCES transactions(id),
  recipient_id TEXT REFERENCES users(id),
  recipient_type TEXT, -- 'platform', 'creator_as_instructor', 'creator_as_author', 'teacher'
  amount_cents INTEGER,
  stripe_transfer_id TEXT,
  status TEXT, -- 'pending', 'paid', 'reversed'
  created_at TIMESTAMP,
  paid_at TIMESTAMP
);
```

---

## Pricing & Fees

| Fee Type | Amount | Who Pays |
|----------|--------|----------|
| Card processing | 2.9% + $0.30 | Platform (deducted from charge) |
| Connect payout | 0.25% (max $25) | Per transfer to connected account |
| Instant payout | 1% | Connected account (optional) |

**Example $450 course:**
- Stripe fee: ~$13.35 (2.9% + $0.30)
- Net received: $436.65
- Platform 15%: $65.50
- Available for splits: $371.15

**Note:** Platform should calculate splits from gross amount, Stripe fees come out of platform's 15%.

---

## Payout Timing

| Schedule | Description |
|----------|-------------|
| Default | Daily rolling (2 business days) |
| Manual | Platform triggers via API |
| Delayed | Configure hold period (recommended for new accounts) |

**Recommendation:** Use 7-day delay for new Creators/Teachers to allow refund window.

---

## Security Considerations

1. **Webhook signature verification** - Always verify `stripe-signature` via `constructWebhookEvent()`. Returns 400 on missing or invalid signatures. ✅ Implemented
2. **Idempotency** - Enrollment creation checks for existing record before INSERT. Transfer creation uses `idempotencyKey` parameter. ✅ Implemented (Session 223)
3. **Self-healing status** - `connect-status` endpoint syncs DB from Stripe's live API, so missed webhooks don't leave stale state. ✅ Implemented (Session 223)
4. **Balance checks** - Verify connected account balance before reversals
5. **Fraud monitoring** - Platform responsible for Express account fraud

---

## Environment Variables

See [env-vars-secrets.md](../architecture/env-vars-secrets.md) for the full environment variable reference and deployment workflow.

| Variable | Secret? | Where it lives | Purpose |
|----------|:-------:|----------------|---------|
| `STRIPE_PUBLISHABLE_KEY` | No | `.dev.vars` + `wrangler.toml [vars]` | Client-side Checkout initialization (`pk_test_` / `pk_live_`) |
| `STRIPE_SECRET_KEY` | **Yes** | `.dev.vars` / `.secrets.cloudflare.*` | Server-side SDK initialization (`sk_test_` / `sk_live_`) |
| `STRIPE_WEBHOOK_SECRET` | **Yes** | `.dev.vars` / `.secrets.cloudflare.*` | Webhook signature verification (`whsec_`) |

**Dev vs Production:** Stripe uses entirely separate key sets per mode. Test-mode keys (`pk_test_`, `sk_test_`) cannot affect real payments. Production keys (`pk_live_`, `sk_live_`) are obtained from the [Stripe Dashboard](https://dashboard.stripe.com/apikeys) after activating your account.

**Webhook secrets** are per-endpoint. Each environment has its own independent `whsec_` secret:
- **Local dev:** Generated by `stripe listen` CLI, stored in `.dev.vars`
- **Preview/staging:** Generated when creating the Stripe Dashboard webhook endpoint for `staging.peerloop.pages.dev`, stored in CF Dashboard Preview secrets
- **Production:** Will be generated at go-live, stored in CF Dashboard Production secrets

### Connected Accounts Are Per-Environment (Database, Not Stripe)

All environments (local, staging, production) share the same Stripe test mode (or live mode) — connected accounts created via `stripe.accounts.create()` exist in Stripe's cloud and are accessible with the same API keys from any environment.

**However, the database link is per-environment.** Each D1 database stores its own `stripe_account_id` on the user record. A connected account created during local dev testing is stored in the local DB only — the staging DB has the same user but with `stripe_account_id = NULL`.

| Concept | Shared Across Environments? | Notes |
|---------|:---------------------------:|-------|
| Stripe API keys (test mode) | Yes | Same `sk_test_`/`pk_test_` keys everywhere |
| Connected accounts in Stripe | Yes | Created once in Stripe's cloud, accessible by ID from anywhere |
| User's `stripe_account_id` in DB | **No** | Each D1 database is independent; onboarding must happen per environment |

**Practical implication:** To test the full payment flow on staging, each creator must go through Stripe Connect onboarding again on that environment. This creates a **new** connected account (new `acct_...` ID) — Stripe doesn't deduplicate by email or name. The local dev account continues to work independently.

**Test mode accounts are free and disposable.** There's no limit on how many you create. Clean up old test accounts from the Stripe Dashboard if they accumulate.

**Shortcut for dev/staging:** `migrations-dev/0002_seed_stripe.sql` contains UPDATE statements that set real Stripe sandbox `acct_` IDs on Guy Rymberg, Sarah Miller, and Marcus Thompson. Run `npm run db:seed:stripe:local` (or `db:seed:stripe:staging`) after the main dev seed to skip manual onboarding. See `migrations-dev/README.md` for setup.

---

## References

### Official Documentation
- [Stripe Connect Overview](https://docs.stripe.com/connect)
- [Stripe Connect Features](https://stripe.com/connect/features)
- [Stripe for Marketplaces](https://stripe.com/use-cases/marketplaces)

### Charge Types
- [Understanding Connect Charges](https://docs.stripe.com/connect/charges)
- [Separate Charges and Transfers](https://docs.stripe.com/connect/separate-charges-and-transfers)
- [Destination Charges](https://docs.stripe.com/connect/destination-charges)

### Account Management
- [Express Accounts](https://docs.stripe.com/connect/express-accounts)
- [Payouts to Connected Accounts](https://docs.stripe.com/connect/payouts-connected-accounts)

### Webhooks & Events
- [Connect Webhooks](https://docs.stripe.com/connect/webhooks)
- [Webhook Event Types](https://docs.stripe.com/api/events/types)
- [Handling Payment Events](https://docs.stripe.com/webhooks/handling-payment-events)

### Refunds & Disputes
- [Refunds and Disputes](https://docs.stripe.com/connect/marketplace/tasks/refunds-disputes)
- [Transfer Reversals API](https://docs.stripe.com/api/transfer_reversals)
- [Payout Reversals](https://docs.stripe.com/connect/payout-reversals)
- [Disputes on Connect Platforms](https://stripe.com/docs/disputes/connect)

### Other Resources
- [Stripe Connect Product Page](https://stripe.com/connect)
- [Split Payments Guide](https://stripe.com/resources/more/how-to-implement-split-payment-systems-what-businesses-need-to-do-to-make-it-work)

---

## PeerLoop Integration

*Migrated from `research/run-001/assets/payment-decisions.md` (2026-01-19)*

### Business Rules

#### Unified Pricing Model (CD-033)

- **Course price = Teacher price** (no separate Teacher premium)
- Creator prices course as if they're NOT the primary teacher
- Rationale: "Too complicated for the creator to charge premium. Too confusing." - Brian

#### Any-Time Refunds

- Students can request refund at any time
- "The pressure is on the student teacher to earn his pay" - Brian
- Platform processes refunds, reverses transfers, claws back from future earnings if needed

### Escrow/Hold Period

| Approach | Pros | Cons |
|----------|------|------|
| **No hold** | Simple, fast payouts | Risk if student refunds after payout |
| **Session hold** | Pay after session completes | Teacher waits for payment |
| **7-day hold** | Refund window | Delays earnings |

**Decision:** Pay after session completes (no additional hold). Refunds clawback from future earnings if needed.

**Recommendation:** Consider 7-day delay for new Creators/Teachers to allow refund window.

### Payment Flow Diagrams

**Enrollment Flow:**
```
Student clicks "Enroll"
  → Redirect to Stripe Checkout
    → Payment success
      → Webhook to our backend
        → Create enrollment record
          → Grant course access
```

**Payout Flow:**
```
Session completes
  → Teacher recommends completion (or session recorded)
    → Calculate split (15% platform, 85% recipient)
      → Hold in Stripe (escrow period if any)
        → Admin approves OR auto-release
          → Transfer to Connect account
            → Webhook confirms payout
```

### Questions Resolved

| Question | Resolution |
|----------|------------|
| Exact Creator/Teacher split when Teacher teaches? | 15% platform, 15% Creator, 70% Teacher |
| Escrow/hold period? | Pay after session, clawback if refund |
| PayPal support? | Post-MVP (CD-032 mentions "eventually") |
| International payments? | Post-MVP (Brian wants global, defer for now) |

### Source Documents

- CD-020 - Payment & Escrow MVP Decision
- CD-033 - Teacher Pricing Clarification (85/15 split)
