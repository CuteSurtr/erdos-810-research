# A power saving for quadratic affine B-colorings with fixed-formula palettes or supports

## Abstract

Consider a bipartite graph over a prime field whose edge of color $`a`$ and potential $`h`$ joins $`h/a^2-a`$ to $`h/a`$. Every color draws its potentials from the same set $`H`$. If either the palette or the nonzero potential set is defined by one fixed formula in the language of rings, and all eligible incidences are retained, then a simple proper coloring with every four-cycle rainbow has $`O_\varphi(p^{2-1/32})`$ edges. The other set is arbitrary, and the formula's parameter values may vary with the prime. A quantitative version permits omissions from a dense definable core. The proof combines an explicit three-color rectangle, finite-cover compatibility, and an adaptation of Tao's algebraic expansion argument. A fixed-index coset theorem is proved first as a special case.

**Scope and status.** The result concerns the specified common-potential model. It gives no bound for unrestricted Erdős problem #810. The argument is a written mathematical proof, not a Lean certificate. The full 2026 paper on perfect colorings has been compared with this result; the distinctions and the comparison with algebraic regularity theorems are given in Section 7. Broader historical novelty remains unestablished. The analytic machinery and its exponent are inherited from [Tao](#references), and no priority or record claim is made.

## 1. The model and the coset theorem

A **B-coloring** is a proper edge-coloring in which every four-cycle is rainbow. The two vertex classes below are distinct copies of $`\mathbb F_p`$. For $`A\subseteq\mathbb F_p^\times`$ and $`H\subseteq\mathbb F_p`$, an *eligible incidence* is a pair $`(a,h)\in A\times H`$, representing color $`a`$ on the edge

```math
(x,y)=\left(\frac{h}{a^2}-a,\frac{h}{a}\right).
\qquad\text{(1)}
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
\qquad\text{(2)}
```

Here $`H`$ is arbitrary, other colors in $`A`$ are unrestricted, and $`m`$ counts **all** retained edges. The deficit $`R`$ concerns only the designated coset.

If $`D=R=0`$, (2) gives $`m=O_L(p^{2-1/32})`$. More generally, $`D=o(p)`$ and $`R=o(p^2)`$ imply $`m=o(p^2)`$. Since there are $`N=2p`$ vertices, the same power saving holds in terms of $`N`$ for this family. The index bound is fixed independently of $`p`$; no uniform conclusion for growing index is asserted. The constants are not numerically explicit here.

The fixed-formula extension, including the symmetric assertion for the support, is Theorem 5 in Section 6.

The conclusion uses more than properness. For example, suppose $`p\equiv1\pmod3`$, take the full palette, and take $`H`$ inside one nontrivial cubic coset. Two distinct color lines $`a,b`$ meet at $`(-a-b,-ab)`$, where their potentials are $`-a^2b,-ab^2`$. Their product is a cube, whereas the product of two elements of the same nontrivial cubic coset is not. Thus the completed incidence system is simple and proper, and can have $`\Theta(p^2)`$ edges. Theorem 1 forces a non-rainbow four-cycle in a dense such system.

## 2. A rectangle with three potential values

Set

```math
K(u,v)=\frac{uv(u+v)}{u^2+v^2},
\qquad
G(u,v)=-\frac{(u^2+uv+v^2)(u^2+v^2)}{uv(u+v)}.
\qquad\text{(3)}
```

Throughout, the *admissible open set* excludes zeros of $`uv(u+v)(u^2+v^2)(u^2+uv+v^2)`$. A nondegenerate configuration also requires $`u\ne v`$.

**Lemma 2.** Suppose $`k=K(u,v)`$ and $`a^3=G(u,v)`$ on this open set, with $`u\ne v`$. Put

```math
b=ak/v,\qquad c=ak/u.
```

The four incidences

```math
(a,u),\quad(a,v),\quad(b,k),\quad(c,k)
\qquad\text{(4)}
```

form a nondegenerate four-cycle with color matrix $`\begin{pmatrix}a&b\\c&a\end{pmatrix}`$. Its three colors are distinct. Among all such ordered configurations, a fixed colored incidence occurs at most sixteen times, and a fixed color occurs at most $`3p`$ times.

**Proof.** Write $`q=v/u`$ and define

```math
Q=q^2+1,\qquad B=q^2+q+1,\qquad
r=\frac{q+1}{Q},\qquad
F=-\frac{BQ}{q(q+1)}.
\qquad\text{(5)}
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
\qquad\text{(6)}
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
\qquad\text{(7)}
```

