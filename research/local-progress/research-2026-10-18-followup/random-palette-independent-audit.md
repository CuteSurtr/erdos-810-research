# Independent audit of the random-palette container argument

18 October 2026. The argument in [Random palettes with arbitrary common potential supports](coset-quantitative.md) passes the written proof audit below, with the harmless zero-potential convention specified at the end. Its novelty is not determined here.

## Primary theorem verified

I checked the primary PDF of Saxton–Thomason, [*Hypergraph containers*](https://arxiv.org/pdf/1204.6595), Definition 3.2 and Corollary 3.6, printed pages 11 and 14. The corollary's entropy constant depends only on uniformity. Its dependence on the edge fraction is explicitly logarithmic, and its final sparse-set clause covers the threshold used in the draft. Thus it is legitimate to let the edge fraction decrease with $p$; a theorem stated only with unspecified dependence on a fixed edge fraction would not have sufficed.

## Hypergraph and multiplicities

With the draft's exclusions, $a,ar,aqr$ are pairwise distinct: $r=1$ forces $q\in\{0,1\}$, $qr=1$ forces $q=1$, and $ar=aqr$ forces $q=1$. Similarly $u,qu,qru$ are pairwise distinct. Two disjoint copies of the field therefore give six distinct vertices even when a color value happens to equal a potential value numerically.

A six-element hyperedge admits at most eighteen parameter descriptions: its repeated color has three choices and the ordered pair of opposite potentials has six choices. These determine $(a,q)$, so there is no extra multiplicity from subsequently reconstructing the other colors. The full-palette lower count therefore gives the asserted edge supersaturation after division by eighteen. The number of parameter pairs is at most $p^2$, giving the upper bound on total edges. Taking the full potential set in the lower count gives $e(\mathcal G_p)\asymp p^2$ and average degree $\asymp p$.

The pair-codegree bounds were independently checked. For two colors, their roles give either a degree-two ratio equation or the value of $q$ directly. For two potentials, the analogous ratio equations have degree at most two, followed by at most three cube roots. For mixed pairs, all nine roles must be counted, not just the four incidence roles. The draft does this correctly. The five additional rational functions have numerator/denominator degrees respectively

```math
(6,4),\quad(4,5),\quad(4,6),\quad(6,4),\quad(5,4),
```

and hence are nonconstant; all have degree at most six. The four incidence roles are the previously audited degree-at-most-four functions. A specified nonzero mixed ratio therefore gives at most $9\cdot6=54$ descriptions. This verifies $\Delta_j\le54$ for every $j\ge2$, and hence

```math
\delta(\mathcal G_p,\tau)\le\frac{K}{p\tau^5}
```

for an absolute constant $K$.

## Explicit parameter dependence

Let the fixed supersaturation constant be $\beta>0$, let $\gamma=\beta/6$, and let $L_\delta=\log(e/\delta)$. Set

```math
\varepsilon=\beta\delta^3/2,
\qquad \tau=k_\alpha\delta^3/L_\delta^2.
```

For sufficiently small fixed $k_\alpha>0$, both parameters are below one half. The co-degree hypothesis reduces to

```math
\frac{p\delta^{18}}{L_\delta^{10}}
\ge K_1 k_\alpha^{-5},
```

where $K_1$ is absolute. The left side is increasing with $\delta$. At $\delta=Mp^{-1/32}$ it is an absolute positive factor times $p^{7/16}/\log^{10}p$, which tends to infinity. Thus the hypothesis is uniform over the entire claimed density interval once $p$ exceeds a threshold depending on $\alpha$.

The container entropy is bounded above by

```math
K_2 k_\alpha(1+\log(1/k_\alpha))\delta^3p.
```

Here $K_2$ is absolute because $\beta$ and the uniformity six are fixed. Choose $k_\alpha$ so that this is at most $\alpha\gamma\delta^3p/16$. This choice depends only on $\alpha$. No unrecorded dependence on $\delta$ remains.

Every container with at least $\delta p$ potential vertices omits at least $\gamma\delta^3p$ colors. The proof subtracts the container edge bound from full-palette supersaturation and divides by the maximum color degree $3p$; this is valid even when an edge has several missing colors, since overcounting only weakens the estimate.

For each such fixed missing-color set, Chernoff gives failure probability at most $\exp(-\alpha\gamma\delta^3p/8)$. The entropy union bound leaves $\exp(-\alpha\gamma\delta^3p/16)$. On the complementary event, every relevant container misses at least $\alpha\gamma\delta^3p/2$ colors of the random palette. This remains true, with a positive gap, after deletion of at most $\alpha\gamma\delta^3p/4$ random-core colors.

The sparse-set clause then yields

```math
e(\mathcal G_p[A'\cup H])
>\varepsilon\tau^6 e(\mathcal G_p)
\gg_\alpha p^2\delta^{21}/L_\delta^{12}.
```

The power twenty-one is $3+6\cdot3$, and the logarithmic power twelve is $6\cdot2$. Both were checked.

## Simultaneous support quantifier and robustness

The container family is chosen from the fixed full hypergraph before revealing the random palette. The event concerning all containers consequently controls every potential support at once. It remains valid if the support is selected after the palette is observed; no union bound over all $2^p$ supports is needed.

There are only $O(\log p)$ dyadic thresholds from $Mp^{-1/32}$ to one. Their smallest Chernoff exponent has order $p^{29/32}$. Summing the failure probabilities and decreasing the constant preserves the bound $\exp(-c_\alpha p^{29/32})$. Every support above the minimum lies within a factor two of one of these thresholds, which changes the lower-count constants only by an absolute factor.

Each hyperedge supplies an actual ordered repeated-color rectangle. Conversely every ordered rectangle must meet an omitted incidence if the actual graph is B-colored. Since an incidence belongs to at most sixteen ordered rectangles, the number of surviving eligible hyperedges is at most $16R$. This confirms both the zero-omission power saving and the qualitative robust conclusion.

The $o(p^2)$ assertion is appropriately interpreted through fixed-density quantifiers: for every fixed $\delta>0$, the event gives a fixed positive lower bound $\rho_{\alpha,\delta}p^2$ on the required omissions, uniformly over all supports of density at least $\delta$ and all actual B-colored retained graphs. Likewise, deleting $o(p)$ random-core colors is eventually within the allowed fixed positive multiple of $p$ at each fixed support density. Additional palette colors do not harm the lower count from the surviving core and contribute at most $p|H|$ edges in total.

## Minor convention

In the hypergraph estimates, write $h=|H\setminus\{0\}|$ and impose $h\ge Mp^{31/32}$. The hypergraph has only nonzero potential vertices. Restoring zero adds at most $p-1$ incidences and changes the support size by at most one. Thus the theorem stated using $|H|=O(p^{31/32})$ is unaffected; only literal formulas at the threshold need this convention.

## Assessment

This is a valid application of a standard container theorem to the already established six-slot configuration count. It proves the common-potential power saving for a random palette of any fixed positive density, simultaneously for adversarially selected supports. It does not infer a random core from an arbitrary deterministic palette. Neither a general solution of #810 nor established bibliographic priority follows.
