# auth-libraries.md

**Libraries:** jose, bcryptjs, arctic
**Type:** Authentication Stack
**Source:** Technology decision session (2025-12-26)
**Status:** SELECTED (2025-12-26)

---

## Overview

Custom JWT authentication for PeerLoop using three lightweight, edge-compatible libraries:

| Library | Purpose | Why Chosen |
|---------|---------|------------|
| **jose** | JWT creation/verification | Works on Cloudflare Workers (edge) |
| **bcryptjs** | Password hashing | Pure JS, no native dependencies |
| **arctic** | OAuth providers | Lightweight, edge-compatible |

---

## Why Custom JWT over Auth Services

### Decision Context

Evaluated against: **Supabase Auth** and **Clerk**

| Criterion | Custom JWT | Supabase Auth | Clerk |
|-----------|------------|---------------|-------|
| Cloudflare Workers | Native | Via HTTP | Known issues |
| External dependency | None | Supabase | Clerk |
| Cost at scale | $0 | $25/mo+ | Per-MAU |
| Full control | Yes | Limited | Limited |
| Dev time | 16h | 8h | 4h |
| Vendor lock-in | None | Medium | High |

### Why Custom JWT Won

1. **Native Cloudflare Workers Support** - No HTTP calls to external auth service
2. **No Vendor Lock-in** - Full control over auth logic
3. **No Per-User Costs** - Unlike Clerk's per-MAU pricing
4. **D1 Integration** - Users stored in same database as other data
5. **16h Budgeted** - Block 0 already allocates time for auth

### Clerk's Cloudflare Issue

