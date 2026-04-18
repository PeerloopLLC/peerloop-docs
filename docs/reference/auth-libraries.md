# auth-libraries.md

**Libraries:** jose, bcryptjs, arctic
**Type:** Authentication stack — decision record
**Source:** Technology-decision session (2025-12-26)
**Status:** ACTIVE DECISION — libraries in production

> **Scope of this doc:** this is a **decision record** explaining *why* Peerloop picked these three libraries over the alternatives. It does NOT document the current implementation. For code shape, see `src/lib/auth/*` and the cross-references at the bottom. The original draft of this doc carried extensive code examples that drifted out of sync with the implementation; those have been removed in Conv 131 (TDS-AUTH audit) in favor of pointers.

---

## Stack Summary

| Library | Purpose | Why Chosen |
|---------|---------|------------|
| **jose** | JWT creation & verification | Native Web Crypto API support — works on Cloudflare Workers without polyfills |
| **bcryptjs** | Password hashing | Pure JS; no native dependencies; runs anywhere including Workers |
| **arctic** | OAuth 2.0 providers (Google, GitHub) | Lightweight, edge-compatible, no bloated deps |

All three are implemented in `src/lib/auth/`:

- `jwt.ts` — jose wrappers (`createToken`, `verifyToken`, `createAccessToken`, `createRefreshToken`, `createEmailVerifyToken`, `createPasswordResetToken`, `extractBearerToken`)
- `password.ts` — bcryptjs wrappers (`hashPassword`, `verifyPassword`, `validatePassword`)
- `oauth.ts` — arctic wrappers (`createGoogleProvider`, `createGitHubProvider`, `generateOAuthState`, user-info fetchers, cookie constants)
- `session.ts` — cookie/session plumbing that composes the above
- `moderation.ts` — two-tier moderation access helper (global admin vs community-scoped moderator)
- `index.ts` — barrel re-exports + `validateEmail` / `validateHandle` utilities

See `docs/as-designed/auth-sessions.md` for the architectural trade-off (JWT-in-cookie vs Astro Sessions-on-KV) that sits *on top of* these libraries.

---

## Decision: Custom JWT over Auth Services

### Alternatives Evaluated

**Supabase Auth** and **Clerk** — both offer managed user accounts, OAuth, email verification, and session management as a service.

| Criterion | Custom JWT (chosen) | Supabase Auth | Clerk |
|-----------|:-------------------:|:-------------:|:-----:|
| Cloudflare Workers runtime | Native | Via HTTP | Known issues |
| External service dependency | None | Supabase | Clerk |
| Cost at scale | $0 | $25/mo+ | Per-MAU |
| Full control over auth logic | Yes | Limited | Limited |
| Estimated build time | 16h | 8h | 4h |
| Vendor lock-in | None | Medium | High |
| User data location | Our D1 | Their servers | Their servers |

### Why Custom JWT Won

1. **Native Workers runtime.** No HTTP calls to an external auth service on every login/refresh — auth decisions happen in the same Worker invocation as the request, with zero added latency and no external SLA dependency.
2. **No vendor lock-in.** If we move off Astro or change hosts, the auth code ports unchanged.
3. **No per-user cost.** Clerk's per-MAU pricing becomes material at scale; Supabase's base fee adds up. Custom JWT is free forever.
4. **D1 integration.** Users live in the same database as courses, enrollments, and everything else — one query to fetch "user + their enrollments", not two round-trips to two different providers.
5. **Block 0 budget already allocated the 16h** needed to build it.

### Clerk's Cloudflare Issue

