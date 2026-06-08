# ROUTE-MIGRATION — legacy `/old/*` → root porting backlog

**The living source of truth for [RTMIG-4]:** porting legacy `/old/*` pages to root `@matt-inspired` / `@matt-source` pages. Consult this file for what remains; it is updated as each route is ported.

> Generated **Conv 249** from a full `src/pages` audit: **97 legacy `.astro` pages = 44 ported · 1 dropped · 52 remaining**.
> Parent block: `PLAN.md § ROUTE-MIGRATION`. TodoWrite carries only the **active slice** (the `[RTMIG-4]` umbrella + the in-flight cluster) — not all 52 routes.
> Audit method: a root page "ports" a legacy route if a non-`/old` page with `@matt-inspired`/`@matt-source` covers its route, including catch-alls (`course/[slug]/[...tab]`, `community/[slug]/[...tab]`, `profile/[...tab]` folds `settings/*`) and the DISC-DROP discover→root remaps.

## Migration policy (Conv 250) — MOVE, don't copy

Porting a route **MOVES** the legacy file `/old/X` → `/X`, marks it `@stand-in`, and
commits that move as the page's legacy baseline. The `/old` copy is **NOT** retained
live. This **supersedes** the Conv-221 keep-`/old`-live rule — that rule's value
collapsed once Matt left (pages are now our own `@matt-inspired` redesigns) and the
**preflip worktree** (`peerloop-ref` → `~/projects/Peerloop-preflip` :4331) + **git
history** took over the behavioral-reference role.

- **Reference / rollback:** preflip worktree (runtime behavior) + git history (exact
  legacy file at the move commit). Rollback = `git revert`, not a live `/old` page.
- **Two-step per route:** (1) **rehost** = `git mv` + `@stand-in` marker + commit
  (restores a working route now); (2) **Matt port** = retrofit `@stand-in →
  @matt-inspired` in place, diffing field-by-field against the move-commit baseline.
- **`[PREFLIP-WT]` re-scoped:** keep alive until **client-vetting complete** (was: until
  RTMIG-4 done) — it is now the designated behavioral backstop.
- The 44 already-ported routes (Reference section below) still carry stale `/old`
  copies under the old copy-policy — now deletable per-route as follow-up cleanup.

See `memory/project_old_pages_no_delete_until_vetted.md` (revised Conv 250).

## Status legend

| Token | Meaning |
|-------|---------|
| ⬜ | Not started — legacy-only, needs a root port |
| ✅ | Ported — root `@matt` page live (note the conv) |
| 🔁 | Redirect-only — no port; route redirects to an existing root page |
| 🗑️ | Dropped — intentionally not ported |

## Summary

| # | Cluster | Routes | Notes |
|---|---------|--------|-------|
| 1 | Admin console | 14 | Largest coherent group; shares one admin shell/layout |
| 2 | Creator Studio (`creating/`) | 7 | Authenticated creator surfaces |
| 3 | Teaching hub (`teaching/`) | 7 | Authenticated teacher surfaces |
| 4 | Learning hub | 2 | Authenticated student surfaces |
| 5 | Public profiles | 3 | `/@handle`, teacher, creator |
| 6 | People listings | 2 | 🔁 redirect-to-`/members` candidates (not ports) |
| 7 | Misc app | 2 | reset-password, certificate verify |
| 8 | Public / marketing | 15 | Separate `PUBLIC-PAGES` block (deferred); low-data, redesign-likely |
| | **Total** | **52** | True RTMIG-4 *port* count ≈ 35 once cluster 6 (redirects) + cluster 8 (PUBLIC-PAGES) are set aside |

---

## 1. Admin console (14) — `/old/admin/*`

**Approach (Conv 250):** MOVE `/old/admin/*` → `/admin/*` as `@stand-in` (per the
migration policy above). Sequencing: **rehost-now, Matt-port-late.**

