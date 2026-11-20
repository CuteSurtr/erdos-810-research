import MatchingRectangle

/-! # Endpoint averaging for normalized bipartite rectangles -/

set_option autoImplicit false
open SimpleGraph Filter
namespace Erdos810

/-- Edge density allowed in a rectangle with two normalized side sizes. -/
noncomputable def profileBound (P : ℝ → ℝ) (a b : ℝ) : ℝ :=
  a*b/(1+(1/(a+b)+P (a+b))*(a*b))

/-- Normalized cut of a part of total size v at position k. -/
noncomputable def matchingCut (P : ℝ → ℝ) (v k : ℝ) : ℝ :=
  let z := k*(v-k)
  z/(1+(1/v+P v)*z)

theorem profileBound_cut (P : ℝ → ℝ) (v k : ℝ) : profileBound P k (v-k) = matchingCut P v k := by
  simp [profileBound,matchingCut]
theorem profileBound_comm (P : ℝ → ℝ) (a b : ℝ) : profileBound P a b = profileBound P b a := by
  simp [profileBound,mul_comm,add_comm]

def UnitProfile (P : ℝ → ℝ) : Prop := ∀ x ∈ Set.Icc (0:ℝ) 1, P x ∈ Set.Icc (0:ℝ) 1

theorem profileBound_range {P : ℝ → ℝ} (hP : UnitProfile P) {a b : ℝ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : a+b ≤ 1) :
    0 ≤ profileBound P a b ∧ profileBound P a b ≤ a*b := by
  have h := (hP (a+b) ⟨add_nonneg ha hb,hs⟩).1
  have dz : 0 ≤ (1/(a+b)+P (a+b))*(a*b) :=
    mul_nonneg (add_nonneg (by positivity) h) (mul_nonneg ha hb)
  unfold profileBound
  constructor
  · exact div_nonneg (mul_nonneg ha hb) (by linarith)
  · exact div_le_self (mul_nonneg ha hb) (by linarith)

private noncomputable def cutSlope (P : ℝ → ℝ) (v m : ℝ) : ℝ :=
  1/(1+(1/v+P v)*(m*(v-m)))^2

private theorem cut_tangent {P : ℝ → ℝ} (hP : UnitProfile P) {v m k : ℝ}
    (hv : v ∈ Set.Icc (0:ℝ) 1) (hm : m ∈ Set.Icc (0:ℝ) v) (hk : k ∈ Set.Icc (0:ℝ) v) :
    matchingCut P v k ≤ matchingCut P v m + cutSlope P v m*((v-2*m)*(k-m)-(k-m)^2) := by
  let d := 1/v+P v
  let z := k*(v-k)
  let t := m*(v-m)
  have hd : 0 ≤ d := add_nonneg (one_div_nonneg.mpr hv.1) (hP _ hv).1
  have hz : 0 ≤ z := mul_nonneg hk.1 (sub_nonneg.mpr hk.2)
  have ht : 0 ≤ t := mul_nonneg hm.1 (sub_nonneg.mpr hm.2)
  have A : 0 < 1+d*z := by linarith only [mul_nonneg hd hz]
  have B : 0 < 1+d*t := by linarith only [mul_nonneg hd ht]
  have id : t/(1+d*t)+(z-t)/(1+d*t)^2-z/(1+d*z) =
      d*(z-t)^2/((1+d*z)*(1+d*t)^2) := by field_simp [ne_of_gt A, ne_of_gt B]; ring
  have nn := div_nonneg (mul_nonneg hd (sq_nonneg (z-t))) (mul_nonneg A.le (sq_nonneg (1+d*t)))
  have diff : z-t=(v-2*m)*(k-m)-(k-m)^2 := by dsimp only [t,z]; ring
  change z/(1+d*z) ≤ t/(1+d*t)+(1/(1+d*t)^2)*_
  rw [← diff, one_div_mul_eq_div]
  linarith

private theorem slope_lower {P : ℝ → ℝ} (hP : UnitProfile P) {v m : ℝ}
    (hv : v ∈ Set.Icc (0:ℝ) 1) (hm : m ∈ Set.Icc (0:ℝ) v) :
    1/(1+v/2)^2 ≤ cutSlope P v m := by
  by_cases hzero : v = 0
  · have mz : m=0 := by rcases hm with ⟨u,v⟩; linarith
    simp [hzero,mz,cutSlope]
  have hpos : 0 < v := lt_of_le_of_ne hv.1 (Ne.symm hzero)
  let z := m*(v-m)
  have zpos : 0 ≤ z := mul_nonneg hm.1 (sub_nonneg.mpr hm.2)
  have zle : z ≤ v^2/4 := by dsimp only [z]; nlinarith only [sq_nonneg (m-v/2)]
  have pz := mul_le_mul_of_nonneg_right (hP _ hv).2 zpos
  have zdiv : (1/v)*z ≤ v/4 := by
    rw [one_div_mul_eq_div]
    apply (div_le_iff₀ hpos).mpr
    nlinarith only [zle]
  have dz : 0 ≤ (1/v+P v)*z := mul_nonneg (add_nonneg (by positivity) (hP _ hv).1) zpos
  have upper : 1+(1/v+P v)*z ≤ 1+v/2 := by
    nlinarith only [zdiv,pz,zle,mul_nonneg hv.1 (sub_nonneg.mpr hv.2)]
  apply one_div_le_one_div_of_le (sq_pos_of_pos (show 0 < 1+(1/v+P v)*z by linarith))
  exact pow_le_pow_left₀ (by linarith) upper 2

