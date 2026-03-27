# env-vars-secrets.md

**Topic:** Environment Variables & Secrets Management
**Source:** Session 204, updated Session 207 (2026-02-06)
**Status:** Active

---

## Overview

This document is the **master reference** for all environment variables and secrets in Peerloop. It answers: *what do I need, where does each value live, and what's actually secret?*

For vendor-specific SDK usage and code examples, see the individual tech docs (cross-referenced below).

---

## File Layout

| File | Git | Purpose | Auto-loaded? |
|------|:---:|---------|:------------:|
| `.dev.vars` | gitignored | All dev env vars (secrets + non-secrets), per-machine | Yes (wrangler dev) |
| `.env` | gitignored | **Symlink → `.dev.vars`** — lets Vite's `loadEnv()` read the same values | Yes (Vite/Astro config) |
| `.secrets.cloudflare.production` | gitignored | Secrets for CF Dashboard **Production** tab | No — reference only |
| `.secrets.cloudflare.preview` | gitignored | Secrets for CF Dashboard **Preview** tab | No — reference only |
| `.dev.vars.example` | committed | Template for new dev setup | No — copy to `.dev.vars` |
| `wrangler.toml` | committed | D1/R2 bindings + non-secret `[vars]` per environment | Yes |

### Why `.env` is a symlink to `.dev.vars`

Two separate runtimes need env vars during local development, and each has its own convention:

| Runtime | Convention | Reads from |
|---------|-----------|------------|
| **Wrangler** (Cloudflare Workers) | `.dev.vars` | `.dev.vars` directly |
| **Vite** (Astro build config) | `.env` | `.env` via `loadEnv()` |

The symlink `.env → .dev.vars` bridges this — one source of truth, two consumers. Without it, you'd maintain two copies of the same values.

**Sole consumer:** `astro.config.mjs` calls `loadEnv(mode, process.cwd(), '')` to load all vars into `process.env`. The `''` third argument is critical — it tells Vite to load all vars, not just `VITE_`-prefixed ones. This is used for build-time decisions only (e.g., `USE_STAGING_DB` to enable remote D1 proxy).

At request time, application code in `src/` never uses `process.env`. It reads from `locals.runtime.env` via `getEnv()`.

### Why non-secrets are in both `.dev.vars` and `wrangler.toml`

CF Pages dashboard only allows encrypted secrets when `wrangler.toml` exists — non-secrets **must** be in `wrangler.toml [vars]` to reach Cloudflare. Locally, `.dev.vars` values override `wrangler.toml [vars]`, so the dev values always win.

### How values reach your code

```
Local dev (npm run dev):
  wrangler.toml [vars]  ──┐
                           ├──▶  locals.runtime.env.KEY  (request-time, src/ code)
  .dev.vars (overrides)  ─┘
  .env (symlink → .dev.vars) ──▶  process.env.KEY  (build-time, astro.config.mjs only)

Cloudflare Preview:
  wrangler.toml [env.preview.vars]  ──┐
                                       ├──▶  env.KEY
  CF Dashboard secrets (encrypted)  ──┘

Cloudflare Production:
  wrangler.toml [env.production.vars]  ──┐
                                          ├──▶  env.KEY
  CF Dashboard secrets (encrypted)  ─────┘
```

All values are accessed via `getEnv(locals, 'KEY')` from `src/lib/env.ts`, which reads from `locals.runtime.env`. Both dev machines use the Cloudflare adapter.

---

## Variable Sources by Environment

The tables below show exactly **which file** supplies each variable in each environment. This is the single place to answer: *"where does this value actually come from when my code runs?"*

### Quick Overview

