# Pass 5 — color-dependent supports

15 October 2026, fifth of eight scheduled continuations.

**Audited progress:** the affine sparsity theorem now includes arbitrary
intercepts with uniformly bounded-VC row supports. More generally it
includes supports omitting any fixed induced bipartite pattern. A second,
quantitative argument treats polynomial intercepts and a shared Fourier
majorant; it permits some support classes whose complexity grows with
the field size. Both arguments keep the actual missing incidences.

**Scope:** these are restricted-class deductions with independent hand
audits. Historical originality remains unverified, and there is no Lean
certificate. We have not obtained an unrestricted asymptotic advance on
#810. The universal \(0.2984440375\ldots\) coefficient and its unresolved
novelty status are unchanged.

## 1. Setting and results

Unless explicitly stated otherwise, \(p\) tends to infinity through odd
primes, \(A\subseteq\mathbb F_p^*\), and each color is the restriction of
\[
\sigma_a(x)=ax+\beta(a)
\]
to its actual row domain \(D_a\). There is one color per slope. The
bipartite graph, on two copies of \(\mathbb F_p\), is simple and proper,
and every \(C_4\) is rainbow. Put \(m=\sum_a|D_a|\). No representation of
general #810 graphs by these maps has been proved.

| Additional hypotheses | Conclusion |
|---|---|
| Arbitrary \(\beta\); the family \(\{D_a\}\) has uniformly bounded VC dimension | \(m=o(p^2)\) |
| Arbitrary \(\beta\); the color–row support bigraph omits any one fixed induced bipartite pattern, or is within \(o(p^2)\) edits of such a bigraph | \(m=o(p^2)\) |
| Polynomial \(\beta\) of fixed degree \(2\le D<p\); joint Fourier majorant \(W\) defined below | \(m\le C_Dp^{47/24}W^{2/3}\) |
| Same polynomial class; \(W=o(p^{1/16})\) | \(m=o(p^2)\) |
| Arbitrary \(\beta\); \(D_a\subseteq X\cap\sigma_a^{-1}(Y)\) and total omissions from these eligible domains are \(o(p^2)\) | \(m=o(p^2)\) |
| Same eligibility hypothesis; polynomial \(\beta\) of fixed degree \(2\le D<p\) | \(m\le C_Dp^{19/10}+\sqrt2\,p\sqrt R\) |

Here \(X,Y\) are arbitrary common vertex sets. Neither the VC result nor
the arbitrary-intercept eligibility result has an explicit rate in this
pass. The Fourier bound also holds, with a different constant, when at
most \(C_0\sqrt p\) coefficient points \((a,\beta(a))\) lie on any line.

## 2. Bounded VC: obtaining the right finite support rectangle

The full [proof and primary-source comparison](pass5-bounded-vc-literature-and-transfer.md)
has two [independent](pass5-bounded-vc-independent-audit.txt)
[audits](pass5-bounded-vc-support-independent-proof.txt).

Suppose a sequence had \(m\ge\delta p^2\). The support matrix, with colors
on one side and row positions on the other, has both parts of linear
size. Take a bipartite cut limit. Omitting a fixed induced bipartite
pattern makes that limit *thin*. Bounded VC implies such an omission
by excluding a fixed shattering pattern.

