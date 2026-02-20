# Page: Sign Up

**Code:** SGUP
**URL:** `/signup`
**Access:** Public (redirects if logged in)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Register new users to the platform, collecting essential information and creating their account.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | "Get Started" / "Sign Up" CTA | Primary conversion |
| LGIN | "Create an account" link | From login page |
| CDET | "Sign up to enroll" | Enrollment prompt |
| SBOK | "Sign up to book" | Booking prompt |
| CPRO | "Follow" while logged out | To follow creator |
| (External) | Direct URL, marketing | `/signup` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SDSH | Successful signup (as Student) | Onboarding may intercept |
| CDSH | Successful signup (as Creator) | Onboarding may intercept |
| (Return URL) | Successful signup | If came from specific page |
| LGIN | "Already have an account? Log in" | Existing user |
| HOME | Logo click | Return to home |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | name, email, password_hash, role, email_verified, created_at | Account creation |

---

## Sections

### Header
- Logo (links to HOME)
- Minimal navigation

### Signup Form
- **Name input**
  - Label: "Full Name"
  - Validation: required, min 2 characters
  - Error: "Please enter your name"
- **Email input**
  - Label: "Email"
  - Type: email
  - Validation: email format, unique check
  - Error: "Please enter a valid email" / "Email already registered"
- **Password input**
  - Label: "Password"
  - Type: password
  - Show/hide toggle
  - Requirements indicator: min 8 chars, etc.
  - Error: "Password must be at least 8 characters"
- **Confirm Password** (optional, or match on submit)
- **Role selection** (optional for MVP)
  - "I want to learn" (Student - default)
  - "I want to create courses" (Creator)
- **Terms checkbox**
  - "I agree to the Terms of Service and Privacy Policy"
  - Links open in new tab
  - Required
- **Submit button:** "Create Account"

### Already Have Account Link
- "Already have an account? Log in" → LGIN
- Below form

### Social Signup (Future)
- "Or sign up with..."
- Google, GitHub
- Placeholder for MVP

---

## User Stories Fulfilled

- US-G011: Register for new account
- US-P007: Create account with email/password

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Empty form |
| With Return URL | "Sign up to continue" message |
| With Prefill | Email prefilled from marketing/invite |
| Validation Errors | Inline errors per field |
| Email Exists | "Email already registered. Log in instead?" |
| Loading | Submit shows spinner |
| Success | Redirect to dashboard or onboarding |
| Already Logged In | Redirect to dashboard |

---

## Mobile Considerations

- Full-width form
- Large touch targets
- Appropriate keyboard types
- Terms link opens modal or new tab (not navigate away)

---

## Error Handling

| Error | Display |
|-------|---------|
| Email exists | "This email is already registered. [Log in instead?]" |
| Weak password | "Password must be at least 8 characters" |
| Terms not accepted | "Please accept the terms to continue" |
| Network error | "Unable to create account. Please try again." |
| Server error | "Something went wrong. Please try again later." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | source, return_url |
| `signup_attempt` | Form submitted | role_selected |
| `signup_success` | Account created | user_id, role |
| `signup_failure` | Signup failed | error_type |
| `login_link_click` | Log in link clicked | - |
| `terms_view` | Terms link clicked | which_link |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `POST /api/auth/signup` | Form submitted | Create account |
| `POST /api/auth/resend-verification` | "Resend" clicked | Resend verification email |
| `POST /api/auth/verify-email` | Verification link clicked | Confirm email |

### Signup Flow (Resend Email Verification)

```
Form Submitted:
  1. POST /api/auth/signup {
       name: string,
       email: string,
       password: string,
       role: 'student' | 'creator'
     }
  2. Backend:
     - Validate email not taken
     - Hash password (bcrypt)
     - Create user record (email_verified = false)
     - Generate verification token
     - Send verification email via Resend
  3. Response: { success: true, message: "Check your email" }
  4. Client shows confirmation screen
```

### Resend Email Integration

```typescript
// Backend sends verification email:
import { Resend } from 'resend';
import { VerificationEmail } from '@/emails/verification';

const resend = new Resend(process.env.RESEND_API_KEY);

await resend.emails.send({
  from: 'PeerLoop <noreply@peerloop.com>',
  to: user.email,
  subject: 'Verify your PeerLoop account',
  react: VerificationEmail({
    name: user.name,
    verificationUrl: `${origin}/verify-email?token=${token}`
  })
});
```

### Email Verification Flow

```
User Clicks Verification Link:
  1. GET /verify-email?token=xxx
  2. POST /api/auth/verify-email { token }
  3. Backend:
     - Validate token (not expired, not used)
     - UPDATE users SET email_verified = true
     - Mark token as used
     - Auto-login user (set session)
  4. Redirect to dashboard (SDSH/CDSH)
```

### React Email Template

```typescript
// emails/verification.tsx
export function VerificationEmail({ name, verificationUrl }) {
  return (
    <Html>
      <Body>
        <Text>Hi {name},</Text>
        <Text>Welcome to PeerLoop! Click below to verify your email:</Text>
        <Button href={verificationUrl}>
          Verify Email
        </Button>
        <Text>This link expires in 24 hours.</Text>
      </Body>
    </Html>
  );
}
```

### Resend Webhook (Optional)

```typescript
// Handle email delivery issues:
POST /api/webhooks/resend

Events:
- email.bounced → Mark user.email_status = 'bounced'
- email.complained → Mark user.email_status = 'complained'
- email.failed → Log for retry
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   SGUP      │      │  PeerLoop   │      │   Resend    │
│   (Client)  │      │  (Server)   │      │   (Email)   │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ POST /auth/signup  │                    │
       │───────────────────>│                    │
       │                    │ Create user        │
       │                    │ Generate token     │
       │                    │                    │
       │                    │ Send verification  │
       │                    │───────────────────>│
       │                    │                    │
       │ { success }        │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ Show "Check email" │                    │
       │                    │                    │
       │                    │                    │ Email delivered
       │                    │                    │ to user inbox
       │                    │                    │
       │ (user clicks link) │                    │
       │                    │                    │
       │ POST /auth/        │                    │
       │   verify-email     │                    │
       │───────────────────>│                    │
       │                    │ Verify token       │
       │                    │ Mark verified      │
       │ { redirect }       │                    │
       │<───────────────────│                    │
```

---

## Notes

- **Invitation-only launch (GO-025):** May require invite code field for Genesis Cohort
- Consider progressive profiling: minimal signup, more info later
- Email verification required before full access (US-P013)
- Security: Password strength indicator
- GDPR: Clear consent for terms/privacy
- Resend handles email delivery, bounces, complaints
- Verification token expires in 24 hours
