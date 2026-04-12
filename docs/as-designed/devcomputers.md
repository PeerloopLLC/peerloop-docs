# Development Computers

**Type:** Development Environment Configuration
**Status:** ACTIVE
**Created:** 2025-12-27
**Last Updated:** 2026-02-28 (Added CF Pages build environment / CI test detection note)

---

## Overview

PeerLoop development occurs across two Mac Mini machines with identical Cloudflare capabilities. Both machines run macOS 15+ (Sequoia) with Apple Silicon and have full support for local D1 emulation, R2 storage, Workers runtime, and the Astro Cloudflare adapter.

---

## Database Strategy (Two Remote D1 Databases)

| Database | ID | Purpose | Used By |
|----------|-----|---------|---------|
| `peerloop-db` | `21c0179a-9e7d-4cc1-91d5-ea402717fce8` | **PRODUCTION** | `main` branch deployments only |
| `peerloop-db-staging` | `605f1ab8-62cc-4934-a2fd-d828e188f50e` | **STAGING** | Preview deploys, QA |

**Critical Rules:**
- Production database is for live customer data only
- Both machines use local D1 emulation for development (no remote writes needed)
- Automated tests use in-memory SQLite (see `tests/helpers/test-db.ts`)

---

## Machine Inventory

| Standard Name | Machine | Hostname | macOS | Cloudflare Local | D1 Access | R2 Access |
|---------------|---------|----------|-------|------------------|-----------|-----------|
| `MacMiniM4-Pro` | Mac Mini M4 Pro (64GB) | Jamess-Mac-mini.local | 15+ (Sequoia) | Full Support | Local emulation | Local emulation |
| `MacMiniM4` | Mac Mini M4 (24GB) | Livings-Mac-mini.local | 15+ (Sequoia) | Full Support | Local emulation | Local emulation |

**Note:** Use standard names (`MacMiniM4-Pro`, `MacMiniM4`) when documenting machine-specific behavior in session files. See DEVELOPMENT-GUIDE.md for conventions.

---

## MacMiniM4-Pro (Mac Mini M4 Pro)

### Specifications

| Component | Value |
|-----------|-------|
| Chip | Apple M4 Pro |
| CPU | 12-core |
| GPU | 16-core |
| Memory | 64GB Unified |
| Hostname | Jamess-Mac-mini.local |
| macOS | 15+ (Sequoia) |

### Cloudflare Compatibility

| Feature | Status | Notes |
|---------|--------|-------|
| Wrangler CLI | Full Support | All commands work |
| `wrangler dev` | Full Support | Local Workers runtime |
| `wrangler d1 migrations apply --local` | Full Support | Local D1 emulation |
| `wrangler d1 migrations apply --remote` | Full Support | Remote D1 access |
| `wrangler r2 object --local` | Full Support | Local R2 emulation |
| `wrangler r2 object --remote` | Full Support | Remote R2 access |
| Astro Cloudflare adapter | Full Support | Native mode |

### Development Configuration

```bash
# .dev.vars (machine-specific, gitignored)
# No special D1 configuration needed - native binding works
JWT_SECRET=your_jwt_secret
```

### Commands

```bash
# Apply migrations locally
npm run db:migrate:local

# Start dev server with full Cloudflare emulation
npm run dev

# Or use wrangler directly
wrangler d1 migrations apply peerloop-db --local
```

### Recommended Workflow

1. Run D1 locally for fast iteration
2. Full Cloudflare Workers emulation available
3. No network latency for database operations
4. Can work completely offline

---

## MacMiniM4 (Mac Mini M4)

### Specifications

| Component | Value |
|-----------|-------|
| Chip | Apple M4 |
| CPU | 10-core |
| GPU | 10-core |
| Memory | 24GB Unified |
| Hostname | Livings-Mac-mini.local |
| macOS | 15+ (Sequoia) |

### Cloudflare Compatibility

