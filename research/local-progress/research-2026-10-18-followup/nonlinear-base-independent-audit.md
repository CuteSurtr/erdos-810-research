# A nonlinear base defeats the affine path-closure obstruction

18 October 2026. This audits the explicit nonlinear-base construction proposed during the session. The construction is correct. It prevents extending the affine-base bound in [the fractional-closure note](fractional-closure.md) to all base bijections. It is an ambient incidence construction, not a B-coloring or a counterexample to Erdős #810.

Let $p\equiv3\pmod4$ and let $\chi$ be the quadratic character. Define

```math
h(0)=0,\qquad h(r)=-\chi(r)r^2/4\quad(r\ne0).
```

Squaring is bijective on each of the two nonzero quadratic classes: the two roots of a square have opposite characters because $\chi(-1)=-1$. Therefore $h$ maps the quadratic residues bijectively to the nonresidues, and the nonresidues bijectively to the residues. In particular, $h$ is a permutation and defines a base matching.

Use the full family $f_b(x)=bx+b^2$, $b\ne0$, as colored incidences. For every center $x\ne0$, put $\epsilon=\chi(x)$ and

```math
B_x=\{b:\chi(b)=\epsilon,\ \chi(b+x)=-\epsilon\}.
```

Upon writing $b=xt$, the defining conditions are $\chi(t)=1$, $\chi(t+1)=-1$. The exact quadratic-character correlation gives

```math
|B_x|=\frac14\sum_t(1+\chi(t))(1-\chi(t+1))
=\frac{p+1}{4}.
```

The apparently exceptional terms $t=0,-1$ are both zero, so this formula requires no correction.

For $b\in B_x$, the central column $b(x+b)$ is a nonresidue. Hence

```math
r_b=h^{-1}(b(x+b))
```

is a nonzero quadratic residue and satisfies

```math
r_b^2=-4b(x+b).                                      \tag{1}
```

The associated conic has the parametrization

```math
b=-\frac{xv^2}{1+v^2},\qquad
r_b=\frac{2xv}{1+v^2}.
```

Because $-1$ is a nonsquare, the denominator never vanishes for finite $v$. All points with $b(b+x)\ne0$ arise with $v\ne0$ finite; the omitted parameters zero and infinity give the excluded endpoints $b=0,-x$. The identity

```math
\frac{r_b-x}{b}=\frac{(v-1)^2}{v^2}
```

therefore proves $\chi(r_b-x)=\chi(b)=\epsilon$ unless $v=1$, in which case $r_b=x$.

For any $b,c\in B_x$, the path with pattern base, $b$, $c$, base, $b$ starts at $r_b$ and ends at $f_b(r_c)$. Its closing edge has color $d$ if

```math
d^2+r_bd-b(r_c+b)=0.
```

By (1), the discriminant is

```math
\Delta=r_b^2+4b(r_c+b)=4b(r_c-x).
```

This is a square or zero, since $\chi(b)=\chi(c)=\epsilon$ and the conic identity gives the same character for $r_c-x$. There is always a nonzero root $d$: if one root is zero, the other is $-r_b\ne0$, and a repeated root is $-r_b/2\ne0$. Thus every actual simple path of the stated form closes using some color of the full quadratic family.

Central coincidences occur only under the involution $b\mapsto-x-b$, which preserves $B_x$. Taking one representative per orbit leaves at least $|B_x|/2$ colors with distinct central neighbors. The possible fixed color $b=-x/2$ causes no problem; it belongs to $B_x$ only when $\chi(2)=-1$.

The full incidence family is still improper: distinct color lines can meet. The construction does not make their color classes into a simple proper B-coloring and does not establish the paper's theorem hypotheses for a legitimate dense B-colored graph. Its precise conclusion is that nonlinear choice of the base bijection can create positive-density path closure in the ambient quadratic family, even though every affine base permits only $O(\sqrt p)$ good colors at a fixed center.
