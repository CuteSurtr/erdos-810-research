## Proved upper bound used in the table (counting bound)

**Lemma.** Let G be a bipartite graph with sides X, Y (|X| = |Y| = p), properly edge-coloured
with at most p − 1 colours so that every 4-cycle is rainbow. For rows x₁ ≠ x₂ let d_i = deg x_i,
c = |N(x₁) ∩ N(x₂)| and k = number of colours present at both rows. Then k + 2c ≤ d₁ + d₂.

*Proof.* For a colour a at both rows let y₁(a), y₂(a) be its columns at x₁, x₂. If both lay
in C = N(x₁) ∩ N(x₂), then x₁ y₁(a) x₂ y₂(a) is a 4-cycle whose opposite edges
x₁y₁(a), x₂y₂(a) both have colour a, contradiction. Send a to y₁(a) ∈ N(x₁)∖C if
y₁(a) ∉ C and otherwise to y₂(a) ∈ N(x₂)∖C. The maps a ↦ y_i(a) are injective (a row has one
edge per column), so k ≤ |N(x₁)∖C| + |N(x₂)∖C| = d₁ + d₂ − 2c. ∎

Summing over the C(p,2) row pairs:
Σ_a C(|E_a|, 2) + 2 Σ_y C(deg y, 2) ≤ (p − 1)·m, where E_a is colour class a. With p − 1 colour
classes of size ≤ p and p columns of degree ≤ p − 1 summing to m, convexity gives the smallest
left side at balanced sizes. `finalize.py: counting_bound` returns the largest m for which the
balanced left side is still ≤ (p − 1)m. This is ≈ 0.669 p² (81 for p = 11, 113 for p = 13),
valid for every β and every support (in fact for every bipartite p × p graph of this kind).
It is far from the found values (≈ 0.34–0.50 p²). It is also not tight at p = 7, where it gives
32 against the exact value 25.

The joint CP-SAT runs never got an objective bound below this for p ≥ 11. On p = 11 the
best CP-SAT bound after 10–45 min on 3–4 workers was 109–112, versus the counting bound 81.
Adding the pair inequality (with auxiliary product variables, `add_pair_cuts`) and its summed
quadratic form (`add_global_cut`) as constraints did not help: the LP relaxation does not see
them, and on p = 7 they slow the core-guided search (16 s → 75–174 s on one worker).
