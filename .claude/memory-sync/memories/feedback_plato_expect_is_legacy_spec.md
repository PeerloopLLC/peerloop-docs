---
name: feedback_plato_expect_is_legacy_spec
description: "PLATO browser-mode expect/pageAction is a frozen functional spec of the legacy pages — when an audit finds \"UI missing\" on a Matt-ported page, triage REDESIGN/REGRESSION/NEVER-EXISTED against the preflip legacy source BEFORE editing the test"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7f0ff8ad-bf19-422b-9c0d-710fcdf280c3
---

When a PLATO browser-mode audit reports that an `expect`/`pageAction` element is "missing" on the current (Matt-inspired, post-route-flip) page, do **NOT** assume the test prose is merely stale and "fix" it to match the current page. PLATO `expect`/`pageAction` was written against the ORIGINAL pages, so it is a **frozen functional spec of the legacy `/old`-era behavior**. A "missing element" has three causes that must be distinguished by reading BOTH sides — current `~/projects/Peerloop` + legacy preflip worktree `~/projects/Peerloop-preflip` @ `608346a2`:

- **REDESIGN** — element renamed/relocated, capability intact → update the test prose.
- **REGRESSION (DISC-DROP)** — element existed in legacy, dropped in the legacy→Matt port → FAILED port; **restore the UI, do NOT edit the test** (editing it hides the regression — PLATO is the canary).
- **NEVER-EXISTED** — the prose over-claimed a UI affordance never built (often the *automated* step hits an API directly and passes; only the human-facing browser prose assumes a button) → correct the prose to reality, OR keep it + add a `// GAP:` marker if the UI is genuinely wanted.

**Why:** Conv 343 — I was about to "fix" 41 PLATO prose divergences to match the current pages; the user caught that several "missing buttons" could be UI lost in the Tier-1/Tier-2 Matt port. A 7-element legacy-vs-current triage found **0 regressions** (the port preserved behavior — often byte-identical components re-skinned) but surfaced **3 genuine product gaps** where the BACKEND exists but no UI: Follow button un-wired (`/api/users/[handle]/follow` + `follows` table exist; an inline "no backend yet" comment was wrong), creator self-certify has no UI (`isCreatorSelfCert` branch exists), homework per-module add + file upload (R2 `uploadToR2` exists). Net-new features, not regressions.

**How to apply:** On any "test expects UI that isn't there" finding for a ported page, run the REDESIGN/REGRESSION/NEVER-EXISTED triage against the legacy source FIRST; only then decide test-edit vs page-restore vs gap-log. Builds on [[feedback_port_functionality_and_styling]] (re-skin-while-dropping-behavior = failed port) and [[feedback_read_legacy_source_before_conclusion]] (read both sides fully). Preflip ref: [[project_preflip_worktree_reference]]. PLATO terminology: [[plato-context]].
