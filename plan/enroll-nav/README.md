# ENROLL-NAV — Dual-zone course SubNav (Explore + gated enrollment Journey)

**Status:** ✅ BUILT (Conv 235) — dual-zone rail + Journey state machine + "My Sessions" tab shipped; 5 gates green (6460 tests). Matt-confirm pending ([ENROLL-NAV-MATT-CONFIRM]).
**PLAN:** DEFERRED #25 → active build Conv 235. **Task:** [ENROLL-NAV] #37 (renumbered from #38).

---

## ⚠️ EVOLVED — Conv 239 [JOURNEY-LOOP] (decision-log 2026-06-04)

The dual-zone rail below stands, but **two decisions are superseded**:

- **"My Sessions" moves from Explore INTO the Journey zone.** The Journey becomes **two-tier**: **one-time gates** (Enroll / Payment / Certificate = real checkboxes) bracketing a **recurring Sessions progress-cluster** (My Sessions list + Book + Prepare/Join) carrying an **"X of N sessions"** meter — not a checkbox, because sessions repeat once per module. **Certificate gates on `completed == total`.** (Supersedes locked decision #5 + the Conv-235 "Sessions in Explore" naming resolution.)
- **Book stays a distinct, addressable rail action → its own page.** The legacy wizard (4 steps + reschedule/invite modes + a hand-rolled calendar + TZ reconciliation) is page-worthy; its Matt restyle is **[BOOK-WIZARD-MATT]** (`[CALENDAR2]`, PLAN DEFERRED #27, deferred), not part of [SESS-GRAD].

**Tracked in PLAN.md:** [JOURNEY-LOOP] = DEFERRED #26; [BOOK-WIZARD-MATT] = DEFERRED #27. (Conv 239 spawned both; this block's build is ✅ Conv 235, the EVOLVED rework is #26.)

**Scope — [JOURNEY-LOOP] (rework now):**
1. `computeCourseJourney()` (`loaders/courses.ts`) → emit `gates {enrolled, paid, certified}` + `sessions {completed, scheduled, total, nextBookableModule, nextUpcomingSession}` from existing `moduleInfo`/`getBookingEligibility`. No new SQL/schema.
2. `_course-tabs.ts` `buildCourseTabs()` → remove "My Sessions" from Explore; build the Journey as gate · gate · **Sessions cluster (progress header + sub-items: My Sessions → /sessions, Book → /book, Join → /session/[next])** · Certificate gate.
3. `SubNav.astro` → support a **progress-bearing sub-group header** ("Sessions · 2/5") + indented children inside the Journey zone (extends the existing dual-zone/done-✓/disabled support). The novel rendering bit.
4. Keep `/sessions` route + `MySessionsTab.astro` content (only its rail placement moves).
5. Active-matching for the nested Journey sub-items (`/sessions`, `/book`, `/session/[next]`).
6. **Overlap dedup:** make the Journey cluster the canonical "book the next one" hub; the wizard's own success "Book Next" / "all booked" terminal becomes secondary (reconcile copy, don't compete).
7. Confirm "X of N" counts *required sessions* = module count (`session_number` vs `module_order`); tests + 5 gates.

---

## Built — Conv 235

Scope A (user choice): one conv informs the whole state machine + rail, incl. the "My Sessions" content port.

**Files:**
- `src/lib/ssr/loaders/courses.ts` — `CourseJourneyState` + `computeCourseJourney()` (state machine from `getBookingEligibility` — zero new SQL bar one next-session query, enrolled-only) + `fetchStudentCourseSessions()`; `journey` attached to `CourseTabData`.
- `src/pages/course/[slug]/_course-tabs.ts` — zoned, state-aware `buildCourseTabs(slug, journey)`. **Benefits moved out of Explore** → it is now the "Enroll" Journey step. "My Sessions" Explore item added (enrolled-only).
- `src/components/SubNav.astro` — backward-compatible dual-zone rendering: divider + zone headers + done-✓ + muted `disabled` steps. Flat callers unchanged. Matt-sourced `SubNavItem` row primitive untouched (zone logic lives in the container).
- `src/components/course/MySessionsTab.astro` — NEW `@matt-inspired`. SSR port of legacy `SessionsTabContent` (progress + book CTA + 5 status buckets + join-window + recordings), restyled to Matt tokens.
- `src/pages/course/[slug]/[...tab].astro` — `sessions` tab (enrolled-guarded, SSR session fetch) + zoned SubNav.
- `src/pages/course/[slug]/book.astro` — journey-aware rail; interim `currentPath=""` replaced (Book step now highlights).
- `src/pages/course/[slug]/success.astro` — **rail added** (Conv 235 review fix): clicking the "Payment" Journey step landed here and dropped the nav. Now carries the course SubNav (journey recomputed from the resolved enrollmentId so a self-healed enrollment still shows the enrolled rail).
- `src/pages/session/[id].astro` — **NEW `@stand-in`** (Conv 235 review fix): root session room, legacy `/old/session/[id]` server logic ported verbatim onto the Matt shell (`SessionRoom` island untouched). The Prepare/Join step + My Sessions Join buttons linked to `/session/[id]`, which **did not exist** → 404. Also fixes the same latent 404 in shipped Matt components (`MyStudents`, `SessionHistory`, `StudentDashboard`). **Carries the course rail for the STUDENT viewer** (2nd review fix — Prepare/Join no longer drops the nav); teacher/admin get the focused rail-less room. Full retrofit → Session family [MATT-EXEC-PG2] #9.

**Rail now persists across the whole Journey:** course tabs → `/success` (Payment) → `/book` (Book) → `/session/[id]` (Prepare/Join, student), each with correct active-step highlighting. Browser-verified as David (enrolled, intro-to-n8n).

**Naming resolved:** the spec's "1:1 Sessions" label collided with Modules (Matt's `497:12684` "N 1-on-1 Sessions" frame = the *curriculum* = our Modules tab). The dropped operational surface — the student's personal *schedule* of meetings — is genuinely distinct, so it ships as **"My Sessions"**, in **Explore** (persistent dashboard), **outside** the Journey state machine. The Journey's Book action stays the funnel step. This dissolves the §Naming 🟠 watch-item.

