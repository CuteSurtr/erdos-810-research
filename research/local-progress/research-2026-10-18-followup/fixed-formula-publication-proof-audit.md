# Publication audit: either one fixed-formula side

18 October 2026. This is a fresh adversarial audit of the written proof, not a search for a further theorem, a formal certificate, or a historical-priority assessment.

Audited inputs:

- [Finite-cover palette descent](finite-cover-palette-descent.md).
- [Fixed-formula potential supports](definable-potential-supports.md).
- [Earlier foundational-chain audit](foundational-chain-adversarial-audit.md), read as a list of claims to recheck rather than as evidence that those claims hold.
- The public `quadratic-coset-palettes.md` at standalone `origin/main`, commit `faea2d0a7e3666821d09a3c0210324645707286d`.
- The explicit restrictions in [dense-palette.md](dense-palette.md), equation (5).

The analytic part was also checked separately by a second agent against Tao's primary text. No builds, installations, or publication actions were performed.

## Verdict and required wording clarification

**No fatal proof gap was found.** The fixed-formula palette theorem and its fixed-formula support counterpart survive this audit. The robust statements must retain a positive density hypothesis on the designated definable core. The complete, exact-side statement does not need a separately specified density hypothesis.

One sentence should be clarified before publication. In `definable-potential-supports.md`, the sentence introducing lower bound (2) should read:

> Under the dense-core hypothesis $|H_0|\ge\delta p$, the proof gives constants $c,C>0$, depending only on $\varphi,\delta$, and a lower count for configurations whose three colors lie in $A$ and whose three potentials lie in $H_0$.

Without that qualification, the standalone lower bound is false for an empty or bounded support and a large arbitrary palette. The preceding robust paragraph already supplies the intended hypothesis, so this is a scoping clarification rather than a failure of the final theorem. The analogous palette lower count also requires its stated dense definable core. Small exact definable sides are treated separately.

## Publication-ready statements

Fix a formula $\varphi(x;\mathbf t)$ in the language of rings, with a fixed finite parameter tuple. For each prime $p$ and parameter choice $\mathbf t\in\mathbb F_p^{|\mathbf t|}$ put

```math
S_\varphi(\mathbf t)=
\{x\in\mathbb F_p^\times:\mathbb F_p\models\varphi(x;\mathbf t)\}.
```

For arbitrary $A\subseteq\mathbb F_p^\times$ and $H\subseteq\mathbb F_p$, let $I\subseteq A\times H$ be the retained incidences. An incidence $(a,h)$ represents an edge of color $a$ between the two distinct vertex classes $\mathbb F_p,\mathbb F_p$, with endpoints

```math
\left(h/a^2-a,\ h/a\right).
```

Assume these retained incidences form a **simple** properly edge-colored graph in which every four-cycle is rainbow, and let $m=|I|$ be its number of edges. Simplicity here includes the requirement that two retained incidences do not represent the same uncolored edge.

**Exact complete-incidence theorem.** There are constants $C_\varphi,p_\varphi>0$, independent of all parameter values, such that $m\le C_\varphi p^{63/32}$ for every prime $p>p_\varphi$ when $I=A\times H$ and either

1. $A=S_\varphi(\mathbf t)$, with $H$ arbitrary; or
2. $H\setminus\{0\}=S_\varphi(\mathbf t)$, with $A$ arbitrary.

Potential zero can be included or excluded in the second alternative. It contributes at most $p-1$ edges. The other side need not be definable. No numerical lower density is assumed in this exact theorem.

**Robust dense-palette theorem.** Fix $\delta>0$ and a core $A_0=S_\varphi(\mathbf t)$ satisfying $|A_0|\ge\delta p$. The actual palette $A$, support $H$, and retained incidence set $I$ remain arbitrary subject to the graph assumptions above. Put

```math
d=|A_0\setminus A|,\qquad
R=|((A\cap A_0)\times H)\setminus I|.
```

Then, for sufficiently large $p$ depending only on $\varphi,\delta$,

```math
m\ll_{\varphi,\delta}
p^{63/32}+p^{4/3}(R+pd)^{1/3}.
```

**Robust dense-support theorem.** Instead take $H_0=S_\varphi(\mathbf t)$ satisfying $|H_0|\ge\delta p$, and put

```math
d=|H_0\setminus H|,\qquad
R=|(A\times(H\cap H_0))\setminus I|.
```

