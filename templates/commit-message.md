# Commit Message Template

<!-- Conventional Commits: https://www.conventionalcommits.org -->

## Formatas

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Tipai

| Tipas | Paskirtis | Pavyzdys |
|---|---|---|
| feat | Nauja funkcija | `feat(auth): add password reset flow` |
| fix | Klaidos taisymas | `fix(api): handle null response from payment service` |
| refactor | Kodo pertvarkymas | `refactor(db): extract query builder into separate module` |
| docs | Dokumentacija | `docs(readme): update installation instructions` |
| test | Testai | `test(auth): add unit tests for token validation` |
| chore | Priežiūra | `chore(deps): update eslint to v9` |
| style | Formatavimas | `style: fix indentation in config files` |
| perf | Performance | `perf(api): add database index for user lookup` |
| ci | CI/CD | `ci: add staging deploy step` |
| build | Build sistema | `build: switch to esbuild for faster builds` |

## Taisyklės

- Description mažosiomis raidėmis, be taško pabaigoje.
- Scope neprivalomas, bet rekomenduojamas.
- Body paaiškina KODĖL, ne KĄ (ką matai iš diff).
- Footer: `BREAKING CHANGE: ...` jei yra breaking change.
- Footer: `Fixes #123` jei taisoma issue.
