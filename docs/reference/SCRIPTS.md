# Scripts Reference

Complete reference for all npm scripts and utility scripts in the Peerloop project.

- **npm scripts**: Defined in `package.json`, run via `npm run <name>`
- **Script files**: Located in `Peerloop/scripts/`, called by npm scripts or run directly
- **Page test scripts**: Located in `Peerloop/scripts/page-tests/`, one per page

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
| `npm run test:coverage` | Scan test coverage (dry-run) |
| `npm run test:coverage:write` | Update PageSpec JSONs with test coverage data |

### Database

| Command | Target | Description |
|---------|--------|-------------|
| `npm run db:setup:local` | Local | Reset + migrate + seed dev data |
| `npm run db:setup:local:clean` | Local | Reset + migrate (no dev seed) |
| `npm run db:setup:staging` | Staging | Reset + migrate + seed dev data |
| `npm run db:setup:staging:clean` | Staging | Reset + migrate (no dev seed) |
| `npm run db:migrate:local` | Local | Apply migrations |
| `npm run db:migrate:staging` | Staging | Apply migrations |
| `npm run db:migrate:prod` | Production | Apply migrations (requires confirmation) |
| `npm run db:seed:local` | Local | Apply dev seed data |
| `npm run db:seed:staging` | Staging | Apply dev seed data |
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

### Page Generation

| Command | Description |
|---------|-------------|
| `npm run parse-page` | Convert single page markdown to JSON |
| `npm run parse-all-pages` | Batch convert all page markdowns to JSON |
| `npm run generate-pages` | Generate Astro page files from route config |
| `npm run pages-map` | Preview PAGES-MAP.md to stdout |
| `npm run pages-map:write` | Write PAGES-MAP.md |
| `npm run site-map` | Preview SITE-MAP.md to stdout |
| `npm run site-map:write` | Write SITE-MAP.md |
| `npm run mock-diagram` | Generate mock data relationship diagram |
| `npm run mock-diagram:html` | Generate mock data diagram as HTML |

### External Services

| Command | Description |
|---------|-------------|
| `npm run stripe:listen` | Forward Stripe webhooks to `localhost:4321/api/webhooks/stripe` |

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
- Handles circular dependencies in the schema

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

### Page Tooling

#### `scripts/page-routes.ts`

Data file exporting the `PAGE_ROUTES` constant — maps page codes to routes, Astro files, and JSON paths.

**Not directly callable.** Imported by other scripts (`generate-all-pages.ts`, `generate-pages-map.ts`, etc.).

---

#### `scripts/parse-page-md.ts`

Convert a single page markdown specification into structured JSON.

```bash
npx tsx scripts/parse-page-md.ts research/run-001/pages/page-CBRO.md [output.json]
```

**What it does:**
- Parses markdown headings, tables, and lists into PageSpec JSON structure
- Output path auto-determined from page code if not specified
- Writes to `src/data/pages/` directory tree

**Called by:** `npm run parse-page`

---

#### `scripts/parse-all-pages.ts`

Batch convert all page markdown files to JSON.

```bash
npx tsx scripts/parse-all-pages.ts
```

**What it does:**
- Finds all `research/run-001/pages/page-*.md` files
- Runs `parse-page-md.ts` logic on each
- Reports success/failure count

**Called by:** `npm run parse-all-pages`

---

#### `scripts/generate-all-pages.ts`

Generate Astro page files from the `PAGE_ROUTES` configuration.

```bash
npx tsx scripts/generate-all-pages.ts
```

**What it does:**
- Reads route definitions from `page-routes.ts`
- Creates `.astro` page files with appropriate layout imports
- Skips files that already exist

**Called by:** `npm run generate-pages`

---

#### `scripts/generate-pages-map.ts`

Generate PAGES-MAP.md — a lookup table mapping page codes to routes and vice versa.

```bash
npx tsx scripts/generate-pages-map.ts          # Preview to stdout
npx tsx scripts/generate-pages-map.ts --write  # Write file
```

