# PLATO — Platform Action Test Orchestrator

**Purpose:** Test that users can accomplish their goals through the platform by executing realistic sequences of page visits and actions against a real database, where the accumulated DB state IS the system truth.

**Status:** ✅ Scenarios + Instances operational — 4 scenarios, 1 instance file, 20 steps, 48 SqlTopUp steps, all passing (Conv 069)

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
| **Instance** | Scenario bound to a specific persona set + execution mode — the unit you actually run | `tests/plato/instances/*.instance.ts` |

Steps are templates — they reference `$persona.email` without knowing whose email. Scenarios compose steps into sequences. Persona sets provide the data. Instances bind scenarios to persona sets with an execution mode (`test`, `seed`, `walkthrough`, `repro`).

**Instance files** group multiple `PlatoInstance` entries that execute sequentially against the same DB (accumulation model). Each instance can override step params and use `when` guards on StepRef entries for conditional step execution. Instance files can also include `WalkthroughCheckpoint` entries for STUMBLE-AUDIT browser pairing — structured browser verification points that pair API proof (PLATO) with UX proof (manual walkthrough).

### Execution Modes

PLATO has two execution modes. A **run** is one execution of an instance, always qualified by mode:

| Mode | Shorthand | What Happens |
|------|-----------|--------------|
| **API mode** | "API-run [instance]" | Execute the instance's automated API chain against the DB — proves the data path works |
| **Browser mode** | "Browser-run [instance]" | Walk the same instance's `WalkthroughCheckpoint` entries in Chrome — proves the UX path works |

The typical workflow is API first, then browser. An API-run proves data flows correctly through the API layer. A browser-run proves that a real user navigating the same journey encounters no UX issues — confusing labels, dead-end flows, validation mismatches, missing feedback. Issues found during browser-runs are fixed in place, then the walkthrough restarts from the top until clean.

Both modes operate on the same instance, same persona data, same user journey — one automated, one visual.

#### Snapshot Bridge (API → Browser)

API-run uses in-memory `better-sqlite3` — data doesn't reach local D1. To bridge: instances with `snapshot: true` auto-save the in-memory DB via `rawDb.serialize()` to `tests/plato/snapshots/<name>.db` after a successful API-run. The restore script copies this into wrangler's local D1 SQLite file, so the dev server immediately serves the exact state the API-run produced.

```bash
npm run plato:restore -- flywheel-to-enrollment   # API-run + restore (~400ms)
npm run plato:snapshot:restore -- flywheel-to-enrollment  # restore only
```

Snapshots are always regenerated (no caching) — API-run is fast enough (~400ms) that staleness management isn't worth the complexity. Snapshots are gitignored.

**Split point selection:** The split point between API-run and browser-run should put mocked external services on the API side. The `flywheel-to-enrollment` snapshot absorbs Stripe (mocked in API-run, baked into snapshot). BBB stays on the browser-run side — only the webhook trigger is needed, not the video room.

**STUMBLE-AUDIT** is a PLAN.md project block (not a system) that tracks the effort to systematically browser-run every instance and fix what's found. See GLOSSARY.md § Testing & Quality (PLATO) for all term definitions.

### Segments: Composability + Restartability (Conv 072 Design)

**Status:** Designed, not yet implemented.

Segments solve two problems simultaneously:

1. **Composability** — reuse the same group of steps across multiple scenarios without duplication
2. **Restartability** — when a step fails mid-scenario, restore to a clean pre-failure state and re-run without replaying the entire chain

#### What Is a Segment?

A segment is a named group of 2-3 steps that represents a meaningful operation. Unlike a scenario, a segment is a **convenience for composition** — it groups steps that frequently travel together. Unlike a bare step, a segment has a goal that describes the operation's outcome.

| Concept | Has a goal? | Has data? | Composable? | Example |
|---------|:-----------:|:---------:|:-----------:|---------|
| Step | No — just mechanics | No | Atomic — not composed further | `register-creator` |
| **Segment** | **Yes — operation outcome** | **No — passes through** | **Yes — reused across scenarios** | `setup-creator` (register + grant) |
| Scenario | Yes — proves a situation | No | Chains segments/steps | `flywheel` |
| Instance | Yes (inherited) | Yes — persona data | No — this is the execution unit | `flywheel-genesis` |

#### Flywheel as Segments

Today (flat, 12 steps):
```
register-creator → grant-creator → create-community → create-course →
add-modules → publish-course → register-student → self-certify-creator →
enroll-student → complete-course → certify-teacher
```

