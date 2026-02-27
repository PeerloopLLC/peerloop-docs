# PWRS - Password Reset

| Field | Value |
|-------|-------|
| Route | `/reset-password` (also `/reset-password/:token`) |
| Access | Public |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 0 |
| Astro Page | `src/pages/reset-password.astro` |
| Component | `src/components/auth/PasswordResetForm.tsx` |
| JSON Spec | `src/data/pages/reset-password.json` |

---

## Purpose

Allow users to recover access to their account by resetting their password via email.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G013 | As a user, I want to reset my forgotten password so that I can regain access | P0 | ⏳ |
| US-P009 | As a user, I want password recovery via email so that I can securely reset credentials | P0 | ⏳ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | "Forgot your password?" link | Primary path |
| (Email) | Reset link in email | Token-based URL |
| (External) | Direct URL | `/reset-password` |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| LGIN | "Back to login" link | Return to login | ✅ |
| LGIN | After successful reset | Redirect to login | ⏳ |
| HOME | Logo click | Return to home | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | email, password_hash | Verification, update |
| password_reset_tokens | token, user_id, expires_at, used_at | Token validation |

---

## Features

### Request Reset
- [x] Email input form `[US-G013]`
- [x] Submit button with loading state `[US-G013]`
- [x] Confirmation message after submit `[US-G013]`
- [x] Back to login link `[US-G013]`

### Reset Form (Token URL) - Block 9
- [ ] Token validation `[US-P009]`
- [ ] New password input `[US-P009]`
- [ ] Confirm password input `[US-P009]`
- [ ] Password strength indicator `[US-P009]`
- [ ] Success message and redirect `[US-P009]`

---

## Sections

### Request Reset (Initial State)

#### Header
- Logo
- Page title: "Reset Password"

#### Request Form
- **Email input**
  - Label: "Email"
  - Type: email
  - Placeholder: "Enter your email address"
- **Submit button:** "Send Reset Link"

#### Back to Login Link
- "Remember your password? Log in" → LGIN

### Confirmation (After Request)

- Success message: "Check your email"
- "We've sent a password reset link to [email]. Check your inbox and spam folder."
- "Didn't receive it? [Resend]" link
- "Back to login" → LGIN

### Reset Form (Token URL)

Accessed via `/reset-password/:token`

#### Header
- Logo
- Page title: "Create New Password"

#### Reset Form
- **New Password input**
  - Label: "New Password"
  - Type: password
  - Show/hide toggle
  - Requirements indicator
- **Confirm Password input**
  - Label: "Confirm New Password"
  - Type: password
- **Submit button:** "Reset Password"

### Success (After Reset)