**What it does:**
- Reads all page JSON files
- Generates two lookup tables: code→route and route→code
- Includes page status and component info

**Called by:** `npm run pages-map`, `npm run pages-map:write`

---

#### `scripts/generate-site-map.ts`

Generate SITE-MAP.md with Mermaid flowcharts showing page interconnections.

```bash
npx tsx scripts/generate-site-map.ts                     # Preview all
npx tsx scripts/generate-site-map.ts --focus student     # Filter by role
npx tsx scripts/generate-site-map.ts --write             # Write file
```

**What it does:**
- Analyzes page link relationships from JSON specs
- Generates Mermaid flowchart diagrams
- Can filter by role: `public`, `student`, `teacher`, `creator`, `admin`, `all`

**Called by:** `npm run site-map`, `npm run site-map:write`

---

#### `scripts/generate-mock-data-diagram.ts`

Generate Mermaid diagram showing mock data relationships (users, courses, enrollments, certificates).

```bash
npx tsx scripts/generate-mock-data-diagram.ts         # Mermaid to stdout
npx tsx scripts/generate-mock-data-diagram.ts --html  # HTML with rendered diagram
```

**Called by:** `npm run mock-diagram`, `npm run mock-diagram:html`

---

#### `scripts/populate-page-metadata.ts`

Enrich page JSON files with file paths discovered from the directory tree.

```bash
npx tsx scripts/populate-page-metadata.ts          # Dry-run (preview changes)
npx tsx scripts/populate-page-metadata.ts --write  # Apply changes
```

**What it does:**
- Walks `src/components/`, `src/pages/`, `docs/` directories
- Populates `tsxComponents[]`, `astroComponents[]`, `docs.spec`, `docs.page`, `docs.audit` fields
- Reports what would change (dry-run) or applies changes (--write)

**Called by:** Not in npm scripts (run directly)

---

#### `scripts/validate-page-spec.ts`

Validate a page spec JSON file against the Zod PageSpec schema.

```bash
npx tsx scripts/validate-page-spec.ts src/data/pages/admin/student-teachers.json
```

**What it does:**
- Loads the JSON file
- Validates against `PageSpecSchema` from `src/lib/schemas/page-spec.ts`
- Reports validation errors with paths

**Called by:** Not in npm scripts (run directly)

---

### Audit & Coverage

#### `scripts/audit-api-coverage.mjs`

Cross-reference page JSON specs with test scripts to find API coverage gaps.

```bash
node scripts/audit-api-coverage.mjs
```

**What it does:**
- Reads `plannedApiCalls` from page JSON files
- Compares against test script contents in `scripts/page-tests/`
- Outputs `scripts/page-tests/COVERAGE-AUDIT.md` with gap analysis

**Called by:** Not in npm scripts (run directly)

---

#### `scripts/audit-test-sufficiency.mjs`

Analyze page-by-page test coverage against spec features and user actions.

```bash
node scripts/audit-test-sufficiency.mjs
```

**What it does:**
- Reads features and user actions from page JSON specs
- Compares against test file `describe`/`it` blocks
- Outputs `scripts/page-tests/TEST-SUFFICIENCY.md` with per-page analysis

**Called by:** Not in npm scripts (run directly)

---

#### `scripts/reconcile-planned-apis.mjs`

Clean up `plannedApiCalls` in page JSONs by removing APIs that have been implemented.

```bash
node scripts/reconcile-planned-apis.mjs --preview  # Show what would change
node scripts/reconcile-planned-apis.mjs --apply    # Apply changes
```

