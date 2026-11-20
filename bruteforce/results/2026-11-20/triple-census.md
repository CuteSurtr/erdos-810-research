# Small (7,4)-free triple systems

Let $g(n)$ be the largest number of distinct triples on $n$ points subject to every seven points containing at most three triples. For $n\ge7$, this is equivalent to requiring the union of any four triples to have at least eight points. These counts also include families in which two triples share a pair.

| Points | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Maximum triples | 3 | 4 | 6 | 7 | 9 | 12 | 13 | 15 | 18 | 18 | 21 | 23 | 25 | 28 |

Lean proves the values through 12 using explicit examples, a two-vertex argument at order ten, and vertex deletion. A degree-sum bound and three further constructions prove the values at 13, 14 and 15. All values in the table also have an independently checked construction. The code checks every four-triple union in each witness. [Small-order proof](../../../research/hall-reduction/SmallTripleNumbers.lean) · [Incidence bound and exact values](../../../research/hall-reduction/TripleIncidence.lean) · [Witnesses and completed census counts](triples.json)

## Exhaustive searches

The first program starts with an empty family on a fixed number of points, tries every possible new triple, and rejects an extension as soon as it contains four triples on seven or fewer points. Deleting any triple from an admissible family leaves an admissible family. This enumerates every family by induction. Nauty canonicalizes its incidence graph with the points and the triples in two separate color classes, retaining isolated points. This equality test respects precisely the allowed point relabelings. The complete runs through 15 points give all layer sizes, including the final empty layer. [Triple augmentation](enumerate_triples.cpp) · [Canonical incidence encoding](triple_canon.hpp)

The second program instead deletes a minimum-degree point of degree $d$ from an $n$-point, $m$-triple system. Its parent has $m-d$ triples on $n-1$ points, with $m-g(n-1)\le d\le\lfloor 3m/n\rfloor$. An extension adjoins a new point and $d$ distinct pairs of old points. It checks each possible mixture of old and new triples and enforces the minimum degree at the old points. A new violation involving the added point consists of four triples whose old points number at most six. A completed empty layer is an exhaustive exclusion at that cardinality. The search checks candidate cardinalities beginning at $\lfloor ng(n-1)/(n-3)\rfloor$, since each triple survives exactly $n-3$ of the $n$ single-point deletions. [Vertex augmentation](extend_triples.cpp)

Starting from the eight-point census, vertex augmentation reproduced each maximum and its number of extremal isomorphism types through 15 points. Starting from the full 14-point census, it extended those calculations to larger orders. For 20 points the deletion inequality allows 29 triples. That layer is empty, and a checked 28-triple witness establishes the exact maximum even before counting all extremal isomorphism types. A null type count in the data means enumeration of all extremizers at that order was unfinished. [Independent witness audit](audit_triples.py)

## Restrictions on a 32-triple system on 21 points

The census gives $30\le g(21)\le32$ using the 30-triple construction and single-point deletion from $g(20)=28$. A 32-triple system would have minimum degree at least four and would be linear by the diamond packing bound. Let $S$ be the largest sum of the three vertex degrees on a triple. The incidence bound above gives $S\le15$, and Cauchy–Schwarz gives $S\ge9\cdot32/21$, so $S$ is 14 or 15. [Checked constructions](triple-constructions.json) · [Linearity criterion](../../../research/hall-reduction/DiamondPacking.lean) · [Degree-sum proof](../../../research/hall-reduction/TripleIncidence.lean)

If $S=14$, a degree-six point would have twelve distinct degree-four neighbors. The eight remaining points would have total degree 42. Their squared degrees sum to at least $6\cdot5^2+2\cdot6^2=222$. Adding the degree-six point and its neighbors gives at least 450, whereas summing the degree cap over triples gives at most $32\cdot14=448$. A larger degree is impossible since two other points in every incident triple have degree at least four. The degree sequence is therefore twelve fives and nine fours.

If $S=15$, a point of degree seven would likewise have fourteen degree-four neighbors. Call its seven incident triples the arms. For each arm $e$, the twelve other triples touching $e$ leave twelve pairs on the eighteen points outside $e$. Their components are six two-edge paths by equality in the incidence bound. The other six arms contribute six disjoint pairs, necessarily one in each path. Its second edge comes from a triple meeting $e$ away from the degree-seven point, meeting another arm, and containing one of the six points outside all the arms. Every outside point appears in exactly one such path for each $e$. Fixing an outside point would therefore pair up the seven arms, which is impossible. This leaves maximum degree at most six.

The program enumerates the possible neighborhoods of a triple attaining $S$. Up to relabeling its three points and the outside vertices, its neighborhood is specified by the root labels on the single edges and the two-edge paths. The degree restrictions above leave ten rooted cases. Each completion still has to satisfy all four-triple constraints. [Root enumeration](rooted_triples.py) · [Completion search](triple_neighborhood.cpp)

## Reproduction

The sources use C++17 and nauty 2.8.9. Set `NAUTY_DIR` to the extracted and built nauty directory containing `nauty.h` and `nauty.a`. From this results directory, run the following commands with a fresh scratch directory.

```sh
c++ -std=c++17 -O3 -I"$NAUTY_DIR" enumerate_triples.cpp "$NAUTY_DIR/nauty.a" -o "$SCRATCH/enumerate"
c++ -std=c++17 -O3 -I"$NAUTY_DIR" extend_triples.cpp "$NAUTY_DIR/nauty.a" -o "$SCRATCH/extend"
for n in 7 8 9 10 11 12 13 14 15; do
  "$SCRATCH/enumerate" "$n" "$SCRATCH/triples$n" 7200 2000000
done
for n in 8 14; do
  "$SCRATCH/enumerate" "$n" "$SCRATCH/base$n" 7200 2000000 save-layers
done
"$SCRATCH/extend" 8 15 "$SCRATCH/base8" "$SCRATCH/vertex-crosscheck" 7200 2000000
"$SCRATCH/extend" 14 20 "$SCRATCH/base14" "$SCRATCH/vertex-census" 12800 1500000
python3 audit_triples.py "$SCRATCH" "$SCRATCH/triples.json"
```

The audit derives upper bounds only from completed eliminations and the deletion inequality. A completed optimum requires a witness at the matching lower bound. [Nauty and Traces](https://pallini.di.uniroma1.it/)
