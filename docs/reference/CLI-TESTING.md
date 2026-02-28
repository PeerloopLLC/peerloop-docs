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
