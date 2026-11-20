import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-! # Averaging the cost of clearing just the active spokes

Left and right extra counts record unmatched spokes incident to a possible
middle edge of the chosen color. Only the smaller collection is required.
The real inequalities are normalized by the number of non-hub vertices.
-/

set_option autoImplicit false
open scoped BigOperators
namespace Erdos810.ActiveSpokes

theorem average_cost (n k L : ℕ) (left right hub : Fin n → ℕ)
    (per : ∀ c, L ≤ k + min (left c) (right c) + hub c) :
    2*n*L ≤ 2*n*k + (∑ c, left c) + (∑ c, right c) + 2*(∑ c, hub c) := by
  have each (c : Fin n) : 2*L ≤ 2*k + left c + right c + 2*hub c := by
    have h := per c
    have h₁ := min_le_left (left c) (right c)
    have h₂ := min_le_right (left c) (right c)
    omega
  have total := Finset.sum_le_sum (s := Finset.univ) (fun c _ => each c)
  simp only [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ,
    Fintype.card_fin, nsmul_eq_mul, ← Finset.mul_sum] at total
  nlinarith

/-- d is the maximum permitted combined star size and b is the largest
permitted split count. The averaged rectangle estimate grows in both. -/
theorem active_estimate {a b z x y : ℝ}
    (hx : 0 ≤ x) (hunit : x ≤ 1) (za : z ≤ a) (zb : z ≤ b)
    (fit : a+b ≤ 1+x) (split : z ≤ 1-x)
    (average : y ≤ z+(2*a*b-z*(a+b))/4) :
    y ≤ 1-x+(1+x)*(3*x-1)/8 := by
  have balance := sq_nonneg (a-b)
  have monotone_d : 0 ≤ (1+x-(a+b))*(1+x+(a+b)-2*z) :=
    mul_nonneg (by linarith) (by linarith)
  have monotone_z : 0 ≤ (1-x-z)*(3-x) :=
    mul_nonneg (by linarith) (by linarith)
  nlinarith

/-- The smaller star gives the lower-overlap branch. The uniform directed
rectangle density of one half controls the higher-overlap branch. -/
theorem sharp_envelope {a b z x y : ℝ}
    (hx : 0 ≤ x) (hunit : x ≤ 1) (za : z ≤ a) (zb : z ≤ b)
    (fit : a+b ≤ 1+x) (split : z ≤ 1-x) (star : 2*y ≤ a+b)
    (average : y ≤ z+(2*a*b-z*(a+b))/4) : y ≤ 2/3 := by
  by_cases small : x ≤ 1/3
  · linarith
  have avg := active_estimate hx hunit za zb fit split average
  have loss : 0 ≤ (3*x-1)*(5-3*x) := mul_nonneg (by linarith) (by linarith)
  nlinarith

/-- At a high-overlap extremum the loss is at least a quarter of the
excess overlap. At low overlap the smaller-star bound loses half the deficit. -/
theorem overlap_stability {a b z x y : ℝ}
    (hx : 0 ≤ x) (hunit : x ≤ 1) (za : z ≤ a) (zb : z ≤ b)
    (fit : a+b ≤ 1+x) (split : z ≤ 1-x) (star : 2*y ≤ a+b)
    (average : y ≤ z+(2*a*b-z*(a+b))/4) :
    1/3-2*(2/3-y) ≤ x ∧ x ≤ 1/3+4*(2/3-y) := by
  constructor
  · linarith
  by_cases small : x ≤ 1/3
  · have hy := sharp_envelope hx hunit za zb fit split star average
    linarith
  · have avg := active_estimate hx hunit za zb fit split average
    have sign : 0 ≤ (3*x-1)*(1-x) := mul_nonneg (by linarith) (by linarith)
    nlinarith

end Erdos810.ActiveSpokes
