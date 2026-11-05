# Restricted finite-correspondence expansion: independent analytic audit

18 October 2026. The analytic extension below passes, conditional on the geometric statements explicitly listed here and verified in [cubic-palette-geometry-audit.md](cubic-palette-geometry-audit.md). It is a proof adaptation, not a claim that a published functional theorem literally covers this correspondence. It is not Lean-certified.

The extremal application to a complete cubic palette is superseded by a stronger character-sum argument using properness alone. The purpose of this note is to preserve the correct correspondence counting statement and its hypotheses.

## Statement and geometric inputs

Put

```math
A(q)=q^4+q^3+q^2+q+1,
\qquad B(q)=q^2+q+1.
\tag{1}
```

Let $S$ be the surface with coordinates $u,v,w$, expressed on its natural dense open by $q=v/u$, $r=w/v$, and

```math
A(q)r^2-q(q+1)r-B(q)=0.
\tag{2}
```

For $\lambda\ne0$, define

```math
G_\lambda(u,v,w)=
-\lambda\frac{u^4+u^3v+u^2v^2+uv^3+v^4}{w(u+v)}.
\tag{3}
```

Restrict to a fixed dense open on which all displayed functions are defined, $G_\lambda\ne0$, and the projection $S\to\mathbb A^2_{u,v}$ has at most two points per fibre. Further fixed proper algebraic exclusions, including $v=\pm u$, may be imposed. The lower bound is unchanged up to its constants.

For all sufficiently large primes there are absolute constants $c,C>0$, uniform in $\lambda\in\mathbb F_p^*$ and in all subsets $X,Y,Z\subseteq\mathbb F_p^*$, such that

```math
\begin{aligned}
T_\lambda(X,Y,Z)
&:=\#\{(u,v,w)\in S(\mathbb F_p):
u\in X,\ v\in Y,\ w\in Z,
\ G_\lambda(u,v,w)\in(\mathbb F_p^*)^5\}\\
&\ge \frac{c|X||Y||Z|}{p}
-Cp^{15/16}\sqrt{|X||Y|}.
\end{aligned}
\tag{4}
```

The count is of correspondence points $(u,v,w)$, not of fifth roots. Each eligible point has between one and five nonzero fifth roots.

The geometric inputs, over every algebraically closed characteristic-zero field, are:

1. The four-grid variety, whose points consist of $u_1,u_2,v_1,v_2$ and four choices $w_{ij}$ with $(u_i,v_j,w_{ij})\in S$, is geometrically integral of dimension four. Its map to $(w_{11},w_{12},w_{21},w_{22})$ is dominant and generically finite.
2. After arbitrary separate dominant maps from geometrically irreducible curves to the $u$-, $v$-, and $w$-lines, the pullback of $S$ together with $a^5=G_\lambda$ is geometrically integral of dimension two.
3. Both assertions hold for every nonzero $\lambda$, including transcendental parameter values. The restriction to any of the dense opens specified above preserves them.

Input 1 needs purity of the whole grid. The existence of one dominant sheet would not suffice if another dimension-four component had nondominant output. The independent square-class calculation in the geometric note resolves exactly this issue. Input 2 is used for a single correspondence point, not for the four-grid fifth-root cover.

## Published inputs and the scope of the adaptation

The primary source is Terence Tao, [*Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/html/1211.2894), specifically Lemma 23, Theorem 25, Lemma 26, Corollary 37, and the proofs of Theorems 38 and 40. The discussion following Theorem 38 explicitly notes a bounded-correspondence variant of its upper-bound argument. The restricted lower bound (4) also needs the positivity argument below.

Work in a characteristic-zero nonstandard finite field of order $Q$. Constants and the number of pieces in each definable partition are standard. The fixed formula may contain the nonzero parameter $\lambda$. All sums below use the fixed dense open source.

## Bounded output-fibre counts, with all sheets retained

Let

```math
e_\lambda(u,v,w)=
1_{\{G_\lambda(u,v,w)\text{ is a nonzero fifth power}\}}.
\tag{5}
```

