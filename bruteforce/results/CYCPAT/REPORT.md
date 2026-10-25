# CYCPAT: structure of optimal cyclic orbit colourings, and explicit rules

Task: `bruteforce/tasks/CYCPAT.md` (family defined in `tasks/CYC.md`). All computation ran in this cloud
container. Tables marked (gen) are produced by `src/make_tables.py` from the raw run files (`runs/tables.md`).

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
nproc: 4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

## 2. Results at a glance

| # | Result | Status |
|---|--------|--------|
| R1 | Full enumeration of optimal (D, g) up to symmetry for n = 12–33 and n = 36, with orbit counts (§4). n = 34 is partial (≥ 25653 orbits). | *proved* (exhaustive SAT with blocking; solver results, no DRAT; k_max re-derived; every listed solution re-checked by two checkers). The n = 34 count is *unfinished* (lower bound). |
| R2 | Optimal solutions have **no visible algebraic structure**: no polynomial g (deg ≤ 2) for n ≥ 20; φ = 2g − d is never c0 + c2·d² for odd n ≥ 15; a nontrivial multiplier stabiliser occurs only at n = 13, 14, 15, 21, 24, 26, 29, 30 (≤ 6 orbits each); no residue pattern mod 4; less Sidon-like than random (§5). | *proved* for the enumerated n (exhaustive tests on the complete lists) |
| R3 | **Closed form of multiplier-invariant colourings.** If (D, g) is invariant under a subgroup K ∌ −1 of Z_p^× and D = ±cK, then after scaling, colour(a→b) = (1−λ)a + (1+λ)b, where each edge is oriented so that b − a ∈ cK. | *proved* (§6.1, paper proof) and numerically confirmed |
| R4 | **Single-coset rule** (D = ±cK, K = the odd-order subgroup of index r in Z_p^×, one free parameter t). It gives k = (p−1)/4 for p = 13, 29, 37, 53, 61 and k = (p−1)/6 for every p ≡ 7 (mod 12) with 19 ≤ p ≤ 643 except p = 439, 523, 571, 607, 619. Each fixed index dies: the last working p is 61 (r=4), 643 (r=6), 1993 (r=8), 4271 (r=10), ≥ 9013 (r=12). Empirically p_last ≈ 0.45·r⁴, so the best k ≈ 0.8·p^{3/4}. **Not εn.** | instances *certificate-verified*; the asymptotic trend is *heuristic* |
| R5 | **New lower bounds**: M(53) ≥ 689 (k=13) and M(61) ≥ 915 (k=15). The README/CONSTR tables have 636 and 793; for the cyclic family CONSTR had k=12 and k=13. | *certificate-verified* (`certs.json`, simple checker) |
| R6 | **Two-class rule** (two ±-cosets, one extra offset γ): k = (p−1)/6 for every p ≡ 13 (mod 24) with 37 ≤ p ≤ 373 except p = 349, and k = (p−1)/5 at p = 31, 71, 151. It also decays. | instances *certificate-verified* (C reduced check + full check; explicit graph for p ≤ 200); trend *heuristic* |
| R7 | **Linear rules are o(n).** If g(d) ≡ b·d on D with b ≡ u/v for fixed integers (v ≥ 1, gcd(v, n) = 1, b ∉ {0, 1}), then D contains no non-degenerate homothetic copy of {0, v, v−u, u}. By Szemerédi's theorem, \|D\| = o(n). For b = 2 the forbidden pattern is a 4-term AP. The same holds for piecewise-affine g with O(1) pieces of bounded-height slope. | *proved* (§6.3, paper proof, uses Szemerédi's theorem as a black box); checked numerically |
| R8 | Exact optimum of the linear rule g = 2d for n = 43–99 (SAT): k/n falls from 0.209 to 0.172. Over all slopes b (n = 61–89) the best k is at most 1 above b = 2. Over all quadratics g = ad² + bd (n = 13–43) the best rule is linear (a = 0) in 29 of 31 cases, and it reaches k_max only at n = 13–17, 20, 22, 25, 26, 29, 30. | *proved* per n (exact SAT within the rule) |
| R9 | ⟨u⟩-invariant optima (SAT, n = 13–53 so far): they reach k_max at n = 13–15, 21, 24, 26, 29, 30 and 38 (k_max(38) = 9 per CYC/C1). They match the CONSTR LB at 37, 41, 48, beat it at 53 (13 vs 12), and give k = 11 at n = 51 (no previous cyclic LB). They fall short elsewhere, e.g. n = 28, 32, 36: no invariant solution with k ≥ 6, 7, 8 for any subgroup (UNSAT). | *proved* per subgroup where the next k returned UNSAT; otherwise lower bound |
| R10 | Literature: no prior cyclic or Cayley construction found for "every C4 rainbow with n colours" (§8). | quick search only |
| R12 | **Doubling lift fails.** For every optimal D at m = 12, 16, 20, the set D′ = D ∪ (m − D) of Z_{2m}-orbits over ±D (size 2k = n′/4) admits no valid g′ (SAT). Results: m = 12: 5 of 5 distinct D′ UNSAT; m = 16: 9 of 9 UNSAT; m = 20: 14 of 14 UNSAT (each < 60 s). So the n/4 solutions at 24, 32, 40 are not lifts of the ones at 12, 16, 20. | *proved* per D (solver UNSAT, unchecked) |
| R11 | Observation: for n ≡ 0 (mod 4) the number of solution orbits at k = n/4 is 58, 165, 362, 285, 128, 59 for n = 16, …, 36. It peaks at 24 and is falling by n = 32–36. Odd n with k_max/n > 1/4 (18, 21, 31) have a **unique** optimal orbit. | counts *proved* (solver); the trend is *heuristic* |