Each prescribed-value equation becomes a nonzero polynomial of degree at most four after clearing denominators. The first, second, and fourth numerators have degree four and larger degree than their denominators. In the third equation the denominator has degree four, the numerator degree three, and the prescribed value is nonzero. Each role therefore permits at most four values of $`q`$. The role and $`q`$ recover the entire configuration, proving the bound sixteen. A fixed color has three possible roles $`a,b,c`$, each with at most $`p`$ choices of $`q`$; the corresponding repeated color is recovered as $`a`$, $`b/r`$, or $`c/(qr)`$. This proves the second bound. $`\square`$

## 3. The geometric checks

The following verification supplies the geometric hypotheses for the counting argument in Section 4. Work first over an algebraically closed field $`k_0`$ of characteristic zero. A separate coordinate cover means a dominant map from a geometrically integral curve to one of the three coordinate lines. All assertions concern the natural dense open sets, so zeros, poles, and finitely many branch points may be removed.

**Lemma 3.** The four-output map

```math
(u,u',v,v')\longmapsto
\bigl(K(u,v),K(u,v'),K(u',v),K(u',v')\bigr)
\qquad\text{(8)}
```

is dominant and generically finite. Moreover, for every fixed integer $`n\ge1`$ and $`\eta\ne0`$, the surface

```math
z=K(u,v),\qquad s^n=G(u,v)/\eta
\qquad\text{(9)}
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
\qquad\text{(10)}
```

Thus $`F=k_0(u,v)`$ is regular over $`k_0(z)`$. For every $`z_0\in\mathbb P^1(k_0)`$, the fiber has a multiplicity-one divisor on which both $`u`$ and $`v`$ vary: for finite nonzero $`z_0`$, use the conic (10); for zero, use $`u+v=0`$; for infinity, use either component $`v=\pm iu`$ of $`u^2+v^2=0`$. The indicated numerator or denominator has a simple zero at the generic point of each chosen component.

Pass the three coordinate covers to Galois closures, with function fields $`L_u/k_0(u)`$, $`L_v/k_0(v)`$, and $`L_z/k_0(z)`$. The product of the first two covering curves is geometrically integral. Inside a common algebraic closure of $`F`$, put

```math
E=FL_uL_v,\qquad M=FL_z,\qquad J=E\cap M.
```

Regularity identifies $`\mathrm{Gal}(M/F)`$ with $`\mathrm{Gal}(L_z/k_0(z))`$. The extension $`E/F`$ is unramified at every chosen fiber divisor: branches of the input covers are vertical or horizontal, whereas both coordinates vary along that divisor. Hence $`J/F`$ is unramified there.

Target inertia survives this base change, because the target local parameter has valuation one. In characteristic zero a tame extension of inertia order $`e`$ is locally generated by an $`e`$th root of a parameter; its ramification index remains $`e`$ after this pullback. Each target inertia subgroup consequently lies in $`\mathrm{Gal}(M/J)`$. This is a normal subgroup, since $`J/F`$ is Galois. Target inertia normally generates the whole group: its quotient would give an everywhere-unramified finite cover of $`\mathbb P^1`$, which has degree one by Riemann–Hurwitz. Therefore $`J=F`$. The Galois extensions $`E,M`$ are linearly disjoint, and so are the relevant subextensions. This proves integrality of the base relation after the three covers. Restricting the curve maps to finite flat maps on suitable opens ensures that the corresponding fiber product has no additional vertical components there.

It remains to adjoin the root in (9). Let $`\omega`$ be a primitive cube root of unity and consider the divisor $`v=\omega u`$ on the base surface. Along it,

```math
K(u,\omega u)=\omega^2u,
\qquad
\mathrm{ord}_{v=\omega u}G=1.
\qquad\text{(11)}
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
\qquad\text{(12)}
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
\qquad\text{(13)}
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
\qquad\text{(14)}
```

Define

```math
\mu(z)=\#\{(u,v)\in X\times Y:E(u,v)=1,\ K(u,v)=z\},
```

and let $`\mu_j`$ be its average on $`U_j`$. Taking the sign of $`\mu-\mu_j`$, subtracting its mean, and dividing by at most two yields

```math
\sum_{z\in U_j}|\mu(z)-\mu_j|
\ll q^{15/16}\sqrt{|X||Y|}.
\qquad\text{(15)}
```

The remaining issue is a **positive lower bound for every cell mean**. The total mass of $`\mu`$ need not be $`|X||Y|`$, so the unrestricted pigeonhole argument would not suffice.

For a fixed $`U_j`$, apply two-variable definable regularity to

```math
F_j=\{(u,v):E(u,v)=1,\ K(u,v)\in U_j\}.
```

