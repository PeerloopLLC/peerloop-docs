# State — Conv 316 (2026-06-21 ~16:17)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Continued the route sweep (RTMIG-4) on **RG-PUBPROF** (public profiles, 3 hub-and-spoke routes). **Swept 2/3:** `/@[handle]` hub (ported root, 5-component white-card conformance) and `/teacher/[handle]` (user decided to **flatten** the legacy coloured gradient hero to the hub white-card look; adopted the `fetchTeacherProfileData` SSR loader; conformed the route-local shared ReviewList/ReviewCard). Browser-verify surfaced + fixed 2 latent bugs (dead components; a hydration-mismatch date). Both routes committed mid-conv (code `41628d8d`, docs `c5efa25`) + DOM-verified (member/visitor/own/error). **`/creator/[handle]` checkpointed before code work** — its flatten recipe mirrors /teacher, but the shared `CourseCard` (course grid) turned out to be major untracked cross-cutting debt → split into [CCARD-CONF].

## Completed

- [x] `/@[handle]` ☑ **Swept** (RG-PUBPROF hub, 1/3) — ported `git mv old→root` (`@matt-inspired`); 5 comps conformed 3-axis (PublicProfile, UserCard, UserAvatar, CreatorTeaser, TeacherTeaser); Tier-2 `<Button>`×4; Creator-purple/Teacher-blue role hues kept honest-orphan; dead UserProfileHeader/QuickLinks logged → OLD-PORTED-CLEANUP. DOM-verified member/visitor/error, 0 forbidden tokens, 0 console errors. SoT: conformance ledger §/@[handle] + route-migration README.
- [x] `/teacher/[handle]` ☑ **Swept** (RG-PUBPROF, 2/3) — **flattened to hub white-card look** (user decision); `.astro` adopted `fetchTeacherProfileData` (inline SQL gone, [SSR-LOADER-DEAD] teacher-half resolved); conformed TeacherProfile/Header/AvailabilityCard + route-local ReviewList/ReviewCard; Tier-2 `<Button>`×6, ReviewCard stars→StarRating, avatar→UserAvatar. 🔴 fixed hydration-mismatch date bug (`timeZone:'UTC'`). DOM-verified member/own-profile/not-found. Cert-type tints + Teacher/Available badges kept honest-orphan. TeacherCard (directory card) excluded.
- [x] Committed hub+teacher (code `41628d8d`, docs `c5efa25`; not pushed at commit time — pushed at this r-end).

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 (umbrella, in_progress) · [RG-PUBPROF] #3 — **2/3 swept; only `/creator/[handle]` remains.** RESUME: structurally mirrors /teacher — flatten the `CreatorProfileHeader` hero (`from-primary-900→700`) to a white UserCard-style header; adopt `fetchCreatorProfileData` (drop-in, `primary_topic_id` mapped-but-unused-by-CourseCard); white-card the body (About/Philosophy/Courses-section/Expertise/Quals/At-a-Glance); `<Button>` adoption (Follow [non-functional placeholder — preserve]/Message/Website + own Edit/Creator-Dashboard); `CreatorCard.tsx` directory card EXCLUDED. ⚠️ DECIDE the CourseCard scope (see [CCARD-CONF]) when resuming. Same flatten direction already user-approved.
- [ ] [RG-WORKSPACES] #6 ⛔client — `/learning`,`/teaching`,`/creating` (6 routes); ⛔ = keep `/old/dashboard` live (vet), sweep is fine
- [ ] [RG-DISCOVER] #7 — `/feed`+`/feeds` remain (likely-retire); `/members` done Conv 315
- [ ] [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #15 (conf OUT)

**Cross-cutting / shared-component conformance:**
- [ ] [CCARD-CONF] #26 [Opus] — **NEW Conv 316.** Conform the shared `CourseCard` (198 ln): 18 consumers, untracked, legacy, already renders on SWEPT `/courses` + `/course/[slug]` = pre-existing cross-cutting debt. Conform 3-axis → backward-glance /courses + /course/[slug] ([XCUT-BACKREF]). `primary_topic_id` plumbed but unused by CourseCard.
- [ ] [XCUT-BACKREF] #23 — re-glance swept routes after cross-cutting extractions (SegmentedPills multi-select + now CourseCard).

**OLD cleanup:**
- [ ] [OLD-PORTED-CLEANUP] #4 — 44 candidate-deletable `/old` routes + the 2 dead comps (UserProfileHeader, UserProfileQuickLinks — 0 importers, logged Conv 316). Per-route inbound-ref check FIRST. List in `.scratch/old-routes-disposition-conv315.md`.
- [ ] [PREFLIP-WT] #5 — teardown preflip worktree (after client-vetting).

**Conformance foundations:**
- [ ] [PALETTE-FDN] #20 · [SPACING-4PX-SWEEP] #21 · [SWEEP-SPACING-GREP] #22 · [LAYOUT-SG] #14

**Memory system:**
- [ ] [MEM-CAP-ARCH] #24 [Opus] — MEMORY.md auto-load cap architecture (fired again at 80% bytes 20481/25600 at this conv's r-start; both prune levers exhausted — do NOT just re-prune).

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #25 · [PROV-STAMP-GAPS] #16 · [HOME-FIXES] #17 · [COURSES-FIXES] #18 · [E2E-MIG] #8 · [E2E-GATE] #9 · [ICN-NS] #10 · [TZ-AUDIT] #11 [Opus] · [DOCGEN-SPEC] #12 · [V217-WATCH] #13 · [M4-ZGUARD] #19

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [RG-PUBPROF] (in_progress, 2/3) · #4 [OLD-PORTED-CLEANUP] · #5 [PREFLIP-WT] · #6 [RG-WORKSPACES] ⛔client · #7 [RG-DISCOVER] · #8 [E2E-MIG] · #9 [E2E-GATE] · #10 [ICN-NS] · #11 [TZ-AUDIT] [Opus] · #12 [DOCGEN-SPEC] · #13 [V217-WATCH] · #14 [LAYOUT-SG] · #15 [RG-PUBLIC] · #16 [PROV-STAMP-GAPS] · #17 [HOME-FIXES] · #18 [COURSES-FIXES] · #19 [M4-ZGUARD] · #20 [PALETTE-FDN] · #21 [SPACING-4PX-SWEEP] · #22 [SWEEP-SPACING-GREP] · #23 [XCUT-BACKREF] · #24 [MEM-CAP-ARCH] [Opus] · #25 [SWEEP-FULLSUITE] · #26 [CCARD-CONF] [Opus]

## Key Context

- **`/creator/[handle]` is the next RG-PUBPROF item + the LAST route in the group** (→ RG-PUBPROF 3/3 closes). Flatten recipe is the proven /teacher pattern; the only real decision left is CourseCard. Sources: `old/creator/[handle]/index.astro` (inline SQL), `CreatorProfile.tsx` (202), `CreatorProfileHeader.tsx` (125, coloured hero `from-primary-900→700`).
- **[CCARD-CONF] is the gating decision for /creator's course grid.** CourseCard renders legacy on /creator AND on already-swept /courses + /course/[slug]. Decide conform-now (big, 18-consumer + backward-verify) vs defer (mark /creator swept w/ CourseCard noted as the one deferred shared surface). It is genuinely cross-cutting — its conformance benefits discover/dashboard/creating/marketing later too.
- **Loader-adoption pattern proven:** `fetchTeacherProfileData`/`fetchCreatorProfileData` are behavior-preserving drop-ins for the inline SQL (canonical `isTeacher/isCreatorSubquery` predicates). `primary_topic_id` (Conv-315 fix) is plumbed in the creator loader but **CourseCard doesn't render it** — nothing visible to verify there.
- **Hydration-mismatch date pattern ([TZ-AUDIT]):** `new Date(s).toLocaleDateString()` without `timeZone` diverges server(UTC)/client(local) on month-boundary dates → React hydration error. Fix = `timeZone:'UTC'`. Likely recurs in other ported components.
- **zsh gotcha:** unquoted `$FILES` in a multi-file grep does NOT word-split (SH_WORD_SPLIT off) → grep matches nothing → false "clean". Pass explicit quoted args.
- **[BRIDGE-MEM] own-profile verify:** detection via `getCurrentUser()` in a mount useEffect needs a WARM client cache — navigate once to warm, then again before asserting own-profile branch.
- **MEMORY.md cap at 80% bytes** — #24 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Dev server up** (4321/4322/4323) this conv; Chrome bridge tab used for DOM-truth.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
