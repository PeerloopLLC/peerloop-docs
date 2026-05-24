---
name: project-module-submodule-model
description: "Peerloop domain — Session↔Module is 1:1; Matt's & creators' nested \"Modules\" are really Sub-Modules"
metadata: 
  node_type: memory
  type: project
  originSessionId: bdcd271a-9807-49e7-8a7c-2b9c1e854337
---

# Module / Sub-Module domain model

**Every Session has exactly ONE Module. Session↔Module is 1:1.** The purpose of a video session is to go over the one Module of learning the Creator laid out for that session.

What Matt's designs (and some Creators' raw inputs) label as "N Modules" *within* a session are actually **Sub-Modules** — subdivisions of the single module. One Creator subdivided his Module into multiple sections and handed them to Matt as separate "Modules"; that subdivision is a misuse of the term, and the subdivision still happens inside the one session.

**Interpretation rule:** wherever Matt or a Creator says "Module" in a nested/within-session sense (e.g. the Modules tab's "4 Modules" sub-count), read it as **Sub-Module**.

**Why:** Conv 188 [MOD-SCHEMA] — probing Matt's Modules tab (`497:12795`) showed sessions containing multiple "Modules", which conflicted with the 1:1 session-module design. User clarified the real model and the relabeling.

**How to apply:** When building the Modules tab (`[MODTAB]`) or any session/curriculum surface, treat session = module (1:1) and Matt's inner "Modules" as Sub-Modules. Do NOT introduce a session→multiple-modules data model. The session-level unit is the Module; the inner list is Sub-Modules. Resolves the [MOD-SCHEMA] data-grouping question without a schema change to group modules under sessions. See [[feedback-routing-addressability-first]] and the Matt drift lookup row 4. Verify how `course_curriculum` / `lesson_count` map to Sub-Modules before building.
