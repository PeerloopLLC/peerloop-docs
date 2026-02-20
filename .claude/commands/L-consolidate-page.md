# Consolidate Page Documentation

**Purpose:** Sync the JSON spec with the verified page documentation (XXXX.md), making the .md file the source of truth.

## Arguments

- `$ARGUMENTS` - The page code (e.g., HOME, CBRO, ASTC)

If no argument provided, ask the user which page to consolidate.

## Prerequisites

The page must have been verified via `/q-verify-page` first, meaning `docs/pages/{CODE}/{CODE}.md` exists with a "Verification Notes" section.

## Schema Reference

The JSON spec schema is defined in `../Peerloop/src/lib/types/page-spec.ts`. This TypeScript file with JSDoc comments is the canonical schema definition. Consult it for field types and documentation.

## Actions

### 1. Read Both Files

Read these files:
- `docs/pages/{CODE}/{CODE}.md` (source of truth)
- The JSON spec path from the .md file's metadata table

If either file is missing, report the error and stop.

### 2. Parse the .md File

Extract the following from the markdown:

**From Metadata Table:**
- title (from heading or metadata)
- code
- route
- astroFile
- access
- priority
- status

**From Purpose Section:**
- purpose (single string)

**From Connections Section:**
- connections.incoming (array of {source, sourceRoute, trigger, notes})
- connections.outgoing (array of {target, targetRoute, trigger, notes})

**From Data Requirements Section:**
- dataRequirements (array of {entity, fields_used, purpose})

**From Sections Section:**
- sections (array of {title, items[]})

**From User Stories Section:**
- userStories (array of story IDs like "US-A044")

**From States & Variations Section:**
- statesVariations (array of {state, description})

**From Mobile Considerations Section:**
- mobileConsiderations (array of strings)

**From Error Handling Section:**
- errorHandling (array of {error, display})

**From Analytics Events Section:**
- analyticsEvents (array of {event, trigger, data})

**From API Endpoints Section:**
- apiCalls (array of {endpoint, when, purpose})

**From Implementation Notes Section:**
- notes (array of strings)

**From Features Section (checkbox lists):**
- features (array of FeatureGroup)
  - Each group has optional `title` and `items[]`
  - Each item: `{description, implemented, storyRefs?, note?}`
  - Parse `- [x]` as implemented: true, `- [ ]` as implemented: false
  - Extract story refs from `[US-XXXX]` patterns

**From Interactive Elements Section:**
- interactiveElements.buttons (array of `{element, component, action, status}`)
- interactiveElements.links (array of link groups with `{section, items[]}`)
- interactiveElements.targetPages (array of `{target, pageCode?, implemented}`)
- interactiveElements.summary (button/link/analytics counts)

**From Verification Notes Section:**
- verificationNotes.verifiedDate
- verificationNotes.consolidatedDate (set to today when running this skill)
- verificationNotes.components (array of `{component, file, status, todoCount?}`)
- verificationNotes.screenshots (array of `{file, date, description}`)
- verificationNotes.notes (array of strings)

### 3. Identify Discrepancies

Compare the current JSON spec with the parsed .md data.

**For each field, categorize as:**
- **Match** - JSON and .md agree
- **Updated** - .md has newer/different value (update JSON)
- **Removed** - In JSON but not in .md (move to discrepancies)
- **Added** - In .md but not in JSON (add to JSON)

### 4. Update the JSON Spec

Create a new JSON structure that:
1. Uses values from the .md file (source of truth)
2. Preserves the original JSON schema structure
3. Adds a new `_discrepancies` section at the bottom for removed/unimplemented items

**Structure of `_discrepancies` section:**
```json
{
  "_discrepancies": {
    "asOf": "2026-01-08",
    "plannedButNotImplemented": [
      {
        "feature": "Date filter",
        "originalSpec": "Certification date range filter",
        "status": "Not implemented",
        "priority": "Low"
      }
    ],
    "implementedDifferently": [
      {
        "feature": "Approved By column",
        "originalSpec": "In table",
        "reality": "In detail panel only",
        "note": "Acceptable - cleaner table"
      }
    ],
    "removedFromSpec": [
      {
        "feature": "Reassign ST",
        "reason": "Feature not needed for this page"
      }
    ]
  }
}
```

### 5. Write Updated JSON

Write the updated JSON spec file with:
- All fields synced from .md
- `_discrepancies` section at the end
- Proper formatting (2-space indent)

### 6. Update .md File (if needed)

If the JSON spec path in the .md metadata table was wrong, update it.

**Update the consolidation note** in the Verification Notes section:
- If a `**Consolidated:**` line already exists, **replace it** (don't append)
- If no consolidation note exists, add it after the verification date

```markdown
**Consolidated:** {YYYY-MM-DD}
- JSON spec updated to match verified implementation
- {N} discrepancies documented in JSON `_discrepancies` section
```

This ensures running `/q-consolidate-page` multiple times doesn't accumulate duplicate notes.

### 7. Summary

Present final summary:

```
Consolidation Complete: {CODE}
─────────────────────────────

JSON Spec: {path}
Page Doc: docs/pages/{CODE}/{CODE}.md

Changes Made:
- Updated: {list of updated fields}
- Added: {list of added fields}
- Discrepancies documented: {count}

Discrepancies:
- Planned but not implemented: {count}
- Implemented differently: {count}
- Removed from spec: {count}

Files Modified:
- {JSON spec path}
- docs/pages/{CODE}/{CODE}.md (consolidation note added)
```

### 8. Validate JSON Spec

Run the validation script to ensure the JSON conforms to the TypeScript schema:

```bash
cd ../Peerloop && npx tsx scripts/validate-page-spec.ts {JSON spec path}
```

**If validation fails:**
- Review the error message
- Fix the JSON structure
- Re-run validation until it passes

**If validation passes:**
- Report success in the summary

This catches issues like:
- Missing required fields
- Wrong enum values (e.g., `status: "working"` instead of `"active"`)
- Malformed nested structures

## Field Mapping Reference

| .md Section | JSON Field |
|-------------|------------|
| Metadata table: Route | metadata.route |
| Metadata table: Access | metadata.access |
| Metadata table: Priority | metadata.priority |
| Metadata table: Status | metadata.status |
| Metadata table: Astro Page | metadata.astroFile |
| Metadata table: Block | metadata.block |
| Metadata table: Component | metadata.component |
| Metadata table: Layout | metadata.layout |
| Purpose | purpose |
| Connections > Incoming | connections.incoming |
| Connections > Outgoing | connections.outgoing |
| Data Requirements | dataRequirements |
| Features (checkbox list) | features |
| Sections | sections |
| User Stories | userStories |
| API Endpoints | apiCalls |
| States & Variations | statesVariations |
| Error Handling | errorHandling |
| Mobile Considerations | mobileConsiderations |
| Analytics Events | analyticsEvents |
| Implementation Notes | notes |
| Interactive Elements > Buttons | interactiveElements.buttons |
| Interactive Elements > Links | interactiveElements.links |
| Interactive Elements > Target Pages | interactiveElements.targetPages |
| Interactive Elements > Summary | interactiveElements.summary |
| Verification Notes (all) | verificationNotes |
| Verification Notes > Discrepancies | _discrepancies |

## Notes

- The .md file is ALWAYS the source of truth after verification
- The JSON spec should reflect what IS implemented, not what was planned
- Planned-but-unimplemented features go in `_discrepancies`
- Run this after every `/q-verify-page` to keep specs in sync
- If the schema needs new fields, update `../Peerloop/src/lib/types/page-spec.ts`
