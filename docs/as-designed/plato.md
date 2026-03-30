# PLATO — Platform Action Test Orchestrator

**Purpose:** Test that users can accomplish their goals through the platform by executing realistic sequences of API calls against a real database, with composable segments that mirror the platform's capability graph.

**Status:** Phase 2 complete, design evolving (Conv 060)

---

## Problem

Peerloop's test suite has strong unit and API endpoint coverage, but a fundamental gap: **seed data proves the app can display data, not that it can create data.**

- Unit tests (`tests/lib/`) use hand-crafted DB inserts
- API tests (`tests/api/`) insert prerequisite data via SQL, then test one endpoint
- Integration tests (`tests/integration/`) insert data for 2-3 coupled operations
- E2E tests (`e2e/`) navigate pre-seeded pages; only 2 of 33 specs create data through the UI

No test layer validates that the *output* of one feature is valid *input* for the next. A user who registers, enrolls, books a session, completes it, and gets certified passes through ~6 API endpoints whose data must be mutually compatible. Today, each endpoint is tested in isolation with "perfect" hand-inserted data.

---

## Design

### Evolution Note

The design evolved significantly during Conv 060 through discussion. The original model used monolithic "runs" (long sequences covering an entire user journey). The revised model uses **composable segments** organized in a **dependency graph**. Phase 2 was built with the original run model; subsequent phases will refactor toward segments.

### Core Concept: Segments

A PLATO **segment** is the smallest user-goal-achieving action. Each segment declares three things:

1. **Intent** — what the user wants to accomplish ("create a course")
2. **Surface** — where they do it (the route/page: `/creating/courses/new`)
3. **Mechanism** — the API call(s) that achieve it (`POST /api/me/courses`)

```typescript
interface PlatoSegment {
  name: string;             // 'create-course'
  goal: string;             // "Creator creates a course"
  actor: ActorName;         // who performs this segment
  route: string;            // where the action happens: '/creating/courses/new'
  requires: string[];       // prerequisite segment names
  steps: PlatoStep[];       // the API calls for THIS segment only
  verify: DBVerification[]; // verify THIS segment's outcome
}
```

**Segments are happy-path only.** Error cases (bad input, validation failures, user stumbles) are tested at the unit/API layer (see STUMBLE-AUDIT). PLATO answers: "Can a user accomplish this goal?" — not "What happens when they make a mistake?"

### Dependency Graph

Every user goal has prerequisites. These form a dependency tree:

```
                    register
                   /        \
          grant-creator    browse-courses
              |                |
       create-community     enroll ←── needs publish-course (cross-branch)
              |                |
        create-course     book-session
              |                |
       publish-course    complete-session
                               |
                           certify
                               |
                        become-teacher
```

Each node is a segment. Segments declare their prerequisites via `requires`. The runner resolves the dependency graph, topologically sorts, and executes from root to the requested goal.

### Leaf-Driven Design

**Start from the leaf, traverse back to root.** The leaf defines the goal. The traversal defines the run.

When you say "run `become-teacher`", the runner resolves:

```
become-teacher → certify → complete-session → book-session → enroll
    → publish-course → create-course → create-community → grant-creator
    → register-creator
enroll also → register-student
```

Topological sort produces the execution order. Shared ancestors (e.g., `register`) execute once.

**Any node can be a leaf.** Running `create-community` executes only: `register-creator` → `grant-creator` → `create-community`. Running `become-teacher` executes the full flywheel.

### Common Ancestor Reuse

If multiple goals share prerequisites, each prerequisite segment executes once. The carry state is reused by all downstream segments that need it.

### Segment Instantiation and Data

A segment is a **template**. Executing it requires **persona data** — the specific names, emails, course titles, etc. A `PersonaSet` provides this data for all actors across all segments.

The same segment template can be instantiated multiple times with different personas (e.g., "Mara creates her AI course" and "David creates his automation course"). Each instantiation produces its own carry state.

