# Dependency Audit Skill

Use this skill to check project dependencies for vulnerabilities, outdated packages, and license issues.

## Steps

1. Detect package manager:
   - `package-lock.json` / `yarn.lock` → npm/yarn
   - `requirements.txt` / `Pipfile.lock` → pip
   - `go.sum` → Go modules
   - `Cargo.lock` → Rust
   - `*.csproj` → .NET

2. Run vulnerability scan:
   - npm: `npm audit --json`
   - yarn: `yarn audit --json`
   - pip: `pip-audit` arba `safety check`
   - .NET: `dotnet list package --vulnerable`

3. Check for outdated packages:
   - npm: `npm outdated`
   - pip: `pip list --outdated`

4. Classify findings:
   - 🔴 Critical/High CVE → immediate fix
   - 🟡 Medium CVE → plan fix
   - 🔵 Low CVE → track
   - ⚪ Outdated (no CVE) → optional update

5. For each critical finding, suggest fix command.

## Output

- Vulnerability count by severity.
- Outdated package count.
- Recommended fix commands.
- Packages that cannot be auto-fixed.
