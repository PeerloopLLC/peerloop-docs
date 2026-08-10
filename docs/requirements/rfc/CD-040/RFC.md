# RFC: CD-040 - Client UI Batch: Community Identity, Pill Elevation & Course-Card Journey CTA

**Source:** [CD-040.md](./CD-040.md)
**Date:** 2026-08-10 (batch spans 2026-08-05 → 2026-08-10)
**Status:** 🔄 In Progress — 30 of 35 items complete. Implemented Convs 433–435; written retrospectively Conv 435.
**Client:** Brian
**Tracked in PLAN.md:** MERGE-BRIAN (closed Conv 428; ledger amended 433/434) · [plan/cert-approval/README.md](../../../../plan/cert-approval/README.md) for `[TEACH-REQ]`

---

## Summary

Five client-requested changes accumulated across Convs 433–434, each one an ask to adopt
something the client had already built on his `brian-July-7` branch, and each one previously
declined in the MERGE-BRIAN review. All five were adopted — because in every case the
recorded objection was about the **carrier**, not the design: raw hex became named `brian-*`
tokens, and a divergent client snapshot became a shared resolver.

The batch also produced a net-new feature (the student request-to-teach flow), exposed **three
defects of our own**, and surfaced a whole class of silent failure that no gate was catching.

⚠️ **This RFC is retrospective.** It was written after the work shipped, so most boxes are
already checked. Its purpose is a client-facing record of what was asked and delivered, and an
honest account of what is still open.

---

## Change Requests

### 1. Community band colour + logo identity (UI/Visual — Conv 433)

**Core Change:** Adopt the client's community band blues and logo medallion, deciding
per-surface what the logo *means*.

#### Band colour
- [x] `--brian-band` (`#e3f1fc`) + `--brian-band-line` (`#d3e7f8`) added to `src/styles/tokens-primitives.css` — his blues verbatim, as named tokens
- [x] `@theme` bridge (`bg-brian-band` / `border-brian-band-line`) in `src/styles/tokens-tailwind-bridge.css`
- [x] Applied to the `/courses` cover-story card via `presentation="band"` (new named variant, so no other card surface changed meaning underneath it)
- [x] Both catalog cards aligned on one band blue

#### Logo identity
- [x] Medallion (white ring, rising above the band edge) adopted on the `/courses` cover-story card — his size, position and ring
- [x] Medallion deliberately **NOT** applied to the community catalog card — there the logo is the card's own subject, not a cross-reference
- [x] Community catalog card leads with the logo forward (56px squircle) over a scrimmed cover, matching `/community/[slug]`'s hero

#### Verification
- [x] `tests/components/entity/CommunityAffiliation.test.tsx` — 10 tests, calibrated per `[CMH]`
- [x] Two Conv-426 guard tests reconciled with the reversed decisions
- [x] Deployed to staging and verified live **from the served stylesheet**, not from source

#### Open
- [ ] **`[COMM-IMG]`** — community art is all `picsum` placeholders. `cover_image_url` has a UI slot but **no upload and no storage**. Needs both.

---

### 2. Topic-pill hover elevation (UI/Visual — Conv 434)

**Core Change:** On `/courses`, hovering a topic pill lifts it instead of tinting it.

- [x] `--brian-pill-shadow` + `--brian-pill-shadow-hover` — his exact two-layer resting shadow and deeper hover shadow
- [x] `@theme` bridge for both
- [x] `hover:bg-neutral-100` removed — hover no longer tints the capsule
- [x] 1px hover lift, with a `motion-reduce` guard
- [x] Scroller `py-2` → `py-12` — `overflow-x-auto` computes `overflow-y: auto` and was clipping the new shadow
- [x] No new colour required: his tint `rgba(16,42,67)` = `#102A43` = `--brian-ink`, already adopted from his tab palette
- [x] Scope kept **local** to that pill row (user decision — not site-wide yet)

#### Parked
- [ ] **`[SHADOW-DEAD]`** — the app-wide `--shadow-*` scale is inert. **Gate:** a deliberate app-wide shadow pass. Explicitly **not** to be picked up as a token cleanup.

**Not adopted:** the gradient selected-capsule and `#2a93d5`.

---

### 3. Per-card journey CTA (Feature — Conv 434)

**Core Change:** Every course card carries the viewer's next step, resolved by the same
function the detail page uses.

#### The CTA
- [x] `buildCoursePrimaryCta` moved into `@lib/course-cta` — the single place a course CTA is decided
- [x] Called by all three surfaces: `/courses`, `/course/[slug]`, community Courses tab
- [x] `tests/lib/course-cta.test.ts` — parity test, exists to fail if a fourth implementation appears
- [x] Client's four states: Enroll Now · Book first session · Book next session · Teach this course
- [x] **Fifth state added** — "session already booked", which his spec omits and without which the catalog and detail page disagree
- [x] `nextSessionId` added to the `/api/me/full` snapshot, predicate deliberately matched to `computeCourseJourney` (scheduled OR in_progress, no future-only filter)

