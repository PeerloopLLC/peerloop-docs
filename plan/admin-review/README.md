# ADMIN-REVIEW — Admin system review

**Focus:** Admin system review — testing gaps, UI consistency, cross-links, menu restructure, settings UI
**Status:** 📋 PENDING (promoted to active Conv 095)
**Absorbs:** ROLES (create UI, audit), ADMIN-SETTINGS-UI
**Conv:** 080 (audit only)

**Risk model:** 2 max users, high trust. Admins develop usage patterns and don't exercise breadth/edge cases. Regressions in decision-data (what the admin sees) or action-execution (what the admin does) are silently catastrophic — wrong data leads to wrong decisions, broken actions fail without the admin realizing.

**Audit baseline (Conv 080):**

| Layer | Source | Tested | Tests | File Coverage |
|-------|--------|--------|-------|---------------|
| Admin components | 28 | 19 | ~876 | 68% |
| Admin APIs | 67 | 55 | ~916 | 82% |
| Admin intel | — | 6 | ~50 | separate |
| Moderator component | 1 | 1 | 59 | 100% |
| **Total** | **96** | **81** | **~1900** | |

**Also completed Conv 080:** Replaced all 23 `prompt()` calls with `FormModal` across 6 admin/moderation files. Created `src/components/ui/FormModal.tsx`. Updated 2 test files.

## ADMIN-REVIEW.TESTING

**Gate question (ask at block start):** Full test implementation for all gaps, or risk-profile-prioritized subset?

### Category 1: Decision Data — must be correct

These show admins the data they use to make decisions. Wrong/missing fields → wrong decisions.

| Gap | What It Shows | Decision It Feeds |
|-----|--------------|-------------------|
| `CreatorApplicationDetailContent` | Application for creator role | Approve/deny creator |
| `ModeratorDetailContent` | Moderator info + activity | Remove moderator |
| `UserEditModal` | Role editing form | Role assignment (escalation risk) |
| 12 × `[id].ts` API endpoints | Single-record fetch for detail panels | All detail views — a regressed field is invisible to the admin |

The 12 missing API endpoints (all GET single-record):
- `admin/enrollments/[id].ts`
- `admin/teachers/[id].ts`
- `admin/certificates/[id].ts`
- `admin/courses/[id].ts`
- `admin/sessions/[id].ts`
- `admin/users/[id].ts`
- `admin/payouts/[id].ts`
- `admin/topics/[id].ts`
- `admin/moderation/[id].ts`
- `admin/intel/courses.ts`
- `admin/intel/dashboard.ts`
- `admin/intel/communities.ts`

These are highly templatable — same pattern (auth, 404, 200 + shape validation) repeated 12 times.

### Category 2: Action Execution — must be bulletproof

Components that trigger irreversible or hard-to-reverse operations. API tests exist but component→API wiring is untested.

| Gap | Actions | Risk |
|-----|---------|------|
| `ModeratorsAdmin` | Invite (FormModal), revoke, remove | Permission escalation/revocation |
| `TopicsAdmin` | Reorder, CRUD topics/tags | Affects course categorization site-wide |

### Category 3: Shared Infrastructure — cascade risk

Building blocks used by every admin view. Currently tested only indirectly through parent components. A regression breaks N tests simultaneously, making root-cause diagnosis harder.

| Gap | Used By | Role |
|-----|---------|------|
| `AdminDataTable` | Every admin list view | Sorting, row selection, rendering |
| `AdminDetailPanel` | Every admin detail view | Panel open/close, sections, fields |
| `AdminFilterBar` | Every admin list view | Search, filter dropdowns |
| `AdminPagination` | Every admin list view | Page navigation, items-per-page |
| `AdminActionMenu` | Every row action | Action buttons, variants, disabled |

### Approach options

