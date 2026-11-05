# Pass 4 — crossing the common-support barrier

15 October 2026, fourth of eight scheduled continuations.

Later update: [Pass 5](PASS5-REPORT.md) extends these results to bounded-VC
supports by a limit-and-bracketing argument and treats additional supports
by Fourier analysis. The open targets below describe the end of Pass 4.

**Verified progress within a restricted class:** the affine common-row-support
case left open in Pass 3 now has a vanishing-density proof, including
arbitrary intercepts. For fixed-degree nonlinear polynomial intercepts,
the proof gives a power saving. These are analytic deductions with
independent hand audits, not finite-search evidence.

**The unrestricted problem remains open.** The universal
\(0.2984440375\ldots\) coefficient is unchanged; its novelty is still
unverified. None of the results here is Lean-certified, and historical
originality of the combined arguments has not been established.

## 1. Exact scope and results

Let \(p\) be an odd prime, \(A\subseteq\mathbb F_p^*\), and
\(\sigma_a(x)=ax+\beta(a)\). There is **one color per slope**.
Retain the color-\(a\) edges at rows \(D_a\subseteq\mathbb F_p\).
Assume the actual graph is simple, properly colored, and every \(C_4\)
is rainbow. Put \(m=\sum_a|D_a|\).

| Intercepts | Actual row supports | Audited conclusion |
|---|---|---|
| Arbitrary function \(\beta:A\to\mathbb F_p\) | All \(D_a=X\), for any \(X\) | \(m\ll p^2\exp[-c(\log p)^{1/12}]\), hence \(o(p^2)\) |
| Arbitrary \(\beta\) | \(D_a\subseteq X\), with \(R=\sum_a|X\setminus D_a|=o(p^2)\) | \(m=o(p^2)\) |
| Polynomial \(\beta\), fixed degree \(2\le D<p\) | All \(D_a=X\) | \(m=O_D(p^{19/10})\) |
| Same polynomial class | \(D_a\subseteq X\), arbitrary \(R\) | \(m\le C_Dp^{19/10}+\sqrt2\,p\sqrt R\) |
| Same polynomial class | Domains ordered by inclusion, or at most \(r\) intervals in one common row ordering, with \(r\) fixed | \(m=O_D(p^{35/18})\) for nested domains; \(O_{D,r}(p^{35/18})\) for intervals |
| Arbitrary \(\beta\) | Those nested or interval support classes | \(m\ll_r p^2\exp[-c_r(\log p)^{1/12}]\) |

The omissions \(R\) are measured inside \(A\times X\), **not**
\(A\times\mathbb F_p\). Thus the theorem permits a common row set
of any fixed positive density below one. Such graphs can have
\(\Theta(p^2)\) omissions from the full affine maps and were outside
Pass 3's sublinear-defect theorem.

The power saving does not extend to arbitrary intercepts: the familiar
Behrend construction in a multiplicative pencil produces examples with
\(m\ge c p^2\exp[-C\sqrt{\log p}]\). This is \(p^{2-o(1)}\), so no
uniform \(O(p^{2-\epsilon})\) estimate can hold in that broader class.
The restriction to genuinely nonlinear fixed-degree polynomials is
essential for the displayed power bound.

## 2. The proof mechanism

The useful operator acts on **edge positions**, not just on one row or
on pairs moved together:
\[
\tau_a(x,y)=\left(\frac{y-\beta(a)}a,\; ax+\beta(a)\right),
\qquad S_A f=\sum_{a\in A} f\circ\tau_a.
\]
These maps are involutions. If an actual edge and its reflected edge
are both present, and both closing color-\(a\) incidences are present,
they form a forbidden repeated-color square unless the transition is
a fixed point. With common support this gives the exact identity
\[
\langle1_E,S_A1_E\rangle=m.
\]
With missing incidences, charging each bad transition to one of its
missing closing edges gives the robust inequality
\[
\langle1_E,S_A1_E\rangle\le m+2dR,\qquad d=|A|.
\]
The charge includes fixed points whose completed color differs from
the actual edge color. It does not assume the completed graph is proper.

Fourier space splits by the invariant frequency product \(\xi\eta\).
On a nonzero-product block the fourth trace moment becomes a sum of
complete Kloosterman sums. All four palette membership tests remain
in the calculation. For arbitrary intercepts, the exceptional terms
are exactly certain collinear quadruples of coefficient points.
Writing \(L\) for maximum line occupancy of
\(\{(a,\beta(a)):a\in A\}\), and \(E_{\rm aff}\) for affine quotient energy,
the nonconstant operator norm has the bound
\[
\lambda^4\le
\max\!\left\{(p-1)E_{\rm aff},\,
p(L+2)d^2+2\sqrt p\,E^\times(A)\right\},
\qquad E^\times(A)\le d^3.
\]
Centering the actual edge indicator then yields
\[
(d+\lambda)\frac{m^2}{p^2}\le (1+\lambda)m+2dR.
\]

For a nonlinear polynomial of fixed degree \(D\), \(L\le D\) and
\(E_{\rm aff}=O_D(d^2)\). Optimizing the spectral inequality against
\(m\le dp\) gives the \(19/10\) exponent.

For arbitrary intercepts, the published PRRW affine-energy theorem gives
\(E_{\rm aff}\ll d^{5/2}+Ld^2\). A line with a positive fraction of
the palette normalizes to a multiplicative-group table. Solymosi's
theorem excludes a positive-density actual graph there, even under the
near-common support hypothesis. Thus \(L=o(p)\); the spectral estimate
then supplies the needed expansion and contradiction.

