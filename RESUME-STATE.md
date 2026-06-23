# State — Conv 324 (2026-06-22 ~20:03)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Route sweep (RTMIG-4) — **completed [CR-STUDIO] in full**, the carried 🔴 [Opus] blocker. Decomposed the ~4,726-line CreatorStudio tree (by mount hierarchy) into **5 cohesion units + 1 cross-cut carve-out**, then conformed/gated/DOM-verified all 5 this conv: **A [CR-ST-ENTRY]** (CreatorStudio+CreateCourseModal), **B [CR-ST-CURRIC]** (CurriculumEditor), **C [CR-ST-HW]** (HomeworkEditor), **D [CR-ST-RES]** (ResourcesEditor), **E [CR-ST-SHELL]** (CourseEditor shell + 7 sub-comp tabs). Payoff: **full-page UNSCOPED DOM leak = 0** on `/creating/studio?course=…` (chrome + all 8 tabs end-to-end). `/creating/[...tab]` flipped ☑ SWEPT → **[RG-WORKSPACES] cluster COMPLETE (6/6)**. 10 commits (5 code on jfg-dev-14: `2cf05892`/`fea60cf2`/`f20d1b03`/`3a51646a`/`1c8ced4d`; 5 docs on main) + this end-of-conv. Only the cross-cut **[CONFIRMMODAL-CONF]** remains in the CR-STUDIO orbit.

## Completed

- [x] [CR-ST-ENTRY] #30 — CreatorStudio + CreateCourseModal ☑ Swept. Code `2cf05892`, docs `cd55243`.
- [x] [CR-ST-CURRIC] #31 — CurriculumEditor ☑ Swept. Code `fea60cf2`, docs `89e9578`.
- [x] [CR-ST-HW] #32 — HomeworkEditor ☑ Swept (Required→error, pending→warning). Code `f20d1b03`, docs `13eb76f`.
- [x] [CR-ST-RES] #33 — ResourcesEditor ☑ Swept (Public→success, external-link→americana). Code `3a51646a`, docs `e61a2c2`.
- [x] [CR-ST-SHELL] #34 — CourseEditor shell + 7 tabs ☑ Swept (prereq chips→error/warning/success, info box→brand). Code `1c8ced4d`, docs `0aba1da`.
- [x] [CR-STUDIO] #26 — all 5 units complete; full-page unscoped DOM leak = 0.
- [x] [RG-WORKSPACES] #5 — `/creating/[...tab]` swept → cluster 6/6 COMPLETE.

## Remaining

**Cross-cut follow-on from CR-STUDIO:**
- [ ] [CONFIRMMODAL-CONF] #35 — conform shared ConfirmModal (99 ln, 4 legacy occ, ~19 consumers incl. conf-OUT admin/teachers/community/booking). **Decide conform-and-back-glance vs keep-honest** before any work; sibling of [COURSEFEED-CONF]. Kept honest within CR-STUDIO this conv.

**Route sweep umbrella + next groups:** [RTMIG-4] #1 (in_progress) · [RG-DISCOVER] #6 (next group) · [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #14 (conf OUT)

**Cross-cutting / shared:** [COURSEFEED-CONF] #25 · [XCUT-BACKREF] #22 · [TA-SKEL] #28 (TeacherAnalytics skeleton `w-80`/`w-96`→`[80px]`/`[96px]`)

**Conformance foundations:** [PALETTE-FDN] #19 · [SPACING-4PX-SWEEP] #20 · [SWEEP-SPACING-GREP] #21 · [LAYOUT-SG] #13

