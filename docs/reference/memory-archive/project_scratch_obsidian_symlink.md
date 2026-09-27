---
name: project_scratch_obsidian_symlink
description: "scratch workspace = real _scratch/ dir + .scratch compat symlink (for Obsidian visibility); do NOT \"clean up\" the symlink"
metadata: 
  node_type: memory
  type: project
  originSessionId: 84b07462-5721-459c-be70-c5b214077381
---

**Conv 300:** the scratch workspace is now **`_scratch/` = the REAL gitignored directory**, and **`.scratch` = a symlink → `_scratch`** (compat alias). Both are gitignored (`.gitignore`: `.scratch` no-slash for the symlink, `_scratch/` for the real dir). Every skill/memory/doc still references `.scratch/…` and resolves transparently through the symlink — the ~46 references were NOT rewritten.

**Why:** peerloop-docs IS itself an Obsidian vault (vault root = repo root, has `.obsidian/`). Obsidian **resolves a symlink to its real path and then hides dot-targets** — so a `.scratch` real dir, OR a `_scratch → .scratch` symlink, is invisible in Obsidian. The *visible* folder must be a **real, non-dot directory**; hence `_scratch/` is real and `.scratch` is the dot-named alias.

**How to apply:**
- **Do NOT delete the `.scratch` symlink** as "stale" — it's load-bearing for all `.scratch/` references.
- **Do NOT flip it back** or rename `_scratch` to a dot-name — that re-breaks Obsidian visibility.
- **Machine-local** (both gitignored, never synced via git). On a fresh machine the scratch dir starts as a real `.scratch`; redo the flip once: `cd ~/projects/peerloop-docs && mv .scratch _scratch && ln -s _scratch .scratch`.
- Lesson: a symlink whose real target is a dotfolder will NOT surface in Obsidian — the resolved path's leading dot wins over the visible name. Related: [[project_obsidian_vault_synced]].
