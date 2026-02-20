# Page: Settings

**Code:** SETT
**URL:** `/settings`
**Access:** Authenticated
**Priority:** P0
**Status:** In Scope

---

## Purpose

Central location for account management, notification preferences, payment settings, availability management, and security options.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Settings" link | Global navigation or user menu |
| PROF | "Settings" link | From profile page |
| SDSH/TDSH/CDSH | "Settings" in menu | From dashboards |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| PROF | "View Profile" link | Back to profile |
| (Stripe) | "Manage Payment" | External: Stripe portal |
| LGIN | After logout | Redirect to login |
| PWRS | "Change Password" → reset flow | Password change |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | email, name, handle, timezone | Account settings |
| (notification_preferences) | various flags | Notification settings |
| availability | day_of_week, start_time, end_time, timezone | ST availability |
| (stripe_customer) | customer_id, payment_method | Payment info |

---

## Sections

### Settings Navigation
- Sidebar or tab navigation:
  - Account
  - Notifications
  - Availability (STs/Creators)
  - Payment (STs/Creators)
  - Privacy
  - Security

### Account Settings
- **Email:** Display current, "Change" button
- **Name:** Editable field
- **Handle:** Display @handle, "Change" (with availability check)
- **Timezone:** Dropdown selector
- **Language:** (Future) Dropdown

### Notification Preferences
- **Email Notifications:**
  - Session reminders (toggle)
  - New message received (toggle)
  - Course updates (toggle)
  - Marketing/newsletter (toggle)
  - Certification notifications (toggle)
- **Push Notifications:** (if mobile app)
  - Same categories as email
- **Notification Frequency:**
  - Immediate / Daily digest / Weekly digest

### Availability Settings (STs/Creators Only)
- Weekly calendar grid
- Set available time slots:
  - Day of week
  - Start time
  - End time
- Timezone reminder/display
- "Copy to all days" helper
- Buffer time between sessions (optional)

### Payment Settings (STs/Creators Only)
- **Payout Method:**
  - Connected Stripe account status
  - "Connect Stripe" or "Update" button → Stripe Connect
- **Payout Threshold:**
  - Minimum balance for auto-payout
- **Payout History:**
  - Recent payouts list
  - "View All" link

### Privacy Settings
- **Profile Visibility:** Public/Private toggle
- **Show Online Status:** Toggle
- **Allow Messages From:** Everyone / Enrolled only / Following only
- **Data Export:** "Download My Data" button

### Security Settings
- **Password:**
  - "Change Password" → PWRS flow or inline
  - Last changed date
- **Two-Factor Authentication:** (Future)
  - Enable/disable 2FA
  - Recovery codes
- **Active Sessions:**
  - List of logged-in devices
  - "Log out" button per session
  - "Log out all devices"
- **Delete Account:**
  - "Delete My Account" (with confirmation)

### Logout
- "Log Out" button
- Confirms and redirects to HOME/LGIN

---

## User Stories Fulfilled

- US-P010: Manage account settings
- US-P018: Control notification preferences
- US-C006: Creator sets availability
- US-T001: ST sets availability
- US-P022: Set timezone preference

---

## States & Variations

| State | Description |
|-------|-------------|
| Student | Hides Availability, Payment sections |
| ST | Shows Availability, Payment sections |
| Creator | Shows Availability, Payment sections |
| Multi-Role | All sections visible |
| Stripe Connected | Shows account status, update option |
| Stripe Not Connected | Prominent "Connect Stripe" CTA |

---

## Mobile Considerations

- Settings nav becomes horizontal tabs or accordion
- Each section is a separate screen
- Large touch targets for toggles
- Confirmation dialogs for destructive actions

---

## Error Handling

| Error | Display |
|-------|---------|
| Save fails | "Unable to save settings. Please try again." |
| Email change fails | "Unable to update email. Try again." |
| Stripe connection fails | "Unable to connect payment. Try again." |
| Account deletion fails | "Unable to delete. Contact support." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | section |
| `setting_changed` | Any setting saved | setting_name, new_value |
| `availability_updated` | Availability changed | slots_count |
| `stripe_connected` | Stripe connected | - |
| `logout` | Logout clicked | - |
| `account_deleted` | Account deleted | - |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/users/me/settings` | Page load | Get all settings |
| `PATCH /api/users/me/settings` | Save changes | Update settings |
| `GET /api/users/me/availability` | Availability tab | Get availability pattern |
| `PUT /api/users/me/availability` | Save availability | Update availability |
| `POST /api/payments/connect/onboard` | "Connect Stripe" | Start Stripe Connect |
| `GET /api/payments/connect/status` | Payment tab | Check account status |
| `POST /api/payments/connect/dashboard` | "Manage" | Get Stripe Express dashboard link |
| `GET /api/users/me/payouts` | Payout history | List past payouts |

### Stripe Connect Onboarding Flow

```
Initial State (No Stripe Account):
  1. User sees "Connect Stripe Account" button
  2. Status: stripe_account_id = null

