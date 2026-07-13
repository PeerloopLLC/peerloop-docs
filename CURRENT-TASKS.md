# Current Tasks — between convs

> Last refreshed 2026-07-13 (Conv 394). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [ORPHAN-BACKLOG] · 🔄 Active · Category-A+C DONE; B parked · [Opus]

`[ORPHAN-DETECT]` surfaced 118 orphaned components. Conv 392 deleted all of **Category A** (dead legacy, 74 files). Conv 393 resolved all of **Category C**: deleted 3 (`error/ErrorPage`, `leaderboard/Leaderboard`+its orphaned API, `context-actions/*`) and **wired 1** — `invite/ModeratorInvite` was a LIVE bug not debris (admin invite emails `/invite/mod/{token}`, RESEND live on staging, but no page existed → link 404'd); built `src/pages/invite/mod/[token].astro` to fix it. Conv 393 also swept **12 stray dead `.ts`** (utils/types + dead live-dir barrels). Component detector now **53** (was 118); all 5 gates green throughout.
- **Remaining — Category B (52, PARKED behind [RG-PUBLIC]):** `marketing/*` (48) + `stories/*` (2) + `testimonials/*` (2) + `creators/profiles/CreatorCard` (marketing `FeaturedCreators` dep) — the old marketing site; keep until the marketing redesign, then delete/replace. (12 dead `.ts` barrels for this parked set were deliberately LEFT with it — they'd dangle still-compiled parked orphans; `icons/icon-provenance.ts` is KEPT, it's the `prov:sweep` source-of-truth, not dead.)
- **Open — detector wiring:** once B resolves, snapshot residuals into `KNOWN_ORPHANS` and wire the detector into `/w-codecheck` as a hard gate (only NEW orphans fail). The stray dead-`.ts` cleanup is DONE (Conv 393); a `.ts` variant of the detector (scope to `src/components/**` — `src/lib/**` has worker/middleware entry points that false-positive) can be productionized then if a `.ts` gate is wanted.
- **Refs:** `.claude/scripts/codecheck-orphan-components.mjs`, `[[feedback_orphaned_components_survive_migration]]`, `.claude/skills/w-codecheck`.

### [PLATO-SEQ] · 🟢 Active work complete · 4c post-launch · [Opus]

Waypoint-sequenced PLATO API+browser test architecture. **Phases 1–4b all ✅ (Convs 379–385)** — the waypoint producers, the dependency-graph + provenance foundation (`plato:graph`), and the `plato:run` make-for-waypoints runner are built, validated, and committed; full history in git + `docs/sessions/` + `docs/as-designed/plato.md`. **Only Phase 4c remains, and it is post-launch-gated** (duplicates the Parked `[BROWSER-SMOKE-2B]` below).
- **⏳ Outstanding — Phase 4c (deferred post-launch):** the agent-driven browser walker (PLATO-ON-STEROIDS / `[BROWSER-SMOKE-2B]`) — auto-walk a pure-UI browser segment from a restored waypoint and self-verify the UI, so a full journey chains API-produced waypoints (which cross Stripe Connect / Checkout / BBB that a browser can't) with browser-verified UI segments. Do NOT resurrect Playwright E2E.
- **To resume 4c:** the reusable browser-walk mechanics (actor-switch via `POST /api/auth/dev-login`; CUT-2 enroll = signed `checkout.session` with **no `payment_intent`** via `trigger-webhook.sh stripe-direct-raw`; CUT-3 = `bbb-meeting-ended`; click-by-`ref`/late-hydration gotchas; Genesis creds) are captured in `.scratch/plato-waypoint-plan.md` and memory `[[reference_chrome_bridge_island_stale_cache]]` / `[[plato_walk_mocked_service_divergence]]`.
- **Refs:** `docs/as-designed/plato.md` § Waypoint-Sequenced Segments, `tests/plato/snapshots/README.md` § Browser-walk validation, `PLAN.md` § PLATO-SEQ, `.scratch/plato-waypoint-plan.md`, `docs/decisions/06-testing-ci.md`.

---

## 📋 Unordered backlog

### [SESSION-REMIND-DEPLOY] · ⏸️ Parked — gate: MVP-GOLIVE (prod repeat only; staging DONE Conv 388)

**Fully activated on STAGING Conv 388** — reminder columns applied (reseed), `RESEND_API_KEY` secret set on `peerloop-cron-staging`, cron worker deployed (`d95ddb91`, `*/15`). Session reminders now fire on staging instead of logging `skipped`. **Remaining (prod only, gated behind MVP-GOLIVE):** repeat both steps for production — `wrangler secret put RESEND_API_KEY --env production --config workers/cron/wrangler.toml` + `deploy:cron:prod` — when prod is unblocked. **Refs:** `workers/cron/wrangler.toml`, `src/lib/session-reminders.ts`.

### [HOME-FIXES] · standalone (deferred per-route bucket)

Deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — small issues set aside to batch later.

### [COURSES-FIXES] · standalone (deferred per-route bucket)

Same as [HOME-FIXES] but for the Courses route(s).

### [BRAND-DOCS] · standalone

Docs-wide "PeerLoop" → "Peerloop" casing sweep — **pre-existing** inconsistency (NOT Conv-369-caused), surfaced by the Conv-369 r-end docs agent: ~30 docs still carry the old casing as generic prose, mostly manual/vendor (`resend.md`, `stripe.md`, `cloudflare.md`, `matt-design-system/*`) + a few driftCheck (`url-routing.md`, `messaging.md`, `ratings-feedback.md`). BRAND-CASE (Conv 369) was scoped "UI copy only." Verify each isn't an intentional reference before bulk-replace. Low priority.

### [CBG] · standalone

Add a commit-time branch-verify guard to `/r-commit` + `/r-end`. `[RSTART-DIFFGATE]` only checks the code branch at `/r-start`; Conv 371 committed to `brian-July-7` (client's experimental branch, checked out externally mid-conv) before it was caught + moved to `jfg-dev-14`. Warn if current code branch ≠ expected/recorded before committing. Low priority. **Refs:** `.claude/scripts/conv-branch-check.sh`, `memory/feedback_git_dash_c_enforcement`.

### [BRIDGE-UPLOAD] · standalone (tooling watch)

`mcp__claude-in-chrome__file_upload` rejects filesystem paths ("MCP controller must read the file and pass contents via the `files` parameter"), but the exposed schema only has `paths` — so there is **no working browser file-upload** in a PLATO browser-run (thumbnails, avatars, homework attachments). Worked around Conv 379 by setting the course thumbnail via the app's `PUT /api/me/courses/[id]/thumbnail` (external URL, JSON). Re-test on a newer Chrome-in-Claude build; document the API-PUT fallback as the standard for file-gated browser steps. **Refs:** `memory/reference_chrome_bridge_island_stale_cache` [BRIDGE-UPLOAD]. Surfaced Conv 379.

### [BLOCKPLAN] · standalone (cleanup decision) · low priority

`CURRENT-BLOCK-PLAN.md` (docs-repo root) is an unfilled March template never used for any block — PLATO-SEQ (and prior multi-conv blocks) tracked in PLAN.md instead (Conv 382 Decision #3, PLAN.md is SoT per CLAUDE.md §Feature Tracking). Decide: adopt it consistently for multi-conv blocks, or remove it to cut surface. Low priority. Surfaced Conv 382.

### [UXQ] · standalone (harness-UX note) · low priority

`AskUserQuestion` tears down the option picker when the user selects "let me clarify" — the choices they wanted to discuss vanish. User flagged this directly Conv 385 ("it disappears just when the user says he wants to chat about it"). Workaround: re-render the options as durable prose. **Not fixable in this repo** — a CC harness behavior; keep as a watch/report-upstream note. Surfaced Conv 385.

### [DEVSRV-KILL] · standalone (tooling hygiene) · low priority

Scope ephemeral dev-server teardown to the spawned PID. Conv 393: during ephemeral `npm run dev` cleanup, a port-based kill (`lsof -ti :4321 | grep 'astro dev'`) killed a **pre-existing** astro dev on :4321 that this session did not start (my server had fallen back to :4322 because :4321 was occupied). Fix: capture the spawned PID and kill only that on teardown — never a broad `:port + astro dev` match. **Refs:** memory `feedback_persistent_dev_server_4321`. Surfaced Conv 393.

### [MEM-PRUNE] · standalone (memory hygiene) · low priority

Run `/r-prune-memory` to compact `MEMORY.md` toward the hook's ~17 KB headroom target. Conv 394 re-flattened the 8 most-bloated index pointer lines inline (20.6→19.1 KB, below the pre-conv baseline, 76% of the 25 KB SessionStart auto-load cap — no longer trips the 80% `/r-start` alert), but a full pass should re-flatten remaining bloated pointers + extract any inline-only entries into sub-files. Not near the hard cap. Surfaced Conv 394 by the MEMORY.md size hook.

### [FEEDBACK-DEPLOY] · ⏸️ Parked — gate: MVP-GOLIVE (prod repeat only; staging DONE Conv 394)

**Fully activated on STAGING Conv 394** — 3 schema columns applied to staging D1 via non-destructive `ALTER` (`email_feedback_reminder` on `users`; `feedback_reminder_student_sent_at` + `feedback_reminder_teacher_sent_at` on `sessions`; all verified present), cron worker redeployed (`deploy:cron:staging`, version `37e506d5`, `*/15`). `RESEND_API_KEY` already set on `peerloop-cron-staging` (Conv 388) → the `sendFeedbackReminders` block fires (not skipped); first-tick prediction `sessions=0` (no completed-unrated sessions in the 72h window — stale seed data correctly excluded). **Remaining (prod only, gated behind MVP-GOLIVE):** apply the same 3 columns to the prod D1 (`ALTER`, or reseed) + `deploy:cron:prod`. Mirrors [SESSION-REMIND-DEPLOY]. **Refs:** `src/lib/feedback-reminders.ts`, `workers/cron/wrangler.toml`.

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

- **[FEEDBACK-DEPLOY] ✅ STAGING DONE (Conv 394)** — activated the feedback-reminder cron on staging: applied the 3 new schema columns to staging D1 via non-destructive `ALTER` (verified present), redeployed the cron worker (`deploy:cron:staging`, v`37e506d5`, `*/15`). `RESEND_API_KEY` confirmed set → block fires (not skipped). Window check: 0 completed-unrated sessions in the last 72h (9 completed total, all stale) → next tick no-ops cleanly, no nudges to old seed data. **Note:** `db:migrate:staging` would NOT have worked — the columns are edits to the already-applied `0001_schema.sql`, so only a reseed or ALTER propagates them. Prod repeat parked behind MVP-GOLIVE (see [FEEDBACK-DEPLOY]).
- **[FEEDBACK-NUDGE] ✅ DONE (Conv 394)** — built the post-session feedback/rating reminder nudge full-stack, mirroring session-reminders. Decisions (user): **email-only** (no in-app notif → dodged a `notifications` table-rebuild migration) + **both parties** nudged independently (two per-party dedup columns). New `src/lib/feedback-reminders.ts` (`sendFeedbackReminders`: completed sessions in `(now−72h, now−1h]`, `NOT EXISTS` a `session_assessments` row for that party, per-party stamp); restored `FeedbackReminderEmail.tsx` from git; pref fan-out (`email_feedback_reminder` in schema + `email.ts`/`settings.ts`/`db/types.ts` + a Settings toggle); cron block in `workers/cron/src/index.ts`; 6 new tests + fixed 2 NotificationSettings toggle-count tests (7→8). All 5 gates green (suite 6540). Staging activation deferred to **[FEEDBACK-DEPLOY]**.
- **[PLAN-XTRACT] ✅ DONE (Conv 394, full — Plan B + Plan C)** — extracted all 10 inline PLAN.md blocks >5 KB to `plan/<slug>/README.md`; **PLAN.md 249 KB → 54 KB (−78%)**, whole file back under the 25 K-token Read limit (~13 K tokens). ROUTE-MIGRATION (58 KB) + HOME-FEED-MERGE (25 KB) status-logs archived to their existing READMEs (overlap-check first revealed the cells were *unique status log*, not README duplicates — moved, not deleted); 8 new per-block READMEs (TYPO-FDN, ROLE-STUDIOS, NAV-RETROFIT, PRIM-REGISTRY, LAYOUT-SG [own dir — distinct from `plan/layout-mode/`=[LAYOUT-MODE]], PALETTE-FDN, ROLE-SEMANTICS, combined `plan/plato/`). Section/subsection headings kept as slim pointers so `#role-semantics`/`#role-studios`/`#plato-revive`/`#plato-seq` anchors resolve; content-preservation + zero-broken-deep-link verified; docs-only (no code gates). Backups + method in `.scratch/xtract/`.