| | **MacMiniM4-Pro (local)** | **MacMiniM4 (local)** | **Preview (CF)** | **Production (CF)** |
|---|---|---|---|---|
| **Triggered by** | `npm run dev` | `npm run dev` | Push non-main branch | Push to `main` |
| **Non-secrets source** | `.dev.vars` (overrides `wrangler.toml`) | `.dev.vars` (overrides `wrangler.toml`) | `wrangler.toml [env.preview.vars]` | `wrangler.toml [env.production.vars]` |
| **Secrets source** | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview tab) | CF Dashboard (Production tab) |
| **D1 database** | Local SQLite (`.wrangler/state/`) | Local SQLite (`.wrangler/state/`) | Remote `peerloop-db-staging` | Remote `peerloop-db` |
| **R2 bucket** | Local emulation | Local emulation | `peerloop-storage-staging` | `peerloop-storage` |
| **Stripe mode** | Test (`pk_test_`, `sk_test_`) | Test (`pk_test_`, `sk_test_`) | Test (`pk_test_`, `sk_test_`) | Live (`pk_live_`, `sk_live_`) |
| **Stream.io app** | Dev app (1457190) | Dev app (1457190) | Dev app (1457190) | Prod app (1456912) |
| **How code reads vars** | `locals.runtime.env` | `locals.runtime.env` | `env.KEY` | `env.KEY` |

### Bindings (D1 and R2 — not string variables)

| Variable | MacMiniM4-Pro | MacMiniM4 | Preview (CF) | Production (CF) |
|----------|---------------|-----------|--------------|-----------------|
| `DB` (D1) | `wrangler.toml` top-level (local SQLite) | `wrangler.toml` top-level (local SQLite) | `wrangler.toml [env.preview.d1_databases]` → staging DB | `wrangler.toml [env.production.d1_databases]` → prod DB |
| `STORAGE` (R2) | `wrangler.toml` top-level (local emulation) | `wrangler.toml` top-level (local emulation) | `wrangler.toml [env.preview.r2_buckets]` → `peerloop-storage-staging` | `wrangler.toml [env.production.r2_buckets]` → `peerloop-storage` |

### Secrets

| Variable | MacMiniM4-Pro | MacMiniM4 | Preview (CF) | Production (CF) |
|----------|---------------|-----------|--------------|-----------------|
| `JWT_SECRET` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |
| `STRIPE_SECRET_KEY` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |
| `STRIPE_WEBHOOK_SECRET` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |
| `STREAM_API_SECRET` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |
| `BBB_SECRET` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |
| `RESEND_API_KEY` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |
| `GOOGLE_CLIENT_SECRET` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |
| `GITHUB_CLIENT_SECRET` | `.dev.vars` | `.dev.vars` | CF Dashboard (Preview) | CF Dashboard (Production) |

### Non-Secrets

| Variable | MacMiniM4-Pro | MacMiniM4 | Preview (CF) | Production (CF) |
|----------|---------------|-----------|--------------|-----------------|
| `STRIPE_PUBLISHABLE_KEY` | `.dev.vars` | `.dev.vars` | `wrangler.toml [env.preview.vars]` | `wrangler.toml [env.production.vars]` |
| `STREAM_API_KEY` | `.dev.vars` | `.dev.vars` | `wrangler.toml [env.preview.vars]` | `wrangler.toml [env.production.vars]` |
| `STREAM_APP_ID` | `.dev.vars` | `.dev.vars` | `wrangler.toml [env.preview.vars]` | `wrangler.toml [env.production.vars]` |
| `GOOGLE_CLIENT_ID` | `.dev.vars` | `.dev.vars` | `wrangler.toml [env.preview.vars]` | `wrangler.toml [env.production.vars]` |
| `GITHUB_CLIENT_ID` | `.dev.vars` | `.dev.vars` | `wrangler.toml [env.preview.vars]` | `wrangler.toml [env.production.vars]` |
| `BBB_URL` | `.dev.vars` | `.dev.vars` | `wrangler.toml [env.preview.vars]` | `wrangler.toml [env.production.vars]` |

### Dev-Only Variables (not needed on Cloudflare)

