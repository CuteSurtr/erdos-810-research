import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Util.AssertNoSorry

/-! # Rational separation of the upper and lower missing-edge counts -/

set_option autoImplicit false
namespace Erdos810.ShadowGap

/-- The normalized endpoint count implies a lower bound for the missing fraction
in a cut of normalized product p and sum a. Here h is the reciprocal order. -/
theorem cut_tangent {p a l h t : ℝ} (hp : 0 ≤ p) (ha : 0 ≤ a) (hl : 0 ≤ l)
    (hh : 0 ≤ h) (cut : p*(p-h) ≤ (a+p)*l) :
    (2*t-t^2)*p-t^2*a-h ≤ l := by
  by_cases pos : 0 < a+p
  · apply le_of_mul_le_mul_left _ pos
    nlinarith only [cut, sq_nonneg (p-t*(a+p)), mul_nonneg hh ha]
  · have ep : p = 0 := by linarith
    have ea : a = 0 := by linarith
    rw [ep,ea]
    linarith

/-- The finite normalized moment inequalities force 3m/n² below 3(0.07384). -/
theorem density_of_moments {r D v A P L h : ℝ}
    (hr : 0 < r) (hD : 0 ≤ D) (hv : 0 ≤ v) (hh : h ≤ 1/1000000)
    (balance : D+3*v = r*(2/3+h-3*r))
    (mean : A ≤ 1/3+D/r)
    (product : r ≤ 1/4 → 1/9-(1-4*r)^2-8*v/r ≤ 4*P)
    (upper : L ≤ 2*D/3)
    (lower : r*((2*(1/16)-(1/16)^2)*P-(1/16)^2*A-h) ≤ L) :
    r < 3*(7384/100000) := by
  by_contra! low
  have room : 0 ≤ 2/3+h-3*r := nonneg_of_mul_nonneg_right (by linarith [balance]) hr
  have high : r ≤ 2/9+1/3000000 := by linarith
  have cap : D+3*v ≤ (2/9+1/3000000)*(2/3+1/1000000-3*(3*(7384/100000))) := by
    rw [balance]
    apply mul_le_mul high (by linarith) room
    norm_num
  have hc : D+3*v ≤ 469/1000000 := by linarith only [cap]
  have avg : A ≤ 336/1000 := by
    have target : D/r ≤ 336/1000-1/3 := (div_le_iff₀ hr).mpr (by linarith only [low,hc,hv])
    linarith only [mean,target]
  have variance : 8*v/r ≤ 8*(469/1000000)/(3*(3*(7384/100000))) := by
    apply (div_le_iff₀ hr).mpr
    linarith only [low,hc,hD]
  have sq : (1-4*r)^2 ≤ (1-4*(3*(7384/100000:ℝ)))^2 := by
    apply sq_le_sq' <;> linarith only [low,high]
  have hp := product (by linarith only [high])
  have prod : 231/10000 ≤ P := by linarith only [hp,sq,variance]
  have frac : (2*(1/16)-(1/16:ℝ)^2)*(231/10000)-(1/16)^2*(336/1000)-1/1000000 ≤
      (2*(1/16)-(1/16)^2)*P-(1/16)^2*A-h := by linarith only [prod,avg,hh]
  have nonneg : 0 ≤ (2*(1/16)-(1/16:ℝ)^2)*(231/10000)-(1/16)^2*(336/1000)-1/1000000 := by norm_num
  have contrad := mul_le_mul low frac nonneg hr.le
  linarith only [contrad,lower,upper,hc,hv]

end Erdos810.ShadowGap
assert_no_sorry Erdos810.ShadowGap.cut_tangent
assert_no_sorry Erdos810.ShadowGap.density_of_moments
