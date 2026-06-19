# State — Conv 305 (2026-06-19 ~13:50)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Drove **[CDETAIL-CONF]** to **code-complete end-to-end**: conformed every component of the `/course/[slug]/[...tab]` hub (CourseHeader, EntityPill, CreatorTab, ModulesTab, MattCourseFeed, PrecheckoutContent, MySessionsTab, TeachersTab) **plus** the `/book` + `/success` sibling routes and their islands (SessionBooking, MilestoneComposer, ExpectationsForm) — all 3 conformance axes, all gates green. Resolved the two carried-over open questions (TagPill→EntityPill `muted` variant; CourseHeader off-scale spacing). **Generalized a project-wide policy:** off-scale `@matt-source` spacing now SNAPS to nearest 4px step (ties round up) rather than kept as exception — §170 carve-out + memory `project_spacing_snap_over_matt_exception`. Also caught + fixed TeachersTab's stale Spacing ☑ (predated the policy). The ONLY remaining CDETAIL-CONF step is the **browser-verify** (member + visitor, DOM-truth) → then mark the route Swept. Commits: code `f3a4b3f6`/`4192da12`/`22d4952f`/`ac81d585`, docs `d2134bf`/`6b9fee8`/`f0b1d9b`/`43d9243` (+ this r-end commit). Code on `jfg-dev-14`.

## Completed

- [x] [CDETAIL-CONF] resolved both open questions: TagPill→EntityPill `muted` variant (`bg-neutral-50`+`text-text-tertiary`); CourseHeader off-scale spacing → snap-to-scale.
- [x] **Spacing-axis snap policy GENERALIZED** — §170 carve-out (off-scale matt-source spacing snaps to nearest 4px step, ties round up; Colour keeps exceptions) + memory `project_spacing_snap_over_matt_exception` + routed to `docs/decisions/05-ui-ux-components.md`.
- [x] Hub code-complete (3 axes): CourseHeader, EntityPill, CreatorTab, ModulesTab, MattCourseFeed, PrecheckoutContent, MySessionsTab, TeachersTab.
- [x] `/book` + `/success` code-complete: book.astro, SessionBooking (mostly conformant from Conv-242), success.astro, MilestoneComposer, ExpectationsForm.
- [x] Fixed TeachersTab stale Spacing ☑ (surfaced + corrected — predated the snap policy).
- [x] Ledger fully updated (per-component rows + /book+/success subsection); 4 code + 4 docs commits.

## Remaining

**Active backfill (this conv's thread — nearly done):**
- [ ] [CDETAIL-CONF] #34 — **CODE-COMPLETE.** Only remaining: hub + `/book` + `/success` **browser-verify** (member + visitor, DOM-truth via dev server + Chrome bridge) → then mark the `/course/[slug]/[...tab]` route ☑ Swept and close the block. No code work left.

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-COMMS] #9 · [RG-DISCOVER] #10 · [RG-MESSAGES] #19 · [RG-NOTIFS] #20 · [RG-SESSIONS] #21 · [RG-MOD] #22 · [RG-PUBLIC] #23 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Primitives / conformance foundations:**
- [ ] [PROFILE-PRIM-SWEEP] #32 [Opus] · [PALETTE-FDN] #28 · [SPACING-4PX-SWEEP] #30 · [SWEEP-SPACING-GREP] #31 · [LAYOUT-SG] #18

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #25 · [COURSES-FIXES] #26 · [PROV-STAMP-GAPS] #24 · [STALE-TESTS] #29 · [XCUT-BACKREF] #33 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [MEM-PRUNE] #17 · [M4-ZGUARD] #27

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-COMMS] · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #17 [MEM-PRUNE] · #18 [LAYOUT-SG] · #19 [RG-MESSAGES] · #20 [RG-NOTIFS] · #21 [RG-SESSIONS] · #22 [RG-MOD] · #23 [RG-PUBLIC] · #24 [PROV-STAMP-GAPS] · #25 [HOME-FIXES] · #26 [COURSES-FIXES] · #27 [M4-ZGUARD] · #28 [PALETTE-FDN] · #29 [STALE-TESTS] · #30 [SPACING-4PX-SWEEP] · #31 [SWEEP-SPACING-GREP] · #32 [PROFILE-PRIM-SWEEP] [Opus] · #33 [XCUT-BACKREF] · #34 [CDETAIL-CONF]

## Key Context

- **CDETAIL-CONF resume = browser-verify only.** All code done. Verify the hub + `/book` + `/success` in-browser (member + visitor, DOM-truth — `reference_chrome_bridge_island_stale_cache`), confirm the spacing snaps render right, then mark the route ☑ Swept in `plan/route-migration/README.md` and close #34. SoT for component conformance: `plan/typo-fdn/migration-ledger.md` § course-detail + § /book+/success.
- **SPACING snap policy (NEW, governs all remaining spacing work):** off-scale `@matt-source` spacing snaps to nearest 4px step, **ties round up** (`gap-[10px]`→`gap-12`, `gap-[6px]`→`gap-8`, `px-[14px]`→`px-16`); `px-[60px]`→`px-64`, `gap-[19px]`→`gap-20`, `gap-x-[30px]`→`gap-x-32`. Even when Figma confirms the value is Matt's exact (CourseHeader case). Colour KEEPS its exception model. SoT: migration-ledger §170 carve-out + memory `project_spacing_snap_over_matt_exception`.
- **🟠 Cross-cutting spacing debt:** components marked Spacing ☑ *before* Conv 305 (RG-HOME/COURSES/PROFILE) may carry stale off-scale spacing the new rule would snap (TeachersTab was a live example). Fold a grep pass into `[SWEEP-SPACING-GREP]` #31 / `[SPACING-4PX-SWEEP]` #30 when they run.
- **EntityPill `muted` variant** (`src/components/entity/EntityPill.tsx`) — `bg-neutral-50` + `text-text-tertiary` for static/placeholder pills (CC static-content signal, not a Matt frame variant). First consumer: CreatorTab static Expertise tags.
- **Colour calls this conv:** `#414141`=`neutral-700` exactly → tokenize (vs CourseHeader's tokenless `#1f2937` which stays raw); `ashy-blue`=`#EAEFF5`=Border-Default primitive → kept (no exact bg role token; SubNav precedent). Emerson quote `text-black`→`text-text-default` (not a person-name). Person-name `text-black` (#000) still KEPT everywhere (SocialPost precedent).
- **MEMORY.md at 88%** of the SessionStart auto-load cap → [MEM-PRUNE] #17 (not addressed this conv; one line added).
- Conv-305 commits: code `f3a4b3f6`/`4192da12`/`22d4952f`/`ac81d585`, docs `d2134bf`/`6b9fee8`/`f0b1d9b`/`43d9243` (+ this r-end commit). Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
