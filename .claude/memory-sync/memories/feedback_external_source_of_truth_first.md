---
name: feedback-external-source-of-truth-first
description: "When an authoritative external source exists (vendor docs, designer-supplied catalogue, user-supplied source files, observable tool behavior), consult or probe it BEFORE inferring from training data, visual analysis, or imagined runtime semantics"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4a3f5c68-576b-4124-9384-868420f173e6
---

**Rule.** When an authoritative external source-of-truth exists for the current task — vendor documentation, a designer-supplied catalogue or naming list, user-provided source files, or the observable runtime behavior of an external tool — consult or probe it BEFORE inferring from training data, visual cues, filename guesses, or imagined semantics.

**Why.** Training data is months stale and vendors evolve fast. Visual inference from designs miscategorizes details that the designer's own label resolves unambiguously. User-supplied material is, by definition, the user's intent expressed canonically — guessing around it wastes their time and reverts choices they already made. Inferring how a tool behaves (vs. probing it once) burns user trust when every recommendation gets corrected by the next test.

**How to apply.** Four concrete contexts where this has bitten this project:

1. **Vendor MCP / SDK setup (Conv 179 [VDF]).** Drafted a Figma MCP walkthrough from training-data recollection — recommended the *local* desktop-MCP path with manual settings.json editing. User pointed at the live docs at `developers.figma.com/docs/figma-mcp-server/`; Figma actually recommends the *remote* hosted MCP (`https://mcp.figma.com/mcp`) via `claude mcp add` CLI + OAuth. Wholly different setup. **Rule: before drafting any MCP/SDK/CLI install walkthrough, `WebFetch` the vendor's current docs.**

2. **Designer-supplied catalogues (Conv 178 [MFM]).** Matt's icon Figma export auto-named files from source Material-Icon names (`newspaper.svg`, `mail.svg`, `calendar_month.svg`, `Vector.svg`). Matt's own catalogue screenshot had the authoritative semantic labels: `feed`, `message`, `calendar`, `user-icon`. Visual inference and filename guesses produced 3 wrong names; 6 corrections needed from the catalogue. **Rule: when a designer-supplied catalogue / index / naming list exists, treat its labels as authoritative over visual-ID drilling or filename inference.**

3. **User-supplied source files (Conv 178 [STOR] [DTU]).** When the user provides a screenshot, paste, file, or other source material as the basis for work, treat it as canonical. Don't drill into independent visual analysis or schema inference when the user's material already states the answer. **Rule: ask the user for their source-of-truth material BEFORE doing independent visual ID drilling or domain inference.**

4. **External tool behavior — probe before recommending (Conv 180 [EMP]).** Made multiple Figma Remote MCP architectural recommendations (registry naming convention, page-filtering hypothesis as Dev-seat-related, `search_design_system` as the icon-discovery tool, optimizing for paste-in efficiency) based on *inferred* behavior of `get_metadata` / `get_design_context` / `search_design_system`. Every recommendation was reversed by the next probe: node access works on unlisted pages (link-based architecture, not seat filtering); `search_design_system` returns only SUBSCRIBED libs, not local symbols; `get_design_context` inlines components as raw markup rather than emitting `<ComponentName>` calls, and explicitly tells you translation IS the workflow. User pushback was direct: *"what you think is going on often is inaccurate or incompletely understood. I don't want recommendations prematurely."* **Rule: when a recommendation depends on how an external tool behaves, probe the tool on a real node BEFORE recommending. One tool call beats one rework cycle.**

**Anti-pattern.** "Drafting from memory" / "starting from training data" / "visually inspecting first" / "reasoning about how the tool probably works." Cheap upfront, expensive when the user redirects with the actual canonical source (or the probe result) minutes later — both for the rework and for the lost trust that you didn't bother to look.

**Related.** [[feedback-check-docs-on-how-questions]] (specific case: check project docs on "how does X work?" questions). [[feedback-memory-index-load-bearing]] (this rule benefits from named markers `[VDF]` / `[MFM]` / `[STOR]` to surface in `grep`-based memory recall).
