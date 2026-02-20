---
description: Implement test improvements from an L-audit-tests report
argument-hint: "<PAGE_CODE>"
---

# Strengthen Tests for Page

**Purpose:** Read the audit report from `/L-audit-tests` and implement its recommended actions — creating missing test files, adding missing assertions, fixing source code issues, and strengthening test coverage to achieve regression safety.

## Arguments

- `$ARGUMENTS` — A single page code (e.g., `CANA`)
- If no argument provided, ask the user which page to strengthen.

---

## Prerequisites

This skill requires an existing audit report at:
```
docs/pages/<CODE>/AUDIT-<CODE>.md
```

If no audit report exists, tell the user:
```
No audit report found at docs/pages/<CODE>/AUDIT-<CODE>.md

Run the audit first:
  /L-audit-tests <CODE>
```

---

## CRITICAL: Quality Rules

1. **READ THE AUDIT REPORT FIRST.** Extract every `[ ]` action item. These are your work items.

2. **READ EVERY FILE YOU WILL MODIFY** before modifying it. Understand the existing patterns, imports, helpers, and mock setup. New tests must match the style of the existing file.

3. **READ MODEL FILES.** When the audit says "Model after: funnel.test.ts:137-143", read that file and use its pattern. Do not invent a different style.

4. **RUN TESTS AFTER EACH FILE CHANGE.** After creating or modifying a test file, run it immediately with `cd ../Peerloop && npm test -- --run <file>`. Fix failures before moving to the next action item.

5. **DO NOT OVER-ENGINEER.** Add exactly what the audit recommends. Do not add tests the audit didn't request. Do not refactor existing tests.

---

## Execution Flow

### Phase 1: Load Audit Report

1. Read `docs/pages/<CODE>/AUDIT-<CODE>.md`
2. Extract the Recommended Actions section
3. Parse each `[ ]` action into a work list
4. Present the work list to the user:

```
Audit report loaded: docs/pages/<CODE>/AUDIT-<CODE>.md
Verdict: ⚠️ Add tests first

Work items (N total):
  Priority 1 — FIX:
    1. [description]
  Priority 2 — CREATE:
    2. [description]
  Priority 3 — ADD:
    3. [description]
    4. [description]
  Priority 4 — ADD (interaction/error):
    5. [description]
  Priority 5 — CREATE (child components):
    6. [description] (lower priority)

Proceed with all items? Or specify which to implement (e.g., "1-4" or "FIX and CREATE only").
```

Wait for user confirmation before proceeding.

---

### Phase 2: Execute — FIX items (Priority 1)

For each FIX action:

1. Read the source file at the cited location
2. Understand the bug (missing .catch, wrong error handling, etc.)
3. Fix it with minimal change
4. Run relevant tests to verify no regression

---

### Phase 3: Execute — CREATE missing test files (Priority 2)

For each CREATE action:

1. **Read the API handler being tested:**
   - Find the handler file (e.g., `../Peerloop/src/pages/api/me/creator-analytics/index.ts`)
   - Read it completely to understand what it does, what params it accepts, what it returns

2. **Read an existing sibling test as a model:**
   - The audit report names the model file
   - Copy its structure: imports, mock setup, `describeWithTestDB` wrapper, `beforeAll` seed data, `beforeEach` reset, section organization

3. **Create the test file** with these sections (in order):
   ```
   Authentication (401)
   Authorization (403)
   Success Cases (200 + response shape + field validation)
   Query Parameters (each param the handler accepts)
   Error Handling (503 database unavailable)
   ```

4. **Run the new test file:**
   ```bash
   cd ../Peerloop && npm test -- --run <new-test-file>
   ```

5. **Fix any failures** before proceeding.

---

### Phase 4: Execute — ADD to existing test files (Priority 3)

For each ADD action:

1. **Read the target test file** completely
2. **Read the model** cited in the audit (if any)
3. **Add the new test(s)** in the appropriate `describe` block:
   - Missing param test → add to `Query Parameters` describe
   - Missing field validation → add to `Success Cases` describe
   - Missing interaction → add to the relevant section in component test
   - Missing error/state test → add to `Error States` or new describe block

4. **Run the modified test file:**
   ```bash
   cd ../Peerloop && npm test -- --run <modified-test-file>
   ```

5. **Fix any failures.**

---

### Phase 5: Execute — ADD interaction/error tests (Priority 4)

For component test additions:

1. **Read the component test** completely (you need to understand mock setup)
2. **Read the source component** at the cited lines (the interaction/error being tested)
3. **Add tests** following the existing patterns in the file:
   - Use `userEvent` for interactions (not `fireEvent`) if the file already uses it
   - Use `waitFor` for async assertions
   - Use existing `setupMockResponses` helper if available
   - Match the existing section numbering and comment style

4. **Run and verify.**

---

### Phase 6: Execute — CREATE child component tests (Priority 5, optional)

Only do these if the user confirmed them. These are larger:

1. **Read the child component source** completely
2. **Check if it has its own props interface** — this defines what to test
3. **Create a standalone test** that:
   - Renders the component with mock props (based on what the parent passes)
   - Verifies all visible elements (column headers, data cells, chart elements)
   - Tests interaction callbacks (if the component has onSort, onClick, etc.)
   - Tests empty state, loading state, error state (if the component handles these)

4. **Run and verify.**

---

### Phase 7: Update and Verify

After all items are done:

1. **Run the full test script:**
   ```bash
   ./../Peerloop/scripts/page-tests/test-<CODE>.sh
   ```
   All tests must pass.

2. **Update the test script** (`../Peerloop/scripts/page-tests/test-<CODE>.sh`) if new test files were created:
   - Update the `API_TESTS` variable to include new paths
   - Update the header comment's API Endpoints list

3. **Update the audit report** (`docs/pages/<CODE>/AUDIT-<CODE>.md`):
   - Check off completed `[ ]` items → `[x]`
   - Add a "Strengthening Completed" section at the bottom:
   ```markdown
   ---
   ## Strengthening Completed

   **Date:** YYYY-MM-DD HH:MM
   **Items completed:** N/N

   Files created:
   - ../Peerloop/tests/api/.../index.test.ts (N tests)

   Files modified:
   - ../Peerloop/tests/api/.../enrollments.test.ts (+2 tests)
   - ../Peerloop/tests/components/.../Component.test.tsx (+3 tests)

   Source fixes:
   - ../Peerloop/src/components/.../Component.tsx:242 — added .catch()

   Test script updated: ../Peerloop/scripts/page-tests/test-<CODE>.sh
   ```

4. **Present summary to user:**
   ```
   ✅ Strengthening complete for <CODE>

   Created: N new test files (N tests)
   Modified: N existing files (+N tests)
   Fixed: N source code issues

   All tests passing: ./../Peerloop/scripts/page-tests/test-<CODE>.sh ✅

   Report updated: docs/pages/<CODE>/AUDIT-<CODE>.md

   Recommendation: Re-run /L-audit-tests <CODE> to verify
   the verdict has improved.
   ```

---

## Notes

- Always work through priorities in order (FIX → CREATE → ADD → ADD → CREATE child).
- Stop and ask the user if any test failure is ambiguous (could be a real bug vs. test issue).
- Match the coding style of existing test files exactly — same import patterns, same mock helpers, same assertion style.
- Do not modify the source component unless the audit specifically calls for a FIX.
- Keep the audit report as the source of truth — check items off as completed.
