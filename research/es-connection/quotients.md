# Smallest abelian shift group for the 17-point ES coordinates

For the fixed integer coordinates in the octagon example, the smallest finite abelian group into which an affine homomorphism sends the 17 points to distinct, progression-free shifts has **285 elements**. Its kernel is unique. A cyclic realization is
$$
 (x,y)\longmapsto 5x+57y\pmod{285}.
$$
Consequently the regular bipartite shift graph uses **570 vertices, 4,845 edges and 17 colors**. All **11,400 four-cycles** are rainbow. This minimizes the number of vertices for this translation construction on these particular coordinates. [ES witness](octagon-anchor.json) · [Two independent enumerations](check_quotients.py)

A common translation of the shifts does not affect the progression condition. Replace a target by the image of the homomorphism from $\mathbb Z^2$. Its kernel is a finite-index sublattice. In Hermite normal form it has basis $(a,0),(b,c)$ with $a,c>0$, $0\le b<a$ and $ac$ equal to the index. Indeed take $a$ as the least positive horizontal period, $c$ as the least positive ordinate, and choose its horizontal coordinate in $[0,a)$. These choices determine the lattice, since subtracting a multiple of $(b,c)$ makes every remaining lattice vector horizontal. At index $m$ this enumerates precisely $\sum_{a\mid m}a$ kernels.

A valid lattice must avoid all nonzero differences $P_i-P_j$ between distinct points and all $P_i+P_j-2P_k$ with the indices not all equal. Endpoints $i=j$ are included to cover elements of order two. These conditions ensure that $s-D$ and $s+D$ cannot both be shifts for $D\ne0$ and $s$ a shift. They are also necessary for this exact shift coloring: such a pair produces a rectangle with the two opposite edges of color $s$.

The first test reduces each point to $(x-b\lfloor y/c\rfloor\bmod a,\,y\bmod c)$, checks distinctness, and tests whether reflecting any projected point through a different projected point stays in the set. The second test generates 2,438 distinct forbidden vectors in the integer lattice. For each $(a,c)$ and forbidden vector $(x,y)$ with $c\mid y$, it excludes all $b$ solving $(y/c)b\equiv x\bmod a$. These independently implemented tests agree on each of the **73,441** lattices of index at most 299. All **66,371** lattices of index below 285 fail. The entire accepted list, as $(m,a,b,c)$, is $(285,57,0,5)$ and $(299,299,20,1)$.

In the first quotient the two moduli are 57 and 5, which are coprime. The displayed cyclic map has the same kernel. Its shifts in increasing order are
$$
1,20,44,52,73,89,111,114,157,163,181,190,193,228,240,245,271.
$$
The 299-element example is the smallest cyclic target with an invertible coefficient of $x$. The difference comes from allowing both coordinates to have noninvertible coefficients. Keep this coordinate restriction distinct from requiring a cyclic target, since both groups here are cyclic. [Earlier 299-element construction](../neighborhood-packing/geometric-lower.md)

The cycle count was obtained directly from pairs of graph rows and independently as $(285/2)\sum_{D\ne0}\binom{r(D)}2$, where $r(D)$ is the number of ordered shift differences equal to $D$. Run the checker from this directory with python3 and the standard library.
