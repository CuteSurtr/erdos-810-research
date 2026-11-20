import ProfileInterpretation

/-! # The two terminal updates for the cut from a global color class -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810
namespace PolynomialCertificate
open Expr

private noncomputable def updatePair (P : ℝ → ℝ) (a b p q : ℝ) : ℝ × ℝ :=
  let U := 1+a*P a
  let V := 1+b*P b
  let A := a*q-p
  let B := b*q-p
  let na := A^2*U
  let nb := B^2*V
  let da := a*q^2+p*A*U
  let db := b*q^2+p*B*V
  let z := a*b
  (z*da*db,da*db+z*(da*db+na*db+nb*da))

private theorem update_eval (P : List ℚ) (e : Expr × Expr) (x y : ℝ) :
    ((cutExpr P e).1.eval x y,(cutExpr P e).2.eval x y) =
    updatePair (realPoly P) x (1-x) (e.1.eval x y) (e.2.eval x y) := by
  rcases e with ⟨p,q⟩
  simp only [cutExpr,updatePair,eval_mul,eval_add,eval_sub,eval_nat,eval_s,horner_eval,eval_sq,
    Nat.cast_one]

private structure BoundPair (T : RectangleLimit) (p q : ℝ) : Prop where
  den : 0 < q
  lower : T.m ≤ p/q
  upper : p/q ≤ T.a*T.b

private theorem side_ratio {P : ℝ → ℝ} (hu : UnitProfile P) {v p q : ℝ} (hv : 0 < v)
    (hv1 : v ≤ 1) (hq : 0 < q) (hp : 0 ≤ p) (h : p/q ≤ v) :
    let U := 1+v*P v
    let A := v*q-p
    0 < v*q^2+p*A*U ∧ sideLoss P v (p/q)=A^2*U/(v*q^2+p*A*U) := by
  let U := 1+v*P v
  let A := v*q-p
  have hU : 0 < U := by have := (hu v ⟨hv.le,hv1⟩).1; dsimp [U]; positivity
  have hA : 0 ≤ A := sub_nonneg.mpr ((div_le_iff₀ hq).mp h)
  have den : 0 < v*q^2+p*A*U := add_pos_of_pos_of_nonneg (mul_pos hv (sq_pos_of_pos hq))
    (mul_nonneg (mul_nonneg hp hA) hU.le)
  refine ⟨den,?_⟩
  have hF := sideScale_pos hu hv hv1
  have side : 0 < sideScale P v+(p/q)*(v-p/q) :=
    add_pos_of_pos_of_nonneg hF (mul_nonneg (div_nonneg hp hq.le) (sub_nonneg.mpr h))
  apply (div_eq_div_iff (ne_of_gt side) (ne_of_gt den)).mpr
  change (v-p/q)^2*(v*q^2+p*A*U)=A^2*U*(v/U+p/q*(v-p/q))
  field_simp [ne_of_gt hq,ne_of_gt hU]
  dsimp only [A]