**What it does:**
- Scans `src/pages/api/` for implemented endpoints
- Compares against `plannedApiCalls` in page JSON files
- Removes implemented APIs from the planned list (they're now in `testCoverage.apiTests`)

**Called by:** Not in npm scripts (run directly)

---

#### `scripts/populate-test-coverage.ts`

Scan test directories and update PageSpec JSONs with `testCoverage` sections.

```bash
npx tsx scripts/populate-test-coverage.ts                    # Dry-run all pages
npx tsx scripts/populate-test-coverage.ts --write            # Apply to all pages
npx tsx scripts/populate-test-coverage.ts --page CBRO        # Single page only
npx tsx scripts/populate-test-coverage.ts --write --page CBRO
```

**What it does:**
- Walks `tests/` directories to find test files for each page
- Extracts test names and API endpoint references
- Populates `testCoverage.componentTests`, `testCoverage.apiTests`, `testCoverage.ssrTests`

**Called by:** `npm run test:coverage`, `npm run test:coverage:write`

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

## Page Test Scripts

Located in `Peerloop/scripts/page-tests/`. One script per page (58 total).

### Convention

Each script is named `test-<CODE>.sh` where `<CODE>` is the 4-letter page code (e.g., `CBRO`, `CDET`, `LGIN`).

```bash
# Run a page's full test suite
./scripts/page-tests/test-CBRO.sh

# Run component test only (quick mode)
./scripts/page-tests/test-CBRO.sh --quick
```

### What Each Script Contains

- Page metadata: code, route, component path
- Component test path and SSR loader test path
- API endpoints that should be tested
- `vitest run` commands targeting the relevant test files
- `curl` commands for manual API testing

### Generated Reports

| File | Generated By | Purpose |
|------|-------------|---------|
| `COVERAGE-AUDIT.md` | `audit-api-coverage.mjs` | API coverage gaps per page |
| `TEST-SUFFICIENCY.md` | `audit-test-sufficiency.mjs` | Feature coverage per page |

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
| `test:coverage` | `scripts/populate-test-coverage.ts` |
| `test:coverage:write` | `scripts/populate-test-coverage.ts --write` |
| `parse-page` | `scripts/parse-page-md.ts` |
| `parse-all-pages` | `scripts/parse-all-pages.ts` |
| `generate-pages` | `scripts/generate-all-pages.ts` |
| `pages-map` | `scripts/generate-pages-map.ts` |
| `pages-map:write` | `scripts/generate-pages-map.ts --write` |
| `site-map` | `scripts/generate-site-map.ts` |
| `site-map:write` | `scripts/generate-site-map.ts --write` |
| `mock-diagram` | `scripts/generate-mock-data-diagram.ts` |
| `mock-diagram:html` | `scripts/generate-mock-data-diagram.ts --html` |

### Standalone Scripts (no npm wrapper)

| Script | How to Run |
|--------|-----------|
| `scripts/link-docs.sh` | `bash scripts/link-docs.sh` |
| `scripts/audit-api-coverage.mjs` | `node scripts/audit-api-coverage.mjs` |
| `scripts/audit-test-sufficiency.mjs` | `node scripts/audit-test-sufficiency.mjs` |
| `scripts/reconcile-planned-apis.mjs` | `node scripts/reconcile-planned-apis.mjs --preview` |
| `scripts/populate-page-metadata.ts` | `npx tsx scripts/populate-page-metadata.ts --write` |
| `scripts/validate-page-spec.ts` | `npx tsx scripts/validate-page-spec.ts <file>` |
| `scripts/run-feed-isolation-test.js` | `node scripts/run-feed-isolation-test.js` |
| `scripts/test-feed-isolation.sh` | `bash scripts/test-feed-isolation.sh <cookie>` |
| `scripts/page-routes.ts` | Not callable (data export, imported by other scripts) |

---

## Data Flow

```
research/run-001/pages/page-*.md        (page specs as markdown)
         |
    parse-page-md.ts / parse-all-pages.ts
         |
         v
src/data/pages/**/*.json                (PageSpec JSON files)
         |
    +----+----+----+----+
    |    |    |    |    |
    v    v    v    v    v
 populate-   generate-  generate-  audit-api-   audit-test-
 test-       pages-     site-      coverage     sufficiency
 coverage    map        map
    |         |          |           |              |
    v         v          v           v              v
 (updates   PAGES-    SITE-     COVERAGE-     TEST-SUFFICIENCY
  JSONs)    MAP.md    MAP.md    AUDIT.md      .md
```