It partitions the input curves into finitely many linear-size definable cells $`V_i,W_k`$. On arbitrary subsets $`V'\subseteq V_i`$, $`W'\subseteq W_k`$, the count equals

```math
\sigma_{ik,j}|V'||W'|+O(q^{7/4}),
\qquad\text{(16)}
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
\qquad\text{(17)}
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
\qquad\text{(18)}
```

Every such configuration must have either a color in $`tC\setminus A`$ or an eligible incidence in $`(A\cap tC)\times H`$ that is not retained. Otherwise all four edges occur in the actual graph, contradicting the B condition. Lemma 2 gives

```math
c_Lh^3/p-C_Lp^{15/16}h\le T\le3pD+16R.
\qquad\text{(19)}
```

If the error in the lower bound is at least half its main term, then $`h\ll_Lp^{31/32}`$. Otherwise $`h^3\ll_Lp(R+pD)`$. Since $`m\le p(h+1)`$, both alternatives imply (2). Potential zero contributes at most $`p-1`$ incidences and is absorbed. Taking maxima and minima over the finitely many $`1\le\ell\le L`$ makes all constants depend only on $`L`$. $`\square`$

## 6. Fixed-formula palettes and supports

A *fixed-formula family* means a single formula $`\varphi(z;\mathbf t)`$ in the language of rings, chosen independently of $`p`$. Its finite tuple of parameters $`\mathbf t\in\mathbb F_p^s`$ may vary. The number of parameters, polynomial degrees, Boolean operations, and quantifier structure remain fixed. Write

```math
S_{\varphi,\mathbf t}
 =\{z\in\mathbb F_p^\times:
          \mathbb F_p\models\varphi(z;\mathbf t)\}.
```

Fixed-degree polynomial images, fixed-exponent residue conditions, and fixed finite Boolean combinations of these conditions are examples. Encoding an arbitrary set by a list or an interpolation polynomial of growing degree is excluded.

**Theorem 5.** Fix $`\varphi`$. Suppose every incidence in $`A\times H`$ in (1) is retained and forms a simple graph with a B-coloring. If either $`A`$ or $`H\setminus\{0\}`$ equals $`S_{\varphi,\mathbf t}`$, then, uniformly in the parameter values and in the other set,

```math
m\ll_\varphi p^{63/32}.
\qquad\text{(20)}
```

There are also the following two robust versions. Fix $`\delta>0`$ and retain any subset of $`A\times H`$ forming a simple graph with a B-coloring.

- **Palette core.** Let $`A_0=S_{\varphi,\mathbf t}`$ have size at least $`\delta p`$. Put $`d=|A_0\setminus A|`$, and let $`R`$ count omitted incidences only in $`(A\cap A_0)\times H`$.
- **Support core.** Let $`H_0=S_{\varphi,\mathbf t}`$ have size at least $`\delta p`$. Put $`d=|H_0\setminus H|`$, and let $`R`$ count omitted incidences only in $`A\times(H\cap H_0)`$.

In either version,

```math
m\ll_{\varphi,\delta}
 p^{63/32}+p^{4/3}(R+pd)^{1/3}.
\qquad\text{(21)}
```

Here $`m`$ counts **all** retained incidences, including arbitrary extra colors or potential values outside the designated core. In particular, $`d=o(p)`$ and $`R=o(p^2)`$ imply $`m=o(p^2)`$. The exact statement (20) requires no separately specified density lower bound. The lower configuration counts used below, however, are asserted only for dense cores or infinite definable sets in a characteristic-zero ultraproduct.

### 6.1. The counting principle needed for the extension

The analytic part of Lemma 4 works for a predicate $`E(u,v)`$ given by one fixed ring-language formula with finitely many varying parameters on the admissible open set, provided its cell-positivity step can be proved. The four-grid map remains (8). Its restricted fiber count is still a bounded integer-valued definable function. Thus (13)–(16), including the error $`O(p^{15/16}\sqrt{|X||Y|})`$, are unchanged.

We will restrict all three counting coordinates to one coset $`\lambda(\mathbb F_p^\times)^n`$, with $`n`$ bounded. Apply the partitions only to this definable domain. Each linear-size cell admits a finite witness curve as in Section 4; append the equation specifying its $`n`$th root before choosing the component. To establish positivity, it suffices to prove the following: for any three such witness curves, there is a geometrically integral surface, defined over the ground field and finite dominant over a dense open of $`z=K(u,v)`$, whose rational points on a designated dense open project into the three cells and satisfy $`E`$. Lang–Weil and bounded fibers then contradict a zero coefficient in (16). Removing finitely many bad fibers or a proper algebraic subset costs $`O(p)`$ pairs and does not affect this argument.

