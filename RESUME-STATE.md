# State — Conv 322 (2026-06-22 ~13:40)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Route sweep (RTMIG-4 / RG-WORKSPACES) — **swept 2 more `/creating` workspace tabs**: **[CR-ANALYTICS]** (`/creating/analytics` — orchestrator + 8 exclusive sub-components, ~199 legacy occ, ~11× the filed "18/quickest" estimate which counted only the orchestrator) and **[CR-EARN]** (`/creating/earnings` — CreatorEarningsDetail, 582 ln, 61 `dark:` variants dropped, structural twin of the conformed /teaching EarningsDetail). Both 3-axis conformed to Matt tokens, 5 gates green (test **6741/6741**), DOM-verified live as Gabriel Rymberg. Mid-conv the user had me kill the 4 stale dev servers (4321–4324) and start a fresh one — which hit a transient Vite SSR "multiple copies of React" cold-start crash (cleared with `rm -rf node_modules/.vite`). Also folded in a cross-cut fix: 13 non-canonical `neutral-400`→`neutral-300` in the CR-ANALYTICS files (Matt neutral scale is {50,100,300,500,700,900} only). 4 code/docs commits (`e1a25942`/`68559c9` + `9d7550ba`/`8512740`); end-of-conv bookkeeping commit + push at this r-end.

## Completed

- [x] [CR-ANALYTICS] #27 — `/creating/analytics` ☑ Swept: CreatorAnalytics orchestrator + 8 sub-components (MetricsRow/ProgressDistribution/EnrollmentTrendsChart/FunnelAnalysis/SessionAnalytics/CoursePerformanceTable/TeacherPerformanceTable/MaterialsFeedbackView) conformed 3-axis vs the TeacherAnalytics template; honest-orphan keeps (session blue/purple tiles, gold/bronze medals, chart hex); `<Button>` adoption; 152 component tests + 5 gates green; DOM-verified live. Code `e1a25942`, docs `68559c9`.
- [x] [CR-EARN] #28 — `/creating/earnings` ☑ Swept: CreatorEarningsDetail (582 ln, 61 `dark:` dropped) conformed per the TCH-EARN/EarningsDetail playbook; status→semantic tokens, summary quartet + Creator-Royalty pill kept honest-orphan, Request-Payout→americana / Manage→outlined Button; 5 gates green; DOM-verified live. Code `9d7550ba`, docs `8512740`.
- [x] Cross-cut: 13 non-canonical `neutral-400`→`neutral-300` corrected across the 7 CR-ANALYTICS files (folded into `9d7550ba`).
- [x] Dev-server rescue: killed stale 4321–4324, started fresh :4321, cleared `.vite` cache to fix the Vite SSR React-dedup crash.

## Remaining

**RG-WORKSPACES /creating cluster (resume here):**
- [ ] [CR-COMMUNITIES] #29 — Creator communities tab (~1,029 ln, fresh component, no known overlap). **Recommended next** /creating unit.
- [ ] [CR-STUDIO] #26 🔴 — CreatorStudio + CourseEditor(1768)/Resources/Homework/Curriculum editors (~4,726 ln) — NEEDS its own sub-decomposition before conforming. The monster.
- [ ] Siblings: [CR-APPLY] #30 (`/creating/apply`) · [CR-COMMUNITY-MGMT] #31 (`/creating/communities/[slug]`).

**Cross-cutting / shared:**
- [ ] [COURSEFEED-CONF] #25 — conform shared CourseFeed (legacy slate/indigo/green; ripples to all consumers).
- [ ] [XCUT-BACKREF] #22 — back-glance of swept routes after cross-cutting extractions.
- [ ] [TA-SKEL] #33 — fix TeacherAnalytics skeleton `w-80`/`w-96`→`[80px]`/`[96px]` (render oversized; XCUT-BACKREF-adjacent).

**Route sweep umbrella:**
- [ ] [RTMIG-4] #1 (in_progress) · [RG-WORKSPACES] #5 (in_progress — /creating cluster remains) · [RG-DISCOVER] #6 · [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #14 (conf OUT)

**Conformance foundations:** [PALETTE-FDN] #19 · [SPACING-4PX-SWEEP] #20 · [SWEEP-SPACING-GREP] #21 · [LAYOUT-SG] #13

