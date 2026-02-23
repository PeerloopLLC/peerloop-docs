# Session Learnings - 2026-02-23

## 1. D1 Enrollments Table Uses `student_id`, Not `user_id`
**Topics:** d1, testing

**Context:** While implementing the community archive guard (checking for active enrollments), the test failed with `SqliteError: table enrollments has no column named user_id`.

**Learning:** The `enrollments` table uses `student_id` (not `user_id`) as the FK to `users`. This aligns with the domain model — the enrollee is specifically a student, not a generic user. Always verify column names against the schema before writing queries that reference enrollment data.

**Pattern:** `enrollments.student_id` references `users(id)`. Status values are `'enrolled'`, `'in_progress'`, `'completed'`, `'cancelled'`, `'disputed'` — there is no `'active'` status. Use `status IN ('enrolled', 'in_progress')` to find active enrollments.

---

## 2. D1 `batch()` Via Lib Helper for Atomic Multi-Table Inserts
**Topics:** d1, astro

**Context:** Community creation requires atomically inserting 3 rows: the community, the creator membership, and the default progression. Using three separate `db.prepare().run()` calls risks partial creation if one fails.

**Learning:** The `batch()` helper in `@lib/db` wraps `db.batch()` with a cleaner API — pass an array of `{ sql, params }` objects. In the test DB wrapper, batch runs all statements in a better-sqlite3 transaction for true atomicity. In production D1, `batch()` runs atomically per Cloudflare's guarantees.

**Pattern:**
```typescript
await batch(db, [
  { sql: 'INSERT INTO communities ...', params: [...] },
  { sql: 'INSERT INTO community_members ...', params: [...] },
  { sql: 'INSERT INTO progressions ...', params: [...] },
]);
```

---

## 3. Stream Mock Pattern: Mock the Entire Module for Non-Fatal Calls
**Topics:** stream, testing

**Context:** Community creation follows the Stream feed on creation (non-fatal, matching the join.ts pattern). Tests need to avoid real Stream API calls.

**Learning:** For endpoints where Stream calls are non-fatal (wrapped in try/catch), mock the entire `@/lib/stream` module to return a stub chain: `getStreamClient → feed → follow`. This avoids test failures from missing Stream credentials while still exercising the code path.

**Pattern:**
```typescript
vi.mock('@/lib/stream', () => ({
  getStreamClient: () => ({
    feed: () => ({
      follow: vi.fn().mockResolvedValue(undefined),
    }),
  }),
}));
```

---

## 4. Dynamic UPDATE Builder Pattern is Well-Established in Codebase
**Topics:** astro, d1

**Context:** Both community PATCH and progression PATCH needed dynamic field updates (only update fields present in the request body).

**Learning:** The codebase has a consistent pattern for dynamic UPDATEs: build `updates[]` and `values[]` arrays, always include `updated_at = datetime('now')`, check if `updates.length === 1` (only the auto-added timestamp = no real changes → 400), then construct the SQL with `updates.join(', ')`. This pattern originated in `me/courses/[id]/index.ts` and was replicated across all CRUD endpoints.

---

## 5. Reorder Endpoints Require Exact ID Match Validation
**Topics:** astro, d1

**Context:** The progressions reorder endpoint accepts an `order` array of progression IDs and updates `display_order`.

**Learning:** The curriculum reorder pattern (`courses/[id]/curriculum/reorder.ts`) validates that the order array contains **exactly** the same IDs as existing records — no extras, no missing. This bidirectional check prevents partial reorders or invalid IDs. The progressions reorder replicates this, but scopes to non-archived progressions only (archived ones aren't reorderable).
