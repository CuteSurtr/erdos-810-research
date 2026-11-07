# Audit of the bounded-index palette extension

The proof in [quadratic-coset-palette-extension.md](quadratic-coset-palette-extension.md) passes the following independent checks. It is a restricted-family theorem; no claim of historical priority or formal verification is made.

1. **The root condition is exact.** If $C\le\mathbb F_p^*$ has index $\ell$, then $C=(\mathbb F_p^*)^\ell$. There exists $a\in tC$ with $a^3=G(u,v)$ if and only if $G(u,v)/t^3$ is a nonzero $3\ell$th power. The forward implication writes $a=ts^\ell$; the reverse uses the same formula. There is no requirement that cubing be injective on the coset.

2. **The higher-degree counting input has the same geometric justification.** The previously checked cover calculation gives a valuation of $G$ equal to one over the divisor $v=\omega u$ after arbitrary separate covers of the three coordinates. Dividing by a nonzero parameter does not change that valuation. Eisenstein therefore proves irreducibility of $z^n-G/c$ for every fixed positive integer $n$, including composite $n$. This is the only additional geometric input in the counting proof. Its bounded-definability, grid, regularity, and positivity steps remain valid with constants depending on $n$. Uniformity in $c\ne0$ follows by including $c$ as a parameter in the same characteristic-zero ultraproduct argument. This does not assert uniform bounds when $n$ grows with $p$.

3. **The three palette memberships remain coupled correctly.** Choosing $u,v,k$ in one coset $\lambda C$ forces both ratios $k/u$ and $k/v$ into $C$. Thus once $a\in tC$, the other two actual colors $ak/v$ and $ak/u$ are also in $tC$. Splitting the input support into disjoint sets ensures $u\ne v$. The earlier nonzero and pole exclusions then give three distinct colors and four distinct edges. No independent-density approximation is used.

4. **Witness multiplicities do not contaminate the deletion bound.** The analytic predicate counts input pairs for which at least one Kummer witness exists. Every such pair gives at least one actual color $a$. The graph count then includes all actual admissible cube roots $a$, rather than the auxiliary $3\ell$th roots $s$. Therefore the previously checked bounds of sixteen configurations per fixed colored incidence and $3p$ per fixed color apply unchanged. The many-to-one map $s\mapsto ts^\ell$ is irrelevant.

5. **Only omissions inside the chosen palette coset matter.** It suffices to define $R$ as the number of missing eligible incidences in $(A\cap tC)\times H$; other colors may have arbitrary omissions. Every counted configuration lies entirely in $tC$. With $d=|tC\setminus A|$, the upper count is still $16R+3pd$. The final conversion $m\le p(|H\setminus\{0\}|+1)$ bounds the total graph, including all colors outside that coset.

6. **The exponents are unchanged.** From $c_Lh^3/p-C_Lp^{15/16}h\le16R+3pd$, the error-dominated case gives $h^2\ll_Lp^{31/16}$, hence $h\ll_Lp^{31/32}$. The other case gives $h\ll_L[p(R+pd)]^{1/3}$. Multiplication by $p$ yields $p^{63/32}$ and $p^{4/3}(R+pd)^{1/3}$ respectively.

The extension is not vacuous merely because propriety is assumed. For the palette $tC$, every collision potential has the form $-a^2b$ with $a,b\in tC$, hence lies in the single coset $-t^3C$. Consequently any support $H$ disjoint from $-t^3C$ gives a proper completed coloring. When $\ell\ge2$, such supports may have fixed positive density and may otherwise be arbitrary. The theorem then forces a non-rainbow four-cycle when the support is sufficiently large.

The remaining limitation is substantive: an arbitrary positive-density palette need not contain almost all of any coset of bounded index. No step in this extension removes that restriction.
