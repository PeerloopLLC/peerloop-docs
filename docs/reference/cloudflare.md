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

### Discovering the Workers.dev Subdomain (Conv 141)

The `.workers.dev` URL for a Worker is `<worker-name>.<account-subdomain>.workers.dev`. The subdomain is separate from the account name/email and is **not** shown by `wrangler whoami`. Query the CF API to find it:

```bash
TOKEN=$(grep '^CLOUDFLARE_API_TOKEN=' .dev.vars | cut -d= -f2-)
ACCOUNT_ID=$(grep '^CLOUDFLARE_ACCOUNT_ID=' .dev.vars | cut -d= -f2-)
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/subdomain" | jq -r '.result.subdomain'
```

For this project the subdomain is `brian-1dc`, so staging is `https://peerloop-staging.brian-1dc.workers.dev`.

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

**Upgrade path:** When CF Pages adds Node 24 support, update `.nvmrc` and `package.json` engines. Verify Astro 6.x compatibility first (officially supports Node 18.20.8+, 20.3.0+, 22.0.0+; Astro 6 dropped Node 18 from official support).

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

**Fix:** Add Vite alias in `astro.config.mjs` (see docs/reference/reactjs.md for details):
```javascript
vite: {
  resolve: {
    alias: import.meta.env.PROD && {
      'react-dom/server': 'react-dom/server.edge',
    },
  },
}
```

#### Astro 6 + Adapter 13: Workers (not Pages)

