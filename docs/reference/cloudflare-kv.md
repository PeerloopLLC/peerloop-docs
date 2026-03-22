# Cloudflare KV

**Created:** 2026-02-16 (Session 215)
**Status:** Active — SESSION namespace provisioned. General use cases deferred to post-MVP.

## Overview

Cloudflare KV (Key-Value) is a globally distributed, eventually consistent key-value store available at the edge. Peerloop has provisioned a KV namespace for the Astro SESSION binding, which satisfies the `@astrojs/cloudflare` adapter requirement. Additional KV use cases are deferred until post-MVP.

## Why KV Was Added

The `@astrojs/cloudflare` adapter auto-enables Astro Sessions backed by KV storage. Without a `SESSION` binding in `wrangler.toml`, production deploys would fail with `Invalid binding SESSION`. Rather than fighting the adapter, we provision the namespace and keep it available for future use.

## Current Configuration

### Namespaces

| Namespace | Binding | Environment | ID |
|-----------|---------|-------------|-----|
| `SESSION` | `SESSION` | Production (top-level + env.production) | `7605e3a386904b77b566161633f609ce` |
| `SESSION_preview` | `SESSION` | Preview (env.preview) | `e2c3e710131340bdb1186b62af7a8c00` |

**Why separate namespaces?** Production and preview environments must not share session data. A preview session ID should never resolve against production KV (and vice versa).

**Local dev:** Wrangler automatically emulates KV locally — no remote namespace needed for `npm run dev`.

### Wrangler Config

```toml
# Top-level (production)
[[kv_namespaces]]
binding = "SESSION"
id = "7605e3a386904b77b566161633f609ce"

# Preview
[[env.preview.kv_namespaces]]
binding = "SESSION"
id = "e2c3e710131340bdb1186b62af7a8c00"
```

## How KV Works

```
Write (any edge location)
  → Propagates globally (eventually consistent, up to 60s)
  → All edge locations serve updated value

Read (nearest edge location)
  → Returns cached value (possibly stale for up to 60s after write)
  → Sub-millisecond reads from cache
```

### Key Characteristics

| Property | Value |
|----------|-------|
| **Consistency** | Eventually consistent (~60s propagation) |
| **Read latency** | Sub-millisecond (edge cached) |
| **Write latency** | ~50-100ms (single write, then propagation) |
| **Max value size** | 25 MB |
| **Max key size** | 512 bytes |
| **Write limit** | 1 write/second per key |
| **TTL support** | Yes — auto-expiration |
| **List operations** | Yes — prefix-based key listing |

## KV vs D1: When to Use Which

| Factor | KV | D1 |
|--------|----|----|
| **Consistency** | Eventually consistent (~60s) | Strongly consistent |
| **Read speed** | Sub-ms (edge cached) | ~5-20ms (single region) |
| **Data model** | Key-value pairs | Relational (SQL) |
| **Queries** | Get by key, list by prefix | Full SQL (JOIN, WHERE, GROUP BY) |
| **Write speed** | Fast, but 1/sec per key | Fast, batched transactions |
| **Best for** | Caching, config, sessions, flags | Business data, relationships, reporting |
| **TTL/expiry** | Built-in | Manual (check timestamps) |
| **Cost** | Reads: $0.50/M; Writes: $5/M | Reads: $0.001/M; Writes: $1/M |

### Decision Guide

**Use KV when:**
- Data is read-heavy (>>10:1 read:write ratio)
- Eventual consistency is acceptable (config, cache, non-critical state)
- You need automatic TTL expiration
- Data is a simple key-value mapping
- Edge latency matters (sub-ms reads)

**Use D1 when:**
- Data has relationships (users → enrollments → courses)
- You need strong consistency (payments, enrollment status)
- You need SQL queries (aggregation, filtering, joins)
- Write frequency is high on the same key
- Data integrity matters (foreign keys, constraints)

## Eventual Consistency: What It Means in Practice

### The 60-Second Window

When a value is written to KV, the write is acknowledged immediately but may take up to 60 seconds to propagate to all Cloudflare edge locations worldwide.

**Scenario:** User in New York updates their profile settings (stored in KV).

