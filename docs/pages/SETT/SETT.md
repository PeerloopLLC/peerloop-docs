# SETT - Settings

| Field | Value |
|-------|-------|
| Route | `/settings` |
| Access | Authenticated |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 9 |
| JSON Spec | `src/data/pages/settings.json` |
| Astro Page | `src/pages/settings.astro` |

---

## Purpose

Central location for account management, notification preferences, payment settings, availability management, and security options.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-P010 | As a Platform, I need settings pages so that users can manage their accounts | P0 | 📋 |
| US-P018 | As a Platform, I need notification controls so that users can set preferences | P0 | 📋 |
| US-C006 | As a Creator, I need to set availability so that students can book with me | P0 | 📋 |
| US-T001 | As a S-T, I need to set availability so that students can book sessions | P0 | 📋 |
| US-P022 | As a Platform, I need timezone settings so that times display correctly | P0 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Settings" link | Global navigation or user menu |
| PROF | "Settings" link | From profile page |
| SDSH/TDSH/CDSH | "Settings" in menu | From dashboards |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| PROF | "View Profile" link | Back to profile | 📋 |
| (Stripe) | "Manage Payment" | External: Stripe portal | 📋 |
| LGIN | After logout | Redirect to login | 📋 |
| PWRS | "Change Password" → reset flow | Password change | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | email, name, handle, timezone | Account settings |
| notification_preferences | various flags | Notification settings |
| availability | day_of_week, start_time, end_time, timezone | ST availability |
| stripe_account | customer_id, account_status, payouts_enabled | Payment info |

---

## Features

### Settings Navigation
- [ ] Sidebar or tab navigation `[US-P010]`
- [ ] Account, Notifications, Availability, Payment, Privacy, Security tabs `[US-P010]`

### Account Settings
- [ ] Email: Display + "Change" button `[US-P010]`
- [ ] Name: Editable field `[US-P010]`
- [ ] Handle: Display + "Change" with availability check `[US-P010]`
- [ ] Timezone: Dropdown selector `[US-P022]`

### Notification Preferences
- [ ] Session reminders (toggle) `[US-P018]`
- [ ] New message received (toggle) `[US-P018]`
- [ ] Course updates (toggle) `[US-P018]`
- [ ] Marketing/newsletter (toggle) `[US-P018]`
- [ ] Certification notifications (toggle) `[US-P018]`
- [ ] Notification frequency: Immediate/Daily/Weekly `[US-P018]`

### Availability Settings (STs/Creators Only)
- [ ] Weekly calendar grid `[US-T001]`
- [ ] Set available time slots `[US-T001]`
- [ ] Timezone reminder/display `[US-P022]`
- [ ] "Copy to all days" helper `[US-T001]`
- [ ] Buffer time between sessions `[US-T001]`

### Payment Settings (STs/Creators Only)
- [ ] Connected Stripe account status `[US-P010]`
- [ ] "Connect Stripe" or "Update" button `[US-P010]`
- [ ] Payout threshold setting `[US-P010]`
- [ ] Recent payouts list `[US-P010]`

### Privacy Settings
- [ ] Profile visibility: Public/Private toggle `[US-P010]`
- [ ] Show online status toggle `[US-P010]`
- [ ] Allow messages from: Everyone/Enrolled/Following `[US-P010]`
- [ ] "Download My Data" button `[US-P010]`

### Security Settings
- [ ] "Change Password" link `[US-P010]`
- [ ] Last password changed date `[US-P010]`
- [ ] Active sessions list `[US-P010]`
- [ ] "Log out all devices" button `[US-P010]`
- [ ] "Delete My Account" (with confirmation) `[US-P010]`

### Logout
- [ ] "Log Out" button `[US-P010]`

---

## Sections (from Plan)

### Settings Navigation
- Sidebar/tabs: Account, Notifications, Availability, Payment, Privacy, Security

### Account Settings
- Email, Name, Handle, Timezone

### Notification Preferences
- Email notification toggles
- Frequency selector

### Availability Settings (STs/Creators)
- Weekly calendar grid
- Time slot management
- Buffer time

### Payment Settings (STs/Creators)
- Stripe Connect status
- Payout history

### Privacy Settings
- Visibility toggles
- Data export

### Security Settings
- Password management
- Active sessions
- Account deletion

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/users/me/settings` | GET | Get all settings | 📋 |
| `/api/users/me/settings` | PATCH | Update settings | 📋 |
| `/api/users/me/availability` | GET | Get availability pattern | 📋 |
| `/api/users/me/availability` | PUT | Update availability | 📋 |
| `/api/payments/connect/onboard` | POST | Start Stripe Connect | 📋 |
| `/api/payments/connect/status` | GET | Check account status | 📋 |
| `/api/payments/connect/dashboard` | POST | Get Stripe dashboard link | 📋 |
| `/api/users/me/payouts` | GET | List past payouts | 📋 |

**Stripe Connect Onboarding Flow:**
```
1. POST /api/payments/connect/onboard
2. Backend:
   - Creates Stripe Express account
   - Stores stripe_account_id in users table
   - Creates Account Link with return/refresh URLs
3. Response: { onboarding_url: "https://connect.stripe.com/..." }
4. Client redirects to Stripe
5. User completes identity verification + bank setup
6. Return to PeerLoop: /settings/payment?success=true
7. Webhook account.updated updates DB status
```

**Stripe Connect States:**
| State | DB Values | UI Display |
|-------|-----------|------------|
| Not Connected | `stripe_account_id = null` | "Connect Stripe" button |
| Onboarding Incomplete | `status = 'pending'` | "Complete Setup" warning |
| Connected (No Payouts) | `status = 'active', payouts = false` | "Connected - Payouts Disabled" |
| Fully Active | `status = 'active', payouts = true` | "Connected" + "Manage" link |

**Availability Management:**
```typescript
GET /api/users/me/availability
{
  slots: [
    { day_of_week: 1, start_time: "09:00", end_time: "12:00" },
    { day_of_week: 1, start_time: "14:00", end_time: "17:00" },
    // ...
  ],
  timezone: "America/New_York",
  buffer_minutes: 15
}

PUT /api/users/me/availability
// Same format - replaces entire availability pattern
```

**Email Verification Flow:**
```
1. PATCH /api/users/me/settings { email: "new@example.com" }
2. Backend validates, sends verification email (Resend)
3. Sets email_pending, current email remains active
4. User clicks verification link
5. POST /api/auth/verify-email?token=xxx
6. Backend updates email, clears email_pending
```

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

## Error Handling

| Error | Display |
|-------|---------|
| Save fails | "Unable to save settings. Please try again." |
| Email change fails | "Unable to update email. Try again." |
| Stripe connection fails | "Unable to connect payment. Try again." |
| Account deletion fails | "Unable to delete. Contact support." |

---

## Mobile Considerations

- Settings nav becomes horizontal tabs or accordion
- Each section is a separate screen
- Large touch targets for toggles
- Confirmation dialogs for destructive actions

---

## Implementation Notes

- Security-sensitive changes should require password confirmation
- Email change triggers verification email via Resend
- Stripe Connect: Express accounts for STs/Creators (per CD-020)
- Availability stored in user's timezone, converted for display to students
- Webhook `account.updated` is source of truth for Stripe status
