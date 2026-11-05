# Quadratic coset theorem: novelty and write-up assessment

18 October 2026.

## Verdict

**Worth preserving as a short technical note; not yet an established new result in the literature or a major advance on unrestricted Erdős #810.** The exact application was not found in the primary sources inspected. Its possible originality lies in a specific algebraic configuration, the necessary covering-space checks, and the transfer to a restricted family of colored graphs. The expansion framework and its quantitative loss are already published.

The mathematical and historical questions have different answers. The accompanying written proof has survived several separate internal audits, with no remaining gap identified. It is not Lean-verified or externally referee-validated. Historical priority remains unestablished, particularly because the full text of the closely related 2026 paper by Gyárfás, Sárközy, and Wagner could not be obtained.

## Exact result and its scope

Fix a positive integer $L$. Over a sufficiently large prime field, use the eligible colored edges

```math
(a,h)\longmapsto(x,y)=\left(h/a^2-a,h/a\right),
\qquad a\in A\subseteq\mathbb F_p^\times,\quad h\in H\subseteq\mathbb F_p.
```

Thus color $a$ lies on $y=ax+a^2$, and every color uses the same allowed potential set $H$ through the condition $ay\in H$. Suppose retained incidences form a simple proper graph with every four-cycle rainbow. If $C$ is a multiplicative subgroup of index at most $L$, put $D=|tC\setminus A|$ and let $R$ count omitted incidences in $(A\cap tC)\times H$. The [proved bound](quadratic-coset-palette-extension.md) is

```math
m\ll_L p^{2-1/32}+p^{4/3}(R+pD)^{1/3}.
```

In particular, a complete palette coset with all its eligible incidences gives $m=O_L(p^{2-1/32})$ for **arbitrary** $H$. Missing $o(p)$ coset colors and $o(p^2)$ coset incidences still give $m=o(p^2)$. The graph has $N=2p$ vertices.

This excludes a nonvacuous family: for $p\equiv1\pmod3$, the full palette and a potential set in one nontrivial cubic coset can already give a simple proper graph with $\Theta(p^2)$ edges. Properness alone does not explain the conclusion. The theorem forces a non-rainbow four-cycle in such dense supports.

There is no proved reduction of arbitrary #810 colorings to this quadratic family or to a common potential set. Even within this family, arbitrary positive-density palettes and arbitrary incidence deletions remain outside the theorem. A power saving here is therefore a structured-family result, not a universal extremal bound.

## What is inherited and what might be original

| Ingredient | Assessment |
|---|---|
| Definable algebraic regularity, finite witnesses, two Cauchy–Schwarz steps, and the $p^{-1/16}$ loss | Established machinery from Tao. |
| Passing from a cube to a fixed higher-power predicate | A technical adaptation using standard finite-cover and Eisenstein arguments; not a new general method. |
| The rational configuration producing a three-color four-cycle | Application-specific calculation; no exact prior statement located. |
| Four-output dominance and integrality after every separate coordinate cover, including the extra root cover | Necessary geometric verification for this application; not supplied by citing an unrestricted expansion theorem. |
| Forcing all three colors into one prescribed coset and bounding damage from omissions | Concrete graph transfer; no exact prior match located. |
| The exponent $63/32$ | Inherited from the method, not an optimized exponent or a known record. |

The relevant source is [Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/pdf/1211.2894), especially Remark 39 and Theorem 40. Remark 39 already discusses finite-correspondence upper bounds. The present lower bound requires the root-restricted cell-positivity argument and specific geometry, so it is a proof adaptation rather than a literal substitution into Theorem 40. This supports a specialized application claim, not a claim to new expansion theory.

## Closest comparisons

| Primary source | Result of the applicability check |
|---|---|
| [Solymosi, Theorem 5](https://arxiv.org/pdf/1309.0133), and subsequent group versions of Brown–Erdős–Sós | Require genuine group-table coordinates at the relevant density. The obvious product reparametrization loses an original endpoint; the natural affine group has quadratic rather than linear order. No valid reduction was found. |
| [Gyárfás–Sárközy (2023), Theorem 2.2](https://real.mtak.hu/191892/1/012-article-p109.pdf) | Requires color matchings larger than $2p/3$ and gives a palette restriction. It does not cover arbitrary positive-density $H$. |
| [Gyárfás–Sárközy–Wagner (2026)](https://doi.org/10.1016/j.disc.2026.115005) | The accessible abstract concerns perfect matchings and shifted/translation-invariant colorings. Its body remains uninspected; an auxiliary overlap cannot be excluded. |
| [Hong–Lim (2025), Theorem 1.1](https://academic.oup.com/imrn/article/2025/10/rnaf118/8129181) | Its stronger quantitative estimate concerns additive rational progressions. No change of variables preserving arbitrary supports and the root restriction was established. |
| [Arala–Chow (2025)](https://arxiv.org/pdf/2403.03732) and [Arala–Chow (2026)](https://doi.org/10.1017/prm.2026.10130) | Image-complement estimates can leave the required value zero missing and do not impose the coupled root condition. The direct 2026 incidence estimate is too weak at the relevant set sizes. |
| Later algebraic regularity and finite-cover frameworks | Confirm that the analytic ingredients are established; no stronger directly applicable restricted-fibre count was located. |

The review also checked the recent B-coloring literature through [Hu–Kong–Wang (September 2026)](https://arxiv.org/html/2609.02845v1). Its degree/degeneracy bounds concern the number of colors needed and do not furnish this support-specific density theorem. Multiplicative recurrence results such as [Frantzikinakis, Theorem 2.2](https://arxiv.org/html/2503.15175v2) have different pattern and action hypotheses; no uniform finite-field transfer was established.

Exact-title and formula searches were used as discovery tools only. Failure to find a matching string is not evidence of originality. The substantive comparison above concerns hypotheses and conclusions, including possible changes of coordinates.

## Is it worth writing up?

Yes, proportionately: a concise self-contained note for mathematical review is justified. The value is excluding a concrete dense algebraic template with unrestricted one-dimensional support and robust omissions. The proof also identifies precisely why a root-unrestricted expansion citation would be insufficient.

A suitable title is **“A power saving for quadratic affine B-colorings with a fixed-index palette coset.”** The note should lead with the restricted theorem and a dense proper example, explicitly credit Tao's method, then give the configuration, geometric checks, counting adaptation, and deletion argument. The easier higher-degree properness bound could supply context, but should not be used to inflate the contribution.

The evidence does not yet justify a large formalization effort or a claim of standalone publication significance. Two targeted checks remain before asserting priority: comparison with the complete 2026 perfect-coloring paper, and specialist review of the all-separate-covers and restricted-cell positivity arguments. No author was contacted. These are future validation steps, not hidden assumptions in the stated theorem.

## Evidence files

- [Complete theorem and proof](quadratic-coset-palette-extension.md).
- [Expansion-framework comparison and exact theorem locations](novelty-expansion-framework-audit.md).
- [Graph, group-table, Latin-square, and incidence reductions](novelty-graph-model-audit.md).
- [Coloring literature and the 2026 full-text access ledger](novelty-2026-paper-audit.md).
- [Overall research report and earlier mathematical audits](REPORT.md).

The three audit strands agree on the narrow conclusion: a possible new concrete application, with substantially better evidence for correctness than for historical originality or publication significance.

Audit concluded at 10:19:50 UTC, within the original two-hour research limit. All audit work stopped; no continuation was scheduled.
