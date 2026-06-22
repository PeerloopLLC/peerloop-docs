# State — Conv 319 (2026-06-22 ~08:15)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

RG-WORKSPACES `/teaching` visual-conformance sweep — **4 of 6 tabs swept** this conv (paused at user request). Conformed the overview tab (8 sub-components), analytics (TeacherAnalytics + shared DateRangeSelector), availability (AvailabilityCalendar, 958 ln), and earnings (EarningsDetail, 512 ln, shared w/ /creating) — each 3-axis (colour/spacing/radius+type), DOM-verified live on the teacher dashboard (Marcus Thompson), all gates green. Established a **status-token rule** (map to a Matt token where one exists; keep honest-orphan Tailwind hue where none does — sky=available, green=saved) which drove the calendar sky-keep and earnings palette-keep. 4 code + 4 docs commits on `jfg-dev-14`/`main` (committed in Step 6, pushed Step 7).

## Completed

- [x] **[TCH-OVERVIEW] #25** — 8 overview sub-components 3-axis conformed, DOM-verified, ☑ Swept. Payout button→americana `<Button>` (user). Code `05104f07`, docs `50bb803`.
- [x] **[TCH-ANALYTICS] #26** — TeacherAnalytics + shared DateRangeSelector conformed, DOM-verified, ☑ Swept. Code `eb0a416d`, docs `fd519fd`.
- [x] **[TCH-AVAIL] #27** — AvailabilityCalendar (958 ln) conformed; **sky-blue availability kept** as semantic status (`primary-*`→`sky-*`); DOM-verified sky resolves. Code `c5d1a76f`, docs `dca974a`.
- [x] **[TCH-EARN] #28** — EarningsDetail (512 ln, shared w/ /creating) conformed; transaction-status palette kept honest-orphan; DOM-verified. Code `88a9bdb5`, docs `81c77b6`.
- [x] Status-token rule established + recorded (ledger + `docs/decisions/05-ui-ux-components.md`).

## Remaining

**RG-WORKSPACES /teaching (resume here — 2 tabs + sibling left):**
- [ ] [TCH-SESSIONS] #29 — TeacherSessionsList (399 ln, ~88 legacy, 17 hues). **Direct teacher analogue of the already-conformed StudentSessionsList — reuse that pattern**; RecordingLink already conformed. Most straightforward remaining.
- [ ] [TCH-STUDENTS] #30 — MyStudents (784 ln, ~128 legacy, 37 hues). Roster + filters; student-status/progress hues.
- [ ] [TCH-COURSEVIEW] #31 — TeacherCourseView (891 ln, ~341 legacy — highest density, 39 hues). Sibling route `/teaching/courses/[courseId]`. Reuses RecordingLink (done).
- After /teaching: **/creating** workspace is the last RG-WORKSPACES route (+apply, +communities/[slug]).

