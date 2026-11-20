# Square-free XOR boards

Give the occupied cells of a $2^k$-by-$2^k$ board the edge color $x+y$, with row and column indices in $\mathbb F_2^k$. Write $s_k$ for the largest possible number of edges when every occupied rectangle is rainbow. The fixed-color model has
$$
s_3=42,\qquad 144\le s_4\le153 .
$$
Peter Mueller reported 42 and a range of 144 to 168 in 2016. We recover the 8-by-8 maximum independently, classify the near-maximum boards and reduce the upper bound on the 16-by-16 board. These are finite bounds for a prescribed coloring in Erdős #810. [Mueller's original calculation](https://mathoverflow.net/questions/251295/square-free-sets-in-mathbb-f-2n-oplus-mathbb-f-2n) · [Connection to the ES coordinates](../sum-colors.md)

Two opposite edges have the same color precisely when their row and column differences agree. The forbidden set of cells is therefore $(x,y),(x+h,y),(x,y+h),(x+h,y+h)$ for $h\ne0$. For the lower bound 144, identify the row and column indices with $\mathbb F_4^2$, choose $S=\{0,1,\omega\}^2$ and occupy $x+\omega y\in S$. Every affine line varies over all four field elements in some coordinate, so $S$ contains no whole line. The image of a forbidden square would be an entire line. There are nine occupied cells in each of sixteen columns. [Additive construction and formal criterion](../sum-colors.md)

## The 8-by-8 classification

The symmetry group used here acts by a simultaneous invertible binary linear map on the indices, independent row and column translations, and a permutation of the three projections $x,y,x+y$. Its order in dimension three is $168\cdot64\cdot6=64{,}512$. Every 42-cell board has seven lines of size five and one line of size seven in **each** of the three families. Each 41-cell board extends to a 42-cell board in exactly one way. This also gives the independent incidence check $1{,}024\cdot42=43{,}008$.

| Occupied cells | Rooted masks | Symmetry orbits | Labeled boards |
| ---: | ---: | ---: | ---: |
| 43 | 0 | 0 | 0 |
| 42 | 1 | 1 | 1,024 |
| 41 | 24 | 2 | 43,008 |
| 40 | 489 | 16 | 903,168 |
| 39 | 7,438 | 273 | 16,389,632 |
| 38 | 113,737 | 5,782 | 365,594,880 |

To enumerate, put the $i$th bits of $(x,y)$ into the single field digit $x_i+\omega y_i$. Each forbidden square becomes a line whose direction has binary coordinates. Slice on the last field digit, leaving four 16-cell layers. The affine permutations of that digit put a largest and a second-largest layer at heights 0 and 1. They extend to square-preserving maps of the whole board by acting on every digit with the same invertible binary map and translating the last digit. Each layer avoids twelve four-point lines and has at most twelve cells.

In the first layer reduce by simultaneous binary basis changes on the two low coordinates, translations and field conjugation. For the second layer also use the shear adding the top digit times a binary two-vector to the low coordinates. This fixes the first layer and translates the second by this vector. Conjugation may interchange the last two layers, whose sizes are both bounded by the second. For a point $z$ in the first layer and $z+h$ in the second with binary $h$, the third point $z+\omega h$ forbids $z+(1+\omega)h$ in the last layer. These pairs describe every transverse forbidden line. Enumerate the third layer and every admissible submask of the remaining fourth-layer cells with the required total size. Finally check all output masks using the original four-cell square definition. The same direct loop checks the degree signatures and the one-point extension assertion. [Layer search](small_boards.cpp)

## Bounding two remaining sections

Let $f$ be any nonzero binary functional in dimension four. The values $(f(x),f(y))$ split the board into four 8-by-8 sections. We may send any **ordered** pair of distinct sections to $A=(0,0)$, $B=(1,0)$ by an affine permutation of the two high bits. Extend the linear part by the same mixing of $x,y$ on the entire vector, and translate the high bits independently. The other sections are $C=(0,1)$ and $D=(1,1)$.

For a low column $y$, build a bipartite graph on the eight row positions in $C$ and eight row positions in $D$. Join $x$ in $C$ to $u$ in $D$ when $A(x,y+x+u)$ and $B(u,y+x+u)$ are both present. The two joined cells in $C,D$, if selected together, would complete a square of difference $(1,x+u)$. A matching of size $m_y$ therefore forces $m_y$ distinct omissions at that column. Summing yields $|C|+|D|\le128-\sum_y m_y$. The program first constructs greedy matchings and augments to maximum size when more omissions are required.

Normalize $A$ under the 10,752 operations fixing the ordered coordinate axes, allowing all six orientations of each orbit representative before this normalization. For $B$ independently quotient by its eight row translations. This uses the same binary shear on both indices, adding $f(x)t$ to the low coordinates of $x$ and $f(y)t$ to those of $y$. It fixes $A$ and translates the rows of $B$. All these last transformations preserve the joint column degrees, up to a common relabeling. [Pair verifier](slice_pairs.cpp)

| Sizes of $A,B$ | Upper bound for $\lvert C\rvert+\lvert D\rvert$ | Condition |
| --- | ---: | --- |
| 42,42 or 42,41 | 66 | All pairs |
| 42,40 or 41,41 | 67 | All pairs |
| 41,40 | 69 | All pairs |
| 40,40 or 42,39 | 72 | All pairs |
| 41,39 or 40,39 or 42,38 | 73 | All pairs |
| 41,38 | 74 | All pairs |
| 40,38 or 39,39 | 75 | Six joint column degrees equal 10 and two equal 9 |

