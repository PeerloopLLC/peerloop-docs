---
name: PLATO Browser Mode via Chrome MCP
description: Browser-runs execute through /chrome MCP bridge, not Playwright; use correct PLATO terminology
type: feedback
---

PLATO has two execution modes — API mode and Browser mode. Use correct terminology:
- "API-run [instance]" — automated endpoint execution
- "Browser-run [instance]" — Chrome MCP bridge execution
- "STUMBLE-AUDIT" — a PLAN.md project block, not a system or verb

**Why:** Browser-runs are part deterministic (NavClick navigation, fail-fast) and part instructional (prose pageAction). This split is by design — pageAction is too varied to automate. The /chrome MCP bridge is the execution engine for browser-runs, not Playwright.

**How to apply:**
- When user says "do a browser-run of [instance]" → use chrome MCP tools to navigate via BrowserIntents and execute pageActions interactively
- Never suggest translating BrowserIntents to Playwright — that misunderstands the design
- Never call browser-runs "STUMBLE walkthroughs" or "manual walkthroughs"
- E2E (Playwright) is a separate test layer — not PLATO, doesn't use instances or BrowserIntents
- Don't frame chrome MCP as "ad-hoc debugging" — it's the actual browser-run execution engine
