# Derivations for the structured families (task CONSTR)

Throughout, a colouring is valid iff every 4-cycle (as a subgraph) gets 4 distinct colours.

## F1. Sum-set colouring on Z_n (exact)

Vertices Z_n. Edge {i, j} (i ≠ j) iff i + j ∈ S. Colour i + j ∈ Z_n, so n colours.

*Adjacent edges never clash:* i + j = i + k forces j = k. So a 4-cycle a-b-c-d-a is bad iff
an opposite pair has equal colour. Say a + b = c + d = s. Write t = b + c and u = d + a. Both
are in S because both are edges. Then t + u = 2s and t − s = c − a =: D ≠ 0, so
{s − D, s, s + D} ⊆ S.

*Conversely,* let s, s ± D ∈ S with D ≠ 0. Pick a ∈ Z_n and set c = a + D, b = s − a and
d = s − c. The edges ab, bc, cd and da have sums s, s + D, s and s − D, all in S. The four
vertices are distinct iff 2a ∉ {s, s − D, s − 2D}. The image of x ↦ 2x has size n (n odd) or
n/2 (n even), so for n ≥ 8 such an a exists. The 4-cycle then repeats colour s.

**Validity condition (n ≥ 8):** S contains no triple s − D, s, s + D with D ≢ 0 (mod n).
Wrap-around progressions count. For even n, D = n/2 gives s − D = s + D, so s and s + n/2
cannot both lie in S.

**Edge count:** |E| = Σ_{s∈S} w(s), where w(s) is the number of pairs {i, s − i} with
2i ≠ s:
- n odd: w(s) = (n − 1)/2;
- n even, s odd: w(s) = n/2;
- n even, s even: w(s) = n/2 − 1.

So F1 is a weighted cyclic 3-AP-free set problem, and |E| ≈ r_3(Z_n)·n/2. Behrend gives
n^(2−o(1)) but o(n²) by Roth. We solve it exactly with weighted MaxSAT (RC2):
- one hard clause per 3-AP;
- translation symmetry fixes 0 ∈ S (n odd), or 0 ∈ S or 1 ∈ S (n even, where translations
  must be even to preserve weights).

Every optimum is regenerated and re-checked as an explicit graph by `check.py`.

## F2. Sum colouring with a free edge set (group A of order n)

Same colouring c(i, j) = i + j in an abelian group A (Z_n, or Z_p^k = (F_q, +)), but every
pair may be kept or dropped. Colour classes are matchings {x, s − x}, so only opposite edges
can clash. Bad configurations are 4-cycles a-b-c-d with a + b = c + d.

Maximising the edge set is a 4-uniform hypergraph independent-set problem. Exact MaxSAT did
not finish even at n = 12 in 10 minutes, so we use local search: `ls` with one allowed colour
per pair. Cayley graphs with i − j ∈ ±S coloured by i + j are a subfamily.

## F3. Cyclic orbit colourings

Vertices Z_n. For each d ∈ D ⊆ {1, …, ⌈n/2⌉ − 1}, add all n edges {i, i + d} with colour
i + g(d) mod n. The colouring is invariant under rotation: rotation shifts colours by 1.

d = n/2 is excluded for even n: the edge {i, i + n/2} would need colours i + g and i + n/2 + g
at once.

|E| = n·|D|. We search (D, g) by annealing (`cyc`), with the target |D| raised whenever a
valid assignment is found.

## F4. Bipartite affine colourings over F_q (q prime here)

Rows F_q (vertices 0..q−1) and columns F_q (vertices q..2q−1). Colour a ∈ F_q^× is the
partial matching x ↦ ax + β(a) on its support D_a, so there are q − 1 colours on n = 2q
vertices.

We fix β ∈ {0, a², a³, a^(−1), random} and choose the supports by local search: `ls` with the
allowed colours of pair (x, y) equal to {a : ax + β(a) = y}. For n = 2q + k the best affine
example is padded with k isolated vertices and handed to the general local search.

## F5. BEGS construction from (7,4)-free triple systems

Let T be a linear triple system on [n] such that no 4 triples span ≤ 7 points. For each triple
{a < b < c}, put the edge ab with colour c. Linearity makes the edges distinct.

Take a 4-cycle v1v2v3v4. Its edges come from 4 distinct triples, whose union is
{v1, …, v4} ∪ {c1, …, c4}. If two colours coincide, the union has ≤ 7 points, a
contradiction. So the colouring is valid, M(n) ≥ |T|, and therefore M(n) ≥ g(n; 7, 4) for
the linear version.

T is built by randomised greedy. The (7,4) test is a DFS that only adds triples meeting the
current union. This is complete because 4 linear triples on ≤ 7 points always form a
connected hypergraph:
- if one triple were isolated, the other 3 would lie on ≤ 4 points, which is impossible for
  linear triples;
- a 2 + 2 split needs ≥ 10 points.

We then allow all three pairs of every triple, each with the remaining point as colour, and
run local search seeded with the one-edge-per-triple graph.

## F6. Vertex addition and deletion

- *Addition:* best(n − 1) plus an isolated vertex, then local search.
- *Deletion:* best(n + 1) minus a minimum-degree vertex. If colour n is still used, drop the
  edges of the rarest colour r and rename colour n to r. Then run local search.
