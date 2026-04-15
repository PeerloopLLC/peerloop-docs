# Role-Check Audit (ROLE-AUDIT) — 2026-04-15

**Status:** Report-only (Option R). Produced in Conv 123.
**Scope:** Systematic sweep for role checks outside the `CurrentUser` / `/api/me/full` / `src/lib/permissions.ts` pattern. Unblocked by `COMMUNITY-TEACHER-KILL` (Conv 120). Original block opened Conv 119.
**Audit axes:**
- **Axis 1** — client code reading role state outside `CurrentUser`.
- **Axis 2** — Astro SSR duplicating role data that `/api/me/full` already serves.
- **Axis 3 (C)** — ad-hoc role conditionals that should go through `src/lib/permissions.ts` (or equivalent).

Results categorized **A/B/C/OK** (see CLAUDE.md handoff options at end).

---

## Executive summary

| Category | Hits | Severity |
|---|---|---|
| **A.** Client code reading role outside `CurrentUser` | **2** confirmed, 0 stale | 🟢 LOW |
| **B.** SSR duplicating role data from `/api/me/full` | **0** (SSR is *correct* — `window` is unavailable server-side) | 🟢 N/A |
| **C.** Ad-hoc role conditionals that should be helpers | **~24** (2 distinct patterns) | 🟡 MEDIUM |
| **OK — reviewed, legitimate** | 88+ | — |

**Headline finding:** the `COMMUNITY-TEACHER-KILL` cleanup landed the only structurally *stale* role construct. There is no remaining "zombie role" in the codebase. The surviving concerns are all **ergonomic/DRY** — repeated inline `SELECT is_admin FROM users WHERE id = ?` in API handlers, and a 5-file-duplicated `roleOrder` helper in Astro community pages.

**Recommendation:** ship as **3 small follow-up blocks** (described in §Follow-ups). None block product work. `CODECHECK-SQL` (already queued as task #8) would catch a subset of these if extended with a "known-permission-helper" lint.

---

## Methodology

1. **Axis 1** — grepped all `.tsx`/`.ts` client code for:
   - `fetch('/api/me...')` — is the fetched data *role state* that `CurrentUser` already has?
   - `localStorage.getItem(...)` — any role-related keys bypassing `CurrentUser` cache?
   - `window.__peerloop...` — any access outside `current-user.ts`?
2. **Axis 2** — grepped `src/pages/**/*.astro` and `src/lib/ssr/**` for role-tables (`community_members`, `teacher_certifications`, `enrollments`, `progressions`, `community_moderators`, `users.is_admin`) queried with the *current viewer's* `user_id` as a parameter. Classified as:
   - ✅ legitimate SSR (needed for first-paint HTML / SEO)
   - ⚠️ duplicative (already in `/api/me/full`)
3. **Axis 3** — flagged repeated patterns:
   - inline `SELECT is_admin FROM users WHERE id = ?` per-request
   - inline `role === 'creator'` / `isAdmin \|\| membership.role === 'creator'` conditionals
   - duplicated Astro `roleOrder` helper

---

## Axis 1 — Client-side role reads

### A.1 `MyCourses.tsx:132` — re-fetches enrollments

```
src/components/courses/MyCourses.tsx:132
  const response = await fetch('/api/me/enrollments');
```

**Finding:** Duplicates `CurrentUser.enrollments` (which has been enriched with Phase 2 data — `hasReview`, `courseDuration`, `courseSessionCount` per Conv 014-015).

**Recommendation:** migrate to `useCurrentUser()` + `user.enrollments`. Delete `/api/me/enrollments` endpoint if no other caller remains (verify separately).

**Effort:** ~30 min. Low risk — endpoint shape is already covered by `UserEnrollment` type.

---

### A.2 `UserProfile.tsx:77, 115` — refetches own profile + stats

```
src/components/profile/UserProfile.tsx:77
  const response = await fetch('/api/me/profile');

src/components/profile/UserProfile.tsx:115
  const statsResponse = await fetch('/api/me/stats').catch(() => null);
```

**Finding:** Duplicates `CurrentUser.user` (identity) and `CurrentUser.stats`.

**Caveat:** `UserProfile.tsx` also handles *viewing other users' profiles* (it's the shared profile component). The fetches may be gated on "is this the current user's own profile?" — **needs inspection before migration.** If it conditionally calls `/api/me/profile` only for self-view, that's the migration candidate. If it always hits it (even on other-profile view), that's a pre-existing bug worth filing separately.

**Recommendation:** read the surrounding conditional logic, then migrate the self-view branch to `useCurrentUser()`.

**Effort:** ~45 min (includes verification of other-profile behavior).

---

### A.3 `ProfileSettings.tsx:324` — settings form reload

```
src/components/settings/ProfileSettings.tsx:324
  const response = await fetch('/api/me/profile');
```

**Classification:** 🟢 **OK — legitimate.** Settings forms intentionally fetch fresh server state on mount to avoid editing stale cached data.

---

### A.4 `SecuritySettings.tsx:171` — settings form reload

**Classification:** 🟢 **OK.** Same reason as A.3.

---

### A.5 — A.∞: other `/api/me/*` fetches

