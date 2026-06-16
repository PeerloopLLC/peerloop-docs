---
name: project_jfg_dev_branches_are_snapshots
description: The many jfg-dev-NN code branches are intentional point-in-time SNAPSHOTS — do NOT propose deleting them as stale
metadata: 
  node_type: memory
  type: project
  originSessionId: 7a4d174a-0668-449c-bcd6-ab03ed4c0dcb
---

The code repo (`~/projects/Peerloop`) carries many `jfg-dev-NN` branches (jfg-dev-2 … jfg-dev-14, plus variants like `jfg-dev-13-matt`). **These are intentional point-in-time snapshots of the code**, kept on purpose — NOT stale/abandoned branches to clean up (user, Conv 292).

**Why:** they're a lightweight history of milestones; the user relies on being able to look back at a branch's state.

**How to apply:** never propose `git branch -d`/`--delete` sweeps of `jfg-dev-*` branches as "cleanup," and don't flag duplicate/ancestor branches (e.g. jfg-dev-13-matt == jfg-dev-14 tip after a ff) as deletable. Conv 292 created then deleted a `[DEV13-RM]` task on this exact mistaken assumption. The *active* working branch is the current checkout (Conv 292: `jfg-dev-14`); older jfg-dev-NN are reference snapshots. Relates to [[feedback_git_dash_c_enforcement]].
