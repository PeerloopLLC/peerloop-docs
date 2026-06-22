# State — Conv 323 (2026-06-22 ~16:35)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Route sweep (RTMIG-4 / RG-WORKSPACES) — swept the **last 3 `/creating` units except CR-STUDIO**: **[CR-COMMUNITIES]** (communities tab, 3 files ~453 ln — scope-corrected from the carried ~1,029 estimate, which had bundled the CR-COMMUNITY-MGMT files; CommunityCard verified exclusive, no cross-cut), **[CR-APPLY]** (`/creating/apply`, CreatorApplicationForm 328 ln + page marker flip `@stand-in`→`@matt-inspired`), and **[CR-COMMUNITY-MGMT]** (`/creating/communities/[slug]`, 4 island internals ~1,044 ln). All 3-axis conformed; 5 gates green each (test **6741/6741**); DOM-verified live as Gabriel Rymberg (+ newuser/Alex Chen for the apply form's non-creator state). **Notable USER decision:** course-level badges mapped onto Matt semantic ramps (beginner→success / intermediate→warning / advanced→error) rather than kept honest-orphan. 6 unit commits (code `aab40134`/`89a73e49`/`12401b89`; docs `6da653e`/`09088ee`/`232bca3`) + end-of-conv bookkeeping. **RG-WORKSPACES now 5/6 routes swept; only CR-STUDIO (the `/creating` `[...tab]`) remains.**

## Completed

- [x] [CR-COMMUNITIES] #27 — `/creating` communities tab ☑ Swept (3 exclusive files ~453 ln: CreatorCommunities/CommunityCard/CreateCommunityModal). Code `aab40134`, docs `6da653e`.
- [x] [CR-APPLY] #28 — `/creating/apply` ☑ Swept (CreatorApplicationForm 328 ln, 5 states; marker `@stand-in`→`@matt-inspired`; CreatorApplicationForm.test 15/15). Code `89a73e49`, docs `09088ee`.
- [x] [CR-COMMUNITY-MGMT] #29 — `/creating/communities/[slug]` ☑ Swept (4 islands ~1,044 ln: CommunityManagement/ProgressionCard/CommunitySettings/CreateProgressionModal; level badges→semantic ramps per user). Code `12401b89`, docs `232bca3`.

## Remaining

**RG-WORKSPACES /creating cluster — LAST unit:**
- [ ] [CR-STUDIO] #26 🔴 [Opus] — CreatorStudio + CourseEditor(1768)/Resources/Homework/Curriculum editors (~4,726 ln). NEEDS its own sub-decomposition pass BEFORE conforming. The only remaining /creating + RG-WORKSPACES route; likely spans multiple convs.

**Cross-cutting / shared:**
- [ ] [COURSEFEED-CONF] #25 — conform shared CourseFeed (legacy slate/indigo/green; ripples to all consumers).
- [ ] [XCUT-BACKREF] #22 — back-glance of swept routes after cross-cutting extractions. **Now also covers** applying the Conv-323 level-badge→semantic-ramp mapping consistently to any OTHER swept routes rendering course-level badges.
- [ ] [TA-SKEL] #31 — fix TeacherAnalytics skeleton `w-80`/`w-96`→`[80px]`/`[96px]`.

**Route sweep umbrella:** [RTMIG-4] #1 (in_progress) · [RG-WORKSPACES] #5 (in_progress — only CR-STUDIO left) · [RG-DISCOVER] #6 · [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #14 (conf OUT)

**Conformance foundations:** [PALETTE-FDN] #19 · [SPACING-4PX-SWEEP] #20 · [SWEEP-SPACING-GREP] #21 · [LAYOUT-SG] #13

