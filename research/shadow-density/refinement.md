# A coefficient of 0.07360

For $n\ge10^6$, a linear $(7,4)$-free system has fewer than $0.07360 n^2$ triples. For an arbitrary system the bound is $0.07360 n^2+n/2$. This improves the $2/27$ coefficient in the June 2026 paper for this specific configuration. The reduction to the linear case and the notation for the shadow graph, edge averages, and defects are given in the first proof. [Definitions and first proof](README.md) · [Gishboliner and Solymosi](https://arxiv.org/html/2606.25931v1)

## An upper bound using the degrees at all three points

Put $h=1/n$ and $a=5/17$. In this section all counts attached to one root triple are divided by $n$. Index its three points by $i$. Write $t_i$ for the common-neighbor count of the opposite pair after subtracting its third root point, and $u_i$ for the number of unused arms through $i$, with the same normalization. Put $p=\sum t_i$, $s=\sum u_i$, and $D=D_e/n$. The opposite-pair codegree is $c_i=t_i+h$. Its defect is $q_i=D/3-s+2u_i$. The normalized hyperdegree at point $i$ is $d_i=h+p-t_i+u_i$. In particular,
```math
0\le s\le D,\qquad D=2-6h-6p-3s,\qquad 3p+2s\le1.
```
We claim the following local estimate, where $\bar d$ is the mean of the three $d_i$:
```math
\sum_i c_iq_i\le(a+h)D+6a\sum_i(d_i-\bar d)^2. \tag{4}
```
The constant parts of the three $c_i$ contribute $h(D-s)\le hD$. If $p\le3a/4$, then
$\sum_i t_iq_i\le p(D/3-s)+2ps\le 4pD/3\le aD$.

In the other case $s\le(1-9a/4)/2=23/136$. Write $T_i=t_i-p/3$ and $U_i=u_i-s/3$. Then
```math
\sum_i t_iq_i=p(D-s)/3+2\sum_iT_iU_i,\qquad
T_i-U_i=\bar d-d_i.
```
The square inequality $2xy\le6a x^2+y^2/(6a)$ applied to $x=T_i-U_i$, $y=U_i$ gives
```math
2\sum_i T_i U_i\le6a\sum_i(d_i-\bar d)^2
          +(4/3+1/(9a))s^2.
```
Here $\sum_i U_i^2\le 2s^2/3$ because the $u_i$ are nonnegative. Now $p/3\le1/9\le a$ and $(4/3+1/(9a))(23/136)\le a$. These inequalities prove (4).

For each triple its mean minimizes the sum of squared deviations. Replacing $\bar d$ by the global mean $\rho$ and summing over triples gives
```math
\frac1{n^2}\sum_e\sum_{i\in e}(d_i-\bar d_e)^2
\le \frac1{n^2}\sum_x d_x^{\rm raw}(d_x^{\rm raw}/n-\rho)^2\le v/2,
```
since the unnormalized hyperdegree $d_x^{\rm raw}\le n/2$. The triangle count from the first proof gives $L/n^4\le (3/2)n^{-2}\sum_e\sum_i c_iq_i$. Consequently
```math
L/n^4\le\min\{2\Delta/3,\ (3/2)[a(\Delta+3v)+h\Delta]\}. \tag{5}
```

## A lower bound from pairs of edges of the same color

Consider the cut between the common-neighbor set $C$ and the set $B$ adjacent to neither endpoint of a fixed shadow edge. Write $c=|C|$, $b=|B|$, $e=e_G(C,B)$, and $l=cb-e$. Two edges of the same color in this cut have distinct endpoints by properness. At least one of their two off-diagonal pairs is missing, since a four-cycle must be rainbow. A missing pair $(z,w)\in C\times B$ can account for at most $c$ pairs of equally colored edges. Indeed choose their other endpoint $z'\in C$. The edge $z'w$ fixes the color, which determines at most one edge at $z$. If the cut has $k_j$ edges of color $j$, this gives
```math
\sum_{j=1}^n\binom{k_j}{2}\le cl,\qquad e^2\le n e+2ncl .
```
Now put $p'=cb/n^2$, $l'=l/n^2$, $c'=c/n$. Substitution and $l'\ge0$ give $(p')^2\le 2(c'+p')l'+hp'$. Completing a square, as in the first proof, gives for every real $t$
```math
l'\ge (2t-2t^2)p'-2t^2 c'-h/2.
```
The empty cut satisfies this directly. Let $C_0=\mathbb E[c']$ for a uniformly sampled shadow edge. The identity $c-b=2d_x^{\rm raw}+2d_y^{\rm raw}-n$ and the size-biased degree identity give $2C_0=A+4\rho-1+4v/\rho$. Thus
```math
L/n^4\ge \rho[(2t-2t^2)P-2t^2 C_0-h/2]. \tag{6}
```

## Exact numerical separation

Suppose $m/n^2\ge0.07360$. Set $h_0=10^{-6}$, $r_0=3(0.07360)$, $r_1=2/9+h_0/3$, and $B_0=r_1(2/3+h_0-3r_0)$. By the degree balance $\Delta+3v\le B_0$ and $r_0\le\rho\le r_1<1/4$. Divide $0\le v\le B_0/3$ into 24 equal closed intervals. For each interval $[v_-,v_+]$ put
```math
D_*=B_0-3v_-,\quad A_*=1/3+D_*/r_0,\quad
C_*=(A_*+4r_1-1+4v_+/r_0)/2,\quad
P_*=[1/9-(1-4r_0)^2-8v_+/r_0]/4 .
```
The degree-moment inequality of the first proof gives $P\ge P_*$. Also $C_0\le C_*$ and $\Delta\le D_*$. Substituting $t=9/100$ in (6), its parenthesis is positive on every interval. Subtract the upper bound $\min\{2D_*/3,(3/2)(aB_0+h_0D_*)\}$ from the lower bound $r_0[(2t-2t^2)P_*-2t^2C_*-h_0/2]$. The smallest of the 24 rational differences is
```math
\frac{8050469057694247}{459000000000000000000}>0.
```
This contradicts (5). Removing at most $n/2$ triples makes an arbitrary admissible system linear, as proved in the first note. The checker verifies the local upper bound, the color collision count and the numerical separation independently. [Exact checker](check_counts.py)

A subsequent end-to-end Lean proof sharpens this coefficient to $0.07354$. [Stronger theorem and verification](verified.md)
