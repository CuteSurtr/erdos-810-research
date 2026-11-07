# Erdős #810 brute-force round (October 2026)

Computational attacks on Erdős problem #810. Each cloud agent gets one task file
in `tasks/` and writes only to `results/<TASK>/`.

## Problem

For a simple graph G on n vertices, an edge colouring c: E(G) → {0, …, n−1} is
**valid** if every 4-cycle of G gets 4 distinct colours. A 4-cycle here is any
subgraph isomorphic to C4, not necessarily induced. Nothing else is required:
edges that do not lie on a common 4-cycle may share a colour.

M(n) is the largest |E(G)| over n-vertex graphs that admit a valid colouring with
at most n colours. Erdős asks whether M(n) ≥ εn² for all large n.
Burr–Erdős–Graham–Sós (1989) believed not. They noted M(n) ≥ c·g(n;7,4), which
gives M(n) ≥ n^(2−o(1)).

**Conflict graph.** Q(G) has vertex set E(G), with two kinds of conflicting pairs:

- adjacent edges uv, vw conflict iff u and w have a common neighbour x ≠ v;
- disjoint edges uv, xy conflict iff ux, vy ∈ E or uy, vx ∈ E.

A colouring is valid iff it properly colours Q(G), so G is *good* iff
χ(Q(G)) ≤ n. For a fixed colour budget k, k-goodness is closed under deleting
edges and vertices. So M(n) = e iff some n-vertex graph with e edges is good and
no n-vertex graph with e + 1 edges is good.

## Known values

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|----|----|----|
| M(n) | 0 | 0 | 1 | 3 | 5 | 7 | 11 | 14 | 17 | 23 | 30* | 34* | ≥ 40 |

- n ≤ 6 are proved in Lean by kernel `decide`, in
  `formalization/legacy/BruteForce.lean` on branch `lean-formalization`.
- The lower bounds for n ≤ 12 are Lean-checked certificates in the same file.
- The upper bounds for 7–9 come from an earlier exhaustive search.
- Values marked * are from the unverified first run in `data/first-run/`.

Local-search lower bounds for n = 13..25 (certificates in
`data/results-2026-10-14.json`, key `lower_bounds`, edges as `[u, v, colour]`):

| n | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 |
|---|----|----|----|----|----|----|----|-----|-----|-----|-----|-----|-----|
| LB | 46 | 53 | 60 | 68 | 76 | 85 | 93 | 102 | 110 | 121 | 132 | 141 | 152 |

LB/n² falls from 0.272 at n = 13 to 0.243 at n = 25.

The repository's notes (`*.md` at the root of `main`) study the bipartite
**affine model** over F_p. Rows and columns are both F_p. Colour a ∈ F_p^× is
the partial map x ↦ ax + β(a) on a row domain D_a. Several restricted support
classes are proved there to give o(p²) edges.

## Rules for every agent

1. **Placement.** Run `uname -a; nproc; free -g` first and put the output at the
   top of your `REPORT.md`. All computation stays in this cloud container.
2. **Git.** Before your first commit run
   `git config user.name CuteSurtr && git config user.email 133225877+CuteSurtr@users.noreply.github.com`.
   - Commit only inside `bruteforce/results/<TASK>/`.
   - Use plain commit messages, with no AI co-author or attribution trailers.
   - Push to `bruteforce-2026-10`, retrying with `git pull --rebase` on rejection.
   - Never push to `main` or `lean-formalization`.
   - Do not use branch names containing "claude".
3. **Checkpoints.** Commit and push partial progress at least every 45 minutes.
   If pushing fails entirely, keep going; your final message is read back through
   the run log.
4. **Waiting.** Do not end your turn while work is still running, because
   ScheduleWakeup does not fire here. Poll your own background jobs with short
   sleeps instead.
5. **Downloads.** If an install or download is blocked (for example by the
   auto-mode classifier), try another source: apt, pip (`python-sat` bundles
   CaDiCaL), or GitHub releases. Failing that, write the code yourself. Note what
   you used.
6. **Lean.** Never write `sorry` or `admit` in any Lean file.
7. **Time budget.** Wrap up by the deadline in your task file.
   - If something needs longer, write an exact sharding plan into `REPORT.md`:
     commands, shard boundaries, measured time per shard and the full source.
     Other agents can then finish it.
   - Finish with a final commit and a final message containing the results summary.

## Rigor

- **Lower bounds.** Every lower bound needs an explicit certificate. Re-verify it
  with a separate, deliberately simple checker that enumerates all 4-cycles
  directly and checks that colours are in 0..n−1.
- **Upper bounds and exact values.** These need an exhaustive method validated on
  known cases. Also use a second independent method or a checked DRAT/LRAT proof.
- **Labels.** Mark every result as *proved*, *certificate-verified*, *heuristic*
  or *unfinished*. Never round a partial search up to a claim.

## REPORT.md layout

1. Placement output (`uname`, `nproc`, memory).
2. Results table with a status for each result.
3. Certificates, machine-readable, also saved as `certs.json`:
   `{"n": [[u, v, c], ...]}` or the task-specific format.
4. Method, parameters, counts, timings and validation.
5. Where the code lives in your results folder.
6. Surprises, and suggested next steps.
