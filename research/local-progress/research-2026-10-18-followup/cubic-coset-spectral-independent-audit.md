# Independent audit of the cubic coset spectral bound

18 October 2026. The argument in [the cubic coset spectral note](cubic-coset-spectral.md) passes this mathematical audit. It proves the stated bound for the cubic common-potential model, with constants depending on a fixed bound for the subgroup index. It is neither a Lean certificate nor a historical novelty determination.

## 1. Wreath-product monodromy

The previously audited reciprocal quartic has geometric group $S_4$ for every $u\notin\{0,1/(64t^3)\}$. At $v=-u$ it specializes to $z(z^3-1/u)$. All four roots are simple when $p>3$. Thus its splitting field is unramified there, and exactly one reciprocal color root has valuation $-1$; the other three have valuation zero. Transitivity gives four places, one isolating each color root.

When adjoining $n$-th roots of the other color roots, these places remain unramified: their radicands are units, and $p\nmid n$. The valuation $-1$ of the selected root therefore survives. Equivalently, its reciprocal satisfies an Eisenstein polynomial of degree $n$. This proves successive degrees $n,n,n,n$, also for composite $n$, rather than merely checking pairwise Kummer independence. The natural root action embeds the resulting group in $C_n\wr S_4$, and its order is $24n^4$, proving equality.

At $v=-u$, inertia supplies one full coordinate $C_n$. Its normal conjugates give all four coordinate factors. At a simple root of $D_u$, inertia maps to a transposition in $S_4$. Consequently the normal closure of all finite nonzero inertia is the full wreath product. No assumption that the transposition lift is literally an untwisted permutation is needed: after quotienting out the already generated Kummer subgroup, the ordinary transpositions generate the remaining $S_4$.

## 2. Base changes, exceptional row pairs, and uniformity

The power-map base change $v=\lambda s^n$ is Galois geometrically and ramified only at zero and infinity. Any intersection with the row splitting field is a Galois quotient on which all finite nonzero inertia acts trivially. Normal generation makes this quotient trivial. The same argument applies to a product of two row covers when their finite nonzero branch sets are disjoint.

There are at most sixteen exceptional partner rows for any fixed row: its branch set has at most four elements $\beta$, and each gives at most one solution of $-u'=\beta$ and three solutions of $D_{u'}(\beta)=0$. This includes the row itself. No estimate on the proportion of exceptional pairs is being substituted for a per-row bound.

Because $n\mid p-1$, all $n$-th roots of unity lie in the ground field. Arithmetic root permutations therefore lie in the same wreath group already attained geometrically; there is no hidden constant-field extension. The groups have orders prime to $p$, the number of branch points after the power-map base change is bounded in terms of $n$, and Riemann–Hurwitz gives the required uniform genus bounds. Classical finite-field Chebotarev consequently has errors $O_n(\sqrt p)$, uniformly in the good row and all nonzero field parameters.

## 3. Counting and deletion transfer

The fixed-letter probability is

```math
\delta_n=\frac1n-\frac1{2n^2}+\frac1{6n^3}-\frac1{24n^4}.
```

Indeed, conditional on the $S_4$ permutation, each fixed block contributes fixed letters precisely when its independent cyclic shift vanishes; inclusion–exclusion and $\mathbb E\binom{\operatorname{Fix}(\sigma)}j=1/j!$ give this formula. A rational letter is exactly a rational palette root, so this is the correct event, without a multiplicity factor from the $n$ roots above a color.

The written proof correctly divides point counts on the $s$-line by $n$ to obtain counts on the potential coset. Its row and codegree main terms are therefore $\delta_n|U|$ and $\delta_n^2|U|$. At most sixteen exceptional partners contribute only $O_n(p)$ to each absolute Gram row sum, and the remaining entries contribute $O_n(p^{3/2})$. The resulting operator norm is $O_n(p^{3/4})$.

If both potentials belong to the same coset of $(\mathbb F_p^\times)^n$, then $b/a=v/u$ lies in that subgroup. Hence a root in the palette coset supplies both required colors. Excluding $u=v$ ensures distinct colors; excluding $v=-u$ removes the pole specialization and only a bounded number of entries per row.

A missing core color appears in at most $2p$ ordered collision configurations. A fixed omitted incidence appears in at most four, because the equation for the other color has degree two and either incidence can occupy either position. These bounds apply to the actual color-pair configurations, not the cover's auxiliary root witnesses.

Choosing the largest potential coset after removing $0$ and the exceptional row gives $h\ge(|H|-2)/n$. Thus the proved inequality is exactly

```math
m\ll_L p^{7/4}+p\sqrt{R+pd},
```

where $R$ counts omissions only on the available core colors and all actual potentials. Arbitrary additional colors are permitted: the estimate controls $|H|$, and then $m\le p|H|$ counts those colors too.

## Verdict and scope

The complete argument passes. It needs only a single-valued color assignment to each ordered pair of endpoints, not the rainbow-four-cycle condition. The fixed index bound is essential to the stated constants; no quantitative assertion for indices growing with $p$ follows from this proof without tracking the genus and Chebotarev constants. Its novelty remains unverified, and its scope is the specified cubic perturbation rather than unrestricted Erdős #810.
