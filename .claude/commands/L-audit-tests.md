---
description: Audit whether a page's tests are sufficient for regression safety
argument-hint: "<PAGE_CODE> [PAGE_CODE2 PAGE_CODE3 ...]"
---

# Audit Test Sufficiency for Page

**Purpose:** Determine whether running `test-<CODE>.sh` will catch regressions when you start modifying a page. This is NOT about counting tests or reading JSON metadata — it's about reading the actual source code and every actual test file, then judging whether the tests verify what the code does.

## Arguments

- `$ARGUMENTS` — 1 to 5 page codes, space-separated (e.g., `CANA`, `CANA CDSH TDSH`)
- If no argument provided, ask the user which page(s) to audit.

---

## CRITICAL: Thoroughness Rules

**These rules exist because the default behavior is to cut corners. Follow them exactly.**

1. **READ EVERY FILE.** For each page, you will build a file inventory. You must `Read` every file in that inventory. No exceptions. No "the rest likely follow the same pattern." No reading 2 of 6 and extrapolating.

2. **CITE LINE NUMBERS.** Every claim about what a test does or doesn't cover must reference a specific file and line number (e.g., `CreatorAnalytics.test.tsx:295` tests error state). If you cannot cite a line number, you have not read the file.

3. **BANNED PHRASES.** Do not write any of these: "likely," "probably," "presumably," "similar pattern," "assume," "appears to," "should be." These indicate you have not verified. Replace them with facts from the code you read.

4. **PER-FILE READ CONFIRMATION.** After reading all files for a page, output a checklist showing every file, its line count, and a ✅. If any file shows ❌, stop and read it before continuing.

5. **NO METADATA SHORTCUTS.** Do not read the page JSON's `testCoverage` or `plannedApiCalls` fields. Those are documentation artifacts. Read the actual `.tsx` and `.test.ts` files.

6. **WORK FROM SOURCE → TEST, NOT TEST → SOURCE.** Start by understanding what the source component does (what it renders, what the user can do, what data it fetches). Then check whether each of those things has a test. Do not start from the test file and declare things covered.

---

## Execution Flow

### Phase 1: File Inventory (per page)

For each page code:

1. **Find the test script:**
   ```
   ../Peerloop/scripts/page-tests/test-<CODE>.sh
   ```
   Read it. Extract COMPONENT_TEST and API_TESTS paths.

2. **Find the source component:**
   - Read the test script header for the component path
   - OR search `../Peerloop/src/components/` and `../Peerloop/src/pages/` for the component
   - Read the FULL source component file

3. **Find ALL child components imported by the source:**
   - Look at every `import` at the top of the source component
   - For each imported component from `../Peerloop/src/components/`, note its path
   - You do NOT need to read child component source files unless the page is a thin orchestrator (like CANA) — in that case, note what each child is responsible for

4. **Build the file inventory:**
   ```
   FILES TO READ:
   □ Source: ../Peerloop/src/components/analytics/CreatorAnalytics.tsx
   □ Component test: ../Peerloop/tests/components/analytics/CreatorAnalytics.test.tsx
   □ API test 1: ../Peerloop/tests/api/me/creator-analytics/courses.test.ts
   □ API test 2: ../Peerloop/tests/api/me/creator-analytics/enrollments.test.ts
   □ API test 3: ../Peerloop/tests/api/me/creator-analytics/funnel.test.ts
   ... (every file)
   ```

5. **Read EVERY file in the inventory.** Use parallel Read calls where possible. Mark each ✅ after reading.

---

### Phase 2: Source Analysis

From the source component, extract:

**A. What the page renders (sections/areas):**
List every visual section the component renders. Look at the JSX return statement.

**B. What the user can do (interactions):**
List every interactive element:
- Buttons with `onClick`
- Form submissions
- Select/dropdown changes
- Links that trigger actions (not just navigation)
- Any `useCallback` or handler function

**C. What data the page fetches:**
List every `fetch()` call with:
- The exact URL pattern (from the source code, with line number)
- When it fires (mount, filter change, user action)
- What state it populates
- How errors are handled (try/catch, .catch(), error state, or silent)