The 40,39 calculation includes 188,480,768 normalized pairs. A second calculation for 42,42 directly enumerated all 256 subsets of the $C$ rows in each column and optimized the $D$ rows by deletion of their forbidden neighbors. Its maximum over 2,048 oriented pairs was also 66. The size-38 pass verified 456,993,600 unrestricted pairs and 70,701,904 degree-conditioned pairs. [Independent column-subset check](maximum_pair.cpp)

## Why 154 cells are impossible

It suffices by deletion to exclude a board of size 154. In any direction, two sections of sizes at least 40 give total at most 152 by the table. A section of size 41 or 42 alongside one of size 38 or 39 gives total at most 153. If its three partners all have size at most 37 the total is again at most 153. A pair of sizes 40,39 gives at most 152. Consequently the only possible section sizes in **every** direction are
$$
(40,38,38,38),\quad(39,39,39,37),\quad(39,39,38,38).
$$

For the row degree function $d(x)$ each Fourier coefficient $\widehat d(f)$ is the difference between the two half-board sizes. The three profiles give $|\widehat d(f)|\le2$ at every nonzero $f$. The same holds for column and XOR-label degrees. For each family, Parseval and integer balancing give
$$
60 \le 16\sum_x d(x)^2-154^2
=\sum_{f\ne0}|\widehat d(f)|^2\le 15\cdot4=60.
$$
The minimum comes from ten degrees of 10 and six of 9. Thus every degree is 9 or 10 and every nontrivial coefficient in all three families has absolute value two. The third profile produces a zero coefficient in two families, excluding it. In the first profile choose sections of sizes 40 and 38, and in the second choose two of size 39. The pair has 78 cells. Its eight joint column degrees are full degrees of a single global family in one half of its index set. Exactly six are 10 and two are 9. The last row of the table limits the other two sections to 75, contradicting the required 76.

The same slice argument gives larger-dimensional bounds. If $s_{k-1}\le m$, $N=2^k$, and a board has $E$ cells, the four section deficits below $m$ sum to $\delta=4m-E$ in every direction. Hence $|\widehat d(f)|\le\delta$ for every nonzero $f$. Writing $r=E\bmod N$ and applying the same integer balancing yields $r(N-r)\le(N-1)\delta^2$. Starting at $m=153$ gives $s_5\le610$, $s_6\le2{,}437$ and $s_7\le9{,}744$.

## A symmetry that limits the 16-by-16 board to 144

Identify the index group with $G=\mathbb F_4^2$. If a square-free board is invariant under $(x,y)\mapsto(x+\omega h,y+h)$ for every $h$ in a binary subspace of dimension at least two, its sharp maximum is **144**. Thus any example improving the lower bound must break this part of the symmetry of the nine-point construction.

It suffices to take a two-dimensional subspace $H$. Under an invertible $\mathbb F_4$-linear change of coordinates, $H$ is either a field line or has a binary basis of two vectors independent over $\mathbb F_4$. In the first case use the quotient projection $\pi(z_1,z_2)=z_2$. In the second take the real binary coordinate of each field digit, whose kernel is spanned by $(\omega,0),(0,\omega)$. Each invariant board is a union of four-element fibers indexed by $(z,p)=(x+\omega y,\pi(y))$. These indices give four layers of sixteen cells. For each nonzero $h$ a forbidden square projects to
$$
(z,p),\quad(z+h,p),\quad(z+\omega h,p+\pi(h)),\quad(z+(1+\omega)h,p+\pi(h)).
$$
These four cells lift to an actual square whenever all are occupied.

Enumerate all permitted subsets of a layer, checking the four or twelve internal lines for the two kernels. Translate a largest layer to height zero and reduce its point mask by translations of $z$. For each of the other three heights, store every internally valid mask compatible with the first. Two such masks must also avoid the forbidden pair constraints corresponding to their height difference. Testing all combinations whose four sizes could total at least 37 excludes them. The line kernel gives 440 largest-layer representatives and the independent kernel gives 80. The nine-point construction occupies 36 quotient cells and its expansion passes the original square check for all fifteen directions. [Quotient verifier](invariant_boards.cpp)

## Reproduction

Run these commands in this directory. Root masks are unsigned 64-bit integers, with bit $8x+y$ representing cell $(x,y)$. The programs stream one second-section orbit at a time. A failed pair check exits with the two masks.

```sh
c++ -O3 -std=c++17 small_boards.cpp -o /tmp/810-xor-small
c++ -O3 -std=c++17 slice_pairs.cpp -o /tmp/810-xor-pairs
c++ -O3 -std=c++17 maximum_pair.cpp -o /tmp/810-xor-maxpair
c++ -O3 -std=c++17 invariant_boards.cpp -o /tmp/810-xor-invariant
for n in 38 39 40 41 42 43; do /tmp/810-xor-small "$n" 2> "/tmp/810-xor-$n"; done
cd /tmp
./810-xor-invariant line
./810-xor-invariant independent
./810-xor-maxpair < 810-xor-42
./810-xor-pairs 810-xor-42 810-xor-42 66 all
./810-xor-pairs 810-xor-41 810-xor-42 66 all 810-xor-41 67 all
./810-xor-pairs 810-xor-40 810-xor-42 67 all 810-xor-41 69 all 810-xor-40 72 all
./810-xor-pairs 810-xor-39 810-xor-42 72 all 810-xor-41 73 all 810-xor-40 73 all 810-xor-39 75 degrees
./810-xor-pairs 810-xor-38 810-xor-42 73 all 810-xor-41 74 all 810-xor-40 75 degrees
```
