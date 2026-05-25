---
name: feedback_dom_truth_over_screenshots
description: "For precise layout/position/visibility checks in the /chrome bridge, trust DOM facts (getComputedStyle / getBoundingClientRect / elementFromPoint) + dev-server logs, NOT screenshots — screenshots mislead"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5a7497b2-e766-4b4b-90f0-327a8eab49b9
---

When verifying a **precise** layout/position/visibility claim through the `/chrome` MCP bridge, treat **DOM inspection as ground truth**, not the screenshot. Use `mcp__claude-in-chrome__javascript_tool` to read `getComputedStyle(el)` (left/top/zIndex/transform/display), `el.getBoundingClientRect()`, and `document.elementFromPoint(cx,cy)` (→ is the top element *inside* the element you think is on top, or is something covering it?). Cross-check the **dev-server log** — it often names the bug outright.

**Why:** Conv 191, twice in one session, I read "the slide-out panel is flush against the navbar" off an ambiguous screenshot. DOM truth showed `left: 0px` (the panel was at the viewport edge, **behind** the navbar; `elementFromPoint` at its centre returned a navbar item, not panel content). The real diagnosis came from the Vite dev log — **"Duplicate 'style' attribute in JSX element"** — my inline `style={{left:'220px'}}` was a *second* `style` attr on a `<div>` that already had `style={{top:'1rem'}}`, and JSX silently keeps only one, so the fix never applied. A screenshot cannot show you "the class/attr didn't apply" or "z-index puts this behind that"; computed styles and `elementFromPoint` can. The user explicitly flagged that my screenshot-based assessment "did not really work for what you are trying to assess" — they were right.

**How to apply:**
- Screenshots are fine for *gross* visual confirmation ("does the page render / roughly look right"). For anything dimensional or stacking-related (is it at X px? flush? on top? hidden? right size?), query the DOM.
- After any CSS/style/layout edit, before claiming it works: reload, read the **dev log** for warnings/errors, then `getComputedStyle`/`getBoundingClientRect`/`elementFromPoint` the affected element. Report the numbers, not "looks good."
- **Duplicate-`style` JSX gotcha:** never add a second `style={{}}` to an element — merge into the existing one. JSX drops the duplicate with only a build *warning*, so the symptom is "my style silently didn't apply."

**Related (Conv 191 NAV-RETROFIT):** Astro View-Transition + `transition:persist` islands drop **island-unique arbitrary Tailwind utilities** (e.g. `py-[10px]`, `left-[220px]`) when a sibling route's CSS swaps in — survives only if the class also appears in the other route's bundle. Fix = standard non-hijacked classes, or inline `style` for one-off px. See `feedback_external_source_of_truth_first.md` for the sibling "probe before claiming" principle.
