# Prime-field average defect: source and novelty audit

Date: 2026-10-15. Companion to `pass2-prime-field-average-defect.txt`.

## What was checked

The local theorem concerns a proper coloring with every C4 rainbow, whose colors are restrictions of nonconstant affine permutations of F_p. Writing d for the number of color labels and D=dp-m for the total omitted colored incidences, the proof establishes

    D=o(p^(11/7))  =>  m=o(p^2).

The same holds under average defect D/d=o(p^(4/7)). The proof handles duplicate completions before passing to the dual point set. It does not establish the arbitrary-support affine case, and it is not a universal result for Erdős #810.

The source input has been verified against the primary PDF. The argument's dyadic uses of the incidence theorem satisfy its cardinality and characteristic restrictions. This is additional source validation, not a replacement for the independent mathematical audits by the other agents.

## Exact published incidence input

Sophie Stevens and Frank de Zeeuw, *An Improved Point-Line Incidence Bound Over Arbitrary Fields*, [arXiv:1609.06284](https://arxiv.org/pdf/1609.06284), Theorem 3, PDF p. 2:

    v^(7/8) < w < v^(8/7),   v^(-2) w^13 << p^15
    imply I(P,L) << v^(11/15) w^(11/15).

Its Beck consequence is Corollary 14, PDF p. 16. The proof there explicitly derives the dyadic rich-line bound T_k << v^(11/4) k^(-15/4). Thus the exponents in the local result come from an existing incidence theorem and its standard dyadic proof mechanism. The local geometric alternative — a linear-size collinear subset, or at least c v^(11/7) total incidences with determined lines — is an adaptation of that mechanism, not grounds for claiming a new incidence theorem.

For the local application v=d=Theta(p), a rich class has w<d^(8/7), and d^(-2)w^13 <= d^(90/7)=o(p^15). The smaller classes are handled by an elementary Cauchy–Schwarz bound, so the published theorem is not being extrapolated beyond its stated range.

The coloring-specific step is that the total incidence count of the dual palette satisfies I_* <= 2D+d, while a large parallel/concurrent pencil is excluded by the known partial group-table theorem. The latter is Solymosi's [*The (7,4)-conjecture in finite groups*, Theorem 5](https://arxiv.org/pdf/1309.0133), after translating a pencil to an additive or multiplicative group table. Neither input alone is the whole local conclusion.

## Distinct later primary sources checked for a stronger applicable exponent

1. Iosevich–Pham–Senger–Tait, [*An improved point-line incidence bound over arbitrary finite fields via the VC-dimension theory*, arXiv:2303.00330](https://arxiv.org/pdf/2303.00330), published in EJC 118 (2024), 103928 under the shorter title *Improved incidence bounds...*. Theorem 1.2 assumes a Cartesian product point set; subsequent results concern point-plane incidences with additional hypotheses. The arbitrary dual palette is not a Cartesian product. The introduction identifies Stevens–de Zeeuw as the general prime-field improvement then available. This source does not improve the local 4/7 average-defect exponent.

2. Bright–Lund–Pham, [*On a radial projection conjecture and pinned directions in finite spaces*, arXiv:2311.05127](https://arxiv.org/pdf/2311.05127), Theorems 1.2–1.3, PDF p. 2. Their useful planar large-set conclusion assumes at least 30p points (the cited predecessor has a 6p threshold). The near-complete color model has d<(1+o(1))p, so that hypothesis fails. The smaller-set exceptional-set estimate does not force a useful pin inside a d=Theta(p) palette. “Pinned directions” must not be mistaken for a directly applicable stronger Beck bound here.

3. Lund–Zhang, [*A combinatorial approach to point-flat incidences over finite fields*, arXiv:2609.33365](https://arxiv.org/pdf/2609.33365), Theorem 1 and Corollary 4, PDF pp. 1–2. This very recent result improves discrepancy in specified higher-dimensional flat ranges. For planar point-line incidences its n=d=1 specialization does not improve the usual Vinh scale. It therefore supplies no better exponent for this argument.

4. Hunter–Pohoata–Verstraete–Zhang, [*Large point-line matchings and small Nikodym sets*, arXiv:2601.19879](https://arxiv.org/pdf/2601.19879), Definition 1.1 and Theorem 1.2, PDF p. 3. Its induced matching has one designated point on each line, absent from all other selected lines. Our model retains nearly p points per color line and permits completed-line intersections when incidences are omitted. The paper's new constructions do not give the needed lower bound on omissions. This is a distinct incidence object, despite the suggestive terminology.

5. Iosevich–Rudnev–Zhai, [*Areas of triangles and Beck's theorem in planes over finite fields*, arXiv:1205.0107](https://arxiv.org/abs/1205.0107), has its strong pinned conclusion for sets of size at least 64p log_2 p. This also misses the palette-size regime.

## Defensible novelty statement

The exact affine-color average-defect formulation was not identified in the inspected primary sources. Historical priority is not established. The honest description is: a locally derived and independently audited application combining Stevens–de Zeeuw's published incidence estimate with Solymosi's published group-table theorem. No later applicable theorem improving its exponent was verified in this targeted search; this is not a certified best-published claim.

The proof is useful because it reaches polynomially growing average omissions, while keeping actual retained support in the argument. Its remaining limitation is substantial: average omission o(p^(4/7)) is much stronger than merely a positive retained fraction, or even arbitrary o(p) omission.

## Final quantitative formulation

After the initial source audit, the proof was strengthened to

    m <= C p(D+1)^(7/11) + 8D + C p^2 exp[-c(log p)^(1/12)].

This version prunes colors missing at least p/8 incidences, then uses
the robust progression exclusion and the previously checked Roth
estimate (Schildkraut, [Theorem 11.4](https://arxiv.org/html/2512.15125v1#S11.SS2)).
Thus the quantitative route uses Stevens–de Zeeuw plus Roth; the
qualitative alternative uses Stevens–de Zeeuw plus Solymosi. Both give
the same average-defect threshold. The additional deduction has
independent mathematical audits, without an established priority claim.
