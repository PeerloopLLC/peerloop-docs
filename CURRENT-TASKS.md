# Current Tasks — between convs

> Last refreshed 2026-07-10 (Conv 380). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [PLATO-SEQ] · 🔄 Active · [Opus]

Waypoint-sequenced PLATO API+browser test architecture. **Phase 1 (Foundation) ✅ DONE Conv 379**; **Phase 2 deterministic foundation ✅ DONE Conv 380** — browser re-walks remain; Phases 3–4 pending.
- **Status (Conv 380):** Deterministic waypoint chain built + state-verified. Decomposed `complete-course` → flywheel-scoped `book-sessions` (pure-UI) + `complete-sessions` (CUT-3/BBB) — flywheel now 15 steps, shared step untouched for ecosystem/seed-dev. Regenerated stale `flywheel-pre-9`; built the 4 API producers `flywheel-pre-9/12/14/15` (`wp-published`/`wp-enrolled`/`wp-booked`/`wp-completed`) via `plato:split`+promote; all 4 snapshots DB-state-verified exactly (pre-14=3 scheduled, pre-15=3 completed). tsc clean, PLATO API 13/13, manifest + `plato.md` + PLAN.md updated.
- **Next (Phase 2 remainder — interactive):** browser segment re-walks via Chrome bridge — **B1** (`wp-fresh`→creator setup→`wp-published`), **B3** (`wp-enrolled`→submit-expectations+book-sessions→`wp-booked`), **B4** (`wp-completed`→verify `/learning`+certify+verify `/teaching`); `plato:capture` browser end-states. Needs ephemeral dev server. Structurally fixes `[FLYWHEEL-WALK-GAP]` + unblocks `[PLATO-WALK2]`.
- **Why:** a pure browser-run can't cross Stripe Connect / Stripe Checkout / BBB boundaries; chaining API-produced waypoints + browser-verified pure-UI segments is the fix.
- **Refs:** `docs/as-designed/plato.md` § Waypoint-Sequenced Segments, `PLAN.md` § PLATO-SEQ, `.scratch/plato-waypoint-plan.md`.

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

_(none yet — refreshed at /r-commit and /r-end as tasks close.)_
