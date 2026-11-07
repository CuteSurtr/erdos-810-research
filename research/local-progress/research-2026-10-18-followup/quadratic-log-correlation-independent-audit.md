# Independent audit of the quadratic-log correlation reduction

18 October 2026. The complete argument in [quadratic-log-correlation-target.md](quadratic-log-correlation-target.md) passes an independent written mathematical audit. It identifies a necessary correlation for one explicit family; it does not prove cancellation or an unrestricted graph theorem.

The following points were checked independently.

1. The actual potential logarithms equal $L_4+e,L_5+e,L_6+e$, with $e=\log(-1)$. The three palette residue conditions force $t,x,y\equiv0\pmod3$, and the support conditions then force $z\equiv2\pmod3$. Since $p-1$ is divisible by six, $e$ is divisible by three.
2. A cube palette and a noncube potential support prohibit the quadratic family's same-endpoint collisions: both collision potentials $-a^2b$ and $-ab^2$ are cubes. This uses $-1=(-1)^3$ and does not need an additional character condition.
3. On writing $n=3m$ and $t=3s$, the normalized common-scale average is exactly

```math
\frac13e_n(W)\,\mathbb E_{s\in\mathbb Z/m\mathbb Z}
 e_m(3Us^2+Vs).
```

The quadratic Gauss bound is $\sqrt{\gcd(6U,m)/m}$, valid for composite $m$ and every linear coefficient $V$. For fixed nonzero $U$, it is $O_U(n^{-1/2})$.

4. For $U=0$, a nonzero integral linear form $V=v_1x+v_2y+v_3z$ can survive only when $m\mid V$. This forces $(q^{v_1}r(q)^{v_2}B(q)^{v_3})^3=1$. The valuations at $q=0$, $q=-1$, and a root of $B$ are respectively sensitive to $v_1,v_2,v_3$, proving that the rational function is nonconstant unless all three coefficients vanish. The fixed-degree equation has only a bounded number of solutions.
5. Solving the coefficient equations $U=V=0$ directly gives

```math
(m_1,m_2,m_3)=(m_6,m_5,m_4),\qquad
m_4+m_5+m_6=0.
```

Writing $(m_4,m_5,m_6)=(j+k,-j,-k)$ gives the stated residual phase. Direct expansion verifies its two coefficients as $Q_1=4xy+2xz$ and $Q_2=2z(x+y)$, with the signs in the note.

6. The three residue conditions on $q$ have limiting density $1/27$: every nontrivial order-three character combination of $q,r,B$ is nontrivial by the same valuation check, so the classical character-sum bound applies. The $t$ restriction contributes another factor $1/3$. Consequently the constant Fourier term is exactly the claimed positive limit, the product of the six bump integrals divided by $81$.
7. Fejér approximation preserves the bump integrals and gives uniformly bounded nonnegative approximations. A fixed approximation degree and sufficiently small fixed product error leave a positive constant term. If the weighted configuration count tends to zero, at least one of the finitely many nonzero residual phases must have correlation bounded away from zero. A subsequence fixes the frequency pair. Expanding the residue indicator into its twenty-seven order-three characters and taking a further subsequence gives the stated fixed twist.
8. The bump supports have positive asymptotic density by the same quadratic Gauss estimate, including the shifted residue-one support class. The weighted configuration count is dominated by the actual configuration count; the checked sixteen-per-incidence deletion bound makes it $o(1)$ after $o(p^2)$ omissions.

The remaining limitation is substantive: the resulting quadratic discrete-log phases are not ordinary fixed multiplicative characters of rational functions. No Weil-type cancellation for those phases is supplied by this argument.