### Routes and Browser Testing

The segment declares the **route** where the action happens, but NOT how the user navigates there. A user might reach `/creating/courses/new` from:
- The creator dashboard
- A community page
- A direct link

The segment doesn't care. Navigation path testing is a separate concern.

**Two test layers per segment:**

| Layer | What It Proves |
|---|---|
| **API test** | Server handles the call sequence correctly for this segment |
| **Browser test** | The declared route has UI elements that trigger the correct API call(s) |
| **Together** | A user can accomplish this goal through the platform |

The browser test verifies:
1. The route exists and is accessible to the actor
2. The page has the form/button for the action
3. Submitting triggers the correct API call (verified via network interception)

### Response Contracts

Each step declares a **response contract** — the shape of the API response. Both test layers use it:

- **API test:** Validates the actual response matches the shape
- **Browser test:** Uses a fixture generated from the shape as a mock response

### DB Verification

Each segment ends with verification queries that confirm the DB state matches expectations. Carry values from the segment's steps can be interpolated into verification queries via `$carry.stepName.key`.

---

## Harvest: Seed Data Generation

After a full leaf-to-root run completes, the in-memory database contains data created entirely through API calls. The **harvest step** exports this as a SQL seed file.

- All data was created through the app's own API — validated by construction
- Core seed rows (topics, tags, admin) are skipped (already in `0002_seed_core.sql`)
- Different persona sets produce different seed files (variety)
- Replaces hand-written `migrations-dev/0001_seed_dev.sql` over time

---

## Testing Arsenal

| Layer | Question | Path Type | Scope |
|---|---|---|---|
| **Unit tests** | Does this function handle edge cases? | Error, boundary | Single function |
| **API tests** | Does this endpoint reject bad input, enforce auth, handle stumbles? | Error, validation | Single endpoint |
| **Integration tests** | Do these components interact correctly? | State transitions | 2-3 coupled operations |
| **PLATO API** | Can the server handle this user goal's API sequence? | **Happy path** | Segment (composable) |
| **PLATO Browser** | Does the UI at this route trigger the correct API calls? | **Happy path** | Segment (per route) |
| **E2E tests** | Do multi-user real-browser flows work? | Critical paths | Cross-user, full stack |

---

## Segment Catalog

### Platform Capability Segments

| Segment | Actor | Route | Prerequisites | API Calls |
|---|---|---|---|---|
| `register-creator` | Visitor | `/signup` | — | `POST /api/auth/register` |
| `register-student` | Visitor | `/signup` | — | `POST /api/auth/register` |
| `grant-creator` | Admin | `/admin/users/[id]` | `register-creator` | `PATCH /api/admin/users/[id]` |
| `create-community` | Creator | TBD | `grant-creator` | `POST /api/me/communities` |
| `create-course` | Creator | `/creating/courses/new` | `create-community` | `POST /api/me/courses`, `PUT /api/me/courses/[id]`, `PUT .../thumbnail` |
| `add-modules` | Creator | `/creating/courses/[id]/curriculum` | `create-course` | `POST /api/me/courses/[id]/curriculum` (×N) |
| `publish-course` | Creator | `/creating/courses/[id]` | `add-modules` | `PUT /api/me/courses/[id]/publish` |
| `enroll` | Student | `/course/[slug]` | `register-student`, `publish-course` | `POST /api/checkout/create-session`, `POST /api/webhooks/stripe` |
| `book-session` | Student | TBD | `enroll` | `POST /api/sessions` |
| `complete-session` | Teacher + Student | TBD | `book-session` | `POST /api/sessions/[id]/complete` |
| `certify` | Creator | TBD | `complete-session` (×all) | TBD |
| `become-teacher` | Graduate | TBD | `certify` | TBD |
| `join-community` | Member | `/community/[slug]` | `register-student` | `POST /api/communities/[slug]/join` |
| `create-post` | Member | `/feed/[slug]` | `join-community` | `POST /api/feeds/community/[slug]` |

