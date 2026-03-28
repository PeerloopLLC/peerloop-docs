# CLI Reference

Detailed documentation for all non-test CLI commands. For quick reference, see [CLI-QUICKREF.md](CLI-QUICKREF.md). For testing commands, see [CLI-TESTING.md](CLI-TESTING.md).

---

## Development Commands

### `npm run dev`

Start the development server.

```bash
npm run dev
```

**What it does:**
- Executes `astro dev`
- Starts local server at `http://localhost:4321`
- Hot module replacement enabled
- Watches for file changes

**Common options:**
```bash
# Different port
npm run dev -- --port 3000

# Expose to network
npm run dev -- --host
```

---

### `npm run dev:staging`

Start the development server connected to the **remote staging D1 database**.

```bash
npm run dev:staging
```

**What it does:**
- Sets `USE_STAGING_DB=1` then executes `astro dev`
- Connects to `peerloop-db-staging` via `getPlatformProxy({ environment: 'preview', remoteBindings: true })`
- Hot module replacement still works — same dev experience as `npm run dev`
- **Warning:** Writes from local dev will modify the staging database

**Use case:** Reproduce bugs that staging users report using the same data they see.

---

### `npm run build`

Build for production.

```bash
npm run build
```

**What it does:**
- Executes `astro build`
- Outputs to `./dist`
- Optimizes assets (minification, bundling)
- Generates static pages where possible

**Output:**
- `dist/` - Production-ready files
- `dist/_astro/` - Hashed assets

---

### `npm run preview`

Preview the production build locally.

```bash
npm run preview
```

**What it does:**
- Executes `astro preview`
- Serves `./dist` folder
- Simulates production environment locally

**Prerequisites:**
- Run `npm run build` first

---

### `npm run start`

Alias for `npm run dev`.

---

### `npm run check`

Run Astro diagnostics.

```bash
npm run check
```

**What it does:**
- Executes `astro check`
- Validates `.astro` file syntax
- Checks component imports
- Reports template errors

---

### `npm run typecheck`

Run TypeScript type checking.

```bash
npm run typecheck
```

**What it does:**
- Executes `tsc --noEmit`
- Checks all TypeScript files
- Reports type errors without emitting files

**Use when:**
- Before committing
- CI validation
- Debugging type issues

---

### `npm run lint`

Run ESLint.

```bash
npm run lint
```

**What it does:**
- Executes `eslint src/`
- Checks for code quality issues
- Reports violations

---

### `npm run lint:fix`

Run ESLint with auto-fix.

```bash
npm run lint:fix
```

**What it does:**
- Executes `eslint src/ --fix`
- Automatically fixes fixable issues
- Reports remaining violations

---

### `npm run format`

Format code with Prettier.

```bash
npm run format
```

**What it does:**
- Executes `prettier --write "src/**/*.{astro,js,jsx,ts,tsx}"`
- Formats all source files in place
- Applies consistent code style

---

### `npm run format:check`

Check formatting without changes.

```bash
npm run format:check
```

**What it does:**
- Executes `prettier --check "src/**/*.{astro,js,jsx,ts,tsx}"`
- Reports files that need formatting
- Exits with error if formatting issues found

**Use when:**
- CI validation
- Pre-commit check

---

### `npm run check:tailwind`

Check for Tailwind v4 compatibility issues.

```bash
npm run check:tailwind
```

**What it does:**
- Executes `scripts/check-tailwind-v4.sh`
- Greps for known Tailwind v3→v4 class renames across the project
- Reports files and line numbers where deprecated classes are found

**Checks for:**
- `bg-gradient-to-*` → should be `bg-linear-to-*`
- `shadow-sm` → should be `shadow-xs` (size shift)
- `blur-sm` → should be `blur-xs`
- `rounded-sm` → should be `rounded-xs`
- `outline-none` → should be `outline-hidden` (behavior change)
- Deprecated opacity utilities (`bg-opacity-*`, `text-opacity-*`)
- Renamed flex utilities (`flex-shrink-*` → `shrink-*`)

