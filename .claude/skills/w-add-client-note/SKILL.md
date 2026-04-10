---
name: w-add-client-note
description: Process client notes and create RFC with actionable checklist
argument-hint: "(paste note in conversation)"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Process Client Note → RFC

Process a client note/directive, analyze implied changes, and create an RFC folder with actionable checklist.

---

## Phase 1: Analysis

1. **Receive the note** — User pastes the client note in the conversation

2. **Analyze the note** for the following categories:
   - **UI/Layout Changes** — Display patterns, responsive behavior, navigation
   - **Business Model Changes** — Pricing, revenue splits, fees, subscriptions
   - **Terminology Changes** — Naming conventions, copy updates, SEO keywords
   - **Feature Changes** — New features, removed features, modified behavior
   - **Data Model Changes** — New fields, tables, relationships
   - **Clarifications** — Existing features that need documentation updates

3. **For each change identified, determine affected files:**
   - **Routes** — Check `docs/as-designed/url-routing.md` for affected routes
   - **Components** — Check `docs/reference/_COMPONENTS.md` for UI components
   - **User Stories** — Check `docs/requirements/USER-STORIES.md` and `docs/requirements/stories/` for related stories
   - **Database** — Check `../Peerloop/migrations/0001_schema.sql` and `docs/reference/DB-GUIDE.md`
   - **Policies** — Check `docs/POLICIES.md` for access control / business rule impacts

4. **Group changes by category** and present as a table:

   ```markdown
   ### Group N: [Category Name]

   **Core Change:** [One sentence summary]

   | Category | Item | Current State | Required Change |
   |----------|------|---------------|-----------------|
   | Routes | /path | Current behavior | New behavior |
   | Components | ComponentName | Current state | New state |
   | Docs | filename.md | Current content | Update needed |
   ```

5. **Identify new user stories** implied by the changes
6. **Generate questions for the client** about ambiguities
7. **Summarize by priority**

---

## Phase 2: RFC Creation (After User Approval)

When user confirms they want to create the RFC:

1. **Get next CD number** from `docs/requirements/rfc/INDEX.md` (highest existing CD number + 1, or CD-001 if none exist)

2. **Create RFC folder structure:**
   ```
   docs/requirements/rfc/CD-XXX/
   ├── original.txt   # Raw pasted text (or original.[ext] if file)
   ├── CD-XXX.md      # Formatted source document
   └── RFC.md         # Actionable checklist
   ```

3. **Save original input:**
   - If pasted text → save as `original.txt`
   - If uploaded file → save as `original.[ext]` (pdf, docx, etc.)

4. **Create CD-XXX.md** — The formatted source document containing:
   - Date, source, type
   - Purpose section
   - Decision sections (one per major change)
   - Client's quotes where applicable
   - Implied goals
   - Implied user stories
   - Technical implementation notes
   - Open questions
   - **Comments section** (for dated client feedback)

5. **Create RFC.md** — The actionable checklist containing:
   - Header with source link, date, status, client
   - Summary
   - Change requests with checkbox items grouped by category
   - Open questions table
   - Implementation priority table
   - Completion tracking stats

6. **Update docs/requirements/rfc/INDEX.md** lookup table with new entry

---

## RFC.md Template

```markdown
# RFC: CD-XXX - [Title]

**Source:** [CD-XXX.md](./CD-XXX.md)
**Date:** YYYY-MM-DD
**Status:** Open
**Client:** [Name]

---

## Summary
[2-3 sentence description]

---

## Change Requests

### 1. [Category Name] ([Type])

**Core Change:** [One sentence]

#### [Subcategory]
- [ ] Item with specific file/component
- [ ] Another item

---

## Open Questions for [Client]

| # | Question | Status | Answer |
|---|----------|--------|--------|
| 1 | Question text | Open | |

---

## Implementation Priority

| Priority | Item | Effort |
|----------|------|--------|
| High | ... | Low/Medium/High |

---

## Completion Tracking

- **Total Items:** X
- **Completed:** 0
- **Remaining:** X
- **Last Updated:** YYYY-MM-DD
```

---

## Reference Files

- `docs/requirements/rfc/INDEX.md` — RFC lookup table and status
- `docs/as-designed/url-routing.md` — Route definitions
- `docs/reference/_COMPONENTS.md` — UI component library
- `docs/requirements/USER-STORIES.md` — User story index
- `../Peerloop/migrations/0001_schema.sql` — Database schema (source of truth)
- `docs/reference/DB-GUIDE.md` — Database design rationale
- `docs/POLICIES.md` — Platform behavior policies

---

## Example Usage

```
User: /w-add-client-note
User: [pastes client note]

Claude: ## Analysis of Client Note

[Grouped analysis tables]
[Questions for client]
[Priority summary]

Would you like me to create an RFC for this? (Creates docs/requirements/rfc/CD-XXX/ folder)

User: Yes

Claude: Created:
- docs/requirements/rfc/CD-XXX/CD-XXX.md (source document)
- docs/requirements/rfc/CD-XXX/RFC.md (actionable checklist with 15 items)
- Updated docs/requirements/rfc/INDEX.md
```
