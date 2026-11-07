# Erdős Problem 810 in Lean 4

A Lean 4 formalisation of [Erdős Problem #810](https://www.erdosproblems.com/810):

> Does there exist some $\epsilon>0$ such that, for all sufficiently large $n$, there exists a
> graph $G$ on $n$ vertices with at least $\epsilon n^2$ many edges such that the edges can be
> coloured with $n$ colours so that every $C_4$ receives $4$ distinct colours?

The problem is open. Burr, Erdős, Graham and Sós [BEGS89] believed that the answer is no.

The statements follow the conventions of
[google-deepmind/formal-conjectures](https://github.com/google-deepmind/formal-conjectures), so
they can be submitted there.

## Files

| File | Contents |
| --- | --- |
| `Erdos810.lean` | The problem and its variants (`max_anti_ramsey`, `max_rainbow_edges`, `path_four`, `connected_bipartite`, `sarkozy_selkow`, `brown_erdos_sos_seven_four`). |
| `AntiRamsey.lean` | The definitions the statements use, including the $C_4$-conflict graph `c4ConflictGraph`, with proved lemmas. |
| `BruteForce.lean` | Self-contained module (verified locally with Lean `v4.24.0` and Mathlib `v4.24.0` via `lake env lean`) proving exact finite values $M(0)\dots M(6)$ and lower-bound certificates $M(7)\dots M(12)$ with `decide`. |
| `Audit.lean` | Fails the build if a result listed as proved depends on `sorry`. |
| `search/` | `erdos810_search.py` and `results.json` for exhaustive stabilizer-reduced brute-force and CaDiCaL SAT verification through $n = 12$. |

## Statements

| Lean name | Statement | Status |
| --- | --- | --- |
| `erdos_810` | The question above. | open |
| `erdos_810.variants.max_anti_ramsey` | The same question as $\chi_S(n, \epsilon n^2, C_4) \le n$. | open |
| `erdos_810.variants.max_rainbow_edges` | The same question as $M(n) \ge \epsilon n^2$. | open |
| `erdos_810.variants.path_four` | With $P_4$ in place of $C_4$, the answer is no. | solved [BEGS89] |
| `erdos_810.variants.path_four_tendsto` | $\chi_S(n, \epsilon n^2, P_4) / n \to \infty$. | solved [BEGS89, Thm 6.3] |
| `erdos_810.variants.connected_bipartite` | Is $\chi_S(n, \epsilon n^2, L) / n \to \infty$ for every connected bipartite $L$ that is not a star? | open [BEGS89, §8] |
| `erdos_810.variants.sarkozy_selkow` | Yes, if $L$ is also not complete bipartite. | solved [SaSe06, Thm 4] |
| `erdos_810.variants.brown_erdos_sos_seven_four` | $M(n) \ge c \cdot g(n; 7, 4)$ for some $c > 0$. | solved [BEGS89, p. 273] |

Here $\chi_S(n, e, H)$ is the least number of colours for which some graph with $n$ vertices and
$e$ edges has an edge colouring in which every copy of $H$ gets distinct colours on its edges.
In Lean it is `SimpleGraph.maxAntiRamseyNumber`. It is not the anti-Ramsey number $\mathrm{AR}(n, H)$.
Similarly, $M(n)$ (`Erdos810.maxRainbowC4Edges n`) is the maximum number of edges in an $n$-vertex
graph admitting an $n$-colouring in which every $C_4$ is rainbow.

Solved asymptotic results from the literature are stated, not proved.

## Proved in this repository

- `erdos_810.test.max_anti_ramsey_iff` and `erdos_810.test.max_rainbow_edges_iff`: the formulations via $\chi_S(n, \lceil \epsilon n^2 \rceil, C_4) \le n$ and $M(n) \ge \epsilon n^2$ are equivalent to `erdos_810`.
- `SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff`: a colouring is rainbow for $C_4$
  exactly when every 4-cycle $a b c d$ gets four distinct colours.
- `SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff_c4ConflictGraph`: a colouring is rainbow for $C_4$
  iff it is a proper vertex colouring of the $C_4$-conflict graph `c4ConflictGraph G` ($Q(G)$).
- `SimpleGraph.maxAntiRamseyNumber_le_iff`: "exactly $e$ edges" and "at least $e$ edges" give the
  same value of $\chi_S$ whenever $e \le \binom{n}{2}$.
- `erdos_810.test.cycleGraph_four`: $C_4 \cong K_{2,2}$, and it is connected, bipartite and not a
  star. So the Sárközy-Selkow theorem does not cover it.
- `erdos_810.test.pathGraph_four`: $P_4$ satisfies the hypotheses of the Sárközy-Selkow theorem.
- In `BruteForce.lean` (kernel-checked with `decide` and audited with `#assert_no_sorry`):
  - Exact values $M(0) = 0$, $M(1) = 0$, $M(2) = 1$, $M(3) = 3$, $M(4) = 5$, $M(5) = 7$, $M(6) = 11$ (`maxRainbowC4Edges_zero` .. `maxRainbowC4Edges_six`).
  - Lower bounds $M(7) \ge 14$, $M(8) \ge 17$, $M(9) \ge 23$, $M(10) \ge 30$, $M(11) \ge 34$, $M(12) \ge 40$ (`fourteen_le_maxRainbowC4Edges_seven` .. `forty_le_maxRainbowC4Edges_twelve`).

## Formalisation choices

- A colouring with $n$ colours is an edge labelling `G.EdgeLabeling (Fin n)`, so at most $n$
  colours are used. For large $n$ this is the same as exactly $n$ colours.
- A $C_4$ in $G$ is any copy of `cycleGraph 4`, that is, an injective homomorphism. It need not be
  induced, as in [BEGS89].
- $\chi_S(n, e, H)$ uses exactly $e$ edges, as in [BEGS89]. If no graph on $n$ vertices has $e$
  edges, its value is $0$. Every statement that uses $\chi_S$ assumes $\epsilon < 1/2$, so this
  case only occurs for finitely many $n$.

## Building

The project uses Lean `v4.33.1` and Mathlib `v4.33.1`, the same versions as formal-conjectures.
It depends on formal-conjectures at a pinned commit for `answer()` and the `category` and `AMS`
attributes.

```bash
lake exe cache get
lake build
```

## Moving the files upstream

- `AntiRamsey.lean` goes to
  `FormalConjecturesForMathlib/Combinatorics/SimpleGraph/AntiRamsey.lean`, listed in
  `FormalConjecturesForMathlib.lean`.
- `Erdos810.lean` goes to `FormalConjectures/ErdosProblems/810.lean`. Its imports become
  `public import FormalConjecturesUtil`.

## Not formalised yet

- The observation of [BEGS89] that $\chi_S(n, c \cdot g(n;7,4), C_4) \le n$ for some $c > 0$, where
  $g(n;7,4)$ is the largest number of triples on $n$ points with no 7 points spanning 4 triples.
  This links #810 to [Problem 1178](https://www.erdosproblems.com/1178).
- The upper bound $\chi_S(n, c \, n \, r_3(n), P_4) \le n$ from [BEGS89, Thm 6.3].
- A proof of the $P_4$ case. Mathlib has the triangle removal lemma it would need.

## References

- [BEGS89] S. A. Burr, P. Erdős, R. L. Graham and V. T. Sós, *Maximal anti-Ramsey graphs and the
  strong chromatic number*. J. Graph Theory 13 (1989), 263-282.
- [SaSe06] G. N. Sárközy and S. M. Selkow, *On an anti-Ramsey problem of Burr, Erdős, Graham, and
  T. Sós*. J. Graph Theory 52 (2006), 147-156.
