import ProportionalRectangle

/-! # Exact finite-depth width profiles for recursive rectangle cuts -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810.DyadicWidth

/-- The d factors are 1-s/4, 1-s/8, ..., 1-s/2^(d+1). -/
noncomputable def deficit : ℕ → ℝ → ℝ
  | 0, _ => 1
  | d+1, s => (1-s/4)*deficit d (s/2)

noncomputable def profile (d : ℕ) (s : ℝ) := 2-deficit d s

private theorem half {s : ℝ} (h : s∈Set.Icc (0:ℝ) 1) : s/2∈Set.Icc (0:ℝ) 1 :=
  ⟨by linarith [h.1],by linarith [h.2]⟩

theorem deficit_range (d : ℕ) {s : ℝ} (h : s∈Set.Icc (0:ℝ) 1) :
    0<deficit d s ∧ deficit d s≤1 := by
  induction d generalizing s with
  | zero => norm_num [deficit]
  | succ d ih =>
    obtain ⟨pos,hi⟩ := ih (half h)
    change 0<(1-s/4)*deficit d (s/2) ∧ (1-s/4)*deficit d (s/2)≤1
    have lo : 0<1-s/4 := by linarith [h.2]
    exact ⟨mul_pos lo pos,(mul_le_of_le_one_right lo.le hi).trans (by linarith [h.1])⟩

private theorem continuous_deficit (d : ℕ) : Continuous (deficit d) := by
  induction d with
  | zero => exact continuous_const
  | succ d ih =>
    change Continuous (fun s : ℝ ↦ (1-s/4)*deficit d (s/2))
    fun_prop

theorem continuous_profile (d : ℕ) : Continuous (profile d) :=
  continuous_const.sub (continuous_deficit d)

theorem profile_range (d : ℕ) : WidthRange (profile d) := by
  intro s hs
  obtain ⟨h0,h1⟩ := deficit_range d hs
  unfold profile
  exact ⟨by linarith,by linarith⟩

/-- The ratio deficit_d(s)/(2-s) increases with s. -/
theorem ratio (d : ℕ) {x y : ℝ} (hx : 0≤x) (hxy : x≤y) (hy : y≤1) :
    (2-y)*deficit d x ≤ (2-x)*deficit d y := by
  induction d generalizing x y with
  | zero => simp only [deficit,mul_one]; linarith only [hxy]
  | succ d ih =>
    have prev := ih (x := x/2) (y := y/2) (by linarith) (by linarith) (by linarith)
    have xl : 0<4-x := by linarith
    have yl : 0<4-y := by linarith
    have dx := (deficit_range d (s := x/2) (by constructor <;> linarith)).1
    have step : (2-y)*(4-x)^2 ≤ (2-x)*(4-y)^2 := by
      nlinarith only [mul_nonneg (sub_nonneg.mpr hxy) (mul_nonneg xl.le hx),
        mul_nonneg (sq_nonneg (y-x)) (show 0≤2-x by linarith)]
    have raised := mul_le_mul_of_nonneg_left prev (mul_nonneg (show 0≤2-x by linarith) yl.le)
    have pay := mul_le_mul_of_nonneg_right step dx.le
    simp only [deficit]
    apply (mul_le_mul_iff_right₀ xl).mp
    nlinarith only [raised,pay]

private theorem improve (d : ℕ) {a b : ℝ} (hb : 0≤b) (ord : b≤a) (fits : a+b≤1) :
    profile (d+1) (a+b) ≤ a+(1-a/2)*profile d b := by
  let y := (a+b)/2
  have by' : b≤y := by dsimp [y]; linarith
  have y1 : y≤1 := by dsimp [y]; linarith
  have b1 : b≤1 := by linarith
  have db := (deficit_range d (s := b) ⟨hb,b1⟩).1
  have prev := ratio d hb by' y1
  have p := mul_le_mul_of_nonneg_left prev (show 0≤2-y by linarith)
  have sq : (2-a)*(2-b)≤(2-y)^2 := by dsimp [y]; nlinarith only [sq_nonneg (a-b)]
  have q := mul_le_mul_of_nonneg_right sq db.le
  unfold profile
  simp only [deficit]
  change 2-(1-(a+b)/4)*deficit d y≤_
  apply (mul_le_mul_iff_right₀ (show 0<2-b by linarith)).mp
  dsimp [y] at p q ⊢
  nlinarith only [p,q]

theorem valid (d : ℕ) : Proportional (profile d) := by
  induction d with
  | zero =>
    apply proportional_of_limits (continuous_profile _) (profile_range _)
    intro T _
    norm_num [profile,deficit]
    exact T.range.2.2.2.2
  | succ d ih =>
    apply proportional_of_limits (continuous_profile _) (profile_range _)
    intro T hm
    obtain ⟨a,b,fit,_,_⟩ := T.range
    rcases le_total T.b T.a with h|h
    · exact (mul_le_mul_of_nonneg_left (improve d b h fit) hm.le).trans
        (T.proportional_row (continuous_profile _) (profile_range _) ih hm)
    · have s : T.b+T.a≤1 := by linarith
      have row := T.transpose.proportional_row (continuous_profile _) (profile_range _) ih hm
      have bound := (mul_le_mul_of_nonneg_left (improve d a h s) hm.le).trans row
      simpa only [RectangleLimit.transpose,add_comm T.a T.b,mul_comm T.a T.b] using bound

end Erdos810.DyadicWidth
#assert_no_sorry Erdos810.DyadicWidth.valid
