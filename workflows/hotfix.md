# Hotfix Workflow

## Tikslas

Greitai pataisyti kritine klaida su minimaliu rizikos lygiu.

## Eiga

1. **Patvirtink kritiškumą**: ar tai tikrai hotfix, ne normalus bugfix?
   - Ar production paveiktas?
   - Ar vartotojai negali naudotis sistema?
   - Ar yra duomenų praradimo rizika?
2. **Izoliuok problemą**: rask tikslią klaidos vietą (max 15 min tyrinėjimo).
3. **Minimal fix**: taisyk TIKTAI klaidą. Jokių refaktorizacijų, jokių papildomų pakeitimų.
4. **Smoke testas**: patikrink, kad pataisa veikia ir nesulaužė pagrindinio flow.
5. **Dokumentuok**: trumpas aprašymas PR/commit žinutėje.

## Skirtumai nuo bugfix

| Aspektas | Bugfix | Hotfix |
|---|---|---|
| Skubumas | Normalus | Kritinis |
| Scope | Thorough fix | Minimal fix |
| Testai | Full regression | Smoke test only |
| Review | Full review | Fast-track review |
| Branch | feature branch | hotfix branch |

## Baigta, kai

- Klaida pataisyta.
- Smoke testas praėjo.
- Nėra side effects pagrindiniame flow.
- Follow-up task sukurtas thorough fix (jei reikia).
