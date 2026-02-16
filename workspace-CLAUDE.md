## Workspace Structure

> **Customize this section** to match your project layout.

```
your-workspace/
├── repo-a/         → your first repository
├── repo-b/         → your second repository
├── shared-libs/    → shared libraries (if any)
└── worktrees/      → git worktrees for feature branches
    ├── repo-a/
    └── repo-b/
```

## Branching & Worktree Workflow

**Never work directly on `main` or `dev`. Never push to `main` or `dev`.**

All feature work happens in worktrees:

1. **Create a feature branch from your base branch:**
   ```bash
   cd your-workspace/<repo>
   git fetch origin
   git worktree add ../worktrees/<repo>/<branch-name> -b <branch-name> origin/dev
   ```

2. **Work in the worktree** at `your-workspace/worktrees/<repo>/<branch-name>/`.

3. **Ship changes** using the `/ship` command when ready.

4. **After PR is merged**, clean up:
   ```bash
   git worktree remove your-workspace/worktrees/<repo>/<branch-name>
   git branch -d <branch-name>
   ```

## Cross-Repo Context

> **Customize this section** with your actual repos and their relationships.

When working in one repo, you often need context from others. Always read relevant code in other repos before making changes that cross boundaries.

## Development Commands

- `/ship` — format, lint, test, review, commit, push (runs autonomously)
- `/triage-ci` — triage CI results and bugbot comments after workflows complete
- `/start` — start a new feature branch with context loading
- `/cleanup` — clean up a merged feature branch and its worktree
- `/handoff` — save session context for the next conversation
- `/retro` — analyze PR feedback to improve /review calibration
- `/review` — code review for bugs, security, style, and maintainability

## Learning & Memory

After completing a non-trivial feature or debugging session, proactively update the relevant memory file in the auto memory directory. Focus on:
- **Gotchas** — things that broke unexpectedly or behaved non-obviously
- **Non-obvious patterns** — things hard to rediscover from just reading code
- **Decision context** — why something was built a certain way, especially when the obvious approach doesn't work
- **Test quirks** — what needs special setup, what's slow, what's flaky

Keep entries concise and actionable. Don't dump entire feature summaries — distill the 2-3 things that would save time next time.

Repo-specific lessons go in each repo's `.claude/lessons.md` (checked into git). Cross-repo patterns go in the auto memory directory.

### Lesson Confidence Levels

When writing lessons (in `.claude/lessons.md` or memory files), categorize by confidence:

- **Hard Rules** — violations caused real bugs or failures. Treat as mandatory. *"Never do X"*, *"Always do Y"*.
- **Proven Patterns** — worked reliably across 2+ instances. Default to following them. *"When doing X, use approach Y"*.
- **Observations** — noticed once or twice. Useful context, not yet proven. May be revised or promoted later.

Higher-confidence lessons override lower ones when they conflict. Promote observations to proven patterns after a second confirmation. Promote proven patterns to hard rules after a violation causes a real failure.

## Workflow Capture

When you complete a multi-step workflow that required significant reasoning and is likely reusable, save it as a recipe in the auto memory `workflows/` directory.

A workflow recipe must include:
- **When to use** — trigger conditions / problem shape
- **Steps** — concrete, ordered procedure (not vague guidance)
- **Pitfalls** — what went wrong or nearly went wrong
- **Example** — a real invocation from the session that produced it

### Workflow Lifecycle

1. **Draft** — saved to `memory/workflows/` after first successful execution
2. **Tested** — validated by a second successful use; refined based on experience
3. **Promoted** — moved to `.claude/commands/` as a slash command (`/user:<name>` global, `/project:<name>` repo-specific)

When a recipe has been used successfully 2+ times and is stable, promote it to a custom command. Promoted commands should be self-contained prompts that execute without re-deriving the approach.

**Do not capture trivial or one-off workflows.** Only capture workflows where the reasoning cost was significant and the pattern is likely to recur.

## Rule Refinement

After significant back-and-forth or a mistake during a feature, identify whether a CLAUDE.md rule was missing, misleading, or too vague. Propose a specific edit to the relevant CLAUDE.md file. Treat instructions like code — they should be debugged and refined based on real experience.