**Use when:**
- Before commits (catches v4 deprecations build won't catch)
- After upgrading Tailwind
- When IDE doesn't flag all issues (Tailwind IntelliSense only works on open files)

**Note:** This script is a workaround for Tailwind v4's lack of official CLI linting. eslint-plugin-tailwindcss has only beta v4 support with false positives.

---

## Database Commands

> Full documentation: [migrations.md](../architecture/migrations.md)

### Migration Strategy

Peerloop uses a split seed strategy for production safety:

```
migrations/              # PRODUCTION-SAFE (applied everywhere)
├── 0001_schema.sql      # Table definitions
└── 0002_seed_core.sql   # Essential data (topics, tags, admin, The Commons)

migrations-dev/          # DEV ONLY (local + staging)
└── 0001_seed_dev.sql    # Test data (users, courses, etc.)
```

---

### `npm run db:setup:local`

Production-like setup: reset + migrate only (schema + core seed).

```bash
npm run db:setup:local
```

**What it does:**
1. Resets local database (deletes SQLite files)
2. Applies migrations (schema + core seed)

**Use when:**
- Testing fresh production flows
- Testing signup, course creation from scratch
- Verifying production-like behavior

---

### `npm run db:setup:local:dev`

Dev setup: reset + migrate + dev seed.

```bash
npm run db:setup:local:dev
```

**What it does:**
1. Runs `db:setup:local` (reset + migrate)
2. Applies dev seed (test users, courses, etc.)

**Use when:**
- Starting fresh development
- After schema changes
- Need test data

---

### `npm run db:setup:local:stripe`

Dev setup + Stripe: reset + migrate + dev seed + Stripe seed.

```bash
npm run db:setup:local:stripe
```

**What it does:**
1. Runs `db:setup:local:dev` (reset + migrate + dev seed)
2. Runs `db:seed:stripe:local` (Stripe sandbox account IDs)

**Use when:**
- Testing checkout/enrollment flows that need Stripe connected accounts

---

### `npm run db:setup:local:booking`

Full dev setup: reset + migrate + dev seed + Stripe seed + booking seed.

```bash
npm run db:setup:local:booking
```

**What it does:**
1. Runs `db:setup:local:stripe` (reset + migrate + dev + Stripe)
2. Runs `db:seed:booking:local` (Alex Chen enrollment in AI Tools Overview)

**Use when:**
- Testing the session booking flow (`/course/ai-tools-overview/book`)
- Login as `newuser@example.com` / `dev123`
- Scenario: Alex Chen has a completed purchase, assigned to Sarah Miller, ready to book

---

### Staging equivalents

The same additive chain exists for staging (`db:setup:staging`, `db:setup:staging:dev`, `db:setup:staging:stripe`, `db:setup:staging:booking`), targeting the remote D1 database.

---

### `npm run db:migrate:local`

Apply migrations to local D1 database.

```bash
npm run db:migrate:local
```

**What it does:**
- Executes `wrangler d1 migrations apply peerloop-db --local`
- Applies pending migrations to local SQLite

**Note:** Only works on machines with local D1 setup (Mac Mini).

---

### `npm run db:migrate:prod`

Apply migrations to production D1. **Requires confirmation.**

```bash
npm run db:migrate:prod
```

**What it does:**
- Prompts: "Type 'production' to confirm"
- Executes `wrangler d1 migrations apply peerloop-db --remote`

**Use when:**
- Deploying schema changes to production
- After testing migrations locally

---

### `npm run db:seed:local`

Apply dev seed to local database.

```bash
npm run db:seed:local
```

**What it does:**
- Executes dev seed file (`migrations-dev/0001_seed_dev.sql`)
- Adds test users, courses, enrollments, etc.

---

### `npm run db:seed:stripe:local`

Apply Stripe sandbox connected account IDs to local database. Included in `db:setup:local:stripe` and above, or run standalone after `db:setup:local:dev`.

```bash
npm run db:seed:stripe:local
```

**What it does:**
- Executes Stripe seed file (`migrations-dev/0002_seed_stripe.sql`)
- Sets `stripe_account_id`, `stripe_account_status`, `stripe_payouts_enabled` on Guy Rymberg, Sarah Miller, Marcus Thompson
- Uses placeholder `acct_REPLACE_*` values — replace with real Stripe test-mode Express account IDs before use

**Prerequisites:** Must run `npm run db:setup:local:dev` first (users must exist).

**See:** `migrations-dev/README.md` for setup instructions.

---

### `npm run db:seed:stripe:staging`

Apply Stripe sandbox connected account IDs to staging database. Opt-in.

```bash
npm run db:seed:stripe:staging
```

Same as `db:seed:stripe:local` but targets the staging D1 database (`DB --env preview --remote`).

---

### `npm run db:seed:feeds:local`

Seed Stream.io feeds and D1 `feed_activities` for smart feed E2E testing.

```bash
npm run db:seed:feeds:local
```

Runs `node scripts/seed-feeds.mjs --local --clean`. Creates 14 activities across 8 feeds (townhall, community, course) via the Stream REST API, adds 17 reactions (likes, comments, celebrates), and dual-writes metadata to D1 `feed_activities` + `feed_visits` tables. The `--clean` flag clears existing feed data before seeding.

**Prerequisites:** Dev seed data must be applied first (`npm run db:setup:local:dev`). Stream API credentials must be in `.dev.vars`.

**Staging variant:** `npm run db:seed:feeds:staging` — same script targeting staging D1 + shared DEV Stream app.

---

### `npm run db:seed:prod`

🚫 **BLOCKED** - Cannot apply dev seed to production.

```bash
npm run db:seed:prod  # Will ERROR
```

This command is intentionally blocked to prevent test data in production.

---

### `npm run db:reset:local`

Reset local D1 database by deleting SQLite files.

```bash
npm run db:reset:local
```

**What it does:**
- Deletes SQLite files at `.wrangler/state/v3/d1/miniflare-D1DatabaseObject/`
- Database recreated on next access

**Follow with:** `npm run db:migrate:local` or `npm run db:setup:local:dev`

---

### `npm run db:reset:prod`

🚫 **BLOCKED** - Production reset is not allowed.

```bash
npm run db:reset:prod  # Will ERROR
```

Contact admin if production reset is truly needed.

---

### `npm run db:studio:local`

Open D1 Studio for local database.

```bash
npm run db:studio:local
```

**What it does:**
- Opens browser-based SQL editor
- Browse tables, run queries

---

### `npm run db:studio:prod`

Open D1 Studio for production database. **Requires confirmation.**

```bash
npm run db:studio:prod
```

**What it does:**
- Prompts: "Type 'production' to confirm"
- Opens D1 Studio for production database

```bash
npm run db:studio:remote
```

**What it does:**
- Executes `wrangler d1 studio peerloop-db --remote`
- Opens browser-based SQL editor for production
- Requires Cloudflare authentication

---

### `npm run db:validate`

Validate SQL migration syntax.

```bash
npm run db:validate
```

**What it does:**
- Executes `sqlite3 :memory: < migrations/0001_initial_schema.sql`
- Loads SQL into in-memory SQLite
- Reports syntax errors if any

**Use when:**
- After editing migrations
- Before applying to any database

---

## Cloudflare Commands

### `npm run cf:dev`

Run Wrangler Pages dev server.

```bash
npm run cf:dev
```

**What it does:**
- Executes `wrangler pages dev ./dist`
- Simulates Cloudflare Pages environment
- Includes Workers runtime, D1 bindings

**Prerequisites:**
- Run `npm run build` first
- `wrangler.toml` configured

---

### `npm run cf:deploy`

Deploy to Cloudflare Pages.

```bash
npm run cf:deploy
```

**What it does:**
- Executes `wrangler pages deploy ./dist`
- Uploads to Cloudflare Pages
- Returns deployment URL

**Prerequisites:**
- Run `npm run build` first
- Authenticated with Cloudflare

---

### `npm run cf:tail`

Tail deployment logs.

```bash
npm run cf:tail
```

**What it does:**
- Executes `wrangler pages deployment tail`
- Streams live logs from production
- Shows requests, errors, console output

**Use when:**
- Debugging production issues
- Monitoring deployments

---

## Build Scripts

### `npm run mock-diagram`

Generate mock data relationship diagram in Markdown format.

```bash
npm run mock-diagram
```

**What it does:**
- Executes `tsx scripts/generate-mock-data-diagram.ts`
- Analyzes `src/lib/mock-data.ts` for users, courses, and enrollments
- Outputs Mermaid diagram and summary tables to console

**Output includes:**
- Full relationship diagram (users → courses → enrollments)
- User roles summary with emails
- Enrollment matrix table
- Teacher certification diagram

**Options:**
```bash
npm run mock-diagram -- --output=diagram.md  # Save to file
```

---

### `npm run mock-diagram:html`

Generate interactive HTML diagram viewer.

```bash
npm run mock-diagram:html
```

**What it does:**
- Executes `tsx scripts/generate-mock-data-diagram.ts --html`
- Generates `docs/mock-data-diagram.html`
- Uses Mermaid CDN for rendering

**Output includes:**
- Legend with color coding for roles
- Interactive flowchart diagram
- Users and enrollments tables
- Quick stats summary

**View the result:**
```bash
open docs/mock-data-diagram.html  # macOS
```

---

---

## Related Documentation

- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail
- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test file inventory
