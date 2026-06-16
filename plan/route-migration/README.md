# ROUTE-MIGRATION — route-group homes for [RTMIG-4]

**The living source of truth for [RTMIG-4]:** porting legacy `/old/*` pages to root
`@matt-inspired` / `@matt-source` pages, organized by **route group**. Each group is a
"home" that owns its port work, its bugs, and its restyle follow-ups, and maps to a
TodoWrite code. Consult this file for what remains; update it as each route is ported.

> **Reconciled Conv 290** against the live `src/pages` tree. The Conv-249 generation
> (and its "53 remaining" count) was materially stale — most of the 79 `/old/*` files are
> already-ported **stale copies** ([OLD-PORTED-CLEANUP]) or owned by **other blocks**
> (ROLE-STUDIOS, PUBLIC-PAGES). The genuinely-unported, RTMIG-owned port work is small:
> **public profiles (3) + misc app (2) + admin Tier-1 (14 @stand-in bodies)**.
>
> Parent block: `PLAN.md § ROUTE-MIGRATION`. The TodoWrite umbrella is **[RTMIG-4]**;
> its children + the per-family homes are the route groups below.

## Migration policy (Conv 250) — MOVE, don't copy

Porting a route **MOVES** the legacy file `/old/X` → `/X`, marks it `@stand-in`, and
commits that move as the page's legacy baseline. The `/old` copy is **NOT** retained live.
Reference / rollback = the **preflip worktree** (`peerloop-ref` → `~/projects/Peerloop-preflip`
:4331, runtime behavior) + **git history** (exact legacy file at the move commit).
`[PREFLIP-WT]` stays alive until **client-vetting complete**.

**Two-step per route:** (1) **rehost** = `git mv` + `@stand-in` + commit (restores the
route now); (2) **Matt port** = retrofit `@stand-in → @matt-inspired` in place, diffing
field-by-field against the move-commit baseline (port = faithful function+content AND full
Matt styling; re-skin while dropping behavior = a failed port).

## Tier-1 / Tier-2 (per `docs/decisions/11-new-routing.md:445`)

Tier is **not** a per-cluster bucket — every remaining cluster is **Tier-1**.

- **Tier-1 (do now):** Matt shell + SubNavbar + tokens + swap to *existing* vetted
  primitives + 404-honest routing.
- **Tier-2 (deferred):** extract *new* primitives / extend existing ones — a cross-cutting
  Rule-of-Three consolidation pass, not a per-page phase. (e.g. `/verify/[id]`'s
  `StatusBadge` → inline in Tier-1, extract in Tier-2.)

## Status legend

| Token | Meaning |
|-------|---------|
| ⬜ | Not started — legacy-only, needs a root port |
| 🟦 | At root as `@stand-in` — rehosted, awaiting Tier-1 Matt port |
| ✅ | Ported — root `@matt` page live |
| 🔁 | Redirect-only |
| 🗑️ | Dropped / deleted — intentionally not ported |

## Route-group home summary

| RG | Home (TodoWrite) | Routes | Port state | What remains |
|----|------------------|--------|-----------|--------------|
| RG-0 | **[RTMIG-4]** #3 | umbrella | — | parent over RG-1/2/3 + cleanup |
| RG-1 | **[RTMIG-ADMIN]** #30 | `/admin/*` (14) | 🟦 rehosted | Tier-1 Matt port of 14 `@stand-in` bodies |
| RG-2 | **[RTMIG-PROFILES]** #31 | `/@[handle]`, `/teacher/[handle]`, `/creator/[handle]` | ⬜ | **port all 3** (blocked by [ROLE-SEMANTICS] #33) |
| RG-3 | **[RTMIG-MISC]** #32 | `/reset-password`, `/verify/[id]` | ⬜ | **port both** |
| RG-4 | **[ROLE-STUDIOS]** #2 | `/creating`, `/teaching`, `/learning`, `/` triage | ✅ shells built | island restyles #17-20, nudge fix, `creating/apply` (⛔ client-blocked) |
| RG-5 | _(no umbrella)_ | `/profile/[...tab]` | ✅ ported | Tier-2 primitive cluster #5-8 |
| RG-6 | _(no umbrella)_ | `/course/[slug]/*` | ✅ ported | #22 dead-code |
| RG-7 | **[COMMUNITY-FIX]** #34 | `/communities`, `/community/[slug]` | ✅ ported | folded bugs (tag-filter deferred, date) |
| RG-8 | **[FEEDS-FIX]** #35 | `/feeds`, `/feed`, `/members` | ✅ ported | folded bugs (disc-card, feed-lane, stream-purge, show-more) |
| RG-9 | _(PUBLIC-PAGES block)_ | 15 marketing pages | ⬜ deferred | separate deferred block, not RTMIG-4 |

---

