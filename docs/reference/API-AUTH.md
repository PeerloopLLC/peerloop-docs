# API Reference: Authentication

Authentication and OAuth endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Authentication Endpoints

### POST /api/auth/register

Create a new user account.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "name": "John Doe"
}
```

Handle is **not accepted** in the request body. The server auto-generates it from the user's name (lowercase, strip non-alphanumeric, max 20 chars). On collision, an incrementing numeric suffix is appended (`johndoe`, `johndoe1`, `johndoe2`, ...). If the name yields no alphanumeric characters, falls back to `user`.

**Response (201):**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "handle": "johndoe",
    "can_take_courses": 1,
    "can_teach_courses": 0,
    "can_create_courses": 0,
    "is_admin": 0,
    "email_verified": false
  },
  "message": "Registration successful"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Invalid email/password/name, password is required (null/missing) |
| 409 | Email already exists |
| 500 | Database/server error |

**Validation:**
- Email: Valid format, lowercase stored
- Password: Required (null guard), min 8 chars, uppercase, lowercase, number
- Name: Min 2 characters

**Side Effects:**
- Auto-joins The Commons community (system community)
- Creates 2 welcome notifications (non-blocking): "Welcome to PeerLoop!" → `/how-it-works`, "Discover Courses" → `/discover/courses`

---

### POST /api/auth/login

Authenticate with email and password.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response (200):**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "handle": "johndoe",
    "avatar_url": null,
    "can_take_courses": 1,
    "can_teach_courses": 0,
    "can_create_courses": 0,
    "can_moderate_courses": 0,
    "is_admin": 0,
    "email_verified": false
  },
  "message": "Login successful"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Email and password required |
| 401 | Invalid email or password |
| 500 | Database/server error |

**Side Effects:**
- Sets `peerloop_access` HttpOnly cookie (JWT access token, 15 min)
- Sets `peerloop_refresh` HttpOnly cookie (JWT refresh token, 7 days)

---

### POST /api/auth/logout

Clear authentication and end session.

**Request:** Empty body

**Response (200):**
```json
{
  "message": "Logged out successfully"
}
```

**Side Effects:**
- Clears `peerloop_access` cookie
- Clears `peerloop_refresh` cookie

---

### GET /api/auth/session

Get current user session.

**Response (200) - Authenticated:**
```json
{
  "authenticated": true,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "handle": "johndoe",
    "avatar_url": null,
    "bio_short": null,
    "can_take_courses": 1,
    "can_teach_courses": 0,
    "can_create_courses": 0,
    "can_moderate_courses": 0,
    "is_admin": 0,
    "email_verified": false
  }
}
```

**Response (200) - Not Authenticated:**
```json
{
  "authenticated": false,
  "user": null
}
```

---

### POST /api/auth/reset-password

Request password reset email.

**Request:**
```json
{
  "email": "user@example.com"
}
```

**Response (200):**
```json
{
  "message": "If an account exists with this email, you will receive reset instructions."
}
```

**Note:** Always returns success to prevent email enumeration. Full implementation deferred to Block 9 (Notifications).

---

## Dev-Only Endpoints

### POST /api/auth/dev-login

**Dev-only:** Authenticate by email without password. Used by PLATO browser walkthroughs to switch between test users. Returns 404 in production builds (`import.meta.env.DEV` gate).

**Request:**
```json
{
  "email": "user@example.com"
}
```

**Response (200):**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "handle": "johndoe"
  },
  "message": "Dev login successful"
}
```

**Errors:**
| Status | Error |
|--------|-------|
| 400 | Email is required |
| 404 | Not found (production) or No user found with email |
| 500 | JWT secret not configured, dev login failed |
| 503 | Database not available |

**Side Effects:**
- Sets `peerloop_access` and `peerloop_refresh` HttpOnly cookies (same as regular login)

**Security:** Gated on `import.meta.env.DEV` — Astro sets this to `false` in production builds, so the endpoint returns a generic 404.

---

## OAuth Endpoints

### GET /api/auth/google

Initiate Google OAuth flow.

**Response:** 302 redirect to Google OAuth consent screen

**Cookies Set:**
- `oauth_state` - CSRF protection (10 min TTL)
- `oauth_verifier` - PKCE code verifier (10 min TTL)

**Required Environment:**
- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`

---

### GET /api/auth/google/callback

Handle Google OAuth callback.

**Query Params:**
- `code` - Authorization code from Google
- `state` - CSRF state token

**Response:** 302 redirect to `/` on success (or `/onboarding` for fresh users with no `onboarding_completed_at`), `/auth/login?error=...` on failure

---

### GET /api/auth/github

Initiate GitHub OAuth flow.

**Response:** 302 redirect to GitHub OAuth consent screen

**Cookies Set:**
- `oauth_state` - CSRF protection (10 min TTL)

**Required Environment:**
- `GITHUB_CLIENT_ID`
- `GITHUB_CLIENT_SECRET`

---

### GET /api/auth/github/callback

Handle GitHub OAuth callback.

**Query Params:**
- `code` - Authorization code from GitHub
- `state` - CSRF state token

**Response:** 302 redirect to `/` on success (or `/onboarding` for fresh users with no `onboarding_completed_at`), `/auth/login?error=...` on failure
