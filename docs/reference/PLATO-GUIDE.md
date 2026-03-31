# PLATO — Practical Guide

**Platform Action Test Orchestrator**
**Last Updated:** 2026-03-31 (Conv 062)

---

## What PLATO Is

PLATO tests whether users can accomplish their goals through the Peerloop platform by executing realistic sequences of API calls against a real database. It fills a gap that no other test layer covers.

### The Gap

| Test Layer | What It Proves | What It Misses |
|---|---|---|
| Unit tests | Individual functions handle edge cases | Functions work together |
| API tests | Single endpoints reject bad input, enforce auth | Endpoint outputs feed correctly into next endpoint |
| Integration tests | 2-3 coupled operations interact correctly | Full multi-step user journeys |
| E2E (Playwright) | Multi-user browser flows work | Flaky, slow, hard to debug |
| **PLATO** | **A user can go from registration to published course (or beyond) through a sequence of API calls, with all data flowing correctly between them** | UI rendering, navigation paths, error handling |

### The Core Insight

Seed data proves the app can **display** data. PLATO proves the app can **create** data — and that the output of one feature is valid input for the next.

Example: When a creator publishes a course, the `POST /api/me/courses` endpoint creates a course record. A student later enrolls via `POST /api/checkout/create-session`, which needs the `course_id`. If the course endpoint stores the ID in a format the checkout endpoint doesn't expect, unit tests won't catch it (they use hand-inserted "perfect" data), but PLATO will — because it uses the actual output of the course creation endpoint as input to the enrollment endpoint.

---

## How It Works

### Model B: Sequential DB-Accumulation

PLATO runs execute in a **fixed order** against a single in-memory SQLite database (via better-sqlite3). Each run deposits data into the DB. The next run's API calls succeed only if the data is actually there.

```
Fresh DB (core seed only)
    │
    ├── Run 1: register-creator     → DB now has a creator user
    ├── Run 2: grant-creator-role   → DB now has creator with can_create_courses
    ├── Run 3: create-community     → DB now has a community + progression
    ├── Run 4: create-course        → DB now has a course with details
    ├── Run 5: add-modules          → DB now has 3 curriculum modules
    └── Run 6: publish-course       → DB now has a published, enrollable course
```

**There is no carry state between runs.** If Run 5 needs the course ID created by Run 4, it must discover it by calling `GET /api/me/courses` — exactly like a real user would browse their dashboard. If the GET endpoint is broken or the data isn't there, the test fails loudly.

This is the design philosophy: **break fast and loudly.** No safety nets, no artificial data injection. If the system can't provide the data a user needs, PLATO catches it.

### Page Visits and Actions

Each run models what a real user does: **visit a page, take an action.**

```typescript
// Example: Run 4 (create-course)
visits: [
  {
    route: '/creating/communities',
    description: 'Creator loads their communities to discover the community slug',
    actions: [
      {
        name: 'loadCommunities',
        description: 'Page loads creator communities list (discovery GET)',
        method: 'GET',
        path: '/api/me/communities',
        provides: { communitySlug: 'communities[0].slug' },
      },
    ],
  },
  {
    route: '/creating/courses/new',
    description: 'Creator fills in course creation form',
    actions: [
      {
        name: 'createCourse',
        description: 'Select progression, enter title and level, click Create',
        method: 'POST',
        path: '/api/me/courses',
        body: { title: '$persona.courseTitle', progression_id: '$context.loadProgressions.progressionId' },
        provides: { courseId: 'course.id' },
      },
    ],
  },
]
```

Each run definition serves **two purposes**:
1. **Executable test** — the runner calls APIs, verifies DB state
2. **Manual test script** — the `route`, `description`, and action descriptions tell you exactly what to do in a browser to verify the UI works

### Intra-Run Context (`$context`)

Within a single run, actions can reference data from earlier actions via `$context.actionName.key`. This models what the page shows the user — a GET response populating a dropdown, a POST response providing an ID for the next action.

```
$context.loadCommunities.communitySlug   → slug from the GET response
$context.createCourse.courseId            → ID from the POST response
```

This is NOT carry state. It is "what the page showed the user." Context is cleared between runs — only the DB persists.

### Actor Resolution

Runs declare their actors and how to resolve their identity:

| Source | When Used | How It Works |
|---|---|---|
| `register` | First run for an actor | Session set from registration response |
| `fromDB` | Subsequent runs for the same actor | Runner queries `SELECT id, email FROM users WHERE email = ?` using persona email |
| `preset` | Admin user (seeded in core data) | Fixed userId/email/roles |

