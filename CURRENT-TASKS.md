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

1. [BRIDGE-DIAG](#bridge-diag) — why is the Chrome bridge unreachable when it used to work? (next conv)
2. [SPACING-VIS](#spacing-vis) — Chrome-bridge visual pass over every page the Conv-423 sweep touched (next conv)
3. [ICON-TOK](#icon-tok) — Phase 6 only: warn→error, gated on `[RG-PUBLIC]` clearing the last 25
4. [ICON-4PX](#icon-4px) — residue: `/become-a-teacher`, gated on RG-PUBLIC
5. [MERGE-BRIAN-JULY7](#merge-brian-july7) — client branch assessment/integration
6. [A11Y](#a11y) — accessibility lint triage
7. [RHOOKS](#rhooks) — react-hooks lint triage
8. [KNIP](#knip) — dead-export oracle → gate
9. [PROV-SWEEP-DEBT2](#prov-sweep-debt2) — `prov:sweep` gate silently red (10 unregistered)
10. [TURNLOG](#turnlog) — `conv-turns.md` unmaintained guard
11. [EDITSAFE](#editsafe) — anchored-edit discipline
12. [RSYNC-GATE](#rsync-gate) — memory-sync rsync auto-mode block
13. [COMPDOC](#compdoc) — `_COMPONENTS.md` ui/ section stale
14. [EMAILDOC](#emaildoc) — `resend.md` dead-template refs
15. [HOME-FIXES](#home-fixes) — Home route fix bucket
16. [COURSES-FIXES](#courses-fixes) — Courses route fix bucket
17. [BRAND-DOCS](#brand-docs) — "PeerLoop"→"Peerloop" docs casing
18. [SCRATCH-DEBRIS](#scratch-debris) — delete retired `conv-tasks.md`
19. [DEVSRV-KILL](#devsrv-kill) — scope dev-server teardown to PID
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
32. [DEVSRV-STALE](#devsrv-stale) — un-parked: stale/bricked astro dev daemon recurred
33. [INTTESTDOC](#inttestdoc) — TEST-COVERAGE Integration header says 10, lists 9
34. [PROBESAFE](#probesafe) — `--help` on a generator script executed it
35. [TLFMT](#tlfmt) — r-end ref documents a TIMELINE.md shape the file no longer uses
36. [OUTLINE-V4B](#outline-v4b) — 3 residual `outline-none` sites the Conv-244 fix missed

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

### [BRIDGE-DIAG]

- **State:** 📋 queued · `[Opus]` — **next conv, #1.** User-raised Conv 423.
- **What:** find out why the Chrome bridge is treated as unreachable against the local dev server, when
  it has worked many times before — PLATO browser testing is the standing counter-example. The current
  memory `[BRIDGE-UNREACHABLE]` (Conv 413) records the *workaround* (fall back to Playwright headless +
  `POST /api/auth/dev-login`, run from inside `~/projects/Peerloop`, use `localhost` because `astro dev`
  binds `[::1]` only) but never diagnosed the cause. **The user's point is that the premise looks wrong:**
  a fallback that has quietly become the default is a smell, not a fix.
- **Re-test the premise first** (`[PREMISE]`): do not start from the memo. Establish whether the bridge
  *actually* fails today, on this machine, against an ephemeral `npm run dev` — the Conv 413 note may be
  describing a transient (a stale daemon per `[DEVSRV-STALE]`, an extension site-permission that was
  never granted for `localhost:4321`, or an IPv6-only bind the bridge cannot follow while curl can).
  Distinguish those before proposing anything.
- **Why it matters:** Playwright headless measures the DOM but nobody *looks* at it. Several of this
  block's defects were things a human eye caught and a measurement did not (`ModeratorInvite`'s 8px glyph,
  the legacy shell header). Losing the bridge quietly downgraded the whole verification loop.
- **Refs:** `memory/reference_playwright_headless_browser_fallback.md`,
  `memory/reference_chrome_bridge_island_stale_cache.md`, `memory/reference_devserver_stale_daemon.md`,
  `memory/plato-context.md`. Surfaced Conv 423.

### [SPACING-VIS]

- **State:** 📋 queued — **next conv, #2** (depends on `[BRIDGE-DIAG]`). User-raised Conv 423.
- **What:** use the **Chrome bridge** to look at every page affected by the Conv-423 spacing change and
  confirm each renders properly at a **16px base**. Not a re-measurement — a human-visible check.
- **Scope:** 99 files changed, but the visual surface is what matters. Start from the 99-file diff
  (`git -C ~/projects/Peerloop show dc1f031e --stat`) and reduce it to distinct **routes**; the 12 routes
  `spacing:scan` already covers are the floor, not the target. `/old/*` pages carry 14 of the changed
  files and are retire-by-default, so decide explicitly whether they are in scope rather than skipping
  them silently.
- **What was already proven, so don't re-do it:** the transform is arithmetically value-preserving,
  the compiled-CSS diff is one line, and `npm run spacing:scan` measured 4,206 strict values across 12
  routes with 0 mismatches. **What is NOT proven is appearance** — measurement cannot see a layout that
  is technically correct and looks wrong, which is exactly the gap the user is closing here.
- **Refs:** code `dc1f031e`, `scripts/spacing-scan.mjs`, plan/icon-sizing/README.md § Phase 6.
  Surfaced Conv 423.

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

### [HOME-FIXES]

- **State:** 📋 queued (deferred per-route bucket)
- **What:** deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — batch later.

### [ICON-4PX]

- **State:** 📋 queued — measured symptoms fixed Conv 419; standard now decided, see `[ICON-TOK]`
- **Mechanism (measured, settled).** `tokens-tailwind-bridge.css` overrides exactly ten Tailwind
  spacing values — `4, 8, 12, 16, 20, 24, 32, 40, 48, 64` — so for those, `N` means **N px** instead
  of Tailwind's `N × 4px`. Every other value keeps the multiplier, which is why `h-5 w-5` is a
  correct 20px and `h-4 w-4` is a broken 4px. Measured: `h-1`=4 `h-2`=8 `h-3`=12 `h-4`=**4**
  `h-5`=20 `h-6`=24 `h-8`=**8** `h-12`=**12** `h-16`=**16**. For *spacing* this is the intended
  Conv-174 behaviour; the bug is only where an author meant the multiplier.
- **✅ Done Conv 419.** `h-4 w-4` / `w-4 h-4` → `size-icon-16`, **43 sites in 21 files**, including
  the 5 `ui/icons.tsx` *defaults* (Chevron{Right,Down,Left,Up}, Sort — so every un-overridden use was
  4px) and two **checkboxes** (`ModeratorInvite`, `TopicPicker`) rendering at 4px. Lone `h-4`
  (skeleton bars, scroll sentinels) is deliberate literal-px and untouched — `AdminDataTable.tsx:7`
  documents that. Re-verified live on 6 routes: zero sub-12px icons.
- **⚠️ The original task understated this** — written from `grep h-4 w-4`, so it missed `h-8 w-8`
  entirely. Do not re-derive scope from grep; **measure**.
- **Residue A — `/become-a-teacher` (measured broken).** Uniformly stock Tailwind: `w-8 h-8` icons ×8
  at 8px, `w-12 h-12` circles holding `text-xl` at 12px, `w-24` label column at 24px. **Gate:
  `[RG-PUBLIC]` marketing redesign** — fixing now may be discarded by it. Carries a *different* bug
  too: `w-5 h-5` rendering **8×20** (horizontal flex squeeze, wants `shrink-0`) — don't conflate.
- **Residue B — folded into `[ICON-TOK]`** below, which is the standing migration.

### [ICON-TOK]

- **✅ Conv 423 — Phase 6: the ambiguity is fixed at the ROOT, not swept.** Scoping the "rename the
  `--spacing-*` override" idea priced it at **4,911 sites / 295 files**, and the same measurement found
  the one-line alternative: numeric spacing splits **4,911 overridden vs 361 multiplier**, so the
  exception was the nineteen *un*-overridden numbers, not the ten overridden ones — and every
  `--space-N` and `--icon-N` token is exactly `N × 0.0625rem`, i.e. Tailwind's untouched base
  multiplier was off by 4×. Setting **`--spacing: 0.0625rem`** makes N mean N px for every number,
  including ones never yet typed. **Blast radius proven by compiling the real stylesheet twice: one
  line differs in 185 KB**, every emitted utility rule byte-identical. The 449 sites that did rely on
  the ×4 reading (354 integer + **95 fractional**, a gap the first regex's trailing-`.` rejection hid)
  were rewritten `N → N×4`, provably value-preserving; an independent verifier reading the **git diff**
  — not the sweep's own report — confirms 449 of 449 conform. **Live: 4,206 strict measurements over 12
  routes, 0 mismatches** via new `npm run spacing:scan`. 5 gates green (suite 6131; 2 `AdminBadge` tests
  pinned literal class names and were updated). **Three of my own instruments produced wrong output
  before being corrected** — SQL `%Y-%m-01` read as a margin utility, index-paired diff hunks, and 184
  "mismatches" that were all variant-shadowed elements; each caught by a number looking implausible.
  **Open decision surfaced, not pre-empted:** the icon rules now police an ambiguity that no longer
  exists (counters unchanged at 25 / 532 because they fire on shape).
- **State:** 🔄 active — `[Opus]` **stripped Conv 423**: every judgment-heavy piece has landed (the
  standard, the em rescind, the root fix, the two open decisions). What remains is Phase 6's
  warn→error promotion — a config flip once `[RG-PUBLIC]` clears 25 sites in one file. Rote.
  **Foundation + standard Conv 419; tranches 1–3a Conv 420;
  arbitrary-px class retired Conv 421** (baseline 1,694 → 1,337 → **1,150**). Migration outstanding
  and **multi-conv**.
- **✅ Conv 421 — the `icon-arbitrary-px` class eliminated, 187 → 0.** Re-targeted at the Matt
  surface after `[ICON-AUDIT]` showed the block had been migrating where nothing renders. **First
  tranche whose premise survived re-testing:** R3 matches only icon-component tags, so all 187 were
  real icons (166 `<MattIcon>` + 21 `ui/icons.tsx`), zero avatars/logos/skeleton bars — unlike
  tranche 2's 891, which was ~44% non-icon. 69 files, 187 line-for-line edits.
  - **Provably neutral.** All 11 `--icon-N` tokens verified pixel-identical to their names at the
    default root (`--icon-20` = 1.25rem = 20px …), so every conversion is zero-change + gains
    root-scaling. Distribution: 62×20px, 61×24px, 26×16px, 10×48px, 10×14px, 7×32px, 4×18px,
    2×40px, 2×28px, 2×12px, 1×19px.
  - **Deliberately rem, not em — the em ladder is still NOT settled and was not applied.** rem is
    neutral; em is not (a Sidebar glyph reclassified inline would shrink 20px → ~16px against its
    14px label). All went to standalone/rem per the Conv-420 nav-row ruling. **This defers, not
    answers, the inline question** — it remains the block's open decision.
  - **Verified live at two root sizes across 10 routes: 232 icons render, 232/232 at their exact
    named px at 16px root, 232/232 grow at 24px root.** Before the tranche only 20 tokened icons
    rendered on those routes. This is the first real completeness proof the block has produced.
  - **Method note:** scoped to flagged tags, never a file-wide sed (tranche-2 lesson: `w-64 h-64`
    is both an icon size and its wrapper circle). The script's non-square guard correctly refused
    one conditional ternary (`MessageUserButton`), edited by hand. Three multi-line JSX tags the
    rewriter reflowed were restored to preserve formatting.
  - 5 gates green: tsc clean · astro 0 errors · eslint 0 errors (166 pre-existing warnings) ·
    **6131 tests pass** · build complete. Code `31251d82`.
- **🔄 Conv 422 — Phase 5 (completeness proof), in progress.**
  - **Route coverage closed: 50 of 50 in-scope pages** now have at least one scanned URL (80 distinct
    URLs / 97 route-states, up from 26). Computed by matching the scanner's route list against the
    page files with Astro's own specificity ordering, not asserted. The plan's "67 routes" counted
    `/old/*` (14, retire-by-default) and `/dev/*` (3, provenance opt-out); the governed surface is
    **50**, six of which are `[...tab]` catch-alls rendering 2–7 tabs each.
  - **States driven deliberately.** Empty lists via `usr-admin` (the one seed user that is
    data-empty *and* capability-bearing — `fraser@meristics.com` has 0 rows but 0 capability flags,
    so /teaching and /creating bounce it rather than render an empty list). `ModeratorInvite` now has
    **4 of its 5 view states measured** (valid · error · success · declined) plus the decline
    **confirmation modal**, via a new opt-in `--drive-invite accept|decline` mode; only the transient
    `loading` is unmeasured. Previously only `error` had ever been live-verified.
  - **✅ FIXED — 4 non-icon elements had been wrongly tokened by Conv 420's tranche 2** (`c429f150`),
    found by this sweep: `analytics/CoursePerformanceTable.tsx:144,147` (a course thumbnail `<img>` +
    its placeholder `<div>`, `size-icon-40 w-[56px]`), `:71` and `admin/AdminDashboard.tsx:333`
    (skeleton bars). Per the settled two-way standard these are "not an icon" → arbitrary px. **Not
    cosmetic:** the token sets height while the adjacent `w-[Npx]` wins for width, so height scaled
    with the root font while width stayed pinned — the thumbnail distorts 56×40 → 56×60 at a 24px
    root — and each was a permanent false positive in `tokened-did-not-scale`, i.e. a mis-classified
    element poisoning the block's own completeness instrument. Fixed to `h-[40px]`/`h-[24px]`/
    `h-[32px]`, pixel-identical at the default root (40/24/32 are all in the override set, so `h-N`
    already meant N px). **Both counters stayed put (25 governed / 532 informational)** — the check
    that the edits landed in neither bucket rather than being silently reclassified. A source-wide
    scan for the same shape (a token co-occurring with a competing `w-`/`h-`) now returns **0**, and
    the re-run sweep shows `tokened-did-not-scale` back to **0**.
  - **This is the phase justifying its own cost.** Tranche 2's own record admitted R1 matched ~44%
    non-icon elements; these four are the ones that reached an actual edit. No static rule caught
    them — only rendering the page at two root sizes did.
  - **`icons:scan` baseline regenerated** over the widened coverage (it described 26 routes, not 95).
  - **✅ Per-element attribution BUILT (Conv 422) — the residue above is now measured, not guessed.**
    The plan was a dev-only babel stamp; the spike **killed that approach and found a better one**.
    A call-site stamp cannot work: `MattIcon` and every `ui/icons.tsx` component have **closed prop
    interfaces** (`{name, className}` / `{className}`, no `...rest`), so an injected `data-icon-src`
    is silently dropped — making it work would have meant editing shared production primitives to
    serve a dev-only measurement. Instead: **React 19's `_debugStack`** already carries the JSX
    creation stack. `_debugSource` *was* removed in React 19 (verified empirically, not assumed), but
    walking up while `className` is the same string lands on the element written at the call site.
    **95% of rendered tokened icons attribute** (252 of 265 over 6 routes). **No babel plugin, no
    Vite transform, no production change, no prod-build risk.**
  - **Two limits encoded rather than papered over.** (1) The stack's line numbers are
    **transformed-module lines, not source lines** (`IconLabelChip.tsx:43` is an interface
    declaration in the source) — valid as *stable site identities*, so the ledger aggregates per FILE
    and never prints a source line it can't stand behind. (2) `.astro` icons render server-side with
    **no React fiber**, so they are outside this method entirely — reported as a named blind spot,
    not counted as residue.
  - **⚠️ The ledger's own first output was wrong, caught because the number was implausible.** It
    labelled **625 of 690** sites "component defaults" — including 27 in `Sidebar.tsx`, a consumer.
    The regex used `className\s*=\s*`, and `\s*` matches zero spaces, so it swallowed JSX attributes
    (`className="..."`) along with real destructuring defaults (`className = '...'`). The comment
    stated the rule correctly; the regex didn't implement it. `\s+` fixes it — **true count 107
    defaults, 522 call sites, 61 `.astro` sites** (= 690; an earlier "457" here was a raw
    `className="` grep that missed template literals and did not partition the total — corrected at
    r-end by the plan agent re-running the ledger's own classifier). Third instrument-before-output
    catch in two
    convs.
  - **The residue is state-coverage, not dead code.** `codecheck-orphan-components.mjs` returns
    **PASS — every `src/components/**` component is route-reachable**, so every unproven site sits in
    code a user can reach; it just never rendered under the states driven.
  - Scanner robustness: one bad seed email (`marcus.thompson@`, actually `marcus.t@`) aborted the
    whole run at route 46 of 95; a failed login now skips that user's group and continues. Logins are
    grouped per user (6, not 95).
- **✅ Conv 420 — Tranche 1 (icon-component defaults) + a rule correction.**
  - **The tasked target didn't exist.** The "46 icon usages with **no size class at all**" that
    Conv 419 called the sharpest finding were **all false positives**: 14 were `entity/UserIcon`,
    an avatar with a typed `size?: 24 | 40` prop (the rule matched the *name* ending in `Icon`), and
    32 were sized one level in by a `className = 'h-5 w-5'` default or a wrapper — already counted by
    R1, so flagging call sites double-counted one defect as many. **Fifth consecutive task premise
    written from the implementation instead of the consumers** (after `[CANMSG]`, `[MSG-ADOPT-A]`,
    `[MSG-ADOPT-B]`, `[COURSETAB-HASH]`). Rule narrowed via a structural `selfSizingIcons()` pre-pass
    (not a hand allowlist, which would rot); verified by injecting a genuinely unsized icon → caught,
    exit 1.
  - **200 genuine migrations from 94 edits.** Icon-component *defaults* were the high-leverage target
    the call-site framing hid: `MattIcon.tsx:43` alone fixes every un-classed `MattIcon` site-wide
    (AdminNavbar's 17 included). 92 `ui/icons.tsx` + `MattIcon` → `size-icon-20`, `MenuIcon` →
    `size-icon-24`. **Provably neutral** — `h-5 w-5` = `calc(0.25rem × 5)` = 1.25rem = `--icon-20`;
    `h-6 w-6` = 1.5rem = `--icon-24`. Both land on Matt's own Small-20 / Medium-24 steps.
  - **Honest limit:** most of the 200 removed *ambiguity*, not rendered size — `h-5 w-5` was already
    rem, so no `% scale with root` meter moved. Only 7 sites (the 6 local wrappers + PromoteButton's
    three svgs → `size-icon-inline-md`) actually went fixed-px → rem/em.
  - **Decision (user):** a nav row with a label is **standalone**, not inline. AdminNavbar's labels
    are 12px, where the em ladder tops out at 17.4px vs today's 20px. First real answer to the em-ratio
    open question: **the three inline steps are anchored on 14px and don't serve a 12px label.**
  - Reachability check ran clean (`PASS`) — no repeat of Conv 419's 5 dead-code edits. 5 gates green
    (suite **6131**), `icons:scan` **no regression** across 26 routes.
- **✅ Conv 420 — Tranche 2 (large standalone icons).** 44 sites / 85 classes at 32/40/48/64px →
  `size-icon-{32,40,48,64}`; baseline 1,448 → **1,363**. Premise re-tested first and again over-scoped:
  R1 matches *any* `w-/h-/size-N`, so the "891 sites that shipped 4px icons" is **~501 icon classes +
  ~390 non-icon** (skeleton bars, badge circles, dots, avatar `<img>`s, one text-column width) — the
  390 are out of this axis entirely. Avoided a blind sed: `w-64 h-64`/`h-48 w-48` occur *both* as icon
  sizes and as the wrapper circles those icons sit in, so edits were scoped to the icon tag per line.
  **Verification honestly partial** — `icons:scan` no regression, but a direct probe showed only
  **4 of 44** actually render under seeded data (on `/admin`, growing correctly at a 24px root); the
  other 40 are empty-state marks behind "list is empty" conditions no route walk reaches. Same probe
  *did* confirm tranche 1 (33 elements on `size-icon-20`/`-16`, all 33 scaling). One test coupled to
  the literal classname `svg.w-48.h-48` failed and was updated; swept `tests/` for the rest — no
  further coupling. 5 gates green (suite 6131).
- **✅ Conv 420 — Tranche 3a (sub-12px = two real defects, not ambiguity).** Baseline 1,363 → **1,337**.
  Working up from the smallest rendered sizes found the only two places the override had shipped
  something visibly wrong. **`ModeratorInvite.tsx`** is a whole component in Tailwind-v3 semantics —
  measured live at `/invite/mod/<bad-token>`, its error glyph rendered **8×8px in a 16×16px circle** on
  a card with **8px** padding (author wrote `w-8 h-8`/`w-16 h-16`/`p-8` meaning 32/64/32). That is what
  a user sees when a moderator invite link is bad. The icon axis alone couldn't fix it — a 32px glyph
  in a container stuck at 16px would overflow — so **per user decision the whole component was fixed**,
  crossing into the spacing scale as a bounded one-component exception: 90 classes to the literal-px
  convention, icons to `size-icon-32`/`-20`, circles to `size-[64px]`. Re-measured: **64×64 circle,
  32×32 icon, 32px padding**, palette/button intact, 36 tests still pass. **`PublicProfile.tsx:290`** —
  error mark at 12px where `h-12` meant 48 → `size-icon-48`. **The legacy class is bounded:** only 7
  files use the v3 palette, only 2 had overridden icon classes (the other is the parked
  `BecomeATeacherPage`). ⚠️ Only the *error* state was live-verified; success/declined/valid share the
  markup but need a valid token. 5 gates green (suite 6131), `icons:scan` no regression.
- **Next (rewritten Conv 422 — the old "Tranche 3b" line was stale).** Tranche 3b *was* the Conv-421
  mechanical sweep (560 → 25) and the em-ladder question it feared was dissolved by the rescind, so
  **no migration work remains**. Verified live at Conv-422 start: `check:icons` = **25 governed ·
  baseline 25 · delta +0**, 532 informational. What is left is proof and enforcement:
  - **Phase 5 — completeness proof.** **49 of 67 routes unswept.** Plus two state classes a seeded
    route walk never reaches and must be driven deliberately: **empty states** (40 of tranche 2's 44
    sites still unproven — the probe saw 4, on `/admin`) and **`ModeratorInvite`'s success/declined/
    valid states** (only the error state was ever live-verified; needs a valid token).
  - **Phase 6 — tighten the guard.** Promote the governed rules warn → error (now a single-file
    dependency: all 25 sit in `BecomeATeacherPage`, behind `[RG-PUBLIC]`); **decide the fate of the
    532 `dimension-bare-numeric` sites** (the informational tier is a holding pattern, not a
    destination — the block's one live open question); ship the editor-visible bare-number lint rule.
- **Standard (decided; simplified Conv 421).** Spacing (`p`/`m`/`gap`) keeps the numeric scale — that
  is what the Conv-174 override was for, settled at 4711 uses vs 55 arbitrary. Dimensions
  (`w`/`h`/`size`) use the icon axis, now split **two ways** by role:
  - **An icon** — any glyph, whether or not text sits beside it → `size-icon-N`, **rem**.
  - **Not an icon** (dots, avatars, hit targets, brand marks, and `ui/icons.tsx` component
    *defaults*, which cannot know their call site) → arbitrary px.

  Never `size-16`, `h-4 w-4`, or a bare `size-[Npx]` on something that is actually an icon.
  **The em inline family was RESCINDED Conv 421** — `--icon-inline-{sm,md,lg}` deleted, all 6 call
  sites → `size-icon-16`. It never fired (3 dodges), `-sm`/`-lg` were never used, `em` resolves
  against the container's font-size rather than the sibling label's, and its 14px anchor capped at
  17.4px against this app's 12px labels. This makes the ~500 remaining 16/20/24px sites **mechanical**
  rather than ~500 judgment calls. Full rationale:
  `matt-design-system/05-color-and-tokens.md` §Icon Size → *The two-way rule*.
- **✅ Built Conv 419.** `--icon-{12,14,16,18,20,24,28,32,40,48,64}` in `tokens-primitives.css`
  (rem-valued, pixel-named, matching `--space-N` Decision 1 C) + `--spacing-icon-N` re-exports in
  `tokens-tailwind-bridge.css`. Tailwind v4 resolves `size-*`/`w-*`/`h-*` from the spacing
  namespace, so the tokens must live there; the `icon-` segment is what makes them unambiguous.
  Plus (**since RESCINDED — Conv 421, see Standard above**) the em inline family
  `--icon-inline-{sm,md,lg}` (1em / 1.15em / 1.45em, anchored on
  `--body-default-size` = 14px so migrating a 16px inline icon is visually neutral).
  **Verified live:** `size-icon-16` → 16×16, → 20×20 at a 20px root (rem);
  `size-icon-inline-md` → 16.1px beside 14px text, 24.1px at a 24px root, and **27.6px when only
  the button's own label is raised to 24px** — proving it tracks the label, not the root.
  43 call sites migrated off `h-4 w-4`; **3 of them** (the profile-header Message buttons, verified
  icon+label) further moved to the em family as the worked exemplars.

- **⚠️ The remaining 40 are on `size-icon-16` (rem) pending classification, not because they are
  standalone.** A crude text-adjacency heuristic misclassified even the Message buttons, so each
  site needs reading, not grepping. The 5 `ui/icons.tsx` defaults are the one settled sub-case:
  they stay rem permanently.
- **Why a separate axis, not the spacing scale.** Two reasons, both checked: the spacing scale has
  no 14, 18 or 28 (≈13 shipped sites inexpressible), and retuning rhythm should not resize every
  glyph. Ladder values are the current de-facto sizes — 16/20/24 alone cover 221 of 304 sites — so
  this *names* shipped design rather than re-snapping it.
- **Migration outstanding (~1,424 bare-numeric + ~600 arbitrary sites).** Census Conv 419:
  `size-[Npx]` 304 · `w-[Npx]`/`h-[Npx]` 301 · `w-N`/`h-N` overridden-ten **878** · `w-N`/`h-N`
  Tailwind-only-N **546** · `size-N` 94. The last two rows are the hazard: identical syntax, two
  meanings. **Mechanical and verifiable, not judgment-heavy** — every bare-numeric class has a
  deterministic true value (overridden → N px, else → N×4 px), so it scripts and is checkable by
  re-measuring the DOM. **Classify by ROLE, not by number** — of the off-ladder values only 19
  (`MattIcon name="verified"`) is an icon (→ `--icon-20`); `size-[6px]`/`[8px]` are status + unread
  **dots**, `size-[22px]` a toggle **knob**, `size-[36px]` a hit-target **container**. Those keep
  arbitrary px; snapping them to the ladder would double a 6px dot. **Latent trap:** the 546 correct-today `h-5`/`h-6`/`h-10` uses would silently
  4×-shrink if anyone ever added 5, 6 or 10 to the override set.
- **✅ Phases 1–2 BUILT (Conv 419).** Promoted to its own PLAN block —
  **[plan/icon-sizing/README.md](plan/icon-sizing/README.md)** holds the 6-phase sequence, the test
  design and the open questions. Do not re-derive them here.
  - `npm run check:icons` (`scripts/check-icon-sizing.ts`) — static guard, **new-violations-only**
    against a committed 1,863-violation baseline (a hard gate would be red on day one and ignored).
    Rules: bare-numeric both ambiguity directions · **51 icon usages with no size class at all** ·
    arbitrary px on an icon. Verified by injecting an `h-4 w-4` regression: caught, exit 1.
  - `npm run icons:scan` (`scripts/icon-scan.mjs`) — runtime, 26 routes × **two root font sizes**.
    The double run is the completeness proof: post-migration, an inline icon that doesn't move
    between a 16px and 24px root is provably still pinned to px. Baseline: **11 findings, all on
    `/become-a-teacher`** (9 too-small incl. an 8px avatar, 2 overflowing) — every other route clean.
  - **Lesson worth keeping:** the first `inline-ratio` rule keyed off "is there text nearby" and
    produced 38 findings that were almost all thumbnails, avatars and empty-state illustrations.
    Re-keyed on **geometry** (does the icon vertically overlap its text, i.e. beside it vs stacked
    above it) → 0 false positives. A noisy rule would have been ignored, which is the failure the
    baselining was meant to avoid.
- **Useful side-effect:** the scan's `% scale with root` column is a per-route migration-progress
  meter — `/admin` 96%, `/admin/users` 98% (largely rem already) vs `/messages`, `/notifications`,
  `/profile` at 0% (entirely fixed px). Use it to order the tranches.
- **Related:** `memory/reference_tailwind_intellisense_canonical_suggestions.md` — IntelliSense's
  arbitrary-`[Npx]`→scale suggestions must be REJECTED; same 4× confusion, inverted direction.

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
- **What:** lower supported min screen width 375px → 320px (iPhone-SE class). 3 scoped overflow sites: `MembersFilters.tsx` + `CoursesFilters.tsx` filter rows (`min-w-0` or wrap) + Home legacy feed-card action button (`min-w-0`/`flex-wrap`); re-verify at 320px via iframe harness. Optional.
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
- **What:** `npm run prov:sweep` reports **11 issues** (10 UNTRACKED errors + 1 drift) — was 0 at Conv 244. Drift since: components stamp `data-prov-name="X"` on their outer element but were never added to `scripts/matt-inspired-registry.ts`. Offenders: `NavDrawer`, `NavMenuButton`, `communities/CommunitiesFilters`, `courses/CoursesFilters`, `feed/SignupCtaCard`, `settings/LayoutToggle`, `ui/MobileUpNav.astro`, `course/CourseJourneyStepper.astro`, `course/CourseSessionsActions.astro`, **`course/CourseReviewComposer.tsx`** (10th, added Conv 416, spotted Conv 418 — the gate drifts by one every time a stamped component ships unregistered, which is the recurring cost of leaving it red).
- **Verified NOT caused by `[A11Y]` Conv 404** (none in that diff; the 2 new primitives are unstamped).
- **Related tooling weakness (Conv 412):** `scripts/gen-registries.ts`'s marker regex `/@matt-source\s+\d+:\d+/` matches the marker-with-node **anywhere in a file, incl. prose** — so a `@matt-inspired` component that *references* another's source node in its docstring gets falsely registered as matt-sourced (hit `messages/matt/Avatar.tsx`, whose prose named the UserIcon node it wraps). Mitigated Conv 412 by rewording Avatar's prose; the durable fix is to require the marker to be a standalone provenance line (align with `prov-sweep.ts`'s accept-rule). Low priority.
- **Why it matters:** a real gate failing unnoticed → the registry⟺marker⟺stamp conformity from `[PRIM-STAMP]` (Conv 217) isn't holding. Each offender needs a registry entry (with `figmaMatchNames`) **or** its stamp removed if not a vetted primitive — decide per component, don't bulk-register.
- **Refs:** `../Peerloop/scripts/matt-inspired-registry.ts`, `npm run prov:sweep`, `docs/as-designed/matt-provenance.md §12c`, `plan/prim-registry/README.md`, `[PRIM-STAMP]`, `[PROV-SWEEP-DEBT]`. Surfaced Conv 404.

### [RG-PUBLIC]

- **State:** ⏸️ parked · **gate: marketing redesign**
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

### [ICON-LIC]

- **State:** ⏸️ parked · **gate: MVP-GOLIVE** (pre-launch legal/compliance)
- **What (surfaced Conv 370):** two items.
  - **Attribution NOTICE** — no `LICENSE`/`NOTICE`/`THIRD-PARTY-NOTICES` file, but `icons.tsx` = Heroicons (MIT, Tailwind Labs) and ~20 `MattIcon` SVGs = Material Symbols (Apache 2.0, Google) both require the notice retained → add a third-party-notices file (low effort).
  - **Brand-logo trademark review** — `brand-icons.tsx` (Google/Stripe/GitHub/X/LinkedIn/YouTube/Instagram) are trademarks: check each against brand guidelines (esp. Google Sign-In button rules, Stripe badge rules, `fill="currentColor"` recoloring). The 39 `matt-catalogue` MattIcons are commissioned — verify the designer agreement assigns IP.
- **NOT legal advice — needs counsel sign-off at launch.**
- **Refs:** `docs/as-designed/icon-system.md`, `src/components/icons/icon-provenance.ts`.

---

## ✅ Done this conv

- **[ICON-TOK] Phase 6 root fix** — `--spacing: 0.0625rem` + 449-site `N→N×4` sweep across 99 files;
  every Tailwind number now means its own pixel count. Blast radius proven at one line of compiled
  CSS; live-verified 4,206 strict measurements / 0 mismatches; 5 gates green. New `npm run spacing:scan`.
- **[ICON-TOK] icon-rule reframe + informational tier retired** — `check:icons` rules now state a
  *readability* rationale ("renders correctly, but does not say it is an icon"); the old text asserted a
  mis-render that can no longer happen. `dimension-bare-numeric` deleted outright — all 532 became
  self-describing at the root, so the tier held a non-defect. Baseline regenerated: **25 governed, one
  file**, `informational` key omitted rather than written as `{}`. Phase 6's bare-number lint rule
  **cancelled deliberately** (its purpose was surfacing an ambiguity that no longer exists).
- **[ICON-AUDIT]** — closed. The Conv-421 audit's findings 1 and 4 were acted on that conv (re-target +
  baseline split); 2–3 were historical-accuracy notes with nothing to do. Its remaining open question
  (the 532) was answered by the Conv-423 root fix. Record lives in `plan/icon-sizing/README.md` and
  git history.
- **[TOKDOC]** — design-system SoT (`docs/as-designed/matt-design-system/05-color-and-tokens.md`)
  rewritten. Its § "Why a separate axis at all" justified the icon axis with the ambiguity Conv 423
  removed, *and* with a rem-vs-pinned contrast that no longer distinguishes `size-16` from
  `size-icon-16`. Now states the real surviving rationale, flags the two claims not to reintroduce, and
  notes the two-way rule's "Not an icon" row is a preference rather than an enforced rule. Surfaced by
  the r-end docs agent as an out-of-scope FYI (category `manual`), verified against the file, fixed at
  the Step 4d checkpoint on user instruction.
- **Decision (user, Conv 423): the `--icon-N` family is KEPT AS-IS** — behaviourally redundant after the
  root fix (`size-icon-16` ≡ `size-16`), but retained because it is the only surviving record of which
  elements are icons, and retiring it is a one-way door on four convs of identification work. Costed at
  ~600 neutral edits; cheap to do, expensive to undo. → `plan/icon-sizing/README.md § Open questions`.
