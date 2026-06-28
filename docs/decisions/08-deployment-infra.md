> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 8. Deployment & Infrastructure

### Staging Is the Deploy Target; Production Is a Gated Launch Event
**Date:** 2026-06-10 (Conv 262)

For all feature work the deploy target is **staging**. Production has never been deployed — MVP-GOLIVE is ⏸️ DEFERRED (no prod secrets, prod D1 unmigrated). A "prod deploy" line in a feature task is mis-scoped and must be folded into MVP-GOLIVE; never run `deploy:prod` / `deploy:cron:prod` for feature work. This conv ran `deploy:cron:prod` literally from a DISCOVERY-RAILS task line, deploying `peerloop-cron` to prod from an unmerged dev branch; it was reverted (`wrangler delete --env production`), #30 re-scoped to staging-complete, and the prod cron deploy folded into MVP-GOLIVE's CRON-CLEANUP item.

**Rationale:** Deploying from a dev branch with no prod secrets against an unmigrated prod D1 is not the controlled MVP-GOLIVE landing. `confirm-prod.js` is an interactive readline gate — its purpose is a human checkpoint; satisfying it programmatically defeats the safeguard. Rule banked as memory `feedback_staging_is_deploy_target_prod_gated`.

**See:** `plan/mvp-golive/README.md` (CRON-CLEANUP).

### Astro Stack Upgrade Executed Conv 177 (4 packages, wrangler coupled)
**Date:** 2026-05-23 (Conv 177) — supersedes Conv 176 [NPM-UP] forward-decision

Upgraded `astro 6.1.5→6.3.7`, `@astrojs/cloudflare 13.1.8→13.5.4`, `@astrojs/react 5.0.3→5.0.5`, and `wrangler 4.81.1→4.94.0` together. Wrangler was added to the upgrade set after `@astrojs/cloudflare@13.5.4`'s ERESOLVE for `wrangler@^4.83.0`. Did NOT use `--legacy-peer-deps`. The Conv 176-planned `resolve.dedupe` + `ssr.noExternal` recipe was attempted, failed, and is NOT in the final config — the real fix was Vite `optimizeDeps.entries + include` (see Vite Cold-Start Dep Discovery entry above). React stays on 19.x (downgrade considered and rejected — see session decisions Conv 177).

**Rationale:** Per CLAUDE.md §Solution Quality, default to durable: `--legacy-peer-deps` papers over real version skew. Wrangler 4.81.1→4.94.0 is a single-version-family change satisfying the upstream peer-dep declaration. Wrangler 4.94.0 still satisfies `^4.67.0` in package.json so the declared range didn't change.

**Consequences:** All 5 baseline gates green (tsc, astro check 0/0/0, lint clean, tests, build 7.27s). Astro 6.3 added `logger` field to `APIContext` — `tests/api/helpers/api-test-helper.ts` gained a no-op stub matching the existing `cache` stub pattern. Astro check hints fixed inline (HeaderBar.astro unused Props interface → added cast; CourseHeader.astro unused Button import → deleted). Sidebar.tsx `flex-shrink-0` → `shrink-0` (Tailwind v3→v4 rename caught by /w-codecheck). [AAP] re-tested against 6.3.7 — still broken upstream, deferral continues. [TWLG-MIN-H] not re-tested this conv.

**See:** `package.json`, `astro.config.mjs`, `tests/api/helpers/api-test-helper.ts`, `docs/reference/DEVELOPMENT-GUIDE.md` § Vite SSR Cold-Start Dep Discovery.

### Stripe Mode Discipline: Local=Test, Staging=Sandbox, Prod=Live
**Date:** 2026-04-21 (Conv 144)

Peerloop's three deployment tiers map to three separate Stripe environments and **never share credentials across modes**:

| Peerloop env | Stripe mode | Why |
|--------------|-------------|-----|
| Local dev | **Test mode** | Free, account-wide, pairs cleanly with `stripe listen` for CLI webhook forwarding |
| Staging | **Sandbox** (`Alpha Peer LLC sandbox`) | Isolated from Test mode — CI/parallel testing can't collide with a dev's manual charges |
| Production | **Live** | Real money; go-live secrets deferred per env-vars-secrets.md |

**Hard rule:** every `.dev.vars*` file and every `wrangler secret put --env <x>` invocation is single-mode. Never mix a Test-mode `sk_test_` with a Sandbox `whsec_` within the same env — signature verification, API lookups, and webhook routing all break silently when modes split.

