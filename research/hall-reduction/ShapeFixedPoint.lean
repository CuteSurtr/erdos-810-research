import ShapeEndpoint
import FullCutContraction

/-! # Fixed-point control for the imbalance-corrected bound -/

set_option autoImplicit false
namespace Erdos810

private theorem quartic_sub_le {v x y : ℝ} (v0 : 0 ≤ v)
    (hx : 0 ≤ x) (hxy : x ≤ y) (hy : y ≤ v) :
    (v-x)^2*(v-2*x)^2-(v-y)^2*(v-2*y)^2 ≤ 6*v^3*(y-x) := by
  let A := fun k ↦ (v-k)*(v-2*k)
  have absA {k : ℝ} (k0 : 0 ≤ k) (kv : k ≤ v) : |A k| ≤ v^2 := by
    change |(v-k)*(v-2*k)| ≤ _
    rw [abs_mul,abs_of_nonneg (sub_nonneg.mpr kv),pow_two]
    apply mul_le_mul (by linarith) _ (abs_nonneg _) v0
    exact abs_le.mpr ⟨by linarith,by linarith⟩
  have B : |3*v-2*x-2*y| ≤ 3*v := abs_le.mpr ⟨by linarith,by linarith⟩
  have C : |A x+A y| ≤ 2*v^2 := (abs_add_le ..).trans (by
    linarith only [absA hx (hxy.trans hy),absA (hx.trans hxy) hy])
  have mult := mul_le_mul B C (abs_nonneg _) (by positivity : 0 ≤ 3*v)
  rw [← abs_mul] at mult
  have cap : (3*v-2*x-2*y)*(A x+A y) ≤ 6*v^3 := by
    nlinarith only [le_abs_self ((3*v-2*x-2*y)*(A x+A y)),mult]
  have id : (v-x)^2*(v-2*x)^2-(v-y)^2*(v-2*y)^2=(y-x)*((3*v-2*x-2*y)*(A x+A y)) := by
    dsimp only [A]; ring
  rw [id]
  nlinarith only [mul_le_mul_of_nonneg_left cap (sub_nonneg.mpr hxy)]

theorem RectangleLimit.le_of_shape_update {P : ℝ → ℝ} (T : RectangleLimit)
    (hu : UnitProfile P) (hc : Continuous P) (v : SampleUpper (fun _ ↦ True) (shapeBound P))
    (hm : 0 < T.m) (hs : T.a+T.b=1) {h : ℝ} (h0 : 0 ≤ h)
    (step : h < T.a*T.b → cutUpdateWith P (shapeExtra T.a T.b) T.a T.b h ≤ h) : T.m ≤ h := by
  by_contra! bad
  obtain ⟨ha,hb⟩ := T.positive_sides hm
  have mz := T.range.2.2.2.2
  have ha1 : T.a ≤ 1 := by linarith
  have hb1 : T.b ≤ 1 := by linarith
  have a := quartic_sub_le ha.le h0 bad.le (mz.trans (mul_le_of_le_one_right ha.le hb1))
  have b := quartic_sub_le hb.le h0 bad.le (mz.trans (mul_le_of_le_one_left hb.le ha1))
  have wa := shapeWeight_nonneg ⟨ha.le,ha1⟩
  have wb := shapeWeight_nonneg ⟨hb.le,hb1⟩
  have coeff {v : ℝ} (v0 : 0 ≤ v) : shapeWeight v*v^3 ≤ (4/15)*v := by
    nlinarith only [mul_le_mul_of_nonneg_right (shapeWeight_sq v) v0]
  have both : shapeWeight T.a*T.a^3+shapeWeight T.b*T.b^3 ≤ 4/15 := by
    linarith [coeff ha.le,coeff hb.le]
  have est : shapeExtra T.a T.b h-shapeExtra T.a T.b T.m ≤ 2*(T.m-h) := by
    unfold shapeExtra
    nlinarith only [mul_le_mul_of_nonneg_left a wa,mul_le_mul_of_nonneg_left b wb,bad,
      mul_le_mul_of_nonneg_right both (sub_nonneg.mpr bad.le)]
  have lip := cutUpdateWith_sub_le hu ha hb hs h0 bad.le mz (by norm_num : (0:ℝ) ≤ 2)
    (fun k _ _ ↦ by unfold shapeExtra; positivity) est
  have m := T.shape_loss_bound hu hc v hm
  change T.m ≤ cutUpdateWith P (shapeExtra T.a T.b) T.a T.b T.m at m
  linarith [step (bad.trans_le mz)]

end Erdos810
#assert_no_sorry Erdos810.RectangleLimit.le_of_shape_update
