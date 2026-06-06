# CALENDAR2 — Matt restyle of the booking wizard (`SessionBooking.tsx`)

**Task:** [CALENDAR2] / [BOOK-WIZARD-MATT] · PLAN DEFERRED #27 · TodoWrite #43
**Goal:** graduate `/course/[slug]/book` from `@stand-in` → `@matt-inspired` by re-skinning the
`SessionBooking.tsx` island to Matt tokens/primitives + adopting Matt's `622:15671` date/time pattern,
**without losing any legacy behavior**.
**Started:** Conv 242 (MacMiniM4).

## Governing principle (user, Conv 242)

> "Matt's design is naive in that it doesn't account for the non-happy-paths that happen during
> booking. The legacy app is much more functional but not as nice looking."

**Legacy is the functional source of truth; Matt is the skin.** Matt's frames cover the happy path
only — he never designed the reschedule notice, the invite "start now" flow, the all-booked terminal,
no-availability, or error states. The merge keeps the **entire** legacy behavior + multi-step structure
and drapes Matt styling over it. Re-skin that drops behavior = FAILED port (see
`memory/feedback_port_functionality_and_styling.md`, `memory/project_matt_phaseout_inspired_default.md`).

## Design source

- `622:15671` "Teacher Schedule" (creator-side, **NOT RFD**) — the date/time pattern. Digest in
  `.scratch/book-route-figma-findings.md` (re-copied from M4Pro Conv 242; screenshot did NOT copy).
  → marker is **`@matt-inspired`** (built from Matt tokens/pattern, referencing a non-RFD frame), not `@matt-source`.
- Matt's intent: date + time on ONE screen (month calendar + "Suggested times" pill grid), flat picker,
  single combined CTA. We adopt the **one-screen date+time visual** but keep legacy's multi-step structure.
- Token vocabulary precedent: [SESS-GRAD] components (Conv 239) — `SessionPrepare.tsx`, `SessionRoom.tsx`.

## Decisions (Conv 242)

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | **Separate confirm step** (option B), NOT Matt's folded single-CTA | Confirm carries module/teacher/message-link summary + reschedule warning — non-happy-path content Matt's single CTA drops. |
| D2 | **Keep the step indicator** (re-skinned Matt) | Serves the multi-step functional flow; dropping it was only justified under Matt's collapsed happy-path. |
| D3 | **Merge date+time onto one screen** (calendar + suggested-times pills) | Pure skin win — still pick date→time, no behavior lost. Matt-faithful visual. |
| D4 | **One-assigned-teacher model kept** (others greyed) | Locked ENROLL-NAV decision #1; Matt's choose-among-teachers is a deferred product change, flagged under [ENROLL-NAV-MATT-CONFIRM]. |
| D5 | **All date/TZ math untouched** | Protects the fragile timezone logic (`memory/project_timezone_confidence.md`). Re-skin is token/layout only. |

## Inherited obligations (parked here by JOURNEY-LOOP, Conv 240)

- **Success-terminal copy reconcile** (ENROLL-NAV step 6, README line 30-33): the rail's "Book" cluster
  child is now the canonical "book the next one" hub. The wizard's success "Book Next Session" /
  all-booked terminal must not compete — soften to secondary / defer to the rail.
- **Dev React-dup error** (ENROLL-NAV README line 36-40): `/book`'s heavy `client:load` island throws a
  dev-only "more than one copy of React" that drops the layout; expected to clear once off `@stand-in`.
  **Watch:** verify `npm run dev` renders `/book` cleanly after the restyle.

## Scope

- Rewrite `src/components/booking/SessionBooking.tsx` — token migration across all render functions;
  merge `renderDateSelection`+`renderTimeSelection` into one screen; keep confirm/success/invite/all-booked;
  swap in `Button`, `MattIcon`; preserve every handler + API call + state + conditional.
- `src/pages/course/[slug]/book.astro` — flip marker `@stand-in` → `@matt-inspired`; update doc-comment.
- Verify: 5 baseline gates (`/w-codecheck`), prov:sweep (this removes one `@stand-in`), browser-verify the
  full funnel + non-happy-paths (reschedule, all-booked, no-availability), dev-render check.

## Provenance

`/course/[slug]/book` → `@matt-inspired 622:15671` (referencing the non-RFD creator-side frame).
Removing this `@stand-in` should drop the stand-in census by one (relevant to [PROV-SWEEP-DEBT] — ✅ cleared 4→0 Conv 244).

## Result (Conv 242) — ✅ COMPLETE

- **Built** as specced: merged date+time onto one screen, kept the confirm step (D1), kept the step
  indicator (D2, re-skinned), one-assigned-teacher model (D4), all date/TZ math untouched (D5). Success
  "Book Next" demoted to secondary (inherited JOURNEY-LOOP step-6 dedup). Status colors stayed functional.
- **Gates:** tsc/astro/lint 0 errors · full suite **6458 passed** · build clean (6.86s — dev React-dup quirk
  clears) · prov:sweep unchanged 6-debt (none in CALENDAR2 files) · deleted_at/datetime/locals/error-render PASS.
- **`@stand-in` census in `src/pages/*.astro` = ZERO** — funnel fully `@matt-inspired` end-to-end.
- **Test rewrite:** `SessionBooking.test.tsx` confirm/booking/success assertions were silently dead (mock
  used non-ISO times → `Invalid Date`, so `if(timeSlot)` blocks never ran; day-click also no-op'd under
  TZ≠UTC). Rewrote to ISO local-date-key mocks + robust pill/Continue matchers → genuinely exercises
  day→time→Continue→Confirm→book (31/31).
- **Spun off:** `[TZ-AUDIT]` #46 (server-UTC vs client-local date-bucketing — `availability-utils.ts` builds
  `slot.date` from local parts = UTC on the Worker, vs browser-local calendar cells; deferred after
  CH-VARIANTS→SUCCESS-COMMUNITY per user). `[OUTLINE-V4]` #45 (v3 `outline-none` in pre-existing SESS-GRAD files).