/-- An affine upper tangent for the contribution of a single side. -/
theorem rowCut_tangent {P : ℝ → ℝ} (hP : UnitProfile P) {v m : ℝ}
    (hv : v ∈ Set.Icc (0:ℝ) (4/5)) (hm : m ∈ Set.Icc (0:ℝ) v) :
    ∃ j : ℝ, ∀ k ∈ Set.Icc (0:ℝ) v,
      k^2 + 2 * matchingCut P v k ≤
        m^2 + 2 * matchingCut P v m + j*(k-m) := by
  have v1 : v ∈ Set.Icc (0:ℝ) 1 := ⟨hv.1,by linarith [hv.2]⟩
  have small : (1+v/2)^2 ≤ (7/5:ℝ)^2 :=
    pow_le_pow_left₀ (by linarith [hv.1]) (by linarith [hv.2]) 2
  have lower := slope_lower hP v1 hm
  have half : 1/2 ≤ cutSlope P v m := by
    apply le_trans _ lower
    apply (le_div_iff₀ (sq_pos_of_pos (by linarith [hv.1]))).mpr
    nlinarith only [small]
  refine ⟨2*m + 2*cutSlope P v m*(v-2*m), ?_⟩
  intro k hk
  have tan := cut_tangent hP v1 hm hk
  have drop := mul_nonneg (show 0 ≤ 2*cutSlope P v m-1 by linarith) (sq_nonneg (k-m))
  nlinarith only [tan,drop]

private theorem joint_slope {P : ℝ → ℝ} (hP : UnitProfile P) {a b m : ℝ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : a+b ≤ 1) (hma : m ∈ Set.Icc (0:ℝ) a)
    (hmb : m ≤ b) : 1 ≤ cutSlope P a m+cutSlope P b m := by
  have grow {v t : ℝ} (hv : 0 ≤ v) (h : v ≤ t) : 1/(1+t/2)^2 ≤ 1/(1+v/2)^2 := by
    apply one_div_le_one_div_of_le (by positivity)
    exact pow_le_pow_left₀ (by positivity) (by linarith) 2
  have ha1 : a ≤ 1 := by linarith
  have hb1 : b ≤ 1 := by linarith
  have A := slope_lower hP ⟨ha,ha1⟩ hma
  have B := slope_lower hP ⟨hb,hb1⟩ ⟨hma.1,hmb⟩
  simp only [one_div] at A B
  rcases le_total a b with h|h
  · have a' := grow ha (show a ≤ 1/2 by linarith)
    have b' := grow hb hb1
    norm_num at a' b'
    linarith
  · have a' := grow ha ha1
    have b' := grow hb (show b ≤ 1/2 by linarith)
    norm_num at a' b'
    linarith

noncomputable def matchingIntegrand (P : ℝ → ℝ) (a b k : ℝ) : ℝ :=
  k^2+matchingCut P a k+matchingCut P b k

/-- A single affine upper bound works for every color matching size. -/
theorem matchingIntegrand_tangent {P : ℝ → ℝ} (hP : UnitProfile P) {a b m : ℝ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : a+b ≤ 1) (hma : m ∈ Set.Icc (0:ℝ) a) (hmb : m ≤ b) :
    ∃ j : ℝ, ∀ k ∈ Set.Icc (0:ℝ) a, k ≤ b →
      matchingIntegrand P a b k ≤ matchingIntegrand P a b m+j*(k-m) := by
  refine ⟨2*m+cutSlope P a m*(a-2*m)+cutSlope P b m*(b-2*m), ?_⟩
  intro k hk hkb
  have A := cut_tangent hP ⟨ha,by linarith⟩ hma hk
  have B := cut_tangent hP ⟨hb,by linarith⟩ ⟨hma.1,hmb⟩ ⟨hk.1,hkb⟩
  have drop := mul_nonneg (sub_nonneg.mpr (joint_slope hP ha hb hs hma hmb)) (sq_nonneg (k-m))
  unfold matchingIntegrand
  nlinarith only [A,B,drop]

/-- The sum of the two slope factors leaves a uniform quadratic remainder. -/
theorem matchingIntegrand_strong_tangent {P : ℝ → ℝ} (hP : UnitProfile P) {a b m : ℝ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : a+b ≤ 1) (hma : m ∈ Set.Icc (0:ℝ) a) (hmb : m ≤ b) :
    ∃ j : ℝ, ∀ k ∈ Set.Icc (0:ℝ) a, k ≤ b →
      matchingIntegrand P a b k ≤ matchingIntegrand P a b m+j*(k-m)-(7/25)*(k-m)^2 := by
  have factor {v : ℝ} (hv : 0 ≤ v) (v1 : v ≤ 1) (mv : m ≤ v) :
      (112-64*v)/125 ≤ cutSlope P v m := by
    apply le_trans _ (slope_lower hP ⟨hv,v1⟩ ⟨hma.1,mv⟩)
    apply (le_div_iff₀ (sq_pos_of_pos (show 0 < 1+v/2 by linarith))).mpr
    nlinarith only [mul_nonneg (sq_nonneg (v-1/2)) (show 0 ≤ 16*v+52 by linarith)]
  have strong : 32/25 ≤ cutSlope P a m+cutSlope P b m := by
    linarith [factor ha (by linarith) hma.2,factor hb (by linarith) hmb]
  refine ⟨2*m+cutSlope P a m*(a-2*m)+cutSlope P b m*(b-2*m), ?_⟩
  intro k hk hkb
  have A := cut_tangent hP ⟨ha,by linarith⟩ hma hk
  have B := cut_tangent hP ⟨hb,by linarith⟩ ⟨hma.1,hmb⟩ ⟨hk.1,hkb⟩
  have drop := mul_nonneg (sub_nonneg.mpr strong) (sq_nonneg (k-m))
  unfold matchingIntegrand
  nlinarith only [A,B,drop]

end Erdos810
#assert_no_sorry Erdos810.matchingIntegrand_tangent
