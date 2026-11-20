import ProfileGlobal
import ProfileTerminal
import CertifiedProfiles
import FixedPointSigns
import FullCutContraction

/-! # The unrestricted asymptotic coefficient 1190169/4000000 -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810
open PolynomialCertificate

private theorem fixedCap_eq (x : ℝ) : fixedCap.eval x 0 = affineCut fixedWidth fixedSlope x := by
  simp only [fixedCap,affineCut,Expr.eval_sq,Expr.eval_add,Expr.eval_mul,Expr.eval_sub,Expr.eval_rat,
    Expr.eval_s,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat]
  ring

private theorem fixedCap_nonneg {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) :
    0 ≤ affineCut fixedWidth fixedSlope x := by
  unfold affineCut fixedWidth fixedSlope
  push_cast
  nlinarith only [mul_nonneg hx.1 (sub_nonneg.mpr hx.2),hx.2]

private theorem fixedCap_interior {a b : ℝ} (hs : a+b=1)
    (hz : affineCut fixedWidth fixedSlope a < a*b) : a ∈ Set.Icc (1/16:ℝ) (15/16) := by
  rw [show b=1-a by linarith] at hz
  unfold affineCut fixedWidth fixedSlope at hz
  push_cast at hz
  constructor
  · by_contra! outside
    nlinarith only [sq_nonneg a,outside,hz]
  · by_contra! outside
    nlinarith only [sq_nonneg (a-15/16),outside,hz]

/-- A degree-24 certificate and the contraction give a uniform estimate for every full cut. -/
theorem certified_full_cut : SampleUpper FullCut (fun a _ ↦ affineCut fixedWidth fixedSlope a) := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨ha,hb,hs,_,_⟩ := H.range hn
    exact fixedCap_nonneg ⟨ha,by linarith⟩
  · intro T _
    have continuous : Continuous (affineCut (fixedWidth:ℝ) fixedSlope) := by unfold affineCut; fun_prop
    exact (continuous.tendsto T.a).comp T.sideA
  · intro T shape hm
    have eq : (fun i ↦ (T.sample i).a+(T.sample i).b) = fun _ ↦ (1:ℝ) := funext shape
    have curve := T.sideA.add T.sideB
    change Tendsto (fun i ↦ (T.sample i).a+(T.sample i).b) atTop _ at curve
    rw [eq] at curve
    have sum : T.a+T.b=1 := tendsto_nhds_unique curve tendsto_const_nhds
    obtain ⟨ha,hb⟩ := T.positive_sides hm
    have cap0 := fixedCap_nonneg (x := T.a) ⟨ha.le,by linarith⟩
    apply T.le_of_fullCutUpdate sixth_profile_valid.1 (realPoly_continuous P₆) sixth_profile_valid.2 hm sum cap0
    intro hz
    have sign := fixedTest_nonnegative (fixedCap_interior sum hz)
    have sub := update_le_of_sign P₆ sixth_profile_valid.1 fixedCap ha hb sum
      (by rwa [fixedCap_eq]) (by rw [fixedCap_eq]; exact hz.le) sign
    simpa only [fullCutUpdate,fixedCap_eq] using sub

/-- The upper bound applies to the original unrestricted extremal function. -/
theorem maxRainbowC4Edges_eventually_fixedPoint (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ (1190169/4000000+ε)*(n:ℝ)^2 := by
  have gap : (fixedSlope:ℝ) < 2*(fixedWidth:ℝ) := by norm_num [fixedSlope,fixedWidth]
  have coeff : (fixedWidth:ℝ)/2=1190169/4000000 := by norm_num [fixedWidth]
  simpa only [coeff] using maxRainbowC4Edges_eventually_of_cut gap certified_full_cut ε he

theorem maxRainbowC4Edges_eventually_5951 (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ (5951/20000+ε)*(n:ℝ)^2 := by
  filter_upwards [maxRainbowC4Edges_eventually_fixedPoint ε he] with n hn
  exact hn.trans (mul_le_mul_of_nonneg_right (by linarith : (1190169/4000000:ℝ)+ε ≤ 5951/20000+ε) (sq_nonneg _))

end Erdos810
#assert_no_sorry Erdos810.sixth_profile_valid Erdos810.certified_full_cut
  Erdos810.maxRainbowC4Edges_eventually_fixedPoint
