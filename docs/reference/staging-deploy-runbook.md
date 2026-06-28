# Staging Deploy Runbook

**Category:** manual (operational procedure — hand-maintained, no automated drift check)
**Reference (why/gotchas):** [`cloudflare.md` §Cloudflare Workers](./cloudflare.md#cloudflare-workers) — this runbook is the *how*; cloudflare.md is the *why*.
**Tracked in PLAN.md:** [plan/deployment/README.md](../../plan/deployment/README.md) (DEPLOYMENT block).

A linear, copy-pasteable procedure for deploying the Peerloop app to **staging** (`peerloop-staging` Worker at `https://peerloop-staging.brian-1dc.workers.dev`, D1 `peerloop-db-staging`). Staging is the project's **only** deploy target — production is gated behind MVP-GOLIVE; **never** run `deploy:prod` / `deploy:cron:prod` as part of a feature push (see `memory/feedback_staging_is_deploy_target_prod_gated.md`).

All commands run from the **code repo**: `cd ~/projects/Peerloop`.

---

## 0. Mental model (read once)

- **Deploy unit = Worker name, not Git branch.** Workers has no Git integration; `wrangler deploy` ships whatever is in the **current working tree**, regardless of branch. Deploying staging from `jfg-dev-N` deploys that branch's HEAD.
- **Environment is baked at build time** via `CLOUDFLARE_ENV=staging` (the npm script sets it). `wrangler deploy` then reads the flattened `dist/server/wrangler.json` — so the deploy command correctly omits `--env`.
- **`legacy_env: true` gotcha:** for `secret`/`tail` ops, use `--name peerloop-staging` **or** `--env staging`, never both (double-suffix → `peerloop-staging-staging` stub). See cloudflare.md §Secrets.

---

## 1. Pre-flight assessment

### 1a. Confirm the branch + how far ahead of the last deploy

```bash
cd ~/projects/Peerloop
git branch --show-current                       # confirm you're on the intended branch
git log -1 --format='%h %s'                      # HEAD that will ship
# Compare to the last deployed commit (find it from the previous deploy's notes / RESUME-STATE):
LAST_DEPLOY=<sha>                                # e.g. 92e1929b
git merge-base --is-ancestor $LAST_DEPLOY HEAD && echo "clean descendant" || echo "DIVERGED — investigate"
git rev-list --count $LAST_DEPLOY..HEAD          # how many commits are shipping
```

A **clean descendant** is safe to ship. **DIVERGED** means staging has commits not in your branch — stop and reconcile.

### 1b. Decide whether the DB needs converging

The big branch in this decision is **schema drift**. Pre-launch, schema edits land **directly in `migrations/0001_schema.sql`** (not incremental migrations). Because D1's migration tracker already counts `0001` as applied, **`wrangler d1 migrations apply` will NOT pick up edits to `0001`** — the only way to converge is a **destructive reset + re-migrate + re-seed**.

```bash
# Did the schema or seed change since the last deploy?
git diff --stat $LAST_DEPLOY..HEAD -- migrations/ migrations-dev/
git rev-list --count $LAST_DEPLOY..HEAD -- migrations/0001_schema.sql   # >0 ⇒ schema changed ⇒ reset required
```

| Result | DB action |
|---|---|
| `0001_schema.sql` unchanged, no new tables in use | **Code-only** — skip §3, go straight to §4 |
| `0001_schema.sql` changed (new tables/columns) | **Destructive reset** required (§3) — new-schema code paths 500 on stale D1 |

> ⚠️ A reset **wipes all current staging data** and re-seeds with dev fixtures. Confirm that's acceptable before running §3.

### 1c. Verify code is green (all 5 baseline gates + bug-class checks)

Per CLAUDE.md §Baseline Verification, **run these in the deploying conv** — don't trust a carried-forward "green". `/w-codecheck` covers gates 1–4 + the bug-class greps; add `npm test` and `npm run build` (build is also a deploy prerequisite).

```bash
# Gates 1-4 + bug-class checks:
/w-codecheck            # tsc, eslint, tailwind-v4, astro check, + datetime/setError/locals.runtime/deleted_at/figma-asset greps
# Gate 5 (tests) + build:
npm test                # full suite (~2-3 min)
npm run build           # must succeed — deploy rebuilds anyway, but catch failures here
```

All must be green before proceeding.

### 1d. Confirm secrets are set (names only, never values)

```bash
./node_modules/.bin/wrangler secret list --name peerloop-staging
```

Expect: `JWT_SECRET`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STREAM_API_SECRET`, `RESEND_API_KEY`, `BBB_SECRET`. If any are missing, push them per cloudflare.md §Secrets (the `wrangler secret bulk --name peerloop-staging` recipe — note `--name`, not `--env`).

---

## 2. (Optional) Tail logs in a second terminal

```bash
npm run cf:tail:staging          # main worker
npm run cf:tail:cron:staging     # cron worker
```

Leave these running to watch the deploy + smoke test live.

---

## 3. Converge the staging DB (only if §1b said "reset required")

**Destructive — wipes staging data.** Seed levels are cumulative; pick the one matching the data surfaces you need to exercise:

| Command | Seeds |
|---|---|
| `npm run db:setup:staging` | reset + migrate only (no seed) |
| `npm run db:setup:staging:dev` | + dev data (users, courses, sessions) |
| `npm run db:setup:staging:stripe` | + Stripe connected accounts / payment intents |
| `npm run db:setup:staging:booking` | + booking/scheduling fixtures |
| `npm run db:setup:staging:feeds` | + feed activity data (**most complete**) |

```bash
npm run db:setup:staging:feeds      # full reset → migrate (new schema) → dev + stripe + booking + feeds seed
```

> 🔴 **Known risk [RS] (Conv 116):** `scripts/reset-d1.js` only drops tables present in the *current* schema, so legacy/orphan tables left over from an older schema can FK-block the drop pass and abort the reset. If `db:reset:staging` errors with a foreign-key / "cannot drop" failure, manually drop the orphan tables (`wrangler d1 execute DB --env staging --remote --command "DROP TABLE <name>"`) in dependency order, then re-run. Watch for this on the **first** reset after a large schema jump.

Verify the environment marker + a new-schema table landed:

```bash
wrangler d1 execute DB --env staging --remote --command "SELECT value FROM platform_stats WHERE key='environment'"   # → staging
wrangler d1 execute DB --env staging --remote --command "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('homework_submissions','feed_activities')"
```

---

## 4. Deploy the main Worker

```bash
npm run deploy:staging
# = CLOUDFLARE_ENV=staging ENVIRONMENT=staging npm run build && wrangler deploy
```

On success wrangler prints the version ID and the `peerloop-staging.brian-1dc.workers.dev` URL.

---

## 5. Deploy the cron Worker (only if `workers/cron/` changed)

```bash
git diff --stat $LAST_DEPLOY..HEAD -- workers/cron/     # changed? then redeploy:
npm run deploy:cron:staging
```

The staging cron runs every 15 min (`*/15 * * * *`). It shares the staging D1 + DISCOVERY_CACHE KV bindings.

---

## 6. Smoke test

```bash
BASE=https://peerloop-staging.brian-1dc.workers.dev
curl -sI  $BASE/ | head -1                         # homepage 200
curl -s   $BASE/api/discovery/rails | head -c 200  # discovery rails populated
curl -s   $BASE/api/admin/stripe-mode              # confirm Sandbox (not live) mode
```

Then in a browser (use the [BRIDGE-MEM] dev-login flow or the staging login):
- Home / dashboard renders (Matt shell)
- Log in; a role workspace (`/creating`, `/teaching`) loads
- One core flow end-to-end (enroll, or open a course, or a session)
- Spot-check a **newly-shipped** surface that depends on the schema change (this deploy: homework submissions / promote-pipeline / system feed)

> ⚠️ **SSR self-fetch class of bug only surfaces on deployed Workers** (not `npm run dev`). After any CF-adapter change, smoke-test every `.astro` page that loads data over HTTP. See cloudflare.md §SSR self-fetch pitfall.

---

## 7. Rollback

The code deploy is reversible — redeploy a known-good commit:

```bash
git stash || true
git checkout <last-good-sha>
npm run deploy:staging
git checkout -      # return to your branch
```

DB resets are **not** reversible (data is wiped). If you need the pre-reset data, take it (`wrangler d1 export DB --env staging --remote --output backup.sql`) **before** §3. For broader recovery floors (D1 Time Travel etc.) see `memory/reference_cf_data_recovery.md`.

---

## Quick reference — full sequence (schema changed, feeds-level)

```bash
cd ~/projects/Peerloop
# 1. pre-flight
git branch --show-current && git log -1 --oneline
/w-codecheck && npm test && npm run build
./node_modules/.bin/wrangler secret list --name peerloop-staging
# 2. converge DB (DESTRUCTIVE — wipes staging data)
npm run db:setup:staging:feeds
# 3. deploy
npm run deploy:staging
npm run deploy:cron:staging          # only if workers/cron changed
# 4. verify
curl -sI https://peerloop-staging.brian-1dc.workers.dev/ | head -1
```