The same bound holds. In both robust statements $m$ counts all retained edges, including those with colors or potentials outside the designated core. Consequently $d=o(p)$ and $R=o(p^2)$ imply $m=o(p^2)$ for a fixed formula and fixed $\delta$.

Neither theorem permits the number of parameters, degrees, or formula length to grow with $p$. Neither is a statement about two arbitrary dense sets, or a reduction from arbitrary B-colorings to this incidence model.

## 1. Finite witness extraction and arithmetic field crossing

The finite-witness representation is the actual statement of [Tao's Theorem 25](https://arxiv.org/html/1211.2894#S4): it is not an assumed elimination of all quantifiers by a single polynomial image. For an infinite unary definable set, invert the finitely many nonzero generic leading coefficients in its simultaneous polynomial root witnesses. A nonzero witness polynomial independent of the witness variable would force a finite set and cannot remain in this case. Monicity makes the simultaneous witness variety finite over an open line.

Its infinitely many rational points cannot all lie on geometric curve components that fail to descend: a rational point on such a component lies in its intersection with a distinct constant-field conjugate, and that intersection is finite. Hence some geometric component descends and dominates the line. Normalization and restriction to a suitable open produce the required regular witness curve. Regularity is over the constant field, not over the one-variable rational function field. Projective completion does not preserve image containment at every added point; the later rational-point argument must, and does, return to the designated open.

The field-crossing lemma was checked directly, including domination. Write $K=k(a)$, let $L/K$ be the arithmetic Galois closure of $k(V)/K$, let $k_e$ be its full constant field, and set

```math
\Gamma=\operatorname{Gal}(L/K),\quad
G=\operatorname{Gal}(L/k_e(a)),\quad
H=\operatorname{Gal}(L/k(V)).
```

The equality $k(V)\cap k_e=k$ makes $H\to\operatorname{Gal}(k_e/k)$ surjective. If $\sigma\in H$ lifts a generator of that cyclic quotient and has order $M$, then $e\mid M$. In $L'=Lk_M$, the automorphism $(\sigma,\mathrm{Frob})$ has order $M$. Its fixed field $E$ has constants exactly $k$, contains $k(V)$, and has degree $|G|$ over $K$.

Moreover, its fixing cyclic subgroup intersects $\operatorname{Gal}(L'/k_M(a))=G$ trivially. The Galois correspondence gives $Ek_M=L'$, so $E$ becomes the geometric Galois closure after extending constants. Thus the descended curve is geometrically integral, geometrically Galois over the base line, and dominates the original witness over $k$. This is sufficient for the required contained rational-point image. Taking fixed points in $L$ without first adjoining $k_M$ would not suffice when $M>e$; the proof does not make that error.

This also works over the characteristic-zero pseudofinite field using its cyclic constant extensions. The construction is consistent with [Dèbes–Legrand, §3.1 and Lemma 3.1](https://arxiv.org/pdf/1106.6154), but the domination assertion follows from the explicit fixed-field inclusion above. Bounded degree, branch complexity, and genus follow from the original standard finite witness complexity. No uniform claim for unbounded wild covers is needed.

## 2. Kummer quotient and all residual inertia lifts

Over algebraically closed constants, let $N$ be the normal closure in the geometric group $G$ of all inertia groups above finite nonzero base values. Arithmetic descent preserves this subgroup because it preserves the set of those branch values. Hence the quotient descends even though the original cover need not be Galois over its original constant field.

The quotient is connected and unramified on $\mathbb G_m$. In characteristic zero it is a cyclic power cover. Its unique points above zero and infinity descend separately, giving two rational points on its genus-zero source. A coordinate with those zero and pole divisors gives

```math
a=\tau w^n
```

over the original field. This argument does not require roots of unity in that field or $n\mid p-1$.

For a nonzero base branch value, the quotient is unramified. Therefore inertia of the residual cover above every lift of that value equals the corresponding original inertia subgroup. Taking **all** lifts includes every $G$-conjugate of every original finite-nonzero inertia subgroup. Their normal closure inside $N$ is $N$ itself, since those conjugates already generate $N$. This proves the residual normal-generation claim. The weaker assertion obtained by selecting one lift per original value would be insufficient and is not used.

## 3. Separate-cover integrality and the root divisors

The public separate-cover proof survives inspection. The generic $K$-fiber is a geometrically integral conic. Every output value, including zero and infinity, has a multiplicity-one fiber divisor along which both inputs vary. The input-cover compositum is unramified at all extensions of that valuation, while the pulled-back output inertia retains its order. Its intersection with the output Galois cover therefore kills every output inertia subgroup. The remaining quotient would be an everywhere-unramified cover of $\mathbb P^1$, so it is trivial.

For the root step, $v=\omega u$ has $\operatorname{ord}G=1$, and all three potential coordinates vary there. Hence the separate potential covers are unramified at that divisor, preserving valuation one. Eisenstein proves irreducibility of a root of any positive degree, including composite degree.

In inverse-color coordinates, $t=\omega s$ has $\operatorname{ord}\kappa=-1$ and all three inverse colors vary. Apply the same argument to the reciprocal-root equation. The divisors may lie outside the final admissible configuration open: they are valuations proving function-field irreducibility, so that exclusion is harmless.

All fiber products are understood on suitable dense opens with finite flat coordinate maps. This removes any possible vertical components before invoking a geometrically integral surface in the counting argument.

## 4. An explicit unramified tower for each residual-cover step

This is the most compressed part of the research notes. The following expands its justification without adding a hypothesis.

For the palette proof fix $i\in\{a,b,c\}$ and use $K_i=\overline F(w_i,q)$. The identity

```math
a=\tau w_i^n/r_i(q),\qquad (r_a,r_b,r_c)=(1,r,qr)
```

makes all three potential coordinates rational functions in $K_i$. At the generic divisor $w_i=\theta\ne0$, each has a nonconstant residue by the nine explicitly calculated restrictions. Its generic image therefore avoids the finite branch locus of every separate potential curve cover. Those pulled-back finite covers are étale over the corresponding valuation ring, and every field component of their compositum is unramified.

There is no unexplained additional root extension over this compositum: the original root $w$ is recovered as $w_i$, $w_i y/z$, or $w_i x/z$ according as $i=a,b,c$. Thus the entire field $M_0$ is obtained from that unramified tower. This establishes unramifiedness at **every** valuation above each indicated divisor, rather than at one selected extension.

For the support proof use $K_i=\overline F(\eta_i,q)$. First adjoin

```math
a^3=\lambda\eta_i^n/\psi_i(q).
```

At $\eta_i=\theta\ne0$ its radicand is a unit and characteristic is zero, so every component of this cubic extension is unramified. The displayed nine color-cubed/potential ratios have nonzero orders at infinity, respectively

```math
\begin{pmatrix}2&1&2\\-1&-2&-1\\2&1&2\end{pmatrix}.
```

Thus all inverse colors have nonconstant residue on every resulting branch. Adjoining their separate witness curves is again unramified. The original root $\xi$ is recovered as $\eta_k$, $\eta_u z/y$, or $\eta_v z/x$ according to the selected index. Hence this also accounts for the whole of $M_0$.

In either proof the other two quotient coordinates have nonconstant residues, because their powers are the other nonconstant colors or potentials. Previously adjoined residual covers are consequently unramified at the selected divisor. Taking a Galois closure remains unramified: locally these are finite étale extensions, which remain so under conjugation and compositum.

Finally, intersect that Galois closure with the selected residual Galois cover over $K_i$. The intersection is a Galois intermediate field. Since it is unramified at every finite nonzero quotient-coordinate value, its corresponding normal subgroup contains all the residual inertia groups. Section 2 shows that their normal closure is the entire residual group. The intersection is therefore $K_i$, proving linear disjointness and preserving full degree and integrality. Repeating for the three coordinates completes the geometry. No regularity of $M_0$ over the one-variable field $\overline F(w_i)$ or $\overline F(\eta_i)$ is asserted or needed.

## 5. Compatible slices and positive cell coefficients

The power-coset restriction is compatible with the geometry. In the palette case restrict all three potential coordinates to the same $\lambda(F^\times)^n$; in the support case restrict all three inverse colors to the same $\mu(F^\times)^n$. The largest slice loses a factor at most $n$, since the index of the power subgroup is at most $n$.

Append the corresponding root equations before selecting each witness component. Each cell's rational points admit those roots, so the same finite-witness extraction still supplies a geometrically integral curve with the designated root function. The displayed quotient-coordinate formulas are then actual rational maps over $F$, not an inference from residue membership alone. The additional root equation and residual-cover argument above produce a geometrically integral surface over $F$ for every triple of full-dimensional cells.

Lang–Weil gives quadratic-order rational points on that surface, and its projection to the two input coordinates has bounded fibers. Thus the cell's restricted relation has positive density. A zero regularity coefficient, which would give only $O(p^{7/4})$ points in the full cell pair, is impossible. This establishes the needed positivity in every cell; total unrestricted mass is never substituted for the restricted mass.

The analytic use of [Tao's Corollary 37 and the proofs of Theorems 38 and 40](https://arxiv.org/html/1211.2894#S6) was rechecked. The restricted grid fiber count is bounded and definable outside a proper exceptional locus. Product regularity gives error $O(p^{15/4})$; two Cauchy–Schwarz inequalities give $O(p^{15/16}\sqrt{|X||Y|})$. Exceptional grids contribute $O(p^3)$. The remaining input-regularity error is absorbed when $|X||Y|\ge p^{15/8}$; below that threshold the claimed lower bound is vacuous after enlarging its error constant. These steps retain the additional predicate throughout.

## 6. Uniformity and transfer to all graph edges

Fixed-formula parameters may vary freely. If uniform constants failed, choose a violating sequence with lower constants $1/j$ and error constants $j$, then take a characteristic-zero ultraproduct. The parameter sequence becomes one tuple in that field. The finite witnesses, covers, partitions, and their finitely many positive cell densities have standard finite complexity and standard constants. Those constants contradict the chosen sequence. Arbitrary palettes and supports enter as internal subsets and need no definability themselves.

For the exact theorem, a bounded definable side gives $O(p)$ edges directly. A hypothetical sequence violating the uniform $p^{63/32}$ bound forces that side's cardinality to tend to infinity. Its fixed-formula ultraproduct is therefore infinite, so the witness extraction and positive-density argument apply. This explains why an explicit numerical density is dispensable for the exact theorem but cannot simply be omitted from the robust dense-core statement.

Writing $h=|H\setminus\{0\}|$ for the palette argument and $a_*=|A|$ for the support argument, the established configuration bounds have the forms

```math
N\ge c h^3/p-Cp^{15/16}h,
\qquad
N\ge c a_*^3/p-Cp^{15/16}a_*.
```

They count actual configurations, not extra choices of cover witnesses. In the palette case a missing core color destroys at most $3p$ configurations; in the support case a missing core potential destroys at most $9p$. In either case an omitted actual incidence destroys at most sixteen. All these bounds concern the same actual configurations used in the lower counts, so the deletion upper bounds are $3pd+16R$ and $9pd+16R$ respectively.

Balancing the lower main term against its analytic error gives a bound $O(p^{31/32})$ on $h$ or $a_*$. Otherwise the deletion term gives $O(p^{1/3}(R+pd)^{1/3})$. The inequalities $m\le p(h+1)$ and $m\le p a_*$ then give exactly

```math
m\ll p^{63/32}+p^{4/3}(R+pd)^{1/3}.
```

This also confirms that arbitrary extra colors or extra support values are included in the stated total edge bound. The result is ready to be stated with the hypotheses above and the lower-count scoping clarification. Historical novelty and formal verification remain separate questions.

## 7. Review of the assembled public draft

The actual title, abstract, Theorem 5, and Sections 6.1–6.5 in `/private/tmp/erdos-810-fixed-formula/quadratic-coset-palettes.md` were subsequently reviewed. The draft correctly scopes the configuration lower bounds to dense cores or infinite definable ultraproduct sets, distinguishes the complete exact theorem from the robust versions, and includes all retained edges in the conclusion. No fatal proof gap or inaccurate theorem scope was found.

Three precision improvements were reported to the author before publication:

1. In the abstract counting principle, make the fixed ring formula and finite parameter tuple explicit. Uniform finite-prime constants follow when the stated positivity hypothesis holds in every characteristic-zero ultraproduct of the allowed data. For the application, Section 6.5 supplies uniformity in the original formula even if auxiliary witness covers are first chosen inside a hypothetical violating ultraproduct; no independently proved global bound for every possible auxiliary choice should be implied.
2. State the finite dominant witness maps and rational-image containment on suitable dense opens. This is the geometric setting actually used throughout.
3. Include the recovery formulas for $w$ and $\xi$ from Section 4 of this audit, making explicit that the asserted unramified towers account for their entire surface fields.

These suggestions concern precision and explanation, not a change to the theorem. The independent analytic check also confirms the general restricted-counting principle for a fixed definable predicate, a fixed or bounded root exponent, and ground-field-defined witness surfaces giving positive density for every triple of full-dimensional definable cells. Arbitrary final input/output subsets need not be definable.
