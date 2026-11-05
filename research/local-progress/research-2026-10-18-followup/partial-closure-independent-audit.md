# Independent audit of the partial path-closure theorem

18 October 2026. The theorem, direct closed-path version, incidence-deficit bound, and aggregate alternative in [partial-path-closure-structure.md](partial-path-closure-structure.md) pass this written audit. The complete base matching remains a necessary stated hypothesis. No formal verification or historical-priority claim is made.

At a chosen center, distinct retained colors have distinct column endpoints because the colored graph is simple. Inverting the base permutation therefore gives distinct $r_b$. None equals the center, since the complete base edge already occupies that endpoint pair. For $b\ne c$, a retained continuation creates a simple path: its last column differs from the first by injectivity of $f_b$, and differs from the fourth because the latter already has the base color at $r_c$. Only the diagonal pairs must be discarded.

An actual closing edge cannot be the base edge: that would force $f_b(r_c)=f_b(x)$ and $r_c=x$. Thus actual closure gives a root of the displayed quadratic in a nonzero family color. For each $b$ there is at most one zero discriminant, using the distinct $r_c$. These observations verify

```math
S_x\ge 2C_x-k_x^2-k_x
\ge k_x^2-2(D_x+Q_x)-3k_x.
```

The second character pushforward has squared norm exactly $k_x$. The first has squared norm at most $E_x+z^2$: the exceptional fiber has at most $z$ members, and the other fibers are bounded by the previously audited full-family energy. The character matrix norm is $\sqrt p$, so $|S_x|^2\le p k_x(E_x+z^2)$. With $k_x\ge3/\eta$ and the stated deficiency bound this gives $E_x+z^2\ge\eta^2k_x^3/p$. The global energy sum $3p(p-1)$ then gives the stated exceptional-center constant $4\eta^{-2}\delta^{-3}$ and agreement threshold $\eta\delta^{3/2}p/2$. The direct closed-path version needs only $k_x\ge1/\eta$ and has the same remaining constants.

The decomposition $D_x=U_x+V_x$ is exact: every missing continuation either lies outside the common potential support or is an omitted eligible incidence. A specified omitted incidence fixes $(b,r)$, and each nonzero $c$ determines at most one center from $cx+c^2=h(r)$, proving $\sum_xV_x\le(p-1)R_{\rm omit}$.

Finally, summing the lower bounds for $S_x$, bounding each above by $\sqrt{pk_x(E_x+z^2)}$, and applying Cauchy–Schwarz yields precisely the square-root term in the aggregate alternative. If $T$ is bounded below by a positive multiple of $p^3$ and $z=o(p)$, that error is $o(T)$ because $L\le p^2$ and there are at most $p$ centers. Under actual closure and $o(p^2)$ eligible omissions, at least $(1/2-o(1))T$ continuations must therefore fail through their potential falling outside the support. This is a quantified obstruction to a completion argument, not an unconditional upper bound for #810.
