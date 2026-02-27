# LGIN - Login

| Field | Value |
|-------|-------|
| Route | `/login` |
| Access | Public (redirects if logged in) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 0 |
| Astro Page | `src/pages/login.astro` |
| Component | `src/components/auth/LoginForm.tsx` |
| JSON Spec | `src/data/pages/login.json` |

---

## Purpose

Authenticate returning users and provide access to their account.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G012 | As a user, I want to return to the platform and log in so that I can access my account | P0 | ✅ |
| US-P008 | As a user, I want to authenticate with email/password so that I can securely access my account | P0 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | "Log In" nav link | Header navigation |
| SGUP | "Already have an account? Log in" | From signup page |
| CDET | "Log in to enroll" | Enrollment attempt while logged out |
| SBOK | "Log in to book" | Booking attempt while logged out |
| Any protected page | Redirect | Attempting to access auth-required page |
| PWRS | "Back to login" | After password reset |
| (External) | Direct URL | `/login` |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SDSH | Successful login (Student) | Default post-login for students | ✅ |
| TDSH | Successful login (ST) | Default post-login for STs | ✅ |
| CDSH | Successful login (Creator) | Default post-login for creators | ✅ |
| ADMN | Successful login (Admin) | Default post-login for admins | ✅ |
| (Return URL) | Successful login | If redirected from another page | ✅ |
| SGUP | "Create an account" link | New user registration | ✅ |
| PWRS | "Forgot password?" link | Password recovery | ✅ |
| HOME | Logo click | Return to home | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | email, password_hash, role, is_creator, is_student_teacher, is_admin | Authentication |

---

## Features

### Login Form
- [x] Email input with validation `[US-G012]`
- [x] Password input `[US-P008]`
- [ ] Password show/hide toggle `[US-P008]` *(not implemented)*
- [x] Submit button with loading state `[US-P008]`
- [x] Validation errors (inline) `[US-P008]`

### Navigation & Links
- [x] Forgot password link → PWRS `[US-G012]`
- [x] Sign up link → SGUP `[US-G012]`
- [x] Redirect after login (role-based) `[US-G012]`

### OAuth
- [x] Google OAuth `[US-P008]`
- [x] GitHub OAuth `[US-P008]`

### Security
- [ ] Remember me checkbox `[US-P008]`
- [ ] Rate limiting (5 per minute per IP) `[US-P008]`

---

## Sections

### Header
- Logo (links to HOME)
- Minimal navigation (or none)

### Login Form
- **Email input**
  - Label: "Email"
  - Type: email
  - Validation: email format
  - Error: "Please enter a valid email"
- **Password input**
  - Label: "Password"
  - Type: password
  - Show/hide toggle
  - Error: "Password is required"
- **Remember me checkbox** (optional)
- **Submit button:** "Log In"

### Forgot Password Link
- "Forgot your password?" → PWRS
- Positioned below password field

### Create Account Link
- "Don't have an account? Sign up" → SGUP
- Positioned below form

### Social Login
- "Or continue with..."
- Google OAuth button
- GitHub OAuth button

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/auth/login` | POST | Authenticate user | ✅ |
| `/api/users/me` | GET | Get user profile/roles | ✅ |

**Login Request:**
```typescript
POST /api/auth/login
{
  email: string,
  password: string,
  remember_me?: boolean
}
```

**Login Response:**
```typescript
{
  success: true,
  user: { id, name, email, role, roles: [] },
  redirect_url: '/dashboard'  // Based on role
}
// Sets httpOnly session cookie
```

**Error Responses:**
- 401: Invalid credentials
- 429: Rate limited (too many attempts)
- 423: Account locked

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Default | Empty form, ready for input | ✅ |
| With Return URL | "Log in to continue" message, redirects after success | ✅ |
| Error (Invalid Credentials) | "Invalid email or password" message | ✅ |
| Error (Account Locked) | "Account locked. Contact support." | ⏳ |
| Loading | Submit button shows spinner | ✅ |
| Already Logged In | Redirect to appropriate dashboard | ✅ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Invalid credentials | "Invalid email or password. Please try again." |
| Account not found | Same message (security: don't reveal existence) |
| Account locked | "Your account has been locked. Please contact support." |
| Too many attempts | "Too many login attempts. Please try again in X minutes." |
| Network error | "Unable to connect. Please check your connection." |

---

## Mobile Considerations

- Full-width form
- Large touch targets for inputs
- Keyboard-appropriate input types
- Auto-focus on email field

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | has_return_url |
| `login_attempt` | Form submitted | - |
| `login_success` | Login succeeded | user_role |
| `login_failure` | Login failed | error_type |
| `forgot_password_click` | Forgot link clicked | - |
| `signup_link_click` | Signup link clicked | - |

---

## Implementation Notes

- OAuth uses Arctic library for provider integration
- JWT tokens stored in HTTP-only cookies
- Redirect destination preserved in query param
- Security: Rate limit login attempts (5 per minute per IP)
- Security: Use secure, httpOnly cookies
- Consider "Stay logged in" duration options
- Accessibility: Form labels, error announcements

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Sign in button | LoginForm | POST /api/auth/login, redirect on success | ✅ Active |

### Form Inputs

| Element | Type | Validation | Status |
|---------|------|------------|--------|
| Email input | email | Required, email format | ✅ Active |
| Password input | password | Required | ✅ Active |

### Links - OAuth

| Element | Target | Status |
|---------|--------|--------|
| "Continue with Google" | /api/auth/google | ✅ Active |
| "Continue with GitHub" | /api/auth/github | ✅ Active |

### Links - Navigation

| Element | Target | Status |
|---------|--------|--------|
| "Forgot password?" | /reset-password | ✅ Active |
| "Create one now" | /signup | ✅ Active |
| Logo (header) | / | ✅ Active |

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Form submit | `/api/auth/login` | POST | ✅ Active |
| Google OAuth click | `/api/auth/google` | GET | ✅ Active |
| GitHub OAuth click | `/api/auth/github` | GET | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| / | HOME | ✅ Yes |
| /signup | SGUP | ✅ Yes |
| /reset-password | PWRS | ✅ Yes |
| /admin | ADMN | 📋 PageSpecView |
| /dashboard/creator | CDSH | 📋 PageSpecView |
| /dashboard/teaching | TDSH | 📋 PageSpecView |
| /dashboard/learning | SDSH | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 4 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Password show/hide toggle | Planned | Not implemented | ❌ Missing |
| Remember me checkbox | Planned | Not implemented | ⏳ Deferred |
| Rate limiting | Planned | Not implemented | ⏳ Deferred |
| Analytics events | 6 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| LoginForm | `src/components/auth/LoginForm.tsx` | ✅ No TODOs |
| login.astro | `src/pages/login.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 1 | 1 | 0 |
| Form Inputs | 2 | 2 | 0 |
| OAuth Links | 2 | 2 | 0 |
| Navigation Links | 3 | 3 | 0 |
| API Endpoints | 3 | 3 | 0 |
| Analytics Events | 6 | 0 | 6 |

**Notes:**
- All core login functionality working
- OAuth buttons link to API endpoints (redirect flow)
- Password field has no show/hide toggle
- Role-based redirect after login works correctly
- Return URL preserved via query parameter

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `LGIN-2026-01-07-06-11-32.png` | 2026-01-07 | Login form with OAuth buttons |
