# Current Tasks — between convs

> Last refreshed 2026-07-08 (Conv 375). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [TZ-LINT-SCAN2] · standalone (deferred audit) · [Opus]

Extend the tz lint guard's source FAIL scan to `src/components` + `.astro` (the remaining dirs [TZ-LINT-CI] deferred Conv 375 — `emails`/`workers` already added). **Not a clean add:** `src/components` = ~60 pre-existing hits (CLIENT-side code in the browser's local tz — a *different* concern from server UTC math; triage legit local-time use vs should-use-viewer-tz-formatters); `.astro` = 6 (Footer copyright year + `MySessionsTab` now → likely `getNow-exempt`; `course/[...tab].astro:426-427` `sod` helper needs client-vs-SSR check; `profile:158` is a comment/false-positive). Annotate benign ones `getNow-exempt` or fix, then add to `SRC_SCAN_DIRS`. Low priority. **Refs:** `scripts/lint-timezone.sh` (`SRC_SCAN_DIRS` + exclusion comment).

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

### [TZ-HOOK-CHECK] · standalone

Verify the CC PreToolUse hook `~/projects/peerloop-docs/.claude/hooks/pre-commit-lint-tz.sh` actually FIRES. Conv 375 discovered it exists + is registered (docs-repo `settings.json:164`) and is designed to DENY CC-initiated code-repo commits when `lint:tz` fails — yet `lint:tz` was RED on baseline this conv (`recordings.ts` bare `new Date()`) and CC commits still went through, so it did NOT block. Check: (a) does its matcher (`Peerloop.*commit`) fire on `git -C ~/projects/Peerloop commit`? (b) is `CLAUDE_PROJECT_DIR` set in the hook env so `${CLAUDE_PROJECT_DIR}/../Peerloop/scripts/lint-timezone.sh` resolves? (c) is it wired under a PreToolUse matcher that matches Bash git commits? If silently non-functional, OTHER PreToolUse guards may be too. CI now backstops `lint:tz`, so not urgent. **Refs:** `.claude/hooks/pre-commit-lint-tz.sh`, `.claude/settings.json`, `docs/as-designed/lint-timezone.md`.

> ## ⏸️ PARKED (blocked behind a clear gate — out of active rotation)
>
> Each revisits when its gate clears.

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

- **[TZ-LINT-CI] COMPLETE — tz lint guard now enforced in CI (Conv 375).** Made `lint:tz` actually gate (it was an ungated npm script — corrected the task premise: no `.claude` PreToolUse hook existed). **(1)** Wired `npm run lint:tz` into `.github/workflows/ci.yml` (`lint-and-typecheck` job). **(2)** Added a hostile-TZ **matrix** to the `test` job (`[UTC, Pacific/Kiritimati]` via `TZ` env) — CI runs on UTC ubuntu, so this is what actually catches host-local date regressions (`getUTC*`≡`get*` on a UTC host); verified the full suite passes under +14 (**6810✓**). **(3)** Extended the guard's `SRC_SCAN_DIRS` to `src/emails` + `workers` (0 violations, server/UTC context). **Excluded** `src/components` (~60 hits, client-side/local-tz) + `.astro` (6, need triage) → deferred to [TZ-LINT-SCAN2]. `lint:tz` green. Files: `.github/workflows/ci.yml`, `scripts/lint-timezone.sh`.
- **[TZ-TESTS] COMPLETE — pre-GO-LIVE timezone test-shoring (Conv 375).** Plan-mode review of TZ-MODEL (Convs 371–375): implementation sound, no bug — risk was verification (Toronto test host + no tz-sensitive assertions ⇒ a `getUTC*`→`get*` revert stayed green). Added **+20 tests, each flip-verified** (revert fix → red): `period-dates.test.ts` (earnings month/year boundary — money), `expiry-helpers.test.ts` (moderation +N-day across DST), `is-valid-timezone.test.ts` (the model's input gate), `register.test.ts` Timezone Capture (signup→register path), `cleanup.test.ts` UTC-day-boundary no-show date. Exported the private helpers (`getPeriodDates` ×2, `getSuspensionEndDate`, `getExpiresAt` ×2) for unit testing. **Analytics bucketers:** deliberately NOT runtime-tested (date keys derive from `toISOString`; a test would give false confidence) — verified their regression is caught statically by `lint:tz`. **Fixed** pre-existing RED `lint:tz` (`recordings.ts` bare `new Date()` → `// getNow-exempt`). **PLATO:** genesis actors now cross-boundary (creator LA / student Tokyo) so browser walks exercise real per-viewer conversion, not UTC fallback. Wrote `docs/guides/TZ-MANUAL-VERIFICATION.md`. **5 gates green (6810✓, +20) + lint:tz green.** Deferred → [TZ-BROWSER-AUTO], [TZ-LINT-CI].
- **[SESSION-REMIND] COMPLETE — session-reminder cron job built + verified (Conv 375).** Delivers the feature Conv 374 decided to build (the `email_session_reminder` Settings toggle was live but inert). **Windows (user decision):** partition bands `(now+1h, now+24h]` = advance / `(now, now+1h]` = imminent — every scheduled future session gets ≥1 reminder; dedup-stamped for at-most-once per slot; bounds computed in JS as ISO strings (no `datetime()`). **Built:** 2 dedup cols in `0001_schema.sql` (`reminder_24h_sent_at`/`reminder_1h_sent_at`); `src/lib/session-reminders.ts` (`sendSessionReminders(db, apiKey, appUrl)` mirroring `runSessionCleanup`); `notifySessionReminder` helper; lead-time-neutral template copy (never says "tomorrow"); cron `Env`+isolated block + `RESEND_API_KEY`/`APP_URL` in `workers/cron/wrangler.toml` (both envs); per-recipient-tz email via `formatRecipientSession`; always-on in-app notif, pref-gated email; 6 integration tests. **Deleted** `FeedbackReminderEmail.tsx` (user decision — dead, no toggle/type) → spun to [FEEDBACK-NUDGE]. **5 gates green (6790✓, +6) + cron tsc clean.** Deploy steps → [SESSION-REMIND-DEPLOY]. **Corrected** task note: session status enum is `'scheduled'` (not `'booked'/'confirmed'`), verified vs schema.
