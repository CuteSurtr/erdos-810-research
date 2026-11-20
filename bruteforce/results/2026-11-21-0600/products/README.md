# Denser finite graphs from products

At 5,632 vertices this construction gives **3,113,070 edges** and uses **5,614 colors**. All **207,434,382,800** four-cycles are rainbow. The earlier nested construction has 1,980,131 edges at the same order. The product adds 1,132,939 edges, or 57.2%. Each order has its own explicit recipe. [Full table](counts.tsv) · [Source graphs, fingerprints and diagonal labels](recipes.json) · [Earlier nested family](../large/README.md)

| Vertices | Product edges | Earlier nested edges | Rainbow four-cycles in the product |
| ---: | ---: | ---: | ---: |
| 512 | 38,690 | 31,696 | 74,742,633 |
| 1,024 | 139,242 | 104,907 | 763,198,246 |
| 2,048 | 511,274 | 348,698 | 8,479,380,537 |
| 3,721 | 1,683,600 |  | 86,250,016,425 |
| 4,096 | 1,883,619 | 1,152,423 | 98,042,462,945 |
| 5,632 | 3,113,070 | 1,980,131 | 207,434,382,800 |
| 8,192 | 5,719,772 |  | 542,119,105,617 |
| 226,981 | 3,089,428,875 |  | 72,557,060,566,924,125 |

For example, the 5,632-vertex witness begins with archived graphs on 61 and 92 vertices having 915 and 1,691 edges. We insert five and eleven diagonal entries with compatible existing labels in their respective adjacency matrices. Their product has 5,612 vertices. Removing the product diagonal gives $((2\cdot915+5)(2\cdot1691+11)-5\cdot11)/2=3,113,050$ ordinary edges. A pendant path adds twenty vertices and twenty edges. The cube of the same augmented 61-vertex matrix gives 3,089,428,875 edges at order 226,981. Each fixed seed has occupied fraction below one, so its powers have density tending to zero. Whether unrestricted #810 has positive limiting density remains open. [61-vertex source](../../CYC/C2/certs.json) · [92-vertex source](../../2026-11-20-evening/certs.json) · [Original problem](https://www.erdosproblems.com/810)

## Why the coloring survives a product

Represent a colored graph by a symmetric partially filled matrix. A filled ordinary edge appears in both orientations with the same color. Require distinct labels in every row and column and four distinct labels in every filled rectangle with two distinct rows and two distinct columns. The matrix of a properly colored #810 graph meets these requirements. In the absence of diagonal entries such a rectangle either represents a genuine four-cycle or would require a loop.

There is a convenient equivalent test. For any two rows $r,s$ and two columns $c,d$, allow equality of the row indices or the column indices. If all four cells are present and the labels at $(r,c)$ and $(s,d)$ agree, then $r=s$ and $c=d$. Distinct indices would contradict the rectangle requirement. If one pair already agrees, row or column properness forces the other pair to agree. Conversely the test gives row properness, column properness and both opposite-edge inequalities.

In a product, a tuple cell is present when every coordinate cell is present. Its color is the tuple of coordinate labels. Equality on opposite corners forces equality of both indices in every coordinate by the preceding test. This proves the rectangle requirement and properness for every finite product. Erase diagonal entries from the symmetric product matrix to get an ordinary simple graph. Adding a pendant path preserves all four-cycles, and at the attachment there is always an available label when the target order exceeds the product order. The C++ program chooses a proper alternating coloring of the path. The coordinate argument also proves $2M_{\mathrm{pr}}(a b)\ge(2M_{\mathrm{pr}}(a))(2M_{\mathrm{pr}}(b))$ for proper colorings with vertex-sized palettes. [Lean proof of the rectangle criterion, product and restriction](../../../../research/hall-reduction/ColorMatrixProduct.lean)

For the optional diagonal entries choose an independent set of vertices. At each such vertex $v$, choose a label absent on all edges incident with $v$ and on all edges between neighbors of $v$. A rectangle with one diagonal entry uses that entry and the three edges of a triangle at $v$. A rectangle with two diagonal entries would require adjacency of their vertices. This proves the augmented factor is valid. The verifier also tests each actual labeled factor directly. Product constructions appeared earlier in the project in a different coloring application. The comparisons above are against the archived nested construction at the same order. [Earlier tensor construction](../../../../research/local-progress/asymptotic-2026-10-15/tensor-obstruction.txt)

## Counting four-cycles from small factors

Write $A_i$ for the symmetric zero-one support matrix of factor $i$, allowing its diagonal. Let $L_i$ be its diagonal support, $d_x$ its row sums, and define

$$
a_i=\sum_x d_x,\quad b_i=\sum_x d_x^2,\quad
t_i=\operatorname{tr}(A_i^4),\quad
l_i=|L_i|,\quad v_i=\sum_{x\in L_i}d_x,\quad
h_i=\sum_{x\in L_i}(A_i^3)_{xx}.
$$

Use $a,b,t,l,v,h$ for the products of the corresponding factor quantities. The simple graph before padding has $m=(a-l)/2$ edges and squared-degree sum $S=b-2v+l$. If $P$ is the tensor product of the matrices and $D$ its diagonal, then the simple support is $B=P-D$. The trace of $B^4$ is $t-4h+4v-l$. Indeed the four terms containing a single $D$ contribute $-4h$. Of the six terms with two copies of $D$, four give $v$ and two give $l$, since the product's looped vertices form an independent set apart from their diagonal entries. The remaining terms give $-4l+l$. All products factor by coordinates. A simple undirected graph has $\operatorname{tr}(B^4)=8C_4+2S-2m$ by counting closed four-walks. This determines every listed four-cycle count with integer arithmetic. Padding leaves the cycle count unchanged.

## Reproducing a witness

From this directory, the following commands build and verify the 5,632-vertex graph. The recipe loader checks a SHA-256 fingerprint of each normalized input graph against its archived source. The C++ program checks the factor matrices, computes the counts, and streams the sorted expanded graph. The independent C verifier reads only that graph. It checks properness, tests the two ways edges of the same color could complete a four-cycle, and independently counts all four-cycles through common-neighbor counts. For a smaller graph, the earlier C verifier can also check all six inequalities on each individual cycle. [Recipe loader](recipe.py) · [Product verifier and generator](product.cpp) · [Expanded-graph verifier](audit_proper.c) · [Literal four-cycle verifier](../large/audit.c)

```sh
c++ -std=c++17 -O3 product.cpp -o /tmp/810-product
cc -std=c11 -O3 audit_proper.c -o /tmp/810-proper
python3 recipe.py 5632 > /tmp/810-5632.recipe
/tmp/810-product < /tmp/810-5632.recipe
/tmp/810-product --emit < /tmp/810-5632.recipe | /tmp/810-proper
```

The small-factor proof and exact arithmetic apply to every listed recipe, including large orders whose full edge list has billions of entries.
