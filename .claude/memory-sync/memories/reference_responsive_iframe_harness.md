---
name: reference-responsive-iframe-harness
description: "Faithful responsive testing via the Chrome MCP: render a page in an exact-size same-origin iframe (media queries key off the iframe, not the real viewport). Works for min-WIDTH and min-HEIGHT/landscape. resize_window is laggy; the MCP sees the real page viewport, not DevTools device mode; container-forcing lies. Gotchas: scrollHeight clamps to clientHeight; HMR contaminates the harness."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 05379449-ab13-47e5-9827-6e2f5fcb3961
---

**For responsive / minimum-width testing via the Chrome MCP, use an exact-width same-origin iframe — NOT `resize_window` or a DevTools device panel.** (Conv 367 [MINWIDTH].)

**Why the obvious approaches fail:**
- `resize_window` is laggy/unreliable — it "succeeds" but `innerWidth` lags (measured 341 one call, 1087 the next for the same request); only takes effect after some navigations.
- **MCP browser automation measures/screenshots the REAL page viewport, not a DevTools device-mode panel.** With the user's responsive panel open, `window.innerWidth` still read 1087 (desktop) — DevTools emulation is invisible to the automation, so you can't rely on the user's device panel for measurements.
- Container-forcing (`el.style.width='320px'`) LIES: `min-[480px]:`/`sm:` media queries key off the real viewport, so responsive classes stay in their desktop state. See [[feedback_dom_truth_over_screenshots]].

**The iframe harness (faithful):** an iframe is a genuine separate viewport — a 320px-wide same-origin iframe makes the page's Tailwind `min-width`/`sm:`/`lg:` media queries evaluate against 320, exactly like a 320px phone (the mechanism real responsive-testing apps use). Load the target path as `iframe.src`, await `onload` + ~2.4s island-hydration settle, then read `iframe.contentWindow.innerWidth` (subtract ~4px for a 2px border each side) and `iframe.contentDocument.documentElement.scrollWidth`. **A page's minimum-fit width = its `scrollWidth`** (below that = horizontal overflow). All `base`-regime widths (<640px) share the same classes, so ONE 320px measure yields the threshold for the whole phone range.

**Offender detection (what overflows):** walk `body *` for `getBoundingClientRect().right > innerWidth`, but EXCLUDE elements that are `position:fixed` OR inside an ancestor with `overflow-x` hidden/auto/scroll/clip — otherwise off-canvas drawers + scroll containers pollute the list (they reported right=600–773 on a 316px document while `scrollWidth` was only 353).

**Also drives min-HEIGHT (landscape) testing (Conv 368 [SIDEBAR-COLLIDE]).** An exact-*height* iframe drives both `@media (max-height:…)` blocks AND `calc(100vh-…)` box heights inside it, so a component's `ResizeObserver` reading `clientHeight` sees the simulated viewport. Sweep `iframe.style.height` across a **down-then-up** sequence to exercise a collision + hysteresis observer and confirm a clean release with no oscillation.

**Two gotchas that cost time (Conv 368):**
- **`scrollHeight` clamps to `≥ clientHeight`.** When content fits, `scrollHeight == clientHeight`, so a `clientHeight − scrollHeight` "slack" maxes at 0 and can NEVER report room-to-spare. Overflow *enter* (`scrollHeight > clientHeight`) is reliable; a hysteresis *release* must compare **un-clamped** `clientHeight` to a separately-recorded content height. Invisible to tsc/lint/build + jsdom tests (0 heights) — only a real-browser height sweep exposes it (shipped stuck-merged in the first cut). See [[feedback_dom_truth_over_screenshots]].
- **HMR / React Fast Refresh contaminates the harness.** A `vite hot updated` mid-sweep (your own edits settling) disrupts a `client:load` island's effect/observer lifecycle → impossible-looking results. Let edits settle, then **recreate the iframe fresh** (`f.src='/'`) before measuring; check the iframe console for `hot updated` timestamps when results look wrong.

**Pairs with:** ephemeral on-demand dev server ([[feedback_persistent_dev_server_4321]]), DOM-truth-over-screenshots ([[feedback_dom_truth_over_screenshots]]), `client:load` island settle ([[e2e-testing-patterns]]). Applied Conv 367 to set the **375px** minimum-width decision — current clean floor ~357px, only listing filter rows + Home overflow below it (docs/decisions/05-ui-ux-components.md § MINWIDTH). Conv 368 extended it to min-height + collision-observer verification (SIDEBAR-COLLIDE per-role merge).
