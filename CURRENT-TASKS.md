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

> **MESSAGES mini-plan (Conv 417, user-sequenced).** One ordered programme, M1→M6.
> **M1 `[MSGBOOT]` ✅ Conv 417 · M2 `[CANMSG]` ✅ Conv 418** — items 1–4 below are the
> remainder (M3→M6). Soft dependency M3→M4/M5 (M4/M5 can't start until the icon variant
> exists). M4 and M5 are independently shippable, so the programme can legitimately stop
> after M4.

1. [MSG-ICON](#msg-icon) — **M3** icon variant of `MessageUserButton` (unblocks 19 sites)
2. [MSG-ADOPT-A](#msg-adopt-a) — **M4** adopt on 11 high-consequence sites
3. [MSG-ADOPT-B](#msg-adopt-b) — **M5** adopt on 10 list/profile sites
4. [MSG-CLEANUP](#msg-cleanup) — **M6** messages-area debt sweep
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
- **Do:** write `memory/reference_devserver_stale_daemon` capturing both variants — the bound-but-dead signature (`lsof` hits + `curl 000` ⇒ bricked by a mid-run `npm install`; kill the PIDs, restart) and the stale-content one (verify with `curl …/matt` → 404 = current; hard-refresh / private window / use `127.0.0.1`). The diagnosis has now been re-derived three times.
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

### [KNIP]

- **State:** 🔄 active
- **What:** `knip@6.27.0` adopted (Conv 398) as the module-graph reachability oracle — closes grep's blind spots (`.astro`, relative imports, barrel passthroughs). Installed + configured (`knip.json`, cron-worker + `scripts/**` entries, `project: src/**`); first run adjudicated the 9 `[RDFIX]` candidates and reproduced the 14 parked `[ORPHAN-BACKLOG]` Cat-B files.
- **Before it can be a hard gate:** (1) tune dependency analysis — false-flags `zod`/`tailwindcss`/`@tailwindcss/forms`/`react-day-picker` (CSS `@plugin`/runtime, not JS import) + `cloudflare:` unlisted; (2) baseline the 14 Cat-B files (or wait for `[RG-PUBLIC]`) — same blocker as `codecheck-orphan-components.mjs`, which knip would replace; (3) wire into `/w-codecheck` (only NEW unused fails).
- **Known dead exports KEPT by decision (knip re-flags when gate lands):** `CHART_BREAKPOINTS`, `now()`/`parseTimestamp()` (`lib/db/index.ts`), `creators`/`getRelatedCourses`/`getFeaturedCreators` (`lib/mock-data.ts`), `MONITORING_COLORS` (`discover/role-utils.ts`), `emails/styles.ts`'s 6 exports (file live).
- **Refs:** `../Peerloop/knip.json`, `.claude/scripts/codecheck-orphan-components.mjs`, `[[feedback_orphaned_components_survive_migration]]`, `[ORPHAN-BACKLOG]`, `docs/decisions/06-testing-ci.md §RDOC`.

### [MEM-PRUNE]

- **State:** 👀 watch (recurring) · receded (70%, below the 80% trigger)
- **What:** threshold-triggered, never "done" — standing watch `[MEM-CAP]` in PLAN.md. Fires when `MEMORY.md` auto-load crosses **80%** of the 200-line / 25 KB SessionStart cap on either axis (`/r-start` Step 5.7 Phase 2 emits 🔴🔴🔴). Remedy is **`/r-prune-memory`** (NOT `/r-prune-claude`).
- **Utilization log:** Conv 211 baseline 53%/73% → tripped 80% bytes Conv 213 → Conv 396 full run 20304 B (79%) → 17979 B (70%), 127 → 124 lines.
- **Next firing:** the two big Conv-396 levers are spent (label-normalization is a no-op; the intro-blockquote dedup is done). Will likely need extraction or sub-file consolidation, not more trimming.
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

### [MSG-ADOPT-A]

- **State:** 📋 queued — **M4** of the MESSAGES mini-plan · gated on `[MSG-ICON]` (M3)
- **What:** adopt `MessageUserButton` on the **11 high-consequence sites** — where navigating away
  destroys work the user cannot cheaply rebuild. Ship as one tranche; independently releasable.
- **Sites — in-progress work destroyed (4):** `booking/SessionBooking:707,790` (mid-wizard: teacher,
  date and time already chosen), `booking/SessionParticipantCard:43` (rendered by `SessionRoom` and
  `SessionCompletedView`, where the user is about to rate), `teachers/workspace/TeacherSessionsList:692`.
- **Sites — slide-over + list state destroyed (7):** every `admin/*DetailContent` —
  `UserDetailContent:96`, `TeacherDetailContent:93`, `EnrollmentDetailContent:123`,
  `SessionDetailContent:167,184`, `ModerationDetailContent:222`, `CreatorApplicationDetailContent:79`.
  These sit inside `AdminDetailPanel` (a **slide-in panel**) over a filtered list, so navigating
  discards both. **This corrects a Conv-417 mid-conv guess that admins want the jump — they don't.**
- **Done-test:** per-site live verify that a click opens the composer and does not navigate; 5 gates.
- **Refs:** `[MSG-ICON]`, `src/components/messages/MessageUserButton.tsx`, Conv 417 sweep.

### [MSG-ADOPT-B]

- **State:** 📋 queued — **M5** of the MESSAGES mini-plan · gated on `[MSG-ICON]` (M3)
- **What:** adopt on the remaining **10 list / profile sites**. Lower stakes than M4 — losing scroll
  position rather than losing work — so this tranche is genuinely optional and can be dropped.
- **Sites — long filtered lists (5):** `teachers/workspace/MyStudents:586`,
  `dashboard/TeacherStudentList:207`, `dashboard/CreatorTeacherList:210`,
  `dashboard/TeacherUpcomingSessions:117`, `community/CommunityMembersTab:94`.
- **Sites — reading context; also the only 3 drop-in `Button`s (3):**
  `teachers/profiles/TeacherProfileHeader:114`, `creators/profiles/CreatorProfileHeader:110`,
  `users/UserCard:111` (the `/@handle` profile).
- **Judgment calls, defaulted MODAL (2):** `dashboard/EnrollmentCard:107`,
  `courses/CourseProgressCard:80` — both "Learning with X". Reading them as *continue our
  conversation* (→ keep anchor) is defensible; **re-decide with the escape hatch in hand.**
- **KEEP THE ANCHOR — do not convert (1):** `booking/SessionRoom:364`. Its own code comment says
  *"links to the existing messages thread (function preserved)"* — thread-intent, not compose.
- **Out of scope:** `Sidebar:315` `href="/messages"` — plain nav to the centre, correctly an anchor.
- **Done-test:** as M4, plus an explicit re-read of the 2 judgment calls.

### [MSG-CLEANUP]

- **State:** 📋 queued — **M6** of the MESSAGES mini-plan (no gate; can run any time)
- **What:** messages-area debt found while doing M1–M5.
  - `MessagesCenter.tsx:4` header claims it re-skins `src/components/messages/Messages.tsx`
    *"(left untouched, still used by /old/messages)"* — **both are gone** (`src/components/messages/`
    holds only `matt/`, `MessageUserButton.tsx`, `types.ts`; no `src/pages/old/messages*`).
  - `[RHOOKS]` warning at `NewConversationModal:54` (`setState` in the debounced-search effect) —
    either fix locally or fold into the standing `[RHOOKS]` task.
  - **`GET /api/me/can-message/:userId` has no UI caller** since `[CANMSG]` (Conv 418) made the
    check local. Deliberately KEPT — it is a valid API surface, still tested
    (`tests/api/me/can-message/[userId].test.ts`), and the same `canMessage()` lib call is the
    authoritative gate on `POST /api/conversations`. Decide here whether to keep or delete it;
    if kept, note that `[KNIP]` will flag it when that gate lands.
  - Registry / `prov:sweep` re-check for `MessageUserButton` + any M3 variant.
- **Done-test:** no stale refs, 5 gates green, `prov:sweep` no worse than the `[PROV-SWEEP-DEBT2]` baseline.

### [MSG-ICON]

- **State:** 📋 queued — **M3** of the MESSAGES mini-plan · unblocks M4 + M5
- **🔴 Why it exists — the island does NOT drop in.** Of the 22 per-user message affordances, only
  **3** are `Button` components. The other **19 are bespoke icon-only `<a>` tags** with per-site
  classNames (`MessageIcon`/`MattIcon` at 16/20px, differing hover colours, some inside flex rows).
  `MessageUserButton` renders a `Button`, so M4/M5 are **not** an href swap.
- **What:** add an icon/bare-child variant — render the trigger as a bare styled `<button>` with
  `className` passthrough instead of the `Button` primitive, keeping the modal wiring, the
  `signedIn` anchor fallback, the discard guard and the "Open in Messages" exit identical.
- **Done-test:** variant renders icon-only with per-site classes preserved; the 3 existing `Button`
  call sites and the 2 course tabs are visually unchanged; 5 gates.

### [ORPHAN-BACKLOG]

- **State:** ⏸️ parked · `[Opus]` · **gate: marketing redesign (RG-PUBLIC)** — Cat-A+C DONE
- **Done:** `[ORPHAN-DETECT]` surfaced 118 orphaned components. Conv 392 deleted all **Category A** (dead legacy, 74). Conv 393 resolved all **Category C** — deleted 3 (`error/ErrorPage`, `leaderboard/Leaderboard`+orphaned API, `context-actions/*`), **wired 1** (`invite/ModeratorInvite` was a LIVE bug: admin invite emails `/invite/mod/{token}`, RESEND live on staging, but no page → 404; built `src/pages/invite/mod/[token].astro`), swept 12 stray dead `.ts`. Detector now **53** (was 118); all 5 gates green.
- **Remaining — Category B (52, parked):** `marketing/*` (48) + `stories/*` (2) + `testimonials/*` (2) + `creators/profiles/CreatorCard` — the old marketing site; keep until the redesign, then delete/replace. (12 dead `.ts` barrels deliberately LEFT with it; `icons/icon-provenance.ts` KEPT — it's the `prov:sweep` SoT.)
- **Then — detector wiring:** snapshot residuals into `KNOWN_ORPHANS`, wire the detector into `/w-codecheck` as a hard gate (only NEW orphans fail). A `.ts` variant (scope `src/components/**` only — `src/lib/**` has entry points) can be productionized then.
- **Refs:** `.claude/scripts/codecheck-orphan-components.mjs`, `[[feedback_orphaned_components_survive_migration]]`, `.claude/skills/w-codecheck`, `[KNIP]`.

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

- **State:** 📋 queued · low priority · `[Opus]` (skill infra)
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

### [TESTUNITDOC]

- **State:** 📋 queued — surfaced by the `/r-end` docs agent, Conv 417
- **What:** `docs/reference/TEST-UNIT.md` (registry category **driftCheck**, so in scope) has been stale
  since **Conv 253**. It lists roughly **21 of the 33** files in `tests/lib/`, and it contradicts itself:
  its own "Subtotal: 20 files, 315 tests" disagrees with its row count, and its Summary claims
  14 files / 262 tests.
- **Not a one-row patch.** The Conv-417 additions were documented, but the file needs a standalone
  reconciliation pass against disk — the same shape as the Conv 378 page-test pass.
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

- **[CANMSG]** — **M2** of the MESSAGES mini-plan. Retired the per-row `useCanMessage` fan-out by
  making the answer derivable on the client rather than by batching it. Chose the durable route
  (option **C**): the check was only non-vacuous because three loaders could surface a soft-deleted
  user, so `u.deleted_at IS NULL` was added to the community-member directory and the
  teacher/creator profile lookups — matching what `/@handle` already did — and only then was the
  network call removed. `useCanMessage` is now a pure `useAuthStatus` + `useCurrentUser` derivation
  (no effect, no fetch, `[MSGBOOT]` three-state cover preserved). Fixes a latent defect on the way:
  the member directory could list a soft-deleted user linking to a `/@handle` that 404s.
  **Measured `/community/ai-for-you/members`: 4 requests → 0, cold and warm, icons unchanged at 4.**
  5 gates green (suite **6573**, +5: 2 rewritten hook tests + 3 new loader tests in
  `tests/ssr/soft-deleted-users.test.ts`). `GET /api/me/can-message/:userId` deliberately kept but
  now UI-unused → noted on `[MSG-CLEANUP]`.
