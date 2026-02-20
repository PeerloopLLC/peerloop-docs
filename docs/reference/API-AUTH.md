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
  "name": "John Doe",
  "handle": "johndoe"
}
```

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
| 400 | Invalid email/password/handle/name |
| 409 | Email or handle already exists |
| 500 | Database/server error |

**Validation:**
- Email: Valid format, lowercase stored
- Password: Min 8 chars, uppercase, lowercase, number
- Handle: 3-30 chars, alphanumeric + underscore, lowercase stored
- Name: Min 2 characters

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
- Sets `auth_token` HttpOnly cookie (JWT)
- Sets `session` cookie (session metadata)

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
- Clears `auth_token` cookie
- Clears `session` cookie

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

**Response:** 302 redirect to `/` on success, `/auth/login?error=...` on failure

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

**Response:** 302 redirect to `/` on success, `/auth/login?error=...` on failure
