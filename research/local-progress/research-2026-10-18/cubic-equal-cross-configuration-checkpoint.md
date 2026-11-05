# Cubic equal-cross-potential configuration: algebraic checkpoint

This records exact algebra from a route that is no longer needed for the full-palette upper bound. The simpler [monomial propriety argument](monomial-common-potential-propriety.md) already gives $O(p^{3/2})$ edges for the cubic palette, using propriety alone. No cubic geometric counting theorem is asserted here.

## 1. The curve and its converse

For $\sigma_a(X)=aX+a^3$, use the potential $h=a^2Y$. The incidence $(a,h)$ is

```math
(X,Y)=\left(h/a^3-a^2,h/a^2\right).
```

Let a repeated diagonal color be $a$, let the other colors be $b=ar$ and $c=aqr$, and let the diagonal potentials be $h_1,h_2$. The two cross-edge equations are exactly

```math
h_2=rh_1+a^5r(r^2-1),\qquad
h_1=qrh_2+a^5qr(q^2r^2-1).
```

Equality of the two cross potentials is equivalent to

```math
h_2=q^2h_1,\qquad k=q^2r^2h_1.
```

Put

```math
A(q)=q^4+q^3+q^2+q+1,\qquad B(q)=q^2+q+1.
```

Eliminating $a^5/h_1$ gives

```math
(q-1)\left[A(q)r^2-q(q+1)r-B(q)\right]=0.
```

The relevant curve and potential ratio are therefore

```math
A(q)r^2-q(q+1)r-B(q)=0,\qquad
F(q,r):=\frac{a^5}{h_1}=-\frac{A(q)}{qr(q+1)}.
```

Conversely, these equations imply both original cross-edge equations whenever the displayed denominators are nonzero. In fact, after substituting $F$, their numerators reduce respectively to

```math
q^4+q^3+B-A=0,\qquad q+1+q^2B-A=0.
```

This verification never divides by $r^2-1$ or by $q^2r^2-1$.

Sufficient nondegeneracy conditions are

```math
a\ne0,\quad h_1\ne0,\quad q\ne0,1,-1,\quad r\ne0,\quad A(q)\ne0.
```

They imply $r\ne1$ and $qr\ne1$: substitution into the curve gives respectively $q(q-1)(q+1)^2=0$ and $-(q-1)(q+1)^2=0$ after multiplication by $q^2$. Thus $a,b,c$ are pairwise distinct, while $q^2\ne1$ makes the diagonal columns distinct. The rows are distinct for the same reason. The resulting four-cycle has exactly three colors.

It would be an error to discard all cases $r=-1$ or $qr=-1$. For example, $r=-1$ is allowed when $q^2=-1$. Such configurations satisfy the converse equations. It is also unnecessary to require the three potential values $h_1,h_2,k$ to be pairwise distinct.

## 2. Square-root coordinates

In a fixed quadratic class, write

```math
h_1=\lambda u^2,\qquad h_2=\lambda v^2,\qquad k=\lambda w^2,
\qquad q=v/u,\quad r=w/v.
```

The curve becomes

```math
P_4(u,v)w^2-u^2v^2(u+v)w-u^2v^2P_2(u,v)=0,
```

where

```math
P_4=u^4+u^3v+u^2v^2+uv^3+v^4,\qquad P_2=u^2+uv+v^2.
```

The hidden fifth-power equation is

```math
a^5=-\lambda\frac{P_4(u,v)}{w(u+v)}.
```

To avoid repeated columns one must exclude both $u=v$ and $u=-v$. One way to do so is to take the first two root sets from disjoint sets of potential values in the same quadratic class. Each actual ordered configuration has exactly two lifts $(u,v,w)$, differing by simultaneous sign. The number of fifth-root witnesses must not be confused with the number of actual colors.

For reference, the four-output correspondence has a nonzero local Jacobian at $(u_1,u_2,v_1,v_2)=(1,-1,1,-1)$, taking the branch $r=1$ at all four positions. Write $w=uW(q)$, $q=v/u$. Its equation is

```math
A(q)W^2-q^2(q+1)W-q^2B(q)=0.
```

At $q=1$, $W=1$, implicit differentiation gives $W'=1/2$, hence $(w_u,w_v)=(1/2,1/2)$. At $q=-1$, $W=-1$, it gives $W'=1$, hence $(w_u,w_v)=(0,1)$. In the output order $(w_{11},w_{12},w_{21},w_{22})$ the four-variable determinant is $-1/4$. This proves a local dominance calculation in odd characteristic where the indicated derivatives are defined. These points are used only as an algebraic Jacobian certificate, not as admissible graph configurations. No separate-cover irreducibility claim follows from this calculation alone.

## 3. Exact deletion multiplicities

Count actual configurations $(a,q,r,h_1)$ satisfying Section 1. For a fixed nonzero incidence, each of its four possible roles gives at most twelve configurations. The following eliminations show this without a generic-fiber assumption.

For fixed $(a,h_1)$, put $z=a^5/h_1$. Then $r=-A/[zq(q+1)]$, and the curve gives

```math
A^3+zAq^2(q+1)^2-z^2Bq^2(q+1)^2=0.
```

For fixed $(a,h_2)$, put $z=a^5/h_2$. Then $r=-A/[zq^3(q+1)]$, and

```math
A^3+zAq^4(q+1)^2-z^2Bq^6(q+1)^2=0.
```

For fixed $(b,k)$, put $z=b^5/k$. Then

```math
z=-\frac{Ar^2}{q^3(q+1)},\qquad
r=-\frac{zq^3(q+1)+B}{q(q+1)},
```

and

```math
A[zq^3(q+1)+B]^2+zq^5(q+1)^3=0.
```

For fixed $(c,k)$, put $z=c^5/k$. Then

```math
z=-\frac{Aq^2r^2}{q+1},\qquad
r=-\frac{z(q+1)+Bq^2}{q^3(q+1)},
```

and

```math
A[z(q+1)+Bq^2]^2+zq^4(q+1)^3=0.
```

These polynomials have degree twelve and nonzero leading coefficients, respectively $1,1,z^2,1$. In every case the value of $q$ uniquely recovers $r$ and the remaining configuration. Thus one omitted incidence destroys at most $48$ configurations.

A fixed color has three possible roles. For each ratio $q$ the curve has at most two branches $r$, because $A(q)\ne0$. The other parameters are then uniquely recovered. Consequently one omitted color destroys at most $6p$ configurations.

If $N_{\rm cubic}(H)$ counts the actual nondegenerate equal-cross configurations in the full eligible system, a selected simple proper graph with every four-cycle rainbow therefore satisfies

```math
N_{\rm cubic}(H)\le48R+6pD,
```

where $D$ is the number of omitted colors and $R$ the number of omitted eligible incidences among the remaining colors. This is an exact combinatorial implication, but no lower bound for $N_{\rm cubic}(H)$ is claimed in this checkpoint. The stronger propriety-only result makes such a lower bound unnecessary for the full-palette application.