| Variable | MacMiniM4-Pro | MacMiniM4 | Preview (CF) | Production (CF) |
|----------|---------------|-----------|--------------|-----------------|
| `CLOUDFLARE_ACCOUNT_ID` | `.dev.vars` (for remote D1/R2 ops) | `.dev.vars` (for remote D1/R2 ops) | N/A | N/A |
| `CLOUDFLARE_API_TOKEN` | `.dev.vars` (for remote D1/R2 ops) | `.dev.vars` (for remote D1/R2 ops) | N/A | N/A |
| `FEATURE_VIDEO_SESSIONS` | `.dev.vars` (optional) | `.dev.vars` (optional) | N/A | N/A |
| `FEATURE_COMMUNITY_FEED` | `.dev.vars` (optional) | `.dev.vars` (optional) | N/A | N/A |

### Footnotes

**Non-secret override:** On both dev machines, non-secrets exist in *both* `.dev.vars` and `wrangler.toml [vars]`. Wrangler loads both, but `.dev.vars` **overrides** `wrangler.toml`. This matters because `.dev.vars` has dev values (e.g., Stream dev app `tgzt4vdwm9cb`) while `wrangler.toml` top-level has prod values (`axpepvxpb6v2`). The override ensures you always hit dev services locally.

### How the Override Chain Works

```
Local dev (both machines):
  wrangler.toml [vars]   -->  STREAM_API_KEY = "axpepvxpb6v2" (prod value)
  .dev.vars              -->  STREAM_API_KEY = "tgzt4vdwm9cb" (dev value)  <-- WINS
  Result: dev value used

Preview (CF):
  wrangler.toml [env.preview.vars]  -->  STREAM_API_KEY = "tgzt4vdwm9cb" (dev value)
  CF Dashboard secrets              -->  STREAM_API_SECRET = (dev app secret)
  Result: dev values used

Production (CF):
  wrangler.toml [env.production.vars]  -->  STREAM_API_KEY = "axpepvxpb6v2" (prod value)
  CF Dashboard secrets                 -->  STREAM_API_SECRET = (prod app secret)
  Result: prod values used
```

### Key Design Decisions

1. **Non-secret duplication is intentional.** `.dev.vars` has non-secrets for local dev (with dev-app values). `wrangler.toml` has them for Cloudflare deployment (with per-environment values). Same variable names, often different values.

2. **Secrets can never appear in `wrangler.toml`** because it's committed to git. The CF Dashboard is the only path for secrets to reach Preview and Production. `.secrets.cloudflare.production` and `.secrets.cloudflare.preview` exist as gitignored local references — one per CF Dashboard tab — for the values you enter into the dashboard.

3. **Separate vendor apps for dev vs prod** (Stream.io app 1457190 vs 1456912, Stripe test vs live mode) means you can never accidentally send test data to production or charge real cards during development.

4. **`wrangler.toml` environments are non-inheritable.** `[vars]`, `[[d1_databases]]`, and `[[r2_buckets]]` in child environments (`[env.preview]`, `[env.production]`) do NOT inherit from the top-level — every environment must redeclare all bindings. This is why `wrangler.toml` has the same D1/R2/vars blocks repeated three times.

---

## Master Variable Reference

### Secrets

| Variable | Vendor | Why it's secret | Tech doc |
|----------|--------|-----------------|----------|
| `JWT_SECRET` | Internal | Signs auth tokens — leaked = forged sessions | — |
| `STRIPE_SECRET_KEY` | Stripe | Full API access to Stripe account | [stripe](../vendors/stripe.md) |
| `STRIPE_WEBHOOK_SECRET` | Stripe | Verifies webhook signatures — leaked = forged payment events | [stripe](../vendors/stripe.md) |
| `STREAM_API_SECRET` | Stream.io | Server-side feed control | [stream](../vendors/stream.md) |
| `RESEND_API_KEY` | Resend | Email sending access | [resend](../vendors/resend.md) |
| `GOOGLE_CLIENT_SECRET` | Google | OAuth token exchange | [google-oauth](../vendors/google-oauth.md) |
| `GITHUB_CLIENT_SECRET` | GitHub | OAuth token exchange | — |

