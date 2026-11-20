# Literature check (2026-10-25)

Scope: what is already known about M(n), the largest number of edges of an n-vertex
graph whose edges can be coloured with n colours so that every 4-cycle is rainbow.
I also checked whether small values or the cyclic constructions have appeared before.

## Burr, Erdős, Graham, Sós (1989)

*Maximal anti-Ramsey graphs and the strong chromatic number*, J. Graph Theory 13 (1989),
263–282. I read the author copy at users.renyi.hu/~sos via its text layer.

- They define χ_S(n, e, L) as the least number of colours needed to colour some n-vertex,
  e-edge graph so that every copy of L is totally multicoloured. M(n) is the largest e with
  χ_S(n, e, C4) ≤ n.
- On C4, §6 gives a construction through triple systems: χ_S(n, c·g(n;7,4), C4) ≤ n.
  They note that it is not known whether g(n;7,4) = o(n²). Even if it were, "it is
  conceivable (but unlikely)" that χ_S(n, εn², C4) ≤ n for small ε.
- In §8 (open questions) they call C4 "one of the most vexing questions". In the two densest
  ranges of their Table 1, χ_S(n, e, C4) is known only to within a factor of about n.
- For P4, Theorem 6.3 shows χ_S(n, c·n·r3(n), P4) ≤ n via Ruzsa–Szemerédi, and
  χ_S(n, εn², P4) > cn for every c once n is large (that is, /n → ∞; checked against the text of (6.4)).
- The closing note links the topic to Berkowitz's question about S ⊂ GF(2)^{3n} with
  x + y + z = 0. That is the sum-colouring idea Tao revisits on the forum.
- **No exact small values, tables of small n, computer searches or cyclic constructions for
  C4 appear.** The formulas in the scan are images; the surrounding text was read.

## Sárközy, Selkow (2006)

*On an anti-Ramsey problem of Burr, Erdős, Graham, and T. Sós*, J. Graph Theory 52
(2006), 147–156. Theorem 4 in the authors' WPI report proves
χ_S(n, αn², L)/n → ∞ for each fixed α > 0 and connected, non-complete bipartite L.
The sentence following the theorem explicitly leaves C4 = K_{2,2} open. This source
and its hypotheses were checked on November 20. [Authors' report, PDF page 3](https://ftp.cs.wpi.edu/pub/techreports/pdf/04-02.pdf#page=3)

## erdosproblems.com #810 (T. F. Bloom) and its forum thread

The problem is listed as open (last edited 1 April 2026). The forum thread has 9 comments:

- **T. Tao, 7 Dec 2025.** A negative answer would imply a finite-field Ajtai–Szemerédi
  theorem (dense subsets of F_2^d × F_2^d contain squares) via the colouring
  (a, b) ↦ a + b. Other colouring schemes give other theorems.
- **M. Sawhney, V. Kovač, 7–8 Dec 2025.** They discuss the reduction to the (7,4) problem.
  M. Bucić notes (1 Apr 2026) that this reduction is already in BEGS89.
- **T. Tao, 11 Dec 2025.** AlphaEvolve found dense n-coloured graphs on {0, …, n−1} with all
  C4 polychromatic, for n = 4..25. The edge counts are 5, 7, 11, 14, 17, 23, 30, 34, 40,
  47, 54, 62, 69, 77, 85, 94, 103, 112, 123, 133, 143, 155. He notes there is no guarantee of
  optimality and suggests **SAT-solver work to find exact optimal values for an OEIS
  submission**. His examples file (terrytao.wordpress.com/wp-content/uploads/2025/12/examples.txt)
  returned HTTP 403 to our fetch. The AlphaEvolve problems repository
  (google-deepmind/alphaevolve_repository_of_problems) has no #810 experiment.

## OEIS

There is no match for 1,3,5,7,11,14,17,23 or for 1,3,5,7,11,14,17,23,30,34,40 (searched
2026-10-25).

## Recent arXiv work in the BEGS framework (none is about C4)

- M. Bucić, K. Chen, J. Ma, *On a maximal anti-Ramsey conjecture of Burr, Erdős, Graham,
  and Sós*, arXiv:2603.18952 (March 2026). Covers odd cycles C_{2k+1}, k ≥ 4.
- For the four-vertex path, Li, Ning and Xie disprove the proposed quadratic color
  lower bound when the complete graph is missing about n^(2−ε) edges and 0 < ε < 1/2.
  Yang proves the lower bound for ε ≥ 1/2. Both papers concern P4.
  [Li–Ning–Xie](https://arxiv.org/abs/2606.30505) · [Yang](https://arxiv.org/abs/2607.05896)

## Consequences for the note

1. **Exact values.** M(10) = 30, M(11) = 34 and M(12) = 40, together with the exactness of
   M(n) for n ≤ 9, answer Tao's request: AlphaEvolve's values for n ≤ 12 are optimal.
2. **Lower bounds.** Ours improve AlphaEvolve's for every n from 14 to 25 and match it at
   n = 13. They are new for n = 26..128.
3. **Cyclic orbit colourings.** I found no prior source for them. The proposition that linear
   rules give o(n) orbits is in the spirit of Tao's remark that colouring schemes yield
   Szemerédi-type statements; cite that remark.
4. **To do before submission.** Read BEGS91 (*Further results on maximal
   anti-Ramsey graphs*, Kalamazoo proceedings, 1991) in full. Ask on the
   forum or OEIS whether anyone has computed exact values.