Once this geometric condition is verified, the rest of (17) and its error absorption proves

```math
\#\{(u,v)\in X\times Y:K(u,v)\in Z,\ E(u,v)\}
\ge c\frac{|X||Y||Z|}{p}
       -Cp^{15/16}\sqrt{|X||Y|}
\qquad\text{(22)}
```

for arbitrary subsets $`X,Y,Z`$ of the selected coset. The constants are uniform in the sets, with dependence on the fixed definable data. Uniformity over varying finite-field parameters follows when the positivity hypothesis holds in every characteristic-zero ultraproduct of the allowed data. In the application, the auxiliary covers can be chosen inside that ultraproduct; Section 6.5 then gives constants for the original formula. This is an adaptation of the proof of Lemma 4, not an invocation of the literal statement of Tao's Theorem 40. The next three subsections supply precisely its extra geometric hypothesis.

### 6.2. A witness cover and its power-map quotient

Let $`k`$ be a characteristic-zero ultraproduct of prime fields and let $`S\subseteq k^\times`$ be an infinite unary definable set. The witness construction in Section 4 gives a geometrically integral curve $`V/k`$ and a finite separable map to the coordinate line whose rational-point image, on a designated open, lies in $`S`$. More explicitly, Tao's Theorem 25 expresses membership by finitely many polynomial root witnesses. After deleting zeros of leading coefficients these equations are monic, so the simultaneous witness variety is finite over the line. A geometric component not defined over $`k`$ has rational points only in its intersections with distinct conjugates. Such intersections are finite. Since the witness variety has infinitely many rational points, some dominant geometric curve component is defined over $`k`$. Normalize it and restrict to an appropriate open. Its function field is regular over the **constant field** $`k`$.

We need a cover $`Z`$ dominating $`V`$ that is geometrically Galois and still defined over $`k`$. Here is the standard field-crossing construction, including the domination property. Write $`z`$ for the base coordinate, let $`L/k(z)`$ be the arithmetic Galois closure of $`k(V)/k(z)`$, and let $`k_e`$ be its constant field. Set

```math
\Gamma=\mathrm{Gal}(L/k(z)),\qquad
G=\mathrm{Gal}(L/k_e(z)),\qquad
J=\mathrm{Gal}(L/k(V)).
```

Regularity over $`k`$ implies that $`J`$ maps onto $`\mathrm{Gal}(k_e/k)`$. Choose $`\sigma\in J`$ lifting a generator of this cyclic group, and put $`M=\mathrm{ord}(\sigma)`$; then $`e\mid M`$. Let $`k_M/k`$ be the cyclic constant extension of degree $`M`$, choose a compatible generator $`\gamma`$, and put $`L'=Lk_M`$. The element $`\sigma'=(\sigma,\gamma)`$ of

```math
\mathrm{Gal}(L'/k(z))
 =\Gamma\times_{\mathrm{Gal}(k_e/k)}\mathrm{Gal}(k_M/k)
```

has order $`M`$. Its fixed field $`E_0=(L')^{\langle\sigma'\rangle}`$ has constants exactly $`k`$, contains $`k(V)`$, and has degree $`|G|`$ over $`k(z)`$. Moreover $`E_0k_M=L'`$: the subgroup $`\langle\sigma'\rangle`$ intersects the geometric group trivially. The curve $`Z`$ with function field $`E_0`$ is therefore regular, geometrically Galois, and dominates $`V`$ over $`k`$. Its rational image on the designated open remains inside $`S`$. Enlarging the constants before taking the fixed field is necessary when $`M>e`$.

All degrees here are bounded in the witness degree $`d`$, since $`|\Gamma|\le d!`$. The geometric Galois closure has no new branch values, and Riemann–Hurwitz bounds its genus. The construction is consequently of bounded complexity. Equivalently it can be performed over the finite fields before passage to an ultraproduct. This is standard field crossing; see Dèbes–Legrand in the references.

Over algebraically closed constants, let $`N\trianglelefteq G`$ be the normal subgroup generated by inertia at every finite nonzero value of $`z`$. Arithmetic descent preserves this subgroup, so the quotient $`W=Z/N`$ descends to $`k`$. It is geometrically a connected cover of $`\mathbb G_m`$ unramified there, hence a cyclic power cover. Its unique points over zero and infinity are individually rational over $`k`$. Thus $`W\cong\mathbb P^1_k`$, with a coordinate $`w`$ for which

```math
z=\tau w^n,\qquad \tau\in k^\times.
\qquad\text{(23)}
```

The degree $`n`$ is bounded. It need not divide $`p-1`$: the index of $`(\mathbb F_p^\times)^n`$ is at most $`n`$.

