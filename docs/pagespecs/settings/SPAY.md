# Page: Payment Settings

**Code:** SPAY
**URL:** `/settings/payments`
**Access:** Authenticated (Creators and Student-Teachers)
**Priority:** P1
**Status:** Implemented

---

## Purpose

Allow Creators and Student-Teachers to manage their Stripe Connect accounts for receiving payments from student enrollments and teaching sessions.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| SETT | "Payments" card/link | From main settings page |
| CDSH | "Set up payments" prompt | When Stripe not connected (Creators) |
| TDSH | "Set up payments" prompt | When Stripe not connected (STs) |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SETT | Breadcrumb "Settings" | Return to settings hub |
| (Stripe) | "Connect with Stripe" button | Opens Stripe Connect onboarding (external) |
| (Stripe Dashboard) | "View Dashboard" button | Opens Stripe Express dashboard (external) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | stripe_account_id | Check if connected |
| users | stripe_account_status | Connection status (pending, active, restricted) |
| (Stripe API) | charges_enabled, payouts_enabled, details_submitted | Live payout status |

---

## Sections

### Header
- Page title: "Payment Settings"
- Description: "Connect your Stripe account to receive payments"

### Stripe Connect Status Card
Status-based display with icon, title, description, and action button:

**Not Connected State:**
- Purple Stripe icon
- "Connect Your Stripe Account" title
- Description about receiving payments
- "Connect with Stripe" button (purple)

**Pending State:**
- Yellow hourglass icon
- "Complete Your Stripe Setup" title
- Warning box listing incomplete requirements
- Requirements checklist:
  - Charges Enabled: ✓ or ✗
  - Payouts Enabled: ✓ or ✗
  - Details Submitted: ✓ or ✗
- "Complete Setup" button

**Active State:**
- Green checkmark icon
- "Stripe Connected" title
- All requirements show green checkmarks
- "View Dashboard" button

**Restricted State:**
- Red warning icon
- "Action Required" title
- Warning about account restrictions
- "Update Information" button

### How Payments Work Section
- Background: Secondary/gray
- Step 1: "When a student pays for a course or session..."
- Step 2: "Payments are split automatically..."
  - Creators: 85% to you, 15% platform
  - Student-Teachers: 70% to you, 15% Creator, 15% platform
- Step 3: "Funds are transferred to your connected Stripe account"

---

## User Stories Fulfilled

- US-C023: Creator connects Stripe to receive payments
- US-ST031: Student-Teacher connects Stripe for teaching earnings

---

## States & Variations

| State | Description |
|-------|-------------|
| Loading | Skeleton animation while checking status |
| Error | Red border, error message, Retry button |
| Not Connected | Purple Stripe icon, Connect with Stripe button |
| Pending | Yellow hourglass, warning box, Complete Setup button |
| Active | Green checkmark, View Dashboard button |
| Restricted | Red warning, Update Information button |

---

## Mobile Considerations

- Full-width buttons on mobile
- Info section remains readable
- Status card adapts to narrow screens

---

## Error Handling

| Error | Display |
|-------|---------|
| Failed to check status | "Unable to check payment status" with retry |
| Failed to create connect link | "Unable to start Stripe setup. Please try again." |
| Failed to create dashboard link | "Unable to open Stripe dashboard. Please try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | stripe_status |
| `stripe_connect_click` | Connect button clicked | - |
| `stripe_dashboard_click` | Dashboard button clicked | - |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/stripe/connect-status` | Page load | Check current Stripe Connect status |
| `POST /api/stripe/connect` | Connect clicked (new) | Create Stripe Express account |
| `GET /api/stripe/connect-link?type=X` | Connect/Complete/Update clicked | Get onboarding URL |
| `GET /api/stripe/connect-link?type=dashboard` | Dashboard clicked | Get Express dashboard URL |

**Status Response:**
```typescript
GET /api/stripe/connect-status
{
  connected: boolean,
  account_id: string | null,
  status: 'not_connected' | 'pending' | 'active' | 'restricted',
  charges_enabled: boolean,
  payouts_enabled: boolean,
  details_submitted: boolean
}
```

**Connect Response:**
```typescript
POST /api/stripe/connect
{
  account_id: string,
  onboarding_url: string
}
```

**Link Response:**
```typescript
GET /api/stripe/connect-link?type=onboarding|dashboard
{
  url: string
}
```

---

## Stripe Connect Flow

```
1. User clicks "Connect with Stripe"
2. POST /api/stripe/connect
   - Backend creates Stripe Express account
   - Stores stripe_account_id in users table
   - Returns onboarding URL
3. User redirected to Stripe for:
   - Identity verification
   - Bank account setup
   - Terms acceptance
4. User returns to /settings/payments
5. Webhook (account.updated) updates status in DB
6. Page shows current status on reload
```

### Express Dashboard Access
- Connected users can access Stripe Express dashboard
- View payouts, update bank info, download tax documents
- Opens in new tab via Stripe-generated URL

---

## Implementation Notes

- Uses Stripe Connect Express accounts (simplest for platforms)
- Revenue split: 85% Creator / 70% ST, 15% Platform
- Status refreshed via Stripe webhooks, not polling
- Dashboard links expire after short time, generated on-demand
- Return URL after Stripe onboarding: `/settings/payments?stripe_return=true`
