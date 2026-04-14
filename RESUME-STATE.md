# State — Conv 116 (2026-04-14 ~15:30)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 116 closed [VS] (staging seed scripts) and [SF] (SSR self-fetch broken on CF Workers + Static Assets). Refactored 8 .astro pages + 3 API handlers to use new `src/lib/ssr/loaders/communities.ts` (extends existing loaders convention, throws `SSRDataError`). Dropped ~750 LOC of duplicated query logic. All staging community/discover pages return 200; 6392/6392 tests pass. PAGES-DISCONNECT also closed (client side). DEPLOYMENT block now ready for GHACTIONS + PROD subblocks. Several follow-ups filed: [RS] reset-d1.js orphans, [DS] dev:staging adapter regression, [PE] platform_stats env marker, plus 5 new from this conv's r-end agents.

## Completed

- [x] DEPLOYMENT.PAGES-DISCONNECT — client uninstalled CF Pages GitHub App
- [x] [VS] staging seed scripts unblocked (3 stale `--env preview` fixes; full reset+migrate+3 seeds verified live on staging)
- [x] [VD] dev:staging tested — exposed adapter regression (filed as [DS])
- [x] [CB] Client to disable CF Pages ↔ GitHub auto-deploy
- [x] [SF] SSR self-fetch refactor complete — 8 pages + 3 API handlers + new loaders module
- [x] CF API token rotation — created User-API-Token `peerloop-wrangler-full` with full scope; updated `.dev.vars`; uncommented `CLOUDFLARE_ACCOUNT_ID`

## Remaining

### Active DEPLOYMENT sub-blocks (next priority)

- [ ] **[DGH]** DEPLOYMENT.GHACTIONS — `.github/workflows/deploy.yml` for staging auto-deploy + `CLOUDFLARE_API_TOKEN` GH secret
- [ ] **[DP]** DEPLOYMENT.PROD — create `peerloop` Worker, verify prod KV/D1/R2 bindings, upload prod secrets, deploy, custom domain
- [ ] **[DSD]** DEPLOYMENT.STAGING-DOMAIN (optional) — `staging.peerloop.com` via Workers Routes

### Conv 116 follow-ups (filed)

- [ ] **[RS]** reset-d1.js doesn't drop orphan tables outside current schema (legacy `users`, `user_interests`, `user_topic_interests`, `categories` survive on staging)
- [ ] **[DS]** dev:staging doesn't actually use remote bindings — adapter 13 / vite-plugin 1.31.2 regression suspected
- [ ] **[PE]** platform_stats 'environment' marker not seeded by `0002_seed_core.sql`

### r-end agent surfaces

- [ ] **[SG]** Fix sync-gaps.sh — exclude `.astro/` subdirs (false positives on generated .d.ts)
- [ ] **[BL]** Pre-existing broken link `/course/[slug]/certificate` referenced from `/discover/course/[slug]` pages
- [ ] **[TL]** Add explicit no-paste-tokens-in-chat rule (CLAUDE.md or memory)
- [ ] **[GI]** Add `.claude/scheduled_tasks.lock` to docs `.gitignore`
- [ ] **[CD]** Bash cwd drift caused git operations on wrong repo — strengthen `git -C` enforcement

### Carried from earlier convs

- [ ] **[IN]** Verify/install gh CLI on MacMiniM4-Pro
- [ ] **[EM]** Add email notification for session invites
- [ ] **[AS]** auth-sessions.md missing refresh-token-as-auth-fallback docs
- [ ] **[CSS]** Page scroll stuck on `/discover/members` — bottom row clipped
- [ ] **[AD]** Auth docs drift check — API-AUTH, auth-libraries, google-oauth, auth-sessions

## TodoWrite Items

