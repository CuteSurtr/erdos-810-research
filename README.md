# Rainbow four-cycles and Erdős problem 810

Extremal bounds, finite constructions, and affine models for graphs in which every four-cycle uses four different colors.

Lean verifies $M(n)\le(1/4+o(1))n^2$ for the unrestricted graph problem and $g(n;7,4)\le(1/18+o(1))n^2$ for unrestricted triple systems. The latter coefficient is 25% below Gishboliner and Solymosi's $2/27$ for linear systems. Whether either problem admits positive quadratic density remains open. Both proofs are local research results. External review and historical priority are pending. [Graph theorem in Lean](research/hall-reduction/QuarterDensity.lean) · [Triple theorem in Lean](research/hall-reduction/HalfBoundedModel.lean) · [Gishboliner and Solymosi](https://arxiv.org/html/2606.25931v1)

The argument approximates the adjacency matrix by one whose entries lie between zero and one half. For a triple system, its shadow graph also has a local upper bound on triangles. Together the two counts give $1/18$. A sequence attaining this last coefficient would have a shadow approaching three equally large groups, with limiting edge probability one half between groups and zero inside. [Short graph proof](research/graph-limits/quarter-short.md) · [Finite proof and verification](research/graph-limits/finite-model.md) · [Triple-system proof and equality](research/shadow-density/eighteenth.md) · [Finite graph constructions](bruteforce/results/2026-11-20/README.md)

## Setting

Let $`p`$ tend to infinity through odd primes. A color $`a`$ is a partial
affine map $`x\mapsto ax+\beta(a)`$, with one color per nonzero slope.
Assume that the resulting bipartite graph is simple, properly colored,
and every four-cycle is rainbow. Write $`D_a`$ for the actual row domain
of color $`a`$, and $`m=\sum_a|D_a|`$.

## Main results

### Eigenvalues and graph limits

The finite spectral estimate describes a separate obstruction to high edge counts. An edge count above $(1/4+\delta)n^2$ forces a least adjacency eigenvalue below $-c_\delta n$ for all sufficiently large $n$. A positive-density sequence also has positive edge variance in every graphon limit. [Spectral theorem and graph-limit obstructions](research/graph-limits/README.md)

### Neighborhoods in arbitrary graphs

Positive edge density in #810 requires open-neighborhood VC dimension at least a constant times $\log n$. At any fixed dimension $d\ge2$, the graph has $O_d(n^{2-1/(2d)})$ edges. At dimension at most one, the exact leading term is $n^{3/2}/\sqrt e$, and the connected maximum is $n\log n+O(n)$. [Packing and vertex order](research/neighborhood-packing/ordering.md) · [Sharp dimension-one result](research/neighborhood-packing/vc-one.md)

If the vertices can be ordered so that every neighborhood is a union of at most $k$ intervals, the maximum is $\sqrt{k}\,n^{3/2}+O_k(n)$ for fixed $k$. Consecutive windows give the upper bound, and properly colored bipartite bands attain the leading constant. [Sharp interval theorem and constructions](research/interval-neighborhoods/README.md)

Every positive-density example with a linear palette would require matrix rank $\Omega(\sqrt n)$ over every field, for any matrix that is nonzero exactly on its edges. The characteristic-zero matching bound uses a sharp size theorem for fooling-set matrices. [Rank obstruction](research/support-rank/README.md) · [Sharp matrix bound](research/support-rank/fooling-sets.md)

### Random graphs

For the full binomial random graph $G(n,p)$, the threshold order for an $n$-coloring with every four-cycle rainbow is $p=(\log n/n)^{1/3}$. A sparse-neighborhood coloring argument gives existence below a small constant times this scale. Counting possible one-color matchings gives failure above it. [Random-graph theorem and proof](research/random-support/README.md)

### Bounded-VC supports

If the family $`\{D_a\}`$ has uniformly bounded VC dimension, then
$`m=o(p^2)`$, with arbitrary intercepts $`\beta(a)`$. The same conclusion
holds when the color–row incidence bigraph omits a fixed induced
bipartite pattern.

