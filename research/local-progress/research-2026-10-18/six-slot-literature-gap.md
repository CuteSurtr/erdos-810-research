# Six-slot rational surface: source comparison and remaining gap

Checked 18 October 2026. This is a limited follow-up to the equal-cross subfamily, not a claim to resolve arbitrary restricted palettes.

## Exact target

For $a\ne0$ and a parameter $q$ avoiding the finitely many zeros and poles below, put

```math
r=\frac{q+1}{q^2+1},\qquad B=q^2+q+1,
\qquad b=ar,\qquad c=aqr,
```

and

```math
x=-\frac{a^3qr}{B},\qquad
y=-\frac{a^3q^2r}{B},\qquad
k=-\frac{a^3q^2r^2}{B}.
```

The desired configuration has $a,b,c\in A$ and $x,y,k\in H$, where $A,H\subseteq\mathbb F_p^*$ have arbitrary fixed positive densities. Thus there are six unary membership tests on a two-dimensional rational surface. Direct substitution gives

```math
ak=by=cx,\qquad
a(b+c)=b^2+c^2,\qquad
x+y+k=-abc.
```

The last two identities are not additive identities between unary slot functions. They nevertheless show why checking only multiplicative divisor relations is not already a counting theorem.

## A new recurrence source does not match

Guo-Dong Hong, [*On weighted multilinear polynomial averages in finite fields*](https://arxiv.org/pdf/2507.14414), Proposition 1.4, printed p.3, proves a power-saving asymptotic for

```math
\mathbb E_{z\in\mathbb F_p^D}\mathbb E_t^*
f_0(z)\prod_i f_i(z+P_i(\varphi(t))v_i).
```

Here the nonzero integer vectors $v_i$ are fixed, the integer polynomials $P_i$ are linearly independent and have zero constant terms, and $\varphi\in\mathbb Q(t)$ is a fixed rational function. The conclusion is uniform for bounded input functions. Theorem 1.2 instead allows a strongly uniform scalar weight on the polynomial parameter. Section 1.3 explains that the general rational progression methods then available addressed three terms; the longer result uses the displayed common-composition structure.

The six maps above have no verified encoding in this shared-additive-base form. Taking discrete logarithms changes the domain to $\mathbb Z/(p-1)\mathbb Z$ and makes the parameter functions logarithms of rational functions; it does not satisfy the theorem's polynomial hypotheses. This source therefore does not establish the desired recurrence.

## Algebraic hypergraph regularity has a precise dimension gap

Alexis Chevalier and Elad Levi, [*An Algebraic Hypergraph Regularity Lemma*](https://arxiv.org/pdf/2204.01158), v2, Definition 3.2.1(2), printed p.24, requires each variety in its system to dominate the fibre product of the lower faces. Its dimension must equal that fibre product's dimension. Theorems 5.2.5 and 5.3.3 then give regularity in this setting, after suitable refinements and decompositions.

The natural system of our output projections fails this condition already on the three color coordinates. Each pair projection of $(a,b,c)$ is dominant: $b/a=r(q)$, $c/a=qr(q)$, and $c/b=q$ are nonconstant rational functions. Their lower-face fibre product is three-dimensional. But the triple satisfies $a(b+c)=b^2+c^2$ and has dimension two. Consequently the theorem is not a direct relative counting theorem for this surface. Applying ordinary regularity to the six-partite relation also provides no lower bound at its $O(p^2)$ scale inside an ambient set of size $p^6$.

This does not rule out a useful lifting or Cauchy–Schwarz argument based on the source; such an argument has not been supplied.

## The unavoidable multiplicative model is positive

The two equations $ak=by=cx$ define a four-dimensional torus. On that torus write $u=ak$ and parametrize independently by $a,b,c,u$; then $k=u/a$, $y=u/b$, and $x=u/c$. If $\alpha=|A|/(p-1)$ and $\beta=|H|/(p-1)$, the density of the six memberships in this model is

```math
\mathbb E_u\left(\mathbb E_a 1_A(a)1_H(u/a)\right)^3
\ge
\left(\mathbb E_{u,a}1_A(a)1_H(u/a)\right)^3
=(\alpha\beta)^3.
```

Thus these two universal relations do not create a density obstruction for the repeated sets $A,A,A,H,H,H$.

The divisor calculation for the actual rational maps likewise gives exactly these two relations among multiplicative characters. Indeed the independent divisor supports of $q$, $r=(q+1)/(q^2+1)$, and $B=q^2+q+1$ force their three character coefficients to vanish separately; averaging over $a$ imposes the fourth relation. If the characters on $(a,b,c,x,y,k)$ are $(\chi_a,\chi_b,\chi_c,\chi_x,\chi_y,\chi_k)$, the constant modes have

```math
\chi_a=\chi_k=(\chi_x\chi_y)^{-1},\qquad
\chi_b=\chi_y,\qquad \chi_c=\chi_x.
```

Every other complete character mode has square-root cancellation by the classical multiplicative-character Weil estimate; see Iwaniec and Kowalski, [*Analytic Number Theory*, Theorem 11.23, printed p.289](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf). Its bound depends on the number of distinct roots, so expressing all characters as powers of a generator does not introduce a degree-sized loss: the possible roots here lie among those of $q(q+1)(q^2+1)(q^2+q+1)$. Rational denominators are replaced by inverse-character exponents off this fixed exceptional set. But summing these bounds against arbitrary unary Fourier expansions incurs their Fourier $\ell^1$ norms. No uniform power-saving error for arbitrary $A,H$ follows from this mode-by-mode observation. What is missing is a multilinear estimate, or a density-increment/recurrence argument, that transfers the positive torus model to the actual two-dimensional surface.

## Scoped verdict

The inspected primary sources do not directly establish this six-slot recurrence. Hong's theorem has the wrong progression structure; Chevalier–Levi's direct system hypothesis fails by an explicit dimension calculation. The existing three-slot rational expansion proof for $K(x,y)$ does not automatically incorporate three additional arbitrary palette memberships. No claim of nonexistence of another relevant theorem, of originality, or of a solution of Erdős problem 810 follows from this search.