**Bottom line.** No explicit rule found here gives |D| ≥ εn on an infinite family. Every structured rule I could formulate dies, and for linear rules this is provable through Szemerédi's theorem. The optimal solutions for n ≤ 36 look unstructured. Their number at k = n/4 shrinks after n = 24–28. The evidence therefore leans toward k_max(n) = o(n) for this family, which agrees with BEGS's belief. This is *evidence, not a theorem*.

## 3. Certificates

`certs.json` uses the format `{"n": [[u, v, c], ...]}` and holds n = 53 (689 edges) and n = 61 (915 edges). Both are single-coset rules with r = 4, class c = 1:

- n = 53, t = 32: (d, g) = (1,0) (4,11) (6,37) (7,50) (9,23) (10,51) (11,49) (13,15) (15,44) (16,32) (17,21) (24,42) (25,19)
- n = 61, t = 6: (d, g) = (1,0) (3,38) (4,2) (5,27) (9,52) (12,41) (13,17) (14,8) (15,30) (16,6) (19,11) (20,32) (22,45) (25,34) (27,28)

Edge {i, i+d} gets colour i + g(d) mod n. The pairs are also in `solutions/new_lower_bounds.json`.

`src/cert_check.py` is deliberately simple. It reads only the edge list, checks the colours are in 0..n−1 and the graph is simple, and enumerates every 4-cycle through pairs of common neighbours. Output:
```
53 edges 689 four-cycles 49608 VALID
61 edges 915 four-cycles 89670 VALID
```
(The checker reports INVALID on a deliberately corrupted copy.)

Other solution files:
- `solutions/enum_n<n>_k<k>.json`: all normal forms (canonical representatives under G) of optimal solutions, with orbit sizes.
- `solutions/coset_rules.json`: best single-coset and two-class instance per prime, with parameters, check flags and (D, g) for p ≤ 400.
- `solutions/symmetric_best.json`: best ⟨u⟩-invariant solution per n.
- `solutions/linear_rule_b2.json`: optimal D for g = 2d.

## 4. Enumeration of optimal solutions (Step 2)

**Encoding** (`src/cycenum.py`, re-derived). Take a closed walk 0 → v1 → v2 → v3 → 0 on distinct vertices with signed steps s = ±d.

- A step +d from v uses edge {v, v+d}, colour v + g(d). A step −d uses edge {v−d, v}, colour (v−d) + g(d). So the colour is v + h(s), with h(d) = g(d) and h(−d) = g(d) − d.
- Two edges in orbits d_a ≠ d_b with offsets o_a, o_b collide iff g(d_a) − g(d_b) ≡ o_b − o_a. Two distinct edges in the same orbit never collide.
- Each forbidden key (d_a, d_b, δ, other orbits) becomes one clause (¬y_{d_a,d_b,δ} ∨ ¬p_others), with y ⇐ x[d_a][t] ∧ x[d_b][t−δ].
- The constraint |D| = k uses a totalizer.
- Colour translation fixes g(min D) = 0.

**Symmetry group G** = Z_n^× (multipliers) × colour translations.

- Vertex map i ↦ ui, colour map c ↦ uc. Edge {i, i+d} with colour i + g(d) maps to edge {ui, ui+ud} with colour ui + u·g(d).
- If ud ≡ e = rep(ud), this is edge {j, j+e} with j = ui, so g′(e) = u·g(d).
- If ud ≡ −e, it is edge {j, j+e} with j = ui − e, and colour ui + u·g(d) = j + e + u·g(d), so g′(e) = e + u·g(d).
- 4-cycles map to 4-cycles and distinct colours stay distinct (u is invertible), so validity is preserved. Empirically, all 9886 G-images of the optimal solutions for n ∈ {20, 21, 24, 27, 28, 31, 32} pass `cyccheck`.

**Enumeration.** Each SAT model is mapped to its G-orbit (all images, re-translated so g(min D) = 0). Every image is blocked, so each SAT call yields a new orbit, and the final UNSAT call proves the list complete.

- For n = 33, 34, 36 and 40 I added a sound case split. Case "unit": D contains a unit, so by a multiplier 1 ∈ D and by translation g(1) = 0. Case "nounit": D contains no unit.
- Validated at n = 28: 285 + 0 = 285 orbits, matching the unsplit run.
- For n = 33 and n = 36, `nounit` returned UNSAT in < 1 s, and `unit` finished in 580 s and 927 s. A further split by the second-smallest orbit (`unit2:e`) is also implemented and was validated at n = 28 (the union over e gives the same 285 normal forms).

