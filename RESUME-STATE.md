# State — Conv 114 (2026-04-13 ~21:10)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `staging`, docs: `main`

## Summary

Conv 114 completed the CF Pages → Workers migration (CF-WORKERS block). Peerloop now deploys as a Worker: staging live at `https://peerloop-staging.brian-1dc.workers.dev`, fully functional (SSR + D1 + R2 + KV + auth all verified). PR #27 merged, staging secrets uploaded, `preview_urls` policy set per env, docs overhauled. A new DEPLOYMENT block was spawned in PLAN.md with 4 sub-blocks covering the remaining work (GH Actions auto-deploy, prod cutover, optional staging domain, and the client-blocked Pages GitHub-integration disconnect).

## Completed

- [x] CF-WORKERS Phase 0: Branch + revert postbuild (`7cef697`)
- [x] CF-WORKERS Phase 1: Rewrite wrangler.toml for Workers (`f2d852e`)
- [x] CF-WORKERS Phase 2: Update package.json scripts (`f2d852e`)
- [x] CF-WORKERS Phase 3: Clean Pages refs in source (`36cc97c`)
- [x] CF-WORKERS Phase 4: `peerloop-staging` Worker created in CF dashboard
- [x] CF-WORKERS Phase 5: Deploy + smoke test (5/6 routes 200 — kv health route doesn't exist, unrelated)
- [x] CF-WORKERS Phase 6: Documentation overhaul (cloudflare.md, DECISIONS.md, PLAN.md)
- [x] CF-WORKERS Phase 7: PR #27 merged into staging (`f911be3`)
- [x] `preview_urls` policy set (`d574bdd`): false for prod, true for staging
- [x] Staging secrets uploaded via `wrangler secret bulk` (JWT_SECRET + 5 others)
- [x] Login verified on staging as Sarah
- [x] Fresh-staging deploy after PR #27 merge (Version ID `b3f411d9`)
- [x] PACKAGE-UPDATES block fully closed (PR #26 + CF-WORKERS)

## Remaining

### Active DEPLOYMENT sub-blocks (tracked in PLAN.md)

- [ ] **DEPLOYMENT.PAGES-DISCONNECT** (client-blocked) — client to disconnect CF Pages ↔ GitHub integration via either CF Dashboard (project → Settings → Git integration → Disconnect) OR GitHub org settings (`https://github.com/organizations/PeerloopLLC/settings/installations/101494732`). Handoff message is in conv; PLAN.md has full text. Live content stays up; only the auto-rebuild trigger is removed.
- [ ] **DEPLOYMENT.GHACTIONS** — GitHub Actions workflow for auto-deploy on push to staging/main; `CLOUDFLARE_API_TOKEN` secret in repo settings
- [ ] **DEPLOYMENT.PROD** — prereqs: create `peerloop` Worker in CF dashboard, verify prod KV/D1/R2 resources, upload prod secrets (NOT staging values — use `sk_live_...` Stripe, prod webhook, prod Stream); then `npm run deploy:prod`, custom domain routing, retire old Pages project
- [ ] **DEPLOYMENT.STAGING-DOMAIN** (optional) — `staging.peerloop.com` via Workers Routes

### Carried from earlier convs

- [ ] **[INFRA]** Verify/install gh CLI on MacMiniM4-Pro (MacMiniM4 done Conv 113)
- [ ] **[EM]** Add email notification for session invites (future enhancement)
- [ ] **[DOC]** auth-sessions.md missing refresh-token-as-auth-fallback documentation
- [ ] **[CSS]** Page scroll stuck on `/discover/members` — bottom row clipped

### Surfaced this conv (by r-end agents)

- [ ] **[DOC]** Auth docs drift check — API-AUTH.md, auth-libraries.md, google-oauth.md, auth-sessions.md (tech-doc-sweep flagged against modified auth components)
- [ ] **[VERIFY]** Staging seed scripts (`plato-seed-staging`, `reset-d1`, `seed-feeds`) — updated `--env preview` → `--env staging` but not test-run
- [ ] **[VERIFY]** `npm run dev:staging` — changed to `CLOUDFLARE_ENV=staging` but not verified against live bindings

## TodoWrite Items

- [ ] #1: [INFRA] Verify/install gh CLI on MacMiniM4-Pro
- [ ] #2: [EM] Add email notification for session invites — future enhancement
- [ ] #3: [DOC] auth-sessions.md missing refresh-token-as-auth-fallback documentation
- [ ] #4: [CSS] Page scroll stuck on /discover/members — bottom row clipped
- [ ] #13: [CLIENT-BLOCKER] Client to disable CF Pages ↔ GitHub auto-deploy
- [ ] #14: [DOC] Auth docs drift check — API-AUTH.md, auth-libraries.md, google-oauth.md, auth-sessions.md
- [ ] #15: [VERIFY] Post-CF-WORKERS: staging seed scripts untested
- [ ] #16: [VERIFY] Post-CF-WORKERS: npm run dev:staging against live bindings

## Key Context

### CF Workers deployment model (NEW this conv)

- **Staging:** `peerloop-staging` Worker at `https://peerloop-staging.brian-1dc.workers.dev`
- **Production:** `peerloop` Worker — NOT YET CREATED. Must be created in CF Dashboard before first `npm run deploy:prod`. (An accidental `peerloop` was auto-created and deleted in Conv 114.)
- **CF Account:** Brian@peerloop.com (`1dcd33766ea5ef9f288c19a8f79f6fd0`)
- **KV SESSION IDs:** staging `e2c3e710131340bdb1186b62af7a8c00`; prod `7605e3a386904b77b566161633f609ce` (⚠️ verify prod ID is correct before prod deploy)

### Critical wrangler/adapter behavior — gotchas to watch for

1. **`CLOUDFLARE_ENV` is a BUILD-TIME concern, not deploy-time.** `wrangler deploy --env staging` is a no-op because `.wrangler/deploy/config.json` redirects to the adapter's flat `dist/server/wrangler.json`. Deploy scripts prefix `CLOUDFLARE_ENV=staging ENVIRONMENT=staging` before `npm run build && wrangler deploy` (no `--env` flag).
2. **`legacy_env: true` + `--env staging` double-suffixes the Worker name.** For `wrangler secret put/bulk`: use `--name peerloop-staging` alone (NO `--env`). Otherwise you'll create a stub `peerloop-staging-staging` Worker.
3. **Root `wrangler.toml` has NO `main` or `[assets]`.** The `@cloudflare/vite-plugin` validates `main` at config-resolution time (before build). Let the adapter emit these into `dist/server/wrangler.json` instead.
4. **Pages GitHub integration still active until client disconnects.** Pushes to staging may trigger broken Pages builds that waste CI and serve SSR-less previews. No impact on Workers.

### Pages project status

- `peerloop` CF Pages project still exists
- Serves production URL (peerloop.pages.dev / peerloop.com) from PRE-Astro-6 code (main branch unchanged this conv)
- Will stay alive as a fallback until DEPLOYMENT.PROD completes
- Delete only AFTER prod cutover verified

### Stale branches (will NOT be cleaned up per user directive)

`jfg-dev-11`, `jfg-dev-12` both contain postfix cruft. User said: "We will not be deleting stale branches in this repo." So they remain.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
