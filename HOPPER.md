# HOPPER — Peerloop

**Spin-off findings captured mid-work.** Something surfaced while doing something else and I'm not stopping to do it — it lands here, immediately, without asking. This file is the signal that spin-offs are accumulating: keep it open and the list is live. (Ported from fps, Conv 457.)

> **The hopper vs. the board.** This file is **convenience capture subject to your scrutiny, not a commitment**. `CURRENT-TASKS.md` is the durable board, and a hopper item has to **earn** a row there — significant work, or multi-conv. Most items are dealt with in the same conv and never become rows.
>
> **Items are dealt with *before* `/r-end`, not at it** — run **`/r-hopper`** to walk the open items and rule each (promote to a `CURRENT-TASKS.md` row · do it now · drop). Working through them mid-conv is the norm; `/r-end` does **not** rule — its Step 0.8 gate **bounces the close** if any open item remains (Conv 457). **Never ruled alone** (CLAUDE.md §Investigative Framings / §User-Facing Questions).
>
> 🔴 **Tracked in git** (docs-repo root, like `CURRENT-TASKS.md`). It survives a session death mid-conv and is backed up on push — losing spin-offs with the session is the failure mode this avoids.

**Capture format** — one line, enough that a future reader knows what was meant without the conversation:

```
- [ ] **Conv NNN** — <subject>
```

Nest detail as an indented sub-bullet when the subject alone won't survive the week. 🔴 **Dealing with an item and clearing it are one act:** when `/r-hopper` rules an item, its line is **deleted immediately** — a promoted item becomes a `CURRENT-TASKS.md` row *first*, then the line goes. `/r-hopper` never *creates* a `- [x]` tick. **If you complete an item outside `/r-hopper`** (ticking it off by hand), a `- [x]` row sits here until the next `/r-hopper`, which disposes of it (batch-confirm). Steady state: the hopper holds only genuinely-open `- [ ]` items; the durable record of what was dealt with is the conv Extract + the board.

---

## Open

_None._
