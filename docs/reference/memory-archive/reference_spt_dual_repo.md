---
name: spt/spt-docs sibling dual-repo
description: spt/spt-docs is a sibling dual-repo at ~/projects/ that runs the same dual-repo Claude Code architecture as peerloop. Some r-* skill variants exist there but NOT in peerloop-docs.
type: reference
originSessionId: 31ca911f-5d4b-49e2-8629-fcb943aa0b59
---
`spt` and `spt-docs` are sibling dual-repos at `~/projects/spt/` and `~/projects/spt-docs/`. Same dual-repo Claude Code architecture as peerloop (docs repo + code repo, launched together via shell alias), but a separate project with its own evolution path.

**Skills present in spt-docs but NOT in peerloop-docs:**
- `r-end-soft`, `r-end-meta` — variants of `/r-end`
- `r-start-soft`, `r-start-meta` — variants of `/r-start`

When the user references any of these by name (e.g., "run r-end-soft"), they're talking about spt context, not peerloop. Do NOT search `peerloop-docs/.claude/skills/` for them — they will not be there.

**Other cross-project relationships:**
- Same-named skills (e.g., `r-end` exists in both projects) often diverge structurally beyond the point where porting is a simple merge — see `feedback_skill_sync_same_name_divergence.md`.
- `/w-sync-skills` is the tool for cross-project skill review.
- `feedback_conversational_brevity.md` originated in spt and was ported to peerloop Conv 150.

**[MSI] portability:** the cross-machine memory-sync pattern (Conv 154) is designed to port cleanly to spt-docs — same skill code shape, slug-derived live paths, in-repo mirror at `<project>/.claude/memory-sync/memories/`. User has flagged a follow-up task in spt-docs to adopt it.
