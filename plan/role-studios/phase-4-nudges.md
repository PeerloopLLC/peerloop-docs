# ROLE-STUDIOS Phase 4 — Progression-Nudge Layer (design doc)

**Status:** ✅ COMPLETE Conv 257–258 + 286 — `ProgressionNudge` built, all 5 placements live, both apply destinations ported; render-checks done + `[NUDGE-TC]` closed (Conv 258). `[NUDGE-TC-V2]` v2 progression-gap ✅ **BUILT Conv 286** (decision A path-capstone — see § below). (Design drafted Conv 256; build record below.)
**Parent:** PLAN.md § ROLE-STUDIOS · memory `project_role_studios_deconstruct_nudges`
**Goal:** a reusable, role-gated nudge component that drives users up the flywheel (student→teacher at 70%, teacher→creator at 15%), placed on the **source role's** surfaces — never the target hub.

---

## 1. Why a component (not per-site copy)

Today the flywheel is almost entirely absent in-app: one static `CourseDetail.tsx:109` "Earn While You Learn" card (not gated, not actionable) + marketing pages aimed at cold visitors. Phase 4 makes the nudge a **first-class, gated, actionable** element reused across 5 placements, so copy/gating/telemetry live in one place.

## 2. Component API (greenfield — proposed)

A **self-gating client island** that reads the current-user store itself and renders nothing when the viewer isn't eligible. This is the key design move: it means a placement host (e.g. `CourseDetail`, which today has no viewer/auth context) just drops the tag in — no prop threading.

```tsx
<ProgressionNudge
  transition="student-to-teacher" | "teacher-to-creator"
  courseId={string}        // optional — per-course placements gate on this course
  variant="card" | "banner" | "inline"   // placement-appropriate chrome
  client:load
/>
```

- Reads `useCurrentUser()`; computes eligibility (§3); returns `null` if ineligible or visitor.
- Renders a **Matt-native** CTA: icon + harvested headline + sub + button → apply destination (§5). Built Matt from the start — it's greenfield, so unlike the harvested dashboard islands there is **no legacy-token restyle to defer** (no `[X-RESTYLE]` task).
- Home is `client:only`-friendly; per-course can be `client:load`.

## 3. Eligibility predicates (canonical — already exist)

The current-user store already carries the exact ROLE-SEMANTICS identity getters the PLAN named for nudge-gating (`src/lib/current-user.ts:512-535`, comment literally cites "flywheel progression NUDGES"):

| Getter | Meaning |
|--------|---------|
| `isStudent` | enrolled in ≥1 course (any status) |
| `isTeacher` | active teacher_certification ≥1 |
| `isCreator` | has created ≥1 course |
| `hasCompletedCourse(courseId)` | this course's enrollment status === 'completed' |

**Derived nudge eligibility:**
- **Student → Teacher:** `isStudent && !isTeacher && completed`, where `completed` = `hasCompletedCourse(courseId)` for per-course placements, or "any enrollment with status==='completed'" for the home strip. (The Certificate gate = course completed.)
- **Teacher → Creator (v1):** `isTeacher && !isCreator`.
- **Teacher → Creator (v2, progression-gap refinement):** v1 **and** the teacher taught the last course in a progression with no further course — i.e. `courses.progression_position === progressions.course_count`. Needs a small data source (no current client signal). **Proposed: ship v1 now, defer v2** (see Open Decision A).

## 4. Placements (the 5, from the nudge table)

| # | Transition | Host surface | Gate | Variant |
|---|-----------|--------------|------|---------|
| ① | S→T | Course **Journey zone** (in `course/[slug]` detail tabs — `_course-tabs.ts`; exact mount to confirm at build) at the Certificate gate | `hasCompletedCourse(slug→id)` | card |
| ② | S→T | **Upgrade** the static `CourseDetail.tsx:109` "Earn While You Learn" card → gated actionable CTA | `hasCompletedCourse(course.id)` | inline (replace existing card) |
| ③ | S→T | Home `TriageStrip` region (built Conv 256) | any completed enrollment | banner |
| ④ | T→C | `/teaching` workspace (overview) | `isTeacher && !isCreator` | card |
| ⑤ | T→C | On the taught course ("Create the next course — earn 15%") | `isTeacher && !isCreator` (+ v2 gap) | inline |

## 5. Copy (harvest from existing — no new voice)

- **S→T:** headline "Earn While You Learn" / "Teach What You Know, Earn What You're Worth" (`BecomeATeacherPage`); sub "Complete the course, get certified, and earn 70% commission teaching others" (existing `CourseDetail:111`); CTA **"Become a Teacher"** → apply destination.
- **T→C:** headline "Create the next course — earn 15%"; sub from `marketing/for-creators/*`; CTA **"Start Creating"** (`for-creators/CtaSection`) → apply destination.

## 6. ⚠️ Dependency: apply destinations are NOT at root yet

