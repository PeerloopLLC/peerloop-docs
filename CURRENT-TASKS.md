# Current Tasks — between convs

> Last refreshed 2026-07-11 (Conv 387). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
>
> **Persistent home for Peerloop task state.** Tracked in git so both machines see the
> same state via `/r-commit` push/pull. Edit by hand to reorder; the refresh (`/r-update-tasks`,
> plus `/r-commit` + `/r-end`) preserves your edits and overlays statuses from TodoWrite for
> code-matched rows.
>
> **Format:** Tasks are keyed by `[CODE]` (the sole stable identifier — no numeric IDs). Every task is
> an H3 (`### [CODE] · status · [model]`; the status segment appears in Ordered only) with a lead line
> then sub-bullets (Ordered uses Status / Next / Why / Refs; backlog is a lead line + adaptive
> sub-bullets). **Lanes** fold related micro-tasks into one H3's sub-bullets. **Parked** items sit under
> the blockquoted `> ## ⏸️ PARKED` divider near the end of the backlog. Only the three real `## ` H2
> anchors (🔥 Ordered / 📋 Unordered backlog / ✅ Completed this conv) are load-bearing.

---

## 🔥 Ordered (next-conv execution sequence)

### [PLATO-SEQ] · 🟢 Active work complete · 4c post-launch · [Opus]

