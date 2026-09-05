---
description: Audit lessons.md and review-calibration.md — promote, demote, or retire stale entries
---

Maintain `.claude/lessons.md` and `.claude/review-calibration.md` so they stay small, current, and trustworthy. Memory tools capture; this command calibrates.

The ladder: **Observation** (noticed once) → **Proven Pattern** (confirmed 2+ times) → **Hard Rule** (a violation caused a real failure). Higher levels override lower ones on conflict.

## Steps

1. **Read** `.claude/lessons.md`. If missing, offer to create it from the plugin's `templates/lessons.md` and stop.

2. **Verify each entry still holds**: if it names a file, function, flag, or command, check it still exists in the repo. Entries about deleted code get retired (removed, with a one-line note in the report).

3. **Promote**:
   - An **Observation** confirmed again since it was written (evidence in recent git history, PR comments, or gap log) → move to **Proven Patterns**, noting both confirmations.
   - A **Proven Pattern** whose violation caused a real failure (a bug, a reverted commit, a CI incident) → move to **Hard Rules**, citing the failure.
   Promote only with evidence you can point to. When it's ambiguous, ask the user rather than guessing.

4. **Demote or retire**:
   - A pattern contradicted by how the code actually works now → demote one level or retire.
   - Duplicates → merge into the highest-confidence copy.

5. **Audit calibration**: read `.claude/review-calibration.md` (skip if missing). For each entry:
   - Names a file, function, flag, or pattern that no longer exists in the repo → retire.
   - Describes a check that a linter, type checker, or test now performs → retire, noting what covers it.
   - Duplicates or overlaps another entry → merge into the more specific one.
   Entries carry a date (`learned from PR #NNN, YYYY-MM-DD`). Age alone is not a reason to retire; an old entry about live code stays.

6. **Report**: a short table of moves (entry, from → to, evidence) and retired calibration entries with the reason. If nothing moved, say both files are current.

$ARGUMENTS
