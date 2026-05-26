# Git Workflow Skill

Use this skill for any git-related operations: branching, committing, merging, conflict resolution.

## Steps

1. Patikrink dabartinę git būseną: `git status`, `git branch`, `git stash list`.
2. Jei yra uncommitted changes – pasiūlyk `git stash` prieš pradedant.
3. Sukurk branch pagal konvenciją:
   - Feature: `feature/trumpas-aprasymas`
   - Bugfix: `bugfix/kas-taisoma`
   - Hotfix: `hotfix/kas-taisoma`
4. Atlik pakeitimus pagal užduotį.
5. Commit su conventional commit formatu:
   - `feat(scope): aprasymas`
   - `fix(scope): aprasymas`
   - `refactor(scope): aprasymas`
   - `docs(scope): aprasymas`
6. Jei yra konfliktai – spręsk po vieną failą, pirmenybė incoming changes.
7. Jei reikia – `git stash pop` grąžink vartotojo darbus.

## Conflict resolution

1. `git diff --name-only --diff-filter=U` – rask konfliktų failus.
2. Kiekvienam failui: perskaityk abi puses, suprask intent.
3. Pasirink logiškai teisingą versiją arba sujunk abi.
4. `git add` resolved failą.
5. Testuok po kiekvieno resolved failo.

## Output

- Git operacijos atliktos.
- Commit hash ir žinutė.
- Conflict resolution (jei buvo).
