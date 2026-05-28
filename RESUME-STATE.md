# State — Conv 207 (2026-05-28 ~11:49)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 207 was the big STANDIN-MATT retrofit pass. Three of the four remaining `@stand-in` pages — login, signup, onboarding — were promoted to `@matt-inspired` via composing newly-built form primitives (11 new: Input, FormField, PasswordInput, Select, SelectableCard, FormBanner, FormSection, SkeletonCard, ErrorState, SearchInput, SegmentedPills). `/courses` CoursesFilters retrofit bonus (SearchInput + SegmentedPills + Select). Conv-level decisions: adopted the **3-marker page-provenance convention** (`@stand-in` / `@matt-source` / `@matt-inspired` — unmarked = legacy); deleted `/teachers/[handle].astro` (zero live callers); applied 8 `@matt-source` markers to course/[slug]/[...tab].astro. Page-provenance audit classified index.astro + courses.astro as `@matt-inspired` and 404.astro as `@stand-in`. Test fix: FormField asterisk-outside-label resolved 35 form-test failures (LoginForm 14, SignupForm 18, OnboardingProfile 3 → 71/71 pass; full suite 6452/6452). All 5 baseline gates green. New memories: `feedback_scan_for_primitive_candidates_on_retrofit` + `feedback_codecheck_moment_includes_tests_and_build`.

## Completed

- [x] Conv 207 /r-start (27 tasks transferred from RESUME-STATE)
- [x] [STANDIN-MATT] scope-trim — removed Conv 205 discover-destinations addendum (DISC-DROP now owns)
- [x] [STANDIN-MATT] Deleted /teachers/[handle].astro (zero live callers)
- [x] [STANDIN-MATT] Removed stale @stand-in marker from course/[slug]/[...tab].astro
- [x] [STANDIN-MATT] Added 8 @matt-source markers to course/[slug]/[...tab].astro
- [x] [STANDIN-MATT] Login retrofit (3 primitives + LoginForm rewrite + @matt-inspired)
- [x] [STANDIN-MATT] Signup retrofit (SignupForm rewrite + @matt-inspired)
- [x] [STANDIN-MATT] Onboarding retrofit (6 primitives + OnboardingProfile rewrite + @matt-inspired)
- [x] Adopted 3-marker page-provenance convention
- [x] /courses CoursesFilters retrofit (2 primitives + @matt-inspired)
- [x] Page-provenance audit (index/courses → @matt-inspired, 404 → @stand-in)
- [x] Pre-existing CourseCatalogCard added to PHASE6_EXTRAPOLATION_CANDIDATES
- [x] Test fix: FormField asterisk-outside-label + 3 test edits → 35 failures resolved
- [x] Full baseline gates green (tsc/check/lint/build/test 6452/6452)
- [x] Route-doc regen
- [x] /w-codecheck SKILL.md edits made then reverted (kept at 8 checks)
- [x] Memory: feedback_scan_for_primitive_candidates_on_retrofit.md
- [x] Memory: feedback_codecheck_moment_includes_tests_and_build.md

## Remaining

**Carried-forward backlog (Conv 206 originals + new this conv):**
- [ ] [STANDIN-MATT] [Opus] Retrofit /profile (last @stand-in page; complex, deferred from Conv 205)
- [ ] [DISC-DROP] [Opus] Finish discover-page migration (Stages 3+4) — now owns 4 unique destinations
- [ ] [DISC-RTB-RECONCILE] [Opus]
- [ ] [AICODING-SEED]
- [ ] [DISC-UNIFY] — pointer to DISC-DROP
- [ ] [RTMIG-4] [Opus]
- [ ] [E2E-MIG]
- [ ] [E2E-GATE] [Opus]
- [ ] [PREFLIP-WT]
- [ ] [MATT-EXEC-PG2] [Opus]
- [ ] [MATT-EXEC-EXT] [Opus]
- [ ] [RTB] [Opus]
- [ ] [ADMIN-REDIRECT-BLANK]
- [ ] [MMP-PH5] [Opus]
- [ ] [MATT-EXEC-GRD]
- [ ] [MMP-PH3] [Opus]
- [ ] [SHOWMORE]
- [ ] [CH-VARIANTS]
- [ ] [ICN-NS] [Opus]
- [ ] [HOWTOREG-ICN]
- [ ] [ASSET-SWEEP-GATE]
- [ ] [MFRD-LOOKUP]
- [ ] [ESOT-STRUCTURE]
- [ ] [BROWSER-FALLBACK]
- [ ] [TXTBTN]
- [ ] [DTUNE-WATCH]
- [ ] [SKILL-DISCOVERY-AUDIT]
- [ ] [PROV-CODIFY] — codify 3-marker convention in CLAUDE.md + matt-design-system docs (NEW Conv 207)
- [ ] [PROV-SWEEP-MI] — teach prov-sweep.ts about @matt-inspired (NEW Conv 207)
- [ ] [STANDIN-404] — retrofit 404.astro from @stand-in to @matt-inspired (NEW Conv 207)
- [ ] [OPM-REGEN] — regen orig-pages-map.md auto-gen (NEW Conv 207, surfaced by docs agent)

