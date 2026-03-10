# Payment & Revenue Decisions - RUN-001

> **⚠️ MIGRATED:** This content has been integrated into `docs/vendors/stripe.md` (2026-01-19).
> This file is kept for historical reference. For current information, see the tech doc.

**Created:** 2025-12-24
**Updated:** 2025-12-26
**Migrated:** 2026-01-19 → `docs/vendors/stripe.md`
**Related Sources:** CD-020 (Payment & Escrow), CD-033 (Teacher Pricing Clarification)

---

## Decision: Stripe Connect

RUN-001 uses **Stripe** for all payment processing with **Connect Express** for payouts.

---

## Pricing Model (from CD-033)

### Unified Pricing
- **Course price = Teacher price** (no separate Teacher premium)
- Creator prices course as if they're NOT the primary teacher
- "Too complicated for the creator to charge premium. Too confusing." - Brian

### Revenue Split ✅ RESOLVED (2025-12-26)

**When Creator teaches:**
| Recipient | Share | Example ($450 course) |
|-----------|-------|----------------------|
| Platform (PeerLoop) | 15% | $67.50 |
| Creator | 85% | $382.50 |

**When Teacher teaches:**
| Recipient | Share | Example ($450 course) |
|-----------|-------|----------------------|
| Platform (PeerLoop) | 15% | $67.50 |
| Creator (royalty) | 15% | $67.50 |
| Teacher | 70% | $315.00 |

**Rationale:** Teacher does the teaching work, deserves majority. Creator still earns royalty for course content.

### Any-Time Refunds
- Students can request refund at any time
- "The pressure is on the student teacher to earn his pay" - Brian
- Implications for escrow/hold period

---

## Stripe Products Used

### Stripe Checkout
- **Purpose:** Course enrollment payments
- **Flow:** Redirect to Stripe-hosted checkout page
- **Benefits:** PCI compliance handled, no card data on our servers

```
Student clicks "Enroll"
  → Redirect to Stripe Checkout
    → Payment success
      → Webhook to our backend
        → Create enrollment record
          → Grant course access
```

### Stripe Connect (Express)
- **Purpose:** Pay out creators and Teachers
- **Account Type:** Express (Stripe-hosted onboarding)
- **Flow:**
  1. Creator/Teacher signs up → Create Connect account
  2. Session completes → Calculate split
  3. Admin triggers payout → Transfer to Connect account

### Stripe Webhooks
| Event | Action |
|-------|--------|
| `checkout.session.completed` | Create enrollment, grant access |
| `payment_intent.succeeded` | Confirm payment recorded |
| `payout.paid` | Update payout status |
| `account.updated` | Update Connect account status |
| `charge.refunded` | Process refund, revoke access |

---

## Payment Flow

### Enrollment Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Student   │────▶│   Stripe    │────▶│   PeerLoop  │
│   Browser   │     │  Checkout   │     │   Backend   │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                    │
      │  1. Click Enroll  │                    │
      │──────────────────▶│                    │
      │                   │                    │
      │  2. Redirect      │                    │
      │◀──────────────────│                    │
      │                   │                    │
      │  3. Pay           │                    │
      │──────────────────▶│                    │
      │                   │  4. Webhook        │
      │                   │───────────────────▶│
      │                   │                    │
      │  5. Success URL   │  6. Create enroll  │
      │◀──────────────────│                    │
```

### Payout Flow

```
Session completes
  → Teacher recommends completion (or session recorded)
    → Calculate split (15% platform, 85% recipient)
      → Hold in Stripe (escrow period if any)
        → Admin approves OR auto-release
          → Transfer to Connect account
            → Webhook confirms payout
