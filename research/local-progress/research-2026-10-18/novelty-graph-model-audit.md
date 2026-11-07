# Novelty audit through graph, group-table, and incidence models

18 October 2026. This is a bounded literature and reduction audit of the [quadratic coset-palette result](quadratic-coset-palette-extension.md). It is not a certificate of historical priority.

## Assessment

No direct consequence of the group-table, quasigroup-completion, or elementary incidence results checked below was found. Several tempting reductions fail for explicit reasons. This is useful evidence about the proof's scope, but it is not evidence that every possible prior derivation has been excluded.

The defensible description is **a specialized application of established algebraic-expansion machinery, with a concrete configuration and root/coset transfer**. The analytic method is inherited from Tao. The exponent $63/32$ is obtained from that method's error exponent, rather than from a new general expansion estimate. The potentially original content is the particular rational configuration, its separate-cover/Kummer check, and the interpretation for this common-potential coloring family. Whether that specialization has appeared before remains unverified.

If written for external evaluation, this merits a concise technical note or a worked application, with the exact restricted model in the title and abstract. It should not be described as solving Erdős #810, as a new general anti-Ramsey theorem, or as a new algebraic-expansion method. An expert's comparison with the rational-expansion literature would still be needed before claiming publication novelty.

## 1. Exact sum/product coordinates

The incidence model is

```math
y=ax+a^2,\qquad a\in A,\qquad ay\in H.
```

Put $b=-x-a$. Then

```math
x=-(a+b),\qquad y=-ab,\qquad ay=-a^2b.
```

Thus the graph is the image of the directed root-pair set

```math
\{(a,b):a\in A,\ -a^2b\in H\}
```

under the sum/product map $(a,b)\mapsto(-(a+b),-ab)$, with color $a$. Swapping the roots leaves the two graph endpoints unchanged and changes the potential to $-ab^2$. Consequently simplicity is exactly the exclusion of simultaneous selected orientations at distinct roots.

This is a genuine sum/product model, but the classical bounds on the cardinalities of sumsets and product sets do not themselves count the required repeated-color rectangle. They control the sizes of endpoint images, whereas this problem imposes a compatibility condition on four specific incidences. No theorem giving the latter implication from an ordinary sum/product image bound was identified in this audit.

The model is not automatically sparse from propriety. For example, with full palette and $p\equiv1\pmod3$, any $H$ contained in one nontrivial cubic coset is proper: the two collision potentials have product $(ab)^3$, so they cannot both belong to that same nontrivial coset. Such $H$ can have positive density and be otherwise arbitrary.

## 2. Why the obvious group-table reparametrization is insufficient

The pairs $(a,y)$ satisfy the genuine multiplication relation $h=ay$. This produces triples $(a,y,h)$ in a multiplicative group table. However, the original row is

```math
x=y/a-a.
```

Replacing $(a,x,y)$ by $(a,y,h)$ removes that coordinate. A rectangle in the $(a,y)$ table need not be a rectangle in the original $(x,y)$ graph, and equal product labels need not be repeated original colors. Thus the replacement is not a vertexwise relabeling of the original colored graph.

