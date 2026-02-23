# Session Learnings - 2026-02-22

## 1. CourseCard Renders Title Twice — Breaks getByText in Tests
**Topics:** testing, astro

**Context:** Writing component tests for `RecommendedCourses.tsx`, which renders `CourseCard` with `variant="compact"`. Tests used `screen.getByText('JavaScript 101')` to verify rendering.

**Learning:** `CourseCard` renders the title in two places: once in the thumbnail placeholder (`<span>` fallback when no thumbnail URL) and once in the `<a>` stretched link. When thumbnail_url is null (common in tests), both are visible in the DOM, causing `getByText` to throw "Found multiple elements." Use `getAllByText(...).length > 0` instead.

**Pattern:**
```typescript
// Wrong — throws when CourseCard has no thumbnail
expect(screen.getByText('JavaScript 101')).toBeInTheDocument();

// Correct — handles CourseCard's dual title rendering
expect(screen.getAllByText('JavaScript 101').length).toBeGreaterThan(0);
```

---

## 2. Courses Schema Has Strict NOT NULL Constraints on description and duration
**Topics:** d1, testing

**Context:** Writing test data INSERTs for recommendation API tests. Initial INSERTs only included the columns visible in the API response (title, tagline, price_cents, etc.).

**Learning:** The `courses` table has `description TEXT NOT NULL` and `duration TEXT NOT NULL` constraints that aren't obvious from the API surface. Test INSERTs must always include these columns even when testing features that don't use them. The `category_id` is also `NOT NULL REFERENCES categories(id) ON DELETE RESTRICT` (not SET NULL as in the explore agent's summary).

---

## 3. Enrollment Status Values Are Domain-Specific
**Topics:** d1, testing

**Context:** Test data used `status: 'active'` for enrollments, which seemed natural for an active enrollment.

**Learning:** The enrollments CHECK constraint uses domain-specific values: `'enrolled', 'in_progress', 'completed', 'cancelled', 'disputed'`. There is no `'active'` or `'pending'` status. The initial state is `'enrolled'` (with DEFAULT), not `'active'`. Always check CHECK constraints in the schema before writing test data.

---

## 4. SQLite MIN() in Correlated Subqueries for Score Capping
**Topics:** d1

**Context:** The recommendation scoring algorithm needs to cap tag overlap at 5 matches (to prevent courses with many tags from dominating). Used `MIN(COUNT(*), 5) * 4` inside a correlated subquery.

**Learning:** SQLite supports `MIN()` wrapping `COUNT()` directly in a correlated subquery: `(SELECT MIN(COUNT(*), 5) * 4 FROM course_tags ct JOIN user_tags ut ON ct.tag = ut.tag WHERE ct.course_id = c.id)`. This is more concise than a CTE or CASE expression for capping aggregate values. The two-argument `MIN(a, b)` form (scalar, not aggregate) returns the smaller of its arguments.
