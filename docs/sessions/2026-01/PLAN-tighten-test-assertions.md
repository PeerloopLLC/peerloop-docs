# Plan: Tighten Test Assertions Post-Seed-Exclusion

## Background

Session 135 modified `resetTestDB()` to exclude seed data from test databases. This means tests now have complete control over their data. However, many tests were written with loose assertions (`toBeGreaterThanOrEqual`) to accommodate unknown seed data pollution.

**Goal:** Review and tighten these assertions to exact values where appropriate.

---

## Priority 1: Tests with Explicit Seed Comments

These files have comments explicitly mentioning seed data compensation:

### 1. `tests/api/users/index.test.ts`
- **Line 348:** `expect(body.items.length).toBeGreaterThanOrEqual(2); // At least two creators in test + seed data`
- **Line 384:** `expect(body.items.length).toBeGreaterThanOrEqual(1); // At least one moderator in test + seed data`
- **Fix:** Change to `.toBe(N)` where N is the exact count created in `beforeAll`

### 2. `tests/api/admin/payouts/pending.test.ts`
- **Line 283:** Comment about seed data adding splits
- **Line 284:** `expect(body.total_pending).toBeGreaterThanOrEqual(8500);`
- **Line 290:** `expect(creatorRecipient.pending_balance).toBeGreaterThanOrEqual(1500);`
- **Line 298-299:** Comment about recipients from seed data
- **Fix:** Change to exact values based on test setup

### 3. `tests/api/admin/courses/index.test.ts`
- **Line 602:** Comment `// could include seed data`
- **Fix:** Remove comment, verify assertion is correct

---

## Priority 2: API Tests with Count Assertions

These tests assert counts that should now be exact:

### 4. `tests/api/debug/db-env.test.ts`
- **Line 89:** `expect(body.userCount).toBeGreaterThanOrEqual(2);`
- Test creates 2 users → should be `.toBe(2)`

### 5. `tests/api/db-test.test.ts`
- **Lines 96, 102, 109:** `toBeGreaterThanOrEqual(1)` for categories, users, features
- Test creates 1 of each → should be `.toBe(1)`

### 6. `tests/api/categories.test.ts`
- **Line 73:** `expect(body.categories.length).toBeGreaterThanOrEqual(3);`
- Check test setup for exact count

### 7. `tests/api/users/search.test.ts`
- **Lines 224, 239, 253:** Various `>= N` assertions
- Review each and tighten to exact counts

### 8. `tests/api/admin/categories/index.test.ts`
- **Line 207:** `expect(body.categories.length).toBeGreaterThanOrEqual(4);`

### 9. `tests/api/admin/moderation/index.test.ts`
- **Line 318:** `expect(body.total).toBeGreaterThanOrEqual(5);`

### 10. `tests/api/admin/dashboard.test.ts`
- **Lines 337, 353, 376, 384, 392, 400, 423, 431, 454, 462, 470, 493, 531, 588**
- Many stat assertions that should be exact

### 11. `tests/api/admin/sessions/index.test.ts`
- **Lines 336, 423:** `toBeGreaterThanOrEqual(5)`

### 12. `tests/api/admin/courses/index.test.ts`
- **Lines 313, 452, 465, 489, 652, 663:** Various count assertions

### 13. `tests/api/admin/users/index.test.ts`
- **Lines 475, 511, 559, 571, 741, 752:** Various count assertions

---

## Priority 3: Legitimate Uses (No Change Needed)

These `toBeGreaterThanOrEqual` uses are **correct** and should NOT be changed:

### Ordering Checks
- `tests/api/leaderboard.test.ts:167,198,228` - Score ordering (prev >= current)
- `tests/api/courses/index.test.ts:362,376` - Sort order verification
- `tests/api/admin/sessions/index.test.ts:587,603` - Sort order verification
- `tests/api/admin/certificates/index.test.ts:328` - Sort order
- `tests/api/admin/courses/index.test.ts:615` - Price ordering
- `tests/api/admin/users/index.test.ts:695` - Name ordering
- `tests/api/admin/categories/index.test.ts:219` - Display order

### Technical Checks
- `tests/api/health/db.test.ts:52` - `latency_ms >= 0` (timing)
- `tests/api/users/search.test.ts:336,337` - Index position >= 0

### UI Tests (Multiple Elements)
These check "at least one element rendered" which is valid for React testing:
- `tests/pages/**/*.test.tsx` - Most are checking UI elements exist
- `tests/components/**/*.test.tsx` - Same pattern

---

## Execution Order

1. **Priority 1** (explicit seed comments) - 3 files
2. **Priority 2** (API count assertions) - 10 files
3. Skip Priority 3 (legitimate uses)

---

## Review Process for Each File

1. Read the `beforeAll` setup to count exact data created
2. For each `toBeGreaterThanOrEqual(N)`:
   - If N matches exact setup count → change to `.toBe(N)`
   - If assertion is for ordering/sorting → leave as-is
   - If test adds data mid-test → verify final count and adjust
3. Remove any "seed data" comments
4. Run the individual test file to verify

---

## Command to Run

```bash
# Run all affected test files
npm test -- tests/api/users/index.test.ts tests/api/admin/payouts/pending.test.ts tests/api/admin/courses/index.test.ts tests/api/debug/db-env.test.ts tests/api/db-test.test.ts tests/api/categories.test.ts tests/api/users/search.test.ts tests/api/admin/categories/index.test.ts tests/api/admin/moderation/index.test.ts tests/api/admin/dashboard.test.ts tests/api/admin/sessions/index.test.ts tests/api/admin/users/index.test.ts
```

---

## Estimated Effort

| Priority | Files | Time |
|----------|-------|------|
| Priority 1 | 3 | 15 min |
| Priority 2 | 10 | 45 min |
| **Total** | 13 | ~1 hour |
