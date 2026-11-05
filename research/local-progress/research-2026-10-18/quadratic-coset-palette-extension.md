# Quadratic palettes containing a multiplicative coset

18 October 2026. This extends the arbitrary-common-support quadratic theorem to palettes containing almost all of a multiplicative coset of bounded index. It makes no invariance assumption on the support. The argument passed independent algebraic, geometric, analytic, and deletion-count reviews; see [one complete audit](coset-palette-independent-audit.md) and [a second transfer audit](quadratic-coset-palette-independent-audit.md). This is a written mathematical proof, not a Lean certificate.

## Statement

Fix a positive integer $L$. There are constants $C_L,p_L$ with the following property. Let $p>p_L$ be prime, $A\subseteq\mathbb F_p^\times$, and $H\subseteq\mathbb F_p$. For each $a\in A,h\in H$, the eligible colored incidence is

```math
(x,y)=\left(h/a^2-a,h/a\right),\qquad y=ax+a^2.
```

Retain incidences forming a simple properly edge-colored bipartite graph whose every four-cycle is rainbow. Let $m$ be the total number retained. Suppose $C\le\mathbb F_p^\times$ has index $\ell\le L$, and choose $t\ne0$. Let $R$ count only the omitted eligible incidences in $(A\cap tC)\times H$, and put

```math
d=|tC\setminus A|.
```

Then

```math
m\le C_Lp^{63/32}+C_Lp^{4/3}(R+pd)^{1/3}.
\tag{1}
```

In particular, containing a full coset of bounded index suffices for $m=O_L(p^{63/32})$ when no eligible incidence is omitted. Allowing $d=o(p)$ and $R=o(p^2)$ still gives $m=o(p^2)$. Other colors in $A$ can be arbitrary.

This is a theorem for the specified common-potential model, not for arbitrary color matchings in Erdős #810. Constants are not numerically explicit, and historical novelty is unverified.

## A higher-root version of the counting lemma

Use

```math
K(u,v)=\frac{uv(u+v)}{u^2+v^2},\qquad
G(u,v)=-\frac{(u^2+uv+v^2)(u^2+v^2)}{uv(u+v)}.
```

For each fixed positive integer $n$ and each nonzero parameter $c$, define

```math
E_{n,c}(u,v)=1_{\{G(u,v)/c\in(\mathbb F_p^\times)^n\}},
```

excluding zeros and poles. The proof in [the counting audit](partial-rational-expansion-independent-audit.md) gives, uniformly in $c$ and all subsets $X,Y,Z\subseteq\mathbb F_p^\times$,

```math
\sum_{u\in X,v\in Y}E_{n,c}(u,v)1_Z(K(u,v))
\ge c_n\frac{|X||Y||Z|}{p}
-C_np^{15/16}\sqrt{|X||Y|}.
\tag{2}
```

Here is the precise change needed to that proof. The four-output rational map and all its bounded-fibre and Jacobian calculations are unchanged. The predicate “there exists a nonzero $s$ with $s^n=G/c$” is a fixed-complexity definable predicate for fixed $n$, so the bounded definable grid multiplicities and the two Cauchy–Schwarz steps are unchanged as well.

For positivity of every output cell, replace the cubic cover by $s^n=G/c$. After arbitrary separate covers of $u,v,K$, the geometric argument in [the cover proof](rational-expander-cover-proof.md) supplies a divisor above $v=\omega u$ on which $G$ has valuation one; $\omega$ is a primitive cube root of unity over the algebraic closure. Every separate coordinate cover is unramified there. The nonzero constant $c$ has valuation zero. Thus $s^n-G/c$ is Eisenstein at that valuation and remains irreducible for **every** $n$, including composite $n$. This proves geometric integrality of the additional cover on the natural dense open set. The curve-cover and Lang–Weil positivity argument therefore applies exactly as before.

