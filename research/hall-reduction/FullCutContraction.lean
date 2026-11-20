import ProfileIteration

/-! # Contraction of the full-cut endpoint bound -/

set_option autoImplicit false
namespace Erdos810

/-- Uniform upper bound for the fall in one side's loss term. -/
theorem sideLoss_sub_le {P : ℝ → ℝ} (hu : UnitProfile P) {v x y : ℝ}
    (hv : 0 < v) (hv1 : v ≤ 1) (hx : 0 ≤ x) (hxy : x ≤ y) (hy : y ≤ v) :
    sideLoss P v x-sideLoss P v y ≤ (4+4*v)*(y-x) := by
  let f := sideScale P v
  have hP := hu v ⟨hv.le,hv1⟩
  have fpos : 0 < f := sideScale_pos hu hv hv1
  have scale : v ≤ 2*f := by
    have pos : 0 < 1+v*P v := by nlinarith only [mul_nonneg hv.le hP.1]
    have upper : v*P v ≤ 1 := (mul_le_mul_of_nonneg_left hP.2 hv.le).trans (by simpa using hv1)
    change v ≤ 2*(v/(1+v*P v))
    rw [← mul_div_assoc]
    apply (le_div_iff₀ pos).mpr
    nlinarith only [mul_le_mul_of_nonneg_left upper hv.le]
  let X := f+x*(v-x)
  let Y := f+y*(v-y)
  have fX : f ≤ X := le_add_of_nonneg_right (mul_nonneg hx (sub_nonneg.mpr (hxy.trans hy)))
  have fY : f ≤ Y := le_add_of_nonneg_right (mul_nonneg (hx.trans hxy) (sub_nonneg.mpr hy))
  have XP := fpos.trans_le fX
  have YP := fpos.trans_le fY
  have den : f*f ≤ X*Y := mul_le_mul fX fY fpos.le XP.le
  have pair : (v-x)*(v-y) ≤ v*v := mul_le_mul (by linarith) (by linarith)
    (sub_nonneg.mpr hy) hv.le
  have upperV : v*v ≤ (2*f)*(2*f) := mul_self_le_mul_self hv.le scale
  have first : f*(2*v-x-y) ≤ 4*(f*f) := by
    nlinarith only [mul_le_mul_of_nonneg_left (show 2*v-x-y ≤ 4*f by linarith) fpos.le]
  have numerator : f*(2*v-x-y)+v*(v-x)*(v-y) ≤ (4+4*v)*(X*Y) := by
    nlinarith only [first,mul_le_mul_of_nonneg_left (pair.trans upperV) hv.le,
      mul_le_mul_of_nonneg_left den (show 0 ≤ 4+4*v by linarith)]
  have diff : sideLoss P v x-sideLoss P v y =
      ((y-x)*(f*(2*v-x-y)+v*(v-x)*(v-y)))/(X*Y) := by
    change (v-x)^2/X-(v-y)^2/Y=_
    field_simp [XP.ne',YP.ne']
    dsimp only [X,Y]
    ring
  rw [diff]
  apply (div_le_iff₀ (mul_pos XP YP)).mpr
  nlinarith only [mul_le_mul_of_nonneg_left numerator (sub_nonneg.mpr hxy)]

noncomputable def fullCutUpdate (P : ℝ → ℝ) (a b k : ℝ) : ℝ :=
  rectangleCap a b (sideLoss P a k+sideLoss P b k)

noncomputable def cutUpdateWith (P E : ℝ → ℝ) (a b k : ℝ) : ℝ :=
  rectangleCap a b (sideLoss P a k+sideLoss P b k+E k)