For exactly common support, the line step has a quantitative Roth proof.
Intersect the pencil's logarithmic color set with each translate of its
logarithmic row set. Every intersection is strongly three-term-
progression-free, since an arithmetic progression gives an actual
repeated-color square. Averaging bounds
\[
L(|X|-1)\le (p-1)r_3([p-1]).
\]
Combining this with the spectral estimate gives
\[
\frac{m}{p^2}\ll p^{-1/11}
  +\left(\frac{r_3([p-1])}{p}\right)^{1/6}.
\]
The stated stretched-exponential bound follows from the established
Kelley–Meka Roth bound. No new Roth or exponential-sum estimate is claimed.

For nested domains, grouping consecutive colors and retaining each
group's smallest domain loses a telescoping number of incidences.
For interval domains, grouping rows loses only boundary incidences.
Both turn a uniform common-support bound \(p^2G(p)\) into
\(O_r(p^2\sqrt{G(p)})\). Thus they retain the same stretched-logarithmic
form for arbitrary intercepts. The final quantitative transfer is
proved and checked in Sections 8–9 of the independent arbitrary-affine
audit below.

## 3. Evidence and audit trail

- [Complete quadratic proof, including omissions and rectangle covers](pass4-crossed-reflection-common-support-theorem.txt).
- [First independent crossed-operator audit](pass4-crossed-operator-independent-audit.txt) and [second audit with robustness](pass4-crossed-reflection-independent-audit-and-robustness.txt).
- [Fixed-degree polynomial extension](pass4-polynomial-intercept-common-support-theorem.txt) and [independent extension audit](pass4-polynomial-palette-independent-audit.txt).
- [Arbitrary-intercept theorem, master inequality and quantitative common-support refinement](pass4-arbitrary-intercept-common-support-theorem.txt), with [independent audit](pass4-arbitrary-affine-common-support-independent-audit.txt).
- [Nested-support proof](pass4-nested-support-theorem.txt) and [interval-support proof with a separate nested audit](pass4-interval-support-theorem.txt).
- [Primary-source and novelty audit](pass4-common-mask-literature.md), and [published affine-energy inputs plus Behrend limitation](pass4-affine-published-input-audit.md).

The relevant classical inputs were checked in primary texts:
[Weil's Kloosterman estimate, Theorem 11.11](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf),
[PRRW, Theorem 2.1](https://arxiv.org/pdf/1911.03401),
[Solymosi, Theorem 5](https://arxiv.org/pdf/1309.0133),
and the [published Bloom–Sisask exposition of the Kelley–Meka bound](https://msp.org/ent/2023/2-1/ent-v2-n1-p02-p.pdf).
The first three suffice for the qualitative near-common theorem;
Roth supplies the explicit rate for exactly common domains.
The recent Lewko incidence preprint used in Pass 3 is not needed here.

An alternative proof uses the previously audited heavy-color global-energy
theorem: low global energy forces low line occupancy, and the crossed
operator translates those facts into sparsity on common supports.
That is a genuine bridge in this representation class. The directly
published PRRW/Solymosi route avoids the alternative's heavier
approximate-group dependencies.

## 4. Routes ruled out or kept separate

The [affine-family classification](pass4-affine-linear-family-classification.txt)
proves that every nondegenerate affine two-plane in the seven-root
configuration variety has opposite rows \(z=-x\). There are exactly
four such planes. An antisymmetric row set excludes all of them, so
that particular linear-recurrence approach could not resolve the
common-support case. The crossed-operator proof counts configurations
outside these planes.

The [genus-one checkpoint](pass4-fixed-root-pair-genus-checkpoint.txt)
records the exact generic fixed-root-pair curve and its exceptional
parameters. It is not needed for the positive theorem and is not a
completed recurrence argument.

There is no claimed bounded-VC-dimension corollary. A naive approximate
cover can accumulate too many missing incidences. Nested domains and
intervals work because their explicit decompositions have a controlled
total deletion cost.

Related reflection/bisector-energy methods are established literature.
No exact published match for the assembled support theorem was found
in the inspected sources. That search outcome does not certify
originality. The previously identified 2026 Gyárfás–Sárközy–Wagner
paper remains an outstanding full-text novelty check; exhausted access
attempts were not repeated.

## 5. Next concrete research step

The remaining obstacle is now precise: for unrelated domains the useful
operator is the support-weighted involution sum
\[
(T_D f)(x,y)=
\sum_{a\in A}1_{D_a}(x)\,
1_{D_a}\!\left(\frac{y-\beta(a)}a\right)
f(\tau_a(x,y)).
\]
It is symmetric, and B still gives
\(\langle1_E,T_D1_E\rangle=m\), but its degree varies and the
Fourier product blocks no longer decouple. Proving a suitable lower
bound on this quadratic form, or extracting substantial actual
common-support pieces with a controlled loss, would remove a real
remaining hypothesis.

The next pass should test a precise density-transfer statement for
\(T_D\), with its support correlations retained. It must not infer
expansion from completed-map mixing alone, invoke a generic VC
rectangle cover, or repeat the already exhausted finite searches.
A second limitation is repeated slopes: the current Fourier count
uses one color per slope. No representation theorem places arbitrary
#810 colorings in this affine class.

Original Gemini artifacts were preserved. This pass involved no
external messages, publication, finite graph enumeration, or new
universal-constant claim.
