import Mathlib.Tactic

/-! # Finite identities for the unordered-pair graph of a matching coloring -/

set_option autoImplicit false
namespace Erdos810.PairEnergy

/-- The two possible cross matchings have at most one occupied edge each. -/
theorem local_compression (p q : ℕ) (hp : p ≤ 1) (hq : q ≤ 1) :
    ((p : ℤ) - q)^2 = (if p+q = 1 then 1 else 0) := by
  interval_cases p <;> interval_cases q <;> decide

/-- An independent indicator, centered at any real parameter, on a list of graph edges. -/
theorem centered_edge_sum {ι : Type*} (E : Finset ι) (l r : ι → ℝ)
    (ind : ∀ i ∈ E, l i * r i = 0) (t : ℝ) :
    ∑ i ∈ E, (l i-t)*(r i-t) =
      -(t*(∑ i ∈ E, (l i+r i))) + E.card*t^2 := by
  calc
    _ = ∑ i ∈ E, (-(t*(l i+r i))+t^2) := by
      apply Finset.sum_congr rfl
      intro i hi
      nlinarith only [ind i hi]
    _ = _ := by
      rw [Finset.sum_add_distrib, Finset.sum_neg_distrib, ← Finset.mul_sum]
      simp

/-- The degree-centered test vector gives the exact normalized Rayleigh quotient. -/
theorem normalized_ratio {v w : ℝ} (hw : 0 < w) (hwv : w < v) :
    -2*(w/v)*w + (w/v)^2*v =
      -(w/(v-w))*(w*(1-w/v)^2 + (v-w)*(w/v)^2) := by
  field_simp [ne_of_gt (lt_trans hw hwv), ne_of_gt (sub_pos.mpr hwv)]
  ring

end Erdos810.PairEnergy
#print axioms Erdos810.PairEnergy.local_compression
#print axioms Erdos810.PairEnergy.centered_edge_sum
#print axioms Erdos810.PairEnergy.normalized_ratio
