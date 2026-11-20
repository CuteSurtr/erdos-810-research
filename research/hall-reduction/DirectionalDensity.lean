import DirectionalRectangle
import IteratedProfiles
import IntegerChart

/-! # A graph density bound from the row degrees of a color-support cut -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810.PolynomialCertificate.IntegerChart

/-- Certify consecutive rational intervals using exact integer arithmetic. -/
def cover (e : Expr) (a b : ℚ) : List ℚ → Bool
  | [] => decide (a < b) && check e a b
  | c::cs => (decide (a < c) && check e a c) && cover e c b cs

theorem cover_sound {e : Expr} {a b : ℚ} {cs : List ℚ} (pass : cover e a b cs = true) :
    ∀ x ∈ Set.Icc (a:ℝ) b, 0 ≤ e.eval x 0 := by
  induction cs generalizing a with
  | nil =>
    obtain ⟨lt,test⟩ := Bool.and_eq_true_iff.mp pass
    exact sound (of_decide_eq_true lt) test
  | cons c cs ih =>
    obtain ⟨left,right⟩ := Bool.and_eq_true_iff.mp pass
    obtain ⟨lt,test⟩ := Bool.and_eq_true_iff.mp left
    intro x hx
    by_cases h : x ≤ (c:ℝ)
    · exact sound (of_decide_eq_true lt) test x ⟨hx.1,h⟩
    · exact ih right x ⟨le_of_not_ge h,hx.2⟩

end Erdos810.PolynomialCertificate.IntegerChart
namespace Erdos810
open PolynomialCertificate PolynomialCertificate.Expr

def directionalWidth : ℚ := 59031/100000
def directionalSlope : ℚ := 43423/100000
private def capExpr : Expr :=
  (rat directionalWidth).sq + rat directionalSlope*(s-rat directionalWidth) - s.sq*rat (1/2)
private def testExpr : Expr :=
  let b := 1-s
  let h := capExpr
  (2-s)*h*(b + (1+b*horner P8 b)*h*(b-h)) - 2*s*b*(b-h)
private def lowExpr : Expr := capExpr*(1+s*(1-s))-s*(1-s)
private def highExpr : Expr := capExpr-s*(1-s)

set_option maxRecDepth 100000
set_option maxHeartbeats 0

private theorem cap_eq (x : ℝ) :
    capExpr.eval x 0 = affineCut directionalWidth directionalSlope x := by
  simp only [capExpr,affineCut,eval_sq,eval_add,eval_mul,eval_sub,eval_rat,eval_s,
    Rat.cast_div,Rat.cast_one,Rat.cast_ofNat]
  ring

private theorem cap_nonnegative {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) :
    0 ≤ affineCut directionalWidth directionalSlope x := by
  unfold affineCut directionalWidth directionalSlope
  push_cast
  nlinarith only [mul_nonneg hx.1 (sub_nonneg.mpr hx.2),hx.2]

private theorem low_sign : IntegerChart.check lowExpr 0 (1/4) = true := by decide +kernel
private theorem high_sign : IntegerChart.check highExpr (15/16) 1 = true := by decide +kernel
private theorem center_sign : IntegerChart.cover testExpr (1/4) (15/16)
    [27/64,65/128,141/256,293/512,597/1024,19/32] = true := by decide +kernel

theorem directional_full_cut : SampleUpper FullCut (fun a _ ↦ affineCut directionalWidth directionalSlope a) := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨ha,hb,hs,_,_⟩ := H.range hn
    exact cap_nonnegative ⟨ha,by linarith⟩
  · intro T _
    have c : Continuous (affineCut (directionalWidth:ℝ) directionalSlope) := by unfold affineCut; fun_prop
    exact (c.tendsto T.a).comp T.sideA
  · intro T full hm
    have eq : (fun i ↦ (T.sample i).a+(T.sample i).b) = fun _ ↦ (1:ℝ) := funext full
    have lim := T.sideA.add T.sideB
    change Tendsto (fun i ↦ (T.sample i).a+(T.sample i).b) atTop _ at lim
    rw [eq] at lim
    have sum : T.a+T.b=1 := tendsto_nhds_unique lim tendsto_const_nhds
    have b : 1-T.a=T.b := by linarith
    obtain ⟨ha,hb,_,_,mz⟩ := T.range
    have a1 : T.a ≤ 1 := by linarith
    let h := affineCut directionalWidth directionalSlope T.a
    have h0 : 0 ≤ h := cap_nonnegative ⟨ha,a1⟩
    by_cases lo : T.a ≤ 1/4
    · have cert := IntegerChart.sound (by norm_num) low_sign T.a
                      (by constructor <;> norm_num <;> assumption)
      have signed : 0 ≤ h*(1+T.a*T.b)-T.a*T.b := by
        simpa only [lowExpr,eval_add,eval_sub,eval_mul,eval_nat,eval_s,cap_eq,Nat.cast_one,b,h] using cert
      have prior := T.of_valid zero_unit continuous_const zero_valid hm
      change T.m ≤ h
      apply prior.trans
      unfold profileBound
      rw [sum]
      norm_num
      apply (div_le_iff₀ (show 0 < 1+T.a*T.b by positivity)).mpr
      linarith only [signed]
    by_cases hi : 15/16 ≤ T.a
    · have cert := IntegerChart.sound (by norm_num) high_sign T.a
                      (by constructor <;> norm_num <;> assumption)
      have signed : 0 ≤ h-T.a*T.b := by
        simpa only [highExpr,eval_sub,eval_mul,eval_nat,eval_s,cap_eq,Nat.cast_one,b,h] using cert
      change T.m ≤ h
      exact mz.trans (sub_nonneg.mp signed)
    have cert := IntegerChart.cover_sound center_sign T.a (by constructor <;> norm_num <;> linarith)
    apply T.row_cap eighth_shape_valid.1 (realPoly_continuous P8)
      (validProfile_of_shape eighth_shape_valid.2) hm (by linarith) h0
    apply sub_nonneg.mp
    simpa only [testExpr,eval_add,eval_sub,eval_mul,eval_nat,eval_s,horner_eval,cap_eq,
      Nat.cast_one,Nat.cast_ofNat,b,h] using cert

/-- The palette has at most n colors and the coloring may be improper. -/
theorem maxRainbowC4Edges_eventually_295155 (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ (295155/1000000+ε)*(n:ℝ)^2 := by
  have gap : (directionalSlope:ℝ) < 2*(directionalWidth:ℝ) := by norm_num [directionalSlope,directionalWidth]
  have width : (directionalWidth:ℝ)/2 = 295155/1000000 := by norm_num [directionalWidth]
  simpa only [width] using maxRainbowC4Edges_eventually_of_cut gap directional_full_cut ε he

end Erdos810
#assert_no_sorry Erdos810.maxRainbowC4Edges_eventually_295155
