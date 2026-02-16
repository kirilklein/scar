---
description: Review code for bugs, security, style, and maintainability (follow CLAUDE.md)
allowed-tools: Read, Grep, Glob
---

You are doing a focused code review.

First, **read `CLAUDE.md`** (and any linked/contributor docs it references) and **follow its instructions exactly**. If any instruction conflicts with this prompt, **CLAUDE.md wins**.

Also check for `.claude/review-calibration.md`. If it exists, read it and apply its patterns alongside the standard checks. These are learned patterns from previous human review feedback.

Then review the target(s) provided in **$ARGUMENTS** (files, directories, or globs). If $ARGUMENTS is empty, review the most relevant changed/mentioned files you can find, otherwise ask for the intended target.

## What to look for (prioritize substantive issues)
1. **Bugs & logic errors**: incorrect logic, edge cases, error handling, data validation, race conditions, off-by-one, etc.
2. **Security**: injection risks, authz/authn mistakes, unsafe deserialization, path traversal, SSRF, hardcoded secrets, insecure defaults.
3. **Performance**: obvious hotspots, unnecessary I/O, quadratic loops, repeated work, missing streaming/batching.
4. **Style & conventions**: PEP 8, typing, docstrings, project patterns (per CLAUDE.md).
5. **Maintainability**: clarity, structure, duplication, naming, testability.

## How to work (tools)
- Use **Glob** to find files and **Grep** to locate usages/patterns.
- Use **Read** to inspect relevant files and surrounding context.
- Don't suggest broad rewrites unless clearly justified.

## Output format
- Start with a **1-3 sentence summary** of overall risk/quality.
- Then list issues as bullets, **highest severity first**.

For each issue include:
- **Severity**: Critical / High / Medium / Low
- **Location**: `path:line` (or nearest function/class if line numbers aren't available)
- **Problem**: what's wrong + why it matters
- **Fix**: concrete recommendation (include a small code snippet only if it clarifies the fix)

Keep it concise: focus on the most important findings, avoid nitpicks.

## Decision points (requires human judgment)

After listing issues, add a **"Decisions to verify"** section. These are NOT bugs — they are places where the change makes a choice that the author should consciously confirm. Look for:

1. **Behavioral changes**: defaults that changed, parameters removed, output formats altered — flag what changed and what downstream consumers expect.
2. **Implicit assumptions**: hardcoded values, threshold choices, fallback strategies — where a different choice would also be reasonable.
3. **Contract changes**: function signatures, return types, config schemas, or API shapes that other code depends on — point to the callers/consumers affected.
4. **Tradeoffs made**: simplicity vs. completeness, performance vs. correctness, consistency vs. special-casing — name the tradeoff so the author can decide intentionally.

Format each as:
- **Location**: `path:line`
- **Decision**: what choice was made and what alternative exists
- **Impact**: who/what is affected if this is wrong

If there are no meaningful decision points, omit this section entirely.

Targets:
$ARGUMENTS
