import ShapeWeight

/-! # Averaging the imbalance correction across color classes -/

set_option autoImplicit false
namespace Erdos810

noncomputable def shapeCubic (v k : ℝ) : ℝ := k*(v-k)*(v-2*k)
noncomputable def shapeIntegrand (P : ℝ → ℝ) (a b k : ℝ) : ℝ :=
  matchingIntegrand P a b k-(shapeWeight a*(shapeCubic a k)^2+shapeWeight b*(shapeCubic b k)^2)

private theorem abs_shapeCubic {v m : ℝ} (hm : m ∈ Set.Icc (0:ℝ) v) :
    |shapeCubic v m| ≤ v^3/8 := by
  let d := |v-2*m|
  have d0 : 0 ≤ d := abs_nonneg _
  have v0 := hm.1.trans hm.2
  have dv : d ≤ v := abs_le.mpr ⟨by linarith [hm.2],by linarith [hm.1]⟩
  have dsq : d^2=(v-2*m)^2 := sq_abs _
  have prod : d*(v-d) ≤ v^2/4 := by nlinarith only [sq_nonneg (v/2-d)]
  have plus : v+d ≤ 2*v := by linarith
  have upper := mul_le_mul prod plus (by linarith : 0 ≤ v+d) (by positivity : 0 ≤ v^2/4)
  have id : 4*(m*(v-m)*d)=d*(v-d)*(v+d) := by
    nlinarith only [congrArg (fun w : ℝ ↦ d*w) dsq]
  rw [shapeCubic,abs_mul,abs_of_nonneg (mul_nonneg hm.1 (sub_nonneg.mpr hm.2))]
  change m*(v-m)*d ≤ _
  linarith only [id,show d*(v-d)*(v+d) ≤ v^3/2 by nlinarith only [upper]]

private theorem square_tangent {v m : ℝ} (hm : m ∈ Set.Icc (0:ℝ) v) :
    ∃ j : ℝ, ∀ k ∈ Set.Icc (0:ℝ) v,
      (shapeCubic v m)^2+j*(k-m)-(3/4)*v^4*(k-m)^2 ≤ (shapeCubic v k)^2 := by
  let A := shapeCubic v m
  let B := v^2-6*v*m+6*m^2
  refine ⟨2*A*B,?_⟩
  intro k hk
  let R := 2*k+4*m-3*v
  have v0 := hm.1.trans hm.2
  have AR : |A| ≤ v^3/8 := abs_shapeCubic hm
  have RR : |R| ≤ 3*v := abs_le.mpr ⟨by dsimp [R]; linarith [hk.1,hm.1],by dsimp [R]; linarith [hk.2,hm.2]⟩
  have prod : |A*R| ≤ (3/8)*v^4 := by
    rw [abs_mul]
    have mult := mul_le_mul AR RR (abs_nonneg _) (by positivity : 0 ≤ v^3/8)
    nlinarith only [mult]
  have lower : -(3/4)*v^4 ≤ 2*A*R := by linarith [(abs_le.mp prod).1]
  have id : shapeCubic v k-A-B*(k-m)=(k-m)^2*R := by dsimp [shapeCubic,A,B,R]; ring
  have lower' := mul_le_mul_of_nonneg_right lower (sq_nonneg (k-m))
  have rem := sq_nonneg (shapeCubic v k-A)
  change A^2+2*A*B*(k-m)-(3/4)*v^4*(k-m)^2 ≤ _
  nlinarith only [rem,lower',congrArg (fun w : ℝ ↦ 2*A*w) id]

theorem shapeIntegrand_tangent {P : ℝ → ℝ} (hP : UnitProfile P) {a b m : ℝ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : a+b ≤ 1) (hma : m ∈ Set.Icc (0:ℝ) a) (hmb : m ≤ b) :
    ∃ j : ℝ, ∀ k ∈ Set.Icc (0:ℝ) a, k ≤ b →
      shapeIntegrand P a b k ≤ shapeIntegrand P a b m+j*(k-m) := by
  obtain ⟨j,tan⟩ := matchingIntegrand_strong_tangent hP ha hb hs hma hmb
  obtain ⟨A,ta⟩ := square_tangent hma
  obtain ⟨B,tb⟩ := square_tangent ⟨hma.1,hmb⟩
  have a1 : a ≤ 1 := by linarith
  have b1 : b ≤ 1 := by linarith
  have a0 := shapeWeight_nonneg ⟨ha,a1⟩
  have b0 := shapeWeight_nonneg ⟨hb,b1⟩
  have coeff {v : ℝ} (v0 : 0 ≤ v) (v1 : v ≤ 1) : shapeWeight v*v^4 ≤ (4/15)*v := by
    nlinarith only [mul_le_mul_of_nonneg_right (shapeWeight_sq v) (sq_nonneg v),
      mul_le_mul_of_nonneg_left v1 v0]
  have curve : shapeWeight a*a^4+shapeWeight b*b^4 ≤ 4/15 := by
    linarith [coeff ha a1,coeff hb b1]
  refine ⟨j-(shapeWeight a*A+shapeWeight b*B),?_⟩
  intro k hk kb
  unfold shapeIntegrand
  nlinarith only [tan k hk kb,mul_le_mul_of_nonneg_left (ta k hk) a0,
    mul_le_mul_of_nonneg_left (tb k ⟨hk.1,kb⟩) b0,
    mul_le_mul_of_nonneg_right curve (sq_nonneg (k-m)),sq_nonneg (k-m)]

end Erdos810
#assert_no_sorry Erdos810.shapeIntegrand_tangent
