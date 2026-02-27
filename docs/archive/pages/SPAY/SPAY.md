# SPAY - Payment Settings

| Field | Value |
|-------|-------|
| Route | `/settings/payments` |
| Status | ✅ Implemented |
| Block | 2 |
| JSON Spec | `src/data/pages/settings/payments.json` |
| Astro Page | `src/pages/settings/payments.astro` |
| Component | `src/components/settings/StripeConnectSettings.tsx` |

## Features

- [x] Stripe Connect status
- [x] Connect account button
- [x] Dashboard link
- [x] Payout status indicators *(Charges enabled, Payouts enabled, Details submitted)*

## Component States

The `StripeConnectSettings` component handles 6 states:

| State | Visual | Action Button |
|-------|--------|---------------|
| Loading | Skeleton animation | - |
| Error | Red border, error message | Retry |
| Not Connected | Purple Stripe icon | Connect with Stripe |
| Pending | Yellow hourglass, warning box | Complete Setup |
| Active | Green checkmark | View Dashboard |
| Restricted | Red warning | Update Information |

## User Stories Covered

- US-C023: Set up Stripe Connect to receive payments
- US-ST031: Connect payment account for earnings

## Interactive Elements

### Buttons (onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Retry | StripeConnectSettings | `fetchStatus()` - Refetch status | ✅ Active |
| Connect with Stripe | StripeConnectSettings | `handleConnect()` - POST to /api/stripe/connect, redirect to Stripe | ✅ Active |
| Complete Setup | StripeConnectSettings | `handleGetLink('onboarding')` - Redirect to Stripe onboarding | ✅ Active |
| View Dashboard | StripeConnectSettings | `handleGetLink('dashboard')` - Redirect to Stripe dashboard | ✅ Active |
| Update Information | StripeConnectSettings | `handleGetLink('onboarding')` - Redirect to fix issues | ✅ Active |

### Links

| Element | Target | Status |
|---------|--------|--------|
| Settings breadcrumb | `/settings` | ✅ Active |
| Stripe onboarding | External (Stripe) | ✅ Active |
| Stripe dashboard | External (Stripe) | ✅ Active |

### Analytics Events

| Event | Trigger | Status |
|-------|---------|--------|
| `page_view` | Page load | ❌ Not Implemented |
| `stripe_connect_click` | Connect button clicked | ❌ Not Implemented |
| `stripe_dashboard_click` | Dashboard button clicked | ❌ Not Implemented |

## API Endpoints Used

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/stripe/connect-status` | Page load | Check current Stripe Connect status |
| `POST /api/stripe/connect` | Connect clicked (new) | Create Stripe Express account |
| `GET /api/stripe/connect-link` | Any action button | Get onboarding or dashboard URL |

## Notes

- For Creators and Student-Teachers to receive payments
- Uses Stripe Connect Express accounts
- Shows onboarding status and dashboard access
- Payment split: 85% Creator / 70% S-T, 15% Platform

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 1 discrepancy documented in JSON `_discrepancies` section

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| StripeConnectSettings | `src/components/settings/StripeConnectSettings.tsx` | ✅ No TODOs |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 5 | 5 | 0 |
| Internal Links | 1 | 1 | 0 |
| External Links | 2 | 2 | 0 |
| Analytics Events | 3 | 0 | 3 |

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Analytics events | 3 events specified | Not implemented | ⚠️ Future work |

**Notes:**
- All 6 component states properly implemented
- Both "pending" and "active" states visually verified
- Analytics tracking deferred (not blocking)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `SPAY-2026-01-07-pending.png` | 2026-01-07 | Pending state with 3 requirements |
| `SPAY-2026-01-07-active.png` | 2026-01-07 | Active state with all checkmarks green |
