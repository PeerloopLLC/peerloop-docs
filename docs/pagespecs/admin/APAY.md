# Screen: Admin Payouts

**Code:** APAY
**URL:** `/admin/payouts` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Manage platform payouts - process pending payouts to STs and Creators, view transaction history, and handle payment issues.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Payouts" nav item | Admin sidebar |
| AUSR | "View Payouts" on user | Filtered to user |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | Recipient name click | View user |
| AENR | "View Enrollment" | Source enrollment |
| (Stripe) | "View in Stripe" | External link |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| payouts | All fields | Payout records |
| payment_splits | All fields | Revenue splits |
| transactions | All fields | Source transactions |
| users (recipients) | id, name, email, stripe_account | Recipient info |
| courses | id, title | Source course |
| enrollments | id | Source enrollment |

---

## Sections

### Header
- Screen title: "Payout Management"
- "Process Pending" button (batch)
- Pending total badge

### Summary Cards
- **Pending Payouts** - Total $ awaiting processing
- **Processing** - Currently in transit
- **Paid This Month** - Month total
- **Paid All Time** - Lifetime total

### Tabs
- **Pending** - Awaiting admin approval
- **Processing** - Sent to Stripe
- **Completed** - Successfully paid
- **Failed** - Failed payouts

### Pending Payouts Tab

Grouped by recipient:

**Recipient Card:**
- Name + avatar
- Pending balance
- Split: ST amount / Creator amount
- Stripe account status
- "Process Payout" button

**Expandable Details:**
- List of individual payment splits:
  - Transaction date
  - Course
  - Student
  - Gross amount
  - Split amount
  - Split type (ST 85% / Creator 15%)

### Payouts Table (All Tabs)

| Column | Content |
|--------|---------|
| Recipient | Name |
| Type | ST / Creator |
| Amount | Payout amount |
| Transactions | Count of splits included |
| Status | Pending / Processing / Completed / Failed |
| Requested | Date requested |
| Processed | Date processed |
| Actions | Process, View, Cancel |

### Payout Detail Panel

**Payout Info:**
- Recipient info (link to AUSR)
- Amount
- Status + timestamps
- Stripe transfer ID (if processed)

**Included Transactions:**
- List of payment splits in this payout
- Source enrollments
- Split calculations

**For Failed Payouts:**
- Failure reason
- Retry option
- Alternative actions

### Actions

| Action | Description |
|--------|-------------|
| Process Single | Process one payout |
| Process All | Batch process all pending |
| Cancel | Cancel pending payout |
| Retry | Retry failed payout |
| Manual Override | Mark as paid (for offline payment) |

### Process Payout Flow
1. Select payouts to process
2. Review totals
3. Confirm Stripe account status
4. Process (calls Stripe API)
5. Update status

---

## CRUD Operations

| Operation | Endpoint | Notes |
|-----------|----------|-------|
| List Pending | GET /api/admin/payouts/pending | Grouped by recipient |
| List All | GET /api/admin/payouts | All payouts |
| Read | GET /api/admin/payouts/:id | Payout detail |
| Process | POST /api/admin/payouts/:id/process | Initiate Stripe transfer |
| Batch Process | POST /api/admin/payouts/batch | Process multiple |
| Cancel | DELETE /api/admin/payouts/:id | Cancel pending |

---

## Revenue Split Reference (CD-020, CD-033)

| Role | Percentage |
|------|------------|
| Student-Teacher | 85% |
| Creator (Royalty) | 15% |
| Platform | 0% (absorbed in fees) |

---

## States & Variations

