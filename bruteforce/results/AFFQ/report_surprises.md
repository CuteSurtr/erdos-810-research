**1. β = 0 is exactly the square-free problem on a torus.** Row 0 and column 0
can carry only one edge, (0,0), and it lies on no 4-cycle. On the nonzero rows,
write x = g^i and y = g^j. Then colour a = g^(j−i), and a bad 4-cycle is exactly
an axis-parallel square {i, i+d} × {j, j+d} with d ≠ 0 in Z_n², where n = p − 1.
Hence

  m_max(β=0, p) = 1 + sq(p − 1),  sq(n) = max size of a square-free subset of Z_n².

Checks:
- The clause counts equal the torus square counts: 20, 81, 425, 756 for
  p = 5, 7, 11, 13.
- `torus_squares.py` gives sq(4) = 10 and sq(6) = 21, matching m = 11 and 22.

A square-free set in Z_n² lifts to a square-free set in [0,n)². By the
Furstenberg–Katznelson multidimensional Szemerédi theorem, sq(n) = o(n²).
So the β = 0 family has m = o(p²), with arbitrary supports. This is a
short-proof observation relying on a standard theorem. It is not a
machine-checked result, and its rate is very weak. It also explains the huge
nauty group for β = 0: it contains the torus translations and dihedral maps
together with the unit multipliers.

**2. 1/a and a² are the same problem.** The map (x,y) ↦ (y, −x) with
a ↦ −1/a carries one family onto the other. The values agree for every p, as
they must.

**3. The best values hardly depend on β once p ≥ 17.**
- At p = 19 the four families give 156, 156, 156 and 157.
- At p = 101 they lie within 1%.

The local optimum seems to be governed by clause counts rather than by the
algebra of β. This is heuristic, since only lower bounds are known there.

**4. The local search is not optimal even at p = 13.** For β = a³, two methods
stopped at 76: the LS, and the CP-SAT optimiser with a 900 s limit. The decision
run "m ≥ 77" found 77 in about 25 s. Round 2 of the LS, with three times the
iterations and a restart from the best, gained 0.5–2% at p ≥ 29. Treat every
p ≥ 17 entry as a lower bound with an unknown gap.

The only upper bounds there are trivial: the distinct-points count, which is
(p−1)(p+2)/2 for a² and about 0.5p². CP-SAT bounds after 500 s of decision search
were no better. "Best + 1" decision runs for p = 17, 19, 23 all returned UNKNOWN
after 500 s each.

**5. Optimal and best supports look random.**
- Sizes cluster around the mean, about ±20%. Mean |D_a|/p is 0.49 at p = 13,
  0.41 at p = 31, 0.35 at p = 61 and 0.30 at p = 101.
- At most 2 supports per configuration at p ≤ 13, and none at p ≥ 31, are
  nontrivial arithmetic progressions (dilated intervals).
- No support is a multiplicative coset, even with 0 added.
- The number of 3-term APs inside each D_a is 0.98–1.09 times the random
  expectation, so the supports are neither AP-free nor AP-rich.
- For a² and a³, 30–47% of the colours use row 0. For β = 0 only one
  colour can.

There is one non-random feature. The occupancy of the symmetry orbits
{(ra, r^k x)} is very uneven: for a² at p = 31, between 1 and 22 of 30 possible.
Even so, fully orbit-invariant configurations are clearly worse; the best
symmetric configuration at p = 13 has 75 edges, against 77 overall.

**6. Comparison with the notes.**
- The common-support bound p²·exp(−c(log p)^(1/12)) and the quadratic
  common-potential bound O(p^(2−1/32)) are almost flat for p ≤ 101. For example,
  p^(−1/32) only falls from 0.95 to 0.87.
- The data cannot distinguish those rates.
- The best values here fall like p^(−0.2), between the random-deletion floor
  p^(−1/3) and the flat theoretical ceilings.
- Nothing seen contradicts m = o(p²) for arbitrary supports. Nothing proves it
  either, except in the β = 0 case of item 1.

**7. No new bounds for M(n).**
- m/(2p)² is at most 0.122, reached at p = 11 for β = a³ and β = 0.
- The general constructions in the README reach about 0.24–0.30 n².
- At n = 14, 22 and 26 the affine values 23, 59 and 78 sit far below the README
  bounds: M(14) ≥ 53, M(22) ≥ 121, and M(25) ≥ 152 at n = 25.
- The certificates are valid but weak lower bounds for M(2p), up to
  M(202) ≥ 3073 (β = a³).

**Next steps and sharding plans.**

(a) **β = a³, p = 13: is 77 optimal? The known bound is 77 ≤ m ≤ 78.** Run
`python3 decide.py a3 13 78 <secs> <workers> <s>` for each shard
s = |D_1| ∈ {7, …, 12}. |D_1| is a largest support, so these shards cover the
whole search; s = 13 is INFEASIBLE in 0.01 s.

Measured with 1 worker on a loaded 4-core VM:
- s = 12 and s = 11: UNKNOWN after 1500 s each.
- s = 10, 9, 8, 7: also UNKNOWN after 1500 s each.
- Unsharded, 2 workers: UNKNOWN after 3600 s.
- RC2, unsharded: no answer in 30 min.

A finer split is the next step. Fix D_1 up to the stabiliser, which is trivial
here, so there are C(13, s) shards per s, each much smaller. Alternatively, use
the sizes of the two largest supports.

(b) **β = 0, p = 11: m ∈ [59, 65], so sq(10) ∈ [58, 64].** Solve the torus
problem directly, with breaking for translations, the dihedral group and
multipliers. The torus group has order about n²·8·φ(n). Shard on the size of
the largest row.

(c) Exact p = 17 for a²/1/a needs a better method. RC2 gave no answer in 40
min, and CP-SAT "≥ 127" was UNKNOWN after 500 s.

(d) A real upper-bound method for mid-range p would let the trend be tested.
Candidates are a Lovász-theta or SDP bound on the conflict hypergraph, or a
flag-algebra-style local counting argument.
