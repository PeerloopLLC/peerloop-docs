# Current Tasks — between convs

> Last refreshed 2026-07-07 (Conv 372). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [TZ-MODEL] · standalone · [Opus]
- **Status:** ★ Phase 1 Booking slice next (Phase 0 + Phase-1 Foundation + Student + Teacher slices DONE Conv 372; 5 gates green, student slice DOM-verified).
- **Next:** Continue Phase 1 with the **remaining slices** using the established pattern (SSR → `Astro.locals.userTimezone`; islands → `useUserTimezone()`; shared `formatSessionTime`/`formatSessionDate`): **Booking** (SessionBooking mixed-zone date/time pairs + calendar day-cell off-by-one) → **Admin/mod** (SessionsAdmin, SessionDetailContent, AllSessionsTabContent, ModerationAdmin, RecordingsAdmin, …) → **Messages** (`messages/types.ts` formatMessageTime + day-bucketing) → **misc date-only stamps** (cert/created/review dates). `getNow()` client-determinism = separate gated question.
- **Why:** No per-user tz model is the root cause of the recurring TZ-display pain; **Model A** chosen (render viewer-local everywhere incl. email). Foundation + student surfaces now render stored tz.
- **Refs:** `plan/tz-model/README.md` (Phase 1 record + remaining site inventory), `.scratch/tz-audit-findings.md` (working copy).

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

- **[TZ-MODEL] Phase 1 Teacher slice (Conv 372).** Applied the established pattern to the teacher session surfaces: `TeacherUpcomingSessions` (**resolved the ⚠️ TZ-AUDIT #10 deferral marker**), `TeacherSessionsList` (date/time/dateTime/clock closures over userTz — scheduled + actual start/end + attendance clocks), `TeacherSessionsTabContent`, discover `TeacherTabContent` session time. Formats preserved; 5 gates green (6773✓). Not re-DOM-verified (mechanism DOM-proven on student slice; one scope slip caught by tsc). Remaining: Booking/Admin/Messages/misc-stamps.
- **[TZ-MODEL] Phase 1 — Foundation + Student slice (Conv 372).** Established the canonical display-threading pattern: middleware resolves `Astro.locals.userTimezone` (nav_layout precedent), shared `formatSessionTime`/`formatSessionDate` helpers (null→UTC-labelled), `useUserTimezone()` hook (hydration-safe). Converted 6 student surfaces (MySessionsTab SSR · StudentSessionsList · StudentDashboard · MyCourses · ModuleAccordion · SessionsTabContent). DOM-verified end-to-end (stored Asia/Tokyo rendered 7:00 PM vs browser Toronto 6 AM / UTC 10 AM). 5 gates green (6773✓ +8 helper tests). Remaining Phase-1 slices (Teacher/Booking/Admin/Messages) queued. Record: `plan/tz-model/README.md`.
- **[TZ-MODEL] Phase 0 — per-user timezone foundation (Conv 372).** Resolved the 2 novel sub-decisions (nullable + UTC-fallback + opportunistic login-capture; raw-IANA storage + reuse the 12-entry `COMMON_TIMEZONES` picker). Shipped across 10 files: `users.timezone TEXT` schema, `isValidTimezone()` validator, signup auto-detect (`SignupForm`→`register.ts`), Settings picker (`me/profile.ts` + `ProfileSettings` `TimezoneSelect`), exposed on `/api/me/full`→`CurrentUser`, `captureTimezoneIfMissing()` login-backfill, seed backfill (all ET, Guy→`Asia/Jerusalem` fixture). 5 gates green (tsc/lint/astro 0/0/0/6766✓/build) + local D1 re-seed verified. Phase 1 (display threading, ~40 sites) is next. Record: `plan/tz-model/README.md`.