#### Defects this request exposed (ours, not his)
- [x] **`[CTA-MOD-GAP]`** — community moderators saw blank cards
- [x] **`[CTA-TEACHER-DUP]`** — certified teachers were told to "Teach this course"; now routed to `/teaching/courses/[id]`
- [x] **`[CTA-CANCELLED]`** — cancelled enrolments disagreed between surfaces
- [x] Root cause: `myCourseIds` conflated enrolments + teaching certs + created courses + moderated courses. Now creators only; everything else routes through the resolver
- [x] **`[CARD-CTA-COMM]`** — community Courses tab was on its own stale logic (enrolled viewers got no CTA at all); wired to the shared resolver with `?via=` attribution preserved on course-bound hrefs only

#### Open
- [ ] **`[CTA-HOST-GUARD]`** — nothing stops a new host of `CourseCatalogCard` shipping dead cards. It has already happened once (the community Courses tab above).

---

### 4. Student request-to-teach flow (Feature — Conv 434)

**Core Change:** A student who completed a course can ask its creator to certify them to
teach it, and the creator has somewhere to act on that.

#### Student side
- [x] `enrollments.teaching_request_sent_at` (`migrations/0001_schema.sql`) — the stamp that flips the CTA to "Request sent"
- [x] `POST /api/me/courses/[courseId]/teaching-request` — **idempotent**; a replay returns 200 `alreadySent` and does not message the creator again
- [x] `src/pages/course/[slug]/teach.astro` — authenticated request page
- [x] CTA flips to "Request sent" on all three surfaces
- [x] **`[TREQ-TEST]`** — 8 test cases (Conv 435). The idempotent replay asserts the **row counts**, not just the 200, because a correct `alreadySent` response that messaged anyway is the actual spam failure mode

#### Creator side
- [x] **`[TEACH-REQ-CREATOR-PATH]`** — `/creating/requests`, a Requests tab in the creator workspace
- [x] `GET /api/me/teaching-requests`, scoped by **authorship** not by teaching certification — a creator usually holds no certification for their own course (seed: Guy 4/4, Gabriel 0/2)
- [x] `recommend.ts` widened to accept the course creator — **both** authorization gates, not one; a positive test caught the second, which would have left the fix inert

#### Open
- [ ] **`[DIPL-SHELL]`** — `/diploma/[id]` renders in the **marketing** shell for signed-in viewers
- [ ] **`[SEED-NOTIF-STALE]`** — seeded admin notification `notif-brian-001` asserts a certificate that was deleted during Conv-434 testing

---

### 5. Gate surfaced by the batch (Infra — Conv 434)

**Core Change:** Invented Tailwind token names and MattIcon names were failing silently.

- [x] `npm run check:tokens` (`scripts/check-token-names.ts`), added to the `verify` chain and to `/w-codecheck` as check #10. Found **6 pre-existing `text-warning-600/700` defects** on its first run. Polices only project-owned families, so false positives stay at zero.

---

## Open Questions for Brian

| # | Question | Status | Answer |
|---|----------|--------|--------|
| 1 | Five client changes were planned for Conv 434; only #1 (pill elevation) and #2 (per-card CTA) were ever named. **What were #3–#5?** This batch is genuinely incomplete, not merely unwritten. | Open | |
| 2 | Does the pill elevation go app-wide, or stay local to the `/courses` topic row? (`[SHADOW-DEAD]`) | Open | |
| 3 | Who maintains community cover images once upload/storage exists, and what size/aspect constraints apply? (`[COMM-IMG]`) | Open | |
| 4 | The "approved Option B / mockup" artifacts his commits cite have still not been supplied. (`[BRIAN-ARTIFACTS]`, carried over from MERGE-BRIAN) | Open | |

---

## Walkthrough note

Before reviewing this batch with the client, **re-read the five amended rows** in
[plan/merge-brian/NOT-ADOPTED.md](../../../../plan/merge-brian/NOT-ADOPTED.md) — two under
§ Communities (Conv 433), three under § Courses (Conv 434). They carry the exact wording, and
the framing that matters:

> **The objection was dissolved, not overruled.** Raw hex became named tokens; a divergent
> snapshot became a shared resolver. Nothing was adopted by giving up a standard.

Worth leading with: his CTA request found **three defects on our side** that no test had
caught.

---

## Implementation Priority

| Priority | Item | Effort | Status |
|----------|------|--------|--------|
| — | Groups 1–5 core adoption | High | ✅ Shipped Convs 433–435 |
| High | `[CTA-HOST-GUARD]` — stop a new card host shipping dead CTAs | Low | Open |
| High | `[DIPL-SHELL]` — diploma renders in the marketing shell | Low | Open |
| Medium | `[COMM-IMG]` — cover-image upload + storage | High | Open |
| Medium | `[SEED-NOTIF-STALE]` — stale seeded notification | Low | Open |
| Low | `[SHADOW-DEAD]` — app-wide shadow pass | Medium | Parked |

---

## Completion Tracking

- **Total Items:** 35
- **Completed:** 30
- **Remaining:** 5 (4 open + 1 parked)
- **Last Updated:** 2026-08-10 (Conv 435)
