# Evening graph search for Erdős #810

At 3:33 p.m. Seoul time on November 20, the independent checkers confirmed stronger lower bounds at **50 graph orders** relative to the 1 p.m. release, with 546 edges gained in total. On 120 vertices the bound rose from 2,552 to 2,572 edges. On 126 vertices it rose from 2,750 to 2,794 edges, with all 471,253 four-cycles rainbow. [Graphs](certs.json) · [Before and after counts](improvements.json) · [Cycle counts](checks.txt)

The 3 p.m. checkpoint had improved 24 orders by 75 edges in total. [Earlier release](https://github.com/CuteSurtr/erdos-810-research/commit/be9937fd8770dc9daea7283c1ed2646555aaa902)

The frozen starting catalog takes the best verified graph at each order through 128 from the previous archive and the 1 p.m. release. Its SHA-256 is `67ffcf9f13af768eaa965e45b24f66bcb13ef913a1203db539f6427a0c261d81`. Each JSON key is the vertex count and each triple gives two endpoints and a color, numbered from zero. A C checker enumerates four-vertex subsets and a separate Python program enumerates pairs of common neighbors. Both check the color budget, edge count and every four-cycle, and agreed on every line of the release. [Previous checkpoint and reproduction commands](../2026-11-20/README.md)

## Searching with distinct spoke colors

For a proposed new vertex with neighbor set $S$, inspect each old two-edge path $u,w,v$ with $u,v\in S$. If its old colors agree, the proposal fails. Otherwise both old colors are forbidden on either new spoke at $u,v$. Assign the remaining colors injectively to $S$ by bipartite matching. A successful assignment makes every new four-cycle rainbow, as each uses exactly one such path and its two spokes. This search restricts the new spokes to distinct colors. It can grow a graph by one vertex or replace the star of an existing vertex, while preserving the coloring away from that star.

The C++ search alternates greedy extensions, small random deletions, and restarts from an existing neighborhood. For a fixed proposal it applies an exact augmenting-path matching oracle. Its fixed-set mode was compared with direct enumeration on all 1,000 choices of a three-vertex edge-colored base and a set of neighbors for the fourth vertex. Every accepted search record is rerun through the graph checker before entering the shared certificate pool. [Matching oracle](hall_extension.cpp) · [Search schedule](hall_search.py) · [Exhaustive oracle comparison](check_hall.py)

From this directory, build with `c++ -O3 -std=c++17 hall_extension.cpp -o "$SCRATCH/hall_extension"`, then run `python3 check_hall.py "$SCRATCH/hall_extension"`. The search driver takes a working directory with the frozen baseline and compiled four-vertex checker, the built oracle, and a timezone-aware closing time supplied with `--until`.