| Option | Strategy | Sequence | Trade-off |
|--------|----------|----------|-----------|
| A | Bottom-up | Primitives → Actions → Data → APIs | Clean isolation, more upfront work |
| B | Risk-first | Actions → Data → Primitives → APIs | Highest-risk first, harder diagnosis |
| C | Hybrid | `AdminDataTable` + `AdminDetailPanel` → `ModeratorsAdmin` + `TopicsAdmin` → Detail contents → APIs. Skip `AdminFilterBar`/`Pagination`/`ActionMenu` (well-exercised indirectly). | Best risk/effort ratio |

**Recommendation:** Option C (hybrid) — gets infrastructure diagnostic value for the two highest-cascade primitives, then closes the action-execution and decision-data gaps. The 12 API endpoints batch separately regardless of option.

### Quality notes from Conv 080 audit

- API tests use real `better-sqlite3` via `describeWithTestDB` — not mocks. Strong pattern.
- Component tests use `@testing-library/react` + `userEvent` — real interaction, not implementation-detail testing.
- `beforeEach` resets DB state — no cross-test contamination.
- No admin E2E tests — component fetch URLs aren't verified against actual API routes. A URL typo passes both layers independently.
- Test counts per file range from 15 (CreatorApplicationsAdmin) to 70 (ModerationDetailContent) — indicating depth varies.

## ADMIN-REVIEW.MENU

**Gate question (ask at block start):** Confirm current menu structure is still accurate before making changes.

### Current Menu Structure (12 items in 3 groups)

```
OVERVIEW
└─ Dashboard (/admin)

MANAGEMENT (9 items)
├─ Users          ├─ Courses        ├─ Topics
├─ Enrollments    ├─ Teachers       ├─ Sessions
├─ Payouts        ├─ Certificates   └─ Creator Apps

MODERATION (2 items)
├─ Moderation Queue
└─ Moderators

HIDDEN (no menu entry)
└─ Analytics (/admin/analytics) — accessible by URL only
```

### Assessment

**A. Missing from menu:**
- `/admin/analytics` exists as a full page but has no sidebar entry. Admin must know the URL.

**B. Grouping doesn't match workflow:**

The flat MANAGEMENT list has 9 items in alphabetical-ish order. But admins think in workflows, not entity types. Related items aren't adjacent:

| Workflow | Current Items (scattered) |
|----------|--------------------------|
| User lifecycle | Users → Creator Apps → Teachers → Certificates |
| Course lifecycle | Courses → Topics → Enrollments → Sessions |
| Money | Payouts (alone) |

**Recommendation:** Regroup by workflow proximity:

```
OVERVIEW
└─ Dashboard
└─ Analytics                          ← promote from hidden

PEOPLE
├─ Users
├─ Creator Apps                       ← adjacent to Users (user applies → admin reviews)
├─ Teachers                           ← certified users
└─ Moderators                         ← moved from MODERATION group

COURSES & LEARNING
├─ Courses
├─ Topics                             ← course metadata
├─ Enrollments                        ← students in courses
├─ Sessions                           ← scheduled learning
└─ Certificates                       ← completion artifacts

OPERATIONS
├─ Payouts                            ← money
└─ Moderation Queue                   ← content review
```

This groups 12+1 items into 4 semantic clusters. The admin's eye can scan to the right section by intent ("I need to deal with a person" vs "I need to check a course-related thing").

**C. Cross-linking between admin views:**

The `admin-links.ts` module provides `?highlight=` navigation between admin list views. Currently supported:

| From Detail Panel | Can Navigate To |
|-------------------|-----------------|
| User → | Profile page (member-facing) |
| Course → | Course page, Creator profile |
| Enrollment → | Course page (but NOT student profile) |
| Session → | Course page (but NOT student/teacher profiles, NOT enrollment) |
| Certificate → | Profile page, Course page |
| Payout → | Recipient profile (but NOT individual splits/transactions) |
| Moderation → | Target user profile (but NOT flagger profile) |

**Missing cross-links (high value for admin workflow):**

