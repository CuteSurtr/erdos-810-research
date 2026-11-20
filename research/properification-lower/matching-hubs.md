# Several repair edges force an inherited loss approaching the order

For every fixed $r\ge2$, infinitely many connected $n$-vertex graphs have the following properties. Exactly $r$ deletions permit a proper rainbow-four-cycle recoloring with $n$ labels. In **every** admissible initial coloring, making the surviving labels proper costs at least
$$
\left(\frac{2r}{2r+1}-o(1)\right)n
$$
edge deletions. The construction gives the exact finite cost. For two repair edges the limiting fraction is $4/5$, and for three it is $6/7$. Taking $r$ slowly increasing gives an inherited cost $(1-o(1))n$ while only $o(\sqrt n)$ deletions permit proper recoloring. The one-repair-edge construction reaches $2/3$ at all sufficiently large orders. These are lower bounds for the general inherited-cost problem. [One repair edge](crossed-rectangles.md) · [Finite examples](matching-hubs-counts.tsv)

For example, on 728 vertices every admissible coloring needs **500** inherited deletions, and two deletions suffice with recoloring. On 2,700 vertices the corresponding costs are **2,058** and **three**. The original graphs have 13,605 and 105,266 edges respectively. A specified proper recoloring of each punctured graph also costs exactly 500 or 2,058 old edges to restore the deleted matching while retaining labels. [C++ generator](matching_hubs.cpp) · [Independent matching and path audit](check_matching_hubs.cpp)

## The graph

Put $h=2r\ge4$, choose a prime $q\ge h$, put $d=h+1$, $s=dq$, and set
$$
n=s(s+h)+h-1.
$$
Use $h$ hubs numbered $0,\dots,h-1$, initially forming a clique. The distinguished matching pairs hubs $0,1$, then $2,3$, and so on. Column vertices are triples $(x,y,\lambda)$ in $\mathbb F_q^2\times\{0,\dots,d-1\}$. Every hub is joined to every column.

For hub $i$ and intercept $b\in\mathbb F_q$, let $P_{i,b}$ contain all triples with $y=ix+b$. Add $s$ private row vertices $X_{i,b}$, each joined to $i$ and to all $s$ members of $P_{i,b}$. These are all group edges. The column sets for a fixed hub partition the columns. Two columns from different base points can lie on at most one common line of the chosen directions. The core uses $h+s^2$ vertices. Add the remaining $hs-1$ vertices as a path at one private row vertex. [Field and size identities in Lean](../hall-reduction/MatchingHubs.lean)

## The original coloring forces exactly $hqs$ deletions

Fix $i,b$ and write $X=X_{i,b}$ and $P=P_{i,b}$. All $(h+s)s$ edges between the hubs together with $X$ on one side and $P$ on the other form a complete bipartite graph. Its edges have distinct labels in any admissible coloring, leaving exactly $h-1$ labels outside this rectangle in the full palette.

The $h-1$ clique edges $ij$ at hub $i$ all have distinct labels and all conflict with the rectangle. For a row edge $xp$, use the cycle $i,j,p,x$. For a column spoke $kp$ at a third hub $k$, use $i,j,p,k$. If the spoke is $ip$ or $jp$, take a third hub to complete a four-cycle through the two adjacent edges. Two clique spokes at $i$ lie on a four-cycle through a column. This accounts for every outside label.

Each of the $s$ spokes $ix$ conflicts with every $X\times P$ edge, using another row if the two edges share their row. It conflicts with every $jp$ for $j\ne i$ via $i,x,p,j$, and with every clique spoke $ij$ via a common column neighbor of $x,j$. The only possible labels for the $ix$ are therefore the labels on $iP$. The $ix$ have distinct labels because their row endpoints have a common column. This forces $s$ edge-disjoint monochromatic incident pairs at $i$. The parts of each hub partition the columns and the row sets are private, so these pairs stay edge-disjoint across all $hq$ parts. Thus $D\ge hqs$ for every admissible initial coloring.

## Coloring the grids

Partition the labels into $q$ buckets. Every bucket has $sd+hd$ labels, with a further $h-1$ in bucket zero. The total is $n$. Assign all hub-to-column spokes distinct labels, putting each spoke with column abscissa $x$ in bucket $x$. Within bucket zero, also give distinct unused labels to every hub-clique edge. There is room because a bucket has $hqd=hs$ boundary spokes and $sd+hd+h-1-hs\ge\binom h2$ in bucket zero.

