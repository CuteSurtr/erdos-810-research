import WidthContraction
import ShadowCuts

/-! # A supporting line for the missing edges in every shadow cut -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open ShadowFlags ShadowGap SimpleGraph
noncomputable section
abbrev widthSlope : ℝ := 36849/208849
abbrev widthIntercept : ℝ := 243/208849

/-- A supporting line in the product of the two side lengths. Its point of
tangency is the balanced rectangle with both sides 3/20. -/
theorem product_line {a b : ℝ} (ha : 0≤a) (hb : 0≤b) (hs : a+b≤1) :
    widthSlope*(a*b)-widthIntercept ≤ a*b-a*b/widthPoly 0 (a+b) := by
  let s := a+b
  let u := widthPoly 0 s
  have s0 : 0≤s := add_nonneg ha hb
  have s1 : s≤1 := hs
  have pos : 0<u := (widthPoly_range (e := 0) (by norm_num) _ ⟨s0,s1⟩).1
  have p0 := mul_nonneg ha hb
  have cap : a*b≤s^2/4 := by dsimp only [s]; nlinarith only [sq_nonneg (a-b)]
  have factor : 0≤8100+58050*s-10750*s^2 := by
    nlinarith only [s0,mul_nonneg s0 (sub_nonneg.mpr s1)]
  have certified : 0≤widthIntercept*u+((1-widthSlope)*u-1)*s^2/4 := by
    have square := mul_nonneg (sq_nonneg (s-3/10)) factor
    dsimp [u,widthPoly,widthSlope,widthIntercept]
    nlinarith only [square]
  have nonneg : 0≤widthIntercept*u+((1-widthSlope)*u-1)*(a*b) := by
    rcases le_total 0 ((1-widthSlope)*u-1) with h|h
    · exact add_nonneg (mul_nonneg (by norm_num [widthIntercept]) pos.le) (mul_nonneg h p0)
    · calc
        0 ≤ widthIntercept*u+((1-widthSlope)*u-1)*s^2/4 := certified
        _ = widthIntercept*u+((1-widthSlope)*u-1)*(s^2/4) := by ring
        _ ≤ _ := add_le_add_left (mul_le_mul_of_nonpos_left cap h) _
  change widthSlope*(a*b)-widthIntercept ≤ a*b-a*b/u
  apply (le_sub_iff_add_le).mpr
  rw [add_comm,div_add',div_le_iff₀ pos]
  · nlinarith only [nonneg]
  · exact pos.ne'

variable {n : ℕ} {H : Finset (Finset (Fin n))}
theorem width_cut_lower (hn : 0<n) {δ : ℝ}
    (bound : ∀ J : RectangleSample n, True → J.mass≤J.a*J.b/widthPoly 0 (J.a+J.b)+δ)
    (C : (twoShadow H).EdgeLabeling (Fin n)) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (x y : Fin n) :
    widthSlope*(common (W H) x y*neither (W H) x y)-(widthIntercept+δ)≤miss (W H) x y := by
  classical
  let A := commonSet H x y
  let B := neitherSet H x y
  have dis : Disjoint A B := by
    apply Finset.disjoint_left.mpr
    intro z za zb
    exact (Finset.mem_filter.mp zb).2.1 (Finset.mem_filter.mp za).2.1
  have fits : A.card+B.card≤n := by
    rw [← Finset.card_union_of_disjoint dis]
    simpa only [Fintype.card_fin] using Finset.card_le_univ (A∪B)
  let J : RectangleSample n := ⟨twoShadow H,C,hp,hr,A,B,fits⟩
  obtain ⟨aa,bb,ss,_,_⟩ := J.range hn
  have cap := bound J trivial
  have line := product_line aa bb ss
  have missing : miss (W H) x y=J.a*J.b-J.mass := by
    rw [missing_size]
    dsimp [J,A,B,RectangleSample.a,RectangleSample.b,RectangleSample.mass]
    ring
  rw [common_size,neither_size,missing]
  change widthSlope*(J.a*J.b)-(widthIntercept+δ)≤J.a*J.b-J.mass
  calc
    _ = (widthSlope*(J.a*J.b)-widthIntercept)-δ := by ring
    _ ≤ (J.a*J.b-J.a*J.b/widthPoly 0 (J.a+J.b))-δ := sub_le_sub_right line _
    _ = J.a*J.b-(J.a*J.b/widthPoly 0 (J.a+J.b)+δ) := by ring
    _ ≤ _ := sub_le_sub_left cap _

end
end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.product_line Erdos810.ShadowRoot.width_cut_lower
