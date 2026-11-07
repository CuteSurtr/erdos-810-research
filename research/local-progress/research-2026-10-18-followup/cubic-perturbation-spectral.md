# A stronger cubic-perturbation bound from row monodromy

18 October 2026. This strengthens the $p^{15/8}$ argument in [cubic-perturbation.md](cubic-perturbation.md) to $p^{7/4}$. The complete proof passed an [independent mathematical audit](cubic-perturbation-independent-audit.md). Its analytic input is classical finite-field Chebotarev and elementary matrix estimates, so the binary regularity lemma is no longer needed. Historical novelty remains unverified.

## 1. Statement and collision relation

Let $p>3$, let $t\in\mathbb F_p^\times$, let $A\subseteq\mathbb F_p^\times$, and let $H\subseteq\mathbb F_p$. Retain incidences from the prescription

```math
(a,h)\longmapsto
\left(\frac h{a^2}-a-ta^2,\ \frac h a\right),
```

subject to the requirement that distinct colors are not assigned to the same ordered endpoint pair. Write $d=p-1-|A|$, let $R$ be the number of omitted incidences in $A\times H$, and let $m$ be the number retained. Then

```math
m\ll p^{7/4}+p\sqrt{R+pd},                 \tag{1}
```

with an absolute implied constant. In particular, the full-palette, no-omission case satisfies $m=O(p^{7/4})$. No rainbow-four-cycle hypothesis is used.

As calculated in the companion proof, a same-endpoint collision between distinct colors $a,b$ has potentials

```math
u=-a^2b(1+t(a+b)),\qquad
v=-ab^2(1+t(a+b)).                         \tag{2}
```

For $u,v\ne0$, put $q=v/u=b/a$ and $z=1/a$. The quartic relation becomes

```math
F_u(v,z)=z^4+\frac v{u^2}z
                    +\frac{t v(u+v)}{u^3}=0.           \tag{3}
```

When $v\notin\{0,u,-u\}$, every field root $z$ is nonzero and supplies distinct nonzero colors $a=1/z$, $b=va/u$. These colors satisfy (2). We will discard the three exceptional values of $v$ for each row.

## 2. Every good row has geometric group $S_4$

Work over an algebraically closed field $k$ of characteristic greater than three. Fix $u\ne0$. The polynomial $F_u(v,z)$ is Eisenstein at $v=0$ in $k[v][z]$, since its constant coefficient has valuation one there. Hence it is irreducible over $k(v)$ and has a transitive Galois group on four roots.

Its cubic resolvent is

```math
T_u(v,Y)=Y^3-\frac{4t v(u+v)}{u^3}Y-\frac{v^2}{u^4}.
```

If it has a root in $k(v)$, monicity and integral closedness force that root to lie in $k[v]$. Comparing degrees shows it has degree at most one: a polynomial root of degree $e\ge2$ would have an uncancelled term of degree $3e>e+2$. Its constant term is zero, so it has the form $Y=\alpha v$. The coefficients of $v^3$ and $v^2$ then require

```math
\alpha^2=\frac{4t}{u^3},\qquad
\alpha=-\frac1{4tu^2},
```

and therefore $u=1/(64t^3)$. Thus the resolvent is irreducible for every

```math
u\notin\left\{0,\frac1{64t^3}\right\}.      \tag{4}
```

Put $C=27/(256t^3)$ and $D_u(v)=(u+v)^3-Cuv$. Direct discriminant identities give

```math
\operatorname{Disc}_z F_u
 =\frac{256t^3v^3}{u^9}\,D_u(v),\qquad
\operatorname{Disc}_v D_u=C^2u^3(4C-27u).    \tag{5}
```

For every $u$ satisfying (4), the cubic $D_u$ has three distinct nonzero roots. Thus $\operatorname{Disc}_z F_u$ is not a square in $k(v)$. An irreducible cubic resolvent means that the Galois group acts transitively on the three pair partitions of four roots. Its order is therefore divisible by three. A transitive subgroup of $S_4$ with this property is $A_4$ or $S_4$; the nonsquare discriminant excludes $A_4$. Hence the geometric Galois group is $S_4$ for every good row, with no unspecified specialization exceptions.

The finite branch values are among $0$ and the three roots of $D_u$. At each root of $D_u$, the discriminant has valuation one, so exactly two roots coalesce and inertia is a transposition. There may also be branching at infinity. All these covers are tame, since $p>3$.

## 3. Distinct row covers are geometrically independent

