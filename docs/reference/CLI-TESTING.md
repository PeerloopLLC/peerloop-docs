# CLI Testing Reference

Detailed documentation for testing commands. For quick reference, see [CLI-QUICKREF.md](CLI-QUICKREF.md). For test file listing by module, see [TEST-COVERAGE.md](TEST-COVERAGE.md).

---

## Testing Stack

| Tool | Purpose | Config |
|------|---------|--------|
| Vitest | Unit/integration tests | `vitest.config.ts` |
| Playwright | End-to-end tests | `playwright.config.ts` |
| Testing Library | React component testing | via Vitest |

---

## Commands

### `npm run test`

Run all unit tests once.

```bash
npm run test
```

**What it does:**
- Executes `vitest run`
- Runs all `*.test.ts` and `*.spec.ts` files
- Outputs results to terminal
- Exits with code 0 (pass) or 1 (fail)

**Use when:**
- Before committing changes
- In CI pipeline
- Quick validation of changes

---

### `npm run test:watch`

Run tests in watch mode for development.

```bash
npm run test:watch
```

**What it does:**
- Executes `vitest` (watch mode is default)
- Re-runs tests when files change
- Shows interactive menu for filtering tests

**Use when:**
- Active development
- TDD workflow
- Debugging test failures

**Interactive commands:**
- `a` - Run all tests
- `f` - Run only failed tests
- `p` - Filter by filename
- `t` - Filter by test name
- `q` - Quit

---

### `npm run test:ui`

Run tests with Vitest's browser UI.

```bash
npm run test:ui
```

**What it does:**
- Executes `vitest --ui`
- Opens browser at `http://localhost:51204/__vitest__/`
- Visual test runner with file tree, results, and coverage

**Use when:**
- Exploring test suite structure
- Debugging complex test failures
- Reviewing coverage visually

---

### `npm run test:plato`

Run PLATO flow tests — API-level user journey tests.

```bash
npm run test:plato
```

**What it does:**
- Executes `vitest run tests/plato`
- Runs composable segment chains that test user goals through API calls
- Uses `seedCoreTestDB()` for production-like starting state (core seed only, no dev seed)
- Verifies that data creation paths work end-to-end through the API layer

**Use when:**
- Validating that user goals (register, create course, enroll, etc.) work through the API chain
- After schema changes that affect data creation paths
- Generating verified seed data (harvest step)

**See also:** `docs/as-designed/plato.md` for architecture and design rationale.

---

### `npm run plato:restore`

API-run a PLATO instance and restore its snapshot into local D1 — the bridge between API mode and browser mode.

```bash
npm run plato:restore -- flywheel-to-enrollment
```

**What it does:**
- Runs the named instance via Vitest (API mode)
- Saves in-memory DB via `better-sqlite3.serialize()` to `tests/plato/snapshots/<name>.db`
- Copies snapshot into wrangler's local D1 SQLite file
- Always regenerates (~400ms) — no caching, no staleness

**Use when:**
- Setting up local D1 for browser-mode walkthrough of post-enrollment checkpoints
- After schema or step changes, to get fresh snapshot state

**Prerequisites:** Instance must have `snapshot: true` in its instance file.

---

### `npm run plato:snapshot:restore`

Restore an existing PLATO snapshot to local D1 (no API-run).

```bash
npm run plato:snapshot:restore -- flywheel-to-enrollment
```

**What it does:**
- Reads `tests/plato/snapshots/<name>.db`
- Copies into `.wrangler/state/v3/d1/` as local D1 SQLite file
- Dev server immediately serves the snapshot state

**Use when:**
- Re-loading a previously generated snapshot without re-running the API-run
- Note: snapshots are gitignored — use `plato:restore` if none exists

---

### `npm run test:e2e`

Run end-to-end tests with Playwright.

```bash
npm run test:e2e
```

**What it does:**
- Executes `playwright test`
- Runs tests in `tests/` or `e2e/` directory
- Tests against real browser (Chromium, Firefox, WebKit)

**Prerequisites:**
- Install browsers: `npx playwright install`
- App must be running or use `webServer` config
- For smart feed tests (`e2e/smart-feed.spec.ts`): use `npm run db:setup:local:feeds` (or add feeds to existing setup with `npm run db:seed:feeds:local`)

**Use when:**
- Testing user flows end-to-end
- Validating integrations
- Before releases

**Common options:**
```bash
# Run specific test file
npm run test:e2e -- tests/auth.spec.ts

# Run in headed mode (see browser)
npm run test:e2e -- --headed

# Run specific browser only
npm run test:e2e -- --project=chromium

# Debug mode
npm run test:e2e -- --debug
```

---

### `npm run test:all`

Run both unit and E2E tests.

```bash
npm run test:all
```

**What it does:**
- Executes `npm run test && npm run test:e2e`
- Runs unit tests first
- If unit tests pass, runs E2E tests
- Fails fast if unit tests fail

**Use when:**
- Full validation before merge
- CI pipeline full test suite
- Release preparation

---

## Test File Conventions

| Pattern | Location | Purpose |
|---------|----------|---------|
| `*.test.ts` | `src/**/__tests__/` | Unit tests |
| `*.spec.ts` | `src/**/__tests__/` | Integration tests |
| `*.e2e.ts` | `tests/` | End-to-end tests |

