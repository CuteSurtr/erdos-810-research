# Random palettes with arbitrary common potential supports

18 October 2026. This note develops a further consequence of the quadratic configuration count. The central additional input is the standard hypergraph container theorem. The proof is complete as a written argument, subject to independent review; no historical novelty or formal verification is claimed. It does not settle arbitrary deterministic palettes or unrestricted Erdős problem #810.

## 1. Statement

Fix a constant $0<\alpha<1$. Form $A_p\subseteq\mathbb F_p^\times$ by including each color independently with probability $\alpha$. With probability at least

```math
1-\exp(-c_\alpha p^{29/32}),
```

the following statement holds **simultaneously for every** $H\subseteq\mathbb F_p$. If all incidences

```math
(a,h)\longmapsto (h/a^2-a,h/a),\qquad (a,h)\in A_p\times H,
```

form a simple proper B-coloring, then $|H|=O(p^{31/32})$, and hence its edge count is $O(p^{63/32})$. Here B means that every four-cycle is rainbow. The implicit support constant can be chosen absolute; the sufficiently-large-prime threshold and probability constant may depend on $\alpha$.

There is also a robust qualitative conclusion. With probability tending to one, uniformly over $H$ and over actual B-colorings obtained from the eligible incidence system, omitting $R=o(p^2)$ eligible incidences still forces $|H|=o(p)$ and $m=o(p^2)$. These statements mean the following precise quantified version: for each fixed $\delta>0$ there exists $\rho_{\alpha,\delta}>0$ such that, with failure probability at most $\exp(-c_{\alpha,\delta}p)$, every $H$ of size at least $\delta p$ requires at least $\rho_{\alpha,\delta}p^2$ incidence omissions to become B.

The robust conclusion survives deletion of $o(p)$ colors from $A_p$. Additional colors outside the random palette may be present without restriction; all retained edges are counted, and only omissions in the surviving random core need be counted. The fixed-density random palette is a hypothesis, not something derived from an arbitrary dense palette.

## 2. Configuration hypergraph

Potential sets in Sections 2–5 are subsets of $\mathbb F_p^\times$. To apply their estimates to an arbitrary original support $H\subseteq\mathbb F_p$, use $H^*=H\setminus\{0\}$ and $h=|H^*|$. The possible zero potential is restored in Section 6.

Write

```math
Q=q^2+1,\quad B=q^2+q+1,\quad
r=\frac{q+1}{Q},\quad F=-\frac{BQ}{q(q+1)}.
```

For $a\ne0$, exclude $q=0,1,-1$ and the roots of $QB$. Put

```math
u=a^3/F,\quad v=qu,\quad k=qru,\quad b=ar,\quad c=aqr.
\tag{1}
```

These are the already verified equal-cross configurations. Their colored incidences are

```math
(a,u),\quad(a,v),\quad(b,k),\quad(c,k),
\tag{2}
```

and form a nondegenerate four-cycle with repeated opposite color $a$. The three colors $a,b,c$ are distinct. The three potentials $u,v,k$ are also distinct: $q\ne1$, $r\ne1$, and $qr\ne1$ on the indicated domain.

Let $\mathcal G_p$ be the simple 6-uniform hypergraph on two disjoint copies of $\mathbb F_p^\times$, one for colors and one for potentials, whose hyperedges are

```math
\{a_{\rm col},b_{\rm col},c_{\rm col},
  u_{\rm pot},v_{\rm pot},k_{\rm pot}\}
```

arising from (1). Repeated descriptions produce just one hyperedge. There are at most 18 descriptions per hyperedge: choose the repeated color in three ways, and the ordered pair $(u,v)$ among the three potentials in six ways. These choices recover $q=v/u$ and $a$, hence the description.

For a potential set $S$, let $\mathcal Q(S)$ denote the ordered configurations (1) with $u,v,k\in S$. The proved full-palette count gives absolute $c_0,C_0>0$ such that

```math
|\mathcal Q(S)|\ge c_0|S|^3/p-C_0p^{15/16}|S|.
\tag{3}
```

Consequently there are absolute $M,\beta>0$ so that, whenever
$|S|\ge Mp^{31/32}$,

```math
e\bigl(\mathcal G_p[\mathbb F_p^\times{}_{\rm col}
                  \cup S_{\rm pot}]\bigr)
\ge\beta |S|^3/p.
\tag{4}
```