**Validation.** k_max agrees with CONSTR (`cyclic_family_status.json`) for every n = 13–34 and 36 in that file: SAT at k_max here. UNSAT at k_max+1 was re-proved here for n = 12, 16, 20, 24, 28, 32, 36; for the other n the CONSTR UNSAT result is used. k_max(12) = 3 (new here).

- *Discrepancy in the task table:* `tasks/CYC.md` lists k_max = 4 for n = 14. CONSTR's own JSON (first UNSAT k = 4) and my enumeration both give **k_max(14) = 3**.
- Every listed normal form was re-checked by `src/cyccheck` (C, cycles through 0) and by `src/explicit_check.py` (explicit graph, all 4-cycles by common neighbours). See `runs/verify_solutions.txt` (all files in `solutions/`) and `runs/verify_enum*.txt`: 0 failures.

(gen) Counts. Solutions with g(min D) = 0, times n, gives all solutions.

| n | k | status | solution orbits under G | solutions with g(min D)=0 | k+1 checked UNSAT here | secs |
|---|---|---|---|---|---|---|
| 12 | 3 | complete | 24 | 96 | yes (0 s) | 0.0 |
| 13 | 3 | complete | 31 | 340 | — (CONSTR) | 0.0 |
| 14 | 3 | complete | 103 | 614 | — (CONSTR) | 0.0 |
| 15 | 4 | complete | 12 | 92 | — (CONSTR) | 0.0 |
| 16 | 4 | complete | 58 | 464 | yes (0 s) | 0.0 |
| 17 | 4 | complete | 191 | 3056 | — (CONSTR) | 0.1 |
| 18 | 5 | complete | 1 | 6 | — (CONSTR) | 0.0 |
| 19 | 5 | complete | 14 | 252 | — (CONSTR) | 0.1 |
| 20 | 5 | complete | 165 | 1320 | yes (0 s) | 0.2 |
| 21 | 6 | complete | 1 | 4 | — (CONSTR) | 0.1 |
| 22 | 5 | complete | 4333 | 43330 | — (CONSTR) | 2.3 |
| 23 | 6 | complete | 28 | 616 | — (CONSTR) | 0.9 |
| 24 | 6 | complete | 362 | 2884 | yes (0 s) | 1.5 |
| 25 | 6 | complete | 2265 | 45300 | — (CONSTR) | 9.2 |
| 26 | 6 | complete | 15791 | 189444 | — (CONSTR) | 26.7 |
| 27 | 7 | complete | 10 | 180 | — (CONSTR) | 8.1 |
| 28 | 7 | complete | 285 | 3420 | yes (2 s) | 12.3 |
| 29 | 7 | complete | 2288 | 63968 | — (CONSTR) | 92.5 |
| 30 | 7 | complete | 49909 | 399264 | — (CONSTR) | 284.8 |
| 31 | 8 | complete | 1 | 30 | — (CONSTR) | 98.6 |
| 32 | 8 | complete | 128 | 2048 | yes (49 s) | 146.7 |
| 33 | 8 | complete (case split unit/nounit) | 1756 | 35120 | — (CONSTR) | 579.7 |
| 34 | 8 | incomplete (lower bound on orbit count) | 25653 | 410448 | — (CONSTR) |  |
| 36 | 9 | complete (case split unit/nounit) | 59 | 708 | yes (1040 s) | 927.7 |

Observations:

- When k_max/n is largest (n = 18, 21, 31, all with k_max/n > 1/4), the optimum is **unique** up to G. n = 27 has 10 orbits.
- When k_max/n is smallest (n = 22, 26, 30, 34, all ≡ 2 mod 4), there are thousands of orbits.
- For n ≡ 0 (mod 4) at k = n/4: 58, 165, 362, 285, 128, 59 orbits for n = 16, 20, 24, 28, 32, 36. The number of *solutions* with g(min D) = 0 (orbits × orbit size) is 464, 1320, 2884, 3420, 2048, 708. Both peak at n = 24–28.

## 5. Structure tests on the optimal solutions (Step 3)

All tests run on the complete lists (n ≤ 32), after normalising by G (`src/stats.py`, `src/dclasses.py`, `src/polyfit.py`, `src/gfit.py`, `src/sidon.py`).

- **D up to multipliers.** There are many distinct D-classes: n = 24: 43, n = 28: 62, n = 32: 60 classes. For n ≥ 24 the most frequent class covers ≤ 12%. Intervals and APs: over all classes, the best multiplier image of D overlaps an initial interval [1, k] in at most k−1 points for 20 ≤ n ≤ 32.
- **Cosets / stabilisers** (exact, from the orbit sizes). The stabiliser in G of an optimal solution is nontrivial only at:
  - n = 13: 4 orbits, order 3
  - n = 14: 1 orbit, order 3
  - n = 15: 1 orbit, order 2
  - n = 21: the unique orbit, order 3 (u = 4)
  - n = 24: 3 orbits, order 2
  - n = 26: 6 orbits, order 3
  - n = 29: 4 orbits, order 7 (D = one coset class of the order-7 subgroup)
  - n = 30: 2 orbits, order 2

  At n = 28 and 32 every optimal solution has trivial stabiliser (complete lists). At n = 36 none is invariant under any nontrivial subgroup: `symscan` proves UNSAT already at k = 8 for each of the 7 subgroups (solver result).
