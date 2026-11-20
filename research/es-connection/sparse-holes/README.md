# The cube-root threshold for nearly complete blocks

Let $Q(B)$ be the least number of colors on a $t$-by-$t$ bipartite board $B$ for which every occupied rectangle is rainbow. Suppose the omitted cells form an $h$-regular bipartite graph, with $h\ge1$.

* If $h=o(t^{1/3})$, then **every** such board has $Q(B)=(1/3+o(1))t^2$.
* At $t=s^3$ there are boards with exactly $3s-2$ omissions per row and column and **$Q(B)=t^2/6+O(t^{5/3})$**.

Thus gaps on the cube-root scale can halve the leading palette cost. The Hamming-distance construction below gives the matching lower and upper coefficient for that particular board. This is a local result about blocks used to construct #810 graphs. The unrestricted problem asks whether an entire graph can have positive edge density with a palette linear in its order. [ES block constructions](../crown-lifts.md) · [Erdős problem 810](https://www.erdosproblems.com/810)

## A three-step walk in the graph of omitted cells

Write $D$ for the bipartite graph of holes. Call an occupied cell $(r,c)$ near if there is a path of length three from $r$ to $c$ in $D$. Each row is the start of at most $h(h-1)^2$ nonbacktracking paths of length three when the maximum degree is $h$. There are therefore at most $t\,h(h-1)^2$ near occupied cells.

For $t\ge2h+2$, the coloring is proper. Two incident edges have at least $t-2h\ge2$ common choices on the other side for completing a rectangle, including the endpoint already in use. Now fix a color class and index its matching edges $(r_i,c_i)$. Between any two indices orient $i\to j$ when $(r_i,c_j)$ is absent, choosing one direction if both cross cells are absent. A direction always exists. A transitive triple $a\to b\to c$, $a\to c$ gives the path $r_b,c_c,r_a,c_b$ of missing cells. Its middle index $b$ is near. In any four indices, mark three and look at their orientations to the fourth. Two have the same orientation to it, and the arc between those two puts one of them in the middle of a transitive triple. Thus a class has at most three far cells, and a class of size at least four has at most two. Lean checks the marked-triple argument. [Lean proof](../../hall-reduction/SparseHoleColors.lean)

For every board with at most $h$ holes per row and column this proves
$$
Q(B)\ge\frac{t(t-h)-t\,h(h-1)^2}{3}.
$$
If $D$ is $h$-regular, Hall's theorem gives an omitted perfect matching. Relabel it as the diagonal. To color all other cells, embed the $t$ indices into the least $m\ge t$ with $m\equiv3\pmod 6$, so $m\le t+5$. A Steiner triple system partitions all unordered pairs of the $m$ symbols into triples. Use one color for each orientation of each triangle. Its three directed arcs share no endpoint as bipartite edges, and one crossed cell of each pair lies on the omitted diagonal. Restriction to the given board yields $Q(B)\le m(m-1)/3$. Together the estimates prove the first assertion.