**Rationale:** Stripe released Sandboxes (2024) as isolated testing environments parallel to (not replacing) Test mode. They have disjoint API keys, webhook endpoints, customers, charges, and events — a key issued in one mode is unusable in another. Conv 144 burned ~90 min on a signature-verification failure that turned out to be a Test-mode/Sandbox mix-up: the staging Worker had a Sandbox webhook secret, but `stripe trigger` from the CLI was firing Test-mode events that never reached the Sandbox endpoint. The mode confusion was also masked by identical `sk_test_` / `pk_test_` prefixes on both Test-mode and Sandbox keys — only the webhook endpoint URL and the Workbench banner (`Alpha Peer LLC sandbox`) distinguish them in the UI.

**Consequences:**
- `.dev.vars` (local) holds Test-mode `sk_test_` + Test-mode `whsec_` issued by `stripe listen`
- `.dev.vars.staging` holds Sandbox keys only; same for `wrangler secret put --env staging`
- Production secrets (not yet provisioned) hold Live keys only
- Stripe CLI's default auth is Test mode; for Sandbox operations, re-auth via `stripe login` into the Sandbox workbench or use direct-sign harnesses (`scripts/trigger-webhook.sh stripe-*-direct`)
- Credential leaks affect only their own mode (a leaked Test-mode `sk_test_` does NOT grant Sandbox or Live access) — scope rotation accordingly

**See:** `docs/reference/stripe.md` §Stripe Mode Discipline, `docs/as-designed/webhook-miss-resilience.md` §Stripe events

### `/api/admin/stripe-mode` Is a Permanent Diagnostic, Not a One-Off Script
**Date:** 2026-04-21 (Conv 145)

Staging/Prod Stripe-mode audits run against a permanent admin-gated GET endpoint (`src/pages/api/admin/stripe-mode.ts`) that returns the platform account identity (`account_id`, `livemode`, `email`, `country`, `charges_enabled`, `payouts_enabled`) using `stripe.accounts.retrieveCurrent()` — NOT a one-off Node script invoked via Wrangler, and NOT a manual Dashboard comparison. Admin auth via `requireRole(cookies, jwtSecret, ['admin'])`.

**Rationale:** The audit is not a one-time concern — every future secret rotation, every pre-go-live check, every mode-drift investigation reuses the same check. Per CLAUDE.md default-to-durable, the permanent endpoint's incremental cost (60 LOC + 4 tests) is amortized across all future audits. It also provides an authoritative mode check independent of Dashboard UI changes — the 2025/2026 "Test mode merged into Sandboxes" Dashboard shift would have required updating a script's instructions but leaves the endpoint contract untouched. Stripe SDK v22's `Account.livemode` type gap is worked around with a narrow cast `(account as unknown as { livemode?: boolean }).livemode`.

**Consequences:** Future audits run via browser-login + navigate to `/api/admin/stripe-mode`, not script invocation. Conv 145 [VA] confirmed staging Worker's `STRIPE_SECRET_KEY` is scoped to `acct_1SkSfYRu7i9fxxy0` (Alpha Peer LLC sandbox) — mode aligned with webhook secret, no drift. Endpoint is the canonical path for all Stripe Mode Discipline verifications going forward.

**See:** `src/pages/api/admin/stripe-mode.ts`, `tests/api/admin/stripe-mode.test.ts`, `docs/reference/stripe.md §Stripe Mode Discipline`

### Stripe Webhook Signature Verification Uses `constructEventAsync` (Runtime-Agnostic)
**Date:** 2026-04-21 (Conv 144)

`src/lib/stripe.ts` `constructWebhookEvent` is `async` and delegates to `stripe.webhooks.constructEventAsync()`. Callers (e.g., `src/pages/api/webhooks/stripe.ts:64`) must `await` it. Never use the synchronous `stripe.webhooks.constructEvent()` — it throws on CF Workers.

**Rationale:** Stripe SDK dispatches `constructEvent()` to `NodeCryptoProvider` (sync, Node only) or `SubtleCryptoProvider` (async-only, Workers/browser) based on runtime. The sync form throws `"SubtleCryptoProvider cannot be used in a synchronous context"` on Workers — 100% failure rate. Conv 114's CF Pages → Workers migration silently introduced this bug: every Stripe webhook to staging had been HTTP 400'd for ~8 weeks because local `astro dev` (Node) masked it. The async variant works on both Node (tests) and Workers — `await` on a sync-resolved value is a no-op — so a single code path serves all environments.

**See:** `docs/as-designed/webhook-miss-resilience.md` §Stripe live observations

### React 19 SSR Fix for Cloudflare
**Date:** 2025-12-29 (updated 2026-02-16)

