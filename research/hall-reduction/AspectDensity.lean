import AspectRectangle
import DirectionalDensity

/-! # Graph density after propagating the aspect ratio one level deeper -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810.AspectDensity
open PolynomialCertificate PolynomialCertificate.Expr

def width : ℚ := 583042/1000000
def slope : ℚ := 457309/1000000
private def cap : Expr := (rat width).sq+rat slope*(s-rat width)-s.sq*rat (1/2)
private def test : Expr :=
  let b := 1-s
  let i := 1+b*rat (1/2)-b.sq*rat (2/75)-b.sq*b*rat (1/750)
  let d := b*rat (7/60)-b.sq*rat (1/75)
  cap*(s+(1-s*rat (1/2))*(i-d*cap))-s*b

set_option maxRecDepth 10000
private theorem sign : IntegerChart.cover test 0 1 [1/2,583042/1000000,3/4] = true := by decide +kernel

private theorem real_sign {x : ℝ} (hx : x∈Set.Icc (0:ℝ) 1) :
    x*(1-x) ≤ affineCut width slope x*(x+(1-x/2)*Aspect.den (1-x) (affineCut width slope x)) := by
  have h := IntegerChart.cover_sound sign x (by simpa using hx)
  unfold test cap at h
  simp only [eval_sq,eval_add,eval_mul,eval_sub,eval_rat,eval_nat,eval_s,Nat.cast_one,
    Rat.cast_div,Rat.cast_one,Rat.cast_ofNat] at h
  unfold affineCut Aspect.den Aspect.intercept Aspect.decay
  linarith only [h]

private theorem cap_range {x : ℝ} (h : x∈Set.Icc (0:ℝ) 1) : affineCut width slope x∈Set.Icc (0:ℝ) 1 := by
  unfold affineCut width slope
  push_cast
  constructor
  · nlinarith only [mul_nonneg h.1 (sub_nonneg.mpr h.2),h.2]
  · nlinarith only [sq_nonneg x,h.2]

theorem cut : SampleUpper FullCut (fun a _ ↦ affineCut width slope a) := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨a,b,s,_,_⟩ := H.range hn
    exact (cap_range ⟨a,by linarith⟩).1
  · intro T _
    have c : Continuous (affineCut (width:ℝ) slope) := by unfold affineCut; fun_prop
    exact (c.tendsto T.a).comp T.sideA
  · intro T full hm
    have eq : (fun i ↦ (T.sample i).a+(T.sample i).b) = fun _ ↦ (1:ℝ) := funext full
    have lim := T.sideA.add T.sideB
    change Tendsto (fun i ↦ (T.sample i).a+(T.sample i).b) atTop _ at lim
    rw [eq] at lim
    have sum : T.a+T.b=1 := tendsto_nhds_unique lim tendsto_const_nhds
    obtain ⟨a,b,_,_,mab⟩ := T.range
    have a1 : T.a≤1 := by linarith
    have b1 : T.b≤1 := by linarith
    let h := affineCut width slope T.a
    have h1 : h≤1 := (cap_range ⟨a,a1⟩).2
    have cert := real_sign (x := T.a) ⟨a,a1⟩
    rw [show 1-T.a=T.b by linarith] at cert
    have row := Aspect.row T hm
    have m1 := (mab.trans (mul_le_of_le_one_left b a1)).trans b1
    obtain ⟨ia,_,_,dd⟩ := Aspect.ranges (s := T.b) ⟨b,b1⟩
    have h0 : 0≤h := (cap_range ⟨a,a1⟩).1
    have bound := mul_le_mul dd (show T.m+h≤2 by linarith) (add_nonneg hm.le h0) (by norm_num)
    have pos : 0<T.a+(1-T.a/2)*(Aspect.intercept T.b-Aspect.decay T.b*(T.m+h)) :=
      add_pos_of_nonneg_of_pos a (mul_pos (by linarith) (by linarith))
    change T.m≤h
    by_contra! big
    have sep := mul_pos (sub_pos.mpr big) pos
    change T.a*T.b≤h*(T.a+(1-T.a/2)*Aspect.den T.b h) at cert
    unfold Aspect.den at row cert
    nlinarith only [sep,row,cert]

end Erdos810.AspectDensity
namespace Erdos810

theorem maxRainbowC4Edges_eventually_291521 (ε : ℝ) (he : 0<ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ)≤(291521/1000000+ε)*(n:ℝ)^2 := by
  have gap : (AspectDensity.slope:ℝ)<2*(AspectDensity.width:ℝ) := by
    norm_num [AspectDensity.slope,AspectDensity.width]
  have w : (AspectDensity.width:ℝ)/2=291521/1000000 := by norm_num [AspectDensity.width]
  simpa only [w] using maxRainbowC4Edges_eventually_of_cut gap AspectDensity.cut ε he

end Erdos810
#assert_no_sorry Erdos810.maxRainbowC4Edges_eventually_291521
