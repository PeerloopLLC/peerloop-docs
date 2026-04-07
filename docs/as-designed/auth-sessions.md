# Auth Architecture: JWT vs Astro Sessions

**Created:** 2026-02-16 (Session 215)
**Status:** Active — Current system uses JWT. Astro Sessions evaluated and deferred.

## Overview

Peerloop uses custom JWT-based authentication with HTTP-only cookies. Astro 5 introduced a built-in Sessions API backed by server-side storage (Cloudflare KV for the Cloudflare adapter). This document records the evaluation and rationale for staying with JWT.

## Current Architecture: Stateless JWT

**Files:** `src/lib/auth/session.ts`, `src/lib/auth/jwt.ts`
**Library:** `jose` (Web Crypto API compatible, works on Cloudflare Workers)

```
Login → Server creates JWT (HS256) → Two HTTP-only cookies:
         ├── peerloop_access  (15 min TTL)  — userId, email, roles
         └── peerloop_refresh (7 day TTL)   — userId, email, roles

Request → Read cookie → Verify signature → Extract payload (no server lookup)
```

### How It Works

1. On login/register, `setAuthCookies()` creates two JWTs and sets them as `httpOnly`, `secure`, `sameSite: lax` cookies
2. On each request, `getSession()` verifies the access token signature; falls back to refresh token if expired
3. The JWT payload contains `userId`, `email`, `roles[]`, and `type` — enough to authorize most operations
4. `requireAuth()` and `requireRole()` provide guard functions for API endpoints
5. Astro middleware (`src/middleware.ts`) calls `getSession()` to guard member-only SSR pages (Conv 053)

### Strengths

- **Zero infrastructure:** No KV namespace, no storage costs, no extra latency
- **Self-contained:** Every request carries its own auth proof — no DB/KV lookup needed
- **Framework-agnostic:** Works if we change frameworks or hosting providers
- **Battle-tested:** JWT is an industry standard; `jose` is well-maintained

### Weaknesses

- **Stale data window:** If admin changes a user's roles or suspends them, the change doesn't take effect until the access token expires (up to 15 minutes)
- **No server-side revocation:** A stolen JWT is valid until expiry. Deleting cookies on the user's browser doesn't invalidate the token itself
- **Cookie size:** JWT cookies are ~500-800 bytes vs ~32 bytes for a session ID

## Alternative: Astro Sessions (Cloudflare KV)

**Astro Docs:** https://docs.astro.build/en/guides/sessions/

```
Login → Server creates session → Data stored in Cloudflare KV → Session ID cookie

Request → Read session ID → Fetch from KV → Return session data
```

### Astro Sessions API

```typescript
// In API endpoint or Astro page
const user = await context.session.get('user');
context.session.set('user', { id, email, roles });
context.session.regenerate(); // New ID after login (prevents fixation)
context.session.destroy();    // Logout — data deleted from KV
```

### Strengths

- **Instant revocation:** Delete KV entry = user is immediately logged out
- **Instant role updates:** Change roles in KV = next request sees new roles
- **Simpler code:** No JWT creation/verification/refresh logic
- **Small cookie:** Only the session ID travels in the cookie
- **Large data capacity:** 25MB per KV value vs 4KB cookie limit

### Weaknesses

- **KV read on every request:** Adds latency (~1-5ms from Cloudflare edge, but still nonzero)
- **Infrastructure dependency:** Requires provisioning KV namespace in Cloudflare
- **Cost at scale:** KV reads are metered (free tier: 100K reads/day; then $0.50/million)
- **Framework lock-in:** Tied to Astro's session implementation
- **Migration effort:** Every endpoint using `getSession()`, `requireAuth()`, `requireRole()` would need updating

## Comparison Matrix

| Factor | JWT (Current) | Astro Sessions (KV) |
|--------|--------------|---------------------|
| Storage | Client-side (cookie payload) | Server-side (Cloudflare KV) |
| Lookup per request | None (signature verification only) | KV read |
| Latency | ~0ms (CPU only) | ~1-5ms (network to KV) |
| Cookie size | ~500-800 bytes | ~32 bytes |
| Revocation | Wait for expiry (≤15 min) | Immediate |
| Role freshness | Stale for ≤15 min | Always current |
| Cost | $0 | KV pricing at scale |
| Code complexity | More (JWT + refresh logic) | Less (get/set/destroy) |
| Framework coupling | None | Astro-specific |
| Portability | High | Low |

## Decision: Stay with JWT

**Rationale:**

1. **Already built and tested.** ~150 lines of auth code, integrated across all API endpoints and tested in 169 API test files. Migration cost is high with no user-facing benefit.

2. **The stale-role gap is manageable.** The 15-minute access token window limits exposure. For critical operations (admin actions, payments), endpoints already query D1 for fresh user data — they don't rely solely on JWT claims.

3. **No KV cost or infrastructure.** One fewer Cloudflare binding to provision and monitor.

4. **Portability preserved.** If we move off Astro (e.g., to a standalone Workers API), the auth system travels unchanged.

## Mitigation: Stale-Role Gap

The main JWT weakness is the stale-role window. Mitigations:

### Current (Sufficient for MVP)

- **Short access token TTL (15 min):** Limits the staleness window
- **Critical endpoints re-check D1:** Admin operations, payment flows, and sensitive mutations query the database for fresh user data rather than trusting JWT claims alone

### Future (If Needed)

- **Hybrid approach:** Keep JWT for identity ("who is this?") but add a lightweight D1 or KV check for authorization ("are they still allowed?") on sensitive endpoints
- **Token revocation list:** Small KV or D1 table of revoked token IDs, checked only on admin/sensitive routes
- **Full migration to Astro Sessions:** If the codebase standardizes fully on Astro and the stale-role gap becomes a real problem (e.g., after a security incident or compliance requirement)

## Related: Cloudflare Adapter Warnings

### SESSION KV Binding Warning

The `@astrojs/cloudflare` adapter auto-enables Astro Sessions and warns:

> "If you see the error 'Invalid binding SESSION' in your build output, you need to add the binding to your wrangler config file."

**Since we don't use Astro Sessions**, this warning is informational. KV namespace bindings were removed from wrangler.toml in Conv 095 — confirmed safe because no code calls `Astro.session`. The adapter's session config remains in `astro.config.mjs` to suppress info messages, but the missing binding causes no runtime errors.

**Deploy note:** Verified Conv 095 — adapter does not fail without KV binding as long as `Astro.session` is never called.

### Sharp Image Service Warning

> "Cloudflare does not support sharp at runtime. Configure imageService: 'compile' to optimize images on prerendered pages during build time."

**No `<Image>` or `getImage()` calls exist in the codebase.** This is informational for now.

**If we add Astro image optimization later**, configure in `astro.config.mjs`:

```javascript
// For prerendered pages (build-time optimization)
image: { service: { entrypoint: 'astro/assets/services/compile' } }

// Or disable optimization entirely
image: { service: { entrypoint: 'astro/assets/services/no-op' } }
```

## References

- `src/lib/auth/session.ts` — Session management (getSession, setAuthCookies, requireAuth, requireRole)
- `src/lib/auth/jwt.ts` — JWT creation and verification (jose library)
- `docs/as-designed/state-management.md` — How auth state propagates across pages/islands
- Astro Sessions: https://docs.astro.build/en/guides/sessions/
- jose library: https://github.com/panva/jose
- Cloudflare KV pricing: https://developers.cloudflare.com/kv/platform/pricing/