### Nearly common supports

If $`D_a\subseteq X`$ and $`\sum_a|X\setminus D_a|=o(p^2)`$, then
$`m=o(p^2)`$. For polynomial intercepts of fixed degree $`D\ge2`$,

```math
m\le C_Dp^{19/10}+\sqrt{2}\,p\sqrt{\sum_a|X\setminus D_a|}.
```

### Oscillatory affine operators

For $`s\ne0`$ and arbitrary complex weights $`|w(a)|\le1`$, the operator

```math
C_{s,w}f(x)=\sum_{a\ne0}w(a)e_p\!\left(s(a^2x+a^3)\right)f(ax+a^2)
```

satisfies

```math
\|C_{s,w}\|_{2\to2}=O(p^{7/8}).
```

An exact decomposition gives the same bound for the corresponding
two-dimensional crossed operator.

### Fixed-formula quadratic palettes or potential sets

For colors $`y=ax+a^2`$, suppose every color uses a common potential set
$`H`$ through $`ay\in H`$, and all eligible incidences are retained. If
either the palette or $`H\setminus\{0\}`$ is defined by one fixed
ring-language formula, then

```math
m=O_\varphi(p^{2-1/32}).
```

The other set is arbitrary. Parameter values may vary with the prime;
formula complexity and parameter count remain fixed. This includes
fixed-degree polynomial images and fixed-exponent residue conditions.
A fixed-index palette coset is a special case.

A robust version starts from a definable palette or support core of
size at least $`\delta p`$. It permits $`d`$ missing core elements and
$`R`$ omitted incidences in the designated core subsystem:

```math
m\ll_{\varphi,\delta}p^{63/32}+p^{4/3}(R+pd)^{1/3}.
```

All retained edges are counted, including those outside the core. The
precise omission domains and assumptions are in Theorem 5 of the note.
This concerns a specified support model, not unrestricted #810. The
analytic framework and exponent come from Tao's algebraic expansion
argument; the extension verifies compatibility of the specific finite
covers. Historical novelty remains unestablished.

## Proofs

| Note | Contents |
|---|---|
| [Bounded-VC supports](bounded-vc-supports.md) | Thin limits, finite bracketing, and extraction of nearly complete support rectangles |
| [Common affine supports](common-affine-supports.md) | Arbitrary intercepts, the affine-energy estimate, group-table reduction, and an explicit common-support rate |
| [Polynomial affine supports](polynomial-affine-supports.md) | Crossed involutions, Fourier fourth moments, and a power saving |
| [Oscillatory affine operators](oscillatory-affine-operator.md) | Uniform weighted norm estimate and exact Fourier–character decomposition |
| [Quadratic palettes and potential sets](quadratic-coset-palettes.md) | A power saving when either set has fixed formula complexity, finite-cover compatibility, robust omission bounds, and comparisons with the primary literature |

The bounded-VC result uses the common-support theorem. Its spectral
calculation is expanded in the polynomial-support note. The oscillatory
operator proof is self-contained and uses elementary quadratic Gauss
sums. Published inputs and their precise roles are cited in the notes.

## Status

The affine results above have written analytic proofs. The linked Lean files give the formal status of the unrestricted results.
Historical novelty has not been established, and external review is
pending. No solution of unrestricted Erdős #810, universal $`o(N^2)`$
bound, or new record is claimed.

The remaining obstacle is controlling arbitrary actual support sets.
A bound for each nonzero Fourier slice does not by itself justify
summing all slices without additional control of their coefficients.

## Formalized hypergraph lower bound

For every $n\geq 7$, Lean verifies that a triple system in which seven vertices
contain at most three triples yields a rainbow-four-cycle graph on the same $n$
vertices, with one edge per triple and at most $n$ colors. This gives
$g(n;7,4)\leq M(n)$. [Proof, sources, and build instructions](research/hall-reduction/README.md)