The construction in the verifier uses the classical Bose triples. Write $m=3q$ with $q$ odd. On $\mathbb Z_q\times\mathbb Z_3$, take the vertical triples over each $x$, and for each $x\ne y$ and layer $i$ take the two points $(x,i),(y,i)$ together with $((x+y)/2,i+1)$. Use each unordered $x,y$ once. A pair in two consecutive layers with different first coordinates determines the other point uniquely, which verifies the pair partition. [Bose, 1939](https://doi.org/10.1111/j.1469-1809.1939.tb02219.x)

## An extremal calculation for the Hamming board

Index the rows and columns by $[s]^3$. Omit $(x,y)$ if the triples differ in at most one coordinate. There are $1+3(s-1)=3s-2$ omissions at each vertex. Two edges of the same color with different row and column endpoints must have at least one cross pair agreeing in two or three coordinates. An edge with all three coordinates different will be called a distance-three cell.

**At most six distance-three cells can have the same color.** This finite statement holds for every alphabet size. For seven putative cells use 14 symbols in each coordinate for all row and column entries. Select, for each pair of cells, which cross pair is missing and two coordinates that agree there. The C++ search propagates those equalities as equivalence classes. It rejects a branch when it equates the endpoints of a distance-three cell in one coordinate, or forces two whole rows or columns to agree. At a surviving leaf, distinct equivalence classes can be assigned distinct symbols in each coordinate. This procedure is exhaustive. The first pair's orientation and exceptional coordinate can be fixed by permuting cells and coordinates. On seven cells it excludes all branches in **50,422 nodes**. Six cells are attainable. [Equality search](hamming_classes.cpp)

A second encoding uses 399 Boolean variables and 3,612 clauses, with all pair orientations left free. It enforces the three equivalence relations by transitivity, a distinct symbol at each end of every coordinate, row and column properness, and one satisfied cross choice per edge pair. CaDiCaL found the formula unsatisfiable. DRAT-trim verified the refutation with 43,270 core lemmas. The CNF SHA-256 is `0506c531d020fdec215540774907c4e4f3813ed289d513fd36280f822b34d670`. [Independent SAT encoder](hamming_cnf.py)

There are $[s(s-1)]^3$ distance-three cells. For $s\ge3$ properness follows from $t\ge2h+2$, so the palette is at least $[s(s-1)]^3/6$. The upper construction partitions cells by a Steiner triple on the symbols in each differing coordinate. On any three fixed symbol triples, each coordinate has six directed edges between different symbols. The certificate partitions all $6^3=216$ possible triples of directed edges into **36 classes of six**. The verifier checks row and column distinctness and one missing cross cell for every pair in every class. Use fresh colors for each triple of symbol triples. Each compatible pair stays compatible in the full Hamming board because its missing cross pair agrees in at least two actual coordinates. [Partition certificate](cube-partition.txt) · [C++ verifier and construction](hamming_blocks.cpp)

For distance-two cells, first fix the equal coordinate and its value. For each differing coordinate, fix a symbol triple and one of its two directed triangles. The nine combinations of two arcs have distinct rows and columns. A difference between arc choices in either coordinate gives a cross equality there, and the fixed coordinate gives a second equality at the same cross pair. One fresh color suffices for all nine cells.

For $s\equiv3\pmod6$, writing $b=s(s-1)/6$, the upper palette is
$$
36b^3+3s(2b)^2=\frac{s^3(s-1)^2(s+1)}6.
$$
For arbitrary $s$, embed the symbols in the least $m\equiv3\pmod6$ above $s$ and restrict. Replacing $s$ by $m\le s+5$ in the upper bound changes the leading $s^6/6$ by $O(s^5)$. Together with the distance-three lower bound this proves the second assertion. For $s=3$ the construction uses 72 colors on 540 occupied cells of the 27-by-27 board.

## How much can be saved below the threshold?

The order of the error term in the universal lower bound is attainable on infinite families. Let $b=s^3$, take $L\equiv3\pmod6$ groups of $b$ indices each, and set $t=Lb$. Omit the Hamming holes inside every group and retain all cross-group cells. The hole graph is regular of degree $h=3s-2$. Use disjoint palettes inside the groups. For cells between groups, take the Bose triples of the $L$ group indices. In an oriented group triple $(A,B,C)$ identify indices within each group with $\mathbb Z_b$. For every $x,y$, put the arcs $(A,x)\to(B,y)\to(C,x+y)\to(A,x)$ in one class. Use the reverse directed triangles for the other orientation. This covers every cross-group cell exactly once, with $L(L-1)b^2/3$ colors. Every pair in a class has a missing crossed diagonal cell.

The upper palette is therefore $t^2/3-tb/6+O(Lb^{5/3})=t^2/3-th^3/162+O(th^2)$. The constant in the error is independent of $L$. The universal lower bound gives $Q(B)\ge t^2/3-O(th^3)$. Consequently the possible saving below $t^2/3$ has order $th^3$ along these families as $s$ grows, even if $L$ also grows and $h=o(t^{1/3})$. Taking an arbitrarily large fixed $L$ shows that, for every constant $c>0$, regular holes of degree at most $ct^{1/3}$ can already save a positive fixed fraction of the quadratic palette.

## Reproduction

Run the commands below in this directory. The second pair of tools accepts the generated DIMACS instance and an independently checkable proof file. [CaDiCaL](https://github.com/arminbiere/cadical) · [DRAT-trim](https://github.com/marijnheule/drat-trim)

```sh
c++ -O3 -std=c++17 hamming_classes.cpp -o /tmp/810-hamming-classes
c++ -O3 -std=c++17 hamming_blocks.cpp -o /tmp/810-hamming-blocks
/tmp/810-hamming-classes 6
/tmp/810-hamming-classes 7
/tmp/810-hamming-blocks 3 < cube-partition.txt
python3 hamming_cnf.py 7 > /tmp/810-seven.cnf
cadical /tmp/810-seven.cnf /tmp/810-seven.drat
drat-trim /tmp/810-seven.cnf /tmp/810-seven.drat
```