Only `/old/become-a-teacher` and `/old/creating/apply` exist (no root ports). The nudge CTAs need a destination. Options in Open Decision B.

---

## RESOLVED DECISIONS (Conv 256)

- **A → v1 simple.** T→C gate = `isTeacher && !isCreator`. Progression-gap refinement (v2) deferred to a later conv.
- **B → port apply flows first.** Port `/become-a-teacher` + `/creating/apply` to root as Phase-4 work; the nudge CTAs point at the new root routes (not `/old/*`).
- **C → simplest two first.** Conv 1 (this conv): `ProgressionNudge` component + placement ② (CourseDetail upgrade) + ③ (home strip). Conv 2: ① Journey-zone certificate gate + ④/⑤ Teacher→Creator.
- **D → Matt-native.** Build `ProgressionNudge` Matt from the start; no restyle-defer task.

## Build status — ✅ BUILT Conv 257 (the "simplest two" cut + ports)

**Conv 257 shipped** (4-gate green: tsc / lint / astro-check 0-0-0 / build; routes smoke-tested on dev):
- ✅ `ProgressionNudge` — Matt-native self-gating island, both transitions, 3 variants (`card`/`banner`/`inline`). `src/components/progression/ProgressionNudge.tsx`.
- ✅ Apply destinations ported to root (MOVE from `/old`, both `@stand-in`): `/creating/apply` (CreatorApplicationForm, auth-gated) + `/become-a-teacher` (mounts the orphaned `BecomeATeacherPage`, public `LandingLayout`). **Bonus repair:** both root paths were already hardcoded across 7 live call-sites (AppNavbar, notifications, deny/apply emails, Footer, StoriesBrowse, 2 marketing sections) but only existed under `/old/*` or as a stub — so those links were silently 404-ing. Verified: `/become-a-teacher`→200 real content, `/creating/apply`→302 login, `/old/*`→404.
- ✅ Placement ③ — S→T `banner` on Home in the TriageStrip region (`client:only="react"`, any completed enrollment).
- ✅ Placement ① (pulled forward — see finding below) — S→T `card` on the live course `about` overview (`course/[slug]/[...tab].astro`, `client:load`, `courseId={data.course.id}`).
- ✅ Placement ④ — T→C `card` on `/teaching` overview tab (`teaching/[...tab].astro`, `client:load`, gate `isTeacher && !isCreator`).
- ✅ Placement ⑤ — T→C `inline` on the taught-course detail (`teaching/courses/[courseId].astro`, `client:load`; page already SSR-gated to certified teachers, nudge self-gates on the not-yet-creator half).

**All 5 placements live (user chose to finish T→C in-conv, Conv 257).** S→T: ① (course about) + ③ (home). T→C: ④ (/teaching overview) + ⑤ (taught course). ② retired (dead target → absorbed into ①). 4-gate green after ④/⑤.

### 🔴 Finding (Conv 257) — placement ② target was DEAD CODE; ① pulled forward instead
The design's placement ② ("upgrade the static `CourseDetail.tsx:109` card") targeted **`src/components/courses/CourseDetail.tsx`, which is orphaned** — no imports anywhere in `src/`, last touched Conv 050. Editing its card would have zero user-visible effect. The live course-detail surface is `course/[slug]/[...tab].astro` (mounts `MattCourseFeed` + tab islands) — which is exactly **placement ①'s** territory (Journey/Certificate zone), the one decision C had deferred as harder. So ②'s live equivalent IS ①. **User chose (Conv 257) to pull ① forward** and mount the S→T nudge on the live course `about` tab now, replacing the obsolete ②. The standalone "②" placement is retired (its target is dead). `CourseDetail.tsx` is now a candidate for deletion (separate cleanup; cf. `[OLD-PORTED-CLEANUP]`/dead-code sweeps — not done this conv).

### Remaining Phase-4 work
- ✅ ~~④ T→C card on /teaching · ⑤ T→C inline on taught course~~ — DONE Conv 257.
- ✅ ~~Browser render-check (the Conv-257 verification gap)~~ — DONE Conv 258 (`[NUDGE-TC]` closed; results in the Verification section above).
- ✅ **`[NUDGE-TC-V2]` BUILT Conv 286 (decision A — path-capstone)** — T→C **v2 progression-gap** refinement now gates placement ⑤ (taught-course inline) additionally on the taught course being a **learning-path capstone** (`progression_position === course_count AND badge='learning_path'`). Semantics decision = **A** (most precisely matches "walked the path to its end → author the follow-on"; B too broad, C depends on sparse `course_prerequisites`). Shipped: NEW `src/lib/progression/capstone.ts` (`isProgressionCapstone(db, courseId)`, server-side); `ProgressionNudge` gained a `capstone?` prop (overview ④ stays v1; course ⑤ gains the gap); `teaching/courses/[courseId].astro` computes it server-side and passes it (server-computed prop → self-gating island, no store change, no test ripple). +20 tests (`tests/lib/progression-capstone.test.ts` + `tests/components/progression/ProgressionNudge.test.tsx`); 5-gate baseline green. (The optional 2nd S→T placement on the `sessions` My-Sessions journey tab remains a low-priority nicety — not built; `about`-tab card already verified clearly visible Conv 258.)

