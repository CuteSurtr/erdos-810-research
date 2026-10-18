# A power saving for quadratic affine B-colorings with a fixed-index palette coset

## Abstract

Consider a bipartite graph over a prime field whose edge of color $`a`$ and potential $`h`$ joins $`h/a^2-a`$ to $`h/a`$. Every color draws its potentials from the same arbitrary set $`H`$. If the palette contains a complete multiplicative coset of bounded index, and every eligible incidence in that coset is retained, then a simple proper coloring with every four-cycle rainbow has $`O_L(p^{2-1/32})`$ edges. A quantitative version allows missing colors and incidences. The proof combines an explicit three-color rectangle with an adaptation of Tao's algebraic expansion argument to a prescribed power-residue condition.

**Scope and status.** The result concerns the specified common-potential model. It gives no bound for unrestricted Erdős problem #810. The argument is a written mathematical proof, not a Lean certificate. Historical novelty is unestablished: the analytic machinery and its exponent are inherited from [Tao](#references), and the closely related 2026 paper on perfect colorings has not yet been compared in full. No priority or record claim is made.

## 1. The theorem

A **B-coloring** is a proper edge-coloring in which every four-cycle is rainbow. The two vertex classes below are distinct copies of $`\mathbb F_p`$. For $`A\subseteq\mathbb F_p^\times`$ and $`H\subseteq\mathbb F_p`$, an *eligible incidence* is a pair $`(a,h)\in A\times H`$, representing color $`a`$ on the edge

```math
(x,y)=\left(\frac{h}{a^2}-a,\frac{h}{a}\right).
\tag{1}
```

Equivalently, the edge lies on $`y=ax+a^2`$ and satisfies $`ay=h`$. Distinct eligible incidences can represent the same uncolored edge. Only the retained incidences are required to form a simple properly colored graph.

**Theorem 1.** Fix $`L\ge1`$. There are constants $`B_L,p_L>0`$ such that the following holds for every prime $`p>p_L`$. Retain any subset of the incidences (1) forming a simple graph with a B-coloring, and let $`m`$ be its number of edges. Let $`C\le\mathbb F_p^\times`$ have index $`\ell\le L`$, and let $`t\ne0`$. Define

```math
D=|tC\setminus A|,
\qquad
R=\#\{(a,h)\in(A\cap tC)\times H:
                 (a,h)\text{ is not retained}\}.
```

Then

```math
m\le B_Lp^{63/32}
       +B_Lp^{4/3}(R+pD)^{1/3}.
\tag{2}
```

Here $`H`$ is arbitrary, other colors in $`A`$ are unrestricted, and $`m`$ counts **all** retained edges. The deficit $`R`$ concerns only the designated coset.

If $`D=R=0`$, (2) gives $`m=O_L(p^{2-1/32})`$. More generally, $`D=o(p)`$ and $`R=o(p^2)`$ imply $`m=o(p^2)`$. Since there are $`N=2p`$ vertices, the same power saving holds in terms of $`N`$ for this family. The index bound is fixed independently of $`p`$; no uniform conclusion for growing index is asserted. The constants are not numerically explicit here.

The conclusion uses more than properness. For example, suppose $`p\equiv1\pmod3`$, take the full palette, and take $`H`$ inside one nontrivial cubic coset. Two distinct color lines $`a,b`$ meet at $`(-a-b,-ab)`$, where their potentials are $`-a^2b,-ab^2`$. Their product is a cube, whereas the product of two elements of the same nontrivial cubic coset is not. Thus the completed incidence system is simple and proper, and can have $`\Theta(p^2)`$ edges. Theorem 1 forces a non-rainbow four-cycle in a dense such system.

## 2. A rectangle with three potential values

Set

```math
K(u,v)=\frac{uv(u+v)}{u^2+v^2},
\qquad
G(u,v)=-\frac{(u^2+uv+v^2)(u^2+v^2)}{uv(u+v)}.
\tag{3}
```

Throughout, the *admissible open set* excludes zeros of $`uv(u+v)(u^2+v^2)(u^2+uv+v^2)`$. A nondegenerate configuration also requires $`u\ne v`$.

**Lemma 2.** Suppose $`k=K(u,v)`$ and $`a^3=G(u,v)`$ on this open set, with $`u\ne v`$. Put

```math
b=ak/v,\qquad c=ak/u.
```

The four incidences

```math
(a,u),\quad(a,v),\quad(b,k),\quad(c,k)
\tag{4}
```

form a nondegenerate four-cycle with color matrix $`\begin{pmatrix}a&b\\c&a\end{pmatrix}`$. Its three colors are distinct. Among all such ordered configurations, a fixed colored incidence occurs at most sixteen times, and a fixed color occurs at most $`3p`$ times.

