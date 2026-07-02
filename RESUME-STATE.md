# State — Conv 359 (2026-07-02 ~14:10)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Added **sticky-on-scroll UI** across the app. Listing pages (`/`, `/courses`, `/members`, `/communities`) now pin their search/sort + role-tab controls via a new shared `StickyListingToolbar.astro` primitive; detail pages (`/course`, `/community`, `/profile`) pin their section tab bar via an opt-in `sticky` prop on the shared `SubNav.astro`. The governing convention: **pin re-used controls, let breadcrumb/title/carousels scroll off.** Two conv commits landed pre-`/r-end` (listing batch `dfc61649`, detail batch `26681186`) plus this end-of-conv commit; all pushed in Step 7.

## Key Context

- **Three root-cause CSS fixes were needed** and are documented in-code (StickyListingToolbar + SubNav docstrings, a CourseCatalogCard comment):
  1. **Tailwind-v4 dev-JIT offset trap** — stacked responsive `top` overrides misorder (arbitrary sorts after named; `sm:` beat `lg:`). Fix = **mutually-exclusive `max-lg`/`lg`** range variants. Remember: named `top-80`/`top-88` ≠ px under the NAV-RETROFIT bridge → must be arbitrary.
  2. **Above-bar bleed-through** — a non-zero top offset leaves an uncovered strip; a **`before:` riser** (20px listing / 16px detail, sized to the at-rest flex-gap) occludes it, invisible when unpinned.
  3. **z-index tie** — a card's `relative z-10` (no stacking-context ancestor) leaked to root and painted over the z-10 bar; fix = **`isolate`** on the card.
- **Course two-band case (Sarah Miller / enrolled):** the journey stepper (Enroll/Payment/Sessions/Certificate) stacks above the sticky Explore tabs. Decision: stepper **stays non-sticky** (glance-once status band, occludes cleanly). A "do not make this sticky" comment guards it.
- **Verification tooling note:** the claude-in-chrome harness blocks programmatic scroll (`window.scrollTo`/`scrollIntoView`), but the **`computer` tool's `scroll` (real wheel events) works** — use it for scroll-state checks. Auth-gated pages reachable via `POST /api/auth/dev-login {email}` + hard-nav.
- **Next:** `[STICKY-P2]` in `CURRENT-TASKS.md` (also PLAN.md STICKY-DETAIL-P2) — condensed pinned Enroll/Join action bars + persistent enrollment strip. `/@handle` intentionally unpinned (no tab bar). `[LAYOUT-DOC]` gained a Conv-359 addendum to record the sticky behavior in the (manual) layout doc.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
