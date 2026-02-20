---
description: Project-specific code checks
---

# Local Code Checks

Project-specific checks called by global `/q-codecheck`.

## Checks

1. **Astro**: `cd ../Peerloop && npx astro check`

## Execution

Run based on argument received from global:

- **(none)** or **smart**: Run check, return results
- **fix**: Astro check is read-only (no auto-fix available), just report
- **clear**: No action needed (global handles todo cleanup)

## Smart Mode

If `smart` argument, only run if relevant files changed:
- `*.astro` files
- `astro.config.*` files

Otherwise SKIP.

## Return Format

```
Local Check: Astro
Status: [PASS/FAIL/SKIP]
Errors: [count or 0]
```

## Notes

- `astro check` validates `.astro` component syntax and TypeScript in frontmatter
- Errors here often overlap with TypeScript errors but can catch Astro-specific issues
- No auto-fix available for Astro check
