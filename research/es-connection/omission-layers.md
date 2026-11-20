# Counting missing ES states and coloring their incidence graph

The November 20 ES handoff records a computer-assisted $ES(8)\le304$. Its search toward $303$ stopped with 24,938 of 32,755 contexts closed. The handoff gives a numerical estimate of the fractional minimum in the balanced model. At the current demands the minimum is **exactly 66 missing states**, including when states 0 and 1 are fixed occupied. At budget 68 an integer solution would have only six possible pairs of totals in the two distinguished classes. Both facts follow from the same 70 catalog inequalities. [ES handoff](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/2d1cb6baa0f5dca2977fd03086f3edcd01eb8a7e/archive/es7-2026-10-19/results/STATUS20261120/README.md) · [Original numerical calculation](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/2d1cb6baa0f5dca2977fd03086f3edcd01eb8a7e/archive/es7-2026-10-19/results/ES303N20261120/tools/lp_zstar.py)

## The 70 inequalities

Write a balanced state as a decreasing sequence $f_0\ge\cdots\ge f_4$ in $\{0,\ldots,5\}$. Encode it as the five-element set $\{i+f_{4-i}:0\le i<5\}$ in $\{0,\ldots,9\}$. Every five-element set occurs once. Put $D=\{1,\ldots,8\}$. The ES class $Z$ consists of the states containing 0 and omitting 9. The class $Z^*$ consists of the states containing 9 and omitting 0. Write $h_T$ for the indicator that state $T$ is missing, $H=\sum_T h_T$, and $z,z^*$ for the sums in the two classes. The fractional model allows $0\le h_T\le1$. [Definition of the two classes and their geometric justification](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/2d1cb6baa0f5dca2977fd03086f3edcd01eb8a7e/archive/es7-2026-10-19/results/ES303N20261120/README.md)

For each four-subset $A$ of $D$, the catalog contains the demand-three inequality on these ten states:

- $A\cup\{0\}$ and $A\cup\{9\}$.
- $(A\setminus\{i\})\cup\{0,9\}$ for the four $i\in A$.
- $A\cup\{j\}$ for the four $j\in D\setminus A$.

The verifier locates all 70 inequalities by their supports and demands in the pinned 3,131-row catalog. Every state in $Z\cup Z^*$ appears once. Every other state appears five times, since a three-subset has five extensions to a four-subset and a five-subset has five four-subsets. Summing gives
$$
  5H-4(z+z^*)\ \ge\ 210.
$$
The ES project attributes the omission method and original catalogs to Michael Schroeder. This argument uses the catalog as input. [Pinned catalog](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/2d1cb6baa0f5dca2977fd03086f3edcd01eb8a7e/experiments/omission-cover-certificates-2026-10-10/balanced-v2-source.json) · [Source credits](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/2d1cb6baa0f5dca2977fd03086f3edcd01eb8a7e/NOTICE)

## Exact fractional optimum with both occupied states fixed

Give $Z$ demand $r$ and $Z^*$ demand $s$. For all real $15\le r,s\le35$, independently, the minimum of $H$ in the catalog relaxation is
$$
  42+\tfrac45(r+s).
$$
The summed inequality proves the lower bound. To attain it, assign $(210-r-s)/560$ to each of the 112 states outside $Z\cup Z^*$. Pair $A\cup\{0\}$ with $A\cup\{9\}$. In the two pairs whose $Z$ member is mandatory occupied (catalog indices 0 and 1), assign values $0,(r+s)/70$. In each of the other 68 pairs assign
$$
  \frac{r}{68},\qquad \frac{s}{70}-\frac{r}{2380}.
$$
These class totals are $r,s$, and the objective equals the displayed lower bound. Each coordinate and each catalog inequality is affine in $(r,s)$. After multiplication by 9,520 the checker verifies the coordinate bounds and all 3,131 catalog inequalities in integers at the four corners of the square. Feasibility throughout follows by convexity. Only demand 15 in each class is used as a geometric input here. Higher demands describe the sensitivity of the relaxation. [Exact verifier](check_omission_layers.py)

## What an integer solution at budget 68 would require

The geometric bounds give $z,z^*\ge15$. If $H=68$, the total surplus above three across the 70 selected inequalities is exactly $130-4(z+z^*)$. Every non-tight integer row uses at least one unit of surplus.

| $z+z^*$ | Possible ordered pairs $(z,z^*)$ | Total surplus | Rows that must contain exactly three holes |
| ---: | --- | ---: | ---: |
| 30 | $(15,15)$ | 10 | At least 60 |
| 31 | $(15,16),(16,15)$ | 6 | At least 64 |
| 32 | $(15,17),(16,16),(17,15)$ | 2 | At least 68 |

