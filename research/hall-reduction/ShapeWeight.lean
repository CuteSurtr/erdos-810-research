import RectangleProfile

/-! # Scale dependence of the imbalance correction -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810

noncomputable def shapeWeight (s : ℝ) : ℝ := (4-3*s)/(5*s)

theorem shapeWeight_nonneg {s : ℝ} (hs : s ∈ Set.Icc (0:ℝ) 1) : 0 ≤ shapeWeight s :=
  div_nonneg (by linarith [hs.2]) (mul_nonneg (by norm_num) hs.1)

theorem shapeWeight_scaled (s t : ℝ) :
    shapeWeight s*(s*t)^2=(1/5)*(4-3*s)*s*t^2 := by
  by_cases h : s=0
  · simp [h,shapeWeight]
  · unfold shapeWeight
    field_simp [h]

theorem shapeWeight_sq (s : ℝ) : shapeWeight s*s^2 ≤ 4/15 := by
  have eq := shapeWeight_scaled s 1
  simp only [mul_one,one_pow] at eq
  nlinarith only [eq,sq_nonneg (3*s-2)]

theorem shapeWeight_tendsto {ι : Type*} {l : Filter ι} {S : ι → ℝ} {s : ℝ}
    (h : Tendsto S l (𝓝 s)) (hs : 0 < s) : Tendsto (fun i ↦ shapeWeight (S i)) l (𝓝 (shapeWeight s)) :=
  (tendsto_const_nhds.sub (tendsto_const_nhds.mul h)).div (tendsto_const_nhds.mul h) (by positivity)

end Erdos810
