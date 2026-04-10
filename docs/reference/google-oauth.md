# google-oauth.md

**Service:** Google OAuth 2.0 (via arctic library)
**Type:** Authentication Provider
**Source:** Session 193 (2026-02-05)
**Status:** CODE COMPLETE — awaiting client setup

---

## Overview

Peerloop uses Google OAuth to let users sign in with their Google account ("Sign in with Google"). The code is fully implemented — what's needed is a **Google Cloud Console app registration** that generates a Client ID and Client Secret for Peerloop.

These credentials identify **Peerloop as an application** to Google. They are NOT personal Google credentials — they are app-level API keys that allow Peerloop to initiate the OAuth flow.

**Library:** [arctic](https://arctic.js.org/) (lightweight, edge-compatible OAuth library)
**Related:** `docs/reference/auth-libraries.md` (auth stack overview)

---

## How It Works

```
User clicks "Sign in with Google"
        │
        ▼
Peerloop redirects to Google login page
(passes Client ID so Google knows which app is asking)
        │
        ▼
User logs in with their Google account
and grants Peerloop access to name/email/photo
        │
        ▼
Google redirects back to Peerloop callback URL
(with a temporary authorization code)
        │
        ▼
Peerloop server exchanges code + Client Secret
for the user's Google profile info
        │
        ▼
Peerloop creates or matches a user account
and issues a JWT session cookie
```

**Key point:** The Client Secret is only used server-side (step 4). It never reaches the browser.

---

## Client Setup Instructions

### Step 1: Access Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Sign in with the Google account that will own the Peerloop project
3. Create a new project (or select existing): **"Peerloop"**

### Step 2: Enable Google OAuth API

1. Navigate to **APIs & Services → Library**
2. Search for **"Google Identity"** or **"Google+ API"**
3. Enable it (if not already enabled)

### Step 3: Configure OAuth Consent Screen

1. Go to **APIs & Services → OAuth consent screen**
2. Choose **External** (allows any Google user to sign in)
3. Fill in required fields:

| Field | Value |
|-------|-------|
| App name | **Peerloop** |
| User support email | (your support email) |
| App logo | (Peerloop logo, optional) |
| App domain | `https://peerloop.com` (or your production domain) |
| Authorized domains | `peerloop.com` |
| Developer contact email | (your email) |

4. Add scopes:
   - `openid`
   - `email`
   - `profile`

5. Save and continue

### Step 4: Create OAuth 2.0 Credentials

1. Go to **APIs & Services → Credentials**
2. Click **+ Create Credentials → OAuth 2.0 Client ID**
3. Application type: **Web application**
4. Name: **"Peerloop Web"**

#### Authorized Redirect URIs

Add callback URLs for each environment:

| Environment | Redirect URI |
|-------------|-------------|
| Production | `https://peerloop.com/api/auth/google/callback` |
| Preview/Staging | `https://<preview-subdomain>.pages.dev/api/auth/google/callback` |
| Local dev | `http://localhost:4321/api/auth/google/callback` |

**Important:** The redirect URI must match EXACTLY — including protocol, domain, port, and path. Google will reject mismatches.

5. Click **Create**
6. Copy the **Client ID** and **Client Secret**

### Step 5: Add Secrets to Environments

#### Local Development (.dev.vars)

Uncomment and fill in:
```
GOOGLE_CLIENT_ID=your-client-id-here.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-your-secret-here
```

#### Cloudflare Preview

In Cloudflare Dashboard → Pages → Peerloop → Settings → Environment variables:
- Add `GOOGLE_CLIENT_ID` (Secret) for Preview
- Add `GOOGLE_CLIENT_SECRET` (Secret) for Preview

#### Cloudflare Production

Same as above but for the Production environment. You may use the same Client ID/Secret for both, or create separate OAuth clients per environment for tighter security.

---

## Implementation Details

### Environment Variables

| Variable | Type | Where Used |
|----------|------|------------|
| `GOOGLE_CLIENT_ID` | Secret | `/api/auth/google` (initiate flow) |
| `GOOGLE_CLIENT_SECRET` | Secret | `/api/auth/google/callback` (exchange code) |

Both are read via `requireEnv(locals, 'GOOGLE_CLIENT_ID' | 'GOOGLE_CLIENT_SECRET')` from `@lib/env`. Under `@astrojs/cloudflare@13` (Conv 101+), this helper resolves through `import { env } from 'cloudflare:workers'` — the old `locals.runtime.env` namespace was removed by the adapter.

### Code Files

| File | Purpose |
|------|---------|
| `src/pages/api/auth/google/index.ts` | Initiates OAuth flow (redirect to Google) |
| `src/pages/api/auth/google/callback.ts` | Handles callback, creates/matches user |
| `src/lib/auth/index.ts` | `createGoogleProvider()`, `fetchGoogleUserInfo()` |
| `tests/api/auth/google/index.test.ts` | Tests for initiation endpoint |
| `tests/api/auth/google/callback.test.ts` | Tests for callback endpoint |

### Security Features

- **PKCE (Proof Key for Code Exchange):** Uses `code_verifier` + `code_challenge` to prevent authorization code interception
- **State parameter:** Random token stored in httpOnly cookie, verified on callback to prevent CSRF
- **Short-lived cookies:** OAuth state/verifier cookies expire in 10 minutes
- **Server-side only:** Client Secret never leaves the server

### User Account Behavior

| Scenario | What Happens |
|----------|-------------|
| New user | Creates account with Google name/email/avatar, auto-joins The Commons |
| Existing user (same email) | Logs in to existing account |
| Unverified email | Marks as verified (Google already verified it) |
| No Google email | Rejects login ("Email not verified with Google") |

### Handle Generation

For new OAuth users, a handle is generated from the email prefix:
- `james.fraser@gmail.com` → `jamesfraser`
- If taken, appends timestamp suffix: `jamesfraser_k7x2`
- Truncated to 25 characters max

---

## GitHub OAuth (Similar Setup)

GitHub OAuth follows the same pattern. See also:
- `src/pages/api/auth/github/index.ts`
- `src/pages/api/auth/github/callback.ts`

GitHub setup requires registering an **OAuth App** at [github.com/settings/developers](https://github.com/settings/developers):

| Field | Value |
|-------|-------|
| Application name | Peerloop |
| Homepage URL | `https://peerloop.com` |
| Authorization callback URL | `https://peerloop.com/api/auth/github/callback` |

This produces `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`.

**Note:** GitHub OAuth Apps only support ONE callback URL per app. You may need separate OAuth Apps for production vs preview/local, or use a single app with the production URL and test locally by tunneling.

---

## Pricing

Google OAuth is **free** with no per-user limits. There is no cost for the OAuth consent screen or API usage for sign-in flows.

GitHub OAuth is also **free** with no per-user limits.

---

## Caveats

1. **Consent screen review:** For production (>100 users), Google requires a verification review of your consent screen. Start this early — it can take 1-2 weeks.
2. **Preview URLs change:** Cloudflare Preview deployments have dynamic subdomains. You may need a wildcard or dedicated staging domain for OAuth to work on preview.
3. **localhost requires http:** Google allows `http://localhost` but NOT `http://127.0.0.1`. Use `localhost` in dev.
4. **GitHub single callback URL:** Unlike Google, GitHub only allows one callback URL per OAuth App. Consider separate apps per environment.

---

## References

- [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Arctic - Google Provider](https://arctic.js.org/providers/google)
- [Arctic - GitHub Provider](https://arctic.js.org/providers/github)
- [GitHub OAuth Apps](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app)