This matters for the exact primary results. Solymosi's [*The (7,4)-conjecture in finite groups*](https://arxiv.org/pdf/1309.0133), Theorem 5, printed p.4, forces a rectangle with equal diagonal products in a dense subset of a group table. Its hypotheses and conclusion refer to those product coordinates. The result does not assert preservation under a map that combines a color with an endpoint. The later [group theorem of Nenadov–Sudakov–Tyomkyn](https://arxiv.org/pdf/1902.07614), Theorem 1.3, and [Long's group-table theorem](https://arxiv.org/pdf/1902.07693) likewise require actual group multiplication triples. No exact representation of the present three original coordinates by such triples was obtained.

There is also a concrete warning from the equal-cross configuration itself. Its three potentials obey

```math
k=\frac{uv(u+v)}{u^2+v^2}.
```

Writing $q=v/u$, the additional geometric-progression condition $k^2=uv$ is equivalent, off the denominators, to

```math
(q-1)^2(q^2+q+1)=0.
```

The first factor gives the repeated-input degeneracy; the second makes the required nonzero cube root vanish. Therefore the nondegenerate equal-cross configurations are not simply the three-term multiplicative progressions supplied by the elementary group-table rectangle argument. This does not rule out a different reduction, but it rules out that particular identification.

## 3. The natural affine-group completion is too large

Write $S=\{\sigma_a:a\in A\}$ with $\sigma_a(x)=ax+a^2$. For $a/b=\rho$,

```math
\sigma_a\sigma_b^{-1}(x)=\rho x+\rho(\rho-1)b^2.
```

Every nonidentity quotient has at most two ordered representations $(a,b)$: its slope fixes $\rho\ne1$, and its intercept fixes $b^2$. Hence

```math
|SS^{-1}|\ge1+\frac{|A|(|A|-1)}2.
```

For a palette coset $A=tC$ of bounded index, this is $\Omega(p^2)$, rather than $O(p)$. Thus the previously available small-difference-set criterion does not cover this natural completion.

The generated affine group is also large. Two maps commute only if

```math
(a-b)(a+b-ab)=0.
```

For fixed $a$, there is at most one distinct commuting parameter $b$. A palette with at least three elements therefore contains a noncommuting pair. Their commutator is a nonzero translation. Over the prime field its powers generate all $p$ translations. The slope group contains all ratios from $A/A=C$, so the generated group has at least $p|C|$ elements. It has quadratic order for bounded index.

These calculations rule out direct use of a small-group theorem in the **natural affine representation**. They do not prove that an arbitrary masked finite graph has no unrelated representation in another group.

## 4. A local obstruction to an algebraic group isotope

Consider the completed incidence surface as the function

```math
f(a,y)=y/a-a.
```

Over characteristic zero, on a nonsingular open set where the relevant derivatives are nonzero,

```math
\frac{f_a}{f_y}=-\frac{a^2+y}{a},\qquad
\partial_a\partial_y\log\!\left(\frac{f_a}{f_y}\right)
=-\frac{2a}{(a^2+y)^2}\ne0.
```

If separate local changes of the three coordinates made this an additive group table, one would have $f(a,y)=\phi(g(a)+h(y))$. Then $f_a/f_y=g'(a)/h'(y)$, whose logarithmic mixed derivative is zero. For a multiplicative table $\phi(g(a)h(y))$, the same ratio is $(g'/g)/(h'/h)$ and again has zero mixed derivative. The nonzero calculation therefore excludes both such local forms.

The same necessary separation condition follows from invariant differentials for a local one-dimensional algebraic group law in characteristic zero. This provides a precise obstruction to a natural algebraic group-table isotope of the completed relation. It does **not** exclude arbitrary field-specific permutations of a finite masked graph, higher-dimensional group embeddings, or other nonlocal encodings. No such stronger claim is intended.

## 5. Partial Latin squares and the orientation of the forbidden configuration

A proper bipartite coloring gives a linear tripartite hypergraph on color, row, and column vertices. Its non-rainbow four-cycle has part sizes $(3,2,2)$, with the size-three part being the colors. Swapping the color part with an endpoint part changes which configuration is forbidden. This is not a harmless symmetry of the B-coloring condition.

For example, an alternating four-edge path has no four-cycle and is therefore B-colored. After interchanging one endpoint part with the two colors in its incidence triples, the same four triples can form a non-rainbow four-cycle. Thus a parastrophe requires a new, model-specific preservation proof.

The primary group paper of Nenadov–Sudakov–Tyomkyn, printed p.2, recalls that partial Latin squares embed into Latin squares of twice the order. That produces a quasigroup, not a group. Their group theorem cannot be invoked merely from this completion fact. Moreover, the original graph's B condition alone does not forbid every possible four-triple configuration on seven vertices.

## 6. What elementary incidence theory does and does not give

The palette lines are $\ell_a:y=ax+a^2$. Their dual points $(a,a^2)$ lie on a parabola. The selected graph edges are points in the affine plane, with one selected color-line incidence per point. A point lies on at most two palette lines in the completed family, since its color equation is quadratic.

Vinh's [point-line theorem](https://arxiv.org/pdf/0711.4427), Theorem 3, gives

```math
I(P,\mathcal L)\le\frac{|P||\mathcal L|}{p}
+\sqrt{p|P||\mathcal L|}.
```

Taking the $m$ selected edge-points and $d$ palette lines gives $m\le I(P,\mathcal L)$. For $d\asymp p$ bounded away from $p$, the resulting inequality allows $m\asymp p^2$; for the full palette it is still weaker. The ordinary point-line estimate alone therefore gives no nonconstant density saving in this substitution. The finite incidence graph is itself a different graph from the original row-column graph.

This calculation does not preclude a more elaborate incidence reduction or a stronger theorem. It only documents why the immediately applicable classical estimate is not already the asserted result. The same caution applies to invoking a finite-field sum/product theorem solely because the endpoint coordinates are a sum and a product.

## 7. Where the actual proof sits relative to prior theory

The substantive primary method is Tao's [*Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/pdf/1211.2894). The present counting proof uses his definable regularity and finite-witness machinery and adapts the proof of the rational-expansion theorem to a fixed root-existence predicate. The accompanying local audits correctly label this as an extension/application of that proof, not a verbatim instance of the unmodified theorem statement.

The following concrete work remains necessary in the specialization: derive the repeated-color configuration; verify the rational map's grid dominance and separate-cover behavior; preserve the Kummer root condition; force all three colors into one palette coset; and control the number of configurations destroyed by each omitted incidence. These are not supplied merely by mentioning a group-table, sum/product, or Latin-square theorem.

Targeted searches included the exact affine family, the oriented sum/product form, the rational function $uv(u+v)/(u^2+v^2)$, group versions of Brown–Erdős–Sós, and algebraic/Latin-square rainbow-four-cycle results. No precise prior theorem with this conclusion and these hypotheses was identified. Search coverage is finite, and an unlocated paper or an expert's standard corollary may still subsume it.

The appropriate external claim is therefore: **an audited candidate corollary for a structured family, whose historical novelty and publication value remain to be checked**. The explicit failure of the simplest reductions supports keeping the calculation, but does not justify elevating it into a major advance on the unrestricted problem.
