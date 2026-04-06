# Scripts Reference

Complete reference for all npm scripts and utility scripts in the Peerloop project.

- **npm scripts**: Defined in `package.json`, run via `npm run <name>`
- **Script files**: Located in `Peerloop/scripts/`, called by npm scripts or run directly

Related: [CLI-QUICKREF.md](CLI-QUICKREF.md) | [CLI-REFERENCE.md](CLI-REFERENCE.md) | [CLI-TESTING.md](CLI-TESTING.md)

---

## npm Scripts Overview

All commands run from the code repo: `cd ../Peerloop && npm run <name>`

### Development

| Command | Description |
|---------|-------------|
| `npm run dev` | Start local dev server (local D1) |
| `npm run dev:staging` | Dev server with remote staging D1 |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build locally |
| `npm run start` | Alias for `dev` |

### Code Quality

| Command | Description |
|---------|-------------|
| `npm run check` | Astro diagnostics |
| `npm run typecheck` | TypeScript type check (`tsc --noEmit`) |
| `npm run lint` | ESLint on `src/` |
| `npm run lint:fix` | ESLint with auto-fix |
| `npm run lint:tz` | Check test files for timezone-unsafe date patterns |
| `npm run format` | Prettier format `src/` |
| `npm run format:check` | Check formatting without changes |
| `npm run check:tailwind` | Check for Tailwind v3 classes needing v4 update |

### Testing

| Command | Description |
|---------|-------------|
| `npm run test` | Run all unit/integration tests once |
| `npm run test:watch` | Run tests in watch mode |
| `npm run test:ui` | Run tests with Vitest UI dashboard |
| `npm run test:unit` | Run `tests/unit/` only |
| `npm run test:api` | Run `tests/api/` only |
| `npm run test:integration` | Run `tests/integration/` only |
| `npm run test:e2e` | Run Playwright end-to-end tests |
| `npm run test:all` | Run unit + E2E tests sequentially |
| `npm run test:reset-db` | Reset test database state |

### PLATO

| Command | Description |
|---------|-------------|
| `npm run test:plato` | Run PLATO flow tests (`tests/plato/`) |
| `npm run plato:restore` | API-run instance + restore snapshot to local D1 (combined) |
| `npm run plato:snapshot:restore` | Restore existing snapshot to local D1 (restore only) |
| `npm run plato:seed` | API-run seed-dev + snapshot → restore to local D1 |
| `npm run plato:seed:staging` | Export PLATO snapshot → reset + apply to staging D1 |
| `npm run plato:split` | Split instance at step N into Pre/Post segment files |
| `npm run plato:split-cleanup` | Promote or delete split segment files (interactive + flags) |

### Database

| Command | Target | Description |
|---------|--------|-------------|
| `npm run db:setup:local` | Local | Reset + migrate (production-like) |
| `npm run db:setup:local:dev` | Local | + dev seed |
| `npm run db:setup:local:stripe` | Local | + dev + Stripe sandbox accounts |
| `npm run db:setup:local:booking` | Local | + dev + Stripe + booking test scenario |
| `npm run db:setup:staging` | Staging | Reset + migrate (production-like) |
| `npm run db:setup:staging:dev` | Staging | + dev seed |
| `npm run db:setup:staging:stripe` | Staging | + dev + Stripe sandbox accounts |
| `npm run db:setup:staging:booking` | Staging | + dev + Stripe + booking test scenario |
| `npm run db:migrate:local` | Local | Apply migrations |
| `npm run db:migrate:staging` | Staging | Apply migrations |
| `npm run db:migrate:prod` | Production | Apply migrations (requires confirmation) |
| `npm run db:seed:local` | Local | Apply dev seed data |
| `npm run db:seed:staging` | Staging | Apply dev seed data |
| `npm run db:seed:stripe:local` | Local | Apply Stripe sandbox account IDs (opt-in, from `0002_seed_stripe.sql`) |
| `npm run db:seed:stripe:staging` | Staging | Apply Stripe sandbox account IDs (opt-in, from `0002_seed_stripe.sql`) |
| `npm run db:seed:booking:local` | Local | Apply booking test scenario (from `0003_seed_booking_test.sql`) |
| `npm run db:seed:booking:staging` | Staging | Apply booking test scenario (from `0003_seed_booking_test.sql`) |
| `npm run db:seed:prod` | Production | 🚫 **BLOCKED** — dev seed cannot be applied to production |
| `npm run db:studio:local` | Local | Open D1 Studio (browser GUI) |
| `npm run db:studio:staging` | Staging | Open D1 Studio |
| `npm run db:studio:prod` | Production | Open D1 Studio (requires confirmation) |
| `npm run db:reset:local` | Local | Drop all tables |
| `npm run db:reset:staging` | Staging | Drop all tables (dependency-aware) |
| `npm run db:reset:prod` | Production | 🚫 **BLOCKED** — production reset is prevented |
| `npm run db:validate` | In-memory | Validate migration SQL syntax |

