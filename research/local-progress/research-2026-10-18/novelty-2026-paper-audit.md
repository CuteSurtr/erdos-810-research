# Quadratic coset theorem: coloring literature and the 2026 paper

**Later full-text comparison:** The access gap described below was resolved on 18 October 2026. The complete publisher article has now been compared; see [the full-text comparison](perfect-colorings-full-text-comparison.md). The earlier access log is retained as a historical record. The quadratic-coset theorem was not found in the paper and no direct implication was found; broader priority remains unverified.

Audit date: 18 October 2026. This is a scoped historical comparison, not a certificate of priority. No author was contacted and nothing was submitted or published.

## Verdict

The inspected primary statements do not directly imply the current quadratic coset theorem. They impose a genuine group-table model, perfect color classes, translation symmetry, or a substantially different matching-size hypothesis. No exact published treatment of the quadratic common-potential family was identified.

This supports describing the result as a **possible new concrete application of established algebraic expansion machinery**. It does not support claiming a new general expansion method, an established new record for Erdős #810, or certified historical originality. The full text of Gyárfás–Sárközy–Wagner (2026) was not recovered; its body remains uninspected. The separate [framework audit](novelty-expansion-framework-audit.md) concerns the analytic machinery rather than the coloring-specific comparison here.

## Exact statement being compared

For a fixed bound $L$, let $C\leq\mathbb F_p^\times$ have index at most $L$. Available colored incidences are

```math
(a,h)\longmapsto (x,y)
=\left(\frac{h}{a^2}-a,\frac{h}{a}\right),
\qquad a\in A,\quad h\in H.
```

The actual incidences form a simple proper bipartite coloring in which every $C_4$ is rainbow. A target coset $tC$ has $D=|tC\setminus A|$ missing colors and $R$ missing incidences in $(A\cap tC)\times H$. The locally proved conclusion is

```math
m\ll_L p^{63/32}+p^{4/3}(R+pD)^{1/3}.
```

Here $H$ is arbitrary, constants are uniform in the varying coset representative $t$, and other colors may be present. The theorem is about this special support model. It is not the unrestricted $o(N^2)$ assertion of #810.

## Primary comparisons

