# Quadratic coset palettes and the 2026 perfect-colorings paper

18 October 2026. Comparison with the complete publisher HTML, including the numbered results, proofs, appendix, and 34 references, of A. Gyárfás, G. N. Sárközy, and A. Z. Wagner, *Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*, Discrete Mathematics 349(6), 115005. [Published article](https://doi.org/10.1016/j.disc.2026.115005).

## Conclusion

The quadratic-coset theorem is not stated in this paper, and no direct implication from its results or proofs was found. The earlier full-text access gap is resolved. This supports a potentially new specialized application of established algebraic expansion, not a claim of established historical priority or a general advance solving Erdős #810.

## Relevant published results

Theorem 2.3 treats additive shifted perfect matchings through modular three-term progressions. Theorem 2.7 proves superlinearity for fixed-fraction translation-invariant **perfect** B-colorings. Its condition selects a positive fraction of vertices and, at each, a positive fraction of colors; every relevant pair must satisfy the specified five-edge path-closing condition. It is not merely a positive density of successful paths.

In its proof, perfectness provides a second edge of a given color when defining the auxiliary matchings in Claim 3.2, and another cross-color edge when using Lemma 3.1, the induced-matching lemma. These existence steps are not automatic for partial matchings.

The remaining results concern linear degree/order bounds, constructions, small-degree values, or rigidity of colorings on shifted graphs. Section 4 leaves general perfect-coloring superlinearity open. No theorem on quadratic coset palettes, arbitrary common potentials, or omission deficits occurs.

## A structural distinction, with proof

Our theorem allows arbitrary $`H\subseteq\mathbb F_p`$ and colors containing a fixed-index coset $`tC`$. In the complete coset subsystem, color $`a`$ has endpoint sets

```math
Y_a=H/a,\qquad X_a=H/a^2-a.
```

Suppose $`\varnothing\ne H\ne\mathbb F_p`$ and $`|C|\ge2`$. These color classes cannot all be perfect matchings on a common pair of vertex sets, even after independent common relabelings of the two vertex classes.

Indeed, equality of $`Y_a`$ for all $`a\in tC`$, compared with $`a=t`$, implies $`H=cH`$ for every $`c\in C`$. Thus $`H/a^2=H/t^2`$ throughout the coset. Write $`S=H/t^2`$. Equality of $`X_a=S-a`$ and $`X_b=S-b`$ for distinct colors gives invariance of $`S`$ under the nonzero translation $`a-b`$. In the additive group of a prime field, any nonzero element generates the group. Hence $`S`$, and therefore $`H`$, is empty or the whole field, a contradiction. Relabeling preserves equality or inequality of endpoint sets.

This already blocks direct application in the zero-deficit case. It does not rule out an additional construction that completes or lifts the partial matchings while preserving the needed density and forbidden cycles. Such a construction would require a proof; the paper does not provide one for this model.

There is also a concrete obstruction to copying the auxiliary-matching construction. Choose the natural base bijection $`f_\beta(x)=\beta x+\beta^2`$. A color-$`b`$ incidence at row $`x`$ has potential $`h=b^2x+b^3`$. Following the base bijection backwards from its column gives row $`x'=h/(b\beta)-\beta`$. The next color-$`b`$ edge would require

```math
h'=b^2x'+b^3=(b/\beta)h+b^2(b-\beta)\in H.
```

Membership $`h\in H`$ supplies no such invariance for arbitrary $`H`$. This checks the natural base choice; it does not exclude every other choice or additional construction.

## Comparison of methods and claims

Our conclusion is

```math
m\ll_L p^{63/32}+p^{4/3}(R+pD)^{1/3},
```

where $`D`$ counts missing colors in the chosen coset and $`R`$ counts omitted eligible incidences there. The common potential set remains arbitrary. Our proof obtains a three-color rectangle using a root-restricted rational-map count, followed by bounded deletion multiplicities. The algebraic regularity machinery and exponent originate in Tao's work.

Neither a fixed-point obstruction to shifted affine permutations nor a commutator calculation would, by itself, exclude the paper's broader definition of translation invariance. The relevant comparison is its actual path-closing hypothesis and the incidence-existence steps in its proof.

Theorem 2.3 also supplies Behrend-type examples with $`n^{2-o(1)}`$ edges. Therefore the paper's entire shifted class cannot have a fixed power saving. Our bound concerns a different restricted family; it is not a quantitative strengthening of their theorem on its original domain.

The appropriate status is: **distinct from the stated results and direct arguments of this 2026 paper; potentially new as a concrete application; broader priority unverified.** The old caveat that the full 2026 paper had not been inspected is now obsolete. The wider novelty caveat remains necessary.
