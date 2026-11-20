# Rectangular block constructions

At 5,632 vertices the following construction has **3,265,658 edges**. It improves the symmetric product at the same order by 152,588 edges and the earlier nested construction by 1,285,527 edges. All **247,044,109,888 four-cycles** are rainbow. At 8,192 vertices it gives **6,340,344 edges**, 620,572 more than the symmetric product. An independent C program verified these two expanded graphs and reproduced their cycle counts. [All 15 recipes and counts](counts.tsv) · [Source graphs and support coordinates](recipes.json) · [Symmetric products](../README.md)

| Vertices | Edges | Colors | Rainbow four-cycles |
| ---: | ---: | ---: | ---: |
| 5,632 | 3,265,658 | 5,632 | 247,044,109,888 |
| 6,144 | 3,727,738 | 6,144 | 302,819,086,668 |
| 8,192 | 6,340,344 | 8,192 | 785,261,001,366 |
| 10,000 | 9,033,102 | 9,986 | 1,467,567,317,516 |
| 15,616 | 22,304,630 | 15,616 | 8,721,610,491,596 |
| 32,768 | 73,756,584 | 32,768 | 56,160,130,615,768 |

## Substitution into a colored graph

Start with a symmetric partial matrix on $n$ base vertices using $q$ labels. Require proper rows and columns and rainbow occupied rectangles. Its diagonal may have compatible labels. Replace each upper off-diagonal occupied cell by a properly labeled $t$-by-$t$ partial matrix $F$ with rainbow rectangles, and place the transpose in the opposite cell. Fill each occupied diagonal cell with a symmetric adjacency matrix $D$ of a proper rainbow-four-cycle graph on $t$ vertices. Use the ordered pair of base and local labels at every resulting edge. Different base cells may use different local matrices.

To check an opposite-label equality in a filled rectangle, first project to the base. The base rectangle criterion forces the two base row indices to coincide and the two base column indices to coincide, including when the projection repeats indices. All four cells therefore lie in one local matrix. Its rectangle criterion forces the actual row and column indices to coincide. This also proves properness by allowing one pair of indices to coincide at the outset. Taking transposes preserves the criterion. Lean checks this argument for arbitrary cell-dependent rectangular boards. [Substitution theorem](../../../../../research/hall-reduction/ColorMatrixProduct.lean)

For our affine blocks use $G=\mathbb F_4^d$ of order $t$. With $\omega^2=\omega+1$, occupy $(x,y)$ if $x+\omega y$ belongs to a specified set $S$ and give it the label $x+y$. Each column contributes $|S|$ cells. Equality on opposite corners would put the entire line $z,z+h,z+\omega h,z+(1+\omega)h$ inside $S$ for a nonzero $h$. The coordinate sets in the recipes contain no such line. This uses the additive coloring criterion originally applied to the project's Erdős–Szekeres coordinates. [Additive-board derivation](../../../../../research/es-connection/sum-colors.md) · [Formal criterion](../../../../../research/hall-reduction/SumColorSquares.lean)

A base with $m$ ordinary edges and $l$ diagonal cells gives $m\,t|S|+l\,|E(D)|$ edges before padding. A pendant path can reach a requested larger order without creating a four-cycle. At 5,632 vertices we use a 22-vertex base with 133 edges and three diagonal cells, a 95-point line-free set in $\mathbb F_4^4$, and a 256-vertex internal graph with 10,366 edges. Thus $133\cdot256\cdot95+3\cdot10,366=3,265,658$. These are finite lower bounds for #810. The positive-density question remains open. [Original problem](https://www.erdosproblems.com/810)

## Counting without expanding the graph

The three possible nonempty block types are $F,F^\mathsf T,D$. For types $U,V$ let $J_{UV}=UV^\mathsf T$ using their zero-one support matrices. For base rows $a,b$ let $m_{ab}(U,V)$ count the base columns whose two blocks have types $U,V$. The matrix of common-neighbor counts for the copy rows over $a,b$ equals $\sum_{U,V}m_{ab}(U,V)J_{UV}$. Summing its squared entries over all $a,b$ gives the fourth trace of the simple adjacency matrix. Precomputing the 81 inner products between the nine possible $J$ matrices gives the trace using only the small blocks. If the graph has $e$ edges and degrees $d_x$, its four-cycle count is $(\operatorname{tr}(A^4)-2\sum_x d_x^2+2e)/8$. Use the core graph throughout this calculation since a pendant path leaves every cycle count unchanged. Rows of the counts table with a SHA-256 fingerprint were also checked directly on the expanded edge stream. [C++ verifier and generator](lift.cpp) · [Independent C checker](../audit_proper.c)

## Reproduction

Run these commands from this directory. The recipe loader verifies the archived source graph hashes before preparing a block. The C++ checker tests both the base and the internal graph, checks the support condition for every starting point and nonzero step, and reports exact counts. At block orders through 256 it also tests the local labeled matrix directly. [Recipe loader](recipe.py)

```sh
c++ -O3 -std=c++17 lift.cpp -o /tmp/810-block
cc -O3 -std=c11 ../audit_proper.c -o /tmp/810-block-audit
python3 recipe.py 5632 > /tmp/810-block.recipe
/tmp/810-block --counts < /tmp/810-block.recipe
/tmp/810-block --emit < /tmp/810-block.recipe | /tmp/810-block-audit
```
