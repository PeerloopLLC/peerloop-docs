---
name: reference-figma-mcp-behavior
description: "Figma Remote MCP empirical behavior — two tool classes (selection-free: get_metadata/get_libraries/search_design_system vs selection-required: get_design_context/get_variable_defs), get_variable_defs returns key→value pairs (colors as hex, typography as Font() spec), local-file Variables invisible to get_libraries/search_design_system (subscribed only), data-name is translation key, asset URLs expire 7d, Variable Mode bakes into CSS-var fallback hex, plugin-rendered Color Guide labels are NOT authoritative Variable names"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 412a9081-86ff-4bf9-b714-cae19905c180
---

Figma Remote MCP (`https://mcp.figma.com/mcp`) — empirical behavior verified Conv 180 + Conv 181 against PeerLoop file `UpDNMiIEO8y3J7ZHkm356b` via Dev seat on Peerloop org (pro tier).

## Architecture

**Link-based by design.** Per [Figma's docs](https://developers.figma.com/docs/figma-mcp-server/remote-server-installation/): *"The remote Figma MCP server is link-based. This means that you need to provide the context of the link or selection that you want the MCP server to use, by copying from a file, and pasting it into your tool of choice."* Do NOT try to enumerate file structure — **the user is the navigator**. Ask them to right-click → "Copy link to selection" → paste the URL, OR open the file in Figma desktop and click a specific layer.

## Two tool classes (CRITICAL — Conv 181 refinement)

The MCP has **selection-free** tools (URL/nodeId alone is sufficient) and **selection-required** tools (user must click a specific layer in Figma desktop AND the passed nodeId must match the selected node). Conv 180 only exercised `get_metadata` via node-id and over-generalized to all tools. Conv 181 [TSV] proved `get_variable_defs` and `get_design_context` require both selection AND matching nodeId — passing a parent/sibling nodeId fails with "select a layer first" even when there IS a selection.

| Tool | Class | Behavior |
|---|---|---|
| `get_metadata(nodeId)` | Selection-free | Any node-id works. Returns XML structure. Page listing (no nodeId) returns currently-scoped pages — incomplete (~2 of 9 in Conv 180 sample). Any node-id IS invisible-but-accessible. |
| `get_design_context(nodeId)` | **Selection-required** | Errors with "select a layer first" without selection. Even with selection, passed nodeId must match selected node. |
| `get_variable_defs(nodeId)` | **Selection-required** | Same selection + nodeId-match constraint. Returns `{"VariableName":"value"}` map of Variables **consumed by the selected node only** — NOT the file's full Variable collection. Colors as hex strings (`"Text/Default":"#414141"`); typography as Figma `Font(family:..., style:..., size:..., weight:..., lineHeight:..., letterSpacing:...)` strings; numerics as bare values. |
| `get_libraries(fileKey)` | Selection-free | Returns subscribed external libraries (Material, iOS, etc.) + community libraries available to add. **Does NOT enumerate local file Variables.** |
| `search_design_system(query)` | Selection-free | Searches SUBSCRIBED libraries only. **Does NOT find local file Variables or local page symbols.** |
| `get_screenshot(nodeId)` | Selection-free | PNG of the node. |

**Invisible local Variables.** There is NO MCP tool that enumerates a file's full local Variable collection. To verify a Variable's existence, find a node that consumes it and probe via `get_variable_defs` (selection-required). Variables defined but unused are invisible — Conv 181 [TSV] could not confirm whether speculative `alert-light`/`carmine-red` exist as Variables because no node consumes them.

**Efficient batch-probing.** Selecting a container frame returns all child-consumed Variables in one call. Conv 181 [TSV]: selecting the Headers section (40:493) returned 10 Header Variables; selecting the Body section (40:485) returned 8 Body Variables. Always prefer container selection over per-node selection when batch-inventorying tokens.

## Per-target output shape (selection-required tools)

| Target | `get_design_context` returns | Useful for |
|---|---|---|
| Section frame (e.g., Components > Button Primary section) | Sparse metadata + "drill into sublayers" hint | Discovery step — must drill |
| Component variant frame (e.g., Button Primary > Default) | **Typed React component with INFERRED PROPS** (`hasLabel`, `hasLeadingIcon`, etc.) | Building primitives |
| Page or card frame | **INLINED HTML+CSS rendering.** Component instances appear as raw markup with `data-name` attributes, NOT as `<ComponentName>` calls | Visual reference + manual substitution |

## Output characteristics

**`data-name` attribute IS the translation key.** Every component instance and icon in `get_design_context` output carries `data-name="<figma symbol name>"`. Grep/substitute when porting MCP-generated code to your registry. Examples: `data-name="course"`, `data-name="Entity Pill"`, `data-name="Button Primary"`, `data-name="Property 1=Right"` (variant), `data-name="stars_2"` (external Material icon).

**Colors come through as CSS variables with hex fallback.** Format: `var(--background,#e8f4df)`, `var(--text/default,#414141)`, `var(--primary,#327d00)`. The **Variable Mode of the parent context is baked into the fallback hex** — same `var(--background,...)` reference has different hex fallbacks in Course context (pastel-green `#e8f4df`) vs Creator context (lavender-blue `#e0e8ff`) vs Student context (pastel-blue `#f1f9ff`). Per-component sub-tokens may exist beyond the global Color Guide.

**Variable Mode is observable, not configurable, via MCP.** Probing `get_variable_defs` on a node inside a Course-context container returns Course-mode values for context-bound Variables (e.g., `"Primary":"#327d00"`). The MCP gives you the resolved value for whatever context the selected node lives in. To probe a different mode, navigate to a node in that mode's context and re-select.

**Plugin-rendered visualizations are NOT authoritative Variable names.** Matt's Color Guide page is generated by a "Color Variable Style-Guide Generator" plugin that renders labels like "Primary/Primary" — but the actual Variable name is `Primary/Default` (Conv 181 discovery). Always verify Variable names via `get_variable_defs`, NOT `get_metadata` label text. The plugin-rendered guide also omits Variables not in its filter scope (Conv 181: `--white` is a real Variable but doesn't appear in the rendered Color Guide).

