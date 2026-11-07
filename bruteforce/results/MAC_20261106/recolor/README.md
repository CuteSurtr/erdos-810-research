# Vertex deletion with safe color elimination

Single-thread deterministic positive-certificate search, 6 November 2026.
No upper bounds, exhaustive optimality claims, or UNSAT claims are made.

Given a valid rainbow-C4 colored graph on n vertices with colors 0,...,n-1:

1. Delete a vertex v.
2. Choose a color c to eliminate.
3. For each surviving c-edge, choose any other color absent from every
   surviving C4 containing that edge. Delete the edge if none exists.
4. Relabel vertices and the remaining n-1 colors consecutively.

The recolorings are independent: two old c-edges cannot coexist in a C4
of the original valid graph. Hence a surviving C4 has at most one changed
edge, and its chosen new color differs from the other three. Deleting edges
cannot create C4s.

The executable enumerates each original C4 once. For each edge and other
color, it stores the intersection of the vertex sets of all C4s witnessing
that conflict. Deleting v removes that conflict exactly when v belongs to
this intersection. Endpoints of the edge are excluded from the stored set;
edges incident to v are deleted separately. This gives exact scores for
every pair (v,c), without re-enumerating cycles after each vertex deletion.
This is exact optimization only for this particular one-step rule.

The driver starts from the largest baseline/current construction available
at each n, processes n in descending order, and reuses any improved output
as a later source. Every retained certificate is checked by both the existing
C checker enumerating all four-vertex sets and all three cycles, and the
independent Python checker enumerating closed wedges.

Files:

- recolor.cpp / recolor: source / compiled single-thread worker.
- run.py: bounded sequential driver; --seconds sets the monotonic deadline.
- full-certs.json: all independently checked outputs.
- full-improvements.json: outputs beating the initial construction incumbents.
- full-provenance.json: source hashes, deletions, recolor counts, both checker logs.
- full-source-N.txt: exact input snapshots for reproducibility.
- small-* files: initial eleven-source feasibility test.

The construction baseline has weak entries at very small n. Improvements
there must be compared against the repository's exact finite results before
being described as new lower bounds.

Build:
    c++ -O3 -std=c++17 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX15.4.sdk recolor.cpp -o recolor
Run:
    python3 run.py --seconds 1200 --tag full

All searches and both checkers run sequentially, using at most one CPU core.

## Continuing supervised run

The background supervisor runs one sequential worker. It refreshes construction
and recoloring incumbents, randomizes labels to diversify equally good choices,
and repeats after a 180-second idle interval. Every published best/N.json is
atomically replaced only after both independent checks pass. Exact input snapshots
and metadata are retained. Non-improving exploratory outputs are discarded.

The supervisor pauses its entire worker process group above 70% measured total
machine CPU and resumes below 55%. Creating STOP in this directory ends the run.
Search stops at 2026-11-05 23:25 UTC (06 Nov 08:25 Seoul); final independent
verification must finish by 23:35 UTC. PIDs are in pids.json, measurements in
resources.jsonl, and the final checked certificates/report will be final-certs.json
and final-status.json. The first complete deterministic pass took 65.438 seconds
and improved 28 construction incumbents in n=13,...,128; all passed both checks.

The guard is a sampled, conservative throttling mechanism; unrelated system
processes can cause brief total-machine spikes. It does not promise an
instantaneous whole-machine 95% ceiling. Historical resource logs are retained.
