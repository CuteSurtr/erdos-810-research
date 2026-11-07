### n = 44, k = 11 (= n/4): cube-and-conquer

**Soundness of the split.** The split is on the presence p(1) of orbit 1, then p(2), p(3), p(4). The 9 cubes {p1 = 0} ∪ {p1 = 1} × {±p2} × {±p3} × {±p4} cover every assignment. So the instance is UNSAT iff every cube is UNSAT.

**The p1 = 0 cube.** Under the lex-leader constraint, p1 = 0 means no present orbit is a unit mod 44: if a unit u were present, mapping it to 1 would give a lex-larger vector. The non-unit orbits in 1..21 are the 10 even ones plus 11, exactly 11 orbits. So this cube is a single D, and it is UNSAT in 0.3 s.

**Results.** Wall times are from CaDiCaL 1.7.3 runs without a proof. "LRAT" means a separate run of the same cube wrote a proof, checked by `src/lratcheck` (`logs/proofs.txt`, `logs/proofs_cubes.txt`).

| cube (orbit presence) | result | time | proof |
|---|---|---|---|
| ¬1 | UNSAT | 0.3 s | LRAT checked (5193 lemmas) |
| 1, ¬2, 3, 4 | UNSAT | 120 s | LRAT checked (1.1 GB) |
| 1, ¬2, 3, ¬4 | UNSAT | 5.7 s | LRAT checked |
| 1, ¬2, ¬3, 4 | UNSAT | 4.4 s | LRAT checked |
| 1, ¬2, ¬3, ¬4 | UNSAT | 0.3 s | LRAT checked |
| 1, 2, ¬3, ¬4 | UNSAT | 128 s | LRAT checked (1.5 GB) |
| 1, 2, ¬3, 4 | UNSAT | 775 s | solver only (proof unchecked) |
| 1, 2, 3, ¬4 | UNSAT | 1899 s | solver only (proof unchecked) |
| 1, 2, 3, 4 | **UNKNOWN** | 1980 s cap; its sub-cubes ±5 also UNKNOWN at 840 s each | – |

**Status.** k = 11 at n = 44 is **unfinished**. Assuming the two solver-only cubes, any valid (D, g) with |D| ≥ 11 must, in its lex-leader form under the multipliers, contain orbits 1, 2, 3 and 4. This is the only open region. The first-wave runs of the three hard cubes (08:30) died without output around 09:05 and were relaunched at 09:19. **Suggested next step:** split cube {1, 2, 3, 4} on p5..p8 (16 sub-cubes) with ≥ 1 h each and LRAT, and re-prove the two solver-only cubes with LRAT (about 13 min and 32 min).
