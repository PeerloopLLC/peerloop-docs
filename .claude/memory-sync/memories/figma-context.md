---
name: figma-context
description: "LOAD-ON-DEMAND bundle for any Figma / design-translation / design-token work. GUARDRAIL FIRST: Figma is READ-ONLY for CC — NEVER call write-shaped mcp__figma__* tools. Also bundles: reuse-existing-components-on-render, Figma Remote MCP empirical behavior, and the tokenize-what-Matt-tokenized probe policy."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 1931ac08-1cf4-4eaa-bfbd-67fd4a7dc272
---

**Load this when** any Figma / design-translation / design-token work arises (Matt frame → code, MCP probe, token decision). Consolidates four formerly-separate always-loaded entries; bundled Conv 281 as Figma usage drops post-Matt-phase-out ([[project_matt_phaseout_inspired_default]]).

---

## 1. GUARDRAIL — Figma is READ-ONLY for CC, NEVER write ([MNV], Conv 183)

**Rule:** Treat Figma as strictly read-only. NEVER call `mcp__figma__use_figma`, `create_new_file`, `upload_assets`, `add_code_connect_map`, `send_code_connect_mappings`, or any other Figma MCP tool that writes / creates / modifies content. Only read-shaped tools are permitted: `get_metadata`, `get_design_context`, `get_screenshot`, `get_variable_defs`, `get_libraries`, `search_design_system`, `get_figjam`, `get_code_connect_map`, `get_code_connect_suggestions`, `whoami`.

**Why:** Conv 183 [MNV] — user stated explicitly: *"We are not to change Figma at all."* Matt is the sole author of all Figma content; CC's role is one-directional translation Figma → code via probes and screenshots. Even seemingly-benign writes (e.g., Code Connect mappings that affect what other Dev-seat viewers see in Figma) are out of scope unless the user opens that door explicitly.

**How to apply:**
- When the user asks for "Figma-to-code" or "implement this Figma design," only read-tools fire.
- When proposing a method that *could* write to Figma (e.g., "let's annotate the Figma file with the spec"), STOP and propose an alternative (scratch markdown, in-code comments, separate memo).
- If a workflow question genuinely needs Figma modification, ask the user first — never assume permission.
- Skill libraries (`/figma-use`, `/figma-generate-design`, `/figma-generate-library`, `/figma-code-connect`, `/figma-use-figjam`, `/figma-generate-diagram`) are all out-of-scope unless the user explicitly re-opens the door.

---

## 2. Reuse existing components when rendering a Figma frame (Conv 184)

**Rule:** Before writing the code render for any Figma frame, page, or component, run `get_metadata` (or read the `get_design_context` output) and identify every `<instance>` node it contains. Each `<instance>` is a Figma-level reuse boundary — Matt explicitly chose to compose, not inline. Map every instance name to either:
- (a) an existing code component → IMPORT and USE it
- (b) a missing primitive → STOP and surface the gap before continuing; build the missing primitive first if it blocks the current work, or add to PLAN/TodoWrite if deferrable

Do NOT inline a duplicate of an existing component just because of perceived friction (Astro/React boundary, prop-shape mismatch, missing minor feature). Resolve the friction by extending/converting the existing component or by stopping to discuss — never by silent duplication.

**Why:** Conv 184 audit (user-requested) discovered that `SocialPost.tsx` inlines `Avatar()` (duplicating UserIcon's cascade logic) and `ActionPill()` (which IS Matt's "Analytic Count" primitive, just unnamed in code). Both inlines were written Conv 175 BEFORE the primitives existed in code — unavoidable then. But the same pattern would have repeated in Conv 184's CourseAnchor.astro: I inlined the CTA button styling (Button Primary in Course Variable Mode) instead of importing `Button.tsx`, citing the Astro/React boundary as friction. The Astro/React boundary doesn't actually hold — Astro renders React components as static HTML by default — so the friction was a fiction and the rule had been violated. Each inline duplication accumulates as design-system drift.