The finite-prime constants are uniform in $c$: in a hypothetical violating sequence, $c$ is simply a nonzero parameter in the characteristic-zero ultraproduct, and the valuation calculation is valid for every such parameter. No estimate for wild covers in a fixed small characteristic is asserted. For $1\le n\le3L$, a maximum/minimum over finitely many constants makes them depend only on $L$.

## Making all three colors land in the same coset

Since the multiplicative group is cyclic, $C=(\mathbb F_p^\times)^\ell$. Let $H^*=H\setminus\{0\}$ and $h=|H^*|$. Choose a coset $\lambda C$ for which

```math
H_0=H^*\cap\lambda C,\qquad |H_0|\ge h/\ell.
```

Split $H_0$ into disjoint subsets $X,Y$ of comparable size and take $Z=H_0$. Small $|H_0|$ is absorbed into the final bound. Apply (2) with $n=3\ell$ and $c=t^3$.

Each counted pair gives $k=K(u,v)\in H_0$ and a nonzero $s$ satisfying

```math
s^{3\ell}=G(u,v)/t^3.
```

Set

```math
a=ts^\ell,\qquad b=ak/v,\qquad c'=ak/u.
```

Then $a^3=G(u,v)$ and $a\in tC$. Also $k/v,k/u\in C$ because all three potentials lie in $\lambda C$. Hence **all three colors** $a,b,c'$ lie in $tC$.

The exact configuration lemma gives a nondegenerate four-cycle with incidences

```math
(a,u),\quad(a,v),\quad(b,k),\quad(c',k).
```

The input split gives $u\ne v$. The nonzero/pole restrictions are the same ones already checked in the quadratic configuration proof and ensure three distinct colors and four distinct edges.

Conversely, $a\in tC$ and $a^3=G(u,v)$ imply $a=ts^\ell$ for some $s$, so the higher-power predicate is exactly the required root condition. Counting witnesses $s$ is unnecessary. Count actual configurations, including every admissible value of $a$; every pair admitted by (2) contributes at least one. Thus, for constants depending only on $L$, their number $N$ satisfies

```math
N\ge c_Lh^3/p-C_Lp^{15/16}h.
\tag{3}
```

## Deletions and the edge bound

The [independently checked multiplicity bounds](common-potential-combinatorics.md) count actual configurations with all cube roots: a fixed colored incidence belongs to at most sixteen, and a fixed color to at most $3p$. Restricting to the configuration subfamily above can only lower these multiplicities. The possible many-to-one map $s\mapsto a$ does not enter this step.

Every such configuration must be destroyed either by one of the $d$ absent colors in $tC$ or by one of the $R$ omitted incidences. Otherwise it gives a non-rainbow four-cycle in the actual graph. Therefore

```math
c_Lh^3/p-C_Lp^{15/16}h\le N\le3pd+16R.
\tag{4}
```

If the error term dominates at least half the cubic term, then $h\ll_Lp^{31/32}$. Otherwise $h^3\ll_Lp(R+pd)$. Since $m\le p(h+1)$, these two cases prove (1). The zero potential contributes at most $p-1$ actual edges and is absorbed.

## Comparison and remaining gap

Unlike the [dilation transfer](palette-dilation-extension.md), this theorem requires no multiplicative symmetry of $H$. For instance, one full cubic coset of colors suffices, with any common potential support. The subgroup index must remain bounded independently of $p$; the proof does not claim uniform control as $\ell\to\infty$.

For a nonvacuous proper example, take $A=tC$ and let $H$ avoid $-t^3C$. Every collision between two distinct colors would have both potentials in $-t^3C$, so these choices already form a simple proper graph before imposing the four-cycle condition. For a bounded index greater than one, such supports can have fixed positive density. The theorem genuinely uses the four-cycle condition to exclude them.

An arbitrary palette of fixed positive density need not contain almost all of any coset of bounded index. That case still requires controlling three coupled color memberships on the rational configuration surface. Nothing in (2) justifies replacing those memberships by independent densities.
