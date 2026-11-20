# Evening graph search for Erdős #810

At 4:30 p.m. Seoul time on November 20, the search had strengthened the 1 p.m. lower bounds at **62 graph orders**, gaining 2,309 edges across those orders. On 128 vertices the bound rose from 2,833 to **2,944 edges**. All 542,384 four-cycles in that graph use four distinct colors. [Graphs](certs.json) · [Before and after counts](improvements.json) · [Cycle counts](checks.txt)

| Seoul checkpoint | Improved orders | Total gain over 1 p.m. |
| --- | ---: | ---: |
| [3 p.m.](https://github.com/CuteSurtr/erdos-810-research/commit/be9937fd8770dc9daea7283c1ed2646555aaa902) | 24 | 75 |
| [3:33 p.m.](https://github.com/CuteSurtr/erdos-810-research/commit/34b1a20d69c3e15352302eed1e9baa6946f14009) | 50 | 546 |
| [3:45 p.m.](https://github.com/CuteSurtr/erdos-810-research/commit/1e1228acc10d112315b06950dfe455d1c2f93321) | 51 | 813 |
| 4:30 p.m. | 62 | 2,309 |

The frozen starting catalog takes the best verified graph at each order through 128 from the previous archive and the 1 p.m. release. Its SHA-256 is `67ffcf9f13af768eaa965e45b24f66bcb13ef913a1203db539f6427a0c261d81`. Each JSON key is the vertex count and each triple gives two endpoints and a color, numbered from zero. A C checker enumerates four-vertex subsets and a separate Python program enumerates pairs of common neighbors. Both check the color budget, edge count and every four-cycle, and agreed on every line of the release. [Previous checkpoint and reproduction commands](../2026-11-20/README.md)

A third check runs the packed common-neighbor predicate in Lean 4.24 for every released graph. Generate the input with `python3 ../2026-11-20/emit_matrix.py certs.json all /tmp/EveningAudit.lean --runtime`, then run `lake env lean -j1 /tmp/EveningAudit.lean` from `research/hall-reduction` with the certificate module built. This is a Lean runtime test. Its general soundness theorem is kernel-checked. [Lean checker and theorem](../../../research/hall-reduction/MatrixCertificate.lean)

## Searching with distinct spoke colors

For a proposed new vertex with neighbor set $S$, inspect each old two-edge path $u,w,v$ with $u,v\in S$. If its old colors agree, the proposal fails. Otherwise both old colors are forbidden on either new spoke at $u,v$. Assign the remaining colors injectively to $S$ by bipartite matching. A successful assignment makes every new four-cycle rainbow, as each uses exactly one such path and its two spokes. This search restricts the new spokes to distinct colors. It can grow a graph by one vertex or replace the star of an existing vertex, while preserving the coloring away from that star.

The C++ search alternates greedy extensions, small random deletions, and restarts from an existing neighborhood. For a fixed proposal it applies an exact augmenting-path matching oracle. Its fixed-set mode was compared with direct enumeration on all 1,000 choices of a three-vertex edge-colored base and a set of neighbors for the fourth vertex. Every accepted search record is rerun through the graph checker before entering the shared certificate pool. [Matching oracle](hall_extension.cpp) · [Search schedule](hall_search.py) · [Exhaustive oracle comparison](check_hall.py)

From this directory, build with `c++ -O3 -std=c++17 hall_extension.cpp -o "$SCRATCH/hall_extension"`, then run `python3 check_hall.py "$SCRATCH/hall_extension"`. The search driver takes a working directory with the frozen baseline and compiled four-vertex checker, the built oracle, and a timezone-aware closing time supplied with `--until`.

## Inserting edges by recoloring

For a missing edge $uv$ in a properly colored witness, each old path $u,a,b,v$ creates one new four-cycle. The only new conflict between old edges is between $ua$ and $bv$ when their colors agree. The search ranks missing edges by this count, temporarily removes one label from each conflicting pair, and gives the new edge and displaced edges valid labels. It tries colors with few conflicts first and can displace other labels to a bounded depth. Each final label differs from those of all incident edges and all opposite edges on four-cycles. The Hall and insertion searches read each other's verified improvements. [Insertion code](edge_repair.cpp) · [Search driver](repair_search.py)

Build with `c++ -O3 -std=c++17 edge_repair.cpp -o "$SCRATCH/edge_repair"`. Its input is `n m milliseconds seed` followed by the colored edge triples. Its output is the new edge count followed by the revised triples. The independent tests check the original edges are retained and inspect every four-cycle. Run `python3 check_repair.py "$SCRATCH/edge_repair"` to reproduce them.