| Feature | Status | Notes |
|---------|--------|-------|
| Wrangler CLI | Full Support | All commands work |
| `wrangler dev` | Full Support | Local Workers runtime |
| `wrangler d1 migrations apply --local` | Full Support | Local D1 emulation |
| `wrangler d1 migrations apply --remote` | Full Support | Remote D1 access |
| `wrangler r2 object --local` | Full Support | Local R2 emulation |
| `wrangler r2 object --remote` | Full Support | Remote R2 access |
| Astro Cloudflare adapter | Full Support | Native mode |

### Development Configuration

```bash
# .dev.vars (machine-specific, gitignored)
# No special D1 configuration needed - native binding works
JWT_SECRET=your_jwt_secret
```

### Commands

```bash
# Apply migrations locally
npm run db:migrate:local

# Start dev server with full Cloudflare emulation
npm run dev

# Or use wrangler directly
wrangler d1 migrations apply peerloop-db --local
```

### Recommended Workflow

1. Run D1 locally for fast iteration
2. Full Cloudflare Workers emulation available
3. No network latency for database operations
4. Can work completely offline

---

## D1 vs Local SQLite: Behavioral Differences

D1 is built on SQLite, so behavior is nearly identical. However, key differences exist that affect how we write code.

**Golden Rule:** Always code for D1's more restrictive behavior. Code that works on D1 will work on SQLite, but not vice versa.

---

### Critical Differences Summary

| Behavior | D1 (Cloudflare) | SQLite (Local) | Code For |
|----------|-----------------|----------------|----------|
| **Transactions** | `batch()` only - no `BEGIN`/`COMMIT` | Full transaction support | D1 |
| **Prepared statements** | Single-use only | Reusable across queries | D1 |
| **Query latency** | 50-200ms (network to Cloudflare) | <1ms (local file I/O) | N/A |

---

### Identical Behavior (Safe to Use)

| Feature | Both D1 and SQLite |
|---------|-------------------|
| SQL syntax | SQLite dialect |
| Data types | TEXT, INTEGER, REAL, BLOB |
| JSON functions | `json_extract()`, `json_array()`, etc. |
| Indexes | B-tree indexes |
| Constraints | FK, UNIQUE, CHECK all enforced |
| NULL handling | SQLite rules (NULL = NULL is false) |

---

### Detailed Differences

| Feature | D1 (Cloudflare) | SQLite (Local) | Impact |
|---------|-----------------|----------------|--------|
| Transactions | **Limited:** `batch()` only | **Full:** `BEGIN`/`COMMIT`/`ROLLBACK` | Must use batch() |
| Prepared statements | **Single-use:** create new per query | **Reusable:** bind multiple times | Must create new each time |
| Result format | `{ results: [...], meta: {...} }` | Raw array | Handled by helpers |
| Query timing | **50-200ms** (network) | **<1ms** (instant) | Remote feels slow |
| Concurrent access | Managed by Cloudflare | File locking | No impact |
| Size limits | 10GB per database | Unlimited | No impact |
| Row size | 1MB per row | 1GB per row | No impact |

---

### Gotcha #1: Transactions (D1 limitation)

**SQLite supports** full transaction control:
```typescript
// This works in SQLite but NOT in D1
await db.exec('BEGIN');
await db.prepare('INSERT INTO users ...').run();
await db.prepare('UPDATE accounts ...').run();
await db.exec('COMMIT');  // D1 ignores this
```

**D1 requires** `batch()` for atomic operations:
```typescript
// This works in BOTH D1 and SQLite
await db.batch([
  db.prepare('INSERT INTO users ...'),
  db.prepare('UPDATE accounts ...'),
]);
// All statements succeed or all fail - atomic
```

**Rule:** Always use `batch()` for multi-statement atomic operations.

---

### Gotcha #2: Prepared Statements (D1 limitation)

**SQLite allows** reusing prepared statements:
```typescript
// This works in SQLite but NOT reliably in D1
const stmt = db.prepare('SELECT * FROM users WHERE id = ?');
await stmt.bind(id1).first();  // Works
await stmt.bind(id2).first();  // SQLite: works, D1: may fail
```

**D1 requires** creating a new statement each time:
```typescript
// This works in BOTH D1 and SQLite
await db.prepare('SELECT * FROM users WHERE id = ?').bind(id1).first();
await db.prepare('SELECT * FROM users WHERE id = ?').bind(id2).first();
```

