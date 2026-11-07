# Cube-restricted rational expansion: independent counting audit

## Conclusion and scope

The counting extension described below passes the audit. It is an extension of the proof of Tao's expansion theorem, rather than a literal application of its stated conclusion. Combined with the separate-cover calculation in [rational-expander-cover-proof.md](rational-expander-cover-proof.md), it gives an absolute constant $C$ such that, for all sufficiently large primes and all nonempty $X,Y\subseteq\mathbb F_p^*$,

```math
\left|\mathbb P^1(\mathbb F_p)\setminus K_E(X,Y)\right|
\le \frac{C p^{31/16}}{\sqrt{|X||Y|}},
\tag{1}
```

where

```math
K(x,y)=\frac{xy(x+y)}{x^2+y^2},\qquad
G(x,y)=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)},
\tag{2}
```

and $K_E(X,Y)$ contains the values $K(x,y)$ for pairs $(x,y)\in X\times Y$ where the displayed rational functions are defined and $G(x,y)$ is a nonzero cube in $\mathbb F_p$. The finite set of excluded output values can be absorbed into the constant in (1).

The geometric argument is used in characteristic zero after passing to an ultraproduct of primes. The proof does not assert uniform control of arbitrary wild covers in individual positive characteristics. Constants are uniform for this fixed pair of rational functions, but are not numerically effective here.

This statement removes the cube restriction for the equal-cross-potential construction with the **full color palette**. It does not remove the additional membership constraints imposed by an arbitrary restricted palette.

## Primary input and exact extension

The source is Terence Tao, [*Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/html/1211.2894), Lemma 23, Theorem 25, Corollary 37, and the proofs of Theorems 38 and 40. Corollary 37 controls products of bounded tests after definable partitions. Lemma 23 supplies two-variable regularity. Theorem 25 supplies finite-witness descriptions of definable cells. The argument below inserts a fixed definable restriction on input pairs into the two Cauchy–Schwarz steps and then proves positivity of every output cell by a separate-cover hypothesis.

Write $q$ for the order of a characteristic-zero nonstandard finite field. All implicit constants in this setting are standard. Work on fixed dense open subsets throughout; the complements have bounded algebraic complexity. Set

```math
E(x,y)=1_{\{G(x,y)\text{ is a nonzero cube}\}}.
\tag{3}
```

This is a first-order definable predicate. Counting cube roots instead would give a bounded weight between $1$ and $3$ on its support, but the existence indicator (3) is sufficient and avoids changing multiplicities.

The two geometric inputs are:

1. The four-output map $(x,x',y,y')\mapsto(K(x,y),K(x,y'),K(x',y),K(x',y'))$ is dominant and generically finite.
2. After arbitrary separate dominant maps from geometrically irreducible curves to the $x$-, $y$-, and $z$-coordinates, the pullback of $z=K(x,y)$, $a^3=G(x,y)$ is geometrically integral on its natural dense open set.

The companion geometric note verifies these inputs. This audit checks their sufficiency and the numerical exponent.

## The restricted grid count is a bounded definable function

Let $\pi$ denote the four-output map. There is a fixed proper algebraic subset $\Lambda$ of the output fourfold product such that every fibre of $\pi$ outside $\Lambda$ is finite of uniformly bounded size. Its inverse image has dimension at most three, hence contributes $O(q^3)$ rational grid points.

For $\mathbf z\notin\Lambda$, define

```math
n_E(\mathbf z)=
\sum_{\substack{x,x',y,y'\\\pi(x,x',y,y')=\mathbf z}}
E(x,y)E(x,y')E(x',y)E(x',y').
\tag{4}
```

The function $n_E$ takes integer values in a fixed finite set. Every level set is definable: one can specify each possible finite number of distinct witnessing grids by a bounded first-order formula. No estimate for the number of cube roots, and no geometric irreducibility of a fourfold Kummer cover, is needed at this step.

Apply the product regularity statement to all these finitely many level sets and take a common refinement of the four output partitions. Lower-dimensional cells contain only $O(1)$ points and can be merged into a full-dimensional cell, changing relevant fourfold sums by $O(q^3)$. We obtain finitely many definable output cells $U_j$, each of size $\asymp q$, with the following property: if $f$ is real, supported on one $U_j$, has mean zero there, and $|f|\le1$, then