**Proof.** Write $`q=v/u`$ and define

```math
Q=q^2+1,\qquad B=q^2+q+1,\qquad
r=\frac{q+1}{Q},\qquad
F=-\frac{BQ}{q(q+1)}.
\tag{5}
```

The hypotheses exclude $`q=0,1,-1`$ and $`QB=0`$. They give

```math
u=a^3/F,\quad v=qu,\quad k=qru,
\qquad b=ar,\quad c=aqr.
```

Direct substitution gives the two cross-edge identities

```math
v=ru+a^3r(r-1),
\qquad
u=qr\,v+a^3qr(qr-1).
\tag{6}
```

Consequently the rectangle has rows $`u/a^2-a,v/a^2-a`$ and columns $`u/a,v/a`$, with the asserted color matrix. The rows and columns are distinct. The equations $`r=1`$, $`qr=1`$, and $`r=qr`$ are excluded by the restrictions on $`q`$, so the colors are distinct.

For the four possible roles of a fixed color/potential incidence, respectively, the parameter $`q`$ satisfies

```math
\frac{a^3}{u}=F,
\qquad
\frac{a^3}{v}=\frac Fq,
\qquad
\frac{b^3}{k}=-\frac{B(q+1)}{q^2Q},
\qquad
\frac{c^3}{k}=-\frac{qB(q+1)}Q.
\tag{7}
```

Each prescribed-value equation becomes a nonzero polynomial of degree at most four after clearing denominators. The first, second, and fourth numerators have degree four and larger degree than their denominators. In the third equation the denominator has degree four, the numerator degree three, and the prescribed value is nonzero. Each role therefore permits at most four values of $`q`$. The role and $`q`$ recover the entire configuration, proving the bound sixteen. A fixed color has three possible roles $`a,b,c`$, each with at most $`p`$ choices of $`q`$; the corresponding repeated color is recovered as $`a`$, $`b/r`$, or $`c/(qr)`$. This proves the second bound. $`\square`$

## 3. The geometric checks

The following verification supplies the geometric hypotheses for the counting argument in Section 4. Work first over an algebraically closed field $`k_0`$ of characteristic zero. A separate coordinate cover means a dominant map from a geometrically integral curve to one of the three coordinate lines. All assertions concern the natural dense open sets, so zeros, poles, and finitely many branch points may be removed.

**Lemma 3.** The four-output map

```math
(u,u',v,v')\longmapsto
\bigl(K(u,v),K(u,v'),K(u',v),K(u',v')\bigr)
\tag{8}
```

is dominant and generically finite. Moreover, for every fixed integer $`n\ge1`$ and $`\eta\ne0`$, the surface

```math
z=K(u,v),\qquad s^n=G(u,v)/\eta
\tag{9}
```

remains geometrically integral after arbitrary separate covers of $`u,v,z`$.

**Proof.** First,

```math
K_u(u,v)=\frac{v^2(-u^2+2uv+v^2)}{(u^2+v^2)^2},
\qquad K_v(u,v)=K_u(v,u).
```

The Jacobian determinant in (8), at $`(u,u',v,v')=(1,2,3,4)`$, is nonzero: its absolute value is $`28944/6105125`$. This proves dominance; equality of dimensions gives generic finiteness.

For the base relation $`z=K(u,v)`$, use reciprocals $`r=1/u`$, $`s_0=1/v`$, $`w=1/z`$. Its generic fiber is the smooth conic

```math
r^2+s_0^2=w(r+s_0).
\tag{10}
```

Thus $`F=k_0(u,v)`$ is regular over $`k_0(z)`$. For every $`z_0\in\mathbb P^1(k_0)`$, the fiber has a multiplicity-one divisor on which both $`u`$ and $`v`$ vary: for finite nonzero $`z_0`$, use the conic (10); for zero, use $`u+v=0`$; for infinity, use either component $`v=\pm iu`$ of $`u^2+v^2=0`$. The indicated numerator or denominator has a simple zero at the generic point of each chosen component.

Pass the three coordinate covers to Galois closures, with function fields $`L_u/k_0(u)`$, $`L_v/k_0(v)`$, and $`L_z/k_0(z)`$. The product of the first two covering curves is geometrically integral. Inside a common algebraic closure of $`F`$, put

```math
E=FL_uL_v,\qquad M=FL_z,\qquad J=E\cap M.
```