### Cloudflare Deployment

| Command | Description |
|---------|-------------|
| `npm run cf:dev` | Serve `dist/` with wrangler Pages dev server |
| `npm run cf:deploy` | Deploy `dist/` to Cloudflare Pages |
| `npm run cf:tail` | Tail Cloudflare deployment logs |

### R2 Storage

| Command | Description |
|---------|-------------|
| `npm run r2:list:local` | List objects in local R2 emulation |
| `npm run r2:list:remote` | List objects in remote R2 |

### Diagrams

| Command | Description |
|---------|-------------|
| `npm run mock-diagram` | Generate mock data relationship diagram |
| `npm run mock-diagram:html` | Generate mock data diagram as HTML |

### External Services

| Command | Description |
|---------|-------------|
| `npm run stripe:listen` | Forward Stripe webhooks to `localhost:4321/api/webhooks/stripe` |
| `npm run dev:webhooks` | Start full webhook dev environment (preflight checks, dev server, Stripe CLI forwarding, cleanup trap) |
| `npm run trigger` | Trigger a single webhook event for manual testing (usage: `npm run trigger -- <event>`) |

### Lifecycle

| Command | Description |
|---------|-------------|
| `postinstall` | Auto-hash `package-lock.json` after `npm install` |
| `npm run env:check` | Validate dev environment (Node, npm, Wrangler, Stripe, etc.) |

---

## Script Files

Located in `Peerloop/scripts/`. Run directly with `node`, `tsx`, or `bash`, or via the npm scripts that call them.

### Environment & Safety

#### `scripts/check-env.sh`

Validate that all required development tools are installed and configured.

```bash
bash scripts/check-env.sh
```

**What it does:**
- Checks Node.js, npm, Wrangler, Stripe CLI, Git
- Verifies `.dev.vars` and `.env` symlink exist
- Verifies `node_modules` is installed
- Displays OK/FAIL status for each check

**Called by:** `npm run env:check`

---

#### `scripts/check-tailwind-v4.sh`

Scan source files for Tailwind v3 utility classes that need v4 equivalents.

```bash
bash scripts/check-tailwind-v4.sh [search-path]
```

**What it does:**
- Searches for deprecated v3 classes (e.g., `bg-opacity-*`, `text-opacity-*`)
- Reports files and line numbers with matches
- Default search path: `src/`

**Called by:** `npm run check:tailwind`

---

#### `scripts/lint-timezone.sh`

Detect timezone-unsafe patterns in test files and source files. Two scan phases:

```bash
bash scripts/lint-timezone.sh
```

**Phase 1 — Test files (`tests/`, `e2e/`):**
- FAIL: `setHours()` (should be `setUTCHours()`), `new Date(year, month, day)` (should use `Date.UTC()` or `utcDate()` helper)
- WARN: `getDate()`/`getDay()` in non-component tests (should consider UTC equivalents)
- Exempt: lines with `// tz-exempt` comment (for intentional local-time constructs, e.g., `toISO` format tests) (Conv 091)

