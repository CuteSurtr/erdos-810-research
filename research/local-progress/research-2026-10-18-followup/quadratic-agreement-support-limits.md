# What quadratic agreement forces, and what it does not

18 October 2026. This note checks the next implication after [the partial-path structural theorem](partial-path-closure-structure.md). It records exact elementary constraints and an obstruction to turning quadratic agreement into a density contradiction by itself. It is not an additional asymptotic bound.

Let $h$ be a permutation and put

```math
Z=\{r:h(r)=-r^2/4\}.
```

Suppose an actual simple graph contains the complete base matching $h$ together with partial quadratic color lines $f_a(r)=ar+a^2$.

## 1. The tangent incidence

For $r\in Z\setminus\{0\}$, the color $a=-r/2$ has

```math
f_a(r)=-r^2/4=h(r).
```

Its common potential is

```math
a f_a(r)=r^3/8=-a^3.
```

Therefore, if $a\in A$ and $-a^3\in H$, that quadratic incidence must be omitted to avoid assigning both the base color and color $a$ to the same edge. The forced count is exactly bounded below by

```math
\#\{r\in Z\setminus\{0\}:-r/2\in A,\ r^3/8\in H\}.
```

This does not imply a density-scale omission lower bound. It forces only one specified incidence per agreement point, at most $p$ in total. Moreover, when $p\equiv1\pmod3$, taking $H$ to be any nontrivial cubic coset excludes all these potentials, because every $-a^3$ is a cube. This example concerns the tangent constraint alone; it is not asserted to satisfy all other graph conditions.

## 2. Two agreement points and a repeated-base four-cycle

Take distinct $r,s\in Z$. Since $h$ is injective, $r^2\ne s^2$. A quadratic-family edge from row $r$ to column $h(s)$ exists precisely when

```math
a^2+ra+s^2/4=0
```

has a nonzero solution. Its discriminant is $r^2-s^2$. The reverse cross edge, from row $s$ to column $h(r)$, has discriminant $s^2-r^2$.

For nonzero $r,s$, square discriminant yields two nonzero colors. If one of $r,s$ is zero, the same existence criterion holds: the equation with zero constant term has one admissible nonzero root and the other direction is decided by the displayed nonzero discriminant.

Consequently, for $p\equiv3\pmod4$, exactly one of these two cross edges exists in the completed quadratic family. The negative of a nonzero square is a nonsquare, so the two required discriminants cannot both be squares. Thus no four-cycle with its two opposite base edges based at $r,s\in Z$ can occur, even before applying palette or support restrictions.

This is a genuine obstruction to the proposed next inference. In this prime class, dense quadratic agreement automatically protects the graph from this particular repeated-base four-cycle. It does not contradict the rainbow condition through that pattern.

For comparison, when $p\equiv1\pmod4$, the two discriminants have the same character. If $|Z|=z\gg p$, a quadratic-character matrix estimate shows that

```math
\frac{z(z-1)}4+O(\sqrt p\,z)
```

unordered pairs have both cross edges available in the completed family. To see this, the values $r^2$ for $r\in Z$ are distinct; the sum of $\chi(r^2-s^2)$ over ordered distinct pairs has magnitude at most $\sqrt p\,z$. Each positive unordered pair counts twice in the ordered sum. Avoiding a repeated-base four-cycle requires at least one of its two cross edges to be unavailable in the actual graph. A palette or support restriction can already account for that unavailability, so this observation alone does not bound the number of omitted eligible incidences.

## 3. Remaining issue

The structural theorem proves quadratic agreement from sufficiently dense retained and closed paths. Agreement itself supplies only the explicit tangent constraint above, and in the $p\equiv3\pmod4$ case it even prevents a basic repeated-base obstruction inside the agreement set. A further advance would need constraints involving other rows, several non-base colors, or simultaneous common-support membership. No such additional implication is proved here.
