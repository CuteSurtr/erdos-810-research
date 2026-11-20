# Quantitative stability at the one-eighteenth bound

Let $W$ be a graphon limit of shadows of linear $(7,4)$-free triple systems. Set $p=\int W$ and $\delta=1/3-p$. The limiting triple density is $p/6$, so the gap below $1/18$ is $\delta/6$. For a partition $\mathcal P$ of $[0,1]$ into three sets, let $K_\mathcal P$ equal $1/2$ between different sets and zero within them.

There is a partition $\mathcal P$ such that
$$
 \|W-K_\mathcal P\|_1=O(\delta),\qquad
 \max_{A\in\mathcal P}\bigl||A|-1/3\bigr|=O(\sqrt\delta).
$$
There is also a partition $\mathcal Q$ into exactly equal thirds with $\|W-K_\mathcal Q\|_1=O(\sqrt\delta)$. All constants are absolute. These estimates concern the limiting kernels. A finite shadow has a zero-one adjacency matrix and is compared to its limit in cut distance. [One-eighteenth theorem and equality case](eighteenth.md)

## Rounding the kernel

The proof uses only $0\le W\le1/2$ and $T\le D_2/4$, where $T=\int W(x,y)W(x,z)W(y,z)$ and $D_2=\int d_W(x)^2\,dx$. All integrals use independent uniform coordinates in $[0,1]$. Put $V=1-2W$ and
$$
 I=\int (1-V(x,y))V(x,z)V(y,z).
$$
Expanding gives $I=2p-8D_2+8T$. Since $I\ge0$ and $D_2\ge p^2$, we have $3D_2\le p$ and $I\le 6p\delta\le2\delta$. Also
$$
 \int(d_V-1/3)^2=4(D_2-2p/3+1/9)\le4\delta/3.
$$
For $a=V(x,z)$ and $b=V(y,z)$, expand $a+b-2ab=(a-b)^2+a(1-a)+b(1-b)$. On integrating against $V(x,y)$ the left side is $2I$. The two fractional terms are equal by symmetry. Hence
$$
 \int d_V(x)V(x,z)(1-V(x,z))\,dx\,dz\le I.
$$
The rows with $d_V(x)<1/6$ have measure at most $48\delta$. Their contribution to $\int V(1-V)$ is at most $12\delta$. The remaining rows contribute at most $6I$. Rounding $V$ at $1/2$ to the zero-one kernel $B$ therefore costs $\|V-B\|_1\le 2\int V(1-V)\le48\delta$.

The rounded kernel satisfies $\int(d_B-1/3)^2\le99\delta$. Indeed $\int(d_B-d_V)^2\le\|B-V\|_1$, since an absolute row difference is at most one. The density $i$ of one specified induced two-edge path in $B$ is at most $8I\le16\delta$: wherever its integrand is one, the corresponding three factors for $I$ are each at least $1/2$.

## Selecting three neighborhoods

For a point $z$ let $N(z)=\{x:B(x,z)=1\}$. Define $h(z)$ as the missing mass within $N(z)^2$ plus twice the occupied mass from $N(z)$ to its complement. By permuting the three variables the integral of $h$ is $3i=O(\delta)$.

Start with the whole space as the remainder $R$. At each of three steps pick $z\in R$ and take $A=N(z)\cap R$ as the next part. Suppose at the start of the step that $|R|\ge1/4$ and the occupied mass from $R$ to its complement is $O(\delta)$. These properties hold initially. The integral over $z\in R$ of
$$
 h(z)+(d_B(z)-1/3)^2+\int_{R^c} B(z,x)\,dx
$$
is $O(\delta)$, so some such $z$ has the entire displayed sum $O(\delta)$. Then $|A|=1/3+O(\sqrt\delta)$. The cost of filling $A^2$ and clearing both orientations between $A$ and $R\setminus A$ is at most $h(z)$. Thus the occupied mass between the next remainder and its complement stays $O(\delta)$. For sufficiently small $\delta$, the first two steps leave enough mass to choose the next point. Only three steps are used.

The final leftover set $S$ has $|S|=O(\sqrt\delta)$ and sends $O(\delta)$ occupied mass outside itself. In fact $|S|=O(\delta)$. When $|S|<1/12$, every row of $S$ with $d_B\ge1/6$ sends at least $1/12$ of its mass outside $S$. The other rows occupy measure $O(\delta)$ by the degree estimate for $B$. Adding $S$ to any one of the three parts costs at most $2|S|$. We have edited $B$ into the union of three complete parts at $L^1$ cost $O(\delta)$. Complementing and dividing by two gives the first conclusion for $W$. Moving $O(\sqrt\delta)$ mass between the parts makes them exactly equal and changes the model by $O(\sqrt\delta)$ in $L^1$. For $\delta$ bounded away from zero the claims follow by enlarging the constants.

## Sharpness for the two input inequalities

For three parts of sizes $1/3+t,1/3-t,1/3$ take $W=K_\mathcal P$. Then $p=1/3-t^2$, $I=0$, and $3D_2-p=-t^2/2$, so both input inequalities hold. Every equal-thirds model has constant degree $1/3$. Its $L^1$ distance from $W$ is at least $\int|d_W-1/3|=t/3$. This gives the square-root order for balanced parts.

For equal parts, take $W$ equal to $1/2-u$ between parts and zero within, with $0<u<1/4$. Writing $a=1/2-u$, we have $p=2a/3$, $T=2a^3/9\le D_2/4=a^2/9$, and $\delta=2u/3$. Any model taking values in $\{0,1/2\}$ costs at least $u$ on the original between-part cells, hence at least $2u/3=\delta$ in total. This gives the linear order when part sizes are free. Whether either family of kernels is realized by admissible triple systems is open.

An exact-integer C++ checker verifies the path identity, its rounding inequality and the pivot identity on 74,674 symmetric step kernels. It also checks the degree and density formulas for 1,274 unequal-part examples. The argument above supplies the proof for arbitrary kernels. [C++ checker](check_stability.cpp)

```sh
c++ -O2 -std=c++17 check_stability.cpp -o /tmp/check_shadow_stability
/tmp/check_shadow_stability
```
