# State — Conv 318 (2026-06-22 ~06:33)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

RG-WORKSPACES sweep, route 1/6 + start of 2/6. **Swept `/learning`** — conformed 7 components (StudentDashboard, StudentSessionsList, EnrollmentCard, CertificatesSection, MyFeeds + tree-walked CollapsibleSection + cross-cutting RecordingLink), DOM-verified both tabs (member sarah.miller), 0 legacy-class leaks, committed code `9f7b0380` / docs `c58fa4f`. User decision: **decorative sky `primary-*` → brand-purple**; interactive sky split (CTAs→`<Button>` americana, text links→`text-primary-default`). Then **assessed `/teaching`** (~4.3K ln, 6 tabs + sibling), decomposed it tab-by-tab into 7 `[TCH-*]` tasks (#25–31), and **conformed the TeacherDashboard shell** (partial — committed `ce1ce61f`; its 8 sub-components remain).

## Completed

- [x] **/learning SWEPT (RG-WORKSPACES 1/6)** — 7 components 3-axis conformed, DOM-verified (In-Progress badge #ECEBFE/brand-500, progress fill #584DF4, completed=green kept, 0 leaks both tabs), gates green (tsc/lint/astro-check/prov + StudentDashboard.test 26/26). README ☑ Swept + 7-row ledger section. Code `9f7b0380`, docs `c58fa4f`.
- [x] Cross-cutting **RecordingLink** conformed (Rule-of-Three Fix, 12 consumers).
- [x] **/teaching assessed + decomposed** into 7 `[TCH-*]` tab-unit tasks (#25–31).
- [x] **TeacherDashboard shell** conformed (TCH-OVERVIEW partial), committed `ce1ce61f`.

## Remaining

**RG-WORKSPACES /teaching (resume here):**
- [ ] [TCH-OVERVIEW] #25 (in_progress) — **shell done; 8 sub-components remain** (~914 ln): DashboardStatCard, EarningsOverview, QuickActionButton, **TeacherCertifications (shared 10× — back-glance)**, TeacherPendingActions, TeacherStudentList, TeacherUpcomingSessions, AvailabilityQuickView. Apply the same token map + decorative-sky→brand decision. Then DOM-verify + mark overview Swept.
- [ ] [TCH-ANALYTICS] #26 · [TCH-AVAIL] #27 · [TCH-EARN] #28 · [TCH-SESSIONS] #29 · [TCH-STUDENTS] #30 · [TCH-COURSEVIEW] #31 — remaining /teaching tab units (sizes/legacy density on each task).

**Route sweep (RTMIG-4 umbrella):**
- [ ] [RTMIG-4] #1 (in_progress, umbrella) · [RG-WORKSPACES] #5 (in_progress, 1/6 swept)
- [ ] [RG-DISCOVER] #6 — `/feed`+`/feeds` (likely-retire); `/members` done Conv 315
- [ ] [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #14 (conf OUT)

**Cross-cutting / shared conformance:**
- [ ] [XCUT-BACKREF] #22 — back-glance swept consumers of **RecordingLink (12)** + **TeacherCertifications (10)** + SegmentedPills multi-select.

**OLD cleanup:**
- [ ] [OLD-PORTED-CLEANUP] #3 · [PREFLIP-WT] #4

**Conformance foundations:**
- [ ] [PALETTE-FDN] #19 · [SPACING-4PX-SWEEP] #20 · [SWEEP-SPACING-GREP] #21 · [LAYOUT-SG] #13

**Memory system:**
- [ ] [MEM-CAP-ARCH] #23 [Opus] — fired again at 80% bytes (20481/25600) this conv's r-start; both prune levers exhausted, architectural fix needed.

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #24 · [PROV-STAMP-GAPS] #15 · [HOME-FIXES] #16 · [COURSES-FIXES] #17 · [E2E-MIG] #7 · [E2E-GATE] #8 · [ICN-NS] #9 · [TZ-AUDIT] #10 [Opus] · [DOCGEN-SPEC] #11 · [V217-WATCH] #12 · [M4-ZGUARD] #18

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [OLD-PORTED-CLEANUP] · #4 [PREFLIP-WT] · #5 [RG-WORKSPACES] (in_progress) · #6 [RG-DISCOVER] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [LAYOUT-SG] · #14 [RG-PUBLIC] · #15 [PROV-STAMP-GAPS] · #16 [HOME-FIXES] · #17 [COURSES-FIXES] · #18 [M4-ZGUARD] · #19 [PALETTE-FDN] · #20 [SPACING-4PX-SWEEP] · #21 [SWEEP-SPACING-GREP] · #22 [XCUT-BACKREF] · #23 [MEM-CAP-ARCH] [Opus] · #24 [SWEEP-FULLSUITE] · #25 [TCH-OVERVIEW] (in_progress) · #26 [TCH-ANALYTICS] · #27 [TCH-AVAIL] · #28 [TCH-EARN] · #29 [TCH-SESSIONS] · #30 [TCH-STUDENTS] · #31 [TCH-COURSEVIEW]

## Key Context

- **Resume point = [TCH-OVERVIEW] #25:** conform the 8 overview sub-components to complete the /teaching overview tab. Scope is on the task + `plan/route-migration/README.md` /teaching row + `.scratch/conv-tasks.md` /teaching group.
- **Workspace conformance playbook (reusable for /teaching + /creating)** — full detail in `20260622_0633 Learnings.md` + the migration-ledger /learning section:
  - Legacy **sky `primary-*` splits by role:** interactive → americana-blue (`<Button>` / `text-primary-default`); decorative tint/fill/badge → **brand-purple** (`brand-100` tint-bg, `brand-300` #584DF4 solid-fill, `brand-500` text/icon). User-decided this conv.
  - **Sparse scales force re-grade:** neutral {50,100,300,500,700,900}, brand {100,300,500}. `secondary-{200,300,400}`→`neutral-300`, `600`→`neutral-500`, `700/900`→`neutral-700/900`.
  - **Spacing:** uniform `X-N`→`X-(N×4)` (Matt class number = px; restores collapsed in-set + zero-change-normalizes the rest). Fractional keys (`mt-0.5`) kept.
  - **Honest-orphan keeps:** status pills (green/blue/amber/red) + stat colours, cert-type tints, feed-type tints, red new-post dots, green live-session CTAs, avatar-initial `font-bold` (display-exception). Amber callouts → `warning-*`, star → `text-star`.
- **DOM-truth verifies token RESOLUTION** (gates can't — a non-existent token computes to rgba(0,0,0,0) and passes). Verify via Chrome bridge + `getComputedStyle`; brand-100 = #ECEBFE confirms the scale is wired.
- **🔴 [TZ-AUDIT] #10 OPEN QUESTION:** `StudentSessionsList.formatTime` (`src/components/learning/StudentSessionsList.tsx`) uses `toLocaleTimeString()` with no `timeZone` + `client:load` = hydration-mismatch. Decide UTC (hydration-safe, Conv-316 precedent) vs user-local **globally** before fixing. Not fixed inline.
- **[XCUT-BACKREF] #22:** RecordingLink (12 consumers) + TeacherCertifications (10 consumers) were/will-be conformed → 30-sec back-glance their already-swept consumers (RG-SESSIONS/COURSES/PUBPROF).
- **Browser is dev-logged as sarah.miller@example.com** (shared-cookie swap for verification) — re-login for your own account.
- **MEMORY.md at 80% byte cap** (#23 [MEM-CAP-ARCH]) — architectural fix, do NOT re-prune.
- Commits this conv: code `9f7b0380` (/learning) + `ce1ce61f` (TeacherDashboard shell); docs `c58fa4f` (/learning record) + this r-end bookkeeping commit. Branch `jfg-dev-14`.
- **🔴 git pathspec + Astro `[param]` trap** (carried): `git add 'src/pages/x/[id]/...'` treats `[id]` as glob → stage the parent dir instead. **Chrome bridge redacts JS keys containing "Token"** → name DOM-assertion keys `legacyClassHits` not `forbiddenTokens`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
