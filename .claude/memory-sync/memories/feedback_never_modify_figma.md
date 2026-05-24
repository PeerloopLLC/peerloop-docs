---
name: feedback-never-modify-figma
description: "Figma is strictly read-only for CC; never call mcp__figma__use_figma, create_new_file, upload_assets, or any write-shaped tool. Translation runs Figma → code only, never code → Figma."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 68c6ec99-d543-4ae1-aab5-d6c1e972deed
---

**Rule:** Treat Figma as read-only. Never call `mcp__figma__use_figma`, `create_new_file`, `upload_assets`, `add_code_connect_map`, `send_code_connect_mappings`, or any other Figma MCP tool that writes / creates / modifies content. Only read-shaped tools are permitted: `get_metadata`, `get_design_context`, `get_screenshot`, `get_variable_defs`, `get_libraries`, `search_design_system`, `get_figjam`, `get_code_connect_map`, `get_code_connect_suggestions`, `whoami`.

**Why:** Conv 183 [MNV] — user stated explicitly: "We are not to change Figma at all." Matt is the sole author of all Figma content; CC's role is one-directional translation Figma → code via probes and screenshots. Even seemingly-benign writes (e.g., Code Connect mappings that affect what other Dev-seat viewers see in Figma) are out of scope unless the user opens that door explicitly. Reinforces [[project_matt_collaboration_style]] — Matt's working material lives in Figma; we produce markdown specs *from* probes, not *into* the file.

**How to apply:**
- When the user asks for "Figma-to-code" or "implement this Figma design," only read-tools fire.
- When proposing a method that *could* write to Figma (e.g., "let's annotate the Figma file with the spec"), STOP and propose an alternative (scratch markdown, in-code comments, separate memo).
- If a workflow question genuinely needs Figma modification, ask the user first — never assume permission.
- Skill libraries (`/figma-use`, `/figma-generate-design`, `/figma-generate-library`, `/figma-code-connect`, `/figma-use-figjam`, `/figma-generate-diagram`) are all out-of-scope unless the user explicitly re-opens the door.
