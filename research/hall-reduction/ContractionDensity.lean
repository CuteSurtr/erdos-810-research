import WidthContraction
import DirectionalDensity

/-! # Upper density from a one-sided contraction of the quadratic width bound -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810
namespace WidthDensity
open PolynomialCertificate PolynomialCertificate.Expr

def width : ℚ := 583264/1000000
def slope : ℚ := 455054/1000000

private def cap : Expr := (rat width).sq + rat slope*(s-rat width)-s.sq*rat (1/2)
private def denom : Expr :=
  let b := 1-s
  s+(1-s*rat (1/2))*(1+b*rat (1/2)-b.sq*rat (1/12))
private def test : Expr := cap*denom-s*(1-s)

set_option maxRecDepth 10000
private theorem sign : IntegerChart.cover test 0 1 [1/2,583264/1000000,3/4] = true := by decide +kernel

private theorem real_sign {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) :
    x*(1-x) ≤ affineCut width slope x*(x+(1-x/2)*widthPoly 0 (1-x)) := by
  have h := IntegerChart.cover_sound sign x (by simpa using hx)
  unfold test cap denom at h
  simp only [eval_sq,eval_add,eval_mul,eval_sub,eval_rat,eval_nat,eval_s,
    Nat.cast_one,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat] at h
  unfold affineCut widthPoly
  linarith only [h]

private theorem cap_nonneg {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) : 0 ≤ affineCut width slope x := by
  unfold affineCut width slope
  push_cast
  nlinarith only [mul_nonneg hx.1 (sub_nonneg.mpr hx.2),hx.2]

theorem cut : SampleUpper FullCut (fun a _ ↦ affineCut width slope a) := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨ha,hb,hs,_,_⟩ := H.range hn
    exact cap_nonneg ⟨ha,by linarith⟩
  · intro T _
    have c : Continuous (affineCut (width:ℝ) slope) := by unfold affineCut; fun_prop
    exact (c.tendsto T.a).comp T.sideA
  · intro T full hm
    have eq : (fun i ↦ (T.sample i).a+(T.sample i).b) = fun _ ↦ (1:ℝ) := funext full
    have lim := T.sideA.add T.sideB
    change Tendsto (fun i ↦ (T.sample i).a+(T.sample i).b) atTop _ at lim
    rw [eq] at lim
    have sum : T.a+T.b=1 := tendsto_nhds_unique lim tendsto_const_nhds
    obtain ⟨ha,hb,_,_,_⟩ := T.range
    have a1 : T.a ≤ 1 := by linarith
    have range := widthPoly_range (e := 0) (by norm_num)
    have positive := (range T.b ⟨hb,by linarith⟩).1
    have den : 0 < T.a+(1-T.a/2)*widthPoly 0 T.b :=
      add_pos_of_nonneg_of_pos ha (mul_pos (by linarith) positive)
    have q := real_sign (x := T.a) ⟨ha,a1⟩
    rw [show 1-T.a=T.b by linarith] at q
    exact (mul_le_mul_iff_left₀ den).mp
      ((T.proportional_row (widthPoly_continuous _) range quadratic_width_valid hm).trans q)

end WidthDensity
/-- The bound on all n-vertex graphs with all four-cycles rainbow, including improper colorings. -/
theorem maxRainbowC4Edges_eventually_291632 (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ (291632/1000000+ε)*(n:ℝ)^2 := by
  have gap : (WidthDensity.slope:ℝ) < 2*(WidthDensity.width:ℝ) := by
    norm_num [WidthDensity.slope,WidthDensity.width]
  have w : (WidthDensity.width:ℝ)/2 = 291632/1000000 := by norm_num [WidthDensity.width]
  simpa only [w] using maxRainbowC4Edges_eventually_of_cut gap WidthDensity.cut ε he

end Erdos810
#assert_no_sorry Erdos810.maxRainbowC4Edges_eventually_291632
