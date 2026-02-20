# Page: Login

**Code:** LGIN
**URL:** `/login`
**Access:** Public (redirects if logged in)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Authenticate returning users and provide access to their account.

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

| Target | Trigger | Notes |
|--------|---------|-------|
| SDSH | Successful login (Student) | Default post-login for students |
| TDSH | Successful login (ST) | Default post-login for STs |
| CDSH | Successful login (Creator) | Default post-login for creators |
| ADMN | Successful login (Admin) | Default post-login for admins |
| (Return URL) | Successful login | If redirected from another page |
| SGUP | "Create an account" link | New user registration |
| PWRS | "Forgot password?" link | Password recovery |
| HOME | Logo click | Return to home |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | email, password_hash, role, is_creator, is_student_teacher, is_admin | Authentication |

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

### Social Login (Future)
- "Or continue with..."
- Google, GitHub, etc.
- Placeholder for MVP

---

## User Stories Fulfilled

- US-G012: Return to platform and log in
- US-P008: Authenticate with email/password

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Empty form, ready for input |
| With Return URL | "Log in to continue" message, redirects after success |
| Error (Invalid Credentials) | "Invalid email or password" message |
| Error (Account Locked) | "Account locked. Contact support." |
| Loading | Submit button shows spinner |
| Already Logged In | Redirect to appropriate dashboard |

---

## Mobile Considerations

- Full-width form
- Large touch targets for inputs
- Keyboard-appropriate input types
- Auto-focus on email field

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

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `POST /api/auth/login` | Form submitted | Authenticate user |
| `GET /api/users/me` | After login success | Get user profile/roles |

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

## Notes

- Security: Rate limit login attempts (5 per minute per IP)
- Security: Use secure, httpOnly cookies
- Consider "Stay logged in" duration options
- Future: Add SSO/social login (Google, GitHub)
- Accessibility: Form labels, error announcements