**Route sweep umbrella:**
- [ ] [RTMIG-4] #1 (in_progress, umbrella) · [RG-WORKSPACES] #5 (in_progress — /learning done, /teaching 4/6, /creating pending)
- [ ] [RG-DISCOVER] #6 — `/feed`+`/feeds` (likely-retire); `/members` done Conv 315
- [ ] [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #14 (conf OUT)

**Cross-cutting / shared conformance:**
- [ ] [XCUT-BACKREF] #22 — back-glance swept consumers of **RecordingLink** (12), **TeacherCertifications** (10), **SegmentedPills** multi-select, **DateRangeSelector** (Conv 319 → Admin/Creator analytics), **EarningsDetail** (Conv 319 → /creating earnings). Tests green; glance live visuals when those routes swept.

**OLD cleanup:**
- [ ] [OLD-PORTED-CLEANUP] #3 · [PREFLIP-WT] #4

**Conformance foundations:**
- [ ] [PALETTE-FDN] #19 · [SPACING-4PX-SWEEP] #20 · [SWEEP-SPACING-GREP] #21 · [LAYOUT-SG] #13

**Memory system:**
- [ ] [MEM-CAP-ARCH] #23 [Opus] — MEMORY.md auto-load cap fired again at 80% bytes this conv's r-start; both prune levers exhausted, architectural fix needed.

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #24 · [PROV-STAMP-GAPS] #15 · [HOME-FIXES] #16 · [COURSES-FIXES] #17 · [E2E-MIG] #7 · [E2E-GATE] #8 · [ICN-NS] #9 · [TZ-AUDIT] #10 [Opus] · [DOCGEN-SPEC] #11 · [V217-WATCH] #12 · [M4-ZGUARD] #18

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [OLD-PORTED-CLEANUP] · #4 [PREFLIP-WT] · #5 [RG-WORKSPACES] (in_progress) · #6 [RG-DISCOVER] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [LAYOUT-SG] · #14 [RG-PUBLIC] · #15 [PROV-STAMP-GAPS] · #16 [HOME-FIXES] · #17 [COURSES-FIXES] · #18 [M4-ZGUARD] · #19 [PALETTE-FDN] · #20 [SPACING-4PX-SWEEP] · #21 [SWEEP-SPACING-GREP] · #22 [XCUT-BACKREF] · #23 [MEM-CAP-ARCH] [Opus] · #24 [SWEEP-FULLSUITE] · #29 [TCH-SESSIONS] · #30 [TCH-STUDENTS] · #31 [TCH-COURSEVIEW]

## Key Context

- **Resume point = [TCH-SESSIONS] #29** (TeacherSessionsList) — the StudentSessionsList analogue; reuse the conformed SSL pattern (`src/components/learning/StudentSessionsList.tsx`). Scope on the task + `plan/route-migration/README.md` /teaching row + `.scratch/conv-tasks.md`.
- **Status-token rule (Conv 319, established this conv — the conformance playbook):** per colour occurrence — (1) interactive control → **americana** (`<Button>` / `text-primary-default`); (2) decorative non-semantic tint → **brand**; (3) semantic status WITH a Matt token → **map** (`red→error-*`, `amber→warning-*`); (4) semantic status with NO Matt token → **keep honest-orphan Tailwind hue** (sky=available, green=saved/positive, categorical stat-accent quartet). Detail: `docs/decisions/05-ui-ux-components.md` + `20260622_0815 Learnings.md`.
- **`primary-*`(legacy sky ramp)→`sky-*`** preserves the EXACT blue (`--color-primary-50`=`#f0f9ff`=sky-50) while dropping the deprecated ramp + clearing the `primary-[0-9]` leak grep. `sky-*` resolves (Tailwind v4 default palette intact; JIT-generated on first use; DOM-verified).
- **DOM-truth caveat:** `[class*="bg-X"]` substring selectors also match `hover:bg-X`/`focus:bg-X` (correctly transparent at rest) and `border-primary-` matches `border-primary-default` (americana) — filter prefixed variants before counting a transparency hit / leak as real.
- **Conformance breaks class-coupled tests:** update test selectors to the conformed classes (intent preserved), don't revert the component. This conv updated 3 in `EarningsDetail.test.tsx`.
- **🔴 [TZ-AUDIT] #10 OPEN (carried):** `TeacherUpcomingSessions.formatDate/formatTime` + `StudentSessionsList.formatTime` use `toLocaleTimeString`/`toLocaleDateString` with no `timeZone` under `client:load` → hydration-mismatch. Decide UTC (hydration-safe, Conv-316) vs user-local **globally** before fixing. Left as-is (consistent with deferred SSL).
- **Browser dev-logged as marcus.t@example.com** (Marcus Thompson, teacher) for DOM-verify — re-login for your own account.
- **MEMORY.md at 80% byte cap** (#23) — architectural fix, do NOT re-prune.
- Commits this conv (pre-push): code `05104f07`/`eb0a416d`/`c5d1a76f`/`88a9bdb5` (jfg-dev-14); docs `50bb803`/`fd519fd`/`dca974a`/`81c77b6` (main) + this r-end bookkeeping commit. **Unpushed until Step 7.**
- **🔴 git pathspec + Astro `[param]` trap** (carried): `git add 'src/pages/x/[id]/...'` treats `[id]` as glob → stage parent dir. **Chrome bridge redacts JS keys containing "Token"** → name DOM-assertion keys `legacyClassHits` not `forbiddenTokens`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
