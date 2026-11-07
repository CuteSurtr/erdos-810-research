# Quadratic pair-action mixing: a direct instance of known incidence theory

Primary-source check, 15 October 2026. This concerns the completed palette
`sigma_a(x) = ax + a^2`, `a != 0`, over an odd prime field. It does not settle
the arbitrary-support affine-coloring problem or Erdős problem #810.

**Verdict.** The bound `||C_2||_{mean-zero} <= sqrt(2p)` and its fixed-set mixing
consequence are elementary special cases of the established finite-field
point-line incidence estimate. They should be classified as a useful reformulation
of known theory, not as a candidate new expansion theorem. An exact published
weighted, two-sided estimate matches the calculation below.

## 1. Verified primary sources

- Thang Pham and Le Anh Vinh, *Distribution of distances in positive
  characteristic*, Pacific Journal of Mathematics 309(2) (2020), 437–451,
  [DOI 10.2140/pjm.2020.309.437](https://doi.org/10.2140/pjm.2020.309.437).
  [Author preprint, arXiv:1905.06483v5](https://arxiv.org/pdf/1905.06483),
  **Lemma 2.1, printed pp. 5–6** (statement on p. 5).
  For multisets E,F in F_p^2, the number of solutions of
  `e_1 f_1 + e_2 + f_2 = lambda` differs from `|E||F|/p` by at most
  `sqrt(p) ||m_E||_2 ||m_F||_2`. The authors explicitly identify this as the
  weighted point-line incidence estimate and prove both sides by character
  orthogonality and Cauchy–Schwarz.
- Le Anh Vinh, *The Szemerédi–Trotter type theorem and the sum-product estimate
  in finite fields*, European Journal of Combinatorics 32 (2011), 1177–1181.
  [Author preprint, arXiv:0711.4427](https://arxiv.org/pdf/0711.4427),
  **Theorem 3, printed p. 2; spectral proof in Section 2, pp. 3–4**.
  The displayed theorem is an upper incidence bound; the weighted two-sided
  statement needed here is stated explicitly in Pham–Vinh above.
- Brandon Hanson, Ben Lund and Oliver Roche-Newton, *On distinct perpendicular
  bisectors and pinned distances in finite fields*,
  [author preprint, arXiv:1412.1611](https://arxiv.org/pdf/1412.1611),
  **Lemma 14, printed p. 13**, also gives a weighted incidence upper bound.

## 2. Exact correspondence with ordinary point-line incidences

Write an ordered distinct pair `(x,z)` as

```
r = z-x != 0,       t = x/r.
```

Under the same completed color `a` on both coordinates,

```
r' = a r,          t' = t + a/r = t + r'/r^2.
```

Thus a transition from `(r,t)` to `(r',t')` exists precisely when the point
`(r',t')` lies on the line

```
ell_(r,t): y = r^(-2) x + t.
```

The color is then uniquely `a=r'/r`. The source-to-line map is at most
two-to-one, because the only duplicate source labels are `(r,t)` and `(-r,t)`.
The target-to-point map is one-to-one, with target first coordinate nonzero.

For arbitrary fixed subsets A,B of the ordered-pair space, form the multiset

```
E = { (r^(-2), t) : (r,t) in A },
F = { (r', -t') : (r',t') in B }.
```

The transition count `E_2(A,B)` is exactly `N(E,F,0)` in Pham–Vinh Lemma 2.1.
Here `|E|=|A|`, `|F|=|B|`, the multiplicity of each E-element is at most two,
and each F-element has multiplicity one. Consequently

```
sum m_E^2 <= 2|A|,       sum m_F^2 = |B|,

|E_2(A,B) - |A||B|/p| <= sqrt(2p |A||B|).
```

The main term includes the full multiset sizes. In particular, replacing the
two duplicate source labels by a single unweighted line without retaining
their multiplicity would not give the required count.

## 3. The mean-zero operator and the centered refinement

For completeness, the same standard incidence calculation proves the operator
statement directly, including its centered form. Let N take a function g on all
points `(u,v)` of F_p^2 to its sums over all nonvertical lines:

```
(Ng)(s,t) = sum_u g(u,su+t).
```

Two points with distinct first coordinates determine exactly one such line;
two different points with the same first coordinate determine none; each point
lies on p such lines. Hence, also for complex g,

```
||Ng||_2^2 = p||g||_2^2 + |sum g|^2
             - sum_u |sum_v g(u,v)|^2.
```

In particular, `sum g=0` implies `||Ng||_2 <= sqrt(p)||g||_2`.
Extend a mean-zero function on the target pair space by zero to points with
first coordinate zero. Restrict the line output to nonzero square slopes and
duplicate each retained slope according to its two square-root source labels.
Restriction cannot increase norm, and duplication increases squared norm by
at most two. This gives

```
||C_2 f||_2 <= sqrt(2p) ||f||_2,   sum f=0.
```

The pair space has size `Q=p(p-1)`, and C_2 has every row and column sum `p-1`.
Applying the preceding bound to centered indicators gives

```
|E_2(A,B) - |A||B|/p|
 <= sqrt(2p)
    sqrt( |A|(1-|A|/Q) |B|(1-|B|/Q) ).
```

The variance factors belong to this centered spectral calculation. They should
not be presented as the literal positive-multiset statement of Lemma 2.1.
This derivation also makes clear why the result is ordinary incidence mixing,
rather than a consequence of a new affine-group expansion phenomenon.

## 4. Why this does not remove the arbitrary-support obstruction

An actual partial color a is retained only on a set D_a of rows. Its contribution
on a source pair has the extra factor

```
1_(D_a)(x) 1_(D_a)(z),       a = r'/r.
```

In the incidence coordinates, that factor depends jointly on the source label,
target point, and the color recovered from both. It is generally not a product
of one fixed line weight and one fixed point weight. The two source labels
corresponding to the same physical line may also have different masks.
Additional conditions requiring crossed edges to be retained add further
coupling.

Weighted incidence estimates control separable point and line weights. They do
not supply a lower bound after an arbitrary incidence-dependent selection.
Dropping the masks gives an upper bound, which is not the needed lower count
of retained forbidden configurations. In general a subgraph of an expander
need not retain its expansion; this observation alone is not a counterexample
within the more constrained proper rainbow-C4 problem.

Thus the fixed-set estimate is valid and already covered by published theory.
The remaining research problem is to exploit the specific simultaneous support
and properness constraints, or to prove a suitable relative counting/removal
statement for them. The present correspondence establishes neither.