- **Residues.** D mod 4, gcd(d, n), and parities of (d, g) are all mixed. No residue class pattern holds for more than 26% of solutions (n = 28).
- **Polynomial g.** For n ≥ 20 no optimal solution is a polynomial of degree ≤ 2 in d on D, under any G-image. For n = 12 and 16 a few are, but k ≤ 4 there.
- **Polynomial φ.** For odd n, φ(d) = 2g(d) − d is the natural even function (colour ×2 = a + b + φ(|b−a|)).
  - φ is never of the form c0 + c2 d² on D for odd n = 15–27.
  - φ is never c0 + c2 d² + c4 d⁴ for n = 15, 19, 21, 23, 25. At n = 17 it is, for 9 of 191 orbits, but there k = 4 is barely above the 3 parameters.
  - c0 + c1 d, c0 + c/d and c0 + c/d² fit only at n = 13 and 17 (k ≤ 4).
- **Sidon / arc.** The point set {(s, h(s)) : s ∈ ±D} ⊂ Z_n² is Sidon *less* often than random sets of the same size (n = 28: 0% vs 4%). Sidon (d, g) only: 39% vs 68%.
- **CRT, n = 4m.** No pattern by d mod 4 (first bullet) or by gcd (n = 28: gcd-profiles spread over ≥ 6 types).

Conclusion: optimal solutions look like generic solutions of a random-looking CSP. Nothing suggests an algebraic rule.

## 6. Explicit rules and what they achieve (Step 4)

### 6.1 Closed form of multiplier-invariant colourings (proved)

Let n = p be an odd prime. Write c′ = 2c, so c′(edge {a, b}) = a + b + φ(s) with s = b − a and φ(s) = 2h(s) − s.

- φ is even: h(−s) = h(s) − s gives φ(−s) = 2h(s) − 2s + s = φ(s).
- Suppose (D, g) is invariant under u up to colour translation, i.e. c′(ua, ub) = u·c′(a, b) + τ. Then φ(us) = u·φ(s) + τ.
- If u ≠ 1, put ψ = φ − τ/(1−u). Then ψ(us) = u·ψ(s).
- If D = ±cK with K = ⟨u⟩ and −1 ∉ K, then ψ(ck) = k·ψ(c) = λ·ck on cK, where λ = ψ(c)/c. By evenness, ψ(s) = −λs on −cK.
- Orient each edge a→b so that b − a ∈ cK. Then c′(a→b) = a + b + λ(b − a) + const = (1−λ)a + (1+λ)b + const.

So the coset rule is an **affine colouring of an oriented Cayley graph**. Numerically confirmed (p = 61, 137, 199).

### 6.2 Coset rules (`src/coset.c`, `src/coset2.c`, `src/rules.py`)

**Single coset.** p prime, r even with m = (p−1)/r odd (so −1 ∉ K = ⟨w^r⟩). D = {rep(c·x) : x ∈ K} for one of the r/2 ±-classes c = w^j. Set g(rep c) = 0 and g(rep(ud)) = u·g(d) + [ud ≡ −rep]·rep(ud) + t, with all t ∈ Z_p tried.

- The colouring is K-invariant, so checking cycles through 0 with first step ±c suffices ("reduced check"). Every passing candidate was re-checked with the full check (all first steps), and none failed.
- `src/collect_rules.py` rebuilds every reported instance in Python (`src/rules.py`, independent code), checks it with `cyccheck`, and for p ≤ 200 with the explicit-graph checker. Result (`solutions/coset_rules.json`): all 327 single-coset instances (p ≤ 2731) and all 76 two-class instances (p ≤ 397) pass `cyccheck`. The 31 + 41 instances with p ≤ 200 also pass the explicit-graph check. 0 failures.

**Two classes.** D = rep(c1·K) ∪ rep(c2·K), with g(rep c1) = 0, g(rep c2) = γ and a common t (p² candidates per class pair).

(gen) Tables:

Single-coset rule, smallest working index r per prime (k = (p-1)/r):

| p | 5 | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 37 | 41 | 43 | 47 | 53 | 59 | 61 | 67 | 71 | 73 | 79 | 83 | 89 | 97 | 101 | 103 | 107 | 109 | 113 | 127 | 131 | 137 | 139 | 149 | 151 | 157 | 163 | 167 | 173 | 179 | 181 | 191 | 193 | 197 | 199 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| k | 0 | 0 | 0 | 3 | 0 | 3 | 0 | 7 | 5 | 9 | 5 | 7 | 0 | 13 | 0 | 15 | 11 | 7 | 9 | 13 | 0 | 11 | 3 | 5 | 17 | 0 | 9 | 7 | 21 | 13 | 17 | 23 | 0 | 25 | 13 | 27 | 0 | 0 | 0 | 15 | 19 | 3 | 7 | 33 |
| r | - | - | - | 4 | - | 6 | - | 4 | 6 | 4 | 8 | 6 | - | 4 | - | 4 | 6 | 10 | 8 | 6 | - | 8 | 32 | 20 | 6 | - | 12 | 16 | 6 | 10 | 8 | 6 | - | 6 | 12 | 6 | - | - | - | 12 | 10 | 64 | 28 | 6 |