The previous budget-67 proof already covers smaller integer totals. Ruling out these six pairs would complete the balanced integer step toward $303$. The table is a necessary condition for that step. [Budget-67 result and verification status](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/2d1cb6baa0f5dca2977fd03086f3edcd01eb8a7e/archive/es7-2026-10-19/results/ES304N20261119/README.md)

The 70 selected rows by themselves admit a binary solution with exactly 66 holes, $z=z^*=15$, and states 0 and 1 occupied. To construct it, start with the 21 three-subsets containing element 1, as states with both endpoints, and their 21 complementary five-subsets in $D$, as states with neither endpoint. Each four-subset sees three of these 42 states. Remove triples $123,145,167$ and their complements. The five four-subsets above each removed triple are distinct across the three triples, since two removed triples have a five-element union. Their complements give 15 further affected four-subsets avoiding 1. For each of the first 15 rows add its $Z^*$ state, and for the other 15 add its $Z$ state. This restores exactly three holes per row and gives $42-6+30=66$ in total. Both mandatory occupied states have four-subsets containing 1 and belong to $Z$. The full catalog excludes this binary example on 660 additional inequalities. This identifies exactly where the 70-row argument stops, even with integrality. [Integer replay](check_omission_layers.py)

## The graph shared with #810

In the incidence graph of these 70 rows, every $Z$ or $Z^*$ state is a leaf. Removing the leaves leaves the three-, four- and five-subsets of $D$, joined by inclusion of consecutive sizes. This gives **182 vertices and 560 edges**. Two different four-subsets have two common neighbors exactly when they differ by one exchanged element. Their intersection and union are those neighbors. There are $70\cdot4\cdot4/2=560$ four-cycles. An explicit **six-color** certificate makes all 560 rainbow. At least five colors are necessary because the five edges through any three-subset are pairwise in four-cycles. Whether five suffice on this graph remains unresolved here. [Six-color certificate](diamond-colors.txt) · [Exhaustive C++ checker](check_diamond_colors.cpp)

If the whole coloring must also be proper, the exact minimum is **eight**, since a four-subset has degree eight. Faudree, Gyárfás, Lesniak and Schelp proved in 1993 that eight colors suffice on the entire eight-dimensional cube, which contains this graph. A short field construction realizes the restriction. Identify the eight ground elements with $\mathbb F_8$ and fix $t\notin\{0,1\}$. On the edge incident to four-subset $A$ which toggles element $x$, use the color $t\sum_{a\in A}a+x$. At a four-subset the colors are distinct. At a three- or five-subset, varying $x$ changes the color by $(t+1)x$ up to a fixed additive constant. On a square exchanging $x,y$, the four colors differ from the first by $0,d,td,(t+1)d$ with $d=x+y\ne0$. The checker constructs this coloring over $\mathbb F_2[t]/(t^3+t+1)$. [Faudree et al., *Rainbow Coloring the Cube*](https://doi.org/10.1002/jgt.3190170507)

## The 17-point weak-delta frontier

The updated ES record certifies weak $D(5,8)$ through 16 points. The general 17-point case timed out. On the particular 17-point integer example used for our #810 graph, exactly three four-point sets meet all 121 four-caps. They are $\{6,8,9,j\}$ for $j=12,13,14$, using the original zero-based indexing. Four disjoint caps, $(0,5,8,10)$, $(1,2,6,11)$, $(3,4,9,15)$ and $(12,13,14,16)$, prove that four is the minimum. All three minimum transversals are nonconvex. [ES frontier record](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/2d1cb6baa0f5dca2977fd03086f3edcd01eb8a7e/archive/es7-2026-10-19/results/DELTA2N20261113/VERIFY_DELTA2N_RECERT1119.md) · [Integer coordinates](octagon-anchor.json)

For example, take $B=\{6,8,9,14\}$ blue and the other 13 points red. No four red points form a cap, and point 8 lies inside the triangle on 6, 9 and 14. Add any three new points in general position with distinct horizontal coordinates and color them blue. A blue convex heptagon would have to contain all four original blue points, an impossibility. Thus the red set meets every convex heptagon and remains four-cap-free. This proves weak-delta existence for every such extension through 20 points and, by restriction, after arbitrary replacement of up to three of the original 17 points. [Exact checks of all four-caps and transversals](check_obstructions.py)

## Reproduction

Run these commands from this directory. Supply the pinned ES catalog as the first command's argument. The Python checker validates its SHA-256. In the six-color table each line gives a three-subset as a bit mask and two five-digit strings. The digits index the five elements outside the triple in increasing order. The first string colors the edges through that triple, and the second colors the edges through its complementary five-subset.

```sh
python3 check_omission_layers.py /path/to/balanced-v2-source.json
c++ -O2 -std=c++17 check_diamond_colors.cpp -o /tmp/check_es_diamonds
/tmp/check_es_diamonds diamond-colors.txt
python3 check_obstructions.py
```