### Non-Secrets

| Variable | Vendor | Why it's not secret | Tech doc |
|----------|--------|---------------------|----------|
| `STRIPE_PUBLISHABLE_KEY` | Stripe | Designed for client-side JS (`pk_` prefix) | [stripe](../vendors/stripe.md) |
| `STREAM_API_KEY` | Stream.io | Used in client-side feed SDK | [stream](../vendors/stream.md) |
| `STREAM_APP_ID` | Stream.io | Public app identifier | [stream](../vendors/stream.md) |
| `GOOGLE_CLIENT_ID` | Google | Embedded in OAuth redirect URLs, visible in browser | [google-oauth](../vendors/google-oauth.md) |
| `GITHUB_CLIENT_ID` | GitHub | Embedded in OAuth redirect URLs, visible in browser | — |

### Dev-Only (not needed on Cloudflare)

| Variable | Purpose | Which machine |
|----------|---------|---------------|
| `CLOUDFLARE_ACCOUNT_ID` | CF credentials for remote D1/R2 operations | Any (for `--remote` commands) |
| `CLOUDFLARE_API_TOKEN` | CF credentials for remote D1/R2 operations | Any (for `--remote` commands) |
| `FEATURE_VIDEO_SESSIONS` | Override feature flag | Any (optional) |
| `FEATURE_COMMUNITY_FEED` | Override feature flag | Any (optional) |

---

## Per-Environment Values

Some vendors have separate dev and production apps/keys.

### Stripe

| | Dev / Preview | Production |
|-|---------------|------------|
| Publishable key | `pk_test_...` | `pk_live_...` |
| Secret key | `sk_test_...` | `sk_live_...` |
| Webhook secret | test `whsec_...` | live `whsec_...` |
| Mode | Test mode — no real charges | Live mode |

### Stream.io

| | Dev / Preview (app 1457190) | Production (app 1456912) |
|-|-----------------------------|--------------------------|
| API key | `tgzt4vdwm9cb` | `axpepvxpb6v2` |
| App ID | `1457190` | `1456912` |
| API secret | dev app secret | prod app secret |

### Resend

| | Dev | Production |
|-|-----|------------|
| API key | `re_Pzge...` | `re_ZpBp...` |

### OAuth (Google & GitHub)

| | Dev | Production |
|-|-----|------------|
| Client ID | Same or separate | Same or separate |
| Client secret | dev secret | prod secret |

Dev values are in `.dev.vars`. Production values are in `.secrets.cloudflare.production` and the CF dashboard. Preview values are in `.secrets.cloudflare.preview`.

---

## Dev Machine Differences

See [devcomputers.md](devcomputers.md) for full machine details.

| | MacMiniM4-Pro (64GB) | MacMiniM4 (24GB) |
|-|----------------------|-------------------|
| Adapter | Cloudflare (wrangler) | Cloudflare (wrangler) |
| D1 | Native binding (local) | Native binding (local) |
| R2 | Native binding (local) | Native binding (local) |
| `npm run db:setup` | `npm run db:setup:local:dev` | `npm run db:setup:local:dev` |

Both machines have identical capabilities. The `.dev.vars` file is the same on both.

---

## Deploying to Cloudflare

### Non-secrets (automatic via git)

Non-secrets are in `wrangler.toml [vars]` per environment. They deploy automatically with every git push — no manual steps needed.

**Why they must be in wrangler.toml:** When a `wrangler.toml` exists, the CF Pages dashboard only allows adding encrypted secrets. Plain-text environment variables can only come from the wrangler file.

### Secrets (CF dashboard)

**Recommended: Use the Cloudflare dashboard for all secrets.**

