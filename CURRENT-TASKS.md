# Current Tasks

> **Write-through task board.** Edit this file directly the moment a task changes — it *is* the task
> state (no Task-tool overlay; see `[TASK-TOOLS-VERIFY]`). Tracked in git so both machines share it via
> `/r-commit` push/pull. Per-conv history lives in `docs/sessions/` + git.
>
> **How it works.** `[CODE]` (unique, bracketed) is the stable key — the whole commit/timecard/memory
> system references it. Task **bodies** live in `## Tasks`, alphabetical by code, and **never move**.
> Ordering + status live in two tables of contents that link down to the bodies:
> - **`## 🎯 Now`** — the ordered execution queue (top = next). Reprioritise by reordering *here* only.
> - **`## ⏸️ Parked`** — gated / out-of-rotation, each with its gate.
>
> Reprioritise / start / park a task by editing a TOC line + its `State:` bullet — the body stays put.
> **Complete** a task by deleting its body from `## Tasks` and adding a one-liner to `## ✅ Done this conv`
> (cleared each `/r-start`). `[Opus]` on the `State:` line flags model tier. Only the four `## ` H2
> anchors (🎯 Now / ⏸️ Parked / Tasks / ✅ Done this conv) are load-bearing.

---

## 🎯 Now  (execution order — top = next)

> **▶ NEXT CONV (440) PRIORITY — clear the 163 codecheck warnings:** `[RHOOKS]` (88 react-hooks,
> mostly `set-state-in-effect`) + `[A11Y]` (75 jsx-a11y). Agreed Conv 439 (option C) after the new
> codecheck reporter surfaced them as the only non-PASS findings — non-blocking, but the chosen next
> focus. **Start here next conv** (behavior-sensitive for react-hooks — go carefully, not bulk).

> **MESSAGES mini-plan — ✅ COMPLETE (M1–M6, Convs 417–419).** `[MSGBOOT]` 417 · `[CANMSG]`,
> `[MSG-ICON]`, `[MSG-ADOPT-A]` 418 · `[MSG-ADOPT-B]`, `[MSG-CLEANUP]` 419. Every per-user message
> affordance composes in place, the per-row can-message fan-out is gone (4 requests → 0), and the
> orphaned endpoint is deleted. Nothing outstanding — kept here one conv for traceability, then
> delete this note.

