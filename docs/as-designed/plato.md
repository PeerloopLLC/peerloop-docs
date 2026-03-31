# PLATO — Platform Action Test Orchestrator

**Purpose:** Test that users can accomplish their goals through the platform by executing realistic sequences of page visits and actions against a real database, where the accumulated DB state IS the system truth.

**Status:** ✅ Complete — 11 runs, full flywheel passing (Conv 062)

---

## Problem

Peerloop's test suite has strong unit and API endpoint coverage, but a fundamental gap: **seed data proves the app can display data, not that it can create data.**

- Unit tests (`tests/lib/`) use hand-crafted DB inserts
- API tests (`tests/api/`) insert prerequisite data via SQL, then test one endpoint
- Integration tests (`tests/integration/`) insert data for 2-3 coupled operations
- E2E tests (`e2e/`) navigate pre-seeded pages; only 2 of 33 specs create data through the UI

No test layer validates that the *output* of one feature is valid *input* for the next. A user who registers, enrolls, books a session, completes it, and gets certified passes through ~6 API endpoints whose data must be mutually compatible. Today, each endpoint is tested in isolation with "perfect" hand-inserted data.

---

## Design Evolution

| Conv | Model | Key Idea |
|------|-------|----------|
| 060 (initial) | Monolithic runs | Long API sequences covering entire journeys |
| 060 (discussion) | Composable segments | Dependency graph, topological sort, carry state |
| 061 | **Model B: Sequential DB-accumulation** | Fixed run order, DB is the truth, no carry state |

### Why Model B

Conv 060's composable segment model (Model A) used explicit carry state (`$carry.stepName.key`) to pass data between segments. This is artificial — no real user carries data in named maps. The carry state acts as a safety net that **hides integration gaps**.

Model B removes the net: each run deposits data into the DB. The next run's API calls succeed only if the data is actually there. If it's not, the test **breaks fast and loudly** — which is the point.

| Aspect | Model A (Composable Segments) | Model B (DB-Accumulation) |
|--------|------|------|
| State mechanism | Explicit carry maps | The database |
| Run ordering | Dynamic (topological sort) | Fixed (manually sequenced) |
| Composability | Any segment can be a leaf | Runs are sequential, not independent |
| Realism | Artificial (injected state) | Realistic (mirrors production) |
| Failure mode | Silent gaps (carry hides missing data) | Loud failures (missing DB data = test failure) |
| Independence | Segments run in isolation | Run N requires Runs 1..(N-1) |

---

## Core Concepts

### Page-Action Model

A PLATO run models what a real user does: **visit a page, take an action.** Each run is a sequence of page visits, where each visit has:

1. **Route** — the page the user is on (real page, or phantom system page for webhooks)
2. **Actions** — one or more button presses / form submits on that page
3. **API calls** — what each action triggers
4. **Data** — what the API needs (pre-supplied via persona, or already in the DB from prior runs)

The test validates: **when the user reaches this page, does the DB contain the data this page's API calls need?**

### Sequential Run Order

Runs execute in a fixed, manually sequenced order against a single in-memory database:

```
Run 1: register-creator     → DB now has a creator user
Run 2: grant-creator-role   → DB now has creator with can_create_courses
Run 3: create-community     → DB now has a community
Run 4: create-course        → DB now has a course in the community
Run 5: add-modules          → DB now has curriculum modules
Run 6: publish-course       → DB now has a published, enrollable course
Run 7: register-student     → DB now has a student user
Run 8: enroll-student       → DB now has an enrollment + payment records
Run 9: book-session         → DB now has a scheduled session
Run 10: complete-session    → DB now has a completed session + ratings
Run 11: certify-teacher     → DB now has a teacher certification
```

Each run assumes all prior runs have completed successfully. The database accumulates state across the full sequence. A fresh in-memory database (seeded with core data via `seedCoreTestDB()`) is created at the start — deterministic, no cross-test contamination.

### Page Visits Within a Run

A run may involve multiple page visits, and a single page visit may involve multiple API calls:

```typescript
interface PlatoRun {
  name: string;              // 'create-course'
  goal: string;              // "Creator creates a course in their community"
  actor: ActorName;          // who performs this run
  visits: PageVisit[];       // ordered sequence of page visits
  verify: DBVerification[];  // confirm the goal was achieved in the DB
}

interface PageVisit {
  route: string;             // '/creating/courses/new'
  actions: PageAction[];     // actions taken on this page
}

interface PageAction {
  description: string;       // 'Fill form and click Create'
  apiCall: APICallSpec;      // POST /api/me/courses, with expected request/response shape
}
```

