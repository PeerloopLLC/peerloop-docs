# Current Tasks — between convs

> Last refreshed 2026-07-04 (Conv 363). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [E2E-DOCS] · standalone

Reconcile E2E test counts across `docs/reference/TEST-COVERAGE.md` + `docs/reference/TEST-E2E.md` (both driftCheck). Pre-existing drift surfaced by the Conv-363 r-end docs agent (NOT caused by Conv 363): TEST-COVERAGE lists E2E = 30; TEST-E2E says "25 files / 105 tests" (last touched Session 390); disk has 28 `e2e/*.spec.ts`. Re-verify per-file counts and fix both docs + the "All Test Files" grand total (carries a stale +2). Low priority.

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

- **[THEME-CS] — Mark the /profile dark-mode toggle "coming soon" (Conv 363).** Follow-on from the [VBAR] "what did we lose" review. Confirmed the codebase has **no** light/dark control anywhere except `/profile` (ThemeToggle, rendered in both auth branches); dark mode was effectively dropped in the Matt porting (Matt pages use tokens, not `dark:` variants — only ~48 legacy files respond to `.dark`). Per user: it's a logged-in bonus, marked "coming soon" rather than shipped half-working. Added a `comingSoon` prop to `ThemeToggle.tsx` (disabled switch + "Coming soon" badge + "Dark mode is on the way"; the mount effect no-ops so it never flips `.dark` behind a disabled control) — kept the component for future revival; passed `comingSoon` at both `/profile` usages. Also fixed the now-stale `Sidebar.tsx` comment (visitors no longer route through `/profile` after [VBAR]). Decisions: `nav_layout` toggle left as-is (logged-in-only — visitors have no user record + it's SSR-resolved); Sidebar otherwise unchanged (kept clean). +2 ThemeToggle tests. 5 gates green (6759). Visually verified on dev `/profile`. Not yet committed/deployed at time of writing.
- **[VBAR] — Dismissable visitor conversion CTA, replacing the undismissable StickySignupBar (Conv 363, Option A).** The logged-out Home showed a sticky "Join Peerloop to follow these feeds" bar that couldn't be dismissed (poor UX for a returning Visitor). Investigation surfaced the real gap: the Matt shell (`HeaderBar`/`Sidebar`) had **no** visitor auth affordance at all, which is why the bar was made persistent. Explored options via an interactive mockup artifact; user chose **Option A** = in-feed dismissable cards + a persistent chrome sign-up. Built: (1) new `SignupCtaCard.tsx` interleaved by `SmartFeed` every 4 real items for visitors (`viewerAuthenticated === false`), dismissable via `ephemeral-dismiss` (persists in prod, re-shows per-reload in dev/staging by design); (2) a persistent **Sign up** (primary button) + **Log in** (link) affordance in `Sidebar.tsx`'s bottom cluster for visitors (replacing the generic "Visitor → /profile" row) — covers desktop rail (expanded + collapsed 70px → `person-add` glyph) AND the mobile NavDrawer (same component); (3) removed `<StickySignupBar>` from `index.astro` and **deleted** the now-orphaned `StickySignupBar.astro`. +6 tests (SignupCtaCard ×2, SmartFeed interleave ×2, Sidebar visitor-auth ×2). 5 gates green (6757 tests). Verified: visitor SSR home renders the Sidebar Sign up/Log in (desktop + drawer) with StickySignupBar gone; in-feed card + dismiss covered by tests. Not yet committed/deployed at time of writing.
- **[PROF500] — Fix /profile 500 on staging (Conv 363).** Logged-in `/profile` on staging returned HTTP 500. Root cause: the staging `users` table was missing `nav_layout` (added to the base `migrations/0001_schema.sql` at Conv 356, but staging's DB was never reset since — and `0001` is edited in place, not shipped as an incremental migration, so an un-reset staging DB never picked it up). The one **unguarded** `nav_layout` read — `src/pages/profile/[...tab].astro` — threw `no such column` → 500, while `middleware.ts` (resolveNavLayout) and `AppLayout.astro` degraded silently because both wrap the same query in `try/catch`. **Fix A (data):** full `db:setup:staging:booking` reset+reseed → schema current (`nav_layout` present, verified via PRAGMA), fresh dev/Stripe/booking seed; then `db:seed:feeds:staging` to reach the `:feeds` level (`:booking` does NOT seed feeds on staging — only the local chain bundles feeds into `dev`). Staging data was confirmed disposable first (all seed accounts, no hand-crafted state). **Fix B (code):** wrapped the profile account query in `try/catch` so any future single-column drift degrades to the existing "couldn't load account details" card instead of 500ing — brings `/profile` in line with middleware + AppLayout. Verified: `nav_layout` PRESENT on staging, `/profile`→HTTP 200. 5 gates green (6751 tests). Fix B takes effect on staging at next deploy; the DB reseed already resolves the live 500 without a redeploy.
