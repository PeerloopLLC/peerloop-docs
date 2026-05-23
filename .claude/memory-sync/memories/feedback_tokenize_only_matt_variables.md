---
name: tokenize-only-matt-variables
description: "Matt's Figma Variables are the sole authority for tokenization in /matt/* code; hardcoded hex in Matt's Figma stays hardcoded inline (no Matt-namespaced tokens for non-Variables like --note-yellow); our scaffolded scales fill categories Matt hasn't categorized (radius, spacing, shadow, opacity, z-index, duration); honest-orphan principle (a stale hardcoded hex is honest, a stale token name lies); established Conv 181 [NOTE-YELLOW]"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a578ee2d-2763-4aed-9e4c-de5aae3b4b4e
---

**Rule:** Token-ify what Matt has tokenized; hardcode what Matt has hardcoded; scaffold what Matt hasn't categorized.

**Why:** Imposing our own tokens on values Matt left as one-off hex creates a divergent style guide that ages badly. Matt later formalizes the value as a Variable with a possibly-different name and possibly-different hex — our orphaned token survives in code references, semantically stale. Mirror Matt exactly: when he formalizes, migration is mechanical (replace inline hex with his new Variable name). Until then, hardcoded hex is *honest* about the value's "not-yet-systematized" status. Established Conv 181 [NOTE-YELLOW] after the user surfaced this principle when I proposed adding `--note-yellow` for a hex value Matt has not made a Variable.

**How to apply:**

1. **Colors:** Matt's Figma Variables → consumed via `tokens-primitives.css` / `tokens-semantic.css` (canonical). Matt's hardcoded hex (revealed via `get_design_context` CSS but ABSENT from `get_variable_defs`) → kept hardcoded inline in the component. Do NOT invent Matt-namespaced tokens (`--note-yellow`, `--button-coral`, etc.) for hex values that aren't Figma Variables.

2. **Typography:** Same probe protocol. Matt's Variables → tokens (`text-body-default` etc.); non-Variable text styles, if any → hardcoded inline.

3. **Scales Matt hasn't formalized as Variables** (radius, spacing, shadow, opacity, z-index, duration): our scaffolded scale fills the gap. When Matt's actual usage falls between our scale steps (e.g., he uses 10px padding in Note but our `--space-*` scale is multiples of 4), prefer Tailwind arbitrary values (`p-[10px]`) over extending the scale — keep our scale clean. Replace the whole scale when Matt formalizes the category.

4. **New style categories Matt adds:** when Matt introduces a new category (e.g., motion tokens, breakpoint tokens, gradient tokens), probe + add to our token system.

**The probe protocol:** `get_variable_defs` (selection-required) is the authority. If a CSS value appears in `get_design_context` output but NOT in `get_variable_defs` for the same selected node, it's a hardcoded hex one-off — keep hardcoded inline; do not tokenize.

**The honest-orphan principle:** A hardcoded `#FFF6B8` in `Note.tsx` is honest if Matt later changes Note to a different yellow or removes Note entirely. A `--note-yellow` token implies a level of systematization Matt has NOT made; if Matt changes the value upstream, the token name lies until updated. Hardcoded values are self-deprecating (when they break, the breakage is obvious in diff); named tokens accumulate stale meaning silently.

**Conv 181 [NOTE-YELLOW] motivating case:** Probing Note (node 652:8646) for `--note-yellow` revealed yellow exists in Matt's Figma as hardcoded `#FFF6B8` background + `#F1E9B0` border — but NOT as Figma Variables (`get_variable_defs` returned only Text/Default, Text/Tertiary, Body/Body Small, Body/Body Default). Initial impulse was to add `--note-yellow` to our speculative primitives sub-block (alongside `alert-light`/`carmine-red`). User redirected: take Matt's design AS-IS, hardcode what's hardcoded in Matt's Figma, wait for Matt to formalize before tokenizing. Also corrected an earlier impulse — our existing speculative `alert-light`/`carmine-red`/`Alert-*` tokens are exactly the kind of thing this principle prevents.

**Implication for the speculative block:** The "Speculative (Conv 172)" sub-blocks in `tokens-primitives.css` / `tokens-semantic.css` / `tokens-tailwind-bridge.css` are precedents this principle would NOT permit going forward. Keep them in place per the Conv 181 [TSV] B decision (preserve for Phase 6 [MATT-EXEC-EXT]), but going forward do not extend the pattern. New unverified-or-missing colors stay hardcoded inline in their consuming components.

Related: [[user_hands_off_pilot_workflow]], [[project_matt_collaboration_style]], [[reference_figma_mcp_behavior]] (the probe protocol relies on the `get_variable_defs` vs `get_design_context` distinction documented there).