**Rule:** Never reuse prepared statements. Create new for each query.

---

### Gotcha #3: Query Latency (Network vs Local)

| Mode | Latency | Experience |
|------|---------|------------|
| D1 Local (either Mac Mini) | <1ms | Instant |
| D1 Remote | 50-200ms | Noticeable delay |
| SQLite file | <1ms | Instant |

**Impact:** When using `--remote`:
- Page loads feel slower during development
- Multiple sequential queries compound the delay
- Consider batching related queries

**Rule:** Batch related queries when possible to reduce round-trips.

```typescript
// SLOW: 3 round-trips (150-600ms total)
const user = await db.prepare('SELECT * FROM users WHERE id = ?').bind(id).first();
const courses = await db.prepare('SELECT * FROM courses WHERE creator_id = ?').bind(id).all();
const stats = await db.prepare('SELECT * FROM user_stats WHERE user_id = ?').bind(id).first();

// FASTER: 1 round-trip (50-200ms total)
const [userResult, coursesResult, statsResult] = await db.batch([
  db.prepare('SELECT * FROM users WHERE id = ?').bind(id),
  db.prepare('SELECT * FROM courses WHERE creator_id = ?').bind(id),
  db.prepare('SELECT * FROM user_stats WHERE user_id = ?').bind(id),
]);
```

---

### Testing Strategy

| Test Type | Where to Run | Database |
|-----------|--------------|----------|
| SQL syntax validation | Any machine | Local SQLite |
| Unit tests (mocked DB) | Any machine | None (mocked) |
| Integration tests | Either machine | Local D1 |
| E2E tests | Either machine | Remote D1 (for consistency) |

---

## D1 Health Check Endpoint

Use `/api/health/db` to verify D1 connectivity:

```bash
# Check D1 status
curl http://localhost:4321/api/health/db
```

**Success Response (200):**
```json
{
  "status": "ok",
  "timestamp": "2025-12-29T17:30:00.000Z",
  "latency_ms": 12,
  "tables": 25
}
```

**Failure Response (503):**
```json
{
  "status": "error",
  "timestamp": "2025-12-29T17:30:00.000Z",
  "error": "D1 database binding not available"
}
```

**Use cases:**
- Startup check: Verify D1 is connected before testing
- CI/CD: Health check before running integration tests
- Debugging: Confirm whether errors are due to D1 connectivity

---

## How database_id Works with Local vs Remote

The `wrangler.toml` contains the remote D1 `database_id`:

```toml
[[d1_databases]]
binding = "DB"
database_name = "peerloop-db"
database_id = "262985c0-3667-4f26-8dc5-0de789d50f33"  # Remote D1 in Cloudflare
```

**Key insight:** The `database_id` is only used when you explicitly request `--remote`. The command flag determines which database is used, not the presence of `database_id` in the config.

| Command | Database Used | Uses `database_id`? |
|---------|---------------|---------------------|
| `npm run db:migrate:local` | Local SQLite in `.wrangler/state/` | **No** - ignores it |
| `npm run db:migrate:remote` | Cloudflare D1 | **Yes** - connects to it |
| `wrangler dev` (default) | Local D1 emulation | **No** |
| `wrangler dev --remote` | Remote D1 | **Yes** |

**Implications for multi-machine development:**

- Both machines share the same `wrangler.toml` (checked into git)
- The `database_id` being present doesn't force remote usage
- Both machines can choose `--local` (faster, offline) or `--remote` (shared data)
- Local and remote databases are **completely separate** - they don't sync

**When to use each:**

| Scenario | Use |
|----------|-----|
| Rapid iteration, offline work | `--local` (either machine) |
| Testing with real Cloudflare behavior | `--remote` |
| Sharing data between machines | `--remote` (both use same DB) |
| Before deploying to production | `--remote` (validates against real D1) |

---

## NPM Scripts

