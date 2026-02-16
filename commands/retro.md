---
description: Analyze PR feedback to improve /review calibration
---

Learn from human reviewer feedback on the current PR. This closes the loop: what did human reviewers catch that `/review` missed?

## Steps

1. **Find the PR**: Run `gh pr view --json number,url,headRefName` to get the PR for the current branch.

2. **Fetch all review feedback**: Collect human review comments (not bugbot/automated):
   - `gh pr view --json reviews,comments` for top-level comments
   - `gh api repos/{owner}/{repo}/pulls/{pr_number}/comments` for inline comments
   Filter out automated comments (bugbot, coverage bots, CI).

3. **Categorize each human comment**:
   - **Bug/logic issue**: reviewer spotted a real bug or logic flaw
   - **Design/architecture**: reviewer questioned an approach or suggested a different design
   - **Missing edge case**: reviewer identified an unhandled scenario
   - **Convention/style**: reviewer flagged a project convention violation
   - **Clarification**: reviewer asked a question (not necessarily an issue)

4. **Identify review gaps**: For each bug, edge case, or convention comment — could `/review` have caught this? If yes:
   - What category does it fall under? (bugs, security, performance, style, maintainability, decision points)
   - What pattern should `/review` look for next time?
   - Write a concise rule for `review-calibration.md`

5. **Update calibration file**: If there are actionable patterns, read `.claude/review-calibration.md` (create if it doesn't exist) and append new entries. Format:
   ```
   ## [Category]
   - [Pattern to watch for] — learned from PR #NNN
   ```
   Do NOT add vague entries. Each must be specific enough to act on during review.

6. **Update lessons if needed**: If any comment revealed a codebase gotcha (not a review gap), add it to `.claude/lessons.md` instead.

7. **Summary**: Report what was learned and what was added to calibration/lessons.

$ARGUMENTS
