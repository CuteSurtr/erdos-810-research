# Final adversarial audit of cube-restricted counting and dilation transfer

18 October 2026. Scope: the complete arguments in [the counting audit](partial-rational-expansion-independent-audit.md) and [the dilation transfer](palette-dilation-extension.md), read as potential false proofs. This audit does not assess publication priority or establish the unrestricted Erdős conjecture.

## Verdict

**The argument passes, with one minor finite-morphism wording repair.** No substantive gap was found in the finite-witness selection, field-of-definition argument, uniform constants for shrinking sets, nondegeneracy exclusions, root multiplicities, or dilation transfer.

The wording repair is precise. Removing base points where a witness polynomial vanishes identically in its witness variable ensures bounded finite fibres, but does not by itself make the morphism finite: $xt-1=0\to\mathbb A^1_x$ is a counterexample. Also remove the finitely many zeros of its generic leading coefficient, and divide by that coefficient to obtain a monic witness polynomial. The simultaneous witness variety is then finite over the remaining open curve. Equivalently, retain bounded fibres and generically finite maps and normalize and shrink later. Either version supports the proof. Redundant polynomials identically zero on the whole curve should first be discarded.

## Source and geometric checks

Tao's [primary paper](https://arxiv.org/pdf/1211.2894), Theorem 25, printed p.20, really supplies finite intersections of one-witness polynomial-existence conditions, rather than merely arbitrary Boolean combinations. Lemma 26, printed pp.20–21, counts the top-dimensional geometrically irreducible components defined over the field. Lemma 23 and Corollary 37 supply the two-variable and product-test regularity statements used here. The cube-restricted expansion is an extension of these proofs, not a verbatim theorem from that paper.

After the finite-morphism repair, a definable curve cell containing $\gg q$ points has a simultaneous witness variety with $\gg q$ rational points, bounded degree, and dimension one. A geometric component not defined over the field has its rational points in its intersection with a distinct conjugate component, a bounded zero-dimensional set. Thus at least one one-dimensional geometric component is defined over the field. Its rational image lies inside the original cell; surjectivity onto the whole cell is unnecessary. Reduction, normalization, and restriction to a dense open preserve all required conclusions.

The selected three covers are defined over the field and geometrically irreducible. The separate-cover calculation is made after base extension to the algebraic closure. Its conclusion therefore says that the pullback surface is geometrically integral, not merely that one unspecified component is integral. Since the surface's equations and covers are defined over the original field, Lang–Weil applies there. The divisor $y=\omega x$ used to detect the noncube need not itself be defined over the original field; checking a valuation after algebraic closure is exactly what proves geometric irreducibility of the Kummer extension.

## Counting and uniformity checks

The four-grid map is dominant between irreducible four-dimensional varieties and generically finite. A proper exceptional output locus has a proper inverse image, of dimension at most three. Its point count is consequently $O(q^3)$, including fibres where the map is not finite. Off that locus, the existence-indicator grid multiplicity is bounded and definable; no irreducibility of a fourfold Kummer cover is assumed.

The two Cauchy–Schwarz steps are valid for signed real test functions. The unrestricted grid expression is a sum of squares, and the four factors retain the cube-existence predicate exactly. Refining the four output partitions to one common partition is harmless. Moving bounded zero-dimensional cells changes the sums by $O(q^3)$; it does not change the $q^{15/4}$ bound. The mean-zero duality step gives the stated $L^1$ error $O(q^{15/16}\sqrt{|X||Y|})$.

The quantitative positivity paragraph is essential and valid. The output partition depends on the fixed definable grid count, not on $X,Y,Z$. For each output cell, every pair of full-dimensional input regularity cells has positive standard density: a zero coefficient contradicts the three-cover Lang–Weil count. A minimum over finitely many such coefficients is a positive standard constant. This proves a lower bound independent of the density of $H$.

The simultaneous ultraproduct contradiction for $c,C$ is sound. A sequence violating the inequality with $c=1/n$ and $C=n$ contradicts the positive standard $c_*$ and finite standard $C_*$ produced in its ultraproduct. Thus the bound does not silently become density-dependent when $H$ shrinks with $p$. The small-product range is legitimately vacuous because its proposed main term is bounded by the stated error. This reasoning gives existence of absolute constants, not numerical effectiveness.

## Nondegeneracy and multiplicities

Taking disjoint input subsets of $H$ ensures $q=y/x\ne1$. Nonzero inputs exclude $q=0$; the domain of $G$ excludes $q=-1$; the rational domain excludes $q^2+1=0$; and requiring $G\ne0$ excludes $q^2+q+1=0$. These are precisely the exclusions used by the combinatorial transfer. They give three distinct nonzero colors and four distinct edges. Any remaining bounded exceptional sets can be absorbed into the counting error; no positive-density ratio set is discarded.

The four fixed-incidence equations have degree at most four after clearing denominators. In the third equation the prescribed left side is nonzero, so the degree-four denominator term cannot cancel identically. In the other cases the numerator has strictly larger degree. Once the incidence role and $q$ are fixed, the repeated color and every potential are determined. The bound of sixteen configurations per incidence therefore counts **all** cube roots correctly. A fixed omitted color has at most three roles and at most $p$ choices per role, giving $3p$.

The counting lower bound can count a single cube root per admitted pair to establish a lower bound, but the dilation universe must contain all roots. The dilation note explicitly uses all triples $(x,y,a)$ and does not select a non-equivariant root section.

## Dilation and final scope

The transformation $(a,h)\mapsto(ta,t^3h)$ is an invertible action on the complete configuration universe, including roots and all nondegeneracy conditions. Its vertex relabeling is $(r,c)\mapsto(tr,t^2c)$. At least a $\gamma$ fraction of group elements simultaneously move all three colors into the palette by the three-set union bound.

For a fixed dilation, a failed potential belongs to $H\setminus t^{-3}H$. Summing the incidence multiplicity bound over possible colors gives at most $16p$ spoiled configurations per such potential. Each missing eligible incidence destroys at most sixteen more configurations, and injectivity of the dilation preserves this bound. Therefore

```math
\gamma N(H)\le16R+16pJ_U(H)
```

is valid. Combining it with the quantitative lower count gives the claimed $p^{63/32}$ and defect terms. The first term is independent of $\gamma$: when $R=J_U(H)=0$, any positive margin forces $N(H)=0$, so a margin varying with $p$ causes no problem. For the qualitative approximate-invariance statement, a fixed positive margin is correctly required.

Deleting zero potential removes at most $p-1$ actual incidences, does not increase the omission count, and does not alter the dilation defect. Restoring these edges is absorbed by the first term. Properness and the rainbow-four-cycle condition are imposed only on the actual selected graph; none of the arguments assumes the completed incidence system has those properties.

The resulting conclusion remains restricted to the written full/near-full palette or dilation-defect hypotheses. The arbitrary dense palette and arbitrary mask problem is not solved by this audit.
