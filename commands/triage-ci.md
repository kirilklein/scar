---
description: Triage CI results and bugbot comments on the current PR
---

Triage CI and automated review results for the current branch's PR.

## Steps

1. **Find the PR**: Run `gh pr view --json number,url,headRefName` to get the PR for the current branch.

2. **Check CI status**: Run `gh pr checks` to see workflow results. If workflows are still running, report that and stop.

3. **Fetch review comments**: Run `gh api repos/{owner}/{repo}/pulls/{pr_number}/comments` to get all review comments. Also check `gh pr view --json reviews,comments` for general PR comments.

4. **Triage each automated comment** (bugbot, linters, etc.):
   - Read the flagged code and understand the concern.
   - Assess: is this a **real issue** or a **false positive**?
   - If **real issue**: fix the code.
   - If **false positive**: reply to the comment with a brief explanation of why it's not applicable using `gh api` to post a reply.

5. **Handle CI failures**: If any workflow failed, read the logs with `gh run view --log-failed` and fix the underlying issues.

6. **Re-ship if needed**: If any code fixes were made, run the /ship workflow to format, lint, test, commit, and push.

7. **Lessons check**: After resolving all issues, review whether any failure was **non-obvious** — something that wasn't caught by local tests, or that revealed a surprising dependency, edge case, or environment difference. If so, append a concise entry to `.claude/lessons.md` (or the auto memory if cross-repo) describing:
   - What failed and why it wasn't caught earlier
   - What to watch for next time
   Do NOT add routine failures (typos, lint, missing imports). Only add things that would genuinely save time if encountered again.

Be concise in comment replies. Only dismiss comments you are confident are false positives.