**Memory system:** [MEM-CAP-ARCH] #23 [Opus] — MEMORY.md fired at 81% bytes again this conv's r-start; architectural fix needed (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #24 · [VITE-DEDUP] #32 · [PROV-STAMP-GAPS] #15 · [HOME-FIXES] #16 · [COURSES-FIXES] #17 · [E2E-MIG] #7 · [E2E-GATE] #8 · [ICN-NS] #9 · [TZ-AUDIT] #10 [Opus] · [DOCGEN-SPEC] #11 · [V217-WATCH] #12 · [M4-ZGUARD] #18 · [OLD-PORTED-CLEANUP] #3 · [PREFLIP-WT] #4 · [REVIEW-COUNT-SRC] #30

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [OLD-PORTED-CLEANUP] · #4 [PREFLIP-WT] · #5 [RG-WORKSPACES] (in_progress) · #6 [RG-DISCOVER] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [LAYOUT-SG] · #14 [RG-PUBLIC] · #15 [PROV-STAMP-GAPS] · #16 [HOME-FIXES] · #17 [COURSES-FIXES] · #18 [M4-ZGUARD] · #19 [PALETTE-FDN] · #20 [SPACING-4PX-SWEEP] · #21 [SWEEP-SPACING-GREP] · #22 [XCUT-BACKREF] · #23 [MEM-CAP-ARCH] [Opus] · #24 [SWEEP-FULLSUITE] · #25 [COURSEFEED-CONF] · #26 [CR-STUDIO] 🔴 [Opus] · #30 [REVIEW-COUNT-SRC] · #31 [TA-SKEL] · #32 [VITE-DEDUP]

## Key Context

- **Resume = [CR-STUDIO] #26 🔴 [Opus]** — the LAST /creating + RG-WORKSPACES unit. ~4,726 ln. Needs its OWN sub-decomposition pass (map files → conformable sub-units, identify shared vs exclusive, sequence) BEFORE conforming. SoT: `plan/route-migration/README.md` /creating row (`creating/[...tab].astro`, line 303).
- **Conformance playbook (locked, reaffirmed this conv):** colour — interactive→americana (`<Button>`/`text-primary-default`); decorative→brand; semantic status WITH a Matt token→map (Published/Active/completed→success, scheduled/processing→info, pending/draft/archived→warning, cancelled/failed→error); tokenless categorical/identity→keep honest-orphan UNLESS the user maps it. `dark:` DROPPED. Spacing→literal-px (in-set bare {4,8,12,16,20,24,32,40,48,64}=intended px, else `[Npx]`); radius `rounded-xl`→`rounded-12`/`-lg`→`-8`. type→Matt tokens (text-2xl→h2-bold, text-lg→h3-bold, text-base→body-medium-bold, text-sm→body-default, text-xs→body-small; `-bold` for font-medium/semibold). Detail: `docs/decisions/05-ui-ux-components.md`.
- **🔴 Course-level badge precedent (Conv 323 USER decision):** difficulty→semantic ramp (beginner→success / intermediate→warning / advanced→error / unknown→neutral), NOT honest-orphan. Apply consistently in CR-STUDIO + any course-level badges elsewhere (→ [XCUT-BACKREF]). Consequence: Beginner+Published render both success-green. Recorded in `docs/decisions/05-ui-ux-components.md` + decision-log.
- **🔴 Matt ramp steps (durable):** brand/success/warning/error/info = {100,300,500} ONLY; neutral = {50,100,300,500,700,900} ONLY (no 200/400/600/800). `<Button>` variants primary/outlined/danger; property1 Default/Small (Small=px-12 py-8 text-body-small); americana fill `bg-primary-default`/`bg-text-primary`, americana text `text-primary-default`, pill radius baked in (39px). Keep icon-ghost / compact-confirm-strip / outlined-danger buttons raw-tokenized (no Button variant fits).
- **DOM-verify procedure:** persistent :4321 dev server; dev-login `POST /api/auth/dev-login {email}` → hard-nav → settle ~1.6s → read computed styles. Role-gated states need the matching account (creator `gabriel-rymberg@example.com`; non-creator `newuser@example.com`/Alex Chen for the apply FORM state). **Restore the session to the original user after** — dev-login swaps the shared :4321 cookie for ALL same-origin tabs.
- **MEMORY.md at 81% bytes** — #23 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Commits this conv (will be pushed at this r-end):** code `aab40134` + `89a73e49` + `12401b89` on jfg-dev-14; docs `3c25634` (counter) + `6da653e` + `09088ee` + `232bca3` + the end-of-conv bookkeeping commit on main.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