- [ ] #1: [IN] Verify/install gh CLI on MacMiniM4-Pro
- [ ] #2: [EM] Add email notification for session invites
- [ ] #3: [AS] auth-sessions.md missing refresh-token-as-auth-fallback docs
- [ ] #4: [CSS] Page scroll stuck on /discover/members — bottom row clipped
- [ ] #6: [AD] Auth docs drift check — API-AUTH, auth-libraries, google-oauth, auth-sessions
- [ ] #9: [DGH] DEPLOYMENT.GHACTIONS — GH Actions deploy workflow + CLOUDFLARE_API_TOKEN secret
- [ ] #10: [DP] DEPLOYMENT.PROD — create peerloop Worker, verify prod KV/D1/R2, upload secrets, deploy, custom domain
- [ ] #11: [DSD] DEPLOYMENT.STAGING-DOMAIN (optional) — staging.peerloop.com via Workers Routes
- [ ] #12: [RS] reset-d1.js doesn't drop orphan tables outside current schema
- [ ] #13: [DS] dev:staging doesn't actually use remote bindings (adapter 13 regression?)
- [ ] #14: [PE] platform_stats 'environment' marker not seeded
- [ ] #16: [SG] Fix sync-gaps.sh — exclude .astro/ subdirs
- [ ] #17: [BL] Pre-existing broken link: /course/[slug]/certificate
- [ ] #18: [TL] Add explicit no-paste-tokens-in-chat rule
- [ ] #19: [GI] Add .claude/scheduled_tasks.lock to docs .gitignore
- [ ] #20: [CD] Bash cwd drift — strengthen git -C enforcement

## Key Context

### CF Workers + Static Assets gotcha (resolved)

- SSR `fetch(self-origin)` from inside a Worker hits the Static Assets layer, NOT the Worker. CF returns text/plain 404 without falling through.
- `run_worker_first` (boolean or path-array) only affects EXTERNAL routing — has zero effect on Worker subrequests. Verified empirically.
- Fix used in Conv 116: refactor SSR pages to call data-loader functions directly. Skip HTTP entirely.
- `[assets].run_worker_first = ["/api/*"]` left in `wrangler.toml` as defensive hygiene only.

### New loader module pattern

- `src/lib/ssr/loaders/communities.ts` — 3 functions (list, detail, progressions), throws `SSRDataError`
- API handlers under `src/pages/api/communities/` are now thin wrappers (~30-50 lines each)
- `SSRDataError` extended with `UNAUTHORIZED` (401) + `FORBIDDEN` (403) codes
- Test mock contract: API handlers must call `getSession` DIRECTLY (not `getCurrentUserId`) — module-internal calls bypass `vi.mock('@/lib/auth')` overrides

### CF API Token state (Conv 116)

- New token `peerloop-wrangler-full` is a User-API-Token (created at `dash.cloudflare.com/profile/api-tokens`, NOT account-tokens page)
- Scopes: D1:Edit, Workers Scripts:Edit, KV:Edit, R2:Edit, Observability:Edit, Workers Routes:Edit (peerloop.com), User:Memberships:Read, User:User Details:Read
- Lives in `~/projects/Peerloop/.dev.vars` line 15. `CLOUDFLARE_ACCOUNT_ID=1dcd33...` uncommented at line 14 (token grants access to 4 accounts; account ID needed for non-interactive selection)
- Old "Edit Cloudflare Workers" Account API Token at the account-tokens page is now stale/unused — can be deleted

### Deployment state

- Staging: `peerloop-staging` Worker live at `https://peerloop-staging.brian-1dc.workers.dev` — fully populated D1, working community/discover pages
- Production: `peerloop` Worker NOT YET CREATED. Pages project still serves prod from pre-Astro-6 code. PAGES-DISCONNECT now done (no longer auto-redeploys).
- Wrangler 4.81.1 in use; staging wrangler.toml has `[env.staging]` block with full bindings

### Conv 116 commit state (Pre-r-end)

- Code repo on `jfg-dev-12`: 2 mid-conv commits already pushed (33b0c15 VS fixes + assets hygiene; one earlier from conv-start)
- Docs repo on `main`: 2 mid-conv commits already pushed (PLAN PAGES-DISCONNECT close + r-start)
- Final r-end commit (loaders + page refactor + API thin wrappers + r-end docs) will be made in Step 6.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
