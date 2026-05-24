# Figma MCP — Remote Server Reference

**Type:** External MCP server (design-tool bridge)
**Status:** ACTIVE — registered Conv 179, OAuth-verified Conv 180, validated through Conv 181
**Source:** https://developers.figma.com/docs/figma-mcp-server/
**Endpoint:** `https://mcp.figma.com/mcp` (HTTP transport)

---

## Overview

The Figma MCP server is Claude Code's bridge into the design tool. Once authenticated, it surfaces ~10 tools (prefix `mcp__figma__*`) that read Figma file structure, component metadata, design tokens (Variables), screenshots, and design-context HTML+CSS. Peerloop uses it as the primary mechanism for translating Matt's designs into code — the canonical workflow under MATT-DESIGN-PUSH.

**Path chosen:** Figma's official **remote/hosted MCP** (recommended by Figma's own docs as of Conv 179). The alternative local-MCP path (Figma desktop + Dev seat + manual `settings.json` edit) was investigated and rejected — remote requires only OAuth and works on any machine.

---

## Setup (one-time per machine)

### Step 1 — Register the MCP server

In any terminal (Claude Code picks this up at next session start):

```bash
claude mcp add --transport http figma https://mcp.figma.com/mcp
```

This registers the server in CC's user-level MCP registry (`~/.claude.json`, project-scoped to `peerloop-docs`). Verify with:

```bash
claude mcp list
```

Expected line on a fresh install: `figma: https://mcp.figma.com/mcp - ! Needs authentication`.

Reversible: `claude mcp remove figma`.

### Step 2 — OAuth authenticate

Inside a Claude Code session (start a new conv after registering):

1. Type `/mcp` at the prompt → select **figma**
2. Choose **Authenticate**
3. Browser opens at Figma's OAuth consent screen
4. Sign in with the account that has Peerloop workspace access
5. Click **Allow Access**

CC reports: `Authentication successful. Connected to figma`. The MCP server list loads once at session start, so OAuth must complete BEFORE the conv where you want to use it. Practical pattern: register + auth in one conv, use the tools in the next.

### Step 3 — Verify tools are loaded

In the same CC session:

```
/mcp
```

Should show `figma` as connected (not "Needs authentication") with available tools. Then in CC:

```
ToolSearch with query "select:mcp__figma__get_metadata,mcp__figma__get_variable_defs"
```

Returns the tool schemas. The full set as of Conv 181:

- `mcp__figma__get_metadata`
- `mcp__figma__get_design_context`
- `mcp__figma__get_variable_defs`
- `mcp__figma__get_screenshot`
- `mcp__figma__get_libraries`
- `mcp__figma__search_design_system`
- `mcp__figma__get_figjam`
- `mcp__figma__create_new_file`
- `mcp__figma__generate_figma_design`
- `mcp__figma__use_figma`
- `mcp__figma__upload_assets`
- Plus a few code-connect tools (`get_code_connect_map`, `add_code_connect_map`, `get_code_connect_suggestions`)

