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

## Counting transitive triples across all colors

There is a quantitative lower bound even above the cube-root scale. Suppose the coloring is proper, let $e$ be the number of occupied cells, let $q$ be the number of colors used, and write $a_r,b_c$ for the two hole degrees. Put
$$
P=\sum_{(r,c)\in D}(a_r-1)(b_c-1).
$$
Then
$$
\boxed{\quad q\ \ge\ \frac{e}{2+\sqrt{1+8P/e}},\qquad e\ \le\ 3q+P/2.\quad}
$$
The sum counts all nonbacktracking three-step hole paths from the row part to the column part. It may include paths ending at a hole.

Orient the missing crosses in each color class as above. A transitive triple $i\to j\to k$, $i\to k$ maps to the path $(r_j,c_k,r_i,c_j)$. The path recovers the middle edge $(r_j,c_j)$ and hence its color. Within that color, the row $r_i$ identifies the first edge and the column $c_k$ identifies the last. Thus paths from distinct transitive triples, including triples in different classes, are distinct. Lean checks the recovery step using only uniqueness of an edge in a cell and properness of each color. [Path recovery proof](../../hall-reduction/SparseHoleColors.lean)

A tournament on $m$ vertices has $\sum_v\binom{d^+(v)}2$ transitive triples, since each one has a unique source. Convexity gives at least $m(m-1)(m-3)/8$. The integer minimum occurs when outdegrees differ by at most one in the sum. For $m=2a$ its lower bound is $a(a-1)^2$, and for $m=2a+1$ it is $(2a+1)a(a-1)/2$. In particular every class contributes at least $2(m-3)$, proving the second inequality. For the first, select an occupied edge uniformly and let $M$ be the size of its class. The injection gives $\mathbb E[(M-2)^2]\le1+8P/e$, and Cauchy–Schwarz gives $\mathbb E[M]=\sum m^2/e\ge e/q$. The stated inequality follows by taking square roots. On the explicit 27-by-27 board, the C++ audit recovers 2,484 distinct paths from transitive triples. The integer tournament lower bound is 2,376 and the hole graph contains 6,804 nonbacktracking three-step paths. [Path audit](hamming_blocks.cpp)