**Phase 2 — Source files (`src/pages/api/`, `src/lib/`) (Conv 089):**
- FAIL: bare `new Date()` or `Date.now()` — should use `getNow()` from `@lib/clock`
- Exempt: lines with `// getNow-exempt` comment (for legitimate uses like DB ID generation, clock.ts itself)

**Exit code:** 1 on any FAILs, 0 if clean.

**Called by:** `npm run lint:tz`

---

#### `scripts/dev-webhooks.sh`

Orchestrate a full webhook development environment — preflight checks, dev server startup with health check, Stripe CLI forwarding, and cleanup on exit. (Conv 091)

```bash
bash scripts/dev-webhooks.sh
# or: npm run dev:webhooks
```

**What it does:**
- Preflight: checks Stripe CLI installed, `.dev.vars` exists, WEBHOOK_SECRET_STRIPE set
- Starts `npm run dev` in the background, polls `/api/health/db` until ready
- Launches `npm run stripe:listen` (Stripe CLI forwarding to localhost:4321)
- Registers a cleanup trap (kills both processes on exit)
- Prints instructions for triggering events with `npm run trigger`

**Prerequisites:** Stripe CLI authenticated (`stripe login`). `.dev.vars` with `WEBHOOK_SECRET_STRIPE`.

**Called by:** `npm run dev:webhooks`

---

#### `scripts/trigger-webhook.sh`

Trigger individual webhook events for manual testing — 3 Stripe events via Stripe CLI and 3 BBB events via synthetic HMAC-signed POST. (Conv 091)

```bash
bash scripts/trigger-webhook.sh <event>
# or: npm run trigger -- <event>
```

**Supported events:**

| Event | Type | Description |
|-------|------|-------------|
| `checkout` | Stripe | `checkout.session.completed` with seed-data metadata overrides |
| `refund` | Stripe | `charge.refunded` (synthetic, no DB match) |
| `dispute` | Stripe | `charge.dispute.created` (synthetic, no DB match) |
| `bbb-meeting-ended` | BBB | `meeting-ended` event for seed session |
| `bbb-user-joined` | BBB | `user-joined` event for seed session |
| `bbb-user-left` | BBB | `user-left` event for seed session |

**BBB HMAC:** Uses `openssl dgst -sha256 -hmac` to generate signatures. Produces identical output to Web Crypto `HMAC-SHA256` (verified test vector: both produce `51825373bdd06272b7861a11bded98d02c786641b2042103c1257899b31fbc7c`).

**Stripe fixture alignment:** The `checkout` trigger injects 7 metadata fields (`user_id`, `course_id`, `teacher_certification_id`, `enrollment_type`, `price`, `teacher_payout`, `creator_payout`) to match seed data records.

**Called by:** `npm run trigger`

---

#### `scripts/confirm-prod.js`

Safety gate requiring explicit typed confirmation before production database operations.

```bash
node scripts/confirm-prod.js
```

**What it does:**
- Prompts user to type "production" to confirm
- Exits with error if confirmation doesn't match
- 5-second timeout before prompt appears

**Called by:** `npm run db:migrate:prod`, `npm run db:studio:prod`

---

#### `scripts/link-docs.sh`

Create symlinks from the code repo to the docs repo for build-time dependencies.

```bash
bash scripts/link-docs.sh
```

**What it does:**
- Creates `Peerloop/docs → ../peerloop-docs/docs`
- Creates `Peerloop/research → ../peerloop-docs/research`
- Run once per machine after cloning

**Called by:** Manual (one-time setup)

---

### Database

#### `scripts/reset-d1.js`

Drop all tables and clear migration tracking for a D1 database.

```bash
node scripts/reset-d1.js --local
node scripts/reset-d1.js --env preview --remote
```