| p range | primes | max k/p | mean k/p |
|---|---|---|---|
| 0–499 | 93 | 0.2459 | 0.0871 |
| 500–999 | 73 | 0.1664 | 0.0602 |
| 1000–1499 | 71 | 0.1249 | 0.0558 |
| 1500–1999 | 64 | 0.1249 | 0.0481 |
| 2000–2499 | 64 | 0.1000 | 0.0455 |
| 2500–2999 | 32 | 0.1000 | 0.0499 |

Last prime with a valid single coset of index r (scanned up to): r=8: 1993 (to 4729), r=10: 4271 (to 11971), r=12: 9013 (to 9277)

Two-class rule (two +-cosets of an odd-order subgroup of index r, k = 2(p-1)/r); "to" = undecided larger k:

| p | k | r | k/p | to |
|---|---|---|---|---|
| 31 | 6 | 10 | 0.1935 | 0 |
| 37 | 6 | 12 | 0.1622 | 0 |
| 41 | 10 | 8 | 0.2439 | 0 |
| 43 | 6 | 14 | 0.1395 | 0 |
| 61 | 10 | 12 | 0.1639 | 0 |
| 67 | 6 | 22 | 0.0896 | 0 |
| 71 | 14 | 10 | 0.1972 | 0 |
| 73 | 6 | 24 | 0.0822 | 0 |
| 79 | 6 | 26 | 0.0759 | 0 |
| 97 | 6 | 32 | 0.0619 | 0 |
| 101 | 10 | 20 | 0.099 | 0 |
| 103 | 6 | 34 | 0.0583 | 0 |
| 109 | 18 | 12 | 0.1651 | 0 |
| 113 | 14 | 16 | 0.1239 | 0 |
| 127 | 18 | 14 | 0.1417 | 0 |
| 131 | 10 | 26 | 0.0763 | 0 |
| 151 | 30 | 10 | 0.1987 | 0 |
| 157 | 26 | 12 | 0.1656 | 0 |
| 163 | 18 | 18 | 0.1104 | 0 |
| 181 | 30 | 12 | 0.1657 | 0 |
| 191 | 10 | 38 | 0.0524 | 0 |
| 197 | 14 | 28 | 0.0711 | 0 |
| 199 | 22 | 18 | 0.1106 | 0 |
| 211 | 30 | 14 | 0.1422 | 0 |
| 229 | 38 | 12 | 0.1659 | 0 |
| 239 | 34 | 14 | 0.1423 | 0 |
| 241 | 30 | 16 | 0.1245 | 0 |
| 271 | 30 | 18 | 0.1107 | 0 |
| 277 | 46 | 12 | 0.1661 | 0 |
| 281 | 14 | 40 | 0.0498 | 0 |
| 307 | 34 | 18 | 0.1107 | 0 |
| 313 | 26 | 24 | 0.0831 | 0 |
| 331 | 30 | 22 | 0.0906 | 0 |
| 337 | 42 | 16 | 0.1246 | 0 |
| 353 | 22 | 32 | 0.0623 | 0 |
| 373 | 62 | 12 | 0.1662 | 0 |
| 379 | 54 | 14 | 0.1425 | 0 |

Interpretation:

- Every fixed index r eventually fails. The last success grows like ≈ 0.45·r⁴ (r = 8: 1993, 10: 4271, 12: ≥ 9013), so the best single-coset k(p) ≈ p/r ≈ 0.8·p^{3/4}.
- The number of valid t also falls steadily with p at fixed r. For example, at r = 8 it goes 296 (p = 137), 272 (409), 96 (761), 24 (953), 8 (1993), then 0.
- *Partial explanation (heuristic).* Every non-degenerate (−,+,−,+) cycle whose opposite edges collide is an affine pattern {x, y, μx+(1−μ)y, (1−μ)x+μy} ⊂ cK with μ = (1+λ)/2.
  - Patterns come in K-orbits, so each pattern class kills one λ.
  - Measured at p = 199, r = 6: the mean number of patterns per λ is 33.2, against |T|⁴/p² = 29.9. Only 136 of 199 λ avoid this one pattern type; the other cycle types remove the rest.
  - As p grows at fixed r, the number of distinct killed λ grows faster than p, and the rule dies.

### 6.3 Linear rules are o(n) (proved)

**Proposition.** Fix integers u, v with v ≥ 1 and b = u/v ∉ {0, 1}. For n with gcd(v, n) = 1, let (D, g) be valid with g(d) ≡ b·d (mod n) for all d ∈ D ⊂ [1, H]. Then D contains no m, r with 1 ≤ r and {m, m+vr, m+(v−u)r, m+ur} ⊂ D (as integers in [1, H]) and ur ≢ 0, (u−v)r ≢ 0 (mod n).

*Proof.* Put d1 = m+vr, d2 = m+(v−u)r, d3 = m, d4 = m+ur. Then d1 − d2 + d3 − d4 = 0.

