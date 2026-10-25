Status labels: every k above is *certificate-verified*: (D, g) is in `solutions.json`, and the
explicit edge list `[u, v, colour]` is in `certs.json`. Each was re-checked by `src/check.py`
(enumerates all 4-cycles). No k_max for my eight n is *proved*. No UNSAT result was obtained at any
k for these n, so every larger k is *unfinished*, not "infeasible". `table.tsv` has the per-n line
the task asks for (k_lo = best certificate, k_unsat blank).

**Observed k/n.** Best k/n: 0.239 (46), 0.228 (57), 0.209 (67), 0.206 (68), 0.205 (78),
0.191 (89), 0.192 (99), 0.190 (100). For the two multiples of 4, **k = n/4 was not found**:
n = 68 (k = 17) and n = 100 (k = 25), and neither was any k between the best and n/4. There is no
UNSAT proof at n/4 either, so the question "does n/4 persist" stays open for these n. The
negative evidence is only search failure.

**Compared with earlier bounds.** n = 57: k = 13 (741 edges) beats CONSTR's cyclic k = 12 (684) and
its general local-search value (684). n = 67: k = 14 (938 edges) beats CONSTR's general bound 909.
n = 46: k = 11, the same as CONSTR. n = 89: k = 17, the same as CONSTR's cyclic 1513 (its general
local search has 1519). n = 68, 78, 99, 100 had no CONSTR value.

## 3. Certificates

`certs.json`: `{"n": [[u, v, c], ...]}` (n·k edges each). `solutions.json`: `{"n": [[d, g], ...]}`,
the edge set {i, i+d} with colour i + g(d) mod n. Both are produced by `src/make_tables.py`, which
re-runs the checker on every entry.

