# November 20 research on Erdős #810

The graph search starts from the repository's strongest certified construction found at each order, including rotation-equivariant graphs and graphs obtained by extending a smaller witness with a pendant edge. The frozen baseline covers orders 13 through 128. Its SHA-256 is `acf44b915a906ecac1f906a6823b10b61a0048981faf265200d4df96d1a379d4`. Each certificate lists the two endpoints and the color of every edge, numbered from zero.

The 1 p.m. KST checkpoint improved **47 graph orders** beyond 10 a.m., with 294 additional edges summed across those orders. Examples include 75 vertices from 1,188 to 1,199 edges, 119 vertices from 2,500 to 2,518 edges, 120 vertices from 2,517 to 2,552 edges. Against the frozen November 8 baseline, 74 orders gained a total of 1,270 edges. The C four-vertex checker and the independent Python common-neighbor checker agreed on every released witness. A third check evaluated the Lean common-neighbor verifier on exactly the released graphs at 75 vertices and at each order from 119 through 124. The 120-vertex graph has 400,940 four-cycles, all rainbow. These are certified lower bounds for the individual graph orders. [Released graphs](certs.json) · [Edge counts](improvements.json) · [Cycle counts](checks.txt)

The morning checkpoint improved the November 8 baseline at 63 orders. Compared with the 06:00 KST checkpoint, 27 orders gained a total of 119 additional edges. At 117 vertices the construction increased from 2,434 edges to 2,443. At 118 it increased from 2,455 to 2,475, and at 119 from 2,477 to 2,500. The 106-vertex witness has 2,095 edges. One checker enumerates four-vertex sets in C. The other enumerates pairs of common neighbors in Python. Their counts of four-cycles agree for every morning graph. The released files above contain the later verified checkpoint.

## Search methods

The extension search adds one vertex or removes a vertex and finds a better attachment to the remaining colored graph. C++ builds the constraints directly in CaDiCaL. In a separate search, a one- or two-edge change to the topology allows every edge to change color. Two edges conflict exactly when a four-cycle contains both. A tabu search repairs the incumbent coloring, and a SAT solver tries to color the full conflict graph. A third search deletes one vertex and one color from a larger graph, with recolorings, to find lower-order constructions. The searches exchange independently checked improvements. An unsatisfiable fixed-topology or fixed-attachment instance excludes just that particular possibility. [Extension solver](native_extension.cpp) · [Topology solver](topology_color.cpp) · [Color and vertex projection](project_search.py)

The extension encoding matched exhaustive attachment search on 319 small graphs at the optimum and one above it. The conflict-graph encoding matched a direct color enumeration in 720 topology and palette cases. The individual witness checkers use neither encoding. [Attachment cross-check](check_native.py) · [Topology cross-check](check_topology.py)

## Reproduction

Build the C++ programs with C++17. The SAT searches used CaDiCaL 2.1.3. From this results directory, the following commands check the released graphs and the independent hypergraph data.

```sh
python3 ../LINUX_20261108/constructions/src/certcheck.py certs.json
cc -O3 ../LINUX_20261108/constructions/src/fourset_check.c -o "$SCRATCH/fourset_check"
```

The C checker reads one graph in the format `n m` followed by `m` lines of `u v color`. The search supervisor's checkpoint mode runs both checkers and compares the results. A fresh search uses `run_search.py` with a new scratch path, an absolute timezone-aware cutoff, the CaDiCaL executable, and its built source directory. The Lean matrix generator converts one selected JSON witness into packed rows and a kernel proof. [Search supervisor](run_search.py) · [Lean matrix checker](../../../research/hall-reduction/MatrixCertificate.lean) · [Certificate generator](emit_matrix.py)

The separate census of $(7,4)$-free triple systems found exact auxiliary hypergraph values through 20 vertices. [Census, witnesses, and reproduction](triple-census.md) · [Research proofs](../../../research/hall-reduction/README.md)