With segments:
```
[setup-creator]     → [create-offering]                → [onboard-student]        → [complete-learning] → [teacher-convert]
 register-creator      create-community                   register-student           complete-course       certify-teacher
 grant-creator         create-course, add-modules         self-certify-creator
                       publish-course                     enroll-student
```

The scenario definition becomes:
```typescript
scenario: {
  name: 'flywheel',
  chain: [
    { segment: 'setup-creator' },
    { segment: 'create-offering' },
    { segment: 'onboard-student' },
    { segment: 'complete-learning' },
    { segment: 'teacher-convert' },
  ]
}
```

#### Composability: Reusing Segments Across Scenarios

The same segment can appear in multiple scenarios with different actor bindings:

```typescript
// Multi-student scenario — same segments, different compositions
scenario: {
  name: 'multi-student',
  chain: [
    { segment: 'setup-creator' },
    { segment: 'create-offering' },
    { segment: 'onboard-student' },                                        // alex (default)
    { segment: 'onboard-student', actorBindings: { student: 'sam' } },     // sam
    { segment: 'onboard-student', actorBindings: { student: 'jordan' } },  // jordan
  ]
}
```

`setup-creator` and `create-offering` are defined once, shared by flywheel, multi-student, and any future scenario that needs a published course.

#### Restartability: DB Snapshots at Boundaries

The runner takes a SQLite file snapshot **before each segment** (or before each step — see "Snapshot Granularity" below). When a segment fails:

1. Runner reports: "segment `onboard-student` failed at step `enroll-student`"
2. Developer fixes the bug
3. Developer re-runs with `--from-segment=onboard-student` (or `--from-step=enroll-student`)
4. Runner restores the pre-segment snapshot (clean state before the failure)
5. Execution continues from that point onward

```
Scenario: flywheel

  snapshot 0 (empty + seed)
  ┌───────────────────────┐
  │ segment: setup-creator │
  └───────────────────────┘
  snapshot 1
  ┌─────────────────────────┐
  │ segment: create-offering │
  └─────────────────────────┘
  snapshot 2
  ┌──────────────────────────┐
  │ segment: onboard-student  │  ← fails at enroll-student
  └──────────────────────────┘

  Fix the bug. Restore snapshot 2. Re-run from onboard-student.
```

**Why snapshots solve the partial-write problem:** A step like `enroll-student` may perform multiple DB operations (create enrollment, increment student_count, follow Stream feed). If it fails partway through, the DB is in an inconsistent state — you can't just re-run the step because earlier writes would conflict. Restoring the pre-segment snapshot gives you a completely clean state before the failed segment. Since segments are small (2-3 steps), replaying from the segment start is cheap.

**Snapshot mechanics (local D1):**
```typescript
// Before each segment boundary:
const snapshotPath = `/tmp/plato-snapshots/${scenarioName}-${segmentIndex}.sqlite`;
fs.copyFileSync(dbPath, snapshotPath);
```

For local D1, this is a simple file copy — the SQLite DB is typically kilobytes to low megabytes, so each snapshot takes sub-millisecond. This is local-only; remote/staging D1 does not support file-level snapshots.

#### Snapshot Granularity: Per-Segment vs Per-Step

Two options, not yet decided:

| Approach | Snapshots per flywheel | Restart granularity | Meaningful restart points? |
|----------|:----------------------:|---------------------|:--------------------------:|
| Per-segment | 5 | Segment boundary | Yes — every snapshot is a meaningful state |
| Per-step | 11 | Any step | Mixed — some mid-segment states are odd |

**Per-step** gives finer restartability (useful for debugging) at negligible performance cost. **Per-segment** only creates snapshots at semantically meaningful boundaries. Both are viable — the decision can be made during implementation based on which proves more useful in practice.

#### Context Flow

Segments are **transparent** — the runner flattens them into steps before execution. Context (`$context.*`) flows through segments exactly as it does through bare steps today. A `$context.createCourse.courseId` set inside segment 2 is visible to steps inside segment 3. No input/output contracts between segments are needed.

The only runtime effect of a segment boundary is the snapshot.

#### Flow Context Pattern (Node-RED inspiration)

Node-RED's `msg` object is a useful model for how context should travel through a PLATO chain. In Node-RED, a single `msg` object passes from node to node. Each node:

1. **Reads** any property it needs (without ceremony — no imports, no contracts)
2. **Passes through** properties it doesn't touch (they survive untouched to downstream nodes)
3. **Tacks on** new properties representing the node's output (results of its operations)
4. **Optionally reads/writes** a reserved `msg.state` property that represents the flow's accumulated state — any node can consult it

