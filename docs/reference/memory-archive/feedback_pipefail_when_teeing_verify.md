# Never let `tee`/`tail` mask a verify/test/build exit code

**Trigger:** any time CC pipes a gate command (`npm run verify`, `npm test`, `npm run build`, `codecheck`) through `| tee <file> | tail -N` (or any pipeline) to capture output while watching a summary.

**Rule:** the exit status of a shell pipeline is the exit status of its **last** command. `npm run verify 2>&1 | tee out.txt | tail -6` therefore returns **`tail`'s** exit (always 0), completely hiding a failing verify. Do one of:

1. **`set -o pipefail`** before the pipeline (works in bash *and* zsh), then read `$?` after it — with pipefail the pipeline reports the first non-zero stage. This is what the [TBK] Conv 443 re-run used:
   ```bash
   cd ~/projects/Peerloop && set -o pipefail && npm run verify 2>&1 | tee out.txt | tail -6; echo "VERIFY_EXIT=$?"
   ```
2. **Don't pipe at all** — redirect to the file, then inspect separately:
   ```bash
   npm run verify > out.txt 2>&1; echo "exit=$?"   # then grep/Read the file
   ```

**Never** treat a background-command "exit code 0" as a green baseline when the command was `… | tee | tail`. Confirm from the captured output's own `Test Files … passed` / `built in …` lines, not just `$?`.

## Incident — Conv 443 [TBK]

Ran `npm run verify 2>&1 | tee verify-out.txt | tail -5 &` (background). The task-completion notification reported **"exit code 0"**, which I initially read as a passing baseline. The captured file actually showed **6 failed tests** (`CommunityCatalogCard` ×4, `CommunityAffiliation` ×2) and `npm run build` never ran (the `&&` chain stopped at `npm test`). The `0` was `tail`'s exit, not verify's. Caught only because I read the file's own `Test Files 2 failed | 411 passed` line rather than trusting `$?`. User then asked this be recorded as a durable fix. (The 6 failures were separately stale tests from the same-conv `[CAS]`/`[COMM-BADGE-STRADDLE]` commits, which had been landed on **codecheck-only** — see [[feedback_codecheck_moment_includes_tests_and_build]] — so a full-suite run hadn't happened since.)