/-- A nonnegative extra loss with one-sided Lipschitz constant c changes the factor by at most c/16. -/
theorem cutUpdateWith_sub_le {P E : ℝ → ℝ} (hu : UnitProfile P) {a b x y c : ℝ}
    (ha : 0 < a) (hb : 0 < b) (hs : a+b=1) (hx : 0 ≤ x) (hxy : x ≤ y) (hy : y ≤ a*b)
    (c0 : 0 ≤ c) (epos : ∀ k, 0 ≤ k → k ≤ a*b → 0 ≤ E k) (esteps : E x-E y ≤ c*(y-x)) :
    cutUpdateWith P E a b y-cutUpdateWith P E a b x ≤ ((12+c)/16)*(y-x) := by
  let z := a*b
  let L := fun k ↦ sideLoss P a k+sideLoss P b k+E k
  let D := fun k ↦ 1+z*(1+L k)
  have ha1 : a ≤ 1 := by linarith
  have hb1 : b ≤ 1 := by linarith
  have ya := hy.trans (mul_le_of_le_one_right ha.le hb1)
  have yb := hy.trans (mul_le_of_le_one_left hb.le ha1)
  have zz : 0 ≤ z := mul_nonneg ha.le hb.le
  have zsmall : z ≤ 1/4 := by dsimp only [z]; nlinarith only [sq_nonneg (a-b),congrArg (fun w : ℝ ↦ w^2) hs]
  have zsq : z*z ≤ 1/16 := by nlinarith only [mul_self_le_mul_self zz zsmall]
  have Lpos (k : ℝ) (k0 : 0 ≤ k) (ky : k ≤ y) : 0 ≤ L k :=
    add_nonneg (add_nonneg (sideLoss_nonneg hu ha ha1 k0 (ky.trans ya)) (sideLoss_nonneg hu hb hb1 k0 (ky.trans yb))) (epos k k0 (ky.trans hy))
  have Dlarge (k : ℝ) (k0 : 0 ≤ k) (ky : k ≤ y) : 1 ≤ D k := by
    have h := Lpos k k0 ky
    dsimp only [D]
    nlinarith only [mul_nonneg zz (show 0 ≤ 1+L k by linarith)]
  have Dx := Dlarge x hx hxy
  have Dy := Dlarge y (hx.trans hxy) le_rfl
  have Dx0 : 0 < D x := by linarith
  have Dy0 : 0 < D y := by linarith
  have Dprod : 1 ≤ D y*D x := by simpa using (mul_le_mul Dy Dx zero_le_one Dy0.le)
  have losses : L x-L y ≤ (12+c)*(y-x) := by
    have left := sideLoss_sub_le hu ha ha1 hx hxy ya
    have right := sideLoss_sub_le hu hb hb1 hx hxy yb
    unfold L
    nlinarith only [left,right,esteps,congrArg (fun w : ℝ ↦ (4*w)*(y-x)) hs]
  have eval (k : ℝ) : cutUpdateWith P E a b k=z/D k := by
    unfold cutUpdateWith rectangleCap
    rw [hs,mul_one]
  have diff : z/D y-z/D x=(z*z*(L x-L y))/(D y*D x) := by
    field_simp [Dx0.ne',Dy0.ne']
    dsimp only [D]
    ring
  rw [eval,eval,diff]
  apply (div_le_iff₀ (mul_pos Dy0 Dx0)).mpr
  have d := sub_nonneg.mpr hxy
  nlinarith only [mul_le_mul_of_nonneg_left losses (mul_nonneg zz zz),
    mul_le_mul_of_nonneg_right zsq (mul_nonneg (by linarith : 0 ≤ 12+c) d),
    mul_le_mul_of_nonneg_left Dprod (mul_nonneg (by linarith : 0 ≤ (12+c)/16) d)]

/-- Across a full cut the combined endpoint update has Lipschitz constant at most 3/4. -/
theorem fullCutUpdate_sub_le {P : ℝ → ℝ} (hu : UnitProfile P) {a b x y : ℝ}
    (ha : 0 < a) (hb : 0 < b) (hs : a+b=1) (hx : 0 ≤ x) (hxy : x ≤ y) (hy : y ≤ a*b) :
    fullCutUpdate P a b y-fullCutUpdate P a b x ≤ (3/4)*(y-x) := by
  have h := cutUpdateWith_sub_le (E := fun _ ↦ 0) hu ha hb hs hx hxy hy
    (c := 0) le_rfl (fun _ _ _ ↦ le_rfl) (by simp)
  norm_num [cutUpdateWith,fullCutUpdate] at h ⊢
  linarith only [h]

/-- A supersolution bounds every admissible positive limiting cut density. -/
theorem RectangleLimit.le_of_fullCutUpdate {P : ℝ → ℝ} (T : RectangleLimit)
    (hu : UnitProfile P) (hc : Continuous P) (v : ValidProfile P) (hm : 0 < T.m)
    (hs : T.a+T.b=1) {h : ℝ} (h0 : 0 ≤ h)
    (step : h < T.a*T.b → fullCutUpdate P T.a T.b h ≤ h) : T.m ≤ h := by
  by_contra! contrary
  obtain ⟨ha,hb⟩ := T.positive_sides hm
  have mz := T.range.2.2.2.2
  have one := T.loss_bound hu hc v hm
  change T.m ≤ fullCutUpdate P T.a T.b T.m at one
  have lipschitz := fullCutUpdate_sub_le hu ha hb hs h0 contrary.le mz
  linarith [step (contrary.trans_le mz)]

end Erdos810
#assert_no_sorry Erdos810.RectangleLimit.le_of_fullCutUpdate
