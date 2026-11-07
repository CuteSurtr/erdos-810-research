# Task PUSH (2026-10-25): close the open cases of the paper draft

Results folder: `bruteforce/results/PUSH/<NAME>/`, where NAME is given in your prompt.
Wrap up by **16:00 UTC on 2026-10-25**.

**Background.** Read `paper/OUTLINE.md` (the claim ledger) and the relevant task reports
(`results/CYC/C*/REPORT.md`, `results/CYCPAT/REPORT.md`). The cyclic orbit family is defined in
`tasks/CYC.md`.

## Rules for every routine

The README rules apply: git identity CuteSurtr, plain commits, push with rebase retries,
checkpoint at least every 45 min, and do not end your turn while jobs run.

**Proofs.** Every UNSAT claim must come with a proof checked by a **standard checker**: drat-trim
for DRAT, or cake_lpr for LRAT. Build both from GitHub.
- If a proof cannot be checked in time, label the result "solver UNSAT, proof unchecked".
- Record, for each UNSAT result: CNF sha256, solver and version, proof size, and the checker's
  verdict line.

**Satisfying results.** Decode every SAT result. Re-verify it as an explicit graph with a
separate, simple 4-cycle checker, and commit it immediately.

## N44A and N44B: finish CYC/C1's split of n = 44, k = 11

C1 split the instance by the presence bits p1..p4 of orbits 1..4. The table is in
`results/CYC/C1/REPORT.md`, §"n = 44, k = 11".
- 8 of the 9 cubes are UNSAT.
- The open cube is {p1, p2, p3, p4 all present}.
- Use **C1's own encoder and lex-leader symmetry breaking** (`results/CYC/C1/src`: `cycenc.c`,
  `cube.py`, `cubeproof.py`, `cubes44.sh`). C1's argument for the ¬p1 cube depends on that
  breaking. Read C1's REPORT and source first, then rebuild.

**Splitting the open cube.** Split it on p5, p6, p7, p8, giving 16 sub-cubes.
- **N44A** takes the sub-cubes with p5 = 1; **N44B** takes p5 = 0.
- If a sub-cube is unresolved after about 40 min of wall time, split it further on the next
  presence bits (p9, p10, …) or with march_cu.
- Presence-bit splits cover everything trivially. Record the full tree in `tree.json`, with
  each leaf's assumptions, result and proof status.

**N44A only.**
- Re-prove the two "solver only" cubes (1, 2, ¬3, 4) and (1, 2, 3, ¬4) with checked proofs.
- Re-check C1's six LRAT cubes with a standard checker, regenerating the proofs.

**Outcome.** If every leaf is UNSAT with checked proofs, then **k_max(44) = 10 < n/4 = 11**
holds with this encoding. Combined with N44A's re-proofs, that is a fully certified result.

## N44C: finish CYCPAT's independent split of n = 44, k = 11

CYCPAT's split (`results/CYCPAT/REPORT.md` §4 and §10) has two parts:
- "nounit";
- "unit2:e" for e = 2..21, meaning 1 ∈ D, g(1) = 0 and e = min(D ∖ {1}).

Every case except **e = 2 and e = 3** finished with no solution.

**Steps.**
1. Finish e = 2 and e = 3. Use kissat and/or CaDiCaL on a CNF export of each case.
   If needed, split further by the third orbit f = min(D ∖ {1, e}); state the cover argument.
2. Produce checked DRAT proofs for e = 2, 3, and, as time permits, for the other cases, which
   so far rest on solver results.
3. Report whether this independent split also gives k_max(44) ≤ 10.

## CERT: standard-checker proofs, and n = 35

1. **n = 38, k = 10.** C1's LRAT was checked by a task-written checker. Regenerate the proof
   (DRAT with drat-trim, or LRAT with cake_lpr), using any validated encoder from
   `results/CYC/C*/src`.
2. **n = 42, k = 11.** C4's 2.4 GB DRAT timed out in drat-trim after 3000 s.
   - Give drat-trim up to 3 h.
   - Or split into presence-bit cubes, each with its own checked proof, plus a trivial cover.
3. **n = 47, k = 12.** C0 used cube-and-conquer over 29 cubes, with coverage checked but no
   per-cube proofs. Produce checked proofs per cube (`results/CYC/C0`), and re-check the
   coverage.
4. **n = 35.** Compute k_max(35), which was never computed. Give the SAT certificate at
   k_max and a checked UNSAT proof at k_max + 1.

## N48: n = 48, k = 12 (= n/4)

CYC/C2 left k = 12 UNKNOWN; k ≥ 11 is known.

1. Use C1's approach: a portfolio for about 30 min, then a presence-bit cube split under C1's
   lex-leader breaking, with the ¬p1 cube handled as in C1.
2. Then split deeper as needed. Prove every leaf UNSAT with a checked proof, or find a solution.
3. Report the tree and the status of every leaf.

## AUDIT: independent referee audit of the draft

Read `paper/main.tex`, `paper/OUTLINE.md` and the task reports. Write `AUDIT.md`.
**Do not edit `paper/`.**

1. **Mathematics.** Check every proof line by line and report any gap:
   - Lemma 1 (heredity);
   - the PRUNE soundness argument;
   - the SAT symmetry-breaking soundness argument (SAT REPORT §4.2);
   - Lemma 2 (walk and collision criterion);
   - Lemma 3 (multiplier action; verify numerically on several solutions);
   - Proposition 4 and its remarks: Szemerédi, the Varnavides counting and the O(n)
     degenerate count; the b = 2 → 4-AP claim; the piecewise-affine and b ∈ {0, 1} claims.
2. **Numbers.** Check every number in the abstract, the text and Table 1 against the result
   files: counts, times, Pólya numbers, extremal counts, proof statuses, and the n/4 orbit
   counts. Re-run `paper/make_tables.py` and confirm that the tables regenerate identically.
3. **References.** Check the bibliographic entries, especially those marked TODO (GT17,
   CaDiCaL), and any citation that is misattributed.
4. **Overclaims.** Flag any claim stronger than its evidence. Suggest exact wording fixes.
