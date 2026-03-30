# PLATO Implementation Plan

**Source:** Conv 060 Plan Mode + post-plan discussion
**Ephemeral plan:** `.claude/plans/tranquil-yawning-blanket.md`
**Design doc:** `docs/as-designed/plato.md`

---

## Context

Peerloop's test suite validates individual endpoints with hand-inserted data, but never validates that the *output* of one feature is valid *input* for the next. PLATO fills this gap by executing realistic sequences of API calls against a real database.

**The design evolved through three stages during Conv 060:**

1. **Initial:** Monolithic runs (long sequences covering entire journeys, chained linearly)
2. **Phase 2 implementation:** Built and validated the first run — proved the concept works, found a real bug
3. **Post-implementation discussion:** Evolved to composable segments with dependency graphs, leaf-driven design, and route declarations

---

## Architecture (Current — Post-Discussion)

### Composable Segments

A **segment** is the smallest goal-achieving user action. It declares:

- **Intent** — what the user wants ("create a course")
- **Surface** — the route where it happens (`/creating/courses/new`)
- **Mechanism** — the API call(s) (`POST /api/me/courses`)
- **Prerequisites** — other segments that must run first (`requires: ['create-community']`)

### Dependency Graph

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

### Leaf-Driven Design

Start from the **leaf goal** (the most dependent), traverse back to root. The traversal IS the run.

Running `become-teacher` resolves the full dependency tree, topologically sorts, and executes all segments from root to leaf. Running `create-community` executes only its branch.

### Common Ancestor Reuse

Segments execute once per run. If `enroll` and `community-participation` both need `register-student`, it runs once and the carry state is shared.

### Segment Three-Layer Testing

| Layer | What It Proves |
|---|---|
| **API test** | Server handles the API sequence correctly |
| **Browser test** | The declared route has UI that triggers the correct API calls |
| **Together** | A user can accomplish this goal through the platform |

Browser tests verify the route, NOT the navigation path. How the user reaches the page is a separate concern.

---

## What Phase 2 Proved

The first run (`creator-publishes-course`) executed 10 API steps through real endpoint handlers:

```
register → admin grants access → create community → create course →
update details → set thumbnail → add module ×3 → publish
```

### Findings

1. **Real bug:** `community_members.joined_via` CHECK constraint missing `'registration'` — fixed
2. **Design gap:** thumbnail requires separate endpoint (`PUT .../thumbnail`), not part of course update
3. **API verification:** `POST /api/me/communities` creates community + default progression atomically
4. **Vitest pattern:** Both `@/lib/auth` and `@lib/auth` must be mocked (separate aliases, same module); `requireRole` must be mocked directly (ESM internal call limitation)

### Technical Patterns Established

- **Handler import resolution:** URL paths with real values → file-system paths with `[param]` brackets
- **Auth mocking:** `vi.hoisted()` for shared mock state across dual aliases; mock `requireRole` not just `getSession`
- **Service mocks:** Registry pattern — `vi.mock()` declared once at file top, runner reconfigures per step
- **Carry state:** Named map (`{ courseId: 'course.id' }`) not arrays; `$carry.stepName.key` interpolation

---

## Next Steps (Conv 061+)

### Segment Refactor

1. Add `PlatoSegment` type — `name`, `goal`, `actor`, `route`, `requires[]`, `steps`, `verify`
2. Add dependency resolver — topological sort of segment graph
3. Split the Phase 2 monolithic run into 5-6 segments
4. Update runner to accept leaf segment name, resolve deps, execute in order
5. Common ancestor reuse — execute once, share carry state

### Remaining Flywheel Segments

After refactor, build segments for: `register-student`, `enroll`, `book-session`, `complete-session`, `certify`, `become-teacher`.

Test the full flywheel by running `become-teacher` as the leaf.

### Browser Layer

Per-segment Playwright tests that verify:
- Route exists and is accessible to the actor
- Page has form/button for the action
- Submitting triggers the declared API call (network interception)

### Key Open Questions

1. **Persona data per segment instance:** How do two executions of `register` (creator vs student) get different persona data? Segment instantiation model needs design.
2. **Routes for all segments:** Several segments have TBD routes — need UI verification.
3. **Multiple routes per action:** Some actions are reachable from multiple pages. Primary route declared in segment; alternates tested separately?

---

## Critical Files

| File | Role | Status |
|------|------|--------|
| `tests/plato/lib/types.ts` | Type definitions | ✅ Built (needs `PlatoSegment` addition) |
| `tests/plato/lib/api-runner.ts` | `PlatoRunner` class | ✅ Built (needs dependency resolver) |
| `tests/plato/lib/reporter.ts` | Console reporter | ✅ Built |
| `tests/plato/lib/mock-registry.ts` | Service mock factories | ✅ Built |
| `tests/helpers/test-db.ts` | Added `seedCoreTestDB()` | ✅ Modified |
| `tests/plato/runs/creator-publishes-course.run.ts` | First run (monolithic) | ✅ Built (needs segment split) |
| `tests/plato/personas/genesis.ts` | Mara Chen persona | ✅ Built |
| `tests/plato/api/plato-chain.api.test.ts` | Test file + mock wiring | ✅ Built |
| `tests/api/helpers/api-test-helper.ts` | Foundation helpers | Unchanged |
| `migrations/0001_schema.sql` | `joined_via` constraint fix | ✅ Fixed |
| `package.json` | Added `test:plato` script | ✅ Modified |

---

## Verification

- `npm run test:plato` — 1 test, 1 passed (202ms)
- `npm test` — 365 files, 6357 tests, all passed (no regressions)

---

*Persisted: Conv 060*