The factor 18 has been absorbed into $\beta$. We may decrease $\beta$ so that $\beta<1/4$. In particular, $e(\mathcal G_p)\asymp p^2$, while the upper bound $e(\mathcal G_p)\le p^2$ follows directly from the two parameters $(a,q)$. Its order is $n=2(p-1)$ and average degree is $d\asymp p$.

Each color vertex belongs to at most $3p$ hyperedges, since it has three color roles and each role has at most one value of $a$ for each $q$. This fact will force a large missing-color set inside each container.

## 3. Bounded pair-codegrees

Every pair of distinct vertices belongs to at most 54 hyperedges. The bound applies also when the two numerical field values coincide but the vertices lie in the two different copies.

For two colors, fix their ordered roles. The equations for $b/a=r(q)$ and $c/a=qr(q)$ have degree at most two; $c/b=q$ determines $q$. Then a fixed color determines $a$. Six ordered role choices give an upper bound of 12 descriptions.

For two potentials, the role pair $(u,v)$ determines $q$ and permits at most three cube roots $a$. The ratios $k/u=qr(q)$ and $k/v=r(q)$ give at most two values of $q$ and then at most three values of $a$. Six ordered role choices therefore give at most 36 descriptions.

For a color and a potential, it is important not to count only the four actual incidences in (2): five other role pairs occur in the six-vertex hyperedge. For all nine role pairs, the prescribed nonzero ratio color-cubed/potential equals an entry of

```math
\begin{pmatrix}
F&F/q&F/(qr)\\
Fr^3&Fr^3/q&Fr^2/q\\
Fq^3r^3&Fq^2r^3&Fq^2r^2
\end{pmatrix}.
\tag{5}
```

Each entry is a nonconstant rational function of degree at most six. For completeness, after cancelling factors the five entries not already associated to (2) are

```math
-\frac{BQ^2}{q^2(q+1)^2},\quad
-\frac{B(q+1)^2}{qQ^2},\quad
-\frac{B(q+1)^2}{q^2Q^2},\quad
-\frac{q^2B(q+1)^2}{Q^2},\quad
-\frac{qB(q+1)^2}{Q^2}.
```

Their numerator and denominator degrees are unequal. The four remaining entries are the nonconstant rational functions of degree at most four in the existing incidence-multiplicity proof. A prescribed value in each role therefore admits at most six values of $q$; the fixed color then determines $a$. Summing over the nine roles gives 54. Every higher codegree is at most the pair-codegree, so

```math
\Delta_j(\mathcal G_p)\le54\qquad(2\le j\le6).
\tag{6}
```

All statements are for sufficiently large prime characteristic; the degree arguments are unaffected there.

## 4. Container input and missing colors

Use Saxton–Thomason, *Hypergraph containers*, Corollary 3.6, printed p.14, including its final sparse-set clause. For a fixed uniformity $r$, if the co-degree function obeys $\delta(\mathcal G,\tau)\le\varepsilon/(12r!)$, it supplies containers with at most $\varepsilon e(\mathcal G)$ edges, logarithmic count at most $C_r\log(1/\varepsilon)n\tau\log(1/\tau)$, and covering every vertex set spanning at most $\varepsilon\tau^r e(\mathcal G)$ edges (a weakening of the stated sparse-set threshold). We use only this standard consequence; no new container theorem is asserted.

From (6), $d\asymp p$, and $0<\tau<1$, the source's definition gives

```math
\delta(\mathcal G_p,\tau)\ll\frac1{p\tau^5}.
\tag{7}
```

Fix a support threshold $\delta$ with $Mp^{-1/32}\le\delta\le1$, and take

```math
\varepsilon=\tfrac12\beta\delta^3.
\tag{8}
```

Write a container as $C=C_{\rm col}\sqcup C_{\rm pot}$. If $|C_{\rm pot}|\ge\delta p$, (4) gives at least $\beta\delta^3p^2$ hyperedges using arbitrary colors and potentials in $C_{\rm pot}$. But the container retains at most $\varepsilon e(\mathcal G_p)\le\beta\delta^3p^2/2$ such edges. Each missing color removes at most $3p$ edges. Hence

```math
|\mathbb F_p^\times\setminus C_{\rm col}|
\ge\gamma\delta^3p,\qquad\gamma=\beta/6.
\tag{9}
```

This converts full-palette supersaturation into a uniform deficit in every relevant container; it does not assume equidistribution of the three coupled color memberships.

