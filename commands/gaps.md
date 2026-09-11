---
description: Review accumulated pipeline gaps and close them by root cause
---

Turn the gap log into pipeline improvements. Run this every week or two, or when `.claude/workflow-gaps.md` has 5+ entries.

## Steps

1. **Read** `.claude/workflow-gaps.md`. If empty or missing, report that no gaps are recorded and stop.

2. **Leak table**: count unresolved entries per `<should-have> → <caught-by>` pair and print them, largest first:

   ```
   review → bot-review     6
   test   → review         4
   review → human-review   2
   ```

   The top row is where the pipeline leaks most; say so in one line. If a should-have stage never appears as a caught-by, it is probably not run at all; say that too.

3. **Cluster** entries by root cause, not by layer. Examples: "lint config doesn't cover async rules", "tests only run for the changed directory, not callers", "review only reads changed files".

4. **Propose one fix per cluster**, preferring the cheapest layer that closes it:
   - running the should-have stage at all, when it is missing (a local review before push, a type checker, a test step)
   - a linter/formatter/type-checker config change (closes the gap mechanically — best of the rest)
   - a change to which tests run and when, recorded in the project `CLAUDE.md` (for example, run the callers' tests too)
   - a calibration entry in `.claude/review-calibration.md`
   - a lessons entry (last resort — relies on being remembered)

5. **Apply** fixes the user approves. For config changes, show the diff first.

6. **Prune the log**: move addressed entries under `## Resolved` with a one-line note of what fixed them. Leave unresolved ones in place.

7. **Report**: leak table, clusters found, fixes applied, gaps remaining.

$ARGUMENTS
