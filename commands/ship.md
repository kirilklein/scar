---
description: Format, lint, test, review, commit and push changes
---

Execute the full pre-push workflow autonomously. Run each step sequentially. Fix issues inline before proceeding to the next step. Do NOT ask for confirmation or permission between steps — just execute every step including skill invocations.

## Steps

1. **Understand changes**: Run `git status` and `git diff` to see what changed. Identify the changed source files.

2. **Verify branch**: Confirm you are NOT on `main` or `dev`. If you are, STOP and tell the user to switch to a feature branch worktree.

3. **Format**: Run your project's formatter on all changed files. Stage any formatting changes.

4. **Lint**: Run your project's linter on changed files. Fix any issues found, then re-run to confirm.

5. **Test**: Run relevant tests locally before pushing. This catches failures early and avoids slow CI round-trips.
   - Read the project's `CLAUDE.md` (or `.claude/CLAUDE.md`) for a **test mapping** section that maps source directories to test commands.
   - If a test mapping exists, use it to determine which test suites to run based on the changed files.
   - If no test mapping exists, identify and run the relevant unit tests based on directory structure (e.g., changes in `foo/` -> run `tests/test_foo/`).
   - **Do not run the entire test suite** — only tests related to the changes.
   - Fix any failures before proceeding.

6. **Review**: Immediately invoke the `/review` skill on the changed files — do NOT ask for permission, just run it. If it reports issues, fix them and re-run steps 3-5.

7. **Commit**: Stage all changes and create a descriptive commit following the repository's existing commit message style (check `git log --oneline -10`).

8. **Push**: Push to the current feature branch.

If any step fails, fix the issue and retry from that step. Run the full pipeline without pausing for approval.

## Workflow gap tracking

If step 6 (review) finds issues that steps 3-5 should have caught, or if tests fail on something review didn't flag, note the gap in the auto memory `workflow-gaps.md` file. Format:
```
- [date] /ship step N missed [what]: [brief description] — caught by step M instead
```
Keep entries terse. These accumulate and are reviewed periodically to tighten the pipeline.