The residual cover $`Z\to W`$ has geometric group $`N`$. Its inertia at **all** finite nonzero $`w`$-values normally generates $`N`$. Indeed, including every lift of each nonzero $`z`$-value includes every $`G`$-conjugate of the original inertia generators. Their normal closure inside $`N`$ is therefore $`N`$ itself. This use of all lifts will be essential below.

### 6.3. Palette covers: compatible roots and residual inertia

Apply Section 6.2 to a dense palette core $`A_0`$, with quotient $`a=\tau w^n`$. In the arbitrary nonzero support choose a largest slice in a coset $`\lambda(k^\times)^n`$, losing a factor at most $`n`$. Three witness curves for cells in this coset can be chosen to carry functions $`x,y,z`$ with

```math
u=\lambda x^n,\qquad v=\lambda y^n,\qquad k_1=\lambda z^n,
\qquad k_1=K(u,v).
```

Here $`k_1`$ denotes the third potential; $`k`$ continues to denote the ground field. Lemma 3 shows that adjoining $`w^{3n}=G(u,v)/\tau^3`$ to these separate curves gives a geometrically integral surface. Denote its function field by $`M_0`$. Set

```math
a=\tau w^n,\qquad
w_a=w,\qquad w_b=wz/y,\qquad w_c=wz/x.
```

The identities in Lemma 2 give

```math
a=\tau w_a^n,\qquad b=\tau w_b^n,\qquad c=\tau w_c^n.
\qquad\text{(24)}
```

Thus these are specified maps into the three power-map quotients over the ground field, not just assertions of power-residue membership.

We next adjoin the residual cover at each $`w_i`$. Work over $`\bar k`$ and retain $`q,r,F`$ from (5). The ratios of color cubed to potential are

```math
\begin{pmatrix}
 a^3/u&a^3/v&a^3/k_1\\
 b^3/u&b^3/v&b^3/k_1\\
 c^3/u&c^3/v&c^3/k_1
\end{pmatrix}
=
\begin{pmatrix}
 F&F/q&F/(qr)\\
 Fr^3&Fr^3/q&Fr^2/q\\
 Fq^3r^3&Fq^2r^3&Fq^2r^2
\end{pmatrix}.
\qquad\text{(25)}
```

Every entry is nonconstant: its growth exponent at infinity is the corresponding entry of

```math
\begin{pmatrix}2&1&2\\-1&-2&-1\\2&1&2\end{pmatrix}.
```

For a selected color index $`i`$, the functions $`w_i,q`$ are algebraically independent and $`M_0`$ is finite over $`K_i=\bar k(w_i,q)`$. Indeed,

```math
a=\tau w_i^n/r_i(q),\qquad (r_a,r_b,r_c)=(1,r,qr),
```

recovers all three potentials rationally, and their witness curves supply only finite extensions. The original root is recovered as $`w=w_a`$, $`w=w_by/z`$, or $`w=w_cx/z`$, so these extensions account for the whole field $`M_0`$. At the generic divisor $`w_i=\theta\ne0`$, (25) shows that every potential is nonconstant as a function of $`q`$. The other two colors are also nonconstant, since the relevant ratios are among $`r,qr,q`$ and their inverses.

Consequently every separate potential cover is unramified at every valuation over this divisor: its coordinate has transcendental residue, so it avoids every constant branch value. The additional root equations have unit radicands and are étale in characteristic zero. This describes a finite étale tower at the divisor and proves that $`M_0/K_i`$ is unramified at all its extensions. Previously adjoined residual color covers are unramified there too: their quotient coordinate has nonconstant $`n`$th power, hence is nonconstant and avoids their branch values.

Let $`M`$ contain $`M_0`$ and any such earlier residual covers, and let $`\widetilde M/K_i`$ be its finite Galois closure. It is still unramified at these divisors. The selected residual cover has field $`L_i/\bar k(w_i)`$ and group $`N`$. The extension $`L_i(q)/K_i`$ is Galois with the same group. Its intersection with $`\widetilde M`$ is a Galois intermediate field. Since the intersection is unramified at every finite nonzero $`w_i`$-value, its corresponding normal subgroup contains all the residual inertia groups. Section 6.2 says these generate $`N`$. Hence

```math
L_i(q)\cap\widetilde M=K_i.
```

The Galois extensions are linearly disjoint. Adjoining this residual cover therefore preserves integrality and its full degree. Repeat for the three colors. The resulting surface is geometrically integral; all maps and designated roots were defined over $`k`$, so it is defined over $`k`$ as well. No regularity assertion over the one-variable field $`\bar k(w_i)`$ is needed.