Reviewed 55 call sites across `components/analytics/**`, `components/creators/studio/**`, `components/teachers/workspace/**`, `components/dashboard/**`, etc. **None fetch role state.** They fetch *scoped workload data* (availability, earnings, sessions, notifications, analytics) that's legitimately out-of-scope for `CurrentUser` by design (per CURRENTUSER block decisions — CurrentUser stores *identity + relationships*, not *dashboard payloads*).

### localStorage audit

All `localStorage` reads reviewed. Zero role-related keys outside `current-user.ts`:

| Key | File | Purpose |
|---|---|---|
| `theme` | `UserAccountDropdown.tsx`, `MoreSlidePanel.tsx` | Dark-mode preference |
| `dashboard_section_*` | `CollapsibleSection.tsx` | UI collapse state |
| `pl_pending_sessions` | `EnrollButton.tsx`, `MyCourses.tsx` | Post-enroll booking handoff (not a role signal) |
| `onboarding-nudge-dismissed-*` | `OnboardingNudgeBanner.tsx` | Banner dismissal |
| `recommendations-dismissed-*` | `RecommendedCourses.tsx`, `RecommendedCommunities.tsx` | Banner dismissal |
| `pl_was_logged_in`, `pl_expired_identity`, `pl_current_user_cache` | `current-user.ts` | ✅ Managed by CurrentUser |

**Result:** no action.

### `window.__peerloop` audit

All 18 hits are inside `src/lib/current-user.ts` (owner) and one typed-assertion comment in `src/lib/auth-modal.ts` (which does not read user state). **No action.**

---

## Axis 2 — SSR duplication

**Context:** `CurrentUser` is a *client-side* window singleton. Astro frontmatter runs on the edge, before hydration, where `window` does not exist. Therefore any SSR page that renders role-aware UI *must* query the DB for itself — the alternative (blank HTML + client fetch) hurts SEO, causes layout shift, and adds a round-trip.

### Sites queried

| File | Table(s) | Current-viewer query? | Classification |
|---|---|---|---|
| `src/pages/teaching/courses/[courseId].astro:50` | `teacher_certifications` | yes | ✅ Legitimate SSR gate |
| `src/pages/teacher/[handle]/index.astro:41,75` | `teacher_certifications` | no (queries `u.handle`) | ✅ Profile page of another user |
| `src/pages/creator/[handle]/index.astro` | via loader | no | ✅ Profile of another user |
| `src/pages/course/[slug]/index.astro` (+ `book/feed/learn/resources/teachers/sessions.astro`) | `enrollments`, `teacher_certifications` | yes for `session.userId` | ✅ Legitimate SSR (needs first-paint role context) |
| `src/pages/discover/course/[slug]/[...tab].astro` | `enrollments`, `teacher_certifications` | yes | ✅ Legitimate SSR |
| `src/pages/community/[slug]/*.astro` (4 pages) | via `fetchCommunityDetailData` | yes | ✅ Uses SSR loader (correct pattern) |
| `src/pages/discover/community/[slug]/*.astro` | via loader | yes | ✅ Correct |
| `src/lib/ssr/loaders/communities.ts:410, 422, 476` | `community_members`, `users.is_admin` | yes | ✅ Correct — this is the SSR loader |

**Finding:** **0 SSR duplication bugs.** The `/api/me/full` client cache and SSR queries serve different purposes — the former hydrates the React islands *after* first paint, the latter generates correct first-paint HTML. The two systems converge on the same data semantically, which is by design.

**Subtle observation:** there's an opportunity to **de-dupe the SSR queries themselves** — `course/[slug]/index.astro`, `feed.astro`, `learn.astro`, `resources.astro`, `sessions.astro`, `teachers.astro` each run near-identical `teacher_certifications` + `enrollments` queries. A shared loader (e.g., `fetchCourseDetailData` mirroring `fetchCommunityDetailData`) would collapse ~6 duplicated SQL blocks into one. **This is SSR hygiene, not role-audit scope** — filing as follow-up §FU-2.

---

## Axis 3 — Ad-hoc role conditionals (Category C)

### C.1 Repeated `SELECT is_admin FROM users WHERE id = ?` in API handlers (10 sites)

```
src/pages/api/creators/apply.ts:190
src/pages/api/checkout/create-session.ts:92
src/pages/api/communities/[slug]/moderators/[userId].ts:72
src/pages/api/communities/[slug]/moderators/index.ts:94, 122
src/pages/api/community-resources/[id]/download.ts:91
src/pages/api/enrollments/[id]/expectations.ts:214
src/pages/api/feeds/course/[slug].ts:316
src/pages/api/me/communities/[slug]/resources/index.ts:60
src/pages/api/me/communities/[slug]/resources/[resourceId].ts:45
src/lib/messaging.ts:67, 118
```

**Finding:** Each request that needs `isAdmin` gating does its own single-row lookup after JWT verification. The JWT already identifies the user; a second round-trip for `is_admin` is the norm.

**Two recommendations (pick one):**