**What it does:**
- **Local:** Deletes SQLite files in `.wrangler/state/v3/d1/`
- **Remote:** Parses `0001_schema.sql` for FK relationships, drops tables in dependency order (children before parents)
- Clears the `d1_migrations` tracking table
- Distinguishes self-referential FKs (informational) from true cross-table circular dependencies (warning)

**Args:** `--local`, `--remote`, `--env preview`

**Called by:** `npm run db:reset:local`, `npm run db:reset:staging`

---

#### `scripts/reset-test-db.ts`

Reset the test database by re-applying all migrations (excludes seed files).

```bash
npx tsx scripts/reset-test-db.ts
```

**What it does:**
- Drops and recreates the in-memory test database
- Applies only schema migrations (filters out files containing "seed")
- Used to get a clean test state

**Called by:** `npm run test:reset-db`

---

### Diagrams

#### `scripts/generate-mock-data-diagram.ts`

Generate Mermaid diagram showing mock data relationships (users, courses, enrollments, certificates).

```bash
npx tsx scripts/generate-mock-data-diagram.ts         # Mermaid to stdout
npx tsx scripts/generate-mock-data-diagram.ts --html  # HTML with rendered diagram
```

**Called by:** `npm run mock-diagram`, `npm run mock-diagram:html`

---

### Documentation

#### `scripts/route-matrix.mjs`

Scan all Astro pages and generate page interconnection docs (adjacency matrix, grid TSVs, markdown).

```bash
npm run route-matrix
# or: node scripts/route-matrix.mjs
```

**What it does:**
- Enumerates all `.astro` page files and maps to route patterns
- Detects layout (AppLayout/AdminLayout) per page
- Extracts links from pages and imported components (2 levels deep)
- Models shared nav components (Footer, AppNavbar, etc.) as pseudo-pages
- Normalizes hardcoded literal slugs (e.g., `/community/the-commons`) to dynamic route equivalents (`/community/[slug]`)
- Reports broken links (routes referenced but no `.astro` page exists)

**Outputs (4 files):**
- `docs/as-designed/page-connections.md` — Detailed markdown with broken links, pseudo-pages, per-page details
- `docs/as-designed/ROUTE-ADJACENCY-MATRIX.tsv` — Full NxN matrix (FROM\TO with link types)
- `docs/as-designed/ROUTE-GRID-REFERENCE.tsv` — Flat lookup: Code → Route → Group → per-type connections
- `docs/as-designed/ROUTE-GRID-MAP.tsv` — Visual spatial grid layout by group

**Called by:** `npm run route-matrix`

---

#### `scripts/route-api-map.mjs`

Scan all Astro pages and components, extract fetch() calls, trace imports, build route↔API mapping with BFS navigation paths.

```bash
npm run route-api-map
# or: node scripts/route-api-map.mjs
```

**What it does:**
- Scans all `.astro` and `.tsx` page files, extracts `fetch()` calls to API endpoints
- Traces component imports 2 levels deep to capture API calls in child components
- Computes BFS navigation paths from AppNavbar, AdminNavbar, and DiscoverSlidePanel
- Detects outbound links per page for same-page navigation
- Adds tab sub-routes as explicit edges for dynamic href detection

**Outputs (2 files):**
- `docs/as-designed/route-api-map.md` — Markdown reference with 3 tables (route→API, API→route, nav paths)
- `tests/plato/route-map.generated.ts` — TypeScript lookup with `routeMap`, `apiToRoutes`, helper functions (`routesForApi()`, `navPathTo()`, `apisOnRoute()`)

**Stats (Conv 074):** 96 pages scanned, 195 API endpoints found, 89 routes reachable from navbar.

**Called by:** `npm run route-api-map`

---

### Seed Data

#### `scripts/seed-feeds.mjs`

Seed Stream.io feeds and D1 `feed_activities` for smart feed E2E testing.

```bash
node scripts/seed-feeds.mjs --local --clean     # Local D1 + Stream DEV app
node scripts/seed-feeds.mjs --staging --clean    # Staging D1 + Stream DEV app
```

