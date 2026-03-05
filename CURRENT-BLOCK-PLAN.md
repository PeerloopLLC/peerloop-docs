# CURRENT-BLOCK-PLAN: BOOKING-MODULES

**Focus:** Positional module assignment for session booking
**Started:** Session 331
**Status:** IN PROGRESS — backend complete, UI pending

---

## Design Summary

Modules are NOT stored on sessions at booking time. Instead, module assignment is **computed positionally** from the chronological order of booked sessions against the course curriculum.

### Core Rule

> Sort an enrollment's non-cancelled sessions by `scheduled_start ASC`. The Nth session in that order teaches the Nth module (by `module_order`). Completed sessions have their `module_id` frozen; scheduled sessions reflow dynamically.

### Why Positional (Not Stored)

If a student cancels a session, the remaining sessions shift which module they cover — automatically maintaining sequential module order. Storing `module_id` at booking time would go stale on every cancellation or rebooking.

### Completion Freezes Module Assignment

When a session transitions to `completed` (via BBB webhook), the computed `module_id` is written to the session row. This is a **historical record** — it never changes after that point.

Constraint: Sessions must be completed in chronological order. Session N cannot complete before Session N-1. This means there are never gaps in completed sessions, so the reflow algorithm only needs to handle `scheduled` sessions after the last completed one.

---

## Algorithm: Resolve Module Assignments

Given an `enrollment_id`:

```
1. Fetch completed sessions for this enrollment, ordered by scheduled_start ASC
   - These have module_id set (frozen)
   - Count them: completedCount = C

2. Fetch scheduled sessions for this enrollment, ordered by scheduled_start ASC
   - These have module_id = NULL

3. Fetch course curriculum for the enrollment's course, ordered by module_order ASC
   - Total modules = N

4. Skip the first C modules (already taught in completed sessions)

5. Assign remaining modules to scheduled sessions in order:
   - scheduled[0] -> module[C+1]
   - scheduled[1] -> module[C+2]
   - ...etc

6. Sessions bookable = N - C - scheduledCount
   (modules not yet assigned to any session)
```

### Helper Function

Create `resolveModuleAssignments(db, enrollmentId)` in `src/lib/booking.ts`:

**Returns:**
```typescript
interface SessionWithModule {
  session_id: string;
  scheduled_start: string;
  status: string;
  module_id: string;        // curriculum ID
  module_title: string;
  module_order: number;
  session_number: number;   // from curriculum
  is_frozen: boolean;       // true if completed (stored), false if computed
}
```

This function is the single source of truth for "which module does this session cover?" Used by:
- Booking wizard (show next available module)
- Session detail page (show module info to teacher/student)
- Teacher dashboard (upcoming sessions with module context)
- Learn page (which modules have sessions booked/completed)
- Booking API (enforce session limit)

---

## Schema Change

### `sessions` table — add `module_id`

```sql
ALTER TABLE sessions ADD COLUMN module_id TEXT REFERENCES course_curriculum(id);
```

- **Nullable** — NULL for `scheduled` sessions (computed at read time)
- **Set on completion** — BBB webhook writes computed `module_id` when status -> `completed`
- **Historical** — once set, never changes

### Seed data update

Update `migrations-dev/0001_seed_dev.sql`:
- Existing completed sessions get `module_id` set to the correct curriculum entry
- Existing scheduled sessions keep `module_id` NULL

---

## Scope: Minimal Path (This Block)

### 1. Schema change
- [x] Add `module_id` column to `sessions` in `0001_schema.sql`
- [x] Update seed data — completed sessions get `module_id`, scheduled stay NULL

### 2. Helper function: `resolveModuleAssignments()`
- [x] Create `src/lib/booking.ts`
- [x] Implement the positional algorithm (steps 1-6 above)
- [x] Export helper for use across API and UI

### 3. Booking API changes (`POST /api/sessions`)
- [x] Enforce session limit: reject 422 if `completedCount + scheduledCount >= module count`
- [x] Count only `completed` + `scheduled` (cancelled sessions free the slot)
- [x] Return the computed module info in the booking response (so UI can display it)

### 4. Completion hook (BBB webhook)
- [x] When session -> `completed`: compute module assignment, write `module_id` to row
- [ ] Validate sequential completion: reject if earlier scheduled session exists

### 5. Booking wizard UI changes (`SessionBooking.tsx`)
- [ ] Fetch and display which module the new session will cover
- [ ] Show "Booking: Module X — [title]" in the wizard
- [ ] Show remaining bookable sessions count
- [ ] Disable booking when all modules have sessions (scheduled or completed)

### 6. Session detail / teacher dashboard
- [x] `GET /api/sessions/:id` returns computed module info
- [x] `GET /api/sessions` (list) returns computed module info per session
- [ ] Teacher sees module title for upcoming sessions

### 7. Tests
- [x] Unit tests for `resolveModuleAssignments()` — core algorithm (13 tests)
  - All scheduled, no completed
  - Mix of completed (frozen) and scheduled (computed)
  - After cancellation — reflow
  - All modules booked — no more slots
  - Edge: single module course
- [x] API tests for session limit enforcement (existing tests pass with curriculum data)
- [ ] API tests for completion writing module_id
- [x] Update existing session tests for new module_id column (2 test files updated)

### 8. Documentation
- [ ] Update `docs/tech/tech-032-session-booking.md` with final positional design
- [ ] Record decision in `DECISIONS.md`

---

## Out of Scope (Future)

| Item | Why deferred |
|------|-------------|
| Multi-session sequential booking ("Book Next Session" button) | UI enhancement, not blocking |
| Mark Complete gated on session completion | Depends on this block but is a separate UI change |
| Rescheduling flow | P1, not MVP (US-S013) |
| Cancellation policy (timing rules) | P1, not MVP (US-S014) |
| Rebooking guards for completed/dropped enrollments | Small guard, can add later |

---

## Files to Touch

| File | Change |
|------|--------|
| `migrations/0001_schema.sql` | Add `module_id` column to `sessions` |
| `migrations-dev/0001_seed_dev.sql` | Set `module_id` on completed seed sessions |
| `src/lib/booking.ts` | **NEW** — `resolveModuleAssignments()` helper |
| `src/pages/api/sessions/index.ts` | Session limit enforcement on POST, module info on GET |
| `src/pages/api/sessions/[id]/index.ts` | Module info on GET response |
| `src/pages/api/webhooks/bbb.ts` | Write `module_id` on completion |
| `src/components/booking/SessionBooking.tsx` | Show module context in wizard |
| `tests/lib/booking.test.ts` | **NEW** — algorithm unit tests |
| `tests/api/sessions/index.test.ts` | Session limit + module info tests |
| `docs/tech/tech-032-session-booking.md` | Update with final design (positional model) |
| `DECISIONS.md` | Record positional module assignment decision |

---

## Open Questions (Resolved)

| Question | Resolution |
|----------|-----------|
| Store module_id on sessions? | Nullable — NULL while scheduled, set on completion |
| What happens on cancellation? | Remaining scheduled sessions reflow automatically |
| Can sessions complete out of order? | No — sequential completion enforced |
| Session limit enforcement? | Hard reject: `completed + scheduled >= session_count` |
| Cancelled sessions count toward limit? | No — cancellation frees the slot |
