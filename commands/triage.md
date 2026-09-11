---
description: Triage CI failures and PR comments, logging each miss as a gap before fixing it
---

Read what CI, review bots, and human reviewers found on the current PR, log each real miss with `/gap`, then fix. This is where post-push gaps get recorded; `/review` records pre-push ones.

## Steps

1. **Find the PR**: `gh pr view --json number,url,headRefName,baseRefName`. If `$ARGUMENTS` names a PR number, use that instead. Stop if there is no PR.

2. **Gather**:
   - `gh pr checks <pr>` — if any check is still running, say so and stop; triage a complete snapshot.
   - For each failing check: `gh run view <run-id> --log-failed | tail -80`.
   - `gh api repos/{owner}/{repo}/pulls/<pr>/comments` (inline) and `gh pr view <pr> --json reviews,comments` (top-level). `user.type == "Bot"` marks a bot; everything else is human.
   - `gh run list --branch <base> --limit 5` — if the base branch fails the same way, that failure is not yours. Say so and skip it.

3. **Judge each item**: read the code it points at. A comment written against an earlier commit may already be fixed. Decide real or false positive. Reply to false positives with a short reason via `gh api`; do not log them.

4. **Log gaps before fixing**. For each real item, name the earliest stage that could have caught it and append one line to `.claude/workflow-gaps.md` in `/gap` format:

   ```
   - [YYYY-MM-DD] <should-have> → <caught-by>: <what slipped through, one line>
   ```

   `caught-by` is `ci` for a failing check, `bot-review` for a bot comment, `human-review` for a person. Typical should-haves: a test that fails in CI but not locally is `test`; a bug in the diff a reviewer found is `review`; a lint or type error is `lint` or `types`. The should-have stage counts even if you do not run it; `/gaps` will say whether it is worth adding.

5. **Fix** the real items. Re-run your format, lint, and test steps and push to the same branch.

6. **Report**: items found, false positives dismissed, gaps logged, what was fixed. If the unresolved gap count is 5 or more, mention `/gaps`.

$ARGUMENTS