This means you never need to pass user IDs between runs. The runner looks up the actor by their persona email in the DB — if the prior run registered them correctly, they'll be found.

### Persona Data

All test data comes from a **persona set** — a collection of actors with their details:

```typescript
// personas/genesis.ts
actors: {
  creator: {
    // ── Actor Identity ──────────────────────────────────
    name: 'Mara Chen',
    email: 'mara.chen@example.com',
    password: 'MaraChen123',
    handle: 'marachen',

    // ── Community: DB-REQUIRED ──────────────────────────
    communityName: 'AI Product Leaders',
    communityDescription: 'A community for aspiring...',

    // ── Community: SITE-NECESSARY ───────────────────────
    communityCoverImageUrl: 'https://placehold.co/...',
    communityIcon: '🤖',

    // ── Course: DB-REQUIRED ─────────────────────────────
    courseTitle: 'Introduction to AI Product Management',
    courseDescription: '...',
    coursePriceCents: 19900,
    // ...

    // ── Course: SITE-NECESSARY ──────────────────────────
    courseObjectives: ['Understand the AI product lifecycle...', ...],
    courseIncludes: ['3 live 1-on-1 tutoring sessions', ...],
    coursePrerequisites: [{ type: 'nice_to_have', content: '...' }],
    courseTargetAudience: ['Product managers moving into AI', ...],
    coursePeerloopFeatures: { one_on_one_teaching: true, ... },

    // ── Modules ─────────────────────────────────────────
    modules: [
      {
        moduleTitle: 'AI Strategy Fundamentals',       // DB-REQUIRED
        moduleDesc: '...',                             // DB-REQUIRED
        moduleDuration: '2 hours',                     // DB-REQUIRED
        moduleLearningObjectives: '...',               // SITE-NECESSARY
        moduleTopicsCovered: '...',                    // SITE-NECESSARY
        moduleHandsOnExercise: '...',                  // SITE-NECESSARY
      },
      // ...
    ],
  },
  student: { ... },
  admin: { ... },
}
```

Runs reference persona fields via `$persona.courseTitle`, `$persona.email`, etc. The persona is resolved based on the action's actor.

### DB-REQUIRED vs SITE-NECESSARY Fields

Persona fields are organized into two categories, marked with comments in the persona file:

| Category | Meaning | What happens if missing |
|----------|---------|----------------------|
| **DB-REQUIRED** | Publish gate or validation requires it | Run fails — action returns 400 |
| **SITE-NECESSARY** | Optional in DB, but needed for a complete-looking site | Run passes, but manual testing reveals empty sections |

This separation serves two purposes:

1. **PLATO proves the minimum works** — DB-REQUIRED fields exercise the publish gate and validation logic. If these API chains break, runs fail loudly.

2. **Enriched personas prove the full experience works** — SITE-NECESSARY fields exercise the About tab, module details, community pages. If these API chains break, runs also fail loudly — but only when the persona includes the data.

To create a second creator with different data, copy the persona block and change the values. The DB-REQUIRED / SITE-NECESSARY comments tell you which fields are mandatory and which are your judgment call.

### Personas as Seed Data

A fully populated persona set can serve double duty: PLATO validates the API chain, and the resulting DB state is realistic enough to serve as seed data (see PLATO.HARVEST in PLAN.md). The richer the persona, the more complete the seeded site looks.

### Discovery GET Pattern

When a run needs data created by a prior run (e.g., Run 5 needs the courseId from Run 4), it starts with a **discovery GET** — the same API call the page would make to load its data:

```
Run 5 (add-modules):
  Visit 1: GET /api/me/courses → provides { courseId: 'courses[0].id' }
  Visit 2: POST /api/me/courses/{courseId}/curriculum (x3)
```

This is realistic (users navigate by browsing their dashboard) and validates the list/detail endpoints at the same time.

### Phantom System Page

Some actions aren't triggered by a user pressing a button — they're system events (webhooks). These use a phantom route `/__plato/system`:

```typescript
{
  route: '/__plato/system',
  description: 'Stripe fires checkout.session.completed webhook',
  actions: [{
    name: 'stripeWebhook',
    method: 'POST',
    path: '/api/webhooks/stripe',
    body: stripeEventFixture,
  }],
}
```

This keeps the "visit page, take action" metaphor universal.

### External Service Mocking

All external HTTP calls are mocked at the library boundary. Handler logic, validation, DB writes, and state transitions all run for real.