- Walk with steps s = (d1, −d2, d3, −d4). The vertices are 0, d1, d1−d2 = ur, and ur + m = d4.
- They are distinct: d1, d4 ∈ [1, H] are nonzero; ur ≢ 0; d1 ≢ d4 since (v−u)r ≢ 0; d1 ≢ ur since d2 ≢ 0; ur ≢ d4 since m ≢ 0.
- Colours: edge 1 (step +d1 from 0) has colour h(d1) = b·d1 = bm + ur. Edge 3 (step +d3 from ur) has colour ur + h(d3) = ur + bm. They are equal, so this 4-cycle is not rainbow. ∎

**Corollary.** By Szemerédi's theorem applied to the 4-point pattern {0, v, v−u, u} (contained in an AP of bounded length), for every δ > 0 and large n, a valid D has fewer than δn elements. Non-degeneracy follows from Varnavides: there are ≫ n² configurations and only O(n) are degenerate. So linear rules give at most o(n²) edges. For b = 2 the pattern is a 4-AP, so |D| ≤ r₄(n/2) = n·exp(−c(log log n)^{c′}) by Green–Tao.

**Strengthening (piecewise-affine rules).** The proof only uses g(d1) and g(d3); d2 and d4 just have to lie in D.

- So the same holds for any A ⊆ D on which g(d) ≡ b·d + c, for one fixed c and b = u/v as above: A contains no non-degenerate copy of {m, m+vr} with m+(v−u)r, m+ur ∈ D. Applying Szemerédi to A alone gives |A| = o(n), uniformly in c.
- Slopes 0 and 1 are worse. With b = 0 the colour is the tail vertex (edge 0→d gets colour c), so a rectangle 0, d, d+d′, d′ with d, d′ ∈ A has two equal colours at vertex 0, and |A| ≤ 1. With b = 1 the colour is the head vertex, and |A| ≤ 1 for the same reason.
- **Corollary.** Any rule where g is piecewise affine on D, with a bounded number of pieces and slopes of bounded height, gives |D| = o(n). This covers "unions of intervals with g linear on each piece", the natural continuum-limit constructions. It does *not* cover slopes depending on n, such as the coset rules, whose slope (1 ± λ)/2 is an arbitrary residue.

- Numerical check: all 4-APs tested (57–301 per n, n ∈ {41, 64, 101, 160, 257}) give BAD with g = 2d.
- The proof needs a *fixed* rational b. A slope b depending on n in an "irrational" way escapes it. But the all-b scan at n = 61–89 finds best k only 0–1 above b = 2, with k/n ≈ 0.19 and falling.

(gen) Linear and quadratic rule tables:

Linear rule g(d) = 2d, exact max |D| (SAT; "complete" = optimal for this rule):

| n | 43 | 44 | 45 | 46 | 47 | 48 | 49 | 50 | 51 | 52 | 53 | 54 | 55 | 56 | 57 | 58 | 59 | 60 | 61 | 62 | 63 | 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 | 72 | 73 | 74 | 75 | 76 | 77 | 78 | 79 | 80 | 81 | 82 | 83 | 84 | 85 | 86 | 87 | 88 | 89 | 90 | 91 | 92 | 93 | 94 | 95 | 96 | 97 | 98 | 99 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| k | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 10 | 10 | 10 | 10 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 12 | 11 | 12 | 12 | 12 | 12 | 13 | 13 | 13 | 13 | 13 | 14 | 13 | 14 | 13 | 14 | 14 | 14 | 14 | 14 | 14 | 15 | 15 | 15 | 16 | 15 | 15 | 16 | 16 | 16 | 16 | 16 | 16 | 17 | 17 | 17 | 17 | 17 | 17 |
| k/n | 0.209 | 0.204 | 0.200 | 0.196 | 0.192 | 0.188 | 0.184 | 0.200 | 0.196 | 0.192 | 0.189 | 0.204 | 0.200 | 0.196 | 0.193 | 0.190 | 0.186 | 0.183 | 0.197 | 0.177 | 0.191 | 0.188 | 0.185 | 0.182 | 0.194 | 0.191 | 0.188 | 0.186 | 0.183 | 0.194 | 0.178 | 0.189 | 0.173 | 0.184 | 0.182 | 0.179 | 0.177 | 0.175 | 0.173 | 0.183 | 0.181 | 0.179 | 0.188 | 0.174 | 0.172 | 0.182 | 0.180 | 0.178 | 0.176 | 0.174 | 0.172 | 0.181 | 0.179 | 0.177 | 0.175 | 0.173 | 0.172 |

Linear rule g(d) = b d, best over all b in Z_n (exact max |D| per b, 60 s cap per b):

| n | b tried | best k | best b (some) | k for b=2 |
|---|---|---|---|---|
| 61 | 61 | 12 | [2, 4, 5, 6, 8, 9] | [12] |
| 64 | 64 | 12 | [2, 3, 6, 7, 10, 11] | [12] |
| 67 | 67 | 13 | [2, 3, 5, 6, 8, 11] | [13] |
| 72 | 72 | 14 | [2, 26, 35, 38, 47, 71] | [14] |
| 79 | 79 | 15 | [4, 5, 7, 9, 12, 14] | [14] |
| 80 | 80 | 15 | [7, 27, 34, 47, 54, 74] | [14] |
| 89 | 61 | 17 | [28] | [16] |

Best quadratic rule g(d) = a d^2 + b d over all (a, b), exact max |D| (n = 13..42):