Start Onboarding:
  1. POST /api/payments/connect/onboard
  2. Backend:
     - Creates Stripe Express account
     - Stores stripe_account_id in users table
     - Creates Account Link with return/refresh URLs
  3. Response: { onboarding_url: "https://connect.stripe.com/..." }
  4. Client redirects to Stripe

Stripe Onboarding:
  - User completes identity verification
  - User adds bank account / debit card
  - User accepts Stripe terms

Return to PeerLoop:
  - Success: /settings/payment?success=true
  - Refresh: /settings/payment?refresh=true (incomplete, link expired)

Webhook Processing:
  account.updated event:
    - Update stripe_account_status
    - Update stripe_payouts_enabled
    - If enabled: show "Connected" badge

Express Dashboard Access:
  POST /api/payments/connect/dashboard
  → Returns: { dashboard_url: "https://connect.stripe.com/..." }
  → User can view/update their Stripe settings
```

### Stripe Connect States

| State | DB Values | UI Display |
|-------|-----------|------------|
| Not Connected | `stripe_account_id = null` | "Connect Stripe" button |
| Onboarding Incomplete | `status = 'pending'` | "Complete Setup" warning |
| Connected (No Payouts) | `status = 'active', payouts = false` | "Connected - Payouts Disabled" |
| Fully Active | `status = 'active', payouts = true` | "Connected ✓" + "Manage" link |

### Availability Management

```typescript
// GET /api/users/me/availability
{
  slots: [
    { day_of_week: 1, start_time: "09:00", end_time: "12:00" },
    { day_of_week: 1, start_time: "14:00", end_time: "17:00" },
    { day_of_week: 2, start_time: "09:00", end_time: "17:00" },
    // ...
  ],
  timezone: "America/New_York",
  buffer_minutes: 15
}

// PUT /api/users/me/availability
// Same format - replaces entire availability pattern
// Stored in DB with times in user's timezone (not UTC)
```

### Email Verification Flow

```
Change Email:
  1. PATCH /api/users/me/settings { email: "new@example.com" }
  2. Backend:
     - Validates new email not taken
     - Sends verification email via Resend
     - Sets email_pending = "new@example.com"
     - Current email remains active
  3. User clicks verification link
  4. POST /api/auth/verify-email?token=xxx
  5. Backend updates email, clears email_pending
```

### Data Flow: Stripe Connect

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   SETT      │      │  PeerLoop   │      │   Stripe    │
│   (Client)  │      │  (Server)   │      │  (Connect)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ POST /connect/     │                    │
       │   onboard          │                    │
       │───────────────────>│                    │
       │                    │ Create Express     │
       │                    │ account            │
       │                    │───────────────────>│
       │                    │ account_id         │
       │                    │<───────────────────│
       │                    │                    │
       │                    │ Create Account     │
       │                    │ Link               │
       │                    │───────────────────>│
       │                    │ onboarding_url     │
       │                    │<───────────────────│
       │ { onboarding_url } │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ redirect ────────────────────────────────>
       │                    │                    │
       │ (user completes KYC on Stripe)          │
       │                    │                    │
       │ <──────────────────────── return URL    │
       │                    │                    │
       │                    │ Webhook:           │
       │                    │ account.updated    │
       │                    │<───────────────────│
       │                    │ Update DB          │
       │                    │                    │
       │ GET /connect/status│                    │
       │───────────────────>│                    │
       │ { connected, enabled }                  │
       │<───────────────────│                    │
```

### Webhook: account.updated

```typescript
// Webhook handler updates:
users.stripe_account_status = event.data.charges_enabled ? 'active' : 'pending'
users.stripe_payouts_enabled = event.data.payouts_enabled

// If newly enabled, send notification:
if (event.data.payouts_enabled && !previous.payouts_enabled) {
  // Send "Payouts Enabled" email via Resend
}
```

---

## Notes

- Security-sensitive changes should require password confirmation
- Email change triggers verification email via Resend
- Consider in-app notification preview
- Stripe Connect: Express accounts for STs/Creators (per CD-020)
- Availability stored in user's timezone, converted for display to students
- Webhook `account.updated` is the source of truth for Stripe status
