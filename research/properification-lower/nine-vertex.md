# Five forced deletions on nine vertices

There is a connected graph on nine vertices with 20 edges and 31 four-cycles for which **every admissible nine-coloring requires five inherited edge deletions** to become proper. Deleting the single edge $67$ permits a proper nine-color recoloring of the other 19 edges. Thus $D(G)=5>9/2$ and $R(G)=1$. This rules out a universal $D(G)\le n/2$ bound at every finite order. The asymptotic question for $R(G)=1$ remains open. [Both explicit colorings](nine-vertex.json) · [Definitions and the shared-edge family](bouquet.md)

## The support

Each of vertices 0 and 1 is joined to $4,6,7$. Each of 2 and 3 is joined to $5,6,8$. On $4,5,6,7,8$ take all edges except $46,56$. Write $ij$ for the edge joining $i,j$. Two edges conflict when they lie on a common four-cycle. On each pair of twins and its three neighbors, the six edges of $K_{2,3}$ pairwise conflict.

At vertex 7 consider $07,17,47,67$. The following seven edges pairwise conflict and each conflicts with all four of those spokes,

$$
04,\ 06,\ 14,\ 16,\ 48,\ 68,\ 78.
$$

Consequently the four spokes have only two available colors. The two colors on $07,17$ are distinct, as are those on $47,67$, so the two unordered color pairs coincide. At vertex 8 the same reasoning applies to $28,38,58,68$. There the seven blocking edges are $25,26,35,36,57,67,78$. This already forces two deletions at each of vertices 7 and 8. Each conflict in these lists can be checked by testing the three cycles on every four-vertex set. [Independent conflict and partition check](check_nine.py)

## The fifth deletion

Name the eight core colors by the labels of $45,47,48,57,58,67,68,78$. They are all different. Within the core every pair conflicts except possibly $45$ with $67$ or $68$. But the color of $67$ also occurs on $07$ or $17$, both of which conflict with $45$. Likewise the color of $68$ occurs on $28$ or $38$, both conflicting with $45$. Let $x$ be the remaining palette label.

The admissible color pairs for the six twin-spoke groups are now determined. The table uses edge names for their colors.

| Edges | Their two colors, in either order |
| --- | --- |
| $04,14$ | $58,x$ |
| $06,16$ | $45,57$ |
| $07,17$ | $47,67$ |
| $25,35$ | $47,x$ |
| $26,36$ | $45,48$ |
| $28,38$ | $58,68$ |

For example, both $04,14$ conflict with every core edge except $58$ and with each other. The edges $06,16$ conflict with $47,48,67,68,78$. Their six-edge rectangle also excludes the colors $58,x$ used by $04,14$. This leaves $45,57$. The argument for $25,35$ and $26,36$ follows by exchanging the twin groups, vertices $4,5$, and vertices $7,8$.

Exactly one edge of $06,16$ and one edge of $26,36$ have the color of $45$. These meet at vertex 6. Their two edges are disjoint as a set from the four spokes tested at 7 and from the four tested at 8. Thus five separate deletions are necessary in every coloring. Conversely the 64 independent orders in the six table rows each give an admissible coloring, and each has exactly five edge-disjoint repeated incident pairs. Deleting one edge from each pair gives a proper restriction. The supplied 19-edge recoloring after removing $67$ proves $R=1$. [Edge-list witnesses](nine-vertex.json)

An independent enumeration found 64 color partitions on the fixed vertex labels. For each color class the audit computes its maximum matching. The sum of those matching numbers is the largest proper restriction that keeps the labels. Every one of the 64 partitions retained exactly 15 edges by this independent calculation. Two additional native coloring counters agree on 64 partitions and ten classes after quotienting by the eight vertex automorphisms. [Partition audit](check_nine.py) · [Native counting algorithms](../../bruteforce/results/2026-11-21-0600/coloring-census.md)

```sh
python3 check_nine.py nine-vertex.json
```