| Service | Mock Strategy |
|---|---|
| Stripe | Mock `@/lib/stripe`; fire synthetic webhook via phantom page |
| Stream.io | Mock `@/lib/stream`; verify D1 feed_activities written |
| BigBlueButton | Mock `@/lib/video`; fire synthetic webhooks |
| Resend (email) | Mock `resend`; verify called with correct data |

Mocks are declared once in the test file (`vi.mock()`), then reconfigured per action by the `MockRegistry`. A run action declares which mock setup it needs:

```typescript
serviceMocks: [
  { module: '@/lib/stream', setup: 'stream-client' },
]
```

---

## Running PLATO

### Run the PLATO chain

```bash
cd ../Peerloop && npm run test:plato
```

This executes all runs in order against a fresh in-memory DB seeded with core data. Current runs complete in ~200ms total.

### Run the full test suite (includes PLATO)

```bash
cd ../Peerloop && npm test
```

PLATO runs are part of the regular test suite. They run alongside all other tests.

### What the output looks like

```
PLATO Chain: full-flywheel (persona: genesis)
  Run: register-creator
    Goal: Visitor registers as a new user (future creator)
    📄 /signup — Visitor fills out registration form
      [1/1] registerCreator ........... POST /api/auth/register → 200 ✓ (133ms)
    Verify: Creator user exists in DB ✓
  Run: register-creator → PASS ✓ (134ms)
  Run: grant-creator-role
    Goal: Admin grants creator capability to registered user
    📄 /__plato/system — Admin grants creator permissions (admin panel action)
      [1/1] grantCreatorAccess ........ PATCH /api/admin/users/usr-abc → 200 ✓ (2ms)
    Verify: Creator user has can_create_courses permission ✓
  Run: grant-creator-role → PASS ✓ (3ms)
  ...
```

Each run shows: the goal, the page visits (with 📄 prefix), the actions (with status, method, path, timing), and the DB verifications.

### Interpreting failures

When a run fails, the failure message tells you exactly what went wrong:

- **Action failure:** `Expected status 200, got 403. Body: {"error":"Creator access required"}` — the endpoint rejected the request. Either the actor doesn't have the right permissions (prior run didn't set them up) or the auth mock isn't working.

- **Verification failure:** `Expected row to exist, got null` — the DB doesn't contain the expected data. Either the action didn't write it, or a prior run didn't deposit the prerequisite data.

- **Context resolution failure:** `No context for action 'loadCommunities'. Has it executed yet in this run?` — you're referencing an action that hasn't run yet in this run, or it failed.

- **Actor resolution failure:** `fromDB actor resolution failed: no user with email 'mara.chen@example.com' in database. Has a prior run registered this user?` — the actor wasn't registered by a prior run. Check run ordering.

---

## The Developer's Manual Walk-Through

**PLATO proves the API chain works. You must prove the UI works.**

After PLATO runs pass, the developer must manually walk each run in a browser to verify that the UI can actually trigger the API calls PLATO tested. Each run definition is a manual test script — the `route` tells you where to go, the `description` tells you what to do, and the `actions` tell you what should happen.

### Why This Step Is Required

PLATO calls API endpoints directly — it never opens a browser. This means it cannot detect:

- A page that is missing the button or form that triggers the API call
- A dropdown that doesn't populate with the data the user needs to select
- A form field that exists but sends the wrong field name to the API
- A page that loads but shows an error state because a client-side query fails
- UI state that prevents the user from reaching the action (disabled button, hidden section, broken navigation)

If PLATO's Run 4 calls `POST /api/me/courses` with `{ progression_id: "prog-abc" }` and it works, that proves the **server** can create a course. But if the course creation page doesn't have a progression dropdown — or has one that's empty — the user can't do it. Only a manual walk-through catches this.

### How to Walk a Run

For each run, follow the `route` and `description` fields:

```
Run 4: create-course
  📄 /creating/communities — Creator loads their communities to discover the community slug
    → Go to /creating/communities. Verify your community appears in the list.
  📄 /creating/courses/new — Creator fills in course creation form
    → Go to /creating/courses/new. Verify the progression dropdown is populated.
       Select a progression. Fill in title and level. Click Create.
  📄 /creating/courses/[id] — Creator updates course details and sets thumbnail
    → You should be on the course detail page. Fill in description, tagline, duration, price.
       Click Save. Upload a thumbnail.
```