| Gap | Why It Matters |
|-----|---------------|
| Session → Student/Teacher profiles | Admin resolving session dispute needs to see participant history |
| Session → Enrollment | Admin needs enrollment context (payment, progress) for session issues |
| Enrollment → Student profile | Admin reviewing enrollment can't quickly check student status |
| Payout → Source enrollments/courses | Admin verifying payout can't trace to originating transactions |
| Moderation → Flagger profile | Admin assessing credibility of flag can't see who flagged it |

**D. Dual-link pattern: admin-to-admin + admin-to-member (both required):**

**Design principle:** The admin↔member boundary is intentionally bidirectional. Existing `memberUrlFor` links (`/@handle`, `/discover/course/slug`) let admins cross into the member side to see what members experience and use the ADMIN-INTEL overlays available there. This is by design — it keeps admins "in touch" with the member experience and puts decision-making apparatus on the member side.

**What's missing** is the other direction: admin-to-admin links that stay within the admin system. From SessionDetail, clicking a student name should offer BOTH `/@handle` (see them as a member) AND `/admin/users?highlight={userId}` (see them in admin context among like users). The `admin-links.ts` infrastructure already supports this via `adminUrlFor`.

**Implementation pattern:** For each entity reference in a detail panel, show two links:
- 🔗 `adminUrlFor(type, id)` — opens in admin context (primary, labeled e.g. "Admin →")
- 👤 `memberUrlFor(type, slug)` — opens in member context (secondary, labeled e.g. "Member →")

**CRITICAL: Never remove existing `memberUrlFor` links.** They are the admin's window into the member experience. Admin-to-admin links are additive.

## ADMIN-REVIEW.UI

**Gate question (ask at block start):** Confirm the functional/convenient priority still holds — not a visual polish pass.

**Design principles for this subblock:**
- Not pretty, but functional and convenient. Related items easily reachable from inside pages. Sidebar as secondary navigation.
- **Bidirectional boundary crossing:** Admin↔Member boundary is intentionally porous. Admin-to-member links (`memberUrlFor`) let admins experience the app as members see it + use ADMIN-INTEL overlays. Admin-to-admin links (`adminUrlFor`) let admins see entities in admin context among like entities. Both directions must coexist — never remove one to add the other.

### Assessment: What works well

1. **Shared component architecture is strong.** All list views use `AdminFilterBar → AdminDataTable → AdminPagination → AdminDetailPanel` consistently. Pattern is learned once, works everywhere.
2. **Detail panels are rich.** `PanelSection` / `PanelField` / `StatusBadge` / `RoleBadge` give uniform information density.
3. **Action patterns are consistent.** ConfirmModal (now + FormModal) → toast → list refresh. Predictable feedback loop.
4. **Dashboard provides genuine operational value.** Alerts, quick actions, session cleanup, recent activity — not just vanity metrics.

### Assessment: Friction points

**F1. Inconsistent status filtering patterns**

| View | Status Selection | Pattern |
|------|-----------------|---------|
| Users, Courses, Enrollments, Teachers, Sessions | Dropdown filter | Standard |
| Certificates | Tab bar (`all \| pending \| issued \| revoked`) | Outlier |
| Payouts | Hybrid: pending tab + dropdown for others | Outlier |

Admin learns dropdown pattern, hits tabs in Certificates, hits hybrid in Payouts. Recommendation: standardize on dropdowns for all, OR standardize on tabs for views where status is the primary workflow axis (Certificates, Payouts, Moderation). Pick one and apply consistently.

**F2. Dead feature: EnrollmentsAdmin stats**

API returns `stats: {total, active, completed, cancelled}` — component fetches but never renders them. Either display as summary cards above the table (like Dashboard metrics) or stop fetching.

**F3. PayoutsAdmin pending mode is a different UI entirely**

Pending tab shows grouped-by-recipient expandable view. All other tabs show standard table. This is the only view with two fundamentally different layouts. Recommendation: either make the grouped view the standard (with status column to distinguish), or split into two pages (`/admin/payouts` for history, `/admin/payouts/pending` for processing).

