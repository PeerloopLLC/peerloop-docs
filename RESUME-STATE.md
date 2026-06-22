# State — Conv 320 (2026-06-22 ~10:06)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

RG-WORKSPACES `/teaching` sweep — **conformed the last 2 tabs (TCH-SESSIONS + TCH-STUDENTS)** so all **6 /teaching tabs are now ☑ Swept**. The conv's pivot: user steered TeacherSessionsList status colours onto Matt semantic tokens, which surfaced that the Conv-319 status-token rule had under-applied — `success` (green) and `info` (blue) ramps DO exist, so green→success / blue→info now MAP (not honest-orphan). **Corrected the rule** (`docs/decisions/05`) and **back-applied it** across 6 components (STATUS-TOKEN-BACKMAP + an XCUT-BACKREF ripple sub-part). 4 code commits on `jfg-dev-14` + 2 docs commits on `main`, all DOM-verified (Marcus Thompson / Sarah Miller), all gates green.

## Completed

- [x] **[TCH-SESSIONS] #25** — TeacherSessionsList (399 ln) conformed mirroring StudentSessionsList + status→Matt semantic tokens (user); `pl-16`→`pl-64` spacing-trap fix; TZ left→#10. DOM-verified. Code `f2589d49`.
- [x] **[TCH-STUDENTS] #26** — MyStudents (784 ln) full 3-axis; spacing ×4-restore (bridge set {4..64}, off-set→[Npx]); status→Matt tokens; **USER: Teacher badge→brand, Join CTA→americana**; progress 100%→success/<100%→brand-300. 43 tests green. Code `c86a604f`.
- [x] **[STATUS-TOKEN-BACKMAP] #28** — green→success/blue→info back-applied to StudentSessionsList, TeacherAnalytics, EarningsDetail, AvailabilityCalendar banners. 69 tests green. Code `0ee17bd9`.
- [x] **Status-token rule CORRECTED** — recorded "Status-token correction (Conv 320)" in `docs/decisions/05-ui-ux-components.md`. Docs `0eb535d`.
- [x] **XCUT-BACKREF ripple sub-part** — EarningsOverview This-Month + TeacherCertifications earned/active green → success (user: map both); CourseCard + TeacherSessionsList `neutral-400`→`neutral-300` (non-Matt leak). Code `970786fb`.
- [x] All 6 /teaching tabs ☑ Swept (overview/analytics/availability/earnings Conv 319; sessions/students Conv 320).

## Remaining

**RG-WORKSPACES /teaching + /creating (resume here):**
- [ ] [TCH-COURSEVIEW] #27 — **RESUME POINT.** TeacherCourseView (`/teaching/courses/[courseId]`, 891 ln, ~341 legacy — densest in the group). Last /teaching piece. Follows the now-locked conformance playbook + corrected status-token rule. Reuses RecordingLink (done).
- After TCH-COURSEVIEW: **/creating** workspace (+apply, +communities/[slug]) — last RG-WORKSPACES route.