| Source and verified location | What it establishes | Why it does not directly settle this statement |
|---|---|---|
| Burr–Erdős–Graham–Sós, *Maximal antiramsey graphs and the strong chromatic number* (1989), printed pp. 272–273, [author archive](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf) | The established connection with sparse triple systems and constructions of graphs whose small prescribed subgraphs are rainbow. | The hypergraph projection is not a density theorem for the partial affine model above. The connection between #810 and Brown–Erdős–Sós must not be advertised as new. |
| Sárközy–Selkow, *On an anti-Ramsey problem of Burr, Erdős, Graham, and T. Sós* (2006), Theorem 4, printed p. 150, [DOI](https://doi.org/10.1002/jgt.20148) | A result for connected bipartite target graphs that are not complete bipartite. The earlier audit inspected the full published paper. | $C_4=K_{2,2}$ is outside the stated target class. Its regularity argument does not supply the necessary closing edge for this case. |
| Gyárfás–Sárközy, *“Less” Strong Chromatic Indices and the (7,4)-Conjecture* (2023), Theorem 2.2, printed p. 114, proof p. 118, [published PDF](https://real.mtak.hu/191892/1/012-article-p109.pdf) | For a balanced bipartite B-coloring with $t$ color matchings, all of size $cn$, where $c=2/3+\varepsilon$, it gives $t<(1-\delta)n$ when $\delta<9\varepsilon/(6\varepsilon+4)$ and $n$ is sufficiently large. | In the current model a complete color class has $|H|$ edges, possibly a small fixed fraction of $p$. The hypothesis $c>2/3$ need not hold. Even where it holds, this is a palette restriction rather than the displayed power saving for arbitrary $H$. |
| Gyárfás–Sárközy–Wagner, *Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s* (2026), [official abstract](https://www.sciencedirect.com/science/article/pii/S0012365X26000294), [DOI](https://doi.org/10.1016/j.disc.2026.115005) | The accessible abstract studies $d$-regular balanced bipartite graphs colored by $d$ perfect matchings, with superlinear order for shifted colorings and an extension to translation-invariant colorings using induced matchings. | Our color classes are partial matchings with color-dependent endpoint sets. Neither perfectness nor the paper's uninspected definition of translation invariance follows from the hypotheses. The abstract does not give a direct implication; an auxiliary result in the unavailable body cannot be excluded. |
| Solymosi, *The (7,4)-conjecture in finite groups*, [arXiv:1309.0133](https://arxiv.org/abs/1309.0133), and Nenadov–Sudakov–Tyomkyn, *Proof of the Brown–Erdős–Sós conjecture in groups*, Theorem 1.3, manuscript p. 2, [primary PDF](https://arxiv.org/pdf/1902.07614) | Dense subsets of genuine group multiplication tables contain the required configurations; the latter treats every fixed number of edges. Density is measured relative to $|\Gamma|^2$. | The displayed affine model is not already such a table on a group of order $O(p)$. The natural affine group has order $p(p-1)$, so lifting only $\Theta(p^2)$ incidences there does not meet a fixed positive density hypothesis. A new, incidence-preserving reduction would be required. |

The 2023 statement and proof were reopened for this audit. Its introductory B-coloring definitions and its finite-plane examples likewise do not provide a bound for the arbitrary common-potential support. Finite-plane incidence graphs already have subquadratic size and do not model the dense family under consideration.

There is a particularly concrete warning about the group-table comparison. Write $b=-x-a$. Then

```math
(x,y)=(-(a+b),-ab),\qquad h=-a^2b.
```

Thus the model is an oriented restricted sum/product graph. Replacing a triple $(a,x,y)$ by $(a,y,ay)$ does produce a multiplication relation, but it loses the original row coordinate $x$. Configurations in that new table therefore need not give the desired repeated-color rectangle. An isomorphism preserving the relevant incidences must be proved; it cannot be inferred from the occurrence of a product in the formulas.

## Fresh public-route audit of the 2026 full text

The paper is Discrete Mathematics **349**(6), article 115005, DOI **10.1016/j.disc.2026.115005**. The following checks were made in this pass, rather than repeatedly attempting previously unsuccessful publisher APIs.

1. The current [official MTMT record 36937867](https://m2.mtmt.hu/api/publication/36937867) lists DOI, citation-database identifiers, and the Elsevier linking-hub URL. It does not provide a REAL repository link. Nearby 2026 records do have REAL links, so the distinction is visible in the actual catalogue, not inferred from a failed keyword search.
2. [Sárközy's current author publication list](https://web.cs.wpi.edu/~gsarkozy/papers/paper.html), item 103, links to ScienceDirect. The list now includes later items through 110, but this paper's entry still supplies no author-hosted manuscript.
3. The actual link targets in [Gyárfás's author homepage](https://www.renyi.hu/~gyarfas/) were inspected. Its publication navigation ends with a [2010–2019 page](https://www.renyi.hu/~gyarfas/index_files/publications_2010_2019.htm) and an old [arXiv-only page](https://www.renyi.hu/~gyarfas/index_files/papers_on_arxiv_only.htm). The previously hypothesized 2020–2029 path is not part of that homepage's navigation. This route produced no 2026 manuscript.
4. [Wagner's current author page](https://zawagner22.github.io/) was inspected, as was the complete, nontruncated public file tree of its [website repository](https://github.com/zawagner22/zawagner22.github.io). No matching manuscript or publication entry was present. The separate older `publications.html` page ends with 2021 preprints and 2020 publications; it is not a current full bibliography.
5. Exact title, DOI/article-number, and PII searches supplied the same publisher and catalogue records, not another primary full text. Secondary abstract copies were useful only as discovery aids. Their recovered formulas and small-order values were not promoted to primary-verified theorem statements.

**Result:** the access gap remains. This is a bounded, documented failure to recover the manuscript, not evidence that no public copy exists and not evidence that the paper lacks a related observation. No request-for-full-text message was sent.

## What would constitute a prior match

A prior theorem would subsume the current statement if it applied to arbitrary subsets $H\subseteq\mathbb F_p$, a nearly full fixed-index multiplicative palette coset, and the actual row/column coordinates above, giving $o(p^2)$ or a stronger quantitative bound with the permitted omissions. A published general theorem plus a short valid coordinate reduction would also count; exact wording or notation need not match.

The following are insufficient by themselves:

- Expansion of the unrestricted rational image $K(X,Y)$: the color root must simultaneously exist in a prescribed coset.
- A theorem for bounded-complexity definable $H$: $H$ here is arbitrary and may vary with $p$ without any complexity bound.
- Group-table density without a coordinate-preserving group model of the right size.
- A perfect-matching or translation-invariant coloring theorem without a valid conversion of the partial matchings.
- A theorem forcing a rainbow cycle: the forbidden configuration here is a **non-rainbow** $C_4$.

The present proof's established input is Tao's algebraic regularity/expansion framework. Its mathematical comparison should therefore be framed as an application-specific verification of separate-cover integrality and a root-restricted counting consequence, followed by an explicit coloring transfer. The broad analytic mechanism is already published. The exact application was not located in this audit; its historical originality remains unestablished.
