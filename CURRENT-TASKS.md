# Current Tasks — between convs

> Last refreshed 2026-07-02 (Conv 360). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [LAYOUT-DOC] · standalone

Fix `docs/as-designed/matt-design-system/08-layout-and-margins.md` (driftCheck): §8.4 container-audit table (~line 28) + §8.5.x still describe ListingShell as always a 640px column + 320px rail. Phase D (Conv 357) made the rail the `nav_layout='left'` (side-rail) mode only; the per-user default (top-bar) is a single column, no rail. Also reconcile the pre-existing inconsistency — the table row says "right rail" while §8.5.3 records the Conv 289 filters-moved-LEFT decision. (Surfaced by the r-end docs agent.) **Conv 359 addendum:** while in here, also record the new sticky behavior — the `StickyListingToolbar` primitive on listing pages + the opt-in `SubNav sticky` prop on the `/course`/`/community`/`/profile` tab bars (this doc is `manual`, so it's an editorial add, not auto-maintained).

### [LAYOUT-TOGGLE-AFF] · standalone

The `/profile` per-user layout opt-in is a segmented "Top bar / Side rail" toggle (`LayoutToggle.tsx`), not literally a checkbox — the user's Conv-357 phrasing ("check a box in /profile") suggests they may expect a checkbox. Confirm the intended control; swap to a checkbox ("Use side rail on desktop") if wanted. Low priority / UX-preference call.

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

- **[STICKY-P2] — Sticky detail-page action bars, Phase 2 (Conv 360).** Merge-into-tab-strip: opt-in `action` prop on `SubNav.astro` (+ exported `SubNavAction`) surfaces the primary CTA in the already-sticky tab strip — **top-bar layout only** (side-rail self-pins the rail; CTA suppressed there) with **reveal-on-stuck** (hidden until the bar pins → no duplicate CTA under the hero at rest; graceful no-JS fallback = always-visible). Course (`/course/[slug]` via `CourseRail`): Enroll/Continue/Go-to-Session. Community (`/community/[slug]`): creator→Manage in strip; **non-member→Join in the header** (natural placement, all layouts) — also fixed a live gap (non-members had no join affordance despite `FeedActivityCard` linking here; wired to `POST /join` via inline script). Member→Leave (header). All 5 gates green + DOM-verified in both layouts. PLAN row 29 ✅. **Follow-up left open:** the persistent enrollment-context/progress strip was NOT built (no room in the strip row); [LAYOUT-DOC] still carries the addendum to document the sticky behavior.
- **[CHCTA] — Community header CTA placement fix (Conv 360).** Added `flex-1` to the `/community/[slug]` header identity column so the membership CTA (Manage/Leave/Join) stays top-right beside the title instead of wrapping bottom-left under the cover image (pre-existing `flex-wrap` behavior, made noticeable by the new prominent Join). Fixed at the r-end checkpoint on user request; DOM-verified top-right, all 5 gates green.
