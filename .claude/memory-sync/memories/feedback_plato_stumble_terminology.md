---
name: PLATO terminology — modes and runs
description: PLATO is the system; API mode and Browser mode are execution modes; a "run" is one execution of an instance; STUMBLE-AUDIT is a project block not a system
type: feedback
---

**Terminology (Conv 073, refined Conv 075):**

- **PLATO** = the whole orchestration system (steps, scenarios, persona sets, instances)
- **Run** = one execution of an instance, always qualified by mode
- **API mode** / "API-run [instance]" = automated API chain execution
- **Browser mode** / "browser-run [instance]" = execute BrowserIntents in Chrome via /chrome MCP bridge
- **STUMBLE-AUDIT** = a PLAN.md project block (the effort to browser-run every instance), NOT a system

**Why:** "STUMBLE" was overloaded — used as both a system name and a project block. Conv 073 simplified: PLATO is one system with two modes. STUMBLE-AUDIT remains as the project tracking name only.

**How to apply:** Use "API-run" and "browser-run" in conversation. Don't say "PLATO run" vs "STUMBLE walkthrough" — say "API-run flywheel" or "browser-run flywheel." Browser-runs execute through the /chrome MCP bridge — NavClick navigation is deterministic (fail-fast), pageAction is prose (instructional, executed interactively). This split is by design; browser-runs are NOT Playwright tests. E2E (Playwright) is a separate test layer. Definitions are in GLOSSARY.md § Testing & Quality (PLATO) and plato.md § Execution Modes.