## TodoWrite Items

- [ ] #1 [STANDIN-MATT] [Opus] / #2 [DISC-DROP] [Opus] / #3 [DISC-RTB-RECONCILE] [Opus]
- [ ] #4 [AICODING-SEED] / #5 [DISC-UNIFY]
- [ ] #6 [RTMIG-4] [Opus] / #7 [E2E-MIG] / #8 [E2E-GATE] [Opus] / #9 [PREFLIP-WT]
- [ ] #10 [MATT-EXEC-PG2] [Opus] / #11 [MATT-EXEC-EXT] [Opus] / #12 [RTB] [Opus] / #13 [ADMIN-REDIRECT-BLANK]
- [ ] #14 [MMP-PH5] [Opus] / #15 [MATT-EXEC-GRD] / #16 [MMP-PH3] [Opus] / #17 [SHOWMORE] / #18 [CH-VARIANTS]
- [ ] #19 [ICN-NS] [Opus] / #20 [HOWTOREG-ICN] / #21 [ASSET-SWEEP-GATE] / #22 [MFRD-LOOKUP]
- [ ] #23 [ESOT-STRUCTURE] / #24 [BROWSER-FALLBACK] / #25 [TXTBTN] / #26 [DTUNE-WATCH] / #27 [SKILL-DISCOVERY-AUDIT]
- [ ] #28 [PROV-CODIFY] / #29 [PROV-SWEEP-MI] / #30 [STANDIN-404] / #31 [OPM-REGEN]

## Key Context

- **3-marker page-provenance convention** (Conv 207): every non-legacy page carries exactly ONE of `@stand-in` / `@matt-source <nodeId>` / `@matt-inspired`. Unmarked = legacy. dev/* opt-out.
- **Form primitive surface** (11 new): `src/components/form/{Input,FormField,PasswordInput,Select,SelectableCard,FormBanner,FormSection,SearchInput,SegmentedPills}.tsx` + `src/components/ui/{SkeletonCard,ErrorState}.tsx`. All registered in `PHASE6_EXTRAPOLATION_CANDIDATES`.
- **FormField asterisk-outside-label** pattern (Conv 207): required indicator sits next to but NOT inside `<label>` element. Preserves accessible name = label text exactly; makes `getByLabelText(/^pattern$/)` work in tests.
- **/teachers/[handle] route deleted.** StudentTeacherAnchor.tsx:41 default `ctaHref = '/teachers/${slug}'` now 404s honestly. Consumers must pass `ctaHref` explicitly.
- **course/[slug]/[...tab].astro** carries 8 @matt-source markers: 480:10833 (Feed) + 496:12305 (About) + 497:12795 (Modules) + 534:11206 (Reviews) + 537:12144 (Resources) + 537:12780 (Teachers) + 552:13664 (Creator) + 517:8934 (Hero Course Header component set).
- **/w-codecheck unchanged** (8 checks). Memory `feedback_codecheck_moment_includes_tests_and_build.md` codifies decision-point: at /w-codecheck trigger, decide per change whether prov-sweep / tests / build belong in this pass. None auto-bundled.
- **Memory `feedback_scan_for_primitive_candidates_on_retrofit.md`**: when retrofitting @stand-in or legacy pages, scan for primitive candidates BEFORE writing inline JSX. Login retrofit revealed 3 primitives; signup composed them with zero new ones; onboarding revealed 6 more; /courses revealed 2 more. Total 11 in this conv.
- **CoursesFilters** (`/courses` filter row) now `@matt-inspired`. Uses SearchInput + SegmentedPills (with Matt level icons) + Select.
- **All 5 baseline gates green this conv:** tsc 0; astro check 1290/0/0/0; lint 0; build clean 7s; test 6452/6452. Verified end of conv after FormField fix.
- **Branch:** `jfg-dev-13-matt` (code), `main` (docs).
- **Next-conv directive:** [STANDIN-404] is the simplest finish-of-STANDIN-MATT pass (404.astro restyle). /profile is the genuine remaining @stand-in retrofit but is "complex" per Conv 205 — may want to pair with [PROV-CODIFY] codification to land the 3-marker convention story together.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
