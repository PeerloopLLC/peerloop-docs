# Current Tasks — between convs

> Last refreshed 2026-07-12 (Conv 389). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [SESSION-REMIND-DEPLOY] · ⏸️ Parked — gate: MVP-GOLIVE (prod repeat only; staging DONE Conv 388)

**Fully activated on STAGING Conv 388** — reminder columns applied (reseed), `RESEND_API_KEY` secret set on `peerloop-cron-staging`, cron worker deployed (`d95ddb91`, `*/15`). Session reminders now fire on staging instead of logging `skipped`. **Remaining (prod only, gated behind MVP-GOLIVE):** repeat both steps for production — `wrangler secret put RESEND_API_KEY --env production --config workers/cron/wrangler.toml` + `deploy:cron:prod` — when prod is unblocked. **Refs:** `workers/cron/wrangler.toml`, `src/lib/session-reminders.ts`.

### [CERT-MASTERY-UI] · standalone (deferred feature) · [Opus]

The judgement-tier certificates — **Mastery** and **Teaching** ("able to teach") — need their own dedicated UI (user: "a different beast, needs a separate UI"). Scoped OUT of [CERT-AUTO] (Conv 389), which auto-issued only the *factual* Completion cert. The backend already exists (`me/certificates/recommend.ts` → `admin/certificates/[id]/approve.ts`, the `'mastery'`/`'teaching'` types + `teacher_certifications` upsert) — the gap is the **grant/recommend UI** (a Teacher/Creator surface to recommend a student, an admin/creator review+approve surface) and surfacing the "recommend this student" action on completed enrollments. **Also fold in:** centralize the `Certificate` row shape — [CERT-AUTO] added the canonical `Certificate` interface to `db/types.ts` but 4 endpoints (`admin/certificates/index.ts`, `me/certificates.ts`, `ssr/loaders/verify.ts`, `api/certificates/[id]/verify.ts`) still redefine it inline. **Refs:** `docs/requirements/GOALS.md` GO-011, `src/lib/certificates.ts`. Surfaced Conv 389.

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

- **[DIPLOMA] De-conflated course-completion (Diploma) from teach-readiness (Certificate) ✅ (Conv 389).** First cut auto-issued a completion *certificate* ([CERT-AUTO]); user reframed — the original credential was teach-readiness, a completion shouldn't be a certificate → **reshaped** into two concepts. **(1) Diploma = completion** (factual, auto): no table — derived from the completed enrollment (`status='completed'` + new `enrollments.diploma_awarded_at` marker), rendered `/diploma/[enrollmentId]`, counted in `user_stats.courses_completed`. **(2) Certificate = teach-readiness**: `certificates.type` CHECK → `('teaching')` only (retired completion/mastery); recommend→approve→`teacher_certifications`; `/certificates/[id]` + email reworded to teaching. New `src/lib/completion.ts::onEnrollmentCompleted` (idempotent hook: courses_completed + students_taught + notification + `DiplomaEmail`) wired into **all 3** completion paths (progress / force-complete / booking session path — replaced its inline block). Deleted `certificates.ts`; new `DiplomaEmail.tsx`; seed + PLATO + ~9 cert test files updated. **5 gates green (suite 6886)**; Diploma + Teaching-cert pages DOM-verified vs reseeded local D1 (0 completion certs). Docs (GLOSSARY/resend) + memory updated. **Parked → [DIPLOMA-UI]** (/learning Diplomas display + cosmetic cleanup).