**Memory system:** [MEM-CAP-ARCH] #23 [Opus] — MEMORY.md fired at 81% bytes again this conv's r-start; architectural fix needed (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #24 · [VITE-DEDUP] #34 · [PROV-STAMP-GAPS] #15 · [HOME-FIXES] #16 · [COURSES-FIXES] #17 · [E2E-MIG] #7 · [E2E-GATE] #8 · [ICN-NS] #9 · [TZ-AUDIT] #10 [Opus] · [DOCGEN-SPEC] #11 · [V217-WATCH] #12 · [M4-ZGUARD] #18 · [OLD-PORTED-CLEANUP] #3 · [PREFLIP-WT] #4 · [REVIEW-COUNT-SRC] #32

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [OLD-PORTED-CLEANUP] · #4 [PREFLIP-WT] · #5 [RG-WORKSPACES] (in_progress) · #6 [RG-DISCOVER] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [LAYOUT-SG] · #14 [RG-PUBLIC] · #15 [PROV-STAMP-GAPS] · #16 [HOME-FIXES] · #17 [COURSES-FIXES] · #18 [M4-ZGUARD] · #19 [PALETTE-FDN] · #20 [SPACING-4PX-SWEEP] · #21 [SWEEP-SPACING-GREP] · #22 [XCUT-BACKREF] · #23 [MEM-CAP-ARCH] [Opus] · #24 [SWEEP-FULLSUITE] · #25 [COURSEFEED-CONF] · #26 [CR-STUDIO] · #29 [CR-COMMUNITIES] · #30 [CR-APPLY] · #31 [CR-COMMUNITY-MGMT] · #32 [REVIEW-COUNT-SRC] · #33 [TA-SKEL] · #34 [VITE-DEDUP]

## Key Context

- **Resume = the `/creating` cluster** (RG-WORKSPACES). CR-OVERVIEW (Conv 321) + CR-ANALYTICS + CR-EARN (Conv 322) done = 3 of 5 workspace tabs. Recommended next = **[CR-COMMUNITIES] #29** (fresh, ~1,029 ln). [CR-STUDIO] #26 needs a sub-decomposition pass first. SoT: `plan/route-migration/README.md` /creating row + `.scratch/conv-tasks.md`.
- **🔴 Tailwind v4 spacing gotcha (durable):** only the 10 bridge `--spacing-N` steps {4,8,12,16,20,24,32,40,48,64} are literal-px; **out-of-set numbers fall back to Tailwind's 0.25rem base** (so `w-80`=320px, NOT 80px). Use arbitrary `[Npx]` for out-of-set px values. See `20260622_1335 Learnings.md` #1.
- **🔴 Matt `neutral` scale gaps (durable):** only `{50,100,300,500,700,900}` are Matt-defined; `neutral-{200,400,600,800}` silently fall back to Tailwind greys (not canonical). Map `secondary-400`/`-600`→`neutral-300`/`-500`/`-700`. A conformance leak-grep should flag `neutral-(200|400|600|800)`. Learnings #2.
- **Conformance playbook (locked):** per colour occurrence — interactive→americana (`<Button>`/`text-primary-default`); decorative→brand; semantic status WITH a Matt token→map (completed/paid/active→success, scheduled/processing→info, pending→warning, cancelled/failed/reversed→error); tokenless categorical/identity accent→keep honest-orphan. `dark:` variants DROPPED (Matt is light-only). Spacing→literal-px ({set} bare, else `[Npx]`); radius `rounded-xl`→`rounded-12`/`-lg`→`-8`. Detail: `docs/decisions/05-ui-ux-components.md`.
- **DOM-verify procedure:** persistent :4321 dev server (now the fresh one I started this conv); dev-login `POST /api/auth/dev-login {email:'gabriel-rymberg@example.com'}` (creator) → hard-nav → settle → read computed styles. **🟠 If a fresh `npm run dev` renders an empty body on authed routes:** Vite SSR "multiple copies of React" dep-mismatch — `rm -rf node_modules/.vite` + restart; often self-resolves on the 2nd authed-route load. Tracked #34 [VITE-DEDUP].
- **Commits this conv (pushed at r-end):** code `e1a25942` (CR-ANALYTICS) + `9d7550ba` (CR-EARN + neutral-400 fix) on jfg-dev-14; docs `a54985a` (counter) + `68559c9` + `8512740` + the end-of-conv bookkeeping commit on main.
- **MEMORY.md at 81% bytes** — #23 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
