# SGUP - Sign Up

| Field | Value |
|-------|-------|
| Route | `/signup` |
| Access | Public (redirects if logged in) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 0 |
| Astro Page | `src/pages/signup.astro` |
| Component | `src/components/auth/SignupForm.tsx` |
| JSON Spec | `src/data/pages/signup.json` |

---

## Purpose

Register new users to the platform, collecting essential information and creating their account.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G011 | As a visitor, I want to register for a new account so that I can use the platform | P0 | ✅ |
| US-P007 | As a user, I want to create an account with email/password so that I have my own credentials | P0 | ✅ |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SDSH | Successful signup (as Student) | Onboarding may intercept | ✅ |
| CDSH | Successful signup (as Creator) | Onboarding may intercept | ✅ |
| (Return URL) | Successful signup | If came from specific page | ✅ |
| LGIN | "Already have an account? Log in" | Existing user | ✅ |
| HOME | Logo click | Return to home | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | name, email, password_hash, role, email_verified, created_at | Account creation |

---

## Features

### Registration Form
- [x] Name input with validation `[US-G011]`
- [x] Email input with validation `[US-P007]`
- [x] Username/handle input with auto-generation `[US-G011]`
- [x] Password input `[US-P007]`
- [x] Confirm password input `[US-P007]`
- [ ] Password show/hide toggle `[US-P007]` *(not implemented)*
- [x] Submit button with loading state `[US-P007]`
- [x] Validation errors (inline) `[US-P007]`
- [x] Terms/Privacy links (passive, not checkbox) `[US-G011]`

### OAuth
- [x] Google OAuth `[US-P007]`
- [x] GitHub OAuth `[US-P007]`

### Navigation & Links
- [x] Login link → LGIN `[US-G011]`

### Pending Features
- [ ] Role selection (Student/Creator) `[US-G011]`
- [ ] Terms checkbox with links `[US-G011]`
- [ ] Password strength indicator `[US-P007]`
- [ ] Email verification flow `[US-P007]`

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
- **Confirm Password** (optional)
- **Role selection** (optional)
  - "I want to learn" (Student - default)
  - "I want to create courses" (Creator)
- **Terms checkbox**
  - "I agree to the Terms of Service and Privacy Policy"
  - Links open in new tab
- **Submit button:** "Create Account"

### Already Have Account Link
- "Already have an account? Log in" → LGIN
- Below form

### Social Signup
- "Or sign up with..."
- Google OAuth button
- GitHub OAuth button

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/auth/signup` | POST | Create account | ✅ |
| `/api/auth/resend-verification` | POST | Resend verification email | ⏳ Block 9 |
| `/api/auth/verify-email` | POST | Confirm email | ⏳ Block 9 |

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

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Default | Empty form | ✅ |
| With Return URL | "Sign up to continue" message | ✅ |
| With Prefill | Email prefilled from marketing/invite | ⏳ |
| Validation Errors | Inline errors per field | ✅ |
| Email Exists | "Email already registered. Log in instead?" | ✅ |
| Loading | Submit shows spinner | ✅ |
| Success | Redirect to dashboard or onboarding | ✅ |
| Already Logged In | Redirect to dashboard | ✅ |

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

## Mobile Considerations

- Full-width form
- Large touch targets
- Appropriate keyboard types
- Terms link opens modal or new tab (not navigate away)

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

## Implementation Notes

- Password hashed with bcryptjs
- Email verification deferred to Block 9
- **Invitation-only launch (GO-025):** May require invite code field for Genesis Cohort
- Consider progressive profiling: minimal signup, more info later
- Email verification required before full access (US-P013)
- Security: Password strength indicator
- GDPR: Clear consent for terms/privacy
- Resend handles email delivery, bounces, complaints
- Verification token expires in 24 hours

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Create account button | SignupForm | Validates form, POST /api/auth/register, redirect on success | ✅ Active |

### Form Inputs

| Element | Type | Validation | Status |
|---------|------|------------|--------|
| Full name | text | Required, min 2 chars | ✅ Active |
| Email address | email | Required, email format | ✅ Active |
| Username | text | Required, 3-20 chars, lowercase/numbers/underscore | ✅ Active |
| Password | password | Required, min 8 chars | ✅ Active |
| Confirm password | password | Required, must match password | ✅ Active |

### Links - OAuth

| Element | Target | Status |
|---------|--------|--------|
| "Continue with Google" | /api/auth/google | ✅ Active |
| "Continue with GitHub" | /api/auth/github | ✅ Active |

### Links - Navigation

| Element | Target | Status |
|---------|--------|--------|
| "Sign in" | /login | ✅ Active |
| "Terms of Service" | /terms | ✅ Active |
| "Privacy Policy" | /privacy | ✅ Active |
| Logo (header) | / | ✅ Active |

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Form submit | `/api/auth/register` | POST | ✅ Active |
| Google OAuth click | `/api/auth/google` | GET | ✅ Active |
| GitHub OAuth click | `/api/auth/github` | GET | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| / | HOME | ✅ Yes |
| /login | LGIN | ✅ Yes |
| /terms | TERM | 📋 PageSpecView |
| /privacy | PRIV | 📋 PageSpecView |
| /dashboard/learning | SDSH | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 8 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Password show/hide toggle | Planned | Not implemented | ❌ Missing |
| Role selection | Planned | Not implemented | ⏳ Deferred |
| Terms checkbox | Planned | Passive text with links | ⚠️ Different |
| Password strength indicator | Planned | Not implemented | ⏳ Deferred |
| Email verification flow | Planned | Deferred to Block 9 | ⏳ Deferred |
| Username/handle field | Not in original spec | ✅ Implemented | ℹ️ Added |
| Confirm password | Listed as optional | ✅ Required | ℹ️ Enhanced |
| Analytics events | 6 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| SignupForm | `src/components/auth/SignupForm.tsx` | ✅ No TODOs |
| signup.astro | `src/pages/signup.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 1 | 1 | 0 |
| Form Inputs | 5 | 5 | 0 |
| OAuth Links | 2 | 2 | 0 |
| Navigation Links | 4 | 4 | 0 |
| API Endpoints | 3 | 3 | 0 |
| Analytics Events | 6 | 0 | 6 |

**Notes:**
- All core signup functionality working
- Username auto-generates from name (can be customized)
- Helper text shows profile URL preview
- Confirm password required (not optional)
- Terms/Privacy are links, not a checkbox
- No password show/hide toggle

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `SGUP-2026-01-07-06-15-38.png` | 2026-01-07 | Signup form with OAuth and fields |
