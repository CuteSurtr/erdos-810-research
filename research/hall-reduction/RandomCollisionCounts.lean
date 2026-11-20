import Mathlib.Tactic

/-! # Finite inequalities in the random-host repeated-cycle count -/

set_option autoImplicit false
namespace Erdos810.RandomCollisionCounts

/-- Partial-derivative bounds d(u)d(v) have squared sum at most this ordered-pair sum. -/
theorem influence_squares {V : Type*} [Fintype V] (d : V → ℝ) :
    (∑ u, ∑ v, (d u*d v)^2) = (∑ u, d u^2)^2 := by
  simp_rw [mul_pow, ← Finset.mul_sum]
  rw [← Finset.sum_mul, sq]

/-- Splitting a large class into pieces of size at least twice the mean retains
at least the tangent to the square function at that mean. -/
theorem tangent_pieces {ι : Type*} (I : Finset ι) (s : ι → ℝ) {a : ℝ}
    (hs : ∀ i ∈ I, 0 ≤ s i) (large : ∀ i ∈ I, 2*a ≤ s i) :
    2*a*(∑ i ∈ I, s i)-a^2 ≤ ∑ i ∈ I, s i^2 := by
  have each (i) (hi : i ∈ I) : 2*a*s i ≤ s i^2 := by
    simpa [sq] using mul_le_mul_of_nonneg_right (large i hi) (hs i hi)
  have z := Finset.sum_le_sum each
  rw [← Finset.mul_sum] at z
  linarith only [z, sq_nonneg a]

theorem tangent_one (a s : ℝ) : 2*a*s-a^2 ≤ s^2 := by nlinarith only [sq_nonneg (s-a)]

/-- Sum the uniform lower bounds for the opposite pairs from each class piece.
Each original bad four-cycle contains at most two such repeated opposite pairs. -/
theorem transfer {ι : Type*} (I : Finset ι) (k w z err : ι → ℝ) {p M Q W B R : ℝ}
    (square_mass : M^2/Q ≤ ∑ i ∈ I, k i^2) (mass : (∑ i ∈ I, k i) = M)
    (adjacent : (∑ i ∈ I, w i) ≤ W) (error : (∑ i ∈ I, err i) ≤ B)
    (compare : ∀ i ∈ I, p^2*(k i^2-k i-2*w i)-err i ≤ z i)
    (cycles : (∑ i ∈ I, z i) ≤ 2*R) :
    p^2*(M^2/Q-M-2*W)-B ≤ 2*R := by
  have total := (Finset.sum_le_sum compare).trans cycles
  simp only [Finset.sum_sub_distrib, ← Finset.mul_sum, mass] at total
  have coeff := mul_le_mul_of_nonneg_left square_mass (sq_nonneg p)
  have loss := mul_le_mul_of_nonneg_left adjacent (sq_nonneg p)
  linarith only [total, coeff, loss, error]

end Erdos810.RandomCollisionCounts
#print axioms Erdos810.RandomCollisionCounts.influence_squares
#print axioms Erdos810.RandomCollisionCounts.tangent_pieces
#print axioms Erdos810.RandomCollisionCounts.transfer
