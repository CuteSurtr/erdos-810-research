# Line-free sets over the four-element field

The largest subset of the 64 points of $\mathbb F_4^3$ containing no entire affine line has **30 points**. All 483,840 maximum sets are affinely equivalent, and their affine stabilizer has order 24. Equivalently, 34 points are necessary and sufficient to meet every affine line. In $\mathbb F_4^4$ we certify a range of **95 to 109**. Two parallel 30-point sections leave at most 49 points in the other two. If three parallel 3-dimensional sections each contain 30 points, the fourth contains at most **three**, and three is attainable. These computations concern complete four-point lines. The 64-point model gives at most $64\cdot30=1,920$ occupied entries in the additive block for #810. [Finite graph application](../../../bruteforce/results/2026-11-21-0600/products/affine/README.md) · [95-point coordinates](../../../bruteforce/results/2026-11-21-0600/products/affine/recipes.json)

## Reducing a 30-point set to parallel planes

Represent $0,1,\omega,1+\omega$ by the two-bit integers $0,1,2,3$ with $\omega^2=1+\omega$. There are 20 lines in the 16-point affine plane. Directly testing its 65,536 point subsets gives 26,073 line-free sets. The maximum has nine points, and exactly 1,120 subsets attain it. The affine group of order 2,880 has two orbits on those nine-point sets. The least integer masks in the orbits are 1,911 and 1,915.

Every line-free 30-point set in three dimensions has a nine-point plane. If all planes had at most eight points, write $s_P$ for the number in plane $P$. The 21 parallel classes contain four planes each. Their four deficits $8-s_P$ sum to two, giving $\sum_P(8-s_P)^2\le84$. Each point belongs to 21 planes, and two distinct points belong together to five. Thus $\sum_Ps_P=630$ and $\sum_Ps_P^2=630+5\cdot30\cdot29=4,980$. Expanding gives $\sum_P(8-s_P)^2=276$, a contradiction. Any larger set contains a 30-point subset, and so also has a nine-point plane. At least one of the remaining three parallel planes contains seven points.

Use affine coordinates to put the nine-point section $A$ at height zero and a section $B$ of at least seven points at height one. A shear $(x,z)\mapsto(x+zv,z)$ translates $B$ arbitrarily while fixing $A$. The affine stabilizer of $A$ also acts. After these reductions there are 54 choices for $B$ over the first plane representative and 275 over the second. For every such pair, try all 26,073 line-free masks for the section $C$ at height $\omega$. A point $x$ in $A$ and $y$ in $B$ forbid the simultaneous choices $x+\omega(y-x)$ in $C$ and $x+\omega^2(y-x)$ in the last section. These are all lines transverse to the layers. A table indexed by each of the 65,536 allowed masks gives the largest line-free subset in the last section. The resulting 8,578,017 checks have maximum sizes 29 and 30 over the respective representatives. [Exhaustive plane program](plane_count.cpp)

The program can also list every last mask attaining 30. Across the reduced pairs it yields three candidate sets. An independent affine-map counter tries all $64\cdot63\cdot60\cdot48=11,612,160$ affine maps. For every ordered pair of candidates exactly 24 maps carry the first onto the second. This proves the orbit and stabilizer statements and supplies the count $11,612,160/24=483,840$. [Affine equivalence verifier](affine_orbits.cpp)

## One point below the maximum

There are **117,780,480** line-free 29-point sets, in **15 affine orbits**. Exactly **14,515,200** of these sets extend to a maximum set. Each of those extends in exactly one way. The two extendible orbit representatives have stabilizers of orders one and four. The other thirteen orbits are maximal under inclusion.

