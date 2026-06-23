# State — Conv 325 (2026-06-22 ~21:40)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Cleared both carried CR-STUDIO cross-cut conformance follow-ons under the RTMIG-4 umbrella. **[CONFIRMMODAL-CONF]** — conformed the shared `ConfirmModal` ui/ primitive (user chose conform-and-back-glance): danger/warning/default → `<Button>` variants, error/neutral/type/radius/spacing tokens; 5 gates + 168 tests + live DOM back-glance (0 leaks). **[COURSEFEED-CONF]** — conformed `community/CourseFeed` (RoleBadgeInline aligned to FeedActivityCard's canonical role→token map; FeedActivityCard scoped OUT); 5 gates + 47 tests + live DOM back-glance (0 leaks). Discovered the **two-feeds split** (MattCourseFeed = student page already conformed; community/CourseFeed = teacher-workspace + /old) — documented in `docs/decisions/05-ui-ux-components.md`. 3 commits this conv (ConfirmModal code `abe0a7c3` + docs `6005494`; CourseFeed end-of-conv pair). RTMIG-4 umbrella stays open — next is RG-DISCOVER.

## Completed

- [x] [CONFIRMMODAL-CONF] #5 — ConfirmModal conformed (→ `<Button>` variants + Matt tokens); gates + 168 tests + DOM back-glance 0 leaks. Code `abe0a7c3`, docs `6005494`.
- [x] [COURSEFEED-CONF] #6 — community/CourseFeed conformed; RoleBadgeInline → canonical map; gates + 47 tests + DOM back-glance 0 leaks. End-of-conv commit.

## Remaining

**Route sweep umbrella + groups:** [RTMIG-4] #1 (in_progress) · [RG-DISCOVER] #2 (next group) · [RG-ADMIN] #3 (conf OUT) · [RG-PUBLIC] #14→#4 (conf OUT)

**Cross-cutting / shared:** [XCUT-BACKREF] #7 (apply Conv-324 status/level badge precedents to swept routes) · [TA-SKEL] #8 (TeacherAnalytics skeleton w-80/w-96 → [80px]/[96px])

**Conformance foundations:** [PALETTE-FDN] #9 · [SPACING-4PX-SWEEP] #10 · [SWEEP-SPACING-GREP] #11 · [LAYOUT-SG] #12

**Memory system:** [MEM-CAP-ARCH] #13 [Opus] — MEMORY.md fired at 81% bytes again this r-start; architectural fix needed (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #14 · [VITE-DEDUP] #15 · [PROV-STAMP-GAPS] #16 · [HOME-FIXES] #17 · [COURSES-FIXES] #18 · [E2E-MIG] #19 · [E2E-GATE] #20 · [ICN-NS] #21 · [TZ-AUDIT] #22 [Opus] · [DOCGEN-SPEC] #23 · [V217-WATCH] #24 · [M4-ZGUARD] #25 · [OLD-PORTED-CLEANUP] #26 · [PREFLIP-WT] #27 · [REVIEW-COUNT-SRC] #28

**Discovered (untracked):** FeedActivityCard conform — shared by 8 feeds, partially brand-conformed; its own future task (scope boundary noted in decisions doc). Consider a tracked code next conv if prioritized.

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-DISCOVER] · #3 [RG-ADMIN] · #4 [RG-PUBLIC] · #7 [XCUT-BACKREF] · #8 [TA-SKEL] · #9 [PALETTE-FDN] · #10 [SPACING-4PX-SWEEP] · #11 [SWEEP-SPACING-GREP] · #12 [LAYOUT-SG] · #13 [MEM-CAP-ARCH] [Opus] · #14 [SWEEP-FULLSUITE] · #15 [VITE-DEDUP] · #16 [PROV-STAMP-GAPS] · #17 [HOME-FIXES] · #18 [COURSES-FIXES] · #19 [E2E-MIG] · #20 [E2E-GATE] · #21 [ICN-NS] · #22 [TZ-AUDIT] [Opus] · #23 [DOCGEN-SPEC] · #24 [V217-WATCH] · #25 [M4-ZGUARD] · #26 [OLD-PORTED-CLEANUP] · #27 [PREFLIP-WT] · #28 [REVIEW-COUNT-SRC]

## Key Context

- **Resume = [RG-DISCOVER] #2** — the next route group under the RTMIG-4 umbrella sweep. SoT: `plan/route-migration/README.md`. Both CR-STUDIO cross-cut follow-ons are now cleared.
- **🔴 Two course-feed components (do not confuse):** `@components/course/MattCourseFeed` = student/public course-page feed (`/course/<slug>/feed`, `[...tab].astro`), already `@matt-source` conformed (Conv 189). `@components/community/CourseFeed` = teacher-workspace (`TeacherCourseView` Feed tab, `/teaching/courses/<id>`) + legacy `/old` course pages (`CourseTabs`) — conformed THIS conv. A future "conform the course feed" must disambiguate. Detail in `docs/decisions/05-ui-ux-components.md`.
- **Shared-primitive conform precedent (locked this conv):** conform-and-back-glance for shared ui/ components even when consumers include conf-OUT routes (it's a primitive, not route-bespoke styling); before conforming, check whether the design system already absorbed the variants (ConfirmModal→`<Button>` danger/warning; CourseFeed RoleBadgeInline→FeedActivityCard's canonical RoleBadge). Detail in decisions doc.
- **Conformance playbook (unchanged):** colour — interactive→americana (`<Button>`/`text-primary-default`); decorative→brand; semantic-status-with-token→map (success/info/warning/error); tokenless categorical→honest-orphan unless precedent. Spacing→literal-px (×4 bridge-restore: `p-6`→`p-24`). Type→Matt tokens (`text-xl`→`h2-bold`, `text-lg`→`h3-bold`, `text-sm`→`body-default`). Radius `rounded-lg`→`rounded-8`/`-xl`→`-12`. `dark:` dropped. Detail: `docs/decisions/05-ui-ux-components.md`.
- **DOM-verify procedure (worked this conv):** persistent :4321; `POST /api/auth/dev-login {email:'gabriel-rymberg@example.com'}` (creator) via same-origin fetch in an isolated MCP tab → hard-nav → settle ~2s → read computed styles + scan for legacy leaks. Course `crs-intermediate-q-system` / slug `intermediate-q-system` (feed NOT enabled → CourseFeed renders !feedEnabled branch). MattCourseFeed renders on `/course/<slug>/feed`; community/CourseFeed reachable via `/old/course/<slug>/feed`.
- **MEMORY.md at 81% bytes** — #13 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Commits this conv:** code `abe0a7c3` (ConfirmModal) + this end-of-conv CourseFeed commit on jfg-dev-14; docs `6005494` (decisions) + this end-of-conv bookkeeping commit on main.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
