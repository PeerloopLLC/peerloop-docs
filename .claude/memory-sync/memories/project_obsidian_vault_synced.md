---
name: Obsidian vault is Obsidian-Sync replicated across machines
description: ~/Obsidian Vaults/main2025/ is replicated across M4 and M4Pro via Obsidian Sync — folder and file creation on one machine propagates automatically; no per-machine bootstrap needed for vault writes
type: project
originSessionId: f241a87e-731d-43f5-92c4-cef70fff2d59
---
The Obsidian vault at `~/Obsidian Vaults/main2025/` is replicated across M4 and M4Pro via Obsidian Sync. Folders and files created on one machine appear on the other automatically.

**Why:** Eliminates per-machine setup for cross-machine vault writes. When a skill or script creates a folder or writes a file on one machine, both the structure and content are available on the other without manual `mkdir`, rsync, scp, or git involvement. Surfaced Conv 157 during /r-timecard-day vault-write design — the user clarified that creating the timecards folder on M4 once would propagate to M4Pro on its own.

**How to apply:** When designing skills/scripts that write into the vault, do NOT plan for per-machine bootstrap. A first-run `mkdir -p` on one machine is sufficient; the second machine sees the folder via Obsidian Sync without any manual step. Tilde-prefixed paths in committed config still pull their weight — `~` expansion handles the per-machine `$HOME` difference (livingroom vs jamesfraser), while Obsidian Sync handles the per-machine content replication. The two mechanisms are orthogonal and stack cleanly.

Anti-pattern: writing skill instructions like "create the folder on each machine" or building per-machine setup steps into skill bootstrap. That's just friction — Obsidian Sync already does it.
