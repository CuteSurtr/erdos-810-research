# Erdős #810 research status

Snapshot prepared on 18 October 2026 from the research and audits dated
14–15 October. Research and the overnight automation are paused.

**This repository does not contain a solution of Erdős #810.**
The original Lean project and its README are preserved. The later
asymptotic research below consists of analytic proofs and independent
agent hand audits; those results have not been formalized in Lean.
Historical novelty and record status have not been established.

## Main completed results

- For proper rainbow-\(C_4\) colorings over \(\mathbb F_p\), with one
  affine color \(x\mapsto ax+\beta(a)\) per nonzero slope, uniformly
  bounded-VC actual row supports imply \(m=o(p^2)\). Intercepts may be
  arbitrary. The result also covers support bigraphs omitting a fixed
  induced bipartite pattern. See the
  [Pass 5 report](overnight-2026-10-15/PASS5-REPORT.md) for exact
  hypotheses, full proofs, independent audits, and other restricted
  support classes.
- The latest completed operator proof establishes
  \(\|C_{s,w}\|_{2\to2}=O(p^{7/8})\), uniformly for \(s\ne0\) and
  \(|w(a)|\le1\), where
  \[
  C_{s,w}f(x)=\sum_{a\ne0}w(a)e_p(s(a^2x+a^3))f(ax+a^2).
  \]
  An exact decomposition gives the same bound for the corresponding
  two-dimensional crossed operator. The
  [complete proof and audit](overnight-2026-10-15/pass6-oscillatory-affine-operator-proof-and-audit.txt)
  and [literature comparison](overnight-2026-10-15/pass6-oscillatory-affine-literature.md)
  are saved. This controls each nonzero Fourier slice; summing the
  slices for arbitrary supports remains unresolved.
- The universal coefficient obtained in the earlier analysis remains
  \(0.2984440375099955469\ldots\), with a hand-audited argument and an
  exact coefficient certificate. Its novelty remains unverified.
  See [asymptotic results](asymptotic-2026-10-15/RESULTS.md).

There is no universal \(o(N^2)\) theorem, no universal bound below
\(N^2/4\), and no established new record. The restricted affine results
do not provide a representation theorem for arbitrary #810 graphs.

## Reading the archive

Start with the [multicolor report](multicolor-2026-10-15/REPORT.md),
[overnight index](overnight-2026-10-15/README.md), and the completed
operator proof above. Reports record the state at their dates: later
results can resolve targets described as open in earlier notes.
The Pass 5 report is the latest consolidated research report; the
completed Pass 6 operator proof is linked separately here.

Later attempts were interrupted by usage limits. The general-polynomial
extension and further support transfers discussed during those attempts
were not incorporated into a complete consolidated proof before work
stopped. They are not promoted to completed results in this snapshot.

The initial audit and finite-computation files preserve the evidence for
earlier checks. Preparing this Git snapshot did not rerun mathematical
searches, Lean builds, or the finite computations. Existing verification
claims refer to their original recorded checks.

## Included material

The commit contains the original project sources, research notes,
audit scripts, certificates, and recorded results. Local compiled search
executables, dependency caches, and archived third-party Lean sources
and verification logs are excluded.

For the external incidence-proof snapshot, the
[provenance record](overnight-2026-10-15/reference-sources/lewko-2609.27023v3/PROVENANCE.md)
and [source audit](overnight-2026-10-15/pass3-lewko-incidence-source-audit.md)
retain upstream links and revision information. References to its local
source paths describe that private audit snapshot, not files distributed
in this commit.