This is a definable existence predicate. For real $f$ with $|f|\le1$, set

```math
B_f(u,v)=\sum_{w:(u,v,w)\in S}
e_\lambda(u,v,w)f(w).
\tag{6}
```

Thus $|B_f|\le2$. Let $\pi$ be the output map of the complete four-grid variety. Input 1 supplies a proper algebraic locus $\Lambda$ in the output fourfold product outside which all fibres are finite of a standard bounded size. Since the grid is integral and dominant, $\pi^{-1}(\Lambda)$ is a proper subset of dimension at most three and has $O(Q^3)$ rational points.

Outside $\Lambda$, let $n_\lambda(\mathbf w)$ count grid points in that output fibre for which all four predicates (5) hold. This is a bounded nonnegative integer-valued definable function. Its finitely many level sets are definable: the bounded fibre cardinalities can be expressed by formulas asserting the existence of a specified number of distinct witnesses and the nonexistence of one more.

Apply Corollary 37 to these level sets and take a common refinement of the output-coordinate partitions. On a curve, lower-dimensional definable pieces have $O(1)$ points; merging them into full-dimensional pieces costs $O(Q^3)$ in the fourfold sums. We obtain a fixed finite partition into cells $U_j$ of size $\asymp Q$. For any mean-zero real $f$ supported in one $U_j$, $|f|\le1$,

```math
\left|\sum_{\mathbf w\notin\Lambda}
n_\lambda(\mathbf w)
f(w_{11})f(w_{12})f(w_{21})f(w_{22})\right|
\ll Q^{15/4}.
\tag{7}
```

Every product main term vanishes because its four coordinate tests are supported in $U_j$ and have zero integral there. The error exponent is $4-1/4=15/4$. No irreducibility assertion about a fourfold fifth-root cover is used.

## Two Cauchy--Schwarz steps and output flatness

For arbitrary $X,Y$, the usual two Cauchy--Schwarz inequalities give

```math
\left|\sum_{u\in X,v\in Y}B_f(u,v)\right|^4
\le |X|^2|Y|^2
\sum_{u_1,u_2,v_1,v_2}
\prod_{i,j=1}^2 B_f(u_i,v_j).
\tag{8}
```

The full grid sum is nonnegative: it is a sum of squares. Expanding each of the four bounded sums in (6) chooses one actual output sheet at each position, exactly giving the grid count in (7), with no omitted or identified multiplicities. The exceptional contribution is $O(Q^3)$; equivalently each base grid contributes at most $2^4$ choices. Therefore

```math
\left|\sum_{u\in X,v\in Y}B_f(u,v)\right|
\ll Q^{15/16}\sqrt{|X||Y|}.
\tag{9}
```

Define

```math
\mu(w)=\#\{(u,v)\in X\times Y:
(u,v,w)\in S,\ e_\lambda(u,v,w)=1\},
\qquad
\mu_j=|U_j|^{-1}\sum_{w\in U_j}\mu(w).
\tag{10}
```

Using the sign of $\mu-\mu_j$, subtracting its mean on $U_j$, and dividing by at most two in (9), gives

```math
\sum_{w\in U_j}|\mu(w)-\mu_j|
\ll Q^{15/16}\sqrt{|X||Y|}.
\tag{11}
```

Unlike a single-valued unrestricted map, $\sum_w\mu(w)$ need not equal $|X||Y|$. The next argument supplies a positive lower mass in every output cell independently of $X,Y$.

## Every output cell has positive product-cell density

For fixed $U_j$, regularize the definable **existence relation**

```math
F_j=\{(u,v):\exists w\in U_j,
(u,v,w)\in S,\ e_\lambda(u,v,w)=1\}.
\tag{12}
```

Lemma 23 gives finite full-dimensional input partitions $V_i,W_k$ and standard rational densities $\sigma_{ik,j}\ge0$ such that every subrectangle count differs from $\sigma_{ik,j}$ times its size by $O(Q^{7/4})$. This uses an indicator relation; it does not silently identify an indicator with the multiplicity weight in (10).

