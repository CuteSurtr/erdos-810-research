import Mathlib.Tactic
import Mathlib.Algebra.Order.Chebyshev

/-! # Counting repeated incident colors in large color stars -/

set_option autoImplicit false
namespace Erdos810.RepeatedCycleStars

/-- Subtract the original star center from the common-neighbor pair sum. -/
noncomputable def marks {n : ℕ} (r : Fin n → ℝ) (k : ℝ) : ℝ :=
  ((∑ y, r y ^ 2) - (∑ y, r y) - k*(k-1))/2

private theorem twice_choose (a : ℕ) :
    2*(a.choose 2 : ℝ) = (a : ℝ)^2-a := by
  induction a with
  | zero => norm_num
  | succ a ih =>
    rw [Nat.choose_succ_succ]
    simp only [Nat.choose_one_right, Nat.cast_add, Nat.cast_succ]
    nlinarith only [ih]

/-- The real formula counts pairs of distinct leaves sharing a second center. -/
theorem marks_count {n : ℕ} (b : Fin n) (r : Fin n → ℕ) :
    marks (fun y ↦ (r y : ℝ)) (r b) =
      ∑ y ∈ Finset.univ.erase b, ((r y).choose 2 : ℝ) := by
  have split := Finset.sum_erase_add (s := Finset.univ) (fun y ↦ ((r y).choose 2 : ℝ))
    (Finset.mem_univ b)
  have total := Finset.sum_congr (s₁ := (Finset.univ : Finset (Fin n))) rfl
    (fun y _ ↦ twice_choose (r y))
  rw [← Finset.mul_sum, Finset.sum_sub_distrib] at total
  unfold marks
  nlinarith only [split, total, twice_choose (r b)]

/-- When each leaf has degree at least δ n, a sufficiently large star accounts for
at least n marks per leaf, counted with the center distinguished on a four-cycle. -/
theorem heavy_star {n : ℕ} (npos : 0 < n) {δ k : ℝ}
    (hd : 0 ≤ δ) (hk : 0 ≤ k) (hn : 4 ≤ δ^2*n) (heavy : 4 ≤ δ^2*k)
    (r : Fin n → ℝ) (cap : ∀ y, r y ≤ k) (mass : δ*n*k ≤ ∑ y, r y) :
    (n : ℝ)*k ≤ marks r k := by
  have np : 0 < (n : ℝ) := by exact_mod_cast npos
  have cauchy : (∑ y, r y)^2 ≤ (n : ℝ)*(∑ y, r y^2) := by
    simpa using (sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := r))
  have energy : δ^2*(n : ℝ)*k^2 ≤ ∑ y, r y ^ 2 := by
    apply (mul_le_mul_iff_right₀ np).mp
    calc
      _ = (δ*(n : ℝ)*k)^2 := by ring
      _ ≤ (∑ y, r y)^2 := pow_le_pow_left₀ (by positivity) mass 2
      _ ≤ _ := by simpa only [mul_comm (n : ℝ)] using cauchy
  have upper : (∑ y, r y) ≤ (n : ℝ)*k := by
    simpa using (Finset.sum_le_sum (s := Finset.univ) (fun y _ ↦ cap y))
  have m₁ := mul_nonneg (sub_nonneg.mpr heavy) (mul_nonneg np.le hk)
  have m₂ := mul_nonneg (sub_nonneg.mpr hn) (sq_nonneg k)
  unfold marks
  nlinarith only [energy, upper, m₁, m₂, hk]

/-- A center b and leaf set T in an actual incidence family. For a graph, N x
is the neighborhood of x, and the pairs counted here are monochromatic at b
whenever the spokes from b to T have a common color. -/
theorem heavy_incidence {n : ℕ} (npos : 0 < n) (b : Fin n) (T : Finset (Fin n))
    (N : Fin n → Finset (Fin n)) {δ : ℝ} (hd : 0 ≤ δ)
    (hn : 4 ≤ δ^2*n) (large : 4 ≤ δ^2*T.card)
    (neighbors : ∀ x ∈ T, b ∈ N x) (degrees : ∀ x ∈ T, δ*n ≤ (N x).card) :
    (n : ℝ)*T.card ≤ ∑ y ∈ Finset.univ.erase b,
      (((T.filter (fun x ↦ y ∈ N x)).card).choose 2 : ℝ) := by
  let r (y : Fin n) := (T.filter (fun x ↦ y ∈ N x)).card
  have rb : r b = T.card := by
    simp only [r, Finset.filter_eq_self.mpr neighbors]
  have mass : (∑ y, (r y : ℝ)) = ∑ x ∈ T, ((N x).card : ℝ) := calc
    _ = ∑ y : Fin n, ∑ x ∈ T, (if y ∈ N x then 1 else 0 : ℝ) := by simp [r]
    _ = ∑ x ∈ T, ∑ y : Fin n, (if y ∈ N x then 1 else 0 : ℝ) := Finset.sum_comm
    _ = _ := by simp
  have lower : δ*(n : ℝ)*T.card ≤ ∑ y, (r y : ℝ) := by
    rw [mass]
    simpa only [Finset.sum_const, nsmul_eq_mul, mul_comm (T.card : ℝ)] using
      (Finset.sum_le_sum degrees)
  have bound := heavy_star npos hd (Nat.cast_nonneg T.card) hn large
    (fun y ↦ (r y : ℝ)) (fun y ↦ by
      change ((T.filter (fun x ↦ y ∈ N x)).card : ℝ) ≤ (T.card : ℝ)
      exact_mod_cast (Finset.card_filter_le T (fun x ↦ y ∈ N x))) lower
  rw [← rb, marks_count b r] at bound
  simpa only [rb] using bound

/-- A four-cycle has at most four marked centers. Sum the local deletion costs. -/
theorem total_heavy_loss {ι : Type*} (H : Finset ι) (k z : ι → ℝ) {n R : ℝ}
    (cost : ∀ i ∈ H, n*k i ≤ z i) (budget : ∑ i ∈ H, z i ≤ 4*R) :
    n*(∑ i ∈ H, k i) ≤ 4*R := by
  rw [Finset.mul_sum]
  exact (Finset.sum_le_sum cost).trans budget

end Erdos810.RepeatedCycleStars
#print axioms Erdos810.RepeatedCycleStars.heavy_star
#print axioms Erdos810.RepeatedCycleStars.heavy_incidence
#print axioms Erdos810.RepeatedCycleStars.total_heavy_loss
