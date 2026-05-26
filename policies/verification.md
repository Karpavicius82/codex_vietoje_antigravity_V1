# Verification Policy

## Preferred Checks

- Unit tests for isolated logic.
- Integration tests for cross-module behavior.
- Typecheck for typed projects.
- Lint and formatter checks when configured.
- Browser verification for visual frontend changes.
- Manual command output checks when no automated tests exist.

## Minimum Standard

Every completed task should include one of:

- Passing relevant automated checks.
- A focused manual verification.
- A clear explanation of why verification could not be run.

## Reporting

Final response must mention:

- What changed.
- Which files were touched, if any.
- What verification ran.
- Any known residual risk.
