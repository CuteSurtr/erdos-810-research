# Extracting and descending a finite cover inside a definable palette

18 October 2026. This supplies the arithmetic, geometric, and counting steps extending polynomial-residue palettes to palettes of fixed definable complexity. The full written chain passed [independent audit](definable-palette-independent-audit.md). The field-crossing lemma is proved explicitly. The analytic input remains the previously established adaptation of Tao's regularity argument. This is not a formal proof certificate or a claim of historical novelty.

## 1. A finite regular witness cover inside a dense unary definable set

Let $F$ be a characteristic-zero nonstandard finite field, as in Tao's algebraic regularity argument, and let $A\subseteq F$ be an infinite definable set. Tao's Theorem 25 expresses membership as a finite intersection of conditions

```math
\exists t_j\in F:\ P_j(a,t_j)=0.
```

All degrees and numbers of polynomials are standard finite quantities. Discard identically zero polynomials. A nonzero polynomial independent of $t_j$ would force $A$ into a finite set, contrary to the hypothesis, so every remaining polynomial has positive generic degree in $t_j$. Remove the finitely many zeros of the leading coefficients, and divide the equations by these invertible coefficients on the resulting open subset of the $a$-line. They become monic in their separate witnesses.

The simultaneous witness variety is then finite over this open line, and it has at least $|A|-O(1)$ rational points because every retained $a\in A$ has a tuple of witnesses. It therefore has infinitely many rational points and dimension one. If no geometric curve component were defined over $F$, every rational point on such a component would lie in its intersection with its distinct Frobenius conjugate. There are only finitely many components and each such intersection is zero-dimensional, giving only $O(1)$ rational points, a contradiction. Hence there is a geometrically irreducible one-dimensional component defined over $F$. Its rational-point image is contained in $A$. Lang–Weil and the bounded fibres then also give an image of size $\gg |F|$.

Normalize and pass to a dense smooth open of that component, deleting the finitely many problematic points. This produces a geometrically irreducible curve $V/F$ and a finite separable map to a dense open of the $a$-line whose rational-point image lies in $A$. Projective completion gives a finite separable function-field extension $F(V)/F(a)$, with $F(V)$ regular over the constant field $F$; it is not generally regular over $F(a)$. The original image containment applies after restricting back to the designated open.

The primary source for the finite-witness representation is [Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*, Theorem 25](https://arxiv.org/html/1211.2894#S4), especially equation (13). The source's proof of Proposition 27, equations (18)–(20), uses the same finite-witness construction. Making the leading coefficients invertible explicitly ensures finiteness, not merely pointwise finite fibres.

For a fixed formula with arbitrary parameters over the varying finite prime fields, a hypothetical failure of uniform boundedness yields an ultraproduct in which this construction has standard finite complexity. Thus the same compactness argument used in the existing note supplies uniform bounds without numerically tracking the degree of every normalization or cover.

## 2. Field-crossing lemma over a finite field

**Lemma.** Let $k=\mathbb F_q$, let $K=k(a)$, and let $V/k$ be a geometrically irreducible smooth curve with a finite separable map $V\to\mathbb P^1_a$. There exists a geometrically irreducible cover $Z\to\mathbb P^1_a$, defined over $k$, such that:

1. $Z\to\mathbb P^1_a$ is geometrically Galois;
2. it factors through $V\to\mathbb P^1_a$ over $k$;
3. its degree equals the order of the geometric monodromy group of $V\to\mathbb P^1_a$.

In particular, after removing the same exceptional fibres, the rational-point image of $Z$ is contained in that of $V$.

**Proof.** Let $L/K$ be the arithmetic Galois closure of $k(V)/K$, let its constant field be $k_e=\mathbb F_{q^e}$, and write

```math
\Gamma=\operatorname{Gal}(L/K),\qquad
G=\operatorname{Gal}(L/k_e(a)),\qquad
H=\operatorname{Gal}(L/k(V)).
```

Regularity of $k(V)/k$ gives $k(V)\cap k_e=k$. Thus the restriction of $H$ to $k_e$ is all of $\operatorname{Gal}(k_e/k)$. Choose $\sigma\in H$ restricting to $q$-Frobenius on $k_e$, and put $M=\operatorname{ord}(\sigma)$. Necessarily $e\mid M$.

Set $k_M=\mathbb F_{q^M}$ and $L'=Lk_M$. Its constant field is $k_M$, and

```math
\operatorname{Gal}(L'/K)
 \cong \Gamma\times_{\operatorname{Gal}(k_e/k)}
              \operatorname{Gal}(k_M/k).
```

The element $\sigma'=(\sigma,\operatorname{Frob}_q)$ belongs to this fibre product and has order $M$. Let

```math
E=(L')^{\langle\sigma'\rangle}.
```

Its constant field is exactly $k$, since the fixed constants of $\sigma'$ in $k_M$ are $k$. Therefore $E/k$ is regular. Also $\sigma'$ fixes $k(V)$, so $E\supseteq k(V)$. Finally,

```math
[L':K]=|G|M,\qquad [E:K]=|G|.
```

The subgroup $\langle\sigma'\rangle$ intersects $G=\operatorname{Gal}(L'/k_M(a))$ trivially, because a power of $\sigma'$ fixing $k_M$ has exponent divisible by $M$. Therefore $Ek_M=L'$. After extending constants to an algebraic closure, $E$ gives the geometric Galois closure of $k(V)/K$. The smooth projective curve with function field $E$ is the asserted $Z$. Its inclusion of $k(V)$ supplies the map $Z\to V$. ∎