Regularity identifies $`\operatorname{Gal}(M/F)`$ with $`\operatorname{Gal}(L_z/k_0(z))`$. The extension $`E/F`$ is unramified at every chosen fiber divisor: branches of the input covers are vertical or horizontal, whereas both coordinates vary along that divisor. Hence $`J/F`$ is unramified there.

Target inertia survives this base change, because the target local parameter has valuation one. In characteristic zero a tame extension of inertia order $`e`$ is locally generated by an $`e`$th root of a parameter; its ramification index remains $`e`$ after this pullback. Each target inertia subgroup consequently lies in $`\operatorname{Gal}(M/J)`$. This is a normal subgroup, since $`J/F`$ is Galois. Target inertia normally generates the whole group: its quotient would give an everywhere-unramified finite cover of $`\mathbb P^1`$, which has degree one by Riemann–Hurwitz. Therefore $`J=F`$. The Galois extensions $`E,M`$ are linearly disjoint, and so are the relevant subextensions. This proves integrality of the base relation after the three covers. Restricting the curve maps to finite flat maps on suitable opens ensures that the corresponding fiber product has no additional vertical components there.

It remains to adjoin the root in (9). Let $`\omega`$ be a primitive cube root of unity and consider the divisor $`v=\omega u`$ on the base surface. Along it,

```math
K(u,\omega u)=\omega^2u,
\qquad
\operatorname{ord}_{v=\omega u}G=1.
\tag{11}
```

The second equality follows by factoring $`u^2+uv+v^2=(v-\omega u)(v-\omega^2u)`$; all other factors in (3) are nonzero generically on this divisor. All three coordinates $`u,v,z`$ vary along it, so the separate covers and their compositum are unramified there. Any extended valuation still assigns value one to $`G/\eta`$. The polynomial $`T^n-G/\eta`$ is Eisenstein at that valuation and is irreducible, including for composite $`n`$. This proves the final integrality assertion. $`\square`$

## 4. Counting with the power-residue restriction

**Lemma 4.** Fix $`n\ge1`$. There are positive constants $`c_n,C_n,p_n`$ such that, for every prime $`p>p_n`$, every $`\eta\in\mathbb F_p^\times`$, and all $`X,Y,Z\subseteq\mathbb F_p^\times`$,

```math
\begin{aligned}
T_{n,\eta}(X,Y,Z)
&:=\#\{(u,v)\in X\times Y:
       K(u,v)\in Z,\ G(u,v)/\eta\in(\mathbb F_p^\times)^n\}\\
&\ge c_n\frac{|X||Y||Z|}{p}
       -C_np^{15/16}\sqrt{|X||Y|}.
\end{aligned}
\tag{12}
```

Only pairs in the admissible open set of Section 2 are counted. All constants are uniform in $`\eta`$ and the three sets.

**Proof.** We give the adaptation of Tao's argument explicitly, because the power-residue restriction does not leave a Cartesian product of admissible inputs. The published inputs are Lemma 23, Theorem 25, Corollary 37, and the proofs of Theorems 38 and 40 in [Tao](#references).

Work in a characteristic-zero ultraproduct of prime fields, whose nonstandard cardinality is denoted $`q`$. The sets $`X,Y,Z`$ may be arbitrary internal sets; they are not required to be definable. All constants below are standard. Put

```math
E(u,v)=\mathbf 1_{\{\exists s\ne0:\ s^n=G(u,v)/\eta\}},
```

with value zero outside the admissible open set. This is a fixed-complexity definable predicate, with $`\eta`$ as a parameter.

By Lemma 3, outside a proper algebraic subset of the four-output space, (8) has uniformly bounded finite fibers. The number of input grids above the exceptional set is $`O(q^3)`$. On the complement let $`N_E(z_{11},z_{12},z_{21},z_{22})`$ count the grids for which all four corresponding values of $`E`$ equal one. This is a bounded integer-valued definable function: each of its finitely many level sets is definable.

Apply Tao's product regularity statement to those level sets. Refining the four coordinate partitions gives a common partition into finitely many definable output cells $`U_j`$, each of size $`\asymp q`$. Bounded exceptional cells can be merged into the others at a cost $`O(q^3)`$. If $`f`$ is real, bounded by one, supported on one $`U_j`$, and has mean zero there, the product main terms vanish. Therefore

```math
\left|\sum_{\mathbf z}N_E(\mathbf z)
             f(z_{11})f(z_{12})f(z_{21})f(z_{22})\right|
\ll q^{15/4}.
\tag{13}
```

The sum is over the nonexceptional outputs. Two Cauchy–Schwarz inequalities, with $`B_f(u,v)=E(u,v)f(K(u,v))`$, give

