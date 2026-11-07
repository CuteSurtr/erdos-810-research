# Independent audit of the low-rank support bound

6 November 2026. **Pass as a written proof**, with the inherited weighted
operator theorem as stated below. This is an independent hand audit,
not Lean verification or external mathematical review. No claim about
historical novelty is certified.

Audited result in `low-rank-supports.md`:

\[
m\le C_Dp^{47/24}r^{1/3}+Cp^{3/2}R^{1/4},
\]

where a bounded real rank-r matrix approximates the actual binary
color–row support matrix with entrywise error R. The zero-error case,
the column-support version, and the criterion r=o(p^{1/8}), R=o(p²)
all follow with the stated hypotheses.

Checks performed:

1. **Exact operator input.** Section 2 of the archived
   `pass5-fourier-majorant-support-theorem.txt` explicitly supplies the
   full completed-operator estimate for arbitrary complex weights and
   polynomial intercepts of any fixed degree 2≤D<p. Its singular fourth
   moment accounts for complex weights, including the absolute d³
   translation contribution on the axis block. The polynomial note's
   energy proof gives E_aff≤(2D−1)d²; line occupancy is at most D.
   Thus the note uses the available O_D(p^{7/8}) bound with the correct
   hypotheses, rather than extrapolating the separate quadratic-only
   oscillatory-operator statement.
2. **Square-root-rank factorization.** In the real row space, symmetric
   John position bounds row norms by √r and column-functional norms by
   one. The cited primary paper's Theorem 1 does provide the contact
   identity needed for the √r inclusion:
   [Gruber–Schuster](https://www.dmg.tuwien.ac.at/schuster/john1.pdf).
   Padding row and column vectors in separate orthogonal directions
   preserves all cross inner products. Gaussian signs give
   Z=(2/π)arcsin(B/√r). Independent copies show that every positive
   integer entrywise power of Z is in the convex hull of rank-one sign
   matrices. The entrywise sine series has absolute coefficient sum
   sinh(π/2). This proves Γ(B)≤sinh(π/2)√r. The finite sign hull is
   compact, so passing from partial sums to a finite separated
   representation is legitimate. No dimension-dependent factor was lost.
3. **Mask expansion.** Both row masks expand with coefficients
   u_i(a)u_j(a); the operator between multipliers is exactly
   Σ_a u_i(a)u_j(a)(U_a−P). Bounding termwise gives ΛΓ², hence
   sinh(π/2)²Λr. Real masks make Q_B positive even though separated
   summands can have negative values.
4. **Graph identity and main term.** A nonfixed masked transition would
   create four distinct bipartite edges with two opposite edges of color
   a. Fixed transitions count precisely the actual selected incidences,
   once each by simplicity. The positive main term is therefore bounded
   using m and two Cauchy–Schwarz inequalities, giving m⁴/(dp⁴).
5. **Approximation error.** B∈[0,1] is used both in the product error
   bound and nonnegativity of the main term. Each of the two errors costs
   at most pR; the second is obtained by the involution substitution.
   Consequently the master inequality, its positive part, and its
   constants are valid. In the large-m case it yields
   m⁴≤4p⁵(1+K²Λr)m+8p⁶R; the displayed sum of the two resulting bounds
   has valid constants. The small-m case uses R≤p². Rank zero gives
   B=0 and R=m, so it requires separate handling exactly as supplied.
6. **Exponents and scope.** (5+7/8)/3=47/24 and the factorization error
   is linear in rank. Thus the rank threshold is p^{1/8}, not p^{1/16}.
   The error contribution divided by p² is (R/p²)^{1/4}. The column
   version uses identical full-space operators with column multipliers;
   no intercept change is required. Empty palettes and empty graphs
   are handled before division.

The result is a substantive quantitative corollary for a restricted
polynomial-affine model. Full-rank support matrices remain uncontrolled;
the proof neither resolves arbitrary affine supports nor represents
arbitrary graphs in this model. The archived operator argument remains
an analytic proof rather than a kernel-checked input.
