# Workflow Gaps

One line each time a later stage catches what an earlier one should have. Written by `/gap`, `/review`, and `/triage`; consumed by `/gaps`.

Format: `- [YYYY-MM-DD] <should-have> → <caught-by>: <what>`
Layers: format lint types test review ci bot-review human-review production tooling
A layer is the kind of check that would catch it, whether or not you run that stage.

<!-- - [2026-03-12] review → bot-review: changed return type to tuple but only reviewed changed files, not callers -->

## Resolved