One must enlarge constants to $k_M$ before taking the fixed field. Taking $L^{\langle\sigma\rangle}$ directly can give the wrong degree when $M>e$, because $\sigma^e$ may be a nontrivial geometric automorphism.

This is the finite-field field-crossing argument, rather than a new descent principle. A primary reference for the general construction is [Dèbes–Legrand, *Twisted covers and specializations*, §3.1, especially Lemma 3.1 and the regular twisted cover following it, printed pp.7–8](https://arxiv.org/pdf/1106.6154). Their geometric monodromy action is the left-regular action, matching the last assertion of the lemma. The explicit proof above also records the domination of the original witness curve needed here.

## 3. Boundedness and passage to the nonstandard field

If the witness degree is $d$, then $|\Gamma|\le d!$, hence $e,M,|G|\le d!$. Its geometric Galois closure has branch points among those of the original witness cover. In large enough characteristic all relevant ramification is tame; alternatively all later geometry is carried out in characteristic zero. Riemann–Hurwitz bounds the genus of the geometric Galois closure in terms of the degree and number of branch points. The descended curve has the same geometric genus and degree. Thus bounded witness complexity gives bounded descended-cover complexity.

These constructions can be made in a sequence of finite fields before taking an ultraproduct. The finite bounds permit a fixed finite presentation after passing to a subsequence. Alternatively, the same field-crossing proof works over a pseudofinite field, whose finite constant extensions are cyclic of each prescribed degree; it uses only bounded-degree extensions. Either formulation avoids assuming that an arithmetic Galois closure is itself regular.

## 4. Descent of the maximal Kummer quotient

Let $Z\to\mathbb P^1_a$ be the regular geometrically Galois cover obtained above, with geometric Galois group $G$. Over an algebraic closure let $N$ be the normal subgroup generated by inertia at all finite nonzero branch values of $a$. Arithmetic descent permutes these inertia groups and therefore preserves $N$. The quotient $W=Z/N$ descends to $k$.

Geometrically, $W\to\mathbb P^1_a$ is connected and unramified over $\mathbb G_m$. In characteristic zero, or tame sufficiently large characteristic, it is a cyclic power cover of some degree $n$. Its unique geometric points over $a=0$ and $a=\infty$ are individually fixed by arithmetic descent, hence are $k$-rational. Thus $W$ is a genus-zero curve with a rational point and is isomorphic over $k$ to $\mathbb P^1$. Choose a coordinate $w$ with these two points as zero and infinity. Divisors then give

```math
a=\tau w^n\qquad\text{for some }\tau\in k^\times.       \tag{1}
```

When $n=1$ this is simply a change of coordinate. The integer $n$ is bounded by $|G|$. It need not divide $q-1$; the rational-point image in $\mathbb G_m(k)$ is the coset $\tau(k^\times)^n$, whose index is $\gcd(n,q-1)\le n$.

The residual geometrically Galois cover $Z\to W$ has group $N$. Its inertia groups at **all** finite nonzero values of $w$ normally generate $N$. Indeed, these groups include every $G$-conjugate of the original inertia at finite nonzero values of $a$, since every point of the Kummer quotient over those values is included. Their normal closure in $N$ is therefore exactly $N$. Using only one point over each $a$-value would not justify this assertion.

The geometric step for the graph application is to show that these residual inertia groups all remain visible after the three potential covers and the other two color covers. Section 5 proves this using the explicit nonconstant restrictions in `dense-palette.md`, equation (5).

## 5. Explicit root coordinates and geometric disjointness

The following completes that geometric step. Work over an algebraic closure of characteristic zero. Retain the earlier notation

```math
Q=q^2+1,\quad B=q^2+q+1,\quad
r=(q+1)/Q,\quad F=-BQ/[q(q+1)],
```

so that $u=a^3/F$, $v=qu$, $k=qru$, and the three colors are $a,b=ar,c=aqr$.

Restrict the potential set to one coset $\lambda(F^\times)^n$. Every finite witness curve used for a definable potential cell in this coset can be chosen to supply its own root coordinate. Explicitly, append the monic equation $x^n=u/\lambda$ to the witness variety before choosing a geometrically irreducible component defined over $F$. Do this independently for all three potential cells, obtaining rational functions $x,y,z$ on their three respective curves with

```math
u=\lambda x^n,\qquad v=\lambda y^n,\qquad k=\lambda z^n.
```

The previous separate-cover theorem says that adjoining

```math
w^{3n}=G(u,v)/\tau^3
```

to these potential covers gives a geometrically integral surface. Let $M_0$ be its function field. Put

```math
a=\tau w^n,\quad
w_a=w,\qquad w_b=wz/y,\qquad w_c=wz/x.
```

Then, as equalities of rational functions over $F$,

```math
a=\tau w_a^n,\qquad b=\tau w_b^n,\qquad c=\tau w_c^n.   \tag{2}
```

Thus the three maps to the Kummer quotient of the palette cover are explicitly chosen. Merely observing that each color is an $n$th-power residue would not provide these rational maps.

For each color index $i$, the pair $(w_i,q)$ is algebraically independent, and $M_0$ is finite over $k(w_i,q)$. Indeed, if $(r_a,r_b,r_c)=(1,r,qr)$, then

```math
a=\tau w_i^n/r_i(q),
```

and all three potentials are rational functions of $(w_i,q)$. The other root coordinates are algebraic over this rational field.

At every generic divisor $w_i=\theta$ with $\theta\ne0$, all three potentials and both other colors are nonconstant functions of $q$, by the nine restrictions already calculated. Therefore each separate potential cover is unramified there. The extra root equations also have unit radicands there, so they are unramified in characteristic zero. It follows that $M_0/k(w_i,q)$ is unramified at every valuation above every such generic divisor. This statement concerns the finite extension over $k(w_i,q)$; it does not assert that $M_0$ is regular over $k(w_i)$.

Let $L_i/k(w_i)$ be a copy of the residual palette-cover function field $k(Z)/k(W)$. Its Galois group is $N$. After adjoining the independent variable $q$, the extension $L_i(q)/k(w_i,q)$ remains Galois with the same group. Adjoin the three palette covers to $M_0$ one at a time. For the selected index $i$, every earlier palette cover is unramified at the generic divisors $w_i=\theta\ne0$, because its quotient coordinate $w_j$ is nonconstant there: its $n$th power is the nonconstant other color divided by $\tau$.

Let $M$ be the field containing $M_0$ and the earlier palette covers, and let $\widetilde M$ be its finite Galois closure over $k(w_i,q)$. A Galois closure of an extension unramified at these characteristic-zero valuations remains unramified there. Consider

```math
J=L_i(q)\cap\widetilde M.
```

This is a Galois intermediate field of $L_i(q)/k(w_i,q)$, hence is of the form $L_i^H(q)$ for a normal subgroup $H\trianglelefteq N$. Since $\widetilde M$ is unramified at every generic divisor $w_i=\theta\ne0$, this intermediate curve cover is unramified at all finite nonzero points of the $w_i$-line. Thus $H$ contains every inertia group at every such point. Their normal closure is $N$, by Section 4. Consequently $H=N$ and $J=k(w_i,q)$.

Since both extensions are Galois, this trivial intersection proves linear disjointness from $\widetilde M$, and hence from $M$. The selected pullback is integral and has degree $|N|$. Repeating for the three colors proves geometric integrality of the complete potential/palette cover. All its defining maps and root coordinates are over $F$, so the geometrically integral variety is also defined over $F$.

## 6. Consequence for the counting and graph transfer

Let $A_0$ be a dense unary definable palette and let $Z\to\mathbb P^1_a$ be the descended witness cover, restricted to an open on which $Z(F)$ maps into $A_0$. Define $E(u,v)$ by existence of $a$ with $a^3=G(u,v)$ and three rational points of $Z$ mapping to the colors $a,b,c$. This is a bounded definable predicate. It forces all three colors into $A_0$.

Choose a largest support slice $H_0=H^*\cap\lambda(F^\times)^n$, where $H^*=H\setminus\{0\}$. The index of $(F^\times)^n$ is bounded by $n$, so $|H_0|\ge|H^*|/n$. Run the previous restricted-grid regularity proof with all input and output coordinates confined to $\lambda(F^\times)^n$. For each full-dimensional cell, choose finite witness covers including the root coordinates as in Section 5. The complete pullback is geometrically integral, hence Lang–Weil supplies the positive quadratic count required in every cell. The two Cauchy–Schwarz estimates are unchanged, as are the fixed grid map and the bounded definable fibre multiplicities.

Taking disjoint comparable subsets of $H_0$ for the two inputs and $H_0$ for the output gives an actual ordered configuration count

```math
N\ge c\,h^3/p-Cp^{15/16}h,\qquad h=|H^*|,             \tag{3}
```

where the constants depend on the fixed formula defining $A_0$ and the fixed positive density bound used to extract the witness. Root witnesses on $Z$ are not counted as separate graph configurations: every accepted pair supplies at least one actual cube root/color $a$, and all actual configurations are counted for the deletion bound.

For an arbitrary actual palette $A$, put $d=|A_0\setminus A|$, and count omitted incidences $R$ only in $(A\cap A_0)\times H$. The familiar multiplicity bounds then give

```math
N\le3pd+16R,
```

and consequently

```math
m\ll p^{63/32}+p^{4/3}(R+pd)^{1/3}.                  \tag{4}
```

The support $H$ remains arbitrary. Uniform finite-prime constants for a fixed formula and a fixed lower density $|A_0|\ge\delta p$ follow by the same ultraproduct contradiction as in the earlier technical note. No density assumption on a containing actual palette $A$ beyond that needed for the statement is used.

For the exact definable palette $A=A_0$, finite definable palettes can be treated separately: a bounded finite palette contributes only $O(p)$ edges. In a hypothetical sequence violating the uniform $O(p^{63/32})$ conclusion, $|A|$ must tend to infinity, so its fixed-formula ultraproduct is one-dimensional and the witness construction above applies. Thus the exact fixed-formula case does not require a separately specified numerical density lower bound.

This extension is still a theorem for bounded definable complexity in the field language. An arbitrary positive-density subset of a finite field is not a fixed-formula definable family with boundedly many parameters. No deduction for arbitrary dense palettes, or for unrestricted Erdős #810, follows.

## 7. What the fixed-formula assumption permits

Choose one formula $\varphi(a;t_1,\ldots,t_s)$ in the language of rings once and for all. The parameter values $t_i\in\mathbb F_p$ may vary freely with $p$, but the number of parameters, polynomial degrees, Boolean operations, and quantifier structure stay fixed. The palette is

```math
A_0=\{a\in\mathbb F_p^\times:\mathbb F_p\models
\varphi(a;t_1,\ldots,t_s)\}.
```

This permits fixed-degree polynomial images, such as $\{f(x):x\in\mathbb F_p\}\setminus\{0\}$; fixed-exponent residue conditions; and any fixed finite Boolean combination of such conditions. Polynomial coefficients and shifts can be parameters. The potential support $H$ remains completely arbitrary and need not be definable. The robust version also allows an arbitrary actual palette that omits only a controlled number of colors from this definable palette.

It does not permit an arbitrary palette to be encoded by a list of length comparable to $p$, by interpolation polynomials of degree growing with $p$, or by a formula whose number of parameters or quantifiers grows with $p$. For a fixed formula with $s$ field parameters there are at most $p^s$ parameter instances, whereas there are $2^{p-1}$ subsets of $\mathbb F_p^\times$. Thus a uniformly random palette is overwhelmingly unlikely to belong to any one fixed-formula family. This distinction is essential; the theorem does not cover every dense palette.

The terminology agrees with the fixed-length, parameters-allowed convention in [Pillay–Pascale Stonestrom, *An arithmetic algebraic regularity lemma*, notation following the introduction](https://arxiv.org/html/2412.11206v2). See [the scoped novelty comparison](definable-palette-novelty-audit.md) for the relationship with their result and Tao's earlier work.
