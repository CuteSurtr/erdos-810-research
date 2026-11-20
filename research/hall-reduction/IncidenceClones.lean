import IntervalWindows
import Mathlib.Data.Real.Sqrt

/-! # Rainbow graphs above incidences with bounded line size -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

private theorem cost_of_capacity {x d s : ℝ} (hx : 0 ≤ x) (hd : 0 ≤ d) (hs : 0 ≤ s)
    (hc : x*d ≤ 4*s^2) : x*d ≤ s*(x+d) := by
  apply (sq_le_sq₀ (mul_nonneg hx hd) (mul_nonneg hs (add_nonneg hx hd))).mp
  nlinarith only [mul_nonneg (sq_nonneg s) (sq_nonneg (x-d)),
    mul_nonneg (mul_nonneg hx hd) (sub_nonneg.mpr hc)]

/-- Weighted incidence bound with a palette cap on every nontrivial complete rectangle.
The parameter k bounds the number of distinct point classes on a line vertex. -/
theorem bounded_incidence_cost {I : Type*} (points : Finset I) (a d : I → ℕ) (q : ℕ)
    (k L : ℝ) (hk : 0 < k)
    (lines : ∑ i ∈ points, (d i : ℝ) ≤ k*L)
    (capacity : ∀ i ∈ points, 1 < a i → 1 < d i → a i*d i ≤ q) :
    ∑ i ∈ points, (a i : ℝ)*d i ≤
      Real.sqrt (k*q)/2 * ((∑ i ∈ points, (a i : ℝ)) + L) +
        (∑ i ∈ points, (a i : ℝ)) + k*L := by
  let s := Real.sqrt (k*q)/2
  have hs : 0 ≤ s := by dsimp [s]; positivity
  have budget : k*q = 4*s^2 := by
    dsimp [s]
    have h := Real.sq_sqrt (mul_nonneg hk.le (Nat.cast_nonneg q))
    nlinarith only [h]
  have per (i : I) (hi : i ∈ points) :
      k*((a i : ℝ)*d i) ≤ s*(k*a i+d i) + k*((a i : ℝ)+d i) := by
    have hpos : 0 ≤ s*(k*a i+d i) := by positivity
    by_cases ha : 1 < a i
    · by_cases hd : 1 < d i
      · have bound : (a i : ℝ)*d i ≤ q := by exact_mod_cast capacity i hi ha hd
        have hc : k*(a i : ℝ)*d i ≤ 4*s^2 := by
          rw [mul_assoc, ← budget]
          exact mul_le_mul_of_nonneg_left bound hk.le
        have h := cost_of_capacity (mul_nonneg hk.le (Nat.cast_nonneg _))
          (Nat.cast_nonneg _) hs hc
        simpa only [mul_assoc] using h.trans (le_add_of_nonneg_right
          (mul_nonneg hk.le (add_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _))))
      · have h1 : (d i : ℝ) ≤ 1 := by exact_mod_cast (by omega : d i ≤ 1)
        have h2 := mul_le_mul_of_nonneg_left h1 (Nat.cast_nonneg (a i) (α := ℝ))
        nlinarith only [hpos, mul_nonneg hk.le (sub_nonneg.mpr h2),
          mul_nonneg hk.le (Nat.cast_nonneg (d i) (α := ℝ))]
    · have h1 : (a i : ℝ) ≤ 1 := by exact_mod_cast (by omega : a i ≤ 1)
      have h2 := mul_le_mul_of_nonneg_right h1 (Nat.cast_nonneg (d i) (α := ℝ))
      nlinarith only [hpos, mul_nonneg hk.le (sub_nonneg.mpr h2),
        mul_nonneg hk.le (Nat.cast_nonneg (a i) (α := ℝ))]
  have total := Finset.sum_le_sum per
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum] at total
  have ht := mul_le_mul_of_nonneg_left lines hs
  have hd := mul_le_mul_of_nonneg_left lines hk.le
  change ∑ i ∈ points, (a i : ℝ)*d i ≤ s*((∑ i ∈ points, (a i : ℝ))+L) +
    (∑ i ∈ points, (a i : ℝ)) + k*L
  apply (le_of_mul_le_mul_left _ hk)
  nlinarith only [total, ht, hd]

/-- Apply the incidence bound directly to the rectangles of a rainbow graph. -/
theorem rainbow_incidence_clones {I V K : Type*} [Fintype K] {G : SimpleGraph V}
    (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4))
    (points : Finset I) (A B : I → Finset V)
    (sides : ∀ i ∈ points, ∀ x ∈ A i, ∀ y ∈ B i, G.Adj x y)
    (k L : ℝ) (hk : 0 < k) (lines : ∑ i ∈ points, ((B i).card : ℝ) ≤ k*L) :
    ∑ i ∈ points, ((A i).card : ℝ)*(B i).card ≤
      Real.sqrt (k*Fintype.card K)/2 * ((∑ i ∈ points, ((A i).card : ℝ)) + L) +
        (∑ i ∈ points, ((A i).card : ℝ)) + k*L := by
  apply bounded_incidence_cost points (fun i ↦ (A i).card) (fun i ↦ (B i).card)
    (Fintype.card K) k L hk lines
  intro i hi ha hb
  exact rectangle_palette_bound C hr (A i) (B i) ha hb (sides i hi)

end Erdos810

#assert_no_sorry Erdos810.bounded_incidence_cost Erdos810.rainbow_incidence_clones
