# Missing edges across shadow cuts in the (7,4) problem

Let $g(n;7,4)$ be the largest number of distinct triples on $n$ points such that any four triples have union of size at least eight. A system is *linear* if distinct triples meet in at most one point.

The graph-limit argument gives an asymptotic upper coefficient of **$1/18$** for unrestricted systems. Lean now verifies this coefficient end to end. [One-eighteenth proof](eighteenth.md) · [Lean theorem](../hall-reduction/HalfBoundedModel.lean)

**First finite bound.** For $n\ge 10^6$, every admissible linear system has fewer than $0.07384 n^2$ triples. For arbitrary admissible systems,
```math
g(n;7,4)<0.07384 n^2+n/2.
```
In particular the unrestricted upper density is at most $0.07384$. Gishboliner and Solymosi prove the leading coefficient $2/27=0.074074\ldots$ for linear systems. Their local estimate supplies the starting point. The argument below also counts absent edges across a cut associated with each pair. The positive-density question for this problem and Erdős #810 remains open. [Gishboliner and Solymosi, Theorem 1.1 and Corollary 1.3](https://arxiv.org/html/2606.25931v1) · [Santos and Tyomkyn, §4](https://arxiv.org/abs/2508.09841)

Keeping the three degree deviations in the upper count and counting repeated colors in the lower count improves the coefficient to **0.07360** with the same finite cutoff. [Refined bound](refinement.md)

The full formal proof gives **0.07354**, with an explicit bound for both linear and unrestricted triple systems. [Theorem and proof](verified.md)

The subsequent asymptotic coefficient is **0.073272**. [Width contraction and variance tradeoff](width.md)

## The defect of a triple

Fix an admissible linear system $H$ with $m>0$ triples. Its shadow is the simple graph $G$ of pairs lying in a triple. Write $N_x$ for the open neighborhood of $x$ in $G$, and $d_x$ for the number of triples containing $x$. Then $|N_x|=2d_x$ and $|E(G)|=3m$. Color each shadow edge by the third point of its unique triple. The coloring is proper by linearity. If opposite edges of a four-cycle had the same color, that point would be outside the cycle. The four cycle edges would belong to four distinct triples on at most seven points. Hence every four-cycle is rainbow. [Formal shadow reduction](../hall-reduction/ShadowReduction.lean)

For a triple $e=\{x,y,z\}$ put $S_e=d_x+d_y+d_z$ and $D_e=2n+3-3S_e$. For each of its three pairs $xy$, define
```math
c_{xy}=|N_x\cap N_y|,\quad b_{xy}=|V\setminus(N_x\cup N_y)|,\quad
\ell_{xy}=|N_x\mathbin\triangle N_y|,\quad q_{xy}=2n/3-\ell_{xy}.
```
Put $t_{xy}=c_{xy}-1$, subtracting the common neighbor $z$. Each of the remaining common neighbors determines a triple through $x$ and a different triple through $y$, both meeting $e$ in just their specified root point. Those two triples meet outside $e$ at precisely the chosen common neighbor. Conversely each such intersection gives that common neighbor.

A triple $f\ne e$ through $x$ can participate in at most one such intersection, counting both possible root points $y,z$. Indeed, $e\cup f$ has size five. Each additional triple through $y$ or $z$ which meets $f$ outside $e$ adds at most one point. Two distinct such triples would give four triples on at most seven points. One such triple cannot intersect $f$ twice by linearity. Consequently
```math
u_x=d_x-1-t_{xy}-t_{xz}\ge0.
```
Define $u_y,u_z$ cyclically and $s=u_x+u_y+u_z$. Eliminating the three $t$'s and using $\ell_{xy}=2d_x+2d_y-2c_{xy}$ gives
```math
2c_{xy}=d_x+d_y-d_z+1-s+2u_z,\qquad
q_{xy}=D_e/3-s+2u_z.
```
For any three vertices, each point contributes either zero or two disagreements among their three adjacency indicators. Thus the sum of the three distances is at most $2n$. Summing the expressions for $q$ gives $0\le\sum_{xy\subset e}q_{xy}=D_e-s$, so $0\le s\le D_e$. Also $c_{xy}\le\min(d_x,d_y)$, by the definition of $u_x,u_y$. Since $d_z\ge1$ and $3S_e\le2n+3$, we have $c_{xy}\le n/3$. Finally, $u_z\le s$ implies
```math
(q_{xy})_+\le (D_e-s)/3+4u_z/3,\qquad
\sum_{xy\subset e}(q_{xy})_+\le4D_e/3.
```
Writing $D=\sum_eD_e$ gives $D=(2n+3)m-3\sum_x d_x^2$.

## Missing pairs across a cut

