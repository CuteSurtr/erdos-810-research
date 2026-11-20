# Line-free sets over the four-element field

The largest subset of the 64 points of $\mathbb F_4^3$ containing no entire affine line has **30 points**. All 483,840 maximum sets are affinely equivalent, and their affine stabilizer has order 24. Equivalently, 34 points are necessary and sufficient to meet every affine line. In $\mathbb F_4^4$ we certify a range of **95 to 110**. If three parallel 3-dimensional sections each contain 30 points, the fourth contains at most **three**, and three is attainable. These computations concern complete four-point lines. The 64-point model gives at most $64\cdot30=1,920$ occupied entries in the additive block for #810. [Finite graph application](../../../bruteforce/results/2026-11-21-0600/products/affine/README.md) · [95-point coordinates](../../../bruteforce/results/2026-11-21-0600/products/affine/recipes.json)

## Reducing a 30-point set to parallel planes

Represent $0,1,\omega,1+\omega$ by the two-bit integers $0,1,2,3$ with $\omega^2=1+\omega$. There are 20 lines in the 16-point affine plane. Directly testing its 65,536 point subsets gives 26,073 line-free sets. The maximum has nine points, and exactly 1,120 subsets attain it. The affine group of order 2,880 has two orbits on those nine-point sets. The least integer masks in the orbits are 1,911 and 1,915.

Every line-free 30-point set in three dimensions has a nine-point plane. If all planes had at most eight points, write $s_P$ for the number in plane $P$. The 21 parallel classes contain four planes each. Their four deficits $8-s_P$ sum to two, giving $\sum_P(8-s_P)^2\le84$. Each point belongs to 21 planes, and two distinct points belong together to five. Thus $\sum_Ps_P=630$ and $\sum_Ps_P^2=630+5\cdot30\cdot29=4,980$. Expanding gives $\sum_P(8-s_P)^2=276$, a contradiction. Any larger set contains a 30-point subset, and so also has a nine-point plane. At least one of the remaining three parallel planes contains seven points.

Use affine coordinates to put the nine-point section $A$ at height zero and a section $B$ of at least seven points at height one. A shear $(x,z)\mapsto(x+zv,z)$ translates $B$ arbitrarily while fixing $A$. The affine stabilizer of $A$ also acts. After these reductions there are 54 choices for $B$ over the first plane representative and 275 over the second. For every such pair, try all 26,073 line-free masks for the section $C$ at height $\omega$. A point $x$ in $A$ and $y$ in $B$ forbid the simultaneous choices $x+\omega(y-x)$ in $C$ and $x+\omega^2(y-x)$ in the last section. These are all lines transverse to the layers. A table indexed by each of the 65,536 allowed masks gives the largest line-free subset in the last section. The resulting 8,578,017 checks have maximum sizes 29 and 30 over the respective representatives. [Exhaustive plane program](plane_count.cpp)

The program can also list every last mask attaining 30. Across the reduced pairs it yields three candidate sets. An independent affine-map counter tries all $64\cdot63\cdot60\cdot48=11,612,160$ affine maps. For every ordered pair of candidates exactly 24 maps carry the first onto the second. This proves the orbit and stabilizer statements and supplies the count $11,612,160/24=483,840$. [Affine equivalence verifier](affine_orbits.cpp)

## Three maximum sections in four dimensions

Fix the first maximum section by affine equivalence. Its 483,840 possible images split into 7,560 translation classes. The same shears and the stabilizer reduce the second maximum section to 351 choices. Given these two sections $A,B$, every ordered pair of points $a\in A,b\in B$ gives one forbidden pair between the last two sections by the transverse-line formula above. Test every one of the 483,840 possible third maximum sections. For the fourth, delete the forbidden points, then split on any full line remaining in its allowed mask, trying each of its four possible deletions. The maximum across **169,827,840** section pairs is three. The executable prints an explicit 93-point witness with section sizes $30,30,30,3$. [Exhaustive three-section program](three_sections.cpp)

For the general upper bound, suppose a 111-point set exists. In four dimensions each point belongs to 85 affine hyperplanes and two points belong together to 21. For its 340 section sizes $s_H$, these counts give $\sum_H(30-s_H)^2=5,745$. The four deficits in a parallel class sum to nine. If the class contains fewer than three maximum sections, at least two deficits are positive and their squared sum is at most $8^2+1^2=65$. This would give at most $85\cdot65=5,525$ in total. Consequently some parallel class has three maximum sections, leaving 21 points in the fourth. The three-section bound excludes that possibility. Deleting points rules out every larger size as well.

## Reproduction

Run the following in this directory. The first program sends its human-readable report to standard output and its rooted candidate masks to standard error. The other two programs both accept those masks.

```sh
c++ -O3 -std=c++17 plane_count.cpp -o /tmp/810-planes
c++ -O3 -std=c++17 affine_orbits.cpp -o /tmp/810-orbits
c++ -O3 -std=c++17 three_sections.cpp -o /tmp/810-sections
/tmp/810-planes --census 2> /tmp/810-30.masks
/tmp/810-orbits < /tmp/810-30.masks
/tmp/810-sections < /tmp/810-30.masks
```
