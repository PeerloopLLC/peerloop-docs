---
name: PLATO testing system context
description: Load when PLATO, browser-run, STUMBLE-AUDIT, or BrowserIntent work is discussed — terminology, execution modes, screenshot conventions
type: feedback
originSessionId: 5cb02e45-1cbd-40f3-926e-c489d261a295
---
## Terminology

- **PLATO** = the whole orchestration system (steps, scenarios, persona sets, instances)
- **API mode / "API-run [instance]"** = automated API chain execution
- **Browser mode / "browser-run [instance]"** = execute BrowserIntents in Chrome via /chrome MCP bridge
- **STUMBLE-AUDIT** = a PLAN.md project block (the effort to browser-run every instance), NOT a system name or verb
- **Run** = one execution of an instance, always qualified by mode

Use "API-run flywheel" or "browser-run flywheel" — never "STUMBLE walkthrough" or "manual walkthrough."

## Browser-Run Execution

Browser-runs execute through the /chrome MCP bridge, not Playwright. Two intent types:
- **NavClick** — deterministic navigation, fail-fast
- **pageAction** — prose instructions, executed interactively (intentionally non-automatable)

E2E (Playwright) is a separate test layer — not PLATO, does not use instances or BrowserIntents. Never suggest translating BrowserIntents to Playwright. Never call chrome MCP "ad-hoc debugging" — it's the actual browser-run execution engine.

## Conditional Nav Links

Nav paths from route-map.generated.ts assume links always exist, but some are conditional:
- AppNavbar "Complete Profile" → `/onboarding` has `hideWhenOnboarded` — disappears after onboarding
- Capability-gated links (e.g., `/teaching` only for teachers) may not exist at runtime

Browser-run steps following a nav path need a fallback (e.g., direct URL entry) if the link is state-dependent.

## Screenshots During Browser Walks

Default: **no screenshots**. Only when user says "with screenshots":
1. `mkdir -p /tmp/stumble-screenshots/{instance-name}`
2. `screencapture -x /tmp/stumble-screenshots/{instance-name}/{NN}-{intent-slug}.png` at each checkpoint
3. `open /tmp/stumble-screenshots/{instance-name}` at walk end
4. Use zero-padded NN (01, 02, ...) and kebab-case slug from intent name

## Infrastructure vs Deliverable

When building PLATO infrastructure (snapshots, scenarios), the user's primary goal is a **repeatable pattern** alongside the immediate task. Surface the dual goal early — the user decides what to prioritize, but both goals should be visible. Ask: "Is this approach generalizable, or am I special-casing for the immediate task?"
