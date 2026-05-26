# Safety Policy

## Never Do Without Explicit Approval

- Delete files or directories recursively.
- Run `git reset --hard`, `git clean`, or destructive checkout commands.
- Rewrite broad project history.
- Install packages globally.
- Send data to external services.
- Modify secrets, credentials, or production configuration.

## Require Extra Care

- Database migrations.
- Authentication and authorization logic.
- Payment, billing, or financial calculations.
- Security-sensitive parsing or file handling.
- CI/CD and deployment scripts.
- Generated files and lockfiles.

## User Work Protection

- Treat all existing uncommitted changes as user-owned.
- Do not revert unrelated changes.
- If user changes conflict with the task, explain the conflict and choose the least invasive path.
