# The cost of inserting one edge into a proper rainbow coloring

Let $H$ be a properly edge-colored graph on $n$ vertices in which every four-cycle is rainbow. Pick a missing edge $uv$. We may delete old edges and must keep the labels on every surviving old edge. The inserted edge must survive, and the final coloring must still be proper and rainbow on four-cycles.

**With a fresh label for $uv$, the minimum cost is exactly the number of length-three $u,v$ paths whose first and last edges have the same color. It is at most $\lfloor2(n-2)/3\rfloor$.** The upper bound is attained at every order $3r+2$ for $r\ge2$, even with a spare label inside the original $n$-color budget. With no fresh label guaranteed, the worst asymptotic cost per vertex lies between $2/3$ and $2-\sqrt7/2\approx0.677125$. A positive fixed gap above $2/3$ would yield quadratic-density witnesses for Erdős #810 at the corresponding orders. [Original problem](https://www.erdosproblems.com/810) · [Finite counting lemmas in Lean](../hall-reduction/EdgeInsertion.lean)

## Exact cost with a fresh label

Write $W=N_H(u)\cap N_H(v)$, $w=|W|$ and $N=n-2$. Call a color split when it occurs on both $ua$ and $vb$ with $ab\in E(H)$. Properness gives a unique ordered pair $(a,b)$ for each split color and $a\ne b$. The sets of $a$'s and $b$'s each have no repetitions. A split pair cannot have both ends in $W$ because $u,a,v,b$ would already form a nonrainbow four-cycle in $H$. Write $B$ for the number of split colors.

Every new nonrainbow cycle with $uv$ fresh consists of $uv$ and one split path $u,a,b,v$. The old edges of different split paths are disjoint. The spokes at either hub are different by properness. If two middle edges agreed, their endpoint pairs would agree or reverse. Agreement gives the same color, and reversal puts both ends in $W$. Thus any repair must delete at least $B$ old edges, even if the new label can be chosen freely. Deleting the $B$ middle edges suffices when $uv$ receives a fresh label.

Each split path uses a vertex outside $W$ that can occur in no other split path. Thus $B\le N-w$. Counting the two sets of ends with overlap confined to $W$ gives $2B\le N+w$. Adding these inequalities yields $3B\le2N$. The Lean lemmas check the injection, the exclusion of reversed middle edges and the disjoint-set lower bound. [Formal statements](../hall-reduction/EdgeInsertion.lean)

## Keeping the palette at $n$ colors

Fix a palette of $n$ labels containing all colors of $H$. Let $L$ be the minimum cost when $uv$ must take a label in this palette. Let $e(W)$ count the internal edges on the common neighbors. Two deletion strategies give

$$
2L\le N+w,\qquad
n L\le n(N-w)+e(W)+2w.
$$

For the first, clear the smaller of the two hub stars and color $uv$ with a label missing at the other hub. Each hub has at most $n-2$ neighbors. No four-cycle can contain the new edge after clearing its star. For the second, clear all spokes from either hub to vertices outside $W$. This costs at most $N-w$. Every remaining three-edge path from $u$ to $v$ has a middle edge in $W$, and its two outside spokes have distinct colors by the old four-cycle through both hubs. Adjacent old edges already have different colors. Among the $n$ labels, choose one occurring least on the $2w$ remaining spokes and the $e(W)$ internal edges together. Delete those occurrences and use that label on $uv$. A color present elsewhere in $H$ is harmless.

Combining the two bounds gives a finite implication for #810,

$$
e(W)\ge 3nL-2n(n-2)-2w.
$$

The subgraph on $W$ therefore has at least $3tn-2w$ edges whenever $L\ge2(n-2)/3+t$. The original $n$-vertex graph $H$ itself is an admissible witness with at least that many edges. On the smaller order $w>0$, retaining the $w$ most frequent color classes inside $W$ also gives $nM(w)\ge w e(W)$. In particular, if $M(n)=o(n^2)$ then the worst possible $L$ is $(2/3+o(1))n$. The lower construction at $3r+2$ extends to every order by adding at most two isolated vertices and using the same fresh label. [Combination of the finite inequalities](../hall-reduction/EdgeInsertion.lean)

