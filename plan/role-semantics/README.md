# ROLE-SEMANTICS

**Status:** ✅ CORE CLOSED (Conv 253) + centralization fully closed (Conv 254) — rule decided + foundation (Conv 252); `[RS-HYBRID-FLIP]`, `[RS-SQL-SWEEP]`, the Tier-3 display-axis fix, and `[RS-MOD-FRAG]` (moderator fragment) all done. **No standalone work remains.** The only open deliverable is the incremental call-site migration (deliverable 4, ~93/68/55 `canX` refs), delegated to `[RTMIG-4]`/`[ROLE-STUDIOS]` ports (touched as each surface is ported). **Origin:** surfaced during the [RTMIG-TIER] cluster-5 review — the `/old/creator/[handle]` page gates "is a creator" on `can_create_courses = 1` (permission) while the spun-out SSR loader uses `EXISTS course` (behavioral). That one divergence turned out to be an instance of a site-wide missing canonical definition.

### Canonical rule (DECIDED Conv 252) — split the two axes by purpose

Do **not** collapse to one definition. The 3-definitions hazard was call-sites conflating *access* with *identity*; the fix is to keep both axes explicit and route each to its purpose:

| Axis | Getter | Source | Gates |
|------|--------|--------|-------|
| **Capability** | `canCreateCourses`, `canTeachCourses`, `canModerateCourses` | permission flags | **actions** (Create-Course button, Book) |
| **Identity** | `isCreator`, `isTeacher`, `isStudent`, `isModerator`, `isAdmin` | behavioral/derived (moderator/admin = assigned) | **nav, workspace routing, progression nudges** |

Per-role identity: `isCreator`=`hasCreatedCourses()` (≥1 created); `isTeacher`=`isActiveTeacher()` (≥1 active cert); `isStudent`=≥1 enrollment; `isModerator`=`canModerateCourses` OR community-scoped (assigned, not earned); `isAdmin`=permission. **Nudge gating consumes this:** teacher→creator nudge fires on `isTeacher && !isCreator` (→ "create your first course" if `canCreateCourses`, else "apply" → `/creating/apply`).

