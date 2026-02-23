# Session Learnings - 2026-02-23

## 1. Vitest 4.x Uses Positional Filters, Not --testPathPattern
**Topics:** testing

**Context:** Tried running targeted tests with `npm test -- --testPathPattern="communities.*moderators"` (Jest syntax) and got `CACError: Unknown option`.

**Learning:** Vitest 4.x uses positional args for file filtering: `npx vitest run "moderators/index"`. The `--testPathPattern` flag doesn't exist. Use `-t` / `--testNamePattern` for filtering by test name, and positional args for file path matching.

**Pattern:**
```bash
# File path filter (positional arg)
npx vitest run "moderators/index"
npx vitest run "me/full"

# Test name filter
npx vitest run -t "returns 401 when not authenticated"
```

---

## 2. Reactivation Pattern for UNIQUE-Constrained Soft-Delete Tables
**Topics:** d1, auth

**Context:** `community_moderators` has `UNIQUE(community_id, user_id)`. When a moderator is revoked (soft-delete via `is_active=0`), re-appointing them can't INSERT a new row — it violates the unique constraint.

**Learning:** For tables with UNIQUE constraints and soft-delete, the endpoint must check for existing inactive rows and UPDATE to reactivate rather than INSERT. This is a three-way check: active (409 conflict), inactive (UPDATE to reactivate), none (INSERT new).

**Pattern:**
```typescript
const existing = await queryFirst(db,
  'SELECT id, is_active FROM community_moderators WHERE community_id = ? AND user_id = ?',
  [communityId, userId]
);
if (existing?.is_active === 1) return 409; // already active
if (existing) { /* UPDATE to reactivate */ }
else { /* INSERT new row */ }
```

---

## 3. Community-to-Course Scope Resolution via Progression Chain
**Topics:** d1, auth

**Context:** Community moderators need authority over all courses in their community, but courses don't have a direct `community_id` column. The chain is: community → progressions → courses.

**Learning:** The existing progression chain (`community_moderators → progressions → courses`) provides scope resolution without any schema denormalization. A single JOIN query pre-computes the set of course IDs a community moderator can moderate, and this set is included in the `/api/me/full` response for O(1) client-side lookups.

**Pattern:**
```sql
SELECT DISTINCT c.id as course_id
FROM community_moderators cm
JOIN progressions p ON p.community_id = cm.community_id
JOIN courses c ON c.progression_id = p.id
WHERE cm.user_id = ? AND cm.is_active = 1
  AND p.is_active = 1 AND p.deleted_at IS NULL
  AND c.is_active = 1 AND c.deleted_at IS NULL
```

---

## 4. Backward-Compatible MeFullResponse Extension
**Topics:** auth, astro

**Context:** Adding `communityModerations` and `communityModeratedCourseIds` to `MeFullResponse` could break existing cached data in localStorage (stale-while-revalidate pattern).

**Learning:** When extending `MeFullResponse` with new array fields, the `CurrentUser` constructor must use `?? []` fallback. This ensures cached localStorage data from before the API update doesn't cause undefined errors when the new fields are missing. The pattern is: add fields to the response type, add `?? []` in the constructor, and the next API refresh will populate them.

**Pattern:**
```typescript
// In CurrentUser constructor
this.communityModerations = new Map(
  (data.communityModerations ?? []).map((m) => [m.communityId, m])
);
```