Clerk has a [known incompatibility](https://community.cloudflare.com/t/issue-with-clerk-astro-and-node-async-hooks-on-cloudflare-pages-local-works/792904) with Astro on Cloudflare Pages (`node:async_hooks` error). Custom JWT avoids the class of Node-runtime-dependency problems entirely because `jose`, `bcryptjs`, and `arctic` are all pure-JS / Web-API.

---

## Per-Library Rationale

### jose (JWT)

- **Home:** https://github.com/panva/jose
- **Why:** Works in every JavaScript runtime including Cloudflare Workers. Written against Web Crypto API primitives — no Node-only dependencies.
- **What we use it for:** HS256-signed JWTs for our access/refresh/email-verify/password-reset tokens. See `src/lib/auth/jwt.ts` for the exact wrappers and token-type enum (`'access' | 'refresh' | 'email_verify' | 'password_reset'`).
- **Token expirations** are centralized in `TOKEN_EXPIRY` in `jwt.ts` — current values: access `15m`, refresh `7d`, email-verify `24h`, password-reset `1h`.

### bcryptjs (passwords)

- **Home:** https://github.com/dcodeIO/bcrypt.js
- **Why:** Pure JavaScript. No native dependencies (the native `bcrypt` package can't run on Workers).
- **What we use it for:** Hashing/verifying user passwords. See `src/lib/auth/password.ts` for the wrapper and password-strength rules.
- **Salt rounds** are configured in `password.ts` (`SALT_ROUNDS` constant) — bump with care; each increment roughly doubles login CPU time.

### arctic (OAuth)

- **Home:** https://arctic.js.org/
- **Why:** Lightweight, edge-compatible, no bloated transitive deps. Explicit PKCE support. Per-provider modules for Google, GitHub, and many others.
- **What we use it for:** Initiating and completing Google + GitHub OAuth flows. See `src/lib/auth/oauth.ts` for provider factories and `src/pages/api/auth/{google,github}/{index,callback}.ts` for the four routes.
- **Client setup:** see `docs/reference/google-oauth.md` for the Google Cloud Console and GitHub OAuth App registration walkthrough.

---

## Security Posture (Summary)

These are the posture decisions the library choices enable; full details live in `docs/as-designed/auth-sessions.md`:

- **HttpOnly + Secure + SameSite=lax cookies** for both access and refresh tokens. Tokens are never exposed to client JS.
- **Short access-token TTL (15 min)** limits the stale-role / stale-permission window.
- **Refresh-token-as-auth fallback** in `getSession()` — a valid refresh token is itself a valid credential when the access token is missing or expired. Trade-off analysis in `auth-sessions.md` §Refresh-Token-as-Auth Fallback.
- **PKCE on OAuth flows** (Google) — `code_verifier` + `code_challenge` to prevent authorization-code interception.
- **Short-lived OAuth state cookies** (10 min) — `peerloop_oauth_state` and `peerloop_oauth_verifier` (constants in `oauth.ts`).
- **Password strength requirements** — see `validatePassword` in `password.ts` for the exact rule set.

---

## Known Gaps (Deliberate)

These are acknowledged weaknesses of the stateless-JWT model, accepted because mitigation exists or cost outweighs benefit. See `auth-sessions.md` for the full trade-off.

- **No server-side revocation list.** A leaked JWT is valid until expiry. Mitigation today: rotate `JWT_SECRET` (logs out everyone).
- **Stale-role window.** Role/permission changes don't take effect until the access token expires (≤15 min, or up to 7 days if the refresh-token-as-auth fallback is continuously exercised). Critical mutations (admin actions, payments) re-query D1 for fresh permissions rather than trusting JWT claims alone.
- **No automatic access-token rotation on refresh-token-served requests.** The user's access cookie stays expired; every subsequent request takes the refresh path. Functionally fine but forfeits the access-token freshness benefit. Comment marker in `session.ts` (`// could refresh access token here`).

---

## Comparison Matrix (Condensed)

| Aspect | Custom JWT | Clerk | Supabase Auth |
|--------|:----------:|:-----:|:-------------:|
| Edge runtime | Native | Known issues | Via HTTP |
| Pre-built UI | None | Yes | Yes |
| OAuth provider setup | Manual (arctic + client secrets) | Automatic | Automatic |
| User management (admin tools) | Build ourselves | Included | Included |
| Cost | $0 | Per-MAU | $25/mo+ |
| Vendor lock-in | None | High | Medium |
| Data location | Our D1 | Their servers | Their servers |

**Net decision:** Custom JWT gives us full control, native edge support, and zero vendor dependencies. The 16h investment pays off in flexibility and per-month cost savings at every scale we care about.

---

## Related Docs

- `docs/as-designed/auth-sessions.md` — JWT vs Astro Sessions architectural decision (sits on top of the library choice)
- `docs/reference/google-oauth.md` — Google + GitHub OAuth client-registration walkthrough
- `docs/reference/API-AUTH.md` — Endpoint contracts for `/api/auth/*`

## External References

### jose
- [GitHub](https://github.com/panva/jose)

### bcryptjs
- [GitHub](https://github.com/dcodeIO/bcrypt.js)
- [npm](https://www.npmjs.com/package/bcryptjs)

### arctic
- [Website](https://arctic.js.org/)
- [GitHub](https://github.com/pilcrowonpaper/arctic)
- [Google Provider](https://arctic.js.org/providers/google)
- [GitHub Provider](https://arctic.js.org/providers/github)

### Alternatives (for future reference)
- [Clerk vs Supabase Auth](https://clerk.com/articles/clerk-vs-supabase-auth)
- [Auth provider comparison](https://blog.hyperknot.com/p/comparing-auth-providers)
- [Clerk Cloudflare issues thread](https://community.cloudflare.com/t/issue-with-clerk-astro-and-node-async-hooks-on-cloudflare-pages-local-works/792904)
