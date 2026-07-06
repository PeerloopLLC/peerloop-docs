---
name: reference-responsive-iframe-harness
description: "Faithful multi-width responsive/min-width testing via the Chrome MCP: render a page in an exact-width same-origin iframe (media queries key off the iframe width). resize_window is laggy; the MCP sees the real page viewport, not DevTools device mode; container-forcing lies."
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

**Pairs with:** ephemeral on-demand dev server ([[feedback_persistent_dev_server_4321]]), DOM-truth-over-screenshots ([[feedback_dom_truth_over_screenshots]]), `client:load` island settle ([[e2e-testing-patterns]]). Applied Conv 367 to set the **375px** minimum-width decision — current clean floor ~357px, only listing filter rows + Home overflow below it (docs/decisions/05-ui-ux-components.md § MINWIDTH).
