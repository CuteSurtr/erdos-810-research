# Bounded Linux continuation, 8 November 2026

Starting revision: `26b47d3dbbb621d223ab5348ee5919517882af6c`, branch
`research-2026-11-07`. The user authorized local computation until approximately
06:00 Korea time, with low resource use. This run uses CPUs 30 and 31 only,
niceness 19 and idle I/O priority. There is one cyclic proof worker and one
construction worker. Search stops at 05:50 KST; final verification ends by
05:58; a separate watchdog enforces the 06:00 hard stop (7 November 21:00 UTC).
No model session is needed for shutdown or the final scoped Git checkpoint.

The cyclic task continues n=56, k=14 from 18,191 checked leaves and 578 open
branches in the merged history. Four of nine root cases were closed before
this run. The exact cyclic n=43 result is already finished on the Mac and is
not repeated. Earlier proof archives remain on the other computer; recorded
historical verdicts are accepted here only after regenerating matching CNF
hashes. New proofs are checked locally by native drat-trim and retained in
`cyclic/proofs`, outside Git, with a 20 GB run quota. Solvers have a 3 GiB
address-space limit and a 2 GiB per-file limit.

The constructor searches n=26 through 128 using the merged November 7 lower
bounds, explicit pendant padding, 45 saved search states and 18,262 distinct
restricted-neighborhood UNSAT cache keys. Its address-space limit is 1 GiB.
These cache entries only describe restricted moves, not global upper bounds.
All 168 baseline/search-state certificates passed the C four-set checker;
positive SAT and negative checked-UNSAT controls passed before launch.

Run configuration, input hashes and native tool provenance are recorded in
`config.json`, `source-manifest.json` and `tools/manifest.json`. The controller
is `src/run.py`; its independent watchdog uses `--watchdog`. Creating a file
named `STOP` in this directory requests an orderly stop and final checks.
Current status is in `logs/status.json`. New lower bounds must pass both the
C four-set checker and the independent Python common-neighbor checker before
appearing in the final verified table.

At shutdown, `FINAL-COMPUTE-REPORT.md`, `logs/final-summary.json`,
`verified/improvements.json` and `cyclic/logs/final-closecheck.txt` record the
outcome. The controller attempts a commit and push scoped to this directory;
`logs/git-checkpoint.log` records success or failure locally. A partial cyclic
search is not an upper-bound proof. No unrestricted solution, published-record
claim, or historical-priority claim is made.

Analytic work for this session belongs under `analytic/`. Its mathematical
assumptions and literature comparisons must be stated separately from these
finite computational certificates.

## First live checkpoint

`verified/0100KST/` freezes the results at 15:58 UTC (00:58 KST): nine strict
construction improvements passed both graph checkers; 146 new UNSAT leaves
passed native DRAT verification and a retained-proof hash audit. Combined
n=56 coverage used 18,337 checked leaves, with 487 branches still open.
These are partial results, and the workers continue toward the configured
deadline. An isolated test of the production watchdog confirmed that it
kills only processes carrying its exact run tag, preserving both untagged
and similar-tagged controls.

## Analytic deductions

- `analytic/quadratic-color-fourier.txt` proves a square-root completed
  operator bound for quadratic intercepts and multiplicative-character
  color weights. For the actual color-by-column Fourier envelope V it gives
  m <= C p^(11/6) V^(2/3), hence vanishing density when V=o(p^(1/4)).
  In the common-potential model it improves the October Fourier bound from
  C p^(11/6) M_A M_H to C p^(11/6) M_A^(1/3) M_H^(2/3).
  The proof includes both exceptional frequency axes. Its dense proper
  example has p^3/64+O(p^(5/2)) three-color four-cycles, counted exactly
  through p=1009. This is the strongest analytic lead of this session.
- `analytic/random-potential-threshold.txt` gives a two-sided threshold
  eta=p^(-3/4) for independent potential thinning of the October quadratic-
  residue family. Above that scale, N_3~eta^4 p^3/64 in probability;
  below it, every C4 is rainbow with high probability. The proof includes
  overlap bounds and an independent direct character-sum proof of the
  unthinned count. This is a coarse threshold for a specified random model.
  The fresh literature comparison identifies it as an application of
  Chen-Greenhill's published general framework. Appendix B derives a
  Poisson limit for distinct potential sets, normalized by their number.
