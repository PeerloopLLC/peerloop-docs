---
description: Project-specific CLAUDE.md pruning config (extends /q-prune-claude)
argument-hint: ""
---

# Peerloop CLAUDE.md Pruning Config

**Extends:** `/q-prune-claude` (run that for the workflow)

**Configuration** (thresholds, paths) comes from `.claude/config.json`.

This file defines Peerloop-specific keep/move rules.

---

## Must-Keep Sections (Never Move)

These sections are essential for Peerloop and must stay in CLAUDE.md:

| Section | Reason |
|---------|--------|
| Project Overview | Core context for every session |
| Technology Stack | Quick reference for tech decisions |
| Development Commands | Used constantly |
| Key Roles | Essential for understanding user types |
| Research Reference | Navigation to specs |
| Block Sequence | Current development focus |
| Session Startup Hooks | Critical for machine detection |

---

## Move Candidates

These can be moved to offload if CLAUDE.md gets bloated:

| Section | Priority to Move |
|---------|------------------|
| Detailed tech doc paths | Medium |
| Full environment variable list | High |
| Extended code examples | High |
| Historical decisions | High |
| Detailed API patterns | Medium |

---

## Peerloop-Specific Rules

1. **Keep machine detection info** - MacMiniM4-Pro and MacMiniM4 identification
2. **Keep RFC system reference** - Active development workflow
3. **Keep block codes** - Current terminology (VIDEO, ADMIN, etc.)
4. **Move completed block details** - Historical, not active guidance