Take $`E(u,v)`$ to assert existence of $`a^3=G(u,v)`$ and rational points on the designated open of $`Z`$ above each of $`a,b,c`$. It forces all three colors into $`A_0`$. The surface just constructed proves the cell-positivity hypothesis of (22), for every triple of cell witnesses.

### 6.4. Support covers and inverse colors

For the support version the same rational counting map appears after inverting the colors. Put

```math
s=1/b,\qquad t=1/c,\qquad w=1/a.
```

The relation $`a(b+c)=b^2+c^2`$ is equivalent to $`w=K(s,t)`$. Conversely, the inverse-color pair recovers $`q=s/t`$ and all three potentials:

```math
k_1=\kappa(s,t)=-\frac1{w(s^2+st+t^2)},
\qquad u=k_1t/w,\qquad v=k_1s/w.
\qquad\text{(26)}
```

At the divisor $`t=\omega s`$, where $`\omega`$ is a primitive cube root of unity, $`w=\omega^2s`$ and $`\mathrm{ord}\,\kappa=-1`$. All three inverse-color coordinates vary there. Thus arbitrary separate covers of $`s,t,w`$ are unramified there, and adjoining

```math
\xi^n=\kappa/\lambda
\qquad\text{(27)}
```

preserves geometric integrality: the reciprocal-root polynomial is Eisenstein at a valuation above this divisor. This is the support counterpart of the last part of Lemma 3.

Apply Section 6.2 to $`H_0`$, with quotient $`h=\lambda\eta^n`$. Choose a largest slice of $`A^{-1}`$ in a coset $`\mu(k^\times)^n`$. The cell witness curves carry functions satisfying

```math
s=\mu x^n,\qquad t=\mu y^n,\qquad w=\mu z^n.
```

Their pullback of $`w=K(s,t)`$ and (27) is geometrically integral. On it choose

```math
\eta_{k_1}=\xi,\qquad \eta_u=\xi y/z,\qquad \eta_v=\xi x/z.
```

Equation (26) gives the actual identities $`k_1=\lambda\eta_{k_1}^n`$, $`u=\lambda\eta_u^n`$, and $`v=\lambda\eta_v^n`$.

For each potential index $`i`$, use the two-variable base field $`K_i=\bar k(\eta_i,q)`$. If

```math
(\psi_u,\psi_v,\psi_{k_1})=(1/F,q/F,qr/F),
```

then $`a^3=\lambda\eta_i^n/\psi_i(q)`$ recovers the colors by a finite cubic extension. Together with the inverse-color witness curves this recovers the entire field, since $`\xi=\eta_{k_1}`$, $`\xi=\eta_uz/y`$, or $`\xi=\eta_vz/x`$. At every divisor $`\eta_i=\theta\ne0`$ the radicand is a unit, so that extension is unramified. Equation (25) shows that all three colors, and therefore their inverses, are nonconstant there. The separate inverse-color covers and their specified roots are consequently unramified at every extension of that valuation. The other potentials have nonconstant ratios $`q,r,qr`$ or their inverses to the selected potential. Thus previously adjoined residual support covers are also unramified there.

The Galois-closure intersection argument of Section 6.3 now applies with $`\eta_i`$ in place of $`w_i`$. All finite nonzero residual inertia groups remain visible, so each residual support cover is linearly disjoint from the preceding compositum. This proves geometric integrality of the entire lifted surface over the ground field.

Define $`E(s,t)`$ by the existence of rational points of $`Z`$ over all three potentials in (26). Its accepted pairs have $`u,v,k_1\in H_0`$. The preceding construction verifies the cell-positivity hypothesis of (22) on the selected inverse-color coset, with the same map $`K`$ and the same error exponent.

### 6.5. Configuration counts, omissions, and uniformity

For a dense palette core, apply (22) to disjoint comparable subsets of the chosen support slice as inputs and the whole slice as output. Count actual ordered configurations, rather than their witness points. Every accepted pair supplies at least one configuration, with at most three choices of its repeated color. If $`h=|H\setminus\{0\}|`$, this gives

```math
N\ge ch^3/p-Cp^{15/16}h,
\qquad N\le3pd+16R.
\qquad\text{(28)}
```

The upper bound follows from Lemma 2, since each forbidden configuration must lose a core color or an incidence in the designated core subsystem. As in Section 5, $`m\le p(h+1)`$ yields (21), including extra colors outside the core.