1. [COURSE-PAGE-FIXES-AUG-17](#course-page-fixes-aug-17) — client change batch for course page(s), Conv 436
2. [SLOT-COLLIDE](#slot-collide) — `right-panel` now names TWO different slots; ListingShell's renders on the LEFT
2. [QSLOT](#qslot) — Conv-435 calibration: batched answer landed in the wrong slot; truncated list read as newest-first
2. [DIPL-SHELL](#dipl-shell) — /diploma/[id] renders in the MARKETING shell for signed-in viewers
2. [CTA-HOST-GUARD](#cta-host-guard) — nothing stops a NEW host of CourseCatalogCard shipping dead cards; happened once already
3. [BRIAN-ARTIFACTS](#brian-artifacts) — 👀 external: the rationale artifacts his commits cite (MERGE-BRIAN itself is CLOSED)
4. [COMM-IMG](#comm-img) — community art is all picsum placeholders; `cover_image_url` has a UI slot but **no upload/storage**
5. [CD035-STALE](#cd035-stale) — CD-035 reads 0/34 done but CD-039 shipped part of it; re-validate before working it
6. [SPACING-4X](#spacing-4x) — sweep for other 4× size artifacts Conv 423 preserved
7. [A11Y](#a11y) — accessibility lint triage
8. [RHOOKS](#rhooks) — react-hooks lint triage
9. [KNIP](#knip) — dead-export oracle → gate
10. [TURNLOG](#turnlog) — `conv-turns.md` unmaintained guard
11. [EDITSAFE](#editsafe) — anchored-edit discipline
12. [RSYNC-GATE](#rsync-gate) — memory-sync rsync auto-mode block
13. [COMPDOC](#compdoc) — `_COMPONENTS.md` ui/ section stale
14. [ROUTESTORIES-DRIFT](#routestories-drift) — route-stories.md §3 still documents dissolved /discover routes
15. [EMAILDOC](#emaildoc) — `resend.md` dead-template refs
16. [HOME-FIXES](#home-fixes) — Home route fix bucket
17. [COURSES-FIXES](#courses-fixes) — Courses route fix bucket
18. [BRAND-DOCS](#brand-docs) — "PeerLoop"→"Peerloop" docs casing
19. [SCRATCH-DEBRIS](#scratch-debris) — delete retired `conv-tasks.md`
20. [BRIDGE-UPLOAD](#bridge-upload) — browser file-upload fallback
21. [BLOCKPLAN](#blockplan) — `CURRENT-BLOCK-PLAN.md` keep/remove
22. [UXQ](#uxq) — AskUserQuestion picker teardown (upstream)
23. [RSFD](#rsfd) — port `r-start-from-dirty`
24. [DEPEXP](#depexp) — dependency-probe hygiene
25. [MEM-PRUNE](#mem-prune) — MEMORY.md auto-load cap watch
26. [TASK-TOOLS-VERIFY](#task-tools-verify) — Task-tools gate probe
27. [SKILLDOC](#skilldoc) — `skills-system.md` retired Task-overlay drift
28. [TSLASH](#tslash) — trailing-slash route normalization (`/profile/` 302s, bare `/profile` 200s)
29. [CHIPWRAP](#chipwrap) — course-hero mobile chips wrap (optional, user say-so)
30. [DL-FILENAME](#dl-filename) — download Content-Disposition filename lacks file extension
31. [TESTUNITDOC](#testunitdoc) — `TEST-UNIT.md` stale since Conv 253 (r-end docs agent)
32. [INTTESTDOC](#inttestdoc) — TEST-COVERAGE Integration header says 10, lists 9
33. [PROBESAFE](#probesafe) — `--help` on a generator script executed it
34. [TLFMT](#tlfmt) — r-end ref documents a TIMELINE.md shape the file no longer uses
35. [OUTLINE-V4B](#outline-v4b) — 3 residual `outline-none` sites the Conv-244 fix missed
36. [ADMIN-OVFLW](#admin-ovflw) — 3 admin routes overflow horizontally (pre-existing, not Conv-423)
37. [LH1](#lh1) — 23 typography tokens hardcode `line-height: 1` (TYPO-FDN axis)
38. [BRIDGE-RESIZE](#bridge-resize) — `resize_window` silently ignores width
39. [ICON-STATES](#icon-states) — Phase-5 tail: drive hidden/loading states over 528 call sites
41. [VPHARNESS](#vpharness) — persist the exact-size iframe harness as a script
42. [RATING-COUNT-DEAD](#rating-count-dead) — dead `rating_count` + "Active" vs "Published" split
43. [PROVDOC](#provdoc) — `matt-provenance.md` §6a says "9 unmarked components"; registry has 22 + 38
44. [PRUNEPTR](#pruneptr) — `/r-end` prune leaves no forwarding pointer when a `---` survives the span
45. [SCHEMADIAG](#schemadiag) — `schema-diagram.md` claims 48 tables, 71 on disk (r-end docs agent, Conv 432)
46. [SEED-NOTIF-STALE](#seed-notif-stale) — seeded admin notification asserts a cert that Conv 434 deleted

## ⏸️ Parked  (gated — out of rotation)

- [RAIL-DETAIL](#rail-detail) — **gate:** the CLIENT accepting the right panel on `/course/{slug}` (phase A, shipped Conv 435). Everything else the panel touches — the 3 listing pages, the 2 detail pages, and both open warnings — waits behind that one answer
- [SHADOW-DEAD](#shadow-dead) — **gate:** deliberate app-wide shadow pass; not to be fixed as a token cleanup (Conv 434)

- [ORPHAN-BACKLOG](#orphan-backlog) — gate: marketing redesign (RG-PUBLIC)
- [PLATO-SEQ](#plato-seq) — gate: post-launch (Phase 4c)
- [SESSION-REMIND-DEPLOY](#session-remind-deploy) — gate: MVP-GOLIVE (prod)
- [FEEDBACK-DEPLOY](#feedback-deploy) — gate: MVP-GOLIVE (prod)
- [RG-PUBLIC](#rg-public) — gate: marketing redesign
- [PREFLIP-WT](#preflip-wt) — gate: user say-so
- [BROWSER-SMOKE-2B](#browser-smoke-2b) — gate: post-launch
- [MINWIDTH-320](#minwidth-320) — gate: user say-so
- [ICON-LIC](#icon-lic) — gate: MVP-GOLIVE

---

## Tasks

### [ADMIN-OVFLW]

- **State:** 📋 queued — surfaced by the Conv-424 `[SPACING-VIS]` pass.
- **What:** three admin routes overflow the 1280 viewport horizontally: **`/admin/sessions` (+289px)**,
  `/admin/moderation` (+96px), `/admin/enrollments` (+75px). On `/admin/sessions` the culprit is a stats
  grid `grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-16 mb-24` in `SessionsAdmin.tsx` computing **4 tracks
  of ~310px = 1287px** inside a ~1060px column — `lg:grid-cols-6` is not winning, and `MAIN`
  (`flex flex-1 flex-col lg:ml-[220px]`) has no `min-w-0`, so min-content pushes it wider (classic flex
  overflow).
- **NOT a Conv-423 regression — verified:** `SessionsAdmin.tsx` is byte-identical across `dc1f031e`
  (`gap-16 mb-24` unchanged) and both 16 and 24 are in the pre-existing override set
  `{4,8,12,16,20,24,32,40,48,64}`, so they measured the same before the sweep.
- **Refs:** `src/components/admin/SessionsAdmin.tsx`, `ModerationAdmin.tsx`, `EnrollmentsAdmin.tsx`;
  `memory/project_admin_conformance_policy.md`. Surfaced Conv 424.

### [BRIDGE-RESIZE]

- **State:** 👀 watch (tooling) · **re-tested Conv 429 — STILL BROKEN, and broader than recorded**
- **What:** `mcp__claude-in-chrome__resize_window` returns `"Successfully resized window ... to WxH"` and
  changes nothing. **Conv 429 re-test: BOTH axes are now no-ops** — asked 900x700 then 1600x500, window
  stayed **1369x1221** both times, still unchanged after a 1500 ms in-page settle.
- **It has degraded across builds** — so re-test, don't assume: Conv 367 merely laggy (values *did*
  move: 341 one call, 1087 the next) → Conv 424 width ignored, height still applied → **Conv 429 neither
  axis moves.** Same success-shaped-failure class as `navigate` onto `chrome-error://` (`[BRIDGE-DIAG]`).
- **Workaround (unchanged, and now the only path):** exact-size same-origin **iframe harness** — set
  `width` + `min-width` + `max-width:none !important` (the app's CSS reset caps embedded elements at
  100%, silently clamping the iframe), then `transform: scale()` to fit. Gives a true `innerWidth: 1280`
  with `mq1200` matching.
- **Next: 👉 upstream report is the user's call** (external/outward-facing — not filed autonomously).
  Everything needed for a report is captured here and in the memory file.
- **Refs:** `memory/reference_responsive_iframe_harness.md` (updated Conv 429 with the degradation
  trajectory), `[BRIDGE-DIAG]` (Conv 424).

### [LH1]

- **State:** 📋 queued · `[Opus]` — TYPO-FDN axis. Surfaced Conv 424.
- **What:** **23** typography tokens in `src/styles/tokens-typography.css` hardcode `line-height: 1`,
  e.g. `--body-small-line-height: 1` → `text-body-small` renders **12px font on a 12px line box**
  (ratio 1.00). Visible as cramped 2-line clamped card descriptions on `/communities`, `/course/[slug]`.
- **NOT a Conv-423 regression — verified:** the literal `1` is present in `dc1f031e~1`, and that file was
  last touched Conv 330 (2026-06-23); the sweep did not modify it.
- **When picked up:** decide the intended ratio per role (body copy wants ~1.4–1.5; display/numeric may
  legitimately want 1) rather than blanket-replacing all 23.
- **Refs:** `src/styles/tokens-typography.css`, `plan/typo-fdn/README.md`. Surfaced Conv 424.

### [A11Y]

- **State:** 🔄 active
- **What:** `eslint-plugin-jsx-a11y@6.10.2` adopted at **warn** (Conv 399) for `.tsx` (recommended) + `.astro`; ESLint-10 peer gap fixed via self-healing package.json `overrides` pin. Gate stays GREEN (warn-only). Triage warnings incrementally.
- **Progress:** 100 → 72 warnings (Conv 404, all 5 gates green). Built 2 behavioral primitives: `ui/ModalBackdrop.tsx` (aria-hidden backdrop, deliberately **not** focusable — 7 sites) + `ui/ClickableRow.tsx` (role=button rows wrapping block content — 1 site). Both **unstamped/unregistered** by design (behavior not design; `prov:sweep` accepts).
- **Next:** batch 2, same `htmlFor`/`id` pattern → `creators/studio/ResourcesEditor` (12), `community/AddCommunityResourceModal` (8), `teachers/workspace/AvailabilityCalendar` (6), `admin/UsersAdmin` (5).
- **Do NOT force `ClickableRow` on:** `AvailabilityCalendar:654` (already `role=gridcell`, wants grid nav), `AdminDataTable:137` (`stopPropagation` sink), `Modal.tsx:83` (`handleBackdropClick` is dead code — delete, don't decorate). Genuine `ClickableRow` candidates: `NotificationCenter:310`, `ModerationDetailContent:265`, `AdminDataTable` row.
- **⚠️ Process:** run the `[ORPHAN-DETECT]` reachability check on **every** file in a batch — Conv 404's `TestimonialsBrowse` edit landed on parked dead code (Cat-B), so honest cleared count was 26 not 28.
- **Deferred:** escalate `recommended`→`strict` after triage; consider gating any rule at `error`; drop the `overrides` pin when upstream ships `eslint ^10`.
- **Refs:** `../Peerloop/eslint.config.js`, `../Peerloop/package.json`, `../Peerloop/src/components/ui/{ModalBackdrop,ClickableRow}.tsx`, `docs/decisions/06-testing-ci.md §A11Y`, `[LE-TRIAGE]`, `[PROV-SWEEP-DEBT2]`.

### [BLOCKPLAN]

- **State:** 📋 queued · low priority
- **What:** `CURRENT-BLOCK-PLAN.md` (docs-repo root) is an unfilled March template never used — multi-conv blocks (PLATO-SEQ etc.) track in PLAN.md instead (PLAN.md is SoT per CLAUDE.md §Feature Tracking; Conv 382 Decision #3).
- **Decide:** adopt it consistently for multi-conv blocks, or remove it to cut surface.
- **Refs:** surfaced Conv 382.

### [BRAND-DOCS]

- **State:** 📋 queued · low priority
- **What:** docs-wide "PeerLoop" → "Peerloop" casing sweep. **Pre-existing** (not Conv-369-caused); ~30 docs still carry old casing, mostly manual/vendor (`resend.md`, `stripe.md`, `cloudflare.md`, `matt-design-system/*`) + a few driftCheck (`url-routing.md`, `messaging.md`, `ratings-feedback.md`).
- **Guard:** verify each mention isn't an intentional reference before bulk-replace. BRAND-CASE (Conv 369) was "UI copy only".

### [BRIDGE-UPLOAD]

- **State:** 👀 watch (tooling)
- **What:** `mcp__claude-in-chrome__file_upload` rejects filesystem paths (wants file contents via `files`), but the exposed schema only has `paths` → **no working browser file-upload** in a PLATO browser-run (thumbnails, avatars, homework).
- **Fallback (Conv 379):** set course thumbnail via the app's `PUT /api/me/courses/[id]/thumbnail` (external URL, JSON). Document API-PUT as the standard for file-gated browser steps.
- **Next:** re-test on a newer Chrome-in-Claude build.
- **Refs:** `memory/reference_chrome_bridge_island_stale_cache` [BRIDGE-UPLOAD]. Surfaced Conv 379.

### [CHIPWRAP]

- **State:** 📋 queued · low priority (optional mobile nicety)
- **What:** Course-hero (`CourseHeader`) metadata chips truncate at true-mobile (<~450px) via the chips-single-row `flex-nowrap overflow-hidden` (Conv 413 [HERO]). Cosmetic clip, not a break; cleanly cut at the card edge.
- **Optional fix:** allow the chip row to wrap onto 2 rows on mobile ONLY (e.g. drop `flex-nowrap`/`overflow-hidden` under a low container breakpoint) so full metadata shows on phones.
- **Gate:** user say-so — the desktop/tablet compaction is the priority and is DONE. Surfaced Conv 413.

### [CD035-STALE]

- **State:** 📋 queued
- **What:** re-validate **CD-035 (UX & Pricing Changes)** against current code before anyone works its checklist. Its INDEX row reads **0 of 34 done**, which is almost certainly false.
- **Why:** surfaced Conv 433 while picking a client-work source. CD-035's listing items — "CourseBrowse.tsx: replace grid with single column", "replace pagination with infinite scroll", "remove pagination UI entirely", "remove Showing X of Y" — describe work **CD-039 shipped in Convs 284–285** (`CoursesCatalog` / `CommunitiesCatalog` / `MemberDirectory` → `ListingShell.astro`, 640px column). And `CourseBrowse.tsx` **no longer exists** — the surviving `CourseBrowse` references are SSR loader names; the live surface is `CoursesCatalog.tsx`.
- **Risk if skipped:** working the checklist top-down means re-doing shipped work or editing components that were deleted. The stale count also makes CD-035 look like the biggest open RFC when it may be among the smallest.
- **Shape:** per-item disposition pass (done / superseded by CD-039 / still-real / obsolete-target), then correct `RFC.md` checkboxes and the `INDEX.md` Done count. This is an investigative framing — surface the dispositions and confirm before editing.
- **Refs:** `docs/requirements/rfc/CD-035/RFC.md`, `docs/requirements/rfc/CD-039/RFC.md` (Closed, 21/21), `docs/requirements/rfc/INDEX.md`, `plan/` LIST-1COL.


### [CTA-HOST-GUARD]

- **State:** 📋 queued — cheap; prevents a repeat of a gap that already happened once
- **What:** nothing stops a NEW host of `CourseCatalogCard` from rendering it without wiring a CTA, so the next
  page to use the card silently ships dead cards for enrolled viewers.
- **Why it is not hypothetical:** exactly this happened in Conv 434. `[CARD-CTA]` gave `/courses` a next-step
  CTA and left the community Courses tab — the only other consumer — on its own stale logic, where enrolled
  viewers got no CTA at all. It was found only because the user asked "will the same CTAs show up on other
  pages?", not by any check. Two consumers were tractable by hand; a third would not be noticed.
- **Shape (options, cheapest first):**
  - a static check that every file rendering `<CourseCatalogCard` also imports `buildCoursePrimaryCta` (or
    passes `cta`), in the shape of `scripts/check-token-names.ts` — a grep-level gate, minutes to write;
  - or make the card's `cta` prop **required** (`cta: … | null`), forcing each host to state its intent
    explicitly rather than inheriting "undefined" — a type-level fix that needs no script at all, and is
    probably the better answer since `tsc` then enforces it.
- **Note:** the second option is the durable one, but it touches every existing call site, so it is a small
  refactor rather than a pure addition. Decide which before starting.
- **Refs:** `src/components/courses/CourseCatalogCard.tsx` (`cta` prop), `CoursesCatalog.tsx`,
  `src/pages/community/[slug]/[...tab].astro`, `src/lib/course-cta.ts`.
- **Client-visible:** open item in `docs/requirements/rfc/CD-040/RFC.md` §3. Tick it there when this closes.

### [COMPDOC]

- **State:** 📋 queued (doc drift)
- **What:** `docs/reference/_COMPONENTS.md` "UI Primitives (`src/components/ui/`)" section badly stale — documents **6** of **29** files; `Breadcrumbs.astro` references a deleted file. Doc is **driftCheck** (in the r-end docs-agent scope), last updated 2026-07-07.
- **Pre-existing** — not Conv-404-caused; docs agent correctly declined a drive-by partial edit (Conv-200 manufactured-edit policy).
- **When picked up:** decide first whether this section stays hand-maintained or becomes `generated` (a `src/components/ui/*` scan would never drift) — that choice IS the work.
- **Refs:** `docs/reference/_COMPONENTS.md`, `.claude/scripts/docs-registry.mjs doc-category`, `[A11Y]`, `[PROV-SWEEP-DEBT2]`.
- **Conv 428 addition:** three components were DELETED (`EnrollmentCard`, `CourseModerationCard`, `CoursesRoleTabs`) and four added (`auth/useRoleGate.ts`, `auth/RoleGatePanel.tsx`, `ui/StickyViewTitle.astro`, `pages/_workspace-tabs.ts`), so the `ui/` section is now stale in both directions — it lists gone components and omits new ones.
- **Conv 432 addition (different section, same file):** `:1090` cites `/feeds` as a live surface in the right-panel layout rule, but `/feeds` was deleted Conv 331 (`[FEEDS]`). Needs a live substitute (`/`, `/courses`, `/communities` all carry the right panel). Independent of the `ui/` section decision above — this one is a one-line fix.


### [COMM-IMG]

- **State:** 📋 queued
- **What:** replace the `picsum.photos` placeholder imagery on communities with real, creator-maintained art — **and close the storage gap that forces placeholders in the first place.**
- **Why now:** surfaced Conv 433 while deciding the `/communities` card's cover-vs-logo treatment. Every community image in the seed is random noise (`migrations-dev/0001_seed_dev.sql:174-188`): cover `picsum.photos/seed/<slug>/800/400`, logo `picsum.photos/seed/<slug>-logo/200/200`. The hay-bale photo on "AI for You" reads as meaningless because it *is* meaningless. Any further visual judgement on these cards is being made against noise.
- **The real gap (checked, not assumed) — the two fields are NOT equally supported:**
  - `logo_url` ✅ **has both a spot and storage.** Dedicated upload endpoint `src/pages/api/me/communities/[slug]/logo.ts` (POST + DELETE, R2-backed, guarded on the `communities/` prefix), wired to an instant-managed file input in `CommunitySettings.tsx` ([N13]).
  - `cover_image_url` ⚠️ **has a spot but NO storage.** `CommunitySettings.tsx:198-210` is a plain **text input for a URL**, PATCHed through `/api/me/communities/[slug].ts:211`. There is no upload endpoint and no R2 path — a creator must host the image somewhere else and paste a link. The UI even gives 16:9 sizing guidance (CD-039 item 61) with no way to act on it. **This is why the seed uses picsum URLs.**
- **Shape:** (a) build cover upload to match the logo's pattern — the logo endpoint is the template, so this is largely symmetry work; (b) then replace the seed placeholders with real art; (c) decide what an empty cover falls back to (today `bg-neutral-700`; the `icon` emoji already covers the empty-logo case).
- **Blocks:** honest visual review of `/communities`, `/community/[slug]`, and the Discovery rails — all three render community imagery.
- **Refs:** `migrations-dev/0001_seed_dev.sql:174-188`, `migrations/0002_seed_core.sql:213` (System community has a cover and **no** logo — the nullable case is real), `src/pages/api/me/communities/[slug]/logo.ts`, `src/components/creators/communities/CommunitySettings.tsx`, `[COMM-BAND-ADOPT]` (Conv 433).
- **Client-visible:** open item in `docs/requirements/rfc/CD-040/RFC.md` §1. Tick it there when this closes.


### [COURSE-PAGE-FIXES-AUG-17]

- **State:** 🔄 active
- **What:** client change batch for course page(s) — details supplied incrementally during Conv 436.
- **Refs:** (to be added as changes land)


### [COURSES-FIXES]

- **State:** 📋 queued (deferred per-route bucket)
- **What:** deferred bucket of per-route fixes captured while sweeping the Courses route(s) — batch later. Sibling of `[HOME-FIXES]`.
- **Holds (from the Conv-292 sweep):** `[FILTERS-RESPONSIVE]` (⟂ responsive/compact filters — the Conv-425 compact toolbar plausibly overlaps this but it was never verified against the original intent) + `[TYPO-REVIEW]` (⟂ app-wide typography).
- **Added Conv 425 — role-tab empty states ignore their `sub` filter.** The all-tab empty state was fixed this conv to distinguish an empty catalog from over-narrow filters; the four ROLE tabs have the same defect class via a different trigger. Each branches on `q` only, so a student on `sub=completed` holding only in-progress enrolments reads *"You haven't enrolled in any courses yet."* — denying enrolments that exist. Same for teaching (`active`/`paused`), created (`published`/`draft`/`retired`) and moderating. Left unfixed deliberately: those tabs are dispositioned for retirement once `[ROLE-CRS-LIST]` lands (MERGE-BRIAN §2 M3), so fix them only if that gate slips. `src/components/courses/CoursesCatalog.tsx` ~lines 366/377/389/408.

### [DEPEXP]

- **State:** 📋 queued · low priority (tooling hygiene)
- **What:** in-place `npm install` probes (during `[A11Y]`) pulled newer transitive optional pins into resolution; a later `npm ci` then failed "out of sync" despite a byte-identical committed lockfile. Reconciled via `npm install` + `git restore package-lock.json`.
- **Habit to adopt:** run dependency experiments in a throwaway git worktree, or always reconcile (`npm install` then restore the committed lockfile) after in-place probes.
- **Refs:** `docs/sessions/2026-07/20260720_1245 Learnings.md §5`. Sibling of `[SCRATCH-DEBRIS]`/`[DEVSRV-KILL]`. Surfaced Conv 399.

### [DL-FILENAME]

- **State:** 📋 queued · low priority (polish) · surfaced Conv 415
- **What:** `/api/resources/[id]/download` sets `Content-Disposition: attachment; filename="${resource.name || getFilenameFromKey(r2_key)}"`. Because `resource.name` is a human title with **no file extension** (e.g. "n8n Node Reference"), downloaded files save without `.pdf`/`.zip`, so the OS/browser may not open them in the right app. The `r2_key` *does* carry the real filename (`node-reference.pdf`).
- **Fix:** prefer `getFilenameFromKey(r2_key)` (has the extension) for the download filename, or append the extension (from the key/mime) to `resource.name`. Decide which reads better. Check the sibling `api/community-resources/[id]/download.ts` for the same pattern.
- **Refs:** `src/pages/api/resources/[id]/download.ts` (~line 102), `getFilenameFromKey` in `@lib/r2`, `[R2-SEED]`. Surfaced Conv 415 while verifying the seeded downloads.

### [DIPL-SHELL]

- **State:** 📋 queued — user-observed Conv 434
- **What:** `/diploma/[id]` renders in the **marketing shell** (`LandingLayout`: Courses / How It Works /
  Pricing / For Creators nav + marketing footer) even for a signed-in user who arrived from inside the app.
  No sidebar, no app chrome. Verified live as Guy — his avatar shows in the marketing header.
- **Why it looks wrong but is not obviously a bug:** the Diploma is a **public, shareable, printable**
  credential (Conv 389 `[DIPLOMA]`, no auth), so a marketing shell is defensible for a signed-out visitor
  following a shared link. It is only wrong for the in-app viewer, which is the common case.
- **Not caused by, but surfaced by, `[TEACH-REQ]`:** the completed-state CTA pointed here briefly, which is how
  it was noticed. That CTA now goes to `/course/[slug]/teach`, so nothing in-app links here at present — which
  is exactly why this could sit unnoticed again.
- **Options:** (a) pick the layout by viewer — `AppLayout` when authenticated, `LandingLayout` when not;
  (b) always `AppLayout` (loses the clean public/share render); (c) accept it as a print artifact and leave it.
  (a) is the obvious answer but doubles the render paths for one page, so it is a real choice.
- **Refs:** `src/pages/diploma/[id].astro:42`, `src/layouts/LandingLayout.astro`, `[DIPLOMA]` Conv 389.
- **Client-visible:** open item in `docs/requirements/rfc/CD-040/RFC.md` §4. Tick it there when this closes.

### [EDITSAFE]

- **State:** 📋 queued (CC discipline)
- **What:** three self-inflicted edit errors in one conv (Conv 396), one cause — programmatic rewrites of structured markdown/JSON without a uniquely-identifying anchor; all caught only by reading back.
  - JSON round-trip: `JSON.stringify(config,null,2)` to add one key reformatted all of `.claude/config.json` (461 ins/129 del). Redone as a 3-line `Edit`.
  - Ambiguous marker: `str.replace('> ## ⏸️ PARKED', …, 1)` hit the **header-prose** occurrence, not the real divider.
  - Status change deleted data: moving a recurring-watch task to Completed removed its backlog row, orphaning the standing trigger.
- **Candidate rule:** prefer `Edit` with a unique anchor over python/sed/serializer rewrites on `config.json`/`CURRENT-TASKS.md`/`PLAN.md`/`MEMORY.md`; never round-trip JSON through a serializer to change one key. Decide: CLAUDE.md or memory.
- **Refs:** surfaced Conv 396.

### [EMAILDOC]

- **State:** 📋 queued · trivial (doc cleanup)
- **What:** Conv 398 deleted `src/emails/WelcomeEmail.tsx` + `PaymentReceiptEmail.tsx` (dead). Both still listed in `docs/reference/resend.md` + `DEVELOPMENT-GUIDE.md` — both **manual** category, so the r-end docs agent left them by policy.
- **Next:** remove/annotate the two templates (verify each mention is the deleted template, not a live one).
- **Refs:** `docs/reference/resend.md`, `docs/reference/DEVELOPMENT-GUIDE.md`. Surfaced Conv 398.

### [VPHARNESS]

- **State:** 📋 queued · low priority (tooling convenience).
- **What:** persist the **exact-size same-origin iframe harness** as a reusable script instead of
  re-injecting it inline. Conv 424 rebuilt it twice after the parent page reloaded mid-conv.
- **The two non-obvious parts worth encoding:** (1) the app's own CSS reset caps embedded elements at
  `max-width:100%`, which silently clamps the iframe — it must be overridden `!important` alongside
  `width` + `min-width`; (2) `transform: scale()` to fit the window, with slack, because the capture
  crops roughly the last 16 CSS px otherwise.
- **Why it exists at all:** `resize_window` never applies width (see `[BRIDGE-RESIZE]`), so this is the
  only way to measure or eyeball a viewport wider than the window manager grants.
- **Refs:** `[BRIDGE-RESIZE]`, `memory/reference_responsive_iframe_harness.md`. Surfaced Conv 424.

### [HOME-FIXES]

- **State:** 📋 queued (deferred per-route bucket)
- **What:** deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — batch later.

### [INTTESTDOC]

- **State:** 📋 queued · low priority (doc drift) — found by the r-end docs agent, Conv 419
- **What:** `docs/reference/TEST-COVERAGE.md`'s `## Integration Tests — tests/integration/ (10 files)`
  header says 10 but the table lists **9** rows. Missing: `tests/integration/session-timezone.test.ts`
  (added Conv 386 `[XTZ]`). **Pre-existing**, not caused by Conv 419.
- **Why the tooling missed it:** `sync-gaps.sh` checks one direction only — disk → doc, by basename —
  so a file present on disk *and* counted in a header but absent from the table is invisible to it.
- **Worth generalising:** the same one-directional blind spot applies to every count-bearing header in
  TEST-COVERAGE.md / TEST-COMPONENTS.md. Consider a bidirectional check (header count == row count ==
  `find` count) rather than fixing this one row and moving on.

### [KNIP]

- **State:** 🔄 active
- **What:** `knip@6.27.0` adopted (Conv 398) as the module-graph reachability oracle — closes grep's blind spots (`.astro`, relative imports, barrel passthroughs). Installed + configured (`knip.json`, cron-worker + `scripts/**` entries, `project: src/**`); first run adjudicated the 9 `[RDFIX]` candidates and reproduced the 14 parked `[ORPHAN-BACKLOG]` Cat-B files.
- **⚠️ CORRECTED Conv 419 — knip does NOT replace `codecheck-orphan-components.mjs`.** The two ask
  different questions and both must run:
  - knip *unused files* → **14**. Question: "is this file imported by anything?"
  - route detector → **53**. Question: "is this reachable from a route?" — i.e. will a user ever
    see my edit.
  - **Why knip under-reports: a dead barrel counts as an importer.** `marketing/index.ts` is itself
    unused, but `export { FaqPage } from './FaqPage'` keeps `FaqPage` alive in knip's graph.
    Verified in a throwaway worktree: deleting all 14 and re-running found **zero** more, so barrel
    removal does not cascade it either.
  - **Trap when reading knip output:** a file can appear under *unused exports* merely for a
    redundant `export default X` beside a live `export function X`. `BecomeATeacherPage.tsx` and
    `FaqPage.tsx` both have that shape; the first is live. Do not derive an orphan count by grepping
    knip's export list — that produced a wrong "64" in Conv 419.
  - knip's real value here is the **unused exports** + dependency analysis, which the route
    detector cannot see. Complementary, not a substitute.
  - **Post-`[MKTDEAD]` (Conv 419):** knip *unused files* is now **0** and the route detector PASSes,
    so blocker (2) — "baseline the Cat-B files" — is **gone**. Remaining before it can gate:
    tune dependency analysis, then wire into `/w-codecheck`.
  - **Untested third oracle (user's suggestion, Conv 419):** tree-shake / build-output analysis —
    if a component is absent from `dist/`, it is provably dead, barrels included. Ground truth, and
    neither tool implements it. Worth a spike before `[MKTDEAD]` is decided.
- **Before it can be a hard gate:** (1) tune dependency analysis — false-flags `zod`/`tailwindcss`/`@tailwindcss/forms`/`react-day-picker` (CSS `@plugin`/runtime, not JS import) + `cloudflare:` unlisted; (2) baseline the 14 Cat-B files (or wait for `[RG-PUBLIC]`); (3) wire into `/w-codecheck` (only NEW unused fails).
- **Known dead exports KEPT by decision (knip re-flags when gate lands):** `CHART_BREAKPOINTS`, `now()`/`parseTimestamp()` (`lib/db/index.ts`), `creators`/`getRelatedCourses`/`getFeaturedCreators` (`lib/mock-data.ts`), `MONITORING_COLORS` (`discover/role-utils.ts`), `emails/styles.ts`'s 6 exports (file live).
- **Refs:** `../Peerloop/knip.json`, `.claude/scripts/codecheck-orphan-components.mjs`, `[[feedback_orphaned_components_survive_migration]]`, `[ORPHAN-BACKLOG]`, `docs/decisions/06-testing-ci.md §RDOC`.

### [MEM-PRUNE]

- **State:** 👀 watch (recurring) · **FIRED Conv 420** — partial relief applied inline (76% bytes); a full `/r-prune-memory` run is still owed
- **What:** threshold-triggered, never "done" — standing watch `[MEM-CAP]` in PLAN.md. Fires when `MEMORY.md` auto-load crosses **80%** of the 200-line / 25 KB SessionStart cap on either axis (`/r-start` Step 5.7 Phase 2 emits 🔴🔴🔴). Remedy is **`/r-prune-memory`** (NOT `/r-prune-claude`).
- **Utilization log:** Conv 211 baseline 53%/73% → tripped 80% bytes Conv 213 → Conv 396 full run 20304 B (79%) → 17979 B (70%), 127 → 124 lines.
- **Next firing:** the two big Conv-396 levers are spent (label-normalization is a no-op; the intro-blockquote dedup is done). Will likely need extraction or sub-file consolidation, not more trimming.
- **✅ Conv 420 partial (inline, not a skill run):** a PostToolUse hook fired at 20475 B (80% of the auto-load cap, 84% of the 24.4 KB read-limit) right after two new memories landed. Compacted the **11 index lines that had grown into paragraphs** — the largest was 546 B, six were over 290 — back to terse marker+trigger pointers per `[[feedback_memory_index_load_bearing]]`. **20475 → 19431 B (80% → 76%), 130 lines, zero markers dropped.** So the lever that *is* left after Conv 396 is confirmed: index lines drift back into carrying sub-file detail, and re-flattening them is worth ~1 KB.
- **⚠️ Still owed:** the hook asked for <17.1 KB and this got to 19.4 KB. Closing the remaining ~2.3 KB needs genuine **consolidation/extraction** (merging near-duplicate entries, retiring stale ones) — a curation judgment call, deliberately NOT wedged into an `/r-end`. Run `/r-prune-memory` as its own focused task.
- **Refs:** `.claude/skills/r-prune-memory`, PLAN.md `[MEM-CAP]` (~line 102), `[[feedback_memory_index_load_bearing]]`.

### [BRIAN-ARTIFACTS]

- **State:** 👀 watch · **external** — waiting on Brian, not on us
- **What:** his commit messages cite an *"approved Option B / mockup"* for several decisions, but that rationale exists **nowhere in git** — only in his own chat sessions. Requested so the reasoning behind his choices is recoverable if a disposition is ever reopened.
- **Why it stays open:** `MERGE-BRIAN` is otherwise **CLOSED (Conv 428)** — all six review units complete, every change dispositioned, the client-facing ledger closed out. This is the one loose end and it is his to supply.
- **Next:** raise it when walking `plan/merge-brian/NOT-ADOPTED.md` through with him; that conversation may also reopen dispositions, which is expected and fine.
- **Refs:** `plan/merge-brian/README.md § Open asks of Brian`, `plan/COMPLETED.md § MERGE-BRIAN`.

### [MINWIDTH-320]

- **State:** ⏸️ parked · **gate: user say-so** (on hold Conv 369)
- **What:** lower supported min screen width 375px → 320px (iPhone-SE class). 3 scoped overflow sites: ~~`CoursesFilters.tsx` filter rows~~ **(✅ cleared Conv 425** — the [MERGE-BRIAN §2 · M5] rewrite's `flex-wrap` + `min-w-[160px] flex-1` search and `overflow-x-auto` pill row measure **0px overflow at 320** in the iframe harness**)** · `MembersFilters.tsx` filter rows (`min-w-0` or wrap) · Home legacy feed-card action button (`min-w-0`/`flex-wrap`). **2 of 3 remain**, both unverified; re-verify at 320px via iframe harness. Optional.
- **Refs:** `docs/decisions/05-ui-ux-components.md` [MINWIDTH], `memory/reference_responsive_iframe_harness`.

### [ORPHAN-BACKLOG]

- **State:** ⏸️ parked · **gate: detector wiring only** — Cat-A+B+C all DONE (B deleted Conv 419)
- **Done:** `[ORPHAN-DETECT]` surfaced 118 orphaned components. Conv 392 deleted all **Category A** (dead legacy, 74). Conv 393 resolved all **Category C** — deleted 3 (`error/ErrorPage`, `leaderboard/Leaderboard`+orphaned API, `context-actions/*`), **wired 1** (`invite/ModeratorInvite` was a LIVE bug: admin invite emails `/invite/mod/{token}`, RESEND live on staging, but no page → 404; built `src/pages/invite/mod/[token].astro`), swept 12 stray dead `.ts`. Detector now **53** (was 118); all 5 gates green.
- **✅ Category B RESOLVED Conv 419 (`[MKTDEAD]`)** — deleted, not deferred. The bundler had been
  tree-shaking these out all along, so "keep them until the redesign" was costing sweep collisions
  for no benefit; a fresh design will not reuse them (Conv 239 Matt phase-out). The detector now
  PASSes. **This task's remaining scope is the detector-wiring below.** Superseded description —
  **Category B (52, was parked):** `marketing/*` (48) + `stories/*` (2) + `testimonials/*` (2) + `creators/profiles/CreatorCard` — the old marketing site; keep until the redesign, then delete/replace. (12 dead `.ts` barrels deliberately LEFT with it; `icons/icon-provenance.ts` KEPT — it's the `prov:sweep` SoT.)
- **Then — detector wiring:** snapshot residuals into `KNOWN_ORPHANS`, wire the detector into `/w-codecheck` as a hard gate (only NEW orphans fail). A `.ts` variant (scope `src/components/**` only — `src/lib/**` has entry points) can be productionized then.
- **Refs:** `.claude/scripts/codecheck-orphan-components.mjs`, `[[feedback_orphaned_components_survive_migration]]`, `.claude/skills/w-codecheck`, `[KNIP]`.

### [OUTLINE-V4B]

- **State:** 📋 queued — small, mechanical, but touches focus behaviour so not folded into an unrelated commit.
- **What:** `npm run check:tailwind` reports 1 issue: `outline-none` (v3) should be `outline-hidden` (v4).
  **5 sites remain, not the 3 this task was written with (re-measured Conv 435)** —
  `src/components/ui/ClickableRow.tsx:73` (`focus-visible:outline-none`),
  `src/components/course/TeachersTabList.tsx:133,142` (`focus:outline-none`), and
  `src/components/discovery/DiscoveryRailCard.tsx:62,98` (`focus-visible:outline-none`).
  The two `DiscoveryRailCard` sites postdate the task, which is the useful signal: **new `outline-none` is
  still being written**, so this is an open drift channel and not a fixed backlog of 3. Re-measure before
  working it rather than trusting the count above.
- **Why it exists:** `[OUTLINE-V4]` (✅ Conv 244) fixed the ×4 sites in the SESS-GRAD booking files and
  closed; these 3 were never in that scope. Confirmed **pre-existing** in Conv 423 by grepping `HEAD` —
  it is not fallout from the spacing sweep, which only ever changed numbers.
- **Care:** v4's `outline-hidden` is a behaviour change, not a rename — it preserves the outline for
  forced-colors mode. Both call sites pair it with a visible `ring`, which is the intended shape, so the
  swap should be safe; verify focus rings still render on keyboard focus after changing.
- **Refs:** `scripts/check-tailwind-v4.sh`, CLAUDE.md §Baseline Verification. Surfaced Conv 423.

### [PLATO-SEQ]

- **State:** ⏸️ parked · `[Opus]` · **gate: post-launch** — active work complete
- **Done:** waypoint-sequenced PLATO API+browser test architecture. Phases 1–4b all ✅ (Convs 379–385) — waypoint producers, `plato:graph` (dependency-graph + provenance foundation), `plato:run` make-for-waypoints runner all built, validated, committed. History in git + `docs/sessions/` + `docs/as-designed/plato.md`.
- **Outstanding — Phase 4c (post-launch, dup of `[BROWSER-SMOKE-2B]`):** agent-driven browser walker — auto-walk a pure-UI segment from a restored waypoint + self-verify, so a full journey chains API-produced waypoints (crossing Stripe/BBB a browser can't) with browser-verified UI segments. **Do NOT resurrect Playwright E2E.**
- **To resume 4c:** browser-walk mechanics (actor-switch via `POST /api/auth/dev-login`; CUT-2 enroll = signed `checkout.session` with **no `payment_intent`** via `trigger-webhook.sh stripe-direct-raw`; CUT-3 = `bbb-meeting-ended`; click-by-`ref`/late-hydration gotchas; Genesis creds) in `.scratch/plato-waypoint-plan.md` + memory `[[reference_chrome_bridge_island_stale_cache]]`/`[[plato_walk_mocked_service_divergence]]`.
- **Refs:** `docs/as-designed/plato.md`, `tests/plato/snapshots/README.md`, `PLAN.md §PLATO-SEQ`, `docs/decisions/06-testing-ci.md`.

### [PREFLIP-WT]

- **State:** ⏸️ parked · **gate: user say-so**
- **What:** tear down the preflip reference worktree (`~/projects/Peerloop-preflip` on :4331, `peerloop-ref` alias). Consequential + machine-local; the PLATO port-audit reason for keeping it has cleared.
- **Refs:** `memory/project_preflip_worktree_reference`.


### [PROBESAFE]

- **State:** 📋 queued · low priority (process) — Conv 419
- **What:** `node scripts/route-matrix.mjs --help` **ran the generator**. `--help` is not a supported
  flag, so argv was ignored and the script executed, rewriting 4 generated docs during what was meant
  to be a read-only capability probe. Harmless that time (the drift was the same conv's own work) but
  it dirtied a clean, just-pushed repo without warning.
- **Do:** treat an unknown flag on an unfamiliar script as **executing**, not as help. Read the source
  or check for an explicit `--dry-run` before probing. `git status` after any exploratory script run.
- **Optional fix:** give the `scripts/*.mjs` generators an arg guard that prints usage and exits on an
  unrecognised flag, instead of silently running.

### [RG-PUBLIC]

- **State:** ⏸️ parked · **gate: marketing redesign**
- **Icon dependency REMOVED (Conv 424):** `[ICON-TOK]`/`[ICON-4PX]` no longer wait on this gate — `BecomeATeacherPage` was fixed on the icon axis directly. This task is now only the *route-group sweep*.
- **What:** public/marketing route-group sweep (the only un-swept RG-* group; RTMIG-4 closed Conv 340 with it deferred). The 14 marketing pages live only in `/old/*`; root paths 404 by design. Revisit if/when the redesign is scheduled. Also gates `[ORPHAN-BACKLOG]` Cat-B.
- **Refs:** `plan/route-migration/README.md § RG-PUBLIC disposition`.

### [PRUNEPTR]

- **State:** 📋 queued — surfaced at Conv 431 `/r-end`
- **What:** `extract-prune.mjs` empties the §Learnings / §Decisions bodies correctly but reports
  `pointers inserted: 0` and leaves no `→ See … Learnings.md` forwarding pointer, because a `---`
  section separator survives inside the span and the body therefore doesn't test as empty.
- **Why it matters:** the pointer is the only thing telling a reader of the Extract where the pruned
  content went. Without it the Extract has two bare headings — the "where did it go" problem the
  pointer exists to prevent. Conv 431's Extract needed the pointers added by hand.
- **Fix:** treat a body as empty when the surviving lines are only blanks and/or a `---` rule; add a
  fixture to `extract-prune.test.sh` covering a `---`-separated Extract (the current fixture has no
  separators, which is why 19 assertions all pass while this slips through). Calibrate per `[CMH]` —
  assert the pointer IS inserted for a separator-bearing fixture and still inserted for a bare one.
- **Refs:** `.claude/scripts/extract-prune.mjs`, `.claude/scripts/extract-prune.test.sh`,
  `[PRUNESAFE]` (Conv 430, which built the span-restriction this rides on).

### [PROVDOC]

- **State:** 📋 queued · surfaced by the `/r-end` docs agent, Conv 429
- **What:** `docs/as-designed/matt-provenance.md` §6a (line ~119) enumerates *"the 9 unmarked components"*. The registry now holds **22** `COMPONENT_CANDIDATES` plus a separate **38**-entry `PHASE6_EXTRAPOLATION_CANDIDATES` array that §6a does not mention at all. The same lines still name `scripts/prov-candidates.ts`, which since Conv 216 is only a back-compat re-export of `matt-inspired-registry.ts` — so the paths still *resolve*, but the naming is stale (§12a line ~338 already documents the move correctly, so the doc contradicts itself).
- **Pre-existing** — not created by Conv 429; the count has drifted over many convs. Conv 429 touched the second array (added its existence check, cleared 8 rows), which is what surfaced the omission.
- **Why it matters:** `matt-provenance.md` is the reference a future conv reads to understand which components are candidates and where they live; a count off by 51 and a superseded path name both mislead.
- **Refs:** `docs/as-designed/matt-provenance.md` §6a + §12a, `../Peerloop/scripts/matt-inspired-registry.ts`, `[PROV-DANGLE]` (Conv 429).

### [RAIL-DETAIL]

- **State:** ⏸️ parked · [Opus] · **gate: the client accepting the right panel on `/course/{slug}`** — phase A
  shipped Conv 435 (`fba8016d`) and is what he is being shown. Everything below is deliberately ONE task
  rather than several, because every part of it is answered by that single yes/no: if he accepts, all of it
  is wanted; if he rejects, none of it is, and phase A comes back out instead.

- **▶ WHAT'S LEFT (the whole of this task — un-park only after he says yes):**
  1. **Phase B — migrate `/`, `/courses` and `/communities` onto the shared shell.** They still hand-roll
     the rail block. This is the part that actually removes the drift risk; phase A only stopped it getting
     worse. Should be visually a no-op — the component's default is `lg:flex-1`, which is what all three
     already use — so prove it by measuring before/after, not by eye.
  2. **Phase C — `/community/[slug]` and `/@[handle]`.** `/community/[slug]` has a `sub-nav` slot and is the
     same shape as phase A. `/@[handle]` does NOT, and its content is capped `max-w-4xl mx-auto` — that cap
     is what stands in the way of a rail, so it is a different problem, not a repeat.
  3. **Decide the 422px rail-mode content column** (see the warning below) — the 3-column call was made
     before the numbers existed.
  4. **Decide the missing regression guard** (see the warning below).
  5. **Fold into the next client RFC (CD-041).** Per the Conv-433 working model this request has its own
     `[CODE]` and batches into an RFC once several accumulate; CD-040 covers the closed 433–434 batch.
- **✅ PHASE A (Conv 435) — shipped and measured.** New `DiscoveryRailPanel.astro` (registered in
  `matt-inspired-registry.ts`), new `right-panel` slot on `AppLayout`, wired into
  `/course/[slug]/[...tab].astro`. 6 gates green (suite 6383).
  - **A defect was introduced and caught by measuring, not by the gates.** The first cut made the outer row
    `lg:flex-row` whenever a panel was present. That is wrong for the DEFAULT top-strip layout, where the
    `sub-nav` slot holds a full-width horizontal strip: as a flex ROW item it became a column and took
    **643px of a 948px row, collapsing the content div to w=0** — a broken course page. Every gate stayed
    green through it (tsc, astro-check, lint, build all pass on a page that renders nothing).
  - **Fix:** the outer row's direction still keys on `subNavOnLeft` ALONE; content + panel share their own
    inner row. When no page fills the slot that wrapper is `display: contents`, so it has no box and the
    no-panel DOM keeps today's layout semantics.
  - **Measured (1440px iframe harness):** default layout → content 648 / panel 284, side by side. Rail
    layout → **3 columns** 196 / 436 / 284, no overlap, at 1280 + 1440 + 1920. Below `lg` → panel
    `display:none`, content full width. No-panel pages → wrapper `contents`, content fills the row, and
    `/profile` in rail mode sits at x=576 = 364+196+**16** proving the parent `gap-16` still applies across
    the inert wrapper.
  - **Width:** the panel is pinned `lg:w-[284px]` on this page rather than the component default
    `lg:flex-1`. On the three listing pages the rail is the REMAINDER beside a `max-w-[640px]` content
    column (measured 284px @>=1440, 273 @1280); this page's content is uncapped, so `flex-1` on both split
    it 50/50 and gave a rail nearly twice the client's. The component keeps `lg:flex-1` as its default so
    Phase B's migration of those three pages is visually a no-op.
  - ⚠️ **In rail layout the content column is 422px @1280** — a consequence of the user-approved 3-column
    decision, taken before these numbers existed. Worth a look before Phase C.
  - ⚠️ **No automated regression guard** — this is a CSS/layout change and the suite cannot see it. A
    future edit to `AppLayout`'s row could silently re-break it exactly as above, and the gates would stay
    green. Consider a DOM assertion in the browser-walk, or accept and re-measure per change.
- **What the client asked:** "When you visit the /courses and / pages you see a panel (at desktop sizes) on
  the right. The client wants that same panel on first the /course/{stub} pages and later on all detail pages
  (/communities, /members and maybe elsewhere (TBD))."
- **Which panel it is — identified, not assumed.** The two pages he named are exactly the two that render
  **`DiscoveryRails`** in the right column, so that is "the same panel". It is NOT the `ListingShell`
  filters panel — `/members` has that one and he did not name it.
  | Page | Shell | Right column |
  |---|---|---|
  | `/` | bespoke 2-col | `DiscoveryRails entityTypes={['course','community']} maxItems={3}` |
  | `/courses` | bespoke 2-col | `DiscoveryRails entityTypes={['course']}` |
  | `/communities` | bespoke 2-col | `DiscoveryRails entityTypes={['community']}` — **already has it** |
  | `/members` | `ListingShell` | `MembersFilters` rail — **no** DiscoveryRails |
- **The reuse trap.** `/`, `/courses` and `/communities` only *mention* `ListingShell` in comments — each
  hand-rolls its own two-column shell (all three replaced the centered `ListingShell` to kill a dead left
  gutter). So there are already **three** near-duplicate implementations of "content + right rail", and this
  request would add a fourth. That is the `[CTA-HOST-GUARD]` shape exactly: N copies of one arrangement,
  free to drift. Strong argument for extracting the two-column-with-rail shell ONCE and porting the three
  existing pages onto it, rather than pasting a fourth.
- **Target 1 — `/course/[slug]/[...tab].astro`.** Uses `AppLayout`, whose slots are `header-bar`,
  `entity-header`, `role-tab-bar`, `sub-nav`, default. **There is no right-panel slot** — so this needs
  either a new `AppLayout` slot or a bespoke column in the page.
- **⚠️ `[LAYOUT-MODE]` collision — smaller than it first looked.** `SUBNAV_LAYOUT` is **`'top'`**
  (`src/lib/subnav-layout.ts`), so by default the `sub-nav` slot is a horizontal strip and there is **no left
  rail at all**. `AppLayout` only goes side-by-side (`lg:flex-row`) when `subNavOnLeft` is true, which comes
  from a per-user `Astro.locals.navLayout` opt-in or from flipping that one global constant back to `'left'`.
  So content + right panel = **2 columns for the default case**, matching `/` and `/courses`; the 3-column
  case (left rail + content + right panel) only arises for opted-in users. **Still needs a decision** for
  that minority — see the open question below.
- **Target 2 — CONFIRMED Conv 435 (user):** "the details pages are the ones that open when you pick a member
  from /members and you pick a community from /communities" → **`/@[handle]`** and **`/community/[slug]`**.
  The listing pages are NOT in scope (`/communities` already has the panel; `/members` keeps its filters rail).
- **The three targets are structurally different — do not assume one fix ports:**
  | Route | Shell | `sub-nav` slot | Rail collision? |
  |---|---|---|---|
  | `/course/[slug]/[...tab]` | `AppLayout` | yes — `CourseRail` (orientation-aware) | only in `'left'` opt-in |
  | `/community/[slug]/[...tab]` | `AppLayout` | yes — plain `SubNav` | only in `'left'` opt-in |
  | `/@[handle]` | `AppLayout` | **none** — content is `max-w-4xl mx-auto` | no collision; needs the centered cap reconsidered |
- **APPROACH — DECIDED Conv 435 (user): extract the shared shell FIRST.** Build the two-column-with-rail
  shell once, port `/course/[slug]` onto it, then migrate `/`, `/courses` and `/communities` onto it after.
  Explicitly NOT a bespoke fourth copy. This is the `[CTA-HOST-GUARD]` lesson applied before the damage.
- **3-COLUMN — DECIDED Conv 435 (user): SHOW the right panel in `'left'` rail mode too.** Left rail +
  content + right panel at desktop. Must be proven with the exact-size iframe harness, not assumed.
- **The extraction is smaller than the ask sounds.** The rail is a self-contained ~18-line block in
  `courses.astro` (`<aside class="hidden lg:block lg:flex-1">` → sticky wrapper with a `max-h`/scroll cap →
  `DiscoveryRails` with a blue honest-orphan placeholder as its fallback child). And `AppLayout` already
  wraps sub-nav + content in `flex flex-col gap-16 flex-1 lg:flex-row`, so a third flex child is the natural
  seam — a `right-panel` slot there produces the approved 3-column case for free.
- **Phases:**
  - **A ✅ SHIPPED Conv 435** — rail block extracted into one component, `right-panel` slot added to
    `AppLayout`, `/course/[slug]/[...tab].astro` wired, proven responsively incl. the 3-col `'left'` case.
  - **B + C** — the remaining phases, itemised under **WHAT'S LEFT** at the top of this task.
- **Testing note:** this is a desktop-breakpoint change — use the exact-size same-origin iframe harness
  (`[MINWIDTH]` / `[SIDEBAR-COLLIDE]`, `reference_responsive_iframe_harness`), not viewport resizing, and
  measure live per `[PREMISE]`.
- **RFC:** not yet in one. Per the Conv-433 working model a client request gets its own `[CODE]` first and
  batches into an RFC once several accumulate; CD-040 covers the *closed* 433–434 batch, so this belongs to
  the next batch (CD-041), not appended there.
- **Refs:** `src/components/discovery/DiscoveryRails.tsx`, `src/lib/discovery-rails/`,
  `src/pages/{index,courses,communities,members}.astro`, `src/components/layout/ListingShell.astro`,
  `src/layouts/AppLayout.astro`, `src/components/course/CourseRail.astro`, `[LAYOUT-MODE]` (Conv 357).

### [RATING-COUNT-DEAD]

- **State:** 📋 queued · small · surfaced by the Conv-429 `[CRS-CREATED-CARD]` trace
- **What:** two display gaps found while tracing the creator-course cards, both harmless but both real drift. (1) **`rating_count` is dead weight**: `/api/me/creator-dashboard` SELECTs it, the response returns it, `CreatorCourseCard`'s `Course` interface declares it — and **nothing renders it**. The orphaned `CourseCreatedCard` does render it (`4.5 (12)`), so the intent existed. Either surface it beside the rating or drop it from the query + interface; carrying a field nobody reads is the shape that made `[TDASH-CERTS-DEAD]` worth closing.
- (2) **Vocabulary split for one state:** `/creating` renders the active state as **"Active"** while `/creating/studio` renders it as **"Published"**, for the same `is_active=1 AND is_retired=0` course. Conv 429 deliberately did **not** unify these — the fix in hand was the missing *Retired* state, and renaming a live user-visible label is a separate decision, not something to smuggle into a defect fix. Pick one word and align both.
- **Why it matters:** low severity, but both are cheap and both are the kind of drift that reads as intentional later.
- **Refs:** `src/pages/api/me/creator-dashboard.ts`, `src/components/dashboard/CreatorCourseCard.tsx`, `src/components/creators/studio/CreatorStudio.tsx` (`getStatusBadge`), `[CRS-CREATED-CARD]`, `[TDASH-CERTS-DEAD]` precedent.

### [RHOOKS]

- **State:** 🔄 active · `[Opus]`
- **Conv 428 — tagged `[Opus]`, and the count grew.** The role-gate work added **8** warnings (156→164), one per gated island, all `set-state-in-effect` from `useRoleGate`'s async effect — the same pattern `useCreatorGate` always had. Tagged because the fix is a **subtle cross-cutting refactor**: these effects sit on the auth-bootstrap path, and the three-state race they guard has bitten silently three times (`[MSGBOOT]` 417, `[COURSETAB-HASH]` 419, pre-empted in `[REC-REHOME]` 427). Rewriting them to `useSyncExternalStore`/derivations, as Conv 400 did for `useAuthStatus`, is where local correctness depends on distant invariants.
- **What:** full `react-hooks` `recommended-latest` set adopted at **warn** (Conv 400) — `eslint.config.js` `.tsx` block spreads `asWarn(reactHooks.configs['recommended-latest'].rules)` (17 rules), then re-overrides `rules-of-hooks` back to `error` (0 violations). No new dep, no `overrides` pin (react-hooks@7.1.1 already ships `eslint ^10`). Gate GREEN. Triage incrementally.
- **Backlog — 95 warnings** (0 `.astro`; scoped `**/*.{ts,tsx}`): `set-state-in-effect` 93 (accepted baseline) · `purity` 1 · `preserve-manual-memoization` 1. `static-components` + `immutability` fully cleared.
  - **Batch 1 done (Conv 400):** 6 `static-components` hoisted + 4 `immutability` reorders + `FilterContent` inline→element-value. Net −6 (the 4 reorders unmasked latent `set-state-in-effect` the error had hidden).
  - **`set-state-in-effect` DECIDED — accepted baseline, not a to-do list.** ~49 idiomatic fetch-on-mount + ~25 deliberate SSR-hydration-safety + ~15 low-ROI; rewriting risks SSR/hydration bugs. Kept at warn; triage only new/egregious cases. One genuine fix taken: `useCurrentUser`+`useAuthStatus` → `useSyncExternalStore` (reusable pattern for client-store hydration hooks).
  - **Leave at warn:** `purity` = `ModeratorDetailContent:83` (`Date.now()` countdown); `preserve-manual-memoization` = `CoursesCatalog:211` (advisory).
- **Next (opportunistic):** clear residual warnings in files touched for other reasons (`[LE-TRIAGE]`/`[A11Y]` model). No standalone sweep.
- **Refs:** `../Peerloop/eslint.config.js`, `docs/decisions/06-testing-ci.md §§ RHOOKS/RDOC`, `[A11Y]`, `[LE-TRIAGE]`.



### [ROUTESTORIES-DRIFT]

- **State:** 📋 queued · doc drift · surfaced by the `/r-end` docs agent, Conv 428
- **What:** `docs/as-designed/route-stories.md` declares itself the "canonical mapping of **current** routes to user stories", but §3 still documents `/discover`, `/discover/courses` (with role-aware tabs) and `/discover/course/[slug]` — routes dissolved at ROUTE-FLIP (Conv 197) and barred by `[DISC-DROP]`. So the doc's own stated scope is wrong.
- **Why it wasn't fixed inline:** reconciling ~402 story IDs against the live route set is a pass, not an agent edit. Long-standing drift, unrelated to Conv 428's work.
- **Note:** the role tabs §3 describes are now doubly gone — `[M3]`/`[CRS-ROLE-DORMANT]` (Conv 428) removed the `/courses` ones too.
- **Refs:** `docs/as-designed/route-stories.md` §3.

### [RSFD]

- **State:** 📋 queued · low priority (skill infra)
- **What:** port spt-docs' `/r-start-from-dirty` (retroactively wrap an already-dirty tree in a tracked Conv). **Not a file copy** (Conv-395 audit): 3 deps missing here — `conv-start-core.sh` (peerloop inlines increment/heartbeat at Steps 3/4/5), `r-health.js`, and `event.js` + `.conv-events.jsonl` (**Peerloop has no event-log system**, which the skill's retro-fire Step 6 depends on entirely).
- **Blocking decision before any build:** does Peerloop want an event log? Without one, a port just increments a counter over a dirty tree and the reasoning is still lost. Must also handle peerloop-only substrate: `conv-session-lock.sh`, `conv-branch-check.sh`, the ~150-line Step 5.7 memory sync.
- **Refs:** `~/projects/spt-docs/.claude/skills/r-start-from-dirty/SKILL.md`, `[[feedback_skill_sync_same_name_divergence]]`. Surfaced Conv 395.

### [RSYNC-GATE]

- **State:** 📋 queued (skill infra)
- **What:** `/r-start` Step 5.7 Phase 2's `rsync -a --delete "$MIRROR/" "$LIVE/"` gets **DENIED by the auto-mode classifier** ("Irreversible Local Destruction" — a destructive call right after a diff-gate whose result is an unseen tool result). **Intermittent** (corrected Conv 397 — NOT every conv), which is worse: a silent pass can be misread as "sync happened". On a conv where the mirror genuinely differs, the block lands mid-`/r-start` and the memory sync doesn't happen.
- **Options:** (a) move Phase 2 into a named script (`conv-memory-sync.sh`) that reads as intentional; (b) Phase 1 writes a decision sentinel Phase 2 checks; (c) document the expected block so CC handles it deterministically; (d) a project `settings.json` allow-rule for the specific invocation.
- **Asymmetry:** `/r-commit` Step 1.5 + `/r-end` Step 5b run the same rsync **live→mirror** (safe) and are never blocked. Only mirror→live is sensitive.
- **Refs:** `.claude/skills/r-start/SKILL.md` Step 5.7 Phase 2, `[[feedback_msi_sync_user_checkpoint]]`. Surfaced Conv 395.

### [QSLOT]

- **State:** 📋 queued · small — process observation from Conv 435, worth one calibration pass not a project
- **Two near-misses this conv, both the same shape: reading data before establishing its shape.**
  1. **Batched questions answered out of slot.** Three `AskUserQuestion` items went out together; the reply in
     Q1's slot was actually a correction to Q2's *premise* ("that was my mistake, the details pages are…").
     Recording it as Q1's answer would have left the genuinely open question (the rail collision) unanswered
     while proceeding as though all three were settled. It was caught, re-asked, and cost one turn.
  2. **Truncated list read as ordered.** `wrangler deployments list | head -14` showed 2026-04 dates; read as
     newest-first that means staging's cron was four months stale — a serious, wrong conclusion one sentence
     from being reported. The list is **oldest-first**; the newest deployment was 2026-07-29.
- **The common rule:** when the shape of the data (which slot an answer belongs to, which end of a list is
  newest) is assumed rather than checked, a confident wrong statement follows. Cheap fixes:
  `... | grep -c '^Created:'` then `| tail -3` before concluding; and when a batched answer doesn't match its
  question, re-ask rather than infer.
- **Disposition:** no code change. Decide whether either belongs in `memory/` as a standing rule — the
  ordering one may already be covered by `[PREMISE]` (`feedback_retest_task_premise_before_executing`), in
  which case this is a confirming instance, not a new memory. Check before writing.

### [SLOT-COLLIDE]

- **State:** 📋 queued — surfaced by the r-end docs agent, Conv 435
- **What:** `AppLayout` gained a `right-panel` slot in Conv 435, but **`ListingShell` already has a slot of
  that exact name** with different semantics, documented in `docs/reference/_COMPONENTS.md`
  (lines ~1070–1071 / 1088). Two contracts, one name:
  | Owner | `right-panel` means | Renders |
  |---|---|---|
  | `ListingShell` | the page's **filter** aside | on the **LEFT** in side-rail mode; not at all in top-bar mode |
  | `AppLayout` (new) | the **discovery rail** | on the **RIGHT** at ≥lg, in both modes |
- **Why it matters:** a reader hitting `slot="right-panel"` in `[...tab].astro` and looking it up finds the
  wrong contract — and it is wrong in the most confusing possible way, since one of the two does not render
  on the right. This is a name I chose without checking the existing slot vocabulary.
- **Options:** (a) rename `AppLayout`'s slot to something unambiguous (`discovery-rail` / `aside-right`) —
  cheap NOW, only 1 consumer; (b) rename `ListingShell`'s; (c) keep both and document the collision loudly.
  (a) gets cheaper the sooner it is done and more expensive after phase B adds consumers.
- **Do it with `[RAIL-DETAIL]` phase B** if (a) is chosen — the three listing pages migrate then, which is
  when the two slot vocabularies actually meet. Note `[RAIL-DETAIL]` is parked on client acceptance, so if
  the panel is rejected this dissolves.
- **Also:** `_COMPONENTS.md` § Layout Components documents neither the new slot nor `DiscoveryRailPanel.astro`.
- **Refs:** `docs/reference/_COMPONENTS.md`, `src/layouts/AppLayout.astro`,
  `src/components/layout/ListingShell.astro`, `src/components/discovery/DiscoveryRailPanel.astro`.

### [SHADOW-DEAD]

- **State:** ⏸️ parked · **gate:** a deliberate app-wide shadow pass — **user decision, Conv 434.** Not to be
  picked up opportunistically as a "token cleanup"; the fix moves 30 live call sites onto different pixel
  values, so it needs its own before/after sweep whenever elevation is next revisited across the app.
  Note for whoever picks this up: this is **not** the "should the pill shadow go site-wide?" question — that
  one is answered under `[PILL-LIFT]` (no, deliberately local). These two got conflated when the task was
  parked, and they are independent.
- **What:** the 7 `--shadow-{sm,md,lg,xl,2xl,inner,none}` tokens in `tokens-primitives.css` are declared in
  `:root` only, **not** in an `@theme` block — so Tailwind generates no utilities from them and the app's
  **30** `shadow-sm|md|lg|xl` call sites silently resolve to **Tailwind v4's defaults** instead.
- **Verified, not inferred (Conv 434):** compiled the real stylesheet with `@tailwindcss/cli@4.3.3` —
  `.shadow-sm` emits `0 1px 3px 0 rgb(0 0 0/.1), 0 1px 2px -1px rgb(0 0 0/.1)` (the v4 default) while `:root`
  separately declares `--shadow-sm: 0 1px 2px 0 rgb(0 0 0/.05)` (the v3 value) with **zero** references.
- **Why it matters:** this is the exact shape of the Conv-311 radius bug, where every bare `rounded-8`/`-12`/
  `-16` computed 0px because the scale sat in `:root` instead of `@theme`. It is quieter here — the utilities
  still *work*, they just don't mean what this repo says they mean — which is why it survived. The token file's
  own comment ("Scaffolded — specific values pending") suggests nobody ever intended these to be live.
- **Why NOT fixed inline:** moving them into `@theme` re-points 30 live call sites at different pixel values.
  That is a **visual change across the app**, not a token cleanup, and it belongs behind a before/after sweep
  (the Conv-423 compile-diff + live-measure technique applies directly). Out of scope for a client UI request.
- **Shape:** decide first whether the declared v3-shaped values or the v4 defaults are the intended design —
  the answer may be "delete the dead block and keep the defaults", which is a one-line fix with no visual delta.
- **Refs:** `src/styles/tokens-primitives.css` § Shadows, `src/styles/tokens-tailwind-bridge.css` (`@theme`),
  Conv 311 `[SWEEP-SPACING-GREP]` radius precedent. Surfaced Conv 434 while adding `[PILL-LIFT]` tokens.
- **Client-visible:** parked item in `docs/requirements/rfc/CD-040/RFC.md` §2, and open question Q2 there
  ("does the pill elevation go app-wide?"). The client's answer is what un-gates this.

### [SCHEMADIAG]

- **State:** 📋 queued (doc drift)
- **What:** `docs/as-designed/schema-diagram.md` is **badly stale and driftCheck** — claims "48 tables" against **71** on disk, still diagrams tables that were dropped (`user_interests`), and was last updated **2026-01-31**. Conv 432's `community_tags` is now one of ~23 missing tables, and `courses.primary_topic_id` (removed Conv 432) is presumably still drawn.
- **Why it wasn't fixed inline:** the r-end docs agent (Conv 432) correctly declined — this needs a full ERD regeneration, not a one-line patch, and a drive-by partial edit is exactly the Conv-200 manufactured-edit anti-pattern.
- **When picked up:** decide first whether the ERD stays hand-drawn or becomes `generated` from `migrations/0001_schema.sql` (a parser already exists — `scripts/reset-d1.js` extracts every `CREATE TABLE` + its `REFERENCES` to compute drop order, which is the same graph an ERD needs). That choice IS the work; a hand-redraw of 71 tables would be stale again within a few convs.
- **Refs:** `docs/as-designed/schema-diagram.md`, `migrations/0001_schema.sql`, `scripts/reset-d1.js` (`getTableDropOrder`), `.claude/scripts/docs-registry.mjs doc-category`, `[COMPDOC]` (same hand-maintained-vs-generated question).

### [SCRATCH-DEBRIS]

- **State:** 📋 queued · trivial (cleanup)
- **What:** `.scratch/conv-tasks.md` still exists despite being **retired by [CURTASKS] (Conv 351)** — `CURRENT-TASKS.md` replaced it. Verify nothing reads it (grep the skills), confirm it isn't depended-on machine-local state, delete. `.scratch/` is gitignored + machine-local, so MacMiniM4 may hold its own copy.
- **Refs:** `[[feedback_current_tasks_persistence]]`. Surfaced Conv 395.

### [SESSION-REMIND-DEPLOY]

- **State:** ⏸️ parked · **gate: MVP-GOLIVE** (prod repeat only; staging DONE Conv 388)
- **Done (staging, Conv 388):** reminder columns applied (reseed), `RESEND_API_KEY` set on `peerloop-cron-staging`, cron worker deployed (`d95ddb91`, `*/15`). Reminders now fire on staging instead of logging `skipped`.
- **Remaining (prod, gated):** repeat both steps for production — `wrangler secret put RESEND_API_KEY --env production --config workers/cron/wrangler.toml` + `deploy:cron:prod` — when prod is unblocked.
- **Refs:** `workers/cron/wrangler.toml`, `src/lib/session-reminders.ts`.

### [SKILLDOC]

- **State:** 📋 queued (doc drift)
- **What:** `docs/as-designed/skills-system.md` (driftCheck) task-lifecycle sections (~311–313 skill-role table, ~503–515 "Task flow" diagram) still describe the **retired TodoWrite/TaskCreate overlay** ("clear TodoWrite", "preserve-then-overlay", "TaskCreate when an item is started") — pre-existing Conv-406 detach drift, surfaced by the r-end docs agent Conv 407. The agent declined a shallow patch (correctly): the fix needs re-grounding against the current r-start/r-commit/r-end SKILL.md bodies + the write-through board model.
- **Refs:** `docs/as-designed/skills-system.md`, `[TASK-TOOLS-VERIFY]`, `[[feedback_current_tasks_persistence]]`. Surfaced Conv 407.


### [TASK-TOOLS-VERIFY]

- **State:** 👀 watch — investigation resolved Conv 406; one live probe pending
- **Root cause FOUND (Conv 406, binary decompile).** `TaskCreate`/`TaskList`/`TaskUpdate`/`TaskGet` are gated by a second, **undocumented** switch beyond `CLAUDE_CODE_ENABLE_TASKS`: `uZ()` reads remote dynamic config `tengu_vellum_ash` and returns true if the **current model ID contains** any listed string. All four are `isEnabled(){return uH()&&!uZ()}`; `TodoWrite` is `!uH()&&!uZ()` — so `uZ()` kills **both**, a combination no local setting can produce. `uH()` (the documented env gate) is provably true now → **`uZ()` is true**. Binary identical across 2.1.214/215/216; `~/.claude/tasks/` last written 07-21 07:21 (after the 2.1.216 install) then stopped → **server-side gate, not a version bump, not our config.** `vellum` = 0 hits in the whole changelog. `CLAUDE_CODE_CHILD_SESSION=1` is harness-native (in no config file) → Conv-403 theory stays falsified.
- **Grep/Glob = SEPARATE known upstream bug** (built-ins vanish from the registry under tool-search deferral; not ToolSearch-discoverable): issues #52121 + #63525, both OPEN. Older, unrelated to the Task gate. Both tools still shipped + documented.
- **One live probe left:** the gate substring-matches the model ID `claude-opus-4-8[1m]`. If the list targets the **1M variant**, selecting the **non-1M Opus 4.8 via `/model`** (not `CLAUDE_CODE_DISABLE_1M_CONTEXT` — that flips detection but `mi()`/`kD()` keep the `[1m]` suffix, so it's void) would restore `Task*`. Negative → the gate targets Opus 4.8 broadly → no local workaround → `/feedback`.
- **Decision (Conv 406): HARD-DETACH from the Task subsystem** — skills/CLAUDE.md/hook rewritten to write-through `CURRENT-TASKS.md` directly, no Task-tool reliance. So this watch no longer blocks work; keep it only to record the gate + run the `/model` probe if curious.
- **Cross-machine:** MacMiniM4 still carries stale Conv-403 `~/.zshrc` `env -u` guards (harmless no-ops) — clean next time on it.
- **Refs:** `memory/project_task_tools_child_session_leak.md`, `DOC-DECISIONS.md §3`, `code.claude.com/docs/en/tools-reference.md`. Surfaced Conv 404, root-caused Conv 406.

### [TLFMT]

- **State:** 📋 queued — surfaced by the `/r-end` learn-decide agent, Conv 422
- **What:** `.claude/skills/r-end/refs/fmt-learn-decide.md` § Timeline Routing documents a
  `TIMELINE.md` shape that **no longer matches the live file**. The ref describes `## YYYY-Mmm-DD`
  headings with a `| Conv |` column; the file actually uses `## YYYY-Mon` month sections with
  `| Date | Ref | Event | Rationale | Concerns |`.
- **Why it matters:** every future `/r-end` learn-decide agent hits this mismatch and has to improvise
  the format from the file. Conv 422's agent did exactly that (correctly followed the file, not the
  ref) — but improvisation is where inconsistent rows come from.
- **Fix:** update the ref to describe the real shape. Read `TIMELINE.md` first — the ref is the thing
  that's wrong, not the file. Also check whether `fmt-learn-decide.md`'s "Last Updated" convention
  claim is accurate: the decision chunks/log/INDEX use a `> Part of…` header rather than a
  "Last Updated" line, so that instruction is a no-op today.

### [SEED-NOTIF-STALE]

- **State:** 📋 queued — trivial, local dev data only
- **What:** seeded admin notification `notif-brian-001` reads *"Jennifer Kim has a pending teaching certificate
  for…"*, which became false in Conv 434 when her seeded `cert-jennifer-cc-teach` row was deleted (at user
  request, to clear a 409 blocking an end-to-end test of the new request flow).
- **Impact:** cosmetic and admin-only — its `action_url` still points at a valid `/admin/certificates` queue,
  which is non-empty. Left deliberately rather than deleted unasked.
- **Fix:** either drop the notification row, or re-seed (`npm run db:setup:local:dev` restores both).
- **Refs:** `migrations-dev/0001_seed_dev.sql`, `[TEACH-REQ]` Conv 434.
- **Client-visible:** open item in `docs/requirements/rfc/CD-040/RFC.md` §4. Tick it there when this closes.

### [TESTUNITDOC]

- **State:** 📋 queued — surfaced by the `/r-end` docs agent, Conv 417
- **What:** `docs/reference/TEST-UNIT.md` (registry category **driftCheck**, so in scope) has been stale
  since **Conv 253**. It lists roughly **21 of the 33** files in `tests/lib/`, and it contradicts itself:
  its own "Subtotal: 20 files, 315 tests" disagrees with its row count, and its Summary claims
  14 files / 262 tests.
- **Not a one-row patch.** The Conv-417 additions were documented, but the file needs a standalone
  reconciliation pass against disk — the same shape as the Conv 378 page-test pass.
- **Re-flagged Conv 418 with sharper numbers** (docs agent declined to patch one row into a doc whose
  totals are globally wrong — correctly): header claims `Total: 25 test files`; the **SSR Loader Tests**
  table lists 3 files at 4 / 13 / ~20 tests against on-disk **7 / 20 / 14**, omits
  `tests/ssr/soft-deleted-users.test.ts` entirely, and its summary row still reads `SSR Loaders | 3 | ~40`.
  Reconcile against a verified `vitest run`, not against the file's own arithmetic.
- **Note:** `TEST-COVERAGE.md` + `TEST-COMPONENTS.md` were reconciled this conv (the docs agent also
  corrected three section headers that had lagged since the Conv 392/393 orphan purge), and
  `sync-gaps.sh` now reports **all 405 test files documented, no gaps** — so this is the last known
  test-doc drift.
- **Refs:** `docs/reference/TEST-UNIT.md`, `.claude/scripts/sync-gaps.sh`.

### [SPACING-4X]

- **State:** 📋 queued
- **What:** Sweep for other **4× rendered-size artifacts** that the Conv-423 spacing-base fix faithfully preserved. `dc1f031e` correctly rewrote size-preserving (`w-56`→`w-224`, `w-80 h-56`→`w-320 h-224`) because pre-fix those classes resolved through Tailwind's stock `0.25rem` base to 4× their apparent intent. The migration was right; what it preserved in places was a pre-existing `[DEMO-HOME]`-class bug.
- **Why:** Conv 426 found **two** such instances on one page (`/community/[slug]` identity square at 224px beside a 96px mobile value, and a Courses-tab thumbnail at 320×224 for what reads as a list-row thumb). Both were found incidentally while reviewing the client branch — Brian had independently flagged the first. Nobody has swept for others.
- **Shape:** grep the Conv-423 commit for size-class rewrites where the *new* number is ≥4× a neighbouring literal (`w-[96px]` next to `w-224`), or where the value is implausible for its role (list thumbnails, avatars, icon wells). Measure live before changing anything — the rendered size is by definition unchanged since Conv 423, so this is a *design-intent* judgement, not a regression.
- **Note:** both known instances are already gone — superseded by MERGE-BRIAN §3 N1 and N4. This task is only about the unswept remainder.
- **Refs:** `plan/merge-brian/README.md §3 finding F5`, code `dc1f031e`, `memory/reference_tailwind_intellisense_canonical_suggestions.md`.

### [TSLASH]

- **State:** 📋 queued · [Opus]
- **What:** Trailing-slash URL variants are not treated as equivalent to their bare form, so route policy diverges between `/x` and `/x/`. **Measured Conv 408 on `:4321`:** signed-out `GET /profile` → `200` (correct — bare `/profile` is the PUBLIC auth-swap surface, Conv 349 `[PROF-MERGE]`), but signed-out `GET /profile/` → `302 /login?redirect=%2Fprofile%2F`. The slash form is being classified as a *subpath* and therefore auth-gated.
- **Suspected cause:** `src/middleware.ts` `PROTECTED_SUBPATHS_ONLY = ['/profile']` — the "is this a subpath?" test presumably matches any path starting with `/profile/`, which `/profile/` itself satisfies with an empty remainder. Verify before fixing; the same class of test may exist in `PROTECTED_PREFIXES` / `PROTECTED_EXACT`.
- **Scope (user directive, Conv 408): do NOT special-case `/profile`.** Handle trailing slashes **generally, for every route** — one normalization decision applied site-wide, not a per-route patch. Decide and record the policy: canonical-redirect `/x/` → `/x` (301) at the edge/middleware, vs. normalize-then-match internally, vs. Astro's own `trailingSlash` config (`'always' | 'never' | 'ignore'` in `astro.config.mjs`) — check what that config is currently set to first, since it may be the right single lever and interacts with the CF Workers adapter.
- **Also check:** whether the same divergence hits auth-gated routes generally (`/learning/`, `/teaching/`, `/creating/`, `/messages/`) and whether any *canonical/SEO* surface double-serves content at both forms (duplicate-content risk on public pages like `/courses/`, `/@handle/`).
- **Done test:** for a representative protected route, a public route, and `/profile`, the bare and trailing-slash forms produce the same auth outcome; policy documented; a test covers it.
- Surfaced Conv 408 while investigating a separate (unreproduced) `/profile` → `/@handle` redirect report.

### [TURNLOG]

- **State:** 📋 queued (workflow guard)
- **What:** `.scratch/conv-turns.md` went **unmaintained for an entire conv** — CLAUDE.md §Conversation Turn Log requires an entry at the end of *every* turn; Conv 396 wrote only Turn 1 and turns 2–11 were reconstructed at `/r-end`. The failure is **silent** (nothing verifies the file), and the user keeps it open expecting a live log → a stale file is worse than an absent one. Same **printed-but-not-verified** class `[CBG]` fixed for branches.
- **Options:** (a) a Stop-hook checking whether the file grew — but CLAUDE.md prefers **structural prevention over post-hoc detection** (QLINT Stop-hook was retired for this exact reason, Conv 273), so weakest despite obvious; (b) fold turn-logging into an already-mandatory step so it can't be skipped; (c) accept retroactive `/r-end` reconstruction as the real contract and rewrite the rule to match.
- **Refs:** CLAUDE.md §Conversation Turn Log, `[[feedback_option_phrasing]]`, `.claude/skills/r-start/SKILL.md` Step 7.7. Surfaced Conv 396.

### [UXQ]

- **State:** 👀 watch (harness-UX, upstream) · low priority
- **What:** `AskUserQuestion` tears down the option picker when the user selects "let me clarify" — the choices vanish. User flagged directly Conv 385. Workaround: re-render options as durable prose. **Not fixable in this repo** — a CC harness behavior; report-upstream note.
- **Frequency:** 3 teardowns in Conv 407 alone (Fable 5, focus mode) — the durable-prose re-render workaround was exercised each time.
- **Refs:** surfaced Conv 385.

### [FEEDBACK-DEPLOY]

- **State:** ⏸️ parked · **gate: MVP-GOLIVE** (prod repeat only; staging DONE Conv 394)
- **Done (staging, Conv 394):** 3 schema columns applied to staging D1 via non-destructive `ALTER` (`email_feedback_reminder` on `users`; `feedback_reminder_student_sent_at` + `feedback_reminder_teacher_sent_at` on `sessions`), cron worker redeployed (`37e506d5`, `*/15`); `RESEND_API_KEY` already set → `sendFeedbackReminders` fires (not skipped).
- **Remaining (prod, gated):** apply the same 3 columns to prod D1 (`ALTER` or reseed) + `deploy:cron:prod`. Mirrors `[SESSION-REMIND-DEPLOY]`.
- **Refs:** `src/lib/feedback-reminders.ts`, `workers/cron/wrangler.toml`.

### [BROWSER-SMOKE-2B]

- **State:** ⏸️ parked · `[Opus]` · **gate: post-launch**
- **What:** evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor. **Do NOT resurrect Playwright E2E.** Duplicates `[PLATO-SEQ]` Phase 4c.
- **Refs:** `docs/decisions/06-testing-ci.md`.

### [ICON-STATES]

- **State:** 📋 queued — the ICON-SIZING block's one remaining piece of real work (Phase 5 tail).
- **What:** prove the icon axis over states a route walk never enters — dropdown menus, slide-over
  panels, modals, and loading/skeleton branches. `codecheck-orphan-components.mjs` returns **PASS**, so
  these are *not* dead code; they are simply states nothing has driven.
- **Denominator restated Conv 424:** **528 attributable call sites** (was quoted as 629/690). The 107
  component defaults and 61 `.astro` sites are now excluded by decision — defaults can never be proven by
  rendering (0 of 395 resolved usages omit `className`), and `.astro` has no React fiber to attribute
  against, though `check:icons` **does** statically enforce it. The ledger prints the residue **per file**,
  so this is a countable worklist, not open-ended coverage.
- **Refs:** `plan/icon-sizing/README.md` § Phase 5 tail, `scripts/icon-scan.mjs` (`reportLedger`).

### [ICON-LIC]

- **State:** ⏸️ parked · **gate: MVP-GOLIVE** (pre-launch legal/compliance)
- **What (surfaced Conv 370):** two items.
  - **Attribution NOTICE** — no `LICENSE`/`NOTICE`/`THIRD-PARTY-NOTICES` file, but `icons.tsx` = Heroicons (MIT, Tailwind Labs) and ~20 `MattIcon` SVGs = Material Symbols (Apache 2.0, Google) both require the notice retained → add a third-party-notices file (low effort).
  - **Brand-logo trademark review** — `brand-icons.tsx` (Google/Stripe/GitHub/X/LinkedIn/YouTube/Instagram) are trademarks: check each against brand guidelines (esp. Google Sign-In button rules, Stripe badge rules, `fill="currentColor"` recoloring). The 39 `matt-catalogue` MattIcons are commissioned — verify the designer agreement assigns IP.
- **NOT legal advice — needs counsel sign-off at launch.**
- **Refs:** `docs/as-designed/icon-system.md`, `src/components/icons/icon-provenance.ts`.

---

## ✅ Done this conv

- **[GATEPAR]** — resolved via the Conv-439 `/w-codecheck` refactor (scope option B). Established the
  two-level model (commit-safety `/w-codecheck` = fast static, no test/build; deploy-safety
  `npm run verify` = +test+build, −E2E/PLATO); added `check:icons` to the skill; fixed the false
  "`/w-codecheck` bundles the 5 gates" claim in CLAUDE.md §Baseline + CLAUDE-OFFLOAD.md (×3); moved gate
  rationale + the Tailwind rename table to new `docs/reference/CODECHECK.md`; removed the dead
  `clear`-mode / TodoWrite cruft.
- **[TZLINT]** — resolved same conv. `lint:tz` is **not** orphaned: it's a gate in CI (`.github/workflows/ci.yml`).
  The new `codecheck` reporter now also runs it locally as a 🔴 build-blocker, so `npm run verify` covers it too.
- **codecheck reporter (scope A)** — `scripts/codecheck.mjs` replaces the `&&` chain: runs all static checks
  without short-circuiting, prints one grouped report (🔴 build-blockers = CI gates / ⚠️ local quality gates /
  ℹ️ warnings), emphasising CI-gating findings. Surfaces the 163 ESLint warnings (88 react-hooks / 75 jsx-a11y)
  as non-blocking. Built + calibrated the 5 grep/script gates as real npm scripts; `verify` = `codecheck && test && build`.
- **[OUTLINE-V4B]** — all 6 `outline-none`→`outline-hidden` sites cleared + a `check-tailwind-v4.sh` CSS-var
  false-positive fixed; SubNav 2 icons `size-16`→`size-icon-16`. `check:tailwind`/`check:icons` green; new
  `outline-none` is now caught by the gate, so the drift channel is closed. (Remove its 🎯 Now line at next tidy.)