## RG-1 · Admin (14) — **[RTMIG-ADMIN] #30** — 🟦 rehosted, Tier-1 port pending

**Rehost ✅ DONE (Conv 250).** All 14 `git mv`'d to `/admin/*` as `@stand-in`;
`/old/admin/*` gone; `[ADMIN-REDIRECT-BLANK]` fixed (admin gate → `middleware.ts`); route
map regenerated; gates green. **Shell already Matt** (`AdminLayout` + `AdminNavbar`, Conv
193) — pages are thin `.astro` wrappers mounting an island, so the Tier-1 port is
**island/body-only**, shell untouched. `/api/admin/*` unaffected. 2 net-new
`@matt-inspired` pages already exist (`announcements`, `promotion-settings`).

**Remaining = Tier-1 Matt port of the 14 `@stand-in` bodies** (low priority,
function-first, "quite late"):

| State | Route | Legacy baseline |
|-------|-------|-----------------|
| 🟦 | `/admin` | `old/admin/index.astro` |
| 🟦 | `/admin/analytics` | `old/admin/analytics.astro` |
| 🟦 | `/admin/certificates` | `old/admin/certificates.astro` |
| 🟦 | `/admin/courses` | `old/admin/courses.astro` |
| 🟦 | `/admin/creator-applications` | `old/admin/creator-applications.astro` |
| 🟦 | `/admin/enrollments` | `old/admin/enrollments.astro` |
| 🟦 | `/admin/moderation` | `old/admin/moderation.astro` |
| 🟦 | `/admin/moderators` | `old/admin/moderators.astro` |
| 🟦 | `/admin/payouts` | `old/admin/payouts.astro` |
| 🟦 | `/admin/recordings` | `old/admin/recordings.astro` |
| 🟦 | `/admin/sessions` | `old/admin/sessions.astro` |
| 🟦 | `/admin/teachers` | `old/admin/teachers.astro` |
| 🟦 | `/admin/topics` | `old/admin/topics.astro` |
| 🟦 | `/admin/users` | `old/admin/users.astro` |

## RG-2 · Public profiles (3) — **[RTMIG-PROFILES] #31** — ⬜ unported · blocked by [ROLE-SEMANTICS] #33

**Hub-and-spoke set** (same shape as role dashboards). `/@[handle]` is the universal hub;
`PublicProfile` carries `is_creator`/`is_teacher` and renders role teasers that link OUT to
the deep role views. All 3 still legacy-only.

```
/@[handle]  (universal hub — bio + role teasers)
   ├─ TeacherTeaser → /teacher/[handle]   (deep: courses, availability, booking)
   └─ CreatorTeaser → /creator/[handle]   (deep: created courses, qualifications)
```

| State | Route | Legacy file | Notes |
|-------|-------|-------------|-------|
| ⬜ | `/@[handle]` | `old/@[handle].astro` | Universal hub. Preserve `/@me` self-redirect + role teasers. `is_creator`/`is_teacher` per **[ROLE-SEMANTICS]**. |
| ⬜ | `/teacher/[handle]` | `old/teacher/[handle]/index.astro` | Deep teacher view. `@stand-in`→`@matt-inspired` (Matt frame **not** Ready-for-Dev, so NOT `@matt-source`). Adopt `fetchTeacherProfileData` (drop-in). |
| ⬜ | `/creator/[handle]` | `old/creator/[handle]/index.astro` | Deep creator view. Adopt `fetchCreatorProfileData` w/ reconciliation (restore `primary_topic_id`; predicate per [ROLE-SEMANTICS]). |

**Folded into this home:**
- **[SSR-LOADER-DEAD]** — adopt the dead profile loaders at port time (teacher = drop-in;
  creator needs `primary_topic_id` restore + [ROLE-SEMANTICS] predicate). Separately,
  **delete** the truly-uncalled listing loaders `fetchTeacherDirectoryData` /
  `fetchCreatorListData` (superseded by `/members`).
- **[ENTITY-ANCHOR]** — plural-slug bug: `StudentTeacherAnchor` → `/teacher/${handle}`
  (singular), `CreatorAnchor` → `/creator/${handle}`.

## RG-3 · Misc app (2) — **[RTMIG-MISC] #32** — ⬜ unported

Both standalone (non-app-shell) pages; both already in `PUBLIC_PREFIXES`.

| State | Route | Legacy file | Notes |
|-------|-------|-------------|-------|
| ⬜ | `/reset-password` | `old/reset-password.astro` | Auth-shell form. Mounts `PasswordResetForm` (multi-state → "check your email"). Swap legacy `AppLayout` → Matt auth/standalone shell; preserve multi-state flow + future `?token=xyz` path + login-modal/settings entry points. |
| ⬜ | `/verify/[id]` | `old/verify/[id].astro` | Public cert verification. **Keep SSR** (data via `fetchCertificateVerifyData`). Minimal branded standalone shell (logo + card, no chrome). Keep 3 states (verified/revoked/not-found). **Tier-1 inlines `StatusBadge`**; defer extraction to Tier-2. Reuse `Card.astro`, `UserAvatar`, `EmptyState.astro`. Preserve links to `/course/[slug]`, `/@[handle]`. |

