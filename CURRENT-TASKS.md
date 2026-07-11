# Current Tasks — between convs

> Last refreshed 2026-07-11 (Conv 386). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

Waypoint-sequenced PLATO API+browser test architecture. **Phase 1 ✅ Conv 379**; **Phase 2 ✅ Conv 380–381**; **Phase 3 ✅ Conv 383–384**; **Phase 4a (graph + registry + provenance) ✅ + Phase 4b (`plato:run` make-for-waypoints) ✅ Conv 385**; **only Phase 4c (agent-driven browser walker, `[BROWSER-SMOKE-2B]`) remains — deferred post-launch.**
- **Status (Conv 384 — `ecosystem` browser re-walk COMPLETE + validated):** restored `ecosystem-pre-12` → ephemeral dev server → walked the multi-actor journey (register Sarah/Marcus/Jennifer; book Sarah's 3 sessions — session 1 via the **full real-UI calendar** flow; certify Sarah + self-cert course-1). Bridges: **CUT-2 ×3** enroll (direct-signed Stripe `checkout.session.completed` via `trigger-webhook.sh stripe-direct-raw`, metadata `instructor_type:creator`, **no `payment_intent`** → 0 transactions/splits, matching the producer's mock), **CUT-3 ×3** completion (BBB `bbb-meeting-ended`). Captured `ecosystem-walk.sqlite`; **69/70 tables row-identical to `ecosystem.sqlite`; all 7 verify assertions pass; `user_stats` matches (0/0/0·3/1/0·3/0/1).**
- **⚠️ Validation methodology (Conv 384): the row-identity bar EXCLUDES `notifications`** — the API producer mocks all `notify*` silent (0 rows) while the live server writes them for real (walk=20). No bridge reconciles it; it is irreducible, so exclude it from the per-table diff. **The Conv-383 `activities` "70/70 identical" claim was INACCURATE** — `activities-walk.sqlite` actually diverges from its oracle on `notifications` (0 vs 6) AND `user_stats` (3 vs 1); the 8 assertions passed but never check those two tables (true bar was ≈ 68/70). **Re-walked Conv 384 with the fix → `activities-walk.sqlite` now matches 69/70 (only `notifications` excluded); all 8 assertions pass.**
- **Prod bug fixed (Conv 384, [PSA-WAITUNTIL] ✅):** `triggerPostSessionActions` (user_stats increments + completion notifications) was fire-and-forget at `booking.ts:171` → dropped on Worker teardown → **`user_stats` never updated after a live BBB `room_ended` webhook**. Fixed via an optional `waitUntil` param on `completeSession`, threaded through both BBB webhook paths (`await` fallback for the other 5 callers). 5 baseline gates green. This made **both** `ecosystem` and `activities` (re-walked Conv 384) user_stats match the oracle.
- **Phase 4a ✅ (Conv 385) — dependency graph + registry + provenance foundation.** The latent `restoreFrom`/`snapshot`/`capturesTo` edges are assembled into one validated topo-sorted DAG (`tests/plato/lib/waypoint-graph.ts`) with a **transitive-closure source hash** per waypoint (producer instance + scenario + every chain step + persona + schema, unioned with parents). CLI `npm run plato:graph` (tsx) with **two clocks** (runs are infrequent): `generate`→committed `tests/plato/snapshots/manifest.generated.json` (Clock 1 `graphSourceHash`), `check`, `status`→per-waypoint last-produced age + FRESH/STALE/MISSING (Clock 2). Provenance = **gitignored JSON sidecar** `<wp>.sqlite.prov.json` (per-machine; `.sqlite` stays byte-clean for the row-identity diff), auto-stamped on API snapshot-save + browser `plato:capture`. 6 unit tests lock the edges + transitive-staleness property. Files: `tests/plato/lib/{waypoint-graph,waypoint-provenance}.ts` + `.test.ts`, `scripts/plato-graph.ts`, wired `plato-scenarios.api.test.ts` + `plato-capture.js`, `.gitignore`, `package.json`.
- **Phase 4b ✅ (Conv 385) — the Segments runner (`npm run plato:run`, make-for-waypoints).** Reads the 4a graph + Clock-2 verdicts, regenerates only STALE/MISSING waypoints (skips FRESH) in topo order: `--chain <prefix>` (one journey), `--from-waypoint <w>` (+ transitive descendants), `--force`, `--dry-run`. Regenerates each via the dynamic API runner (`PLATO_INSTANCE=<producer> vitest …`) which stamps a fresh sidecar. Semantic: API producers full-replay from the seed so `--from-waypoint` = regenerate-downstream, not restore+continue (that's Phase 4c). Pure planning logic unit-tested (4 tests); verified live (regenerated the flywheel chain → all FRESH). Files: `scripts/plato-run.ts`, `tests/plato/lib/waypoint-status.ts` + `.test.ts`, `package.json`; `plato-graph.ts` status refactored onto shared `computeStatuses`.
- **Next — Phase 4c (optional, deferred post-launch):** the agent-driven browser walker (`[BROWSER-SMOKE-2B]` / PLATO-ON-STEROIDS) — auto-walk a browser segment from a restored waypoint + self-verify the UI. With 4a+4b done, the PLATO-SEQ block's active work is complete; 4c is parked behind the post-launch gate.
- **▶ Reusable browser-walk mechanics (Conv 383–384):** actor-switch = `POST /api/auth/dev-login {email}` + `localStorage.clear();sessionStorage.clear()` + hard nav; register a NEW user via `POST /api/auth/register {email,password,name,timezone}` (row-faithful — 1 `users` row, no stats/progression); **CUT-2 enroll** = pipe a `checkout.session` JSON (metadata: `pending_enrollment_id`/`student_id`/`course_id`/`creator_id`/`instructor_type:creator`/`teacher_certification_id`/`assigned_teacher_id`, **NO `payment_intent`**) to `./scripts/trigger-webhook.sh stripe-direct-raw checkout.session.completed -`; **CUT-3** = `SESSION_ID=<id> ./scripts/trigger-webhook.sh bbb-meeting-ended`; booking via `POST /api/sessions {enrollment_id,teacher_id,scheduled_start,scheduled_end}` (distinct increasing starts → deterministic module 1/2/3 freeze); certify / add-teacher-cert via `POST /api/me/courses/[id]/teachers {user_id}` as the creator; live miniflare D1 read via `sqlite3` (WAL-safe with server up); **click by `ref` from `find`** (screenshot px ≠ CSS px, ~1.055 scale), islands hydrate late → first ref-click can no-op, re-click. Genesis creds: Alex `alex.rivera@example.com`/`AlexRivera123`, Mara `mara.chen@example.com`/`MaraChen123`.
- **Why:** a pure browser-run can't cross Stripe Connect / Checkout / BBB; chaining API-produced waypoints + browser-verified pure-UI segments is the fix.
- **Refs:** `docs/as-designed/plato.md` § Waypoint-Sequenced Segments, `tests/plato/snapshots/README.md` § Browser-walk validation, `PLAN.md` § PLATO-SEQ, `.scratch/plato-waypoint-plan.md`.

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

### [HW-SUBMIT-UI] · standalone (Matt-port regression) · [Opus]

**REGRESSION found Conv 383** during the PLATO `activities` browser re-walk: the **student-facing homework SUBMISSION UI has no live route.** `src/components/learning/HomeworkTab.tsx` (where Conv 345 built the file-upload submission form) is only reachable via `components/courses/LearnTab.tsx` → `CourseTabs.tsx`, and **CourseTabs is mounted by no page** — the current Matt course page `src/pages/course/[slug]/[...tab].astro` (Conv 166 route-flip) + `_course-tabs.ts buildCourseTabs` expose About/Course Feed/Meet the Creator/Teachers/Reviews/Resources/Modules (+ session funnel), no Learn/Homework tab; `StudentDashboard` + `/learning/[sessions|overview]` have none either. So an enrolled student can't submit homework through any UI (the **creator** side — create homework via `/creating/studio` Homework tab — works). Fix: add a Homework/Learn tab to `buildCourseTabs` + render `HomeworkTab` (needs `courseId`+`enrollmentId`) in `[...tab].astro`, or otherwise re-home the form — part of the broader Matt port-functionality obligation (DISC-DROP). **NOVEL UI decision (which tab, where) → surface options before building.** Walk workaround: API bridge `POST /api/homework/[id]/submit`. **Refs:** `src/components/learning/HomeworkTab.tsx`, `src/components/courses/{LearnTab,CourseTabs}.tsx`, `src/pages/course/[slug]/[...tab].astro`, `_course-tabs.ts`, memory `feedback_port_functionality_and_styling`.

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

- **[XTZ] Cross-timezone booking walk + codify ✅ (Conv 386).** Live cross-tz browser walk (teacher LA / student Tokyo) confirmed all three goals — student sees availability in their own tz + books the UTC-midnight-crossing slot; notifications/emails/reminders/messages render per-role tz; day-of UI (student SSR + teacher dashboard) shows each their local time. **Found + fixed a real bug:** the course-hero "next session" time rendered in the *browser* tz (and date-only server-tz on `success`/`book`) instead of the stored `users.timezone` — new shared `formatSessionRelativeWhen` helper renders it server-side in stored tz across all 3 hero pages (`[...tab]`/`success`/`book`), browser-tz `<script>` removed; live-verified. **Codified** (5 test files): +8 unit (`timezone.test.ts`), +1 API booking notif/email per-recipient (`sessions/index.test.ts`), + cross-role day-of component (new), + messages viewer-tz (new), + integration boundary+`users.timezone` (`session-timezone.test.ts`). All 5 gates green (tsc/astro-check/lint/build + full suite **6849/6849**). Refs `.scratch/xtz-walk-findings.md`.