[Lovász–Szegedy](https://arxiv.org/pdf/1002.4377), Theorem 4.1 and
Lemma 4.7, supply a binary pure limit with compact row metric and finite
dual essential VC dimension. A countable dense row family becomes an
ordinary VC family after removing the countable union of its null Boolean
atoms. [Adams–Nobel](https://arxiv.org/pdf/1010.4515), Corollary 1, then
gives finitely many brackets in this one fixed measure space.

Brackets are closed in \(L^1\). Their finite union therefore covers the
closure of the dense row family. Positive edge density yields a bracket
with a positive-measure lower set and a positive-measure class of rows.
The limit is consequently identically one almost everywhere on a
rectangle \(U\times V\) of positive measure.

Cut convergence to a binary limit upgrades to \(L^1\) convergence.
Thresholding the fractions of each finite vertex cell lying in \(U,V\)
produces actual linear-size color and row subsets with only \(o(p^2)\)
missing incidences. Arithmetic labels are unchanged. Restricting to these
subsets contradicts the Pass 4 near-common-support theorem.

This resolves the earlier finite-cover quantifier difficulty. The number
of brackets is chosen in a fixed limit before returning to finite
graphs; no unsupported bound on a product such as \(K(\varepsilon)
\varepsilon\) is used. The full notes check null sets, measurability,
bracket closure, and fractional vertex cells.

There is a stronger necessary condition. For every fixed \(\delta>0\)
and fixed bipartite pattern \(F\), with positive part sizes \(s,t\), a hypothetical
affine B graph with \(m\ge\delta p^2\) must contain at least
\[
c(\delta,F)|A|^s p^t
\]
labeled induced injective copies of \(F\) in its support bigraph, for
all sufficiently large \(p\). Otherwise a subsequence would have a thin
positive limit and give the same contradiction. Thus any remaining
dense example must exhibit every fixed induced support pattern with
positive density. This is a necessary condition, not an existence claim.

## 3. Fourier control with growing support complexity

The complete [analytic proof](pass5-fourier-majorant-support-theorem.txt)
and [independent audit](pass5-fourier-majorant-independent-audit.txt)
define
\[
\widehat{1_{D_a}}(k)=\frac1p\sum_x1_{D_a}(x)e_p(-kx),\qquad
W=\sum_k\sup_a|\widehat{1_{D_a}}(k)|.
\]
The order of the sum and supremum is essential.

For crossed involutions
\[
\tau_a(x,y)=((y-\beta(a))/a,\;ax+\beta(a)),
\]
the actual-support operator is
\[
T_D=\sum_a M_{1_{D_a}}U_{\tau_a}M_{1_{D_a}}.
\]
The B property gives \(\langle1_E,T_D1_E\rangle=m\) exactly. Both
closing incidences are required by the masks.

The completed-map fourth-moment estimate extends to arbitrary complex
color weights, using fourth singular moments. A needed correction is
retained explicitly: nonidentity translations have character \(-1\),
but their complex coefficients prevent discarding them. Their absolute
contribution is at most \(d^3\), where \(d=|A|\).

For fixed nonlinear polynomial degree, the resulting norm is
\(\Lambda=O_D(p^{7/8})\). Fourier expansion of the two masks gives
\[
T_0=p^{-2}\sum_a |v_a\rangle\langle v_a|,
\quad v_a(x,y)=1_{D_a}(x),\qquad
\|T_D-T_0\|\le\Lambda W^2.
\]
This main term is positive and depends on the actual supports.
Two applications of Cauchy–Schwarz imply
\[
\langle1_E,T_01_E\rangle\ge\frac{m^4}{dp^4},\qquad
m^3\le dp^4(1+\Lambda W^2).
\]
Hence \(m\le C_Dp^{47/24}W^{2/3}\). In particular a positive-density
sequence in this polynomial class would require
\(W\gg_{\delta,D}p^{1/16}\).

A concrete class permits a shared list of nonzero frequencies
\(k_1,\ldots,k_r\), with arbitrary cyclic intervals \(I_{a,j}\):
\[
D_a=\{x:k_jx\in I_{a,j}\text{ for every }j\}.
\]
The interval Fourier estimate and convolution give the common envelope
\[
W\le(C\log(2p))^r,\qquad
m\ll_D p^{47/24}(C\log(2p))^{2r/3}.
\]
The frequencies may depend on \(p\), and intervals may vary independently
with the color. Even growing \(r=r(p)\) is allowed whenever
\[
\limsup_{p\to\infty}\frac{r(p)\log\log p}{\log p}<\frac1{16}.
\]
The audit keeps the factor \(C^r\). Color-dependent frequency lists are
not covered. This supplies a quantitative class beyond requiring one
fixed VC bound; it is not a bound for arbitrary masks.

## 4. Other audited extensions and a failed generalization

The [common vertex-rectangle theorem](pass5-common-vertex-rectangle-theorem.txt)
allows \(D_a=X\cap\sigma_a^{-1}(Y)\), with \(o(p^2)\) total omissions.
If two crossed edge positions lie in \(X\times Y\), both closing
color incidences are eligible. The Pass 4 argument therefore applies.
The polynomial estimate is uniform in \(X,Y\); the arbitrary-intercept
proof uses heavy-color pruning, Solymosi's group-table theorem and PRRW
affine energy. We do not assert the earlier explicit common-row Roth
rate for arbitrary \(Y\).

A separate [repeated-slope theorem](pass5-affine-slope-multiplicity-theorem.txt)
permits a set \(S\) of \(O(p)\) distinct affine maps. If \(v_a\) is the
number with slope \(a\), put
\[
T(S)=\sum_{a_1a_3=a_2a_4}v_{a_1}v_{a_2}v_{a_3}v_{a_4}.
\]
For common vertex-rectangle eligibility with \(o(p^2)\) omissions,
\(T(S)=o(p^{7/2})\) forces \(m=o(p^2)\). In particular
\(\max_a v_a=o(\sqrt p)\) suffices. The proof explicitly counts
same-slope additive degeneracies. A proper, heavy example with
\(T(S)\gg p^{7/2}\), but small affine energy and no linearly rich
coefficient line, shows that those weaker data do not imply this
slope-energy hypothesis. That example is not B.

Finally, the [negative-spectrum construction](pass5-masked-operator-negative-spectrum-obstruction.txt)
shows that proper heavy quadratic masks can give the masked operator
a mean-zero Rayleigh quotient \(-\Omega(p)\). Thus a mask-uniform
\(o(p)\) lower-spectrum bound is false. The constructed graph is not B,
and the bad test vector is orthogonal to its actual edge indicator.
This obstruction leaves open an argument that uses B and the alignment
between actual edges and masks.

## 5. Novelty, verification, and next target

The mathematical inputs are established results: Weil's Kloosterman
bound, [PRRW Theorem 2.1](https://arxiv.org/pdf/1911.03401),
[Solymosi Theorem 5](https://arxiv.org/pdf/1309.0133), and the graphon
and bracketing results cited above. Primary statements and relevant
hypotheses were inspected. The new local deductions have independent
hand audits; no formal verification is claimed.

Targeted literature checks did not locate an exact statement of the
affine support consequences. That does not prove novelty. The previously
unavailable 2026 perfect-B paper remains part of the broader novelty
gap; exhausted access routes were not repeated. Original Gemini files
were preserved. No finite graph enumeration, external contact, or
publication was used.

The next concrete target is the part of arbitrary quadratic supports
that has neither a thin limit nor a small joint Fourier envelope.
The [audited phase checkpoint](pass5-quadratic-common-potential-mask-checkpoint.txt)
gives an exact identity worth testing. Set
\[
u_a(x)=a^2x+a^3,\qquad Q(x,y)=xy,\qquad z=(y-a^2)/a.
\]
Then
\[
Q(\tau_a(x,y))-Q(x,y)=u_a(z)-u_a(x)
=ay-a^2x-a^3.
\]
For masks \(1_{D_a}(x)=1_H(u_a(x))\), the Fourier terms with
indices \(k+\ell=0\) are conjugates of the completed crossed operator
by the chirp \(e_p(\ell Q)\). Their constant-projection contributions
are positive rank-one operators. The terms with \(k+\ell\ne0\) are
uncontrolled. This is an unproved direction, not an additional theorem:
test whether their aggregate is small, or construct an exact obstruction.
Any later proof must retain the same actual support in both slots and
must not reuse the defeated four-independent-slot mixing argument.

The [off-diagonal operator checkpoint](pass5-offdiagonal-chirp-operator-checkpoint.txt)
records an exact pair-product formula and a one-dimensional compression
for these terms. The compression supplies only a lower bound on the full
operator norm. Neither a uniform norm saving nor a linear-norm obstruction
was found. An upper bound for the compression alone would not finish
the argument; the other components and the sum of Fourier coefficients
must also be controlled.

Unrestricted affine masks, general permutation palettes, and #810 itself
remain unresolved. Later continuations should start from these files
instead of repeating common-support, finite-cover, or worst-spectrum
arguments.
