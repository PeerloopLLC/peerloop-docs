# ROLE-STUDIOS Phase 4 — Progression-Nudge Layer (design doc)

**Status:** 📐 DESIGN — drafted Conv 256 for review (user chose design-first before code). No code written yet.
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

## Build status — DESIGN COMPLETE, build DEFERRED to Conv 257 (user, Conv 256)

Design + decisions are locked; **no Phase-4 code was written in Conv 256.** Next conv executes the build plan below.

### ⚠️ Finding (Conv 256) — the two apply destinations are asymmetric
- **`/old/creating/apply`** → a REAL `CreatorApplicationForm`; clean port to root `/creating/apply` (auth-gated, `/creating` already in `PROTECTED_PREFIXES`).
- **`/old/become-a-teacher`** → a **"Coming soon" STUB**. The real recruitment landing `src/components/marketing/BecomeATeacherPage.tsx` (hero / requirements / 5-step certification path / earnings calc / FAQ / "Apply Now" CTA) exists but is **mounted nowhere**. Becoming a teacher is a *certification* path, not a self-apply form, so this recruitment landing IS the correct S→T destination. **OPEN (deferred to Conv 257):** wire `BecomeATeacherPage` into root `/become-a-teacher` (public `LandingLayout`, existing styling — Matt-restyle out of scope per Matt phase-out) vs. defer/stub. Recommended: wire it (the content already exists).

### Conv-257 build plan (the "simplest two first" cut, decision C)
1. **Apply destinations:** port `/creating/apply` (CreatorApplicationForm) to root; resolve the become-a-teacher OPEN above and make `/become-a-teacher` real.
2. **Build `ProgressionNudge`** (§2) — Matt-native self-gating island, `student-to-teacher` + `teacher-to-creator`, variants `card`/`banner`/`inline`.
3. **Wire ② + ③** — replace static `CourseDetail.tsx:109` card with `<ProgressionNudge transition="student-to-teacher" courseId variant="inline"/>`; add `<ProgressionNudge … variant="banner"/>` to the home strip region (S→T on any completed enrollment).
4. Gates + SSR/eligibility verification (Guy = teacher+creator → T→C should NOT show; a pure completed-course student → S→T shows).
5. **Conv-2+ (later):** placement ① Journey-zone certificate gate + ④/⑤ Teacher→Creator + the T→C progression-gap (v2).
