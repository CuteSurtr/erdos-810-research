import RectangleLimit

/-! # Algebra of the unbalanced rectangle iteration -/

set_option autoImplicit false
open Filter Topology SimpleGraph
namespace Erdos810

noncomputable def rectangleCap (a b loss : ℝ) : ℝ :=
  a*b*(a+b)/(a+b+a*b*(1+loss))

noncomputable def sideScale (P : ℝ → ℝ) (v : ℝ) : ℝ := v/(1+v*P v)
noncomputable def sideLoss (P : ℝ → ℝ) (v k : ℝ) : ℝ :=
  (v-k)^2/(sideScale P v + k*(v-k))

theorem profileBound_eq_cap {P : ℝ → ℝ} (hu : UnitProfile P) {a b : ℝ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : a+b ≤ 1) (hp : 0 < a+b) :
    profileBound P a b = rectangleCap a b ((a+b)*P (a+b)) := by
  have h := (hu _ ⟨hp.le,hs⟩).1
  have d₁ : 0 < 1+(1/(a+b)+P (a+b))*(a*b) := by positivity
  have d₂ : 0 < a+b+a*b*(1+(a+b)*P (a+b)) :=
    add_pos_of_pos_of_nonneg hp (by positivity)
  unfold profileBound rectangleCap
  apply (div_eq_div_iff (ne_of_gt d₁) (ne_of_gt d₂)).mpr
  field_simp [ne_of_gt hp]

theorem sideScale_pos {P : ℝ → ℝ} (hu : UnitProfile P) {v : ℝ} (hv : 0 < v) (h1 : v ≤ 1) :
    0 < sideScale P v := by
  have h := (hu _ ⟨hv.le,h1⟩).1
  exact div_pos hv (by positivity)

theorem sideLoss_nonneg {P : ℝ → ℝ} (hu : UnitProfile P) {v k : ℝ}
    (hv : 0 < v) (h1 : v ≤ 1) (hk : 0 ≤ k) (hle : k ≤ v) : 0 ≤ sideLoss P v k := by
  exact div_nonneg (sq_nonneg _) (add_nonneg (sideScale_pos hu hv h1).le (mul_nonneg hk (sub_nonneg.mpr hle)))

theorem matchingCut_loss_identity {P : ℝ → ℝ} (hu : UnitProfile P) {v k : ℝ}
    (hv : 0 < v) (h1 : v ≤ 1) (hk : 0 ≤ k) (hle : k ≤ v) :
    matchingCut P v k = k*(v-k)-k^2*sideLoss P v k := by
  let f := sideScale P v
  let z := k*(v-k)
  have hf : 0 < f := sideScale_pos hu hv h1
  have hz : 0 ≤ z := mul_nonneg hk (sub_nonneg.mpr hle)
  have hp := (hu _ ⟨hv.le,h1⟩).1
  have den : 0 < 1+v*P v := by positivity
  have id : 1/v+P v=1/f := by
    dsimp [f,sideScale]; field_simp [ne_of_gt hv,ne_of_gt den]
  have total : 0 < f+z := by linarith
  have d : 0 < 1+(1/f)*z := by positivity
  change z/(1+(1/v+P v)*z)=z-k^2*((v-k)^2/(f+z))
  rw [id]
  field_simp [ne_of_gt d,ne_of_gt hf,ne_of_gt total]
  dsimp only [z]; ring

theorem rectangleCap_antitone {a b L U : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : 0 < a+b)
    (hL : 0 ≤ L) (hLU : L ≤ U) : rectangleCap a b U ≤ rectangleCap a b L := by
  unfold rectangleCap
  apply div_le_div_of_nonneg_left (mul_nonneg (mul_nonneg ha hb) hs.le)
    (add_pos_of_pos_of_nonneg hs (by positivity))
  nlinarith only [mul_nonneg (mul_nonneg ha hb) (sub_nonneg.mpr hLU)]

/-- Before Cauchy--Schwarz, retain one term for each of the two sides. -/
theorem RectangleLimit.loss_bound (T : RectangleLimit) {P : ℝ → ℝ} (hu : UnitProfile P)
    (hc : Continuous P) (v : ValidProfile P) (hm : 0 < T.m) :
    T.m ≤ rectangleCap T.a T.b (sideLoss P T.a T.m+sideLoss P T.b T.m) := by
  obtain ⟨ha,hb,hs,hn,hab⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have ha1 : T.a ≤ 1 := by linarith
  have hb1 : T.b ≤ 1 := by linarith
  have ma := hab.trans (mul_le_of_le_one_right ha hb1)
  have mb := hab.trans (mul_le_of_le_one_left hb ha1)
  have la := sideLoss_nonneg hu pa ha1 hn ma
  have lb := sideLoss_nonneg hu pb hb1 hn mb
  have E := T.endpoint hu hc v hm
  unfold matchingIntegrand at E
  rw [matchingCut_loss_identity hu pa ha1 hn ma,matchingCut_loss_identity hu pb hb1 hn mb] at E
  unfold rectangleCap
  apply (le_div_iff₀ (add_pos_of_pos_of_nonneg (add_pos pa pb) (by positivity))).mpr
  apply (mul_le_mul_iff_of_pos_left hm).mp
  nlinarith only [E]

