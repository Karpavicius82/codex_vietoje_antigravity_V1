# Migrate Workflow

## Tikslas

Saugiai migruoti priklausomybes, framework versijas, duomenu bazes schemas ar API kontraktus.

## Eiga

1. **Inventorizuok**: kas tiksliai migruojama? (dependency, framework, DB, API versija)
2. **Compatibility check**: perskaityk migration guide / changelog / breaking changes.
3. **Backup**: užtikrink, kad dabartinė būsena yra saugi (git commit, DB backup).
4. **Planuok žingsnius**: suskaidyk migraciją į mažus, revertinamumus žingsnius.
5. **Vykdyk po vieną žingsnį**:
   - Padaryk pakeitimą
   - Paleisk build
   - Paleisk testus
   - Jei FAIL → rollback ir analizuok
6. **Validuok visumą**: po visų žingsnių paleisk pilną test suite.
7. **Dokumentuok**: atnaujink README, CHANGELOG, dependency docs.

## Rollback planas

Kiekvienas migracijos žingsnis turi turėti atšaukimo kelią:
- **Dependency**: grąžink seną versiją `package.json` / `requirements.txt`
- **DB schema**: `migration:down` arba reverse SQL
- **API**: palaikyk seną versiją lygiagrečiai (versioning)
- **Framework**: git revert

## Baigta, kai

- Migracija atlikta pilnai arba sustabdyta su aiškia priežastimi.
- Visi testai praeina.
- Dokumentacija atnaujinta.
- Rollback planas dokumentuotas.
