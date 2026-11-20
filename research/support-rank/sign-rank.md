# Strict sign rank and rainbow four-cycles

The **sign rank** of a graph is the minimum real rank of a square matrix strictly positive on edges and strictly negative on nonedges, including the diagonal. Its entries need not be symmetric. With $n$ vertices, at most $n$ colors and every four-cycle rainbow, the extremal edge counts at the first four sign-rank budgets are as follows.

| Sign rank at most | Maximum edge count |
| --- | --- |
| 1 | $n-1$ for $n\ge5$ |
| 2 | $n\log n+O(n)$ |
| 3 | $\Theta(n^{3/2})$ |
| 4 | $\Theta(n^{3/2})$ |

Every fixed rank $r\ge5$ gives the upper bound $O_r(n^{2-1/(\lfloor(r-1)/2\rfloor+1)})$. The arguments use strict signs, so this result applies to a different representation from the [matrix required to vanish on nonedges](README.md).

## From strict signs to incidences

Factor an admissible matrix as $A_{ij}=x_i\cdot y_j$ in $\mathbb R^r$, padding by zero coordinates when necessary. Choose a linear functional $f$ nonzero on every $x_i$; finitely many proper hyperplanes cannot cover the space. Split the rows by the sign of $f(x_i)$ and normalize to the affine chart $f(x)=1$. On each part positivity is an affine halfspace test in dimension $r-1$, reversing the inequality on the negative part. Empty and full tests can be represented by halfspaces missing or containing all sampled points. Strictness and finiteness allow duplicate points and halfspaces to be perturbed independently into distinct ones while preserving every incidence.