Suppose some $\sigma_{ik,j}=0$. Its full-cell count is then $O(Q^{7/4})=o(Q^2)$. We construct separate curve covers with rational-point images contained in $V_i,W_k,U_j$ as follows. Theorem 25 gives each linear-size definable cell a description by finitely many polynomial witness equations. Remove identically zero equations and the finitely many input zeros of the remaining generic leading coefficients in their witnesses. Dividing by those coefficients makes the equations monic on the remaining dense open. The simultaneous witness variety is finite over that open curve, has dimension one, and has $\gg Q$ rational points. A one-dimensional geometrically irreducible component defined over the field must therefore occur: components not defined over the field have rational points only in intersections with their distinct conjugates, contributing $O(1)$ points. Restrict that component to a dense open. It gives the required dominant bounded-fibre curve map. Its image need only be contained in the cell; equality with the cell is unnecessary.

Pull back $S$ and $a^5=G_\lambda$ along the three selected curve covers. Input 2 makes the resulting surface geometrically integral and defined over the field. Lang--Weil gives $\asymp Q^2$ rational points on its dense open. Projection to $(u,v)$ has bounded fibres: at most two possible $w$, at most five roots $a$, and bounded multiplicities from the three coordinate covers. Each projected pair belongs to $F_j\cap(V_i\times W_k)$. This contradicts its $o(Q^2)$ size.

Thus every $\sigma_{ik,j}$ is positive. Since there are finitely many standard coefficients, their minimum is a positive standard number. Summing regularity estimates over the fixed partitions, and observing that multiplicity is at least existence, yields

```math
\sum_{w\in U_j}\mu(w)
\ge c_0|X||Y|-C_0Q^{7/4}.
\tag{13}
```

This establishes a uniform positive lower mass for every output cell. It is the additional step needed beyond bounded-correspondence upper bounds.

## Lower count, all size ranges, and varying parameters

Divide (13) by $|U_j|\asymp Q$, use (11), and sum over $Z\cap U_j$. The result is

```math
T_\lambda(X,Y,Z)
\ge c_1\frac{|X||Y||Z|}{Q}
-C_1Q^{3/4}|Z|
-C_1Q^{15/16}\sqrt{|X||Y|}.
\tag{14}
```

If $|X||Y|\ge Q^{15/8}$, the middle error is at most $C_1Q^{7/4}$ and is absorbed by the last error. If $|X||Y|\le Q^{15/8}$, the desired positive term is at most $|X||Y|\le Q^{15/16}\sqrt{|X||Y|}$, so (4) is vacuous after enlarging $C$. This proves the nonstandard form of (4) in every size range.

To obtain finite-prime constants uniform in $\lambda$, suppose none exist. For each integer $n$, choose a prime $p_n\ge n$, a nonzero parameter $\lambda_n$, and sets violating (4) with $c=1/n$ and $C=n$. Their ultraproduct has characteristic zero and nonzero parameter $\lambda$. Inputs 1--3 and the preceding argument supply some positive standard $c_*$ and finite standard $C_*$. Eventually $1/n<c_*$ and $n>C_*$, so the purported violated bound is weaker than the one just proved, a contradiction. No numerical effectiveness of the constants is asserted.

## Audit conclusion and application limitation

The two-output multiplicity, all grid sheets, exceptional fibres, the existence-versus-count distinction, bounded cover projections, and parameter uniformity are accounted for. The exponent $15/16$ is the fourth root of the product-regularity error $Q^{15/4}$.

In the cubic graph application, $\lambda$ labels a square class of **potentials**: $h_1=\lambda u^2$, $h_2=\lambda v^2$, $k=\lambda w^2$. It is not a coefficient in the affine map $x\mapsto ax+a^3$. The resulting graph estimate $O(p^{63/32})$ is valid if the stated correspondence-to-cycle algebra is used, but is weaker than the subsequently audited $O(p^{3/2})$ properness-only estimate. It should therefore not be advertised as a stronger extremal result for that palette.
