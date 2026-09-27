---
name: Check memory before re-answering "do you have this directive?" questions
description: Before offering to save a directive the user is asking about, grep auto-memory for existing entries on the same topic
type: feedback
originSessionId: a0806615-5507-4a6f-a998-ef32e7e417c1
---
When the user asks "do you have this directive?" or "do you remember that I want X?" or any variant of "is this saved?", **check the auto-memory directory first** before offering to save it.

`~/.claude/projects/-Users-<user>-projects-peerloop-docs/memory/` — where `<user>` is your macOS username (the username appears explicitly in the segment because Claude encodes the absolute project path into the directory name, replacing `/` with `-`). Grep the filenames and, if promising, read the contents. Match on topic, not exact wording.

**Why:** In Conv 098 the user asked about the same directive twice and Claude offered to save it both times without noticing the first save already existed. This wasted the user's time and created an implied concern that memory isn't reliable. The memory system only works if Claude actually consults it before writing new entries.

**How to apply:** Any time the user's question implies "is this already captured?" — MEMORY.md is always in context so scan it first, then if nothing matches, grep the memory directory by keyword before deciding to save. If a matching entry exists, say so ("yes — saved in {file} as: …") instead of re-offering to save. If the existing entry is stale or incomplete, update it rather than creating a duplicate.
