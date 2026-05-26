# Security Audit Workflow

## Tikslas

Atlikti saugumo audita ir identifikuoti pažeidžiamumus prieš jiem tampant incidentais.

## Eiga

1. **Dependency scan**: patikrink priklausomybių pažeidžiamumus.
   - Node: `npm audit` / `yarn audit`
   - Python: `pip-audit` / `safety check`
   - .NET: `dotnet list package --vulnerable`
   - General: `trivy`, `snyk`

2. **Secret scan**: ieškok hardcoded credentials.
   - Ieškok: API keys, passwords, tokens, connection strings
   - Failuose: `.env`, config files, source code
   - Git istorijoje: `git log --all -p | grep -i "password\|secret\|key\|token"`

3. **Input validation audit**: kiekvienas user input kelias.
   - SQL parametrizavimas (ne string concatenation)
   - XSS apsauga (output encoding)
   - Path traversal (failų keliai iš user input)
   - Command injection (shell komandos iš user input)

4. **Auth/Authz review**: autentifikacijos ir autorizacijos logika.
   - Session valdymas
   - Password hashing algoritmas
   - Role-based access control
   - JWT validacija

5. **HTTPS/TLS**: ar komunikacija šifruota.

6. **Ataskaita**: kiekvienam radiniui – severity, lokacija, siūlymas.

## Severity

- 🔴 **Critical**: Remote code execution, SQL injection, exposed secrets
- 🟠 **High**: XSS, CSRF, broken auth
- 🟡 **Medium**: Information disclosure, missing headers
- 🔵 **Low**: Best practice violations

## Baigta, kai

- Visos 6 sritys patikrintos.
- Radiniai surašyti su severity ir kodo nuorodomis.
- Critical ir High radiniai turi siūlomus pataisymus.
