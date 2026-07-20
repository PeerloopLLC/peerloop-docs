# Current Tasks — between convs

> Last refreshed 2026-07-20 (Conv 398, r-end). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [MERGE-BRIAN-JULY7] · ⏸️ ON HOLD — gate: user's conversation with the client · [Opus]

**HOLD (Conv 396, user's call):** integration discussion is suspended until the user has talked to Brian about the **why** and the **what** of his changes. User's position: *"I wanted the client to explore, but I am not going to keep all that he has done. I have to see its impact first and he has to explain his intentions… He is not in a position to know if they are destabilizing changes."* → Do **not** transfer files, plan batches, or re-open the merge-mechanism debate until that conversation has happened. Assessment findings below are complete and durable; resume from them.

**🚦 THE ADMISSION GATE (user's framing, Conv 396 — every file passes this before entering `jfg-dev*`).** New-ness is not a pass; novelty of a file says nothing about its blast radius. Three questions:
1. **Destabilizing?** Do these changes break the Peerloop app?
2. **Structural dependency?** Do they imply changes to structure other parts depend on — *in particular reporting, messaging, notification, and admin counterparts*?
3. **Style-guide conflict?** Do they negate the current style guide — and if so, do we want to adopt them?

**Gate-probe results so far (Conv 396, partial — Gate 1 not yet run):**
- **Gate 2 — the user's instinct was correct, verdict this time benign.** The `Teachers → Peer Teachers` relabel did NOT stay in course UI: it reached **`admin/AdminDashboard.tsx`, `admin/TeachersAdmin.tsx`, `analytics/CoursePerformanceTable.tsx`, `layout/AdminNavbar.tsx`, and the API endpoint `src/pages/api/admin/analytics/users.ts`** — i.e. reporting + admin counterparts, exactly the named concern. **On inspection it is display-string only:** the endpoint changes `{ name: 'Teachers' → 'Peer Teachers' }` while the SQL field `teacher_certifications` is untouched; `CoursePerformanceTable` is a `<th>` label. **Nothing keys off the literal** (`git grep "=== 'Teachers'"` → 0) and the sole consumer is `AdminAnalytics.tsx`, which renders `name` as a chart label. So: the gate correctly flagged it, and it passes. **Messaging / notifications / email are untouched** — zero files matched `notif|messag|email`. The `[COMM-BRAND]` schema change is **additive** (`ADD COLUMN accent_color, logo_url`), the low-risk shape.
- **Gate 3 — one systemic miss, token conformance mostly fine.** All **7 of his new `src/` files carry NO provenance marker** (`TeachersTabList.tsx`, `CourseCoverPanel.tsx`, `CommunityBand.tsx`, `CourseMiniHeader.tsx`, `community-branding.ts`, `logo.ts`, `[...key].ts`) — violates CLAUDE.md §Page Provenance (exactly one of `@stand-in` / `@matt-source` / `@matt-inspired`). Design-token conformance is **better than expected**: `CommunityBand.tsx` and `CourseMiniHeader.tsx` have zero hardcoded colors or arbitrary px; only `CourseCoverPanel.tsx` deviates (2 hex `#0e3a5c`/`#0b2740` + arbitrary `[180px]`/`[120px]`/`[10px]`). Not systemic — a specific, small fix.
- **Gate 1 — NOT YET MEASURED.** Mechanical when wanted: apply his tree to a scratch branch and run all 5 gates. Also unknown and cheap: **does his own branch pass the 5 gates?** Known destabilizer already in hand: the `CourseTabs.tsx` modify/delete below.

**Questions the conversation needs to cover** (derived from the findings below): why the course-tab architecture was rebuilt on a component we had deleted; what the `[COMM-BRAND]` schema addition is for; whether the hidden-but-retained surfaces (Popular Courses carousel, role tabs, Meet-the-Creator/Reviews/Resources tabs, photo backdrops) are meant to come back; and — since several commits cite *"approved Option B"* / *"approved interactive mockup"* — **ask him for those mockups and option write-ups**, because they exist only in his own chat sessions and are the sole record of his reasoning (see docs-repo finding).

Assess the client's `brian-July-7` branch for impact, then integrate what's worth keeping into `jfg-dev-14`. **Discard nothing without review** — the user's standing instruction is that the work may be very good for Peerloop; be methodical and diligent. The client has said he wants to **discuss the work soon**, so an assessment should be ready before that conversation. Scope will likely grow — the user expects to add to this task.

- **Working model of the client (user's framing, Conv 396):** Brian is not a coder and drives his own CC instances. Treat him as a peer recipient of the *same* expert suggestions CC gives the user — with **one exception**: his directives are issued without regard to downstream codebase consequences, whereas the user's are framed with the codebase in mind and the user can course-correct interactively. So client-originated changes need a consequence audit that user-originated ones don't.
- **Branch state (measured Conv 396):** merge-base `c50afd82` (Conv 370, 2026-07-07). **53 commits ahead, 52 behind** `jfg-dev-14`. **66 files**: `src/components` 34, `src/pages` 14, `public/images` 6, `src/lib` 4, `public/demo-logos` 3, plus `src/layouts/AppLayout.astro`, `scripts/seed-feeds.mjs`, `migrations/0005_community_branding.sql`, `migrations-dev/0001_seed_dev.sql`, `.gitignore`. All 53 authored **`brian@peerloop.com`** — confirmed genuinely the client's, *not* CC work stranded by the Conv-371 wrong-branch incident.
- **🔴 NOT UI-only** (contradicts the working assumption): the branch carries a **new schema migration** `migrations/0005_community_branding.sql` (`ALTER TABLE communities ADD COLUMN accent_color TEXT, logo_url TEXT`) plus a new module `src/lib/community-branding.ts`, edits to `src/lib/ssr/loaders/{courses,communities}.ts`, `src/lib/mock-data.ts`, and the dev seed. Schema + SSR loaders + seed = real consequence surface. Note `0005` is a **filename collision risk** — `jfg-dev-14` has no `0005`, so it merges cleanly *today*, but any `0005_*` we author before merging collides. See CLAUDE.md §Schema Discrepancy Discipline before touching it.
- **Conflict surface — 17 files changed on BOTH branches:** `src/components/courses/{CoursesCatalog,CoursesFilters,CourseTabs}.tsx`, `src/components/creators/studio/CourseEditor.tsx`, `src/components/entity/CourseHeader.tsx`, `src/components/layout/AdminNavbar.tsx`, `src/components/teachers/profiles/TeacherProfile.tsx`, `src/lib/mock-data.ts`, `src/lib/ssr/loaders/courses.ts`, `src/pages/api/admin/analytics/users.ts`, `src/pages/course/[slug]/{_course-tabs.ts,[...tab].astro,book.astro,success.astro}`, `src/pages/index.astro`, `migrations-dev/0001_seed_dev.sql`, `.gitignore`.
- **Themes on the branch** (client's own `[CODE]`s): `[COVER-STORY]`/`[COVER-STORY-MIRROR]` catalog+detail hero rework · `[TAB-SCROLL]`/`[TAB-FLOAT]`/`[TAB-COMPACT]`/`[TAB-OWNS-PAGE]` course-tab architecture · `[COMM-BRAND]` community branding (the schema change) · `[TCH-SEARCH]` · "Teachers"→"Peer Teachers" relabel sweep · bespoke SVG course covers · hidden-but-code-retained surfaces (Popular Courses carousel, role tabs, Meet-the-Creator/Reviews/Resources tabs, photo backdrops).
- **🟠 Conv-number collision:** his CC numbers convs too — `brian-July-7` carries commits labelled "Conv 371/372/373/374/375", which are *different work* from our Convs 371–375. Breaks the same-number-in-both-repos traceability invariant (CLAUDE.md §Conv Lifecycle) and will confuse commit archaeology + the timecard skills.
- **⛔ Gate before any merge:** **[TC-MERGE-TZ]** (Parked) — Brian commits from **CST**, Fraser from **ET**; a history-preserving merge imports his commits into `jfg-dev-14`'s daily timecard buckets. Resolve merge strategy (author filter / `--squash` / tz offset) *first*.
- **📊 Timecard contamination MEASURED (Conv 396, empirical — `node .claude/scripts/timecard-day.js <date>`):** `brian-July-7` is a **local** branch, so `discoverCandidateBranches()` already sweeps it every run. Confirmed contaminated days: **07-07 (6 of his commits in the audit table, absorbed into our real Conv 371 bucket, `isAdHoc:false`), 07-08, 07-09, 07-11 (1 each)**. **Billable-minute delta on every one of those days = 0m** — his commits landed *inside* windows our own commits already bounded, so to date the damage is **cosmetic** (audit table + Block attribution), not financial. That is luck, not design: a commit of his outside our window would extend it. **07-17/07-18 (19 commits) produced a 0m timecard** — no conv heartbeat of ours on those dates, so no window was anchored at all.
- **⚠️ Conv-number collision is the mechanism:** timecard buckets anchor on docs-repo heartbeats (`^Conv (\d{3}) start —`) and match code commits via `^Conv (\d{3})[:\s]`. His commits carry the *same* prefixes. He collides only when his conv number **and** date coincide with ours — 07-07 (his "Conv 371" ↔ our Conv 371 heartbeat) is the confirmed hit; his other conv-prefixed days missed by date and were silently skipped.
- **🟠 `--exclude-branches` is CLI-only and effectively inert:** parsed at `timecard-day.js:64/70`, used once at `:1586`, **no persistent config default** — so no routine timecard run passes it. It *works* when passed (07-07: 6 of his commits → 0 extracted), but nobody remembers a flag. **Branch exclusion also dies at merge time** — once `brian-July-7` lands in `jfg-dev-14` his commits are on our branch and branch-filtering can no longer see them. **Author-based exclusion (`brian@peerloop.com`) is the only filter that survives the merge.**
- **✅ Docs repo is CLEAN of client commits (verified Conv 396).** `peerloop-docs` has **one** branch (`main`), **1205 commits, every one authored *and* committed `Fraser Gorrie <fraser@meristics.com>`**; `--author=brian@peerloop.com` returns 0 across `--all`. **So the client did NOT use the dual-repo architecture** — he worked code-only. Three consequences: (1) his `Conv NNN` labels have **no heartbeat commits**, which is why `timecard-day.js` silently skipped most of his days (only same-date collisions like 07-07 got through); (2) there are **no session docs, no PLAN.md entries, no RESUME-STATE narratives** for any of his work — his *rationale exists nowhere in git*, only in his own chat sessions; (3) his commit messages cite *"approved Option B"* / *"approved interactive mockup"* / *"approved mockup"*, so decision artifacts exist on his side and must be **requested from him**, not reconstructed.
- **🔴 Biggest integration question — `CourseTabs.tsx` modify/delete (found Conv 396).** Conv 392 `cfcfc8af` [ORPHAN-PURGE] **deleted 16 orphaned course-detail components**, `CourseTabs.tsx` among them (389 lines), as confirmed-dead after `/old` routing was retired (Conv 339). The client forked at Conv 370 — *before* the purge — and built **8+ commits of tab architecture on top of it** (`[TAB-SCROLL]`, `[TAB-FLOAT]`, `[TAB-COMPACT]`, `[TAB-OWNS-PAGE]`). Both determinations were locally correct; nothing routed to it on our branch, it was the centerpiece on his. **This is a design question, not a merge conflict** — no per-hunk resolution answers it: does his tab architecture supersede the Matt `/course/[slug]` page, or does the *intent* get ported onto the page we kept? Likely carries more work than the other 65 files combined. **Expect more of this class** — his branch predates the purge entirely, so anything built on the other 15 deleted components has the same shape. An exhaustive survey of that class was offered and *not yet run* (deferred by the hold).
- **🔬 Merge dry-run (`git merge-tree`, Conv 396) — far less conflict than feared.** Of the 17 both-touched files, **12 auto-merge cleanly**; only **5** need real resolution: `CourseTabs.tsx` (modify/delete, above), `CoursesCatalog.tsx`, `CoursesFilters.tsx`, `CourseHeader.tsx`, `src/pages/course/[slug]/[...tab].astro`. The other **49 of 66 files are his-only** and transfer with zero risk.
- **🧭 Integration mechanism — reasoned through Conv 396, no decision taken (hold).** Direction of travel: **keep git as the transfer vehicle, drive it per-theme.** Hand-moving files was considered and argued against — `git checkout brian-July-7 -- <file>` is a *wholesale overwrite*, not a merge, so on the 17 shared files it silently discards our side; it would trade 5 genuine reconciliations for 17 manual ones with invisible-work-loss as the failure mode. **Batch unit = theme, sized so each commit passes all 5 gates** (his themes cut across schema + lib + loaders + components; a half-transferred theme won't build). A **worktree of `brian-July-7` is still wanted — but to *run* his branch and compare behavior, not as the transfer path** (`git show brian-July-7:<path>` reads any file without one); same role `Peerloop-preflip` plays. **Squash (no history) remains required**, and is now load-bearing for the timecard fix: the `^jfg-dev` allowlist stops working the instant his commits land on a `jfg-dev*` branch with history preserved. Caveat to honor: `--squash` records no merge parent, so he must **abandon `brian-July-7` after handoff** and start from the branch we deliver, or every subsequent squash re-presents old changes as new conflicts.
- **Refs:** branch `origin/brian-July-7`, `[TC-MERGE-TZ]` (Parked, below), CLAUDE.md §Schema Discrepancy Discipline, `[[project_jfg_dev_branches_are_snapshots]]`, `[[project_preflip_worktree_reference]]`, Conv 392 `cfcfc8af`. Surfaced Conv 396.

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

### [BRIDGE-UPLOAD] · standalone (tooling watch)

`mcp__claude-in-chrome__file_upload` rejects filesystem paths ("MCP controller must read the file and pass contents via the `files` parameter"), but the exposed schema only has `paths` — so there is **no working browser file-upload** in a PLATO browser-run (thumbnails, avatars, homework attachments). Worked around Conv 379 by setting the course thumbnail via the app's `PUT /api/me/courses/[id]/thumbnail` (external URL, JSON). Re-test on a newer Chrome-in-Claude build; document the API-PUT fallback as the standard for file-gated browser steps. **Refs:** `memory/reference_chrome_bridge_island_stale_cache` [BRIDGE-UPLOAD]. Surfaced Conv 379.

### [BLOCKPLAN] · standalone (cleanup decision) · low priority

`CURRENT-BLOCK-PLAN.md` (docs-repo root) is an unfilled March template never used for any block — PLATO-SEQ (and prior multi-conv blocks) tracked in PLAN.md instead (Conv 382 Decision #3, PLAN.md is SoT per CLAUDE.md §Feature Tracking). Decide: adopt it consistently for multi-conv blocks, or remove it to cut surface. Low priority. Surfaced Conv 382.

### [UXQ] · standalone (harness-UX note) · low priority

`AskUserQuestion` tears down the option picker when the user selects "let me clarify" — the choices they wanted to discuss vanish. User flagged this directly Conv 385 ("it disappears just when the user says he wants to chat about it"). Workaround: re-render the options as durable prose. **Not fixable in this repo** — a CC harness behavior; keep as a watch/report-upstream note. Surfaced Conv 385.

### [DEVSRV-KILL] · standalone (tooling hygiene) · low priority

Scope ephemeral dev-server teardown to the spawned PID. Conv 393: during ephemeral `npm run dev` cleanup, a port-based kill (`lsof -ti :4321 | grep 'astro dev'`) killed a **pre-existing** astro dev on :4321 that this session did not start (my server had fallen back to :4322 because :4321 was occupied). Fix: capture the spawned PID and kill only that on teardown — never a broad `:port + astro dev` match. **Refs:** memory `feedback_persistent_dev_server_4321`. Surfaced Conv 393.


### [FEEDBACK-DEPLOY] · ⏸️ Parked — gate: MVP-GOLIVE (prod repeat only; staging DONE Conv 394)

**Fully activated on STAGING Conv 394** — 3 schema columns applied to staging D1 via non-destructive `ALTER` (`email_feedback_reminder` on `users`; `feedback_reminder_student_sent_at` + `feedback_reminder_teacher_sent_at` on `sessions`; all verified present), cron worker redeployed (`deploy:cron:staging`, version `37e506d5`, `*/15`). `RESEND_API_KEY` already set on `peerloop-cron-staging` (Conv 388) → the `sendFeedbackReminders` block fires (not skipped); first-tick prediction `sessions=0` (no completed-unrated sessions in the 72h window — stale seed data correctly excluded). **Remaining (prod only, gated behind MVP-GOLIVE):** apply the same 3 columns to the prod D1 (`ALTER`, or reseed) + `deploy:cron:prod`. Mirrors [SESSION-REMIND-DEPLOY]. **Refs:** `src/lib/feedback-reminders.ts`, `workers/cron/wrangler.toml`.

### [RSYNC-GATE] · standalone (skill infra) · surfaced Conv 395

`/r-start` **Step 5.7 Phase 2**'s `rsync -a --delete "$MIRROR/" "$LIVE/"` was **DENIED by the auto-mode classifier** ("Irreversible Local Destruction" — the destructive call sits immediately after a diff-gate whose result is an unseen tool result, so it "may proceed past its own intended confirmation gate"). **This will RECUR every conv** — it's a structural property of the step's shape, not a one-off. Conv 395 impact was nil (Phase 1 returned 0 changes → the rsync was a provable no-op; verified out-of-band with an independent `diff -rq` and **skipped, not forced**), but on a conv where the mirror genuinely differs the block lands mid-`/r-start` and **the memory sync doesn't happen**.
- **Options to evaluate:** (a) move Phase 2 into a named script (`conv-memory-sync.sh`) whose shape reads as intentional rather than a raw `--delete`; (b) have Phase 1 write a decision sentinel Phase 2 checks, making the gate legible; (c) document the expected block in the skill so CC handles it deterministically instead of improvising; (d) a project `settings.json` Bash allow-rule for the specific invocation.
- **Note the asymmetry:** `/r-commit` Step 1.5 + `/r-end` Step 5b run the same rsync in the **safe** direction (live→mirror) and were **not** blocked. Only mirror→live is sensitive.
- **⚠️ CONFIRMED RECURRING (Conv 396).** Second occurrence — the block fired again at Conv 396's `/r-start`, same shape, same skip. Conv 396 was again harmless (Phase 1 returned a 0-change diff → provable no-op → verified out-of-band and skipped). Two clean convs in a row means the *first* conv with a genuinely-differing mirror is the one that silently loses the sync — so fix it before that lands, not after.
- **🔻 CORRECTION (Conv 397) — it is INTERMITTENT, not "every conv".** The rsync ran **without any block** at Conv 397's `/r-start`. The earlier claims ("this will RECUR every conv — it's a structural property of the step's shape"; "now evidence, not prediction") are **falsified** and should not be relied on. Intermittent is **worse than reliable** for this failure mode: a block that fires every time gets noticed and handled, whereas one that fires 2 convs in 3 invites the assumption that a silent pass means the sync happened. The fix case is unchanged and slightly strengthened — the options (a)–(d) below all still apply, and none of them depend on the block being deterministic.
- **Refs:** `.claude/skills/r-start/SKILL.md` Step 5.7 Phase 2, `[[feedback_msi_sync_user_checkpoint]]`.

### [SCRATCH-DEBRIS] · standalone (cleanup) · trivial · surfaced Conv 395

`.scratch/conv-tasks.md` still exists on MacMiniM4Pro despite being explicitly **retired by [CURTASKS] (Conv 351)** — `CURRENT-TASKS.md` replaced it, and `/r-start` Step 7.5 states the companion + its no-shrink reconciliation guard are retired. Verify nothing reads it (grep the skills), confirm it isn't machine-local state anyone depends on, delete. `.scratch/` is gitignored + machine-local, so MacMiniM4 may hold its own copy. **Refs:** `[[feedback_current_tasks_persistence]]`.

### [RSFD] · standalone (skill infra) · low priority · [Opus]

Port spt-docs' `/r-start-from-dirty` (retroactively wrap an already-dirty tree in a tracked Conv, for when `/r-start` was forgotten). **Conv-395 dependency audit: it is NOT a file copy.** Three deps are missing here — (1) `conv-start-core.sh` (peerloop's `/r-start` does increment/heartbeat **inline** at Steps 3/4/5, so there's no shared core to call); (2) `r-health.js`; (3) `event.js` + `.conv-events.jsonl` — **Peerloop has no event-log capture system at all**, and the skill's Step 6 retro-fire (which its own Rules call "the whole point") depends on it entirely. **Blocking decision before any build: does Peerloop want an event log?** Without one, a port just increments a counter over a dirty tree and the session's reasoning is still lost. Peerloop also has substrate spt lacks that a from-dirty variant must consciously handle: Step 0 `conv-session-lock.sh` (Conv 293), Step 5.6 `conv-branch-check.sh` (Conv 297), the ~150-line Step 5.7 memory sync. **Refs:** `~/projects/spt-docs/.claude/skills/r-start-from-dirty/SKILL.md`, `[[feedback_skill_sync_same_name_divergence]]`. Surfaced Conv 395.

### [MEM-PRUNE] · 🔁 Recurring watch · receded (70%, below the 80% trigger)

**Threshold-triggered, never "done"** — the standing watch is `[MEM-CAP]` in PLAN.md. Fires when `MEMORY.md` auto-load utilization crosses **80%** of the 200-line / 25 KB SessionStart cap on either axis (`/r-start` Step 5.7 Phase 2 emits the 🔴🔴🔴 alert); recedes below it. Remedy is **`/r-prune-memory`** — **NOT** `/r-prune-claude`, a different file with different cap mechanics.
- **Utilization log:** Conv 211 baseline 53% lines / 73% bytes → tripped 80% bytes Conv 213 → Conv 394 inline re-flatten 20.6→19.1 KB → Conv 395 hit 79% (two new memories) → **Conv 396 full run: 20304 B (79%) → 17979 B (70%), 127 → 124 lines (62%).**
- **Conv 396 run notes (for the next firing):** label-normalization (c) was a **no-op** — all pointers already use `[link]` since Conv 394, so don't budget for it. The biggest single win was **not** a pointer: the 5-line intro blockquote (910 B) duplicated `CLAUDE.md §Memory`, which is *always* loaded anyway → compressed to a one-liner for −760 B at zero information loss. **That lever is now spent.** 12 bloated pointers were re-flattened; the remaining ones are mostly ≤250 B, where the ~190 B pointer floor makes re-flattening low-yield. **Next firing will likely need extraction (a) or sub-file consolidation**, not more trimming.
- **Refs:** `.claude/skills/r-prune-memory`, PLAN.md `[MEM-CAP]` (line ~102), `[[feedback_memory_index_load_bearing]]`.

### [TURNLOG] · standalone (workflow guard) · surfaced Conv 396

`.scratch/conv-turns.md` went **unmaintained for an entire conv** — CLAUDE.md §Conversation Turn Log requires prepending an entry at the end of *every* turn; Conv 396 wrote only Turn 1 (via `/r-start` Step 7.7) and turns 2–11 were reconstructed retroactively at `/r-end` COLLECT (the file now carries a "reconstructed" banner). **The failure is silent** — nothing verifies the file, and the user keeps it open in VS Code expecting a live log, so a *stale* file is worse than an absent one. Same **printed-but-not-verified** class that [CBG] fixed for branches: the rule is clear, nothing enforces it.
- **Options to weigh:** (a) a Stop-hook checking whether `conv-turns.md` grew this turn — but note CLAUDE.md prefers **structural prevention over post-hoc detection**, and the QLINT Stop-hook was *retired* for exactly that reason (Conv 273), so this is the weakest option despite being the obvious one; (b) fold turn-logging into an already-mandatory step so it can't be skipped independently; (c) accept retroactive reconstruction at `/r-end` as the real contract and rewrite the CLAUDE.md rule to match, dropping the every-turn claim.
- **Refs:** CLAUDE.md §Conversation Turn Log, `[[feedback_option_phrasing]]` (QLINT retirement precedent), `.claude/skills/r-start/SKILL.md` Step 7.7.

### [EDITSAFE] · standalone (CC discipline) · surfaced Conv 396

Three self-inflicted edit errors in one conv, **one common cause**: programmatic rewrites of structured markdown/JSON without anchoring on a uniquely-identifying match. All three were caught only by reading the result back — no guard fired.
- **(1) JSON round-trip destroyed formatting.** `JSON.stringify(config, null, 2)` to add ONE key reformatted all of `.claude/config.json` — **461 insertions / 129 deletions**, wiping hand-formatting (blank-line grouping, compact one-line objects). Reverted; redone as a 3-line `Edit`.
- **(2) Ambiguous marker matched the wrong occurrence.** A python `str.replace(marker, row+marker, 1)` inserted a task row into `CURRENT-TASKS.md`'s **header prose**, because the literal `> ## ⏸️ PARKED` appears twice — once as documentation in the format note, once as the real divider.
- **(3) Status change deleted data.** Moving a recurring-watch task to `## ✅ Completed this conv` removed its backlog row entirely, leaving the standing trigger unrepresented.
- **Candidate rule:** prefer `Edit` with a unique anchor over python/sed/serializer rewrites on `.claude/config.json`, `CURRENT-TASKS.md`, `PLAN.md`, `MEMORY.md`; for JSON specifically, **never round-trip through a serializer to change one key**. Decide whether this lands in CLAUDE.md or as a memory.

### [A11Y] · 🔄 Active — linter ADOPTED Conv 399; triage the 100 warnings incrementally

**Permanent a11y linter adopted (Conv 399).** `eslint-plugin-jsx-a11y@6.10.2` wired into `eslint.config.js` at **warn** for `.tsx` (recommended set) + `.astro` (via `eslint-plugin-astro`'s jsx-a11y config, scoped to `.astro`). The ESLint-10 peer gap (jsx-a11y caps at `eslint ^9`; upstream fix stalled — jsx-eslint#1075, PRs #1079/#1081 open since Feb) is resolved with a self-healing package.json `overrides` pin (`{ "eslint-plugin-jsx-a11y": { "eslint": "$eslint" } }`) — mirrors our existing react-hooks posture. Researched + rejected the es-tooling fork `eslint-plugin-jsx-a11y-x` (natively eslint-10 but silently **drops `.astro` coverage** + young 0.x) and Oxlint (separate tool). Decision → `docs/decisions/06-testing-ci.md` § A11Y. **Lint gate stays GREEN** (warnings only, exit-0); tsc clean.
- **Triage backlog — 100 `.tsx` warnings / 34 files** (0 `.astro` — shells; Astro dev Audit covers runtime): `label-has-associated-control` 61 · `click-events-have-key-events` 13 · `no-static-element-interactions` 11 · `no-autofocus` 8 · `aria-role` 5. Hottest: `creators/studio/HomeworkEditor` 14, `creators/studio/ResourcesEditor` 12, `community/AddCommunityResourceModal` 8, `teachers/workspace/AvailabilityCalendar` 6. Fix incrementally like `[LE-TRIAGE]`; clear warnings in files touched for other reasons.
- **Follow-on decisions deferred:** (1) escalate `recommended`→`strict` (adds `control-has-associated-label`, ~60 more) after recommended is triaged; (2) whether to ever gate any rule at `error` (like `rules-of-hooks`) once the backlog clears; (3) drop the `overrides` pin when upstream ships `eslint ^10`.
- **Refs:** `../Peerloop/eslint.config.js`, `../Peerloop/package.json` (overrides + devDep), `docs/decisions/06-testing-ci.md` § A11Y, `[LE-TRIAGE]`, `.scratch/rdoc-report-conv397.json`.

### [RHOOKS] · standalone (lint coverage) · surfaced Conv 397 · [Opus]

Enable the **15 React Compiler rules we already ship but never run**. `eslint-plugin-react-hooks@7.1.1` is already a devDep and already registered in `eslint.config.js`; it exposes 29 rules, `recommended-latest` enables 17, and we enable **2** (`rules-of-hooks`=error, `exhaustive-deps`=warn). The rest have been sitting unused in `node_modules`.
- **Control run (Conv 397, `src/**/*.{ts,tsx}`, throwaway config, already reverted):** **108 findings across 80 files** — `set-state-in-effect` 91 · `static-components` 8 · `immutability` 4 · `purity` 1 · `preserve-manual-memoization` 1.
- **Unenabled rules:** `static-components`, `use-memo`, `void-use-memo`, `preserve-manual-memoization`, `incompatible-library`, `immutability`, `globals`, `refs`, `set-state-in-effect`, `error-boundaries`, `purity`, `set-state-in-render`, `unsupported-syntax`, `config`, `gating`.
- **Why it matters beyond free signal:** react-doctor reports **zero** `react-hooks/*` rules despite depending on the plugin — these 108 findings are invisible to it, and its 154 a11y findings are invisible to the plugin. Complementary, not overlapping. This is the half we get with **no new dependency**.
- **🔴 NOT a free flip:** 105 of the 108 are `error` severity and `npm run lint` is one of the five baseline gates — enabling at `error` turns the gate **RED immediately** and blocks all baseline verification. Land at `warn` first and triage incrementally. Exact precedent: `[LE-TRIAGE]` (Convs 147–149, COMPLETE) did this for `exhaustive-deps` — 31 warnings, set to warn, triaged over time.
- **Also unknown:** whether these fire on `.astro` frontmatter via `eslint-plugin-astro`. Check while wiring.
- **Refs:** `../Peerloop/eslint.config.js`, `docs/decisions/06-testing-ci.md` §§ RDOC + "react-hooks/exhaustive-deps Registered as warn".

### [KNIP] · 🔄 Active — oracle adopted Conv 398; gate-wiring deferred

Adopted `knip@6.27.0` (devDep + `knip.json` + `npm run knip`) as the module-graph reachability oracle — closes grep's blind spots (`.astro`, relative-path imports, barrel passthroughs). **Done Conv 398:** installed, configured (cron-worker + `scripts/**` entries, `project: src/**`), first run adjudicated all 9 `[RDFIX]` candidates (converged with grep, now with `.astro` coverage) and independently reproduced the 14 parked `[ORPHAN-BACKLOG]` Cat-B files + kept `emails/styles.ts` correctly live.
- **Remaining before it can be a hard gate:** (1) tune the dependency analysis — false-flags `zod`/`tailwindcss`/`@tailwindcss/forms`/`react-day-picker` (used via CSS `@plugin`/runtime, not JS import) + `cloudflare:` unlisted; (2) baseline the 14 Cat-B files (or wait for `[RG-PUBLIC]` cleanup) so gating doesn't fail on known-parked orphans — **same blocker as the hand-rolled `codecheck-orphan-components.mjs`, which knip would replace**; (3) wire into `/w-codecheck` (only NEW unused fails).
- **Known dead exports KEPT by decision (Conv 398), knip will re-flag when the gate lands:** `CHART_BREAKPOINTS` (+ its barrel re-export line), `now()`/`parseTimestamp()` (`lib/db/index.ts`), `creators`/`getRelatedCourses`/`getFeaturedCreators` (`lib/mock-data.ts`), and `MONITORING_COLORS` (`discover/role-utils.ts` — newly orphaned by the Group-A `MEMBER_ROLE_COLORS` deletion). Plus `emails/styles.ts`'s 6 unused exports (file is live). Sweep whenever the gate is stood up.
- **Refs:** `../Peerloop/knip.json`, `.claude/scripts/codecheck-orphan-components.mjs`, `[[feedback_orphaned_components_survive_migration]]`, `[ORPHAN-BACKLOG]`, `docs/decisions/06-testing-ci.md` § RDOC.

### [EMAILDOC] · standalone (doc cleanup) · trivial · surfaced Conv 398

Conv 398 deleted `src/emails/WelcomeEmail.tsx` + `PaymentReceiptEmail.tsx` (dead, zero importers). Both are still listed in `docs/reference/resend.md` + `docs/reference/DEVELOPMENT-GUIDE.md` — both **`manual`** category (editorial/vendor, user-owned), so the r-end docs agent left them by policy. Stale reference to now-deleted files — remove/annotate the two templates (verify each mention is the deleted template, not a live one). Low priority. **Refs:** `docs/reference/resend.md`, `docs/reference/DEVELOPMENT-GUIDE.md`.

### [NPMVULN] · standalone (security hygiene) · low priority · surfaced Conv 398

`npm install` (knip adoption) reported **21 tree-wide vulnerabilities** (2 low / 10 moderate / 9 high) — whole-dependency-tree total, **not** knip-specific. Run `npm audit` in `~/projects/Peerloop`, triage dev-only/transitive vs. runtime-reachable, decide fixes (don't churn the lockfile without cause). PACKAGE-UPDATES-adjacent; worth a look before MVP-GOLIVE. **Refs:** `~/projects/Peerloop/package.json`.

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

### [A11Y] adoption — permanent a11y linter wired (triage remains as active [A11Y])

`eslint-plugin-jsx-a11y@6.10.2` adopted at **warn** (`.tsx` recommended + `.astro`), ESLint-10 peer gap fixed via a self-healing package.json `overrides` pin. Researched the eslint-10 situation at the user's request and **rejected** the `jsx-a11y-x` fork (drops `.astro` coverage) + Oxlint; upstream+overrides mirrors our react-hooks posture and self-heals when upstream ships `eslint ^10`. Lint gate GREEN (100 warnings, 0 errors), tsc clean. Decision doc + `[A11Y]` triage backlog updated.