- `analytic/potential-set-orbits.txt` proves the missing generic multiplicity
  bound: all but O(p^2) four-potential cycles occur in potential sets of
  multiplicity g=gcd(3,p-1). Thus M_p=p^3/(64g)+O(p^(5/2)). Together with
  Chen-Greenhill this gives, at eta=c p^(-3/4), the limiting rainbow
  probability exp(-c^4/(64g)) and raw cycle law g*Poisson(c^4/(64g)), along
  each fixed class p mod 3. Exact integer-polynomial certificates and
  separate small-field graph enumeration passed. This is an application
  candidate prompted by the literature audit; historical novelty is open.
- `analytic/factorization-and-defects.txt` develops a gamma_2 support bound,
  a three-color C4 counting formula, a degree-weighted robust inequality,
  and discrepancy/trace-norm consequences for fixed nonlinear polynomial
  intercepts. It includes a concrete dense family with asymptotically
  p^3/16384 three-color C4s.
- `analytic/arbitrary-intercepts-norm-growth.txt` combines the archived
  common-support theorem with published matrix extraction results. For
  arbitrary intercepts, normalized trace norm t gives the explicit bound
  m/p^2 <= C[t/(log p)^(1/27) + sqrt(t)/(log p)^(1/18)
  + exp(-c(log p)^(1/9))].
- `analytic/proof-and-literature-audit.txt` records the proof checks,
  source versions, overlap with existing results, and remaining review work.

The exact local identity audit and dense-example counts passed. Theorems
from the archive and the literature are not thereby formally verified.
These are candidate research contributions; novelty and paper readiness
have not been established.

## Second live checkpoint

`verified/0130KST/` freezes the results at 16:29 UTC (01:29 KST): twelve
graph sizes improved, with seventeen edges of total gain over the merged
baseline. Both graph checkers passed. There are 358 new native-DRAT-checked
UNSAT leaves, giving 18,549 combined leaves and 385 still-open branches.
This snapshot rechecks the CNF hashes; it does not repeat the retained-proof
hash pass from the first checkpoint. Final verification is still scheduled.

The additional common-potential spectrum probe used six small examples
at p=193 and 379. Its floating-point Ritz values are exploratory lower
bounds on extremal magnitudes, not certified spectral upper bounds or a
proof of a general estimate. See `analytic/potential-spectrum-probe.json`.

Exact potential-set multiplicities were also counted locally in C through
p=1019, with a 768 MiB memory cap and one of the same two CPU cores.
The counts agree with the separate Python cycle counts on shared inputs.
Different graph cycles can have the same potential set; these multiplicities
must be retained in a second-moment argument. The calculation took about
11.5 seconds and is recorded in `analytic/potential-quadruple-counts.jsonl`.

## Latest verified live checkpoint

`verified/0155KST/` completed at 16:54 UTC (01:54 KST). Sixteen sizes
improve over the merged baseline, with 29 edges of total gain. The largest
single gain is n=123: 2625 to 2631 edges. Every saved improvement passed
both graph checkers. All 536 new UNSAT leaves passed native DRAT checking,
and all 536 retained proof archives passed a fresh hash check. Combined
n=56 coverage has 18,727 verified leaves and 318 open branches; four of
nine top-level cases are closed. There is still no exact n=56 conclusion.

The finalizer now reserves 90 seconds for coverage and reporting if the
proof-hash audit reaches its time budget. An isolated control-flow test
confirmed that both full and time-limited audits save their report and
clearly distinguish an incomplete hash pass from corrupted proof data.
This test did not affect the live workers. The searches remain authorized
until 05:50 KST, with the independent hard stop at 06:00 KST.

## Fresh journal literature comparison

`analytic/journal-literature-comparison.txt` records ten relevant published
papers, their DOI/open-manuscript links, and the scope of the comparison.
The main new prior-art finding is Chen-Greenhill (Journal of Combinatorics,
2021), with a second route through Kim-Lund-Pham-Yoo (Finite Fields and
Their Applications, 2023). Their general threshold results cover the
probabilistic step after our algebraic counts and overlap bounds are
verified. The corresponding novelty assessment has been narrowed.
The same literature supplied a useful next step: the generic multiplicity
argument now makes the critical-window limit explicit, distinguishing
single cycles from triples according to p mod 3.

The fixed-formula result should be presented as an application of Tao's
published algebraic regularity machinery. The quadratic operator proof
uses the classical Weil estimate. Forey-Fresan-Kowalski-Wigderson's related
cubic spectral construction remains labeled a preprint: this pass did
not verify a journal publication. None of these comparisons establishes
historical priority or journal acceptance for the project's applications.