```
T+0s:   Write succeeds at New York edge
T+0s:   New York reads return new value ✅
T+5s:   London reads may return OLD value ⚠️
T+30s:  Tokyo reads may return OLD value ⚠️
T+60s:  All locations return new value ✅
```

### What This Means for Peerloop

| Use Case | Consistency Risk | Acceptable? |
|----------|-----------------|-------------|
| Feature flags | Flag change delayed ~60s | Yes — flags change rarely |
| Rate limiting | Counts slightly off across edges | Yes — approximate is fine |
| Cache | Stale cache for ~60s after invalidation | Yes — that's what caches do |
| Session data (if adopted) | Logout delayed ~60s at other edges | Maybe — depends on security posture |
| User permissions | Role change delayed ~60s | No — use D1 for this |
| Payment state | Enrollment status delayed | No — use D1 for this |

### Mitigation Strategies

1. **Use D1 for authoritative data.** KV is a cache/convenience layer, not the source of truth.
2. **Design for staleness.** If reading from KV, assume the value might be up to 60s old.
3. **Write-through pattern.** Write to D1 first (source of truth), then update KV (cache).
4. **TTL for auto-cleanup.** Use KV's TTL feature rather than manual deletion for ephemeral data.

## Potential Use Cases (Post-MVP)

### 1. Feature Flags

```typescript
// Read feature flag (sub-ms, edge-cached)
const flags = await env.SESSION.get('feature_flags', { type: 'json' });
if (flags?.new_checkout_flow) { ... }

// Admin updates flag (propagates in ~60s)
await env.SESSION.put('feature_flags', JSON.stringify({ new_checkout_flow: true }));
```

### 2. Rate Limiting

```typescript
// Per-IP rate limiting with TTL
const key = `rate:${clientIP}`;
const count = parseInt(await env.SESSION.get(key) || '0');
if (count > 100) return new Response('Too many requests', { status: 429 });
await env.SESSION.put(key, String(count + 1), { expirationTtl: 3600 });
```

### 3. API Response Cache

```typescript
// Cache expensive D1 query results
const cacheKey = `cache:courses:popular`;
const cached = await env.SESSION.get(cacheKey, { type: 'json' });
if (cached) return Response.json(cached);

const courses = await db.prepare('SELECT ... expensive query ...').all();
await env.SESSION.put(cacheKey, JSON.stringify(courses), { expirationTtl: 300 });
return Response.json(courses);
```

### 4. Short-Lived Tokens

```typescript
// Email verification token with auto-expiry
const token = crypto.randomUUID();
await env.SESSION.put(`verify:${token}`, userId, { expirationTtl: 86400 }); // 24h

// Verification endpoint
const userId = await env.SESSION.get(`verify:${token}`);
if (!userId) return new Response('Token expired', { status: 410 });
```

## Pricing

| Operation | Free Tier | Paid |
|-----------|-----------|------|
| Reads | 100,000/day | $0.50/million |
| Writes | 1,000/day | $5.00/million |
| Deletes | 1,000/day | $5.00/million |
| List | 1,000/day | $5.00/million |
| Storage | 1 GB | $0.50/GB-month |

**For Peerloop MVP:** Free tier is more than sufficient. Even at 1,000 daily active users with 10 KV reads each = 10,000 reads/day (well within 100K free limit).

## Accessing KV in Code

### In Astro API Endpoints

```typescript
export const GET: APIRoute = async ({ locals }) => {
  const kv = locals.runtime?.env?.SESSION as KVNamespace;
  if (!kv) {
    return Response.json({ error: 'KV not available' }, { status: 503 });
  }

  const value = await kv.get('my-key');
  // ...
};
```

### In Astro Sessions (if adopted)

```typescript
// Astro handles KV internally — you just use the session API
const user = await context.session.get('user');
context.session.set('user', { id, email, roles });
context.session.destroy(); // Logout
```

## References

- Cloudflare KV docs: https://developers.cloudflare.com/kv/
- KV pricing: https://developers.cloudflare.com/kv/platform/pricing/
- KV consistency model: https://developers.cloudflare.com/kv/concepts/how-kv-works/
- Astro Sessions: https://docs.astro.build/en/guides/sessions/
- `docs/as-designed/auth-sessions.md` — JWT vs Astro Sessions decision
- `wrangler.toml` — KV namespace bindings