## 5. Uniform random-palette supersaturation

Put $L_\delta=\log(e/\delta)$ and choose

```math
\tau=k_\alpha\delta^3/L_\delta^2,
\tag{10}
```

where $k_\alpha>0$ is a sufficiently small constant. Since
$\log(1/\varepsilon)\ll L_\delta$ and
$\log(1/\tau)\ll(1+\log(1/k_\alpha))L_\delta$, the number of containers can be made to satisfy

```math
\log|\mathcal C|
\le\frac{\alpha\gamma}{16}\delta^3p.
\tag{11}
```

This uses $k\log(1/k)\to0$. The co-degree condition (7) follows, uniformly in the indicated range of $\delta$, from

```math
\frac{p\delta^{18}}{L_\delta^{10}}\longrightarrow\infty.
```

At the smallest permitted $\delta=Mp^{-1/32}$ the numerator grows like $p^{7/16}$, faster than the logarithmic denominator. Thus the hypotheses hold for every sufficiently large prime, uniformly in this range.

For a fixed container with at least $\delta p$ potential vertices, let $D$ be its missing-color set. By (9), $|D|\ge\gamma\delta^3p$. The random variable $|A_p\cap D|$ is binomial with mean $\alpha|D|$. The elementary Chernoff bound gives

```math
\Pr\bigl(|A_p\cap D|\le\alpha|D|/2\bigr)
\le\exp(-\alpha|D|/8).
```

Combining this with (11) and taking a union bound shows that, except with probability at most $\exp(-\alpha\gamma\delta^3p/16)$, every relevant container misses at least
$\alpha\gamma\delta^3p/2$ colors of $A_p$.

In particular, no such container can contain $A_p\sqcup H$ when $|H|\ge\delta p$. By the sparse-set clause of the container theorem,

```math
e\bigl(\mathcal G_p[A_p{}_{\rm col}\cup H_{\rm pot}]\bigr)
>\varepsilon\tau^6 e(\mathcal G_p)
\ge c_\alpha\frac{\delta^{21}}{\log^{12}(e/\delta)}p^2.
\tag{12}
```

The final constant uses $e(\mathcal G_p)\gg p^2$. The power 21 and logarithms are an unoptimized loss from the container input; they are not claimed to describe the true supersaturation rate.

More generally, (12) holds after replacing $A_p$ by any $A'\subseteq A_p$ that omits at most $\alpha\gamma\delta^3p/4$ colors of $A_p$. Such an $A'$ still cannot be contained in any relevant container. Supersets of $A'$ may be used as the actual palette as well.

Apply this argument to dyadic values $\delta_j=2^jMp^{-1/32}\le1$. There are $O(\log p)$ values. Their total failure probability is at most $\exp(-c_\alpha p^{29/32})$ after decreasing the constant. For an original support $H\subseteq\mathbb F_p$, put $H^*=H\setminus\{0\}$ and $h=|H^*|$. If $h\ge Mp^{31/32}$, choose a dyadic threshold within a factor two of $h/p$. Equation (12), with altered constants, then gives the simultaneous lower bound

```math
e\bigl(\mathcal G_p[A_p{}_{\rm col}\cup H^*_{\rm pot}]\bigr)
\ge c_\alpha p^2
\frac{(h/p)^{21}}{\log^{12}(ep/h)}.
\tag{13}
```

All these events refer to the single random palette; $H$ may be chosen after that palette is revealed. This order of quantifiers is essential.

## 6. Incidence omissions and the B condition

In the actual graph each configuration whose colors and potentials are eligible must lose at least one incidence from (2), or it would be a non-rainbow four-cycle. The established incidence multiplicity bound is sixteen for ordered configurations. Therefore, if $R$ eligible incidences are omitted,

```math
e\bigl(\mathcal G_p[A_p{}_{\rm col}\cup H^*_{\rm pot}]\bigr)
\le |\mathcal Q(A_p,H^*)|\le16R.
\tag{14}
```

For $R=0$, (13) excludes $h\ge Mp^{31/32}$ and proves the stated power saving. For $R=o(p^2)$, if $h/p$ failed to tend to zero then (13) would give a fixed positive multiple of $p^2$ on a subsequence, contradicting (14). Since the actual edge count is at most $p(h+1)$, the total is $o(p^2)$.