For a dense support core, apply (22) to disjoint comparable subsets of the chosen inverse-color slice. Distinct input pairs give distinct actual configurations. The condition $`s\ne t`$ and the admissible open ensure nondegeneracy. A fixed potential value belongs to at most $`9p`$ configurations: it has three roles, and for each $`q`$ its value prescribes a cubic equation for $`a`$ with at most three roots. Lemma 2 still bounds the multiplicity of a fixed incidence by sixteen. Therefore

```math
N\ge c|A|^3/p-Cp^{15/16}|A|,
\qquad N\le9pd+16R.
\qquad\text{(29)}
```

Using $`m\le p|A|`$ yields (21), including arbitrary extra potential values.

Uniform constants in (21) follow by the same contradiction argument as in Section 4. A hypothetical sequence of failures, with fixed $`\varphi,\delta`$ but varying parameters, gives a characteristic-zero ultraproduct with an infinite definable core. The witness, descent, and positivity arguments supply standard positive lower constants and finite error constants there, contradicting the failures. The fixed formula ensures standard finite complexity throughout; no effective numerical bound for the constants is asserted.

Finally, (20) follows without a specified $`\delta`$. A bounded palette or support has only $`O(p)`$ incidences. Along any sequence violating a uniform $`O_\varphi(p^{63/32})`$ bound, the relevant definable set must therefore be infinite in the ultraproduct. Finite-witness extraction and Lang–Weil then give a positive standard density and the configuration count above. With no omissions, (28) or (29) forces the asserted power saving, a contradiction. $`\square`$

## 7. Relation to earlier work and remaining scope

The proof uses the framework and quantitative loss of Tao's algebraic regularity and expansion theory. The application-specific work is the configuration (4), the separate-cover and root-cover checks in Lemma 3, and the compatibility verification in Sections 6.3–6.4. The latter resolves the power-map quotients by designated roots and preserves the remaining inertia after all other covers. Together with the restricted counting argument, it gives the colored-graph consequence. Finite witnesses, field crossing, and the analytic exponent are inherited tools.

The common potential condition differs from the common **row** support condition in the [companion note](common-affine-supports.md): here the row domain is $`H/a^2-a`$ and varies with the color. Theorem 5 removes the coset hypothesis when either set has fixed definable complexity. It does not cover two arbitrary sets: an arbitrary positive-density set need not contain almost all of a dense fixed-formula core. No structural reduction puts general #810 colorings into this model.

### Comparison with algebraic regularity and expansion

Tao's Theorems 38 and 40 give expansion for maps from a Cartesian product, and their proofs already use the four-output grid and finite witnesses to establish cell positivity. Remark 39 extends an upper incidence estimate to finite-fiber correspondences. Rational maps become regular on suitable opens, with the exceptional loci accounted for, so rationality is not the distinction here. The extra requirement is the joint predicate imposing three further cover conditions on the same parameter surface. Sections 4 and 6.1 retain the analytic argument; Sections 6.2–6.4 supply positivity with those conditions.

Chevalier–Levi's algebraic hypergraph regularity framework also handles finite-cover predicates. Its stochastic independence theorem assumes a regular system, and compatible base change is a substantive hypothesis. The relation $`w=K(s,t)`$ has dimension two and is not dominant over the three-line product, as their system definition would require in that direct setup. Treating it simply as a sparse definable hypergraph gives no lower count either: its entire size is at the $`O(p^2)`$ small-cell scale allowed by their three-coordinate regularity theorem. Reparameterizing by two variables leaves three coupled arbitrary-set tests. The required finite-cover compatibility must still be checked.

Pillay–Stonestrom make a bounded-definable subset of a finite definable group quasirandom on bounded-index subgroup cosets. Their principal relation is $`xy^{-1}\in D`$. They also note that their improved four-cycle discrepancy applies in Tao's general graph setting. That discrepancy and the cut error used here have different normalizations; it is not a direct improvement of the exponent in (22). Their result does not by itself supply the joint lower count for the six coupled color and potential coordinates under arbitrary tests on the other set.

These comparisons identify the additional geometric verification needed to apply the established methods. They do not exclude another deduction of this consequence from those methods, and do not establish historical priority. In particular, no general theorem that six arbitrary covers are independent is asserted: the designated power-map compatibility is essential.

The equal-size matching theorem in Gyárfás–Sárközy requires matching size greater than two thirds of a vertex class, whereas $`|H|`$ here may be a small fraction of $`p`$.

### Comparison with perfect colorings

In Gyárfás–Sárközy–Wagner (2026), Theorem 2.3 concerns shifted perfect matchings and modular three-term progressions. Theorem 2.7 treats a broader class of perfect B-colorings with a fixed-fraction translation-invariance condition: a positive fraction of vertices each have a positive fraction of colors such that every relevant pair satisfies a specified five-edge path-closing condition. This is stronger than requiring merely a positive density of successful paths. Its proof uses perfectness to construct the auxiliary matchings in Claim 3.2 and to supply cross-color edges in the induced-matching argument.