Take distinct good values $u,u'$. The monic cubics $D_u,D_{u'}$ cannot have identical root sets: their $v^2$ coefficients are $3u$ and $3u'$. Each has three distinct roots, so there is a root of $D_u$ which is not a root of $D_{u'}$. That root is finite and nonzero. The first row's splitting field has transposition inertia there; the second row's splitting field is unramified there.

Their intersection is a Galois subextension of the first $S_4$ extension. The corresponding normal subgroup contains the transposition, and hence is all of $S_4$. Thus the intersection is $k(v)$. The two Galois extensions are linearly disjoint, and their compositum has geometric group $S_4\times S_4$.

Over $\mathbb F_p$, the arithmetic Galois groups are the same as these geometric groups. Indeed, the arithmetic groups embed in $S_4$ or $S_4\times S_4$ through their action on the labelled polynomial roots, and already contain the full geometric groups. Thus the splitting fields have constant field $\mathbb F_p$, as required for the counting below.

## 4. Chebotarev gives row and pair correlations

Let

```math
U=\mathbb F_p\setminus\{0,1/(64t^3)\}.
```

Define a symmetric zero-one matrix $M$ indexed by $U$ by setting $M_{uv}=1$ if (3) has a field root and $v\notin\{u,-u\}$. Symmetry follows from the collision equations (2), by exchanging $a$ and $b$. The excluded diagonal is zero.

For an unramified polynomial specialization, a field root is equivalent to the Frobenius permutation having a fixed point. Exactly $15$ of the $24$ permutations in $S_4$ have a fixed point, so put $\delta=5/8$.

Finite-field Chebotarev, applied to the row cover and the product of two distinct row covers, gives uniformly

```math
\sum_{w\in U}M_{uw}=\delta |U|+O(p^{1/2}),
```

and, for $u\ne u'$,

```math
\sum_{w\in U}M_{uw}M_{u'w}
             =\delta^2|U|+O(p^{1/2}).       \tag{6}
```

Deleting the branch values and the finitely many exceptional specializations affects each count by $O(1)$. The errors have absolute constants: the relevant Galois degrees are at most $24^2$, the branch sets have at most eight geometric points, and tameness plus Riemann–Hurwitz bounds their genera absolutely. A primary reference for the finite-field Frobenius count through twists and Lang–Weil is [Meagher, *A simple proof of Chebotarev's density theorem over finite fields*, Theorem 1.1, Bulletin of the Australian Mathematical Society 98 (2018), 196–202](https://doi.org/10.1017/S0004972718000448). In the present curve case the twists have the same bounded genus, so the usual Weil bound makes the uniform square-root error explicit.

## 5. Spectral estimate and support bound

Let $J$ be the all-ones matrix and $B=M-\delta J$. Equation (6) and the row estimate show that every off-diagonal entry of $BB^{\mathsf T}$ is $O(p^{1/2})$, while every diagonal entry is $O(p)$. Its maximum absolute row sum is therefore $O(p^{3/2})$. Consequently

```math
\|B\|_{\mathrm{op}}=O(p^{3/4}).             \tag{7}
```

For $H_0=H\cap U$ and $h=|H_0|$, apply (7) to its indicator vector:

```math
\sum_{u,v\in H_0}M_{uv}
       \ge \delta h^2-Cp^{3/4}h.            \tag{8}
```

Every counted ordered pair supplies at least one actual ordered collision configuration $(a,b)$. Let $N$ count all such configurations. Missing colors and incidences bound $N$ exactly as in the companion proof: one absent color occurs in at most $2p$ ordered configurations; one omitted incidence occurs in at most four, because the other color solves a quadratic equation. Therefore

```math
\delta h^2-Cp^{3/4}h\le N\le2pd+4R.
```

Solving this quadratic inequality gives

```math
h\ll p^{3/4}+\sqrt{R+pd}.
```

There are only two excluded potential values, so $m\le p(h+2)$. This proves (1).

## 6. Interpretation and limits

The bound is a concrete restriction on the full or nearly full palette construction with color lines $y=ax+a^2+ta^3$ and a common potential set $h=ay$. It shows that the unperturbed quadratic model's proper full-palette supports are unstable under every nonzero cubic perturbation. It does not handle an arbitrary dense palette, arbitrary nonlinear color functions, or general graphs in Erdős #810.

The Chebotarev and matrix arguments are established methods. The explicit quartic row monodromy and the distinction of all row branch sets are the application-specific calculations. Historical novelty remains unverified.
