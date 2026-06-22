# State — Conv 321 (2026-06-22 ~11:55)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

RG-WORKSPACES sweep — **finished the `/teaching` cluster** ([TCH-COURSEVIEW]: TeacherCourseView 891 ln conformed + DOM-verified, all 6 tabs across 2 courses) and **started `/creating`**. Scoped `/creating` (~8,000+ ln, bigger than all of /teaching) and **decomposed it tab-by-tab into 7 [CR-*] units** (mirrors the Conv-318 /teaching decision); completed the first, **[CR-OVERVIEW]** (CreatorDashboard shell + 4 creator sub-components, DOM-verified as creator Gabriel Rymberg). RG-WORKSPACES is now **3/6 routes swept**. 4 code commits (2 on jfg-dev-14 this conv) + docs, all gates green.

## Completed

- [x] **[TCH-COURSEVIEW] #25** — TeacherCourseView (891 ln) full Matt conformance: dark: dropped, neutral/brand/americana + semantic status pills, spacing→literal-px, Button primitive; **USER: StatCards→sibling plain-number pattern; progress 100%→success-500/<100%→brand-300**. Fixed a `*/`-in-JSDoc comment bug. Gates green; DOM-verified live (Marcus, both courses, 6 tabs). Code `3c6e54f0`.
- [x] **/teaching cluster 100% complete** (6 tabs Convs 319–320 + course-detail sibling Conv 321).
- [x] **/creating scoped + decomposed** into 7 [CR-*] units (#27–33); recorded in route README.
- [x] **[CR-OVERVIEW] #27** — CreatorDashboard shell + 4 creator sub-comps (CreatorCourseCard/PendingApprovals/TeacherList/TeachingSummary). Status badge→success, pending→warning, toggles (discussion→americana, teaching→success), **My-Teaching purple KEPT honest-orphan**, error/CTAs→Button. Gates green; DOM-verified live (Gabriel Rymberg, creator). Code `6a7a66cd`.

## Remaining

**RG-WORKSPACES /creating cluster (resume here):**
- [ ] [CR-ANALYTICS] #29 — **RECOMMENDED NEXT** (quickest: 378 ln/18 leg, TeacherAnalytics-analogue, shared DateRangeSelector already conformed).
- [ ] [CR-EARN] #30 (CreatorEarningsDetail 582 ln/279 leg — densest; check overlap w/ conformed EarningsDetail) · [CR-COMMUNITIES] #31 (~1,029 ln) · [CR-APPLY] #32 (/creating/apply) · [CR-COMMUNITY-MGMT] #33 (/creating/communities/[slug]).
- [ ] [CR-STUDIO] #28 🔴 — CreatorStudio + CourseEditor(1768)/Resources/Homework/Curriculum editors (~4,726 ln) — **NEEDS its own sub-decomposition** before conforming. The monster.

**Cross-cutting / shared:**
- [ ] [COURSEFEED-CONF] #26 — conform shared CourseFeed (legacy slate/indigo/green tokens; surfaced on TeacherCourseView Feed tab; ripples to all consumers).
- [ ] [XCUT-BACKREF] #22 — live-visual back-glance of RecordingLink/SegmentedPills/DateRangeSelector when those routes swept.

**Route sweep umbrella:**
- [ ] [RTMIG-4] #1 (in_progress) · [RG-WORKSPACES] #5 (in_progress — 3/6 routes; /creating cluster remains) · [RG-DISCOVER] #6 · [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #14 (conf OUT)

**Conformance foundations:** [PALETTE-FDN] #19 · [SPACING-4PX-SWEEP] #20 · [SWEEP-SPACING-GREP] #21 · [LAYOUT-SG] #13

**Memory system:** [MEM-CAP-ARCH] #23 [Opus] — MEMORY.md fired at 80% bytes again this conv's r-start; architectural fix needed (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #24 · [PROV-STAMP-GAPS] #15 · [HOME-FIXES] #16 · [COURSES-FIXES] #17 · [E2E-MIG] #7 · [E2E-GATE] #8 · [ICN-NS] #9 · [TZ-AUDIT] #10 [Opus] · [DOCGEN-SPEC] #11 · [V217-WATCH] #12 · [M4-ZGUARD] #18 · [OLD-PORTED-CLEANUP] #3 · [PREFLIP-WT] #4 · [REVIEW-COUNT-SRC] #34

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [OLD-PORTED-CLEANUP] · #4 [PREFLIP-WT] · #5 [RG-WORKSPACES] (in_progress) · #6 [RG-DISCOVER] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [LAYOUT-SG] · #14 [RG-PUBLIC] · #15 [PROV-STAMP-GAPS] · #16 [HOME-FIXES] · #17 [COURSES-FIXES] · #18 [M4-ZGUARD] · #19 [PALETTE-FDN] · #20 [SPACING-4PX-SWEEP] · #21 [SWEEP-SPACING-GREP] · #22 [XCUT-BACKREF] · #23 [MEM-CAP-ARCH] [Opus] · #24 [SWEEP-FULLSUITE] · #26 [COURSEFEED-CONF] · #28 [CR-STUDIO] · #29 [CR-ANALYTICS] · #30 [CR-EARN] · #31 [CR-COMMUNITIES] · #32 [CR-APPLY] · #33 [CR-COMMUNITY-MGMT] · #34 [REVIEW-COUNT-SRC]

## Key Context

- **Resume = the `/creating` cluster** (RG-WORKSPACES). CR-OVERVIEW done; recommended next = **[CR-ANALYTICS] #29** (quickest). [CR-STUDIO] #28 needs a sub-decomposition pass first. Scope detail: `plan/route-migration/README.md` /creating row + `.scratch/conv-tasks.md`.
- **Conformance playbook + corrected status-token rule** (the locked recipe): per colour occurrence — interactive→**americana** (`<Button>`/`text-primary-default`); decorative non-semantic→**brand**; semantic status WITH a Matt token→**map** (completed→`success`, scheduled/info→`info`, in_progress/pending→`warning`, cancelled/failed→`error`); semantic status with NO token OR identity/category accent→**keep honest-orphan** (e.g. DashboardStatCard quartet incl. purple, AvailabilityCalendar sky, **CreatorTeachingSummary "My Teaching" purple** kept Conv 321). Detail: `docs/decisions/05-ui-ux-components.md`.
- **Bridge spacing is a FIXED set** `{4,8,12,16,20,24,32,40,48,64}` (radius `{2,4,6,8,12,16,24}`). Conform a bridge-shrunk legacy comp: `legacy-N → N×4` if in-set, else arbitrary `[Npx]`. Off-set legacy values (`space-y-6`, `gap-3`, `mt-1`) already render correctly — leave them.
- **🔴 `*/`-in-JSDoc gotcha (Conv 321):** never write a literal `*/` inside a doc-comment (e.g. `secondary-*/primary-*`) — it closes the block comment early. tsc catches it; leak-grep doesn't.
- **DOM-verify (Conv 321):** use the user's **persistent :4321 dev server** (kept logged-in across convs — `feedback_persistent_dev_server_4321`); do NOT spawn a fresh port. Dev-login via `POST /api/auth/dev-login {email}` (fire-to-window + read-back; top-level await unavailable). **Creator account = `gabriel-rymberg@example.com`** (`can_create_courses=1`); teacher = `marcus.t@example.com`. `/creating` is creator-gated (`useCreatorGate` → users.`can_create_courses`).
- **Thin-shell pattern:** CreatorDashboard/TeacherDashboard are thin shells; several children (DashboardStatCard, EarningsOverview, QuickActionButton, MyFeeds) already conformed — conform the shell + only the not-yet-swept children. Residual blue/green/amber/red leaks on /creating Overview = DashboardStatCard quartet + MyFeeds red dots (intentional keeps).
- **MEMORY.md at 80% byte cap** (#23) — architectural fix, do NOT re-prune.
- Commits this conv: code `3c6e54f0` (TCH-COURSEVIEW) + `6a7a66cd` (CR-OVERVIEW) on jfg-dev-14; docs `b3a40c6` (counter) + `e27ed8e` (TCH README) + `24e8fee` (CR README) on main + the end-of-conv bookkeeping commit. **Pushed in /r-end Step 7.**

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
