# Current Tasks — between convs

> Last refreshed 2026-07-03 (Conv 361). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

- **[MOBUP] — Mobile contextual up-chevron for deep flows (Conv 362).** New `MobileUpNav.astro` — a `lg:hidden` compact `‹ {parent}` arrow-left link to the page's immediate-parent href; **deterministic "up," NOT `history.back()`** (reliable on deep-link/notification/fresh-tab entry). Rendered in a new guarded `mobile-upnav` AppLayout slot **above the hero**. Fills the mobile gap where the desktop breadcrumb (`hidden lg:block`) disappears < lg. Wired the **7 deep-flow pages** (course `[...tab]`/book/success, session, community `[...tab]`, teaching course, creating community); top-level pages skip it (up = Home, already a ControlBar shortcut). +8 source-level tests; 5 gates green (6751); layout §8.6.4 + PLAN LAYOUT-SG updated. DOM-verified desktop-hidden (`display:none` at 1208px) + correct href/label/aria/arrow-svg; live <lg render blocked by the machine's OS window clamp (real-phone eyeball pending). Grew from a discussion on breadcrumb-based back nav (up = deterministic; history.back = fragile).
- **[MOBNAV] — Mobile-nav follow-ups resolved (Conv 362).** Two design calls from Conv 361, both via AskUserQuestion: (1) bottom `ControlBar` → **5 icons** (added **Members**/`student-teacher` alongside Communities — user chose "both", not a swap): Home·Courses·Communities·Members·Messages; (2) header-right → **keep notifications** bell (avatar declined — Profile already in the drawer; no change). Change was `ControlBar.tsx` (+1 nav entry) + its test (assert 5 links incl. Members). DOM-verified on `:4321` at 472/520px (below `lg`): 5 links/correct hrefs/Members SVG renders/~314px pill fits ≥314px viewports/no overflow; NavDrawer opens end-to-end (11 role-aware links, body-lock, Esc/backdrop). 5 gates green (6743 tests). Layout doc §8.6.4 + PLAN LAYOUT-SG updated. Notes: the drawer's "frozen" slide during verify was a background-hidden-tab artifact (Chrome freezes transition timelines), not a bug; a transient `/`-only D1_ERROR was environmental (`[VITE-DEDUP]` territory), not from this change.