If any step fails in the browser that passed in PLATO, that's a UI bug — the API works but the page doesn't expose it correctly.

### When to Walk

- **After adding a new run** — verify the UI supports the actions you defined
- **After changing a page** — re-walk any runs that touch that route
- **Before release** — walk the full chain at least once

---

## Why Not Playwright for Everything?

We considered making PLATO runs drive Playwright instead of calling APIs directly. Here's why we chose API emulation.

### The Flakiness Problem

Playwright tests fail for reasons that have nothing to do with your code:

- **Hydration timing** — Astro's `client:load` islands may not be interactive when Playwright tries to click. We've already had to add `waitForLoadState('networkidle')` workarounds.
- **Animation and transition delays** — a button exists but isn't clickable yet because a CSS transition hasn't finished.
- **Selector brittleness** — a class name or DOM structure change breaks the selector, but the feature still works perfectly.
- **Network timing** — a slow API response causes a timeout on CI but passes locally.

When a PLATO API run fails, it means **the server cannot handle this request sequence**. That's a real, actionable bug. When a Playwright test fails, it might mean the server is broken, OR the DOM changed, OR the animation was slow, OR the CI machine was under load. You have to investigate to find out. That's not "break fast and loud" — that's "break fast and garbled muttering."

### The Speed Problem

| Approach | Time for 6 Runs (~15 API calls) |
|---|---|
| PLATO API emulation | ~200ms |
| Playwright (estimated) | 30-60 seconds |

PLATO runs 150-300x faster. This matters for development iteration: you change an endpoint, run PLATO, see the result in under a second. With Playwright, every debug cycle costs 30+ seconds of browser startup, page loads, and rendering.

### The Debugging Problem

When a PLATO action fails, you get:
```
[3/5] createCourse ... POST /api/me/courses → 403 ✗ FAILED
     Expected status 201, got 403. Body: {"error":"Creator access required"}
```

The problem is immediately clear: the creator doesn't have permissions. You know exactly which endpoint, which status, which error message.

When a Playwright test fails, you get a screenshot of a page that might show an error toast, or might show a loading spinner, or might show nothing wrong at all because the assertion timed out waiting for an element that was already on the page but had the wrong text content.

### What Playwright IS Good For

Playwright is the right choice for specific, targeted E2E tests that verify multi-browser, real-time interactions — things PLATO can't model at all:

- Teacher and student both in a video session room simultaneously
- Real-time notifications appearing across browser tabs
- OAuth redirect flows

These are in the E2E-GAPS block, separate from PLATO. Playwright tests are written sparingly, for scenarios that genuinely require a browser.

### The Division of Labor

| Concern | Tested By |
|---|---|
| Can the server handle this API sequence? | **PLATO** (automated, fast, deterministic) |
| Does the UI expose the right actions? | **Developer manual walk-through** (using PLATO run definitions as scripts) |
| Do multi-browser real-time flows work? | **Playwright E2E** (targeted, few tests) |
| Does a single endpoint handle bad input? | **API unit tests** (comprehensive, fast) |

---

## What PLATO Does NOT Cover

### 1. UI Rendering

PLATO calls API endpoints directly — no browser, no HTML, no React components. If a page is missing a button, has a broken form, or doesn't load data correctly, PLATO won't catch it.

**Mitigation:** Each run's `route` and `description` fields serve as a manual test script. After PLATO passes, walk through the runs in a browser to verify the UI matches.

### 2. Navigation Paths

PLATO doesn't test how users get to a page. It tests what happens when they're there. A user might reach `/creating/courses/new` from the dashboard, a community page, or a direct link — PLATO doesn't care.

### 3. Error Handling and Validation

PLATO is **happy path only**. It tests: "Can a user accomplish this goal?" Not: "What happens when they make a mistake?" Bad input, missing fields, permission violations, and edge cases are tested by the unit and API test layers (and the future STUMBLE-AUDIT block).

### 4. Multi-Browser Scenarios

Some flows require two users simultaneously (e.g., teacher and student in a video session). PLATO models these as sequential actions by different actors — which validates the API chain but not the real-time interaction. True multi-browser testing requires Playwright E2E tests (see E2E-GAPS block).

### 5. Client-Side State

React component state, localStorage, cookies set by JavaScript, WebSocket connections — none of these are tested by PLATO. The auth mock simulates cookies at the API level.

### 6. Timing and Concurrency

PLATO executes actions sequentially. It won't catch race conditions, double-submit bugs, or timing-dependent behavior.

---