**Route sweep umbrella:**
- [ ] [RTMIG-4] #1 (in_progress) · [RG-WORKSPACES] #5 (in_progress — /learning done, /teaching 6/6 tabs done, sibling + /creating remain)
- [ ] [RG-DISCOVER] #6 — `/feed`+`/feeds` (likely-retire)
- [ ] [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #14 (conf OUT)

**Cross-cutting / shared conformance:**
- [ ] [XCUT-BACKREF] #22 — ripple sub-part DONE (Conv 320). **Remaining: live-visual back-glance** of RecordingLink (12 consumers), SegmentedPills multi-select, DateRangeSelector (Admin/Creator analytics) when those routes are swept.

**OLD cleanup:**
- [ ] [OLD-PORTED-CLEANUP] #3 · [PREFLIP-WT] #4

**Conformance foundations:**
- [ ] [PALETTE-FDN] #19 · [SPACING-4PX-SWEEP] #20 · [SWEEP-SPACING-GREP] #21 · [LAYOUT-SG] #13

**Memory system:**
- [ ] [MEM-CAP-ARCH] #23 [Opus] — MEMORY.md auto-load cap fired again at 80% bytes this conv's r-start; architectural fix needed (do NOT re-prune).

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #24 · [PROV-STAMP-GAPS] #15 · [HOME-FIXES] #16 · [COURSES-FIXES] #17 · [E2E-MIG] #7 · [E2E-GATE] #8 · [ICN-NS] #9 · [TZ-AUDIT] #10 [Opus] · [DOCGEN-SPEC] #11 · [V217-WATCH] #12 · [M4-ZGUARD] #18

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [OLD-PORTED-CLEANUP] · #4 [PREFLIP-WT] · #5 [RG-WORKSPACES] (in_progress) · #6 [RG-DISCOVER] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [LAYOUT-SG] · #14 [RG-PUBLIC] · #15 [PROV-STAMP-GAPS] · #16 [HOME-FIXES] · #17 [COURSES-FIXES] · #18 [M4-ZGUARD] · #19 [PALETTE-FDN] · #20 [SPACING-4PX-SWEEP] · #21 [SWEEP-SPACING-GREP] · #22 [XCUT-BACKREF] · #23 [MEM-CAP-ARCH] [Opus] · #24 [SWEEP-FULLSUITE] · #27 [TCH-COURSEVIEW]

## Key Context

- **Resume point = [TCH-COURSEVIEW] #27** (TeacherCourseView, `/teaching/courses/[courseId]`, 891 ln, ~341 legacy — highest density). Scope on `plan/route-migration/README.md` /teaching row + `.scratch/conv-tasks.md`. Reuses RecordingLink (conformed). **Note:** it currently has `dark:` classes (unconformed) — drop them per the port playbook.
- **Status-token rule (CORRECTED Conv 320 — the conformance playbook):** per colour occurrence — (1) interactive → **americana** (`<Button>`/`text-primary-default`); (2) decorative non-semantic → **brand**; (3) semantic status WITH a Matt token → **map** — now covers **all four**: completed/positive→`success`, scheduled/info→`info`, in_progress/pending→`warning`, cancelled/failed→`error`; (4) semantic status with NO Matt token → **keep honest-orphan** (sky=available; data-viz chart series; categorical accent palettes with a tokenless member like the EarningsDetail/DashboardStatCard quartets; the AvailabilityCalendar sky/red/amber cell-state legend). Map-vs-keep test: *does the colour encode a good/bad/in-between STATE (→map) or identity/category/data (→keep)?* Detail: `docs/decisions/05-ui-ux-components.md` §"Status-token correction (Conv 320)".
- **Bridge spacing is a FIXED set** `{4,8,12,16,20,24,32,40,48,64}` (radius `{2,4,6,8,12,16,24}`). Off-set numeric utilities fall through to Tailwind's default → BUG (e.g. legacy `w-40`=40px not 160px). Conformance of a bridge-shrunk legacy comp = `legacy-N → N×4` if the result is in-set, else arbitrary `[Npx]` (`h-20`→`h-[80px]`, `w-40`→`w-[160px]`).
- **🔴 `neutral-400` is NON-Matt** (scale = {50,100,300,500,700,900}) → resolves to Tailwind-default grey. Add `neutral-(200|400|600|800)` to conformance leak greps. Map legacy `secondary-400`→`neutral-300`. Fixed in TeacherSessionsList + CourseCard this conv.
- **🔴 [TZ-AUDIT] #10 OPEN (carried):** date/time `toLocaleString` (no timeZone) under client:load = hydration-mismatch in several ported comps. Decide UTC (hydration-safe) vs user-local **globally** before fixing. Left untouched this conv (visual-only commits).
- **Browser dev-logged as marcus.t@example.com** (Marcus Thompson, teacher) + tested sarah.miller@example.com (student). Chrome bridge: top-level `await` unavailable in the REPL → fire-to-`window` + read-back; poll-until-rendered for client:load islands.
- **MEMORY.md at 80% byte cap** (#23) — architectural fix, do NOT re-prune.
- Commits this conv: code `f2589d49`/`0ee17bd9`/`c86a604f`/`970786fb` (jfg-dev-14); docs `0eb535d`/`6b4a45d` (main) + the end-of-conv bookkeeping commit. **Pushed in /r-end Step 7.**

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