| n | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 | 36 | 37 | 38 | 39 | 40 | 41 | 42 | 43 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| k | 3 | 3 | 4 | 4 | 4 | 4 | 4 | 5 | 5 | 5 | 5 | 5 | 6 | 6 | 6 | 6 | 7 | 7 | 7 | 7 | 7 | 7 | 8 | 7 | 8 | 8 | 8 | 8 | 9 | 9 | 9 |
| (a,b) | 0,2 | 0,2 | 4,0 | 0,2 | 0,2 | 0,2 | 0,2 | 5,4 | 0,2 | 0,2 | 0,2 | 0,2 | 0,2 | 0,2 | 0,2 | 0,2 | 0,9 | 0,14 | 0,2 | 0,2 | 0,2 | 0,2 | 0,17 | 0,2 | 0,2 | 0,2 | 0,2 | 0,2 | 0,5 | 0,2 | 0,2 |
| k_max | 3 | 3 | 4 | 4 | 4 | 5 | 5 | 5 | 6 | 5 | 6 | 6 | 6 | 6 | 7 | 7 | 7 | 7 | 8 | 8 | 8 | 8 |  | 9 |  |  |  | 10 |  |  |  |

### 6.3b Doubling lift (`src/lift.py`)

CRT-style constructions would build a solution at 2m from one at m. The orbits of Z_{2m} over ±d ∈ Z_m are d and m − d. So the natural lift of D is D′ = D ∪ (m − D), with |D′| = 2|D| = n′/4 when |D| = m/4. For every optimal normal form at m = 12, 16, 20, SAT decides whether some g′ makes D′ valid, with no constraint linking g′ to g. Result: m = 12: 5 of 5 distinct D′ UNSAT; m = 16: 9 of 9 UNSAT; m = 20: 14 of 14 UNSAT (each < 60 s). Every lifted D′ is UNSAT, so no doubling construction exists along this route, even with g′ free.

### 6.4 Prescribed-automorphism SAT (`src/cycsym.py`, `src/symscan.py`)

For every nontrivial cyclic subgroup ⟨u⟩ ≤ Z_n^×, SAT searches for (D, g) with e ∈ D and g(e) = u·g(d) + [σ = −1]·e + t, for every d ∈ D, where e = rep(ud) and ud ≡ σe.

- Translation by s changes t by (u−1)s, so only t mod gcd(u−1, n) is tried. The search increases k from ⌊n/5⌋ (120 s cap per call).
- These are honest solutions (re-checked with `cyccheck`). They give lower bounds, and an exact symmetric optimum per subgroup when the next call is UNSAT.
- Forcing D = squares at p = 101 with *free* g (no symmetry) is **UNSAT** (CaDiCaL, 253 s, proof not checked). So the index-4 failure at p ≥ 101 is not an artifact of the symmetric g.

(gen):

Best <u>-invariant solution per n (SAT over all nontrivial cyclic subgroups, search started at k = n/5):

| n | best k | u | ord(u) | k_max / known LB | subgroups tried |
|---|---|---|---|---|---|
| 13 | 3 | 3 | 3 | 3 | 5 |
| 14 | 3 | 9 | 3 | 3 | 3 |
| 15 | 4 | 4 | 2 | 4 | 5 |
| 16 | 3 | 7 | 2 | 4 | 5 |
| 17 | <3 |  |  | 4 | 4 |
| 18 | <3 |  |  | 5 | 3 |
| 19 | 3 | 18 | 2 | 5 | 5 |
| 20 | 4 | 9 | 2 | 5 | 5 |
| 21 | 6 | 4 | 3 | 6 | 7 |
| 22 | <4 |  |  | 5 | 3 |
| 23 | <4 |  |  | 6 | 3 |
| 24 | 6 | 5 | 2 | 6 | 7 |
| 25 | <5 |  |  | 6 | 5 |
| 26 | 6 | 3 | 3 | 6 | 5 |
| 27 | <5 |  |  | 7 | 5 |
| 28 | 5 | 13 | 2 | 7 | 7 |
| 29 | 7 | 7 | 7 | 7 | 5 |
| 30 | 7 | 11 | 2 | 7 | 5 |
| 31 | 6 | 5 | 3 | 8 | 7 |
| 32 | 6 | 15 | 2 | 8 | 7 |
| 33 | 7 | 10 | 2 | 8 | 7 |
| 34 | <6 |  |  | 8 | 4 |
| 35 | 8 | 6 | 2 |  | 11 |
| 36 | 7 | 17 | 2 | 9 | 7 |
| 37 | 9 | 10 | 3 | ≥9 | 8 |
| 38 | 9 | 7 | 3 |  | 5 |
| 39 | 9 | 14 | 2 |  | 11 |
| 40 | 9 | 9 | 2 | 10 | 11 |
| 41 | 10 | 10 | 5 | ≥10 | 7 |
| 42 | 9 | 13 | 2 | ≥10 | 7 |
| 43 | 9 | 6 | 3 |  | 7 |
| 44 | 8 | 21 | 2 |  | 7 |
| 45 | 10 | 19 | 2 |  | 11 |
| 46 | <9 |  |  | ≥11 | 3 |
| 47 | <9 |  |  | ≥11 | 3 |
| 48 | 11 | 17 | 2 | ≥11 | 11 |
| 49 | 9 | 18 | 3 | ≥11 | 7 |
| 50 | <10 |  |  | ≥11 | 5 |
| 51 | 11 | 16 | 2 |  | 9 |
| 52 | 10 | 25 | 2 | ≥12 | 1 |
| 53 | 13 | 10 | 13 | ≥12 | 3 |

