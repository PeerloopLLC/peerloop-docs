---
name: Same-name skill divergence — prefer independent evolution over cross-project porting
description: When /w-sync-skills finds significant structural divergence in same-named skills across dual-repo projects, recommend independent evolution rather than walking through HARD RULES / philosophy merge discussions
type: feedback
originSessionId: c5890b2c-8633-4a3e-b26f-828bbb7885c0
---
Same-named skills (e.g., `r-end` existing in both `peerloop-docs` and `spt-docs`) often diverge beyond the point where "porting" is a simple merge. When `/w-sync-skills` finds this pattern, default recommendation is **evolve independently**, not "let's discuss which HARD RULES / behavioral deltas to port."

**Why:** Conv 140 — attempted to port `r-end` HARD RULES from `spt-docs` → `peerloop-docs`. The diffs revealed that the two skills encode **different PLAN.md philosophies**:
- LOCAL (peerloop-docs): ACTIVE/ON-HOLD/DEFERRED table + strip-on-complete + `(Conv NNN)` attributions scattered through Follow-ups sections
- SOURCE (spt-docs): inline 🔥 emoji markers + checkoff-in-place + no `(Conv NNN)` attributions anywhere in PLAN.md

Plus LOCAL-only customizations had accumulated: promoted shared scripts (`sync-gaps.sh`, `tech-doc-sweep.sh` moved to `.claude/scripts/`), `advance-drift-baseline.sh` integration, API Route Mapping table, CLI Detail Files table, richer Peerloop-specific change detection matrix, 10 vs 7 checklists.

User concluded: *"the ability to port skills is becoming too complex a process. There are a great many differences in these r-end associated files. So much so that porting is problematic. So I am going to evolve the same-named skills independently."*

**How to apply:**
- In `/w-sync-skills` Step 3: if an exact-match skill has >~30% structural divergence after normalization (new sections, missing sections, different philosophies — not just extra rows), report it as "DIVERGED — recommend independent evolution" and do NOT walk through HARD-RULES-style merge discussion unless user explicitly asks.
- Source-only skills (Step 4) remain fair game — they have no LOCAL counterpart to conflict with.
- Source→LOCAL mechanical fixes (e.g., small bug fixes, new verification lines in output schemas) are still portable — but require the LOCAL skill to be otherwise in-sync.
- When in doubt, show the diff first and ask before drafting a port plan.
