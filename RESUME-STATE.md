# State — Conv 317 (2026-06-21 ~19:04)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Continued the route sweep (RTMIG-4). **Closed RG-PUBPROF 3/3** by sweeping the last route `/creator/[handle]` (rehost `git mv old→root`, `fetchCreatorProfileData` loader, gradient hero→white card, `<Button>`/`UserAvatar`/`getRatingDisplay`, Creator-purple badge) + **[CCARD-CONF]** (shared CourseCard conformed 3-axis). DOM-verified all 3 RG-PUBPROF pages coherent; corrected two carry-over claims (CourseCard footprint = 5 not 18, renders live only on /creator) and logged 3 dead components under #4. Committed code `13b66d7b` / docs `afc2572` (mid-conv). Then **assessed RG-WORKSPACES + unblocked it**: client resolved the old-vs-new comparison (individual dashboards approved; composite `/dashboard` not ported, kept in `/old/*`) → ⛔ freeze lifted; recorded in memory + README. `/learning` assessed + 5-component conformance planned but **paused** (not started, per user) before the conformance edits.

## Completed

- [x] **RG-PUBPROF closed 3/3** — `/creator/[handle]` ☑ Swept (rehost+loader, flatten to hub white-card, Creator-purple badge); DOM-verified visitor/own/not-found; committed code `13b66d7b` / docs `afc2572`.
- [x] **#26 [CCARD-CONF]** — shared CourseCard conformed 3-axis (props frozen; featured→brand, new→success, popular/bestseller honest-orphans).
- [x] All 3 RG-PUBPROF pages cross-verified coherent (hub/@handle + /teacher + /creator), 0 forbidden tokens, console clean.
- [x] 3 dead components confirmed + logged under #4 (FeaturedCourses fully dead; CourseBrowse + CourseDetail test-only dead) — NOT deleted.
- [x] **RG-WORKSPACES UNBLOCKED** — client comparison resolved; memory `project_role_studios_deconstruct_nudges` + route-migration README updated (Conv-256 freeze rule superseded).
- [x] `/learning` assessed; 5-component conformance plan captured in README `/learning` row.

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 (umbrella, in_progress)
- [ ] [RG-WORKSPACES] #6 (in_progress) — **UNBLOCKED.** `/learning` is next: execute the 5-component conformance (plan in `plan/route-migration/README.md` /learning row): StudentDashboard own-markup (30) + StudentSessionsList (54) are non-shared; **EnrollmentCard (34) / CertificatesSection (15) / MyFeeds (25) are shared with the deprecated /old/dashboard — conforming them incidentally restyles it (OK)**. Map: slate `secondary-*`→`neutral-*`, sky `primary-*`→`brand-*` (brand-300-vs-500 context nuance — DOM-verify vs precedent), `rounded-xl/lg`→`12/8`, type→Matt; honest-orphan keeps = status/cert-type/feed tints; star→`text-star`; CTAs→`<Button>`. Then /teaching, /creating, etc. (they share MyFeeds/dashboard comps too — same unblock applies).
- [ ] [RG-DISCOVER] #7 — `/feed`+`/feeds` remain (likely-retire); `/members` done Conv 315
- [ ] [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #15 (conf OUT)

**Cross-cutting / shared-component conformance:**
- [ ] [XCUT-BACKREF] #23 — re-glance swept routes after cross-cutting extractions (SegmentedPills multi-select; CourseCard done — minimal live footprint).

**OLD cleanup:**
- [ ] [OLD-PORTED-CLEANUP] #4 — 44 candidate `/old` routes + 2 dead comps (Conv 316) + **3 NEW dead CourseCard comps (Conv 317)**: FeaturedCourses (single-file safe-delete), CourseBrowse (+test), CourseDetail (+test). Per-route inbound-ref check FIRST. Detail in `.scratch/creator-sweep-conv317.md`.
- [ ] [PREFLIP-WT] #5 — teardown preflip worktree (after client-vetting).

**Conformance foundations:**
- [ ] [PALETTE-FDN] #20 · [SPACING-4PX-SWEEP] #21 · [SWEEP-SPACING-GREP] #22 · [LAYOUT-SG] #14

**Memory system:**
- [ ] [MEM-CAP-ARCH] #24 [Opus] — MEMORY.md auto-load cap architecture (fired again at 80% bytes 20481/25600 at this conv's r-start; both prune levers exhausted — do NOT just re-prune).

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #25 · [PROV-STAMP-GAPS] #16 · [HOME-FIXES] #17 · [COURSES-FIXES] #18 · [E2E-MIG] #8 · [E2E-GATE] #9 · [ICN-NS] #10 · [TZ-AUDIT] #11 [Opus] · [DOCGEN-SPEC] #12 · [V217-WATCH] #13 · [M4-ZGUARD] #19

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #4 [OLD-PORTED-CLEANUP] · #5 [PREFLIP-WT] · #6 [RG-WORKSPACES] (in_progress) · #7 [RG-DISCOVER] · #8 [E2E-MIG] · #9 [E2E-GATE] · #10 [ICN-NS] · #11 [TZ-AUDIT] [Opus] · #12 [DOCGEN-SPEC] · #13 [V217-WATCH] · #14 [LAYOUT-SG] · #15 [RG-PUBLIC] · #16 [PROV-STAMP-GAPS] · #17 [HOME-FIXES] · #18 [COURSES-FIXES] · #19 [M4-ZGUARD] · #20 [PALETTE-FDN] · #21 [SPACING-4PX-SWEEP] · #22 [SWEEP-SPACING-GREP] · #23 [XCUT-BACKREF] · #24 [MEM-CAP-ARCH] [Opus] · #25 [SWEEP-FULLSUITE]

(#3 [RG-PUBPROF] + #26 [CCARD-CONF] completed this conv.)

## Key Context

- **`/learning` is the next RG-WORKSPACES unit** — assessed + planned, conformance NOT started. Full plan in `plan/route-migration/README.md` /learning row. 5 components, all now free to conform (⛔ lifted).
- **The RG-WORKSPACES unblock applies to the WHOLE group.** `/teaching` + `/creating` also share `MyFeeds` and the dashboard components with the deprecated `/old/dashboard` — the same client decision (freeze lifted) covers them. `/old/dashboard` is **kept** (not retired/deleted), only the appearance-freeze is lifted.
- **Canonical legacy→Matt token map** is in `plan/typo-fdn/migration-ledger.md` (20+ prior components): slate `secondary-*`→`neutral-*`, sky `primary-*`→`brand-*` (NOTE: `primary-default`/`primary-light` are VALID americana-blue role tokens, NOT legacy — verify-before-counting), red→`error-*`, star gold→`text-star`, `rounded-xl/lg`→`rounded-12/8`. Spacing collapse-fix: legacy numeric ×4 (`p-4`→`p-16`).
- **🔴 git pathspec + Astro `[param]` trap:** `git add 'src/pages/x/[id]/...'` treats `[id]` as a glob char-class → never matches the literal dir → `git add` aborts staging ALL args. Stage the parent dir (`git add src/pages/x/`) or `:(literal)`. Always `--stat`-verify commits touching bracketed routes. (Cost me an incomplete commit this conv.)
- **Chrome bridge redacts JS-result keys containing "Token"** → rename DOM-assertion keys (`legacyClassHits` not `forbiddenLegacyTokens`).
- **MEMORY.md cap at 80% bytes** — #24 [MEM-CAP-ARCH] is the architectural fix (do NOT re-prune).
- **r-end prune note:** a linter modified the Extract mid-prune this conv, shifting manifest line numbers → over-deletion; Extract was rewritten by hand. The manifest-prune invariant (Extract immutable post-Step-2) is broken by linters.
- **Dev server up** (4321/4322/4323) this conv; Chrome bridge tab used for DOM-truth; local D1 creator handle `guy-rymberg` (also a teacher).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