```math
\begin{aligned}
\left|\sum_{u\in X,v\in Y}B_f(u,v)\right|^4
\le |X|^2|Y|^2
\sum_{u,u',v,v'}
B_f(u,v)B_f(u,v')B_f(u',v)B_f(u',v').
\end{aligned}
```

The final sum is a sum of squares. Equation (13) and the $`O(q^3)`$ exceptional contribution imply

```math
\left|\sum_{u\in X,v\in Y}E(u,v)f(K(u,v))\right|
\ll q^{15/16}\sqrt{|X||Y|}.
\tag{14}
```

Define

```math
\mu(z)=\#\{(u,v)\in X\times Y:E(u,v)=1,\ K(u,v)=z\},
```

and let $`\mu_j`$ be its average on $`U_j`$. Taking the sign of $`\mu-\mu_j`$, subtracting its mean, and dividing by at most two yields

```math
\sum_{z\in U_j}|\mu(z)-\mu_j|
\ll q^{15/16}\sqrt{|X||Y|}.
\tag{15}
```

The remaining issue is a **positive lower bound for every cell mean**. The total mass of $`\mu`$ need not be $`|X||Y|`$, so the unrestricted pigeonhole argument would not suffice.

For a fixed $`U_j`$, apply two-variable definable regularity to

```math
F_j=\{(u,v):E(u,v)=1,\ K(u,v)\in U_j\}.
```

It partitions the input curves into finitely many linear-size definable cells $`V_i,W_k`$. On arbitrary subsets $`V'\subseteq V_i`$, $`W'\subseteq W_k`$, the count equals

```math
\sigma_{ik,j}|V'||W'|+O(q^{7/4}),
\tag{16}
```

where $`\sigma_{ik,j}\ge0`$ is standard. We claim every coefficient is positive.

We use the following consequence of Tao's finite-witness theorem. A linear-size definable subset of a curve contains the rational-point image of a dominant map from a geometrically integral curve defined over the field, with bounded fibers. To see this, express membership using finitely many polynomial root witnesses. On a dense open, remove identically zero equations and the zeros of generic leading coefficients, and divide by those coefficients to make the witness equations monic. Their simultaneous witness variety is finite over the base curve and has $`\gg q`$ rational points. A geometric component not defined over the field contributes only boundedly many rational points, since they lie in intersections with its distinct conjugates. Thus some one-dimensional geometric component is defined over the field and is dominant. Restrict it to a suitable open; its rational-point image is contained in the specified cell.

If $`\sigma_{ik,j}=0`$, (16) applied to the full cells gives $`|F_j\cap(V_i\times W_k)|=O(q^{7/4})`$. Choose the three curve covers supplied by the preceding observation for $`V_i,W_k,U_j`$. By Lemma 3, their pullback of (9) is a geometrically integral surface defined over the field. Lang–Weil gives $`\asymp q^2`$ rational points on its dense open. Its projection to $`(u,v)`$ has bounded fibers, including at most $`n`$ root choices, and every projected pair belongs to $`F_j\cap(V_i\times W_k)`$. This is a contradiction. Hence every coefficient is positive.

There are finitely many coefficients. Taking their positive minimum, summing (16) over the input cells, and absorbing bounded exceptional points gives

```math
\sum_{z\in U_j}\mu(z)\ge c_0|X||Y|-C_0q^{7/4}.
```

Use this inequality in (15) and sum over output cells after restricting to $`Z`$. Since $`|U_j|\asymp q`$,

```math
T_{n,\eta}(X,Y,Z)
\ge c_1\frac{|X||Y||Z|}{q}
 -C_1q^{3/4}|Z|
 -C_1q^{15/16}\sqrt{|X||Y|}.
\tag{17}
```

If $`|X||Y|\ge q^{15/8}`$, the middle error is absorbed by the last one. If $`|X||Y|\le q^{15/8}`$, the proposed main term in (12) is already at most a constant times the last error, so (12) is vacuous after enlarging that constant. This proves the nonstandard estimate in every size range.

Finally, uniform finite-prime constants follow by contradiction. If they did not exist, for each integer $`j`$ choose a prime $`p\ge j`$, a parameter $`\eta\ne0`$, and sets violating (12) with $`c_n=1/j`$, $`C_n=j`$. Their ultraproduct is of characteristic zero. The argument just given, valid for its nonzero parameter $`\eta`$, supplies a positive standard lower constant and a finite standard error constant. For large $`j`$ these imply the weaker inequality with $`1/j,j`$, a contradiction. The geometric argument is used only in characteristic zero; no uniform statement about arbitrary wild covers in fixed small characteristic is assumed. $`\square`$

## 5. Forcing the colors into the coset