Waypoint-sequenced PLATO API+browser test architecture. **Phases 1–4b all ✅ (Convs 379–385)** — the waypoint producers, the dependency-graph + provenance foundation (`plato:graph`), and the `plato:run` make-for-waypoints runner are built, validated, and committed; full history in git + `docs/sessions/` + `docs/as-designed/plato.md`. **Only Phase 4c remains, and it is post-launch-gated** (duplicates the Parked `[BROWSER-SMOKE-2B]` below).
- **⏳ Outstanding — Phase 4c (deferred post-launch):** the agent-driven browser walker (PLATO-ON-STEROIDS / `[BROWSER-SMOKE-2B]`) — auto-walk a pure-UI browser segment from a restored waypoint and self-verify the UI, so a full journey chains API-produced waypoints (which cross Stripe Connect / Checkout / BBB that a browser can't) with browser-verified UI segments. Do NOT resurrect Playwright E2E.
- **To resume 4c:** the reusable browser-walk mechanics (actor-switch via `POST /api/auth/dev-login`; CUT-2 enroll = signed `checkout.session` with **no `payment_intent`** via `trigger-webhook.sh stripe-direct-raw`; CUT-3 = `bbb-meeting-ended`; click-by-`ref`/late-hydration gotchas; Genesis creds) are captured in `.scratch/plato-waypoint-plan.md` and memory `[[reference_chrome_bridge_island_stale_cache]]` / `[[plato_walk_mocked_service_divergence]]`.
- **Refs:** `docs/as-designed/plato.md` § Waypoint-Sequenced Segments, `tests/plato/snapshots/README.md` § Browser-walk validation, `PLAN.md` § PLATO-SEQ, `.scratch/plato-waypoint-plan.md`, `docs/decisions/06-testing-ci.md`.

---

## 📋 Unordered backlog

### [SESSION-REMIND-DEPLOY] · standalone (deploy-time — user-owned)

Two deploy-time steps to **activate** session reminders (code complete + verified Conv 375; CC cannot run these — staging-only rule + user owns deploy). (1) **Set the Resend secret** on the cron Worker: `npx wrangler secret put RESEND_API_KEY --env staging --config workers/cron/wrangler.toml` (and `--env production` when prod is unblocked) — until set, the cron logs `session-reminders skipped` and runs cleanup only, no crash. (2) **Apply the 2 new `sessions` columns** (`reminder_24h_sent_at` / `reminder_1h_sent_at`) to the **existing staging D1** — editing `0001_schema.sql` only affects fresh setups, so either re-seed staging or run a one-off `ALTER TABLE sessions ADD COLUMN …` (local dev + tests already pick it up). **Refs:** `workers/cron/wrangler.toml`, `migrations/0001_schema.sql`, `src/lib/session-reminders.ts`.

### [FEEDBACK-NUDGE] · standalone (deferred feature) · [Opus]

Build the post-session feedback/rating nudge properly. `FeedbackReminderEmail.tsx` was **deleted** Conv 375 (dead scaffolding — no Settings toggle, no notif type, imported nowhere). When built, needs the full stack like session reminders: a new email-pref column (e.g. `email_feedback_reminder`) + Settings toggle + notif type + a cron block (mirror `sendSessionReminders`) targeting recently-completed sessions the user hasn't rated, with a per-session dedup stamp. Recreate the template then (git history has the deleted version). Low priority.

### [HOME-FIXES] · standalone (deferred per-route bucket)

Deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — small issues set aside to batch later.

### [COURSES-FIXES] · standalone (deferred per-route bucket)

Same as [HOME-FIXES] but for the Courses route(s).

### [PLAN-XTRACT] · standalone

Extract bloated inline PLAN.md blocks out to `plan/<slug>/README.md`. PLAN.md is ~62K tokens — over the Read-tool limit (forced a Python-splice workaround Conv 350). Low priority.

### [BRAND-DOCS] · standalone

Docs-wide "PeerLoop" → "Peerloop" casing sweep — **pre-existing** inconsistency (NOT Conv-369-caused), surfaced by the Conv-369 r-end docs agent: ~30 docs still carry the old casing as generic prose, mostly manual/vendor (`resend.md`, `stripe.md`, `cloudflare.md`, `matt-design-system/*`) + a few driftCheck (`url-routing.md`, `messaging.md`, `ratings-feedback.md`). BRAND-CASE (Conv 369) was scoped "UI copy only." Verify each isn't an intentional reference before bulk-replace. Low priority.

### [CBG] · standalone

Add a commit-time branch-verify guard to `/r-commit` + `/r-end`. `[RSTART-DIFFGATE]` only checks the code branch at `/r-start`; Conv 371 committed to `brian-July-7` (client's experimental branch, checked out externally mid-conv) before it was caught + moved to `jfg-dev-14`. Warn if current code branch ≠ expected/recorded before committing. Low priority. **Refs:** `.claude/scripts/conv-branch-check.sh`, `memory/feedback_git_dash_c_enforcement`.

### [BRIDGE-UPLOAD] · standalone (tooling watch)

`mcp__claude-in-chrome__file_upload` rejects filesystem paths ("MCP controller must read the file and pass contents via the `files` parameter"), but the exposed schema only has `paths` — so there is **no working browser file-upload** in a PLATO browser-run (thumbnails, avatars, homework attachments). Worked around Conv 379 by setting the course thumbnail via the app's `PUT /api/me/courses/[id]/thumbnail` (external URL, JSON). Re-test on a newer Chrome-in-Claude build; document the API-PUT fallback as the standard for file-gated browser steps. **Refs:** `memory/reference_chrome_bridge_island_stale_cache` [BRIDGE-UPLOAD]. Surfaced Conv 379.

### [PUB-CHECKLIST-STALE] · standalone (minor client bug) · low priority

Course editor: saving the Basic Info "Tags" field persists to `course_tags` (DB verified) but the Publishing tab's checklist still shows "At least one tag assigned" as UNMET until a full page reload. The `PublishingChecklist` reads a client course/tags state not refreshed after the Basic Info save. Fix: invalidate/refetch tags into the checklist state on save. Reload works, so low priority. Surfaced Conv 379.

### [PLATO-DOCTREE] · standalone (doc reconcile) · low priority

`docs/as-designed/plato.md` § "Current File Structure" snapshot block (~L771–833, driftCheck) is stale: says flywheel "12 steps" (now 15), labels `flywheel-pre-9` "Enrollment-ready (first 9 steps)" (now `wp-published`, steps 1–8), omits `book-sessions`/`complete-sessions` steps + `flywheel-pre-11/12/14/15` instances/scenarios. Pre-existing (Conv 379 left it too) + Conv-380 additions + **Conv-382 additions** (`activities-pre-11` / `ecosystem-pre-12` instances+scenarios + their gitignored snapshots). It **duplicates** TEST-COVERAGE.md's now-current file tables → decide: reconcile the snapshot, or trim it to avoid double-maintenance. The doc's authoritative sections are already correct. Surfaced Conv 380 r-end docs agent.

### [BLOCKPLAN] · standalone (cleanup decision) · low priority

`CURRENT-BLOCK-PLAN.md` (docs-repo root) is an unfilled March template never used for any block — PLATO-SEQ (and prior multi-conv blocks) tracked in PLAN.md instead (Conv 382 Decision #3, PLAN.md is SoT per CLAUDE.md §Feature Tracking). Decide: adopt it consistently for multi-conv blocks, or remove it to cut surface. Low priority. Surfaced Conv 382.

### [UXQ] · standalone (harness-UX note) · low priority

`AskUserQuestion` tears down the option picker when the user selects "let me clarify" — the choices they wanted to discuss vanish. User flagged this directly Conv 385 ("it disappears just when the user says he wants to chat about it"). Workaround: re-render the options as durable prose. **Not fixable in this repo** — a CC harness behavior; keep as a watch/report-upstream note. Surfaced Conv 385.

### [AVAIL-BUFFER] · standalone (minor bug) · low priority

Teacher availability `buffer_minutes` is accepted + validated by `PUT /api/me/availability` but never written to the DB (the INSERT omits it), and `GET /api/me/availability` hardcodes `bufferMinutes = 15` with a "column may not exist yet" comment — so a teacher-configured buffer is silently dropped and booking conflict checks use raw slot adjacency only. Fix: add/confirm the `availability.buffer_minutes` column and persist it. **Also surfaced (seam, note-only):** availability/booking reads the *availability-rule* tz (`availability[0].timezone`) while emails/notifications read `users.timezone` — if a teacher's account tz ≠ their availability-rule tz, the calendar and the confirmation email can label the teacher's zone differently. Both surfaced Conv 386 during [XTZ]. **Refs:** `src/pages/api/me/availability.ts`, `src/pages/api/teachers/[id]/availability.ts`.

> ## ⏸️ PARKED (blocked behind a clear gate — out of active rotation)
>
> Each revisits when its gate clears.

### [TC-MERGE-TZ] · ⏸️ Parked — gate: before the brian-July-7 merge (rediscuss w/ specifics)

Surface the **timecard implications of a *regular* (history-preserving) merge** of the client branch `brian-July-7` into `jfg-dev-14`, to be worked BEFORE that merge happens. **Cross-tz billing hazard:** the client (Brian) commits from **CST**; Fraser commits from **ET**. A regular merge imports Brian's CST-authored commits into `jfg-dev-14`'s history, and `r-timecard-day` buckets **all** branch activity for a day — so Brian's CST commits mix with Fraser's ET commits on the same day → day-boundary **overlap** and the client's own commits landing in the daily (billable) timecard where they don't belong / with wrong day attribution. NB: this is a *different* tz source than the "2 co-located ET dev machines" analysis (Conv 376), which correctly found no differential for Claude's own work — that conclusion stands; this is about **Brian's** commits entering history via merge. **To analyze when un-parked:** does `timecard-day.js` filter by author/branch? Exclude client commits by author (`PeerloopLLC`), or use `--squash` to keep them out of the daily buckets, or offset by committer tz? **Refs:** `.claude/scripts/timecard-day.js`, skills `r-timecard-day` / `r-timecard` / `w-timecard`, branch `brian-July-7` (author `PeerloopLLC`, CST). Surfaced Conv 376.

### [RG-PUBLIC] · ⏸️ Parked — gate: marketing redesign

Public/marketing route group sweep (the only un-swept RG-* group; RTMIG-4 closed Conv 340 with it deferred). The 14 marketing pages live only in `/old/*`; root paths 404 by design. Revisit if/when the marketing redesign is scheduled. **Refs:** `plan/route-migration/README.md § RG-PUBLIC disposition`.

### [PREFLIP-WT] · ⏸️ Parked — gate: user say-so

Tear down the preflip reference worktree (`~/projects/Peerloop-preflip` on :4331, `peerloop-ref` alias). Consequential + machine-local; the PLATO port-audit reason for keeping it has cleared. **Refs:** memory `project_preflip_worktree_reference`.

### [BROWSER-SMOKE-2B] · ⏸️ Parked — gate: post-launch · [Opus]

Evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor. Do NOT resurrect Playwright E2E. **Refs:** `docs/decisions/06-testing-ci.md`.

### [MINWIDTH-320] · ⏸️ Parked — gate: user say-so (on hold Conv 369)

Lower the supported minimum screen width 375px → 320px (iPhone-SE class). 3 scoped overflow sites: `MembersFilters.tsx` + `CoursesFilters.tsx` filter rows (let search shrink via `min-w-0`, or wrap the cluster) + Home's legacy feed-card action button (`min-w-0`/`flex-wrap`); re-verify at 320px via the iframe harness. Optional — **put on hold Conv 369** pending user say-so. **Refs:** `docs/decisions/05-ui-ux-components.md` [MINWIDTH], `memory/reference_responsive_iframe_harness`.

### [ICON-LIC] · ⏸️ Parked — gate: MVP-GOLIVE (pre-launch legal/compliance)

Icon commercial-use compliance, surfaced Conv 370 during [ICN-NS]. **Two items:** (1) **Attribution NOTICE** — no `LICENSE`/`NOTICE`/`THIRD-PARTY-NOTICES` file exists, but `icons.tsx` = **Heroicons (MIT, Tailwind Labs)** and ~20 `MattIcon` SVGs = **Material Symbols (Apache 2.0, Google)** both require the notice retained → add a third-party-notices file (low effort). (2) **Brand-logo trademark review** — `brand-icons.tsx` (Google/Stripe/GitHub/X/LinkedIn/YouTube/Instagram) are trademarks, not licensed assets: check each against brand guidelines before launch — esp. **Google Sign-In** button rules, **Stripe** badge rules, and the `fill="currentColor"` monochrome recoloring (some brands mandate specific colors). The 39 `matt-catalogue` MattIcons are commissioned/owned — verify the designer agreement assigns IP. **NOT legal advice — needs counsel sign-off at launch.** **Refs:** `docs/as-designed/icon-system.md`, `src/components/icons/icon-provenance.ts`.

---

## ✅ Completed this conv

- **[HW-SUBMIT-UI] Re-home + Matt-restyle student homework submission UI ✅ (Conv 387).** Closes the Conv-383 Matt-port regression where an enrolled student had no live route to submit homework. **Placement (Option A):** enrolled-only "Homework" Explore tab → `/course/[slug]/homework`. `buildCourseExploreTabs(slug, isEnrolled)` appends the tab (icon `assignment`) when enrolled; `[...tab].astro` adds `homework` to VALID_TABS/labels, extends the non-enrolled redirect (like `/sessions`), passes `isEnrolled`, and renders `<HomeworkTab client:load courseId={data.course.id} enrollmentId={data.enrollmentId ?? ''}>`. **Restyle:** rewrote `HomeworkTab.tsx` off the legacy primary/secondary palette onto Matt tokens (course-primary button, neutral card/border/text ramp, success/warning/error/info status badges, primary-default focus rings, rounded-8/12). **+3 unit tests** (`journey-loop-tabs.test.ts`). **Live browser walk verified:** enrolled (Sarah/Marcus) see the tab + full submission form (textarea/URL/file/Submit), logged-out bounced off `/homework` + tab hidden, computed styles show course-green button + neutral borders + 0 legacy classes. All 5 gates green (tsc/astro-check/lint/build + suite **6852**).
- **[PLATO-SEQ] trim (Conv 387).** Trimmed the CURRENT-TASKS PLATO-SEQ entry to its one outstanding item (Phase 4c, post-launch-gated) + resume context; cut the completed-phase history (preserved in git + `docs/sessions/` + `docs/as-designed/plato.md`).
- **[CAF] Course "Available soon" filter — teacher available within an admin window (default 14) ✅ (Conv 387).** New `/courses` filter toggle showing only active courses with a certified, teaching-active teacher who has a real open slot within the admin-configurable window. **Approach (user-chosen): Option 2 exact-lazy** — SSR untouched; new **`POST /api/courses/availability-batch`** (public, cap 50, short-circuits `hasAvailability` via `countAvailableSlots`, honors bookings/overrides) computed only when the toggle flips, cached in the catalog island (no KV cache in v1). `CoursesFilters.tsx` adds a `Switch` "Available soon" (both orientations, chip, clear); `CoursesCatalog.tsx` lazily fetches the boolean map + filters (composes with level/topic/search) + loading/error states. **Window:** REUSED the existing `platform_stats.availability_window_days`, default **30/28 → 14** (seed `0002` + `availability-summary` now share `lib/availability-config.ts`); new **`/admin/availability-settings`** page + `GET/POST /api/admin/availability-config` (admin-gated) + AdminNavbar item. **+24 tests** (config lib, batch endpoint w/ frozen clock, admin API). **Live-verified:** batch returns 14 + correct booleans on real data; UI toggle narrows 6→2 (ai-tools-overview + intro-to-n8n) and restores; admin page shows 14, POST 21→ok / 0→400 / restore 14. All 5 gates green (tsc/astro-check/lint/build + suite **6876**). **NOTE:** the 30→14 seed change only affects fresh DBs — existing staging keeps 30 until an admin sets it via the new `/admin/availability-settings` UI (no SQL needed).
