# Random common supports: a simpler collision obstruction

18 October 2026. This strengthens the random-support corollary in [the container note](coset-quantitative.md), but shows that this symmetric random-support statement is already forced by simplicity of the colored graph. It is therefore not a distinct four-cycle phenomenon. The container argument is standard; no novelty claim is made.

## Statement

Fix $0<\alpha<1$. Include each nonzero element of $\mathbb F_p$ independently in $H_p$ with probability $\alpha$. With probability tending to one, simultaneously for every $A\subseteq\mathbb F_p^\times$, the completed incidence family

```math
(a,h)\longmapsto (h/a^2-a,\ h/a),\qquad (a,h)\in A\times H_p,
```

can represent a simple graph with a uniquely assigned color on each edge only if

```math
|A|\ll_\alpha p^{7/8}\log p,
\qquad m\ll_\alpha p^{15/8}\log p.
```

The conclusion is simultaneous over all palettes. If $o(p)$ elements of this random support are removed and $o(p^2)$ incidences are omitted, simplicity still forces $|A|=o(p)$ and $m=o(p^2)$, allowing arbitrary additional actual potential values. No properness or rainbow-cycle assumption is needed.

## The four-vertex collision hypergraph

For distinct nonzero $a,b$, the incidences

```math
(a,-a^2b),\qquad (b,-ab^2)
```

represent the same graph edge $(-a-b,-ab)$ with two distinct colors. The two potential values are distinct, since their equality would imply $a=b$.

Let $\mathcal J_p$ be the four-uniform hypergraph on disjoint color and potential copies of $\mathbb F_p^\times$, with one edge

```math
\{a,b,-a^2b,-ab^2\}
```

for every unordered pair $\{a,b\}$. Distinct pairs give distinct hyperedges because their two color vertices recover the pair. Thus $e(\mathcal J_p)=\binom{p-1}{2}$ and its average degree is $\Theta(p)$.

Every pair codegree is at most six. Two color vertices determine the edge. A specified color $a$ and potential $h$ give either $h=-a^2b$ or $h=-ab^2$, hence at most three choices for $b$. Two potentials $u,v$, with their roles specified, give $a/b=u/v$ and a cubic equation for $b$; allowing both assignments gives at most six choices. Higher codegrees are at most six as well. A fixed potential lies in at most $2p$ edges.

For any color set $S$ of size $h$, the hypergraph on $S$ and the entire potential side has exactly $\binom h2$ edges. An omitted actual incidence $(a,h)$ destroys at most one collision edge, because its possible partner is uniquely $b=-h/a^2$.

## Containers and random support

Use Saxton–Thomason, *Hypergraph containers*, [Corollary 3.6](https://arxiv.org/pdf/1204.6595), including its sparse-set clause. Write $L=\log(e/\delta)$, and choose

```math
\varepsilon=c_0\delta^2,\qquad
\tau=c_1\delta^2/L^2.
```

Here $c_0$ is a sufficiently small absolute constant, followed by $c_1$ sufficiently small in terms of $\alpha$. The pair-codegree bound gives

```math
\delta(\mathcal J_p,\tau)\ll (p\tau^3)^{-1}.
```

The required codegree condition holds uniformly for

```math
\delta\ge\delta_0:=M p^{-1/8}\log p
```

and sufficiently large $p$, since $p\delta^8/L^6\to\infty$ there. The number of containers satisfies

```math
\log|\mathcal C|\ll p\tau\log(1/\tau)\log(1/\varepsilon)
\le c_2\alpha\delta^2p,
```

with $c_2$ arbitrarily small after choosing $c_1$ small. All constants are uniform in $\delta_0\le\delta\le1$.

Any container containing at least $\delta p$ color vertices omits at least $c_3\delta^2p$ potential vertices. Indeed, its color side together with the full potential side creates at least $\delta^2p^2/4$ hyperedges for large $p$, whereas the container has at most $\varepsilon e(\mathcal J_p)$ edges. Deleting one potential removes at most $2p$ edges. Take $c_0$ sufficiently small and compare the two counts.

Chernoff's bound shows that the random support meets every such missing potential set in at least $\alpha c_3\delta^2p/2$ vertices, except with probability $\exp(-c_4\alpha\delta^2p)$. The container entropy is absorbed by choosing $c_2$ smaller than the Chernoff constant. Taking a dyadic set of thresholds from $\delta_0$ to one preserves the conclusion, with overall failure probability $\exp(-c_5 p^{3/4}(\log p)^2)$.

Every independent set lies in a container. Consequently no independent set can contain $H_p$ on the potential side and $\delta p$ colors, for any listed threshold. This proves the asserted bound for completed families.

For robustness, the sparse-set clause states that any vertex set inducing at most $\varepsilon\tau^4 e(\mathcal J_p)$ hyperedges also lies in a container (using this weaker safe threshold suffices). Thus for each fixed $\delta>0$, after deletion of $o(p)$ random support values, every palette of size at least $\delta p$ still creates at least

```math
c_{\alpha,\delta}p^2
```

collision hyperedges. Since one omitted actual incidence destroys at most one such hyperedge, $o(p^2)$ omitted incidences cannot remove them all. This proves the robust vanishing-density statement. Arbitrary extra potential values do not affect the lower count, and the total number of actual incidences is at most $p|A|$.

## Interpretation

This result explains why the random-support direction is weaker evidence of progress on the rainbow-four-cycle obstruction than the random-palette theorem. The latter uses the six-vertex configuration and the rational expansion theorem. For random common supports, even avoiding two colors on one edge already forces a stronger power saving.