For a regular board, $e=t(t-h)$ and $P=th(h-1)^2$. Thus $h=O(t^{1/3})$ forces a quadratic palette even when the implied constant is large. If $t^{1/3}=o(h)$ and $h=o(t)$, the bound is $(1/\sqrt{8}-o(1))t^{5/2}/h^{3/2}$. The injection uses only the rainbow condition that at least one crossed cell is missing. Alon, Moitra and Sudakov use three-step missing paths for bipartite graphs partitioned into induced matchings, in which *both* crossed cells are missing. Their Theorem 3.9 bounds the total missing edges for a partition into equal-sized induced matchings. [Alon, Moitra and Sudakov, §3.2](https://people.math.ethz.ch/~sudakovb/induced-matchings.pdf)

The necessary cube-root scale also holds for an irregular complement with average degree $h$. If $h=o(t^{1/3})$, choose a degree cutoff $D_0=o(t^{1/3})$ with $h/D_0=o(1)$. Discard rows and columns above the cutoff. Markov's inequality removes $o(t)$ on each side. The retained board has $(1-o(1))t^2$ occupied cells, maximum hole degree $D_0$, and at most $tD_0^3=o(t^2)$ three-step paths. Every incident pair of retained edges lies in a rectangle for large $t$. Hence $q\ge(1/3-o(1))t^2$. If $h=O(t^{1/3})$, cutting off at $4\max(h,1)$ retains at least three quarters of each side and at least $(9/16-o(1))t^2$ edges. This gives $P=O(t^2)$ and $q=\Omega(t^2)$. In particular a subquadratic palette on nearly complete boards requires $h/t^{1/3}\to\infty$.

## A price bound for holes given by group differences

Let the indices form an abelian group $G$ of order $t$. Omit the cells with $c-r\in D$, where $|D|=h$. Assume properness, which follows from the rainbow condition for $t\ge2h+2$. For $s\notin D$, let $m_s$ count representations
$$
s=a-b+c,\qquad a,b,c\in D,\quad a\ne b,\quad c\ne b,
$$
where the outer pair $\{a,c\}$ is an **unordered multiset** and $b$ is distinguished. Put $w_s=\max(0,2-m_s)$. Every color class has total weight at most **six** when its cell $(r,c)$ receives weight $w_{c-r}$. Consequently
$$
Q(B)\ \ge\ \left\lceil\frac{t}{6}\sum_{s\notin D}w_s\right\rceil
\ \ge\ \left\lceil\frac{t}{6}\left(2(t-h)-\frac{h^2(h-1)}2\right)\right\rceil .
$$
The second inequality counts $h$ choices of the middle label and $\binom h2$ unordered pairs with repetition from the other $h-1$ labels. For three holes this gives $\lceil t(2t-15)/6\rceil$ for **every** such abelian board. The local 32-by-32 ES block attains 262, the exact minimum over all abelian difference boards of that order with three holes per row. [ES certificates and applications](../sparse-blocks/README.md#the-cost-of-three-or-more-common-omissions)

**Proof.** Discard the zero-weight edges of a class and orient every pair of the remaining matching edges through a missing cross. A transitive triple $i\to j\to k$, $i\to k$ gives the three hole differences $a=c_k-r_j$, $b=c_k-r_i$, $c=c_j-r_i$. They satisfy $a-b+c=c_j-r_j$. For a fixed middle edge, the ordered triple of hole differences recovers $c_k$ and $r_i$, and the matching identifies $k$ and $i$. A weight-two edge can never be a middle. A weight-one edge can be a middle at most twice, since the two possible orders of its outer labels account for all its representations.

A tournament on six vertices has at least twelve transitive triples, by summing $\binom{d^+(v)}2$ over its vertices. Six positive-weight edges could exceed total weight six only if at least one had weight two, allowing at most ten triples. Seven positive-weight edges would allow at most fourteen triples whereas their tournament has at least twenty-one. Any larger positive-weight class would contain seven. With four edges at most two can have weight two by the marked-four argument above. Three edges immediately satisfy the bound.

It remains to consider five positive-weight edges. A violation needs two weight-two edges $u,v$ and three weight-one edges, because no four vertices contain three weight-two edges. Orient $u\to v$. For each other vertex $y$, its incidences with $u,v$ either give $u\to y\to v$ or $v\to y\to u$. The other two possibilities would make $u$ or $v$ a middle. If $x$ had the first type and $y$ the second, forbidding a transitive middle at $u$ would require $x\to y$, while forbidding one at $v$ would require $y\to x$. Thus all three vertices have the same type.

If all lie between $u$ and $v$, there are at least nine transitive triples, three using both endpoints and three each using one endpoint and two of the other vertices. The three weight-one middles allow only six. In the remaining case write $v\to j\to u$ for all three. The triples using exactly one of $u,v$ already account for six. The other three vertices must therefore form a directed cycle. Index them modulo three with $j\to j+1$. Write
$$
p_j=c_u-r_j,\qquad q_j=c_j-r_v,\qquad \ell_j=c_{j+1}-r_j .
$$
The three $p_j$ are distinct. At vertex $j$ the triples $(j-1,j,u)$ and $(v,j,j+1)$ give the two ordered representations
$$
(p_j,p_{j-1},\ell_{j-1}),\qquad(\ell_j,q_{j+1},q_j).
$$
Weight one means there is exactly one representation up to swapping the outer entries. Equality of the middle entries gives $q_j=p_{j+1}$ around the cycle. Since $p_j\ne q_j$, equality of the outer multisets forces $\ell_j=p_j$ and $\ell_{j-1}=p_{j+1}$. Applying the first equation at $j-1$ contradicts distinctness of the three $p$'s. This proves the weight bound. Summing over all $t$ translates of each occupied difference proves the result. [Lean check of the final label contradiction](../../hall-reduction/SparseHoleColors.lean) · [Direct cyclic matching audit](../sparse-blocks/cyclic_prices.cpp)

An independent C++ audit enumerated every hole set of sizes one through seven up to translation in each of three abelian groups of order 16. It tested 1,732 shapes in $\mathbb F_2^4$, 1,666 in $\mathbb Z_4^2$, and 1,652 in $\mathbb Z_{16}$. For each shape it checked the six-unit ceiling by enumerating compatible positive-weight matchings with an edge translated into row zero. [Group difference verifier](abelian_prices.cpp)

## Exactly three cyclic holes on infinitely many orders

For each $b\in\{24,30,36\}$, and for $L=1$ or any positive $L\equiv3\pmod6$, there is a cyclic board of order $t=bL$ with exactly three omitted differences whose minimum palette is
$$
\boxed{\frac{t(2t-15)}6}.
$$
The preceding price bound proves that no three omitted differences in any abelian group of order $t$ can give a smaller palette. In particular, the coefficient of the linear term is sharp on infinitely many orders.

| Seed order $b$ | Occupied cells | Minimum colors | Translation step | Seed classes |
| ---: | ---: | ---: | ---: | ---: |
| 24 | 504 | 132 | 2 | 11 |
| 30 | 810 | 225 | 2 | 15 |
| 36 | 1,188 | 342 | 2 | 19 |

Each seed board omits the differences $0,1,4$ modulo $b$. Translate each listed class by every even shift. The resulting classes partition the occupied cells, and every pair within a class has a missing cross. A separate C++ check also constructs the full labeled matrix and tests its rectangles. [24-point seed](three-hole-24.txt) · [30-point seed](three-hole-30.txt) · [36-point seed](three-hole-36.txt) · [Matrix verifier](../crown_lift.cpp)

In $\mathbb Z_{bL}$ omit $0,L,4L$ and split the indices into their $L$ residue classes modulo $L$. Each coset carries the seed board on its $b$ indices. Use distinct palettes on these $L$ internal boards. For the cross-coset cells take a Steiner triple system on the $L$ cosets. In each triple $(A,B,C)$ develop the two oriented triangles on $(A,x),(B,y),(C,x+y)$ for every $x,y\in\mathbb Z_b$. Give each oriented triangle its own color. Every directed cross-coset cell occurs once, and each pair of edges of one color has a missing diagonal cross. The total color count is
$$
L\,\frac{b(2b-15)}6 + \frac{L(L-1)b^2}3 = \frac{t(2t-15)}6 .
$$
The verifier expands the Bose triples for $L\equiv3\pmod6$, tests class compatibility and checks coverage of every required cell. At $L=9$ the three graphs of orders 216, 270 and 324 attain 15,012, 23,625 and 34,182 colors. [Block and lift verifier](two_holes.cpp)

```sh
c++ -O3 -std=c++17 two_holes.cpp -o /tmp/810-cyclic-lifts
c++ -O3 -std=c++17 ../crown_lift.cpp -o /tmp/810-cyclic-matrix
for b in 24 30 36; do
  /tmp/810-cyclic-matrix "$b" --local "three-hole-$b.txt"
  for L in 1 3 9; do /tmp/810-cyclic-lifts "$L" "three-hole-$b.txt"; done
done
```

## Exactly two holes in each row and column

For every $t\ge6$ and every 2-regular hole graph, the palette has at least $\lceil t(t-3)/3\rceil$ colors. Indeed $e=t(t-2)$ and $P=2t$ in the second path inequality. This bound is **exact** for an infinite family, including $t=12,36,108$. It identifies the linear term as well as the leading quadratic coefficient.

On twelve indices modulo 12, omit the differences 0 and 1. Use the six even translates of each of the first two classes below, and all twelve translates of each of the last two.

| Row-column pairs in a class | Translation step |
| --- | ---: |
| $(1,3),(2,4),(3,9),(8,2)$ | 2 |
| $(1,0),(6,1),(11,6),(0,11)$ | 2 |
| $(0,3),(3,7),(7,0)$ | 1 |
| $(0,8),(7,4),(3,1)$ | 1 |

The 36 classes partition all 120 occupied cells. For $t=12L$ with $L\equiv3\pmod6$, take $L$ such groups. Keep all cross-group cells and color them by the oriented group-triangle construction above with $b=12$. This adds $144L(L-1)/3$ colors to $36L$, totaling $t(t-3)/3$. The hole graph in this family is the disjoint union of $L$ cycles of length 24. The verifier checks every occupied cell and every same-color pair. [C++ verifier](two_holes.cpp)

## A subquadratic palette with fewer than square-root many holes

An infinite family of regular boards has $h=o(\sqrt t)$ and $Q(B)=o(t^2)$. The construction is bipartite and each color actually forms an induced matching. It adapts the coordinate flips of Alon, Moitra and Sudakov's code construction. Their unordered edges require a code containing the all-ones word. Here the two vertex parts distinguish the two orientations of each possible pair, so a binary simplex code of relative distance greater than $1/2$ can be used. [Alon, Moitra and Sudakov, §2.2, especially Claims 2.15–2.17](https://people.math.ethz.ch/~sudakovb/induced-matchings.pdf)

Take $d=2^m-1$ and $k=(d-1)/2$. Use $t=s^d$ rows and columns indexed by $[s]^d$, declaring distances at most $k$ missing. Index the coordinates by nonzero $v\in\mathbb F_2^m$. For each $u\in\mathbb F_2^m$ swap the row and column symbols at the coordinates where $u\cdot v=1$. A nonzero word swaps exactly $(d+1)/2$ coordinates because a nonzero linear form takes the value one on half the vectors. The flips compose by addition.

For an occupied pair at distance $j>k$, at most $d-j$ of the swapped coordinates can have equal symbols. A nonidentity flip therefore swaps at least $j-k$ differing positions. The new row and column are both different from the old ones, and each of the two crossed pairs has distance at most $j-(j-k)=k$. Applying this argument to any two flips shows that each orbit is an induced matching of exactly $d+1$ edges. Every occupied cell belongs to exactly one orbit. Hence
$$
h=\sum_{i=0}^k\binom di(s-1)^i,\qquad Q(B)\le\frac{t(t-h)}{d+1}.
$$
For $d=3$ and arbitrary $s$, this partitions the board into induced matchings of four with exactly $t(3s-2)=\Theta(t^{4/3})$ missing edges. For matchings of this fixed size the missing-edge exponent attains the lower bound in Theorem 3.9 of Alon, Moitra and Sudakov. The six-edge rainbow classes above use the weaker one-cross condition to improve the leading palette coefficient on the same board. [Explicit C++ orbit verifier](simplex_matching.cpp)

The induced-matching coefficient is sharp. In any induced matching retain only the $b$ cells whose row and column differ in all $d$ coordinates. In one coordinate write $R_z,C_z$ for the counts of the symbol $z$ on the two ends. Each retained cell contributes to at most one of $R_z,C_z$, so $R_z+C_z\le b$. Consequently
$$
\sum_z R_zC_z\le\tfrac14\sum_z(R_z+C_z)^2\le b^2/2.
$$
Each ordered pair of distinct matching edges must agree in at least $d-k$ coordinates from its row to the other's column. Summing gives $b(b-1)(d-k)\le db^2/2$. For $d=2k+1$ this forces $b\le d+1$. There are $[s(s-1)]^d$ cells of full distance, so between $[s(s-1)]^d/(d+1)$ and $t(t-h)/(d+1)$ induced matchings are needed. These bounds agree asymptotically for fixed $d$ as $s$ grows, and also whenever $d/s\to0$. In particular on the original three-coordinate board, the strong chromatic index is $(1/4+o(1))t^2$ and the rainbow-rectangle palette is $(1/6+o(1))t^2$. Their ratio tends to $3/2$.

Finally take $s=2^{4d}$ and let $m$ grow. The bound $h\le2^d s^{(d-1)/2}$ yields $h/\sqrt t\le2^{-d}$. The partition gives $Q(B)/t^2\le1/(d+1)$, with $\log_2t=4d^2$. This gives an explicit palette of at most $2t^2/\sqrt{\log_2t}$ along the family. The gap between the necessary cube-root scale for a subquadratic palette and these sub-square-root examples remains open here.

## Reproduction

Run the commands below in this directory. The second pair of tools accepts the generated DIMACS instance and an independently checkable proof file. [CaDiCaL](https://github.com/arminbiere/cadical) · [DRAT-trim](https://github.com/marijnheule/drat-trim)

```sh
c++ -O3 -std=c++17 hamming_classes.cpp -o /tmp/810-hamming-classes
c++ -O3 -std=c++17 hamming_blocks.cpp -o /tmp/810-hamming-blocks
c++ -O3 -std=c++17 two_holes.cpp -o /tmp/810-two-holes
/tmp/810-two-holes 1
/tmp/810-two-holes 9
c++ -O3 -std=c++17 simplex_matching.cpp -o /tmp/810-simplex
/tmp/810-simplex 2 3
/tmp/810-simplex 3 2
/tmp/810-hamming-classes 6
/tmp/810-hamming-classes 7
/tmp/810-hamming-blocks 3 --paths < cube-partition.txt
python3 hamming_cnf.py 7 > /tmp/810-seven.cnf
cadical /tmp/810-seven.cnf /tmp/810-seven.drat
drat-trim /tmp/810-seven.cnf /tmp/810-seven.drat
```
