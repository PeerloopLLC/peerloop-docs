# CURRENT-BLOCK-PLAN: BOOKING-FOLLOW-UPS

**Focus:** Small follow-up items from the completed BOOKING-MODULES block
**Predecessor:** Sessions 331-332 (positional module assignment — complete)
**Status:** NOT STARTED

**Reference:** `docs/tech/tech-032-session-booking.md` — full design and implementation details

---

## Scope

Three actionable items that build on the completed booking-modules backend. All backend support exists; these are UI changes and a small API guard.

### 1. Rebooking guard for completed/dropped enrollments
- [ ] `POST /api/sessions` — reject if `enrollment.status` not in `('enrolled', 'in_progress')`
- [ ] Test: booking against completed enrollment returns 400/403

**Why:** Currently nothing prevents booking sessions after a course is finished or dropped.

### 2. "Book Next Session" button on success screen
- [ ] Add "Book Next Session" link to `SessionBooking.tsx` success screen
- [ ] Link reloads `/course/[slug]/book` — the `moduleInfo` prop auto-computes the next module
- [ ] Hide button when `bookableCount` is 0 (all modules booked)

**Why:** Students currently must navigate back manually to book their next session.

### 3. Mark Complete gated on session completion
- [ ] Fetch `resolveModuleAssignments()` data on Learn page
- [ ] Disable Mark Complete button until module's session is `completed`
- [ ] Show contextual hints: "Book a session first" / "Session scheduled for [date]" / enabled

**Why:** Students can currently self-report module completion without attending the session.

---

## Out of Scope (P1, not MVP)

| Item | Why deferred |
|------|-------------|
| Rescheduling flow (US-S013) | Needs cancellation policy design, client input |
| Cancellation policy — timing rules (US-S014) | Business rules undefined |

These are tracked in `docs/tech/tech-032-session-booking.md` Open Design Questions #4.