```math
\left|
\sum_{\mathbf z\notin\Lambda}n_E(\mathbf z)
f(z_{11})f(z_{12})f(z_{21})f(z_{22})
\right|=O(q^{15/4}).
\tag{5}
```

Indeed, each product main term contains a factor $\sum_{U_j}f=0$; the finite number of level-set errors is still $O(q^{15/4})$.

## Two Cauchy–Schwarz steps retain the restriction exactly

For arbitrary subsets $X,Y$, put

```math
B_f(x,y)=E(x,y)f(K(x,y)).
\tag{6}
```

Two Cauchy–Schwarz inequalities, extending the intervening sums to the full input curves, give

```math
\left|\sum_{x\in X,y\in Y} B_f(x,y)\right|^4
\le |X|^2|Y|^2
\sum_{x,x',y,y'}
B_f(x,y)B_f(x,y')B_f(x',y)B_f(x',y').
\tag{7}
```

The rightmost grid sum is nonnegative because it is also a sum of squares. Its restriction off the exceptional locus is exactly (5). The exceptional contribution is $O(q^3)$, since $|B_f|\le1$. Thus

```math
\left|\sum_{x\in X,y\in Y} E(x,y)f(K(x,y))\right|
\ll q^{15/16}\sqrt{|X||Y|}.
\tag{8}
```

For

```math
\mu(z)=\#\{(x,y)\in X\times Y:E(x,y)=1,\ K(x,y)=z\},
\qquad
\mu_j=\frac1{|U_j|}\sum_{z\in U_j}\mu(z),
\tag{9}
```

duality, using the sign of $\mu-\mu_j$ with its mean subtracted and then dividing by at most two, yields

```math
\sum_{z\in U_j}|\mu(z)-\mu_j|
\ll q^{15/16}\sqrt{|X||Y|}.
\tag{10}
```

The total mass of $\mu$ need not equal $|X||Y|$. The unrestricted proof's pigeonhole step cannot be copied. The next step supplies the missing positivity independently for every cell.

## Why no output cell has vanishing mean

Assume $|X||Y|\gg q^{15/8}$, with the implicit lower bound sufficient for the target conclusion to be nonvacuous. Suppose for contradiction that one cell satisfies

```math
\mu_j=o(|X||Y|/q).
\tag{11}
```

Let $F_j$ be the definable relation $E(x,y)=1$, $K(x,y)\in U_j$. Then $|F_j\cap(X\times Y)|=o(|X||Y|)$. Two-variable definable regularity partitions the input curves into finitely many linear-size definable cells $V_i,W_k$, with standard rational densities $\sigma_{ik}$ and error $O(q^{7/4})$ for every subrectangle.

Choose $i,k$ with $|X\cap V_i|\gg|X|$ and $|Y\cap W_k|\gg|Y|$. Because $q^{7/4}=o(|X||Y|)$, regularity and (11) give $\sigma_{ik}=o(1)$. Being standard, $\sigma_{ik}=0$. Applying regularity to the full cells gives

```math
|F_j\cap(V_i\times W_k)|=O(q^{7/4})=o(q^2).
\tag{12}
```

Here is the precise curve-cover consequence of the finite-witness theorem. For any linear-size definable subset $C$ of a curve, write membership as a finite intersection of assertions $\exists t_\ell:P_\ell(x,t_\ell)=0$. Remove identically zero equations, and remove the finitely many input points where any remaining polynomial's generic leading coefficient in its witness vanishes. On this dense open, divide by those invertible coefficients to make the witness polynomials monic. The simultaneous witness variety is then finite over the remaining curve and has dimension one. It has $\gg q$ rational points, so one of its one-dimensional geometrically irreducible components is defined over the field. Restricting that component to a dense open gives a dominant curve map with bounded fibres whose rational-point image is contained in $C$. It is not necessary to represent all of $C$ by a single component. Merely knowing that individual fibres are finite would give a quasi-finite morphism, so the leading-coefficient restriction is included explicitly.

