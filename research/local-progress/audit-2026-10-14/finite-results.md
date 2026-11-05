# Finite adversarial audit, 14 October 2026

## Conclusions and evidence level

All supplied colored-graph certificates for orders 1 through 25 pass an independent
checker. The order-25 certificate has 152 edges and 2,124 four-cycles, all rainbow.
The checker in `finite_audit.py` enumerates exactly the three undirected cycles on
every four-element vertex set; it imports neither the original cycle enumerator nor
its verification functions. It also checks endpoint/color ranges and edge uniqueness.
Full statistics are in `finite_certificate_audit.json`.

The supplied `search/results.json` labels order 10 as an exact value, but its proof
field only says `lower_kernel_proved`. Its supplied Python upper-bound targets stop
at order 9, and `BruteForce.lean` only proves the order-10 lower bound. Thus exactness
at order 10 was unsupported by the supplied finite proof artifacts alone.

This audit supplies the missing **exhaustive computational** upper bound:

> Every simple graph on 10 vertices with 31 edges has an eleven-vertex clique in its
> four-cycle conflict graph. Therefore it cannot have a rainbow-four-cycle coloring
> using ten colors. Together with the 30-edge certificate, this gives M(10) = 30.

This is an external exhaustive calculation, **not a Lean/kernel theorem**, and no
claim of literature novelty is made. The calculation is reproducible from
`exhaustive.cpp`; the log and hashes are in `exhaustive_n10_m31.log` and
`exhaustive_metadata.json`. It checks 2,735,357 representatives, all excluded by an
eleven-clique; it never needs its coloring backtracker at order 10, size 31.
If a graph had more than 31 edges, restricting to any 31 preserves the coloring,
so exclusion at exactly 31 supplies the upper bound for all larger sizes too.

| Maximum degree | Representatives | All excluded by conflict K11 |
|---|---:|---:|
| 7 | 753,459 | yes |
| 8 | 1,412,156 | yes |
| 9 | 569,742 | yes |
| Total | 2,735,357 | yes |

The original Python checks were replayed through order 9. An independent C++
conflict-graph builder reproduces exactly 4,913 representatives for (n,m)=(8,18),
including 4,907 clique obstructions and six exact coloring obstructions, and 98,939
for (9,24), all conflict-K10 obstructions. The JSON's older order-8 counts differ
from its present script; this does not affect the obstruction conclusion.

There is also a precise correction to the order-7 graph-count interpretation.
`count_n7.py` independently enumerates all 54,264 labeled 15-edge graphs without
symmetry pruning. Exactly 53,844 have a K8 in their conflict graph; exactly 37,569
have conflict independence number at most two; 37,149 satisfy both conditions.
Consequently **only 420 are conflict-K8-free**, all of independence number at most
two. The supplied split 37,569 plus 16,695 is valid when independence obstructions
are counted first and the residual graphs are excluded by cliques. Interpreting
37,569 as the number of K8-free conflict graphs is false. The order-7 extremal
conclusion remains valid. Full counts are in `n7_labeled_counts.json`.

The original Python upper-bound routine was also run at (10,31), beyond its normal
command-line target list. It completed in 476.573 seconds and independently
returned `(2735357, 2735357, 0, 0, ...)`, agreeing with the C++ total and the
all-clique obstruction conclusion. Its cycle-based conflict calculation differs
from the C++ common-neighbor calculation. Both use the same justified canonical
labeling scheme. The extension invocation and output are in
`original_python_n10_m31.log`.

An additional C++ run at (11,35) was stopped after several minutes without a
completed maximum-degree branch or a witness. It supplies no bound or exactness
claim at order 11.

## Why the representative generation covers every graph

Given an arbitrary graph with n vertices and m edges:

1. Choose a maximum-degree vertex as 0, of degree d0. Its degree is at least
   ceil(2m/n), explaining the enumerated range. Label its neighbors 1 through d0.