**What it does:**
- Creates 14 activities across 8 feeds (townhall, community, course) via Stream REST API
- Adds 17 reactions (likes, comments, celebrates) for engagement signal testing
- Dual-writes `feed_activities` rows to D1 with real `stream_activity_id`
- Seeds `feed_visits` for 4 users at staggered timestamps (unseen badge testing)
- `--clean` flag clears existing `feed_activities`, `feed_visits`, and `smart_feed_dismissals`

**Prerequisites:** Dev seed data must be applied first (users, communities, courses). Stream credentials in `.dev.vars`.

**Called by:** `npm run db:seed:feeds:local`, `npm run db:seed:feeds:staging`

---

### PLATO Snapshot Scripts

#### `scripts/plato-restore.js`

Combined API-run + snapshot restore. Runs the named instance via Vitest, then copies the snapshot into the local D1 directory.

```bash
npm run plato:restore -- flywheel-to-enrollment
```

**What it does:**
- Runs `vitest run tests/plato --testNamePattern=<name>` to execute the instance (API-run)
- Sets `PLATO_INSTANCE` env var so the dynamic test runner creates a describe block for the instance
- The API-run produces a snapshot via `better-sqlite3.serialize()` (opt-in `snapshot: true` on instance)
- Calls `plato-restore-snapshot.js` to copy the snapshot into wrangler's local D1 SQLite file
- Always regenerates — no caching, no staleness concerns (~400ms)

**Called by:** `npm run plato:restore`

---

#### `scripts/plato-restore-snapshot.js`

Restore a PLATO snapshot file into the local D1 database (restore only, no API-run).

```bash
npm run plato:snapshot:restore -- flywheel-to-enrollment
```

**What it does:**
- Checks port 4321 is free (aborts if dev server is running — prevents SQLITE_CORRUPT)
- Reads snapshot from `tests/plato/snapshots/<name>.db`
- Copies it into `.wrangler/state/v3/d1/` as the local D1 SQLite file
- Dev server immediately serves the snapshot state

**Called by:** `npm run plato:snapshot:restore`

---

#### `scripts/plato-split.js`

Split a PLATO instance at a specific step into Pre/Post segment files for browser walkthrough testing.

```bash
npm run plato:split -- <instance-name> --at <step-name-or-number>
npm run plato:split -- flywheel --at enroll-student
npm run plato:split -- flywheel --at 9
```

**What it does:**
- Reads the instance's scenario chain to find the split point
- Creates `<instance>-pre-<N>.instance.ts` (with `snapshot: true`) containing steps 1 through N
- Creates `<instance>-post-<N>.instance.ts` containing steps N+1 onward
- Both files use inline scenarios (no separate `.scenario.ts` files)
- Auto-registers both in `instances/index.ts`

**Lifecycle:** Split → API-run Pre (snapshot) → restore snapshot → browser-walk Post → cleanup

**Called by:** `npm run plato:split`

---

#### `scripts/plato-split-cleanup.js`

Promote or delete split segment files after browser walkthrough testing.

```bash
# Interactive (terminal prompts per-side: keep/delete/skip)
npm run plato:split-cleanup
npm run plato:split-cleanup -- flywheel

# Non-interactive (flags)
npm run plato:split-cleanup -- --keep flywheel-pre-9 --delete flywheel-post-9
npm run plato:split-cleanup -- --delete-all
```

**What it does:**
- **Keep:** Extracts inline scenario to a named `.scenario.ts` file, rewrites instance to reference it, registers in `scenarios/index.ts`
- **Delete:** Removes `.instance.ts` file, unregisters from `instances/index.ts`
- **Skip:** Leaves files as-is

**Flags:** `--keep <name>`, `--delete <name>`, `--delete-all`

**Called by:** `npm run plato:split-cleanup`

---

#### `scripts/plato-seed-staging.js`

Export a PLATO snapshot as SQL and apply it to a remote D1 database (staging).

```bash
npm run plato:seed:staging
# or: node scripts/plato-seed-staging.js
```

