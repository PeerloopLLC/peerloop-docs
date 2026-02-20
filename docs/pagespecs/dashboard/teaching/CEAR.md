# Page: Earnings Detail (Creator)

**Code:** CEAR
**URL:** `/studio/earnings`
**Access:** Authenticated (Creator role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Provide Creators with detailed view of their earnings, revenue breakdown by course, payout history, and pending balances.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CDSH | "View Earnings" link | From earnings summary |
| CANA | "View Earnings" link | From analytics |
| Nav | "Earnings" link | Creator navigation |
| STUD | "Earnings" tab | From Creator Studio |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CDET | Course name click | View course |
| SETT | "Payment Settings" | Update payout method |
| CDSH | Back/breadcrumb | Return to dashboard |
| (Stripe) | "View in Stripe" | External link |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| payment_splits | amount_cents, status, released_at (where recipient = creator) | Revenue records |
| transactions | enrollment_id, amount_cents, paid_at | Transaction source |
| payouts | amount_cents, status, paid_at, approved_at | Payout records |
| courses | id, title | Course breakdown |
| enrollments | course_id | Link transactions to courses |

---

## Sections

### Header
- Page title: "Earnings"
- Period selector: This month / Last month / This year / All time

### Earnings Summary Cards
- **Available Balance** - Ready for payout
- **Pending** - In escrow, not yet released
- **This Period** - Earned in selected period
- **Lifetime Earnings** - Total ever earned
- "Request Payout" button (if balance > threshold)

### Revenue Chart
- Bar/line chart: Revenue over time
- Monthly or weekly granularity
- Stacked by course (optional)

### Revenue by Course

| Column | Content |
|--------|---------|
| Course | Title |
| Enrollments | Count in period |
| Gross Revenue | Total course revenue |
| Your Royalty (15%) | Creator's share |
| Status | Released / Pending |

### Transaction History

| Column | Content |
|--------|---------|
| Date | Transaction date |
| Student | Student name |
| Course | Course title |
| Amount | Gross amount |
| Your Share | 15% royalty |
| Status | Pending / Released / Paid |

- Expandable for full transaction details
- Filter by course, status, date range
- Pagination or infinite scroll

### Payout History

| Column | Content |
|--------|---------|
| Date | Payout date |
| Amount | Payout amount |
| Status | Processing / Completed / Failed |
| Reference | Stripe transfer ID |

### Pending Releases
- List of transactions still in escrow
- Expected release dates
- Conditions for release (student completion, time-based)

### Payment Settings Summary
- Connected Stripe account status
- Payout threshold
- "Update Settings" → SETT

---

## User Stories Fulfilled

- US-C035: View detailed earnings
- US-C050: Track revenue by course
- US-C051: View payout history
- US-C052: Request payouts

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Current month earnings |
| Filtered | By date range or course |
| Has Balance | Payout button enabled |
| No Balance | Payout button disabled |
| Stripe Not Connected | Prompt to connect Stripe |
| Empty | No earnings yet |

---

## Mobile Considerations

- Summary cards scroll horizontally
- Transaction list is primary view
- Charts simplified
- Payout action prominent

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load earnings. [Retry]" |
| Payout request fails | "Unable to process. Try again." |
| Stripe disconnected | "Reconnect your Stripe account" |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | balance, period |
| `payout_requested` | Request clicked | amount |
| `period_changed` | Date range changed | new_period |
| `transaction_viewed` | Row expanded | transaction_id |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/creators/me/earnings` | Page load | Aggregated earnings data |
| `GET /api/creators/me/transactions` | Transaction tab | Transaction history |
| `GET /api/creators/me/payouts` | Payout history | Past payouts |
| `POST /api/payouts/request` | "Request Payout" | Initiate payout |
| `GET /api/payments/connect/status` | Page load | Stripe Connect status |

### Earnings Data Aggregation

```typescript
// GET /api/creators/me/earnings?period=this_month
{
  summary: {
    available_balance: 15000,    // cents, ready for payout
    pending: 5000,               // cents, in escrow
    this_period: 8000,           // cents, earned in period
    lifetime: 250000             // cents, total ever
  },
  by_course: [
    {
      course_id, title,
      enrollments: 12,
      gross_revenue: 120000,     // cents
      your_share: 18000,         // 15%
      status: 'released'
    }
  ],
  chart_data: [
    { month: '2025-01', amount: 12000 },
    { month: '2025-02', amount: 15000 }
  ]
}
```

### Transaction History (Stripe Data)

```typescript
// GET /api/creators/me/transactions?page=1&limit=20
{
  transactions: [
    {
      id,
      date: '2025-01-15',
      student_name,
      course_title,
      gross_amount: 10000,       // cents
      your_share: 1500,          // 15% of gross
      status: 'released',        // pending | released | paid
      stripe_charge_id           // Link to Stripe dashboard
    }
  ],
  pagination: { page, total_pages, total_count }
}

// Data source: payment_splits + transactions tables
// Stripe is source of truth for charge status
```

### Payout Request Flow (Stripe Transfer)

```
"Request Payout" Clicked:
  1. POST /api/payouts/request {
       amount: available_balance (or specific amount)
     }
  2. Backend validates:
     - amount <= available_balance
     - amount >= minimum_threshold (e.g., $50)
     - user.stripe_payouts_enabled = true
  3. Backend creates Stripe Transfer:
     stripe.transfers.create({
       amount: amount_cents,
       currency: 'usd',
       destination: user.stripe_account_id,
       transfer_group: `payout-${user.id}-${date}`
     })
  4. Create payout record (status: 'processing')
  5. Response: { payout_id, status: 'processing' }

Webhook: transfer.paid
  - UPDATE payouts SET status = 'completed', paid_at = NOW()
  - UPDATE payment_splits SET status = 'paid' WHERE payout_id = ?
```

### Stripe Connect Status Check

```typescript
// GET /api/payments/connect/status
{
  connected: true,
  account_id: 'acct_xxx',
  payouts_enabled: true,
  requirements: []  // or pending verification items
}

// If not connected, show "Connect Stripe" CTA → SETT
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   CEAR      │      │  PeerLoop   │      │   Stripe    │
│   (Client)  │      │  (Server)   │      │  (Connect)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /earnings      │                    │
       │───────────────────>│                    │
       │                    │ Query DB:          │
       │                    │ - payment_splits   │
       │                    │ - transactions     │
       │ { summary, by_course }                  │
       │<───────────────────│                    │
       │                    │                    │
       │ GET /connect/status│                    │
       │───────────────────>│                    │
       │                    │ Check Stripe       │
       │                    │───────────────────>│
       │ { connected, enabled }                  │
       │<───────────────────│                    │
       │                    │                    │
       │ POST /payouts/     │                    │
       │   request          │                    │
       │───────────────────>│                    │
       │                    │ Create Transfer    │
       │                    │───────────────────>│
       │                    │ transfer_id        │
       │                    │<───────────────────│
       │ { processing }     │                    │
       │<───────────────────│                    │
       │                    │                    │
       │                    │ Webhook:           │
       │                    │ transfer.paid      │
       │                    │<───────────────────│
       │                    │ Mark paid          │
```

---

## Notes

- CD-020: Creator gets 15% royalty
- CD-033: 85/15 split (ST gets 85%, Creator gets 15% when ST teaches)
- Stripe Connect for payouts (Express accounts)
- Earnings come from payment_splits table
- Stripe dashboard link for detailed transaction info
- Consider tax documentation features (1099, future)
