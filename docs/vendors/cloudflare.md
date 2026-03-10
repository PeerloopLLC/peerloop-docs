# cloudflare.md

**Service:** Cloudflare
**Type:** Edge Platform / Hosting / Database / Storage
**Website:** https://cloudflare.com/
**Source:** DIRECTIVES.md (DIR-003)
**Status:** CONFIRMED

---

## Overview

Cloudflare is the hosting and infrastructure platform for PeerLoop, providing edge computing, database, and storage services.

---

## API Authentication

### API Token vs Global API Key

| Type | Recommendation | Notes |
|------|----------------|-------|
| **API Token** | **Use this** | Scoped permissions, can be revoked, multiple tokens allowed |
| **Global API Key** | Avoid | Full account access, cannot be scoped, single key |

### Authentication Methods

| Method | How It Works | Use Case |
|--------|--------------|----------|
| `wrangler login` | OAuth via browser | Interactive CLI use (recommended for dev) |
| API Token | Token in env var | CI/CD, scripts, non-interactive |

### When API Token is Needed

| Scenario | Auth Method | Notes |
|----------|-------------|-------|
| Local dev with local D1 emulation | None | D1 runs locally |
| Local dev with remote D1 | `wrangler login` | OAuth sufficient |
| `wrangler d1 migrations apply --remote` | `wrangler login` | OAuth sufficient |
| Deployed site (Pages/Workers) | None | Uses bound resources automatically |
| CI/CD pipelines (GitHub Actions) | **API Token** | Non-interactive, needs `CLOUDFLARE_API_TOKEN` |
| External scripts/services | **API Token** | Accessing Cloudflare REST API |

**Key insight:** For interactive development, `wrangler login` (OAuth) is sufficient. API tokens are only needed for non-interactive/automated scenarios.

### Creating an API Token

1. Go to https://dash.cloudflare.com/profile/api-tokens
2. Click **"Create Token"**
3. Use **"Edit Cloudflare Workers"** template (recommended)
4. Set Account Resources to your specific account
5. Copy token immediately (shown only once)

### Required Permissions for PeerLoop

For local development with remote D1:

| Permission | Level | Purpose |
|------------|-------|---------|
| Account > D1 > Edit | Read/Write | Query and modify D1 databases |
| Account > Workers Scripts > Edit | Read/Write | Wrangler commands |

The "Edit Cloudflare Workers" template includes both permissions.

### Token Storage

```bash
# .dev.vars (gitignored, machine-specific)
CLOUDFLARE_ACCOUNT_ID=your_account_id
CLOUDFLARE_API_TOKEN=your_api_token
```

**Security:**
- Never commit tokens to git
- `.dev.vars` is gitignored
- Tokens can be revoked anytime from dashboard
- Create separate tokens for different purposes (dev vs CI)

---

## Cloudflare Pages

Cloudflare Pages hosts the PeerLoop application with Git-based deployments.

### Why Pages

- **Zero-config Git deployment** - Connects directly to GitHub, deploys on push
- **Preview deployments** - Each PR gets a preview URL
- **Edge-first** - Static assets at edge, Workers for SSR
- **Integrated bindings** - D1, R2, KV available to Pages Functions

### Configuration

#### wrangler.toml Settings

For Git-connected Pages projects, `wrangler.toml` settings sync to Dashboard:

```toml
name = "peerloop"
compatibility_date = "2024-12-01"
compatibility_flags = ["nodejs_compat_v2"]  # Recommended for React SSR
pages_build_output_dir = "./dist"

[[d1_databases]]
binding = "DB"
database_name = "peerloop-db"
database_id = "your-database-id"
```

#### Build Settings

| Setting | Value | Notes |
|---------|-------|-------|
| Build command | `npm run build` | Runs Astro build |
| Output directory | `dist` | Astro default |
| Node version | 22.19.0 | Set via `.nvmrc` and `package.json` engines |

#### Node.js Version on CF Pages

The CF Pages build image uses `asdf`/`node-build` to install the Node version specified in `.nvmrc`.

| Node Version | CF Pages Support | Status |
|--------------|:----------------:|--------|
| **22.x** | ✅ | Current project version. LTS Maintenance until April 2027. |
| **24.x** | ❌ | Not available in CF Pages build image (as of Feb 2026). |

**Build warning (informational, not a blocker):**
```
WARNING: node-v22.19.0-linux-x64 is in LTS Maintenance mode and nearing its end of life.
```