```json
{
  "scripts": {
    "db:migrate:local": "wrangler d1 migrations apply peerloop-db --local",
    "db:migrate:remote": "wrangler d1 migrations apply peerloop-db --remote",
    "db:migrate:staging": "wrangler d1 migrations apply DB --env staging --remote",
    "db:studio:local": "wrangler d1 studio peerloop-db --local",
    "db:studio:remote": "wrangler d1 studio peerloop-db --remote",
    "db:studio:staging": "wrangler d1 studio DB --env staging --remote",
    "db:validate": "sqlite3 :memory: < migrations/0001_initial_schema.sql && echo 'SQL syntax valid'",
    "r2:list:local": "wrangler r2 object list peerloop-storage --local",
    "r2:list:remote": "wrangler r2 object list peerloop-storage --remote"
  }
}
```

| Script | MacMiniM4-Pro | MacMiniM4 | Purpose | Database |
|--------|---------------|-----------|---------|----------|
| `db:migrate:local` | Yes | Yes | Apply migrations locally | Local emulation |
| `db:migrate:remote` | Yes | Yes | Apply to production D1 | `peerloop-db` |
| `db:migrate:staging` | Yes | Yes | Apply to staging D1 | `peerloop-db-staging` |
| `db:studio:local` | Yes | Yes | Open D1 Studio | Local emulation |
| `db:studio:remote` | Yes | Yes | Open D1 Studio | `peerloop-db` |
| `db:studio:staging` | Yes | Yes | Open D1 Studio | `peerloop-db-staging` |
| `db:validate` | Yes | Yes | Validate SQL syntax | In-memory |
| `r2:list:local` | Yes | Yes | List R2 objects | Local emulation |
| `r2:list:remote` | Yes | Yes | List R2 objects | Cloudflare R2 |

---

## Quick Reference

### MacMiniM4-Pro (Full Support)

```bash
# Development
npm run dev                    # Full Cloudflare emulation
npm run dev:staging            # Dev server with remote staging D1
npm run db:migrate:local       # Apply migrations locally
npm run db:studio:local        # Open D1 Studio
npm run r2:list:local          # List R2 objects locally

# Production
npm run db:migrate:remote      # Apply to production D1
npm run r2:list:remote         # List R2 objects in production
```

### MacMiniM4 (Full Support)

```bash
# Development
npm run dev                    # Full Cloudflare emulation
npm run dev:staging            # Dev server with remote staging D1
npm run db:migrate:local       # Apply migrations locally
npm run db:studio:local        # Open D1 Studio
npm run r2:list:local          # List R2 objects locally

# Production
npm run db:migrate:remote      # Apply to production D1
npm run r2:list:remote         # List R2 objects in production
```

---

## Cloudflare Pages Deployment Configuration

Cloudflare Pages uses **wrangler.toml** for binding configuration. The `[env.preview]` section automatically applies to preview deployments (non-main branches).

### Environment Strategy

| Environment | Git Branch | D1 Database | wrangler.toml Section |
|-------------|------------|-------------|----------------------|
| **Production** | `main` | `peerloop-db` | Top-level `[[d1_databases]]` |
| **Preview** | Any other | `peerloop-db-staging` | `[[env.preview.d1_databases]]` |

### wrangler.toml Configuration

```toml
# Production (top-level = main branch)
[[d1_databases]]
binding = "DB"
database_name = "peerloop-db"
database_id = "21c0179a-9e7d-4cc1-91d5-ea402717fce8"

[[r2_buckets]]
binding = "STORAGE"
bucket_name = "peerloop-storage"

# Preview (automatically used for non-main branches)
[[env.preview.d1_databases]]
binding = "DB"
database_name = "peerloop-db-staging"
database_id = "605f1ab8-62cc-4934-a2fd-d828e188f50e"

[[env.preview.r2_buckets]]
binding = "STORAGE"
bucket_name = "peerloop-storage"
```

### How It Works

| wrangler.toml Section | Pages Environment | When Used |
|-----------------------|-------------------|-----------|
| Top-level bindings | Production | `main` branch deployments |
| `[env.preview]` | Preview | All other branch deployments |
| `[env.staging]` | N/A (CLI only) | `npm run db:migrate:staging` |

