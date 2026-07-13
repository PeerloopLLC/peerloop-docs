# Current Tasks — between convs

> Last refreshed 2026-07-12 (Conv 392). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [ORPHAN-BACKLOG] · ★ Next · decision needed · [Opus]

The `[ORPHAN-DETECT]` script (`.claude/scripts/codecheck-orphan-components.mjs`) surfaced **~118 orphaned components** in `src/components/**` reachable from no route — the pre-Matt legacy tail left behind by the route-flip migration (whole `discover/Explore*` + community-detail-tabs/tabs families, old `courses/*` listing + detail components, `dashboard/unified/*`, etc.), far beyond the course-detail family purged in `[ORPHAN-PURGE]`.
- **Decision needed (surfaced Conv 392):** (a) **bulk cleanup** — triage + delete in batches (large, each needs a closure analysis like ORPHAN-PURGE); (b) **baseline + wire** — snapshot the 118 into the detector's `KNOWN_ORPHANS` allowlist and wire it into `/w-codecheck` as a hard gate so only NEW orphans fail; (c) leave the detector as a manual tool. NOT started — awaiting user direction.
- **Why:** big dead-code surface; the detector can't be a hard codecheck gate until the 118 are cleaned or baselined.
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

- **[ADMIN-DIPLOMA-VIS] ✅ (Conv 392)** — Surfaced the Diploma in admin (the Conv-392 walk's open gap). Admin enrollments **list + detail APIs** now return `diploma_awarded_at`; completed Enrollments rows get a **View Diploma** action → `/diploma/[enrollmentId]`; the `EnrollmentDetailContent` Status panel shows a **Diploma** field (View Diploma link + "awarded {date}"). +2 API assertions + component-mock fix. Verified live (row menu + detail panel render for `enr-david-n8n`). 5 gates green (suite 419/6794).
- **[ORPHAN-DETECT] ✅ (Conv 392)** — Built `.claude/scripts/codecheck-orphan-components.mjs`: builds the import graph over `src/**`, BFS from every `src/pages/**` route, flags `src/components/**` components reachable from no route (type/re-export imports count as edges; `KNOWN_ORPHANS` allowlist). Validated: known-live components not flagged; `discover/MemberDirectory` correctly flagged (superseded by live `members/MembersDirectory`). Surfaced **~118 pre-existing orphans** → tracked as `[ORPHAN-BACKLOG]` (not yet wired as a hard `/w-codecheck` gate pending that cleanup decision).
- **[DIPLOMA-WALK] ✅ (Conv 392)** — Live-walked all 9 Conv-391 certificate→diploma surfaces. **5 LIVE + verified** (journey stepper Diploma node, student completion notification "View Diploma", precheckout "Diploma & Teaching", teacher "your student completed" notification, creator-editor toggle removed) + the `/diploma/[id]` page. **4 ORPHANED** — `LearnTab` completion card, discover `CompletedTabContent`, `role-utils` tab label, `CourseHero` "Diploma on completion" — rendered by no route (Conv-391 grep-sweep edited dead code). Force-completed `enr-david-n8n` via admin to generate notifications live. Led to [COMPLETE-CARD] + [ORPHAN-PURGE].
- **[ADMIN-DIPLOMA] ✅ (Conv 392, investigation)** — Confirmed the user's fear: admin Certificates page is teaching-only; completed courses are visible **only** via Enrollments (status filter); **Diploma appears nowhere in admin** (no column/field/link/`diploma_awarded_at`). Fix tracked as active `[ADMIN-DIPLOMA-VIS]`.
- **[COMPLETE-CARD] ✅ (Conv 392)** — Rebuilt the orphaned LearnTab "Course complete! → View Diploma" celebration as a server-rendered Matt-styled banner on the **live** `/course/[slug]` about tab (`[...tab].astro`), gated on the same `certified` derivation the stepper uses (banner + stepper never disagree). DOM-verified live: shows for a completed student, hidden for in-progress. 5 gates green (suite 419/6793).
- **[ORPHAN-PURGE] ✅ (Conv 392)** — Deleted the confirmed-orphaned course-detail component family: **20 files** (16 components across `discover/`, `discover/detail-tabs/`, `courses/`, `courses/course-tabs/` + 4 tests). Closure analysis kept everything shared (`course-tabs/types.ts` → live community tabs, `role-utils.ts`/`discover/types.ts` → live). Left `admin-intel/AdminCourseTab.tsx` + `computeRoleTabs` as residual dead code (separate subsystem / avoid live-file churn) — to be swept by `[ORPHAN-DETECT]`. tsc/lint/astro/build/test all green.
- **[CERT-ROWSHAPE-FOLLOWUP] ✅ (Conv 392)** — Made `PUT /api/me/courses/[id]` return the fully-enriched `CourseDetail` instead of a bare row+tags. Extracted a shared `loadCourseDetail(db, courseId, creatorId)` loader from GET (all 6 joined arrays + boolean coercion) and called it from both GET and PUT — single source of truth for the shape. Removed the nested CourseEditor detail-editor's now-redundant follow-up GET (reads the enriched PUT response directly — 1 round-trip vs 2); also fixes a latent number-vs-boolean merge on `is_active`/`lifetime_access`. +1 regression test asserting PUT returns the enriched shape. 5 gates green (suite 6893). No doc drift (API-COURSES.md covers only public `/api/courses/*`).