### Import & Fixture Hygiene

After writing or editing a test file, do a quick cleanup pass:

1. **Remove unused imports** — `afterAll`, `within`, `waitFor`, `closeTestDB` etc. are commonly imported but not always used
2. **Remove unused variables** — e.g., `const { container } = render(...)` when only `screen` queries are used
3. **Verify fixture completeness** — check the source interface for all required fields; missing fields cause TS errors that surface later in `npm run typecheck` or `npx astro check`

This prevents TypeScript/Astro hints from accumulating. See also [BEST-PRACTICES.md §8 Testing](BEST-PRACTICES.md#8-testing) for more detail.

---

## Common Patterns

### Running a Single Test File

```bash
# Vitest
npm run test -- src/lib/__tests__/auth.test.ts

# Playwright
npm run test:e2e -- tests/login.e2e.ts
```

### Running Tests Matching a Pattern

```bash
# Vitest - by test name
npm run test -- -t "should validate"

# Vitest - by file pattern
npm run test -- auth
```

### Debugging Tests

```bash
# Vitest with debugger
node --inspect-brk node_modules/vitest/vitest.mjs run

# Playwright debug mode
npm run test:e2e -- --debug
```

---

## Multi-User Manual Testing

For testing two-sided interactions (student ↔ teacher, student ↔ admin), use **two different browser vendors**:

| Browser | User | Purpose |
|---------|------|---------|
| Chrome | User A (e.g., student) | Enroll, book, join BBB |
| Safari | User B (e.g., teacher) | Accept booking, join same BBB |

Each browser has independent cookies and localStorage — both are fully authenticated real sessions. Dev accounts all use password `Password1` (see `src/lib/mock-data.ts`).

**Tip:** Keep Chrome for your primary test user and Safari for the counterparty. The sessions persist across restarts, so you only log in once per browser.

---

## Webhook Testing

Local webhook testing uses two scripts: an orchestrator that starts the dev server + Stripe CLI in one terminal, and a trigger script that fires individual events.

### `npm run dev:webhooks`

Start the full webhook development environment.

```bash
cd ../Peerloop && npm run dev:webhooks
```

**What it does:**
- Runs preflight checks (Stripe CLI installed/authed, port 4321 free, `.dev.vars` has `BBB_SECRET`, `BBB_URL`, `STRIPE_WEBHOOK_SECRET`)
- Starts the dev server (or skips if port 4321 is already in use)
- Starts `stripe listen --forward-to localhost:4321/api/webhooks/stripe`
- Displays a ready banner with trigger command examples
- Ctrl+C stops all background processes

**Logs:** `/tmp/peerloop-dev-server.log`, `/tmp/peerloop-stripe-listen.log`

**Use when:**
- Testing Stripe webhook handlers end-to-end locally
- Testing BBB webhook handlers (dev server must be running; Stripe CLI is optional for BBB-only testing)

---

### `npm run trigger <event>`

Fire individual webhook events against the local dev server.

```bash
cd ../Peerloop && npm run trigger stripe-checkout
cd ../Peerloop && npm run trigger bbb-meeting-ended
cd ../Peerloop && npm run trigger list          # show all events
```

**Available events:**

| Event | Webhook | Notes |
|-------|---------|-------|
| `stripe-checkout` | `checkout.session.completed` | Seed-aligned overrides (David → n8n course) |
| `stripe-refund` | `charge.refunded` | Synthetic — no DB match, handler logs and returns |
| `stripe-dispute` | `charge.dispute.created` | Synthetic — no DB match, handler logs and returns |
| `bbb-meeting-ended` | `meeting-ended` | HMAC-signed, targets `ses-david-n8n-3` |
| `bbb-all-left` | Two `user-left` events | Empty-room auto-completion flow |
| `bbb-recording-ready` | `rap-publish-ended` | HMAC-signed, synthetic recording URL |
| `bbb-analytics` | Analytics callback | JWT HS512 auth, 2-attendee engagement data |

**Prerequisites:**
- Dev server running on port 4321 (for all events)
- Stripe CLI listening (for `stripe-*` events) — use `npm run dev:webhooks` or `stripe listen` separately
- `.dev.vars` with `BBB_SECRET` (for `bbb-*` events)

**Seed data targets:** All events target the David Rodriguez / Marcus Thompson enrollment chain in the n8n course. See `migrations-dev/0001_seed_dev.sql` for the full records. BBB events target session `ses-david-n8n-3`; Stripe checkout creates a new enrollment with a timestamped pending ID.

**How BBB HMAC works:** The trigger script reads `BBB_SECRET` from `.dev.vars` and generates an HMAC-SHA256 token via `openssl dgst`. The token is passed as `?token=` in the URL, matching the server-side verification in `src/lib/webhook-auth.ts`.

---

## CI Integration

Tests run automatically in GitHub Actions on:
- Pull requests to `main`
- Pushes to `main`

See `.github/workflows/ci.yml` for configuration.

---

## Related Documentation

- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference
- [CLI-REFERENCE.md](CLI-REFERENCE.md) - Non-test CLI commands
- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test file inventory by module
