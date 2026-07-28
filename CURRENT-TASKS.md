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

> **MESSAGES mini-plan — ✅ COMPLETE (M1–M6, Convs 417–419).** `[MSGBOOT]` 417 · `[CANMSG]`,
> `[MSG-ICON]`, `[MSG-ADOPT-A]` 418 · `[MSG-ADOPT-B]`, `[MSG-CLEANUP]` 419. Every per-user message
> affordance composes in place, the per-row can-message fan-out is gone (4 requests → 0), and the
> orphaned endpoint is deleted. Nothing outstanding — kept here one conv for traceability, then
> delete this note.

1. [MERGE-BRIAN-JULY7](#merge-brian-july7) — client branch assessment/integration
2. [ROLE-CRS-LIST](#role-crs-list) — teaching/moderating course lists (blocks §2 M3)
3. [REC-REHOME](#rec-rehome) — rehome course recommendations (blocks §2 M4)
4. [A11Y](#a11y) — accessibility lint triage
5. [RHOOKS](#rhooks) — react-hooks lint triage
6. [KNIP](#knip) — dead-export oracle → gate
7. [PROV-SWEEP-DEBT2](#prov-sweep-debt2) — `prov:sweep` gate silently red (10 unregistered)
8. [TURNLOG](#turnlog) — `conv-turns.md` unmaintained guard
9. [EDITSAFE](#editsafe) — anchored-edit discipline
10. [RSYNC-GATE](#rsync-gate) — memory-sync rsync auto-mode block
11. [COMPDOC](#compdoc) — `_COMPONENTS.md` ui/ section stale
12. [EMAILDOC](#emaildoc) — `resend.md` dead-template refs
13. [HOME-FIXES](#home-fixes) — Home route fix bucket
14. [COURSES-FIXES](#courses-fixes) — Courses route fix bucket
15. [BRAND-DOCS](#brand-docs) — "PeerLoop"→"Peerloop" docs casing
16. [SCRATCH-DEBRIS](#scratch-debris) — delete retired `conv-tasks.md`
17. [DEVSRV-KILL](#devsrv-kill) — scope dev-server teardown to PID
18. [BRIDGE-UPLOAD](#bridge-upload) — browser file-upload fallback
19. [BLOCKPLAN](#blockplan) — `CURRENT-BLOCK-PLAN.md` keep/remove
20. [UXQ](#uxq) — AskUserQuestion picker teardown (upstream)
21. [RSFD](#rsfd) — port `r-start-from-dirty`
22. [DEPEXP](#depexp) — dependency-probe hygiene
23. [MEM-PRUNE](#mem-prune) — MEMORY.md auto-load cap watch
24. [TASK-TOOLS-VERIFY](#task-tools-verify) — Task-tools gate probe
25. [SKILLDOC](#skilldoc) — `skills-system.md` retired Task-overlay drift
26. [TSLASH](#tslash) — trailing-slash route normalization (`/profile/` 302s, bare `/profile` 200s)
27. [CHIPWRAP](#chipwrap) — course-hero mobile chips wrap (optional, user say-so)
28. [DL-FILENAME](#dl-filename) — download Content-Disposition filename lacks file extension
29. [TESTUNITDOC](#testunitdoc) — `TEST-UNIT.md` stale since Conv 253 (r-end docs agent)
30. [DEVSRV-STALE](#devsrv-stale) — un-parked: stale/bricked astro dev daemon recurred
31. [INTTESTDOC](#inttestdoc) — TEST-COVERAGE Integration header says 10, lists 9
32. [PROBESAFE](#probesafe) — `--help` on a generator script executed it
33. [TLFMT](#tlfmt) — r-end ref documents a TIMELINE.md shape the file no longer uses
34. [OUTLINE-V4B](#outline-v4b) — 3 residual `outline-none` sites the Conv-244 fix missed
35. [ADMIN-OVFLW](#admin-ovflw) — 3 admin routes overflow horizontally (pre-existing, not Conv-423)
36. [LH1](#lh1) — 23 typography tokens hardcode `line-height: 1` (TYPO-FDN axis)
37. [BRIDGE-RESIZE](#bridge-resize) — `resize_window` silently ignores width
38. [ICON-STATES](#icon-states) — Phase-5 tail: drive hidden/loading states over 528 call sites
39. [GATEPAR](#gatepar) — `/w-codecheck` vs `npm run verify` diverged on the icon gate
40. [VPHARNESS](#vpharness) — persist the exact-size iframe harness as a script

## ⏸️ Parked  (gated — out of rotation)

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

- **State:** 👀 watch (tooling) — surfaced Conv 424.
- **What:** `mcp__claude-in-chrome__resize_window` returns `"Successfully resized window ... to WxH"` but
  **width is never applied** (height is). Measured: window asked for 900, 1404, 1600 → `innerWidth`
  stayed **1156** every time. Same success-shaped-failure class as the `navigate`-onto-`chrome-error://`
  trap from `[BRIDGE-DIAG]`.
- **Workaround in use:** exact-size same-origin **iframe harness** — set `width` + `min-width` +
  `max-width:none !important` (the app's CSS reset caps embedded elements at 100%, which silently clamps
  the iframe), then `transform: scale()` to fit. Gives a true `innerWidth: 1280` with `mq1200` matching.
- **Next:** re-test on a newer Chrome-in-Claude build; if still broken, report upstream.
- **Refs:** `memory/reference_responsive_iframe_harness.md`, `[BRIDGE-DIAG]` (Conv 424).

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

### [COMPDOC]

- **State:** 📋 queued (doc drift)
- **What:** `docs/reference/_COMPONENTS.md` "UI Primitives (`src/components/ui/`)" section badly stale — documents **6** of **29** files; `Breadcrumbs.astro` references a deleted file. Doc is **driftCheck** (in the r-end docs-agent scope), last updated 2026-07-07.
- **Pre-existing** — not Conv-404-caused; docs agent correctly declined a drive-by partial edit (Conv-200 manufactured-edit policy).
- **When picked up:** decide first whether this section stays hand-maintained or becomes `generated` (a `src/components/ui/*` scan would never drift) — that choice IS the work.
- **Refs:** `docs/reference/_COMPONENTS.md`, `.claude/scripts/docs-registry.mjs doc-category`, `[A11Y]`, `[PROV-SWEEP-DEBT2]`.

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

### [DEVSRV-KILL]

- **State:** 📋 queued · low priority (tooling hygiene)
- **What:** scope ephemeral dev-server teardown to the spawned PID. Conv 393 a port-based kill (`lsof -ti :4321 | grep 'astro dev'`) killed a **pre-existing** astro dev on :4321 this session didn't start (ours had fallen back to :4322).
- **Fix:** capture the spawned PID, kill only that on teardown — never a broad `:port + astro dev` match.
- **Refs:** `memory/feedback_persistent_dev_server_4321`. Surfaced Conv 393.

### [DEVSRV-STALE]

- **State:** 📋 queued — **gate FIRED, un-parked Conv 417** (third occurrence; recurred in consecutive convs)
- **What:** Conv 414 — user hit an "old version" of the site on :4321 (`/matt` + `/discover` as real routes = **pre-flip**, dissolved Conv 197). Current code verified correct via curl (`/matt`→404). Root cause not pinned at the time: a stale `astro dev` **daemon** persists across sessions (`npm run dev` reported "already running pid 9015"), OR the pre-flip worktree server (`~/projects/Peerloop-preflip` @ 608346a2) bound to 4321, OR Brave's localhost cache.
- **✅ One variant now root-caused (Convs 416–417):** an `npm install` run **while `astro dev` is up** bricks the running server's in-memory miniflare module runner. Symptom is distinctive: **the port stays bound (`lsof -ti:4321` returns PIDs) but `curl` returns `000`** — a dead daemon holding the socket. Conv 417 hit exactly this from the Conv-416 dependency work; fix was `kill <pids>` then a fresh `npm run dev`. This is a *different* variant from the Conv-414 stale-content one, which remains unpinned.
- **Why it's un-parked:** flagged by the r-end docs agent as appearing in two consecutive session extracts (2026-07-25 and 2026-07-26), and the earlier extract had said to act "if it bites again". It bit again.
- **✅ A THIRD variant (Conv 418) — stale Vite dep-optimizer cache.** A long-running `astro dev`
  (up since the previous conv) 500s on routes importing a pre-optimized dep after new imports are
  added across several files: `The file does not exist at ".../node_modules/.vite/deps_ssr/
  react-chartjs-2.js?v=<hash>" ... might be incompatible with the dep optimizer`. Distinctive
  signature: **the server answers (not `000`) but a specific route 500s**, while `npm run build` is
  clean — so it is never a code defect. Fix: `rm -rf node_modules/.vite` + restart. ⚠️ The restarted
  daemon binds **`[::1]` only** → use `localhost:4321`, not `127.0.0.1:4321` (see
  `[[reference_playwright_headless_browser_fallback]]`). Related to `[VITE-DEPS-WATCH]`.
- **✅ Vite-cache variant RECURRED Conv 420 (4th occurrence overall, 2nd of this variant)** — same
  signature, different dep: `curl /` → **HTTP 500**, `The file does not exist at
  ".../node_modules/.vite/deps_ssr/astro_compiler-runtime.js?v=564df0ce"`. Note it hit the **root
  route**, so "a specific route 500s" understates it — it takes out any route importing the stale dep.
- **✅ Cleaner teardown found Conv 420 — `npx astro dev stop`.** Astro's dev daemon has first-class
  `stop` / `status` / `logs` subcommands (`astro dev --help`). `npx astro dev stop` reports the pid it
  killed, which is strictly better than the `kill <pids>` this task previously prescribed and directly
  satisfies `[DEVSRV-KILL]`'s "scope teardown to PID". Full recovery: `npx astro dev stop` →
  `rm -rf node_modules/.vite` → `npx astro dev --background` → verify `curl localhost:4321` = 200.
- **✅ Memory written Conv 420:** `memory/reference_devserver_stale_daemon.md` — all three variants,
  their distinguishing signatures, and the recovery for each.
- **Refs:** `memory/feedback_persistent_dev_server_4321`, `memory/project_wrangler_exact_pin_miniflare_dedupe`, `[DEVSRV-KILL]`. Surfaced Conv 414, recurred 415/417.

### [DL-FILENAME]

- **State:** 📋 queued · low priority (polish) · surfaced Conv 415
- **What:** `/api/resources/[id]/download` sets `Content-Disposition: attachment; filename="${resource.name || getFilenameFromKey(r2_key)}"`. Because `resource.name` is a human title with **no file extension** (e.g. "n8n Node Reference"), downloaded files save without `.pdf`/`.zip`, so the OS/browser may not open them in the right app. The `r2_key` *does* carry the real filename (`node-reference.pdf`).
- **Fix:** prefer `getFilenameFromKey(r2_key)` (has the extension) for the download filename, or append the extension (from the key/mime) to `resource.name`. Decide which reads better. Check the sibling `api/community-resources/[id]/download.ts` for the same pattern.
- **Refs:** `src/pages/api/resources/[id]/download.ts` (~line 102), `getFilenameFromKey` in `@lib/r2`, `[R2-SEED]`. Surfaced Conv 415 while verifying the seeded downloads.

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

### [GATEPAR]

- **State:** 📋 queued — surfaced by the `/r-end` docs agent, Conv 424.
- **What:** the two "run every gate" entry points have **diverged**. Conv 424 wired `check:icons` into
  `npm run verify`, but `/w-codecheck` (`.claude/skills/w-codecheck/SKILL.md`) still runs only
  TypeScript · ESLint · Tailwind · Astro + the grep gates, and **CLAUDE.md §Baseline Verification** +
  `CLAUDE-OFFLOAD.md` both define the baseline as **five** gates.
- **The decision, not the edit:** should the icon guard become a **sixth baseline gate**? If yes, update
  `/w-codecheck`, CLAUDE.md §Baseline Verification and the offload doc together. If no, record why
  `verify` and the baseline definition legitimately differ — otherwise the next conv will "fix" one of
  them by guessing.
- **Why it matters:** an inconsistency between the documented baseline and the executable chain is the
  class of drift that makes a green report untrustworthy.
- **Refs:** `package.json` (`verify`), `.claude/skills/w-codecheck/SKILL.md`, `CLAUDE.md §Baseline
  Verification`, `docs/reference/SCRIPTS.md`. Surfaced Conv 424.

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

### [MERGE-BRIAN-JULY7]

- **State:** 🔄 active · `[Opus]` (HOLD lifted Conv 407 — client conversation happened; integration planning)
- **📦 §1 BUILD progress (Conv 409–411):** **Tier A+B BUILT (409)** — Tier A cosmetic: M1 hero-compress (`CourseHeader.tsx`, 360→166px) · M5 band-compact + `actionable` links (`CourseJourneyStepper.astro` + `_course-tabs.ts`) · M4 "Peer Teachers" relabel + count-gated search island (`TeachersTabList.tsx`). Tier B shared-primitive (all **opt-in**): M6 `[TAB-SCROLL]` (`SubNav preserveScroll` + script) · M7 `[TAB-FLOAT/COMPACT]` (`SubNavItem dense` — tokenised, no gradient) · M12 `MattCourseFeed` (compact composer + tokenised skeletons). **Tier C M10 + [RECEIPT] BUILT (410):** M10 `[COMM-BAND]` (`communities.logo_url` + reseed + loader join + `CourseHeader` affiliation line; `accent_color`/palette/picker DROPPED) · `[RECEIPT]` (own durable `/receipt/[id]` view, owner-only + printable; M5 Payment step retargeted off `/success`). All 5 gates green + live-verified; prov:sweep unchanged at `[PROV-SWEEP-DEBT2]` baseline. **Tier C M2 `[SESS-TAB]` BUILT (411):** merged curriculum-first Modules tab — IA user-decided (route `/modules`, label "Modules", 2nd position); `ModulesTab.astro` rewritten with the enrolled session overlay + `MySessionsTab.astro` deleted; new `fetchCourseModulesView` loader (reuses positional SoT `resolveModuleAssignments`); `/sessions` 301→`/modules`; session-family hrefs retargeted; 5 gates green (suite **6542**, +3 durable fixture tests) + live-verified on `:4321` against the david-n8n booked-not-completed fixture; prov:sweep unchanged. Code `5ac9493d`. **Tier C M3 `[SESS-FILES]` BUILT (412):** per-module + course-wide file strips folded into the Modules tab — `session_resources.display_order` column (folded into `0001` + reseed; `in_room` NOT adopted), loader `is_public`-gated + `display_order`-ordered with a non-null `href` guard (dead-link defect avoided), `ModulesTab.astro` strips wired to `/api/resources/:id/download` (uploads) / external URL (links), +3 loader tests. 5 gates green (suite **6550**) + live-verified (anon → public-only; enrolled david → 2 uploads under Module 1 ordered 003→001). Fixed a latent Conv-411 `TS2367` in `courses.test.ts:412` inline. Also, on discovering the **Resources tab was a functional regression** (pre-flip `ResourcesTabContent.tsx` rendered files; Conv-188 Matt flip replaced it with an empty stub — DISC-DROP), the user asked for a parity diff → **2 gaps closed** so M3 is a faithful superset: per-file **descriptions** rendered + **role-aware visibility** (`canViewAllFiles` param: creator/admin/moderator see all files unenrolled). Then **retired the Resources tab** — `/resources` 301→`/modules`, removed from `VALID_TABS`/`buildCourseExploreTabs`, orphaned `ResourcesTab.astro` deleted + registry regenerated. **🔴 Fixed a `gen-registries.ts` scanner false-positive** (regex matched `@matt-source <node>` in Avatar's prose → falsely registered a `@matt-inspired` component; reworded prose, prov:sweep back to baseline). **§1 is now 9 of 9 ADAPT built = COMPLETE.** **Remaining:** §2–6 disposition walks (`/courses`, communities, shell track, sessions-files-feature, misc). Detail: `plan/merge-brian/README.md §1 Build logs + Resources-tab decision`.
- **📦 §3 `/community/*` + `/communities` — DISPOSITIONS DONE **and all 13 buildable mechanisms BUILT** (Conv 426).** Tier A: **N14** `/api/storage/[...key]` (allowlisted public asset server — closes `[THUMB-404]`; live-proved to gate before R2) + **N5** Join/Leave `astro:page-load` rebinding + Leave self-heal (**F4 confirmed live with a hard-load control before fixing**). Tier B: **N16** loader aggregates (visibility-filtered like the Courses tab; review-count-**weighted** rating) · **N11** named `hero` card variant + courses band (tokenised `--Primary-Light`, zero raw hex) · **N12** brand marks on all 3 variants · **N6** 640px left-anchored geometry (measured 640/left-1035) · **N7** search-first `sr-only h1` · **N9** `RoleTabBar variant="pill"` **retaining the Matt role palette** (his build drops it) · **N10** visible labelled compact sort · **N3** "Community Feed" label fix. Tier C: **N1** identity band (**272px→96px**, byline `by X · Public · N members · N posts`, description de-duplicated) · **N4** shared `cover-story` card with `href` attribution override and **no invented journey CTA** · **N13** logo upload endpoint + settings UI (**SVG rejected**; verified end-to-end upload→serve→403-on-non-owner). Suite 6165→**6234** (+69, 4 new test files), 5 gates green, `prov:sweep` at baseline. Remaining: **N8 only**, gated on `[REC-REHOME]`. Detail: `plan/merge-brian/README.md §3`.
- **📄 Client-facing ledger (Conv 426):** `plan/merge-brian/NOT-ADOPTED.md` — everything of Brian's that is **not** in our app (❌ declined · 🟡 declined-for-now · 🔵 took-the-idea-left-the-build · ⏸️ prerequisite-gated · ⬜ unreviewed), written for a live walkthrough **with him**. Now covers §1–§3 (42 distinct mechanisms: 6 ADOPT · 32 ADAPT · 4 DROP), including a "where his work fixed real defects on our side" section — the thumbnail 404, the Join/Leave dead-button, the mislabelled feed tab and the 224px square. **Standing obligation — README ground rule 9:** every new disposition updates it in the same conv (DROP → §1/§2 · ADAPT's left-behind part → §3 · gated → §4 · finished walk leaves §5). Reasons stated as consequences, never internal shorthand; the user's own verbatim stance stays out of it.
- **HOLD LIFTED (Conv 407):** the user confirmed the Brian conversation has happened → integration may proceed. (The Conv-396 HOLD principle survives as method: his rationale still isn't in git — request the "approved Option B / mockup" artifacts his commits cite; client-originated changes get a consequence audit.)
- **🧭 Client directives (Conv 407, from the user↔Brian conversation):** (1) **NO adoption "as is" — ever** (user: *"I know I won't be merging any of his work as is"*); his branch is a **reference exhibit**, adoption = selective reimplementation of intent with a consequence audit per change. (2) Watch areas he flagged: `/course/[slug]` page changes (implications for other detail pages), **breadcrumb/back-nav rework** (`[BACK-X]` `BackHeader.astro` — site-wide), **colour changes that may contradict role-based colour theming** (his `accent_color` community branding + `CourseCoverPanel` hex deviations are the known collision points).
- **Task:** assess client branch for impact, integrate what's worth keeping into `jfg-dev-14`. **Discard nothing without review.** Scope will grow.
- **🎯 Target = pivot snapshot `8a1e677f`** (tip of `origin/brian-July-7`, 07-20 11:29 — user + Brian **agreed this was a good pivot point**; settled Conv 407). `brian-July-20` is Brian's post-pivot **exploration branch** (user created it 07-20 to protect his work; he doesn't use git routinely) — its 7 extra commits (`[TAB-FIT]`, `[SNAV-SCROLL]`, `[CRS-MEMBERS]`, SubNav drag, Sidebar tweaks, feed changes) are **out of scope**, revisit at the next pivot. No moving-target problem: he explores there without moving our target. ⚠️ The *local* `brian-July-7` branch is 28 commits stale (tip 07-11) — use origin.
- **Conflict census (measured Conv 407): same 9 files vs both the pivot `8a1e677f` and July-20** — `CourseTabs.tsx` (modify/delete), `CoursesCatalog.tsx`, `CoursesFilters.tsx`, `CourseHeader.tsx`, `course/[slug]/[...tab].astro`, `_course-tabs.ts`, `book.astro`, `success.astro`, `tests/unit/journey-loop-tabs.test.ts` — all course/tab-related. Informational only under no-as-is (nothing gets merged), but maps where reimplementation must reconcile with our work.
- **✅ Timecard protection LANDED (Conv 407):** `[TC-MERGE-TZ]` resolved — author allowlist in `timecard-day.js` (verified against a real scratch merge; billing byte-identical). A history-preserving merge can no longer contaminate timecards; `--squash` still preferred for history hygiene.
- **`0005_community_branding.sql` still collision-free** (our `migrations/` tops out at `0004_feed_activity_index.sql`, checked Conv 407).

**🚦 The admission gate** (every file passes before entering `jfg-dev*`; new-ness is not a pass):
- **Gate 1 — Destabilizing?** NOT YET MEASURED. Apply his tree to a scratch branch, run all 5 gates; also check whether **his own branch** passes them. Known destabilizer in hand: the `CourseTabs.tsx` modify/delete.
- **Gate 2 — Structural deps** (reporting/messaging/notification/admin)? User's instinct was right, verdict benign: the `Teachers → Peer Teachers` relabel reached admin+analytics+API (`AdminDashboard`, `TeachersAdmin`, `CoursePerformanceTable`, `AdminNavbar`, `api/admin/analytics/users.ts`) but is **display-string only** (SQL `teacher_certifications` untouched; `git grep "=== 'Teachers'"` → 0). Messaging/notifications/email untouched. `[COMM-BRAND]` schema change is additive.
- **Gate 3 — Style-guide conflict?** (Conv-407 correction of the Conv-396 measurement — his later commits changed the picture.) Provenance: most new course-cluster files DO carry markers; only `CourseMembersTab.tsx` (post-pivot) + `TeachersTabList.tsx` are unmarked. Token conformance: worse than Conv 396 thought — `CourseMiniHeader.tsx` carries heavy raw hex on its dark scrim, `SubNavItem`/`SubNav` add hex + rgba shadows, `CourseCoverPanel.tsx` still deviates; per-mechanism audit in `plan/merge-brian/README.md §1`.

**Branch facts (measured Conv 396):**
- Merge-base `c50afd82` (Conv 370, 07-07); **53 ahead, 52 behind** `jfg-dev-14`. **66 files** (components 34, pages 14, images 6, lib 4, +migration/seed/layout). All 53 authored `brian@peerloop.com` — genuinely his, not CC work stranded by Conv-371.
- **🔴 NOT UI-only (pivot-snapshot census Conv 407: 96 files at `8a1e677f`):** TWO migrations now — `0005_community_branding.sql` (`ALTER communities ADD accent_color, logo_url`) **and** `0006_session_resource_files.sql` (`[SESS-FILES]`) — plus **two new API surfaces**: `api/storage/[...key].ts` (storage) + `api/me/communities/[slug]/logo.ts` (logo upload), edits to `api/sessions/index.ts` + communities/recommendations APIs, `lib/community-branding.ts`, `ssr/loaders/{courses,communities}.ts`, `mock-data.ts`, dev seed, and ~28 files of demo content (`public/docs/vibe-coding-101/*`, demo-logos, course cover SVGs). Under the no-as-is rule these are **feature adoption decisions**: if a feature is wanted we author our own schema change (fold into `0001` + reseed, per §Database Migrations) and reimplement the API; his migration files never land.
- **Conflict surface:** 17 files touched on both branches; merge dry-run (`git merge-tree`) says **12 auto-merge clean**, only **5** need real resolution — `CourseTabs.tsx` (modify/delete), `CoursesCatalog.tsx`, `CoursesFilters.tsx`, `CourseHeader.tsx`, `course/[slug]/[...tab].astro`. The other 49 are his-only, zero risk.
- **Themes:** `[COVER-STORY]`/`[COVER-STORY-MIRROR]` hero rework · `[TAB-*]` course-tab architecture · `[COMM-BRAND]` (the schema) · `[TCH-SEARCH]` · "Peer Teachers" relabel · bespoke SVG covers · hidden-but-retained surfaces (Popular Courses carousel, role tabs, Meet-Creator/Reviews/Resources tabs).

**✅ RESOLVED (Conv 407 brief) — `CourseTabs.tsx` is dormant on his branch:** his course page **doesn't import it**; his real tab architecture is `[...tab].astro` + `_course-tabs.ts` + SubNav (permanent-chrome model). Only `discover/ExploreCourseTabs.tsx` imports it on his branch; his sole edit was a label sweep. The feared modify/delete design dilemma evaporates — full mechanism inventory in `plan/merge-brian/README.md §1`.

**Integration mechanism (reasoned Conv 396, no decision):**
- Keep **git** as the transfer vehicle, drive **per-theme**. Hand-moving files argued against: `git checkout <branch> -- <file>` is a wholesale overwrite, silently discarding our side on the 17 shared files.
- **Batch unit = theme, sized so each commit passes all 5 gates** (themes cut across schema+lib+loaders+components).
- Worktree of his branch wanted to **run/compare behavior**, not as transfer path (`git show <branch>:<path>` reads any file).
- **`--squash` (no history) required** + load-bearing for the timecard fix: the `^jfg-dev` allowlist breaks the instant his commits land on a `jfg-dev*` branch with history. Caveat: squash records no merge parent → he must abandon `brian-July-7` after handoff and start from the delivered branch.

**⚠️ Contamination / traceability:**
- **Conv-number collision:** his CC labels commits "Conv 371/372…" — *different work* from ours; breaks same-number-in-both-repos traceability + confuses timecard buckets.
- **Timecard (RESOLVED Conv 407):** author-allowlist filter now live in `timecard-day.js` (`authorAllowPattern` in config) — the only filter that survives a merge, verified end-to-end. The Conv-396 contamination analysis is historical context.
- **Docs repo CLEAN of his commits** — he worked code-only, no dual-repo. So his rationale exists **nowhere in git**, only his chat sessions; commits cite *"approved Option B / mockup"* → **request those artifacts from him**.
- **Working model of the client:** not a coder, drives his own CC; treat as peer recipient of the same expert suggestions, but his directives ignore downstream codebase consequences → client-originated changes need a consequence audit user-originated ones don't.
- **Refs:** **`plan/merge-brian/README.md` (the review program + dispositions — PLAN.md block MERGE-BRIAN)**, pivot `8a1e677f` = `origin/brian-July-7` tip (review target), `origin/brian-July-20` (out-of-scope exploration), `[TC-MERGE-TZ]`, CLAUDE.md §Schema Discrepancy Discipline, `[[project_jfg_dev_branches_are_snapshots]]`, `[[project_preflip_worktree_reference]]`, Conv 392 `cfcfc8af`. Surfaced Conv 396.

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
  3 sites remain — `src/components/ui/ClickableRow.tsx:73` (`focus-visible:outline-none`) and
  `src/components/course/TeachersTabList.tsx:133,142` (`focus:outline-none`).
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

### [PROV-SWEEP-DEBT2]

- **State:** 📋 queued (gate silently red)
- **What:** `npm run prov:sweep` reports **11 issues** (10 UNTRACKED errors + 1 drift) — was 0 at Conv 244. Drift since: components stamp `data-prov-name="X"` on their outer element but were never added to `scripts/matt-inspired-registry.ts`. Offenders: `NavDrawer`, `NavMenuButton`, `communities/CommunitiesFilters`, `courses/CoursesFilters`, `feed/SignupCtaCard`, `settings/LayoutToggle`, `ui/MobileUpNav.astro`, `course/CourseJourneyStepper.astro`, `course/CourseSessionsActions.astro`, **`course/CourseReviewComposer.tsx`** (10th, added Conv 416, spotted Conv 418 — the gate drifts by one every time a stamped component ships unregistered, which is the recurring cost of leaving it red). **Conv 425 did NOT add to this**: its 3 new stamped components (`CourseCoverPanel`, `CoursePriceSticker`, `CommunityAffiliation`) were registered on landing after a self-audit caught the gate at 17, restoring the 11 baseline. Registering-on-landing is the cheap habit that stops this growing.
- **Verified NOT caused by `[A11Y]` Conv 404** (none in that diff; the 2 new primitives are unstamped).
- **Related tooling weakness (Conv 412):** `scripts/gen-registries.ts`'s marker regex `/@matt-source\s+\d+:\d+/` matches the marker-with-node **anywhere in a file, incl. prose** — so a `@matt-inspired` component that *references* another's source node in its docstring gets falsely registered as matt-sourced (hit `messages/matt/Avatar.tsx`, whose prose named the UserIcon node it wraps). Mitigated Conv 412 by rewording Avatar's prose; the durable fix is to require the marker to be a standalone provenance line (align with `prov-sweep.ts`'s accept-rule). Low priority.
- **Why it matters:** a real gate failing unnoticed → the registry⟺marker⟺stamp conformity from `[PRIM-STAMP]` (Conv 217) isn't holding. Each offender needs a registry entry (with `figmaMatchNames`) **or** its stamp removed if not a vetted primitive — decide per component, don't bulk-register.
- **Refs:** `../Peerloop/scripts/matt-inspired-registry.ts`, `npm run prov:sweep`, `docs/as-designed/matt-provenance.md §12c`, `plan/prim-registry/README.md`, `[PRIM-STAMP]`, `[PROV-SWEEP-DEBT]`. Surfaced Conv 404.

### [REC-REHOME]

- **State:** 📋 queued · `[Opus]` · gate-prerequisite for MERGE-BRIAN §2 M4 **and** §3 N8
- **What:** give personalized **course _and_ community recommendations** a home outside `/courses` and `/communities`, so both carousels can leave those pages. **Scope widened Conv 426** (user decision in the §3 walk): the two are solved together because they would compete for the same destination.
- **Why:** measured, both walks. `/courses` is the **only** consumer of `RecommendedCourses`, and `/communities` is the **only** consumer of `RecommendedCommunities` — each carousel is likewise the only caller of its API (`/api/recommendations/courses`, `/api/recommendations/communities`). Hiding either (his `[CRS-POPULAR-OFF]` / `[COMM-REC-OFF]`) retires that surface site-wide and strands its endpoint.
- **🔴 Target undecided:** Home is the obvious candidate, but `[FEEDS]` (Conv 267, `memory/project_feeds_hub.md`) explicitly bars re-adding panel surfaces (FeedsHub / ActionCards / TriageStrip) to `/`. Decide the destination — for both surfaces at once — before building.
- **Blocks:** MERGE-BRIAN §2 **M4 `[CRS-POPULAR-OFF]`** and §3 **N8 `[COMM-REC-OFF]`** — both dispositioned *ADAPT — hide only after rehoming*.
- **Refs:** `plan/merge-brian/README.md § 2 Dispositions (Batch B)` + `§ 3 Dispositions (Batch B)`, `src/components/recommendations/RecommendedCourses.tsx`, `RecommendedCommunities.tsx`, `src/pages/api/recommendations/{courses,communities}.ts`.

### [RG-PUBLIC]

- **State:** ⏸️ parked · **gate: marketing redesign**
- **Icon dependency REMOVED (Conv 424):** `[ICON-TOK]`/`[ICON-4PX]` no longer wait on this gate — `BecomeATeacherPage` was fixed on the icon axis directly. This task is now only the *route-group sweep*.
- **What:** public/marketing route-group sweep (the only un-swept RG-* group; RTMIG-4 closed Conv 340 with it deferred). The 14 marketing pages live only in `/old/*`; root paths 404 by design. Revisit if/when the redesign is scheduled. Also gates `[ORPHAN-BACKLOG]` Cat-B.
- **Refs:** `plan/route-migration/README.md § RG-PUBLIC disposition`.

### [RHOOKS]

- **State:** 🔄 active
- **What:** full `react-hooks` `recommended-latest` set adopted at **warn** (Conv 400) — `eslint.config.js` `.tsx` block spreads `asWarn(reactHooks.configs['recommended-latest'].rules)` (17 rules), then re-overrides `rules-of-hooks` back to `error` (0 violations). No new dep, no `overrides` pin (react-hooks@7.1.1 already ships `eslint ^10`). Gate GREEN. Triage incrementally.
- **Backlog — 95 warnings** (0 `.astro`; scoped `**/*.{ts,tsx}`): `set-state-in-effect` 93 (accepted baseline) · `purity` 1 · `preserve-manual-memoization` 1. `static-components` + `immutability` fully cleared.
  - **Batch 1 done (Conv 400):** 6 `static-components` hoisted + 4 `immutability` reorders + `FilterContent` inline→element-value. Net −6 (the 4 reorders unmasked latent `set-state-in-effect` the error had hidden).
  - **`set-state-in-effect` DECIDED — accepted baseline, not a to-do list.** ~49 idiomatic fetch-on-mount + ~25 deliberate SSR-hydration-safety + ~15 low-ROI; rewriting risks SSR/hydration bugs. Kept at warn; triage only new/egregious cases. One genuine fix taken: `useCurrentUser`+`useAuthStatus` → `useSyncExternalStore` (reusable pattern for client-store hydration hooks).
  - **Leave at warn:** `purity` = `ModeratorDetailContent:83` (`Date.now()` countdown); `preserve-manual-memoization` = `CoursesCatalog:211` (advisory).
- **Next (opportunistic):** clear residual warnings in files touched for other reasons (`[LE-TRIAGE]`/`[A11Y]` model). No standalone sweep.
- **Refs:** `../Peerloop/eslint.config.js`, `docs/decisions/06-testing-ci.md §§ RHOOKS/RDOC`, `[A11Y]`, `[LE-TRIAGE]`.

### [ROLE-CRS-LIST]

- **State:** 📋 queued · `[Opus]` · gate-prerequisite for MERGE-BRIAN §2 M3
- **What:** give the **teaching** and **moderating** role lenses their own course lists, so `/courses` role tabs can be retired.
- **Why:** Conv 425 §2 disposition walk found `/courses#teaching` is today the **only** list of the courses a teacher teaches — `/teaching/[...tab].astro`'s own route comment states "There is no courses LIST page, so bare `/teaching/courses` is an unknown tab → redirects to `/teaching`", and `TeacherDashboard` groups *students* by course without ever listing courses. Same shape for `#moderating`. `/learning` already covers the student lens.
- **Blocks:** MERGE-BRIAN §2 **M3 `[CRS-ROLE-TABS-OFF]`** — dispositioned *ADAPT — hide only after rehoming*.
- **Refs:** `plan/merge-brian/README.md § 2 Dispositions (Batch A)`, `src/pages/teaching/[...tab].astro`, `src/components/dashboard/TeacherDashboard.tsx`, `src/components/courses/CoursesRoleTabs.tsx`.

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

- **[THUMB-404]** ✅ — course-thumbnail uploads no longer 404. Built `GET /api/storage/[...key]` (MERGE-BRIAN §3 N14): prefix allowlist (`courses/*/thumbnail/`, `communities/*/logo/`), traversal rejection, ETag/304, immutable caching. **Live-proved the allowlist gates BEFORE R2** — a real object seeded at `homework/sub-1/secret.pdf` still 404s, so private-key existence is unobservable. +18 tests.
- **[MERGE-BRIAN-JULY7] §3 walk + build** ✅ — 16 mechanisms dispositioned (3 ADOPT · 11 ADAPT · 2 DROP) and **all 13 buildable ones shipped** across 3 tiers. Findings F3 (fixed by N14), F4 (Join/Leave dead on client-side nav — **confirmed live with a control**, then fixed) and F5 (224px / 320×224 4× artifacts — superseded) all closed. Only N8 remains, gated on `[REC-REHOME]`. 5 gates green, suite 6165→**6234**, `prov:sweep` at baseline.
