---
name: Balance infrastructure patterns with immediate deliverables
description: When building test infrastructure, user prioritizes reusable patterns alongside the immediate task — always consider both goals
type: feedback
---

When building test infrastructure (PLATO snapshots, scenarios, etc.), the user's primary goal is establishing a **repeatable pattern**, not just completing the immediate task. The task (e.g., flywheel checkpoints) is the first test case of the pattern.

**Why:** User explicitly noted (Conv 073): "I am foremost thinking of this as one instance of a process I will want to use elsewhere... why you are focused on getting the flywheel as a task done." The tension was productive but worth being aware of.

**How to apply:** When building infrastructure, pause periodically to check: "Is this approach generalizable, or am I special-casing for the immediate task?" Surface the dual goal early. The user decides what to prioritize, but both goals should be visible.
