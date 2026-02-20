# CEAR - Earnings Detail

| Field | Value |
|-------|-------|
| Route | `/studio/earnings` |
| Access | Authenticated (Creator role) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 3 |
| JSON Spec | `src/data/pages/dashboard/teaching/earnings.json` |
| Astro Page | `src/pages/dashboard/teaching/earnings.astro` |

---

## Purpose

Provide Creators with detailed view of their earnings, revenue breakdown by course, payout history, and pending balances.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-C035 | As a Creator, I need to view detailed earnings so that I can track my income | P0 | 📋 |
| US-C050 | As a Creator, I need to track revenue by course so that I can see which courses perform best | P0 | 📋 |
| US-C051 | As a Creator, I need to view payout history so that I can reconcile my finances | P0 | 📋 |
| US-C052 | As a Creator, I need to request payouts so that I can receive my earnings | P0 | 📋 |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CDET | Course name click | View course | 📋 |
| SETT | "Payment Settings" | Update payout method | 📋 |
| CDSH | Back/breadcrumb | Return to dashboard | 📋 |
| (Stripe) | "View in Stripe" | External link | 📋 |

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

## Features

### Earnings Summary
- [ ] Available balance (ready for payout) `[US-C035]`
- [ ] Pending balance (in escrow) `[US-C035]`
- [ ] This period earnings `[US-C035]`
- [ ] Lifetime earnings `[US-C035]`
- [ ] Period selector: This month / Last month / This year / All time `[US-C035]`

### Payout Actions
- [ ] "Request Payout" button (if balance > threshold) `[US-C052]`
- [ ] Minimum threshold display `[US-C052]`
- [ ] Stripe Connect status `[US-C052]`

### Revenue Chart
- [ ] Bar/line chart: Revenue over time `[US-C050]`
- [ ] Monthly or weekly granularity `[US-C050]`
- [ ] Stacked by course (optional) `[US-C050]`

### Revenue by Course
- [ ] Course breakdown table `[US-C050]`
- [ ] Enrollments in period `[US-C050]`
- [ ] Gross revenue per course `[US-C050]`
- [ ] Creator royalty (15%) `[US-C050]`
- [ ] Status: Released / Pending `[US-C050]`

### Transaction History
- [ ] Transaction table with date, student, course, amount, share, status `[US-C035]`
- [ ] Expandable rows for full details `[US-C035]`
- [ ] Filter by course, status, date range `[US-C035]`
- [ ] Pagination or infinite scroll `[US-C035]`

### Payout History
- [ ] Payout table with date, amount, status, reference `[US-C051]`
- [ ] Status: Processing / Completed / Failed `[US-C051]`
- [ ] Stripe transfer ID link `[US-C051]`

### Pending Releases
- [ ] List of transactions in escrow `[US-C035]`
- [ ] Expected release dates `[US-C035]`
- [ ] Release conditions `[US-C035]`

### Payment Settings Summary
- [ ] Connected Stripe account status `[US-C052]`
- [ ] Payout threshold display `[US-C052]`
- [ ] "Update Settings" link → SETT `[US-C052]`

---

## Sections (from Plan)

### Header
- Page title: "Earnings"
- Period selector: This month / Last month / This year / All time

### Earnings Summary Cards

| Card | Content |
|------|---------|
| Available Balance | Ready for payout |
| Pending | In escrow, not yet released |
| This Period | Earned in selected period |
| Lifetime Earnings | Total ever earned |

### Revenue Chart
- Time-series chart
- Monthly/weekly toggle
- Course stacking option

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

### Payout History

| Column | Content |
|--------|---------|
| Date | Payout date |
| Amount | Payout amount |
| Status | Processing / Completed / Failed |
| Reference | Stripe transfer ID |

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/creators/me/earnings` | GET | Aggregated earnings data | 📋 |
| `/api/creators/me/transactions` | GET | Transaction history | 📋 |
| `/api/creators/me/payouts` | GET | Past payouts | 📋 |
| `/api/payouts/request` | POST | Initiate payout | 📋 |
| `/api/payments/connect/status` | GET | Stripe Connect status | 📋 |

**Earnings Response:**
```typescript
GET /api/creators/me/earnings?period=this_month
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

**Transaction History:**
```typescript
GET /api/creators/me/transactions?page=1&limit=20
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
```

**Payout Request Flow:**
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

**Stripe Connect Status:**
```typescript
GET /api/payments/connect/status
{
  connected: true,
  account_id: 'acct_xxx',
  payouts_enabled: true,
  requirements: []  // or pending verification items
}
```

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

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load earnings. [Retry]" |
| Payout request fails | "Unable to process. Try again." |
| Stripe disconnected | "Reconnect your Stripe account" |

---

## Mobile Considerations

- Summary cards scroll horizontally
- Transaction list is primary view
- Charts simplified
- Payout action prominent

---

## Implementation Notes

- CD-020: Creator gets 15% royalty
- CD-033: 85/15 split (ST gets 85%, Creator gets 15% when ST teaches)
- Stripe Connect for payouts (Express accounts)
- Earnings come from payment_splits table
- Stripe dashboard link for detailed transaction info
- Consider tax documentation features (1099, future)
- Minimum payout threshold configurable (default $50)
