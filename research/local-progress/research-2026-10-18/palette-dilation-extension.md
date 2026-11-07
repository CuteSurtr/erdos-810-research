# A dilation transfer for palettes with a fixed proportion of missing colors

18 October 2026. This is a consequence of the cube-restricted counting argument and the exact incidence multiplicity bounds. It does not prove sparsity for arbitrary dense palettes, and historical priority is not asserted.

## Statement

Let $p$ be a sufficiently large prime, $U\le\mathbb F_p^\times$ a multiplicative subgroup, and $0<\gamma\le1$. Suppose the palette $A\subseteq\mathbb F_p^\times$ satisfies

```math
|A\cap cU|\ge\frac{2+\gamma}{3}|U|
\qquad\text{for every }c\in\mathbb F_p^\times.           \tag{1}
```

Let $H\subseteq\mathbb F_p$ be arbitrary, and define its averaged dilation defect by

```math
J_U(H)=\frac1{|U|}\sum_{t\in U}|H\setminus t^{-3}H|.
\tag{2}
```

Retain a subset of the quadratic common-potential incidences

```math
(a,h)\longmapsto
\left(\frac{h}{a^2}-a,\frac ha\right),
\qquad (a,h)\in A\times H,
```

and suppose the resulting actual graph is simple, properly colored, and has every four-cycle rainbow. Let $R$ be the number of omitted eligible incidences and $m$ the actual edge count. Then, with an absolute implicit constant,

```math
m\ll p^{63/32}
 +\gamma^{-1/3}p^{4/3}\bigl(R+pJ_U(H)\bigr)^{1/3}.
\tag{3}
```

Thus, for fixed $\gamma>0$, the conditions $R=o(p^2)$ and $J_U(H)=o(p)$ imply $m=o(p^2)$. In the exact case $t^3H=H$ for every $t\in U$ and $R=0$, one has $m=O(p^{63/32})$. For that exact conclusion it is enough that each palette coset has density strictly greater than $2/3$; the positive margin may depend on $p$.

The completed eligible incidence system is not assumed proper. The B condition is imposed only on the actual selected graph.

## Configurations and their multiplicities

First remove zero from $H$. This deletes at most $p-1$ actual incidences, does not increase $R$, and does not change (2). These incidences will be restored into the first term of (3).

Let $\mathcal Q(H)$ be the set of **all** ordered nondegenerate triples $(x,y,a)$ with

```math
x,y,k=K(x,y)\in H,\qquad a^3=G(x,y)\ne0,
```

where

```math
K(x,y)=\frac{xy(x+y)}{x^2+y^2},\qquad
G(x,y)=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)}.
```

All cube roots are counted. Arbitrarily selecting one root per pair would not in general respect the dilation action used below. Write $N(H)=|\mathcal Q(H)|$. The [cube-restricted counting proof](partial-rational-expansion-independent-audit.md) gives

```math
N(H)\ge c\frac{|H|^3}{p}-C p^{15/16}|H|.              \tag{4}
```

Each configuration has three distinct colors

```math
a,\qquad b=ak/y,\qquad c=ak/x,
```

and four colored incidences

```math
(a,x),\quad(a,y),\quad(b,k),\quad(c,k).                \tag{5}
```

Section 8 of [the combinatorial proof](common-potential-combinatorics.md) proves that any fixed colored incidence occurs in at most sixteen such ordered configurations. Consequently, a fixed nonzero potential value occurs in at most $16(p-1)$ configurations, by summing over its possible colors. These bounds also hold in the unrestricted configuration universe before imposing membership in $H$.

## Simultaneous dilation of the three colors

For $t\in U$, the transformation

```math
(a,h)\longmapsto(ta,t^3h)
\tag{6}
```

corresponds to the vertex relabeling

```math
(\text{row},\text{column})\longmapsto
(t\,\text{row},t^2\,\text{column}).
```