**Historical context (Conv 113-114):** Astro 6 shipped with `@astrojs/cloudflare@13`, which targets **Cloudflare Workers with Static Assets**, not Cloudflare Pages. The Astro maintainer confirmed: *"Astro 6 doesn't support Pages, because the Cloudflare Vite plugin does not."* ([Issue #16107](https://github.com/withastro/astro/issues/16107))

Conv 113 attempted a postbuild-patch workaround to keep deploying to Pages; the build passed but CF Pages silently skipped the Worker entrypoint, so every SSR route returned 404. Conv 114 migrated the deploy target to Workers — see §"Cloudflare Workers Deployment" below. The workaround script (`scripts/fix-pages-wrangler.mjs`) was removed.

**Current setup:** The root `wrangler.toml` holds bindings and env overrides. The adapter emits `dist/server/wrangler.json` with `main` + `[assets]` at build time. `wrangler deploy` reads the generated file via `.wrangler/deploy/config.json`.

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

> **Decision Pending:** D1 + Durable Objects is one option for PeerLoop messaging. See `docs/as-designed/messaging.md` for comparison with Stream Chat.

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

**Caveat (Session 359):** The reset script drops tables but not indexes. If the batch drop fails partway (circular FK dependency), orphaned indexes survive and block re-migration. See `docs/as-designed/migrations.md` "Remote Reset Caveats" for details and recovery steps.

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
// In API routes or Astro pages — use the centralized helper.
// Direct reads of locals.runtime?.env are forbidden and throw under @astrojs/cloudflare@13.
import { getR2 } from '@lib/r2';

const r2 = getR2(locals); // throws if STORAGE binding missing

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

Workers provide serverless compute at Cloudflare's edge. **PeerLoop deploys the entire app (SSR pages + API routes + static assets) as a single Worker** via `@astrojs/cloudflare@13`.

### Deployment (current)

Since Conv 114 (CF-WORKERS migration), deploy is manual via `wrangler deploy`:

| Target | Command | Result |
|---|---|---|
| Staging | `npm run deploy:staging` | Worker `peerloop-staging` at `peerloop-staging.<account>.workers.dev` |
| Production | `npm run deploy:prod` | Worker `peerloop` (requires `scripts/confirm-prod.js` confirmation) |

GitHub Actions auto-deploy is deferred (see PLAN.md §DEPLOYMENT follow-up).

### Branch-to-deployment mapping (mental model shift from Pages)

**Pages had built-in GitHub integration**: pushing any branch auto-created a deployment. `main` → production; any other branch → `<branch>.peerloop.pages.dev` preview. Branch = deployment, 1:1, automatic.

**Workers has no Git integration by default.** Git branches are pure Git state; Workers exist only when `wrangler deploy` is run. The deployment unit is the **Worker name** (`peerloop`, `peerloop-staging`), not the branch.

| Aspect | Pages | Workers |
|---|---|---|
| Deploy trigger | Git push | `wrangler deploy` command |
| Who watches Git | CF Pages GitHub App | Nothing (until GH Actions is set up) |
| Deployment unit | Branch | Worker name |
| Per-branch preview URL | Automatic | Not available (would need custom CI) |
| Production URL | Custom domain → Pages | Custom domain → Workers Routes |
| Environment selection | Automatic from branch name | `CLOUDFLARE_ENV` at build time |

**Today's workflow (manual deploy, CF-WORKERS complete):**
- Work on feature branches (e.g., `jfg-dev-N`) — no URL, local testing only
- Merge to `staging` → someone runs `npm run deploy:staging`
- Merge to `main` → (after prod cutover) someone runs `npm run deploy:prod`

**After DEPLOYMENT.GHACTIONS ships:** a GitHub Actions workflow will restore the branch-trigger UX, but as **explicit CI config** — not platform magic. Sketch:

```yaml
# .github/workflows/deploy.yml
on:
  push:
    branches: [staging, main]
jobs:
  deploy:
    steps:
      - if: github.ref == 'refs/heads/staging'
        run: npm run deploy:staging
      - if: github.ref == 'refs/heads/main'
        run: npm run deploy:prod
```

**Testing a feature branch on the Worker platform:** options are (a) local dev against staging D1 (`npm run dev:staging`), (b) manually deploy the branch to `peerloop-staging` — overwrites whatever's there, coordinate with the team, or (c) set up per-branch Workers via custom CI (uncommon).

### Version-specific "preview URLs" (different from Pages "branch previews")

Workers supports its own preview-URL feature: each deploy to a Worker gets a unique per-version URL (e.g., `<version-id>-peerloop-staging.brian-1dc.workers.dev`). This is a **version** affordance, not a branch one — it's the same Worker, just a way to hit a historical deploy without making it primary. Configured per-env in `wrangler.toml`:

| Env | `preview_urls` | Reason |
|---|---|---|
| Top-level + `[env.production]` | `false` | Never expose prod bindings on guessable URLs |
| `[env.staging]` | `true` | Useful for testing a specific deploy before it becomes primary |


**Important build-time behavior:** The adapter selects an environment at **build time** via `CLOUDFLARE_ENV` (read by `@cloudflare/vite-plugin`), flattening the chosen `[env.<name>]` overrides from `wrangler.toml` into `dist/server/wrangler.json`. At deploy time, wrangler redirects to that flattened file via `.wrangler/deploy/config.json` — so `wrangler deploy --env staging` is a **no-op**; the env is already baked in. This is why the npm scripts prefix both `CLOUDFLARE_ENV` and `ENVIRONMENT`:

```json
"deploy:staging": "CLOUDFLARE_ENV=staging ENVIRONMENT=staging npm run build && wrangler deploy"
```

- `CLOUDFLARE_ENV` — picks the `[env.staging]` section of `wrangler.toml` for bindings
- `ENVIRONMENT` — injected into the client/server bundle as `__ENVIRONMENT__` via Vite define (consumed by `src/lib/version.ts::getEnvironment()`)

### `wrangler.toml` shape

Root `wrangler.toml` contains bindings, vars, per-env overrides, and `[assets]` blocks — but **no `main`**. The adapter writes `main` (and duplicates `[assets]`) into `dist/server/wrangler.json`:

```toml
name = "peerloop"
compatibility_date = "2024-12-01"
compatibility_flags = ["nodejs_compat_v2", "enable_nodejs_http_modules"]

# Top-level = production defaults
[assets]
binding = "ASSETS"
directory = "./dist/client"
run_worker_first = ["/api/*"]  # defensive hygiene — see §SSR self-fetch pitfall below

[[d1_databases]]      # DB = peerloop-db (prod)
[[r2_buckets]]        # STORAGE = peerloop-storage (prod)
[[kv_namespaces]]     # SESSION = <prod id>

# Env overrides (non-inheritable — must repeat [assets], d1, r2, kv per env)
[env.staging]
name = "peerloop-staging"
[env.staging.assets]
binding = "ASSETS"
directory = "./dist/client"
run_worker_first = ["/api/*"]
[[env.staging.d1_databases]]   # DB = peerloop-db-staging
[[env.staging.r2_buckets]]     # STORAGE = peerloop-storage-staging
[[env.staging.kv_namespaces]]  # SESSION = <staging id>
[env.staging.vars]             # ENVIRONMENT = "staging"
```

Why keep `main` out of the root? The `@cloudflare/vite-plugin` validates `main` points to an existing file at config-resolution time — but `dist/server/entry.mjs` doesn't exist until after the build. The adapter emits `main` into `dist/server/wrangler.json`, which wrangler reads via `.wrangler/deploy/config.json` at deploy time. `[assets]` can safely live in both — the generated file wins.

### SSR self-fetch pitfall (Workers + Static Assets)

**The issue:** On Workers, Static Assets sit in front of the Worker in a two-layer routing model. When an SSR `.astro` page does `await fetch(new URL('/api/...', Astro.url.origin))`, the subrequest **does not fall through to the Worker** — the Assets layer catches it and returns a plain-text 404. This happens even when the same path works for external requests and even with `run_worker_first = ["/api/*"]` or `= true` configured. `run_worker_first` only affects CF's external-edge routing; it has **zero effect on Worker-internal subrequests**.

Pages didn't have this problem because Pages used single-layer routing (every request hit the SSR Function). The bug therefore only surfaces post-migration and only on deployed Workers — `npm run dev` (miniflare + Vite) doesn't emulate the two-layer model accurately enough to catch it.

**The fix:** Don't self-fetch. Import data-loader functions directly (see `docs/reference/DEVELOPMENT-GUIDE.md` §SSR Data Loaders). API endpoints that need browser-reachability should be thin wrappers around the same loaders. Alternative would be a `[[services]] binding = "SELF"` self-binding — rejected for Peerloop because direct loaders also eliminate the HTTP round-trip and give end-to-end type safety. Conv 116 [SF] refactored 8 community/discover pages + 3 API handlers onto this pattern; `run_worker_first = ["/api/*"]` was kept in wrangler.toml as defensive hygiene against future external-route asset shadowing.

**Verification after any CF adapter migration:** smoke-test every `.astro` page that does HTTP-style data loading against deployed staging. Unit tests and dev server will not catch this class of regression.

### Secrets (encrypted variables)

Unlike Pages — which conflated "env vars" and "secrets" in one dashboard panel — Workers enforces a strict split:

- **`[vars]` in `wrangler.toml`** — public values, committed to git (publishable keys, app IDs, URLs)
- **Secrets** — encrypted at rest, set out-of-band via `wrangler secret put/bulk` or the CF Dashboard → Worker → Settings → Variables and Secrets

Pushing secrets from `.dev.vars` to a new Worker (used when `peerloop-staging` was first provisioned, will be used again for `peerloop` prod):

```bash
# Extract the required secret keys from .dev.vars into a JSON file
node -e '
  const fs = require("fs");
  const needed = ["JWT_SECRET","BBB_SECRET","RESEND_API_KEY",
                  "STRIPE_SECRET_KEY","STRIPE_WEBHOOK_SECRET","STREAM_API_SECRET"];
  const out = {};
  for (const line of fs.readFileSync(".dev.vars","utf8").split("\n")) {
    const m = line.match(/^([A-Z_]+)\s*=\s*(.*)$/);
    if (m && needed.includes(m[1])) out[m[1]] = m[2].trim().replace(/^["'"'"']|["'"'"']$/g,"");
  }
  fs.writeFileSync("/tmp/secrets.json", JSON.stringify(out));
'

# Upload (note: use --name directly, NOT --env, because legacy_env: true
# in the adapter config would cause --env staging to double-suffix the name)
./node_modules/.bin/wrangler secret bulk /tmp/secrets.json --name peerloop-staging

# Clean up
rm /tmp/secrets.json
```

**Gotcha — `legacy_env: true`:** The adapter-generated `dist/server/wrangler.json` sets `legacy_env: true`, which changes the semantics of `--env staging`: with legacy envs, `--env staging` appends `-staging` to the worker name. So `wrangler secret bulk --name peerloop-staging --env staging` resolves to `peerloop-staging-staging`, creating an empty stub Worker. Use `--name peerloop-staging` alone (no `--env`) for secret operations. For `wrangler deploy`, the correct Worker name is already baked into `dist/server/wrangler.json` via `CLOUDFLARE_ENV=staging` at build time, so deploy commands also omit `--env`.

Listing existing secrets (shows names only, never values):

```bash
./node_modules/.bin/wrangler secret list --name peerloop-staging
```

### Tailing logs

```bash
npm run cf:tail:staging    # wrangler tail --env staging  (merges nothing — kept for symmetry)
npm run cf:tail:prod
```

Note: `wrangler tail` works against the deployed Worker name from the CLI args, not from the config-resolved env. So `wrangler tail` targets prod `peerloop` and `wrangler tail --env staging` targets `peerloop-staging` by name-suffixing via legacy_env.

#### Wrangler tail double-suffix pitfall (Conv 141)

When a `[env.staging]` block already sets `name = "peerloop-cron-staging"`, passing BOTH `--env staging` AND the explicit worker name causes wrangler to append `-staging` again, yielding `peerloop-cron-staging-staging`. **Use one or the other — not both:**

```bash
# ✅ CORRECT — let env name lookup resolve the Worker
wrangler tail --env staging --config workers/cron/wrangler.toml

# ✅ CORRECT — explicit name, no --env
wrangler tail peerloop-cron-staging --config workers/cron/wrangler.toml

# ❌ WRONG — double-suffix: resolves to peerloop-cron-staging-staging
wrangler tail peerloop-cron-staging --env staging --config workers/cron/wrangler.toml
```

The npm scripts (`cf:tail:cron:staging`, `cf:tail:cron:prod`) use the `--env` form only.

---

## Standalone Cron Worker (`workers/cron/`)

### Why a Separate Worker

`@astrojs/cloudflare@13`'s public `Options` type does not expose `workerEntryPoint`. Adding a `scheduled()` handler to the Astro Worker entry is not cleanly supported. The durable solution is a **separate standalone Worker** that shares bindings with the main Worker.

**Pattern:** For any Astro+CF project needing cron handlers:
- Deploy a standalone Worker at `workers/<name>/` with its own `wrangler.toml`
- Share D1/R2/KV bindings via binding IDs (same IDs, both Workers)
- Share business logic via `src/lib/*.ts` modules that both Workers import
- Configure the standalone Worker's `tsconfig.json` to include `src/env.d.ts` so `App.Locals` and `Cloudflare.Env` augmentations resolve

### Structure

```
Peerloop/
└── workers/
    └── cron/
        ├── wrangler.toml   # standalone config: staging (*/15) + production (*/30) envs
        ├── tsconfig.json   # extends root; includes src/env.d.ts + shared lib files
        └── src/
            └── index.ts    # scheduled() handler → runSessionCleanup(db, bbb)
```

### Shared Logic Pattern

Extract orchestration into a pure `src/lib/*.ts` module accepting dependencies as parameters. Both the HTTP endpoint and the cron Worker call the same function:

```typescript
// src/lib/cleanup.ts
export async function runSessionCleanup(db: D1Database, bbb: VideoProvider): Promise<CleanupSummary>

// src/pages/api/admin/sessions/cleanup.ts  — HTTP handler, 53 lines
// workers/cron/src/index.ts               — scheduled() handler, ~40 lines
// Both call runSessionCleanup(db, bbb)
```

`CleanupSummary` fields: `no_shows`, `orphaned_completed` (Conv 142 — BBB-authoritative attendance-aware pass), `auto_completed`, `bbb_reconciled`, `counts`, `errors`.

### Deployment

```bash
# Staging (first deploy — also sets BBB_SECRET)
npm run deploy:cron:staging
printf "%s" "$BBB_SECRET" | wrangler secret put BBB_SECRET --env staging --config workers/cron/wrangler.toml

# Production (requires confirm-prod.js confirmation)
npm run deploy:cron:prod
printf "%s" "$BBB_SECRET" | wrangler secret put BBB_SECRET --env production --config workers/cron/wrangler.toml
```

**Secret injection note:** Pipe the secret value via `printf "%s" "$VAR" | wrangler secret put ...` — never echo or inline the value to avoid shell history leakage.

### Cron Schedule

| Env | Schedule | Worker Name |
|-----|----------|-------------|
| Staging | `*/15 * * * *` | `peerloop-cron-staging` |
| Production | `*/30 * * * *` | `peerloop-cron` |

Staging fires more frequently for faster feedback during verification. Production balances freshness against D1 + BBB API cost (most missed webhooks are caught within 30 min of `scheduled_end`).

### First Run (Conv 141 — 2026-04-21T09:30:35Z)

The first scheduled firing on staging recovered a **real** orphaned `recording_ready` webhook from prior staging activity — not a synthesized test. Session `ff1eb239-2ff6-4579-9e70-fa0272b543d3` had a missing recording URL that the cron backfilled on its first run. Elapsed: 1181ms, cpuTime: 7ms, 0 errors, 1 no-show detected + 1 recording recovered.

### API Routes

PeerLoop API routes run as Workers via Astro's Cloudflare adapter.

### Durable Objects

Durable Objects provide stateful coordination for WebSocket connections.

> **Messaging Use Case:** If custom messaging is chosen (see `docs/as-designed/messaging.md`), Durable Objects would coordinate real-time message delivery via WebSockets.

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
