# Adversarial audit of the finite-cover and restricted-counting chain

18 October 2026. This audit targets the dependencies shared by the fixed-formula extensions, rather than another special case. It checked the public `origin/main` technical note and [the complete definable-palette proof](finite-cover-palette-descent.md), and reread the cited source statements. No mathematical counterexample or missing essential hypothesis was found. One incorrect regularity phrase was corrected below. This is a written audit, not a formal certificate.

## Correction: regularity over the constant field

Section 1 of the definable-palette note formerly said that projective completion gives a “regular function-field extension $F(V)/F(a)$.” That is false for a nontrivial finite algebraic extension. The sentence now says that $F(V)/F(a)$ is finite separable and that $F(V)$ is regular **over $F$**.

The subsequent field-crossing proof already uses the latter, correct assertion: $F(V)\cap F_e=F$. No later step relies on regularity over $F(a)$. Thus this is a substantive terminology repair, not a gap in the field-crossing argument. It must not be confused with the genuinely regular transcendence-degree-one extension $\bar F(u,v)/\bar F(K(u,v))$ used in the separate-cover proof.

## 1. Attempted failure: arbitrary separate covers might disconnect the surface

The base argument does not infer disjointness merely from pairwise distinct branch loci. It fixes the rational surface field $L=\bar F(u,v)$ and compares two Galois extensions over exactly $L$: the compositum of the two input covers and the pulled-back output cover. The generic $K$-fiber is geometrically integral, so the output-cover group survives base change.

For each output value, including zero and infinity, there is a multiplicity-one fiber divisor on which both input coordinates vary. The input-cover compositum is unramified at **every** valuation above that divisor. The pulled-back output inertia retains its full order because a target uniformizer still has value one. Therefore the intersection kills all output inertia, whose normal closure is the full group by the absence of nontrivial unramified covers of the projective line. This is sufficient even for arbitrary finite input covers.

The extra root cover uses a different divisor, $v=\omega u$. It need not lie in the final admissible open set: it is a function-field valuation used to prove irreducibility before restricting to that open. Each separate coordinate varies there, and the radicand has valuation one. After the unramified base change its valuation remains one, so Eisenstein works for composite root degree too. This excludes the potential hidden assumption that “not a cube” would suffice for an arbitrary composite exponent.

## 2. Attempted failure: a definable set might have no regular witness image

The finite-witness extraction uses only a **contained** rational-point image, not equality with the whole definable set. Generic leading coefficients are inverted before claiming finiteness. After this restriction, simultaneous witness equations define a finite cover of an open line. An infinite set of rational points cannot be supported entirely on geometric components not defined over the field: each such component's rational points lie in its finite intersection with a distinct conjugate. One defined geometric curve component therefore suffices.

