# PLATO — Platform Action Test Orchestrator

**Purpose:** Test that users can accomplish their goals through the platform by executing realistic sequences of page visits and actions against a real database, where the accumulated DB state IS the system truth.

**Status:** ✅ Scenarios operational — 4 scenarios (flywheel, ecosystem, activities, seed-dev), 19 steps, 48 SqlTopUp steps, all passing (Conv 066)

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

Model B removes the net: each step deposits data into the DB. The next step's API calls succeed only if the data is actually there. If it's not, the test **breaks fast and loudly** — which is the point.

| Aspect | Model A (Composable Segments) | Model B (DB-Accumulation) |
|--------|------|------|
| State mechanism | Explicit carry maps | The database |
| Step ordering | Dynamic (topological sort) | Fixed (manually sequenced) |
| Composability | Any segment can be a leaf | Steps are sequential, not independent |
| Realism | Artificial (injected state) | Realistic (mirrors production) |
| Failure mode | Silent gaps (carry hides missing data) | Loud failures (missing DB data = test failure) |
| Independence | Segments run in isolation | Step N requires Steps 1..(N-1) |

---

## Core Concepts

### Taxonomy

PLATO uses four concepts:

| Concept | Definition | Code Location |
|---------|-----------|---------------|
| **Step** | Atomic action template — data-independent, models one user goal (e.g., register, create course) | `tests/plato/steps/*.step.ts` |
| **Scenario** | Sequence of steps + DB verification — proves a situation or populates a database | `tests/plato/scenarios/*.scenario.ts` |
| **Persona Set** | Named collection of actor data — provides the concrete values steps need | `tests/plato/personas/*.ts` |
| **Instance** | Scenario bound to a specific persona set + execution mode — the unit you actually run | *Future: `tests/plato/instances/*.instance.ts`* |

Steps are templates — they reference `$persona.email` without knowing whose email. Scenarios compose steps into sequences. Persona sets provide the data. Instances bind scenarios to persona sets with an execution mode (`test`, `seed`, `walkthrough`, `repro`).

Today, instances are implicit — each scenario file hardcodes its `personaSet`. The instance concept will be extracted in a future conv to enable running the same scenario with different data (e.g., walkthrough personas for manual testing vs genesis personas for CI).

### Page-Action Model

A PLATO step models what a real user does: **visit a page, take an action.** Each step is a sequence of page visits, where each visit has:

1. **Route** — the page the user is on (real page, or phantom system page for webhooks)
2. **Actions** — one or more button presses / form submits on that page
3. **API calls** — what each action triggers
4. **Data** — what the API needs (pre-supplied via persona, or already in the DB from prior steps)

The test validates: **when the user reaches this page, does the DB contain the data this page's API calls need?**

### Sequential Step Order

Steps execute in a fixed, manually sequenced order against a single in-memory database:

```
Step 1: register-creator     → DB now has a creator user
Step 2: grant-creator-role   → DB now has creator with can_create_courses
Step 3: create-community     → DB now has a community
Step 4: create-course        → DB now has a course in the community
Step 5: add-modules          → DB now has curriculum modules
Step 6: publish-course       → DB now has a published, enrollable course
Step 7: register-student     → DB now has a student user
Step 8: enroll-student       → DB now has an enrollment + payment records
Step 9: book-session         → DB now has a scheduled session
Step 10: complete-session    → DB now has a completed session + ratings
Step 11: certify-teacher     → DB now has a teacher certification
```

Each step assumes all prior steps have completed successfully. The database accumulates state across the full sequence. A fresh in-memory database (seeded with core data via `seedCoreTestDB()`) is created at the start — deterministic, no cross-test contamination.

### Page Visits Within a Step

A step may involve multiple page visits, and a single page visit may involve multiple API calls:

```typescript
interface PlatoStep {
  name: string;              // 'create-course'
  goal: string;              // "Creator creates a course in their community"
  actor: ActorName;          // who performs this step
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

The step sequence involves multiple actors (visitor, creator, admin, student, teacher). Each step declares its `actor`. The runner handles auth context switching between steps. Within a single step, the actor is constant.

For multi-actor scenarios (e.g., both teacher and student in a session room), model as sequential visits by different actors rather than simultaneous presence — the API chain doesn't require simultaneity.

### Persona Data

Steps need concrete data — names, emails, course titles. A `PersonaSet` provides this data keyed by actor:

```typescript
interface PersonaSet {
  creator: PersonaData;   // { name: 'Mara Chen', email: '...', ... }
  student: PersonaData;
  admin: PersonaData;
  // ...
}
```

Steps reference `persona.creator.name`, `persona.student.email`, etc. The persona provides pre-supplied data; everything else comes from the DB (deposited by prior steps).

### DB-REQUIRED vs SITE-NECESSARY

Persona fields are organized into two categories, marked with comments:

- **DB-REQUIRED** — Fields that the publish gate or endpoint validation demands. If missing, the step fails with a 400/422. These are the minimum data for a valid entity.

- **SITE-NECESSARY** — Fields that are optional in the DB but produce a complete-looking site. If missing, steps still pass but manual testing reveals empty About tabs, missing objectives, blank cover images. These are a judgment call — the persona file lists all schema fields so you can decide what to populate.

This separation means PLATO serves two levels of assurance:
1. **Minimum viability** — with only DB-REQUIRED fields, steps prove the API chain works
2. **Site completeness** — with SITE-NECESSARY fields added, steps also prove that the full data round-trips correctly through create → store → display

To create a second creator with different data, copy the persona block and change the values. Both categories are just flat fields in the persona — no runtime conditionals. If a step body references `$persona.courseObjectives`, the persona must have it; if the persona has a field the step doesn't reference, it's simply unused.

---

## Validation Layers

A step definition is **layer-agnostic** — it describes what the user does. The test harness decides how to execute it:

| Layer | How It Executes | What It Proves |
|---|---|---|
| **API layer** | Direct API calls, verify DB state | Server handles the call sequence correctly |
| **Playwright layer** (future) | Actually visit pages, press buttons, verify APIs fire | UI provides the data and actions the user needs |

Both layers use the same step definitions. The API layer is fast (in-memory DB, no browser). The Playwright layer is slow but proves the UI works.

---

## Step Catalog

| # | Step | Actor | Route(s) | API Calls | Deposits |
|---|-----|-------|----------|-----------|----------|
| 1 | `register-creator` | Visitor | `/signup` | `POST /api/auth/register` | User record (creator persona) |
| 2 | `grant-creator-role` | Admin | `/__plato/system`* | `PATCH /api/admin/users/[id]` | `can_create_courses = true` |
| 3 | `create-community` | Creator | `/creating/communities` | `POST /api/me/communities` | Community + default progression |
| 4 | `create-course` | Creator | `/creating/courses/new`, `/creating/courses/[id]` | `POST /api/me/courses`, `PUT .../[id]`, `PUT .../thumbnail` | Course with details + thumbnail |
| 5 | `add-modules` | Creator | `/creating/courses/[id]/curriculum` | `POST /api/me/courses/[id]/curriculum` (x3) | 3 curriculum modules |
| 6 | `publish-course` | Creator | `/creating/courses/[id]` | `PUT /api/me/courses/[id]/publish` | Course status = published |
| 7 | `register-student` | Visitor | `/signup` | `POST /api/auth/register` | User record (student persona) |
| 8 | `self-certify-creator` | Creator | `/__plato/system` | Stripe Connect + `POST /api/me/courses/[id]/teachers` | `stripe_account_id` + `teacher_certifications` row |
| 9 | `add-teacher-cert` | Creator | `/__plato/system` | `POST /api/me/courses/[id]/teachers` (no Stripe) | `teacher_certifications` row (for additional courses) |
| 10 | `enroll-student` | Student | `/course/[slug]`, `/__plato/system` | `POST /api/checkout/create-session`, `POST /api/webhooks/stripe` | Enrollment + payment records |
| 11 | `complete-course` | Student | `/course/[slug]/book`, `/__plato/system` | `POST /api/sessions` (x3), `POST /api/webhooks/bbb` (x3) | 3 completed sessions + enrollment auto-complete |
| 12 | `certify-teacher` | Creator | `/creating/courses/[id]` | `POST /api/me/courses/[id]/teachers` | `teacher_certifications` record |
| 13 | `book-complete-session` | Student | `/course/[slug]/book`, `/__plato/system` | `POST /api/sessions`, `POST /api/webhooks/bbb` | 1 completed session (atomic, no enrollment auto-complete) |
| 14 | `cancel-session` | Student | `/learning`, `/__plato/system` | `POST /api/sessions`, `PATCH /api/sessions/[id]/cancel` | 1 cancelled session |
| 15 | `send-message` | Student | `/messages` | `POST /api/me/messages` | Conversation + message |
| 16 | `follow-user` | Student | `/member/[handle]` | `POST /api/me/following` | Follow relationship |
| 17 | `create-homework` | Creator | `/creating/courses/[id]` | `POST /api/me/courses/[id]/homework` | Homework assignment |
| 18 | `submit-homework` | Student | `/learning` | `POST /api/me/homework/[id]/submit` | Homework submission |
| 19 | `set-availability` | Creator | `/teaching/availability` | `POST /api/me/availability` (x3) | 3 availability slots |

*Grant-creator uses the phantom system page because there's no dedicated admin page for this action in the current UI — it's an API call the admin makes. If an admin UI page is built later, update the route.

### Scenarios

Scenarios compose steps into independent, goal-driven test cases. Each scenario has its own persona set, chain of entries, and optional DB verifications.

| Scenario | Category | Persona Set | Steps | Verifications | What It Proves |
|----------|----------|-------------|:-----:|:-------------:|----------------|
| `flywheel` | test | genesis | 11 | 0 (per-step only) | Full learn-teach-earn cycle (steps 1-8, 10-12) |
| `ecosystem` | test | ecosystem | 18 | 7 | Multi-course (2), multi-student (3), actor bindings, findBy discovery |
| `activities` | test | ecosystem | 7 | 0 (per-step only) | Atomic steps: book-complete-session, cancel-session, send-message, follow-user, create-homework, submit-homework, set-availability |
| `seed-dev` | seed | seed-full | 53 API + 48 SqlTopUp | 44 | Full dev database replacing SQL seed. 10 actors, 6 courses, 2 communities, enrichment data across 30+ tables |

Key scenario infrastructure:
- **Actor bindings** — same step invoked with different personas (e.g., enroll-student with student1, student2, student3)
- **findBy in extractPath** — `courses.findBy(title,$persona.courseTitle).id` for multi-course discovery
- **Course flattening** — `runtimeOverrides.courseIndex` copies courses[N] onto persona top level
- **Scenario-level verify** — DB assertions after ALL steps complete (the real test)

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
| **PLATO API** | Can the server handle this user goal's API sequence, with real DB state? | **Happy path** | Step (sequential, cumulative) |
| **PLATO Browser** (future) | Does the UI at this route provide the data and actions the user needs? | **Happy path** | Step (per route) |
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

Files: `steps/creator-publishes-course.step.ts`, `personas/genesis.ts`, `api/plato-chain.api.test.ts`

### Phase 3: Model B Refactor ✅ (Conv 061)

Restructured from flat API sequence to page-visit model with DB-accumulation:

- Split monolithic run into 6 individual steps with page-visit structure
- Replaced `$carry` with `$context` (intra-step only) and `$actor` references
- Added `fromDB` actor resolution (queries users table by persona email)
- Discovery GET pattern: steps that operate on prior steps' data start with a GET to find the entity
- Removed all cross-step carry state (`chainCarry`, `$chainCarry`)
- Single `PlatoRunner` instance executes all steps against one shared DB
- All 6 steps pass, 6362 total tests passing (no regressions)

Files restructured: `types.ts`, `api-runner.ts`, `reporter.ts`, `mock-registry.ts`, `personas/genesis.ts`, 6 new step files, `_chain.ts`, `index.ts`, `plato-chain.api.test.ts`

### Phase 4: Full Flywheel ✅ (Conv 062)

Added 5 new steps (7-11) completing the learn-teach-earn cycle:

- **Step 7: register-student** — mirrors register-creator for student persona
- **Step 8: self-certify-creator** — Stripe Connect setup + creator self-certifies as teacher (required for enrollment guards and booking validation)
- **Step 9: enroll-student** — course discovery, checkout creation, Stripe `checkout.session.completed` webhook via phantom page creates enrollment
- **Step 10: complete-course** — books 3 sessions, fires BBB `room_ended` webhooks for each; `completeSession()` freezes module IDs, and 3rd completion auto-completes enrollment via `checkEnrollmentCompletion()`
- **Step 11: certify-teacher** — creator discovers eligible student and certifies them; flywheel closes

Infrastructure changes:
- Added `headers` field to `PageAction` type (needed for Stripe webhook signature)
- Fixed `ctx.url` search params propagation (Astro handlers read from `url`, not `request.url`)
- Added `createConnectedAccount`, `createAccountLink` to Stripe mock
- Added `bbb-webhook-room-ended` mock setup (configures `parseWebhook` return per session)
- Added `parseWebhook`, `getRoomInfo`, `getRecordings` to BBB provider mock
- Added `getUserEmail` to email mock, R2 mock for recording replication
- All 11 steps pass, 6367 total tests (no regressions)

**Key discovery:** `maybeUpdateActorSession` auto-detects user creation by checking for `provided.userId`/`studentId`/`teacherId` keys. This can corrupt actor sessions when a discovery action provides someone else's ID under those key names. Worked around by using `assignedTeacherUserId` instead of `teacherId` for enrollment discovery.

### Phase 5: Scenario System ✅ (Conv 063)

Replaced single-chain model with independent, goal-driven scenarios:

- **Types:** `PlatoScenario`, `StepRef`, `SqlTopUpRef`, `ChainEntry`, `ScenarioResult` added to `types.ts`
- **Runner:** `executeScenario()` method, `applyActorBindings()`, `flattenCourseData()`, `parseDotPath()` for paren-aware dot splitting, `findBy` in `extractPath`
- **Reporter:** Scenario-level reporting methods
- **Scenarios directory:** `scenarios/index.ts` registry, `flywheel.scenario.ts`, `ecosystem.scenario.ts`
- **Ecosystem persona set:** Mara Chen (2 courses), Sarah/Marcus/Jennifer (3 students), admin
- **New step:** `add-teacher-cert.step.ts` — per-course teacher certification without Stripe Connect
- **Test harness:** `plato-scenarios.api.test.ts` replaces `plato-chain.api.test.ts`
- **4 steps updated:** `add-modules`, `publish-course`, `self-certify-creator`, `certify-teacher` — from `courses[0].id` to `findBy(title,$persona.courseTitle)` for multi-course compatibility
- **Cookie store rekeyed** by persona email (needed for multi-student scenarios)

Ecosystem scenario: 18 chain steps, 7 scenario-level DB verifications. Proves 2 courses, 3 enrollments, 1 student-to-teacher conversion, 3 completed sessions.

All passing: 365 files, 6359 tests.

### Phase 6: Atomic Runs + Activities Scenario ✅ (Conv 063)

Added 7 new atomic steps for platform activities beyond the core flywheel:

- **Step 13: book-complete-session** — books 1 session and completes it (no enrollment auto-complete)
- **Step 14: cancel-session** — books a session then cancels it
- **Step 15: send-message** — student sends message to creator (conversation creation)
- **Step 16: follow-user** — student follows creator (also added `POST /api/me/following` endpoint)
- **Step 17: create-homework** — creator creates homework assignment for a course
- **Step 18: submit-homework** — student submits homework for review
- **Step 19: set-availability** — creator sets 3 recurring availability slots

Activities scenario: composes steps 13-19 to prove these atomic operations work in sequence.

### Phase 7: Seed-Dev Scenario ✅ (Conv 064-065)

Built the seed-dev scenario — a `seed`-category scenario that replaces `migrations-dev/0001_seed_dev.sql` with API-driven data seeding:

- **seed-full persona set:** 10 actors — 2 creators (Guy: 4 courses, Gabriel: 2 courses), 1 core admin, 1 dev admin (Brian), 7 students (Sarah, Marcus, Jennifer, David, Amanda, Alex, Fraser)
- **53 API chain steps** across 10 phases: creator setup, course creation (6 courses), teacher certifications (self-cert + additional), student registration (7), enrollments (5), completions (3), partial progress (David), student→teacher certification (Sarah, Marcus), platform activities (availability, homework, social)
- **SqlTopUp enrichment:** 36 steps adding data with no API endpoint — reviews, ratings, transactions, payment splits, certificates, expertise, qualifications, member profiles, notifications, conversations, moderation, creator applications, success stories, community resources, intro sessions, session credits, contact submissions, session invites, moderator invites, platform stats
- **`npm run db:seed:plato`** — npm script to run the seed-dev scenario and produce a dev database
- **flattenCourseData bug fix** — iteration order now prefers 'creator' actor slot for multi-creator scenarios
- **CTE enrollment limitation** — enrollment CTEs fail in D1 INSERT context; workaround uses explicit JOINs

### Phase 8: Seed-Topup Completion ✅ (Conv 066)

Completed the seed-dev enrichment and validation:

- **Two independent admins** — core admin (`usr-admin`/`admin@peerloop.com`) separated from Brian dev admin (`topup-brian-admin`/`brian@peerloop.com`). 6 files updated across 3 persona sets, 1 run, 1 topup, 1 scenario.
- **Fraser member-only** — SqlTopUp UPDATE strips `can_take_courses` after API registration
- **David's 2 scheduled sessions** — future sessions using enrollment JOIN pattern
- **Marcus n8n data** — 7 new steps: enrollment (completed), teacher certification, session, 2 certificates (completion + teaching), transaction
- **Timestamp backdating** — 4 steps backdate `created_at`/`updated_at`/`last_login` on users, courses, communities, enrollments to match SQL seed dates
- **48 total SqlTopUp steps**, **44 verify assertions** covering every enrichment table
- **Known divergences documented** — hyphenated handles (SQL seed uses hyphens, API rejects them), CTE enrollment limitation

---

## Current File Structure

```
tests/plato/
├── lib/
│   ├── types.ts              # PlatoStep, PlatoScenario, StepRef, SqlTopUpRef, ChainEntry, etc.
│   ├── api-runner.ts         # PlatoRunner — executeScenario(), findBy, actor bindings
│   ├── reporter.ts           # Console progress reporter (step + scenario levels)
│   └── mock-registry.ts      # Service mock factories
├── scenarios/
│   ├── index.ts              # Scenario registry and loader
│   ├── flywheel.scenario.ts  # Genesis flywheel (11 steps)
│   ├── ecosystem.scenario.ts # Multi-course/multi-student (18 steps, 7 verifications)
│   ├── activities.scenario.ts # Atomic steps: session, message, follow, homework, availability
│   ├── seed-dev.scenario.ts  # Full dev database (53 API + 48 SqlTopUp, 44 verifications)
│   └── seed-dev-topup.ts     # SqlTopUp enrichment steps (reviews, ratings, transactions, etc.)
├── steps/
│   ├── _chain.ts             # Legacy fixed step order (used by flywheel scenario)
│   ├── index.ts              # Step loader (dynamic imports)
│   ├── register-creator.step.ts
│   ├── grant-creator-role.step.ts
│   ├── create-community.step.ts
│   ├── create-course.step.ts
│   ├── add-modules.step.ts
│   ├── publish-course.step.ts
│   ├── register-student.step.ts
│   ├── self-certify-creator.step.ts
│   ├── add-teacher-cert.step.ts   # Per-course certification (no Stripe Connect)
│   ├── enroll-student.step.ts
│   ├── complete-course.step.ts
│   ├── certify-teacher.step.ts
│   ├── book-complete-session.step.ts  # Atomic: 1 session (no enrollment auto-complete)
│   ├── cancel-session.step.ts         # Book + cancel
│   ├── send-message.step.ts           # Student → Creator conversation
│   ├── follow-user.step.ts            # Student follows Creator
│   ├── create-homework.step.ts        # Creator creates assignment
│   ├── submit-homework.step.ts        # Student submits work
│   └── set-availability.step.ts       # Creator sets 3 availability slots
├── personas/
│   ├── index.ts              # Persona set loader
│   ├── genesis.ts            # Flywheel persona set (Mara, Alex, Admin)
│   ├── ecosystem.ts          # Ecosystem persona set (Mara 2 courses, 3 students, Admin)
│   └── seed-full.ts          # Seed-dev persona set (10 actors: Guy, Gabriel, Admin, Brian, 7 students)
├── api/
│   └── plato-scenarios.api.test.ts  # Test file — runs all registered scenarios
├── browser/                  # Future: Playwright per-step tests
└── harvest/                  # Future: DB → SQL export
```

---

## Design Decisions

| Decision | Choice | Rationale |
|---|---|---|
| State mechanism | DB-accumulation (Model B) | Breaks fast and loudly — no carry state hiding integration gaps |
| Step ordering | Fixed, manually sequenced | Step N assumes Steps 1..(N-1) completed; order IS the dependency graph |
| Step structure | Page visits with actions | Models what users actually do: visit page, press button |
| System events | Phantom system page (`/__plato/system`) | Keeps "visit page, press button" metaphor universal for webhooks |
| Actor switching | Per-step actor declaration | Runner handles auth context; one actor per step |
| Multi-actor scenarios | Sequential visits by different actors | API chain doesn't require simultaneity |
| Same-page multi-action | Multiple actions within one visit | User stays on page; response data feeds next action |
| DB lifecycle | Fresh in-memory DB per test session | Deterministic, no cross-test contamination |
| Starting state | Core seed only (`seedCoreTestDB()`) | Matches production; proves day-one viability |
| Happy path only | Yes | Stumbles tested at unit/API layer (STUMBLE-AUDIT) |
| External services | Mock at service boundary | Tests all handler logic; only HTTP calls faked |
| Persona data | Actor-keyed, flat fields with section comments | Simple, copyable for new actors; no runtime conditionals |
| Field categories | DB-REQUIRED vs SITE-NECESSARY comments in persona | Steps prove minimum viability; enriched personas prove site completeness |
| Adding data | Add field to persona + reference in step body | No conditionals — if persona has it and step references it, it's sent; if not, it's not |
| Test layers | Layer-agnostic step definitions | Same definition drives API tests and future Playwright tests |
| Composition unit | Scenarios (not chains) | Independent, goal-driven; each has own persona set, chain, and DB verifications |
| Multi-course discovery | findBy in extractPath | Declarative array search with paren-aware dot splitting; no conditional logic in steps |
| Multi-student reuse | Actor bindings on chain entries | Same step, different personas; steps stay unchanged |
| Per-course steps | Separate atomic steps | One-time setup (self-certify-creator) vs per-entity (add-teacher-cert); no conditional logic |
| Scenario verification | DB assertions after all steps | Per-step verify is sanity gates; scenario verify proves the intended situation |

---

*Created: Conv 060. Revised Conv 061: adopted Model B (sequential DB-accumulation), page-action model, phantom system page. Model B refactor implemented Conv 061. Conv 063: scenario system, multi-course/multi-student support, atomic steps. Conv 064-065: seed-dev scenario with SqlTopUp enrichment. Conv 066: seed-topup completion, two-admin separation, timestamp backdating, 44 verify assertions. Conv 067: terminology rename (run→step, RunRef→StepRef, ChainStep→ChainEntry), taxonomy section added.*

See also: `docs/as-designed/plato-implementation-plan.md` (Conv 060 plan, superseded by Model B but retains useful technical patterns).