```

---

## Database Entities

### transactions
| Field | Type | Purpose |
|-------|------|---------|
| id | uuid | Primary key |
| enrollment_id | uuid | FK to enrollments |
| amount_cents | int | Total payment |
| stripe_payment_intent_id | string | Stripe reference |
| status | enum | pending, completed, refunded |
| created_at | timestamp | Payment time |

### payment_splits
| Field | Type | Purpose |
|-------|------|---------|
| id | uuid | Primary key |
| transaction_id | uuid | FK to transactions |
| recipient_id | uuid | FK to users |
| recipient_type | enum | platform, creator_as_author, teacher |
| amount_cents | int | Split amount |
| status | enum | pending, paid, held |

### payouts
| Field | Type | Purpose |
|-------|------|---------|
| id | uuid | Primary key |
| user_id | uuid | Recipient |
| amount_cents | int | Payout amount |
| stripe_transfer_id | string | Stripe reference |
| status | enum | pending, processing, paid, failed |

### refunds
| Field | Type | Purpose |
|-------|------|---------|
| id | uuid | Primary key |
| transaction_id | uuid | Original transaction |
| amount_cents | int | Refund amount |
| reason | text | Refund reason |
| stripe_refund_id | string | Stripe reference |
| processed_at | timestamp | When processed |

---

## Escrow/Hold Period

### Open Question
CD-020 mentions escrow, but CD-033 says "any-time refunds." Need to reconcile:

| Approach | Pros | Cons |
|----------|------|------|
| **No hold** | Simple, fast payouts | Risk if student refunds after payout |
| **Session hold** | Pay after session completes | Teacher waits for payment |
| **7-day hold** | Refund window | Delays earnings |

**RUN-001 Assumption:** Pay after session completes (no additional hold). Refunds clawback from future earnings if needed.

---

## Connect Onboarding

### Creator/Teacher Signup Flow
1. User registers on PeerLoop
2. When ready to earn, clicks "Set up payments"
3. Redirected to Stripe Connect Express onboarding
4. Stripe collects identity, bank info
5. Webhook confirms account ready
6. User can now receive payouts

### Connect Account Types
| Type | Onboarding | Control | Best For |
|------|------------|---------|----------|
| **Express** | Stripe-hosted | Limited | PeerLoop (recommended) |
| Standard | User's Stripe | Full | Not applicable |
| Custom | We build it | Full | Complex needs |

**RUN-001 Decision:** Express accounts - Stripe handles KYC, tax forms, etc.

---

## Stripe Fees

| Transaction | Fee |
|-------------|-----|
| Card payment | 2.9% + $0.30 |
| Connect transfer | Free (within platform) |
| Payout to bank | Free (standard) |
| Refund | Original fee lost |

**Example $450 course:**
- Stripe fee: ~$13.35 (2.9% + $0.30)
- Net to platform: $436.65
- Platform share (15%): $65.50
- Creator/Teacher share (85%): $371.15

---

## Admin Features

### Payout Management (US-A006, US-A007)
- View pending payouts
- Process individual or batch payouts
- View payout history
- Handle failed payouts

### Refund Processing (US-A006)
- View refund requests
- Process refunds
- Track refund impact on splits

---

## Implementation Notes

### Stripe SDK
```javascript
// Server-side (Workers)
import Stripe from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

// Create checkout session
const session = await stripe.checkout.sessions.create({
  mode: 'payment',
  line_items: [{
    price_data: {
      currency: 'usd',
      product_data: { name: course.title },
      unit_amount: course.price_cents,
    },
    quantity: 1,
  }],
  success_url: `${baseUrl}/courses/${courseId}/success`,
  cancel_url: `${baseUrl}/courses/${courseId}`,
  metadata: {
    course_id: courseId,
    user_id: userId,
  },
});
```

### Webhook Handler
```javascript
// Verify webhook signature
const event = stripe.webhooks.constructEvent(
  body,
  signature,
  process.env.STRIPE_WEBHOOK_SECRET
);

switch (event.type) {
  case 'checkout.session.completed':
    await handleEnrollment(event.data.object);
    break;
  case 'charge.refunded':
    await handleRefund(event.data.object);
    break;
}
```

---

## Questions Status

| Question | Status | Resolution |
|----------|--------|------------|
| Exact Creator/Teacher split when Teacher teaches? | ✅ Resolved | 15% platform, 15% Creator, 70% Teacher |
| Escrow/hold period? | Assumed none | Pay after session, clawback if refund |
| PayPal support? | Post-MVP | CD-032 mentions "eventually" |
| International payments? | Post-MVP | Brian wants global, defer for now |

---

## References

- CD-020 - Payment & Escrow MVP Decision
- CD-033 - Teacher Pricing Clarification (85/15 split)
- [Stripe Checkout Docs](https://stripe.com/docs/checkout)
- [Stripe Connect Docs](https://stripe.com/docs/connect)
- [Stripe Webhooks](https://stripe.com/docs/webhooks)