Potential zero costs at most $p-1$ edges and is restored at the end. The same proof uses $A'$ from the previous section if $o(p)$ colors of the random core are unavailable. For every fixed positive support density the allowed missing-color threshold is a fixed positive multiple of $p$, so any $o(p)$ color deficit is eventually permitted. Take $A'=A_p\cap A_{\rm actual}$; the incidence count $R$ is then needed only for $A'\times H$, and extra colors do not affect the bound $m\le p|H|$.

## 7. Scope and comparison

For each fixed index bound $L$ and fixed $0<\alpha<1$, with probability tending to one every multiplicative coset of index at most $L$ has at least $(1-\alpha)/(2L)\cdot(p-1)$ colors missing from $A_p$. This is another direct Chernoff bound, followed by a union bound over at most $\sum_{\ell\le L}\ell$ cosets. Thus a typical palette in the present theorem contains no almost-complete coset of any fixed bounded index. This establishes a real extension of scope beyond the deterministic coset hypothesis.

The theorem permits arbitrary common potential supports, including supports with no useful multiplicative symmetry or Fourier-envelope bound. It does not prove that every dense palette is typical in the required sense; exceptional deterministic palettes remain open. It also does not provide a reduction from general B-colorings to the common-potential model.

The new step here is a standard container transfer applied to the specific six-slot configuration hypergraph. The full-palette algebraic count and its exponent come from the prior quadratic theorem and Tao's framework. Novelty of this specialized consequence has not been established by a complete literature search.

## References and exact dependencies

