# Performance Check Skill

Use this skill when investigating or validating performance of code, APIs, or frontend rendering.

## Steps

1. **Nustatyk metriką**: ką matuoji? (response time, render time, memory, CPU, bundle size)
2. **Baseline**: išmatuok dabartinę reikšmę PRIEŠ pakeitimus.
3. **Profiliuok**:
   - Node.js: `--prof`, `clinic.js`, `0x`
   - Python: `cProfile`, `py-spy`
   - Frontend: Lighthouse, Chrome DevTools Performance tab
   - API: `curl -w "%{time_total}"`, `ab`, `wrk`
4. **Identifikuok bottleneck**: kas užima daugiausiai laiko/atminties?
5. **Optimizuok**: taikyk tikslinę optimizaciją (ne premature optimization).
6. **After**: išmatuok po pakeitimo su ta pačia metrika.
7. **Palygink**: before vs after su skaičiais.

## Dažniausi bottlenecks

| Tipas | Simptomai | Sprendimas |
|---|---|---|
| N+1 queries | Lėtas DB, daug mažų query | Eager loading, JOIN |
| Large bundle | Lėtas FE load | Code splitting, tree shaking |
| Memory leak | Augantis RAM naudojimas | Profiler, weak references |
| Sync I/O | Blokuojantis thread | Async/await, worker threads |
| Missing index | Lėtas DB query | `EXPLAIN ANALYZE`, add index |
| Re-renders | Lėtas UI | React.memo, useMemo, virtualization |

## Output

- Metrika: before vs after.
- Bottleneck identifikuotas.
- Optimizacija pritaikyta.
- Likusios rizikos.