Add Vite alias to use `react-dom/server.edge` instead of `react-dom/server.browser`. The upstream fix (PR #12996) merged Jan 2025 but only shipped in `@astrojs/cloudflare` v13 beta (Astro 6), not the v12 stable line. The workaround is fragile — works by Vite alias resolution order coincidence, not by design. Remove when `@astrojs/cloudflare` v13+ is stable.

**Rationale:** Official workaround for MessageChannel error in Cloudflare Workers; fix applies only to production builds.

**See:** `docs/reference/astrojs.md` (Caveats section)

### ~~Provision Cloudflare KV Namespace~~ → KV Removed from Codebase
**Date:** 2026-02-16 (provisioned) → 2026-04-07 Conv 095 (removed)

KV namespace bindings removed from wrangler.toml (all 3 environments). Health check endpoint (`src/pages/api/health/kv.ts`) deleted. Session config in astro.config.mjs retained with comment — the adapter auto-configures KV sessions but causes no runtime error if the binding is absent and no code calls `Astro.session`. KV namespaces still exist in Cloudflare dashboard but are unbound. Feature flags (the planned KV use case) noted as Post-MVP #19.

**Rationale:** KV was provisioned Session 215 but never used by application code. Auth uses JWT cookies, not KV sessions. Removing dead bindings simplifies config. Re-add post-launch if feature flags need KV.

**See:** `docs/reference/cloudflare-kv.md`

### DISCOVERY-RAILS: Precomputed Rails via Cron-Writer + KV-Reader (Compute-Fallback Endpoint)
**Date:** 2026-06-10 (Conv 261)

DISCOVERY-RAILS reintroduces a Cloudflare KV namespace (`DISCOVERY_CACHE`) — the first app-code KV use since it was removed Conv 095 (auth still uses JWT cookies, not KV). The rails (trending/popular/new × course/community) are precomputed daily by the **standalone cron Worker** (`workers/cron/`, which already hosts `runSessionCleanup`) and written to KV; new scheduled jobs extend this Worker rather than the main Astro Worker, because `@astrojs/cloudflare` v13 does not expose `workerEntryPoint` to add a `scheduled()` export. The serving endpoint `GET /api/discovery/rails` reads KV when the binding is present + blob version matches, **else computes on demand from D1** — KV access is a type-safe optional probe (`cfEnv.DISCOVERY_CACHE` cast through Record) that lights up when the binding is declared, so the endpoint needed no edit when the namespace/cron landed. Same KV id per env is bound in BOTH `wrangler.toml` (reader: top-level + production + staging) and `workers/cron/wrangler.toml` (writer: production + staging) so writer+reader share storage. Runtime tuning via `platform_stats` `discovery_%` dials (code-defaulted, no migration); trending = trailing-window enrollment/join velocity count (not a true prior-window delta — too noisy at Genesis scale).

**Rationale:** Compute-fallback keeps the feature functional in dev before KV/cron exist and makes the precompute path a transparent optimization; the version guard self-invalidates a stale blob on a version bump. Verified both paths live on staging (compute → kv after cron tick).

### UTC ISO 8601 for All Session Times
**Date:** 2026-03-17 Conv 002

All `scheduled_start` and `scheduled_end` values stored as UTC ISO 8601 with Z suffix (e.g., `2026-03-20T18:00:00.000Z`). The POST/PATCH endpoints reject bare datetime strings. Availability API converts teacher-local times to UTC at slot generation time using `src/lib/timezone.ts` (Intl-based, no external dependencies). Browsers display times in the user's local timezone automatically via `toLocaleTimeString()` on Z-suffixed strings.

**Rationale:** Cloudflare Workers parse bare datetime strings as UTC; browsers parse them as local time. This caused session join failures (both parties got "Session time has passed" when arriving on time). Z-suffixed strings are unambiguous across all runtimes. Migration `0003_fix_session_times.sql` normalizes existing data.

> **Insight:** This is the "ambient timezone" antipattern — code implicitly relying on the runtime's default timezone. In serverless/edge where the runtime is always UTC, every datetime crossing the client/server boundary must be explicitly UTC.

### Image Service: Passthrough (No Optimization)
**Date:** 2026-02-16

Use `imageService: 'passthrough'` on the Cloudflare adapter. No Astro `<Image>` components. Plain `<img>` tags with R2 URLs. Image optimization (Cloudinary or CF Image Resizing) deferred to post-MVP.

**Rationale:** Low image volume for MVP. Optimization adds vendor complexity with no measurable benefit. The `passthrough` setting must be on the adapter constructor (not Astro's top-level `image` config) because the adapter overrides Astro's image config.

**See:** `docs/as-designed/image-handling.md`

### Merge to main for Deployment
**Date:** 2025-12-29

Merge development branch to main rather than reconfigure CF Pages branch.

**Rationale:** `main` is standard production convention; cleaner workflow.

### nodejs_compat_v2 Flag
**Date:** 2025-12-29

Use `nodejs_compat_v2` compatibility flag in wrangler.toml.

**Rationale:** Provides more Node.js APIs; better compatibility.

### Environment Detection
**Date:** 2025-12-30

- `DEV`: localhost
- `STG`: CF Pages + branch !== 'main'
- `PROD`: CF Pages + branch === 'main' or production domain

### Stream.io REST API Instead of Node SDK
**Date:** 2026-01-19

Use Stream.io REST API directly with `fetch()` and `jose` for JWT auth instead of the `getstream` Node.js SDK.

**Rationale:** The `getstream` SDK uses `http.Agent` which is incompatible with Cloudflare Workers runtime. Even with `nodejs_compat_v2` and `enable_nodejs_http_modules` flags, Cloudflare's `http.Agent` is a stub that doesn't satisfy the SDK. Code worked locally but failed on CF Pages deployment. REST API works everywhere.

**See:** `src/lib/stream.ts` for implementation, `docs/reference/stream.md` for full caveat.

### Environment Variable Architecture (CF Pages Constraints)
**Date:** 2026-02-06

Non-secret env vars are duplicated in both `.dev.vars` (local dev) and `wrangler.toml [vars]` (Cloudflare deployment). Secrets live in `.dev.vars` (local) and are set via CF dashboard (deployed). Reference files `.secrets.cloudflare.production` and `.secrets.cloudflare.preview` list all secrets for each dashboard tab.

**Rationale:** CF Pages dashboard only allows encrypted secrets when `wrangler.toml` exists — non-secrets must come from `[vars]`. Meanwhile `.dev.vars` must keep non-secrets to override production values with dev values locally. All CF secrets managed via dashboard (not CLI) because `wrangler pages secret put` has no `--env` flag for preview.

**See:** `docs/as-designed/env-vars-secrets.md` for complete reference.

### Stay on Node 22 — Node 24 Blocked by CF Pages
**Date:** 2026-02-16 (updated 2026-04-11, Conv 106 [P6])

Remain on Node 22.19.0. Do not upgrade to Node 24 until Cloudflare Pages adds it to their build image and the current Astro major (Astro 6.x as of Conv 101) officially supports it. Node 22 is supported until April 2027.

**Rationale:** Two blockers: (1) CF Pages build image doesn't include Node 24 (`node-build: definition not found: 24`), (2) Astro 6.x lists Node 18.20.8+, 20.3.0+, and 22.0.0+ as supported; Node 24 is not yet explicitly listed. The build warning ("LTS Maintenance mode") is informational only.

**2026-04-11 update:** Original decision cited Astro 5.x. After PACKAGE-UPDATES Phase 2a (Conv 101) the codebase is on Astro 6.1.5 — the decision still stands, just re-stated against the current Astro major.

**See:** `docs/reference/cloudflare.md` (Node.js Version on CF Pages), `docs/as-designed/devcomputers.md` (Node.js Version)

### Defer Stripe Production Secrets Until Go-Live
**Date:** 2026-02-06

Do not add `STRIPE_SECRET_KEY` or `STRIPE_WEBHOOK_SECRET` to the Cloudflare Production environment until MVP go-live. Live values are stored in `.secrets.cloudflare.production` for reference but should not be entered into the CF Dashboard yet.

**Rationale:** With no Stripe secrets in production, payment endpoints fail gracefully (missing key) rather than processing real charges. This creates a clear launch gate — adding live Stripe secrets becomes an explicit go-live checklist item, not something that's been sitting there untested.

**See:** `.secrets.cloudflare.production` (Stripe section), `docs/as-designed/env-vars-secrets.md` (deployment table)

### Self-Healing API Endpoints for Stripe Status Sync
**Date:** 2026-02-18

The `connect-status` API endpoint derives the correct Stripe account status from live Stripe API data (`active` when charges + payouts + details all enabled) and automatically syncs the database when it detects drift from the stored value. This makes the endpoint write to the DB (was previously read-only).

**Rationale:** Webhooks can be missed (listener not running, network issues, race conditions). Since the endpoint already makes a Stripe API call for the boolean flags, deriving status is essentially free. The `account.updated` webhook remains as an optimization for real-time updates, but the system is correct-by-default even without it.

**See:** `src/pages/api/stripe/connect-status.ts`

### Staging Webhook Active for Stripe (Supersedes "Skip Preview Webhook")
**Date:** 2026-02-18 (Session 224, supersedes Session 223)

Register a Stripe webhook endpoint for the `staging` branch at `staging.peerloop.pages.dev/api/webhooks/stripe`. While per-commit URLs are dynamic, branch-based URLs are stable enough for Stripe webhooks. Uses "Your account" context (6 events: checkout.session.completed, charge.refunded, account.updated, transfer.created, charge.dispute.created, charge.dispute.closed). The `payout.failed` event requires a separate "Connected accounts" endpoint — deferred.

**Rationale:** The Session 223 decision was based on per-commit URLs (`<hash>.peerloop.pages.dev`). Branch-based URLs (`staging.peerloop.pages.dev`) are fixed and suitable. Having webhooks on staging enables full payment flow testing.

**See:** `docs/reference/stripe.md` (Per-Environment Webhook Configuration)

### Dispute Handling Is Critical Infrastructure
**Date:** 2026-02-18 (Session 224)

Implement `charge.dispute.created` and `charge.dispute.closed` webhook handlers as part of core payment infrastructure, not deferred/nice-to-have. Disputes are the only webhook event where silence causes automatic financial loss (Stripe rules against the platform if no evidence is submitted within 7-14 days). On dispute creation: freeze enrollment, mark transaction as disputed, notify admin. On dispute loss: cancel enrollment, reverse transfers to connected accounts to recover platform funds.

**Rationale:** Systematic audit of all Stripe API calls revealed disputes as the most dangerous unhandled event. Unlike `payout.failed` (courtesy notification) or `checkout.session.expired` (cleanup), disputes have urgent financial and operational consequences.

**See:** `src/pages/api/webhooks/stripe.ts` (handleDisputeCreated, handleDisputeClosed)

### Separate R2 Bucket for Staging/Preview
**Date:** 2026-03-27 Conv 037

Created `peerloop-storage-staging` R2 bucket, bound to preview environment in `wrangler.toml`. Production uses `peerloop-storage`.

**Rationale:** D1 and KV were already properly separated between production and preview, but R2 was shared — any test recording replication on preview would write to production R2. Separate bucket matches existing separation pattern. Free.

**See:** `wrangler.toml` (preview R2 binding), `docs/as-designed/env-vars-secrets.md`

### Staging Webhook Strategy (BBB + Stripe + Stream)
**Date:** 2026-03-27 Conv 037 (extends Session 224 Stripe-only decision)

Use `staging.peerloop.pages.dev` as stable webhook target for all vendors. BBB webhooks auto-configure per-meeting (callback URLs derived from `request.url.origin` in `join.ts` — no vendor-side config needed). Stripe requires a second Dashboard endpoint for staging. Stream.io webhooks are available but not used.

**Rationale:** Simplest approach. Staging branch already exists and is used for client approvals. No new infrastructure needed. BBB's per-meeting self-configuration is a key architectural advantage.

**See:** `docs/guides/STAGING-WEBHOOKS-SETUP.md`, `docs/reference/REMOTE-API.md` (webhook status table)

### URL-Embedded HMAC for BBB Webhook Authentication
**Date:** 2026-04-02 Conv 075

BBB's `meta_endCallbackUrl` has no built-in auth mechanism (unlike the analytics callback which uses JWT/HS512). Use HMAC-SHA256(sessionId, BBB_SECRET) as a hex token appended to the webhook URL at room creation time. The webhook handler recomputes the HMAC from the parsed roomId and verifies with constant-time comparison.

**Rationale:** BBB doesn't forward custom headers on callbacks and has no signing mechanism for `meta_endCallbackUrl`. URL-embedded HMAC is the only viable approach. Token is scoped to a specific roomId, preventing replay against different resources. CD-038 (Blindside Networks) confirmed this limitation.

> **Insight:** When a third-party service doesn't support webhook signing, URL-embedded HMAC tokens bound to a resource ID are a practical alternative. The token proves the callback was registered by your system and is scoped to a specific resource, preventing replay.

**See:** `src/lib/webhook-auth.ts`, `src/pages/api/webhooks/bbb.ts`, `src/pages/api/sessions/[id]/join.ts`

### PLATO Seed Data is Local-Dev Only
**Date:** 2026-04-06 Conv 087

PLATO seed data (API-driven scenarios via `tests/plato/`) is exclusively for local development. Staging and production use only the SQL seed chain (core → dev → stripe → booking → feeds). PLATO and SQL seeds use different entity IDs and are incompatible — merging would require reconciling IDs and relationships.

**Rationale:** Staging should match production data shapes. PLATO's value is local flywheel testing, not environment provisioning.

**See:** `docs/as-designed/migrations.md` (PLATO Seed section)

### Astro 6 + @astrojs/cloudflare@13 Incompatible with CF Pages — Workers Migration Required
**Date:** 2026-04-13 Conv 113

`@astrojs/cloudflare@13` generates Workers-format output exclusively. CF Pages builds fail with 3 validation errors (`triggers` empty, KV missing `id`, `ASSETS` reserved binding). Astro maintainer confirmed in GitHub issue #16107: "Astro 6 doesn't support Pages, because the Cloudflare Vite plugin does not." CF's own Pages Astro docs are stale. A temporary `postbuild` script (`scripts/fix-pages-wrangler.mjs`) patches the generated wrangler.json on the staging branch to unblock client review. CF-WORKERS block added to PLAN.md for the permanent Pages→Workers migration.

**Rationale:** Platform limitation — not a choice. The adapter no longer targets Pages. Temporary patch buys time; Workers migration is the only durable path.

> **Insight:** When a framework's deployment adapter changes target platforms between major versions, the vendor's own docs may lag behind. The build errors appeared as "wrangler.json validation" issues, not as a clear "Pages unsupported" message — diagnosing this required reading GitHub issues, not official docs.

**See:** `docs/reference/cloudflare.md` (Astro 6 + Pages Incompatibility)

### reset-d1.js: Idempotent 6-Step Remote Reset with Orphan-Index Handling
**Date:** 2026-04-15 (Conv 122)

`scripts/reset-d1.js` remote path restructured into explicit steps: (1) drop all user indexes first, (2) drop tables in FK dependency order, (3) post-sweep leftover user objects (index→trigger→view→table), (4) clear `d1_migrations`, (5) verify and print leftovers, (6) return false on verification failure. Uses `queryWrangler(sql, base)` with `--json` plus graceful-degradation fallback, and `listUserObjects(base, typeFilter)` filtering out `sqlite_%`, `d1_%`, `_cf_%`.

**Rationale:** Session 359's orphan-index bug (documented in CLAUDE.md with manual recovery procedure) recurred. Durable restructure eliminates the failure class and self-heals prior failed resets. If wrangler lacks `--json`, `listUserObjects` returns `[]` and sweeps become no-ops — preserves pre-change behavior as fallback.

**See:** `scripts/reset-d1.js`, CLAUDE.md §D1 Database Reset

### Vite SSR Cold-Start Dep Discovery: Resolved via `optimizeDeps.entries + include`
**Date:** 2026-05-23 (Conv 177) — supersedes Conv 122 DEV-STAGING-SSR deferral and Conv 176 [NPM-UP] forward-decision

The `Cannot read properties of null (reading 'useState')` SSR crash (Conv 122 → 176 → 177) is the industry-wide Vite cold-start optimizeDeps race, not a duplicate-React-copies issue. Fixed structurally via `astro.config.mjs` Vite config: `optimizeDeps.entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro']` + `include: ['astro/virtual-modules/transitions.js']`. The package upgrade landed alongside (astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, wrangler 4.81.1→4.94.0) but the upgrade alone did NOT fix the crash; the Vite config does. The Conv 176-attempted `resolve.dedupe` + `ssr.noExternal` recipe is unnecessary and is NOT in the current config.

**Rationale:** Conv 177 web research found the same cold-start symptom across Remix (#10156), TanStack/router (#4264), Storybook (#32049), and Vite itself (#17979/#17986). Vite's lazy dep discovery finds a new import on the first request, re-optimizes the deps_ssr bundle, swaps the bundled React copy mid-flight, and the in-flight render hits a null hooks dispatcher. Forcing Vite to pre-scan all source + the Astro virtual module at startup eliminates mid-session re-optimization → no swap → no crash. Diagnostic checklist:
1. Same request reproduces after fresh server start, self-heals on 2nd request → cold-start race (this class, this fix).
2. Crash persists across multiple requests → duplicate React copies (#11825 class, different fix).
3. Production build reproduces → fundamental config issue (neither class).

**Consequences:** All routes (`/`, `/login`, `/discover`, `/matt/`, etc.) return HTTP 200 with `</html>` on cold start. Production build verified clean. Conv 176 [DSSR-SCOPE] closed. Matt-design stateless-primitives discipline retired (see UI/UX section above). `astro/virtual-modules/transitions.js` is the only Astro virtual module currently in `include` — new Astro features that surface in the dev log as `✨ new dependencies optimized: X` should be added to the array.

**See:** `astro.config.mjs` (Vite optimizeDeps block), `docs/reference/DEVELOPMENT-GUIDE.md` § Vite SSR Cold-Start Dep Discovery, Remix #10156, TanStack/router #4264

### `detectOrphanedParticipants`: BBB-Authoritative Cron Pass for One-Sided Participant Crashes
**Date:** 2026-04-21 (Conv 142)

New exported function in `src/lib/booking.ts` called from `runSessionCleanup` **before** `detectStaleInProgress`. Logic: find in-progress sessions past `scheduled_end` with `bbb_meeting_id` and ≥1 open `session_attendance` row → query `bbb.getRoomInfo()` → if inactive, force-close open rows (`left_at = scheduled_end`, per-row `duration_seconds` computed in JS) → call `completeSession()`. Returns `{results, errors}` with per-session error recording so one failed session doesn't block others. Extends `CleanupSummary` with `orphaned_completed[]` + `counts.orphaned_completed`; admin endpoint surfaces the new array. Notifications mirror auto-completed path (`notifySessionNoShow` with "(auto-completed)" suffix). `runSessionCleanup` now runs a **strict narrowing cascade**: noShows → orphaned → staleInProgress → reconcile.

**Rationale:** Empty-room auto-complete requires both participants fire `participant_left`. One-sided crashes (network drop, browser quit) previously waited for the 1-hour DB backstop (`detectStaleInProgress`). BBB is authoritative for "is the room still active" so we ask it directly at `scheduled_end + 0`. Alternatives rejected: tightening `detectStaleInProgress` grace +1h→+15m (false-positives on legitimate long sessions); widening `reconcileBBBSessions` time window (false-positives on mid-session BBB API stalls). The narrowing cascade eliminates double-work — completed orphan sessions drop out before reconcile runs. `detectStaleInProgress` at +1h remains the final DB-only backstop when BBB is unreachable.

> **Insight:** When multiple detection passes operate on overlapping candidate sets, ordering them so each pass narrows the set before the next runs eliminates duplicate external API calls. BBB-authoritative + attendance-aware narrows faster than DB-only passes.

**See:** `src/lib/booking.ts` (`detectOrphanedParticipants`), `src/lib/cleanup.ts` (`runSessionCleanup`), `src/pages/api/admin/sessions/cleanup.ts`

### Partial Unique Index + `INSERT OR IGNORE` for "At Most One Open Row" Invariants
**Date:** 2026-04-21 (Conv 142)

`session_attendance` gets a partial unique index: `CREATE UNIQUE INDEX idx_session_attendance_open_unique ON session_attendance(session_id, user_id) WHERE left_at IS NULL`. Webhook `INSERT INTO session_attendance` changed to `INSERT OR IGNORE INTO session_attendance`. Duplicate `participant_joined` webhook deliveries become DB-level atomic no-ops; legitimate rejoin (join → leave → rejoin) still produces 2 rows because the closed row falls out of the partial index.

**Rationale:** Plain `UNIQUE(session_id, user_id)` would forbid rejoins. `SELECT EXISTS` guard has a race window between check and insert (two simultaneous webhook deliveries could both pass the check). Partial index pushes the invariant to the DB — atomic, race-free. SQLite supports `WHERE` predicates on `CREATE INDEX` natively. Pattern applies to any "at most one open X per Y" invariant that must coexist with legitimate state transitions (close → reopen).

**Pattern:**
```sql
CREATE UNIQUE INDEX idx_X_open_unique ON table(k1, k2) WHERE status_col IS NULL;
-- combined with:
INSERT OR IGNORE INTO table ...
```

**See:** `migrations/0001_schema.sql`, `src/pages/api/webhooks/bbb.ts:211`

### `completeSession` Centralizes `started_at` Backfill via `COALESCE`
**Date:** 2026-04-21 (Conv 142)

Extended `completeSession(db, sessionId, endedAt?, durationSeconds?)` in `src/lib/booking.ts`. Computes `inferredStartedAt = endedAt − durationSeconds` when caller has BBB payload duration, else falls back to `scheduled_start`. UPDATE uses `started_at = COALESCE(started_at, ?)` so existing values are preserved (never overwritten). Webhook path (`handleRoomEnded`) passes `durationSeconds`; the other 4 callers (`detectStaleInProgress`, `reconcileBBBSessions`, admin endpoint, `detectOrphanedParticipants`) omit it and get `scheduled_start` as fallback.

**Rationale:** Any path that completes a session with null `started_at` has the same invariant violation (duration-dependent reads break). Centralizing the fallback in `completeSession` means all 5 call sites automatically get a sensible default without per-caller plumbing. Webhook path keeps its authoritative fallback via the new parameter. `COALESCE` in a single UPDATE is atomic — avoids the read-modify-write race window entirely.

**Pattern:** `UPDATE ... SET nullable_col = COALESCE(nullable_col, ?)` = "set if null, preserve if set" as a one-line change.

**See:** `src/lib/booking.ts` (`completeSession`), `src/pages/api/webhooks/bbb.ts:185`

---

### `checkout.session.expired` Webhook: Intentionally NOT Handled (No-Op)
**Date:** 2026-06-01 (Conv 233)

The `checkout.session.expired` Stripe webhook case is deliberately left unhandled. Its prior `FUTURE` stub comment ("clean up pending enrollment record, free up seat") was misleading: checkout-session creation (`create-session.ts`) writes **nothing** to D1 — the `pendingEnrollmentId` is just a UUID in Stripe metadata, and the enrollment row is created only on success via `createEnrollmentFromCheckout` — and courses have no capacity-limited seats. The stub comment was replaced with an accurate "intentionally not handled, nothing to clean up; revisit if pending-rows or seat-limiting are ever added" note.

**Rationale:** Building the handler would be dead code against patterns (pending-enrollment rows, seat limits) that were never implemented. The `pl_pending_sessions` client-side localStorage hint is cleaned by `MyCourses.tsx`, not the webhook.

**See:** `src/pages/api/webhooks/stripe.ts`; Conv 233.

---

### Checkout Cancel Feedback via Transient Toast (Not a Page)
**Date:** 2026-06-01 (Conv 233)

When a buyer abandons Stripe Checkout, `cancel_url` now appends `?enroll=cancelled` and returns to `/course/[slug]`; a small client island (`CheckoutCancelToast.tsx`, mounted on the About view) fires a one-time "you weren't charged" toast via the existing `showToast` and strips the param. Rejected: a dedicated cancel page, and leaving the bare-course-page silence.

**Rationale:** A transient confirmation is an overlay, not an addressable page (routing-addressability rule); the unhappy path is undrawn by Matt so no frame is needed; the toast is cheap and honest about the non-charge.

**See:** `src/lib/stripe.ts` (cancel_url), `src/components/courses/CheckoutCancelToast.tsx`, `docs/reference/stripe.md`; Conv 233.

---

### Per-Course Teacher-Earnings Aggregate: Mirror the Canonical Query, Honest Zero-State
**Date:** 2026-06-01 (Conv 233)

The precheckout page's earnings figure is computed from a real aggregate — `payment_splits` (`recipient_type='teacher'`) joined through `enrollments.course_id` — mirroring the canonical per-course query in `api/teaching/courses/[courseId].ts` (dropping its per-recipient filter; **no** `status` filter). Surfaced as `teacherEarningsCents` on `CourseTabData` from `fetchCourseTabData`. Rendered live as a whole-dollar total when >0, else forward-looking copy with **no fabricated number** (the static `$7,438` demo figure is retired).

**Rationale:** Consistency with what teachers already see on their own dashboards (same query) plus honest $0 handling; supersedes the Conv-189 static-demo earnings placeholder.

**See:** `src/lib/ssr/loaders/courses.ts`, `src/components/course/PrecheckoutContent.astro`; Conv 233.

---

### Pre-Launch Schema Edits Force a Destructive Staging-DB Reset to Converge
**Date:** 2026-06-28 (Conv 348)

Converging a stale staging D1 with the current schema requires a **destructive** `db:reset:staging` → re-migrate → re-seed (`db:setup:staging:feeds`), NOT `wrangler d1 migrations apply`. Because pre-launch schema edits land directly in the already-tracked `migrations/0001_schema.sql` (not incremental `0003_*` migrations), D1's migration tracker counts `0001` as applied and will never re-apply the edits. Conv 348 deployed jfg-dev-14 (167 commits ahead of the Conv-261 staging deploy, `0001_schema.sql` changed in 7 of them) and ran a feeds-level destructive reseed to land the new tables (homework, promote-pipeline, system feed, announcements). Staging data is reproducible seed data, so the wipe is acceptable; feeds level gives the most complete demo data.

**Rationale:** Only a reset re-runs the edited `0001`. This is the central gotcha of any large pre-launch staging redeploy. (Post-launch, incremental `0003_*.sql` migrations apply cleanly and this no longer holds.)

**See:** `docs/reference/staging-deploy-runbook.md`; `migrations/0001_schema.sql`; Conv 348.

---

### Dedicated Staging-Deploy Runbook (Operational How, Separate from cloudflare.md Reference)
**Date:** 2026-06-28 (Conv 348)

The step-by-step staging-deploy procedure lives in a new linear, copy-pasteable `docs/reference/staging-deploy-runbook.md` (manual category) — pre-flight gates → DB convergence → worker + cron deploy → smoke test → rollback — rather than as a subsection of `cloudflare.md`. Cross-linked from `cloudflare.md` §Workers Deployment and `plan/deployment/README.md`.

**Rationale:** `cloudflare.md` is the reference/*why* (legacy_env double-suffix, SSR self-fetch, secrets recipe); a runbook is the operational *how*. Distinct artifacts; the runbook is reusable for future deploys and was executed verbatim in Conv 348.

**See:** `docs/reference/staging-deploy-runbook.md`, `docs/reference/cloudflare.md`, `plan/deployment/README.md`; Conv 348.

---