1. D. Saxton and A. Thomason, *Hypergraph containers*, Inventiones Mathematicae **201** (2015), 925–992. [Primary preprint](https://arxiv.org/pdf/1204.6595), Corollary 3.6, printed p.14, and Definition 3.2 for the co-degree function. The sparse-set clause is used explicitly in (12).
2. D. Saxton and A. Thomason, *Online containers for hypergraphs, with applications to linear equations*, [primary preprint](https://arxiv.org/pdf/1611.01433), Corollary 1.3, printed p.5, gives an alternative qualitative proof with a fixed support threshold; its constants suffice for the $o(p^2)$ conclusion. The explicit dependence in the first source is used for the uniform power saving.
3. [Quadratic coset technical note](https://github.com/CuteSurtr/erdos-810-research/blob/main/quadratic-coset-palettes.md), Sections 2–5: exact rectangles, incidence multiplicity, and the full-palette specialization of the root-restricted count.

## 8. Primary-source novelty check and deterministic limitation

The probabilistic transfer itself is established machinery. Saxton–Thomason's Corollary 3.6 applies directly after checking the configuration hypergraph; no new algebraic geometry is used beyond (3). Their later *Online containers* Corollary 1.3 also immediately supplies the qualitative fixed-$\delta$ version. Thus this should be described as a **random-palette corollary of the quadratic configuration count**, not as a new transference principle or a separate breakthrough in random extremal theory.

The general context is already covered by Conlon–Gowers, [*Combinatorial theorems in sparse random sets*](https://annals.math.princeton.edu/wp-content/uploads/annals-v184-n2-p02-p.pdf), and Schacht, [*Extremal results for random discrete structures*](https://annals.math.princeton.edu/wp-content/uploads/annals-v184-n2-p01-p.pdf). The latter's Theorem 3.3 assumes global density and boundedness for a uniformly sampled ambient hypergraph. It does not literally state the present assertion with randomness only on the color copy and an arbitrary potential set selected afterwards. The standard container theorem is the direct sufficient published result here.

A recent primary source is Allen–Böttcher–Lada–Mergoni Cecchelli, [*A generalised transference principle*](https://arxiv.org/pdf/2608.17982), August 2026. Its Theorems 2.4 and 2.6 concern ordered hypergraphs with bounded codegrees and prescribed families of weighted subcounts. They reinforce that transferring suitable configuration results to random subsets is a general established program. A direct invocation with one weight for every possible potential set would need to check their bound on the number of subcounts, which is at most $\exp(pn/C)$ in their notation. Our full family has $2^{p-1}$ supports, and no such direct substitution has been justified. No claim is made that these sources exclude another route to the same corollary.

Targeted searches for this quadratic common-potential model, random palettes in B-colorings, and the rainbow-four-cycle literature did not locate a statement of this precise random-palette consequence. This is a limited negative search result, not proof of historical priority. Once the full-palette count and bounded codegrees are available, the implication is standard enough that its main role is to broaden the scope of the technical note.

There is a sharp conceptual limitation to the argument: for every fixed support density $\delta$, it only says that any exceptional deterministic palette must fit inside one of a small collection of color sets each missing at least $\gamma\delta^3p$ colors. A palette of density $\alpha<1-\gamma\delta^3$ can still fit in such a set. The container method does not show that those exceptional palettes contain a near-full multiplicative coset, or have any other exploitable algebraic structure. Eliminating these exceptional palettes would require a new deterministic recurrence or structural theorem, not another probability estimate.

## 9. Random common potential supports and arbitrary palettes

There is a symmetric consequence, with one additional elementary count. Fix $0<\alpha<1$ and choose $H_p\subseteq\mathbb F_p^\times$ independently with probability $\alpha$ for each value. With probability at least $1-\exp(-c_\alpha p^{29/32})$, simultaneously for every palette $A\subseteq\mathbb F_p^\times$, a completed B-coloring with incidences $A\times H_p$ has

```math
|A|=O(p^{31/32}),\qquad m=O(p^{63/32}).
```

If $R=o(p^2)$ eligible incidences are omitted, then $|A|=o(p)$ and $m=o(p^2)$. The conclusion survives deleting $o(p)$ values from the random support core and adding arbitrary further potential values. Here $R$ need only count omissions on $A$ times the surviving random core. The palette may be selected after the random support is revealed.

To prove the full-potential supersaturation needed for the same container argument, set $k=|A|$ and $A^{-1}=\{a^{-1}:a\in A\}$. The already proved lower count for $K$ gives at least

```math
\frac{c k^3}{p}-C p^{15/16}k
```

ordered triples $(x,y,z)\in(A^{-1})^3$ with $z=K(x,y)$. In fact the previous root-restricted estimate counts a subset of these triples, which is sufficient here; its extra cube condition is not needed. Put $b=1/x$, $c=1/y$, $a=1/z$. Then

```math
a=\frac{b^2+c^2}{b+c},\qquad a(b+c)=b^2+c^2.
```

The denominator cannot vanish for these triples. If $b\ne c$, then also $a\ne b,c$: for example $a=b$ would imply $c(b-c)=0$. For $q=c/b$, the relation gives $b/a=(q+1)/(q^2+1)=r(q)$. Thus this color triple supplies the configuration (2), unless $B(q)=q^2+q+1=0$. The diagonal $b=c$ and those at most two additional values of $q$ cost at most $3k$ triples, which are absorbed into the displayed error. The other excluded parameter values are already ruled out by the nonzero, distinct colors and the equation.

Each simple hyperedge has at most eighteen parameter descriptions as before. Consequently, for sufficiently large fixed $M$, every $A$ with $k\ge Mp^{31/32}$ satisfies

```math
e\bigl(\mathcal G_p[A_{\rm col}\cup(\mathbb F_p^\times)_{\rm pot}]\bigr)
\ge \beta'k^3/p.
```

A fixed potential value belongs to at most $9p$ parameter configurations: there are three possible potential roles; fixing $q$ and the role gives a nonzero equation for $a^3$, with at most three roots. Thus its hypergraph degree is at most $9p$. All codegree bounds of Section 3 remain unchanged.

Now interchange the two vertex copies throughout Sections 4–6, replace the maximum degree $3p$ used to remove colors by $9p$ for removing potential values, and decrease the fixed constants accordingly. A container containing $\delta p$ color vertices must omit at least $\gamma'\delta^3p$ potential vertices. The same choices $\varepsilon\asymp\delta^3$ and $\tau\asymp_\alpha\delta^3/\log^2(e/\delta)$, followed by Chernoff and the dyadic union bound, give

```math
e\bigl(\mathcal G_p[A_{\rm col}\cup(H_p)_{\rm pot}]\bigr)
\ge c_\alpha p^2\frac{(k/p)^{21}}{\log^{12}(ep/k)}
\qquad(k\ge Mp^{31/32}).
```

The incidence-deletion bound $e\le16R$ is unchanged. Since every actual graph has at most $p|A|$ edges, the conclusions follow, including arbitrary additional potential values. The proof for deleting $o(p)$ random-core values is the same container-hitting margin used for missing random-core colors in Section 5. This is a second application of the same standard transfer, with no additional geometric input and no separate novelty claim.