**Done Conv 252 (durable foundation):**
- **Client identity:** canonical `get isCreator/isTeacher/isStudent/isModerator` getters on `src/lib/current-user.ts` (JSDoc'd with the axis rule); `tests/lib/current-user-role-identity.test.ts` (12 tests).
- **Server identity:** canonical `isCreatorSubquery(userRef)` / `isTeacherSubquery(userRef)` SQL fragments in `src/lib/roles.ts` (pure strings — no DB import, client-bundle-safe); `tests/lib/roles-sql.test.ts` (3 tests). Migrated **6 pure-behavioral inline sites** (7 instances) to the fragments — zero behavior change (`/api/me/availability` ×2, `/api/me/settings`, `/api/leaderboard`, `/api/admin/users/index` + `[id]`, `/api/teachers/[id]/availability`). tsc + lint clean; leaderboard API test (real SQL) green.

🔴 **Scope finding (Conv 252):** the inline duplication is **~15+ more sites**, and in **two definitions** — pure-behavioral `(SELECT COUNT(*)>0 FROM courses…)` AND **hybrid** `(u.can_create_courses = 1 OR (SELECT COUNT(*)>0 …))`. The hybrid form is permission-OR-behavioral — it **violates the decided identity rule**. So the remainder splits:
- **(mechanical)** pure-behavioral inline sites (`creator-analytics*`, `teacher-students`, `teacher-sessions`, `teacher-earnings`, `certificates/recommend`, …) → swap to the fragments, zero behavior change.
- **(behavior-changing)** hybrid sites (`creator-dashboard`, `me/courses/index`, `me/communities/index`, …) → see the audit + resolution below.

### Blast-radius audit + resolution (DECIDED Conv 252 — 3 parallel Explore sweeps)

A full read-only sweep (server SQL, client `CurrentUser` call-sites, `roles.ts`/display/middleware) found the radius is **bounded** and most surfaces are already behavioral. The migration targets, tiered:

| Tier | Sites | Disposition |
|------|-------|-------------|
| **1 — act** | Server 3 hybrid gates (`me/creator-dashboard.ts:96`, `me/courses/index.ts:82`, `me/communities/index.ts:64`); client `useCreatorGate.ts:41` (gates all 5 `/creating` workspace comps; **shadows** the new getter), `ContextActionsPanel.tsx:80` (permission-as-identity) | ✅ **DONE Conv 253** (`[RS-HYBRID-FLIP]`) — decision A applied (below) |
| **2 — evaporates** | `DashboardLinks.tsx:28/35` + `UnifiedDashboard.tsx:53/65` (4 mismatches) | **No work** — in `unified/`, retired by Phase 3 |
| **3 — reconcile** | `roles.ts userRoles()/describeRoles()` → Sidebar label (the ONLY visible display change); `getUserRoles()` → JWT `session.roles` | Display + security (below) |
| **4 — cosmetic/mechanical** | ~17 inline-behavioral SQL → fragments (`[RS-SQL-SWEEP]`); ~5 already-behavioral client sites not yet on the `.isCreator` getter; `old/creator/[handle]` permission-only (dies with `/old`) | Low priority |

**DECISION A — split each Tier-1 hybrid site by PURPOSE (not "flip to behavioral"):**
- **Access** (the `if(!is_creator)→403` gates + `useCreatorGate`) → gate on **`canCreateCourses`** (capability). A granted creator with 0 live courses **keeps access** → empty-state "create your first course" dashboard. No 403 cliff.
- **Identity / badge / nav-label / nudge** → **`isCreator`** (behavioral). 0 courses ⇒ no Creator badge yet; teacher→creator nudge fires until first course ships.
- So `[RS-HYBRID-FLIP]` = "route each site to the correct axis," which *minimizes* behavior change (the naive hybrid→behavioral flip would have 403'd approved-but-0-course creators — caught by re-examining).

**✅ `[RS-HYBRID-FLIP]` DONE (Conv 253):** all 5 Tier-1 sites flipped per decision A. The 3 server gates (`creator-dashboard`, `me/courses`, `me/communities`) + client `useCreatorGate` now gate **access** on `can_create_courses` capability only (hybrid `(can OR has)` dropped; `useCreatorGate` keeps `hasCourses` for empty-state UX, not access). The only behavior change: a **revoked ex-creator with live courses now 403s** (the accepted edge, line 115) — encoded by flipping 4 tests (the 3 "Pattern C → 200" endpoint tests + the useCreatorGate has-courses test → the not-creator/403 contract). 🔴 **Bonus finding:** `ContextActionsPanel.tsx:80-81` fed `is_creator`/`is_teacher` into `getActionsForContext`, but the registry **never read them** (creator/teacher actions gate on `entityData.isOwner`/`isAssignedST`) — dead pass-throughs, removed from both the call-site and the registry signature. Gates Conv 253: tsc ✅ / full test 6472/6472 ✅ / lint ✅. **Unblocks `[ROLE-STUDIOS]`.** Remainder of ROLE-SEMANTICS = `[RS-SQL-SWEEP]` (mechanical) + Tier-3 `roles.ts userRoles()` axis fix.

**✅ `[RS-SQL-SWEEP]` core DONE (Conv 253):** swept **18 files / 24 instances** of the inline scalar identity projection (`(SELECT COUNT(*) > 0 …) as is_creator/is_teacher`, ref `u.id`) → `isCreatorSubquery('u.id')` / `isTeacherSubquery('u.id')`, zero behavior change (each fragment emits the identical SQL). Files: the 8 `creator-analytics*`, `me/availability/overrides`, `me/payouts/request`, `users/[handle]`, `users/index`, `members/index`, `stripe/connect`, `me/teacher-{students,sessions,earnings}`, `me/certificates/recommend`. Per-file import of only the used fragment(s) (lint-clean). ⚠️ **Look-alike preserved:** `members/index.ts:176 has_active_courses` (`… IS NULL AND c.is_active = 1`) is a *different* predicate ("has a live course" ≠ identity) — left inline. Gates: tsc ✅ / full test 6472/6472 ✅ / lint ✅.
- **✅ EXISTS tail DONE (Conv 253):** converted **16 instances** of `EXISTS(SELECT 1 … deleted_at IS NULL)` / `NOT EXISTS` identity filters in WHERE clauses → the COUNT(*)>0 fragments (decision: reuse existing fragments, not add EXISTS-form variants — one fragment form across all sites; SQLite `(SELECT COUNT(*)>0 …)` ≡ `EXISTS(…)`, short-circuit perf delta moot at 2-user scale). Files: `ssr/loaders/{creators,home,teachers}`, `creators/[handle]`, `creators/[id]/courses`, `admin/analytics/{courses,users}` (incl. 3 `NOT EXISTS` analytics buckets w/ outer refs `u2/u3/u4.id`), `admin/users/index`, `members/index`, `leaderboard`, `users/index`. JS-string-literal sites became fragment calls (`conditions.push(isCreatorSubquery('u.id'))`). Gates: tsc ✅ / full test 6472/6472 ✅ / lint ✅.
- **⛔ Left inline (correct):** `is_active = 1` EXISTS variants (`creators.ts:44`, `users/index:78`, `creators/index:43` — "has a *live* course" ≠ identity); `teacher-students:201` (course-scoped `is_certified`).
- **✅ `[RS-MOD-FRAG]` DONE (Conv 254):** added `isCommunityModeratorSubquery(userRef)` fragment to `roles.ts` (`(SELECT COUNT(*) > 0 FROM community_moderators cm WHERE cm.user_id = … AND cm.is_active = 1)`; doc-comment distinguishes it from the `can_moderate_courses` permission *label*). Centralized both inline `community_moderators` sites in `members/index.ts` — the `:121` EXISTS filter AND the `:180` `COUNT(*)>0` projection (one scalar fragment serves both filter + projection positions in SQLite). Name chosen `isCommunityModeratorSubquery` (not `isModeratorSubquery`) — the Moderator role *label* reads `can_moderate_courses`, this fragment reads the behavioral `community_moderators` table; the `[MOD-NAV]` nav signal also reuses it. Gates: tsc ✅ / lint ✅ / members tests 26/26 ✅. **Closes the ROLE-SEMANTICS centralization fully.**

**✅ Tier-3 axis fix DONE (Conv 253):** the role **LABEL** path (`roles.ts userRoles`/`describeRoles` → Sidebar profile row in `AppLayout.astro`) now reads behavioral `is_creator`/`is_teacher` (via the fragments in the Sidebar SQL) instead of `can_create_courses`/`can_teach_courses`. Admin/Moderator stay assigned; Student stays the permission base. This **closes a live inconsistency**: a granted-but-0-course creator previously read "Creator" in the Sidebar but had no Creator badge on their profile header (which was already behavioral) — now both agree. New `tests/lib/roles-labels.test.ts` (7 tests) locks the axis rule + the regression. **JWT `getUserRoles` (db/types.ts) deliberately left permission-based** — `requireRole` only gates `['admin']` (audited: zero creator/teacher/moderator gates), so it's security-neutral, and a behavioral value there would be a stale login-time snapshot; doc-comment added marking it not-for-display. Gates: tsc ✅ / astro check 0·0·0 ✅ / lint ✅ / full test 6479/6479 ✅.

**Security rule (banked):** `getUserRoles()` bakes a **permission-based** `roles` array into the JWT; `requireRole` today only checks `['admin']`/`['moderator']` (assigned), so the identity change is **security-neutral now**. ⚠️ **Never gate a route on `requireRole(['creator'])`/`['teacher']`** without first making `getUserRoles` behavioral — else it reads the stale permission flag.

**Edge (narrow, noted):** `can_create_courses` is admin-revocable while courses still exist → a revoked ex-creator loses `/creating` access (intended: revocation removes management) but `isCreator` (behavioral) still shows the badge. **Default:** accept it (badge = "was a creator," access denied); revisit only if orphaned-course management becomes an issue.

**Problem — two axes exist, applied inconsistently:**

- **Permission ("CAN", admin-controlled, schema flags):** `can_create_courses`, `can_take_courses` (default 1), `can_teach_courses`, `can_moderate_courses`, `is_admin`, `email_verified` → on `CurrentUser` as `canCreateCourses` / `canTeachCourses` / `canModerateCourses` / `isAdmin`.
- **Behavioral state ("HAS/IS", derived):** `hasCreatedCourses()` (`createdCourses.size > 0`), `isActiveTeacher()` (≥1 active cert), course-scoped `isCreatorFor` / `isTeacherFor` / `isStudentFor` / `hasCompletedCourse`. Code comments already say *"State check, not permission."*

**🔴 The hazard — "is a creator" has THREE definitions in active use, so the same `is_creator` field means different things by code path:**

| Definition | Call-sites |
|------------|-----------|
| Permission (`canCreateCourses`) | `ContextActionsPanel` (`is_creator: user.canCreateCourses`), `AppNavbar` capability gates, inline `/old/creator/[handle]` |
| Behavioral (`hasCreatedCourses()` / `EXISTS course`) | `PublicProfile`, `ExploreCourses`, `RolePillFilters`, `CoursesRoleTabs`, the creator SSR loader, `/api/me/availability`, `/api/me/settings` |
| Hybrid (`can \|\| has`) | `useCreatorGate`, `DashboardLinks`, `UnifiedDashboard` |

**Other findings:** naming asymmetry (`hasCreatedCourses()` vs `isActiveTeacher()` for the same concept); no canonical source (`/api/me/availability` + `/api/me/settings` recompute via duplicated inline SQL subqueries); scale ≈ 93 `can_create*` refs, 68 `can_teach*`, 55 `isActiveTeacher`/cert-EXISTS.

**Deliverables:**
1. ✅ Decide, per role, what "is a {role}" means + document the rule — DONE (canonical rule above).
2. ✅ Consistent `canX` (permission) + `isX` (identity) pair per role — DONE (getters on `CurrentUser`).
3. ✅ ONE derivation: canonical `CurrentUser` getters + server SQL fragments — DONE. The inline identity-SQL sites (`/api/me/*` + others) are migrated to the fragments via `[RS-SQL-SWEEP]` (Conv 253: 24 scalar projections + 16 EXISTS filters across 29 files) and `[RS-MOD-FRAG]` (Conv 254: `isCommunityModeratorSubquery` + 2 `members/index` sites). All identity predicates now centralized.
4. ⏳ Migrate the competing **call-sites** (~93 `can_create*` / 68 `can_teach*` / 55 cert-EXISTS refs; the 3-definition table) to the canonical getters — REMAINING, **incremental** (absorbed as Phase-2 workspace ports touch each surface; NOT a 200-ref big-bang). The Tier-3 `roles.ts userRoles()`/`describeRoles()`/Sidebar-label axis fix is ✅ DONE (Conv 253 — now behavioral; JWT `getUserRoles` deliberately left permission-based + documented). **Conv 315 — the RG-PUBPROF-blocking residue cleared:** (a) `fetchCreatorProfileData` (`ssr/loaders/creators.ts`) now SELECTs + maps `courses.primary_topic_id` (was hardcoded `null`; column exists schema L347 — RG-PUBPROF-preparatory, no live consumer yet so browser-verify rides the loader's adoption); (b) `UserProfileHeader` role badges now delegate to canonical `userRoles()` (was re-implementing inline — behavior-preserving DRY). tsc/lint clean. This **unblocks [RG-PUBPROF]** in the route sweep (the predicate was already canonical — these were the last two ad-hoc spots).

**Relationships:** [RTMIG-4] cluster-5 creator port **consumes** the agreed rule (do not settle the loader predicate ad-hoc); resolves the `#22 [SSR-LOADER-DEAD]` creator-loader predicate question; touches `#21 [ENTITY-ANCHOR]` indirectly. Tracked in TodoWrite as `[ROLE-SEMANTICS]`. **Conv 315: the creator-loader `primary_topic_id` reconciliation (deliverable 4 above) is DONE; `[SSR-LOADER-DEAD]` + `[ENTITY-ANCHOR]` plural-slug remain RG-PUBPROF's own scope (not ROLE-SEMANTICS).**

---

_Extracted from the PLAN.md `## ROLE-SEMANTICS` section (Conv 394 [PLAN-XTRACT])._