- **C.1-a (cheapest, still correct):** extract a single helper `getCurrentUserAdminFlag(db, userId): Promise<boolean>` in `src/lib/auth/session.ts` and call it in all 10 sites. Zero behavior change; trivial refactor.
- **C.1-b (durable, slight risk):** embed `is_admin` in the JWT claims (already done for `userId`; add `isAdmin`). Eliminates the DB round-trip entirely. **Risk:** admin-revocation latency until next session refresh (~15 min with current config). Acceptable for most gates (permission checks happen via API regardless) but **must be vetted against each admin gate individually** — e.g., a revoked admin triggering a payout would be bad.
- **C.1-c (strict, most complex):** same as C.1-b but add a revocation blacklist check. Overkill for current scale.

**Recommendation:** **C.1-a for this audit**, file C.1-b as a decision for later (the durability dividend is real but doesn't unblock anything).

### C.2 Inline `roleOrder` helper duplicated across 5 Astro pages

```
src/pages/community/[slug]/resources.astro:33
src/pages/community/[slug]/courses.astro:36
src/pages/community/[slug]/index.astro:45
src/pages/community/[slug]/members.astro:33
src/pages/discover/community/[slug]/[...tab].astro:51
src/pages/discover/community/[slug]/index.astro:32
```

Each page inlines a `roleOrder` function of the form:

```typescript
function roleOrder(role: string): string {
  if (role === 'creator') return 'creator';
  // ... similar fall-throughs
}
```

**Finding:** Six copies of the same 5-line helper. Pure copy-paste drift risk.

**Recommendation:** extract to `src/lib/permissions.ts` or a new `src/lib/role-display.ts`. ~15 min.

### C.3 `isAdmin || membership?.role === 'creator'` inline (already addressed)

The 5 `canUploadCommunityResources` sites identified in Conv 119-120 are already routed through `src/lib/permissions.ts`. ✅ No remaining copies.

### C.4 Inline `member_role === 'creator'` comparisons (2 sites)

- `src/pages/api/communities/[slug]/join.ts:201` — gate for "cannot join your own community". Legitimate (domain-specific, one-of-a-kind).
- `src/components/creators/communities/CommunityManagement.tsx:350,354` — UI label ("Creator" vs "Member") in a members list. Legitimate (display, not access control).

**No action.**

---

## Follow-ups (proposed)

| ID | Scope | Effort | Priority |
|---|---|---|---|
| **FU-1** | Migrate `MyCourses.tsx` + `UserProfile.tsx` (self-view branch) to `useCurrentUser()` | 1-2 hr | 🟡 ergonomic, not urgent |
| **FU-2** | Collapse `course/[slug]/*.astro` duplicated SSR queries into a `fetchCourseDetailData` loader (mirror `fetchCommunityDetailData`) | 3-4 hr | 🟡 SSR hygiene |
| **FU-3** | Extract `getCurrentUserAdminFlag(db, userId)` helper; replace 10 inline `SELECT is_admin` sites | 1 hr | 🟢 DRY |
| **FU-4** | Extract shared `roleOrder()` helper from 6 Astro pages | 15 min | 🟢 DRY |
| **FU-5 (decision only)** | Evaluate embedding `isAdmin` in JWT claims (C.1-b). Product + security call. | 30 min discussion | 🟢 future |
| **FU-6 (lint)** | Extend [CCS] `/w-codecheck` to flag inline `SELECT is_admin` when a helper exists | included in [CCS] | 🟢 preventive |

**Each FU is an independent PR-sized piece.** None are blockers for COMMUNITY-RESOURCES P8, DEPLOYMENT, or any active block. Recommend scheduling FU-3 + FU-4 as a "ROLE-AUDIT drain" conv (combined ~1.5 hr), and FU-1 + FU-2 separately as they touch UI and warrant browser verification.

---

## What this audit did **not** cover

- **Tests.** Not scoped. Tests *should* exercise role gates, but a "does test coverage match the role matrix" question is distinct from "is role state sourced correctly" — filing as potential [TC-ROLE] follow-up if the user wants it.
- **Email templates** (`src/emails/Session*.tsx`) — they reference roles for template rendering but don't gate access. Out of scope.
- **Admin-intel layer** (`src/components/admin-intel/**`) — reviewed, all consumers correctly gate on `currentUser?.isAdmin` from `useCurrentUser()`.
- **Smart-feed scoring** (`src/lib/smart-feed/**`) — role references are data inputs to the ranker, not access control. Out of scope.
- **PLATO scenarios** — test harness role setup. Out of scope.

---

## Conclusion

The codebase is in **materially better shape** than the ROLE-AUDIT block's framing suggested when opened in Conv 119. The `COMMUNITY-TEACHER-KILL` + `CURRENTUSER` blocks did most of the structural work. What remains is **DRY refactors** and **two minor client migrations**, none of which block product work.

**Recommendation:** close ROLE-AUDIT as "audit complete, no structural fixes required." Spawn FU-3 + FU-4 as a single drain task, and FU-1 as a quiet-conv task. FU-2 stands on its own as SSR hygiene work.

*Produced by Conv 123. Audit scope and categorization are Claude-generated — spot-check the A.1/A.2 self-view claim against actual `UserProfile.tsx` logic before migration.*
