---
name: reference-figma-mcp-behavior
description: "Figma Remote MCP empirical behavior — link-based by design (don't enumerate), per-tool output shapes (section=sparse, component-variant=typed React with props, page=inlined markup), data-name is the translation key, asset URLs expire 7d, Variable Mode bakes into CSS-var fallback hex, search_design_system finds only subscribed libs not local symbols"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 412a9081-86ff-4bf9-b714-cae19905c180
---

Figma Remote MCP (`https://mcp.figma.com/mcp`) — empirical behavior verified Conv 180 against PeerLoop file `UpDNMiIEO8y3J7ZHkm356b` via Dev seat on Peerloop org (pro tier).

## Architecture

**Link-based by design.** Per [Figma's docs](https://developers.figma.com/docs/figma-mcp-server/remote-server-installation/): *"The remote Figma MCP server is link-based. This means that you need to provide the context of the link or selection that you want the MCP server to use, by copying from a file, and pasting it into your tool of choice."* Do NOT try to enumerate file structure — **the user is the navigator**. Ask them to right-click → "Copy link to selection" → paste the URL.

**Page listing is incidental, node access is not.** `get_metadata(fileKey)` with no nodeId returns only currently-scoped pages (probably "last viewed" — Conv 180 returned 2 of 9 actual pages), NOT the full page tree. **Any node-id can be queried directly** even if its parent page doesn't appear in the listing (invisible-but-accessible). Conv 180 verified: probing `Content / Happy / Home` (node 477:8502) on the un-listed Happy Path page worked cleanly.

## Per-tool output behavior

| Tool / target | Returns | Useful for |
|---|---|---|
| `get_metadata(fileKey)` no nodeId | Top-level pages list — incidentally filtered | File-level discovery (incomplete) |
| `get_metadata(nodeId=section)` | **Sparse metadata + "drill into sublayers" instruction**, NOT code | Discovery step only — must drill |
| `get_metadata(nodeId=frame/component)` | Full XML structure with all child IDs | Structural understanding |
| `get_design_context(nodeId=variant frame)` e.g. Button Primary > Default | **Typed React component with INFERRED PROPS** (`hasLabel`, `hasLeadingIcon`, etc.) — most useful output | Building primitives |
| `get_design_context(nodeId=page or card)` | **INLINED HTML+CSS rendering.** Component instances appear as raw markup with `data-name` attributes, NOT as `<ComponentName>` calls | Visual reference + manual substitution |
| `search_design_system(query)` | Only returns components from **SUBSCRIBED libraries** (e.g., Material, Apple HIG) — NOT local symbols defined on pages | Discovering external library components only — wrong tool for "find designer's icons" |

## Output characteristics

**`data-name` attribute IS the translation key.** Every component instance and icon in `get_design_context` output carries `data-name="<figma symbol name>"`. This is what you grep/substitute when porting MCP-generated code to your registry. Examples seen: `data-name="course"`, `data-name="Entity Pill"`, `data-name="Button Primary"`, `data-name="Property 1=Right"` (variant), `data-name="stars_2"` (external Material icon).

**Colors come through as CSS variables with hex fallback.** Format: `var(--background,#e8f4df)`, `var(--text/default,#414141)`, `var(--primary,#327d00)`. The **Variable Mode of the parent context is baked into the fallback hex** — same `var(--background,...)` reference will have different hex fallbacks in Course context (pastel-green `#e8f4df`) vs Creator context (lavender-blue `#e0e8ff`) vs Student context (pastel-blue `#f1f9ff`). Per-component sub-tokens may exist beyond the global Color Guide (e.g., `--color` on Button Primary).

**Asset URLs expire after 7 days.** Icon SVGs and images are referenced as `https://www.figma.com/api/mcp/asset/<uuid>` — these are short-lived. Never paste asset URLs into production code; substitute against your own icon registry / asset store.

**"SUPER CRITICAL" translation notice always present.** MCP explicitly tells you: *"The generated React+Tailwind code MUST be converted to match the target project's technology stack and styling system."* **Translation IS the workflow** — there is no paste-in shortcut. This collapses any argument that depends on "matching MCP output names to optimize paste-in efficiency."

## Seat tier (Dev vs Full)

**Dev seat is sufficient for all read operations.** Page listing + any node-id query both work. Per [Figma docs](https://developers.figma.com/docs/figma-mcp-server/plans-access-and-permissions/): Dev seat = read-only outside drafts. Full seat = required for writes (which are usually unwanted — write-blocking is a structural safety guarantee).

**View/Collab seats are capped at 6 tool calls per month** on Starter/paid plans — practically unusable. Recommend Dev seat to a new collaborator (not View, not Full).

## Implications captured at decision points

- **Icon registry naming convention** is decoupled from MCP output. Translation table handles mapping regardless of whether registry keys are Figma symbol names or designer's display labels. Code-readability dominates the choice.
- **Designer's "Dev Ready" labels** (e.g., Matt's `Section Title` component with WIP/Dev Ready/Archived variants) are a **purely human visual convention**, NOT Figma metadata the MCP can read or filter on. Don't try to detect Dev-Ready status programmatically — ask the designer.
- **External library icons appear inline** in real designs (Material `stars_2`, `accessibility_new`, `how_to_reg` etc.) — designer's curated set is NOT the only icon scope you'll need. Plan for a separate harvest of inline-external icons used in Phase 5 page implementations.
- **`get_variable_defs`** behavior (whether it returns ready-to-paste CSS variable declarations or just key→hex pairs) was NOT probed Conv 180. Verify when token implementation starts.

## Workflow pattern

User-as-navigator: itemize what URLs you need, user pastes them, you query. Maintain a checklist (inline conversation for small batches, `.scratch/figma-mcp-needs.md` for larger). See [[user_hands_off_pilot_workflow]] for the broader hand-off philosophy.

Related: [[feedback_external_source_of_truth_first]] for the vendor-doc-first principle that should precede inferring MCP behavior.