**D. What states the component manages:**
List every `useState` and what drives state transitions.

---

### Phase 3: Test-by-Test Verification

For EACH item found in Phase 2, check whether a test exists:

**A. Rendering coverage:**
For each section/area the component renders, find the specific `it()` block that verifies it renders. Cite the test file and line number. If no test exists, mark it ❌.

**B. Interaction coverage:**
For each user interaction (button click, dropdown change, form submit), find the specific `it()` block that simulates the interaction and verifies the result. Cite file:line. If no test, mark ❌.

**C. Fetch coverage:**
For each `fetch()` call in the source:
- Is there a component-level test that verifies the fetch is called with the right URL? (file:line)
- Is there an API-level test file that tests the actual endpoint handler? (file:line)
- Does the API test cover: 401 unauth? 403 forbidden? 200 success with response shape? Query params? 503 db error?
- For each of these, cite the specific `it()` block or mark ❌.

**D. Error handling coverage:**
For each error path in the source (`.catch()`, error state render, fallback UI):
- Is there a test that triggers this error path? (file:line)
- If the source silently catches errors (e.g., `console.error`), note that the error path is untestable at UI level.

**E. State transition coverage:**
For key state changes (loading → loaded, loaded → error, filter change → refetch):
- Is there a test that verifies the transition? (file:line)

---

### Phase 4: Verdict

Present the complete assessment:

```
══════════════════════════════════════════════════════════════
  TEST AUDIT: <CODE> — <Page Name>
══════════════════════════════════════════════════════════════

FILES READ:
  ✅ ../Peerloop/src/components/.../Component.tsx (345 lines)
  ✅ ../Peerloop/tests/components/.../Component.test.tsx (699 lines, 30 tests)
  ✅ ../Peerloop/tests/api/.../endpoint1.test.ts (209 lines, 9 tests)
  ✅ ../Peerloop/tests/api/.../endpoint2.test.ts (136 lines, 5 tests)
  ... (every file)

──────────────────────────────────────────────────────────────
WHAT THE PAGE DOES → WHAT THE TESTS VERIFY
──────────────────────────────────────────────────────────────

RENDERING:
  ✅ Page header with title/description — Component.test.tsx:202
  ✅ MetricsRow with summary data — Component.test.tsx:534
  ❌ CoursePerformanceTable column rendering — no test for individual columns
  ...

INTERACTIONS:
  ✅ Period selector changes refetch — Component.test.tsx:361
  ❌ Course table sort click — no test simulates column header click
  ...

FETCH CALLS:
  Source: fetch('/api/me/creator-analytics?...') — Component.tsx:153
    ✅ Component verifies URL called — Component.test.tsx:258
    ❌ No API test file for index route
  Source: fetch('/api/me/creator-analytics/courses?...') — Component.tsx:175
    ✅ Component verifies URL called — Component.test.tsx:260
    ✅ API test: 401 — courses.test.ts:94
    ✅ API test: 403 — courses.test.ts:108
    ✅ API test: 200 shape — courses.test.ts:122
    ✅ API test: params — courses.test.ts:152
    ✅ API test: 503 — courses.test.ts:201
  ...

ERROR HANDLING:
  ✅ Summary fetch error shows UI + retry — Component.test.tsx:295
  ❌ Enrollments fetch error — silently caught (Component.tsx:170), no test
  ...

──────────────────────────────────────────────────────────────
REGRESSION SAFETY VERDICT
──────────────────────────────────────────────────────────────

Will test-<CODE>.sh catch regressions if you modify:

  The orchestrator component:  YES / PARTIAL / NO
  A child component:           YES / PARTIAL / NO
  An API endpoint handler:     YES / PARTIAL / NO
  The database schema:         YES / PARTIAL / NO

SPECIFIC BLIND SPOTS:
  1. [Exact description of what change would NOT be caught]
  2. [Another blind spot]
  ...

OVERALL: ✅ Safe to modify / ⚠️ Add tests first / ❌ Insufficient
```

---

### Phase 5: Multi-page summary (if >1 page)

If auditing multiple pages, end with a comparison table:

```
AUDIT SUMMARY
═══════════════════════════════════════════════
Code  | Tests | Rendering | Interactions | APIs | Verdict
──────┼───────┼───────────┼──────────────┼──────┼────────
CANA  |    70 | 6/7       | 4/5          | 6/7  | ⚠️ Partial
CDSH  |    37 | 8/8       | 3/3          | 1/1  | ✅ Safe
```

---

### Phase 6: Save Report

For each page audited, save the full verdict as a markdown file:

**Location:** `docs/pages/<CODE>/AUDIT-<CODE>.md`

**Format:**
```markdown
# Test Audit: <CODE> — <Page Name>

> **Date:** YYYY-MM-DD HH:MM
> **Verdict:** ✅ Safe to modify / ⚠️ Add tests first / ❌ Insufficient
> **Files read:** N files, N lines, N test assertions

[Full Phase 4 output goes here — everything from FILES READ through OVERALL verdict]

---

## Recommended Actions

[See Recommended Actions section below for what to include here]
```

**After saving, tell the user:**
```
Report saved: docs/pages/<CODE>/AUDIT-<CODE>.md

To address the findings, run:
  /L-strengthen-tests <CODE>
```

---

### Recommended Actions (included in saved report)

At the end of the report, generate a prioritized action list. Each action must be one of these types:

**Type 1: CREATE — Missing test file**
```
[ ] CREATE ../Peerloop/tests/api/me/creator-analytics/index.test.ts
    Reason: No API test for GET /api/me/creator-analytics (summary endpoint)
    Tests needed: 401, 403, 200 + response shape (9 metric fields), period param, courseId param, 503
```

**Type 2: ADD — Missing assertions in existing test**
```
[ ] ADD to enrollments.test.ts: courseId parameter test
    Reason: Component sends courseId (source :164) but API test has no courseId case
    Model after: funnel.test.ts:137-143

[ ] ADD to enrollments.test.ts: item field validation
    Reason: Only checks Array.isArray(body.data). Does not verify items have date, enrollments, revenue fields
    Model after: courses.test.ts:133-144
```

**Type 3: ADD — Missing interaction test in component test**
```
[ ] ADD to CreatorAnalytics.test.tsx: sort column click interaction
    Reason: handleCourseSort (source :235) passed to CoursePerformanceTable but never triggered by test
    Needs: simulate column header click, verify fetch called with new sort/order params
```

**Type 4: ADD — Missing error/state test in component test**
```
[ ] ADD to CreatorAnalytics.test.tsx: partial fetch failure (non-summary endpoint)
    Reason: 6 of 7 fetches silently console.error (source :170, :181, :192, :203, :214, :225). No test verifies page remains functional when one sub-fetch fails.
```

**Type 5: FIX — Source code issue found during audit**
```
[ ] FIX ../Peerloop/src/components/analytics/CreatorAnalytics.tsx:242-248: missing .catch() on sort re-fetch
    Reason: useEffect fetch has .finally() but no .catch(). Unhandled promise rejection if sort fetch fails.
```

**Type 6: CREATE — Missing child component test (optional, note as lower priority)**
```
[ ] CREATE ../Peerloop/tests/components/analytics/CoursePerformanceTable.test.tsx (lower priority)
    Reason: Orchestrator test only checks one text node. Column-level rendering regressions in this child will not be caught.
```

**Prioritization order:**
1. FIX — source code bugs found during audit (ship-blocking)
2. CREATE — missing API test files (endpoint has zero coverage)
3. ADD — missing assertions in existing tests (easy wins)
4. ADD — missing interaction/error tests in component test
5. CREATE — missing child component tests (lower priority, larger effort)

---

## Notes

- This skill is READ-ONLY. It does not create or modify test files. It only reads and reports.
- For each page, expect to read 4-12 files. Do not rush this. The whole point is thoroughness.
- If a page has no test script, report that immediately and skip to recommendations.
- If the source component imports child components that handle significant logic (not just display), note them as blind spots — the orchestrator test won't catch regressions inside children.
- The user's goal: know whether they can safely start modifying a page with confidence that `test-<CODE>.sh` will alert them to breakage.
- After the report is saved, suggest running `/L-strengthen-tests <CODE>` to implement the recommended actions.