Our complete coset subsystem generally fails perfectness for a structural reason. Color $`a\in tC`$ has endpoint sets

```math
Y_a=H/a,\qquad X_a=H/a^2-a.
```

Suppose $`\varnothing\ne H\ne\mathbb F_p`$ and $`|C|\ge2`$. If all $`Y_a`$ agree, comparison with $`a=t`$ makes $`H`$ invariant under multiplication by $`C`$. Consequently $`H/a^2=H/t^2`$. If all $`X_a`$ also agree, then $`H/t^2`$ is invariant under translation by $`a-b\ne0`$ for two distinct colors. A nonzero element generates the additive group of $`\mathbb F_p`$, forcing $`H`$ to be empty or the whole field, a contradiction. Thus even independent common relabelings of the two vertex classes cannot make these matchings perfect on common endpoint sets.

The proof-level distinction is equally concrete. Choose the natural base bijection $`f_\beta(x)=\beta x+\beta^2`$, with $`\beta\ne0`$. Starting from a color-$`b`$ incidence with potential $`h\in H`$, following the base bijection backwards from its column and then following color $`b`$ again would require

```math
h'=(b/\beta)h+b^2(b-\beta)\in H.
```

The arbitrary set $`H`$ need not have this invariance. Hence perfectness cannot simply be dropped from that construction. This calculation concerns the stated base choice; it does not exclude a different completion or an additional incidence-preserving reduction.

The Behrend-type examples accompanying Theorem 2.3 have $`n^{2-o(1)}`$ edges, so that entire shifted class cannot admit a fixed power saving. Our bound concerns a different restricted family, rather than strengthening their estimate on its original domain.

Comparison with the full paper, including its proofs and appendix, found neither the quadratic-coset theorem nor a direct implication yielding it. The fixed-formula extension does not supply the missing perfectness or closure hypotheses either. The exact application was not located in the primary sources compared above, but comprehensive historical priority remains unverified. The result is an explicit specialized application of established regularity and covering methods, with no claim of a new general expansion method or a solution of unrestricted #810.

## References

1. T. Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*, Contributions to Discrete Mathematics **10**(1) (2015), 22–98. [Published version](https://doi.org/10.55016/ojs/cdm.v10i1.62182); [preprint](https://arxiv.org/pdf/1211.2894). Inputs: Lemma 23, Theorem 25, Corollary 37, Remark 39, and the proofs of Theorems 38 and 40. In the published pagination, Theorem 38 and its proof occupy pp. 61–64, Remark 39 pp. 64–65, and Theorem 40 and its proof pp. 65–67. The present restricted-source lower bound is derived in Section 4, rather than attributed to the literal statement of Theorem 40.
2. A. Gyárfás and G. N. Sárközy, *“Less” Strong Chromatic Indices and the (7,4)-Conjecture*, Studia Scientiarum Mathematicarum Hungarica **60** (2023), 109–122. [Published PDF](https://real.mtak.hu/191892/1/012-article-p109.pdf). See Theorem 2.2 for the matching-size comparison.
3. A. Gyárfás, G. N. Sárközy, and A. Z. Wagner, *Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*, Discrete Mathematics **349**(6) (2026), 115005. [Published article](https://doi.org/10.1016/j.disc.2026.115005). See Theorems 2.3 and 2.7, Claim 3.2 and the proof of Theorem 2.7 in Section 3, and the open questions in Section 4.
4. P. Dèbes and F. Legrand, *Twisted covers and specializations*. [Preprint](https://arxiv.org/pdf/1106.6154). See Section 3.1, especially Lemma 3.1 and the construction of the regular twisted cover, for the field-crossing framework. Section 6.2 above gives the specific fixed-field calculation and domination property used here.
5. A. Chevalier and E. Levi, *An Algebraic Hypergraph Regularity Lemma*. [Preprint, version 2](https://arxiv.org/pdf/2204.01158v2). See Definition 3.2.1, Proposition 3.2.6, Theorem 4.1.2, and Theorems 5.2.5 and 5.3.3 for dominance, compatible base change, stochastic independence, and regularity.
6. Anand Pillay and Atticus Pascale Stonestrom, *An arithmetic algebraic regularity lemma*. [Preprint, version 2](https://arxiv.org/html/2412.11206v2), 5 February 2026. See Fact 2.3, Theorem 5.2 and the paragraph preceding it, and Corollary 5.3 for the discrepancy conventions and the group-theoretic conclusions.
