import ShapeDensity
import ImbalanceGain
import IteratedSigns7
import IteratedSigns8

/-! # Two more certified transitions using the imbalance of the child rectangles -/

set_option autoImplicit false
namespace Erdos810
open PolynomialCertificate

private theorem gain_product (s : ℝ) :
    profileGain s = s^2*(4-3*s)^2*(4-3*s)*(4-s)^2*(9-4*s)*(1/62500) := by
  unfold profileGain
  ring

private theorem iterated_step {P Q : List ℚ} (hu : UnitProfile (realPoly P))
    (prior : SampleUpper (fun _ ↦ True) (shapeBound (realPoly P)))
    (range : BoundedPoly Q) (test : OnSquare (iteratedShapeStep P Q)) :
    UnitProfile (realPoly Q) ∧ SampleUpper (fun _ ↦ True) (shapeBound (realPoly Q)) := by
  have zero : (0:ℝ) ∈ Set.Icc (0:ℝ) 1 := ⟨le_rfl,zero_le_one⟩
  have qu := bounded_of_signs (fun x hx ↦ range.1 x hx 0 zero) (fun x hx ↦ range.2 x hx 0 zero)
  refine ⟨qu,?_⟩
  apply valid_shape_bound_of_loss (gain := profileGain) hu (realPoly_continuous P)
    (validProfile_of_shape prior) qu (realPoly_continuous Q) (fun _ hx ↦ profileGain_nonneg hx)
  · intro T hm
    obtain ⟨ha,hb,hs,_,mz⟩ := T.range
    obtain ⟨pa,pb⟩ := T.positive_sides hm
    have a1 : T.a ≤ 1 := by linarith
    have b1 : T.b ≤ 1 := by linarith
    have la := sideLoss_nonneg hu pa a1 hm.le (mz.trans (mul_le_of_le_one_right ha b1))
    have lb := sideLoss_nonneg hu pb b1 hm.le (mz.trans (mul_le_of_le_one_left hb a1))
    have sg := mul_nonneg (add_nonneg ha hb) (profileGain_nonneg ⟨add_nonneg ha hb,hs⟩)
    exact (T.shape_loss_bound hu (realPoly_continuous P) prior hm).trans (rectangleCap_antitone ha hb
      (add_pos pa pb) (add_nonneg (add_nonneg la lb) sg)
      (add_le_add_left (T.gain_le_shapeExtra hm) _))
  · intro s hs t ht
    simpa only [iteratedShapeStep,shapeValue,shapeWeight_scaled,gain_product,
      Expr.eval_sq,Expr.eval_add,Expr.eval_sub,Expr.eval_mul,Expr.eval_s,
      Expr.eval_t,Expr.eval_rat,Expr.eval_nat,horner_eval,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat,
      Nat.cast_ofNat,Nat.cast_one] using test s hs t ht

theorem eighth_shape_valid : UnitProfile (realPoly P8) ∧ SampleUpper (fun _ ↦ True) (shapeBound (realPoly P8)) := by
  have seven := iterated_step sixth_profile_valid.1 certified_shape_bound range7 iterated_sign7
  exact iterated_step seven.1 seven.2 range8 iterated_sign8

end Erdos810
#assert_no_sorry Erdos810.eighth_shape_valid