For any triangle $T$ of $G$, let $Q(T)$ count points with zero or three neighbors in $T$. The disagreement count, now applied to $T$, gives $2Q(T)=\sum_{xy\subset T}q_{xy}$. For each edge $xy$ let $L_{xy}$ count missing edges between $C=N_x\cap N_y$ and $B=V\setminus(N_x\cup N_y)$. A missing pair $zw$ with $z\in C$, $w\in B$ corresponds to the triangle $xyz$ and a point $w$ adjacent to none of that triangle. Each triangle and such a point occur for exactly three choices of $xy$. Each graph edge belongs to $c_{xy}$ triangles. These counts and the bounds above imply
```math
L:=\sum_{xy\in E(G)}L_{xy}
\le3\sum_T Q(T)=\tfrac32\sum_{xy\in E(G)} c_{xy}q_{xy}
\le\tfrac32\tfrac n3\sum_e\sum_{xy\subset e}(q_{xy})_+
\le\tfrac23 nD. \tag{1}
```

For the same edge write $c=|C|$, $b=|B|$. In a proper rainbow-four-cycle coloring with $n$ colors, the rectangle inequality gives
```math
[n(c+b)+cb] e_G(C,B)\le ncb(c+b+1).
```
The two sets are disjoint, so $L_{xy}=cb-e_G(C,B)$. Subtracting gives $[n(c+b)+cb]L_{xy}\ge cb(cb-n)$. Put $p=cb/n^2$, $a=(c+b)/n$. Then $L_{xy}/n^2\ge p^2/(a+p)-1/n$, with the empty cut covered directly. Expanding the square $(p-t(a+p))^2\ge0$ gives, for any real $t$,
```math
L_{xy}/n^2\ge (2t-t^2)p-t^2a-1/n.
```
Here is the finite rectangle inequality used in this step. [Rectangle bound](../hall-reduction/RectangleBound.lean)

## Degree moments and the numerical gap

Use a uniform unordered shadow edge $xy$. Set $P=\mathbb E[p]$, $A=\mathbb E[a]$, $\rho=3m/n^2$, $\Delta=D/n^3$, and $v=n^{-1}\sum_x(d_x/n-\rho)^2$. The preceding lower bound and the degree-sum identity give
```math
L/n^4\ge\rho[(2t-t^2)P-t^2 A-1/n],\qquad
\Delta+3v=\rho(2/3+1/n-3\rho). \tag{2}
```
In particular $\rho\le2/9+1/(3n)$. As $a=1/3+q_{xy}/n$ and the sum of $q$ on each triple is between zero and $D_e$, we have
```math
1/3\le A\le1/3+\Delta/\rho.
```
For $X=(d_x+d_y)/n-2\rho$ we have $\mathbb E[X]=2v/\rho$. Indeed, a point $x$ occurs on exactly $2d_x$ shadow edges, and $\sum_x d_x=3m$. Also $\mathbb E[X^2]\le2v/\rho$. To see this, put $s_x=d_x/n-\rho$ and sum $(s_x+s_y)^2\le2(s_x^2+s_y^2)$ over edges. Each $s_x^2$ occurs $2d_x\le n$ times.

The identity $c-b=2d_x+2d_y-n$ now gives
```math
4P=\mathbb E[a^2]-\mathbb E[(4\rho-1+2X)^2]
\ge 1/9-(1-4\rho)^2-8v/\rho\qquad(\rho\le1/4). \tag{3}
```
We used $\mathbb E[a^2]\ge A^2\ge1/9$ and $(4\rho-1)\mathbb E[X]\le0$.

Suppose $m/n^2\ge0.07384$, $n\ge10^6$. Set $r_0=3(0.07384)$, $r_1=2/9+1/(3\cdot10^6)$ and $D_0=r_1(2/3+10^{-6}-3r_0)$. Then $r_0\le\rho\le r_1<1/4$, $\Delta\le D_0$ and $3v\le D_0$. It follows that
```math
A\le A_0=1/3+D_0/r_0,\qquad
P\ge P_0=[1/9-(1-4r_0)^2-8D_0/(3r_0)]/4.
```
Take $t=1/16$. The lower bound in (2) is at least $r_0[(2t-t^2)P_0-t^2 A_0-10^{-6}]$, which is positive. Subtracting the upper bound $2D_0/3$ from (1) gives exactly
```math
\frac{45494507793931}{2592000000000000000}>0.
```
This contradiction proves the linear bound. The checker below evaluates these rational numbers and independently counts the quantities in finite examples. [Exact arithmetic and finite checks](check_counts.py)

## Removing pairs of overlapping triples

In an arbitrary admissible system, remove both members of a pair of distinct triples sharing two points and repeat until the system is linear. Each removed pair occupies four points. The supports of different pairs are disjoint, since otherwise their four distinct triples would occupy at most seven points. There are therefore at most $n/4$ removed pairs and at most $n/2$ removed triples. Applying the linear bound to the remaining system gives the claimed inequality.
