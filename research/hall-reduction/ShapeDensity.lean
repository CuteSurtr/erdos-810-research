import ProfileGlobal
import ProfileTerminal
import CertifiedProfiles
import ShapeTerminalSigns
import ShapeSigns
import ShapeFixedPoint

/-! # The unrestricted asymptotic coefficient 148677/500000 -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810
open PolynomialCertificate

private theorem shapeCap_eq (x : ℝ) : shapeCap.eval x 0 = affineCut shapeWidth shapeSlope x := by
  simp only [shapeCap,affineCut,Expr.eval_sq,Expr.eval_add,Expr.eval_mul,Expr.eval_sub,Expr.eval_rat,
    Expr.eval_s,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat]
  ring

private theorem shapeCap_nonneg {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) :
    0 ≤ affineCut shapeWidth shapeSlope x := by
  unfold affineCut shapeWidth shapeSlope
  push_cast
  nlinarith only [mul_nonneg hx.1 (sub_nonneg.mpr hx.2),hx.2]

private theorem shapeCap_interior {a b : ℝ} (hs : a+b=1)
    (hz : affineCut shapeWidth shapeSlope a < a*b) : a ∈ Set.Icc (1/16:ℝ) (15/16) := by
  rw [show b=1-a by linarith] at hz
  unfold affineCut shapeWidth shapeSlope at hz
  push_cast at hz
  constructor
  · by_contra! outside
    nlinarith only [sq_nonneg a,outside,hz]
  · by_contra! outside
    nlinarith only [sq_nonneg (a-15/16),outside,hz]

theorem certified_shape_bound : SampleUpper (fun _ ↦ True) (shapeBound (realPoly P₆)) := by
  apply valid_shape_bound fifth_profile_valid.1 (realPoly_continuous P₅) fifth_profile_valid.2
    sixth_profile_valid.1 (realPoly_continuous P₆)
  intro s hs t ht
  have sign := shapeStep_sign s hs t ht
  simpa only [shapeStep,shapeValue,zero_mul,add_zero,shapeWeight_scaled,Expr.eval_sq,Expr.eval_add,Expr.eval_sub,Expr.eval_mul,Expr.eval_s,
    Expr.eval_t,Expr.eval_rat,Expr.eval_nat,horner_eval,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat,
    Nat.cast_ofNat,Nat.cast_one] using sign

/-- The one-variable polynomial obtained by evaluating a weighted endpoint update at a trial cap. -/
def weightedCutTest (P : List ℚ) (h : Expr) : Expr :=
  let pair := cutExpr P (h,1)
  let a := Expr.s
  let b := 1-a
  let W := b*(4-3*a)*(a-h).sq*(a-2*h).sq+a*(4-3*b)*(b-h).sq*(b-2*h).sq
  a*b*(h*pair.2-pair.1)+h*(Expr.rat (1/5)*W)*pair.1

