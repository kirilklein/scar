## Pipeline gaps

When a later stage catches what an earlier one should have — CI fails on what passed locally, a reviewer or bot finds what tests or `/review` missed, a bug reaches production — log it before fixing it. Run `/triage` on a PR with CI failures or comments; it logs each miss itself. For anything else, run `/gap <should-have> <caught-by> <what>`. Run `/gaps` when the log has 5+ entries.
