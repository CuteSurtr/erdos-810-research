import IteratedProfiles
import IteratedTerminal

/-! # An iterated upper bound for the unrestricted problem -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810
open PolynomialCertificate

private theorem iteratedCap_eq (x : ℝ) : iteratedCap.eval x 0 = affineCut iteratedWidth iteratedSlope x := by
  simp only [iteratedCap,affineCut,Expr.eval_sq,Expr.eval_add,Expr.eval_mul,Expr.eval_sub,Expr.eval_rat,
    Expr.eval_s,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat]
  ring

private theorem iteratedCap_nonneg {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) :
    0 ≤ affineCut iteratedWidth iteratedSlope x := by
  unfold affineCut iteratedWidth iteratedSlope
  push_cast
  nlinarith only [mul_nonneg hx.1 (sub_nonneg.mpr hx.2),hx.2]

private theorem iteratedCap_interior {a b : ℝ} (hs : a+b=1)
    (hz : affineCut iteratedWidth iteratedSlope a < a*b) : a ∈ Set.Icc (1/16:ℝ) (15/16) := by
  rw [show b=1-a by linarith] at hz
  unfold affineCut iteratedWidth iteratedSlope at hz
  push_cast at hz
  constructor
  · by_contra! outside
    nlinarith only [sq_nonneg a,outside,hz]
  · by_contra! outside
    nlinarith only [sq_nonneg (a-15/16),outside,hz]

theorem iterated_full_cut : SampleUpper FullCut (fun a _ ↦ affineCut iteratedWidth iteratedSlope a) :=
  shape_cut_of_certificate P8 eighth_shape_valid.1 eighth_shape_valid.2 iteratedCap iteratedWidth iteratedSlope
    iteratedCap_eq iteratedCap_nonneg iteratedCap_interior (fun _ hx ↦ iteratedTest_nonnegative hx)

/-- The upper bound applies to the original unrestricted extremal function. -/
theorem maxRainbowC4Edges_eventually_297331 (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ (297331/1000000+ε)*(n:ℝ)^2 := by
  have gap : (iteratedSlope:ℝ) < 2*(iteratedWidth:ℝ) := by norm_num [iteratedSlope,iteratedWidth]
  have coeff : (iteratedWidth:ℝ)/2=297331/1000000 := by norm_num [iteratedWidth]
  simpa only [coeff] using maxRainbowC4Edges_eventually_of_cut gap iterated_full_cut ε he

end Erdos810
#assert_no_sorry Erdos810.maxRainbowC4Edges_eventually_297331