- **Already wired to `/admin/*`:** zero refs to `/old/admin` exist in `src/`;
  `middleware.ts` (PROTECTED_PREFIXES `/admin`), `AdminNavbar.tsx` (14 links),
  `admin-intel/admin-links.ts` (6 deep-links), `context-actions/registry.ts` (3),
  `AdminDashboardCard.tsx` (5) all point at root `/admin/*`. So the console is
  **currently broken** at `/old/admin/*` (every nav link / deep-link 404s). The move
  fixes all of them for free — **zero link rewrites**.
- **Shell is already Matt:** `AdminLayout` + `AdminNavbar` retrofitted to Matt rail +
  Matt icons (Conv 193). Admin pages are thin `.astro` wrappers mounting an island
  (e.g. `analytics.astro` → `<AdminAnalytics client:load />`); the Matt port is
  **island/body-only**, shell untouched.
- **`[ADMIN-REDIRECT-BLANK]` #12 rides along** — lives in `AdminLayout` (non-admin →
  blank 200 instead of redirect); currently dormant (nothing at `/admin/*`), goes live
  on rehost → fix as part of the rehost.
- **`/api/admin/*` endpoints unaffected** — admin *functionality* is intact; only the
  page routes are displaced.
- **Matt-port order within the cluster:** TBD when the cluster goes active for porting
  (function-first, low priority per "quite late"). Rehost order is irrelevant (mechanical).

