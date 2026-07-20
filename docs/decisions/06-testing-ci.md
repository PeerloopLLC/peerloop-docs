> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 6. Testing & CI/CD

### Enable the Full `react-hooks` `recommended-latest` Set at `warn` — the 15 React-Compiler Rules We Already Shipped but Never Ran (RHOOKS, Conv 400)
**Date:** 2026-07-20 (Conv 400)

The Conv-397 RDOC audit found that `eslint-plugin-react-hooks@7.1.1` — already a devDep and already registered in `eslint.config.js` — exposes 29 rules, of which `recommended-latest` enables 17, and we ran only **2** (`rules-of-hooks`=error, `exhaustive-deps`=warn). The other 15 React-Compiler rules had been sitting unused in `node_modules`. `[RHOOKS]` turns them on. This is the half of the "react-doctor coverage gap" that costs **no new dependency** (react-doctor's a11y half was `[A11Y]`); the two are complementary — react-doctor reports zero `react-hooks/*` rules, and the plugin's findings are invisible to it.

**Land-at-warn (per `[LE-TRIAGE]` / `[A11Y]`):** `eslint.config.js` now spreads `asWarn(reactHooks.configs['recommended-latest'].rules)` in the `.tsx` block, then re-overrides `react-hooks/rules-of-hooks` back to `error` (it catches genuine runtime crashes — a conditional hook call — not a stylistic finding to triage; it has **0 violations**). All 15 newly-enabled rules land at `warn` (the `asWarn` helper preserves each rule's options and `off` state). The set surfaced **105 `.tsx`/`.ts` findings / 86 files** — `set-state-in-effect` 91 · `static-components` 8 · `immutability` 4 · `purity` 1 · `preserve-manual-memoization` 1 — every one an `error`-severity rule downgraded to warn. `npm run lint` (`eslint src/`, no `--max-warnings`) stays **exit-0**: 205 warnings total (105 react-hooks + 100 a11y), **0 errors** — the lint baseline gate is green; the 105 are the triage backlog under `[RHOOKS]`. Landing at `error` would have turned the gate red immediately and blocked all baseline verification.

**`.astro` coverage:** none, by design. The react-hooks block is scoped to `**/*.{ts,tsx}` and `eslint-plugin-astro` does not register react-hooks — all 105 findings are on `.tsx` (82) / `.ts` (4); **0 `.astro`**. Correct: Astro frontmatter is server-side JS, not React, so hook rules don't apply there (the answer to the `[RHOOKS]` open question). `set-state-in-effect` dominating (91) reflects the codebase's `useEffect(() => setState(...))` hydration pattern (e.g. `current-user.ts`, `useCanMessage.ts`) — a real perf-relevant signal (cascading renders) to triage incrementally, not a config artifact.

**Deferred (tracked under `[RHOOKS]`/`[A11Y]`):** triage the 105 warnings incrementally (clear them in files touched for other reasons); decide later whether any rule graduates to `error`; drop nothing to `off` without cause. No `overrides` pin was needed here — unlike jsx-a11y, react-hooks@7.1.1 already ships the `eslint ^10` peer.

**See:** `../Peerloop/eslint.config.js`; the RDOC entry below (`[RHOOKS]` origin — "enable the 15 unenabled `recommended-latest` rules") and the `exhaustive-deps`/`[LE-TRIAGE]` entry (land-at-warn precedent); the `[A11Y]` entry directly below (sibling adoption, same conv-arc); `CURRENT-TASKS.md` § [RHOOKS]; Conv 400.

### Adopt `eslint-plugin-jsx-a11y` at `warn` (upstream + `overrides` peer pin), Not the ESLint-10-Native Fork — the Fork Silently Drops `.astro` Coverage (A11Y, Conv 399)
**Date:** 2026-07-20 (Conv 399)

`[A11Y]` (from the Conv-397 RDOC audit — "zero accessibility linting anywhere") needed a **permanent** a11y linter for both `.tsx` and `.astro`. The obvious pick, `eslint-plugin-jsx-a11y`, hit a real obstacle: its latest release (`6.10.2`, Oct 2024) caps its `eslint` peer at `^9`, so `npm install` ERESOLVE-fails on our ESLint 10 — and the upstream fix is **stalled** (issue [#1075](https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/issues/1075), PRs [#1079](https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/pull/1079)/[#1081](https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/pull/1081) open + unmerged since Feb 2026; maintainer spread thin, no ETA). Two alternatives were evaluated empirically. **The es-tooling fork `eslint-plugin-jsx-a11y-x@0.2.0`** natively supports ESLint 10 — but tested via npm alias it **resolves 0 rules through `eslint-plugin-astro`'s a11y config** (astro hard-codes upstream's shape), i.e. it silently drops `.astro` coverage, and it's a young `0.x` with an ESM-redesigned API. **Oxlint** (a separate Rust linter that natively ports the jsx-a11y rules, no eslint-peer coupling) is a whole parallel tool to adopt. Chosen: **upstream `jsx-a11y@6.10.2` + a one-line package.json `overrides` peer pin** (`{ "eslint-plugin-jsx-a11y": { "eslint": "$eslint" } }`) — it keeps `npm install`/`npm ci` clean, integrates natively with `eslint-plugin-astro` for `.astro`, and **self-heals**: delete the override the day upstream ships `eslint ^10`. This is the exact posture we already run for `eslint-plugin-react-hooks@7.1.1` (which *has* shipped the `eslint ^10` peer) — jsx-a11y is just the lagging sibling; empirically it loads and runs all 34 rules on ESLint 10.

**Land-at-warn (per `[LE-TRIAGE]`):** the `recommended` set surfaced **100 `.tsx` findings / 34 files** (label-has-associated-control 61 · click-events-have-key-events 13 · no-static-element-interactions 11 · no-autofocus 8 · aria-role 5) and **0 `.astro`** (our 90 `.astro` are structural shells; interactive UI lives in `.tsx` islands, and Astro's dev-toolbar Audit already runtime-checks rendered `.astro`). All rules registered at `warn` (options preserved, `off` rules kept off), so `npm run lint` (`eslint src/`, no `--max-warnings`) stays **exit-0** — the lint baseline gate is green; the 100 are the triage backlog under `[A11Y]`. Astro coverage was deemed **not load-bearing now** (0 findings) but kept for free/future-proofing.

**Config wrinkle (ESLint 10):** `eslint-plugin-astro`'s `flat/jsx-a11y-recommended` registers the `jsx-a11y` plugin in an **unscoped** config object, which collides with the `.tsx` block's own `jsx-a11y` registration ("Cannot redefine plugin"). Fix: `.map()` that one object to `files: ['**/*.astro']` so the two registrations never apply to the same file. This is baked into `eslint.config.js` with a comment.

**See:** `../Peerloop/eslint.config.js`, `../Peerloop/package.json` (`overrides` + devDep); the RDOC entry below (`[A11Y]` origin) and the `exhaustive-deps`/`[LE-TRIAGE]` entry (land-at-warn precedent); `CURRENT-TASKS.md` § [A11Y]; Conv 399.

### Adopt `knip` as the Durable Module-Graph Reachability Oracle — "Absent From the Build = Dead" Closes grep's Blind Spots (KNIP, Conv 398)
**Date:** 2026-07-20 (Conv 398)

The Conv-397 RDOC follow-through (`[RDFIX]`) needed to delete dead code, but `git grep` importer analysis has five structural blind spots that mis-classify usage — same-named local vars (`hasRole` had 90+ hits, all local `const`), relative-path misses (`from './styles'` invisible to an `emails/styles`-shaped grep, nearly reading a live 17-importer file as dead), barrel passthroughs, internal/namespace self-use, and `.astro` markup invisible to a JS-only text search. The user challenged deleting anything while the "is it in use" check had known holes, and asked whether a build could adjudicate. A production build's module graph does — it follows real entry points and tree-shakes, so **absent from the build = dead (bundler-grade); present = keep.** Chosen (Option 1) over a one-off `build --sourcemap` + `sources[]` check (authoritative once, not reusable — Option 2) and over deleting nothing (Option 3): **install `knip@6.27.0` (devDep) + a repo-specific `knip.json` (cron-worker + `scripts/**` entries, `project: src/**`, `ignoreBinaries`) + an `npm run knip` script**, use it to adjudicate the 9 RDFIX candidates, and keep it as the standing oracle. First run parsed `.astro` cleanly and **confirmed all 9 candidates dead** (2 unused email files; 7 unused exports incl. `CHART_BREAKPOINTS` at both def + barrel), converged with grep now WITH `.astro` coverage, independently reproduced the 14 parked `[ORPHAN-BACKLOG]` Cat-B files, and correctly kept `styles.ts` live. It is effectively `codecheck-orphan-components.mjs` generalized (that detector is `src/components/**`-scoped; knip covers all of `src/` + `.astro`).

**Rationale:** The module graph closes exactly the flagged grep holes (esp. the `.astro` page layer no text search can see), settles the current deletions on evidence rather than a leaky heuristic, and generalizes the hand-rolled orphan detector. Aligns with the `[A11Y]`/`[RHOOKS]` "pick the right permanent tool" pattern. **Not yet a hard gate:** knip's file/export reachability was solid on first run but its *dependency* analysis false-positived (`zod`/`tailwindcss`/`react-day-picker` are used via CSS `@plugin`/runtime, not JS import) — trust file/export before the dependency section and tune the latter before gating; gating is also blocked on the 14 parked Cat-B files (same blocker as the orphan detector, which would fail the gate). Tracked as `[KNIP]`: remaining = dep-analysis tuning, baseline Cat-B (or await `[RG-PUBLIC]`), wire into `/w-codecheck` as a NEW-only gate.

**See:** `../Peerloop/knip.json`, `package.json` (`knip` script + devDep); generalizes `.claude/scripts/codecheck-orphan-components.mjs` (the ORPHAN-DETECT/ORPHAN-BACKLOG entries below); `CURRENT-TASKS.md` § [KNIP]; `docs/sessions/2026-07/20260720_0909 Decisions.md` §1, Learnings §§1–2; Conv 398.

### React Doctor = Occasional External Audit (e.g. Pre-Go-Live), NOT Toolbelt Tooling; Its Real Yield Was Two Coverage Gaps We Already Owned (RDOC, Conv 397)
**Date:** 2026-07-19 (Conv 397)

`react-doctor` (Million Software; 405 rules on an oxlint engine; `npx react-doctor@latest`) was evaluated against the code repo on `jfg-dev-14` — read-only, no branch, no dependency added, working tree restored clean. **Verdict: run it occasionally as an external audit — explicitly pre-go-live — but do NOT add it to the toolbelt.** The `install` (agent skill) and `ci install` (GitHub Actions) surfaces were deliberately left unexecuted.

**Scan result:** 712 findings (2 error / 710 warning) over 210 files in 16.5s, from 47 of 405 rules — Bugs 287, Maintainability 164, Accessibility 154, Performance 105, Security 2.

**The disqualifier for standing tooling is structural, not quality: it cannot see Astro.** 0 of our 90 `.astro` files were analyzed (it reported `framework: "unknown"`); coverage is our React islands only. Despite the oxlint docs claiming framework files are linted via their `<script>` blocks, none were opened. A gate blind to the entire page layer can never be trusted as a gate — a route could regress freely while the check stays green. Secondary: `0.x` at ~4 published versions/day (579 versions in 5 months) is a poor fit for deterministic tooling, and `@latest` pins nothing.

**Precision, measured by reading the code at sampled sites:** of the 2 `error` hits, 1 was a **genuine bug** (`SessionRoom.tsx:126` — a `setViewState` updater calling `setTimeUntilJoin()` inside itself; React may run updaters more than once) and 1 a **false positive** (`MyStudents.tsx:197` — cleanup does exist, in a separate unmount `useEffect` using the captured-ref pattern the rule can't follow). 3 of 3 sampled a11y warnings were true positives. Dead-code (the bundled `deslop` pass) re-derived our knowingly-parked `[ORPHAN-BACKLOG]` Category B, added genuine net-new hits **outside our own detector's `src/components/**` scope** (`src/emails/{WelcomeEmail,PaymentReceiptEmail}.tsx`; dead `hasRole`/`canAccessFeature` exports in `db/types.ts`), and false-positived on `workers/cron/src/index.ts` — the Cloudflare Worker entry-point class our own detector was already scoped to avoid.

**The load-bearing finding — the tools are complementary, not overlapping.** react-doctor depends on `eslint-plugin-react-hooks@7.1.1` but **reports zero `react-hooks/*` rules**; its 413-rule catalogue has no equivalent (the only "react-hooks" string in it is `preact-no-react-hooks-import`). A control run of `react-hooks` at `recommended-latest` — 17 rules we **already own and already ship as a devDep**, of which `eslint.config.js` enables 2 — produced **108 findings, 91 of them `set-state-in-effect`**, none of which react-doctor sees. So the hypothesis that react-doctor might repackage signal we already had is **falsified in both directions**: its 154 a11y findings are invisible to the plugin, and the plugin's 91 state-in-effect findings are invisible to it.

**Rationale:** As a one-time `npx` audit the cost is genuinely zero — no dependency, no lockfile change, nothing committed — so occasional runs are pure upside, and pre-go-live is the natural cadence (a11y and dead-code drift are exactly what accumulates unwatched). As standing tooling the Astro blind spot removes the property a gate needs (trustworthy red/green), and `0.x` churn adds maintenance we would carry every conv. The audit's durable value is not the tool but the two gaps it exposed in coverage **we already own**: no a11y linting anywhere, and 15 unused React Compiler rules already sitting in `node_modules`.

**Consequences:** Three tasks created — `[A11Y]` (154 findings; decide on a permanent a11y linter, since react-doctor is not it), `[RHOOKS]` (enable the 15 unenabled `recommended-latest` rules), `[RDFIX]` (the confirmed `SessionRoom.tsx` bug + dead code outside the detector's scope). ⚠️ `[RHOOKS]` is **not** a free flip: 105 of the 108 control findings are `error` severity, and `npm run lint` is one of the five baseline gates — enabling at `error` turns the gate red immediately. Land them at `warn` first, per the `exhaustive-deps` precedent below (`[LE-TRIAGE]`, Convs 147-149, completed). Telemetry note for any future run: the CLI reports to Sentry by default (`--no-telemetry` opts out) and the supply-chain scan transmits the dependency manifest to Socket.dev (`--no-supply-chain`); this evaluation used both flags.

**See:** `plan/mvp-golive/README.md` § **MVP-GOLIVE.CODE-AUDIT** (the pre-launch run procedure, reproducing this evaluation exactly — tracked in `PLAN.md` block 3); `../Peerloop/eslint.config.js`; `CURRENT-TASKS.md` §§ [A11Y] [RHOOKS] [RDFIX]; the `exhaustive-deps` entry below; the Conv-393/392 orphan-detector entries below (dead-code scope overlap); `.scratch/rdoc-report-conv397.json` (baseline report); Conv 397.

### Dead `.ts` Sweep + Deletion-Safety Refinement — Route-Reachability Is Authoritative for `src/components/**` Only (ORPHAN-BACKLOG, Conv 393)
**Date:** 2026-07-13 (Conv 393)

Extends the Conv-392 ORPHAN-DETECT entry below by resolving its two deferred concerns. **(1) Category C cleared:** of the 4 "needs-a-look" orphans, 3 were confirmed dead (`error/ErrorPage` superseded by the self-contained `404.astro`, `leaderboard/Leaderboard`+`api/leaderboard.ts` an abandoned full-stack feature, `context-actions/*` a never-mounted FAB) and deleted; the 4th (`invite/ModeratorInvite`) was **not debris but a wiring gap** — the live admin invite email links to `/invite/mod/{token}`, a page that never existed, so the invitee accept/decline UI 404'd on staging (RESEND live). Fixed by building `src/pages/invite/mod/[token].astro` (`@matt-inspired`, `LandingLayout` per the `verify/[id]` public-token-landing precedent) rather than deleting — detector 57→53. **The tell for dead-vs-unwired:** trace what *should* reach the orphan (an API, an email, a link/redirect target) and grep that target for a page route before concluding "dead."

**(2) Dead `.ts` sweep, scoped to `src/components/**`:** the `.tsx`/`.astro` detector's `reachable` BFS already traverses all `.ts` — it only *filters the report* to components, so a `.ts` variant is cheap. But it is **safe only under `src/components/**`**, where `.ts` is reachable exclusively via routes (same as components); `src/lib/**` has additional entry points (`middleware.ts`, `workers/**` importing lib, config, tests) invisible to a pages-rooted BFS, so a lib sweep would false-positive on every worker/middleware-only file. The scoped variant found 22 dead `.ts`; deleted 12 (7 dead utils/types + 5 dead live-dir barrels), left 9 parked Category-B/entangled barrels, and kept `icons/icon-provenance.ts` (zero code importers but read-as-a-file by `scripts/prov-sweep.ts` — the `.ts` analogue of a `KNOWN_ORPHANS` allowlist entry).

**Deletion-safety refinement (supersedes the Conv-392 "closed-orphan-set" framing for `.ts`):** safe-to-delete = **zero importers of ANY kind** (reachable + parked-orphan + test), **not** "zero route-reachable importers." A file with no *reachable* importer can still be imported by a parked/unreachable orphan that Vite tree-shakes at build but `tsc` still compiles — deleting it dangles that orphan and breaks `tsc`. A 🟡-DANGLES classifier (any src importer, live or orphan) caught 7 such barrels and kept them with the parked set. Corollary: prior-conv "keep because X imports it" notes **decay** — Conv-392 kept `courses/course-tabs/types.ts` for a community-tabs importer that was gone by Conv 393; re-run the importer check at delete time, don't trust the closure note.

**Rationale:** Reachability-from-routes is authoritative for `src/components/**` (both `.tsx` and `.ts`) and unsafe for `src/lib/**`; `tsc --noEmit` between batches is the final dangler arbiter regardless of importer class. A `.ts` detector variant is productionizable (re-derive from the component detector, scope to components) if a `.ts` gate is later wanted — deferred alongside the component-detector `/w-codecheck` wiring, gated behind Category B resolving.

**See:** `src/pages/invite/mod/[token].astro`; `.claude/scripts/codecheck-orphan-components.mjs`; `memory/feedback_orphaned_components_survive_migration.md`; `CURRENT-TASKS.md` § [ORPHAN-BACKLOG]; `docs/sessions/2026-07/20260713_1116 Decisions.md` §§1–2, Learnings §§1–5; continues the Conv-392 ORPHAN-DETECT entry below; Conv 393.

### Orphaned Page-Component Detector (BFS Reachability from Routes) — Built as a Manual Tool, Not Yet a `/w-codecheck` Gate (ORPHAN-DETECT, Conv 392)
**Date:** 2026-07-12 (Conv 392)

Route migrations that delete `/old` *pages* but keep their *components* strand those components unreachable while all five gates stay green (`tsc`/`lint`/`astro check`/`build` see only reachable-from-entrypoint errors; unit tests import the components DIRECTLY, bypassing routing) — the failure mode that left 4 Conv-391 diploma surfaces (`LearnTab` completion card, discover `CompletedTabContent`, `role-utils` tab label, `CourseHero`) rendered by no route. Systemic guard: `.claude/scripts/codecheck-orphan-components.mjs` does a BFS reachability walk from `src/pages/**` routes and flags any `src/components/**` `.tsx`/`.astro` unreachable from a route, with a `KNOWN_ORPHANS` allowlist. It surfaced ~118 pre-existing orphans; **kept as a manual tool (exits 1), NOT wired as a hard `/w-codecheck` gate**, until Categories B (52 marketing, parked [RG-PUBLIC]) + C (4 needs-a-look, possibly built-but-unwired) resolve and the residuals baseline into `KNOWN_ORPHANS` (57 remain post-Category-A). Deletion safety rests on the **closed-orphan-set property**: reachability is transitive, so no live file imports an orphan; deleting the full set can only dangle tests, dead barrels, or other orphans, and `tsc --noEmit` between batches is the precise arbiter (every dangler across the 20-file + 74-file passes was a test or a dead barrel — zero live breakage). Detector is `.tsx`/`.astro`-only; dead `.ts` utils need a separate sweep.

**Rationale:** Gating on 57 pre-existing orphans would fail every run (noise, not a gate) — gate once the backlog is zero/baselined. `tsc` is a precise-enough dangler arbiter that a grep import pre-check is unneeded (and false-positives on same-basename files in other dirs + doc-comment mentions). The detector makes the "component green in every gate but mounted nowhere" class visible, which no existing gate catches.

**See:** `.claude/scripts/codecheck-orphan-components.mjs`; `memory/feedback_orphaned_components_survive_migration.md`; `docs/sessions/2026-07/20260712_2027 Decisions.md` §§4–5, Learnings §§1–4; `CURRENT-TASKS.md` § [ORPHAN-BACKLOG]; Conv 392.

### PLATO Waypoint Dependency Graph + Registry + Provenance Foundation, and a `make`-for-Waypoints Runner (PLATO-SEQ Phase 4a/4b, Conv 385)
**Date:** 2026-07-11 (Conv 385)

Phase 4 was reframed around a **dependency graph** rather than a hardcoded chain runner. The dependency edges were **latent, not missing** — `restoreFrom` (depends-on) and `snapshot`/`capturesTo` (produces) already existed as strings scattered across instance files (a grep showed exactly 4 declared consumption edges); the gap was that nothing *assembled* them into a validated graph or tracked freshness. Phase 4a derives the DAG from those existing fields (no new `dependsOn`/`produces` schema — single source of truth, no drift) and adds the one genuinely absent thing: a **transitive-closure source hash** (producer instance + its scenario(s) + **every step in the chain** + persona + shared schema, unioned with each `restoreFrom` parent's hash), so editing a shared step (`enroll-student`) marks the right downstream waypoints STALE while leaving unrelated ones FRESH.

**Three dials** (chosen over caching run-state into the committed manifest — which would lie on the other machine — and over coarse producer-file-only hashing): (1) a **committed static graph** `manifest.generated.json` (`generatedAt`/`gitRev`/`graphSourceHash`) checked by `plato:graph check` (Clock 1 = graph freshness); (2) **live-read gitignored per-machine provenance sidecars** read by `plato:graph status` (Clock 2 = per-waypoint last-run); (3) staleness via transitive-closure `sourceHash` compare. Run-state is inherently per-machine (local gitignored snapshots) so it must not be committed; the graph is shared and committed.

Provenance is stored as a **gitignored JSON sidecar** `<wp>.sqlite.prov.json`, **not** an in-DB `_plato_provenance` table (flagged deviation from the literal "stamp into the .sqlite" proposal, accepted). An in-DB table would be a second permanent footgun to the Conv-383/384 manual per-table row-identity diff (like `notifications`); the sidecar keeps the `.sqlite` byte-clean and is readable from both the JS capture script and the TS CLI with no sqlite round-trip.

Phase 4b built `plato:run` — a **`make` for waypoints**: reads the graph + Clock-2 verdicts and regenerates only STALE/MISSING waypoints (skips FRESH) in topo order (`--chain`, `--from-waypoint` + transitive descendants, `--force`, `--dry-run`). Because API producers (`flywheel-pre-N`) each **full-replay** the step prefix in-memory (sub-second) rather than restoring a parent snapshot, `--from-waypoint X` means "regenerate X + everything that transitively depends on it," not debugger-style restore-and-continue (that's the deferred browser walker). The CLI runs under **tsx**, importing the real instance/scenario objects (robust to formatting; typed edges/chains for free) rather than the text-parse precedent of `plato-split.js`.

Sequencing: **4a (foundation) → 4b (runner) → 4c (agent browser walker, deferred post-launch, `[BROWSER-SMOKE-2B]`)**. Both 4a and 4b shipped this conv; PLATO-SEQ's active work is complete. Full baseline 6834/6834.

**Rationale:** The graph is the substrate every runner variant reads, so building it first turns the runner from a hardcoded chain into a dependency-aware `make`. Deriving edges from existing fields avoids a parallel schema that could drift. Per-machine run-state cannot be committed (snapshots are gitignored), so the two-clock split (committed graph vs live-read sidecars) is the only honest model across infrequent runs on multiple machines. The sidecar keeps the artifact clean for its own byte-level validators.

**See:** `tests/plato/lib/waypoint-graph.ts`, `tests/plato/lib/waypoint-provenance.ts`, `tests/plato/lib/waypoint-status.ts`, `scripts/plato-graph.ts`, `scripts/plato-run.ts`, `tests/plato/snapshots/manifest.generated.json`, `docs/as-designed/plato.md` (waypoint graph/registry/provenance subsection); continues the Conv-379/380/381/382/384 PLATO-SEQ decisions; `docs/sessions/2026-07/20260711_1159 Decisions.md` §§1–3; Conv 385.

### PLATO Live-Walk Row-Identity Excludes Producer-Mocked Tables; `user_stats` Divergence Was a Real Worker Bug (PLATO-SEQ Phase 3, Conv 384)
**Date:** 2026-07-11 (Conv 384)

When a PLATO browser walk (live dev server) is validated row-identical against its API producer (vitest + `MockRegistry`), the **per-table COUNT diff excludes tables the producer mocks away**. `notifications` is **irreducible**: the producer silences every `notify*` call (0 rows) while the live server writes them for real, so it can never match and is excluded — the honest bar is 69/70, not a bridge that deletes live rows. `user_stats`, by contrast, was **not** an irreducible mock divergence — it exposed a real production bug: `completeSession`'s `triggerPostSessionActions` (user_stats + completion notifications) ran as a **floating promise** (`booking.ts:171`), which a CF Worker drops on request teardown, so it never persisted after a live BBB `room_ended` webhook. vitest (node, no Worker lifecycle) drains the floating promise, which is exactly why the oracle carried the rows and hid the bug. Chosen (Option 3) over excluding both tables (Option 1 — would have masked the bug) and SQL-bridge reconciliation (Option 2 — papers over the mock/live gap): **fix the bug so `user_stats` persists live, exclude only the irreducible `notifications`.** Corollary correction: the Conv-383 "activities 70/70 identical" claim was inaccurate — the 8 scenario `verify` assertions are targeted COUNT checks that never touch `notifications` or `user_stats`, so passing assertions do NOT imply full row-identity; always run a real full per-table diff to claim it. Both ecosystem + activities walks re-validated 69/70 with the fixed code (ecosystem 7/7 asserts, activities 8/8), closing PLATO-SEQ Phase 3.

**Rationale:** Producer-mocked tables (notifications) can never match a live walk, so excluding them is the correct methodology, not a defect. But a divergence must be triaged before it's excluded — `user_stats` looked like the same class of problem but was a genuine Worker fire-and-forget bug that vitest masked. Re-walking with the fixed server produces a true validated capture rather than a note-only correction of the record.

**See:** `tests/plato/snapshots/README.md` (notifications-exclusion rule + Conv-383 correction + user_stats waitUntil fix), `src/lib/booking.ts`, `.claude/memory-sync/memories/plato_walk_mocked_service_divergence.md`; the waitUntil fix shape is in `01-architecture.md`; continues the Conv-379/380/381/382 PLATO-SEQ decisions; `docs/sessions/2026-07/20260711_0856 Decisions.md` §§1,3; Conv 384.

### PLATO-SEQ Phase 3 Foundation — Lineage-Exact Waypoint Producers Required for Row-Identity Validation; Two Journey Shapes (Restore-Only vs Restore-From-Waypoint) (Conv 382)
**Date:** 2026-07-10 (Conv 382)

Extends the PLATO-SEQ waypoint architecture to the 4 non-flywheel journeys (ecosystem, activities, session-invite, member-directory) and commits to the **full Phase-3 arc across multiple convs** (formalize + author producers + Phase-2-style browser re-walks validated row-identical to API producers), rather than metadata-only formalization. Two journey shapes are now canonical past the flywheel: **restore-only** (`restoreFrom` a snapshot + pure-UI-from-restore, no capture — session-invite from `flywheel-pre-12`, member-directory from its own `member-directory` snapshot) and **restore-from-waypoint** (`restoreFrom` + `capturesTo` + a **lineage-exact producer** — activities from `activities-pre-11`, ecosystem from `ecosystem-pre-12`). The core decision: **row-identity validation (browser-captured end-state == API producer, all tables) forbids reusing a state-*sufficient* snapshot from a different scenario.** activities could restore `flywheel-pre-12` (same personas/course, enrollable), but that snapshot's lineage differs on setup-derived tables (community-resources rows, availability slot count, step order), so a capture restored from it would diverge from `activities.sqlite` even when the activity tables match. Row-identity therefore requires the `restoreFrom` waypoint to be a **prefix of the journey's OWN scenario** — hence 2 new lineage-exact producers (`activities-pre-11` steps 1–10, `ecosystem-pre-12` steps 1–11), authored + registered in both `index.ts` + API-validated as correct prefixes. Cut points annotated by **reading the step files, not inferring from names** (`[EMP]`): `add-teacher-cert` is NOT a cut (only the FIRST `self-certify-creator` crosses Stripe Connect; a second-course cert is pure-DB `selfCertify`); `book-complete-session` splits half pure-UI (`bookSession` `POST /api/sessions`) / half CUT-3 (`completeSession` BBB webhook, inline API bridge). Restore-from-waypoint segments that register no users inherit correct persona tzs for free (sidestepping Conv-381's `[TZ-TESTS]` reconciliation caveat). Phase 3 tracked in **PLAN.md § PLATO-SEQ** (not the dormant CURRENT-BLOCK-PLAN.md — PLAN.md is the SoT and already carries the phase breakdown). Gates: tsc clean, eslint clean, PLATO API 13/13. The activities browser re-walk was started + checkpointed at the booking gate (restore → real booking UI → DB-verified `scheduled` session at `2026-07-20T13:00Z`).

**Rationale:** Row-identity is the user's chosen validation bar; a convenient cross-scenario snapshot cannot satisfy it because setup-derived tables carry lineage. A lineage-exact prefix producer per journey is the only restore base that makes a browser capture row-identical to its API producer. The two journey shapes name the reusable structure (restore-only vs restore-from-waypoint) for all PLATO journeys past the flywheel.

**See:** `tests/plato/scenarios/{activities-pre-11,ecosystem-pre-12}.scenario.ts`, `tests/plato/instances/{activities-pre-11,ecosystem-pre-12}.instance.ts` + `index.ts`, `tests/plato/snapshots/README.md`, `PLATO-REGISTRY.md`, `docs/as-designed/plato.md` (§ Waypoint-Sequenced Segments — Phase 3), `PLAN.md` (§ PLATO-SEQ); continues the Conv-379/380/381 PLATO-SEQ decisions below; `docs/sessions/2026-07/20260710_1945 Decisions.md` §§1–2; Conv 382. Browser re-walks (activities finish + ecosystem) remain multi-conv; the CUT-3 completion-bridge mechanism on a live dev server is the open blocker.

### PLATO-SEQ Phase 2 Browser Re-Walks Validated Row-Identical to API Producers — Hybrid Walk Fidelity + Persona-TZ Reconciliation (Conv 381)
**Date:** 2026-07-10 (Conv 381)

First end-to-end proof of the PLATO-SEQ dual-producer premise: a browser walk through pure-UI intents produces the **same DB state** a deterministic API producer builds via mocks. All 3 browser segments' captured waypoints were **row-identical to their API producers** — B1 `wp-published`==`flywheel-pre-9` (14 tables), B3 `wp-booked`==`flywheel-pre-14` (8 tables), B4 `wp-certified`==`flywheel` (9 tables) — validated via a per-table `sqlite3 COUNT(*)` diff, structurally closing `[FLYWHEEL-WALK-GAP]`. Two execution conventions were adopted for browser re-walks: **(1) Hybrid walk fidelity** — drive the genuinely *interactive gates* via real UI (create-course modal, one add-module form, Publish gate, `/signup`, the booking calendar/slot/confirm flow, the Certify modal) to prove those surfaces render + work, but submit *bulk/repeat* payloads (12-field course About tab with nested arrays + un-uploadable thumbnail; repeat modules/sessions) via the app's own authed fetch endpoints (the same ones the PLATO steps call) — chosen over full-UI drive (slow/fragile on array fields + thumbnail) or state-first (barely tests the UI); generalizes the `[BRIDGE-UPLOAD]` precedent. **(2) Persona-TZ reconciliation before capture** — browser *registration* auto-detects the machine's zone client-side (`America/Toronto`; the signup UI exposes no tz field), so a fully browser-produced waypoint (B1 from `wp-fresh`) silently collapses the cross-boundary LA/Tokyo tz pair `[TZ-TESTS]` depends on; reconcile `users.timezone` to the persona spec via SQL after registration, **before** capturing (waypoints *restored* from an API snapshot already carry correct tzs). Live chrome-bridge gotchas reconfirmed: `[BRIDGE-MEM]` blank-body on the first client-side nav to an authed island (hard reload fixes), prefer `find`+ref-clicks over coordinate clicks, `[PUB-CHECKLIST-STALE]` stays stale until reload when detail is written outside the client form, and `plato:snapshot:restore` races the port release after `kill` (verify port 4321 free — `lsof -ti:4321 | xargs kill -9` + re-check — not just that `kill` returned).

**Rationale:** Proves the waypoint architecture's core equivalence claim end-to-end at every cut point (not just that the pipeline runs), so browser and API runs are interchangeable producers. Hybrid fidelity keeps the walk reliable while still exercising every interactive surface + real app code/auth/rendering; tz reconciliation isn't fabricating UI behavior (tz is settable state the UI doesn't expose — the API producer injects it) but restoring the intended waypoint, preserving `[TZ-TESTS]`.

**See:** `tests/plato/snapshots/README.md` (Browser-walk validation Conv 381 + tz caveat), `PLAN.md` (§ PLATO-SEQ); builds on the two PLATO-SEQ decisions below (Convs 379/380); `docs/sessions/2026-07/20260710_1455 Decisions.md` §§1–2; Conv 381. Phase 3 (other journeys) + Phase 4 (Segments runner) remain.

### Decompose Flywheel `complete-course` into `book-sessions` + `complete-sessions` (PLATO-SEQ Phase 2, Conv 380)
**Date:** 2026-07-10 (Conv 380)

The flywheel scenario's `complete-course` step **fused** browser-drivable session booking (3× `POST /api/sessions`, pure-UI) with the CUT-3 BBB completion webhook — blocking the waypoint model, because a pure browser segment couldn't produce `wp-booked` and hand it to an API bridge. **Decomposed it into two flywheel-scoped steps** — `book-sessions` (pure-UI → `wp-booked`) and `complete-sessions` (discover scheduled sessions via `GET /api/sessions?status=scheduled`, then 3× BBB `room_ended`, CUT-3 bridge → `wp-completed`) — leaving the **shared** `complete-course` untouched (chosen over decomposing it everywhere, which would touch seed-dev/ecosystem and disturb the dev seed). The flywheel grows to **15 steps**; 4 waypoint producers built via `plato:split` (`flywheel-pre-9/12/14/15` → `wp-published`/`-enrolled`/`-booked`/`-completed`) and all DB-state-verified. Two reusable patterns established: **Decompose-at-CUT-boundary** (split a fused pure-UI+external step into a browser step + an API-bridge step so the waypoint chain captures the intermediate pre-cut state) and **DB-discovery API bridge** (the bridge re-discovers its inputs from the DB via GET rather than inheriting cross-step context — required because `api-runner.ts` clears context every step under Model B, and because a restored snapshot has no in-memory context). `complete-sessions` is order-independent by construction: `completeSession()` defers `module_id` on out-of-order completion, then `backfillModuleIds()` assigns them.

**Rationale:** Realizes the Conv-379 waypoint segment model (browser books → `wp-booked`; API completes → `wp-completed`), gives session-booking real browser coverage, and contains blast radius by scoping the split to the flywheel rather than the shared step catalog.

**See:** `tests/plato/steps/{book-sessions,complete-sessions}.step.ts`, `tests/plato/scenarios/flywheel.scenario.ts`, `tests/plato/instances/flywheel-pre-{9,12,14,15}.instance.ts`, `docs/as-designed/plato.md`, `PLAN.md` (§ PLATO-SEQ); builds on the "Waypoint-Sequenced PLATO Test Architecture" decision below; `docs/sessions/2026-07/20260710_1324 Decisions.md` §1; Conv 380.

### Waypoint-Sequenced PLATO Test Architecture — API-Runs Produce Snapshots at 4 External Cut Points, Browser-Runs Verify Pure-UI Segments (PLATO-SEQ, Conv 379)
**Date:** 2026-07-10 (Conv 379)

A pure browser-run of the flywheel scenario dead-ends at each external-service boundary the API-run mocks but the live dev server cannot reach (the motivating failure: enrollment → "Enrollment Unavailable — no teachers available"). Adopt a **waypoint model** over pushing the browser through real Stripe/BBB test flows (heavy, external, brittle) or abandoning browser-mode for those legs: **API-runs produce a snapshot at each boundary; browser segments each restore the nearest waypoint and walk pure-UI only.** A mapping pass established there are exactly **4 external cut points** (everything else is browser-drivable because `MockRegistry.resetAll()` applies an `all-silent` default before every step): **CUT‑1** self-certify-creator Stripe Connect (`POST /api/stripe/connect`), **CUT‑2a** enroll checkout (`POST /api/checkout/create-session`), **CUT‑2b** enroll Stripe webhook (`POST /api/webhooks/stripe`, creates the `enrollments` row), **CUT‑3** completion BBB webhook (`POST /api/webhooks/bbb`). Browser segments are B1 creator-setup, B2 availability, B3 post-enroll booking, B4 completion+certification. `session-invite` already worked this way and is the template. Proven end-to-end this conv: API-running `flywheel-pre-11` (steps 1–10, Stripe Connect mocked) → restore → the course Benefits page rendered **enrollable** ("Get Started Now"), resolving the exact dead-end. New tooling banked: `plato:capture` (WAL-safe live-D1 → snapshot via `sqlite3 ".backup"`, closing the previously one-directional snapshot bridge) and the `plato:split` / `plato:split-cleanup` waypoint-minting lifecycle. Phase 1 foundation committed; Phases 2–4 own the `PLATO-SEQ` PLAN block.

**Rationale:** Matches the already-written `plato.md` principle "put mocked external services on the API side"; makes runs build on each other deterministically; structurally eliminates the flywheel/ecosystem walkthrough precondition gaps rather than papering over each with brittle live-service drives.

**See:** `docs/as-designed/plato.md` (§ Waypoint-Sequenced Segments), `scripts/plato-capture.js`, `tests/plato/instances/flywheel-pre-11.instance.ts`, `PLAN.md` (§ PLATO-SEQ); `docs/sessions/2026-07/20260710_1212 Decisions.md` §1; Conv 379.

### Automated Browser-Level TZ-Display Regression = a jsdom Component-Render Suite, NOT Playwright (TZ-BROWSER-AUTO, Conv 377)
**Date:** 2026-07-09 (Conv 377)

Resolves the Conv-375 `[TZ-BROWSER-AUTO]` open decision (whether to add an automated browser-level timezone-**display** regression test) with **Option A: a jsdom component-render suite, no Playwright.** The Conv-375/376 work had already closed most of the gap — Vitest runs in **jsdom** and CI runs the unit/component job under the hostile-TZ matrix `['UTC','Pacific/Kiritimati']` ([TZ-LINT-CI]), and the Conv-376 `SessionRoom.test.tsx` established a render test that asserts a session time in a mocked viewer zone and is flip-verified. The common bug class — a component dropping its explicit `{ timeZone }` and silently falling back to **host**-local formatting (literally the Conv-376 SessionRoom bug) — is therefore catchable by a jsdom render test under the hostile leg, **with no real browser**. This conv generalized that pattern to **6 more display islands** (`TeacherUpcomingSessions`, admin `SessionDetailContent` attendance times, `StudentSessionsList`, `StudentDashboard` upcoming, `TeacherSessionsList`, `SessionBooking` confirm step) — 12 tests, each asserting the viewer-zone wall-clock **and** the `" UTC"` null-fallback, each **flip-verified** (reverting `formatSessionTime` to host-local turns all 12 red under `Pacific/Kiritimati`; a per-component host-local flip of `TeacherUpcomingSessions` was also confirmed red). All 6 candidate islands already used the viewer-tz helpers (`formatSessionDate/Time` + `useUserTimezone`), so **no live bug was found** — the suite is pure regression protection.

Playwright (Option B) was **declined**: it would reverse the Conv-347 `[BROWSER-SMOKE-2B]` pre-launch Playwright freeze to add only the residual jsdom cannot reach — the **SSR `.astro` path** (`MySessionsTab.astro` reading `Astro.locals.userTimezone`) and **hydration flicker**. That residual stays owned by the manual `TZ-MANUAL-VERIFICATION.md` checklist pre-launch; automated browser tz coverage is deferred post-launch with `[BROWSER-SMOKE-2B]`.

**Rationale:** The viewer-tz display model formats to the user's **stored** zone (not the browser's), so a real browser's `timezoneId` is not what exposes the regression — a hostile **host** TZ is, which jsdom + the existing CI matrix already provide. A component render test gives durable, gated, deterministic coverage of the exact bug class inside the green `npm test`, without reversing the Playwright freeze or taking on E2E flakiness for a single spec. Declining Playwright while still adding real automated coverage is the correct, documented outcome. Full suite 6824✓ (+12).

**See:** `tests/components/{dashboard/TeacherUpcomingSessions,admin/SessionDetailContent,learning/StudentSessionsList,teaching/TeacherSessionsList,booking/SessionBooking}.test.tsx`, `tests/pages/dashboard/StudentDashboard.test.tsx`, `docs/guides/TZ-MANUAL-VERIFICATION.md`; complements "TZ Fixes Protected by Flip-Verified Runtime Tests" (Conv 375) and "`lint:tz` Enforced in CI…" (Conv 375) below; Conv 377.

### `lint:tz` Client-Dir Scan Extension DECLINED — the FAIL Patterns Are Server-Oriented (TZ-LINT-SCAN2, Conv 376)
**Date:** 2026-07-09 (Conv 376)

Resolves the Conv-375 `[TZ-LINT-SCAN2]` deferral (extend the guard scan to `src/components` + `.astro`) with a **decision not to extend**. Audit found the ~65 client-dir hits (P1 `new Date()`, P2 local-constructor, P3 local-accessor) are ~all benign: calendar UI legitimately renders in browser-local time, `Date > Date` comparisons are tz-safe absolute-instant math, and DB-timestamp writes are fine. The `getNow()`/UTC-math enforcement exists for the **UTC Worker**, not client components. The genuine client-tz risk is a *display* one — raw `.toLocaleDateString/TimeString()` without a `timeZone`, bypassing the viewer-tz formatters — a pattern the FAIL scan doesn't detect, and one a **line-based** lint can't reliably catch anyway (a `timeZone` key lives on an adjacent line or in a variable, so a `grep -v timeZone` throws false positives). The audit found **zero** accidental client-tz display bugs; the one real gap was `SessionRoom.tsx` (hard-coded `timeZone:'UTC'` while ~20 sibling islands use `useUserTimezone()`), fixed in-conv via the established hook pattern + 2 flip-verified render tests. The exclusion is now documented as deliberate in `lint-timezone.sh` + `lint-timezone.md` (not a pending TODO).

**Rationale:** Extending server-oriented patterns to client dirs = ~65 exemptions for ≈0 bugs — pure exemption-noise. Even a targeted `toLocale*` forward-guard would be noisy because a line-based lint can't see a multi-line/variable `timeZone`. Client display is already handled by the TZ-MODEL viewer-tz helpers + UTC-anchoring + the `data-session-time` enhancement. Declining a scan extension can be the correct, documented outcome.

**See:** `scripts/lint-timezone.sh`, `docs/as-designed/lint-timezone.md`, `src/components/booking/SessionRoom.tsx`; `docs/sessions/2026-07/20260709_1002 Decisions.md` §4–5; Conv 376.

### `lint:tz` Enforced in CI + a Hostile-TZ Test Matrix (`[UTC, Pacific/Kiritimati]`); Scan Extended to Server Dirs Only (TZ-LINT-CI, Conv 375)
**Date:** 2026-07-08 (Conv 375)

`lint:tz` is wired into the `lint-and-typecheck` CI job (previously an ungated npm script), and the `test` job runs a **timezone matrix `['UTC', 'Pacific/Kiritimati']`** (`env: TZ: ${{ matrix.timezone }}`) — the UTC leg is prod parity, the +14 hostile leg is the host-local-bug detector. The guard's `SRC_SCAN_DIRS` is extended to `src/emails` + `workers` (0 violations); `src/components` (~60, client-side browser-local) and `.astro` (6, needs triage) are **excluded** and deferred to `[TZ-LINT-SCAN2]`.

**Complements** the Conv-091 "Claude Code PreToolUse Hook for lint-timezone Gate" entry (below): that hook (`.claude/hooks/pre-commit-lint-tz.sh`, in the **docs** repo under `$CLAUDE_PROJECT_DIR/.claude/`, registered in docs-repo `.claude/settings.json`) was *believed* to gate **CC-initiated** code-repo commits — but Conv 376 later proved it was **inert** (blocked nothing, missing `hookEventName`) until fixed, which is precisely why `lint:tz` was RED on baseline this conv (a pre-existing `recordings.ts` bare `new Date()`), so the hook was insufficient regardless. CI (runs on every push/PR regardless of author) + the hostile-TZ **test** matrix (which the static hook never ran) close that gap. (A mid-conv "the hook doesn't exist" claim was a repo-scoping error — it was looked for in the *code* repo `.claude/`; the hook lives in peerloop-docs `.claude/`.)

**Rationale:** A UTC CI host cannot catch host-local date bugs because `getUTC*() ≡ get*()` on UTC — boundary tests give zero protection there unless CI deliberately runs a non-UTC zone; the hostile-TZ leg is the only thing that makes CI enforce the UTC contract. Components run in the browser's local tz (a different concern) and would flood the guard red, so the scan stays server-side. Full suite verified passing under +14 (6810✓).

**See:** `.github/workflows/ci.yml`, `scripts/lint-timezone.sh`; complements this chunk's "Claude Code PreToolUse Hook for lint-timezone Gate" (Conv 091, still active); Conv 375.

### TZ Fixes Protected by Flip-Verified Runtime Tests; Analytics Bucketers Protected by Lint, Not Runtime Tests (TZ-TESTS, Conv 375)
**Date:** 2026-07-08 (Conv 375)

Pre-GO-LIVE test-shoring for the TZ-MODEL fixes uses **flip-verified runtime tests** for the high-value date-math sites (earnings `getPeriodDates` month/year rollover, moderation expiry helpers across DST, the `isValidTimezone` gate, signup→register timezone capture, `cleanup` UTC-day-boundary no-show date) and leaves the 7 near-identical analytics date-bucketers to the static `lint:tz` guard. A test only counts as protective if reverting the fix (`getUTC*`→`get*`, `Date.UTC`→`new Date`) makes it go **red** on the (non-UTC) dev host — every added test was flip-verified. +20 tests; 6 files exported private helpers for unit testing.

**Rationale:** Bucketer date keys derive from `toISOString()` (always UTC) over an epoch range, so a runtime test there would be contrived and give false confidence, whereas the exact regression is caught deterministically by `lint:tz` (verified by flipping a bucketer). Reserve runtime tests for real arithmetic logic; use lint for defensive hygiene. The whole suite stayed green through Phase 3 precisely because no assertion had been tz-sensitive — the flip-check is the missing acceptance criterion.

**See:** `tests/unit/{period-dates,expiry-helpers,is-valid-timezone}.test.ts`, `tests/api/auth/register.test.ts` (Timezone Capture), `tests/api/admin/sessions/cleanup.test.ts`, `scripts/lint-timezone.sh`; Conv 375.

### Server Date Math Must Be UTC-Explicit; the Vitest Host Runs in America/Toronto, Not UTC (TZ-MODEL Phase 3, Conv 374)
**Date:** 2026-07-08 (Conv 374)

Any server date arithmetic whose result is stored or compared must use the UTC accessors — `Date.UTC(...)` / `getUTC*()` / `setUTC*()` — never the local-zone `Date` constructor or `getDate`/`setDate`/`getMonth`. Applied in TZ-MODEL Phase 3(b) across 13 files (earnings `getPeriodDates`, 7 analytics bucketing loops, 3 moderation expiry helpers, `lib/cleanup.ts` notification stamps via `{timeZone:'UTC'}`).

**Rationale:** `vitest.config.ts` / `vitest.setup.ts` / `vitest.global-setup.ts` do **not** set `process.env.TZ`, so the suite runs in the machine's local zone (`America/Toronto`, UTC−4, confirmed via `Intl.DateTimeFormat().resolvedOptions().timeZone`) — NOT UTC, and NOT the same as the UTC Cloudflare Worker. Bare-`Date` server math therefore produces host-local (Toronto) boundaries in tests that silently diverge from production; UTC-explicit accessors are the only form that is both test-deterministic and production-correct. The divergence was latent (full suite stayed green at 6784✓ because no test pinned exact boundaries). Complements the Conv-010 DATE-FORMAT UTC-Z storage convention and the CLAUDE.md SQLite datetime rule.

**See:** `src/pages/api/me/{creator,teacher}-earnings.ts`, `src/pages/api/admin/analytics/*`, `src/pages/api/admin/moderation/*`, `src/lib/cleanup.ts`; Conv 374.

### STRIPE-E2E-DEV Deferred as 4-Tier Block with Explicit Dev→Staging→Live Value Chain
**Date:** 2026-04-21 (Conv 145)

Stripe integration confidence gap (between unit tests + one-shot staging live-verification + harness replay vs. real-browser-in-real-user-flow) is addressed by a deferred block — not inline work — with four scope tiers (A paper walkthrough / B scripted orchestrator / C Playwright E2E / D Claude-MCP-driven), an 11-scenario matrix, and 7 open questions for Plan Mode. Tier selection is delegated to a future Plan Mode session rather than defaulted.

**Rationale:** Conv 144 proved Stripe integration bugs can hide for 8 weeks (`constructEventAsync` silent 400s since Conv 114's CF Workers migration). The user explicitly asked for "as much assurance that we have a bullet-proof Stripe integration as I can before we go live" — a bigger frame than any single testing guide. Deferring with full context (rather than implementing in a rushed slice) lets Plan Mode pick the right tier intentionally; the block's "What Dev E2E testing buys us" section makes the *why* explicit so tier selection hinges on goals (team enablement / regression prevention / ad-hoc rehearsal) rather than effort alone.

**Consequences:** `PLAN.md` carries DEFERRED row #20 + ~160-line detail block. Claude-MCP browser-automation of Stripe Checkout is now on the roadmap (Tier D); Stripe Checkout's cross-origin iframe structure (card/expiry/CVC in separate `js.stripe.com` iframes for PCI isolation) is flagged as the decisive unknown for Tier D feasibility. The block is a durable artifact — next Plan Mode session starts from shared framing rather than reinventing the scope.

**See:** `PLAN.md §Deferred: STRIPE-E2E-DEV`

### `react-hooks/exhaustive-deps` Registered as `warn`; `rules-of-hooks` as `error`
**Date:** 2026-04-21 (Conv 143)

`eslint-plugin-react-hooks@^7.1.1` is now a devDep and registered in `eslint.config.js`. `react-hooks/rules-of-hooks` is `error` (genuine runtime crashes); `react-hooks/exhaustive-deps` is `warn` (high-signal but false-positive-prone, deferred to incremental triage). Activating the plugin surfaced 31 warnings across 26 files — tracked as `[LE-TRIAGE]` in `PLAN.md §POLISH.TECHNICAL_DEBT`.

**Rationale:** The plugin had been referenced by a single `// eslint-disable-next-line react-hooks/exhaustive-deps` comment in `MemberDirectory.tsx:141` since long before Conv 143, but had never been installed or registered — ESLint v10 (adopted in Convs 104-114 PACKAGE-UPDATES) newly errors on unknown rules in disable directives, which is how the gap surfaced. Error severity on `exhaustive-deps` would have blocked the baseline for a ~2-4 hour triage; `warn` activates detection across the whole codebase (127 React files, 405 hook occurrences) without blocking, and future convs touching these files will see the warnings inline.

**See:** `../Peerloop/eslint.config.js`, `PLAN.md §POLISH.TECHNICAL_DEBT [LE-TRIAGE]`

### `json<T>(response)` is the Canonical Test JSON Helper
**Date:** 2026-04-10 (Conv 102)

Test files read response bodies via `json<T>(response)` from `@api-helpers` instead of `await response.json() as any`. A ts-morph codemod (`scripts/codemods/migrate-test-json-as-any.ts`) migrated 1,587 sites across 198 test files in a single bisectable commit. `T` is a non-optional `{ field: any; ... }` shape inferred from the enclosing scope's top-level property accesses.

**Rationale:** Non-optional `any` fields catch top-level typos at compile time while preserving nested-access ergonomics (`body.stats.find(...)`, `body.data[0]`) that `as any` already provided. Optional/unknown variants break chained access. Completes an abandoned investment — the helper existed since an earlier conv but only 4 integration tests used it.

### ts-morph Codemods for Uniform Test Sweeps
**Date:** 2026-04-10 (Conv 102)

For mechanical test-file patterns where scope is >50 files and uniformity is >90%, write a ts-morph codemod rather than dispatching parallel subagents. Codemods produce one consistent style, a single bisectable commit, and a reusable template. Subagents produce N style variations and are harder to verify. Added `ts-morph@^27.0.2` as devDep; template lives at `scripts/codemods/migrate-test-json-as-any.ts`.

**Rationale:** In Conv 102 the `.json() as any` sweep ballooned from ~30 files to 1,587 sites across 198 files. Codemod wrote + ran + verified in under 1 hour; subagents would have been 2–4 hours with style drift.

### `futureAt(daysFromNow, utcHour=12)` for Time-Stable Test Dates
**Date:** 2026-04-10 (Conv 102)

Tests that need future dates for scheduling must use a helper that pins the hour to noon UTC rather than `new Date(Date.now() + Nh)`. The naive pattern can cross midnight when `Date.now()` falls in late UTC hours, exposing latent day-boundary bugs in code under test. Helper currently scoped to `tests/api/sessions/index.test.ts`; a project-wide sweep is tracked as task [TT].

**Rationale:** Five `sessions/index.test.ts` tests had been failing silently across unknown conversations because `isSlotWithinAvailability` checks only `startDate`'s day, and a midnight-crossing end time fails against any single-day availability window. Pinning to noon UTC eliminates the class of failure entirely.

### Branching Workflow Test Architecture
**Date:** 2026-03-05 (Session 342)

Multi-step workflow tests use a shared expensive setup (users, courses, enrollments, sessions) and branch into separate `describe` blocks at decision points. Shared helper functions (e.g., `setupCompletedSession(db)`) get to the decision point cheaply. Only branches where the decision changes downstream state are worth testing.

**Rationale:** The expensive part is building the world; branches are cheap once at the decision point. This gives N test variants for roughly the cost of 1.5 full tests. Integration tests cover branching logic (ms per branch); E2E tests cover only the 2-3 most critical happy paths.

**See:** PLAN.md WORKFLOW-TESTS block (4 workflow groups: BOOKING, COMPLETION, PAYMENT, MESSAGING)

### E2E Tests in CI with Local D1
**Date:** 2025-12-30

Keep E2E tests in CI; add `npm run db:migrate:local` step before tests.

**Rationale:** E2E in CI catches regressions; local D1 validates code works together.

### Vitest CLI Mode Only
**Date:** 2025-12-16

Use Vitest in CLI mode only (no GUI).

**Rationale:** User had bad experience with Vitest GUI; CLI-only approach is faster and more reliable.

### Playwright for E2E
**Date:** 2025-12-16

Use Playwright for E2E tests.

**Rationale:** Good Astro support; simpler than Cypress.

### Use Standard Vitest Config (Not Astro's getViteConfig)
**Date:** 2026-01-23

Use `defineConfig` from `vitest/config` instead of Astro's `getViteConfig` wrapper for test configuration.

**Rationale:** Astro's `getViteConfig()` starts file watchers that don't close properly, causing Vitest to hang after tests complete. Standard config with manual path aliases fixes this at the root cause. Tests don't need Astro-specific features.

**See:** `vitest.config.ts`, Session 71 Learnings

### Mock Astro Virtual Modules via Vitest Aliases
**Date:** 2026-02-19

Components that import Astro virtual modules (e.g., `astro:transitions/client`) fail to resolve in Vitest since the Astro Vite plugin isn't loaded. Add `resolve.alias` entries in `vitest.config.ts` pointing to mock files in `tests/helpers/`.

**Rationale:** Global aliases are cleaner than per-test `vi.mock()` calls and ensure every test file automatically gets the mock. Extends the "Standard Vitest Config" decision — since we don't use Astro's `getViteConfig`, we must manually alias any Astro virtual modules our components import.

**See:** `vitest.config.ts`, `tests/helpers/mock-astro-navigate.ts`

### E2E Flow Tests: Separate Specs per Lifecycle Phase
**Date:** 2026-03-05 (Session 335)

For multi-step flows with external dependencies (e.g., booking → BBB session → completion), create separate E2E specs per lifecycle phase rather than one monolithic test. Each spec includes dual-perspective verification (both parties see the result).

**Trigger:** Booking and session completion are naturally separated by days/weeks. Testing them as one flow requires mocking the entire middle (BBB session), creating fragile dependencies.

**Options Considered:**
1. Single test: book, mock BBB, webhook, verify — tests the chain but couples unrelated phases
2. Separate specs per phase: booking wizard + verification, webhook completion + verification ← Chosen

**Rationale:** Independent specs have no ordering dependencies, use the most appropriate strategy per phase (UI wizard for booking, direct API call for webhook), and mirror real user flows. Mock only what's environment-dependent (availability API), let everything else run real.

**Consequence:** `e2e/session-booking-flow.spec.ts` and `e2e/session-completion-flow.spec.ts`. Seed data needs "headroom" (more modules than sessions) so parallel tests can create records without exhausting capacity.

> **Insight:** The minimal mock boundary matters — mocking only the availability API (which is date/environment-dependent) while running session creation, notifications, and module resolution real gives far more confidence than mocking the whole booking endpoint. The webhook test has zero mocks, directly calling the real endpoint. (Session 335)

### E2E Tests Must Be Resilient to DB State Drift
**Date:** 2026-03-25 (Conv 029)

E2E tests that check seed data must use general assertions (regex counts, `>= 1` checks) rather than exact values. Mutation tests (delete, mark-read) permanently alter the dev D1 database, and other tests (booking flow) create additional records. Tests should verify component behavior, not specific seed data.

**Rationale:** Exact-count assertions (`toHaveCount(2)`, `getByText('2 notifications')`) break on re-runs when prior mutation tests have altered DB state. General assertions (`/\d+ notification/`, `count >= 1`) verify the same behavior without coupling to seed data. A periodic `npm run db:reset:local && npm run db:setup:local:dev` restores clean state when needed.

**Consequence:** Notification tests rewritten with general assertions. Pattern applies to any E2E test checking counts or specific records that other tests may create/modify.

### Decompose Large Components Before Testing
**Date:** 2026-01-23 (Updated: Session 75)

Before writing tests for a page component, analyze section sizes:
1. Identify any section >40 lines → extract as subcomponent
2. If 2+ sections exceed 40 lines → full decomposition warranted
3. Test subcomponents individually, then integration

**Rationale:** Original threshold (>200 lines or 5+ sections) was too coarse. A designer will be styling all pages and may significantly expand what are currently minor sections. The 40-line threshold ensures components remain testable and maintainable even after styling expansion. Decomposition also enables isolated testing, improves maintainability, and allows subcomponent reuse.

**See:** PLAN.md TESTING.PAGES process

### Retroactive Decomposition Review Results
**Date:** 2026-01-23

Reviewed 5 already-tested components that exceeded 200-line threshold:

| Component | Lines | Sections | Verdict |
|-----------|-------|----------|---------|
| CourseBrowse.tsx | 491 | 8 | HIGH priority - needs decomposition |
| SignupForm.tsx | 350 | 7 | MEDIUM - extract OAuthButtons |
| LoginForm.tsx | 238 | 6 | MEDIUM - extract OAuthButtons (shared) |
| STDirectory.tsx | 259 | 5 | Acceptable as-is |
| CreatorBrowse.tsx | 227 | 5 | Acceptable as-is |

**Key findings:**
- STDirectory and CreatorBrowse are borderline (5 sections) but well-organized; decomposition would add complexity without clear benefit
- OAuthButtons component (~80 lines of SVG) is duplicated between LoginForm and SignupForm; extraction would benefit both
- CourseBrowse has same complexity as CourseDetail; should extract FilterSidebar, FilterPills, Pagination, MobileDrawer

**See:** PLAN.md TESTING.PAGES retroactive review section

### PLATO Test Framework — API Flow Testing Layer
**Date:** 2026-03-30 (Conv 060), updated 2026-03-31 (Conv 061 — Model B pivot)

PLATO is a new test layer that tests user goals by executing API call sequences through real handlers with a real in-memory database. Unlike unit tests (which mock dependencies) or E2E tests (which drive browsers), PLATO proves the server-side write chain works end-to-end. First run (creator-publishes-course) completed in 202ms and immediately found a real production bug (`joined_via` CHECK constraint missing `'registration'`).

**Architecture (Model B — Conv 061):** Sequential DB-accumulation. Runs execute in fixed order; each deposits data into the DB. No cross-run carry state — the DB is the only truth. Supersedes Model A (composable segments with dependency graph and topological sort) because carry state hid integration gaps. Page-visit model: each run models page visits with button presses that trigger API calls. `$context` provides intra-run data flow ("what the page showed the user"); context is cleared between runs.

**Key rules:**
- **No direct DB inserts.** If PLATO can't create data through an API, that's a finding, not a reason for a workaround.
- **Happy path only.** Stumbles (bad input, wrong password) are single-step concerns tested at the unit/API layer (see STUMBLE-AUDIT block).
- **Route, not navigation.** Runs declare WHERE the action happens, not HOW the user gets there.
- **API emulation, not Playwright.** PLATO calls endpoints directly (~200ms, deterministic). Playwright is reserved for targeted E2E tests. The developer must manually walk each run in the browser to verify the UI can trigger the API calls.
- **Discovery GETs.** Runs that need data from prior runs start with a GET (the same call the page would make), not carry state.
- **`fromDB` actor resolution.** Runner queries users table by persona email — no cross-run identity carry.

**Rationale:** 6362 tests all insert data via SQL — none test the creation path. Model B breaks fast and loudly: if the DB doesn't have the data, the test fails. API emulation avoids Playwright's "fast and garbled muttering" (flakiness from hydration timing, animation delays, selector brittleness).

> **Insight:** The gap between "data exists in the database" and "the app can create that data" is invisible to conventional test suites. Seed-data-based testing creates a false sense of coverage by skipping the exact code paths users exercise. PLATO makes this gap visible by construction.

> **Insight:** Carry state between test segments is an anti-pattern for integration testing. If data must be passed explicitly between steps, you never discover that the real system doesn't provide it. Sequential DB-accumulation forces each step to discover its data the same way a user would — through the UI (or its API equivalent). The rigidity of fixed ordering is the feature, not a limitation.

**See:** `docs/as-designed/plato.md`, `tests/plato/`, `docs/reference/PLATO-GUIDE.md`, PLAN.md PLATO block

### Rename apiCalls → plannedApiCalls in Page Spec JSON
**Date:** 2026-01-27

Renamed `apiCalls` to `plannedApiCalls` across the Zod schema (`PageSpecSchema`), `PageSpecView.astro`, all 66 page JSON files, and helper scripts. The `testCoverage.apiTests` section (populated from shell scripts) serves as ground truth for what's actually built and tested.

**Rationale:** The `apiCalls` field contained a mix of implemented and aspirational endpoints (e.g., `/export` never built). Renaming to `plannedApiCalls` preserves all spec data while eliminating ambiguity. Two clear layers: "what was designed" (`plannedApiCalls`) vs "what exists" (`testCoverage.apiTests`).

**See:** `src/lib/schemas/page-spec.ts`, Session 126 Decisions

### Exclude Seed Data from Test Database
**Date:** 2026-01-28

The `resetTestDB()` function skips migration files containing "seed" in the filename. Tests use only `0001_schema.sql`, not `0002_seed.sql`.

```typescript
// In tests/helpers/test-db.ts
const files = fs.readdirSync(migrationsDir)
  .filter((f) => f.endsWith('.sql') && !f.includes('seed'))
  .sort();
```

**Options Considered:**
1. Rename seed file during tests (fragile, file system manipulation)
2. **Filter out seed files in `resetTestDB()`** ← Chosen
3. Have each test clear tables before inserting data (requires updating every test)

**Rationale:** Tests must control their own data. Seed data pollutes test state and causes:
- Count mismatches (test expects 4 enrollments, gets 10 due to seed data)
- Flaky assertions that pass due to seed data accidentally satisfying conditions
- Tests written with overly permissive assertions (`>= 4` instead of `toBe(4)`) to accommodate unknown seed data

**Consequences:**
- Tests have clean, isolated data
- Each test file sets up exactly the data it needs
- Integration tests that specifically validate seed data can use a separate `reseedTestDB()` helper

**See:** `tests/helpers/test-db.ts`, Session 135 Decisions

### SSR Testing: Extract to Testable Functions
**Date:** 2026-01-28

Extract SSR data fetching logic from .astro frontmatter to testable functions in `src/lib/ssr/`. Each page's data fetching becomes a pure function: `(db) → data | error`.

**Context:** 17 pages query D1 directly in Astro frontmatter. This layer was untested because .astro files can't be easily unit tested.

**Options Considered:**
1. **Extract to `src/lib/ssr/` functions** ← Chosen
2. Use E2E tests to implicitly cover SSR layer
3. Accept the gap for MVP

**Rationale:** Enables fast, isolated unit tests without Astro rendering complexity. E2E alone would be slow and wouldn't isolate SSR issues.

**Related:** SSR errors should show error pages, not empty content. Layouts need error boundary support.

**See:** PLAN.md TESTING.SSR, Session 138 Decisions

### API Test File Naming: Path-Mirroring Convention
**Date:** 2026-03-04 (Session 329)

Test files must mirror the API source path structure exactly. `src/pages/api/me/communities/[slug]/members.ts` → `tests/api/me/communities/[slug]/members.test.ts`.

**Rationale:** Path-mirroring enables automated coverage audits via `comm -23` between source and test paths. Flattened names (e.g., `slug-members.test.ts`) create false positives that require manual verification. The convention was already used by 95%+ of test files.

### 100% API Endpoint Test Coverage
**Date:** 2026-03-04 (Session 329)

All 211 API endpoints have corresponding test files (210 test files, with one covering 3 related progression endpoints). Each test covers at minimum: auth (401), authorization (403), success case, and error handling (503).

**Rationale:** The final 7 gaps were closed in one session. The process itself caught a real bug (`courses/[id]/sessions.ts` used invalid enrollment status `'active'`), validating the investment.

---

### Multi-User Manual Testing: Two Browser Vendors, No Code Changes
**Date:** 2026-03-12 (Session 380)

For testing two-sided interactions (student ↔ teacher, booking ↔ BBB), use two different browser vendors (e.g., Chrome + Safari) rather than code-level tab isolation. Each browser has independent cookies and localStorage, giving full session isolation with zero production code changes.

**Trigger:** User wanted per-tab localStorage scoping for simultaneous multi-user sessions.

**Options Considered:**
1. Tab-scoped auth tokens (sessionStorage + Authorization header)
2. Dev-mode impersonation (`?_as=userId` middleware)
3. Two browser vendors ← Chosen

**Rationale:** HTTP-only auth cookies are shared across all tabs in the same browser — scoping localStorage alone is insufficient. Code-level solutions would add dev-only infrastructure to the production codebase. Two browsers solve the 90% case (two simultaneous users) for free.

**See:** `docs/reference/BEST-PRACTICES.md` §8, `docs/reference/CLI-TESTING.md`

### Live Stream API Seeding for Feed E2E Tests
**Date:** 2026-03-19 (Conv 018)

Smart feed E2E tests use real Stream.io activities (not mocks) created by `scripts/seed-feeds.mjs`. The script calls the Stream REST API to create 14 activities + 17 reactions, then dual-writes `feed_activities` rows to D1 with the returned `stream_activity_id`. This ensures the full smart feed pipeline (D1 candidate selection → Stream enrichment → scoring → rendering) is tested end-to-end.

**Rationale:** The smart feed's value is its ranking algorithm, which depends on real engagement signals from Stream (`reaction_counts`). Mocking would test UI rendering but not the actual scoring. Feed seed is the only setup level that makes external API calls.

**See:** `scripts/seed-feeds.mjs`, `e2e/smart-feed.spec.ts`, `npm run db:setup:local:feeds`

### webhook_log Table for Payload Capture
**Date:** 2026-03-27 Conv 037

Added `webhook_log` table with fire-and-forget INSERTs at the top of all 3 webhook handlers (bbb.ts, bbb-analytics.ts, stripe.ts). Captures raw payloads for fixture generation and variability analysis. Auth headers are redacted for security.

**Rationale:** Durable, queryable, in-context (knows which handler received it). Payloads can be extracted via `wrangler d1 execute` for test fixture generation. May be replaced by proper API logging later.

**See:** `migrations/0001_schema.sql` (webhook_log table), `src/pages/api/webhooks/`

### PLATO Persona Fields: DB-REQUIRED vs SITE-NECESSARY
**Date:** 2026-03-31 (Conv 062)

PLATO persona files organize entity fields into two comment-delimited sections: **DB-REQUIRED** (fields needed to pass publish/validation gates) and **SITE-NECESSARY** (fields that a diligent user would fill out for a complete experience). Runs send both categories. Flat structure with no conditionals — copy a persona block and change values to create a new variant.

**Rationale:** The publish gate tests minimum validity, not user experience completeness. PLATO should model what a real user does, not just what passes validation. Section comments make the distinction self-documenting without adding runtime complexity.

> **Insight:** Test frameworks that only satisfy validation gates miss the user experience surface area — the same gap that causes empty product pages in production despite all tests passing.

**See:** `tests/plato/personas/genesis.ts`, `docs/reference/PLATO-GUIDE.md`

### PLATO Scenario Layer — Independent Goal-Driven Compositions
**Date:** 2026-03-31 (Conv 063)

PLATO gains a "Scenario" layer above individual runs. A scenario is an independent, goal-driven composition of runs with its own persona set, chain steps, and DB verification. Three scenario categories: `test` (critical path validation), `seed` (replace SQL seed data), `repro` (reproduce observed issues). Scenarios are self-contained — each declares its personas, chain order, actor bindings, and expected DB state.

**Key design choices:**
- **findBy in extractPath:** `courses.findBy(title,$persona.courseTitle).id` enables multi-course discovery without carry state. Custom parseDotPath() handles paren-aware dot splitting.
- **Actor bindings:** `RunRef.actorBindings` remaps persona keys to run actor slots, so the same run (e.g., enroll-student) works with different students without modification.
- **Scenario-level DB verification:** Per-run verify blocks are sanity gates; scenario verify proves the intended situation was reproduced with comprehensive state checks.

**Rationale:** Independent scenarios enable ad-hoc creation ("generate a new scenario to test X"). The findBy pattern is declarative and backward-compatible. Actor bindings keep runs atomic — they never know which persona is using them.

> **Insight:** Separating one-time setup operations (Stripe Connect) from per-entity operations (teacher certification) is critical for composable test runs. When a run combines both, it works for the first invocation but fails on subsequent ones. Atomic runs that do exactly one thing compose cleanly in any scenario.

**See:** `tests/plato/scenarios/`, `tests/plato/lib/types.ts` (PlatoScenario), `tests/plato/lib/api-runner.ts` (executeScenario)

### PLATO Four-Concept Taxonomy (step / scenario / persona set / instance)
**Date:** 2026-04-01 (Conv 068)

Adopted four-concept taxonomy to resolve "run" ambiguity: **Steps** are atomic action templates (data-independent). **Scenarios** compose steps into sequences with verification. **Persona Sets** provide the data. **Instances** bind scenarios to persona sets with an execution mode (test/seed/walkthrough/repro). Renamed `run` → `step` across 30+ files (~150 replacements). Instances are future work — currently implicit via hardcoded personaSet in scenario files.

**Rationale:** "Run" was both a noun (a test run) and a verb (run the test), causing confusion. The four concepts map cleanly to three use cases: canned seed data, automated test execution, and ad-hoc reproduction scenarios.

> **Insight:** When domain terminology is ambiguous between "the thing" and "the act of doing the thing" (run/run, build/build), splitting into separate concepts with distinct names eliminates an entire class of communication errors. The cost of renaming is front-loaded; the clarity benefit compounds.

**See:** `docs/as-designed/plato.md`, `tests/plato/steps/`, `tests/plato/lib/types.ts`

### PLATO Instance Architecture: Inline Scenarios + When Guards + Accumulation
**Date:** 2026-04-01 (Conv 069)

Built PlatoInstance/PlatoInstanceFile types with `when` predicate guards on StepRef, multi-instance execution against same DB (accumulation), inline scenario support, and WalkthroughCheckpoint type for STUMBLE pairing. Instances solve the general parameterization problem — any future scenario variant uses the same infrastructure.

**Rationale:** The `when` guard is the minimal mechanism for conditional steps. `executeInstanceFile()` swaps persona data per-instance and delegates to existing `executeScenario()`. The existing architecture (actorBindings, runtimeOverrides) was already designed for pluggable data — instance is the next logical layer up.

> **Insight:** When an orchestration layer works on first try with zero changes to the underlying execution engine, it validates the original architecture's extensibility. The cost of the instance system was ~300 lines of new code with no modifications to existing step execution, value resolution, or mock management.

**See:** `tests/plato/lib/types.ts`, `tests/plato/lib/api-runner.ts`, `tests/plato/instances/`

### STUMBLE-AUDIT Formalization: Lightweight Pairing with PLATO Instances
**Date:** 2026-04-01 (Conv 069) — *Superseded by BrowserIntent (Conv 074)*

Added WalkthroughCheckpoint type to PLATO instance files. Execution uses accumulate-with-checkpoints model (walk sub-flow, batch findings, pause for triage). Issues captured as TodoWrite tasks with severity (broken/confusion/cosmetic) and source tag.

**Rationale:** Instance file is the natural home for "what to check in browser." Lightweight structure avoids over-engineering while ensuring findings are captured persistently. PLATO proves API correctness; STUMBLE proves UI correctness. Contract mismatches between API response shapes and component expectations only surface when the browser actually renders — validating the complementary pairing.

### CTE Cross-Reference Limitation: Use JOINs for Enrollment Lookups in D1 INSERT
**Date:** 2026-03-31 (Conv 065)

In the D1/better-sqlite3 test environment, CTEs that reference other CTEs via scalar subqueries return NULL when used inside INSERT...SELECT statements. Single-level CTEs work fine. For enrollment lookups (which depend on user + course CTEs), use explicit JOINs on base tables instead: `FROM enrollments e JOIN users u ON e.student_id = u.id JOIN courses c ON e.course_id = c.id WHERE u.email = ? AND c.title = ?`.

**Rationale:** The CTE limitation may be a SQLite/better-sqlite3 quirk. JOINs are proven reliable, self-contained per step, and avoid silent NULL propagation. Additionally, INSERT...SELECT with UNION ALL reports success even when 0 rows are inserted, so splitting into individual INSERT steps per enrollment is more debuggable.

> **Insight:** When working with SQLite CTEs in INSERT context, prefer explicit JOINs over CTE cross-references for reliability. The verbosity cost is minor compared to the debugging cost of silent NULL propagation.

### PLATO Terminology: One System, Two Modes
**Date:** 2026-04-02 (Conv 073)

PLATO is one system with two execution modes: API mode (Vitest, in-memory DB, mocked externals) and Browser mode (dev server, real D1, real UI). "Run" = one execution of an instance. STUMBLE-AUDIT is a PLAN.md project block name only, not a separate system. Supersedes the PLATO run / STUMBLE walkthrough terminology from Conv 060.

**Rationale:** "STUMBLE" was overloaded — used as both a system name and a project block. WalkthroughCheckpoint already lives in PLATO's type system, confirming it's architecturally one system. Two modes is clearer than two systems.

### Defer PLATO Segments to PLATO-ON-STEROIDS Block
**Date:** 2026-04-02 (Conv 073)

All segment implementation deferred. Current primitives (StepRef + actorBindings + sequential instances) are sufficient for all envisioned scenarios at current scale (4 scenarios, 2 instances). Segments are DX convenience, not capability unlock.

**Rationale:** Multi-student, post-enrollment, restartability, and step group reuse all work without segments. Created PLATO-ON-STEROIDS deferred block (#41) capturing the full vision: composable data, segments, DB snapshots, automated agent walkthroughs.

> **Insight:** When a new abstraction layer doesn't unlock capabilities that existing primitives can't achieve, it's DX debt disguised as architecture. Defer until scale forces the issue.

### PLATO Snapshot Bridge: Always-Regenerate
**Date:** 2026-04-02 (Conv 073)

`better-sqlite3.serialize()` dumps in-memory DB to a Buffer, copied to wrangler's D1 SQLite file. `npm run plato:restore -- <name>` always regenerates (API-run + restore in one command). No caching — every restore regenerates from current code.

**Rationale:** API-run takes ~400ms — faster than thinking about staleness. Eliminates entire class of bugs (stale schema, stale persona data, stale steps). Snapshots are gitignored.

### PLATO Snapshot Coverage: 7/8 Instances Snapshotted; new-user-pair Self-Building
**Date:** 2026-06-27 (Conv 342)

Browser instances whose data diverges from the dev seed get their own generated `.sqlite` snapshot (`snapshot: true`) rather than being re-pinned to the dev seed or seeding genesis personas into `migrations-dev`. This extends the established `flywheel` snapshot pattern to member-directory/activities/ecosystem, bringing snapshot coverage to 7/8 instances. **new-user-pair is the principled exception** — it stays self-building (no snapshot) because its walkthrough's focus *is* the register/onboarding flow; a restored snapshot would pre-create its users and bypass exactly what the instance verifies.

**Rationale:** Re-pinning to the dev seed breaks each instance's own `verify` (e.g. member-directory asserts COUNT=2 vs the dev seed's ~10) and loses minimal-data edge cases; seeding genesis personas into `migrations-dev` pollutes the dev seed and still fails COUNT=2. Snapshot generation costs zero instance/verify rewrites, keeps data faithful and isolated, and is write-only-on-pass against the in-memory test DB (`plato-scenarios.api.test.ts:400` gates on `result.status === 'pass'`; it serializes `getRawTestDB()`, never the dev D1) — so the flag cannot regress the green baseline or mutate the dev server. The snapshot pattern fits instances whose setup is condensed preamble to a feature-walk; new-user-pair is the inverse, so it stays self-building.

**Consequences:** `snapshot: true` added to member-directory/activities/ecosystem; 3 `.sqlite` generated (gitignored). new-user-pair documented as a deliberate self-building exception in PLAN + `PLATO-REGISTRY.md`. Surfaced a latent bug while wiring this up: the instanceFile-level `verify` path is not exercised by `npm test` for Scenario-only instances, so `activities` carried a stale `expected: 7` availability assertion (the step creates 5 weekday slots) — fixed 7→5; gating the instanceFile path is a candidate `[E2E-GATE]` follow-up.

**See:** `tests/plato/PLATO-REGISTRY.md`, `tests/plato/instances/`, PLAN.md § PLATO-REVIVE

### PLATO `expect` Is a Frozen Legacy Spec — Triage Before Editing; Genuine Gaps Keep `// GAP` Marker
**Date:** 2026-06-27 (Conv 343)

A PLATO browser-mode `expect`/`pageAction` was written against the *original* pre-Matt pages, so it is a frozen functional spec of legacy behavior — **not** a description of the current page. When an audit finds a "missing UI element" on a Matt-ported page, do NOT edit the test prose to match the page. First triage the absence against the legacy preflip source (`608346a2`) into one of three buckets: **REDESIGN** (renamed/relocated, capability intact), **REGRESSION** (behavior dropped in the legacy→Matt port — a failed port), or **NEVER-EXISTED** (prose over-claimed UI that was never built; the automated step hits the API directly and passes). Editing a test to match a regressed page would silently hide the regression — PLATO is the canary. The Conv-343 sweep of all 5 instances triaged 7 absences → **0 regressions** (all REDESIGN or NEVER-EXISTED), confirming high Tier-1/Tier-2 port fidelity.

For NEVER-EXISTED steps that are **genuine product gaps** (backend exists, no UI — Follow-wire, creator self-certify UI, homework per-module upload), keep the aspirational intent and add a `// GAP (Conv NNN):` marker (records what's missing, that the backend exists, the not-a-regression verdict, and the `[PLATO-GAP]` tracker) rather than thinning the prose to API-only reality. Pure REDESIGN steps just become accurate.

**Rationale:** Editing the test to match a possibly-regressed page hides exactly the regression PLATO exists to catch; the legacy source-of-truth must be read before concluding. Keeping aspirational prose + a `// GAP` marker preserves PLATO as both a desired-UI spec and a visible to-do, rather than silently shrinking the test to match a thinner reality.

**Consequences:** ~50 `expect`/`pageAction` fixes (REDESIGN→reality) across 5 instances; `// GAP (Conv 343)` markers in activities/ecosystem; `[PLATO-GAP]` #15 logged (build the 3 backend-ready UI gaps); 2 stale code-comments corrected. Saved as memory `feedback_plato_expect_is_legacy_spec`. If the gaps are built, re-sync the corresponding PLATO prose (drop the GAP markers).

**See:** `tests/plato/instances/*.instance.ts`, memory `feedback_plato_expect_is_legacy_spec`, PLAN.md § PLATO-GAP, Conv 343.

### BrowserIntent Replaces WalkthroughCheckpoint
**Date:** 2026-04-02 (Conv 074)

WalkthroughCheckpoint replaced by BrowserIntent: `navigate: { via, clicks: NavClick[] }` for deterministic navigation, `pageAction: string` for prose instructions, `coversStepActions` for API-run cross-reference. Navigation is structured (fail-fast on missing UI elements); page actions remain prose to avoid building a Playwright DSL.

**Rationale:** WalkthroughCheckpoints "teleported" to pages via address bar URLs instead of navigating like real users. BrowserIntent captures the deterministic navigation contract without over-engineering page interactions. The hybrid split (structured nav + prose actions) matches the natural boundary: navigation is mechanical, page actions are contextual.

> **Insight:** When automating user journeys, the navigation/action boundary is the natural seam for structured vs unstructured specification. Navigation has finite, enumerable paths through a known graph. Page actions are combinatorially complex. Structuring navigation enables fail-fast validation; keeping actions as prose avoids an ever-expanding DSL.

**See:** `tests/plato/lib/types.ts` (BrowserIntent, NavClick), `tests/plato/lib/navigation-helper.ts`

### Route↔API Map: Self-Maintaining Scanner Pipeline
**Date:** 2026-04-02 (Conv 074)

Single scanner script (`scripts/route-api-map.mjs`) generates both TypeScript lookup (`tests/plato/route-map.generated.ts`) and Markdown reference (`docs/as-designed/route-api-map.md`) from source code analysis. BFS from nav components (AppNavbar, AdminNavbar, DiscoverSlidePanel) computes reachability. Wired into `/r-end` docs agent for auto-regeneration on API/component changes.

**Rationale:** Code needs the data (PLATO navigation helpers). Humans need the reference (scenario authoring). One source of truth prevents drift. Stats: 96 pages scanned, 195 API endpoints, 89 reachable routes.

**See:** `scripts/route-api-map.mjs`, `tests/plato/route-map.generated.ts`, `docs/as-designed/route-api-map.md`

### Per-Route `export const noNav = true;` Annotation for Designed-Unreachable Routes
**Date:** 2026-05-21 (Conv 168 established; Conv 169 swept across remaining 19 routes)

Routes that are legitimately unreachable from the main navigation graph (footers, 404, role-gated admin, role-conditional tabs reached via in-page switching, 301-redirect shims) opt out of `route-api-map.mjs`'s `⚠️ no discovered nav path` warning by adding `export const noNav = true;` to their `.astro` frontmatter. The scanner reads the declaration via `parseNoNav(content)` and emits `ℹ️ no-nav by design` instead. Convention: include a brief one-line comment naming the category (e.g., `// Public footer page — reached from public footer, not AppNavbar`).

**Rationale:** Per-route declarative locality outperforms a scanner-wide whitelist for "expected unreachable" routes — the file that knows it's no-nav declares it; new no-nav routes self-document at creation time; central whitelists drift as the codebase evolves. Output continues to distinguish `⚠️` (real concern) from `ℹ️` (intentional). Applied first to `/course/[slug]/[tab]` (CRT role-tab catch-all reached via CourseTabs switching); Conv 169 completed the sweep across 19 additional routes (14 footer/marketing pages, /404, /admin/recordings, 3 /discover/* 301-redirect shims) — `[RAM-NONAV-SWEEP]` done. Zero `⚠️ no discovered nav` warnings remain in scanner output; 20 routes report `ℹ️ no-nav by design`.

**See:** `scripts/route-api-map.mjs` (`parseNoNav` helper at line 90), `src/pages/course/[slug]/[tab].astro`

### Diagnostic Instances Are Ephemeral
**Date:** 2026-04-02 (Conv 074)

Diagnostic segments (instances created to isolate bugs) are deleted when their bugs are fixed. If the journey is independently useful, promote to a named scenario. Git history preserves the diagnostic if needed later. Taxonomy: Scenario (permanent, proves a journey), Diagnostic segment (ephemeral, isolate bugs), Derived scenario (promoted from diagnostic if useful).

**Rationale:** PLATO-REGISTRY should track permanent scenarios, not ephemeral debug probes. Accumulating stale diagnostic artifacts creates confusion about what's canonical.

### PLATO Navigation Rules: Same-Page First, Then AppNavbar
**Date:** 2026-04-02 (Conv 074)

Deterministic navigation rules for BrowserIntent: Rule (a) if target route has a link/button on the CURRENT page → `via: 'same-page'`. Rule (b) if not → start from AppNavbar, follow BFS shortest path. Implemented in `suggestNavigation()` helper. `outboundLinks` added to RouteInfo to support rule (a) checks.

**Rationale:** Users naturally click links on the current page before going to the sidebar. This matches real user behavior and produces the most natural-looking browser-runs.

**See:** `tests/plato/lib/navigation-helper.ts`

### getNow() Enforcement via Lint Rule
**Date:** 2026-04-06 (Conv 089, completed Conv 090)

Complete sweep of server-side files to replace bare `new Date()` with `getNow()` from `@lib/clock`. Conv 089 converted 22 files and added the lint rule; Conv 090 completed the sweep with 25 more files (47+ total) and added `// getNow-exempt` comments to ~12 files with legitimate uses. Extended `lint-timezone.sh` with source-file scan that catches future `new Date()` and `Date.now()` in API routes and lib code. Supports `// getNow-exempt` inline comments for legitimate uses (clock.ts itself, health checks, debug endpoints, DB timestamp utility, R2 metadata, performance timing, JWT expiry).

**Rationale:** `getNow()` abstraction existed since Conv 003 but only 4 files used it — infrastructure without enforcement drifts. The lint rule closes the feedback loop. PLATO proof-of-fix validated by restoring realistic `America/New_York` availability (was all-day UTC workaround). Conv 090 proved that post-hoc sweeps are inherently incomplete — the "comprehensive" Conv 089 sweep missed 25+ files.

> **Insight:** Creating an abstraction is necessary but not sufficient — without a lint rule or other enforcement mechanism, new code will bypass it by default. The gap between "4 files using getNow()" and "22+ files using new Date()" accumulated silently over 86 convs. Even with the lint rule, enforcement is only advisory (manual `npm run lint:tz`) — promoting to a pre-commit hook or CI gate would prevent recurrence.

### Claude Code PreToolUse Hook for lint-timezone Gate
**Date:** 2026-04-06 (Conv 091)

> **Still active + complemented (Conv 375); was INERT until Conv 376:** this hook DOES exist and is registered — it lives in the **docs** repo (`$CLAUDE_PROJECT_DIR/.claude/hooks/pre-commit-lint-tz.sh` + docs-repo `.claude/settings.json`), NOT the code repo. **Correction (Conv 376):** despite being registered + matching + running the right lint, it **blocked nothing** from creation until Conv 376 — the deny JSON omitted the required `hookSpecificOutput.hookEventName:"PreToolUse"`, so the decision was silently ignored and even CC-initiated code commits proceeded on a red `lint:tz` (this is why `lint:tz` was RED on baseline in Conv 375 — the hook had never been enforcing). Conv 376 fixed the emit to `jq -nc` + `hookEventName` and scoped the matcher case-sensitively (`grep -qE`, dropping `-i`) so it no longer over-matches `peerloop-docs` commits — see DOC-DECISIONS.md §3 "TZ Pre-Commit Hook Was Inert Since Conv 091…". Conv 375 also added CI enforcement (covers human/IDE/PR + runs `lint:tz` on every push) and a hostile-TZ **test** matrix — see "`lint:tz` Enforced in CI…" at the top of this chunk. The layers are complementary. The `// tz-exempt` / `// getNow-exempt` conventions below remain valid.

`lint-timezone.sh` promoted from advisory to enforced gate. Two options considered: (1) git pre-commit hook via husky (gates all committers), (2) Claude Code `PreToolUse` hook (gates Claude commits only). Option 2 chosen.

**Rationale:** Claude is currently the sole committer. Adding husky introduces a build dependency and configuration surface for a single-dev project. The Claude Code hook intercepts `Bash` tool calls matching `git commit` targeting the code repo, runs `lint-timezone.sh`, and returns `{"permissionDecision": "deny"}` with the violation output on any FAILs. Human git commits bypass it — documented fragility in `docs/as-designed/lint-timezone.md` with clear mitigation path (add husky + CI when a second developer joins).

**Also added (Conv 091):** `// tz-exempt` suppression comment for test-file Phase 1 FAILs, paralleling the existing `// getNow-exempt` for source-file Phase 2 FAILs. Used for intentional local-time Date constructs in tests (e.g., `toISO` format tests that verify local-time output).

**See:** `docs/as-designed/lint-timezone.md`, `.claude/hooks/pre-commit-lint-tz.sh`

### Canonical Feed Seed: `scripts/seed-feeds.mjs` Wired into `db:setup:local:dev`
**Date:** 2026-06-12 (Conv 271)

`scripts/seed-feeds.mjs` is the **single canonical feed seed** — it writes real activities to Stream and dual-writes the returned IDs into D1, producing working content (real Stream UUIDs, real reactions). The 28 dangling SQL `feed_activities` rows in `migrations-dev/0001_seed_dev.sql` are **removed** (left as a breadcrumb), and `db:setup:local:dev` now ends with `db:seed:feeds:local`. The script is **creds-resilient**: a machine without Stream credentials skips the feed seed gracefully rather than failing the whole setup. Also fixed a real bug surfaced by making the path canonical — the script wrote `feed_type='townhall'` which fails the schema CHECK (`system`/`community`/`course`); Stream addressing (group `'townhall'`) is now decoupled from D1 addressing (`feed_type='system'`).

**Rationale:** A pure-SQL seed can only store a dangling pointer — Stream activity IDs are minted by Stream when an activity is created, so the seed must call the service, not fabricate IDs. One dataset with real IDs beats two datasets where the SQL one renders "empty" posts via the `buildPlaceholderActivity` enrichment fallback. Making the optional/untested script canonical surfaced the dormant `feed_type` CHECK failure that "worked in isolation" only because nobody exercised it.

**See:** `scripts/seed-feeds.mjs`, `migrations-dev/0001_seed_dev.sql`, `package.json`

### Discovery-Rail Source Tables Freshened via the Seed's Relative-Date Mechanism (PART C)
**Date:** 2026-06-12 (Conv 272)

The discovery rails compute `new` (created <30d) and `trending` (velocity <7d) signals, so source rows with fixed historical seed dates never populate them — 4/6 rails were empty in dev. Fixed by extending the seed's existing **"TIMESTAMP FRESHNESS"** section (post-INSERT `strftime('now','-N days')` UPDATEs) with a new **PART C: DISCOVERY RAILS FRESHNESS** that freshens the rail-source tables (courses / communities / progressions / community_resources / enrollments / community_members) with id-targeted, inversion-safe UPDATEs. Freshened dates store ISO `T`-format (`strftime('%Y-%m-%dT%H:%M:%fZ',…)`) to match the JS `.toISOString()` cutoff the compute compares against (the SQLite-datetime pitfall). All 6 rails populate after re-seed; `migrations-dev/0001_seed_dev.sql` +34 lines.

**Rationale:** Reuses the established, durable freshness mechanism rather than hardcoding new dates that would re-stale or leaving the rails cold-start-empty. Inversion-safety rule: when freshening an entity's date, pick rows with NO conflicting dependents or freshen the whole dependent sub-tree in step — else you invert a timeline (e.g. a completed-in-2024 enrollment predating a course created 6 days ago).

**See:** `migrations-dev/0001_seed_dev.sql` (§PART C: DISCOVERY RAILS FRESHNESS)

### Test Expectations Track Settled Behavior, Not In-Flight UI; Ground-Truth Divergence = Stale-Test
**Date:** 2026-06-15 (Conv 287)

When an e2e/integration assertion diverges from runtime, resolve it against **ground truth** (code comments, seed rows, schema) before touching anything. If ground truth proves the app/seed is correct and intentional (e.g., admin-only system feed citing Conv 259 in a code comment; an explicit `in_progress` seed enrollment with a deliberate `enrolled_at` bump), it is a **stale test** — update the expectation, do not "fix" the app. This is the §Schema Discrepancy Discipline unambiguous-code-design-intent exception that permits proceeding without a halt. Conversely, do **not** update expectations to match **in-flight** UI (e.g., dashboard headings that will change when client-blocked ROLE-STUDIOS ships) — doing so creates false-green that silently re-breaks when the feature lands, and the re-break reads like a regression. Defer expectations coupled to unsettled features; fix only already-shipped drift.

**Rationale:** Test expectations are only meaningful against settled behavior. Verifying against code/seed ground truth distinguishes a stale test from a real bug; deferring in-flight-coupled expectations prevents churn and false-green. Also: a fix to a shared test helper only protects callers that import it — grep the buggy pattern (`getByLabel('Password')`) across the whole suite to catch inline duplicates, and bucket failures by spec-file + error-signature before fixing to separate mechanical from investigative work.

**See:** `e2e/seed-data-verification.spec.ts`, `src/lib/current-user.ts`, PLAN.md §E2E-MIG

### Playwright E2E Deprioritized Pre-Launch; Browser Regression = PLATO API + Manual; Automated PLATO Browser Mode is Post-Launch Only
**Date:** 2026-06-28 (Conv 347)

The 28 Playwright specs (164 cases) are post-route-flip stale and **frozen, not migrated** — `[E2E-MIG]` is **dropped**. Pre-launch browser-regression coverage = **PLATO API mode** (gated/green in `npm test`; backend write-chains + data invariants) + the **Matt design-conformance sweep** + **manual review** (visual/UX). The PLATO `BrowserIntent` walkthrough DSL is *intentionally human-prose* (`pageAction`/`expect` are free text an agent interprets via the Chrome bridge — see the Conv-074 BrowserIntent decision above), so converting browser mode into a **deterministic CI gate** would mean re-authoring every walkthrough with machine selectors + programmatic assertions — i.e. reinventing Playwright under a bespoke runner. An **LLM-driven PLATO browser smoke-walker** (the only automation that preserves the prose DSL) is tracked as a **post-launch** idea (`[BROWSER-SMOKE-2B]`) and is a periodic smoke-walk, **not** a deterministic gate. The PLATO half of `[E2E-GATE]` was **completed this conv**: the 3 walkthrough instances (`activities`/`ecosystem`/`member-directory`) gained static `Instance:` blocks in `plato-scenarios.api.test.ts` so their file-level `verify` runs in `npm test` (PLATO 10→13 tests).

**Rationale:** Pre-launch (small team, 2 trusted users, fixed timeline/budget), backend correctness — already covered by the gated PLATO API suite — is the higher-value automated coverage. Playwright E2E overlaps PLATO browser mode at the journey layer and adds only *automated* browser regression, whose value is unrealized until the 28 stale specs are migrated **and** gated **and** kept green (a multi-conv cost). The custom-runner path for automating PLATO browser mode converges on "Playwright with extra steps"; the LLM-runner path is non-deterministic and a poor gate. Neither is worth the pre-launch spend. Specs are **kept, not deleted**, as a journey reference (the 164 cases enumerate flows worth covering). Note: Playwright E2E does NOT meaningfully catch *visual/UX* quality (it asserts presence/text/structure, not design correctness) — that is the Matt sweep + manual review's job, so dropping it does not lose UX-quality coverage.

**Consequences:** `[E2E-MIG]` dropped; `[E2E-GATE]` reduced to (and closed by) the PLATO-instanceFile-gate; new deferred `[BROWSER-SMOKE-2B]` (post-launch). `../Peerloop/e2e/README.md` documents the freeze; `docs/reference/TEST-E2E.md` carries a FROZEN banner. `npm run test:e2e` still runs but is expected-red and is not a gate. **(Conv 377: the CI `e2e` job gained `continue-on-error: true` so a red result no longer fails the workflow — the config now enforces this "not a gate" intent; it only runs on `main` push/PR, not on `jfg-dev-*` dev pushes.)** Revisit post-launch if automated browser regression becomes a priority.

**See:** `../Peerloop/e2e/README.md`, `../Peerloop/tests/plato/api/plato-scenarios.api.test.ts`, `docs/as-designed/plato.md`, `docs/reference/TEST-E2E.md`

---