/-- A cleared polynomial inequality at one nonnegative trial value certifies a supersolution. -/
theorem update_le_of_sign_extra (P : List ℚ) (hu : UnitProfile (realPoly P)) (e : Expr)
    {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (hs : a+b=1)
    (h0 : 0 ≤ e.eval a 0) (hz : e.eval a 0 ≤ a*b)
    {extra : ℝ} (he : 0 ≤ extra)
    (sign : 0 ≤ (e*(cutExpr P (e,1)).2-(cutExpr P (e,1)).1).eval a 0+
      e.eval a 0*extra*((cutExpr P (e,1)).1.eval a 0)) :
    rectangleCap a b (sideLoss (realPoly P) a (e.eval a 0)+sideLoss (realPoly P) b (e.eval a 0)+extra) ≤
      e.eval a 0 := by
  let h := e.eval a 0
  let z := a*b
  let U := 1+a*realPoly P a
  let V := 1+b*realPoly P b
  let da := a+h*(a-h)*U
  let db := b+h*(b-h)*V
  let na := (a-h)^2*U
  let nb := (b-h)^2*V
  have a1 : a ≤ 1 := by linarith
  have b1 : b ≤ 1 := by linarith
  have ah : h/1 ≤ a := by simpa [h] using hz.trans (mul_le_of_le_one_right ha.le b1)
  have bh : h/1 ≤ b := by simpa [h] using hz.trans (mul_le_of_le_one_left hb.le a1)
  have aa : 0 < da ∧ sideLoss (realPoly P) a h=na/da := by
    simpa [da,na,U] using side_ratio hu ha a1 zero_lt_one h0 ah
  have bb : 0 < db ∧ sideLoss (realPoly P) b h=nb/db := by
    simpa [db,nb,V] using side_ratio hu hb b1 zero_lt_one h0 bh
  have eq := update_eval P (e,1) a 0
  rw [show 1-a=b by linarith] at eq
  change ((cutExpr P (e,1)).1.eval a 0,(cutExpr P (e,1)).2.eval a 0)=
    updatePair (realPoly P) a b h ((1:Expr).eval a 0) at eq
  have pair : ((cutExpr P (e,1)).1.eval a 0,(cutExpr P (e,1)).2.eval a 0)=
      (z*da*db,da*db+z*(da*db+na*db+nb*da)) := by
    simpa only [eval_nat,Nat.cast_one,updatePair,one_pow,mul_one] using eq
  have pp := congrArg Prod.fst pair
  have qq := congrArg Prod.snd pair
  dsimp only at pp qq
  rw [eval_sub,eval_mul,pp,qq] at sign
  have la := sideLoss_nonneg hu ha a1 h0 (by simpa using ah)
  have lb := sideLoss_nonneg hu hb b1 h0 (by simpa using bh)
  have z0 : 0 < z := mul_pos ha hb
  have pos : 0 < 1+z*(1+(sideLoss (realPoly P) a h+sideLoss (realPoly P) b h+extra)) := by positivity
  unfold rectangleCap
  rw [hs,mul_one]
  apply (div_le_iff₀ pos).mpr
  apply (le_of_mul_le_mul_right _ (mul_pos aa.1 bb.1))
  change z*(da*db) ≤ h*(1+z*(1+(sideLoss (realPoly P) a h+sideLoss (realPoly P) b h+extra)))*(da*db)
  rw [aa.2,bb.2]
  have id : (1+z*(1+(na/da+nb/db+extra)))*(da*db)=da*db+z*(da*db+na*db+nb*da)+extra*(z*da*db) := by
    field_simp [aa.1.ne',bb.1.ne']
    ring
  rw [mul_assoc h,id]
  change 0 ≤ h*(da*db+z*(da*db+na*db+nb*da))-z*da*db+h*extra*(z*da*db) at sign
  nlinarith only [sign]

/-- A cleared polynomial inequality at one nonnegative trial value certifies a supersolution. -/
theorem update_le_of_sign (P : List ℚ) (hu : UnitProfile (realPoly P)) (e : Expr)
    {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (hs : a+b=1)
    (h0 : 0 ≤ e.eval a 0) (hz : e.eval a 0 ≤ a*b)
    (sign : 0 ≤ (e*(cutExpr P (e,1)).2-(cutExpr P (e,1)).1).eval a 0) :
    rectangleCap a b (sideLoss (realPoly P) a (e.eval a 0)+sideLoss (realPoly P) b (e.eval a 0)) ≤
      e.eval a 0 := by
  have result := update_le_of_sign_extra P hu e ha hb hs h0 hz (extra := 0) le_rfl (by simpa using sign)
  simpa using result

private theorem update_bound {P : ℝ → ℝ} (hu : UnitProfile P) (hc : Continuous P)
    (v : ValidProfile P) (T : RectangleLimit) (hm : 0 < T.m) (hs : T.a+T.b=1)
    {p q : ℝ} (H : BoundPair T p q) :
    BoundPair T (updatePair P T.a T.b p q).1 (updatePair P T.a T.b p q).2 := by
  obtain ⟨ha,hb⟩ := T.positive_sides hm
  have ha1 : T.a ≤ 1 := by linarith
  have hb1 : T.b ≤ 1 := by linarith
  have pqPos := hm.le.trans H.lower
  have hp : 0 ≤ p := by simpa using (le_div_iff₀ H.den).mp pqPos
  have Ali := H.upper.trans (mul_le_of_le_one_right ha.le hb1)
  have Bli := H.upper.trans (mul_le_of_le_one_left hb.le ha1)
  let z := T.a*T.b
  let U := 1+T.a*P T.a
  let V := 1+T.b*P T.b
  let A := T.a*q-p
  let B := T.b*q-p
  let na := A^2*U
  let nb := B^2*V
  let da := T.a*q^2+p*A*U
  let db := T.b*q^2+p*B*V
  have Adata := side_ratio hu ha ha1 H.den hp Ali
  have Bdata := side_ratio hu hb hb1 H.den hp Bli
  change 0 < da ∧ sideLoss P T.a (p/q)=na/da at Adata
  change 0 < db ∧ sideLoss P T.b (p/q)=nb/db at Bdata
  have hla := sideLoss_nonneg hu ha ha1 pqPos Ali
  have hlb := sideLoss_nonneg hu hb hb1 pqPos Bli
  have nn := add_nonneg hla hlb
  have order := add_le_add (sideLoss_antitone hu ha ha1 hm.le H.lower Ali)
    (sideLoss_antitone hu hb hb1 hm.le H.lower Bli)
  have improved := (T.loss_bound hu hc v hm).trans (rectangleCap_antitone ha.le hb.le (add_pos ha hb) nn order)
  have zpos : 0 < z := mul_pos ha hb
  have daPos := Adata.1
  have dbPos := Bdata.1
  rw [Adata.2] at hla
  rw [Bdata.2] at hlb
  have naPos : 0 ≤ na := by simpa using (le_div_iff₀ daPos).mp hla
  have nbPos : 0 ≤ nb := by simpa using (le_div_iff₀ dbPos).mp hlb
  have den : 0 < da*db+z*(da*db+na*db+nb*da) := by positivity
  have den' : 0 < 1+z*(1+(na/da+nb/db)) := by positivity
  have id : rectangleCap T.a T.b (sideLoss P T.a (p/q)+sideLoss P T.b (p/q)) =
      (z*da*db)/(da*db+z*(da*db+na*db+nb*da)) := by
    rw [Adata.2,Bdata.2]
    unfold rectangleCap
    rw [hs,mul_one]
    change z/(1+z*(1+(na/da+nb/db)))=_
    apply (div_eq_div_iff den'.ne' den.ne').mpr
    field_simp [daPos.ne',dbPos.ne']
    ring
  have upper : (z*da*db)/(da*db+z*(da*db+na*db+nb*da)) ≤ z := by
    apply (div_le_iff₀ den).mpr
    nlinarith only [mul_nonneg (sq_nonneg z) (add_nonneg (add_nonneg
      (mul_nonneg daPos.le dbPos.le) (mul_nonneg naPos dbPos.le)) (mul_nonneg nbPos daPos.le))]
  exact ⟨den,improved.trans_eq id,upper⟩

private theorem realPoly_one (P : List ℚ) : realPoly P 1 = (P.sum:ℝ) := by
  induction P with
  | nil => simp [realPoly]
  | cons c cs ih => simp [realPoly, ih]

private theorem initial_bound {P : List ℚ} (hu : UnitProfile (realPoly P)) (v : ValidProfile (realPoly P))
    (T : RectangleLimit) (hm : 0 < T.m) (hs : T.a+T.b=1) :
    BoundPair T ((initialCut P).1.eval T.a 0) ((initialCut P).2.eval T.a 0) := by
  have bound := T.of_valid hu (realPoly_continuous P) v hm
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have b : 1-T.a=T.b := by linarith
  have pp := (hu 1 ⟨by norm_num,le_rfl⟩).1
  simp only [initialCut,eval_add,eval_mul,eval_nat,eval_s,eval_sub,eval_rat,Nat.cast_one,b, ← realPoly_one]
  have den : 0 < 1+T.a*T.b*(1+realPoly P 1) := by positivity
  have dz : 0 ≤ T.a*T.b*(1+realPoly P 1) := by positivity
  refine ⟨den, ?_,div_le_self (mul_nonneg pa.le pb.le) (by linarith)⟩
  unfold profileBound at bound
  simpa only [hs,div_one,mul_comm (T.a*T.b)] using bound

noncomputable def cutCap (x : ℝ) : ℝ := (w:ℝ)^2+(slope:ℝ)*(x-w)-x^2/2

theorem cap_eval (x y : ℝ) : cap.eval x y = cutCap x := by
  simp only [cap,cutCap,eval_sq,eval_add,eval_sub,eval_mul,eval_s,eval_rat,Rat.cast_div,
    Rat.cast_one,Rat.cast_ofNat]
  ring

theorem cutCap_nonneg {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) : 0 ≤ cutCap x := by
  unfold cutCap w slope
  push_cast
  nlinarith only [mul_nonneg hx.1 (sub_nonneg.mpr hx.2),hx.2]

theorem terminal_limit (hu : UnitProfile (realPoly P₆)) (v : ValidProfile (realPoly P₆))
    (sign : ∀ x ∈ Set.Icc (0:ℝ) 1, 0 ≤ terminal.eval x 0)
    (T : RectangleLimit) (hm : 0 < T.m) (hs : T.a+T.b=1) : T.m ≤ cutCap T.a := by
  let E := initialCut P₆
  have b : 1-T.a=T.b := by linarith
  have update (e : Expr × Expr) (h : BoundPair T (e.1.eval T.a 0) (e.2.eval T.a 0)) :
      BoundPair T ((cutExpr P₆ e).1.eval T.a 0) ((cutExpr P₆ e).2.eval T.a 0) := by
    have eq := update_eval P₆ e T.a 0
    rw [b] at eq
    have fst := congrArg Prod.fst eq
    have snd := congrArg Prod.snd eq
    dsimp only at fst snd
    rw [fst,snd]
    exact update_bound hu (realPoly_continuous P₆) v T hm hs h
  have twice := update _ (update E (initial_bound hu v T hm hs))
  obtain ⟨ha,hb,fit,_,_⟩ := T.range
  have nonneg := sign T.a ⟨ha,by linarith⟩
  change 0 ≤ (cap*(cutExpr P₆ (cutExpr P₆ E)).2-(cutExpr P₆ (cutExpr P₆ E)).1).eval T.a 0 at nonneg
  rw [eval_sub,eval_mul,cap_eval] at nonneg
  exact twice.lower.trans ((div_le_iff₀ twice.den).mpr (sub_nonneg.mp nonneg))

end PolynomialCertificate
end Erdos810
#assert_no_sorry Erdos810.PolynomialCertificate.terminal_limit