Match the $s$ rows in each $X_{i,b}$ bijectively to its $s$ columns. Initially give $ix$ the label of the spoke from $i$ to its paired column $z$. In the punctured coloring delete the distinguished matching and give $ix$ the label of the spoke from the mate of $i$ to $z$. Each such latter pair is disjoint and a four-cycle containing it would require either the missing hub edge or an edge from the row to the other hub.

For the grid edges $X_{i,b}\times P_{i,b}$ attached to a column of abscissa $x$, use bucket $x+i$ in the field. Exclude all hub-spoke labels attached to columns of $P_{i,b}$ and all clique labels incident to $i$, including the matching label after puncturing. Each line meets each abscissa in $d$ column vertices. Precisely $hd$ labels per bucket are excluded by the spokes, with $h-1$ more excluded in bucket zero. Exactly $sd$ labels remain in each bucket, the number of row edges to the $d$ columns at that abscissa. Use each remaining label once.

Within one grid every label is different. Two row vertices from different directions have as common neighbors just the columns in the intersection of their two lines. The lines meet in one base point, so the corresponding grid edges have the same abscissa but belong to different buckets. Rows of different intercepts in one direction have only their hub in common. A grid edge can meet or share a four-cycle with a hub-to-column edge only when that column lies in its own part. It can share a four-cycle with a hub-clique edge only when that edge is incident to its own hub. A grid edge can conflict with a hub-to-row spoke only within its own grid. All these labels were excluded. Other equalities among boundary spokes occur only in the designated pairs. Initially the outer endpoints of each repeated pair have only their hub as a common neighbor. After puncturing, every such equal pair is disjoint and its four-cycle is broken. The path can always use labels unused at its attachment, followed by alternating different labels. This proves admissibility, properness after puncturing, and $D=hqs$.

## Why $r$ repair edges are necessary

Suppose fewer than $r$ edges have been removed. Some hub $i$ is untouched because each deleted edge meets at most two hubs. At this hub, any removed edge damages at most one of the $q$ rectangles between all hubs together with $X_{i,b}$ and their columns. The different column parts are disjoint for fixed $i$. Since $q>r-1$, at least one rectangle is intact.

All edges $ij$ and $ix$ at $i$ survive. Each of the $s$ distinct row-spoke labels still conflicts with all rectangle labels except those on $iP$, using the same cycles through the intact rectangle and the surviving hub spokes. A proper coloring cannot reuse any label on $iP$ at $i$. Only $h-1<s$ colors lie outside the rectangle. This rules out a proper recoloring after fewer than $r$ deletions. Deleting the matching attains the bound. [Untouched-hub and intact-part counts](../hall-reduction/MatchingHubs.lean)

## Restoring the whole matching

In the punctured coloring every paired row and column supplies a split three-edge path between the appropriate matched hubs. Across the entire matching there are $hqs$ such paths with disjoint old edge sets. A restored hub edge would close its split path to a nonrainbow cycle regardless of the new label. Delete the paired middle grid edge from each path and restore every hub edge in its reserved label. A four-cycle containing two restored edges lies entirely in the hub clique and has distinct labels. For a cycle with only one restored edge, the three old edges have different labels after hitting all split paths. A surviving grid edge with the restored edge's label can only belong to a nonincident hub's grid and cannot lie on a four-cycle with that restored edge. Boundary spokes have distinct reserved labels apart from the specified split pairs. The resulting graph is proper and every surviving old label is unchanged.

Finally $(h+1)D=h s^2$ and $n=s^2+hs+h-1$. This proves the fixed-$r$ limiting fraction. For growing $r$, take $h=2\lfloor\sqrt q/2\rfloor$ through primes $q$. Then $h\to\infty$, $h/s\to0$, $D/n\to1$ and $r=O(n^{1/6})$.

```sh
c++ -O3 -std=c++17 matching_hubs.cpp -o "$SCRATCH/hubs"
c++ -O3 -std=c++17 check_matching_hubs.cpp -o "$SCRATCH/check-hubs"
cc -O3 ../../bruteforce/results/2026-11-21-0600/large/audit.c -o "$SCRATCH/audit"
for mode in original punctured reinserted
do
    "$SCRATCH/hubs" 4 5 "$mode" > "$SCRATCH/$mode"
    "$SCRATCH/audit" --cycles < "$SCRATCH/$mode"
done
"$SCRATCH/check-hubs" 4 "$SCRATCH/original" "$SCRATCH/punctured" "$SCRATCH/reinserted"
```
