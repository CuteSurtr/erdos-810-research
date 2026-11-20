# How many optimal colorings are there?

There are **173,139** inequivalent colorings of the optimal 47-edge graphs on 13 vertices. Relabeling vertices or permuting colors preserves the class. Exactly **168,120** classes are proper and **5,019** have an equal-colored incident pair. There are **1,971** underlying graphs with a unique coloring up to both symmetries. The most flexible single graph has **4,346** coloring classes. All the colorings use 13 labels because 12 labels support at most 46 edges. [Per-graph counts](data/color-counts-13.tsv.gz) · [Fixed-palette upper bound](../2026-11-21/README.md#twelve-colors-on-the-same-13-vertices)

On a fixed representative of each support, identifying only color permutations gives 187,664 partitions in total. Of the 11,461 supports, 11,307 have trivial vertex automorphism group, 149 have group order two, and five have group order four. The two computations below agree on all 11,461 rows, including the automorphism orders and the proper-coloring counts. [Underlying graphs](data/optimal-13.g6)

## Direct enumeration

The first C++ program lists four-cycles and constructs the conflict graph on the original edges. It fixes the colors on a clique, then enumerates every coloring of the remaining edges, introducing a new color only at its first use. At a leaf it normalizes color labels in edge order. It keeps the lexicographically least normalized coloring under all automorphisms of the underlying graph. The program finds those automorphisms directly by refining vertex classes and testing adjacency during backtracking. [Direct coloring count](native/count_colorings.cpp)

## Independent orbit count

The second program constructs conflicts using common neighbors and enumerates every nonempty independent set of original edges. A partition into color classes is an exact cover by these sets. It obtains graph automorphisms independently from nauty. For each automorphism, a fixed partition is a disjoint union of whole orbits of independent sets. An orbit is eligible if its distinct sets are pairwise disjoint. We branch on the orbit covering a chosen uncovered edge, charging one color per set. The average fixed-partition count over the group gives the number of coloring classes by Burnside's lemma. Adding conflicts on every pair of incident edges gives the independent proper-coloring count. [Exact-cover counter](native/burnside_count.cpp) · [nauty group enumeration](native/orbit_group.c)

```sh
sh native/build.sh "$NAUTY" "$SCRATCH"
"$SCRATCH/count-colorings" 13 < data/optimal-13.g6 > "$SCRATCH/direct.txt"
"$SCRATCH/burnside-count" 13 < data/optimal-13.g6 > "$SCRATCH/burnside.txt"
awk '{print $1,$2,$3,$4,$5}' "$SCRATCH/direct.txt" > "$SCRATCH/direct-five.txt"
cmp "$SCRATCH/direct-five.txt" "$SCRATCH/burnside.txt"
```

Both methods also agree at every order from two through twelve. On ten vertices the two optimal graphs each have a unique coloring up to the two relabelings. On twelve vertices 3,330 optimal supports yield 226,758 colored classes. On four and six vertices the unique optimal support requires a repeated incident color. Imposing properness lowers the edge maximum from five to four on four vertices and from eleven to ten on six. [Full table](data/census-by-order.tsv) · [Previous exact uncolored bounds](../M12/REPORT.md)

On 14 vertices there are **1,151** optimal coloring classes across **52** underlying graphs. Every one of these colorings is proper. Both counters give the same values on every support. [Per-graph counts](data/color-counts-14.tsv.gz) · [Graphs](data/optimal-14.g6)

## Comparison with public finite results

Tao's December 2025 AlphaEvolve experiments gave 47, 54 and 62 edges at orders 13, 14 and 15, respectively, and explicitly left optimality open. A July 2026 computational report establishes optimality through order ten. The sources checked on 21 November 2026 yielded no earlier exact 14-vertex maximum or complete 13-vertex coloring census. Historical priority remains unverified. The original problem asks for a positive edge density at all sufficiently large orders. [Tao's table](https://www.erdosproblems.com/forum/thread/810) · [July 2026 report](https://www.erdosproblemaday.com/report/810) · [Original problem](https://www.erdosproblems.com/810)
