# APAY - Admin Payouts

| Field | Value |
|-------|-------|
| Route | `/admin/payouts` |
| Access | Admin |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 8 |
| JSON Spec | `src/data/pages/admin/payouts.json` |
| Astro Page | `src/pages/admin/payouts.astro` |
| Component | `src/components/admin/PayoutsAdmin.tsx` |

---

## Purpose

Manage platform payouts - process pending payouts to STs and Creators, view transaction history, and handle payment issues.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A045 | As an Admin, I need to view pending payment splits grouped by recipient | P0 | ✅ |
| US-A046 | As an Admin, I need to create payouts from pending splits | P0 | ✅ |
| US-A047 | As an Admin, I need to process payouts via Stripe transfer | P0 | ✅ |
| US-A048 | As an Admin, I need to retry failed payouts | P1 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Payouts" nav item | Admin sidebar |
| AUSR | "View Payouts" on user | Filtered to user *(API supports, UI doesn't use yet)* |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | Recipient name click | *(Not yet linked)* |
| AENR | "View Enrollment" | *(Not yet linked)* |
| (Stripe) | "View in Stripe" | External link ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| payouts | id, recipient_id, recipient_type, amount_cents, stripe_transfer_id, status, approved_by, approved_at, paid_at, failure_reason, created_at | Payout records |
| payment_splits | id, transaction_id, enrollment_id, recipient_id, recipient_type, amount_cents, percentage, stripe_transfer_id, status, payout_id, created_at, paid_at | Revenue splits |
| transactions | id, enrollment_id, amount_cents, stripe_payment_intent_id, status, created_at | Source transactions |
| users | id, name, email, avatar_url, handle, stripe_account_id, stripe_account_status, stripe_payouts_enabled | Recipient info |
| courses | id, title | Course context |
| enrollments | id, student_id, course_id | Enrollment context |

---

## Features

### Stats & Overview
- [x] Four summary cards (Pending Payouts, Processing, Paid This Month, Paid All Time) `[US-A045]`
- [x] Pending count badge on Pending tab `[US-A045]`
- [x] Failed count badge on Failed tab `[US-A048]`

### Pending Payouts View
- [x] Recipients grouped by user with collapsible sections `[US-A045]`
- [x] Stripe Ready/Pending status badges `[US-A046]`
- [x] Expandable split details table `[US-A045]`
- [x] "Create Payout" button per recipient `[US-A046]`
- [x] Minimum threshold validation ($50) `[US-A046]`

### Payout Processing
- [x] Process single payout via Stripe transfer `[US-A047]`
- [x] Batch process all pending payouts `[US-A047]`
- [x] Cancel pending payout (returns splits to pool) `[US-A047]`
- [x] Retry failed payout (reset to pending) `[US-A048]`
- [ ] Manual override (mark as paid) `[US-A047]` *(P2 - Not built)*

### Detail Panel
- [x] Recipient info section with Stripe status `[US-A045]`
- [x] Payout status with timestamps `[US-A045]`
- [x] List of included splits with course/student context `[US-A045]`
- [x] Action buttons based on payout status `[US-A047]`
- [x] View in Stripe external link `[US-A047]`

### Table View (non-pending tabs)
- [x] Sortable data table with pagination `[US-A045]`
- [x] Status badges (Processing/Completed/Failed) `[US-A045]`
- [x] Row actions menu `[US-A047]`
- [x] Row click opens detail panel `[US-A045]`

---

## Sections

### Header
- Screen title: "Payout Management"
- Subtitle: "Process payments to Student-Teachers and Creators"
- "Process All Pending" button (shows when pending_count > 0)

### Summary Cards (4 columns)
- **Pending Payouts** - Total $ of created but unprocessed payouts + recipient count
- **Processing** - Currently in transit to Stripe (yellow)
- **Paid This Month** - Month-to-date total (green)
- **Paid All Time** - Lifetime total (indigo)

### Status Tabs
- **Pending** - Created payouts awaiting processing (badge shows count)
- **Processing** - Sent to Stripe, awaiting confirmation
- **Completed** - Successfully paid
- **Failed** - Failed payouts with retry option (badge shows count)

### Pending Tab - Grouped View
Recipients grouped by user with collapsible sections:
- Avatar/initial + name
- Type (Student-Teacher / Creator) + handle
- Pending balance (large, bold)
- Transaction count
- "Stripe Ready" or "Stripe Pending" badge
- "Create Payout" button (disabled if Stripe not ready)
- Expand/collapse chevron

**Expanded Details Table:**
| Column | Content |
|--------|---------|
| Date | Transaction date |
| Course | Course title |
| Student | Student name |
| Split Type | Type + percentage |
| Amount | Split amount |

### Other Tabs - Table View
| Column | Content |
|--------|---------|
| Recipient | Avatar + name + type |
| Amount | Payout amount |
| Splits | Transaction count |
| Status | Badge |
| Created | Date created |
| Paid | Date paid (or -) |
| Actions | Menu |

### Payout Detail Panel
**Recipient Section:**
- Avatar + name + email
- Type (Student-Teacher / Creator)
- Stripe Account ID
- Payouts Enabled (Yes/No)

**Status Section:**
- Current status badge
- Amount
- Created date
- Approved by/at (if approved)
- Paid at (if completed)
- Stripe Transfer ID (if processed)
- Failure reason (if failed)

**Included Transactions:**
- Scrollable list of splits
- Each shows: course title, amount, student name, date, split type + percentage

**Footer Actions:**
- Process Payout (pending)
- Cancel (pending)
- Retry (failed)
- View in Stripe (if has transfer_id)

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/payouts` | GET | List payouts with filtering/pagination | ✅ |
| `/api/admin/payouts` | POST | Create payout from pending splits | ✅ |
| `/api/admin/payouts/pending` | GET | Pending splits grouped by recipient | ✅ |
| `/api/admin/payouts/:id` | GET | Single payout detail with splits | ✅ |
| `/api/admin/payouts/:id` | DELETE | Cancel pending payout | ✅ |
| `/api/admin/payouts/:id/process` | POST | Execute Stripe transfer | ✅ |
| `/api/admin/payouts/:id/retry` | POST | Retry failed payout | ✅ |
| `/api/admin/payouts/batch` | POST | Batch process multiple payouts | ✅ |

---

## Revenue Split Reference (CD-020, CD-033)

**When S-T teaches:**
| Role | Percentage |
|------|------------|
| Student-Teacher | 70% |
| Creator (Royalty) | 15% |
| Platform | 15% |

**When Creator teaches directly:**
| Role | Percentage |
|------|------------|
| Creator | 85% |
| Platform | 15% |

---

## States & Variations

| State | Description |
|-------|-------------|
| Pending Tab - Empty | Success icon, "All payment splits have been processed" |
| Pending Tab - With Recipients | Grouped cards, some expanded |
| Processing Tab | Table of in-transit payouts |
| Completed Tab | History table |
| Failed Tab | Table with retry actions |
| Detail Panel Open | Slide-in panel with payout info |
| Batch Processing | Process All button shows spinner |

---

## Error Handling

| Error | Display |
|-------|---------|
| API load fails | Red error banner with Retry button |
| Stripe transfer fails | Alert with error, payout moves to Failed tab |
| No Stripe account | Create Payout disabled, "Stripe Pending" badge |
| Below minimum ($50) | Alert showing threshold not met |
| Batch partial failure | Summary alert (X succeeded, Y failed) |

---

## Implementation Notes

- CD-020: Semi-automated payouts (admin approves, Stripe transfers)
- Stripe Connect Express accounts for marketplace payouts
- Minimum payout threshold: $50 (enforced in POST /api/admin/payouts)
- All transfers tagged with transfer_group for reconciliation
- Admin can only process existing splits, cannot modify amounts
- Failed payouts retain failure_reason from Stripe
- Tax documentation: 1099 thresholds should be tracked (future)

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Process All Pending | PayoutsAdmin | POST /api/admin/payouts/batch | ✅ Active |
| Create Payout | PayoutsAdmin | POST /api/admin/payouts | ✅ Active |
| Process Payout | PayoutsAdmin | POST /api/admin/payouts/:id/process | ✅ Active |
| Cancel | PayoutsAdmin | DELETE /api/admin/payouts/:id | ✅ Active |
| Retry | PayoutsAdmin | POST /api/admin/payouts/:id/retry | ✅ Active |
| Expand/Collapse | PayoutsAdmin | Toggle splits visibility | ✅ Active |
| View Details | PayoutsAdmin | Fetch payout detail, open panel | ✅ Active |
| Tab buttons | PayoutsAdmin | Switch active tab | ✅ Active |
| Retry (error) | PayoutsAdmin | Reload data | ✅ Active |

### Links

| Section | Element | Target | Status |
|---------|---------|--------|--------|
| Detail Panel | View in Stripe | https://dashboard.stripe.com/transfers/:id | ✅ Active |
| Recipients | Recipient name → AUSR | /admin/users | ❌ Not linked |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /admin/users | AUSR | ✅ Yes |
| /admin/enrollments | AENR | ✅ Yes |
| https://dashboard.stripe.com | (External) | ✅ Yes |

### Analytics Events

| Event | Trigger | Status |
|-------|---------|--------|
| admin_payout_viewed | Page load | ❌ Not implemented |
| admin_payout_processed | Single payout processed | ❌ Not implemented |
| admin_payout_batch_processed | Batch process completed | ❌ Not implemented |
| admin_payout_cancelled | Payout cancelled | ❌ Not implemented |
| admin_payout_retried | Failed payout retried | ❌ Not implemented |

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| PayoutsAdmin | src/components/admin/PayoutsAdmin.tsx | ✅ Clean (no TODOs) |

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Manual Override | Mark as paid for offline | Not built | ❌ P2 |
| Recipient name link | Links to AUSR | Not linked | ❌ P1 |
| Filter by recipient | URL param from AUSR | API supports, UI doesn't use | ⚠️ P1 |
| Analytics events | 5 events specified | None implemented | ❌ P2 |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 9 | 9 | 0 |
| Internal Links | 1 | 0 | 1 |
| External Links | 1 | 1 | 0 |
| Analytics Events | 5 | 0 | 5 |

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `APAY-2026-01-08-15-26-37.png` | 2026-01-08 | Pending tab with 3 recipients (Guy, Marcus, Sarah) |

---

## _Discrepancies

**As of:** 2026-01-08

### Planned But Not Implemented

| Feature | Original Spec | Status | Priority |
|---------|---------------|--------|----------|
| Manual Override | Mark as paid for offline payment | Not built | P2 |
| Filter by recipient | URL param ?recipient_id for filtered view from AUSR | API supports, UI doesn't use | P1 |
| Analytics events | 5 page/action events | Not implemented | P2 |
| Recipient name link | Navigate to AUSR user detail | Not linked | P1 |

### Implemented Differently

| Feature | Original Spec | Reality | Note |
|---------|---------------|---------|------|
| Pending view | Table like other tabs | Grouped by recipient with expandable sections | Better UX |
| Revenue split | ST 85% / Creator 15% | ST 70% / Creator 15% / Platform 15% | Corrected per latest spec |