Clerk has [known issues](https://community.cloudflare.com/t/issue-with-clerk-astro-and-node-async-hooks-on-cloudflare-pages-local-works/792904) with Astro on Cloudflare Pages (`node:async_hooks` error). Custom JWT avoids this entirely.

---

## Library: jose

**Purpose:** JWT creation and verification
**Website:** https://github.com/panva/jose
**Why:** Works in all JavaScript runtimes including Cloudflare Workers

### Installation

```bash
npm install jose
```

### JWT Creation

```typescript
// src/lib/auth/jwt.ts
import { SignJWT, jwtVerify } from 'jose';

const JWT_SECRET = new TextEncoder().encode(process.env.JWT_SECRET);
const JWT_ISSUER = 'peerloop';
const JWT_AUDIENCE = 'peerloop-users';

interface JWTPayload {
  sub: string;       // user ID
  email: string;
  roles: string[];   // ['student', 'teacher', etc.]
}

export async function createToken(payload: JWTPayload): Promise<string> {
  return new SignJWT(payload)
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setIssuer(JWT_ISSUER)
    .setAudience(JWT_AUDIENCE)
    .setExpirationTime('7d')
    .sign(JWT_SECRET);
}

export async function verifyToken(token: string): Promise<JWTPayload | null> {
  try {
    const { payload } = await jwtVerify(token, JWT_SECRET, {
      issuer: JWT_ISSUER,
      audience: JWT_AUDIENCE,
    });
    return payload as JWTPayload;
  } catch {
    return null;
  }
}
```

### Refresh Token Pattern

```typescript
// Access token: short-lived (15 min)
export async function createAccessToken(payload: JWTPayload): Promise<string> {
  return new SignJWT(payload)
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('15m')
    .sign(JWT_SECRET);
}

// Refresh token: long-lived (7 days), stored in httpOnly cookie
export async function createRefreshToken(userId: string): Promise<string> {
  return new SignJWT({ sub: userId, type: 'refresh' })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('7d')
    .sign(JWT_SECRET);
}
```

---

## Library: bcryptjs

**Purpose:** Password hashing
**Website:** https://github.com/dcodeIO/bcrypt.js
**Why:** Pure JavaScript, no native dependencies, works everywhere

### Installation

```bash
npm install bcryptjs
npm install -D @types/bcryptjs
```

### Password Hashing

```typescript
// src/lib/auth/password.ts
import bcrypt from 'bcryptjs';

const SALT_ROUNDS = 12;

export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

export async function verifyPassword(
  password: string,
  hash: string
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}
```

### Usage in Registration

```typescript
// POST /api/auth/register
export async function POST({ request, env }) {
  const { email, password, name } = await request.json();

  // Validate
  if (password.length < 8) {
    return Response.json({ error: 'Password too short' }, { status: 400 });
  }

  // Check if email exists
  const existing = await env.DB.prepare(
    'SELECT id FROM users WHERE email = ?'
  ).bind(email).first();

  if (existing) {
    return Response.json({ error: 'Email already registered' }, { status: 409 });
  }

  // Hash password
  const passwordHash = await hashPassword(password);

  // Create user
  const userId = crypto.randomUUID();
  await env.DB.prepare(`
    INSERT INTO users (id, email, password_hash, name, role)
    VALUES (?, ?, ?, ?, 'student')
  `).bind(userId, email, passwordHash, name).run();

  // Create tokens
  const accessToken = await createAccessToken({ sub: userId, email, roles: ['student'] });
  const refreshToken = await createRefreshToken(userId);

  return Response.json(
    { user: { id: userId, email, name }, accessToken },
    {
      headers: {
        'Set-Cookie': `refresh_token=${refreshToken}; HttpOnly; Secure; SameSite=Strict; Max-Age=604800`,
      },
    }
  );
}
```

---

## Library: arctic

**Purpose:** OAuth 2.0 providers (Google, GitHub)
**Website:** https://arctic.js.org/
**Why:** Lightweight, edge-compatible, no bloated dependencies

### Installation

```bash
npm install arctic
```

### Provider Setup

```typescript
// src/lib/auth/oauth.ts
import { Google, GitHub } from 'arctic';

export const google = new Google(
  process.env.GOOGLE_CLIENT_ID!,
  process.env.GOOGLE_CLIENT_SECRET!,
  process.env.GOOGLE_REDIRECT_URI!
);

export const github = new GitHub(
  process.env.GITHUB_CLIENT_ID!,
  process.env.GITHUB_CLIENT_SECRET!,
  process.env.GITHUB_REDIRECT_URI!
);
```

### Google OAuth Flow

```typescript
// GET /api/auth/google
export async function GET() {
  const state = crypto.randomUUID();
  const codeVerifier = crypto.randomUUID();

  const url = google.createAuthorizationURL(state, codeVerifier, {
    scopes: ['openid', 'email', 'profile'],
  });

  return new Response(null, {
    status: 302,
    headers: {
      Location: url.toString(),
      'Set-Cookie': `oauth_state=${state}; HttpOnly; Secure; Max-Age=600`,
    },
  });
}

// GET /api/auth/google/callback
export async function GET({ request, env }) {
  const url = new URL(request.url);
  const code = url.searchParams.get('code');
  const state = url.searchParams.get('state');

  // Validate state (from cookie)
  // ...

  // Exchange code for tokens
  const tokens = await google.validateAuthorizationCode(code, codeVerifier);

  // Get user info
  const response = await fetch('https://openidconnect.googleapis.com/v1/userinfo', {
    headers: { Authorization: `Bearer ${tokens.accessToken()}` },
  });
  const googleUser = await response.json();

  // Find or create user
  let user = await env.DB.prepare(
    'SELECT * FROM users WHERE email = ?'
  ).bind(googleUser.email).first();

  if (!user) {
    const userId = crypto.randomUUID();
    await env.DB.prepare(`
      INSERT INTO users (id, email, name, avatar_url, email_verified, role)
      VALUES (?, ?, ?, ?, true, 'student')
    `).bind(userId, googleUser.email, googleUser.name, googleUser.picture).run();

    user = { id: userId, email: googleUser.email, name: googleUser.name };
  }

  // Create tokens and redirect
  const accessToken = await createAccessToken({
    sub: user.id,
    email: user.email,
    roles: [user.role],
  });

  return Response.redirect('/dashboard', {
    headers: {
      'Set-Cookie': `access_token=${accessToken}; HttpOnly; Secure; Max-Age=900`,
    },
  });
}
```

### GitHub OAuth Flow

```typescript
// GET /api/auth/github
export async function GET() {
  const state = crypto.randomUUID();
  const url = github.createAuthorizationURL(state, {
    scopes: ['user:email'],
  });

  return new Response(null, {
    status: 302,
    headers: {
      Location: url.toString(),
      'Set-Cookie': `oauth_state=${state}; HttpOnly; Secure; Max-Age=600`,
    },
  });
}

// GET /api/auth/github/callback
// Similar to Google, but GitHub user info endpoint differs
```

---

## Complete Auth Flow

### Database Schema

```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT,  -- NULL for OAuth-only users
  name TEXT NOT NULL,
  handle TEXT UNIQUE,
  avatar_url TEXT,
  role TEXT NOT NULL DEFAULT 'student',
  is_creator BOOLEAN DEFAULT FALSE,
  is_teacher BOOLEAN DEFAULT FALSE,
  is_admin BOOLEAN DEFAULT FALSE,
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE oauth_accounts (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  provider TEXT NOT NULL,  -- 'google', 'github'
  provider_user_id TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(provider, provider_user_id)
);

CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  refresh_token_hash TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

### Auth Middleware

```typescript
// src/middleware/auth.ts
import { verifyToken } from '../lib/auth/jwt';

export async function authMiddleware(request: Request) {
  const authHeader = request.headers.get('Authorization');
  if (!authHeader?.startsWith('Bearer ')) {
    return null;
  }

  const token = authHeader.slice(7);
  const payload = await verifyToken(token);

  if (!payload) {
    return null;
  }

  return {
    userId: payload.sub,
    email: payload.email,
    roles: payload.roles,
  };
}

// Usage in API route
export async function GET({ request }) {
  const user = await authMiddleware(request);
  if (!user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  // User is authenticated
}
```

### Protected Route (Astro)

```typescript
// src/pages/dashboard.astro
---
import { verifyToken } from '../lib/auth/jwt';

const token = Astro.cookies.get('access_token')?.value;
if (!token) {
  return Astro.redirect('/login');
}

const user = await verifyToken(token);
if (!user) {
  return Astro.redirect('/login');
}
---

<h1>Welcome, {user.email}</h1>
```

---

## Security Considerations

### Token Storage
- **Access token:** HttpOnly cookie (15 min expiry)
- **Refresh token:** HttpOnly cookie (7 day expiry)
- Never store tokens in localStorage

### CSRF Protection
- Use SameSite=Strict cookies
- Validate Origin header on mutations

### Rate Limiting
- Implement in Cloudflare Workers
- Limit login attempts per IP

### Password Requirements
- Minimum 8 characters
- Consider HaveIBeenPwned check (via API)

---

## Comparison: Custom JWT vs Clerk vs Supabase Auth

| Aspect | Custom JWT | Clerk | Supabase Auth |
|--------|------------|-------|---------------|
| Edge runtime | Native | Issues | Via HTTP |
| Pre-built UI | None | Yes | Yes |
| OAuth setup | Manual | Automatic | Automatic |
| User management | Build yourself | Included | Included |
| Cost | $0 | Per-MAU | $25/mo+ |
| Setup time | 16h | 4h | 8h |
| Vendor lock-in | None | High | Medium |
| Data location | Your D1 | Their servers | Their servers |

**Decision:** Custom JWT gives us full control, native edge support, and no vendor dependencies. The 16h investment pays off in flexibility and cost savings.

---

## User Stories Covered

| Story | Implementation |
|-------|----------------|
| US-P007 | Email/password registration |
| US-P008 | Email/password login |
| US-P009 | Google OAuth login |
| US-P010 | GitHub OAuth login |
| US-P013 | Email verification |
| US-P014 | Password reset |
| US-P015 | Session management |

---

## References

### jose
- [GitHub](https://github.com/panva/jose)
- [Documentation](https://github.com/panva/jose#readme)

### bcryptjs
- [GitHub](https://github.com/dcodeIO/bcrypt.js)
- [npm](https://www.npmjs.com/package/bcryptjs)

### arctic
- [Website](https://arctic.js.org/)
- [GitHub](https://github.com/pilcrowonpaper/arctic)
- [Google Provider](https://arctic.js.org/providers/google)
- [GitHub Provider](https://arctic.js.org/providers/github)

### Comparisons
- [Clerk vs Supabase Auth](https://clerk.com/articles/clerk-vs-supabase-auth)
- [Auth Provider Comparison](https://blog.hyperknot.com/p/comparing-auth-providers)
- [Clerk Cloudflare Issues](https://community.cloudflare.com/t/issue-with-clerk-astro-and-node-async-hooks-on-cloudflare-pages-local-works/792904)

### Related Tech Docs
- `docs/vendors/google-oauth.md` - OAuth provider setup instructions (Google + GitHub app registration, Cloudflare secrets)
