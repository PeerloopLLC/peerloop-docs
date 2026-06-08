# ROUTE-MIGRATION — legacy `/old/*` → root porting backlog

**The living source of truth for [RTMIG-4]:** porting legacy `/old/*` pages to root `@matt-inspired` / `@matt-source` pages. Consult this file for what remains; it is updated as each route is ported.

> Generated **Conv 249** from a full `src/pages` audit: **97 legacy `.astro` pages = 44 ported · 1 dropped · 52 remaining**.
> **Conv 251 correction:** `/old/dashboard.astro` (`UnifiedDashboard`) was wrongly counted as ported (the "index/dashboard→`/`" conflation — see the Unified Dashboard section). Corrected tally: **43 ported · 1 dropped · 53 remaining** (dashboard → root `/dashboard`, decision A).
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
| 0 | Unified Dashboard (`/dashboard`) | 1 | Cross-role command center; was mis-counted as ported (Conv-251 correction). Port — decision A. |
| 1 | Admin console | 14 | Largest coherent group; shares one admin shell/layout |
| 2 | Creator Studio (`creating/`) | 7 | Authenticated creator surfaces |
| 3 | Teaching hub (`teaching/`) | 7 | Authenticated teacher surfaces |
| 4 | Learning hub | 2 | Authenticated student surfaces |
| 5 | Public profiles | 3 | `/@handle`, teacher, creator |
| 6 | People listings | 2 | 🔁 redirect-to-`/members` candidates (not ports) |
| 7 | Misc app | 2 | reset-password, certificate verify |
| 8 | Public / marketing | 15 | Separate `PUBLIC-PAGES` block (deferred); low-data, redesign-likely |
| | **Total** | **53** | True RTMIG-4 *port* count ≈ 36 once cluster 6 (redirects) + cluster 8 (PUBLIC-PAGES) are set aside (+1 vs Conv-249's 35: the recovered `/dashboard`) |

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

## 0. Dashboard (1) — `/old/dashboard` → root `/dashboard` — **port (decision A, Conv 251)**

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/dashboard` | `old/dashboard.astro` | Cross-role command center (`UnifiedDashboard`). Port to root `/dashboard` (Matt); fix `AppNavbar.tsx:97` link; reuse role components (see anti-duplication rule + DASH-GAP map below). |


**Correction (Conv 251):** the "Ported (44)" reference line below conflated **two**
legacy pages under "index/dashboard→`/`". Only `/old/index.astro` (the legacy *home*)
was ported to root `/` (Conv 203, a deliberately *lightweight* Matt hub). **`/old/dashboard.astro`
was never ported** and is orphaned:

- It mounts `UnifiedDashboard` (orchestrator + 12 sub-components in
  `src/components/dashboard/unified/`) — an **additive cross-role command center** that
  fetches *all* of a user's active roles in parallel and composes 11 activity-first
  sections (DashboardLinks, PriorityHeader, MergedSchedule, NeedsAttention, StatsOverview,
  MergedCourses, MergedPeople, MergedCertsAvail, MergedEarnings, MyFeeds, MergedQuickActions).
- `/dashboard` is in `middleware.ts` `PROTECTED_PREFIXES` but has **no root page** →
  currently **auth-gates then 404s**. `AppNavbar.tsx:97` still links `href: '/dashboard'`
  (a live broken link). The whole `unified/` tree is reachable only via the dead
  `/old/dashboard` route.

**Disposition (decision A, Conv 251):** **port** `/old/dashboard` → root `/dashboard`
as the Matt cross-role command center. Role dashboards stay on their own routes
(`/learning`, `/teaching`, `/creating`); root `/` stays the lightweight home; fix the
AppNavbar link as part of the port.

> ⚠️ **PROVISIONAL — decision A is reopened by `[ROLE-STUDIOS]` (Conv 251).** The next-conv
> design exploration weighs a *combined* `/dashboard` vs *per-role dashboards* with
> Creator/Teacher Studios as SubNavBar workspaces. Do not build `/dashboard` until that
> resolves. See PLAN.md § ROLE-STUDIOS.

**Anti-duplication rule for clusters 2/3/4 (why the overlap notes below exist):**
`UnifiedDashboard` is a **summary layer** that already **reuses the role-dashboard
components** (`EnrollmentCard`, `CreatorCourseCard`, `EarningsOverview`,
`CertificatesSection`, `AvailabilityQuickView`, `TeacherCertifications`,
`QuickActionButton`, `DashboardStatCard`) and the same APIs (`/api/me/teacher-dashboard`,
`/api/me/creator-dashboard`, `/api/sessions`). When `/dashboard` **and** the role routes
are Matt-ported, they MUST share the **same** Matt-ported components — do **not** rebuild a
second copy. The per-route `↔ /dashboard §N` notes below mark exactly where each role
route's content is summarized by a `/dashboard` section.

### DASH-GAP results (Conv 251) — what the role routes have that `/dashboard` does NOT

Full read of all three role hubs + every cluster-2/3/4 sub-route mount + the `Merged*`
sections. Two kinds of gap: **(a) hub-level** content the role *index* shows that the
`/dashboard` summary drops, and **(b) sub-route** surfaces `/dashboard` has *nothing* for.

**(a) Hub-level gaps — present on `/learning`,`/teaching`,`/creating`, MISSING from `/dashboard`:**

| Role hub | Omitted by /dashboard summary | Why it matters |
|----------|-------------------------------|----------------|
| `/learning` (StudentDashboard) | **Join-Now affordance** (15-min pre-start window → green "Join Now" vs "View"); **completed-courses** as its own section (MergedCourses folds completed into a "view all" link); **empty state** ("No courses yet" → Browse CTA) | Live-session entry is the student's primary action; /dashboard §MergedSchedule lists but doesn't surface the join window. |
| `/teaching` (TeacherDashboard) | **Availability TOGGLE** in header (interactive `is_available` setter); **sessions-this-week** in greeting; **`past_students`** list; **View Profile** link | The toggle is a stateful action absent from /dashboard's read-only §PriorityHeader/§MergedCertsAvail. |
| `/creating` (CreatorDashboard) | **Create Course** CTA (header + empty state); **`CreatorTeachingSummary`** (creator-who-also-teaches block); **`past_teachers`** list; not-creator gate state | Primary creator action (create course) and the also-teaches summary have no /dashboard equivalent. |

Shared: `MergedPeople` omits **past** students/teachers (hubs show them); `MergedSchedule`
shows top-3 **upcoming** only (no history / no Join-Now styling).

**(b) Sub-route UNIQUE surfaces — `/dashboard` has NO equivalent (full port required):**

| Route | Mounts | Nature |
|-------|--------|--------|
| `/teaching/analytics` | `TeacherAnalytics` | Deep analytics (vs §StatsOverview cards) |
| `/teaching/availability` | `AvailabilityCalendar` | Full editor (vs read-only `AvailabilityQuickView`) |
| `/teaching/earnings` | `EarningsDetail` | Full ledger (vs `EarningsOverview` summary) |
| `/teaching/sessions` | `TeacherSessionsList` | Full history (vs top-3 upcoming) |
| `/teaching/students` | `MyStudents` | Full roster (vs §MergedPeople summary) |
| `/teaching/courses/[courseId]` | per-course workspace | Course detail — no summary equivalent |
| `/creating/studio` | `CreatorStudio` | Course editor — no summary equivalent |
| `/creating/analytics` | `CreatorAnalytics` | Deep analytics (vs §StatsOverview cards) |
| `/creating/apply` | `CreatorApplicationForm` | Application flow — no summary equivalent |
| `/creating/communities` | `CreatorCommunities` | Community mgmt list — no summary equivalent |
| `/creating/communities/[slug]` | `CommunityManagement` | Community detail — no summary equivalent |
| `/learning/sessions` | `StudentSessionsList` | Full session history (vs top-3 upcoming) |

**Port implications:**
1. `/dashboard` port must **reuse** the shared components (`EnrollmentCard`, `CreatorCourseCard`, `EarningsOverview`, `CertificatesSection`, `AvailabilityQuickView`, `TeacherCertifications`, `QuickActionButton`, `DashboardStatCard`) Matt-ported **once** — not rebuilt per surface.
2. Cluster 2/3/4 hub ports must **preserve the (a) gaps** above (Join-Now, availability toggle, Create-Course CTA, past-people lists, empty states) — the summary is not a substitute.
3. Every (b) sub-route is a standalone full port (no overlap shortcut).

## 2. Creator Studio (7) — `/old/creating/*`

> **Disposition (Conv 251): NOT mechanically ported.** The (a) hub differentiators fold into the dashboard(s); the (b) deep surfaces (studio/analytics/earnings/communities) consolidate into a **Creator Studio** — pending the `[ROLE-STUDIOS]` exploration. **`/old/creating/*` stays live** as the build reference until the studio lands; revisit only on client request. (`/creating/apply` is a become-a-creator pre-flow, not a studio surface.)

**Shell now:** legacy `@layouts/old/AppLayout.astro` (NOT Matt — unlike admin). **Wiring:**
zero `/old/creating` refs anywhere; all internal links already point at root `/creating/*`
(CreatorDashboard, context-actions registry, approval email, CreatorApplicationForm), so
the routes are **currently broken (404)** and a `git mv` rehost fixes them for free.
Already in `PROTECTED_PREFIXES`. Role hub = `/creating` mounts `CreatorDashboard`.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/creating` | `old/creating/index.astro` | `CreatorDashboard` hub. **↔ /dashboard** §StatsOverview (creator stats), §MergedCourses (Created), §MergedPeople (My Teachers), §MergedEarnings (creator), §NeedsAttention (apps/certs/homework), §MergedQuickActions. /dashboard summarizes; this is the full creator hub — share components. |
| ⬜ | `/creating/studio` | `old/creating/studio.astro` | **UNIQUE** — full course editor. /dashboard only *links* to it (§MergedQuickActions "Creator Studio"); no content overlap. |
| ⬜ | `/creating/analytics` | `old/creating/analytics.astro` | **↔ /dashboard** §StatsOverview (creator stats summary). Full analytics is deeper here. |
| ⬜ | `/creating/apply` | `old/creating/apply.astro` | **UNIQUE** — creator application flow. No /dashboard overlap. |
| ⬜ | `/creating/earnings` | `old/creating/earnings.astro` | **↔ /dashboard** §MergedEarnings (creator side, `EarningsOverview` summary). Full earnings page deeper — reuse `EarningsOverview`. |
| ⬜ | `/creating/communities` | `old/creating/communities/index.astro` | **UNIQUE** (mostly) — community management list. /dashboard §MergedQuickActions links "My Communities". |
| ⬜ | `/creating/communities/[slug]` | `old/creating/communities/[slug].astro` | **UNIQUE** — community detail/management. No /dashboard overlap. |

## 3. Teaching hub (7) — `/old/teaching/*`

> **Disposition (Conv 251): NOT mechanically ported.** (a) differentiators fold into the dashboard(s); (b) deep surfaces (analytics/availability/courses/earnings/sessions/students) consolidate into a **Teacher Studio** — pending the `[ROLE-STUDIOS]` exploration. **`/old/teaching/*` stays live** as the build reference until the studio lands; revisit only on client request.

**Shell now:** legacy `@layouts/old/AppLayout.astro`. **Wiring:** zero `/old/teaching`
refs; all links point at root `/teaching/*` (TeacherDashboard, context-actions, dashboards)
→ **currently broken (404)**, rehost fixes free. Already in `PROTECTED_PREFIXES`. Role hub =
`/teaching` mounts `TeacherDashboard`.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/teaching` | `old/teaching/index.astro` | `TeacherDashboard` hub. **↔ /dashboard** §PriorityHeader (next session), §MergedSchedule (teaching), §NeedsAttention (cert recs/intros/homework), §StatsOverview (teacher), §MergedPeople (My Students), §MergedCertsAvail (avail+certs), §MergedEarnings (teacher). /dashboard aggregates; full hub here — share components. |
| ⬜ | `/teaching/analytics` | `old/teaching/analytics.astro` | **↔ /dashboard** §StatsOverview (teacher stats summary). |
| ⬜ | `/teaching/availability` | `old/teaching/availability.astro` | **↔ /dashboard** §MergedCertsAvail (`AvailabilityQuickView`, read-only). **UNIQUE** = full availability editor — reuse the quick-view component. |
| ⬜ | `/teaching/courses/[courseId]` | `old/teaching/courses/[courseId].astro` | **↔ /dashboard** §MergedCourses (Teaching list). **UNIQUE** = per-course detail. |
| ⬜ | `/teaching/earnings` | `old/teaching/earnings.astro` | **↔ /dashboard** §MergedEarnings (teacher side, `EarningsOverview` summary). Full page deeper — reuse `EarningsOverview`. |
| ⬜ | `/teaching/sessions` | `old/teaching/sessions.astro` | **↔ /dashboard** §MergedSchedule (teaching sessions, top-3). Full list here. |
| ⬜ | `/teaching/students` | `old/teaching/students.astro` | **↔ /dashboard** §MergedPeople (My Students summary). **UNIQUE** = full `MyStudents`. |

## 4. Learning hub (2) — `/old/learning*`

> **Disposition (Conv 251): NOT mechanically ported.** (a) differentiators fold into the dashboard(s). **Open in `[ROLE-STUDIOS]`:** does the student get its own **Learning** workspace, or fold into `/dashboard` + `/courses`? **`/old/learning*` stays live** until resolved; revisit only on client request.

**Shell now:** legacy `@layouts/old/AppLayout.astro`. **Wiring:** zero `/old/learning`
refs; all links point at root `/learning*` (StudentDashboard, booking, AppHeader) →
**currently broken (404)**, rehost fixes free. Already in `PROTECTED_PREFIXES`. Role hub =
`/learning` mounts `StudentDashboard`.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/learning` | `old/learning.astro` | `StudentDashboard` hub. **↔ /dashboard** §MergedSchedule (student sessions), §MergedCourses (Enrolled), §MergedPeople (My Teachers), §MergedCertsAvail (Certificates earned), §StatsOverview (student), §NeedsAttention (courses needing review), §MergedQuickActions. /dashboard summarizes; full student hub here — share components. |
| ⬜ | `/learning/sessions` | `old/learning/sessions.astro` | **↔ /dashboard** §MergedSchedule (student sessions, top-3). Full list here. |

## 5. Public profiles (3) — **hub + spoke** (port all three, Conv 251)

**Not redundant — it's a hub-and-spoke set** (the same shape as cluster 0 `/dashboard` : role dashboards). `/@[handle]` is the **universal hub**: `PublicProfile` carries `is_creator`/`is_teacher` and renders **role teasers** (`CreatorTeaser`/`TeacherTeaser`) that link OUT to the deep role views.

```
/@[handle]  (universal hub — bio + role teasers)
   ├─ TeacherTeaser → /teacher/[handle]   (deep: courses, availability, booking)
   └─ CreatorTeaser → /creator/[handle]   (deep: created courses, qualifications)
```

**Wiring:** `/members` `MemberCard` + `UserCard` + `MergedPeople` + `TeacherCourseView` link to `/@${handle}` (the hub, 404-honest until ported). `TeacherCard`/`TeacherTeaser` → `/teacher/[handle]`; `CreatorTeaser` → `/creator/[handle]`. Shell: all on legacy `@layouts/old/AppLayout.astro` (`@stand-in` after move).

**Loader directive (A, adopt — Conv 251):** `/teacher|creator/[handle]` currently do **inline** D1 queries; faithful `fetchTeacherProfileData`/`fetchCreatorProfileData` loaders exist (dead — this is `#22`). Adopt them at port time. Teacher loader = **drop-in** (identical to inline). Creator loader needs reconciliation: **(a)** restore `primary_topic_id` (loader drops it → `null`); **(b)** the creator-detection predicate (`can_create_courses=1` vs `EXISTS course`) is **NOT decided here** — it is owned by **`[ROLE-SEMANTICS]`** (PLAN.md); the port consumes that rule.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/@[handle]` | `old/@[handle].astro` | Universal hub. `PublicProfile` island. **Preserve `/@me` self-redirect + role teasers.** `is_creator`/`is_teacher` derivation → per `[ROLE-SEMANTICS]`. |
| ⬜ | `/teacher/[handle]` | `old/teacher/[handle]/index.astro` | Deep teacher view. Matt frame exists but **NOT Ready-for-Dev** → port as legacy migration (`@stand-in`→`@matt-inspired`, not `@matt-source`). Adopt `fetchTeacherProfileData` (drop-in). **`#21 [ENTITY-ANCHOR]` fix lands here** (`StudentTeacherAnchor` → `/teacher/${handle}` singular). |
| ⬜ | `/creator/[handle]` | `old/creator/[handle]/index.astro` | Deep creator view. Adopt `fetchCreatorProfileData` with reconciliation (restore `primary_topic_id`; predicate per `[ROLE-SEMANTICS]`). `#21` `CreatorAnchor` → `/creator/${handle}`. |

## 6. People listings (2) — 🗑️ **DELETED (Conv 251, decision B)**

Both legacy pages were empty **"Coming soon." stubs** (never built), and `/members`
(Conv 223 [DRV-C]) already supersedes them as the unified role-filterable directory
(creators · teachers · students · moderators · admins) with a `?roles=` deep-link.
Per the pre-production "no redirects" rule, the stubs were **deleted** (not redirected)
and all internal referrers repointed **directly** at `/members?roles=…`.

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| 🗑️ | `/teachers` | ~~`old/teachers.astro`~~ | Deleted. Referrers repointed → `/members?roles=teacher` (Footer "Find Teachers", `TeacherProfile` back-link + breadcrumb). |
| 🗑️ | `/creators` | ~~`old/creators.astro`~~ | Deleted. Referrers repointed → `/members?roles=creator` (Footer "Find Creators", `CreatorProfile` back-link + breadcrumb, `FeaturedCreators` ×2, `for-creators/HeroSection`). |

**Conv 251 deletion record:** 2 stub pages `git rm`'d; 8 internal links repointed to
`/members?roles=…`; no remaining bare `/teachers`/`/creators` page-links in `src`. Two
related follow-ups tracked: **`[ENTITY-ANCHOR]`** (plural-slug profile-link bug, deferred
to cluster 5) and **`[SSR-LOADER-DEAD]`** (pre-existing uncalled listing loaders
`fetchTeacherDirectoryData`/`fetchCreatorListData`).

## 7. Misc app (2)

Both already in `PUBLIC_PREFIXES` (`/reset-password`, `/verify/`). Dispositions (Conv 251):

| Status | Route | Legacy file | Notes / instructions |
|--------|-------|-------------|----------------------|
| ⬜ | `/reset-password` | `old/reset-password.astro` | **Port** (standalone auth form, like `/login`/`/signup`). Mounts `PasswordResetForm` (client island, multi-state form → "check your email"). Directives: swap legacy `AppLayout` → the Matt auth/standalone shell; Matt-style `PasswordResetForm`; **preserve** the multi-state flow + the future `?token=xyz` reset path + the login-modal/settings entry points. |
| ⬜ | `/verify/[id]` | `old/verify/[id].astro` | **Port** (public, externally-shareable certificate verification). **Keep SSR** — no client island; data via `fetchCertificateVerifyData`. Directives (Conv 251): **(A)** render in a **minimal branded standalone** shell (logo + card, no app/marketing chrome — it's an external landing target); **(B)** **extract a reusable `StatusBadge` primitive** (verified=green / revoked=red) — no `ui/Badge` exists today; **(C)** keep the **3 states** (verified / revoked / not-found), defer share affordances (copy-link/print/LinkedIn). Reuse `Card.astro` (container), `UserAvatar` (identity), `EmptyState.astro` (not-found). Preserve links to `/course/[slug]`, `/@[handle]` (creator), issuer name. |

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

**Ported (43)** — for audit completeness; these legacy routes already have a root `@matt` page:
- **Direct:** index→`/` (legacy *home* only — **NOT** `/old/dashboard`; see Conv-251 correction in the Unified Dashboard section), login, signup, onboarding, messages, notifications, feed, feeds, courses, profile, session/[id]
- **Catch-all:** `course/[slug]/{index,feed,learn,resources,sessions,teachers,[tab]}` → `/course/[slug]/[...tab]`; `course/[slug]/book` + `course/[slug]/success` (standalone); `community/{index,[slug]/*}` → `/communities` + `/community/[slug]/[...tab]`; `settings/*` → `/profile/[...tab]`
- **DISC-DROP remaps:** discover/{communities→/communities, courses→/courses, feeds→/feeds, members→/members, students/teachers/creators→superseded by /members, community/*, course/*, index→folded}