- Success message: "Password updated"
- "Your password has been successfully reset."
- "Log in with your new password" → LGIN
- Auto-redirect after 5 seconds

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/auth/forgot-password` | POST | Send reset email | ⏳ Block 9 |
| `/api/auth/reset-token/:token` | GET | Validate token | ⏳ Block 9 |
| `/api/auth/reset-password` | POST | Update password | ⏳ Block 9 |

### Request Reset Flow (Resend)

```
Email Submitted:
  1. POST /api/auth/forgot-password { email }
  2. Backend:
     - Look up user by email (don't reveal if exists)
     - If exists: generate reset token, store with expiry
     - Send reset email via Resend
     - Always return success (security)
  3. Response: { success: true }
  4. Client shows "Check your email" regardless
```

### Token Validation

```typescript
// GET /api/auth/reset-token/:token
1. Look up token in password_reset_tokens
2. Check: not expired (< 1 hour old)
3. Check: not used (used_at is null)
4. Return: { valid: true } or { valid: false, reason: 'expired'|'invalid' }
```

### Password Reset Flow

```
New Password Submitted:
  1. POST /api/auth/reset-password {
       token: string,
       password: string
     }
  2. Backend:
     - Validate token again
     - Hash new password
     - UPDATE users SET password_hash = new_hash
     - Mark token as used
     - Invalidate all existing sessions
     - Send confirmation email (optional)
  3. Response: { success: true }
  4. Client redirects to LGIN
```

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Request | Initial email entry form | ✅ |
| Confirmation | Email sent message | ✅ |
| Reset Form | New password entry (valid token) | ⏳ Block 9 |
| Token Expired | "This link has expired. Request a new one." | ⏳ Block 9 |
| Token Invalid | "Invalid reset link. Request a new one." | ⏳ Block 9 |
| Token Used | "This link has already been used." | ⏳ Block 9 |
| Success | Password updated, redirect to login | ⏳ Block 9 |
| Loading | Button spinner during submit | ✅ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Email not found | "If this email exists, we've sent a reset link." (security) |
| Token expired | "This reset link has expired. [Request a new one]" |
| Token invalid | "Invalid reset link. [Request a new one]" |
| Passwords don't match | "Passwords do not match" |
| Weak password | "Password must be at least 8 characters" |
| Network error | "Unable to process. Please try again." |

---

## Mobile Considerations

- Simple, single-column forms
- Large input fields
- Clear success/error messaging

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | state (request/reset) |
| `reset_request` | Email submitted | - |
| `reset_request_success` | Email sent | - |
| `reset_form_view` | Token page loaded | token_valid |
| `password_reset` | New password submitted | - |
| `password_reset_success` | Password updated | - |
| `password_reset_failure` | Reset failed | error_type |

---

## Implementation Notes

- Full flow requires email integration (Block 9)
- Currently shows confirmation but doesn't send email
- **Security:** Token expires in 1 hour
- **Security:** Token is single-use (marked used after reset)
- **Security:** Generic response (don't reveal if email exists)
- **Security:** Invalidate all sessions after password reset
- Rate limit reset requests (3 per hour per IP)
- Resend handles email delivery
- Consider CAPTCHA for request form (anti-abuse)

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Send reset instructions | PasswordResetForm | POST /api/auth/reset-password, show success state | ✅ Active |
| "try again" button | PasswordResetForm (success state) | Resets form to initial state | ✅ Active |
| "Back to login" button | PasswordResetForm (success state) | Navigate to /login | ✅ Active |

### Form Inputs

| Element | Type | Validation | Status |
|---------|------|------------|--------|
| Email address | email | Required, email format | ✅ Active |

### Links - Navigation

| Element | Target | Status |
|---------|--------|--------|
| "Back to login" | /login | ✅ Active |
| Logo (header) | / | ✅ Active |

### Links - Header (via LandingLayout)

| Element | Target | Status |
|---------|--------|--------|
| Courses | /courses | ✅ Active |
| How It Works | /how-it-works | ✅ Active |
| Pricing | /pricing | ✅ Active |
| For Creators | /for-creators | ✅ Active |

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Form submit | `/api/auth/reset-password` | POST | ✅ Active |

*Note: Spec originally listed `/api/auth/forgot-password` but implementation uses `/api/auth/reset-password`*

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| / | HOME | ✅ Yes |
| /login | LGIN | ✅ Yes |
| /courses | CBRO | ✅ Yes |
| /how-it-works | HIWO | 📋 PageSpecView |
| /pricing | PRIC | 📋 PageSpecView |
| /for-creators | FCRE | 📋 PageSpecView |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 5 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| API endpoint name | `/api/auth/forgot-password` | `/api/auth/reset-password` | ⚠️ Different |
| Resend link in confirmation | Spec says "[Resend]" link | "try again" button (resets form) | ⚠️ Different |
| Token-based reset form | Planned | Not implemented (Block 9) | ⏳ Deferred |
| Analytics events | 7 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| PasswordResetForm | `src/components/auth/PasswordResetForm.tsx` | ✅ No TODOs |
| reset-password.astro | `src/pages/reset-password.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 3 | 3 | 0 |
| Form Inputs | 1 | 1 | 0 |
| Navigation Links | 2 | 2 | 0 |
| Header Links | 4 | 4 | 0 |
| API Endpoints | 1 | 1 | 0 |
| Analytics Events | 7 | 0 | 7 |

**Notes:**
- Request form fully functional
- Shows success state regardless of whether email exists (security)
- Token-based password reset form deferred to Block 9
- "try again" button resets form (doesn't resend)
- Uses LandingLayout with full header/footer

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `PWRS-2026-01-07-06-19-19.png` | 2026-01-07 | Password reset request form |