Apply this observation to $V_i,W_k,U_j$. Pull back $z=K(x,y)$ and $a^3=G(x,y)$ along the resulting three covers. By geometric input 2, the resulting surface is geometrically integral. It is defined over the field, so Lang–Weil gives $\asymp q^2$ rational points on its dense open. Its projection to $(x,y)$ has uniformly bounded fibres: the three curve maps have bounded fibres and there are at most three choices of $a$. Each projected pair is counted in (12). This contradicts (12).

Therefore every output cell satisfies $\mu_j\gg |X||Y|/q$. Combining this with (10) gives

```math
|\{z\in U_j:\mu(z)=0\}|
\ll \frac{q^{31/16}}{\sqrt{|X||Y|}}.
\tag{13}
```

There are only finitely many cells, proving the nonstandard counterpart of (1). If $|X||Y|\ll q^{15/8}$, the right side is already a constant multiple of $q$, so the estimate is vacuous and needs no positivity argument.

## Uniformity and the finite-prime exponent

The uniform finite-prime constant in (1) follows by contradiction. If it failed, choose primes tending to infinity and sets for which the ratio of the left side to $p^{31/16}/\sqrt{|X||Y|}$ tends to infinity. Since the left side is at most $p+1$, this forces

```math
\frac{|X||Y|}{p^{15/8}}\longrightarrow\infty.
\tag{14}
```

Their ultraproduct therefore lies in the regime used above. The fixed formulas and characteristic-zero geometric inputs produce a standard bound for that same ratio, a contradiction. This argument does not require an explicit numerical bound on the partition complexity or on the finite-witness cover degrees.

For a set $H\subseteq\mathbb F_p^*$, split $H$ into disjoint subsets $X,Y$ of comparable size, and apply (1) with target $H$. If $|H|>C_1p^{31/32}$, the exceptional output set is smaller than $H$. Thus there are distinct $x,y\in H$, $k=K(x,y)\in H$, and $a\ne0$ with $a^3=G(x,y)$. The equations $k=x$ or $k=y$ force $x=y$, so $x,y,k$ are pairwise distinct.

The equal-cross-potential construction then gives a forbidden repeated-color four-cycle whenever all three colors $a,ak/y,ak/x$ are available. In the full-palette common-potential model, a proper graph with every four-cycle rainbow must therefore have

```math
|H|=O(p^{31/32}),\qquad
m=(p-1)|H|=O(p^{63/32}).
\tag{15}
```

The conclusion concerns this structured family. It is not a solution of the unrestricted Erdős problem.

## Additional audited scope

For fixed positive densities of $X,Y,H$, the same proof gives $\Omega(p^2)$ eligible pairs with output in $H$: every output-cell mean is $\gg p$, while the total error in (10) is $o(p^2)$. This is a qualitative supersaturation statement with density-dependent constants. Turning it into a result for a nearly complete palette additionally requires bounding the number of configurations lost per omitted color; that is a separate combinatorial check and is not used to justify (1) or (15).

No claim is made here that arbitrary-palette color constraints can be incorporated into three separate curve covers. Those constraints involve additional coupled rational functions and are a remaining obstacle.

## Quantitative lower count and uniform positive constants

The preceding argument also gives a stronger quantitative statement. There are absolute constants $c,C>0$ such that

```math
T(X,Y,Z):=
\#\{(x,y)\in X\times Y:E(x,y)=1,\ K(x,y)\in Z\}
\ge \frac{c|X||Y||Z|}{p}
-C p^{15/16}\sqrt{|X||Y|}
\tag{16}
```

for all $X,Y,Z\subseteq\mathbb F_p^*$ and sufficiently large primes.

Here is the additional positivity argument, which is independent of the particular sets $X,Y,Z$. Fix an output cell $U_j$ from the grid regularity step and apply two-variable regularity to $F_j$. Each pair of resulting full-dimensional input cells has a standard rational density $\sigma_{ik,j}$. If any one were zero, its full-cell count would be $O(q^{7/4})$, contradicting the curve-cover and Lang–Weil argument already given. Thus all these coefficients are positive. There are finitely many, so their minimum is a positive standard constant. Summing the subrectangle estimates over the fixed input partitions gives

