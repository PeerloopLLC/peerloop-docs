# Current Tasks — between convs

> Last refreshed 2026-07-06 (Conv 369). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

_(none — the [MEM-CAP-ARCH] block completed Conv 358 via full-collapse; promote a backlog item here to set the next sequence.)_

---

## 📋 Unordered backlog

### [MINWIDTH-320] · standalone

Lower the supported minimum screen width from 375px → 320px (iPhone-SE class). Per the Conv 367 **[MINWIDTH]** decision (`docs/decisions/05-ui-ux-components.md`), only 3 sites overflow below ~357px: the listing filter rows in `MembersFilters.tsx` + `CoursesFilters.tsx` (the `flex shrink-0 … gap-8` cluster + `min-w-[150px]` search can't compress → let search shrink via `min-w-0`, or wrap the cluster) and Home's legacy feed-card `ml-auto … px-3 py-1.5` action button in a no-wrap flex row (→ `min-w-0` / `flex-wrap`). Re-verify at 320px via the iframe harness (`memory/reference_responsive_iframe_harness`). Optional — only if iPhone-SE-class support is wanted.

### [ICN-NS] · standalone

Icon-namespace cleanup across the two icon systems (Astro path registry `icon-paths.ts` + React `icons.tsx`/`brand-icons.tsx`) and the Matt `MattIcon` registry — reconcile naming so the three don't collide/duplicate.

### [TZ-AUDIT] · standalone · [Opus]

Full timezone-correctness audit. Recurring `new Date()` issues have survived multiple sweeps; user has low confidence TZ handling is right — dedicated deep pass.

### [HOME-FIXES] · standalone (deferred per-route bucket)

Deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — small issues set aside to batch later.

### [COURSES-FIXES] · standalone (deferred per-route bucket)

Same as [HOME-FIXES] but for the Courses route(s).

### [PLAN-XTRACT] · standalone

Extract bloated inline PLAN.md blocks out to `plan/<slug>/README.md`. PLAN.md is ~62K tokens — over the Read-tool limit (forced a Python-splice workaround Conv 350). Low priority.

> ## ⏸️ PARKED (blocked behind a clear gate — out of active rotation)
>
> Each revisits when its gate clears.

### [RG-PUBLIC] · ⏸️ Parked — gate: marketing redesign

Public/marketing route group sweep (the only un-swept RG-* group; RTMIG-4 closed Conv 340 with it deferred). The 14 marketing pages live only in `/old/*`; root paths 404 by design. Revisit if/when the marketing redesign is scheduled. **Refs:** `plan/route-migration/README.md § RG-PUBLIC disposition`.

### [V217-WATCH] · ⏸️ Parked — gate: new CC release

Watch the upstream Claude Code `[TERM-GARBLE]` bug (blank/partial tool output + confabulated failure under Opus 4.8 + parallel batches; unfixed as of CC 2.1.159). Re-check on new CC releases. **Refs:** memory `reference_term_garble_upstream_bug`.

### [PREFLIP-WT] · ⏸️ Parked — gate: user say-so

Tear down the preflip reference worktree (`~/projects/Peerloop-preflip` on :4331, `peerloop-ref` alias). Consequential + machine-local; the PLATO port-audit reason for keeping it has cleared. **Refs:** memory `project_preflip_worktree_reference`.

### [BROWSER-SMOKE-2B] · ⏸️ Parked — gate: post-launch · [Opus]

Evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor. Do NOT resurrect Playwright E2E. **Refs:** `docs/decisions/06-testing-ci.md`.

---

## ✅ Completed this conv

- **[BRAND-CASE] — "PeerLoop"→"Peerloop" casing sweep (Conv 369).** Fixed 20 rendered UI-copy sites (course editor, marketing, discover, sidebar aria-labels, seed bios, Stripe charge desc, BBB welcome, register email, verify link) **plus the Logo wordmark** — user chose "fix logo too", so the Matt-sourced wordmark SVG was hand-edited (capital-L glyph → lowercase-l stem, trailing "oop" re-kerned via a `<g translate(-7.683 0)>`, viewBox tightened 108.245→100.562 + Logo.tsx Large-variant `w-[108px]`→`w-[100px]`); Medium/Small text + sr-only also fixed. Left 29 `PeerLoop` in `src/` by design (12 `PeerLoopFeatures*` code identifiers, the Figma file-name ref, the wordmark group id, the general code/doc comments per "UI copy only", and the `/old` legacy h1). Updated 2 tests that asserted the old casing (`register.test.ts`, `CourseDetail.test.tsx`). Gates green (tsc/lint/astro 0-0-0 / build ✓ / 82-2 targeted tests); wordmark kerning visually verified in Chrome (real + 4× + Inter ref). 15 code files changed.

- **[E2E-DOCS] — Reconciled E2E test counts across TEST-COVERAGE + TEST-E2E (Conv 369).** Disk truth = **28** `e2e/*.spec.ts` / **125** tests (`feed-badges`=2 — my first grep over-counted it as 4 — `my-feeds-card`=4, `seed-data-verification`=14, the 3 files accrued since the Session-390 25-file/105-test snapshot). `TEST-COVERAGE.md`'s *detailed* E2E table was already per-file-accurate; fixed its stale Summary (E2E 30→28 files), All-Test-Files grand total (438→436), the "(30 files)" header + a Conv-369 changelog line. `TEST-E2E.md`: added the 3 files to the File-Reference table + 3 Test-Flows sections, Total 105→125, Last-Updated bumped. Both driftCheck docs now match the source-of-truth spec files.

- **[DOCGEN-SPEC] — Documented the generated-docs regen contract in doc-sync-strategy.md (Conv 369).** Added **§9** (generated-docs regeneration contract): the `route-docs-generated` registry binding (`inputs` globs / `commands` / cross-repo `alsoWrites`), the `/r-end` Step 5c conditional gate (`regen-generated-docs.mjs` — regenerates only when this conv's code touched `src/pages|components|lib/**`, ordered *before* the drift-baseline advance so the change-set isn't zeroed), the `route-stories.md` hand-written carve-out, and the "never `TaskCreate` a route-doc regen" consequence. Also refreshed the stale §5 Q1 (it still called `route-api-map.md` a "future candidate" though it's been `generated` since Conv 246) + the header. Contract pulled from the actual SKILL.md / config.json / scripts, not memory.
