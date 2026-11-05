# Independent audit of fixed-formula potential supports

18 October 2026. Audited source: [definable-potential-supports.md](definable-potential-supports.md). The new inverse-coordinate geometry, root construction, residual-cover independence, and deletion transfer pass. This audit accepts the previously audited separate-cover theorem and restricted-grid counting argument as stated inputs; it does not claim to have replaced those inputs with a formal certificate.

## 1. Coordinate identities

Starting from $b=ar$, $c=aqr$, $r=(q+1)/(q^2+1)$, the inverse coordinates satisfy

```math
s=\frac1{ar},\qquad t=\frac1{aqr},\qquad w=\frac1a,
\qquad \frac st=q.
```

Direct substitution gives $K(s,t)=w$. Also

```math
s^2+st+t^2=\frac{w^2(q^2+q+1)}{q^2r^2},
```

so $-1/[w(s^2+st+t^2)]=-a^3q^2r^2/(q^2+q+1)=k$. The identities $u=kt/w$ and $v=ks/w$ follow. Thus no new expansion map is being substituted: it is exactly the already treated $K$.

## 2. Root survives all three inverse-color covers

On $D:t=\omega s$ with $\omega^3=1$, $\omega\ne1$, one has $w=\omega^2s$. The three coordinates $s,t,w$ are nonconstant at the generic point of $D$, so arbitrary separate curve covers have no branch there. The factor $s^2+st+t^2$ has a simple zero and $w$ is a unit. Consequently $\kappa$ has valuation $-1$, and this valuation is unchanged after every separate cover.

The reciprocal equation $T^n-\lambda/\kappa$ is Eisenstein. This proves geometric irreducibility for every positive $n$, including composite $n$. The divisor need not be rational over the finite ground field: it is used over algebraically closed constants to prove geometric integrality, and all equations of the resulting cover remain defined over the original field.

The potential-root formulas are exact. From $s=\mu x^n$, $t=\mu y^n$, $w=\mu z^n$, and $k=\lambda\xi^n$, one gets

```math
u=\lambda(\xi y/z)^n,\qquad
v=\lambda(\xi x/z)^n.
```

The text correctly requires these roots to be included before extracting witness components defined over the field. Choosing an arbitrary component first and adjoining roots afterward would not justify arithmetic positivity.

## 3. Residual cover independence

For $i\in\{u,v,k\}$, the comparison field $K_i=\overline F(\eta_i,q)$ is rational of transcendence degree two. The two coordinates are independent because the selected potential is a nonzero rational function of the form $a^3\psi_i(q)$. The full prior field is finite over $K_i$: adjoin the cubic root $a$ from equation (8), the separate inverse-color cover functions and their designated roots, and recover $\xi$ from $\eta_i$ and those roots.

At $\eta_i=\theta\ne0$, the cubic radicand is a unit, hence that extension is unramified. I checked all nine entries in the color-cubed/potential matrix. Their growth orders at infinity are exactly

```math
\begin{pmatrix}2&1&2\\-1&-2&-1\\2&1&2\end{pmatrix}.
```

Every color and inverse color is therefore nonconstant in the residue field. The separate inverse-color covers and root equations are unramified. Each other potential differs from the selected one by one of $q,r,qr$ or their reciprocals, all nonconstant. Its designated quotient coordinate is therefore nonconstant too, so every earlier residual support cover is unramified at the selected divisors.

Passing to the finite Galois closure over $K_i$ preserves this unramifiedness. The intersection with the selected residual Galois cover is a Galois intermediate field. Since all nonzero finite inertia groups act trivially on that intermediate field and normally generate the full residual group, the intersection is $K_i$. Galois linear disjointness follows. Repeating for the three potential roles proves the simultaneous geometric integrality used in the count.

This argument does not require the prior compositum to be regular over the one-variable field $\overline F(\eta_i)$. The rational two-variable comparison field is essential and is used correctly. The maximal Kummer quotient and residual inertia normal-generation rely on all lifts of the original branch values, as established in the companion descent proof.

## 4. Counting and transfer

The restricted relation is bounded definable. Its extra conditions do not change the four-output grid map, and the complete cover above supplies the positive count for every full-dimensional input/output cell. Thus the previously audited restricted-grid argument yields

```math
N\ge c|A|^3/p-Cp^{15/16}|A|.
```

The disjoint input subsets ensure $s\ne t$. On the nondegenerate open, $K(s,t)=s$ or $K(s,t)=t$ implies $s=t$, so all three colors are distinct. A fixed exceptional ratio removes only $O(|A|)$ pairs. The inverse-coordinate pair determines an actual configuration uniquely; finite-cover witnesses do not increase graph multiplicities.

A missing potential value affects at most $9p$ configurations: there are three potential roles and, for each admissible $q$, at most three roots of the corresponding cubic equation in $a$. The established incidence bound remains sixteen. Consequently $N\le9pd+16R$. Since the total actual graph, including extra potential values, has at most $p|A|$ incidences, the advertised robust edge bound follows.

## 5. Exact quantifier order and warranted conclusion

The robust theorem fixes the formula and a positive density threshold $\delta$ first. Its constants may depend on them. Parameter values, the arbitrary palette, the actual support, and the omitted incidences then vary. The finite-cover degrees and coset indices are uniformly bounded for this fixed-formula family by the previously established witness/compactness argument. The proof gives no bound uniform over arbitrary increasing formula complexity.

For the exact support, no separate density threshold is required. If an alleged counterexample sequence had bounded support size, it would have only $O(p)$ edges. Otherwise the fixed-formula ultraproduct support is infinite, and the unary witness argument gives a positive-density curve image. This justifies the stated fixed-formula constant, including varying parameters.

Together with the independently audited palette theorem, the strongest conclusion is:

> In the quadratic common-potential family, $m=O(p^{63/32})$ when either the palette or the support is defined by a fixed ring-language formula, while the other set is arbitrary, for the corresponding completed family. The stated robust variants tolerate the specified missing core colors/support values and incidences.

Both sets arbitrary remains untreated, as does a reduction of arbitrary B-colorings to this model. The analytic methods and general covering machinery are established; historical novelty of this particular consequence remains unverified.