**Note:** The Dashboard shows "Bindings for this project are being managed through wrangler.toml" — this is correct! Pages reads bindings directly from the repo.

### Verification

After configuring bindings and deploying, verify the correct database is bound:

**Option 1: Check user count**
```bash
# Production (should show real user count once live)
curl https://peerloop.pages.dev/api/health/db

# Preview (should show 9 seed users)
curl https://your-branch.peerloop.pages.dev/api/health/db
```

**Option 2: Add temporary debug endpoint** (remove before launch)
```typescript
// src/pages/api/debug/env.ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ locals }) => {
  const db = locals.runtime?.env?.DB;
  if (!db) {
    return new Response(JSON.stringify({ error: 'No DB binding' }), { status: 500 });
  }

  const result = await db.prepare('SELECT COUNT(*) as count FROM users').first();

  return new Response(JSON.stringify({
    environment: import.meta.env.PROD ? 'production' : 'development',
    userCount: result?.count,
    // Don't expose database ID in production!
  }), {
    headers: { 'Content-Type': 'application/json' }
  });
};
```

### Complete Environment Matrix

| Environment | Branch | D1 Database | Configuration Method |
|-------------|--------|-------------|---------------------|
| Local (MacMiniM4-Pro) | Any | Local emulation | `wrangler --local` |
| Local (MacMiniM4) | Any | Local emulation | `wrangler --local` |
| Tests | Any | In-memory SQLite | better-sqlite3 |
| **Preview (Pages)** | Non-main | `peerloop-db-staging` | **Dashboard binding** |
| **Production (Pages)** | `main` | `peerloop-db` | **Dashboard binding** |

### Applying Migrations

Before deploying, ensure both databases have the latest migrations:

```bash
# Apply to staging (for preview deployments)
npm run db:migrate:staging

# Apply to production (for main branch)
npm run db:migrate:remote
```

Always apply migrations to staging first, verify the deployment works, then apply to production.

### CF Pages Build Environment (Test Detection)

Tests run during CF Pages builds on **Linux** (not macOS). The `CF_PAGES` env var documented by Cloudflare is **not reliably set** during the test phase. To detect CI in test helpers, use `process.platform !== 'darwin'` as the primary check.

See `tests/helpers/machine.ts` → `isCI()` for the implementation. The test header shows `Machine: CI` with platform info on CF builds, and hides the Wrangler D1 status line (irrelevant in CI).

*Added: Session 313 (2026-02-28)*

---

## Node.js Version

The project pins Node.js in two places:

| File | Value | Purpose |
|------|-------|---------|
| `.nvmrc` | `22.19.0` | CF Pages build + local nvm/asdf |
| `package.json` engines | `"node": "22.19.0"` | Enforces version match |

### Version Lifecycle

| Version | Status (Feb 2026) | CF Pages Support | EOL |
|---------|-------------------|:----------------:|-----|
| **Node 22** | LTS Maintenance | Yes | April 2027 |
| **Node 24** | Active LTS (24.13.1 "Krypton") | No (not in build image) | April 2028 |

**Current situation:** Node 22 triggers an informational warning during CF Pages builds ("LTS Maintenance mode") but is fully functional. Node 24 cannot be used because the CF Pages build image doesn't include it yet (users report `node-build: definition not found: 24`).

**When to upgrade:** Once Cloudflare adds Node 24 to their build image AND Astro 6.x officially supports it (currently supports 18.20.8+, 20.3.0+, 22.0.0+). Upgrade is a two-file change (`.nvmrc` + `package.json` engines).

---

## References

- [Cloudflare Workerd Requirements](https://github.com/cloudflare/workerd?tab=readme-ov-file#running-workerd)
- [Wrangler D1 Commands](https://developers.cloudflare.com/d1/wrangler-commands/)
- [Astro Cloudflare Adapter](https://docs.astro.build/en/guides/integrations-guide/cloudflare/)
- [Cloudflare Pages Bindings](https://developers.cloudflare.com/pages/functions/bindings/)
- [Cloudflare Pages D1 Integration](https://developers.cloudflare.com/d1/get-started/#4-bind-your-worker-to-your-d1-database)