private theorem engel {A B X Y : ℝ} (hA : 0 < A) (hB : 0 < B) :
    (X+Y)^2/(A+B) ≤ X^2/A+Y^2/B := by
  apply (div_le_iff₀ (add_pos hA hB)).mpr
  have id : (X^2/A+Y^2/B)*(A+B)-(X+Y)^2 = (B*X-A*Y)^2/(A*B) := by
    field_simp [ne_of_gt hA,ne_of_gt hB]; ring
  have h := div_nonneg (sq_nonneg (B*X-A*Y)) (mul_nonneg hA.le hB.le)
  linarith

/-- Uniform lower bound on both losses, evaluated at any larger edge bound. -/
theorem two_loss_lower {P : ℝ → ℝ} (hu : UnitProfile P) {a b m M : ℝ}
    (ha : 0 < a) (hb : 0 < b) (hs : a+b ≤ 1) (hm : 0 ≤ m)
    (hmM : m ≤ M) (hM : M ≤ a*b) :
    (a+b-2*M)^2/(sideScale P a+sideScale P b+M*(a+b-2*M)) ≤ sideLoss P a m+sideLoss P b m := by
  let s := a+b
  let f := sideScale P a+sideScale P b
  have ss : 0 < s := add_pos ha hb
  have ha1 : a ≤ 1 := by linarith
  have hb1 : b ≤ 1 := by linarith
  have ma := hmM.trans (hM.trans (mul_le_of_le_one_right ha.le hb1))
  have mb := hmM.trans (hM.trans (mul_le_of_le_one_left hb.le ha1))
  have fa := sideScale_pos hu ha ha1
  have fb := sideScale_pos hu hb hb1
  have F : 0 < f := add_pos fa fb
  have Mpos := hm.trans hmM
  have gap : 0 < s-2*M := by
    dsimp only [s]
    nlinarith only [sq_nonneg (a-b),hM,mul_nonneg (add_nonneg ha.le hb.le) (sub_nonneg.mpr hs),ss]
  have gap' : 0 < s-2*m := by linarith
  have D : 0 < f+M*(s-2*M) := add_pos_of_pos_of_nonneg F (mul_nonneg Mpos gap.le)
  have D' : 0 < f+m*(s-2*m) := add_pos_of_pos_of_nonneg F (mul_nonneg hm gap'.le)
  have monotone : (s-2*M)^2/(f+M*(s-2*M)) ≤ (s-2*m)^2/(f+m*(s-2*m)) := by
    apply (div_le_div_iff₀ D D').mpr
    have prod := mul_nonneg (sub_nonneg.mpr hmM) (add_nonneg
      (mul_nonneg (show 0 ≤ 4*f by positivity) (show 0 ≤ s-m-M by linarith))
      (mul_nonneg (mul_nonneg ss.le gap'.le) gap.le))
    nlinarith only [prod]
  have A : 0 < sideScale P a+m*(a-m) := add_pos_of_pos_of_nonneg fa (mul_nonneg hm (sub_nonneg.mpr ma))
  have B : 0 < sideScale P b+m*(b-m) := add_pos_of_pos_of_nonneg fb (mul_nonneg hm (sub_nonneg.mpr mb))
  refine monotone.trans ?_
  have e := engel (X := a-m) (Y := b-m) A B
  convert e using 2 <;> dsimp only [s,f,sideLoss] <;> ring

theorem sideLoss_antitone {P : ℝ → ℝ} (hu : UnitProfile P) {v m M : ℝ} (hv : 0 < v)
    (h1 : v ≤ 1) (hm : 0 ≤ m) (hM : m ≤ M) (hMv : M ≤ v) :
    sideLoss P v M ≤ sideLoss P v m := by
  let f := sideScale P v
  have pos : 0 < f := sideScale_pos hu hv h1
  have mpos := hm.trans hM
  have G := sub_nonneg.mpr hMv
  have g := sub_nonneg.mpr (hM.trans hMv)
  apply (div_le_div_iff₀ (add_pos_of_pos_of_nonneg pos (mul_nonneg mpos G))
    (add_pos_of_pos_of_nonneg pos (mul_nonneg hm g))).mpr
  have prod := mul_nonneg (sub_nonneg.mpr hM) (add_nonneg
    (mul_nonneg pos.le (show 0 ≤ 2*v-m-M by linarith)) (mul_nonneg (mul_nonneg hv.le g) G))
  nlinarith only [prod]

/-- The scalar transition test for a pair of profiles. -/
def ProfileTransition (P Q : ℝ → ℝ) : Prop :=
  ∀ a b : ℝ, 0 < a → 0 < b → a+b ≤ 1 →
    let M := profileBound P a b
    (a+b)*Q (a+b)*(sideScale P a+sideScale P b+M*(a+b-2*M)) ≤ (a+b-2*M)^2

theorem validProfile_step {P Q : ℝ → ℝ} (p : ValidProfile P) (hu : UnitProfile P)
    (hc : Continuous P) (qu : UnitProfile Q) (qc : Continuous Q) (h : ProfileTransition P Q) :
    ValidProfile Q := by
  apply validProfile_of_limits qu qc
  intro T hm
  obtain ⟨ha,hb,hs,_,_⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  let M := profileBound P T.a T.b
  have mM : T.m ≤ M := T.of_valid hu hc p hm
  have cap := (profileBound_range hu ha hb hs).2
  have mA := cap.trans (mul_le_of_le_one_right ha (by linarith))
  have mB := cap.trans (mul_le_of_le_one_left hb (by linarith))
  have mg : 0 ≤ T.a+T.b-2*M := by change M ≤ T.a at mA; change M ≤ T.b at mB; linarith
  have ss := add_pos pa pb
  have fa := sideScale_pos hu pa (by linarith : T.a ≤ 1)
  have fb := sideScale_pos hu pb (by linarith : T.b ≤ 1)
  have den := add_pos_of_pos_of_nonneg (add_pos fa fb) (mul_nonneg (hm.le.trans mM) mg)
  have test := (le_div_iff₀ den).mpr (h T.a T.b pa pb hs)
  have loss := test.trans (two_loss_lower hu pa pb hs hm.le mM cap)
  rw [profileBound_eq_cap qu ha hb hs ss]
  exact (T.loss_bound hu hc p hm).trans (rectangleCap_antitone ha hb ss
    (mul_nonneg ss.le (qu _ ⟨ss.le,hs⟩).1) loss)

theorem zero_unit : UnitProfile (fun _ ↦ 0) := fun _ _ ↦ ⟨le_rfl,zero_le_one⟩

theorem zero_valid : ValidProfile (fun _ ↦ 0) := by
  apply validProfile_of_limits zero_unit continuous_const
  intro T hm
  have finite {n : ℕ} (hn : 0 < n) (H : RectangleSample n) :
      (H.a+H.b+H.a*H.b)*H.mass ≤ H.a*H.b*(H.a+H.b+1/(n:ℝ)) := by
    have N : 0 < (n:ℝ) := by exact_mod_cast hn
    have h := rectangle_bound H.C H.proper H.rainbow H.L H.R
    rw [Fintype.card_fin] at h
    have cast : ((n:ℝ)*((H.L.card:ℝ)+H.R.card)+(H.L.card:ℝ)*H.R.card)*(rectangle H.G H.L H.R).card ≤
      (n:ℝ)*H.L.card*H.R.card*((H.L.card:ℝ)+H.R.card+1) := by exact_mod_cast h
    unfold RectangleSample.a RectangleSample.b RectangleSample.mass
    field_simp [ne_of_gt N]
    nlinarith only [cast]
  have limit := le_of_tendsto_of_tendsto (((T.sideA.add T.sideB).add (T.sideA.mul T.sideB)).mul T.edges)
    ((T.sideA.mul T.sideB).mul ((T.sideA.add T.sideB).add T.inv_order_zero))
    (T.positive_orders.mono (fun i hn ↦ finite hn (T.sample i)))
  obtain ⟨ha,hb,hs,_,_⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have s := add_pos pa pb
  rw [profileBound_eq_cap zero_unit ha hb hs s]
  unfold rectangleCap
  simp only [mul_zero,add_zero,mul_one]
  apply (le_div_iff₀ (add_pos_of_pos_of_nonneg s (mul_nonneg ha hb))).mpr
  nlinarith only [limit]

end Erdos810
#assert_no_sorry Erdos810.validProfile_step Erdos810.zero_valid
