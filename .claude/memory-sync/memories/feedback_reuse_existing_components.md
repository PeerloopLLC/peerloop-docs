---
name: reuse-existing-components-on-figma-render
description: "When translating any Figma frame/page/component into code, FIRST scan its `<instance>` children and map them to existing code components; use those existing components, do NOT inline duplicates"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ca115062-1d4e-42dd-ae47-75218f92d59e
---

**Rule:** Before writing the code render for any Figma frame, page, or component, run `get_metadata` (or read the `get_design_context` output) and identify every `<instance>` node it contains. Each `<instance>` is a Figma-level reuse boundary — Matt explicitly chose to compose, not inline. Map every instance name to either:
- (a) an existing code component → IMPORT and USE it
- (b) a missing primitive → STOP and surface the gap before continuing; build the missing primitive first if it blocks the current work, or add to PLAN/TodoWrite if deferrable

Do NOT inline a duplicate of an existing component just because of perceived friction (Astro/React boundary, prop-shape mismatch, missing minor feature). Resolve the friction by extending/converting the existing component or by stopping to discuss — never by silent duplication.

**Why:** Conv 184 audit (user-requested) discovered that `SocialPost.tsx` inlines `Avatar()` (duplicating UserIcon's cascade logic) and `ActionPill()` (which IS Matt's "Analytic Count" primitive, just unnamed in code). Both inlines were written Conv 175 BEFORE the primitives existed in code — so they were unavoidable then. But the same pattern would have repeated in Conv 184's CourseAnchor.astro: I inlined the CTA button styling (Button Primary in Course Variable Mode) instead of importing `Button.tsx`, citing the Astro/React boundary as friction. The Astro/React boundary doesn't actually hold — Astro renders React components as static HTML by default — so the friction was a fiction and the rule had been violated. Each inline duplication accumulates as design-system drift; refactors to bring inlines into compliance are slow and easy to skip.

**How to apply:**
- **Before building a Figma render:** call `get_metadata` on the target frame, list every `<instance>` it contains (Figma's `<instance>` XML tag has a `name=` attribute — that's the component name in Matt's library). Map each name to a code file or note its absence.
- **During the build:** every visual element that has a Figma `<instance>` peer must come from that imported code component, not inline markup. Even if the prop shape doesn't quite fit, prefer extending the existing component over duplicating its styling.
- **When a needed primitive doesn't exist:** halt the current build. Either (1) build the missing primitive first if it's blocking, or (2) escalate to the user as a gap before continuing. Do NOT proceed with an inline duplicate "for now."
- **Retroactive sweep:** when auditing pre-strict-B code (Conv 175/176 era), identify all inlined elements that now have code-level primitives and refactor.

**Standing reference for Astro/React boundary:** an `.astro` component CAN import a `.tsx` (React) component and render it as static HTML without `client:*` directive. Hydration is opt-in, not required. So "this is Astro and Button is React" is NOT a valid reason to inline Button's styling.

See also: [[feedback_external_source_of_truth_first]] (probe vs infer), [[feedback_tokenize_only_matt_variables]] (extract what Matt categorized).

Established Conv 184 [MATT-EXEC-CMP-ANCH-COURSE audit].