**Journey state machine (steps):** 1 Enroll `/benefits` (done=enrolled) · 2 Payment `/success` (done=enrolled) · 3 Book `/book` (done=scheduled-or-completed) · 4 Prepare/Join `/session/[next]` or `/sessions` (muted until scheduled; done=complete) · 5 Certificate (inert — no student cert route yet, CERT-APPROVAL; done-✓ on complete). Not-enrolled viewers see only step 1.

### 🚩 Divergences from Matt — confirm before/with sign-off ([ENROLL-NAV-MATT-CONFIRM])

1. **Dual-zone divider + Journey zone** — not in Matt's frames (his enrolled rail is flat). Peerloop IA innovation.
2. **"My Sessions" as a distinct Explore tab** — our addition (Matt's "1:1 Sessions" label was the curriculum = Modules).
3. **One-assigned-teacher** kept vs Matt's `667:12040`/`622:15671` choose-among-teachers implication.
4. ~~`/success` left rail-less~~ → **RESOLVED Conv 235 review**: the rail was added to `/success` (user flagged that the Payment step dropped the nav). Matt's `579:16885` frame is rail-less, but rail-persistence across the Journey won — flag to Matt that success now diverges from `579:16885` by carrying the course rail.

### Still pending (follow-on)
- `/book` stays `@stand-in` — the Journey item now exists, but the wizard's Matt restyle (`622:15671` date/time pattern) is separate (CALENDAR territory). Graduates `@stand-in → @matt-inspired` when that lands.
- Mobile (<1024px) zone divider/header rendering in the horizontal-scroll strip — serviceable, Phase-6 drawer interplay deferred.
- Certificate step route (CERT-APPROVAL).
**Origin:** Conv 234 [BOOK-ROUTE]. While porting `/course/[slug]/book`, the user observed the course SubNav should be the persistent home for the enrolment sequence (which can be interrupted and resumed), not just a flat browse rail.
**Design refs:** `.scratch/book-route-figma-findings.md` (Figma frame investigation), Matt frames `667:12040` (Teachers Enrolled), `622:15671` (Teacher Schedule — date/time pattern), `497:12795` (Modules).

> ⚠️ Diverges from Matt's frames (his enrolled rail is flat, relabel-only — no divider, no Journey zone). The dual-zone concept is a **Peerloop IA innovation**, like the Benefits tab — **flag to Matt** before/alongside build ([PRECHECKOUT-MATT-CONFIRM] #34 precedent).

---

## Problem — what the Matt rewrite dropped

The legacy course page is **one tabbed island** (`CourseTabs.tsx`); the legacy `.astro` files (`index/feed/learn/sessions/teachers/resources`) are thin shims giving each tab a bookmarkable URL. `book.astro` and `/session/[id]` are the only genuinely-separate pages. Booking was never a tab — it's a wizard reached *from* the About/Teachers/Sessions tabs.

The new Matt rail (`_course-tabs.ts`) reorganized around **pre-enroll/marketing** surfaces and silently dropped the **post-enroll operational** ones:

| Legacy tab | Gate | New Matt rail |
|---|---|---|
| About / Teachers / Resources / Feed | public | About / Teachers / Resources / Course Feed ✓ |
| **Sessions** (session list + booking entry) | enrolled | **— dropped —** |
| **Learn** (modules + progress + homework) | enrolled | ≈ Modules (partial) |
| **My Teaching / All Sessions** (role views) | role | **— dropped —** |
| — | — | + Benefits, Meet the Creator, Reviews (new) |

ENROLL-NAV **re-homes the dropped enrolled-operational surfaces** and formalizes the enrolment sequence as a discoverable, addressable, gated funnel living in the SubNav.

---

## The model — one rail, two zones, split by a divider

The SubNav has a **dual nature** (user's framing): ad-hoc *browse* above, directed *flow* below.

### ▲ ABOVE — "Explore" (browse anytime; some items enrollment-aware)

| Item | Visible | Source / notes |
|---|---|---|
| About | always | existing |
| Course Feed | always | existing |
| Meet the Creator | always | existing |
| Teachers | always | existing — **book only with the *assigned* teacher** (see Teacher model) |
| Reviews | always | existing |
| Resources | always | preview public / full when enrolled |
| **Modules** | always | curriculum (public, Matt `497:12795`) + progress overlay when enrolled (absorbs legacy Learn). **Name stays "Modules"** — see Naming. |
| **1:1 Sessions** | **enrolled** | session list / management — legacy Sessions tab **minus** its book CTA (the booking *action* moves below). Persistent/operational ⇒ Explore nature. |

*Benefits leaves the Explore zone* — it becomes the "Enroll" Journey step below.

### ▼ BELOW — "Your enrollment journey" (ordered · gated · always rendered)

| # | Step | Route (reuse existing) | Active when | Done ✓ |
|---|---|---|---|---|
| 1 | **Enroll** (was Benefits) | `/course/[slug]/benefits` | not enrolled | enrolled |
| 2 | **Payment** | `/course/[slug]/success` | returning from Stripe / just paid | enrollment row exists |
| 3 | **Book** | `/course/[slug]/book` | enrolled & a module is unbooked | a session is scheduled |
| 4 | **Prepare / Join** | `/session/[id]` | an upcoming session exists | session completed |
| 5 | **Complete / Certificate** | cert route (CERT-APPROVAL) | course completed | — |

The Journey zone is a **state machine projected onto the rail**: enrollment/payment/booking/session flags decide which steps render, in what state. **Always shown** — a not-yet-enrolled visitor sees just **Enroll** (the path forward stays discoverable; the SubNav is the home for the enrolment sequence). Steps are **addressable** (each has a URL → deep-linkable / redirect target) and **revisitable** (a done step stays clickable).

---

## Locked decisions (Conv 234)

1. **Teacher model — keep ONE assigned teacher** (legacy: `assigned_teacher_id`, set at enrollment; you can only book with them, others greyed). Backend already built around this. **Flag to Matt** that his frames (`667:12040`/`622:15671`) imply *choosing* among teachers — that's a deferred product change, not built here.
2. **Curriculum vs sessions — keep SEPARATE.** "Modules" (curriculum/progress) and "1:1 Sessions" (session list) are two distinct tabs, not merged. (This **supersedes** the earlier "Modules → 1:1 Sessions relabel" idea, which only made sense under a merge.)
3. **Booking — its own Journey item** (#3 below the divider); the `/book` wizard is that step's target. Not folded into the "1:1 Sessions" list tab.
4. **Zone visibility — always show** the divider + Journey zone; gate the steps (non-enrolled sees just "Enroll").
5. **Placement — "1:1 Sessions" list ABOVE** (persistent Explore), **Book action BELOW** (directed Journey). The legacy Sessions tab is split: list-above / book-below.

### Naming
"Modules" **stays "Modules"** — matches Matt's RFD frame `497:12795`, and under keep-separate there's nothing to relabel. 🟠 Watch-item: Modules (content) and 1:1 Sessions (scheduled meetings) describe the same module=session entities two ways (syllabus vs schedule). If user-testing shows confusion, rename the **content** tab ("Modules" → "Curriculum"), **not** "1:1 Sessions." Defer.

---

## Divergences from Matt — flag list

- **Dual-zone divider + Journey zone** — not in Matt's frames (his enrolled rail is flat). Peerloop IA innovation.
- **"1:1 Sessions" as a distinct tab** — our addition (Matt showed it only in the merged Modules slot).
- **One-assigned-teacher** kept vs Matt's choose-among-teachers implication.

Run all three past Matt (Benefits-tab precedent).

---

## Implementation notes (for the build conv)

- **`SubNav.astro`** currently renders a flat `items[]`. Needs: section grouping (Explore / Journey) with a **divider** + optional zone headers, and per-item **gate flags** (visible / active / done) + a done-✓ affordance. Container is already a Peerloop extrapolation (`data-prov="matt-inspired"`), so extending it is in-bounds.
- **`_course-tabs.ts`** currently returns a static list. Needs to become **enrollment-state-aware** — accept flags (`isEnrolled`, `paymentReturned`, `hasUnbookedModule`, `hasUpcomingSession`, `isComplete`) and emit the two zones with per-step state. The course pages already have these flags from `fetchCourseTabData`.
- **Active-matching** (`SubNav.matchHref`): Journey steps map to real routes (`/benefits`, `/success`, `/book`, `/session/[id]`) — booking finally gets a SubNav item that highlights (this conv's `/book` rehost passes `currentPath=""` as an interim precisely because no item existed yet).
- **Route reuse** — no new routes; the Journey steps point at existing ones. `/book` stays the booking wizard (its Matt restyle → Matt `622:15671` pattern is separate, still parked).
- **`@stand-in` `/book`** — once the Journey item + Matt restyle land, the page graduates `@stand-in → @matt-inspired`.
- **Apply the rail to funnel pages** — `/book` already got the rail this conv; `/success` likewise shows the course rail per Matt's booking-context frames. (`/precheckout` intentionally omits it per Matt `558:15067`.)

---

## Open questions (resolve in the build conv)

- Per-step **gate edge cases**: multi-enrollment, cancelled-then-rebook, refunded/disputed payment, no-teacher-available — exact visible/active/done for each.
- **Divider rendering** on mobile (`SubNav`'s <1024px horizontal-scroll fallback) — how the two zones read in a horizontal strip; Phase-6 drawer interplay.
- **Role views** (My Teaching / All Sessions) — do they get their own zone, or stay role-gated within Explore? (Out of this spec's enrolled-student focus; note for completeness.)
- **Certificate route** (step 5) depends on CERT-APPROVAL (no student cert page yet).

---

## Cross-references

- PLAN.md DEFERRED #25 (this block)
- `.scratch/book-route-figma-findings.md` — Figma frame investigation that seeded this
- Legacy source of truth: `src/components/courses/CourseTabs.tsx`, `course-tabs/SessionsTabContent.tsx`, `course-tabs/TeachersTabContent.tsx`
- Current Matt rail: `src/pages/course/[slug]/_course-tabs.ts`, `src/components/SubNav.astro`
- Related blocks: CALENDAR (the `/book` date-picker rebuild), CERT-APPROVAL (step 5), [PRECHECKOUT] (Benefits → Enroll), [SUCCESS-COMMUNITY] (#36), [CH-VARIANTS] (#15)