Peerloop is a Cloudflare **Pages** project. While `wrangler pages secret put` exists, it only supports production — there's no `--env` flag for preview ([known Pages limitation](https://github.com/cloudflare/wrangler-action/issues/354)). To avoid two different workflows, manage all secrets through the dashboard:

1. Go to **Cloudflare Dashboard** → Pages → peerloop → Settings → Environment Variables
2. Select the environment tab (**Production** or **Preview**)
3. Add the variable and click **Encrypt** to mark it as a secret
4. Repeat for each secret, in both environments

Secrets to set (copy values from `.secrets.cloudflare.production` for Production, `.secrets.cloudflare.preview` for Preview):

| Secret | Preview value | Production value |
|--------|---------------|------------------|
| `JWT_SECRET` | Same for both | Same for both |
| `STRIPE_SECRET_KEY` | `sk_test_...` | **Deferred until go-live** |
| `STRIPE_WEBHOOK_SECRET` | test `whsec_...` | **Deferred until go-live** |
| `STREAM_API_SECRET` | dev app secret | prod app secret |
| `RESEND_API_KEY` | dev key | prod key |
| `GOOGLE_CLIENT_SECRET` | Same for both | Same for both |
| `GITHUB_CLIENT_SECRET` | Same for both | Same for both |

> **Stripe Production secrets are intentionally deferred.** Do NOT add `STRIPE_SECRET_KEY` or `STRIPE_WEBHOOK_SECRET` to CF Production until MVP go-live. This prevents accidental real charges during development. Live Stripe values are stored in `.secrets.cloudflare.production` for reference. Adding them to the CF Dashboard is a go-live checklist item.

> **CLI alternative (production only):** If you prefer the CLI for production secrets, you can use `wrangler pages secret put KEY --project peerloop` — it will prompt for the value interactively. But you'll still need the dashboard for preview secrets, so the dashboard-for-everything approach is simpler.

#### Verify what's set

```bash
wrangler pages secret list --project peerloop
```

---

## How to Tell If Something Is Secret

A quick mental model for any new vendor integration:

| Signal | Not secret | Secret |
|--------|-----------|--------|
| Name contains | `publishable`, `public`, `client_id`, `app_id` | `secret`, `private`, `webhook` |
| Key prefix | `pk_` (Stripe) | `sk_` (Stripe) |
| Used in | Client-side JS, browser URLs, OAuth redirects | Server-side only |
| If leaked | No risk — vendor designed it to be public | Full API access, token forging, or impersonation |

---

## Type Definitions

All environment variables are declared in `src/env.d.ts`:

```typescript
interface Env {
  DB: D1Database;
  STORAGE: R2Bucket;
  JWT_SECRET: string;
  GOOGLE_CLIENT_ID?: string;
  GOOGLE_CLIENT_SECRET?: string;
  GITHUB_CLIENT_ID?: string;
  GITHUB_CLIENT_SECRET?: string;
  STRIPE_SECRET_KEY?: string;
  STRIPE_PUBLISHABLE_KEY?: string;
  STRIPE_WEBHOOK_SECRET?: string;
  STREAM_API_KEY?: string;
  STREAM_API_SECRET?: string;
  STREAM_APP_ID?: string;
  RESEND_API_KEY?: string;
}
```

When adding a new vendor, add its variables here first.

---

## Checklist: Adding a New Vendor

1. **Identify** which keys are public vs secret (see mental model above)
2. **Add to `src/env.d.ts`** — declare the types
3. **Add to `.dev.vars`** and `.dev.vars.example` — all dev values (secrets + non-secrets)
4. **Add to `.secrets.cloudflare.production`** and **`.secrets.cloudflare.preview`** — secret values for each environment
5. **Non-secrets** → add to `wrangler.toml` `[vars]`, `[env.production.vars]`, and `[env.preview.vars]`
6. **Secrets** → add to CF dashboard for both Preview and Production (click Encrypt)
7. **Document** — create or update the vendor's tech doc with code examples
8. **Cross-reference** — add a row to the Master Variable Reference table above