**Asset URLs expire after 7 days.** Icon SVGs and images are referenced as `https://www.figma.com/api/mcp/asset/<uuid>` — short-lived. Never paste asset URLs into production code; substitute against your own icon registry / asset store.

**"SUPER CRITICAL" translation notice always present.** MCP explicitly tells you: *"The generated React+Tailwind code MUST be converted to match the target project's technology stack and styling system."* **Translation IS the workflow** — there is no paste-in shortcut. Collapses any "match MCP output names to optimize paste-in" argument.

## Seat tier (Dev vs Full)

**Dev seat is sufficient for all read operations.** Page listing + any node-id query both work. Per [Figma docs](https://developers.figma.com/docs/figma-mcp-server/plans-access-and-permissions/): Dev seat = read-only outside drafts. Full seat = required for writes (usually unwanted — write-blocking is a structural safety guarantee).

**View/Collab seats are capped at 6 tool calls per month** on Starter/paid plans — practically unusable. Recommend Dev seat to a new collaborator (not View, not Full).

## Implications captured at decision points

- **Icon registry naming** is decoupled from MCP output. Translation table handles mapping regardless of whether registry keys are Figma symbol names or designer's display labels. Code-readability dominates.
- **Designer's "Dev Ready" labels** (e.g., Matt's `Section Title` component WIP/Dev Ready/Archived variants) are a **purely human visual convention**, NOT Figma metadata the MCP can read. Ask the designer.
- **External library icons appear inline** in real designs (Material `stars_2`, `accessibility_new`, `how_to_reg`) — designer's curated set is NOT the only icon scope you'll need.
- **Token-system audits via `get_variable_defs`** are selection-bound. Batch by selecting the largest container frame that covers your target Variables (Conv 181 [TSV]: Body section → 8 Variables, Headers section → 10 Variables, each one call).
- **The visual-absence heuristic** for "does this Variable exist?" is the strongest signal available without consuming-node probing. If no layer in any page uses red/pink, `--carmine-red` is effectively absent regardless of whether the Variable record technically exists.

## Workflow pattern

User-as-navigator: itemize what URLs you need, user pastes them, you query. For selection-required tools, the user must also click the specific layer in Figma desktop. Maintain a checklist (inline conversation for small batches, `.scratch/figma-mcp-needs.md` for larger). See [[user_hands_off_pilot_workflow]] for the broader hand-off philosophy.

Related: [[feedback_external_source_of_truth_first]] for the vendor-doc-first principle that should precede inferring MCP behavior.