With $q$ colors, set $t=\lfloor\sqrt q\rfloor+1$ for $q\ge1$. No positive $t$ by $t$ submatrix exists, since all its $t^2$ entries would require different colors. Row and column vertex sets in an all-positive rectangle are disjoint because the graph is loopless. Each of the two incidence graphs therefore excludes $K_{t,t}$. For dimension at most three Chan and Har-Peled prove an upper bound $O(t(u+v))$ for $u$ points and $v$ halfspaces. The two charts give $m=O(n\sqrt q)$ for sign rank at most four. For $r\ge5$ put $h=\lfloor(r-1)/2\rfloor$. Their higher-dimensional bound gives
$$
m=O_r\!\left(q^{1/(h+1)} n^{2h/(h+1)}+n\sqrt q\right).
$$
Substituting $q=n$ gives the claimed exponents. [Chan and Har-Peled, Lemmas 3.10 and 3.12](https://sarielhp.org/p/22/klan/klan.pdf) · [Complete rectangle bound in Lean](../hall-reduction/IntervalWindows.lean)

The rank-three lower bound already follows from graphs with one interval per open neighborhood in a common ordering. For the interval $[\ell_i,h_i]$, the column polynomial $(j-\ell_i+1/2)(h_i+1/2-j)$ realizes exactly its sign pattern. Use the constant $-1$ for an empty row. This matrix has rank at most three, with column coordinates $(1,j,j^2)$. The interval construction attains $n^{3/2}+O(n)$ edges. For general $q$, disjoint balanced $K_{b,b}$ with $b$ of order $\min(\sqrt q,n)$ give $\Omega(n\min(\sqrt q,n))$ edges by giving each edge a distinct color within its component. Their rows also have interval neighborhoods in a common ordering. [Sharp interval construction](../interval-neighborhoods/README.md)

## The one-dimensional affine charts

At sign rank two the chart for each row group is a line. Each column trace is an initial or final segment in a single order of the rows, or is empty or full. Split the columns according to the direction of the ray, assigning constant traces to either part. This partitions the full incidence matrix into at most four Ferrers boards.

On a Ferrers board with $a$ rows and $b$ columns, sort row lengths $d_i$ in decreasing order. If $i,d_i\ge2$ then $id_i\le q$, by the complete rectangle condition. The first row and the rows of length one add at most $a+b$. The other rows contribute at most $\sum_{i=1}^a\min(b,q/i)$. Its upper integral is at most $q(1+\log^+(ab/q))$ where $\log^+ z=\max(0,\log z)$. Summing the boards gives $m=O(n+q(1+\log^+(n^2/q)))$.

This order is sharp for every $1\le q\le n^2$ after capping by $n^2$. For a balanced board of side $b=\lfloor n/2\rfloor$, use the cells $ij\le q$. They admit a proper rainbow coloring in at most $q$ colors by the interval-coloring construction for chain graphs. To realize the **whole symmetric graph** with sign rank two, put all left vertices first in increasing $i$, followed by all right vertices in decreasing $j$. A right vertex sees exactly a prefix of the left vertices; a left vertex sees exactly a suffix of the right vertices. Each column is therefore the sign of an affine function of the row position. An isolated padding vertex can be placed between the two parts. [Ferrers coloring and integral estimate](../neighborhood-packing/vc-one.md)

For $b\le q\le b^2$, the integral estimate gives order $q(1+\log(b^2/q))$ up to an $O(n)$ rounding loss. If $q\ge b^2$ use the complete board. For $q<b$ the nonempty hyperbola rows through $q$ give order $q(1+\log q)$. The term $q\log(n/q)$ is $O(n)$, and a star gives $n-1$ edges at one color.

## Eight vertex deletions suffice at rank two

There is a sharper structural description at $q=n$. Every rainbow graph of sign rank at most two can be made a single bipartite chain graph by deleting at most **eight vertices**. This gives the leading coefficient one in the table.

Write $d$ for the minimum degree and assume $n\ge5$ and $d\ge3$. In the two affine charts above, each column has at least $\lceil d/2\rceil$ neighbors in one of its two row charts. On this chart choose a direction in which its neighbors form a prefix, allowing reverse order. At least $\lceil n/4\rceil$ columns choose the same chart and direction. Their nested neighborhoods contain the same $\lceil d/2\rceil$ rows. Both sides have at least two vertices, so $\lceil n/4\rceil\lceil d/2\rceil\le q$, giving $d\le8q/n$. In general $d\le\max(2,8q/n)$.

Choose a vertex $v$ of degree $d$ and delete its neighbors. All remaining row vectors now lie in the single open chart $x\cdot y_v<0$. On the chart line each remaining neighborhood is a prefix or a suffix of the same linear order. Since it excludes its own vertex, a prefix can only look to lower indices and a suffix to higher ones. An edge $i<j$ therefore joins a suffix vertex $i$ to a prefix vertex $j$. The suffix neighborhoods are nested and the prefix neighborhoods are nested, so the graph is a single chain graph with possible isolated vertices.

At $q=n$, the deletion removes at most $8n$ edges. A chain graph on at most $n$ vertices and palette $n$ has at most $F_n(\lfloor n/2\rfloor,\lceil n/2\rceil)$ edges, the balanced hyperbola count from the linked Ferrers result. That same board has a rank-two sign representation, giving matching upper and lower bounds up to $8n$. Since the balanced count is $n\log n+O(n)$, the coefficient follows. For $n<5$ the deletion assertion is immediate.

Lean verifies the palette count for the four classes of nested lists, and the edge-direction and nesting conclusions within one chart. The passage from the real factorization to those chart hypotheses and the deductions above have written proofs. [Chart lemmas in Lean](../hall-reduction/SignRankCharts.lean)

At rank one write $A_{ij}=x_i y_j$. The negative diagonal makes the sign of $y_i$ opposite to that of $x_i$. The graph is complete bipartite, or empty. If both sides have at least two vertices all edges need distinct colors. At $n\ge5$ and $q=n$, even the smallest such spanning cut has $2(n-2)>n$ edges. A star attains $n-1$.

## Side-of-line tests from the ES project

Testing which side of an oriented line contains a point records the sign of a planar determinant, the basic datum of the Erdős–Szekeres order type. If a #810 graph contains every prescribed point–halfplane incidence then it has $O(n\sqrt q)$ edges, even with repeated point or line classes. For an open or closed halfplane, an infinitesimal parallel shift resolves boundary points on the chosen side for a finite configuration. The order is sharp: arrange many small disjoint clusters around points in convex position and take halfplanes cutting off precisely one cluster each, giving a disjoint union of complete bipartite graphs. The published halfspace theorem supplies the upper bound directly on this single incidence board. The [point-on-line model](../neighborhood-packing/incidence.md) uses a different geometric predicate. Allowing arbitrary deletions from a halfplane incidence board can destroy its sign representation, so the bound assumes the retained adjacency is the prescribed incidence test.
