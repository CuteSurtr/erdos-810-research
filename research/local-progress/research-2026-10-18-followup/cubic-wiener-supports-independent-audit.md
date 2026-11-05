# Independent audit of the cubic Wiener-support criterion

18 October 2026. The complete proof in [cubic-wiener-supports.md](cubic-wiener-supports.md) passes an independent mathematical audit, including the density-sensitive bound and the support-core transfer. Historical priority is not established.

With $s=|A|$, $\beta=|H|/(p-1)$, and the normalized multiplicative Fourier norm $M_H$, the checked central inequality is

```math
\beta^2s^2\le4R+(1+\beta)s+\sqrt p\,sM_H^2.
```

The verification is as follows.

1. The two collision potentials are exactly $-a^2bL$ and $-ab^2L$, where $L=1+t(a+b)$. Fourier expansion gives outer weights $\chi^2\psi(a)$ and $\chi\psi^2(b)$, the factor $(\chi\psi)(-1)$, and the kernel $(\chi\psi)(L)$.
2. When $\psi=\chi^{-1}$, the coefficient is $|\widehat H(\chi)|^2$ because the indicator is real. The unrestricted sum is $|\sum_{a\in A}\chi(a)|^2$. Subtracting the pairs with $L=0$ costs at most $\beta s$, since there are at most $s$ such pairs and Parseval gives $\sum|\widehat H|^2=\beta$. The surviving nonnegative main terms include $\beta^2s^2$.
3. For every nontrivial $\rho$, additive reflection turns the matrix $\rho(1+t(a+b))$ into convolution. Its zero-frequency eigenvalue vanishes and every other eigenvalue has modulus $\sqrt p$, by the classical Gauss identity. The complex bilinear expression is bounded by the same operator norm, using conjugation of the first vector if necessary. Both outer vector norms are $\sqrt s$.
4. Summing the remaining Fourier pairs absolutely costs at most $\sqrt p\,sM_H^2$. The factor $\rho(-1)$ has modulus one and changes no bound.
5. The $a=b$ configurations number at most $s$. Any fixed omitted incidence affects at most four ordered distinct-color configurations because the other color satisfies a quadratic with nonzero leading coefficient. Thus $N\le s+4R$, giving the displayed inequality.

For nonempty $H$, Fourier inversion at a point of $H$ gives $M_H\ge1$. Replacing $s$ by its bound $p$ proves the uniform estimate $m\ll p^{7/4}M_H+p\sqrt R$. Keeping $s$ and solving the quadratic inequality in $\beta s$ instead proves $m\ll p^{3/2}M_H^2/\beta+p\sqrt R$. These are simultaneous bounds, so their main terms may be minimized.

For a union of cosets of an index-$\ell$ subgroup, at most $\ell$ Fourier coefficients are nonzero. Cauchy–Schwarz and Parseval give $M_H^2\le\ell\beta$, so $m\ll\ell p^{3/2}+p\sqrt R$ without a separate lower bound on $\beta$. The character-arc consequence follows from the usual cyclic-interval Fourier norm and the submultiplicativity of the Wiener norm.

The dense support-core transfer also checks. A fixed missing potential participates in at most $4p$ configurations, so $R$ is replaced by $R+pd$ up to an absolute factor. The positive core density bounds $s$ through the same inequality; the final bound $m\le ps$ then includes every actual potential, including zero and arbitrary extra support outside the core.

All conclusions use only single-valued colors on each graph edge. They are specialized simplicity obstructions for the stated cubic common-potential model, not new unrestricted rainbow-four-cycle bounds.
