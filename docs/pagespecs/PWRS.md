# Page: Password Reset

**Code:** PWRS
**URL:** `/reset-password` (also `/reset-password/:token` for reset form)
**Access:** Public
**Priority:** P0
**Status:** In Scope

---

## Purpose

Allow users to recover access to their account by resetting their password via email.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | "Forgot your password?" link | Primary path |
| (Email) | Reset link in email | Token-based URL |
| (External) | Direct URL | `/reset-password` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| LGIN | "Back to login" link | Return to login |
| LGIN | After successful reset | Redirect to login |
| HOME | Logo click | Return to home |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | email, password_hash | Verification, update |
| (password_reset_tokens) | token, user_id, expires_at, used_at | Token validation |

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

## User Stories Fulfilled

- US-G013: Reset forgotten password
- US-P009: Password recovery via email

---

## States & Variations

| State | Description |
|-------|-------------|
| Request | Initial email entry form |
| Confirmation | Email sent message |
| Reset Form | New password entry (valid token) |
| Token Expired | "This link has expired. Request a new one." |
| Token Invalid | "Invalid reset link. Request a new one." |
| Token Used | "This link has already been used." |
| Success | Password updated, redirect to login |
| Loading | Button spinner during submit |

---

## Mobile Considerations

- Simple, single-column forms
- Large input fields
- Clear success/error messaging

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

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `POST /api/auth/forgot-password` | Email submitted | Send reset email |
| `GET /api/auth/reset-token/:token` | Token page load | Validate token |
| `POST /api/auth/reset-password` | New password submitted | Update password |

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

### Resend Password Reset Email

```typescript
// Backend sends reset email:
import { Resend } from 'resend';
import { PasswordResetEmail } from '@/emails/password-reset';

const resend = new Resend(process.env.RESEND_API_KEY);

await resend.emails.send({
  from: 'PeerLoop <noreply@peerloop.com>',
  to: user.email,
  subject: 'Reset your PeerLoop password',
  react: PasswordResetEmail({
    name: user.name,
    resetUrl: `${origin}/reset-password/${token}`
  })
});
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

### React Email Template

```typescript
// emails/password-reset.tsx
export function PasswordResetEmail({ name, resetUrl }) {
  return (
    <Html>
      <Body>
        <Text>Hi {name},</Text>
        <Text>Click the button below to reset your password:</Text>
        <Button href={resetUrl}>
          Reset Password
        </Button>
        <Text>This link expires in 1 hour.</Text>
        <Text>If you didn't request this, ignore this email.</Text>
      </Body>
    </Html>
  );
}
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   PWRS      │      │  PeerLoop   │      │   Resend    │
│   (Client)  │      │  (Server)   │      │   (Email)   │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ POST /auth/        │                    │
       │   forgot-password  │                    │
       │───────────────────>│                    │
       │                    │ Generate token     │
       │                    │ Store in DB        │
       │                    │                    │
       │                    │ Send reset email   │
       │                    │───────────────────>│
       │ { success }        │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ Show confirmation  │                    │
       │                    │                    │
       │                    │                    │ Email delivered
       │                    │                    │
       │ (user clicks link: /reset-password/:token)
       │                    │                    │
       │ GET /auth/reset-   │                    │
       │   token/:token     │                    │
       │───────────────────>│                    │
       │ { valid: true }    │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ Show reset form    │                    │
       │                    │                    │
       │ POST /auth/        │                    │
       │   reset-password   │                    │
       │───────────────────>│                    │
       │                    │ Update password    │
       │                    │ Invalidate sessions│
       │ { success }        │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ Redirect to LGIN   │                    │
```

---

## Notes

- **Security:** Token expires in 1 hour
- **Security:** Token is single-use (marked used after reset)
- **Security:** Generic response (don't reveal if email exists)
- **Security:** Invalidate all sessions after password reset
- Rate limit reset requests (3 per hour per IP)
- Resend handles email delivery
- Consider CAPTCHA for request form (anti-abuse)
