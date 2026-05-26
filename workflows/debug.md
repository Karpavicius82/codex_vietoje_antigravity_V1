# Debug Workflow

## Tikslas

Sistemingai rasti ir isstaisyti klaida, uzkirsti kelia regresijai.

## Eiga

1. **Surink informacija**: klaidos pranešimas, stack trace, žingsniai atkurti, aplinkos detalės.
2. **Reprodukuok**: atkurk klaidą lokaliai. Jei nepavyksta – surink daugiau duomenų.
3. **Izoliuok**: susiaurink iki mažiausio kodo bloko:
   - Komentuok dalį kodo ir tikrink ar problema lieka
   - Naudok `git bisect` jei klaida nauja
   - Sukurk minimalų reprodukcijos pavyzdį
4. **Hipotezės**: suformuluok 1-3 hipotezes dėl šakninės priežasties.
5. **Testuok hipotezes**: kiekvieną hipotezę testuok atskirai (logging, breakpoints, vieno kintamojo pakeitimas).
6. **Taisyk šaknį**: kai randi root cause – taisyk priežastį, ne simptomą.
7. **Regresijos apsauga**: pridėk testą, kuris pagautų šią klaidą ateityje.
8. **Dokumentuok**: trumpai aprašyk priežastį ir pataisą.

## Conditional branching

- Jei klaida tik specifinėje aplinkoje → patikrink env kintamuosius, OS, versijas.
- Jei klaida intermittent (kartais atsiranda) → ieškokis race condition, timing, cache.
- Jei klaida tik su specifiniais duomenimis → ieškok edge case validacijos.
- Jei nežinai kur pradėti → pradėk nuo error message ir ieškok kode.

## Baigta, kai

- Šakninė priežastis identifikuota ir paaiškinta.
- Pataisa nekeičia nesusijusio elgesio.
- Yra regresijos testas arba aiškiai nurodyta kodėl jo nėra.
- Vartotojas gali atkurti, kad klaida dingo.
