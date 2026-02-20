---
description: Analyze page test coverage and create test script
argument-hint: "<PAGE_CODE>"
---

# Test Plan for Page

**Purpose:** Analyze a page's test coverage, create an action plan for gaps, and generate a reusable test script.

---

## Input

Page code from PAGES-MAP.md (e.g., `CANA`, `STUD`, `CBRO`)

---

## Execution Flow

### Phase 1: Discovery

1. **Find page in PAGES-MAP.md**
   - Extract route, block, status
   - If not found, error and stop

2. **Find route file**
   - Location: `../Peerloop/src/pages/<route>.astro`
   - Extract downstream component (look for `client:load` or `client:idle`)

3. **Find component**
   - Parse the import to get component path
   - Read component file

4. **Find component test**
   - Search `../Peerloop/tests/components/` and `../Peerloop/tests/pages/` for matching test file
   - Count tests (`grep -c "it("`)

5. **Find API calls in component**
   - Search for `fetch(` patterns
   - Extract `/api/*` endpoints
   - Note query parameters used

6. **For each API endpoint found:**
   - Find corresponding test file in `../Peerloop/tests/api/`
   - Count tests
   - Quick-scan for coverage (auth tests, param tests, error tests)

7. **Check for existing test script**
   - Look for `../Peerloop/scripts/page-tests/test-<PAGE>.sh`
   - Note if exists (will be overwritten)

---

### Phase 2: Report & Plan

Present findings to user:

```
=== Test Plan: <PAGE_CODE> - <Page Name> ===

Route: <route>
Component: <ComponentName>.tsx
Component Test: <path> (<N> tests) ✅/❌

API Calls Found:
  1. GET /api/xxx - <test file> (<N> tests) ✅/⚠️/❌
  2. GET /api/yyy - <test file> (<N> tests) ✅/⚠️/❌
  ...

Existing Script: ../Peerloop/scripts/page-tests/test-<PAGE>.sh [EXISTS/NEW]

=== Gaps Found ===

<List specific gaps, e.g.:>
- /api/me/creator-analytics/courses: Missing auth tests (401, 403)
- /api/me/creator-analytics/courses: Missing sort/order parameter tests
- Component test: None found ❌

=== Action Plan ===

<TodoWrite items to fix gaps>
```

**Then ask user to confirm** before proceeding to Phase 3.

---

### Phase 3: Execute Plan

After user confirms:

1. **Create TodoWrite items** for each gap to address
2. **Work through each item:**
   - For missing tests: Create or enhance test files
   - Mark items complete as done
3. **Generate test script** (see format below)
4. **Confirm completion**

---

## Test Script Format

Save to: `../Peerloop/scripts/page-tests/test-<PAGE>.sh`

```bash
#!/bin/bash
# =============================================================================
# Test Script: <PAGE_CODE> - <Page Name>
# Route: <route>
# Generated: <date>
# =============================================================================
#
# Component: <ComponentName>.tsx
# Component Test: <path>
#
# API Endpoints:
#   - <endpoint 1>
#   - <endpoint 2>
#   ...
#
# Usage:
#   ./../Peerloop/scripts/page-tests/test-<PAGE>.sh          # Run all tests
#   ./../Peerloop/scripts/page-tests/test-<PAGE>.sh --quick  # Component test only
#
# =============================================================================

set -e

PAGE="<PAGE_CODE>"
COMPONENT_TEST="<component_test_path>"
API_TESTS="<space-separated API test paths>"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  Testing: $PAGE - <Page Name>                                  "
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Quick mode - component test only
if [[ "$1" == "--quick" ]]; then
  echo "▶ Component Test (quick mode):"
  cd ../Peerloop && npm test -- --run "$COMPONENT_TEST"
  exit 0
fi

# Full test suite
echo "▶ Component Test:"
cd ../Peerloop && npm test -- --run "$COMPONENT_TEST"

echo ""
echo "▶ API Tests:"
cd ../Peerloop && npm test -- --run $API_TESTS

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ All $PAGE tests complete"
echo "════════════════════════════════════════════════════════════════"
```

Make executable: `chmod +x ../Peerloop/scripts/page-tests/test-<PAGE>.sh`

---

## Coverage Assessment Criteria

### Component Test
- ✅ Good: 20+ tests with multiple describe blocks
- ⚠️ Thin: 5-19 tests
- ❌ Missing: No test file found

### API Test (per endpoint)
- ✅ Good: 8+ tests covering auth, params, errors
- ⚠️ Thin: 1-7 tests (likely just happy path)
- ❌ Missing: No test file found

### Gaps to Check For
- Missing 401 unauthenticated test
- Missing 403 unauthorized test
- Missing parameter tests (for each param component sends)
- Missing 503 database unavailable test
- Missing empty state test

---

## Example Session

```
User: /L-test-plan CANA

Claude:
=== Test Plan: CANA - Creator Analytics ===

Route: /dashboard/creator/analytics
Component: CreatorAnalytics.tsx
Component Test: ../Peerloop/tests/components/analytics/CreatorAnalytics.test.tsx (30 tests) ✅

API Calls Found:
  1. GET /api/me/creator-analytics - creator-analytics.test.ts (5 tests) ⚠️
  2. GET /api/me/creator-analytics/courses - courses.test.ts (1 test) ❌
  3. GET /api/me/creator-analytics/enrollments - enrollments.test.ts (4 tests) ⚠️
  ...

Existing Script: ../Peerloop/scripts/page-tests/test-CANA.sh [NEW]

=== Gaps Found ===
- courses.test.ts: Only 1 test, missing auth/param/error tests
- Most API tests missing sort, order, period, courseId parameter coverage

=== Action Plan ===
1. Enhance courses.test.ts with auth, param, error tests
2. Add parameter tests to other shallow API test files
3. Generate test script

Proceed with this plan? [Confirm to continue]

User: yes

Claude: [Creates TodoWrite items, works through them, generates script]

Created: ../Peerloop/scripts/page-tests/test-CANA.sh
  chmod +x applied

Run with: ./../Peerloop/scripts/page-tests/test-CANA.sh
```

---

## Notes

- This skill pauses for confirmation after presenting the plan
- If no gaps found, skip to script generation
- Script is always generated/overwritten
- For SSR-only pages (no API calls), script just runs component test
