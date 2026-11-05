# Monomial propriety bound: independent audit

18 October 2026. The proof in [monomial-common-potential-propriety.md](monomial-common-potential-propriety.md) passes. This audit checks the points where a false extension from the cubic case could otherwise arise.

For fixed $d\ge3$, put $e=d-1$, $n=2e+1$, and $P(q)=q+\cdots+q^e$. The exact line-intersection equations give $h_1=-a^nP(q)$ and $h_2=q^eh_1$. Every omitted color/potential incidence has at most $e$ collision partners, because the equation for $q$ has degree $e$ and nonzero leading coefficient. Ordered collisions therefore satisfy the upper bound $2eR+2pD$ used in the canonical proof.

For any nontrivial root character $\chi$ and any Mellin character $\eta$, the factor $\eta(q)$ can affect valuations only at zero and infinity. The polynomial $1+q+\cdots+q^{e-1}$ has a simple nonzero root in the algebraic closure when $p>d$. At that root the exponent of the factor from $\chi$ is nonzero modulo the order of a primitive character. Thus no Mellin twist cancels the character sum. The usual Weil bound in terms of the number of distinct roots gives $O_d(\sqrt p)$ uniformly in the Mellin character. Using a high-degree polynomial to encode a primitive character is harmless here: the estimate depends on distinct roots, not the displayed degree. The cited primary input is Iwaniec--Kowalski, [*Analytic Number Theory*, Theorem 11.23](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf).

Let $g=\gcd(e,p-1)$. Lifting one potential coset by $h=\lambda u^e$ gives exactly $g$ lifts of every ordered collision, rather than $g^2$: after choosing $u$, the ratio $q=b/a$ fixes $v=qu$. The exact root count $\sum_{\chi^n=1}\chi(z)$ includes all nonzero roots without an additional normalization. Dividing by $g$, summing all $g$ potential cosets, and applying $g\sum h_\lambda^2\ge(\sum h_\lambda)^2$ gives the claimed global lower bound $h^2-O_d(\sqrt p)h$.

These checks prove the stated conclusion

```math
m\ll_d p^{3/2}+p\sqrt{R+pD}.
```

For $d=3$, the explicit coefficient $4\sqrt p+6$ in the lower collision bound is safe: it includes the deletion of the diagonal in the trivial term and all four nontrivial fifth-character terms. The bound is obtained from properness alone, without a four-cycle assumption, and consequently supersedes the weaker cubic correspondence application.

For $d=2$, the obstruction disappears because $P(q)=q$. A Mellin character can then cancel the entire kernel and leave an eigenvalue of order $p$. This failure is substantive: a noncube potential coset with the full quadratic palette gives a proper graph with order $p^2$ edges when $p\equiv1\pmod3$.
