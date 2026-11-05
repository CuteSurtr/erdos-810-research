# A fixed-index palette coset: independent audit

18 October 2026. The extension below passes. It uses the previously audited rational-expansion proof with a fixed higher Kummer exponent; it is not an assertion about arbitrary dense palettes.

## Exact hypotheses and conclusion

Fix a positive integer $\ell$. Let $p$ range over sufficiently large primes with $\ell\mid p-1$, and let

```math
C=(\mathbb F_p^*)^\ell,\qquad t\in\mathbb F_p^*.
\tag{1}
```

Consider the quadratic affine colors $\sigma_a(x)=ax+a^2$ and the potential $h=ay$. Every selected incidence has its potential in a common set $H\subseteq\mathbb F_p$. Let $D$ be the number of absent colors inside $tC$, and let $R$ count missing eligible incidences of the remaining colors in $tC$ with potentials in $H$. Actual edges with colors outside $tC$ are permitted, provided they also have potentials in $H$.

If the selected graph is simple and proper and every four-cycle is rainbow, its total number of edges satisfies

```math
m\ll_\ell p^{63/32}+p^{4/3}(R+pD)^{1/3}.
\tag{2}
```

In particular, a complete coset $tC$ with no missing eligible incidences gives $m=O_\ell(p^{63/32})$. No invariance assumption on $H$ is required. The conclusion with $D=o(p)$ and $R=o(p^2)$ is $m=o(p^2)$.

## The higher-root predicate preserves the analytic proof

Use the rational functions

```math
K(x,y)=\frac{xy(x+y)}{x^2+y^2},\qquad
G(x,y)=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)}.
\tag{3}
```

Replace the previous cube predicate by

```math
E_{t,\ell}(x,y)=
1_{\{G(x,y)/t^3\in(\mathbb F_p^*)^{3\ell}\}}.
\tag{4}
```

The cover used in the positivity argument is now $z^{3\ell}=G/t^3$. In the separate-cover proof, the divisor where $G$ has valuation one remains unramified after every separate coordinate cover. The unit $t^{-3}$ changes no valuation. Eisenstein therefore proves irreducibility for every positive integer $3\ell$, not only for a prime exponent. The four-output map of $K$ is unchanged. The predicate (4) has fixed definable complexity for fixed $\ell$.

Consequently the proof in [partial-rational-expansion-independent-audit.md](partial-rational-expansion-independent-audit.md) gives constants $c_\ell,C_\ell>0$ such that

```math
\#\{(x,y)\in X\times Y:E_{t,\ell}(x,y)=1,\ K(x,y)\in Z\}
\ge \frac{c_\ell|X||Y||Z|}{p}
-C_\ell p^{15/16}\sqrt{|X||Y|}.
\tag{5}
```

They are uniform in nonzero $t$. To see this, include a hypothetical varying sequence of parameters $t_p$ in the same simultaneous-constant ultraproduct contradiction. Its limit is nonzero and the characteristic-zero geometric argument holds for every such unit. A representative $\lambda$ for a potential coset does not enter the defining formula; it merely chooses the sets to which (5) is applied.

The analytic source remains Tao's [*Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/html/1211.2894), together with the explicit separate-cover proof and adaptation already recorded. This is a consequence of that proof, rather than a literal quotation of a new published theorem.

## Palette membership and the split of the potential set

Partition $H^*=H\setminus\{0\}$ among the $\ell$ cosets of $C$. Choose a part $H_\lambda\subseteq\lambda C$ of size at least $|H^*|/\ell$. Split this part into two disjoint subsets $X,Y$ of comparable size and put $Z=H_\lambda$. Bounded small sets can be absorbed into the final constant.

For a pair counted by (5), write $k=K(x,y)$. Equation (4) supplies some $z\ne0$ with $z^{3\ell}=G(x,y)/t^3$. Then

```math
a=t z^\ell\in tC,
\qquad a^3=G(x,y).
\tag{6}
```

The equal-cross-potential rectangle uses colors

```math
a,\qquad b=\frac{ak}{y},\qquad c=\frac{ak}{x}.
\tag{7}
```

Since $x,y,k\in\lambda C$, both $k/y$ and $k/x$ lie in $C$. Thus all three colors in (7) lie in $tC$. The disjointness of $X,Y$ gives $x\ne y$, and the existing nondegenerate open exclusions ensure three distinct colors and four distinct edges. In particular, this argument does not require the whole palette to be present or $H$ to be a union of cosets.

The predicate counts pairs, not choices of $z$. Each pair supplies at least one valid color $a$, and there are at most three distinct $a$ satisfying $a^3=G$. The potentially $3\ell$ choices of $z$ must not be treated as distinct graph configurations. Count actual configurations $(x,y,k,a,b,c)$; their number is at least the pair count in (5).

## Deletions and the final exponent

The previously audited configuration multiplicities are unchanged: a fixed missing color destroys at most $3p$ actual configurations, and a fixed missing colored incidence destroys at most sixteen. Restricting all configurations to $tC$ and $H_\lambda$ can only decrease these bounds. Therefore, writing $h=|H^*|$,

```math
\frac{c_\ell h^3}{p}-C_\ell p^{15/16}h
\le 3pD+16R.
\tag{8}
```

If the error on the left is at least half its cubic main term, then $h\ll_\ell p^{31/32}$. Otherwise $h^3\ll_\ell p(R+pD)$. Since every selected color/potential pair determines one edge and there are at most $p-1$ colors,

```math
m\le p(h+1),
\tag{9}
```

and (2) follows. The additional $p$ accounts for potential zero.

## Why the elementary monomial propriety argument does not subsume this

For the quadratic palette, a collision of distinct colors has potentials $h_1,h_2$ satisfying

```math
q=h_2/h_1\ne1,\qquad a^3=-h_1^2/h_2.
\tag{10}
```

When $p\equiv1\pmod3$, take $H$ to be a noncube coset. Then $h_1^2/h_2$ stays in that coset and $-1$ is a cube, so (10) has no solution. The full quadratic palette with this $H$ is therefore simple and proper and has order $p^2$ edges. The four-cycle condition is essential to (2); the properness-only argument for fixed monomial degrees at least three does not prove it.

## Comparison with the earlier product-set criterion

For $S=\{\sigma_a:a\in tC\}$, put $s=|C|$ and $g=\gcd(2,s)$. If $r=a/b$, then $\sigma_a\sigma_b^{-1}$ has slope $r$ and translation $r(r-1)b^2$. The identity quotient has multiplicity $s$; every nonidentity quotient has multiplicity exactly $g$. Hence

```math
|SS^{-1}|=1+\frac{(s-1)s}{g},
\qquad
E(S)=s^2+g s(s-1)\le3s^2-2s.
\tag{11}
```

For fixed index, the difference set has order $p^2$, so the previous hypothesis $|SS^{-1}|=O(p)$ does not cover this palette. Its energy already has order $p^2$, so the earlier necessary condition $E(S)=o(|S|^3)$ by itself does not exclude these palettes either.