This maps naturally to PLATO's context:

| Node-RED `msg` | PLATO equivalent | Status |
|----------------|-----------------|--------|
| `msg.propertyName` | `$context.stepName.key` | **Exists today** — steps provide values via `provides`, downstream steps read them |
| Pass-through (untouched props survive) | Context accumulation | **Exists today** — all prior steps' context is visible to later steps |
| `msg.state` (reserved flow-wide state) | Not yet implemented | **Consideration** — a `$flow.state` object that any step can read/write |

The current `$context` is already close to Node-RED's `msg` — each step's `provides` block tacks on new properties, and downstream steps read them. The key difference is that PLATO's context is **namespaced by step** (`$context.createCourse.courseId`), while Node-RED's `msg` is flat (`msg.courseId`). Namespacing prevents accidental collisions when the same step runs multiple times with different actor bindings.

**Potential addition: `$flow.state`** — a single reserved context property (containing an object) that represents the accumulated state of the flow. Unlike `$context.stepName.*` which is scoped per-step, `$flow.state` would be a shared bag that any step or segment can consult or update.

In Node-RED, `msg` serves as both **data plane** and **control plane** — nodes read it not just for data but for *intent*: should I execute? what mode am I in? what's already been done? Each node is self-aware and decides its own behavior based on `msg` state. This enables rewiring flows, bypassing nodes, and partial re-execution — all without the orchestrator needing special logic.

Applied to PLATO, `$flow.state` would carry three kinds of information:

**1. Data accumulation** (what's been produced):
- A step that needs to know "how many students have been enrolled so far" without knowing which specific step enrolled them
- A segment that needs to communicate results to a later segment without coupling to specific step names

**2. Control directives** (what should happen):
- Skip directives: "segment `create-offering` already completed, skip it"
- Mode flags: "this is a restart from segment 3, verify-only for prior segments"
- Bypass signals: "Stripe is unavailable, skip enrollment and use SQL seed instead"

**3. Completion tracking** (what's been done):
```typescript
// $flow.state after restoring snapshot 2 and restarting:
{
  completedSegments: ['setup-creator', 'create-offering'],
  mode: 'restart',
  restorePoint: 'onboard-student'
}
```

Each segment inspects `$flow.state.completedSegments` — if already listed, skip (or verify-only). If not, execute and mark complete. The runner doesn't need special restart logic; the segments are self-aware.

This mirrors Node-RED's strength: every node knows what to expect and how complete the flow is, enabling rewiring and partial execution without changing the orchestrator. The flow state is the contract, not the runner's execution plan.

This is a **future consideration**, not a requirement for the initial segment implementation. The current `$context` mechanism is sufficient for the flywheel and existing scenarios. `$flow.state` becomes valuable when scenarios grow complex enough that steps need to react to accumulated state rather than specific prior step outputs, or when restart/bypass behavior needs to be driven by the flow itself rather than by runner flags.

#### Segment-Level Verify (Optional)

Segments can optionally include a `verify` block — DB assertions that confirm the segment deposited its expected data:

```typescript
segment: {
  name: 'create-offering',
  goal: 'Published course with modules',
  steps: [...],
  verify: [
    { description: 'Course is published', query: 'SELECT is_active FROM courses WHERE title = ?', ... },
  ]
}
```

This serves dual purpose:
- **During normal run:** confirms the segment's steps succeeded before moving on
- **During `--from-segment`:** prior segments' verify blocks run (without executing their steps) to confirm the DB is in the expected pre-segment state

#### Type Changes

One new type and one new `ChainEntry` variant:

```typescript
// New: segment definition
interface PlatoSegment {
  name: string;
  goal: string;
  steps: ChainEntry[];           // same StepRef/SqlTopUpRef as today
  verify?: DBVerification[];     // optional post-segment assertions
}

// New: reference to a segment within a scenario chain
interface SegmentRef {
  segment: string;                            // resolved from registry
  label?: string;                             // display label when same segment appears multiple times
  actorBindings?: Record<string, string>;     // cascaded to all steps in the segment
  runtimeOverrides?: Record<string, unknown>; // cascaded to all steps
}

// Extended: ChainEntry gains SegmentRef
type ChainEntry = StepRef | SqlTopUpRef | SegmentRef;
```

Steps, scenarios, instances, and persona sets are **unchanged**.

#### Runner Changes

Two additions to `PlatoRunner`:

1. **Segment resolution** — when the runner encounters a `SegmentRef`, it looks up the segment from a registry and inlines its steps (applying actor bindings and runtime overrides). This happens before execution, same as how scenarios resolve step names today.

2. **Snapshot management** — before executing each segment (or step), the runner copies the SQLite file. A `--from-segment` (or `--from-step`) flag restores the appropriate snapshot before resuming execution.

#### External Service Boundary Alignment

Segments naturally align with external service dependencies:

| Segment | External Service | Always browser-walkable? |
|---------|-----------------|:------------------------:|
| `setup-creator` | None | Yes |
| `create-offering` | None | Yes |
| `onboard-student` | Stripe (enrollment) | Needs Stripe CLI |
| `complete-learning` | BBB (video sessions) | Needs DEV-WEBHOOKS |
| `teacher-convert` | None | Yes |

Segments before a service boundary are always walkable. This means a STUMBLE can progress through `setup-creator` + `create-offering` on any machine, regardless of which external services are configured.

#### Candidate Segments (from existing steps)

| Segment | Steps | Goal |
|---------|-------|------|
| `setup-creator` | register-creator, grant-creator-role | Creator registered with permissions |
| `create-offering` | create-community, create-course, add-modules, publish-course | Published course with modules |
| `onboard-student` | register-student, self-certify-creator, enroll-student | Student registered and enrolled |
| `complete-learning` | complete-course | Student completes all sessions |
| `teacher-convert` | certify-teacher | Student certified as teacher |

Additional segments for future scenarios:
| Segment | Steps | Goal |
|---------|-------|------|
| `register-member` | register-student (or register-creator without grant) | New user registered |
| `book-session` | book-complete-session | Single session booked and completed |
| `social-activity` | send-message, follow-user | Social interactions established |

#### Validation Proof

The design is validated when:
1. Two different scenarios share the same segment (e.g., `setup-creator`)
2. Both scenarios are instantiated with persona data
3. Both instances pass their verify blocks
4. The segment is defined exactly once

This proves composability works end-to-end: segment → scenario → instance → pass.

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
| 20 | `complete-onboarding` | Any | `/onboarding` | `POST /api/me/onboarding-profile` | Onboarding profile + tag associations |

*Grant-creator uses the phantom system page because there's no dedicated admin page for this action in the current UI — it's an API call the admin makes. If an admin UI page is built later, update the route.

### Scenarios

Scenarios compose steps into independent, goal-driven test cases. Each scenario has its own persona set, chain of entries, and optional DB verifications.

| Scenario | Category | Persona Set | Steps | Verifications | What It Proves |
|----------|----------|-------------|:-----:|:-------------:|----------------|
| `flywheel` | test | genesis | 11 | 0 (per-step only) | Full learn-teach-earn cycle (steps 1-8, 10-12) |
| `ecosystem` | test | ecosystem | 18 | 7 | Multi-course (2), multi-student (3), actor bindings, findBy discovery |
| `activities` | test | ecosystem | 7 | 0 (per-step only) | Atomic steps: book-complete-session, cancel-session, send-message, follow-user, create-homework, submit-homework, set-availability |
| `seed-dev` | seed | seed-full | 53 API + 48 SqlTopUp | 44 | Full dev database replacing SQL seed. 10 actors, 6 courses, 2 communities, enrichment data across 30+ tables |

### Instance Files

Instance files group multiple `PlatoInstance` entries that execute sequentially against the same DB. Each instance binds a scenario (or inline scenario) to a persona set with optional `when` guards for conditional steps.

| Instance File | Instances | Persona Sets | What It Proves |
|---------------|:---------:|--------------|----------------|
| `new-user-pair` | 2 (Alice, Bob) | new-user-alice, new-user-bob | Registration + conditional onboarding coexist; `when` guards skip/include complete-onboarding per persona |

Key instance infrastructure:
- **`when` guards** — predicate on StepRef receives `instanceParams`, returns boolean for conditional step execution
- **`executeInstanceFile()`** — swaps persona data per-instance, delegates to `executeScenario()`
- **`applyStepOverrides()`** — merges instance-level overrides into step params
- **WalkthroughCheckpoint** — structured browser verification points for STUMBLE-AUDIT pairing

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
├── PLATO-REGISTRY.md         # Manifest: all scenarios, instances, personas with descriptions
├── route-map.generated.ts    # Auto-generated route→API map (from npm run route-api-map)
├── lib/
│   ├── types.ts              # PlatoStep, PlatoScenario, StepRef, SqlTopUpRef, ChainEntry, BrowserIntent, etc.
│   ├── api-runner.ts         # PlatoRunner — executeScenario(), findBy, actor bindings
│   ├── reporter.ts           # Console progress reporter (step + scenario levels)
│   ├── mock-registry.ts      # Service mock factories
│   └── navigation-helper.ts  # BrowserIntent navigation rules (same-page-first/navbar-fallback)
├── scenarios/
│   ├── index.ts              # Scenario registry and loader
│   ├── flywheel.scenario.ts  # Genesis flywheel (12 steps, including submit-expectations)
│   ├── flywheel-pre-9.scenario.ts    # Enrollment-ready checkpoint (first 9 flywheel steps)
│   ├── flywheel-to-enrollment.scenario.ts  # Diagnostic: flywheel through enrollment
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
│   ├── submit-expectations.step.ts    # Post-enrollment expectations form (Conv 078)
│   ├── set-availability.step.ts       # Creator sets 3 availability slots
│   └── complete-onboarding.step.ts    # Complete onboarding profile
├── personas/
│   ├── index.ts              # Persona set loader
│   ├── genesis.ts            # Flywheel persona set (Mara, Alex, Admin)
│   ├── ecosystem.ts          # Ecosystem persona set (Mara 2 courses, 3 students, Admin)
│   ├── seed-full.ts          # Seed-dev persona set (10 actors: Guy, Gabriel, Admin, Brian, 7 students)
│   ├── new-user-alice.ts     # Alice persona (skip onboarding)
│   └── new-user-bob.ts       # Bob persona (with onboarding goal + tags)
├── instances/
│   ├── index.ts              # Instance file loader
│   ├── new-user-pair.instance.ts     # Two-user registration with conditional onboarding + walkthrough checkpoints
│   ├── flywheel.instance.ts          # Full flywheel with snapshot (Conv 071)
│   ├── flywheel-pre-9.instance.ts    # Enrollment-ready checkpoint with snapshot (Conv 078)
│   ├── ecosystem.instance.ts         # Multi-course ecosystem with BrowserIntents (Conv 075)
│   ├── activities.instance.ts        # Atomic activity steps with BrowserIntents (Conv 075)
│   └── seed-dev.instance.ts          # Full dev seed with snapshot + plato:seed scripts (Conv 083)
├── api/
│   └── plato-scenarios.api.test.ts  # Test file — runs all registered scenarios + instance files
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
| Instance parameterization | `when` guards on StepRef | Minimal mechanism for conditional steps — predicate receives instanceParams, returns boolean |
| Multi-instance execution | Sequential against same DB (accumulation) | Proves coexistence — Alice's data persists when Bob runs; mirrors real multi-user system |
| STUMBLE pairing | WalkthroughCheckpoint in instance files | Instance file is natural home for "what to check in browser"; pairs API proof with UX proof |
| Segment composability | Named step groups with transparent context | Reuse across scenarios without duplication; context flows through unmodified |
| Restartability | DB snapshots at segment (or step) boundaries | Restore pre-failure state, re-run without replaying entire chain; solves partial-write problem |
| Segment scope | 2-3 steps per segment, with goal | Small enough to replay cheaply, large enough to be a meaningful operation |

---

*Created: Conv 060. Revised Conv 061: adopted Model B (sequential DB-accumulation), page-action model, phantom system page. Model B refactor implemented Conv 061. Conv 063: scenario system, multi-course/multi-student support, atomic steps. Conv 064-065: seed-dev scenario with SqlTopUp enrichment. Conv 066: seed-topup completion, two-admin separation, timestamp backdating, 44 verify assertions. Conv 067: terminology rename (run→step, RunRef→StepRef, ChainStep→ChainEntry), taxonomy section added. Conv 069: instance system implemented — PlatoInstance/PlatoInstanceFile types, `when` guards on StepRef, executeInstanceFile(), WalkthroughCheckpoint for STUMBLE-AUDIT pairing, complete-onboarding step (20th), new-user-pair instance file. Conv 072: full segment design — composability (reusable step groups across scenarios) + restartability (DB snapshots at segment boundaries), type system additions (PlatoSegment, SegmentRef), snapshot granularity analysis, candidate segment catalog.*

See also:
- `docs/as-designed/plato-implementation-plan.md` (Conv 060 plan, superseded by Model B but retains useful technical patterns)
- `docs/as-designed/stumble-workflow.md` (Conv 077: fix-and-verify workflow using Pre/Post segment split with DB snapshots)