**Rehost ✅ DONE (Conv 250 `[RTMIG-ADMIN-REHOST]`):** all 14 `git mv`'d to `/admin/*`
with `@stand-in` markers; `[ADMIN-REDIRECT-BLANK]` fixed (admin-role gate moved from the
broken `AdminLayout` redirect into `middleware.ts` + unit-tested); route map regenerated;
5 gates green (tsc 0 / astro 1337·0 / lint / test 6459 / build). The ⬜ rows below now
track the **Matt port** (late), not the rehost.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/admin` | `old/admin/index.astro` | |
| ⬜ | `/admin/analytics` | `old/admin/analytics.astro` | |
| ⬜ | `/admin/certificates` | `old/admin/certificates.astro` | |
| ⬜ | `/admin/courses` | `old/admin/courses.astro` | |
| ⬜ | `/admin/creator-applications` | `old/admin/creator-applications.astro` | |
| ⬜ | `/admin/enrollments` | `old/admin/enrollments.astro` | |
| ⬜ | `/admin/moderation` | `old/admin/moderation.astro` | |
| ⬜ | `/admin/moderators` | `old/admin/moderators.astro` | |
| ⬜ | `/admin/payouts` | `old/admin/payouts.astro` | |
| ⬜ | `/admin/recordings` | `old/admin/recordings.astro` | |
| ⬜ | `/admin/sessions` | `old/admin/sessions.astro` | |
| ⬜ | `/admin/teachers` | `old/admin/teachers.astro` | |
| ⬜ | `/admin/topics` | `old/admin/topics.astro` | |
| ⬜ | `/admin/users` | `old/admin/users.astro` | |

## 2. Creator Studio (7) — `/old/creating/*`

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/creating` | `old/creating/index.astro` | |
| ⬜ | `/creating/studio` | `old/creating/studio.astro` | |
| ⬜ | `/creating/analytics` | `old/creating/analytics.astro` | |
| ⬜ | `/creating/apply` | `old/creating/apply.astro` | |
| ⬜ | `/creating/earnings` | `old/creating/earnings.astro` | |
| ⬜ | `/creating/communities` | `old/creating/communities/index.astro` | |
| ⬜ | `/creating/communities/[slug]` | `old/creating/communities/[slug].astro` | |

## 3. Teaching hub (7) — `/old/teaching/*`

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/teaching` | `old/teaching/index.astro` | |
| ⬜ | `/teaching/analytics` | `old/teaching/analytics.astro` | |
| ⬜ | `/teaching/availability` | `old/teaching/availability.astro` | |
| ⬜ | `/teaching/courses/[courseId]` | `old/teaching/courses/[courseId].astro` | |
| ⬜ | `/teaching/earnings` | `old/teaching/earnings.astro` | |
| ⬜ | `/teaching/sessions` | `old/teaching/sessions.astro` | |
| ⬜ | `/teaching/students` | `old/teaching/students.astro` | |

## 4. Learning hub (2) — `/old/learning*`

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/learning` | `old/learning.astro` | |
| ⬜ | `/learning/sessions` | `old/learning/sessions.astro` | |

## 5. Public profiles (3)

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/@[handle]` | `old/@[handle].astro` | Public user profile (`/@me` self-alias planned) |
| ⬜ | `/teacher/[handle]` | `old/teacher/[handle]/index.astro` | Matt-designed frame exists but NOT Ready-for-Dev → port as legacy migration, not Matt-design |
| ⬜ | `/creator/[handle]` | `old/creator/[handle]/index.astro` | |

## 6. People listings (2) — 🔁 redirect-to-`/members` candidates

`/members` (Conv 223 [DRV-C]) is a unified role-filterable directory (creators · teachers · students · moderators · admins), so these likely become redirects rather than ports.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/teachers` | `old/teachers.astro` | Confirm: redirect → `/members?role=teacher` vs standalone port |
| ⬜ | `/creators` | `old/creators.astro` | Confirm: redirect → `/members?role=creator` vs standalone port |

## 7. Misc app (2)

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/reset-password` | `old/reset-password.astro` | Auth flow — like `/login`/`/signup`, may stay a standalone form page |
| ⬜ | `/verify/[id]` | `old/verify/[id].astro` | Certificate verification (public) |

## 8. Public / marketing (15) — separate `PUBLIC-PAGES` block

Tracked under PLAN.md `§ Deferred: PUBLIC-PAGES`. Low-data, public, redesign-likely — listed here for completeness but **not** part of the RTMIG-4 app-port count.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/about` | `old/about.astro` | |
| ⬜ | `/blog` | `old/blog.astro` | |
| ⬜ | `/careers` | `old/careers.astro` | |
| ⬜ | `/contact` | `old/contact.astro` | |
| ⬜ | `/cookies` | `old/cookies.astro` | |
| ⬜ | `/faq` | `old/faq.astro` | |
| ⬜ | `/for-creators` | `old/for-creators.astro` | |
| ⬜ | `/help` | `old/help.astro` | |
| ⬜ | `/how-it-works` | `old/how-it-works.astro` | |
| ⬜ | `/pricing` | `old/pricing.astro` | |
| ⬜ | `/privacy` | `old/privacy.astro` | |
| ⬜ | `/stories` | `old/stories.astro` | |
| ⬜ | `/terms` | `old/terms.astro` | |
| ⬜ | `/testimonials` | `old/testimonials.astro` | |
| ⬜ | `/become-a-teacher` | `old/become-a-teacher.astro` | |

---

## Reference: already resolved (not actionable)

**Dropped (1):** `/old/discover/leaderboard` — product decision not to port (Conv 229).

**Ported (44)** — for audit completeness; these legacy routes already have a root `@matt` page:
- **Direct:** index/dashboard→`/`, login, signup, onboarding, messages, notifications, feed, feeds, courses, profile, session/[id]
- **Catch-all:** `course/[slug]/{index,feed,learn,resources,sessions,teachers,[tab]}` → `/course/[slug]/[...tab]`; `course/[slug]/book` + `course/[slug]/success` (standalone); `community/{index,[slug]/*}` → `/communities` + `/community/[slug]/[...tab]`; `settings/*` → `/profile/[...tab]`
- **DISC-DROP remaps:** discover/{communities→/communities, courses→/courses, feeds→/feeds, members→/members, students/teachers/creators→superseded by /members, community/*, course/*, index→folded}
