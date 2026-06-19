# State — Conv 304 (2026-06-19 ~11:03)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Three threads. (1) Created the **USER-WIP.md** authored-file workflow — the one file the user edits directly (git-tracked, CC-read-only, auto-saved at r-end Step 1.5). (2) Established the **cross-cutting / shared-surface backward-pointer policy** for the route sweep (sweep = client-showable; shared comps conform at first-touch; ≥2-swept-consumer surfaces record back-pointers so a later change re-glances the swept routes). (3) Started **[CDETAIL-CONF]** — the conformance 4-gate backfill of the `/course/[slug]/[...tab]` hub (3 of ~15 components green: CourseHeader hero type, AnalyticCount `trigger` extension, ReviewsTab adoption). Clarified `/` and `/courses` are already conformance-complete. Multi-conv. Committed code `589d8cc6` + docs `3ec87b5` (+ this r-end commit).

## Completed

- [x] USER-WIP.md workflow (file + CLAUDE.md § "User WIP File" + r-end Step 1.5 + memory carve-out); Step 1.5 validated idempotent (clean-file skip).
- [x] Cross-cutting / shared-surface backward-pointer policy (README § + tier2-ledger convention + `feedback_route_sweep_pause_protocol`); [XCUT-BACKREF] created.
- [x] [CDETAIL-CONF] STARTED — 3/~15 hub components: CourseHeader hero type (700→600 text-h1-bold + h3-bold + body-medium-medium); AnalyticCount `trigger` extension (backward-compat); ReviewsTab adopts all 3 pills + prose tokens + name-tracking drop. Gates green (tsc 0, astro 0/0/0).
- [x] Full hub exception inventory + decided conventions recorded in the conformance ledger.
- [x] Scope correction: `/` (Conv 300) + `/courses` (Conv 301) already conformance-complete — only need [XCUT-BACKREF] back-pointers.

## Remaining

**Active backfill (this conv's thread):**
- [ ] [CDETAIL-CONF] #34 — finish the `/course/[slug]/[...tab]` hub: CreatorTab (+ **OPEN: TagPill→EntityPill muted-variant decision**), ModulesTab, MattCourseFeed, PrecheckoutContent, MySessionsTab, TeachersTab → spacing pass (CourseHeader `px-[60px]` off-scale etc.) → ledger rows + exceptions + AnalyticCount back-pointer → browser-verify (member+visitor DOM-truth) → mark Swept. Then `/book` + `/success`. Full spec in the task description.
- [ ] [XCUT-BACKREF] #33 — retro-seed back-pointers for ≥2-swept-consumer shared surfaces across RG-HOME/COURSES/PROFILE.

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-COMMS] #9 · [RG-DISCOVER] #10 · [RG-MESSAGES] #19 · [RG-NOTIFS] #20 · [RG-SESSIONS] #21 · [RG-MOD] #22 · [RG-PUBLIC] #23 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Primitives / conformance foundations:**
- [ ] [PROFILE-PRIM-SWEEP] #32 [Opus] · [PALETTE-FDN] #28 · [SPACING-4PX-SWEEP] #30 · [LAYOUT-SG] #18

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #25 · [COURSES-FIXES] #26 · [PROV-STAMP-GAPS] #24 · [STALE-TESTS] #29 · [SWEEP-SPACING-GREP] #31 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [MEM-PRUNE] #17 · [M4-ZGUARD] #27

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-COMMS] · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #17 [MEM-PRUNE] · #18 [LAYOUT-SG] · #19 [RG-MESSAGES] · #20 [RG-NOTIFS] · #21 [RG-SESSIONS] · #22 [RG-MOD] · #23 [RG-PUBLIC] · #24 [PROV-STAMP-GAPS] · #25 [HOME-FIXES] · #26 [COURSES-FIXES] · #27 [M4-ZGUARD] · #28 [PALETTE-FDN] · #29 [STALE-TESTS] · #30 [SPACING-4PX-SWEEP] · #31 [SWEEP-SPACING-GREP] · #32 [PROFILE-PRIM-SWEEP] [Opus] · #33 [XCUT-BACKREF] · #34 [CDETAIL-CONF]

## Key Context

- **CDETAIL-CONF resume (hub-first):** 8 components clean; CourseHeader/AnalyticCount/ReviewsTab done (Conv 304). **DECIDED conventions:** `text-body-default leading-normal`→`text-body-default-prose` (body-default alone = dense lh 1.0 — NOT a leading-drop); hero `font-bold` 700→`text-h1-bold` (600); `font-semibold`→`-bold` tokens, `font-medium`→`-medium` tokens (`text-body-medium-medium`=16/500); About-style heading `text-black`→`text-text-default` but **person-name `text-black` KEPT** (SocialPost #000 precedent); emoji 👍💕💬 KEPT. **Exceptions:** image scrims, `#1f2937`/`#414141` fallbacks, `text-white`/`bg-white`, 7px avatar initials, radii/sizes, `py-[2px]`. SoT: `plan/typo-fdn/migration-ledger.md` § course-detail.
- **AnalyticCount** (`src/components/ui/AnalyticCount.tsx`) extended with `trigger` variant — backward-compat; `#f6f6f6`/rgba = documented `@matt-source` signature (recorded exception at the primitive). **Back-pointer: swept consumers = `/` (SocialPost), `/course/[slug]` (ReviewsTab).**
- **Cross-cutting policy:** sweep done = client-showable; shared comps conform first-touch; ≥2-swept-consumer surfaces record back-pointers (re-glance on later change). SoT: `plan/route-migration/README.md` § "Cross-cutting / shared-surface handling".
- **USER-WIP.md:** user-authored, git-tracked, **CC READ-ONLY**; auto-saved by `/r-end` Step 1.5. `/r-start` unmodified (dirty HALT = safety net).
- **`/` and `/courses` are conformance-complete** (Conv 300/301) — do NOT re-do; the course-detail family is the remaining backfill.
- **MEMORY.md at 88%** of the SessionStart auto-load cap → [MEM-PRUNE] #17 (not addressed this conv).
- Conv-304 commits: code `589d8cc6`, docs `3ec87b5` (+ this r-end commit). Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
