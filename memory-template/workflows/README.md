## Workflow Recipes

Reusable multi-step workflows saved after successful execution.
Each recipe captures a complex procedure so it can be replayed without re-deriving the approach.

### Recipe Format

```markdown
## <Workflow Name>

**When to use:** <trigger conditions / problem shape>

**Steps:**
1. ...
2. ...

**Pitfalls:**
- ...

**Example:** <real invocation that produced this recipe>

**Status:** draft | tested | promoted -> `/user:<cmd>` or `/project:<cmd>`
```

### Lifecycle

- **Draft** — saved here after first successful execution
- **Tested** — validated by a second use; refined
- **Promoted** — moved to `.claude/commands/` (global) or `<repo>/.claude/commands/` (repo-specific) as a slash command