It maps a configuration to a configuration: $K$ and $G$ are homogeneous of degree one, so

```math
K(t^3x,t^3y)=t^3K(x,y),\qquad
G(t^3x,t^3y)=t^3G(x,y)=(ta)^3.
```

For a given configuration, each of its three colors has at least $(2+\gamma)|U|/3$ dilations landing in $A$, by (1). The union bound on the three bad-color subsets leaves at least $\gamma|U|$ dilations for which all three colors lie in $A$.

This uses actual configurations and a common vertex relabeling. It does not complete the graph by adding absent colors, or assume that a union of differently scaled B-colorings remains B.

## Exact and approximate invariance

In the exact case $t^3H=H$, the action preserves $\mathcal Q(H)$. Double counting pairs consisting of a configuration and a palette-valid dilation shows that at least a $\gamma$ fraction of $\mathcal Q(H)$ has all three colors in $A$: each target configuration has exactly $|U|$ preimage pairs. Such a configuration must lose an actual incidence, or it gives the forbidden four-cycle. Therefore

```math
\gamma N(H)\le16R.
```

For general $H$, consider the same pairs before discarding potential failures. Fix $t\in U$. If a dilated potential leaves $H$, the original configuration contains some

```math
h\in H\setminus t^{-3}H.
```

There are at most $16p|H\setminus t^{-3}H|$ configurations spoiled in this way. Among the remaining palette-valid dilations, every forbidden rectangle must lose at least one of the $R$ omitted actual incidences. Dilation is injective on the full configuration universe, so these account for at most $16R$ original configurations for the fixed $t$.

Summing over $t$ and using the lower bound $\gamma|U|N(H)$ for the total number of palette-valid pairs gives

```math
\gamma N(H)\le16R+16pJ_U(H).                           \tag{7}
```

Insert (4) into (7). Splitting according to whether its error term or the right side dominates yields

```math
|H|\ll p^{31/32}
 +\gamma^{-1/3}p^{1/3}\bigl(R+pJ_U(H)\bigr)^{1/3}.
```

Since $m\le p|H|$, this proves (3), after restoring the possible zero-potential incidences.

## A concrete scope beyond the previous Fourier criterion

For primes $p\equiv1\pmod{21}$, take $U$ of order seven. The cube map permutes $U$, so exact invariance means that $H\setminus\{0\}$ is an arbitrary union of $U$-orbits. Let $A$ contain exactly five elements of every $U$-coset. Then (1) holds with $\gamma=1/7$, while the palette omits exactly two sevenths of all nonzero colors. Every actual B-coloring retaining all these eligible incidences has

```math
m=O(p^{63/32}).
```

The orbit union may be chosen arbitrarily and need not have a bounded Fourier envelope. Invariance under a fixed group of order seven only restricts the multiplicative spectrum to roughly one seventh of all characters; it does not provide the small Fourier $\ell^1$ norm required by the earlier envelope criterion. The statement therefore uses the new full-palette configuration count in a way that is not implied by that criterion.

There is also a nonvacuity check at the level of properness. The order-seven group lies in the subgroup of cubes. Choose $H$ to be any $U$-invariant subset of one fixed nontrivial cubic coset. The full-palette classification in Section 7 of the combinatorial note shows that the completed incidence system is already simple and proper, and so is every subpalette. Such $H$ can have positive density. Since $-1\notin U$, its orbits occur in disjoint pairs $O,-O$; choosing one orbit from each pair even permits $H\cap(-H)=\varnothing$ and $|H|=(p-1)/6$. The result above therefore uses the rainbow-four-cycle condition essentially and is not confined to negation-symmetric masks.

