## Lessons

Lessons are organized by confidence level. Higher-confidence lessons override lower ones when they conflict.

### Hard Rules
> Violations of these caused real bugs or failures. Treat as mandatory.

<!-- Example:
- Never call `process()` without checking `is_initialized` first — causes silent data corruption (PR #42)
- Always run migration tests before pushing schema changes — CI doesn't catch all migration issues
-->

### Proven Patterns
> These worked reliably across multiple instances. Default to following them.

<!-- Example:
- When adding a new endpoint, copy the pattern from `users.py` — it handles auth, validation, and error responses correctly
- For batch processing, use the chunked iterator from shared utils — it handles memory correctly
-->

### Observations
> Noticed once or twice. Useful context, but not yet proven. May be revised.

<!-- Example:
- The test suite runs faster when database fixtures are loaded per-class rather than per-test
- Large file uploads seem to timeout after ~30s in the staging environment
-->