For 29 points, the same incidence count gives $\sum_P(8-s_P)^2=301$. If every plane had at most eight points, the four nonnegative deficits in each direction would sum to three. Their squared sums could total at most $21\cdot9=189$. A nine-point plane therefore exists, and at least one of the remaining parallel planes contains seven points. The plane search with target 29 yields 512 rooted candidates. For each candidate, map every one of its nine-point planes to either of the two standard shapes in every possible way and try all 48 transverse basis vectors. The least resulting point mask determines the orbit. The number of maps attaining it equals the affine stabilizer order, since the maps from a fixed source to a fixed image form a coset of the stabilizer. For each representative, try every absent point against all 336 affine lines. Summing the extension counts over the labeled sets gives $14{,}515{,}200=30\cdot483{,}840$, an independent incidence check against the 30-point census. [Orbit and extension verifier](canonical_sections.cpp) · [Representatives and counts](orbits29.tsv)

## Maximum sections in four dimensions

Fix the first maximum section by affine equivalence. Its 483,840 possible images split into 7,560 translation classes. The same shears and the stabilizer reduce the second maximum section to 351 choices. Given these two sections $A,B$, every ordered pair of points $a\in A,b\in B$ gives one forbidden pair between the last two sections by the transverse-line formula above. Test every one of the 483,840 possible third maximum sections. For the fourth, delete the forbidden points, then split on any full line remaining in its allowed mask, trying each of its four possible deletions. The maximum across **169,827,840** section pairs is three. The executable prints an explicit 93-point witness with section sizes $30,30,30,3$. [Exhaustive three-section program](three_sections.cpp)

Two maximum sections already imply that the other two sections together contain at most 49 points. If their total were at least 50, delete points to obtain sizes $l,50-l$ with $20\le l\le 30$. For each of the 351 choices for the second section, form a 64-by-64 compatibility table for the last two. For a candidate fourth point $v$, its row lists all compatible third points. For any common allowed mask $U$ in the third section, bound its maximum line-free subset by intersecting $U$ with the four planes in each of 21 parallel classes. The table from the 16-point plane gives an exact bound within each plane. The minimum of the 21 sums bounds the third section.

Reject a triple of fourth points when their common allowed mask cannot hold $l$ third points by this bound. A pair in a feasible fourth section must occur in at least $50-l-2$ acceptable triples whose third point is still compatible with both endpoints. Iteratively delete pairs failing this necessary condition. Branch on the remaining fourth points, checking internal line-freeness, pair and triple compatibility, and the recomputed third-section bound. Even this relaxation rejects every case. The run covers **3,861** size-and-section pairs in **257,306,730** branch nodes. [Two-section verifier](two_sections.cpp) · [Shared symmetry and transverse-line calculation](section_geometry.hpp)

For the general upper bound, a hypothetical 110-point set has 340 hyperplane section sizes $s_H$. Each point lies in 85 hyperplanes, and each pair in 21. This gives $\sum_H(30-s_H)^2=6{,}140$. The four nonnegative deficits in each parallel class sum to ten. If at most one deficit vanishes, the class contributes at most $8^2+1^2+1^2=66$ to that sum. Across all 85 directions the total would be at most 5,610. Some direction therefore has two 30-point sections, leaving 50 points in the other two. The two-section calculation excludes this. Deleting points excludes larger sets as well.

## Reproduction

Run the following in this directory. The first program sends its human-readable report to standard output and its rooted candidate masks to standard error. The affine verifiers accept those masks on standard input. The two-section program takes the range of third-section sizes to test.

```sh
c++ -O3 -std=c++17 plane_count.cpp -o /tmp/810-planes
c++ -O3 -std=c++17 affine_orbits.cpp -o /tmp/810-orbits
c++ -O3 -std=c++17 three_sections.cpp -o /tmp/810-sections
c++ -O3 -std=c++17 two_sections.cpp -o /tmp/810-two-sections
c++ -O3 -std=c++17 canonical_sections.cpp -o /tmp/810-canonical
/tmp/810-planes --census 2> /tmp/810-30.masks
/tmp/810-orbits < /tmp/810-30.masks
/tmp/810-sections < /tmp/810-30.masks
/tmp/810-two-sections 20 30 < /tmp/810-30.masks
/tmp/810-planes --census 29 2> /tmp/810-29.masks
/tmp/810-canonical < /tmp/810-29.masks
```
