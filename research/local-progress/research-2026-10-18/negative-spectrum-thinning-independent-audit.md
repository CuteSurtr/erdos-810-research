# Audit of the random-thinning spectral lemma

Sections 3–5 of [common-potential-negative-spectrum.md](common-potential-negative-spectrum.md) pass the following checks. This audit uses the previously established completed-operator bound and triangle-removal spectral criterion only where the source note explicitly invokes them.

For a nonzero potential $t$, a state $(x,y)$ can have a changed color contribution only when $ay=t$ or $a^3+xa^2=t$. The former has at most one solution and the latter at most three. At $y=0$ the operator vanishes. The difference is self-adjoint and has maximum absolute row sum at most four, so its operator norm is at most four. This remains true even if several colors lead to the same matrix entry: the sum of their absolute contributions is still bounded by the number of changed colors.

Under independent Bernoulli thinning, a transition with distinct potential values is retained with probability $\eta^2$. Equality of the two values is equivalent to the fixed-point equation $y=ax+a^2$ and gives precisely the diagonal-loop correction, retained with probability $\eta$. Hence $\mathbb ET_{A,H}=\eta^2T_{A,J}+\eta(1-\eta)L_{A,J}$, with $L_{A,J}$ positive semidefinite.

The matrix bounded-differences proxy is $16|J|I$: each single-coordinate difference has square bounded by $16I$. Applying both signs of the cited inequality in dimension $p^2$ gives exactly the factor $2p^2$ and exponent $-t^2/(128|J|)$. No independence of individual matrix entries is assumed or needed; the independent variables are the potential-membership bits.

For the quadratic-character example, every palette color is a square and therefore preserves the base support $J$ under multiplication. This gives the exact compression $T_{A,J}=M_J S_A M_J$. The positive constant part of the completed operator remains positive after compression. Its established $O(p^{7/8})$ remainder therefore supplies the stated lower bound, and thinning adds only $O(\sqrt{p\log p})$ with high probability. The collision-character calculation also verifies propriety for every submask of $J$.

The conclusions remain probabilistic. They neither bound the negative spectrum for every deterministic common mask nor produce a negative-spectrum counterexample. The stated limitation on a union bound over all masks is correct.