**How to apply:**
- **Before building a Figma render:** call `get_metadata` on the target frame, list every `<instance>` it contains (Figma's `<instance>` XML tag has a `name=` attribute — that's the component name in Matt's library). Map each name to a code file or note its absence.
- **During the build:** every visual element that has a Figma `<instance>` peer must come from that imported code component, not inline markup.
- **When a needed primitive doesn't exist:** halt — build it first if blocking, or escalate as a gap. Do NOT proceed with an inline duplicate "for now."
- **Retroactive sweep:** when auditing pre-strict-B code (Conv 175/176 era), identify all inlined elements that now have code-level primitives and refactor.

**Standing reference for the Astro/React boundary:** an `.astro` component CAN import a `.tsx` (React) component and render it as static HTML without `client:*`. Hydration is opt-in. So "this is Astro and Button is React" is NOT a valid reason to inline Button's styling. Established Conv 184 [MATT-EXEC-CMP-ANCH-COURSE audit]. See also §4 below (tokenize policy) and [[feedback_external_source_of_truth_first]].

---

## 3. Figma Remote MCP — empirical behavior (Convs 180-187)

Figma Remote MCP (`https://mcp.figma.com/mcp`) — verified Conv 180-187 against PeerLoop file `UpDNMiIEO8y3J7ZHkm356b` via Dev seat (pro tier).

**Architecture — link-based by design.** Per Figma's docs: the remote server is link-based — you provide the context of the link/selection by copying from a file and pasting it in. Do NOT try to enumerate file structure — **the user is the navigator**. Ask them to right-click → "Copy link to selection" → paste the URL, OR open the file in Figma desktop and click a layer.

**Two tool classes (refined Conv 181/186):** selection-free vs conditionally-selection-required.

| Tool | Class | Behavior |
|---|---|---|
| `get_metadata(nodeId)` | Selection-free | Any node-id works. Returns XML structure. Page listing (no nodeId) returns currently-scoped pages — incomplete. |
| `get_design_context(nodeId)` | **Selection-free with explicit nodeId** (Conv 186) | Works without desktop selection when explicit nodeId passed; "select a layer first" only when nodeId omitted/stale. 11-call parallel batch verified Conv 186. |
| `get_variable_defs(nodeId)` | **Selection-free with explicit nodeId** (CONFIRMED Conv 187) | Returns `{"VariableName":"value"}` map of Variables consumed by the target node ONLY — not the file's full collection. Colors as hex (`"Text/Default":"#414141"`); typography as `Font(...)` strings; numerics bare. Conv 181 failures were stale nodeIds, not an absolute selection requirement. |
| `get_libraries(fileKey)` | Selection-free | Subscribed external libraries (Material, iOS) + community libs. Does NOT enumerate local file Variables. |
| `search_design_system(query)` | Selection-free | Searches SUBSCRIBED libraries only. Does NOT find local file Variables or local page symbols. |
| `get_screenshot(nodeId)` | Selection-free | PNG of the node. |

**Invisible local Variables.** No MCP tool enumerates a file's full local Variable collection. To verify a Variable exists, find a node that consumes it and probe via `get_variable_defs`. Variables defined-but-unused are invisible.

**Efficient batch-probing.** Selecting a container frame returns all child-consumed Variables in one call (Conv 181: Headers section → 10 Variables, Body section → 8, each one call). Prefer container selection over per-node.

**Per-target output shape of `get_design_context`:** section frame → sparse metadata + drill hint; component variant frame → typed React component with inferred props (`hasLabel`, `hasLeadingIcon`); page/card frame → inlined HTML+CSS, instances as raw markup with `data-name` attributes (NOT `<ComponentName>` calls).

**Output characteristics:**
- `data-name` attribute IS the translation key — every instance/icon carries `data-name="<figma symbol name>"`. Grep/substitute when porting.
- Colors come through as CSS vars with hex fallback: `var(--background,#e8f4df)`. The **Variable Mode of the parent context is baked into the fallback hex** — same `var(--background,...)` differs in Course (`#e8f4df`) vs Creator (`#e0e8ff`) vs Student (`#f1f9ff`) contexts.
- Variable Mode is observable, not configurable, via MCP — the MCP gives the resolved value for whatever context the target node lives in; probe a different mode by passing a nodeId in that mode's context.
- Plugin-rendered Color Guide labels are NOT authoritative Variable names (Matt's generator renders "Primary/Primary" but the real name is `Primary/Default`, Conv 181). Always verify via `get_variable_defs`.
- Asset URLs expire after 7 days (`https://www.figma.com/api/mcp/asset/<uuid>`); never paste into production. They return **SVG content for vector sources** (Conv 185) — `curl` returns raw SVG; fills come as `fill="var(--fill-0, #hex)"`; normalize to `currentColor` (`perl -i -pe 's/fill="var\(--fill-0, #[0-9A-Fa-f]+\)"/fill="currentColor"/g'`). `get_screenshot` returns PNG.
- "SUPER CRITICAL" translation notice always present — MCP output MUST be converted to the target stack/styling. Translation IS the workflow; no paste-in shortcut.

**Seat tier:** Dev seat sufficient for all read operations (read-only outside drafts). Full seat required for writes (usually unwanted — write-blocking is a structural safety guarantee, see §1). View/Collab seats capped at 6 tool calls/month — practically unusable; recommend Dev seat to new collaborators.

**Workflow:** user-as-navigator — itemize URLs you need, user pastes, you query. For selection-required tools the user clicks the layer. Maintain a checklist (inline for small batches, `.scratch/figma-mcp-needs.md` for larger). See [[user_hands_off_pilot_workflow]] and [[feedback_external_source_of_truth_first]].

---

## 4. Tokenize what Matt tokenized — the probe policy (Conv 181 [NOTE-YELLOW])

**Rule:** Token-ify what Matt has tokenized; hardcode what Matt has hardcoded; scaffold what Matt hasn't categorized.

**Why:** Imposing our own tokens on values Matt left as one-off hex creates a divergent style guide that ages badly — Matt may later formalize the value as a Variable with a different name/hex, leaving our orphaned token semantically stale. Mirror Matt exactly: hardcoded hex is *honest* about a value's "not-yet-systematized" status. Established Conv 181 [NOTE-YELLOW] after the user surfaced this when CC proposed adding `--note-yellow` for a hex Matt had not made a Variable.

**How to apply:**
1. **Colors:** Matt's Figma Variables → consumed via `tokens-primitives.css` / `tokens-semantic.css`. Matt's hardcoded hex (in `get_design_context` CSS but ABSENT from `get_variable_defs` — see §3) → kept hardcoded inline. Do NOT invent Matt-namespaced tokens (`--note-yellow`, `--button-coral`) for non-Variable hex.
2. **Typography:** same probe protocol — Variables → tokens (`text-body-default`); non-Variable styles → hardcoded inline.
3. **Scales Matt hasn't formalized** (radius, spacing, shadow, opacity, z-index, duration): our scaffolded scale fills the gap. When usage falls between steps (10px vs a 4-multiple scale), prefer Tailwind arbitrary (`p-[10px]`) over extending the scale.
4. **New categories Matt adds** (motion, breakpoint, gradient tokens): probe + add to our token system.

**The probe protocol:** `get_variable_defs` is the authority. A CSS value in `get_design_context` but NOT in `get_variable_defs` for the same node = hardcoded one-off; keep inline.

**The honest-orphan principle:** a hardcoded `#FFF6B8` in `Note.tsx` is honest if Matt later changes/removes Note; a `--note-yellow` token implies systematization Matt hasn't made and lies silently when the upstream value changes. Hardcoded values self-deprecate (breakage shows in diff); named tokens accumulate stale meaning.

**Conv 181 [NOTE-YELLOW] case:** probing Note (node 652:8646) revealed yellow exists in Matt's Figma as hardcoded `#FFF6B8` bg + `#F1E9B0` border but NOT as Variables. User redirected: take Matt's design as-is, hardcode what's hardcoded, wait for Matt to formalize. The pre-existing speculative `alert-light`/`carmine-red`/`Alert-*` tokens are exactly what this principle prevents — kept per the Conv 181 [TSV] B decision but the pattern is not extended going forward.

Related: [[project_matt_phaseout_inspired_default]] (Matt's Figma-as-source-of-truth workflow is folded into that entry), §3 above.