theorem shape_cut_of_certificate (P : List ℚ) (hu : UnitProfile (realPoly P))
    (prior : SampleUpper (fun _ ↦ True) (shapeBound (realPoly P))) (e : Expr) (w j : ℝ)
    (cap_eq : ∀ x, e.eval x 0=affineCut w j x)
    (cap_nonneg : ∀ {x}, x ∈ Set.Icc (0:ℝ) 1 → 0 ≤ affineCut w j x)
    (interior : ∀ {a b : ℝ}, a+b=1 → affineCut w j a < a*b → a ∈ Set.Icc (1/16:ℝ) (15/16))
    (test : ∀ x ∈ Set.Icc (1/16:ℝ) (15/16), 0 ≤ (weightedCutTest P e).eval x 0) :
    SampleUpper FullCut (fun a _ ↦ affineCut w j a) := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨ha,hb,hs,_,_⟩ := H.range hn
    exact cap_nonneg ⟨ha,by linarith⟩
  · intro T _
    have continuous : Continuous (affineCut (w:ℝ) j) := by unfold affineCut; fun_prop
    exact (continuous.tendsto T.a).comp T.sideA
  · intro T shape hm
    have eq : (fun i ↦ (T.sample i).a+(T.sample i).b) = fun _ ↦ (1:ℝ) := funext shape
    have curve := T.sideA.add T.sideB
    change Tendsto (fun i ↦ (T.sample i).a+(T.sample i).b) atTop _ at curve
    rw [eq] at curve
    have sum : T.a+T.b=1 := tendsto_nhds_unique curve tendsto_const_nhds
    obtain ⟨ha,hb⟩ := T.positive_sides hm
    have cap0 := cap_nonneg (x := T.a) ⟨ha.le,by linarith⟩
    apply T.le_of_shape_update hu (realPoly_continuous P) prior hm sum cap0
    intro hz
    let h := e.eval T.a 0
    have sb : 1-T.a=T.b := by linarith
    have sign := test T.a (interior sum hz)
    let pair := cutExpr P (e,1)
    have cleared : 0 ≤ (e*pair.2-pair.1).eval T.a 0 +
        h*shapeExtra T.a T.b h*(pair.1.eval T.a 0) := by
      let z := T.a*T.b
      have zp : 0 < z := mul_pos ha hb
      have scaled := scaled_shapeExtra ha hb h
      have raw : 0 ≤ z*((e*pair.2-pair.1).eval T.a 0)+
          h*((1/5)*(T.b*(4-3*T.a)*(T.a-h)^2*(T.a-2*h)^2+
          T.a*(4-3*T.b)*(T.b-h)^2*(T.b-2*h)^2))*(pair.1.eval T.a 0) := by
        change 0 ≤ (Expr.s*(1-Expr.s)*(e*pair.2-pair.1)+
          e*(Expr.rat (1/5)*((1-Expr.s)*(4-3*Expr.s)*(Expr.s-e).sq*(Expr.s-2*e).sq+
          Expr.s*(4-3*(1-Expr.s))*((1-Expr.s)-e).sq*((1-Expr.s)-2*e).sq))*pair.1).eval T.a 0 at sign
        simpa only [z,h,Expr.eval_add,Expr.eval_mul,Expr.eval_sub,Expr.eval_sq,Expr.eval_s,Expr.eval_nat,
          Expr.eval_rat,Nat.cast_one,Nat.cast_ofNat,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat,sb] using sign
      rw [← scaled] at raw
      apply nonneg_of_mul_nonneg_right _ zp
      change 0 ≤ z*((e*pair.2-pair.1).eval T.a 0+h*shapeExtra T.a T.b h*(pair.1.eval T.a 0))
      change 0 ≤ z*((e*pair.2-pair.1).eval T.a 0)+h*(z*shapeExtra T.a T.b h)*(pair.1.eval T.a 0) at raw
      nlinarith only [raw]
    have wa := shapeWeight_nonneg (s := T.a) ⟨ha.le,by linarith⟩
    have wb := shapeWeight_nonneg (s := T.b) ⟨hb.le,by linarith⟩
    have sub := update_le_of_sign_extra P hu e ha hb sum
      (by rwa [cap_eq]) (by rw [cap_eq]; exact hz.le)
      (extra := shapeExtra T.a T.b h) (by unfold shapeExtra; positivity) cleared
    simpa only [cutUpdateWith,h,cap_eq] using sub

theorem certified_shape_cut : SampleUpper FullCut (fun a _ ↦ affineCut shapeWidth shapeSlope a) :=
  shape_cut_of_certificate P₆ sixth_profile_valid.1 certified_shape_bound shapeCap shapeWidth shapeSlope
    shapeCap_eq shapeCap_nonneg shapeCap_interior (fun _ hx ↦ shapeTest_nonnegative hx)

/-- The upper bound applies to the original unrestricted extremal function. -/
theorem maxRainbowC4Edges_eventually_shape (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ (148677/500000+ε)*(n:ℝ)^2 := by
  have gap : (shapeSlope:ℝ) < 2*(shapeWidth:ℝ) := by norm_num [shapeSlope,shapeWidth]
  have coeff : (shapeWidth:ℝ)/2=148677/500000 := by norm_num [shapeWidth]
  simpa only [coeff] using maxRainbowC4Edges_eventually_of_cut gap certified_shape_cut ε he

end Erdos810
#assert_no_sorry Erdos810.certified_shape_cut Erdos810.maxRainbowC4Edges_eventually_shape