**What it does:**
- Exports snapshot (`tests/plato/snapshots/seed-dev.sqlite`) to SQL via `sqlite3 .dump`
- Filters out PRAGMA/TRANSACTION wrappers (D1 handles these)
- Resets staging D1 (drops all user tables via `reset-d1.js`)
- Applies the dump SQL via `wrangler d1 execute --file`
- Marks all production migrations as applied in `d1_migrations` (so wrangler doesn't re-apply schema)

**Prerequisites:** PLATO snapshot must exist (generate with `npm run plato:seed`). Wrangler must be authenticated.

**Called by:** `npm run plato:seed:staging`

---

### Integration Tests

#### `scripts/run-feed-isolation-test.js`

Test Stream.io feed isolation — verify posts to one feed don't leak to another.

```bash
node scripts/run-feed-isolation-test.js
BASE_URL=https://staging.peerloop.pages.dev node scripts/run-feed-isolation-test.js
```

**What it does:**
- Generates a JWT token for test user
- Posts to a specific feed via API
- Verifies the post appears only in the intended feed
- Default: `http://localhost:4321`

**Called by:** Not in npm scripts (run directly)

---

#### `scripts/test-feed-isolation.sh`

Bash version of the feed isolation test using session cookies.

```bash
bash scripts/test-feed-isolation.sh <session_cookie>
```

**What it does:**
- Uses `curl` with an existing session cookie
- Tests feed posting and isolation
- Simpler than the JS version (no JWT generation)

**Called by:** Not in npm scripts (run directly)

---

## Cross-Reference: npm Scripts to Script Files

| npm Script | Script File |
|-----------|-------------|
| `env:check` | `scripts/check-env.sh` |
| `check:tailwind` | `scripts/check-tailwind-v4.sh` |
| `db:reset:local` | `scripts/reset-d1.js --local` |
| `db:reset:staging` | `scripts/reset-d1.js --env preview --remote` |
| `db:migrate:prod` | `scripts/confirm-prod.js` + wrangler |
| `db:studio:prod` | `scripts/confirm-prod.js` + wrangler |
| `test:reset-db` | `scripts/reset-test-db.ts` |
| `mock-diagram` | `scripts/generate-mock-data-diagram.ts` |
| `mock-diagram:html` | `scripts/generate-mock-data-diagram.ts --html` |
| `route-matrix` | `scripts/route-matrix.mjs` |
| `route-api-map` | `scripts/route-api-map.mjs` |
| `db:seed:feeds:local` | `scripts/seed-feeds.mjs --local --clean` |
| `db:seed:feeds:staging` | `scripts/seed-feeds.mjs --staging --clean` |
| `plato:restore` | `scripts/plato-restore.js` |
| `plato:snapshot:restore` | `scripts/plato-restore-snapshot.js` |
| `plato:seed` | `scripts/plato-restore.js seed-dev` |
| `plato:seed:staging` | `scripts/plato-seed-staging.js` |
| `plato:split` | `scripts/plato-split.js` |
| `plato:split-cleanup` | `scripts/plato-split-cleanup.js` |

| `dev:webhooks` | `scripts/dev-webhooks.sh` |
| `trigger` | `scripts/trigger-webhook.sh <event>` |

### Standalone Scripts (no npm wrapper)

| Script | How to Run |
|--------|-----------|
| `scripts/link-docs.sh` | `bash scripts/link-docs.sh` |
| `scripts/run-feed-isolation-test.js` | `node scripts/run-feed-isolation-test.js` |
| `scripts/test-feed-isolation.sh` | `bash scripts/test-feed-isolation.sh <cookie>` |

---

## Data Flow

```
src/lib/mock-data.ts                    (mock users, courses, enrollments)
         |
    generate-mock-data-diagram.ts
         |
         v
  (stdout or docs/mock-data-diagram.html)
```

*Note: The page spec JSON pipeline (parse → generate → audit) and all related audit scripts were removed in Sessions 307+311. See git history.*
