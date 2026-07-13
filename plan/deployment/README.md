# DEPLOYMENT — CF Workers production cutover + automation

**Focus:** Complete the CF Workers rollout — production cutover and automation.
**Status:** 📋 PENDING (spawned from CF-WORKERS Conv 114)
**Tech Doc:** `docs/reference/cloudflare.md` (§Cloudflare Workers Deployment)
**Staging deploy runbook:** `docs/reference/staging-deploy-runbook.md` (linear how-to; added Conv 348 [STG-DEPLOY])

## DEPLOYMENT.STAGING-DEPLOY — Staging deploy log

**[STG-DEPLOY] Conv 348 — first staging deploy past Conv 261.** Deployed jfg-dev-14 HEAD (`8cc4ce7e`, 167 commits ahead of the prior staging point `92e1929b` from Conv 261) to staging and browser-verified the homework file-upload feature end-to-end. **Staging only — prod cutover remains gated** (DEPLOYMENT.PROD + DEPLOYMENT.DB-SYNC below untouched).

- **Worker versions:** app `6553c1cb`, cron `e5a75e73` (cron had changed +24 lines → redeploy required).
- **DB convergence:** destructive `db:setup:staging:feeds` (reset 70 tables / 155 indexes, 4 migrations applied, dev+stripe+booking+feeds seeds). Required because pre-launch schema edits land in the already-tracked `0001_schema.sql`, which `wrangler d1 migrations apply` will NOT re-apply — 7 schema-touching commits since Conv 261 left staging D1 stale, so only a reset converges. The flagged `[RS]` orphan-table FK-block did **not** recur this time.
- **Seed sample:** `sub-sarah-n8n` file-upload homework submission (`workflow.json` / `r2_key`, by in-progress student Sarah Miller for `hw-n8n-001`) now lands in the staging seed; matching R2 object written via `wrangler r2 object put` so the authed creator download streams 200.
- **Smoke + browser-verify:** homepage 200, discovery rails 200+data, homework download auth-gated (401 unauth / 200 authed creator, `application/json` from R2). Verified in-browser at `/creating/studio?course=crs-intro-to-n8n` → Submissions → Sarah Miller's graded submission with the workflow.json download chip.
- **Verify caveat:** `dev-login` (`/api/auth/dev-login`) returns 404 on staging — guarded on `import.meta.env.DEV`, which is false in a production build (staging is a prod build with staging bindings). The `[BRIDGE-MEM]` dev-login island-verify path is dev/`:4321` only; staging auth-gated UI needs a real password login (user-assisted handoff, as CC can't type passwords).
- **Procedure:** `docs/reference/staging-deploy-runbook.md` (authored + executed this conv).

**[STG-DEPLOY] Conv 388 — buffer + session-reminders redeploy (supersedes the Conv 348 versions above).** Full staging reset+reseed+deploy of jfg-dev-14 (`81f57e17`) to land `availability.buffer_minutes` + the `sessions.reminder_*` columns — staging was behind on both schema edits. **Staging only — prod cutover still gated.**

- **Worker versions:** app `170a0b1a`, cron `d95ddb91` (`*/15`).
- **DB convergence:** destructive `db:setup:staging:feeds` again (same rationale — pre-launch schema edits land in the already-tracked `0001`, so only a reset converges). The reseed also resolved the [SESSION-REMIND-DEPLOY] `reminder_*` columns as a side effect.
- **Resend / cron activation:** set `RESEND_API_KEY` secret on `peerloop-cron-staging` (piped from `.dev.vars`, never surfaced in chat) → deployed the cron worker. Verified the cron fires session reminders end-to-end: a due row (`now+2h`) got `reminder_24h_sent_at` stamped on the next `*/15` tick + 2 `session_reminder` notifications; ground-truth inbox delivery confirmed to `fgorrie@bio-software.com` (FROM `send.peerloop.com`, Resend-verified). Test rows cleaned up.
- **Smoke:** schema cols present; public `availability-batch` 200 (`windowDays:14`); authed `PUT buffer_minutes:30` → `GET` 30 round-trip (Sarah).
- **Tooling gotchas (this conv):** D1 caps compound SELECT <70 terms; `wrangler` writes results to **stderr** (capture `2>&1`); macOS has no `timeout` (use a bg process + explicit `kill`); the staging `RESEND_API_KEY` is **send-only** (401 on the delivery-status GET).

**[FEEDBACK-DEPLOY] Conv 394 — feedback-reminder cron activation on staging (surgical, NOT a full reset).** Activated the new `[FEEDBACK-NUDGE]` post-session feedback-reminder cron block on staging without reseeding. **Staging only — prod repeat gated behind MVP-GOLIVE** (see MVP-GOLIVE.CRON-CLEANUP prod-cron-deploy item).

- **Schema convergence via manual ALTER (not reseed):** ran 3 `ALTER TABLE ADD COLUMN` on staging D1 — `users.email_feedback_reminder` + `sessions.feedback_reminder_student_sent_at` + `sessions.feedback_reminder_teacher_sent_at` (all present, verified). Non-destructive — preserves the client's staging data (Decision: manual ALTER over the destructive `db:setup:staging` reseed the Conv 348/388 deploys used).
- **Cron redeploy:** `deploy:cron:staging` → version `37e506d5` (`*/15`); confirmed `RESEND_API_KEY` already set on `peerloop-cron-staging` (so the feedback block fires, not skips).
- **Window check:** 0 completed-but-unrated sessions in `(now−72h, now−1h]` (9 completed total, all stale) → first tick no-ops cleanly, no stale-data nudge blast.
- **Drift note:** staging schema is now "0001 + manual ALTER" — the 3 columns reached staging **out-of-band** (not recorded in the migration tracker). Same recurring gotcha as the Conv 348/388 entries above: editing the already-applied `0001_schema.sql` creates no new migration file, so `db:migrate:staging` no-ops; columns reach a live remote D1 only via ALTER or a full reseed. Self-heals on any future `db:setup:staging` reseed (0001 now carries the columns).

## DEPLOYMENT.GHACTIONS — GitHub Actions auto-deploy workflow

- [ ] `.github/workflows/deploy.yml` — auto-deploy on push to staging/main
- [ ] Configure GitHub repo secrets: `CLOUDFLARE_API_TOKEN` (deploy), `DOCS_REPO_PAT` (doc-drift workflow cross-repo checkout of peerloop-docs — PAT needs `repo` read scope)
- [ ] Build + run tests + deploy (staging env)
- [ ] Main branch deploys to production (once prod cutover done)

## DEPLOYMENT.PAGES-DISCONNECT — Disable old Pages auto-deploy ✅ COMPLETE (Conv 116)

**Resolved:** Client uninstalled the Cloudflare Pages GitHub App from `PeerloopLLC`. Pushes to `staging`/`main` no longer trigger broken CF Pages builds.

- [x] **GitHub-side:** Cloudflare Pages GitHub App uninstalled from `PeerloopLLC` org.

**Do NOT delete the Pages project itself** — production still serves from it until DEPLOYMENT.PROD completes.

## DEPLOYMENT.DB-SYNC — Prod D1 schema/data convergence (Conv 169 discovery)

**Status:** 📋 PENDING — pre-cutover prerequisite. Discovered Conv 169 while preparing [PROD-PW-APPLY]: prod D1 has drifted vs local + staging. Bundling all prod D1 mutations (schema-sync + password rotation + tracker-cleanup) into one synchronous sweep.

**Drift state (live, captured Conv 169):**

| Migration | Local | Staging | Production |
|---|:---:|:---:|:---:|
| 0001_schema.sql | ✅ | ✅ | ✅ |
| 0002_seed_core.sql | ✅ | ✅ | ⚠️ recorded under old name `0002_seed.sql` |
| 0003_fix_session_times.sql | ✅ | ✅ | ❌ **NOT APPLIED** (would be no-op — `sessions_missing_z = 0`) |
| 0004_feed_activity_index.sql | ✅ | ✅ | ❌ **NOT APPLIED** — `feed_visits` / `feed_activities` tables missing on prod |

**Live prod row counts (Conv 169):** 9 users (including `usr-admin`), 6 sessions, 0 sessions missing `Z` suffix.

**Tasks (run as one bundle when ready to apply):**

- [ ] **[DB-SYNC-04]** Apply `migrations/0004_feed_activity_index.sql` to prod via `wrangler d1 execute peerloop-db --remote --file migrations/0004_feed_activity_index.sql`. Creates `feed_visits` + `feed_activities` tables + 2 indexes. Real schema gap — any feed-intel code path that reads/writes these tables will fail on prod until applied. Then insert tracker row: `wrangler d1 execute peerloop-db --remote --command="INSERT INTO d1_migrations (name, applied_at) VALUES ('0004_feed_activity_index.sql', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))"`.

- [ ] **[DB-SYNC-03]** Insert tracker row for `0003_fix_session_times.sql` without running the SQL (already-converged data — prod has zero bare-string sessions): `wrangler d1 execute peerloop-db --remote --command="INSERT INTO d1_migrations (name, applied_at) VALUES ('0003_fix_session_times.sql', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))"`. Tracker-only — keeps `wrangler d1 migrations list` clean.

- [ ] **[DB-SYNC-02-RENAME]** Rename the stale tracker entry `0002_seed.sql` → `0002_seed_core.sql` to match the current filename: `wrangler d1 execute peerloop-db --remote --command="UPDATE d1_migrations SET name = '0002_seed_core.sql' WHERE name = '0002_seed.sql'"`. Cosmetic — but `wrangler d1 migrations list` will then return clean "No migrations to apply" instead of falsely listing 0002_seed_core.sql as pending.

- [ ] **[PROD-PW-APPLY]** Execute the deferred `Peerloop2` rotation against prod admin (was Conv 168 deferred, redirected here Conv 169). **Three sub-steps, all in this same DB-SYNC bundle:**
  1. Edit `migrations/0002_seed_core.sql:172` — replace the `Password1` hash (`$2b$10$Mc4KOG9BDrsrhzJZznRipeGBmQbYHxxxa..IIemgOSUIpMq0wxJk6`) with the `Peerloop2` hash (`$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi`) — same hash used in `migrations-dev/0001_seed_dev.sql` and `src/lib/mock-data.ts:1485`. Update the file comment at line 168 too.
  2. `wrangler d1 execute peerloop-db --remote --command="UPDATE users SET password_hash = '<hash>' WHERE id = 'usr-admin'"` against prod.
  3. Verify by logging into prod as `admin@peerloop.com` / `Peerloop2`.

- [ ] **[DB-SYNC-VERIFY]** Final convergence check — `wrangler d1 migrations list peerloop-db --remote` should report "No migrations to apply"; spot-check `SELECT name FROM sqlite_master WHERE name IN ('feed_visits','feed_activities')` returns both; spot-check `SELECT substr(password_hash,1,12) FROM users WHERE id='usr-admin'` returns `$2b$10$tQMU...` (Peerloop2) not `$2b$10$Mc4K...` (Password1).

**Rationale for bundling:** Each individual task is small and could be done separately, but the DECISIONS.md §4 principle ("bundle so live prod and seed never disagree") generalizes — applying these one-by-one over multiple convs leaves prod in successively-different intermediate states, none of which match any reference (local/staging/seed-file). Batching makes the diff a single atomic step.

**Why not run now (Conv 169):** User direction — route into the existing pre-production block rather than mutate prod mid-conv. Apply when the DEPLOYMENT block is actively being worked.

## DEPLOYMENT.PROD — Production cutover

**Prerequisites (before first prod deploy):**
- [ ] Create the `peerloop` Worker in the Cloudflare Dashboard (Workers & Pages → Create → Worker → "Hello World" template → rename to `peerloop`). First `wrangler deploy` will overwrite the stub. *Note: the accidental `peerloop` Worker from Conv 114 was deleted; it no longer exists.*
- [ ] Confirm the prod KV `SESSION` namespace ID in `wrangler.toml` (`7605e3a3...`) is correct for the production account — verify in CF Dashboard that this namespace exists and is not a staging leftover. If wrong, create a new prod KV namespace and update the top-level `[[kv_namespaces]]` in `wrangler.toml`.
- [ ] Confirm prod D1 `peerloop-db` and R2 `peerloop-storage` resources exist and contain the intended production data (not test seed). **Tracked separately: DEPLOYMENT.DB-SYNC above covers prod D1 migration convergence.**
- [ ] Upload production secrets to the `peerloop` Worker via `wrangler secret bulk` — JWT_SECRET, BBB_SECRET, RESEND_API_KEY, STRIPE_SECRET_KEY (live `sk_live_...`, not test), STRIPE_WEBHOOK_SECRET (separate prod webhook in Stripe Dashboard), STREAM_API_SECRET (prod Stream.io key). See `docs/reference/cloudflare.md` §Secrets for the bulk-upload recipe. **Do NOT reuse staging secrets for production.**

**Cutover:**
- [ ] Deploy `peerloop` Worker via `npm run deploy:prod` (tests `confirm-prod.js`)
- [ ] Smoke test the `.workers.dev` URL before any DNS change
- [ ] Configure custom domain routing in CF dashboard (`peerloop.com` → Worker)
- [ ] Verify production DNS resolves to Worker, not old Pages project
- [ ] Delete the old CF Pages project (after prod cutover verified stable)

## DEPLOYMENT.STAGING-DOMAIN — Staging custom domain (optional)

- [ ] If desired: `staging.peerloop.com` → Worker Routes (replaces `.workers.dev`)

## DEPLOYMENT.STAGING-FOLLOWUPS — Discovered during Conv 116 staging verification

- [x] **[VS]** Staging seed scripts unblocked — fixed 3 stale `--env preview` references in `scripts/reset-d1.js` (2) + `scripts/plato-seed-staging.js` (1); live reset → migrate → seed:staging → seed:booking:staging → seed-feeds.mjs all green (Conv 116)
- [x] **[SF]** SSR self-fetch 404 regression on Workers — refactored 8 community/discover `.astro` pages + 3 `/api/communities/*` handlers to use new `src/lib/ssr/loaders/communities.ts`; extended `SSRDataError` with UNAUTHORIZED/FORBIDDEN; ~750 LOC net deletion; all 4 community slugs + 3 API endpoints return 200 on staging; 6392/6392 tests pass (Conv 116)
- [x] **[CF-TOKEN]** Rotated `CLOUDFLARE_API_TOKEN` to User API Token `peerloop-wrangler-full` with D1/Workers/KV/R2/Observability/Routes + User:Memberships:Read + User:User Details:Read; set `CLOUDFLARE_ACCOUNT_ID` in `.dev.vars` to disambiguate multi-account token (Conv 116)
- [ ] **[RS]** `scripts/reset-d1.js` doesn't drop orphan tables outside current schema — Conv 116 staging reset left legacy `users`, `user_interests`, `user_topic_interests`, `categories` tables (not in `0001_schema.sql`) that FK-blocked the drop-in-dependency-order pass. Required manual DROP. Fix: query `sqlite_master` for ALL non-system tables, not just ones in current schema. *(Conv 348: the feeds-level staging reset succeeded with no `[RS]` error — no orphan tables present this time, so the underlying gap is latent, not fixed.)*
- [ ] **[DS]** `npm run dev:staging` doesn't actually use remote bindings — `remoteBindings: true` in adapter 13 config appears to be a no-op. Dev server reads empty local miniflare D1 sandbox instead of remote staging D1. Suspect adapter 13 / vite-plugin 1.31.2 regression. Blocks the "post-adapter-migration smoke test" workflow that would have caught [SF] earlier.
- [ ] **[PE]** `platform_stats.environment` marker row not seeded by `migrations/0002_seed_core.sql` — `/api/debug/db-env` returns 'unknown' for remote D1s even when data is correctly populated.

**Learning (folded into tech docs by r-end):** CF Workers + Static Assets route SSR self-fetches to the Assets layer which 404s plain-text; `[assets].run_worker_first` has ZERO effect on Worker-internal subrequests (only external-edge routing). Fix was Path B — refactor to direct loader imports — per CLAUDE.md §Solution Quality.