We prove Theorem 1. Let $`h=|H\setminus\{0\}|`$. Since $`\mathbb F_p^\times`$ is cyclic and $`C`$ has index $`\ell`$,

```math
C=(\mathbb F_p^\times)^\ell.
```

Choose a coset $`\lambda C`$ with $`H_0=H\cap\lambda C`$ of size at least $`h/\ell`$. Split $`H_0`$ into disjoint sets $`X,Y`$ of comparable size, and take $`Z=H_0`$. Bounded small sizes are absorbed by (2).

Apply Lemma 4 with $`n=3\ell`$ and $`\eta=t^3`$. Every counted pair gives $`u,v,k=K(u,v)\in H_0`$ and a nonzero $`s`$ with $`s^{3\ell}=G(u,v)/t^3`$. Set

```math
a=ts^\ell,\qquad b=ak/v,\qquad c=ak/u.
```

Then $`a^3=G(u,v)`$ and $`a\in tC`$. Also $`k/v,k/u\in C`$, so $`b,c\in tC`$. Disjointness of $`X,Y`$ gives $`u\ne v`$; the admissible open set supplies all remaining exclusions in Lemma 2.

Count configurations using their actual repeated color $`a`$, not their witnesses $`s`$. Every pair counted by Lemma 4 supplies at least one configuration; there are at most three possible $`a`$ for a given pair. Their total number $`T`$ therefore satisfies

```math
T\ge c_Lh^3/p-C_Lp^{15/16}h.
\tag{18}
```

Every such configuration must have either a color in $`tC\setminus A`$ or an eligible incidence in $`(A\cap tC)\times H`$ that is not retained. Otherwise all four edges occur in the actual graph, contradicting the B condition. Lemma 2 gives

```math
c_Lh^3/p-C_Lp^{15/16}h\le T\le3pD+16R.
\tag{19}
```

If the error in the lower bound is at least half its main term, then $`h\ll_Lp^{31/32}`$. Otherwise $`h^3\ll_Lp(R+pD)`$. Since $`m\le p(h+1)`$, both alternatives imply (2). Potential zero contributes at most $`p-1`$ incidences and is absorbed. Taking maxima and minima over the finitely many $`1\le\ell\le L`$ makes all constants depend only on $`L`$. $`\square`$

## 6. Relation to earlier work and remaining scope

The proof uses the framework and quantitative loss of Tao's algebraic regularity and expansion theory. The application-specific work is the configuration (4), the separate-cover and root-cover checks in Lemma 3, the positivity argument in Lemma 4, and the transfer into one palette coset. The higher-root lemma is a technical consequence of that established framework, not a new general expansion method.

The common potential condition differs from the common **row** support condition in the [companion note](common-affine-supports.md): here the row domain is $`H/a^2-a`$ and varies with the color. An arbitrary positive-density palette need not contain almost all of any bounded-index coset. No argument above replaces its three coupled color memberships by independent densities, and no structural reduction puts general #810 colorings into this model.

The exact application was not located in the literature comparison, but that does not establish priority. The equal-size matching theorem in Gyárfás–Sárközy requires matching size greater than two thirds of a vertex class, whereas $`|H|`$ here may be a small fraction of $`p`$. The accessible description of Gyárfás–Sárközy–Wagner concerns perfect matchings and translation-invariant colorings; without a complete comparison of that paper, possible overlap remains unresolved. These qualifications concern historical novelty, not additional hypotheses of Theorem 1.

## References

1. T. Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*, Contributions to Discrete Mathematics **10**(1) (2015), 22–98. [Published version](https://doi.org/10.55016/ojs/cdm.v10i1.62182); [preprint](https://arxiv.org/pdf/1211.2894). Inputs: Lemma 23, Theorem 25, Corollary 37, Remark 39, and the proofs of Theorems 38 and 40. In the published pagination, Theorem 38 and its proof occupy pp. 61–64, Remark 39 pp. 64–65, and Theorem 40 and its proof pp. 65–67. The present restricted-source lower bound is derived in Section 4, rather than attributed to the literal statement of Theorem 40.
2. A. Gyárfás and G. N. Sárközy, *“Less” Strong Chromatic Indices and the (7,4)-Conjecture*, Studia Scientiarum Mathematicarum Hungarica **60** (2023), 109–122. [Published PDF](https://real.mtak.hu/191892/1/012-article-p109.pdf). See Theorem 2.2 for the matching-size comparison.
3. A. Gyárfás, G. N. Sárközy, and A. Z. Wagner, *Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*, Discrete Mathematics **349**(6) (2026), 115005. [DOI](https://doi.org/10.1016/j.disc.2026.115005). Full-text comparison remains outstanding.
