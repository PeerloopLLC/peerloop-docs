> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 6. Testing & CI/CD

### STRIPE-E2E-DEV Deferred as 4-Tier Block with Explicit Dev→Staging→Live Value Chain
**Date:** 2026-04-21 (Conv 145)

Stripe integration confidence gap (between unit tests + one-shot staging live-verification + harness replay vs. real-browser-in-real-user-flow) is addressed by a deferred block — not inline work — with four scope tiers (A paper walkthrough / B scripted orchestrator / C Playwright E2E / D Claude-MCP-driven), an 11-scenario matrix, and 7 open questions for Plan Mode. Tier selection is delegated to a future Plan Mode session rather than defaulted.

**Rationale:** Conv 144 proved Stripe integration bugs can hide for 8 weeks (`constructEventAsync` silent 400s since Conv 114's CF Workers migration). The user explicitly asked for "as much assurance that we have a bullet-proof Stripe integration as I can before we go live" — a bigger frame than any single testing guide. Deferring with full context (rather than implementing in a rushed slice) lets Plan Mode pick the right tier intentionally; the block's "What Dev E2E testing buys us" section makes the *why* explicit so tier selection hinges on goals (team enablement / regression prevention / ad-hoc rehearsal) rather than effort alone.

**Consequences:** `PLAN.md` carries DEFERRED row #20 + ~160-line detail block. Claude-MCP browser-automation of Stripe Checkout is now on the roadmap (Tier D); Stripe Checkout's cross-origin iframe structure (card/expiry/CVC in separate `js.stripe.com` iframes for PCI isolation) is flagged as the decisive unknown for Tier D feasibility. The block is a durable artifact — next Plan Mode session starts from shared framing rather than reinventing the scope.

**See:** `PLAN.md §Deferred: STRIPE-E2E-DEV`

### `react-hooks/exhaustive-deps` Registered as `warn`; `rules-of-hooks` as `error`
**Date:** 2026-04-21 (Conv 143)

`eslint-plugin-react-hooks@^7.1.1` is now a devDep and registered in `eslint.config.js`. `react-hooks/rules-of-hooks` is `error` (genuine runtime crashes); `react-hooks/exhaustive-deps` is `warn` (high-signal but false-positive-prone, deferred to incremental triage). Activating the plugin surfaced 31 warnings across 26 files — tracked as `[LE-TRIAGE]` in `PLAN.md §POLISH.TECHNICAL_DEBT`.

**Rationale:** The plugin had been referenced by a single `// eslint-disable-next-line react-hooks/exhaustive-deps` comment in `MemberDirectory.tsx:141` since long before Conv 143, but had never been installed or registered — ESLint v10 (adopted in Convs 104-114 PACKAGE-UPDATES) newly errors on unknown rules in disable directives, which is how the gap surfaced. Error severity on `exhaustive-deps` would have blocked the baseline for a ~2-4 hour triage; `warn` activates detection across the whole codebase (127 React files, 405 hook occurrences) without blocking, and future convs touching these files will see the warnings inline.

**See:** `../Peerloop/eslint.config.js`, `PLAN.md §POLISH.TECHNICAL_DEBT [LE-TRIAGE]`

### `json<T>(response)` is the Canonical Test JSON Helper
**Date:** 2026-04-10 (Conv 102)

Test files read response bodies via `json<T>(response)` from `@api-helpers` instead of `await response.json() as any`. A ts-morph codemod (`scripts/codemods/migrate-test-json-as-any.ts`) migrated 1,587 sites across 198 test files in a single bisectable commit. `T` is a non-optional `{ field: any; ... }` shape inferred from the enclosing scope's top-level property accesses.

**Rationale:** Non-optional `any` fields catch top-level typos at compile time while preserving nested-access ergonomics (`body.stats.find(...)`, `body.data[0]`) that `as any` already provided. Optional/unknown variants break chained access. Completes an abandoned investment — the helper existed since an earlier conv but only 4 integration tests used it.

### ts-morph Codemods for Uniform Test Sweeps
**Date:** 2026-04-10 (Conv 102)

For mechanical test-file patterns where scope is >50 files and uniformity is >90%, write a ts-morph codemod rather than dispatching parallel subagents. Codemods produce one consistent style, a single bisectable commit, and a reusable template. Subagents produce N style variations and are harder to verify. Added `ts-morph@^27.0.2` as devDep; template lives at `scripts/codemods/migrate-test-json-as-any.ts`.

**Rationale:** In Conv 102 the `.json() as any` sweep ballooned from ~30 files to 1,587 sites across 198 files. Codemod wrote + ran + verified in under 1 hour; subagents would have been 2–4 hours with style drift.

### `futureAt(daysFromNow, utcHour=12)` for Time-Stable Test Dates
**Date:** 2026-04-10 (Conv 102)

Tests that need future dates for scheduling must use a helper that pins the hour to noon UTC rather than `new Date(Date.now() + Nh)`. The naive pattern can cross midnight when `Date.now()` falls in late UTC hours, exposing latent day-boundary bugs in code under test. Helper currently scoped to `tests/api/sessions/index.test.ts`; a project-wide sweep is tracked as task [TT].

**Rationale:** Five `sessions/index.test.ts` tests had been failing silently across unknown conversations because `isSlotWithinAvailability` checks only `startDate`'s day, and a midnight-crossing end time fails against any single-day availability window. Pinning to noon UTC eliminates the class of failure entirely.

### Branching Workflow Test Architecture
**Date:** 2026-03-05 (Session 342)

Multi-step workflow tests use a shared expensive setup (users, courses, enrollments, sessions) and branch into separate `describe` blocks at decision points. Shared helper functions (e.g., `setupCompletedSession(db)`) get to the decision point cheaply. Only branches where the decision changes downstream state are worth testing.

**Rationale:** The expensive part is building the world; branches are cheap once at the decision point. This gives N test variants for roughly the cost of 1.5 full tests. Integration tests cover branching logic (ms per branch); E2E tests cover only the 2-3 most critical happy paths.

**See:** PLAN.md WORKFLOW-TESTS block (4 workflow groups: BOOKING, COMPLETION, PAYMENT, MESSAGING)

### E2E Tests in CI with Local D1
**Date:** 2025-12-30

Keep E2E tests in CI; add `npm run db:migrate:local` step before tests.

**Rationale:** E2E in CI catches regressions; local D1 validates code works together.

### Vitest CLI Mode Only
**Date:** 2025-12-16

Use Vitest in CLI mode only (no GUI).

**Rationale:** User had bad experience with Vitest GUI; CLI-only approach is faster and more reliable.

### Playwright for E2E
**Date:** 2025-12-16

Use Playwright for E2E tests.

**Rationale:** Good Astro support; simpler than Cypress.

### Use Standard Vitest Config (Not Astro's getViteConfig)
**Date:** 2026-01-23

Use `defineConfig` from `vitest/config` instead of Astro's `getViteConfig` wrapper for test configuration.

**Rationale:** Astro's `getViteConfig()` starts file watchers that don't close properly, causing Vitest to hang after tests complete. Standard config with manual path aliases fixes this at the root cause. Tests don't need Astro-specific features.

**See:** `vitest.config.ts`, Session 71 Learnings

### Mock Astro Virtual Modules via Vitest Aliases
**Date:** 2026-02-19

Components that import Astro virtual modules (e.g., `astro:transitions/client`) fail to resolve in Vitest since the Astro Vite plugin isn't loaded. Add `resolve.alias` entries in `vitest.config.ts` pointing to mock files in `tests/helpers/`.

**Rationale:** Global aliases are cleaner than per-test `vi.mock()` calls and ensure every test file automatically gets the mock. Extends the "Standard Vitest Config" decision — since we don't use Astro's `getViteConfig`, we must manually alias any Astro virtual modules our components import.

**See:** `vitest.config.ts`, `tests/helpers/mock-astro-navigate.ts`

### E2E Flow Tests: Separate Specs per Lifecycle Phase
**Date:** 2026-03-05 (Session 335)

For multi-step flows with external dependencies (e.g., booking → BBB session → completion), create separate E2E specs per lifecycle phase rather than one monolithic test. Each spec includes dual-perspective verification (both parties see the result).

**Trigger:** Booking and session completion are naturally separated by days/weeks. Testing them as one flow requires mocking the entire middle (BBB session), creating fragile dependencies.

**Options Considered:**
1. Single test: book, mock BBB, webhook, verify — tests the chain but couples unrelated phases
2. Separate specs per phase: booking wizard + verification, webhook completion + verification ← Chosen

**Rationale:** Independent specs have no ordering dependencies, use the most appropriate strategy per phase (UI wizard for booking, direct API call for webhook), and mirror real user flows. Mock only what's environment-dependent (availability API), let everything else run real.

**Consequence:** `e2e/session-booking-flow.spec.ts` and `e2e/session-completion-flow.spec.ts`. Seed data needs "headroom" (more modules than sessions) so parallel tests can create records without exhausting capacity.

> **Insight:** The minimal mock boundary matters — mocking only the availability API (which is date/environment-dependent) while running session creation, notifications, and module resolution real gives far more confidence than mocking the whole booking endpoint. The webhook test has zero mocks, directly calling the real endpoint. (Session 335)

### E2E Tests Must Be Resilient to DB State Drift
**Date:** 2026-03-25 (Conv 029)

E2E tests that check seed data must use general assertions (regex counts, `>= 1` checks) rather than exact values. Mutation tests (delete, mark-read) permanently alter the dev D1 database, and other tests (booking flow) create additional records. Tests should verify component behavior, not specific seed data.

**Rationale:** Exact-count assertions (`toHaveCount(2)`, `getByText('2 notifications')`) break on re-runs when prior mutation tests have altered DB state. General assertions (`/\d+ notification/`, `count >= 1`) verify the same behavior without coupling to seed data. A periodic `npm run db:reset:local && npm run db:setup:local:dev` restores clean state when needed.

**Consequence:** Notification tests rewritten with general assertions. Pattern applies to any E2E test checking counts or specific records that other tests may create/modify.

### Decompose Large Components Before Testing
**Date:** 2026-01-23 (Updated: Session 75)

Before writing tests for a page component, analyze section sizes:
1. Identify any section >40 lines → extract as subcomponent
2. If 2+ sections exceed 40 lines → full decomposition warranted
3. Test subcomponents individually, then integration

**Rationale:** Original threshold (>200 lines or 5+ sections) was too coarse. A designer will be styling all pages and may significantly expand what are currently minor sections. The 40-line threshold ensures components remain testable and maintainable even after styling expansion. Decomposition also enables isolated testing, improves maintainability, and allows subcomponent reuse.

**See:** PLAN.md TESTING.PAGES process

### Retroactive Decomposition Review Results
**Date:** 2026-01-23

Reviewed 5 already-tested components that exceeded 200-line threshold:

| Component | Lines | Sections | Verdict |
|-----------|-------|----------|---------|
| CourseBrowse.tsx | 491 | 8 | HIGH priority - needs decomposition |
| SignupForm.tsx | 350 | 7 | MEDIUM - extract OAuthButtons |
| LoginForm.tsx | 238 | 6 | MEDIUM - extract OAuthButtons (shared) |
| STDirectory.tsx | 259 | 5 | Acceptable as-is |
| CreatorBrowse.tsx | 227 | 5 | Acceptable as-is |

**Key findings:**
- STDirectory and CreatorBrowse are borderline (5 sections) but well-organized; decomposition would add complexity without clear benefit
- OAuthButtons component (~80 lines of SVG) is duplicated between LoginForm and SignupForm; extraction would benefit both
- CourseBrowse has same complexity as CourseDetail; should extract FilterSidebar, FilterPills, Pagination, MobileDrawer

**See:** PLAN.md TESTING.PAGES retroactive review section

### PLATO Test Framework — API Flow Testing Layer
**Date:** 2026-03-30 (Conv 060), updated 2026-03-31 (Conv 061 — Model B pivot)

PLATO is a new test layer that tests user goals by executing API call sequences through real handlers with a real in-memory database. Unlike unit tests (which mock dependencies) or E2E tests (which drive browsers), PLATO proves the server-side write chain works end-to-end. First run (creator-publishes-course) completed in 202ms and immediately found a real production bug (`joined_via` CHECK constraint missing `'registration'`).

**Architecture (Model B — Conv 061):** Sequential DB-accumulation. Runs execute in fixed order; each deposits data into the DB. No cross-run carry state — the DB is the only truth. Supersedes Model A (composable segments with dependency graph and topological sort) because carry state hid integration gaps. Page-visit model: each run models page visits with button presses that trigger API calls. `$context` provides intra-run data flow ("what the page showed the user"); context is cleared between runs.

**Key rules:**
- **No direct DB inserts.** If PLATO can't create data through an API, that's a finding, not a reason for a workaround.
- **Happy path only.** Stumbles (bad input, wrong password) are single-step concerns tested at the unit/API layer (see STUMBLE-AUDIT block).
- **Route, not navigation.** Runs declare WHERE the action happens, not HOW the user gets there.
- **API emulation, not Playwright.** PLATO calls endpoints directly (~200ms, deterministic). Playwright is reserved for targeted E2E tests. The developer must manually walk each run in the browser to verify the UI can trigger the API calls.
- **Discovery GETs.** Runs that need data from prior runs start with a GET (the same call the page would make), not carry state.
- **`fromDB` actor resolution.** Runner queries users table by persona email — no cross-run identity carry.

**Rationale:** 6362 tests all insert data via SQL — none test the creation path. Model B breaks fast and loudly: if the DB doesn't have the data, the test fails. API emulation avoids Playwright's "fast and garbled muttering" (flakiness from hydration timing, animation delays, selector brittleness).

> **Insight:** The gap between "data exists in the database" and "the app can create that data" is invisible to conventional test suites. Seed-data-based testing creates a false sense of coverage by skipping the exact code paths users exercise. PLATO makes this gap visible by construction.

> **Insight:** Carry state between test segments is an anti-pattern for integration testing. If data must be passed explicitly between steps, you never discover that the real system doesn't provide it. Sequential DB-accumulation forces each step to discover its data the same way a user would — through the UI (or its API equivalent). The rigidity of fixed ordering is the feature, not a limitation.

**See:** `docs/as-designed/plato.md`, `tests/plato/`, `docs/reference/PLATO-GUIDE.md`, PLAN.md PLATO block

### Rename apiCalls → plannedApiCalls in Page Spec JSON
**Date:** 2026-01-27

Renamed `apiCalls` to `plannedApiCalls` across the Zod schema (`PageSpecSchema`), `PageSpecView.astro`, all 66 page JSON files, and helper scripts. The `testCoverage.apiTests` section (populated from shell scripts) serves as ground truth for what's actually built and tested.

**Rationale:** The `apiCalls` field contained a mix of implemented and aspirational endpoints (e.g., `/export` never built). Renaming to `plannedApiCalls` preserves all spec data while eliminating ambiguity. Two clear layers: "what was designed" (`plannedApiCalls`) vs "what exists" (`testCoverage.apiTests`).

**See:** `src/lib/schemas/page-spec.ts`, Session 126 Decisions

### Exclude Seed Data from Test Database
**Date:** 2026-01-28

The `resetTestDB()` function skips migration files containing "seed" in the filename. Tests use only `0001_schema.sql`, not `0002_seed.sql`.

```typescript
// In tests/helpers/test-db.ts
const files = fs.readdirSync(migrationsDir)
  .filter((f) => f.endsWith('.sql') && !f.includes('seed'))
  .sort();
```

**Options Considered:**
1. Rename seed file during tests (fragile, file system manipulation)
2. **Filter out seed files in `resetTestDB()`** ← Chosen
3. Have each test clear tables before inserting data (requires updating every test)

**Rationale:** Tests must control their own data. Seed data pollutes test state and causes:
- Count mismatches (test expects 4 enrollments, gets 10 due to seed data)
- Flaky assertions that pass due to seed data accidentally satisfying conditions
- Tests written with overly permissive assertions (`>= 4` instead of `toBe(4)`) to accommodate unknown seed data

**Consequences:**
- Tests have clean, isolated data
- Each test file sets up exactly the data it needs
- Integration tests that specifically validate seed data can use a separate `reseedTestDB()` helper

**See:** `tests/helpers/test-db.ts`, Session 135 Decisions

### SSR Testing: Extract to Testable Functions
**Date:** 2026-01-28

Extract SSR data fetching logic from .astro frontmatter to testable functions in `src/lib/ssr/`. Each page's data fetching becomes a pure function: `(db) → data | error`.

**Context:** 17 pages query D1 directly in Astro frontmatter. This layer was untested because .astro files can't be easily unit tested.

**Options Considered:**
1. **Extract to `src/lib/ssr/` functions** ← Chosen
2. Use E2E tests to implicitly cover SSR layer
3. Accept the gap for MVP

**Rationale:** Enables fast, isolated unit tests without Astro rendering complexity. E2E alone would be slow and wouldn't isolate SSR issues.

**Related:** SSR errors should show error pages, not empty content. Layouts need error boundary support.

**See:** PLAN.md TESTING.SSR, Session 138 Decisions

### API Test File Naming: Path-Mirroring Convention
**Date:** 2026-03-04 (Session 329)

Test files must mirror the API source path structure exactly. `src/pages/api/me/communities/[slug]/members.ts` → `tests/api/me/communities/[slug]/members.test.ts`.

**Rationale:** Path-mirroring enables automated coverage audits via `comm -23` between source and test paths. Flattened names (e.g., `slug-members.test.ts`) create false positives that require manual verification. The convention was already used by 95%+ of test files.

### 100% API Endpoint Test Coverage
**Date:** 2026-03-04 (Session 329)

All 211 API endpoints have corresponding test files (210 test files, with one covering 3 related progression endpoints). Each test covers at minimum: auth (401), authorization (403), success case, and error handling (503).

**Rationale:** The final 7 gaps were closed in one session. The process itself caught a real bug (`courses/[id]/sessions.ts` used invalid enrollment status `'active'`), validating the investment.

---

### Multi-User Manual Testing: Two Browser Vendors, No Code Changes
**Date:** 2026-03-12 (Session 380)

For testing two-sided interactions (student ↔ teacher, booking ↔ BBB), use two different browser vendors (e.g., Chrome + Safari) rather than code-level tab isolation. Each browser has independent cookies and localStorage, giving full session isolation with zero production code changes.

**Trigger:** User wanted per-tab localStorage scoping for simultaneous multi-user sessions.

**Options Considered:**
1. Tab-scoped auth tokens (sessionStorage + Authorization header)
2. Dev-mode impersonation (`?_as=userId` middleware)
3. Two browser vendors ← Chosen

**Rationale:** HTTP-only auth cookies are shared across all tabs in the same browser — scoping localStorage alone is insufficient. Code-level solutions would add dev-only infrastructure to the production codebase. Two browsers solve the 90% case (two simultaneous users) for free.

**See:** `docs/reference/BEST-PRACTICES.md` §8, `docs/reference/CLI-TESTING.md`

### Live Stream API Seeding for Feed E2E Tests
**Date:** 2026-03-19 (Conv 018)

Smart feed E2E tests use real Stream.io activities (not mocks) created by `scripts/seed-feeds.mjs`. The script calls the Stream REST API to create 14 activities + 17 reactions, then dual-writes `feed_activities` rows to D1 with the returned `stream_activity_id`. This ensures the full smart feed pipeline (D1 candidate selection → Stream enrichment → scoring → rendering) is tested end-to-end.

**Rationale:** The smart feed's value is its ranking algorithm, which depends on real engagement signals from Stream (`reaction_counts`). Mocking would test UI rendering but not the actual scoring. Feed seed is the only setup level that makes external API calls.

**See:** `scripts/seed-feeds.mjs`, `e2e/smart-feed.spec.ts`, `npm run db:setup:local:feeds`

### webhook_log Table for Payload Capture
**Date:** 2026-03-27 Conv 037

Added `webhook_log` table with fire-and-forget INSERTs at the top of all 3 webhook handlers (bbb.ts, bbb-analytics.ts, stripe.ts). Captures raw payloads for fixture generation and variability analysis. Auth headers are redacted for security.

**Rationale:** Durable, queryable, in-context (knows which handler received it). Payloads can be extracted via `wrangler d1 execute` for test fixture generation. May be replaced by proper API logging later.

**See:** `migrations/0001_schema.sql` (webhook_log table), `src/pages/api/webhooks/`

### PLATO Persona Fields: DB-REQUIRED vs SITE-NECESSARY
**Date:** 2026-03-31 (Conv 062)

PLATO persona files organize entity fields into two comment-delimited sections: **DB-REQUIRED** (fields needed to pass publish/validation gates) and **SITE-NECESSARY** (fields that a diligent user would fill out for a complete experience). Runs send both categories. Flat structure with no conditionals — copy a persona block and change values to create a new variant.

**Rationale:** The publish gate tests minimum validity, not user experience completeness. PLATO should model what a real user does, not just what passes validation. Section comments make the distinction self-documenting without adding runtime complexity.

> **Insight:** Test frameworks that only satisfy validation gates miss the user experience surface area — the same gap that causes empty product pages in production despite all tests passing.

**See:** `tests/plato/personas/genesis.ts`, `docs/reference/PLATO-GUIDE.md`

### PLATO Scenario Layer — Independent Goal-Driven Compositions
**Date:** 2026-03-31 (Conv 063)

PLATO gains a "Scenario" layer above individual runs. A scenario is an independent, goal-driven composition of runs with its own persona set, chain steps, and DB verification. Three scenario categories: `test` (critical path validation), `seed` (replace SQL seed data), `repro` (reproduce observed issues). Scenarios are self-contained — each declares its personas, chain order, actor bindings, and expected DB state.

**Key design choices:**
- **findBy in extractPath:** `courses.findBy(title,$persona.courseTitle).id` enables multi-course discovery without carry state. Custom parseDotPath() handles paren-aware dot splitting.
- **Actor bindings:** `RunRef.actorBindings` remaps persona keys to run actor slots, so the same run (e.g., enroll-student) works with different students without modification.
- **Scenario-level DB verification:** Per-run verify blocks are sanity gates; scenario verify proves the intended situation was reproduced with comprehensive state checks.

**Rationale:** Independent scenarios enable ad-hoc creation ("generate a new scenario to test X"). The findBy pattern is declarative and backward-compatible. Actor bindings keep runs atomic — they never know which persona is using them.

> **Insight:** Separating one-time setup operations (Stripe Connect) from per-entity operations (teacher certification) is critical for composable test runs. When a run combines both, it works for the first invocation but fails on subsequent ones. Atomic runs that do exactly one thing compose cleanly in any scenario.

**See:** `tests/plato/scenarios/`, `tests/plato/lib/types.ts` (PlatoScenario), `tests/plato/lib/api-runner.ts` (executeScenario)

### PLATO Four-Concept Taxonomy (step / scenario / persona set / instance)
**Date:** 2026-04-01 (Conv 068)

Adopted four-concept taxonomy to resolve "run" ambiguity: **Steps** are atomic action templates (data-independent). **Scenarios** compose steps into sequences with verification. **Persona Sets** provide the data. **Instances** bind scenarios to persona sets with an execution mode (test/seed/walkthrough/repro). Renamed `run` → `step` across 30+ files (~150 replacements). Instances are future work — currently implicit via hardcoded personaSet in scenario files.

**Rationale:** "Run" was both a noun (a test run) and a verb (run the test), causing confusion. The four concepts map cleanly to three use cases: canned seed data, automated test execution, and ad-hoc reproduction scenarios.

> **Insight:** When domain terminology is ambiguous between "the thing" and "the act of doing the thing" (run/run, build/build), splitting into separate concepts with distinct names eliminates an entire class of communication errors. The cost of renaming is front-loaded; the clarity benefit compounds.

**See:** `docs/as-designed/plato.md`, `tests/plato/steps/`, `tests/plato/lib/types.ts`

### PLATO Instance Architecture: Inline Scenarios + When Guards + Accumulation
**Date:** 2026-04-01 (Conv 069)

Built PlatoInstance/PlatoInstanceFile types with `when` predicate guards on StepRef, multi-instance execution against same DB (accumulation), inline scenario support, and WalkthroughCheckpoint type for STUMBLE pairing. Instances solve the general parameterization problem — any future scenario variant uses the same infrastructure.

**Rationale:** The `when` guard is the minimal mechanism for conditional steps. `executeInstanceFile()` swaps persona data per-instance and delegates to existing `executeScenario()`. The existing architecture (actorBindings, runtimeOverrides) was already designed for pluggable data — instance is the next logical layer up.

> **Insight:** When an orchestration layer works on first try with zero changes to the underlying execution engine, it validates the original architecture's extensibility. The cost of the instance system was ~300 lines of new code with no modifications to existing step execution, value resolution, or mock management.

**See:** `tests/plato/lib/types.ts`, `tests/plato/lib/api-runner.ts`, `tests/plato/instances/`

### STUMBLE-AUDIT Formalization: Lightweight Pairing with PLATO Instances
**Date:** 2026-04-01 (Conv 069) — *Superseded by BrowserIntent (Conv 074)*

Added WalkthroughCheckpoint type to PLATO instance files. Execution uses accumulate-with-checkpoints model (walk sub-flow, batch findings, pause for triage). Issues captured as TodoWrite tasks with severity (broken/confusion/cosmetic) and source tag.

**Rationale:** Instance file is the natural home for "what to check in browser." Lightweight structure avoids over-engineering while ensuring findings are captured persistently. PLATO proves API correctness; STUMBLE proves UI correctness. Contract mismatches between API response shapes and component expectations only surface when the browser actually renders — validating the complementary pairing.

### CTE Cross-Reference Limitation: Use JOINs for Enrollment Lookups in D1 INSERT
**Date:** 2026-03-31 (Conv 065)

In the D1/better-sqlite3 test environment, CTEs that reference other CTEs via scalar subqueries return NULL when used inside INSERT...SELECT statements. Single-level CTEs work fine. For enrollment lookups (which depend on user + course CTEs), use explicit JOINs on base tables instead: `FROM enrollments e JOIN users u ON e.student_id = u.id JOIN courses c ON e.course_id = c.id WHERE u.email = ? AND c.title = ?`.

**Rationale:** The CTE limitation may be a SQLite/better-sqlite3 quirk. JOINs are proven reliable, self-contained per step, and avoid silent NULL propagation. Additionally, INSERT...SELECT with UNION ALL reports success even when 0 rows are inserted, so splitting into individual INSERT steps per enrollment is more debuggable.

> **Insight:** When working with SQLite CTEs in INSERT context, prefer explicit JOINs over CTE cross-references for reliability. The verbosity cost is minor compared to the debugging cost of silent NULL propagation.

### PLATO Terminology: One System, Two Modes
**Date:** 2026-04-02 (Conv 073)

PLATO is one system with two execution modes: API mode (Vitest, in-memory DB, mocked externals) and Browser mode (dev server, real D1, real UI). "Run" = one execution of an instance. STUMBLE-AUDIT is a PLAN.md project block name only, not a separate system. Supersedes the PLATO run / STUMBLE walkthrough terminology from Conv 060.

**Rationale:** "STUMBLE" was overloaded — used as both a system name and a project block. WalkthroughCheckpoint already lives in PLATO's type system, confirming it's architecturally one system. Two modes is clearer than two systems.

### Defer PLATO Segments to PLATO-ON-STEROIDS Block
**Date:** 2026-04-02 (Conv 073)

All segment implementation deferred. Current primitives (StepRef + actorBindings + sequential instances) are sufficient for all envisioned scenarios at current scale (4 scenarios, 2 instances). Segments are DX convenience, not capability unlock.

**Rationale:** Multi-student, post-enrollment, restartability, and step group reuse all work without segments. Created PLATO-ON-STEROIDS deferred block (#41) capturing the full vision: composable data, segments, DB snapshots, automated agent walkthroughs.

> **Insight:** When a new abstraction layer doesn't unlock capabilities that existing primitives can't achieve, it's DX debt disguised as architecture. Defer until scale forces the issue.

### PLATO Snapshot Bridge: Always-Regenerate
**Date:** 2026-04-02 (Conv 073)

`better-sqlite3.serialize()` dumps in-memory DB to a Buffer, copied to wrangler's D1 SQLite file. `npm run plato:restore -- <name>` always regenerates (API-run + restore in one command). No caching — every restore regenerates from current code.

**Rationale:** API-run takes ~400ms — faster than thinking about staleness. Eliminates entire class of bugs (stale schema, stale persona data, stale steps). Snapshots are gitignored.

### BrowserIntent Replaces WalkthroughCheckpoint
**Date:** 2026-04-02 (Conv 074)

WalkthroughCheckpoint replaced by BrowserIntent: `navigate: { via, clicks: NavClick[] }` for deterministic navigation, `pageAction: string` for prose instructions, `coversStepActions` for API-run cross-reference. Navigation is structured (fail-fast on missing UI elements); page actions remain prose to avoid building a Playwright DSL.

**Rationale:** WalkthroughCheckpoints "teleported" to pages via address bar URLs instead of navigating like real users. BrowserIntent captures the deterministic navigation contract without over-engineering page interactions. The hybrid split (structured nav + prose actions) matches the natural boundary: navigation is mechanical, page actions are contextual.

> **Insight:** When automating user journeys, the navigation/action boundary is the natural seam for structured vs unstructured specification. Navigation has finite, enumerable paths through a known graph. Page actions are combinatorially complex. Structuring navigation enables fail-fast validation; keeping actions as prose avoids an ever-expanding DSL.

**See:** `tests/plato/lib/types.ts` (BrowserIntent, NavClick), `tests/plato/lib/navigation-helper.ts`

### Route↔API Map: Self-Maintaining Scanner Pipeline
**Date:** 2026-04-02 (Conv 074)

Single scanner script (`scripts/route-api-map.mjs`) generates both TypeScript lookup (`tests/plato/route-map.generated.ts`) and Markdown reference (`docs/as-designed/route-api-map.md`) from source code analysis. BFS from nav components (AppNavbar, AdminNavbar, DiscoverSlidePanel) computes reachability. Wired into `/r-end` docs agent for auto-regeneration on API/component changes.

**Rationale:** Code needs the data (PLATO navigation helpers). Humans need the reference (scenario authoring). One source of truth prevents drift. Stats: 96 pages scanned, 195 API endpoints, 89 reachable routes.

**See:** `scripts/route-api-map.mjs`, `tests/plato/route-map.generated.ts`, `docs/as-designed/route-api-map.md`

### Per-Route `export const noNav = true;` Annotation for Designed-Unreachable Routes
**Date:** 2026-05-21 (Conv 168 established; Conv 169 swept across remaining 19 routes)

Routes that are legitimately unreachable from the main navigation graph (footers, 404, role-gated admin, role-conditional tabs reached via in-page switching, 301-redirect shims) opt out of `route-api-map.mjs`'s `⚠️ no discovered nav path` warning by adding `export const noNav = true;` to their `.astro` frontmatter. The scanner reads the declaration via `parseNoNav(content)` and emits `ℹ️ no-nav by design` instead. Convention: include a brief one-line comment naming the category (e.g., `// Public footer page — reached from public footer, not AppNavbar`).

**Rationale:** Per-route declarative locality outperforms a scanner-wide whitelist for "expected unreachable" routes — the file that knows it's no-nav declares it; new no-nav routes self-document at creation time; central whitelists drift as the codebase evolves. Output continues to distinguish `⚠️` (real concern) from `ℹ️` (intentional). Applied first to `/course/[slug]/[tab]` (CRT role-tab catch-all reached via CourseTabs switching); Conv 169 completed the sweep across 19 additional routes (14 footer/marketing pages, /404, /admin/recordings, 3 /discover/* 301-redirect shims) — `[RAM-NONAV-SWEEP]` done. Zero `⚠️ no discovered nav` warnings remain in scanner output; 20 routes report `ℹ️ no-nav by design`.

**See:** `scripts/route-api-map.mjs` (`parseNoNav` helper at line 90), `src/pages/course/[slug]/[tab].astro`

### Diagnostic Instances Are Ephemeral
**Date:** 2026-04-02 (Conv 074)

Diagnostic segments (instances created to isolate bugs) are deleted when their bugs are fixed. If the journey is independently useful, promote to a named scenario. Git history preserves the diagnostic if needed later. Taxonomy: Scenario (permanent, proves a journey), Diagnostic segment (ephemeral, isolate bugs), Derived scenario (promoted from diagnostic if useful).

**Rationale:** PLATO-REGISTRY should track permanent scenarios, not ephemeral debug probes. Accumulating stale diagnostic artifacts creates confusion about what's canonical.

### PLATO Navigation Rules: Same-Page First, Then AppNavbar
**Date:** 2026-04-02 (Conv 074)

Deterministic navigation rules for BrowserIntent: Rule (a) if target route has a link/button on the CURRENT page → `via: 'same-page'`. Rule (b) if not → start from AppNavbar, follow BFS shortest path. Implemented in `suggestNavigation()` helper. `outboundLinks` added to RouteInfo to support rule (a) checks.

**Rationale:** Users naturally click links on the current page before going to the sidebar. This matches real user behavior and produces the most natural-looking browser-runs.

**See:** `tests/plato/lib/navigation-helper.ts`

### getNow() Enforcement via Lint Rule
**Date:** 2026-04-06 (Conv 089, completed Conv 090)

Complete sweep of server-side files to replace bare `new Date()` with `getNow()` from `@lib/clock`. Conv 089 converted 22 files and added the lint rule; Conv 090 completed the sweep with 25 more files (47+ total) and added `// getNow-exempt` comments to ~12 files with legitimate uses. Extended `lint-timezone.sh` with source-file scan that catches future `new Date()` and `Date.now()` in API routes and lib code. Supports `// getNow-exempt` inline comments for legitimate uses (clock.ts itself, health checks, debug endpoints, DB timestamp utility, R2 metadata, performance timing, JWT expiry).

**Rationale:** `getNow()` abstraction existed since Conv 003 but only 4 files used it — infrastructure without enforcement drifts. The lint rule closes the feedback loop. PLATO proof-of-fix validated by restoring realistic `America/New_York` availability (was all-day UTC workaround). Conv 090 proved that post-hoc sweeps are inherently incomplete — the "comprehensive" Conv 089 sweep missed 25+ files.

> **Insight:** Creating an abstraction is necessary but not sufficient — without a lint rule or other enforcement mechanism, new code will bypass it by default. The gap between "4 files using getNow()" and "22+ files using new Date()" accumulated silently over 86 convs. Even with the lint rule, enforcement is only advisory (manual `npm run lint:tz`) — promoting to a pre-commit hook or CI gate would prevent recurrence.

### Claude Code PreToolUse Hook for lint-timezone Gate
**Date:** 2026-04-06 (Conv 091)

`lint-timezone.sh` promoted from advisory to enforced gate. Two options considered: (1) git pre-commit hook via husky (gates all committers), (2) Claude Code `PreToolUse` hook (gates Claude commits only). Option 2 chosen.

**Rationale:** Claude is currently the sole committer. Adding husky introduces a build dependency and configuration surface for a single-dev project. The Claude Code hook intercepts `Bash` tool calls matching `git commit` targeting the code repo, runs `lint-timezone.sh`, and returns `{"permissionDecision": "deny"}` with the violation output on any FAILs. Human git commits bypass it — documented fragility in `docs/as-designed/lint-timezone.md` with clear mitigation path (add husky + CI when a second developer joins).

**Also added (Conv 091):** `// tz-exempt` suppression comment for test-file Phase 1 FAILs, paralleling the existing `// getNow-exempt` for source-file Phase 2 FAILs. Used for intentional local-time Date constructs in tests (e.g., `toISO` format tests that verify local-time output).

**See:** `docs/as-designed/lint-timezone.md`, `.claude/hooks/pre-commit-lint-tz.sh`

### Canonical Feed Seed: `scripts/seed-feeds.mjs` Wired into `db:setup:local:dev`
**Date:** 2026-06-12 (Conv 271)

`scripts/seed-feeds.mjs` is the **single canonical feed seed** — it writes real activities to Stream and dual-writes the returned IDs into D1, producing working content (real Stream UUIDs, real reactions). The 28 dangling SQL `feed_activities` rows in `migrations-dev/0001_seed_dev.sql` are **removed** (left as a breadcrumb), and `db:setup:local:dev` now ends with `db:seed:feeds:local`. The script is **creds-resilient**: a machine without Stream credentials skips the feed seed gracefully rather than failing the whole setup. Also fixed a real bug surfaced by making the path canonical — the script wrote `feed_type='townhall'` which fails the schema CHECK (`system`/`community`/`course`); Stream addressing (group `'townhall'`) is now decoupled from D1 addressing (`feed_type='system'`).

**Rationale:** A pure-SQL seed can only store a dangling pointer — Stream activity IDs are minted by Stream when an activity is created, so the seed must call the service, not fabricate IDs. One dataset with real IDs beats two datasets where the SQL one renders "empty" posts via the `buildPlaceholderActivity` enrichment fallback. Making the optional/untested script canonical surfaced the dormant `feed_type` CHECK failure that "worked in isolation" only because nobody exercised it.

**See:** `scripts/seed-feeds.mjs`, `migrations-dev/0001_seed_dev.sql`, `package.json`

### Discovery-Rail Source Tables Freshened via the Seed's Relative-Date Mechanism (PART C)
**Date:** 2026-06-12 (Conv 272)

The discovery rails compute `new` (created <30d) and `trending` (velocity <7d) signals, so source rows with fixed historical seed dates never populate them — 4/6 rails were empty in dev. Fixed by extending the seed's existing **"TIMESTAMP FRESHNESS"** section (post-INSERT `strftime('now','-N days')` UPDATEs) with a new **PART C: DISCOVERY RAILS FRESHNESS** that freshens the rail-source tables (courses / communities / progressions / community_resources / enrollments / community_members) with id-targeted, inversion-safe UPDATEs. Freshened dates store ISO `T`-format (`strftime('%Y-%m-%dT%H:%M:%fZ',…)`) to match the JS `.toISOString()` cutoff the compute compares against (the SQLite-datetime pitfall). All 6 rails populate after re-seed; `migrations-dev/0001_seed_dev.sql` +34 lines.

**Rationale:** Reuses the established, durable freshness mechanism rather than hardcoding new dates that would re-stale or leaving the rails cold-start-empty. Inversion-safety rule: when freshening an entity's date, pick rows with NO conflicting dependents or freshen the whole dependent sub-tree in step — else you invert a timeline (e.g. a completed-in-2024 enrollment predating a course created 6 days ago).

**See:** `migrations-dev/0001_seed_dev.sql` (§PART C: DISCOVERY RAILS FRESHNESS)

---

