# Current Tasks — between convs

> Last refreshed 2026-07-08 (Conv 374). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [SESSION-REMIND] · ★ Next · [Opus]
- **Status:** 📋 Scoped, not started — spun out of TZ-MODEL Phase 3 (c) (user decision Conv 374: *build* the session-reminder feature). Its own conv.
- **Next:** Build the **session-reminder job**. Scaffolding already exists (~70%): `SessionReminderEmail.tsx` (24h/1h template) + `email_session_reminder` pref (schema col default 1 + full settings stack + live toggles in `ProfileSettings` **and** `NotificationSettings` + `lib/email.ts` pref-map) + `'session_reminder'` notif type (unions + `NotificationCenter`/`NotificationsList` styles + schema CHECK). **To build:** (1) add per-session dedup columns (`reminder_24h_sent_at` / `reminder_1h_sent_at`, schema `0001` pre-launch); (2) `sendSessionReminders(db)` lib fn (mirror `runSessionCleanup` shape) — select `booked`/`confirmed` sessions whose `scheduled_start` falls in the 24h and 1h windows ahead (via `getNow()` + `strftime('%Y-%m-%dT%H:%M:%fZ', …)` — NEVER `datetime()`), skip already-sent per the dedup cols; (3) send `SessionReminderEmail` per recipient gated on `email_session_reminder`, formatting the time in each recipient's stored tz via `formatRecipientSession(iso, tz)`; (4) emit a `session_reminder` in-app notification; (5) wire into `workers/cron/src/index.ts` (isolated try/catch like the rails/purge blocks); (6) tests (`tests/api/admin/sessions/cleanup.test.ts` pattern). Also **decide FeedbackReminderEmail** (separately dead — no pref/type, template only): build the post-session rating nudge too, or delete it.
- **Why:** A scheduling product needs reminders to cut no-shows; the pref toggle is **already live in Settings but inert** (users think they'll get reminders and don't) — building it makes the promise real. Chosen over deleting the scaffolding (Conv 374).
- **Refs:** `plan/tz-model/README.md § Phase 3 (c)`, `src/emails/SessionReminderEmail.tsx`, `src/emails/FeedbackReminderEmail.tsx`, `src/lib/cleanup.ts` (job shape), `src/lib/timezone.ts` (`formatRecipientSession`), `workers/cron/src/index.ts`. SQLite-datetime rule (CLAUDE.md) applies.

---

## 📋 Unordered backlog

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

- **[TZ-MODEL] COMPLETE — Phase 3 (a)+(b) + (c) decision (Conv 374).** Closes the per-user timezone model block (Convs 371–374). **(a)** Leftover-UTC-label sweep across `src/{components,emails,pages,lib}` — nothing to remove (Phase 2 already localized the senders; the only `${…} UTC` strings left are the designed null-tz fallbacks inside `timezone.ts`'s own helpers). **(b)** Bucket-3 UTC date-math hardening — 13 files made host-tz-independent via `getUTC*`/`Date.UTC`/`setUTCDate`: earnings `getPeriodDates` (creator+teacher), 7 analytics bucketing loops (admin revenue/courses/engagement/teachers/users + creator-analytics/enrollments + teacher-analytics/earnings), 3 expiry helpers (suspend/invite/resend), + `lib/cleanup.ts` 3 notification date stamps (`{timeZone:'UTC'}`). **Key finding:** vitest host = `America/Toronto` (not UTC, not forced) → the change is a real test-env fix aligning with the UTC Worker; no prod behaviour change. 5 gates green (tsc/lint/astro 0-0-0/**6784✓**/build). **(c)** Dead session-reminder scaffolding → **DECIDED: build**, spun out to new block **[SESSION-REMIND]** (own conv). Commits: code `5db13be6`, docs `30e5f1a`. Record: `plan/tz-model/README.md`.
