# First run (2026-10-19)

These files come from the first brute-force attempt. It was meant to run in
the cloud but ran on the user's laptop and was stopped. Its results are
**not independently verified**; the cloud tasks re-derive them.

Reported results:

- M(10) = 30. Exactly 2 good 30-edge graphs up to isomorphism. All 71,318
  isomorphism classes with 31 edges have a clique K11 in Q.
- M(11) = 34. All 15,108,047 isomorphism classes with 35 edges fail:
  15,108,045 have K12 in Q, and 2 needed exhaustive colouring
  (one of them has clique number 11 but chromatic number 13).
  There are exactly 131 good 34-edge graphs, one of them 10-colourable.
- n = 9 at 24 edges: 5,995 isomorphism classes, all with K10 in Q.
- M(12) at 41 edges: shards 0, 1, 255, 511 of `geng -q 12 41:41 res/512`
  with the prune hook (K = 12) found no good graph (6–9 CPU-seconds each).

`n11_e34_good.certs` lists the 131 good 34-edge graphs as
`GOOD <graph6> [(u,v,c),...]`.

`src/` holds the checkers:

- `q810.h`: conflict graph Q, clique bound, DSATUR.
- `chkB.h`: an independently written checker that builds Q from explicit
  4-cycles.
- `filt810.c`: stdin graph6 filter.
- `prune810.c`: geng PRUNE hook rejecting any intermediate graph whose Q
  needs more than K colours (K from env `M810_K`, default maxn).
- `verify_cert.py`, `polya.py`, `hard_check.py`, `agg.py`, `cert2g6.py`:
  helpers.

Build on Linux, with nauty 2.8.x unpacked at `$N` and its `W1` objects built:

```bash
gcc -O3 -march=native -o filt810 filt810.c
gcc -O3 -march=native -DMAXN=WORDSIZE -DWORDSIZE=32 -I$N -DPRUNE=prune810 -DSUMMARY=summary810 \
  -o geng810 $N/geng.c prune810.c $N/gtoolsW.o $N/nautyW1.o $N/nautilW1.o \
  $N/naugraphW1.o $N/schreier.o $N/naurng.o
```