**F4. Missing admin-to-admin cross-links in detail panels (additive — keep member links)**

Detail panels link to member-facing pages (`/@handle`, `/discover/course/slug`) — this is intentional and must be preserved. These links let admins cross into the member experience to see what members see and use ADMIN-INTEL overlays for in-context decision-making.

What's missing is the **complementary** admin-to-admin direction. An admin investigating a session dispute who wants to see the student's admin record has to:
1. Open session detail
2. Note the student name
3. Close panel
4. Navigate to Users
5. Search for the student
6. Open their detail

Should be: click student name in session detail → `/admin/users?highlight={userId}` (admin view) alongside the existing `/@handle` (member view).

The `admin-links.ts` infrastructure exists for this (`adminUrlFor('user', id)` → `/admin/users?highlight={id}`). It's just not wired into most detail content components.

**Implementation:** Dual-link pattern per entity reference — admin link (primary) + member link (secondary, existing). See .MENU §D for pattern details.

**Priority detail panels for admin-to-admin wiring:**
- `SessionDetailContent` — student, teacher, enrollment links
- `EnrollmentDetailContent` — student link
- `PayoutDetailContent` — source course/enrollment links
- `ModerationDetailContent` — flagger link

**F5. No filter persistence across navigation**

Navigating away from a filtered list and returning clears all filters. Admin must re-enter search criteria. Low-cost fix: store filter state in URL query params (already partially supported via `?highlight=`).

**F6. TopicsAdmin has no detail panel**

Only admin view without a detail panel. Cannot view topic metadata, associated course count, or tag usage. Actions are limited to reorder and delete. Recommendation: add a lightweight detail panel showing course count, creation date, and usage stats.

**F7. Admin page-level auth guard gap (Conv 082)** ✅ Fixed Conv 083

~~Non-admin users can navigate to `/admin/*` pages and see the full admin sidebar layout before the API rejects the data request.~~ Auth guard added to `AdminLayout.astro` — checks JWT, verifies session, confirms admin role. Unauthenticated → `/login`, non-admin → `/`.

**F8. ModeratorsAdmin has no detail panel content**

`ModeratorDetailContent.tsx` exists as a file but its completeness should be verified at block start. If the panel shows basic info only, it should display moderation activity stats (flags reviewed, actions taken).

### Recommended execution order

1. **Menu restructure** (ADMIN-REVIEW.MENU) — regroup sidebar, promote Analytics, add admin-to-admin links in detail panels
2. **Filter consistency** (F1) — pick tabs vs dropdowns and standardize
3. **Cross-link wiring** (F4) — wire `adminUrlFor` into detail content components (SessionDetail, EnrollmentDetail, PayoutDetail, ModerationDetail)
4. **Dead feature cleanup** (F2, F3) — render EnrollmentsAdmin stats or remove; decide on PayoutsAdmin pending layout
5. **Filter persistence** (F5) — URL query param state for filters
6. **TopicsAdmin detail panel** (F6) — lightweight panel with course count
7. **ModeratorsAdmin detail panel** (F8) — verify and enhance if needed

Items 1-4 are functional improvements (convenience, workflow). Items 5-7 are polish (nice-to-have for 2-user system).

## ADMIN-REVIEW.ROLES (absorbed from ROLES block)

*Role management additions. EDIT_UI complete (Session 280).*

- [ ] Admin user creation UI (UserCreateModal → `POST /api/admin/users`)
- [ ] Role change audit trail (subsumed by OBSERVABILITY.AUDIT-LOG)

## ADMIN-REVIEW.SETTINGS (absorbed from ADMIN-SETTINGS-UI)

*Admin UI for editing `platform_stats` values*

- [ ] Settings page: edit `availability_window_days`, 13 `smart_feed_*` parameters
- [ ] Validate ranges, show current values, save confirmation