### Same Page, Multiple Actions

When multiple API calls happen on the same page (e.g., update course details, upload thumbnail, publish — all on `/creating/courses/[id]`), they're modeled as multiple actions within one page visit. Data from one API response (e.g., `courseId` from creation) feeds the next action's API call. The user stays on the page.

Alternatively, the user may leave and return to the same route — modeled as two separate page visits. Both are valid user patterns.

### Phantom System Page

Some actions aren't triggered by a user pressing a button — they're system events:

- **Stripe webhook** — fired after payment
- **BBB webhook** — fired after session ends
- **Certificate side effects** — teacher access granted after certification

These are modeled as visits to a **phantom system page** — a test-only construct that doesn't exist in production. The phantom page hosts "buttons" that emulate system events (fire webhooks, trigger background processes).

```typescript
// Phantom page for system events
{
  route: '/__plato/system',  // test-only, not a real route
  actions: [
    {
      description: 'Stripe fires checkout.session.completed webhook',
      apiCall: { method: 'POST', path: '/api/webhooks/stripe', body: stripeFixture }
    }
  ]
}
```

### Actor Switches

The run sequence involves multiple actors (visitor, creator, admin, student, teacher). Each run declares its `actor`. The runner handles auth context switching between runs. Within a single run, the actor is constant.

For multi-actor scenarios (e.g., both teacher and student in a session room), model as sequential visits by different actors rather than simultaneous presence — the API chain doesn't require simultaneity.

### Persona Data

Runs need concrete data — names, emails, course titles. A `PersonaSet` provides this data keyed by actor:

```typescript
interface PersonaSet {
  creator: PersonaData;   // { name: 'Mara Chen', email: '...', ... }
  student: PersonaData;
  admin: PersonaData;
  // ...
}
```

Runs reference `persona.creator.name`, `persona.student.email`, etc. The persona provides pre-supplied data; everything else comes from the DB (deposited by prior runs).

### DB-REQUIRED vs SITE-NECESSARY

Persona fields are organized into two categories, marked with comments:

- **DB-REQUIRED** — Fields that the publish gate or endpoint validation demands. If missing, the run fails with a 400/422. These are the minimum data for a valid entity.

- **SITE-NECESSARY** — Fields that are optional in the DB but produce a complete-looking site. If missing, runs still pass but manual testing reveals empty About tabs, missing objectives, blank cover images. These are a judgment call — the persona file lists all schema fields so you can decide what to populate.

This separation means PLATO serves two levels of assurance:
1. **Minimum viability** — with only DB-REQUIRED fields, runs prove the API chain works
2. **Site completeness** — with SITE-NECESSARY fields added, runs also prove that the full data round-trips correctly through create → store → display

To create a second creator with different data, copy the persona block and change the values. Both categories are just flat fields in the persona — no runtime conditionals. If a run body references `$persona.courseObjectives`, the persona must have it; if the persona has a field the run doesn't reference, it's simply unused.

---

## Validation Layers

A run definition is **layer-agnostic** — it describes what the user does. The test harness decides how to execute it:

| Layer | How It Executes | What It Proves |
|---|---|---|
| **API layer** | Direct API calls, verify DB state | Server handles the call sequence correctly |
| **Playwright layer** (future) | Actually visit pages, press buttons, verify APIs fire | UI provides the data and actions the user needs |

Both layers use the same run definitions. The API layer is fast (in-memory DB, no browser). The Playwright layer is slow but proves the UI works.

---

## Run Catalog

### Full Flywheel Sequence

