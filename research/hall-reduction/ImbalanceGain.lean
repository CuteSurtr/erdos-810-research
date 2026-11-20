import ShapeEndpoint

/-! # A positive, scale-dependent gain retained by a second rectangle iteration -/

set_option autoImplicit false
namespace Erdos810

noncomputable def profileGain (s : ℝ) : ℝ :=
  s^2*(4-3*s)^3*(4-s)^2*(9-4*s)/62500

theorem profileGain_nonneg {s : ℝ} (hs : s ∈ Set.Icc (0:ℝ) 1) : 0 ≤ profileGain s := by
  have b : 0 ≤ 4-3*s := by linarith [hs.2]
  have f : 0 ≤ 9-4*s := by linarith [hs.2]
  unfold profileGain
  positivity

private theorem harmonic {a b X Y : ℝ} (ha : 0 < a) (hb : 0 < b) (hs : a+b ≤ 1) :
    shapeWeight (a+b)*(X+Y)^2 ≤ shapeWeight a*X^2+shapeWeight b*Y^2 := by
  let s := a+b
  have sp : 0 < s := add_pos ha hb
  have ks := shapeWeight_nonneg ⟨sp.le,hs⟩
  have simplify {v : ℝ} (hv : 0 < v) : shapeWeight v*v=(4-3*v)/5 := by
    unfold shapeWeight; field_simp [hv.ne']
  have da : shapeWeight s*s ≤ shapeWeight a*a := by rw [simplify sp,simplify ha]; dsimp only [s]; linarith
  have db : shapeWeight s*s ≤ shapeWeight b*b := by rw [simplify sp,simplify hb]; dsimp only [s]; linarith
  apply (mul_le_mul_iff_of_pos_right (mul_pos ha hb)).mp
  change shapeWeight s*(X+Y)^2*(a*b) ≤ _
  have aa := mul_le_mul_of_nonneg_right da (mul_nonneg hb.le (sq_nonneg X))
  have bb := mul_le_mul_of_nonneg_right db (mul_nonneg ha.le (sq_nonneg Y))
  have sq := mul_nonneg ks (sq_nonneg (b*X-a*Y))
  nlinarith only [aa,bb,sq,congrArg (fun w : ℝ ↦ shapeWeight s*w*(b*X^2+a*Y^2)) (show s=a+b from rfl)]

private theorem scale_gain {s : ℝ} (sp : 0 < s) (small : s ≤ 1) :
    s*profileGain s ≤ shapeWeight s/4*
      ((s*(4-s)/(4+s))*(s*(4-3*s)/(4+s)))^2 := by
  have ds : 0 < 4+s := by linarith
  have b : 0 ≤ 4-3*s := by linarith
  have poly : 0 ≤ 821+362*s+63*s^2+4*s^3 := by positivity
  have upper : (9-4*s)*(4+s)^4 ≤ 3125 := by
    nlinarith only [mul_nonneg (sq_nonneg (1-s)) poly]
  have nonneg : 0 ≤ (4-3*s)^3*(4-s)^2 := by positivity
  have major := mul_le_mul_of_nonneg_left upper nonneg
  unfold profileGain shapeWeight
  field_simp [sp.ne',ds.ne']
  nlinarith only [major]

/-- The side imbalance supplies a positive gain even in the next balanced rectangle. -/
theorem RectangleLimit.gain_le_shapeExtra (T : RectangleLimit) (hm : 0 < T.m) :
    (T.a+T.b)*profileGain (T.a+T.b) ≤ shapeExtra T.a T.b T.m := by
  let a := T.a
  let b := T.b
  let s := a+b
  let m := T.m
  obtain ⟨ha,hb,small,_,_⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have sp : 0 < s := add_pos pa pb
  have ks : 0 ≤ shapeWeight s := shapeWeight_nonneg ⟨sp.le,small⟩
  have base := T.of_valid zero_unit continuous_const zero_valid hm
  rw [profileBound_eq_cap zero_unit ha hb small sp] at base
  change m ≤ a*b*s/(s+a*b*(1+s*0)) at base
  simp only [mul_zero,add_zero,mul_one] at base
  have den : 0 < s+a*b := add_pos sp (mul_pos pa pb)
  have ds : 0 < 4+s := by linarith
  have ab : 4*(a*b) ≤ s^2 := by dsimp only [s]; nlinarith only [sq_nonneg (a-b)]
  have mz : m ≤ s^2/(4+s) := by
    refine base.trans ((div_le_div_iff₀ den ds).mpr ?_)
    nlinarith only [mul_le_mul_of_nonneg_right ab sp.le]
  have scaled := (le_div_iff₀ ds).mp mz
  have left : s*(4-s)/(4+s) ≤ s-2*m := (div_le_iff₀ ds).mpr (by nlinarith only [scaled])
  have right : s*(4-3*s)/(4+s) ≤ s-4*m := (div_le_iff₀ ds).mpr (by nlinarith only [scaled])
  have l0 : 0 ≤ s*(4-s)/(4+s) := div_nonneg (mul_nonneg sp.le (by linarith)) ds.le
  have r0 : 0 ≤ s*(4-3*s)/(4+s) := div_nonneg (mul_nonneg sp.le (by linarith)) ds.le
  have comp := mul_le_mul left right r0 (l0.trans left)
  let X := (a-m)*(a-2*m)
  let Y := (b-m)*(b-2*m)
  have total : (s-2*m)*(s-4*m) ≤ 2*(X+Y) := by
    dsimp only [X,Y,s]
    nlinarith only [sq_nonneg (a-b)]
  have first := mul_nonneg l0 r0
  have sq := pow_le_pow_left₀ first (comp.trans total) 2
  have kg := mul_le_mul_of_nonneg_left sq ks
  have en := harmonic (X := X) (Y := Y) pa pb small
  have sg := scale_gain sp small
  change s*profileGain s ≤ shapeWeight a*(a-m)^2*(a-2*m)^2+shapeWeight b*(b-m)^2*(b-2*m)^2
  have equality : shapeWeight a*(a-m)^2*(a-2*m)^2+shapeWeight b*(b-m)^2*(b-2*m)^2=
      shapeWeight a*X^2+shapeWeight b*Y^2 := by dsimp only [X,Y]; ring
  rw [equality]
  change shapeWeight s*(X+Y)^2 ≤ _ at en
  nlinarith only [sg,kg,en]

end Erdos810
#assert_no_sorry Erdos810.RectangleLimit.gain_le_shapeExtra