## How to Add a New Run

### Step 1: Create the run file

Create `tests/plato/runs/your-run-name.run.ts`:

```typescript
import type { PlatoRun } from '../lib/types';

export const run: PlatoRun = {
  name: 'your-run-name',
  goal: 'What the user accomplishes in this run',

  actors: {
    // Who participates. Use 'fromDB' for actors registered in prior runs.
    student: {
      source: 'fromDB',
      personaKey: 'student',
    },
  },

  visits: [
    {
      route: '/the-page-url',
      description: 'What the user sees when they visit this page',
      actions: [
        {
          name: 'uniqueActionName',
          description: 'What the user does (for manual test script)',
          actor: 'student',
          method: 'POST',
          path: '/api/endpoint',
          body: {
            field: '$persona.fieldName',           // from persona data
            otherId: '$context.priorAction.key',   // from earlier action in this run
          },
          expectedStatus: 201,
          provides: {
            resultId: 'result.id',                 // extract from response for later use
          },
        },
      ],
    },
  ],

  verify: [
    {
      description: 'What should be true in the DB after this run',
      query: 'SELECT ... FROM ... WHERE ... = ?',
      params: ['$persona.someField'],              // or '$actor.student.userId'
      assert: { type: 'exists' },
    },
  ],
};
```

### Step 2: Add persona data (if needed)

If your run uses data not already in the persona set, add it to `tests/plato/personas/genesis.ts`. Place new fields in the appropriate section:

```typescript
actors: {
  student: {
    name: 'Alex Rivera',
    email: 'alex.rivera@example.com',
    // ── Course Review: SITE-NECESSARY ──────────────────
    enrollmentReason: 'Career change into AI',
  },
}
```

Use the section comment pattern (`DB-REQUIRED` / `SITE-NECESSARY`) so future readers know whether each field is mandatory for the run to pass or optional for site completeness. When the run body references a persona field, that field MUST exist — the runner throws if it's missing. There are no conditionals or defaults.

### Step 3: Register the run

Add it to the run loader in `tests/plato/runs/index.ts`:

```typescript
const runLoaders: Record<string, () => Promise<{ run: PlatoRun }>> = {
  // ... existing runs ...
  'your-run-name': () => import('./your-run-name.run'),
};
```

### Step 4: Add to the chain

Add it to the run order in `tests/plato/runs/_chain.ts`:

```typescript
export const defaultChain: PlatoChain = {
  name: 'full-flywheel',
  order: [
    // ... existing runs ...
    'your-run-name',    // ← add here, in dependency order
  ],
  personaSet: 'genesis',
};
```

**Order matters.** Your run goes after every run it depends on. If your run needs a published course, it goes after `publish-course`.

### Step 5: Add mock setups (if needed)

If your run calls endpoints that use external services (Stripe, Stream, BBB), add a mock setup to `tests/plato/lib/mock-registry.ts` and reference it in your action's `serviceMocks`.

### Step 6: Run and debug

```bash
cd ../Peerloop && npm run test:plato
```

Common issues when adding runs:
- **403 Forbidden** — actor doesn't have the right permissions. Check `fromDB` resolution and role flags.
- **404 Not Found** — the entity doesn't exist in the DB. Check that prior runs create it.
- **Wrong response shape** — the `provides` path doesn't match the actual API response. Check the endpoint's `Response.json(...)` call.
- **Handler import failure** — the `path` and `params` don't map to the correct file. Check Astro's file-based routing (`[id].ts` patterns).

### Step 7: Verify the "break fast and loudly" property

Comment out one of the prior runs and verify your new run fails. This confirms your run actually depends on the DB state, not some hidden shortcut.

---

## Key Design Decisions

| Decision | Choice | Why |
|---|---|---|
| State mechanism | DB-accumulation | Breaks fast and loudly — no carry state hiding integration gaps |
| Run ordering | Fixed, manually sequenced | Order IS the dependency graph — simple, explicit, no magic |
| Run structure | Page visits with actions | Models what users actually do; doubles as manual test script |
| System events | Phantom page (`/__plato/system`) | Keeps "visit page, take action" metaphor universal |
| Intra-run data | `$context` (cleared between runs) | "What the page showed the user" — not cross-run state |
| Actor identity | DB lookup by persona email | Simple, realistic, no cross-run carry needed |
| Path coverage | Happy path only | Stumbles tested at unit/API layer (STUMBLE-AUDIT block) |
| External services | Mock at library boundary | All handler logic runs for real; only HTTP calls faked |
| DB lifecycle | Fresh in-memory per test session | Deterministic, no cross-test contamination |
| Starting state | Core seed only | Matches production; proves day-one viability |
| Test execution | API emulation (not Playwright) | Fast (~200ms), deterministic, debuggable; Playwright is too flaky |
| Persona field categories | DB-REQUIRED vs SITE-NECESSARY comments | Runs prove minimum viability; enriched data proves site completeness |
| No conditionals | If persona has field and run references it, it's sent | No "if provided, include" logic — you control both sides |