**Upgrade path:** When CF Pages adds Node 24 support, update `.nvmrc` and `package.json` engines. Verify Astro 5.x compatibility first (officially supports Node 18/20/22 as of Feb 2026).

### Deployment Caveats

#### "Retry deployment" Uses Same Commit

**Gotcha:** Clicking "Retry deployment" in the Dashboard re-deploys the exact same commit that failed, not the latest on the branch.

**Fix:** Push a new commit to trigger a fresh deployment:
```bash
git commit --allow-empty -m "Trigger deployment"
git push
```

#### React 19 SSR Requires Edge Module

React 19's SSR uses `MessageChannel` API which isn't available in Workers.

**Error:**
```
ReferenceError: MessageChannel is not defined
at requireReactDomServer_browser_production
```

**Fix:** Add Vite alias in `astro.config.mjs` (see docs/vendors/reactjs.md for details):
```javascript
vite: {
  resolve: {
    alias: import.meta.env.PROD && {
      'react-dom/server': 'react-dom/server.edge',
    },
  },
}
```

#### Compatibility Flags

| Flag | Purpose | Recommendation |
|------|---------|----------------|
| `nodejs_compat` | Basic Node.js APIs | Minimum required |
| `nodejs_compat_v2` | Extended Node.js APIs | **Recommended** |

Use `nodejs_compat_v2` for better Node.js compatibility in Workers runtime.

---

## Cloudflare D1

D1 is Cloudflare's serverless SQL database built on SQLite.

### Why D1

- **Edge-native** - Runs at edge locations for low latency
- **SQLite compatible** - Familiar SQL syntax, migrations
- **Zero configuration** - No connection pooling, auto-scaling
- **Integrated** - Direct binding in Workers/Pages

### Messaging with D1

> **Decision Pending:** D1 + Durable Objects is one option for PeerLoop messaging. See `docs/architecture/messaging.md` for comparison with Stream Chat.

If custom messaging is chosen, D1 would store:
- `conversations` - Conversation metadata
- `messages` - Message content and read status

### Foreign Key Enforcement (Immutable)

**Critical Caveat:** D1 enforces `foreign_keys=ON` at the platform level. You **cannot** disable it.

| PRAGMA | Works in D1? | Notes |
|--------|:------------:|-------|
| `foreign_keys = OFF` | ❌ | Silently ignored - D1 enforces at platform level |
| `defer_foreign_keys = ON` | ✅ | Defers constraint check to end of transaction |

**Impact on DROP TABLE:**
- `defer_foreign_keys` only affects data operations (INSERT/UPDATE/DELETE)
- It does NOT help with `DROP TABLE` - SQLite still prevents dropping a referenced table
- **Solution:** Drop tables in FK dependency order (children before parents)

**Database Reset Pattern:**
```bash
# Local: Delete SQLite files (simplest)
npm run db:reset:local

# Remote: Drop tables in dependency order (parses schema)
npm run db:reset:staging
npm run db:reset:remote
```

See `scripts/reset-d1.js` for implementation that parses `0001_schema.sql` to determine correct drop order.

**Caveat (Session 359):** The reset script drops tables but not indexes. If the batch drop fails partway (circular FK dependency), orphaned indexes survive and block re-migration. See `docs/architecture/migrations.md` "Remote Reset Caveats" for details and recovery steps.