2. Choose a maximum-degree vertex within N(0) as 1. Write its degree as d1.
   Necessarily d1 <= d0, and every neighbor of 0 has degree <= d1.
3. Among the remaining vertices, form four blocks, in this order:
   N(0) intersect N(1), N(0) outside N(1), N(1) outside N(0), and neither.
   Vertices 0 and 1 are omitted from these blocks. Relabel within each block by
   nonincreasing final degree. This leaves the prescribed first two rows unchanged.
4. The code enumerates every possible size of the first and third blocks, fixes
   the first two adjacency rows, and enumerates every subset in each later row.
   It imposes only the degree bounds and within-block ordering just established.

The degree of the previous row's vertex is final when the next row is generated.
Thus the ordering test compares a proposed final degree with a finalized degree.
Every degree is bounded above by its cap while edges are inserted. Removing an
edge restores both endpoints' degrees and adjacency bits. The last row has no
future edges, so the final ordering check is sufficient there.

The remaining-edge lower bound subtracts the number of pairs entirely beyond the
current row. The upper bound uses the row's available positions, required total,
and remaining allowed degree. The `choose` recursion enumerates increasing lists
of future neighbors and skips a vertex only when its degree cap has already been
reached. Each prune is therefore necessary for the target labeling; none removes
all representatives of an isomorphism class. Duplicate representatives are allowed
and harmless; the count is not a count of isomorphism classes.

## Independent conflict and clique checks

For two incident edges uv and uw, they share a four-cycle exactly when v and w have
a common neighbor different from u. For disjoint edges ab and cd, they share a
four-cycle exactly when either ac and bd are both edges, or ad and bc are both
edges. The C++ checker uses these two conditions, independently of the original
Python's cycle enumeration.

The clique recursion maintains the common-neighbor candidate set of the vertices
already selected. It branches on the smallest candidate and intersects with its
neighbors; failure when fewer than the required number remain is valid. A success
therefore exhibits n+1 mutually conflicting edges. The order-10 conclusion needs
neither the independence-number shortcut nor exact graph coloring.

## A compact cyclic construction replacing the raw order-10 witness

Let vertices be (i,b), where i is modulo 5 and b is 0 or 1. For each color (i,b),
assign that color to these three edges (all subscripts are modulo 5):

* (i,b)—(i+2,b),
* (i+1,b)—(i−1,1−b),
* (i−1,b)—(i,1−b).

This gives 30 different edges and ten colors. The graph is the complement of the
pentagonal prism C5 square K2: within each layer, edges have difference ±2; across
the layers, every pair with distinct indices is an edge. The independently checked
certificate is `cyclic_n10_certificate.json`; it has 95 rainbow four-cycles.

Here is a short proof of the rainbow property. By rotation and layer interchange,
it suffices to consider color (0,0), whose three edges are AB, CD, EF with
A=(0,0), B=(2,0), C=(1,0), D=(−1,1), E=(−1,0), F=(0,1).
These edges are pairwise disjoint. For AB/CD, the two possible opposite-edge
four-cycles are prevented by absent edges AC and BC. For AB/EF they are prevented
by absent edges AE and AF. For CD/EF they are prevented by absent edges DF and DE.
No four-cycle contains two edges of this color, and symmetry proves the claim.

The same formula and proof work modulo every integer k >= 5, on 2k vertices with
2k colors and 6k edges: within-layer differences are ±2, and across-layer
differences are ±1 and ±2. This is only a linear-size construction and does not
advance the quadratic-density question in Erdős #810. Its value here is a concise
checkable construction and an explanation of the order-10 witness.

## Reproduction

```sh
python3 finite_audit.py
c++ -O3 -std=c++17 exhaustive.cpp -o exhaustive
./exhaustive 10 31
```

On the audit host, the default macOS 27 SDK had a linker/SDK mismatch; explicitly
passing `-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX26.5.sdk` compiled
successfully. No source or system configuration changes were needed.