| # | Run | Actor | Route(s) | API Calls | Deposits |
|---|-----|-------|----------|-----------|----------|
| 1 | `register-creator` | Visitor | `/signup` | `POST /api/auth/register` | User record (creator persona) |
| 2 | `grant-creator-role` | Admin | `/__plato/system`* | `PATCH /api/admin/users/[id]` | `can_create_courses = true` |
| 3 | `create-community` | Creator | `/creating/communities` | `POST /api/me/communities` | Community + default progression |
| 4 | `create-course` | Creator | `/creating/courses/new`, `/creating/courses/[id]` | `POST /api/me/courses`, `PUT .../[id]`, `PUT .../thumbnail` | Course with details + thumbnail |
| 5 | `add-modules` | Creator | `/creating/courses/[id]/curriculum` | `POST /api/me/courses/[id]/curriculum` (x3) | 3 curriculum modules |
| 6 | `publish-course` | Creator | `/creating/courses/[id]` | `PUT /api/me/courses/[id]/publish` | Course status = published |
| 7 | `register-student` | Visitor | `/signup` | `POST /api/auth/register` | User record (student persona) |
| 8 | `enroll-student` | Student | `/course/[slug]`, `/__plato/system` | `POST /api/checkout/create-session`, `POST /api/webhooks/stripe` | Enrollment + payment records |
| 9 | `book-session` | Student | `/course/[slug]/book` | `POST /api/sessions` | Scheduled session |
| 10 | `complete-session` | Teacher+Student | `/session/[id]`, `/__plato/system` | `POST .../join` (x2), `POST /api/webhooks/bbb` | Completed session |
| 11 | `certify-teacher` | Creator | `/creating/courses/[id]` | `POST /api/me/courses/[id]/teachers` | `teacher_certifications` record |

*Grant-creator uses the phantom system page because there's no dedicated admin page for this action in the current UI — it's an API call the admin makes. If an admin UI page is built later, update the route.

### Supporting Runs (after flywheel)

| # | Run | Actor | Route(s) | API Calls |
|---|-----|-------|----------|-----------|
| 12 | `join-community` | Student | `/community/[slug]` | `POST /api/communities/[slug]/join` |
| 13 | `create-post` | Student | `/community/[slug]` | `POST /api/feeds/community/[slug]` |

---

## External Service Boundaries

| Service | PLATO Approach |
|---|---|
| **Stripe** | Mock at `@/lib/stripe`; fire synthetic webhook via phantom system page |
| **Stream.io** | Mock at `@/lib/stream`; verify D1 feed_activities written correctly |
| **BigBlueButton** | Mock at `@/lib/video`; fire synthetic webhooks via phantom system page |
| **Resend (email)** | Mock at `resend`; verify called with correct data |

All handler logic, validation, DB writes, and state transitions run for real. Only external HTTP calls are faked.

---

## Testing Arsenal

| Layer | Question | Path Type | Scope |
|---|---|---|---|
| **Unit tests** | Does this function handle edge cases? | Error, boundary | Single function |
| **API tests** | Does this endpoint reject bad input, enforce auth, handle stumbles? | Error, validation | Single endpoint |
| **Integration tests** | Do these components interact correctly? | State transitions | 2-3 coupled operations |
| **PLATO API** | Can the server handle this user goal's API sequence, with real DB state? | **Happy path** | Run (sequential, cumulative) |
| **PLATO Browser** (future) | Does the UI at this route provide the data and actions the user needs? | **Happy path** | Run (per route) |
| **E2E tests** | Do multi-user real-browser flows work? | Critical paths | Cross-user, full stack |

---

## Implementation Status

### Phase 1: Foundation (Conv 060)

- `tests/plato/lib/types.ts` — type definitions
- `tests/plato/lib/api-runner.ts` — `PlatoRunner` class
- `tests/plato/lib/reporter.ts` — console progress output
- `tests/plato/lib/mock-registry.ts` — service mock factories
- `tests/helpers/test-db.ts` — added `seedCoreTestDB()` (core seed only)

### Phase 2: First Run (Conv 060)

Built as a monolithic run (pre-Model-B). 10 API steps, all passing:

```
register → admin grants access → create community → create course →
update details → set thumbnail → add module x3 → publish
```

**Findings:**
- **Bug found:** `community_members.joined_via` CHECK constraint missing `'registration'` — fixed
- **Design gap surfaced:** thumbnail requires separate endpoint (`PUT .../thumbnail`), not part of course update
- **API verified:** `POST /api/me/communities` creates community + default progression atomically

Files: `runs/creator-publishes-course.run.ts`, `personas/genesis.ts`, `api/plato-chain.api.test.ts`

### Phase 3: Model B Refactor ✅ (Conv 061)

Restructured from flat API sequence to page-visit model with DB-accumulation:

- Split monolithic run into 6 individual runs with page-visit structure
- Replaced `$carry` with `$context` (intra-run only) and `$actor` references
- Added `fromDB` actor resolution (queries users table by persona email)
- Discovery GET pattern: runs that operate on prior runs' data start with a GET to find the entity
- Removed all cross-run carry state (`chainCarry`, `$chainCarry`)
- Single `PlatoRunner` instance executes all runs against one shared DB
- All 6 runs pass, 6362 total tests passing (no regressions)