## RG-4 · Role workspaces — **[ROLE-STUDIOS] #2** — ✅ shells built · ⛔ client-blocked

Workspace shells built `@matt-inspired` (`creating/[...tab]`, `teaching/[...tab]`,
`learning/[...tab]`, + `teaching/courses/[courseId]`, `creating/communities/[slug]`).
`/learning` was the Conv-255 pilot. `/dashboard` is **retired** (deconstructed into these
workspaces + a home triage strip + a progression-nudge layer) — this **supersedes** the old
"port `/dashboard` (decision A)" disposition. `/old/{creating,teaching,learning}/*` stay
live as island source until the restyles land.

**Owned here:** `creating/apply` Tier-1 port (become-a-creator pre-flow + nudge
destination); **[NUDGE-CACHE-FLASH]** (folded — first-paint wrong-role nudge bug,
[BRIDGE-MEM]).
**Pointed-to (own tasks):** [LEARN-ISLAND-RESTYLE] #17, [CREATE-ISLAND-RESTYLE] #18,
[TEACH-ISLAND-RESTYLE] #19, [TRIAGE-RESTYLE] #20.
**SoT:** `PLAN.md § ROLE-STUDIOS` (6-phase).

## RG-5 · Own profile & settings — `/profile/[...tab]` — ✅ ported (Tier-2 cluster)

Already `@matt-inspired` (folds `old/profile` + `old/settings/*`). Remaining is the **Tier-2
primitive cluster** (PAUSED, own tasks): [CT-RESTYLE] #5, [PRIM-MATCH-INDEX] #6, [TXTBTN]
#7, [PROFILE-PRIM-SWEEP] #8. No port work.

## RG-6 · Course — `/course/[slug]/*` — ✅ ported

`course/[slug]/[...tab]` (`@matt-source`), `book`, `precheckout`, `success`. Remaining:
**[COURSEDETAIL-DEAD] #22** (lone dead-code item, kept standalone). The course-detail hero
deviation (inset vs full-bleed-top entity-header slot) is tracked under **[LAYOUT-SG]**.

## RG-7 · Community / Commons — **[COMMUNITY-FIX] #34** — ✅ ported

`/communities` + `/community/[slug]/[...tab]` (`@matt-inspired`). Maintenance bucket (folded
bugs): **[COMM-TAG-FILTER]** (tag filter — DEFERRED post-production) + **[COMMONS-DATE]**
(date bug).

## RG-8 · Discover / Feeds — **[FEEDS-FIX] #35** — ✅ ported

`/feeds`, `/feed`, `/members` (`@matt-inspired`; DISC-DROP remaps done). Maintenance bucket
(folded): **[DISCCARD-DEL]**, **[FEED-LANE-RENDER]**, **[STREAM-PURGE]**, **[SHOWMORE]**
(held until client-vet; ⚠️ tentative home).

## RG-9 · Public / marketing (15) — separate `PUBLIC-PAGES` block (deferred)

Tracked under `PLAN.md § Deferred: PUBLIC-PAGES`. Low-data, redesign-likely, **not** part of
the RTMIG-4 app-port count. `become-a-teacher` already rehosted `@stand-in`; the other 14
remain `/old/*` (`about, blog, careers, contact, cookies, faq, for-creators, help,
how-it-works, pricing, privacy, stories, terms, testimonials`).

---

## Reference: resolved / not actionable

**Retired (not ported):** `/dashboard` (`UnifiedDashboard`) → deconstructed by ROLE-STUDIOS
(two sections harvested, rest superseded by role workspaces); `AppNavbar.tsx:97`
`/dashboard` link fixed in ROLE-STUDIOS Phase 3.

**Deleted (Conv 251, decision B):** `/teachers`, `/creators` (empty "Coming soon" stubs;
referrers repointed → `/members?roles=…`).

**Dropped (Conv 229):** `/old/discover/leaderboard` — product decision not to port.

**Stale `/old` copies → [OLD-PORTED-CLEANUP] #16:** ~43 already-ported routes still carry a
`/old` copy under the pre-Conv-250 copy policy — deletable per-route as follow-up cleanup.
Ported families (root `@matt` page exists): `index, login, signup, onboarding, messages,
notifications, feed, feeds, courses, profile (+settings/*), session/[id], communities,
community/[slug]/*, course/[slug]/* (+book/success), members, learning (+sessions),
teaching/*, creating/*`.