Routes marked TBD need verification against actual UI.

---

## External Service Boundaries

| Service | PLATO Approach |
|---|---|
| **Stripe** | Mock at `@/lib/stripe`; fire synthetic webhook with correct metadata |
| **Stream.io** | Mock at `@/lib/stream`; verify D1 feed_activities written correctly |
| **BigBlueButton** | Mock at `@/lib/video`; fire synthetic webhooks |
| **Resend (email)** | Mock at `resend`; verify called with correct data |

All handler logic, validation, DB writes, and state transitions run for real. Only external HTTP calls are faked.

---

## Implementation Status

### Phase 1: Foundation ✅ (Conv 060)

- `tests/plato/lib/types.ts` — type definitions
- `tests/plato/lib/api-runner.ts` — `PlatoRunner` class
- `tests/plato/lib/reporter.ts` — console progress output
- `tests/plato/lib/mock-registry.ts` — service mock factories
- `tests/helpers/test-db.ts` — added `seedCoreTestDB()` (core seed only)

### Phase 2: First Run ✅ (Conv 060)

Built as a monolithic run (pre-segment-model). 10 API steps, all passing:

```
register → admin grants access → create community → create course →
update details → set thumbnail → add module ×3 → publish
```

**Findings:**
- **Bug found:** `community_members.joined_via` CHECK constraint missing `'registration'` — fixed
- **Design gap surfaced:** thumbnail requires separate endpoint (`PUT .../thumbnail`), not part of course update
- **API verified:** `POST /api/me/communities` creates community + default progression atomically

Files: `runs/creator-publishes-course.run.ts`, `personas/genesis.ts`, `api/plato-chain.api.test.ts`

### Next: Segment Refactor

The Phase 2 monolithic run needs refactoring into composable segments with dependency declarations. The runner needs dependency resolution (topological sort). This is the focus of the next conv.

---

## Current File Structure

```
tests/plato/
├── lib/
│   ├── types.ts              # Type definitions (needs segment types)
│   ├── api-runner.ts         # PlatoRunner (needs dependency resolver)
│   ├── reporter.ts           # Console progress reporter
│   └── mock-registry.ts      # Service mock factories
├── runs/
│   ├── index.ts              # Run loader
│   ├── _chain.ts             # Chain ordering (pre-segment model)
│   └── creator-publishes-course.run.ts  # Phase 2 monolithic run
├── personas/
│   ├── index.ts              # Persona set loader
│   └── genesis.ts            # "Mara Chen" creator persona
├── api/
│   └── plato-chain.api.test.ts  # Test file with mock wiring
├── browser/                  # Future: Playwright per-segment tests
└── harvest/                  # Future: DB → SQL export
```

---

## Design Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Unit of composition | Segment (atomic goal) | Composable, independently testable, maps to user goals |
| Dependency resolution | Topological sort of declared prerequisites | Automatic execution ordering, common ancestor reuse |
| Run assembly | Leaf-to-root traversal | Start from the goal, discover all prerequisites by necessity |
| DB strategy | In-memory (better-sqlite3) | Fast, clean; harvest exports when needed |
| Happy path only | Yes | Stumbles tested at unit/API layer (STUMBLE-AUDIT) |
| Starting state | Core seed only | Matches production; proves day-one viability |
| External services | Mock at service boundary | Tests all handler logic; only HTTP calls faked |
| Segment surface | Route declaration (not navigation path) | Segments don't care how user arrived, only where the action happens |
| Browser testing | Verify route has UI that triggers correct API | Navigation is a separate concern |
| Data parameterization | Persona sets (same segment, different data) | Segments are templates; personas instantiate them |
| Response sharing | Contracts (shapes, not literal values) | API carries real IDs, browser carries fixture IDs |

---

*Created: Conv 060. Revised during Conv 060 discussion (segment model, dependency graph, route declarations).*