### Verification (Conv 257 + Conv 258)
4-gate green + routes smoke-tested (`/become-a-teacher`→200, `/creating/apply`→302, `/old/*`→404). Browser render-check (client-gated, so curl can't see it) done via **D1 user-classification + dev-login session-switch + DOM-truth inspection** of the `[data-nudge]` marker (every variant emits `data-nudge="<transition>"`).
- ✅ **T→C confirmed in-browser** (user, Conv 257): `sarah.miller` (teacher, non-creator) → ④ T→C card on `/teaching` overview, ⑤ T→C inline on `/teaching/courses/crs-ai-tools-overview`. One nudge per page.
- ✅ **S→T confirmed** (Conv 258, /chrome bridge + DOM-truth): `amanda-lee` (student, completed `vibe-coding-101`, non-teacher) → ③ banner on Home + ① card on `/course/vibe-coding-101`, both persist visible after hydration settle. **Per-course gate confirmed:** amanda on `/course/intro-to-claude-code` (NOT completed) → no nudge (validates `hasCompletedCourse(courseId)`).
- ✅ **Negative confirmed** (Conv 258): `guy-rymberg` (teacher+creator) → zero nudges across all 4 surfaces (Home, course, `/teaching`, taught-course). T→C gate fails on `isCreator`, S→T on `isTeacher`.

#### 🔴 Conv-258 finding — stale `peerloop_user_cache` causes a transient wrong-role nudge flash
On the **first** navigation after a `dev-login` account-switch, the nudge island hydrates from the **cached previous user's** classification in `localStorage['peerloop_user_cache']`, renders, then the fresh `/api/auth/session` fetch re-classifies and removes/replaces it. Observed: guy-rymberg briefly showed the S→T banner on Home (amanda's cached eligibility) before it vanished on settle. Implication for verification: a "break on first `[data-nudge]` sighting" detector RACES this — the correct method is **settle-then-read** (wait ~1.5–1.8s after navigate, then query the DOM). Real-usage impact is narrow but non-zero: a user whose cache is stale relative to their session (e.g. a freshly-certified teacher whose cache still says student) could see a brief S→T flash until the refetch lands, because `authStatus` resolves to `authenticated` immediately from cache rather than waiting for fresh classification. Tracked as `[NUDGE-CACHE-FLASH]` — candidate fix: gate nudges on a "classification fresh" signal, not just `authStatus !== 'loading'`. This is the concrete evidence behind `[BRIDGE-MEM]`.

**Seed eligibility map (local D1, Conv 257):** S→T → amanda.lee, jennifer.kim · T→C → marcus.t, sarah.miller · none → guy-rymberg (T+C), gabriel-rymberg (creator), david.r (enrolled, 0 completed).

---

## Original build plan (pre-execution, Conv 256) — kept for reference

### ⚠️ Finding (Conv 256) — the two apply destinations are asymmetric
- **`/old/creating/apply`** → a REAL `CreatorApplicationForm`; clean port to root `/creating/apply` (auth-gated, `/creating` already in `PROTECTED_PREFIXES`).
- **`/old/become-a-teacher`** → a **"Coming soon" STUB**. The real recruitment landing `src/components/marketing/BecomeATeacherPage.tsx` (hero / requirements / 5-step certification path / earnings calc / FAQ / "Apply Now" CTA) exists but is **mounted nowhere**. Becoming a teacher is a *certification* path, not a self-apply form, so this recruitment landing IS the correct S→T destination. **OPEN (deferred to Conv 257):** wire `BecomeATeacherPage` into root `/become-a-teacher` (public `LandingLayout`, existing styling — Matt-restyle out of scope per Matt phase-out) vs. defer/stub. Recommended: wire it (the content already exists).

### Conv-257 build plan (the "simplest two first" cut, decision C)
1. **Apply destinations:** port `/creating/apply` (CreatorApplicationForm) to root; resolve the become-a-teacher OPEN above and make `/become-a-teacher` real.
2. **Build `ProgressionNudge`** (§2) — Matt-native self-gating island, `student-to-teacher` + `teacher-to-creator`, variants `card`/`banner`/`inline`.
3. **Wire ② + ③** — replace static `CourseDetail.tsx:109` card with `<ProgressionNudge transition="student-to-teacher" courseId variant="inline"/>`; add `<ProgressionNudge … variant="banner"/>` to the home strip region (S→T on any completed enrollment).
4. Gates + SSR/eligibility verification (Guy = teacher+creator → T→C should NOT show; a pure completed-course student → S→T shows).
5. **Conv-2+ (later):** placement ① Journey-zone certificate gate + ④/⑤ Teacher→Creator + the T→C progression-gap (v2).