## 7. Timings and runs

- Enumeration: n ≤ 32 took < 5 min each (n = 30: 285 s, 49909 orbits).
  - n = 34 was stopped at the 2400 s cap while still finding new orbits.
  - n = 33 and n = 36 completed with the unit/nounit case split (580 s and 928 s). The final UNSAT call is the expensive part. A first unsplit attempt stalled after the last solution and was stopped.
- Coset scans: a single-coset scan of one (p, r) takes well under a second for p ≲ 3000 (p = 199, r = 6, with full re-check: 0.26 s). The r = 8/10/12 scans to p ≈ 5000–12000 took minutes each.
- Linear-rule exact max: < 2 s per n up to 90, then minutes (n ≥ 100 runs into the 900 s cap).
- Symmetric scan: about 1–10 min per n.

## 8. Literature check (Step 5)

Quick web searches ("Erdős problem 810", "rainbow C4 cyclic/Cayley colouring", "local anti-Ramsey C4", "strong chromatic") found:

- erdosproblems.com/810 lists the problem as **open** (BEGS 1989 believed the answer is no). It notes the P4 analogue is false and that Sárközy–Selkow handled other bipartite graphs, but not complete bipartite ones such as C4.
- Krop–Krop: an n-colour construction for K_{n,n} where every C4 gets ≥ 3 colours. This is weaker than rainbow.
- arXiv 2606.30505 (2026) studies the BEGS maximal anti-Ramsey functions for P4, via strong chromatic index / induced matchings.
- No prior cyclic or Cayley construction with every C4 rainbow was found. The affine-oriented-Cayley form of §6.1 and the 4-AP obstruction of §6.3 did not turn up either; I have not checked deeper.

Sources: https://www.erdosproblems.com/810 , https://ar5iv.labs.arxiv.org/html/1905.10584 , https://arxiv.org/pdf/2606.30505 , https://www.dmgt.uz.zgora.pl/publish/pdf.php?doi=1710

## 9. Code (`src/`)

| file | purpose |
|---|---|
| `cyccheck.c` | fast checker for (n, D, g): all closed walks through 0 |
| `explicit_check.py` | independent explicit-graph checker (all 4-cycles via common neighbours) |
| `cert_check.py` | simplest checker for `certs.json` edge lists |
| `cycenum.py` | SAT enumerator of all optimal (D, g) up to G; optional unit/nounit case split |
| `verify_enum.py` | re-checks every enumerated normal form with both checkers |
| `stats.py`, `dclasses.py`, `polyfit.py`, `gfit.py`, `sidon.py` | structure tests (§5) |
| `forb.c`, `maxD.py`, `scanrule.py`, `linscan.py` | fixed rule g on all orbits → exact max D via SAT (§6.3) |
| `forbcell.c`, `cellmax.py` | coarse-grained (cell) version of the above, used to show every cell is self-forbidden under g = 2d |
| `cycsym.py`, `symscan.py` | prescribed-automorphism SAT (§6.4); `cycsym.py n 1 0 T squares` forces D = squares |
| `quartic.py`, `coset.c`, `coset2.c`, `rules.py`, `cosetscan.py`, `scan_r.sh`, `bestr.sh`, `best2.sh`, `collect_rules.py` | coset rules (§6.2) |
| `make_tables.py`, `summ.py`, `symsumm.py` | tables |

Binaries are built with `gcc -O2 -o src/X src/X.c` and are git-ignored. Raw logs are in `runs/` (large `enum_*.json` and `*.log` are git-ignored; their content is in `solutions/`).

## 10. Surprises and next steps

- **Surprise:** the multiplier-invariant optimum at n = 29 is a single coset of the order-7 subgroup. The resulting rule reaches (p−1)/4 for five primes and gives the best cyclic colourings known at n = 53 and n = 61. It then dies at p = 101 even with free g on D = squares (UNSAT).
- **Surprise:** k_max(n)/n > 1/4 happens exactly where the optimum is unique (18, 21, 31). This is consistent with a "random CSP near threshold" picture rather than an algebraic one.
- **Discrepancy:** `tasks/CYC.md` has k_max(14) = 4, but CONSTR's JSON and this enumeration give 3.
- Next steps:
  1. Finish n = 34, and enumerate n = 40 at k = 10 (started, see `runs/enumcase_n40_*`) and n = 44 at k = 11, using the `unit2:e` split in parallel, to test whether the orbit count at k = n/4 keeps falling.
  2. Check whether the orbit counts at k = n/4 keep falling at n = 40, 44 (CYC agents).
  3. Try to prove the coset-rule death rate (character sums for the pattern count).
  4. Extend the Szemerédi obstruction from linear g to "piecewise linear" or Bohr-set-structured rules. Every rule tried so far fails in a way that could be explained by such a density argument.
