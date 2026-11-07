# Independent audit of the growing-index and Wiener bounds

18 October 2026. Audited source: [growing-index-wiener-palettes.md](growing-index-wiener-palettes.md). The exact six-coordinate count, Fourier estimate, and both quantitative consequences pass. This audit uses the previously verified equal-cross configuration and its sixteen-incidence deletion multiplicity.

## 1. Exact logarithmic kernel

Since $F=-B/(qr)$, the potentials are $-a^3qr/B$, $-a^3q^2r/B$, and $-a^3q^2r^2/B$. Thus translating the support indicator by $\log(-1)$ is necessary and sufficient. The six displayed linear forms have exactly these logarithms.

The change of variables to the three color logarithms and $S=L_1+L_6$ is invertible over every cyclic group: its inverse uses only addition and subtraction. No division by two or three is implicit. The three potential forms become $S-c,S-b,S-a$, so the mean kernel is precisely a third moment of a nonnegative convolution. Jensen's lower bound $\mu\ge(\alpha\beta)^3$ is correct even when the group order has factors two or three.

The count $N=(p-1)\sum_{q\in\Omega}T(\log q,\log r,\log B)$ is exact. There is no assumption of independence among the six slots; the relations $ak=bv=cu$ are retained in the kernel.

## 2. Uniform character estimate

I checked [Reis, *Arithmetic constraints of polynomial maps through discrete logarithms*, Theorem 3.2](https://arxiv.org/pdf/2007.04114) in the primary PDF. It bounds a character sum by the number of distinct roots, rather than polynomial degree, provided the polynomial is not a constant times the relevant full character-order power. Composite character orders are allowed.

After reducing the four factor exponents modulo the character order, the polynomial has at most six distinct roots. At $0$, $-1$, and a root of $B$, the multiplicities are respectively $j_1,j_2,j_3$ modulo the order. For $p>3$, these points are distinct from each other and from the other factors' roots. A nonzero mode therefore cannot be a full-order power. The asserted absolute $O(\sqrt p)$ bound, independent of the character order, follows. Removing $\Omega$'s at most seven exceptional values costs only $O(1)$.

This verifies equation (8), including its uniformity in a growing index. The trivial index is handled separately as stated. Bounded small primes are absorbed in the final absolute constants when replacing $p-7$ by a fixed proportion of $p$.

## 3. General Wiener criterion and arcs

The normalized Fourier conventions are consistent: averaging in the auxiliary variable discards its nonzero Fourier modes, pullback along a homomorphism does not increase the Fourier $\ell^1$ norm, and pointwise multiplication is submultiplicative in that norm. Hence $\|\widehat T\|_1\le M_A^3M_H^3$.

The exact deletion inequality $N\le16R$ yields

```math
m\ll p^{11/6}\|\widehat T\|_1^{1/3}+p^{4/3}R^{1/3},
```

and therefore the displayed $p^{11/6}M_AM_H$ bound. The powers of $p$ and of $R$ check.

A character arc is an interval on its cyclic image. Its normalized Fourier norm is $O(\log(2d))$ for image order $d$, by the finite geometric-series formula and the harmonic sum. Pullback and products therefore give the claimed fixed-number-of-arcs bound, without requiring the characters to be independent or their orders bounded. Fixed finite unions are also covered by inclusion–exclusion with constants depending on the number of pieces.

## 4. Growing coset unions

If both sets factor through a quotient of order $\ell$, the kernel has $\ell^3$ Fourier modes. Since $0\le T\le1$, Parseval and Cauchy–Schwarz give exactly

```math
\|\widehat T\|_1\le\ell^{3/2}\sqrt\mu.
```

The count then implies $\mu\ll\ell^{3/2}p^{-1/2}\sqrt\mu+R/p^2$. Completing the square gives $\mu\ll\ell^3/p+R/p^2$. Combining this with Jensen proves

```math
m\ll\ell p^{5/3}+p^{4/3}R^{1/3}.
```

The selected cosets can be arbitrary and their number can grow. The nontrivial asymptotic range is $\ell=o(p^{1/3})$. This is a two-set complexity condition, complementary to the one-sided fixed-formula results.

## 5. Remaining limitation

The proof does not bound $\|\widehat T\|_1$ sufficiently for arbitrary dense sets. At full group order the generic Parseval estimate is too large. The uniform torus-model positivity is settled by Jensen; the remaining problem is a weighted restriction estimate for this kernel on the actual rational curve $(q,r(q),B(q))$. Per-mode square-root cancellation alone does not supply that estimate.

The argument is a valid specialized consequence of established character-sum and Fourier methods. It is an actual extension to growing complexity, but it is neither an unrestricted #810 result nor an established novelty claim.
