# Current Tasks — between convs

> Last refreshed 2026-07-01 (Conv 355). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [MEM-CAP-ARCH] · ★ Next (Phase 2) · [Opus]

Durable two-tier (HOT/COLD) `MEMORY.md` index — Phase 1 shipped Conv 353; Phase 2 = automate enforcement.

- **Status:** Phase 1 DONE (Conv 353) — live MEMORY.md rewritten to two-tier HOT(22)/COLD(60), **86%→71%** (18066 B), all 82 entries intact, 0 broken links; default-COLD write-time rule documented in `CLAUDE.md §Memory Index Tiering` + the MEMORY.md preamble. Architecture chosen after deep discussion = keep index in MEMORY.md (rejected relocating to CLAUDE.md, on framing grounds).
- **Next (Phase 2):** rewrite `/r-prune-memory` to **enforce** the grammar — default new entries to COLD, tier-aware flatten, and periodic auto-re-tier (promote always-on→🔥 HOT, demote quiet→📇 COLD).
- **Why:** Phase 1 is a behavioral rule with no enforcer; without Phase 2 the tiers drift as memories accumulate. Cap pressure is relieved (71%) but not self-maintaining.
- **Refs:** `CLAUDE.md §Memory Index Tiering` · `docs/sessions/2026-06/20260630_1314 Decisions.md` · `DOC-DECISIONS.md §3`.

---

## 📋 Unordered backlog

### [SNAV-CLEAN] · standalone (Phase 2b follow-up)

Remove the now-dead zoned/cluster rendering from `SubNav.astro` — zone divider/headers, the `kind:'cluster'` branch, done-✓, disabled gates, and the `SubNavClusterItem`/`SubNavClusterChild` interfaces. Inert after [SNAV-TOP] Phase 2a moved the course journey out of SubNav into `CourseJourneyStepper`. No user-visible effect; also simplify the active-matching loop's zoned branches. Tracked as TodoWrite task.

### [LAYOUT-SG] · standalone

`/course/[slug]` hero design call: inset (contained in the content column) vs full-bleed (edge-to-edge). Decide, then apply.
- **Context update (Conv 354):** the "move the course hero to the `entity-header` slot / full-bleed top" residual is DONE — `CourseHeader` now renders full-width above the rail+content via AppLayout's `entity-header` slot ([SNAV-TOP]). Remaining decision = inset-vs-full-bleed *styling* of the hero, with the entity-header placement as the baseline.

### [VITE-DEDUP] · standalone

Durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash. Retires the manual `rm -rf node_modules/.vite` workaround.

### [ICN-NS] · standalone

Icon-namespace cleanup across the two icon systems (Astro path registry `icon-paths.ts` + React `icons.tsx`/`brand-icons.tsx`) and the Matt `MattIcon` registry — reconcile naming so the three don't collide/duplicate.

### [TZ-AUDIT] · standalone · [Opus]

Full timezone-correctness audit. Recurring `new Date()` issues have survived multiple sweeps; user has low confidence TZ handling is right — dedicated deep pass.

### [DOCGEN-SPEC] · standalone

Document the generated-docs regen binding + the `/r-end` Step 5c regen gate in `doc-sync-strategy.md` (the auto-regen contract is encoded in skill scripts but not written down).

### [BRAND-CASE] · standalone

App-wide "PeerLoop" → "Peerloop" casing cleanup: 45 camelCase instances in `src/` UI copy vs the canonical 168. Verify each isn't intentional stylization before bulk-replace; skip the wordmark SVG filename.

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

- **[SNAV-TOP] Phase 2a** — course enrollment journey redesigned as a horizontal stepper ("Direction C"): split `_course-tabs.ts` into 3 builders (`buildCourseExploreTabs`/`buildCourseJourney`/`buildCourseSessionActions`), added `CourseJourneyStepper.astro` (light hero band, route-driven active state) + `CourseSessionsActions.astro` (Sessions sub-row), rewired all 4 course pages (`[...tab]`/`success`/`book`/`session/[id]`) to Explore-only top SubNav + dropped `subNavLayout="left"`. Added an `exact` match flag to SubNav (fixes the index "About" tab staying active on non-Explore routes) + fixed a 1px overflow scrollbar. 5 gates green (tests 6731); browser-verified 4 states on :4321. Follow-up: **[SNAV-CLEAN]** (Phase 2b — SubNav dead-code removal).
