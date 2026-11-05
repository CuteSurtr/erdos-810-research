# Independent checks of the cube-restricted counting argument

18 October 2026. This is a mathematical proof check, not formal verification or a claim of historical priority.

The geometric argument in [rational-expander-cover-proof.md](rational-expander-cover-proof.md), the counting extension in [partial-rational-expansion-independent-audit.md](partial-rational-expansion-independent-audit.md), and the transfer in Section 8 of [common-potential-combinatorics.md](common-potential-combinatorics.md) are compatible and pass the checks below.

## Geometry

For $K(x,y)=xy(x+y)/(x^2+y^2)$, direct differentiation gives the derivatives recorded in the geometric note. At $(x_1,x_2,y_1,y_2)=(1,2,1,3)$, the Jacobian determinant of the ordered outputs $(K_{11},K_{12},K_{21},K_{22})$, with the input coordinates in that order, is

```math
\frac{1512}{105625}\ne0.
```

Thus the four-output grid map is dominant and generically finite in characteristic zero. The generic fibre of $K$ is a geometrically integral conic after reciprocating coordinates. Every target value, including zero and infinity, has a multiplicity-one nonvertical and nonhorizontal divisor in its fibre.

After taking normal closures, an intersection between a separate-input-cover field and a target-cover field is Galois. Each target inertia group must act trivially on that intersection, because the separate input covers are unramified at the chosen multiplicity-one fibre divisor. These inertia groups normally generate the target Galois group: their quotient would be a nontrivial finite étale cover of the projective line in characteristic zero. This proves the required linear disjointness.

For

```math
G(x,y)=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)},
```

the divisor $y=\omega x$, where $\omega$ is a primitive cube root of unity, has $\operatorname{ord}(G)=1$ and $K(x,\omega x)=\omega^2x$. All three coordinate maps vary along that divisor, so every separate $x,y,z$ cover is unramified there. The valuation of $G$ remains one after their compositum; hence $G$ is not a cube in that field. This verifies the additional Kummer irreducibility. The divisor may be excluded from the actual configuration open set without invalidating this function-field valuation argument.

The use of characteristic-zero ultraproducts is material: no unproved reduction of arbitrary positive-characteristic covers to separable covers is needed.

## Counting extension

The original statements and proofs of Tao's Theorems 25, 35, 38, and 40 were checked against the [primary paper](https://arxiv.org/pdf/1211.2894). The cube predicate is retained as an existence indicator throughout. Outside the exceptional locus of the generically finite grid map, the number of admitted grid points is a bounded integer-valued definable function. Regularity applied to its finitely many level sets gives the required fourth-order bound. No assertion that the fourfold cube-cover variety is irreducible is used.

The two Cauchy–Schwarz inequalities then give the within-cell discrepancy

```math
O\!\left(p^{15/16}\sqrt{|X||Y|}\right).
```

Positivity of every input cell is a separate step. Finite-witness descriptions of a linear-size definable curve set provide a geometrically irreducible curve cover whose rational-point image is contained in that set. Redundant identically zero witness equations may first be discarded. The separate-cover and cube-cover irreducibility give a geometrically integral surface; Lang–Weil and bounded projection fibres contradict a zero-density regularity cell.

There are only finitely many cells, so the least positive cell density is a positive standard constant, independent of the arbitrary subsets. Summing their estimates gives a mass error $O(p^{7/4})$, and then an output-count error $O(p^{3/4}|Z|)$. This is absorbed by the displayed discrepancy whenever $|X||Y|\ge p^{15/8}$. In the remaining range the proposed lower bound is vacuous after enlarging its error constant. The simultaneous failing-sequence argument in the counting note establishes uniform finite-prime constants $c,C>0$.

Consequently, for two disjoint comparable subsets of $H$ and target $H$, the number of nondegenerate configurations is at least

```math
c\frac{|H|^3}{p}-C p^{15/16}|H|.
```

The disjointness removes $x=y$. The remaining exceptional ratios force a zero potential, a pole, or $G=0$, and have already been excluded by the definition of the relation.

## Graph transfer and scope

Each fixed omitted incidence appears in at most sixteen configurations: the four possible roles each reduce to a nonconstant rational equation of degree at most four. Each omitted color appears in at most $3p$ configurations. These explicit multiplicity bounds preserve the actual selected supports, even when the completed eligible incidence system is not proper.

For a simple proper B-coloring with $D$ missing colors and $R$ missing eligible incidences, the resulting bound is

```math
m\ll p^{63/32}+p^{4/3}(R+pD)^{1/3}.
```

Thus a full palette has a power saving for arbitrary common $H$, and $D=o(p)$, $R=o(p^2)$ still imply $m=o(p^2)$. The argument does not handle an arbitrary positive-density palette: the three palette tests remain coupled and are not separate $x,y,z$ curve constraints. No unrestricted Erdős problem #810 conclusion follows.