The actual source is [Tao's Theorem 25 and its cardinality statement](https://arxiv.org/html/1211.2894#S4). It also rules out an infinite unary definable set of intermediate order between bounded size and linear size in the characteristic-zero ultraproduct. The proof needs the fixed-formula restriction; it would fail if formula length or parameter count grew with the prime.

## 3. Attempted failure: geometric Galois closure might lose rational descent or domination

The arithmetic Galois closure generally has extra constants, so simply using it as a regular witness would be wrong. The written construction avoids that error.

With arithmetic group $\Gamma$, geometric group $G$, constants $F_e$, and witness stabilizer $H$, regularity over the constant field makes $H\to\operatorname{Gal}(F_e/F)$ surjective. Choose $\sigma\in H$ over Frobenius and let $M$ be its order. In the constant extension to $F_M$, the fixed field of $(\sigma,\operatorname{Frob})$ has constants exactly $F$, contains the original witness field, and has degree $|G|$. Its compositum with $F_M$ is the entire extended arithmetic closure, because the fixing cyclic group intersects $G$ trivially.

All three required properties therefore hold: regularity, geometric Galoisness, and domination of the original witness. Enlarging constants before taking the fixed field is essential when $M>e$. The construction is consistent with the primary [field-crossing reference](https://arxiv.org/pdf/1106.6154), but the note also gives the needed domination argument explicitly.

## 4. Attempted failure: the residual cover might retain an unnoticed power quotient

The quotient by the normal closure of inertia at finite nonzero color values is connected and unramified on the multiplicative group. In characteristic zero its geometric cover is a power map. The unique points above zero and infinity descend separately, so the quotient has a coordinate over the original field and equation $a=\tau w^n$; roots of unity need not lie in that field.

Residual inertia must be taken at **all** nonzero $w$-values. Those inertia groups include every original group-conjugate, hence generate the full residual group as a normal subgroup. Taking only one lift of each original branch value could leave a nontrivial quotient; the written proof explicitly avoids that shortcut.

The non-Galois nature of the cover over the original constant field is harmless here. The group and inertia calculations take place after algebraic closure, while the quotient and the displayed root functions descend. Calling the residual cover geometrically Galois, rather than necessarily Galois over the original field, is the correct formulation.

## 5. Attempted failure: sequential color covers might become entangled

For each selected color the comparison field is $\bar F(w_i,q)$, not merely $\bar F(w_i)$. The surface field is finite over this rational two-variable field. At $w_i=\theta\ne0$, all other relevant coordinate functions remain nonconstant in the residue field. Any finite extension of that residue field still contains the transcendental parameter $q$; it cannot turn those nonconstant rational functions into constants.

Each separate coordinate cover and each root equation is therefore unramified at all valuations over the divisor. The same is true after earlier residual covers are adjoined, and after taking their Galois closure. This last assertion requires unramifiedness at every extension of the valuation, which the proof supplies; unramifiedness at only one chosen branch would be insufficient.

The intersection with the selected residual cover is a Galois intermediate field of $L_i(q)/\bar F(w_i,q)$. Its subgroup is constant under the purely transcendental $q$-extension. Being unramified at all finite nonzero $w_i$-values, it must kill the inertia generators identified above. Thus the intersection is trivial. The explicit quotient roots ensure the geometric pullback also exists over the original field.

## 6. Attempted failure: restriction destroys the expansion theorem's positivity

It would be invalid to apply Tao's stated expansion conclusion directly after imposing a non-Cartesian predicate, or to retain the unrestricted identity that total output mass equals $|X||Y|$. The public note does neither.

The restricted four-grid count is a bounded definable function off a proper exceptional locus. Its finitely many level sets admit the product partitions in [Tao's Theorem 35 and Corollary 37](https://arxiv.org/html/1211.2894#S6). Two Cauchy–Schwarz steps preserve the predicate exactly. For the two-variable input partition, one may use Theorem 35 with two factors directly, avoiding any ambiguity in the printed shorthand of Lemma 23.

The decisive extra step is positivity in **every** full-dimensional input/output cell. Each cell supplies a finite witness cover. The complete pullback, including the restricted predicate's witnesses, is geometrically integral and defined over the field, so it has quadratic-order rational points. Every projection has bounded fibers; hence the projected cell count has positive density. A zero regularity coefficient is impossible. This step needs only one admissible surface, not geometric integrality of a fourfold root-cover grid.

The exponent bookkeeping is consistent: the four-output error is $O(q^{15/4})$, the fourth root gives $q^{15/16}\sqrt{|X||Y|}$, and the extra input-regularity error is absorbed above $|X||Y|=q^{15/8}$. Below that threshold the claimed lower bound is vacuous after increasing its error constant.

## 7. Attempted failure: varying parameters might defeat uniform constants

The contradiction argument chooses a single ultraproduct of a violating sequence, with all varying field parameters retained as elements of that field. For the fixed original formula, the witness equations, descended covers, partition sizes, and positive minimum densities produced there have standard finite complexity and standard constants. No explicit uniform finite-field construction of every cover is required beforehand.

Choosing violations with lower constant $1/j$ and error constant $j$ contradicts the positive standard lower constant and finite standard error constant produced in that same ultraproduct. The argument genuinely yields constants uniform over parameter values. It does not yield uniformity over increasing formulas, cover degrees, or root exponents; those remain outside the theorem.

## Audit outcome

The tested chain remains intact after correcting the constant-field regularity phrase. Its most delicate dependencies are the all-cell positivity argument and the arithmetic descent plus residual-inertia step; both have explicit proofs in the notes. The result remains a specialized written theorem depending on established algebraic regularity and covering theory. This audit does not establish historical novelty, a Lean verification, or a theorem for arbitrary dense palettes and supports simultaneously.
