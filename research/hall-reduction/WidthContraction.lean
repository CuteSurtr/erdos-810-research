import ProportionalRectangle

/-! # A quadratic width bound obtained by repeatedly taking the shorter child -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810

noncomputable def widthPoly (e s : ℝ) : ℝ := 1+s/2-s^2/12-e*s

theorem widthPoly_continuous (e : ℝ) : Continuous (widthPoly e) := by
  unfold widthPoly
  fun_prop

theorem widthPoly_range {e : ℝ} (he : e ∈ Set.Icc (0:ℝ) (1/2)) : WidthRange (widthPoly e) := by
  intro s hs
  obtain ⟨s0,s1⟩ := hs
  obtain ⟨e0,e1⟩ := he
  unfold widthPoly
  constructor
  · nlinarith only [mul_nonneg (sub_nonneg.mpr e1) s0, mul_nonneg (sub_nonneg.mpr s1) s0,s1]
  · nlinarith only [mul_nonneg e0 s0,sq_nonneg s,s1]

private theorem improve {a b e : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (he : 0 ≤ e) (hab : b ≤ a) :
    widthPoly (e/2) (a+b) ≤ a+(1-a/2)*widthPoly e b := by
  unfold widthPoly
  nlinarith only [mul_nonneg ha (sub_nonneg.mpr hab),mul_nonneg ha (sq_nonneg b),
    mul_nonneg he (sub_nonneg.mpr hab),mul_nonneg he (mul_nonneg ha hb)]

private theorem widthPoly_step {e : ℝ} (he : e ∈ Set.Icc (0:ℝ) (1/2))
    (v : Proportional (widthPoly e)) : Proportional (widthPoly (e/2)) := by
  apply proportional_of_limits (widthPoly_continuous _) (widthPoly_range (e := e/2)
    ⟨by linarith [he.1],by linarith [he.2]⟩)
  intro T hm
  obtain ⟨ha,hb,_,_,_⟩ := T.range
  rcases le_total T.b T.a with h|h
  · exact (mul_le_mul_of_nonneg_left (improve ha hb he.1 h) hm.le).trans
      (T.proportional_row (widthPoly_continuous _) (widthPoly_range he) v hm)
  · have row := T.transpose.proportional_row (widthPoly_continuous _) (widthPoly_range he) v hm
    have bound := (mul_le_mul_of_nonneg_left (improve hb ha he.1 h) hm.le).trans row
    simpa only [RectangleLimit.transpose,add_comm T.a T.b,mul_comm T.a T.b] using bound

private noncomputable def slack (i : ℕ) : ℝ := (1/2:ℝ)^i/2

private theorem slack_range (i : ℕ) : slack i ∈ Set.Icc (0:ℝ) (1/2) := by
  unfold slack
  exact ⟨by positivity, div_le_div_of_nonneg_right
    (pow_le_one₀ (by norm_num : 0 ≤ (1/2:ℝ)) (by norm_num)) (by norm_num)⟩

private theorem all_widths (i : ℕ) : Proportional (widthPoly (slack i)) := by
  induction i with
  | zero =>
    apply proportional_of_limits (widthPoly_continuous _) (widthPoly_range (slack_range _))
    intro T _
    obtain ⟨_,_,_,hm,hp⟩ := T.range
    have ub : widthPoly (slack 0) (T.a+T.b) ≤ 1 := by
      unfold widthPoly slack
      norm_num
      nlinarith only [sq_nonneg (T.a+T.b)]
    exact (mul_le_of_le_one_right hm ub).trans hp
  | succ i ih =>
    have eq : slack (i+1) = slack i/2 := by unfold slack; rw [pow_succ]; ring
    rw [eq]
    exact widthPoly_step (slack_range _) ih

/-- Every limiting rectangle of width s has edge density at most
ab/(1+s/2-s²/12), uniformly over its aspect ratio. -/
theorem quadratic_width_valid : Proportional (widthPoly 0) := by
  apply proportional_of_limits (widthPoly_continuous _) (widthPoly_range (e := 0) (by norm_num))
  intro T _
  have decay : Tendsto slack atTop (𝓝 0) := by
    simpa only [slack,zero_div] using
      (tendsto_pow_atTop_nhds_zero_of_lt_one (by norm_num : 0 ≤ (1/2:ℝ)) (by norm_num)).div_const 2
  have cont : Continuous (fun e ↦ T.m*widthPoly e (T.a+T.b)) := by unfold widthPoly; fun_prop
  apply le_of_tendsto_of_tendsto ((cont.tendsto (0:ℝ)).comp decay) tendsto_const_nhds
  exact Eventually.of_forall (fun i ↦ T.proportional (widthPoly_continuous _) (widthPoly_range
    (slack_range i)) (all_widths i))

end Erdos810
#assert_no_sorry Erdos810.quadratic_width_valid