---

## File Structure

```
tests/plato/
├── lib/
│   ├── types.ts              # PlatoRun, PageVisit, PageAction, etc.
│   ├── api-runner.ts         # PlatoRunner — executes runs against DB
│   ├── reporter.ts           # Console progress output
│   └── mock-registry.ts      # Service mock factories (Stripe, Stream, BBB, etc.)
├── runs/
│   ├── _chain.ts             # Fixed run order (the dependency graph)
│   ├── index.ts              # Run loader (dynamic imports)
│   ├── register-creator.run.ts
│   ├── grant-creator-role.run.ts
│   ├── create-community.run.ts
│   ├── create-course.run.ts
│   ├── add-modules.run.ts
│   ├── publish-course.run.ts
│   ├── register-student.run.ts
│   ├── self-certify-creator.run.ts
│   ├── enroll-student.run.ts
│   ├── complete-course.run.ts
│   └── certify-teacher.run.ts
├── personas/
│   ├── index.ts              # Persona set loader
│   └── genesis.ts            # Default persona set (Mara Chen, Alex Rivera, Admin)
├── api/
│   └── plato-chain.api.test.ts  # Test file — single runner, DB is the state
├── browser/                  # Future: Playwright per-run tests (not yet built)
└── harvest/                  # Future: DB → SQL seed export (not yet built)
```

---

## Interpolation Reference

| Syntax | Resolves To | Scope |
|---|---|---|
| `$persona.fieldName` | Active actor's persona data | Any action |
| `$context.actionName.key` | Response value from a prior action | Within the same run only |
| `$actor.actorName.userId` | Actor's resolved session userId | Any action (actor must be initialized) |
| `$actor.actorName.email` | Actor's resolved session email | Any action |
| `$runtime.key` | Value from runner config runtimeValues | Any action |

### In paths (inline interpolation)

```
/api/me/courses/$context.createCourse.courseId/publish
→ /api/me/courses/crs-abc123/publish
```

### In bodies (full value replacement)

```typescript
body: {
  title: '$persona.courseTitle',           // → 'Introduction to AI Product Management'
  progression_id: '$context.loadProgressions.progressionId',  // → 'prog-xyz'
}
```

### In verifications (bind params)

```typescript
verify: [{
  query: 'SELECT is_active FROM courses WHERE title = ?',
  params: ['$persona.courseTitle'],
  assert: { type: 'equals', field: 'is_active', expected: 1 },
}]
```

---

## Current Run Catalog

| # | Run | Actor | What It Does | What It Deposits |
|---|-----|-------|-------------|-----------------|
| 1 | `register-creator` | Visitor | Registers Mara Chen at `/signup` | User record |
| 2 | `grant-creator-role` | Admin | Grants `can_create_courses` permission | Permission flag |
| 3 | `create-community` | Creator | Creates "AI Product Leaders" community | Community + default progression |
| 4 | `create-course` | Creator | Discovers progression, creates course, updates details, sets thumbnail | Course with description, price, thumbnail |
| 5 | `add-modules` | Creator | Discovers course, adds 3 curriculum modules | 3 module records |
| 6 | `publish-course` | Creator | Discovers course, publishes it | Course status = published |
| 7 | `register-student` | Visitor | Registers Alex Rivera at `/signup` | User record |
| 8 | `self-certify-creator` | Creator | Sets up Stripe Connect + self-certifies as teacher | `stripe_account_id` + `teacher_certifications` row |
| 9 | `enroll-student` | Student | Discovers course, creates checkout, Stripe webhook fires | Enrollment + community membership |
| 10 | `complete-course` | Student | Books 3 sessions + BBB webhooks complete them | 3 completed sessions + enrollment status = completed |
| 11 | `certify-teacher` | Creator | Certifies the student as a teacher | `teacher_certifications` row + `can_teach_courses = 1` |

All 11 runs pass. PLATO proves the complete learn-teach-earn flywheel works end-to-end.
