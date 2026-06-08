# ROUTE-MIGRATION — legacy `/old/*` → root porting backlog

**The living source of truth for [RTMIG-4]:** porting legacy `/old/*` pages to root `@matt-inspired` / `@matt-source` pages. Consult this file for what remains; it is updated as each route is ported.

> Generated **Conv 249** from a full `src/pages` audit: **97 legacy `.astro` pages = 44 ported · 1 dropped · 52 remaining**.
> Parent block: `PLAN.md § ROUTE-MIGRATION`. TodoWrite carries only the **active slice** (the `[RTMIG-4]` umbrella + the in-flight cluster) — not all 52 routes.
> Audit method: a root page "ports" a legacy route if a non-`/old` page with `@matt-inspired`/`@matt-source` covers its route, including catch-alls (`course/[slug]/[...tab]`, `community/[slug]/[...tab]`, `profile/[...tab]` folds `settings/*`) and the DISC-DROP discover→root remaps.

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