**Memory system:** [MEM-CAP-ARCH] #23 [Opus] — MEMORY.md fired at 81% bytes again this conv's r-start; architectural fix needed (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #24 · [VITE-DEDUP] #29 · [PROV-STAMP-GAPS] #15 · [HOME-FIXES] #16 · [COURSES-FIXES] #17 · [E2E-MIG] #7 · [E2E-GATE] #8 · [ICN-NS] #9 · [TZ-AUDIT] #10 [Opus] · [DOCGEN-SPEC] #11 · [V217-WATCH] #12 · [M4-ZGUARD] #18 · [OLD-PORTED-CLEANUP] #3 · [PREFLIP-WT] #4 · [REVIEW-COUNT-SRC] #27

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [OLD-PORTED-CLEANUP] · #4 [PREFLIP-WT] · #6 [RG-DISCOVER] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [LAYOUT-SG] · #14 [RG-PUBLIC] · #15 [PROV-STAMP-GAPS] · #16 [HOME-FIXES] · #17 [COURSES-FIXES] · #18 [M4-ZGUARD] · #19 [PALETTE-FDN] · #20 [SPACING-4PX-SWEEP] · #21 [SWEEP-SPACING-GREP] · #22 [XCUT-BACKREF] · #23 [MEM-CAP-ARCH] [Opus] · #24 [SWEEP-FULLSUITE] · #25 [COURSEFEED-CONF] · #27 [REVIEW-COUNT-SRC] · #28 [TA-SKEL] · #29 [VITE-DEDUP] · #35 [CONFIRMMODAL-CONF]

## Key Context

- **Resume = [CONFIRMMODAL-CONF] #35 or [RG-DISCOVER] #6.** ConfirmModal is the one open CR-STUDIO follow-on (a cross-cut DECISION, not a route unit); RG-DISCOVER is the next route group under RTMIG-4. SoT: `plan/route-migration/README.md`.
- **Conformance playbook (locked, reaffirmed + extended this conv):** colour — interactive→americana (`<Button>`/`text-primary-default`); decorative→brand; semantic status WITH a Matt token→map (Published/Active→success, scheduled/processing→info, pending/draft→warning, cancelled/failed→error); tokenless categorical→honest-orphan UNLESS user maps. Spacing→literal-px (in-set bare {4,8,12,16,20,24,32,40,48,64}=intended px via ×4 bridge-restore, else `[Npx]`; e.g. `w-48`→`[192px]`, `w-9`→`[36px]`); radius `rounded-lg`→`rounded-8`/`-xl`→`-12`/badge `rounded`→`-4`. Type→Matt tokens (`text-2xl`→`h2-bold`, `text-lg`→`h3-bold`, `text-sm`→`body-default`, `text-xs`→`body-small`; `-bold` for font-medium/semibold). `dark:` DROPPED. Detail: `docs/decisions/05-ui-ux-components.md`.
- **🔴 Status-badge precedents (Conv 324 USER decision):** Retired course-status → `neutral` (kept distinct from Draft=warning), deviating from literal "archived→warning". Published→success, Draft→warning. **Level badges → Conv-323 difficulty ramp** (beginner→success/intermediate→warning/advanced→error). Apply consistently (→ [XCUT-BACKREF]).
- **🔴 Other Conv-324 token maps (in `05-ui-ux-components.md`):** prereq chips required/nice/not→error/warning/success; "Required" assignment badge→error; "About PeerLoop" info box→brand (decorative-indigo→brand, brand-identity content); publish-checklist tick→success/incomplete→neutral; Teacher activate/deactivate/revoke→success/warning/error compact (raw); shared ConfirmModal **kept honest** → [CONFIRMMODAL-CONF].
- **Scoped vs unscoped DOM-verify pattern (new this conv):** verify each child editor with a leak-check **scoped to its own subtree** while the parent chrome is still legacy; verify the parent shell with an **unscoped full-page sweep** once it lands (then any residual is unambiguously the shell's). Leaves-before-shell sequencing makes the final unscoped `leak=0` a real end-to-end cert.
- **DOM-verify procedure:** persistent :4321 dev server; dev-login `POST /api/auth/dev-login {email}` → hard-nav → settle ~1.6s → read computed styles. **Bridge tab was an ISOLATED context this conv (empty cookies) — no clobber of the user's main :4321 session, no restore needed.** Creator account `gabriel-rymberg@example.com`; course `crs-intermediate-q-system` (7 modules, 1 homework, 1 resource — good for editor tabs). Teacher status buttons couldn't be DOM-verified live (no teachers/eligible on that course) — verified in code.
- **MEMORY.md at 81% bytes** — #23 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Commits this conv (pushed at this r-end):** code `2cf05892`+`fea60cf2`+`f20d1b03`+`3a51646a`+`1c8ced4d` on jfg-dev-14; docs `d089f44`(counter)+`cd55243`+`89e9578`+`13eb76f`+`e61a2c2`+`0aba1da` + end-of-conv bookkeeping on main.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