There is an unconditional upper bound using the project's uniform rectangle theorem. Its application to $W\times W$ gives $e(W)\le w^2/4+o(n^2)$ uniformly. With $x=w/n$, the two strategies bound $L/n$ by the smaller of $(1+x)/2$ and $1-x+x^2/4+o(1)$. The former increases and the latter decreases on $[0,1]$. They meet at $x=3-\sqrt7$, giving $L\le(2-\sqrt7/2+o(1))n$. The status of this deduction depends on the repository's rectangle theorem. [Uniform rectangle proof](../graph-limits/quarter-short.md#every-rectangle-uniformly-over-a-linear-palette) · [Lean theorem](../hall-reduction/LinearPalette.lean)

## Constructions attaining the lower bound

For each $1\le i\le r$, introduce a common neighbor $z_i$ and two private neighbors $x_i,y_i$. Use the six edges $uz_i,vz_i,ux_i,vy_i,x_i z_i,y_i z_i$. There are $3r+2$ vertices. With $uv$ absent, color $ux_i,vz_i$ with $\alpha_i$ and $uz_i,vy_i$ with $\beta_i$. Take all $2r$ boundary labels distinct. Give the two types of middle edges two further, different labels. The coloring is proper. Its four-cycles are $u z_i v z_j$ and they are rainbow. All $2r$ boundary colors split, and the palette still has room for a fresh label. Thus $L=2r$.

One can also require that the enlarged support $G=H+uv$ admit an $n$-coloring with rainbow four-cycles, while every such coloring is improper. Choose $s\ge2$, $n=s(s+1)$ and $h\ge1$. Use $h$ square blocks through $uv$, sharing only those endpoints and their edge. Add $r=\lfloor(n-2-h(2s-1))/3\rfloor$ groups of three vertices as above, assuming $r\ge2$. Put the $\ell\in\{0,1,2\}$ spare vertices on a path attached to a private vertex.

Define $D$ as the least inherited deletion cost for properness over all admissible colorings of $G$. Define $R$ as the least number of edges to delete from $G$ if recoloring is allowed. For this family,

$$
D=hs,\qquad R=1,\qquad L=B=2r+h(s-1),\qquad
3L+D=2(n-2)-h-2\ell .
$$

Each full square block forces $s$ disjoint spoke deletions. To attain $D$, use the cyclic boundary pairing between blocks. In the added groups with $uv$ present, rotate only the labels on $ux_i$ and $vy_i$ by one index. The two new cycles through the middle edges of group $i$ now use distinct colors. Reserve a common color for $uv$ and choose the $2r$ group boundary labels outside the block boundary palettes. The full blocks require at most $1+h(2s-1)$ boundary labels for $h\ge2$, or $2s+1$ for one block. Both fit with the group labels. A mixed four-cycle uses two length-two paths between the hubs and is rainbow. All inherited repetitions are the $hs$ private apex pairs. [Block proof and boundary assignments](bouquet.md)

With $uv$ absent use the proper punctured coloring on each block and the unrotated coloring on each group. The boundary palettes of separate blocks and groups can be disjoint. The paired boundary spokes in a punctured block give $s-1$ split colors. All other boundary labels within a block occur on a single spoke. Fix a global interior label outside all boundary palettes. Within every block permute interior labels so that one private diagonal $a_1b_1$ has this label. That diagonal has a unique label in its punctured block. Give the group's middle edges and any padding path colors different from the reserved label. Delete the middle edge of every split path. In particular every designated diagonal is deleted, so the reserved label is now free for $uv$ within the same palette. This gives the displayed cost and realizes the lower bound. The identity follows by substituting $n=2+h(2s-1)+3r+\ell$.

Taking $h=1$ gives $R=1$ and $L/n\to2/3$. More generally any limiting inherited cost $D/n\to\theta$ for $0\le\theta\le1/2$ can be achieved together with $L/n\to(2-\theta)/3$ by choosing $h/s\to\theta$ and leaving room for two groups. The formula concerns the particular proper coloring of the punctured graph. The definition of $D$ minimizes over all colorings of the full support.

## Verification

On 462 vertices, one square block gives $D=21$ and requires 298 old-edge deletions to restore $uv$ to the specified proper coloring. At the same order, nine blocks give $D=189$ and require 240 deletions. The executable emits each of the three colored graphs. The independent audit verifies every four-cycle, counts edge-disjoint split paths, checks properness of both later stages, and compares the labels on every surviving edge. [Counts for ten examples](split-counts.tsv) · [C++ constructor](split_edges.cpp) · [Independent audit](check_split.py)

```sh
c++ -O3 -std=c++17 shared_edge.cpp -o "$SCRATCH/blocks"
c++ -O3 -std=c++17 split_edges.cpp -o "$SCRATCH/split"
cc -O3 ../../bruteforce/results/2026-11-21-0600/large/audit.c -o "$SCRATCH/audit"
"$SCRATCH/blocks" --square 21 original | "$SCRATCH/split" --blocks 21 1 original > "$SCRATCH/full"
"$SCRATCH/blocks" --square 21 recolored | "$SCRATCH/split" --blocks 21 1 punctured > "$SCRATCH/old"
"$SCRATCH/blocks" --square 21 recolored | "$SCRATCH/split" --blocks 21 1 restored > "$SCRATCH/new"
python3 check_split.py "$SCRATCH/audit" "$SCRATCH/full" "$SCRATCH/old" "$SCRATCH/new"
```