These masks can also lie well outside the small-envelope range. Independently half-select the $U$-orbits inside that nontrivial cubic coset. On the quotient group of size $(p-1)/7$, all but the three characters factoring through the cubic quotient have centered Fourier coefficients with second moment of order $1/p$ and fourth moment $O(1/p^2)$. The elementary second/fourth-moment bound gives expected absolute coefficient $\gg p^{-1/2}$. Summing over the other characters shows that some choices have multiplicative Fourier $\ell^1$ norm $\gg\sqrt p$, while scalar concentration permits $|H|=(1/6+o(1))p$. Alternatively, choosing one orbit independently from each pair $O,-O$ gives a skew mask of that density: the same moment argument on characters with $\chi(-1)=-1$ gives a large Fourier envelope. These are proper examples; the theorem forces them to contain a non-rainbow four-cycle.

For the skew choice $H\cap(-H)=\varnothing$, every bichromatic four-cycle is absent. Indeed, an alternating two-color cycle would give a two-cycle of the relative affine permutation $\sigma_b^{-1}\sigma_a$. In odd characteristic this forces $b=-a$; the corresponding potentials occur in opposite pairs $h,-h$, which the skew mask forbids. Thus the forced non-rainbow rectangle in these dense proper examples has three colors. The simpler bichromatic argument below cannot supply it.

More quantitatively, if $|H|\ge\delta p$ for fixed $\delta>0$, the completed order-seven example has $\Omega_\delta(p^2)$ distinct three-color four-cycles. The counting estimate gives $N(H)\ge c_\delta p^2$ for large $p$, and the dilation argument retains at least $N(H)/7$ distinct ordered configurations with all colors in $A$. A three-color four-cycle has one repeated color and at most two choices of ordered diagonal potentials, so at most two of these configurations describe the same underlying cycle. Omitting $R=o(p^2)$ eligible incidences still leaves $\Omega_\delta(p^2)$ such cycles, because each omission destroys at most sixteen ordered configurations. This is a supersaturation conclusion for these proper graphs, not merely the negation of condition B.

For $U=\mathbb F_p^\times$, exact invariance would force bounded multiplicative spectral complexity and would already fall under the earlier Fourier argument. The fixed-small-subgroup example is the relevant new scope of this transfer. No assertion is made for an arbitrary dense palette or an arbitrary mask without the stated dilation-defect condition.

## A stronger elementary comparison for even-order dilation groups

The order of $U$ matters when comparing this transfer with simpler arguments. If $U$ has even order and $H$ is exactly invariant under $U^3$, then $H=-H$. In this case a bichromatic rectangle supplies a stronger bound without the rational-expansion theorem.

Take two distinct nonzero potential values $h_1,h_2\in H$ with $h_1+h_2=2a^3\ne0$. The two rows are $x,-x$, where $x=(h_1-h_2)/(2a^2)$, and the columns are $a^2+ax,a^2-ax$. The four potentials, for colors $a,-a$, are $h_1,h_2,-h_1,-h_2$, all in $H$. Thus it is a nondegenerate bichromatic four-cycle whenever both colors are available.

For $p\equiv1\pmod3$, the cubic-character indicator and the elementary Gauss-sum bound give at least

```math
\frac{h^2-h}{3}-\frac23\sqrt p\,h
```

ordered pairs with nonzero cubic midpoint, where $h=|H|$. The character-sum error follows because the additive Fourier transform of a nontrivial multiplicative character has magnitude $\sqrt p$ at every nonzero frequency, so the matrix with entries $\chi(s+t)$ has operator norm $\sqrt p$. Removing the at most $h$ diagonal pairs shows that $h>C\sqrt p$ forces such a rectangle. For $p\equiv2\pmod3$, cubing is bijective and the same conclusion is immediate.

Only two color conditions must be met under dilation. If every $U$-coset has palette density greater than $1/2$, some common dilation puts both colors in $A$. In the exact no-omission case this gives the stronger bound $m=O(p^{3/2})$ for even-order $U$. In particular, an order-four example should not be advertised as the principal new application of the weaker exponent $63/32$. The odd-order example above avoids this automatic symmetry and this elementary bichromatic argument.
