# State — Conv 115 (2026-04-14 ~12:39)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 115 added a prompt-gated `npm install` drift check to `/r-start` as a new Step 5.5 (placed after the conv-counter push so any artifacts get tracked under the current conv). Picked this over a silent hook to preserve `!` backtick determinism. Short tooling conv — no PLAN block advanced.

## Completed

- [x] `npm install` in code repo (hash resync)
- [x] Added "Dependency sync check" pre-computed context line to `/r-start` SKILL.md
- [x] Added Step 5.5 "Sync dependencies" to `/r-start` SKILL.md

## Remaining

### Carried from earlier convs (unchanged)

- [ ] **[IN]** Verify/install gh CLI on MacMiniM4-Pro (MacMiniM4 done Conv 113)
- [ ] **[EM]** Add email notification for session invites (future enhancement)
- [ ] **[AS]** `auth-sessions.md` missing refresh-token-as-auth-fallback documentation
- [ ] **[CSS]** Page scroll stuck on `/discover/members` — bottom row clipped
- [ ] **[CB]** DEPLOYMENT.PAGES-DISCONNECT — client to disconnect CF Pages ↔ GitHub integration (client-blocked)
- [ ] **[AD]** Auth docs drift check — API-AUTH, auth-libraries, google-oauth, auth-sessions
- [ ] **[VS]** Post-CF-WORKERS: staging seed scripts (`plato-seed-staging`, `reset-d1`, `seed-feeds`) untested after `--env preview` → `--env staging` rename
- [ ] **[VD]** Post-CF-WORKERS: `npm run dev:staging` untested against live bindings

### Active DEPLOYMENT sub-blocks (tracked in PLAN.md)

- [ ] **DEPLOYMENT.PAGES-DISCONNECT** (same as [CB] above; client-blocked)
- [ ] **DEPLOYMENT.GHACTIONS** — GH Actions deploy workflow + `CLOUDFLARE_API_TOKEN` secret
- [ ] **DEPLOYMENT.PROD** — create `peerloop` Worker, verify prod KV/D1/R2, upload prod secrets, deploy, custom domain
- [ ] **DEPLOYMENT.STAGING-DOMAIN** (optional) — `staging.peerloop.com` via Workers Routes

## TodoWrite Items

- [ ] #1: [IN] Verify/install gh CLI on MacMiniM4-Pro
- [ ] #2: [EM] Add email notification for session invites
- [ ] #3: [AS] auth-sessions.md missing refresh-token-as-auth-fallback docs
- [ ] #4: [CSS] Page scroll stuck on /discover/members — bottom row clipped
- [ ] #5: [CB] Client to disable CF Pages ↔ GitHub auto-deploy
- [ ] #6: [AD] Auth docs drift check — API-AUTH, auth-libraries, google-oauth, auth-sessions
- [ ] #7: [VS] Post-CF-WORKERS: staging seed scripts untested
- [ ] #8: [VD] Post-CF-WORKERS: npm run dev:staging against live bindings

## Key Context

### New `/r-start` Step 5.5 (this conv)

- Drift detected by comparing `sha256(package-lock.json)` vs `node_modules/.package-lock-hash` (same mechanism as `check-env.sh`)
- Runs AFTER Step 5 (counter push) so any file changes from `npm install` are attributable to the current conv
- Prompt-gated — user must say "yes" before install runs; "skip" is allowed
- This change will be exercised on next `/r-start` when drift is present

### Deployment state (from Conv 114)

- **Staging:** `peerloop-staging` Worker live at `https://peerloop-staging.brian-1dc.workers.dev`
- **Production:** `peerloop` Worker NOT YET CREATED; Pages project still serves prod from pre-Astro-6 code
- CF Pages GitHub auto-deploy still active — client needs to disconnect (see [CB])
- Wrangler gotchas documented in Conv 114 extract (legacy_env, CLOUDFLARE_ENV build-time behavior, etc.)

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
