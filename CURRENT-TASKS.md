# Current Tasks — between convs

> Last refreshed 2026-07-09 (Conv 376). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

_(empty — [SESSION-REMIND] completed Conv 375; no CC-execution item queued. Pick the next item from the backlog below.)_

---

## 📋 Unordered backlog

### [SESSION-REMIND-DEPLOY] · standalone (deploy-time — user-owned)

Two deploy-time steps to **activate** session reminders (code complete + verified Conv 375; CC cannot run these — staging-only rule + user owns deploy). (1) **Set the Resend secret** on the cron Worker: `npx wrangler secret put RESEND_API_KEY --env staging --config workers/cron/wrangler.toml` (and `--env production` when prod is unblocked) — until set, the cron logs `session-reminders skipped` and runs cleanup only, no crash. (2) **Apply the 2 new `sessions` columns** (`reminder_24h_sent_at` / `reminder_1h_sent_at`) to the **existing staging D1** — editing `0001_schema.sql` only affects fresh setups, so either re-seed staging or run a one-off `ALTER TABLE sessions ADD COLUMN …` (local dev + tests already pick it up). **Refs:** `workers/cron/wrangler.toml`, `migrations/0001_schema.sql`, `src/lib/session-reminders.ts`.

### [FEEDBACK-NUDGE] · standalone (deferred feature) · [Opus]

Build the post-session feedback/rating nudge properly. `FeedbackReminderEmail.tsx` was **deleted** Conv 375 (dead scaffolding — no Settings toggle, no notif type, imported nowhere). When built, needs the full stack like session reminders: a new email-pref column (e.g. `email_feedback_reminder`) + Settings toggle + notif type + a cron block (mirror `sendSessionReminders`) targeting recently-completed sessions the user hasn't rated, with a per-session dedup stamp. Recreate the template then (git history has the deleted version). Low priority.

### [TZ-BROWSER-AUTO] · standalone (decision — deferred)

Decide whether to add an automated browser-level timezone-DISPLAY regression test. Only a real browser with a controllable tz auto-catches a display bug; clean tool = a Playwright spec with `contextOptions.timezoneId` (e.g. `Asia/Tokyo`) booking/viewing a session and asserting the rendered local time. Tensions with parked [BROWSER-SMOKE-2B] ("do NOT resurrect Playwright E2E"). Surfaced Conv 375 [TZ-TESTS]. **Refs:** `docs/guides/TZ-MANUAL-VERIFICATION.md`, `docs/decisions/06-testing-ci.md`.

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

- **[TZ-HOOK-CHECK] COMPLETE — the TZ pre-commit hook had been inert since Conv 091; fixed + verified (Conv 376).** Root cause was none of (a)/(b)/(c): the matcher fires, `CLAUDE_PROJECT_DIR` resolves, and it's wired under the PreToolUse Bash matcher — but the deny **emit** omitted the required `hookSpecificOutput.hookEventName:"PreToolUse"` (and spliced multi-line lint output into JSON via a heredoc → invalid JSON), so Claude Code silently ignored the decision and every `git commit` proceeded. Confirmed 4 ways (schema, self-fetched `code.claude.com/docs/en/hooks`, git history, and a **live test**: identical `git commit` with a red `lint:tz` passed pre-fix, blocked post-fix). Fix: rewrote the emit to `jq -nc` mirroring `guard-dangerous-bash.sh` (adds `hookEventName`, escapes the reason). The other decision-emitting hook (`guard-dangerous-bash.sh`) was verified correctly-formatted → no other guard affected. Files: `.claude/hooks/pre-commit-lint-tz.sh`, `docs/as-designed/lint-timezone.md` (History + fragility note).
- **[TZ-LINT-SCAN2] COMPLETE — audited, extension consciously declined + one real gap fixed (Conv 376).** Audited the deferred `src/components` (~60) + `.astro` (5) hits: all benign (client-local calendar UI, tz-safe absolute-instant comparisons, DB-timestamp writes), so extending the server-oriented FAIL scan there = ~65 exemptions and ≈0 bugs — **declined**, documented as intentional in `lint-timezone.sh` + `lint-timezone.md`. The real client risk (raw `.toLocale*String()` without `timeZone`) is a different pattern; audit found no such display bugs (viewer-tz helpers + UTC-anchoring + `data-session-time` enhancement already cover it). **One genuine gap fixed:** `SessionRoom.tsx` showed the live session time UTC-anchored, not in the viewer's tz → moved to `useUserTimezone()` + `formatSessionDate/Time` (sibling pattern) + a **flip-verified** render test (`SessionRoom.test.tsx`, +2). tsc/eslint clean; SessionRoom + session-timezone suites green. Files: `src/components/booking/SessionRoom.tsx`, `tests/components/booking/SessionRoom.test.tsx`, `scripts/lint-timezone.sh`, `docs/as-designed/lint-timezone.md`.