This reference covers only the read-side tools — the write/generate tools are out of scope for current Peerloop work (we read Matt's design into code, not the reverse).

---

## Architecture — link-based by design

Per [Figma's docs](https://developers.figma.com/docs/figma-mcp-server/remote-server-installation/):

> *"The remote Figma MCP server is link-based. This means that you need to provide the context of the link or selection that you want the MCP server to use, by copying from a file, and pasting it into your tool of choice."*

**Do NOT try to enumerate file structure** — the user is the navigator. Practical workflow:

1. User opens the relevant Figma page in the desktop client
2. User right-clicks the layer → "Copy link to selection" → pastes URL into chat
3. Claude parses the `node-id` from the URL and calls the relevant MCP tool

URL parsing: `figma.com/design/<fileKey>/<fileName>?node-id=<nodeId>` — convert `-` to `:` in nodeId (Figma URL encoding artifact). Example: `?node-id=519-9096` becomes `nodeId="519:9096"`.

---

## Two tool classes (CRITICAL distinction — refined Conv 186)

Tools split into **selection-free** (URL/nodeId alone is sufficient) and **conditionally-selection-required**. Conv 180 only exercised `get_metadata` via node-id and over-generalized. Conv 181's [TSV] saw `get_design_context` / `get_variable_defs` fail with "select a layer first" and classified them as selection-required. **Conv 186 [MFRD-SEED] disproved the absolute requirement**: 11+ parallel `get_design_context` probes against explicit node-IDs across the Components page returned full JSX with NO Figma desktop selection. Corrected rule: selection is needed only when the request semantics target the **currently-selected** node (omitted/stale nodeId); explicit node-IDs bypass the selection gate.

| Tool | Class | Behavior |
|---|---|---|
| `get_metadata(nodeId)` | Selection-free | Any node-id works. Returns XML structure. Page-listing call (no nodeId) returns currently-scoped pages only — incomplete (~2 of 9 pages in Conv 180 sample); any specific node-id is invisible-but-accessible. |
| `get_design_context(nodeId)` | **Selection-free with explicit nodeId** (Conv 186) | Works without Figma desktop selection when an explicit nodeId is passed; 11-call parallel batch verified Conv 186. Falls back to "select a layer first" only when nodeId is omitted or stale. |
| `get_variable_defs(nodeId)` | **Likely selection-free with explicit nodeId** (Conv 186 by analogy — not separately re-tested) | Conv 181 failures were stale/mismatched nodeIds; Conv 186's selection-free `get_design_context` finding suggests the same rule applies here. Returns `{"VariableName":"value"}` map of Variables **consumed by the target node only** — NOT the file's full Variable collection. Colors as hex strings (`"Text/Default":"#414141"`); typography as Figma `Font(family:..., style:..., size:..., weight:..., lineHeight:..., letterSpacing:...)` strings; numerics as bare values. |
| `get_libraries(fileKey)` | Selection-free | Returns subscribed external libraries (Material, iOS, etc.) + community libraries available to add. **Does NOT enumerate local file Variables.** |
| `search_design_system(query)` | Selection-free | Searches SUBSCRIBED libraries only. **Does NOT find local file Variables or local page symbols.** |
| `get_screenshot(nodeId)` | Selection-free | PNG of the node. |

**Invisible local Variables.** There is NO MCP tool that enumerates a file's full local Variable collection. To verify a Variable's existence, find a node that consumes it and probe via `get_variable_defs`. Variables defined but unused are invisible — Conv 181 [TSV] could not confirm whether speculative `alert-light`/`carmine-red` Variables exist because no node in the file consumes them.

**Efficient batch-probing.** Selecting a container frame returns all child-consumed Variables in one call. Conv 181 [TSV] examples: selecting the Headers section (node 40:493) returned 10 Header Variables; selecting the Body section (40:485) returned 8 Body Variables. Always prefer container selection over per-node selection when batch-inventorying tokens.

---

## Per-target output shape (selection-required tools)

| Target | `get_design_context` returns | Useful for |
|---|---|---|
| Section frame (e.g., Components > Button Primary section) | Sparse metadata + "drill into sublayers" hint | Discovery step — must drill |
| Component variant frame (e.g., Button Primary > Default) | **Typed React component with INFERRED PROPS** (`hasLabel`, `hasLeadingIcon`, etc.) | Building primitives |
| Page or card frame | **INLINED HTML+CSS rendering.** Component instances appear as raw markup with `data-name` attributes, NOT as `<ComponentName>` calls | Visual reference + manual substitution |

---

## Output characteristics

**`data-name` IS the translation key.** Every component instance and icon in `get_design_context` output carries `data-name="<figma symbol name>"`. Grep/substitute when porting MCP-generated code to your registry. Examples: `data-name="course"`, `data-name="Entity Pill"`, `data-name="Button Primary"`, `data-name="Property 1=Right"` (Component variant), `data-name="stars_2"` (external Material icon).

**Colors come through as CSS variables with hex fallback.** Format: `var(--background,#e8f4df)`, `var(--text/default,#414141)`, `var(--primary,#327d00)`. The **Variable Mode of the parent context is baked into the fallback hex** — same `var(--background,...)` reference has different hex fallbacks in Course context (pastel-green `#e8f4df`) vs Creator context (lavender-blue `#e0e8ff`) vs Student context (pastel-blue `#f1f9ff`). Per-component sub-tokens may exist beyond the global Color Guide.

**Variable Mode is observable, not configurable, via MCP.** Probing `get_variable_defs` on a node inside a Course-context container returns Course-mode values for context-bound Variables (e.g., `"Primary":"#327d00"`). The MCP gives you the resolved value for whatever context the selected node lives in. To probe a different mode, navigate to a node in that mode's context and re-select.

**Plugin-rendered visualizations are NOT authoritative Variable names.** Matt's Color Guide page is generated by a "Color Variable Style-Guide Generator" plugin that renders labels like `"Primary/Primary"` — but the actual Variable name is `Primary/Default` (Conv 181 discovery). Always verify Variable names via `get_variable_defs`, NOT `get_metadata` label text. The plugin-rendered guide also omits Variables not in its filter scope (Conv 181: `--white` is a real Variable but doesn't appear in the rendered Color Guide).

**Asset URLs expire after 7 days.** Icon SVGs and images are referenced as `https://www.figma.com/api/mcp/asset/<uuid>` — short-lived. Never paste asset URLs into production code; substitute against your own icon registry / asset store.

**"SUPER CRITICAL" translation notice always present.** MCP explicitly tells you: *"The generated React+Tailwind code MUST be converted to match the target project's technology stack and styling system."* **Translation IS the workflow** — there is no paste-in shortcut. This collapses any "match MCP output names to optimize paste-in" argument.

---

## Seat tier (Dev vs Full)

**Dev seat is sufficient for all read operations.** Page listing + any node-id query both work. Per [Figma docs](https://developers.figma.com/docs/figma-mcp-server/plans-access-and-permissions/): Dev seat = read-only outside drafts. Full seat = required for writes (usually unwanted — write-blocking is a structural safety guarantee).

**View / Collab seats are capped at 6 tool calls per month** on Starter/paid plans — practically unusable. Recommend Dev seat for a new collaborator (not View, not Full).

---

## Workflow patterns

### User as navigator

Itemize what URLs you need, user pastes them, you query. For selection-required tools, the user must also click the specific layer in Figma desktop. Maintain a checklist (inline conversation for small batches, `.scratch/figma-mcp-needs.md` for larger batches).

### Batch-probing for tokens

Goal: enumerate all Variables in a token category (e.g., Header typography) in as few MCP calls as possible. Pattern:

1. Identify the largest container frame that covers your target Variables (e.g., the "Headers" section on the Color Guide page)
2. Ask the user to select that frame in Figma desktop
3. Call `get_variable_defs(<containerNodeId>)` — returns all Variables consumed by the entire subtree

Conv 181 [TSV] inventoried 18 typography Variables in 2 calls (Headers section + Body section).

### Token verification (does Variable X exist?)

The MCP has no Variable-enumeration call, so you cannot directly answer "does `--carmine-red` exist as a Variable?" To check:

1. Inspect Matt's design for any visible usage of the color/value in question
2. If found: ask user to select that node, then `get_variable_defs(<nodeId>)` — Variable will appear by name
3. If no visible usage exists: the Variable is "effectively absent" regardless of whether it technically exists in the file. This is the **visual-absence heuristic** — strongest signal available without consuming-node probing.

This empirical-probe approach is the basis for the `feedback_tokenize_only_matt_variables.md` design-system principle (Conv 181 [NOTE-YELLOW]): if a value doesn't show up in `get_variable_defs`, don't invent a token for it.

---

## Implications captured at decision points

- **Icon registry naming** is decoupled from MCP output. The mandatory translation step handles name mapping regardless of whether registry keys match Figma symbol names or designer's display labels. Code-readability dominates.
- **Designer's "Dev Ready" labels** (e.g., Matt's `Section Title` component WIP / Dev Ready / Archived variants) are a **purely human visual convention**, NOT Figma metadata the MCP can read. Ask the designer.
- **External library icons appear inline** in real designs (Material `stars_2`, `accessibility_new`, `how_to_reg`) — designer's curated set is NOT the only icon scope you'll need.
- **MMP-PH4 visual diff** (re-render test) uses MCP-supplied `get_design_context` HTML+CSS as the comparison target. The translation work (substituting `data-name` attrs against the project's component registry) is THE workflow gate, not a paste-in shortcut.

---

## Fallback paths

### Fallback 1 — Local Dev Mode MCP server

Use if remote MCP OAuth fails or returns "no access to file" after auth. Requires:

1. Figma desktop app (Mac: `brew install --cask figma`)
2. Dev seat assigned by workspace admin
3. Toggle "Dev Mode MCP server" ON in Figma desktop → Preferences
4. Local endpoint defaults to `http://127.0.0.1:3845/sse`
5. Register: `claude mcp add --transport sse figma-local http://127.0.0.1:3845/sse`

### Fallback 2 — Community MCP (`figma-developer-mcp` by GLips)

Use only if both official paths (remote + local) are blocked. REST-only — no live selection sync; paste file/node URLs manually into prompts.

1. Generate Figma personal access token: avatar → Settings → Account → Personal access tokens → Generate
2. Register in CC:
   ```bash
   claude mcp add figma-community --env FIGMA_API_KEY=<paste-token> -- npx -y figma-developer-mcp --stdio
   ```
3. ⚠️ Token is now stored in CC's MCP registry — verify it doesn't get backed up to git anywhere unintentional.

---

## Related

- `memory/reference_figma_mcp_behavior.md` — same empirical findings in memory-rule shorthand for fast recall
- `memory/feedback_tokenize_only_matt_variables.md` — design-system principle derived from MCP probe behavior (Conv 181 [NOTE-YELLOW])
- `memory/feedback_external_source_of_truth_first.md` — vendor-doc-first principle that should precede inferring MCP behavior (Conv 179 [VDF])
- `docs/as-designed/matt-design-system.md` — design-system spec where MCP-extracted Variables land
- Conv 178–181 session extracts — full empirical-discovery archaeology