```math
\sum_{z\in U_j}\mu(z)
\ge c_0|X||Y|-C_0q^{7/4}.
\tag{17}
```

All output cells have size $\asymp q$. Combining (17) with the within-cell estimate (10), summing over output cells, and restricting to $Z$ gives

```math
T(X,Y,Z)
\ge \frac{c_1|X||Y||Z|}{q}
-C_1q^{3/4}|Z|
-C_1q^{15/16}\sqrt{|X||Y|}.
\tag{18}
```

If $|X||Y|\ge q^{15/8}$, the middle error is at most $C_1q^{7/4}$ and is absorbed by the last error, which is at least a constant multiple of $q^{15/8}$. If $|X||Y|\le q^{15/8}$, then $|X||Y||Z|/q\le |X||Y|\le q^{15/16}\sqrt{|X||Y|}$, so the claimed lower bound is vacuous after enlarging its error constant. This proves the nonstandard version of (16) in every size range.

Uniformity of **both** finite-prime constants follows by a single contradiction argument. If no fixed $c,C,p_0$ worked, for each integer $n$ choose a prime $p\ge n$ and a violating triple of sets with $c=1/n$ and $C=n$. The ultraproduct proof yields some positive standard constant $c_*$ and finite standard $C_*$. Eventually $1/n<c_*$ and $n>C_*$, so the inequality with $c=1/n,C=n$ is weaker than the proved inequality, a contradiction. Thus one does not merely obtain constants depending on a density parameter.

Taking disjoint $X,Y\subset H$ with $|X|,|Y|\gg h:=|H|$, and $Z=H$, yields

```math
T_H\ge \frac{c h^3}{p}-C p^{15/16}h,
\tag{19}
```

where $T_H$ may count the corresponding configurations with their nonzero cube roots, since each counted pair supplies at least one such root. This is the precise lower count required for a subsequent missing-color or missing-incidence argument. Its transfer to a graph with deleted incidences is a separate combinatorial step.

## Independent check of the robust graph transfer

Section 8 of [common-potential-combinatorics.md](common-potential-combinatorics.md) supplies that separate step, and its four rational substitutions have been independently checked. With $q=y/x$, write

```math
B=q^2+q+1,\quad Q=q^2+1,\quad
F=-\frac{BQ}{q(q+1)},\quad r=\frac{q+1}{Q}.
\tag{20}
```

The configuration has $x=a^3/F$, $y=qx$, $k=qrx$, and colors $a,b=ar,c=aqr$. Fixing a color/potential incidence in each of its four possible roles forces, respectively,

```math
\frac{a^3}{x}=F,\qquad
\frac{a^3}{y}=\frac Fq,\qquad
\frac{b^3}{k}=-\frac{B(q+1)}{q^2Q},\qquad
\frac{c^3}{k}=-\frac{qB(q+1)}Q.
\tag{21}
```

Every prescribed-value equation in (21) is a nonzero polynomial equation of degree at most four after clearing denominators. The color and $q$ uniquely recover the rest of the configuration. Thus one missing incidence destroys at most sixteen configurations. A fixed omitted color has three roles and at most $p$ parameters per role, destroying at most $3p$ configurations. The nondegenerate parameter exclusions ensure three distinct colors and four distinct edges.

Consequently, if $D$ colors are absent and $R$ eligible incidences of the remaining colors are omitted from a simple proper graph whose four-cycles are all rainbow, then

```math
\frac{c h^3}{p}-C p^{15/16}h
\le T_H\le 3pD+16R.
\tag{22}
```

If the first error term is at least half the cubic main term, then $h\ll p^{31/32}$. Otherwise $h^3\ll p(R+pD)$. Since $m\le ph$, both cases give the independently audited bound

```math
m\ll p^{63/32}+p^{4/3}(R+pD)^{1/3}.
\tag{23}
```

In particular $D=o(p)$ and $R=o(p^2)$ force $m=o(p^2)$. This permits arbitrary $H$ and arbitrary deletion patterns subject to those two deficit conditions. It does not assert a conclusion when a positive fraction of the palette is absent or a positive fraction of the eligible incidences is deleted. A zero potential contributes at most $p-1$ extra incidences and is absorbed into (23).