**Reference:** [Cloudflare D1 Foreign Keys docs](https://developers.cloudflare.com/d1/sql-api/foreign-keys/)

### Schema Design

*To be documented*

### Migrations

Two-file system during development:
- `0001_schema.sql` - All table definitions (single source of truth)
- `0002_seed.sql` - All seed data

See CLAUDE.md "Database Migrations" section for details.

### Query Patterns

*To be documented*

---

## Cloudflare R2

Cloudflare R2 provides S3-compatible object storage for course resources, homework submissions, and session recordings.

### Why R2

- **S3-compatible API** - Familiar interface, works with existing S3 tools
- **No egress fees** - Unlike S3, no charges for data transfer out
- **Edge integration** - Direct binding in Workers/Pages, no API keys needed
- **Integrated with D1** - Store metadata in D1, files in R2

### Configuration

#### wrangler.toml Settings

```toml
[[r2_buckets]]
binding = "STORAGE"
bucket_name = "peerloop-storage"
```

#### Accessing R2 in Code

```typescript
// In API routes or Astro pages
const r2 = locals.runtime?.env?.STORAGE as R2Bucket | undefined;

if (!r2) {
  return Response.json({ error: 'Storage not available' }, { status: 503 });
}

// Upload
await r2.put('path/to/file.pdf', fileData, {
  httpMetadata: { contentType: 'application/pdf' },
  customMetadata: { uploadedBy: userId },
});

// Download
const object = await r2.get('path/to/file.pdf');

// Delete
await r2.delete('path/to/file.pdf');

// List
const objects = await r2.list({ prefix: 'courses/123/' });
```

### Machine Compatibility

Like D1, R2 local emulation requires the Cloudflare Workers runtime.

| Machine | R2 Local | R2 Remote | Notes |
|---------|:--------:|:---------:|-------|
| MacMiniM4-Pro (64GB) | ✅ | ✅ | Full functionality |
| MacMiniM4 (24GB) | ✅ | ✅ | Full functionality |

### NPM Scripts

```bash
# List objects in local R2 emulation
npm run r2:list:local

# List objects in production R2
npm run r2:list:remote
```

### Health Check

Test R2 connectivity via the health endpoint:

```bash
curl http://localhost:4321/api/health/r2
```

**Success Response (200):**
```json
{
  "status": "ok",
  "message": "R2 bucket is working",
  "bucket": "peerloop-storage",
  "tests": { "write": "pass", "read": "pass", "delete": "pass" }
}
```

**Failure Response (503):**
```json
{
  "status": "error",
  "message": "R2 STORAGE binding not available"
}
```

### File Organization

```
peerloop-storage/
├── courses/{courseId}/
│   └── resources/{resourceId}/
│       └── {filename}
├── sessions/{sessionId}/
│   └── recording.webm
└── submissions/{submissionId}/
    └── {filename}
```

### Upload Patterns

See `src/lib/r2.ts` for helper functions:
- `generateResourceKey()` - Generate R2 key for course resources
- `generateRecordingKey()` - Generate R2 key for session recordings
- `uploadToR2()` - Upload with metadata
- `downloadFromR2()` - Stream download
- `deleteFromR2()` - Delete object
- `listR2Objects()` - List with prefix filter

---

## Cloudflare Workers

Workers provide serverless compute at Cloudflare's edge.

### API Routes

PeerLoop API routes run as Workers via Astro's Cloudflare adapter.

### Durable Objects

Durable Objects provide stateful coordination for WebSocket connections.

> **Messaging Use Case:** If custom messaging is chosen (see `docs/architecture/messaging.md`), Durable Objects would coordinate real-time message delivery via WebSockets.

### Edge Functions

*To be documented*

---

## Cloudflare Queues

*To be documented*

### Background Jobs

### Queue Patterns

---

## Pricing

*To be documented*

---

---

## PeerLoop Integration

*Migrated from `research/run-001/assets/hosting-decisions.md` (2026-01-19)*

### Why Cloudflare for PeerLoop

Per DIR-003, Cloudflare is the required hosting platform.

| Factor | Cloudflare | Vercel | Winner |
|--------|------------|--------|--------|
| Cost at Scale | Lower | Higher per-request | Cloudflare |
| Free Tier | Commercial use OK | Hobby = personal only | Cloudflare |
| Cold Starts | ~0ms | 100ms-1s | Cloudflare |
| R2 Egress | Free | Paid | Cloudflare |
| Dashboard/DX | Good | Excellent | Vercel |
| Edge Network | 330+ cities | 100+ regions | Cloudflare |

**Decision:** Cloudflare wins on cost and performance, critical for a bootstrapped MVP.

### Cost Projection

| Phase | Users | Cloudflare Est. | Vercel Est. |
|-------|-------|-----------------|-------------|
| Genesis Cohort | 60-80 | ~$0 (free tier) | $20/mo (must use Pro) |
| Growth | 1,000 | ~$20/mo | $40-60/mo |
| Scale | 10,000 | ~$20-50/mo | $100-200/mo |

**Budget:** Plan for $0-20/month for hosting infrastructure.

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Cloudflare Edge                              │
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │    Pages     │    │   Workers    │    │       R2         │  │
│  │   (Astro)    │◀──▶│    (API)     │◀──▶│   (Storage)      │  │
│  └──────────────┘    └──────────────┘    └──────────────────┘  │
│         │                   │                                   │
│         │                   ▼                                   │
│         │            ┌──────────────┐                          │
│         │            │      D1      │                          │
│         └───────────▶│   (SQLite)   │                          │
│                      └──────────────┘                          │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
       ┌──────────┐    ┌──────────┐    ┌──────────┐
       │  Stripe  │    │  Stream  │    │ PlugNmeet│
       └──────────┘    └──────────┘    └──────────┘
```

### Services Stack

| Layer | Service | Purpose |
|-------|---------|---------|
| Static Hosting | Cloudflare Pages | Astro SSG/SSR |
| API/Backend | Cloudflare Workers | API endpoints |
| Database | Cloudflare D1 | SQLite at edge |
| File Storage | Cloudflare R2 | Course materials, recordings |
| Key-Value | Cloudflare KV | Sessions, rate limiting, caching |
| Auth | Custom JWT | No vendor lock-in |
| Email | Resend | Transactional email |

### R2 Storage Organization

```
peerloop-storage/
├── courses/{courseId}/
│   └── resources/{resourceId}/
│       └── {filename}
├── sessions/{sessionId}/
│   └── recording.webm
└── submissions/{submissionId}/
    └── {filename}
```

### Environment Variables

See [env-vars-secrets.md](../architecture/env-vars-secrets.md) for the complete reference.

**How variables reach Cloudflare:**

| Type | Mechanism | Managed via |
|------|-----------|-------------|
| Non-secrets | `wrangler.toml [vars]` per environment | Git (automatic on deploy) |
| Secrets | CF Dashboard → Encrypt | Dashboard (manual, one-time) |

**Important:** When `wrangler.toml` exists, the CF Pages dashboard **only allows encrypted secrets** — non-secret plain-text variables must be defined in `wrangler.toml [vars]`.

**Non-inheritable key rule:** `vars`, `d1_databases`, and `r2_buckets` are non-inheritable in CF Pages. If any one is overridden in an environment section (e.g. `[env.preview]`), all must be specified. This is why `[vars]` appears three times in `wrangler.toml` (top-level, production, preview).

**Current non-secrets in `wrangler.toml [vars]`:**
- `STRIPE_PUBLISHABLE_KEY` — client-side Checkout (`pk_test_` / `pk_live_`)
- `STREAM_API_KEY` — client-side feed SDK
- `STREAM_APP_ID` — public app identifier
- `GOOGLE_CLIENT_ID` — OAuth redirect URLs (when configured)
- `GITHUB_CLIENT_ID` — OAuth redirect URLs (when configured)

**Secrets set in CF Dashboard (encrypted):**
- `JWT_SECRET`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`
- `STREAM_API_SECRET`, `RESEND_API_KEY`
- `GOOGLE_CLIENT_SECRET`, `GITHUB_CLIENT_SECRET` (when configured)

### Limitations & Mitigations

| Limitation | Impact | Mitigation |
|------------|--------|------------|
| D1 SQLite (not Postgres) | Limited SQL features | Keep schema simple, migrate later if needed |
| Workers V8 (not Node.js) | Some npm packages won't work | Use compatible packages, polyfills |
| Workers 128MB memory | Large operations may fail | Offload to external services |
| D1 row limits | May hit at scale | Monitor, plan migration path |

### Future Migration Path

If Cloudflare becomes limiting:

1. **Database:** D1 → Neon Postgres or Supabase
2. **Hosting:** Pages → Vercel (change Astro adapter)
3. **Storage:** R2 → S3 or Vercel Blob
4. **API:** Workers → Vercel Functions

**Migration Effort:** Medium - Astro adapters make it manageable.

### Questions Resolved

| Question | Resolution |
|----------|------------|
| Existing accounts? | Assume new Cloudflare account |
| Node.js packages needed? | Minimize, use Workers-compatible |
| Recording storage? | PlugNmeet + replicate to R2 |
| Cost vs DX priority? | Cost (bootstrapped MVP) |
| Email provider? | Resend (revisit Cloudflare Email post-MVP) |
| Calendar system? | Custom built with Google/Apple export |

---

## References

### Official Documentation
- [Cloudflare Pages](https://developers.cloudflare.com/pages/)
- [Cloudflare D1](https://developers.cloudflare.com/d1/)
- [Cloudflare R2](https://developers.cloudflare.com/r2/)
- [Cloudflare Workers](https://developers.cloudflare.com/workers/)
- [Cloudflare Queues](https://developers.cloudflare.com/queues/)