Files restructured: `types.ts`, `api-runner.ts`, `reporter.ts`, `mock-registry.ts`, `personas/genesis.ts`, 6 new run files, `_chain.ts`, `index.ts`, `plato-chain.api.test.ts`

### Phase 4: Full Flywheel ✅ (Conv 062)

Added 5 new runs (7-11) completing the learn-teach-earn cycle:

- **Run 7: register-student** — mirrors register-creator for student persona
- **Run 8: self-certify-creator** — Stripe Connect setup + creator self-certifies as teacher (required for enrollment guards and booking validation)
- **Run 9: enroll-student** — course discovery, checkout creation, Stripe `checkout.session.completed` webhook via phantom page creates enrollment
- **Run 10: complete-course** — books 3 sessions, fires BBB `room_ended` webhooks for each; `completeSession()` freezes module IDs, and 3rd completion auto-completes enrollment via `checkEnrollmentCompletion()`
- **Run 11: certify-teacher** — creator discovers eligible student and certifies them; flywheel closes

Infrastructure changes:
- Added `headers` field to `PageAction` type (needed for Stripe webhook signature)
- Fixed `ctx.url` search params propagation (Astro handlers read from `url`, not `request.url`)
- Added `createConnectedAccount`, `createAccountLink` to Stripe mock
- Added `bbb-webhook-room-ended` mock setup (configures `parseWebhook` return per session)
- Added `parseWebhook`, `getRoomInfo`, `getRecordings` to BBB provider mock
- Added `getUserEmail` to email mock, R2 mock for recording replication
- All 11 runs pass, 6367 total tests (no regressions)

**Key discovery:** `maybeUpdateActorSession` auto-detects user creation by checking for `provided.userId`/`studentId`/`teacherId` keys. This can corrupt actor sessions when a discovery action provides someone else's ID under those key names. Worked around by using `assignedTeacherUserId` instead of `teacherId` for enrollment discovery.

---

## Current File Structure

```
tests/plato/
├── lib/
│   ├── types.ts              # Type definitions
│   ├── api-runner.ts         # PlatoRunner (needs page-visit model)
│   ├── reporter.ts           # Console progress reporter
│   └── mock-registry.ts      # Service mock factories
├── runs/
│   ├── index.ts              # Run loader
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
│   └── genesis.ts            # Persona set (Mara Chen, Alex Rivera, Admin)
├── api/
│   └── plato-chain.api.test.ts  # Test file with mock wiring
├── browser/                  # Future: Playwright per-run tests
└── harvest/                  # Future: DB → SQL export
```

---

## Design Decisions

| Decision | Choice | Rationale |
|---|---|---|
| State mechanism | DB-accumulation (Model B) | Breaks fast and loudly — no carry state hiding integration gaps |
| Run ordering | Fixed, manually sequenced | Run N assumes Runs 1..(N-1) completed; order IS the dependency graph |
| Run structure | Page visits with actions | Models what users actually do: visit page, press button |
| System events | Phantom system page (`/__plato/system`) | Keeps "visit page, press button" metaphor universal for webhooks |
| Actor switching | Per-run actor declaration | Runner handles auth context; one actor per run |
| Multi-actor scenarios | Sequential visits by different actors | API chain doesn't require simultaneity |
| Same-page multi-action | Multiple actions within one visit | User stays on page; response data feeds next action |
| DB lifecycle | Fresh in-memory DB per test session | Deterministic, no cross-test contamination |
| Starting state | Core seed only (`seedCoreTestDB()`) | Matches production; proves day-one viability |
| Happy path only | Yes | Stumbles tested at unit/API layer (STUMBLE-AUDIT) |
| External services | Mock at service boundary | Tests all handler logic; only HTTP calls faked |
| Persona data | Actor-keyed, flat fields with section comments | Simple, copyable for new actors; no runtime conditionals |
| Field categories | DB-REQUIRED vs SITE-NECESSARY comments in persona | Runs prove minimum viability; enriched personas prove site completeness |
| Adding data | Add field to persona + reference in run body | No conditionals — if persona has it and run references it, it's sent; if not, it's not |
| Test layers | Layer-agnostic run definitions | Same definition drives API tests and future Playwright tests |

---

*Created: Conv 060. Revised Conv 061: adopted Model B (sequential DB-accumulation), page-action model, phantom system page. Model B refactor implemented Conv 061.*

See also: `docs/as-designed/plato-implementation-plan.md` (Conv 060 plan, superseded by Model B but retains useful technical patterns).