| State | Description |
|-------|-------------|
| Pending Tab | Showing pending, grouped by recipient |
| Processing | Payout in progress |
| Completed | Viewing history |
| Failed | Viewing/retrying failures |
| Detail | Payout panel open |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load payouts. [Retry]" |
| Stripe error | "Stripe error: [message]. Check dashboard." |
| No Stripe account | "Recipient has no Stripe account connected" |
| Insufficient balance | "Platform balance insufficient" |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/payouts/pending` | Pending tab | Grouped pending payouts |
| `GET /api/admin/payouts` | All tabs | All payout records |
| `GET /api/admin/payouts/:id` | Detail view | Single payout detail |
| `POST /api/admin/payouts/:id/process` | "Process" clicked | Execute Stripe transfer |
| `POST /api/admin/payouts/batch` | "Process All" | Batch transfers |
| `DELETE /api/admin/payouts/:id` | "Cancel" clicked | Cancel pending payout |
| `POST /api/admin/payouts/:id/retry` | "Retry" on failed | Retry failed transfer |

### Pending Payouts Aggregation

```typescript
// GET /api/admin/payouts/pending
{
  total_pending: 450000,          // cents
  recipients: [
    {
      user_id,
      name,
      email,
      type: 'student_teacher' | 'creator',
      stripe_account_id,
      stripe_account_status,
      stripe_payouts_enabled,
      pending_balance: 85000,     // cents
      splits: [
        {
          id,
          transaction_date,
          course_title,
          student_name,
          gross_amount,
          split_amount,
          split_type: 'st_85' | 'creator_15'
        }
      ]
    }
  ]
}
```

### Process Single Payout (Stripe Transfer)

```
"Process Payout" Clicked:
  1. POST /api/admin/payouts/:id/process
  2. Backend validates:
     - Payout exists and is pending
     - Recipient has stripe_payouts_enabled = true
     - Amount > 0
  3. Backend creates Stripe Transfer:
     stripe.transfers.create({
       amount: payout.amount_cents,
       currency: 'usd',
       destination: recipient.stripe_account_id,
       transfer_group: `admin-payout-${payout.id}`,
       metadata: { payout_id: payout.id, admin_id: admin.id }
     })
  4. Update payout status: 'processing'
  5. Response: { status: 'processing', transfer_id }

Webhook: transfer.paid
  - UPDATE payouts SET status = 'completed', paid_at = NOW()
  - UPDATE payment_splits SET status = 'paid'
```

### Batch Process Payouts

```typescript
// POST /api/admin/payouts/batch
{
  payout_ids: ['id1', 'id2', 'id3']  // or 'all' for all pending
}

// Backend processes each sequentially:
for each payout_id:
  1. Validate recipient Stripe status
  2. Create Stripe Transfer
  3. Update payout status
  4. Record result

// Response:
{
  processed: 8,
  failed: 2,
  results: [
    { payout_id: 'id1', status: 'success', transfer_id: 'tr_xxx' },
    { payout_id: 'id2', status: 'failed', error: 'Stripe account not enabled' }
  ]
}
```

### Failed Payout Retry

```typescript
// POST /api/admin/payouts/:id/retry
// Same flow as process, but clears previous error first
// May need manual intervention for persistent failures
```

### Stripe Connect Validation

```typescript
// Before processing, check recipient:
const account = await stripe.accounts.retrieve(stripe_account_id);

if (!account.payouts_enabled) {
  throw new Error('Recipient payouts not enabled');
}

if (account.requirements?.currently_due?.length > 0) {
  throw new Error('Recipient has pending verification');
}
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   APAY      │      │  PeerLoop   │      │   Stripe    │
│   (Admin)   │      │  (Server)   │      │  (Connect)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /admin/        │                    │
       │   payouts/pending  │                    │
       │───────────────────>│                    │
       │                    │ Query DB:          │
       │                    │ - payment_splits   │
       │                    │ - users            │
       │ { recipients }     │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ POST /admin/       │                    │
       │   payouts/:id/     │                    │
       │   process          │                    │
       │───────────────────>│                    │
       │                    │ Validate account   │
       │                    │───────────────────>│
       │                    │ account.payouts_   │
       │                    │ enabled            │
       │                    │<───────────────────│
       │                    │                    │
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
       │                    │ Mark completed     │
```

### Audit Trail

```typescript
// All payout actions logged:
admin_audit_log {
  id,
  admin_user_id,
  action: 'payout_processed' | 'payout_cancelled' | 'payout_retried',
  payout_id,
  details: { amount, recipient_id, transfer_id },
  created_at
}
```

---

## Notes

- CD-020: Semi-automated payouts (admin approves, Stripe transfers)
- Stripe Connect for marketplace payouts (Express accounts)
- Minimum payout threshold: $50 (configurable)
- Tax documentation: 1099 thresholds tracked
- Audit trail critical for financial records
- Admin can only process, not modify amounts
- All transfers tracked with transfer_group for reconciliation
