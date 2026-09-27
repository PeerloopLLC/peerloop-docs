# A newly-added arbitrary Tailwind class can be STALE on the ClientRouter swap path

**Trigger:** you add/change an **arbitrary** Tailwind utility (`mr-[20px]`, `min-h-[16px]`, `size-[50px]`, …) and the user reports the visual change "didn't apply" / "hasn't changed" / looks wrong — **especially when it looks right on a full page load / hard-reload but reverts after clicking around** (tab switches, in-app links).

**Cause (dev-only):** this app uses Astro `<ClientRouter />` (View Transitions). Tailwind v4's JIT generates utilities on demand. In a *running* dev session, a freshly-referenced arbitrary class gets regenerated into the CSS the **full-load** path serves, but the **client-side View-Transition swap** path can keep serving a **stale** stylesheet that lacks the new rule. Result: the class is on the element (`el.className` shows it) but `getComputedStyle` reports the property as **0 / unset** after a swap, while a fresh full load shows the correct value. It is NOT a code bug — production ships one static CSS with every class, persisted across swaps, so it's correct there.

**Fix / diagnosis:** **restart the dev server** (regenerates CSS for all paths incl. swaps). To confirm it's staleness vs a real bug: reproduce a real View-Transition swap (click an in-app link — NOT a full `navigate()`), then restart and re-test; if it's correct after restart, it was staleness.

**Verifying spacing/layout live:** measure the **swap path**, not just full loads. Full-page `navigate()` (and the MCP `navigate` tool) always fetch fresh CSS and will **mask** this — click an in-app SubNav/tab link to trigger the actual ClientRouter swap, then read `getComputedStyle`.

## Incident — Conv 443 [TBK], the whole spacing back-and-forth

The BackStackButton's gap was tuned `mr-8`→`mr-[10px]`→`mr-[20px]` over three turns. Each time the user said it "hadn't changed" or looked "very narrow" — because their open tab switched tabs via View-Transition swaps that served stale CSS (arbitrary `mr-[Npx]` computed to 0). My live checks used full-page `navigate()`, which always looked correct (20px), so I kept mis-attributing it to a different stale-CSS flavor and telling them to hard-reload. Reproducing an actual tab-click swap showed `marginRight: 0px`; a dev-server restart made swaps correctly report `20px`. Same root cause also sat behind the earlier `deps_ssr` churn family — the running dev session lagging code changes. Lesson: for any arbitrary-class spacing change, verify on the swap path and restart the dev server before concluding anything about the code.
