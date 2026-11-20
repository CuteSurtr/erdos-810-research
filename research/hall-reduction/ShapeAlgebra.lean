import ProfileInterpretation
import ShapeWeight

/-! # A rectangle bound that retains its side imbalance -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810

noncomputable def shapeBound (P : ℝ → ℝ) (a b : ℝ) : ℝ :=
  profileBound P a b-shapeWeight (a+b)*(a*b)^2*(a-b)^2

noncomputable def shapeValue (P Q : ℝ → ℝ) (s t : ℝ) (bonus : ℝ := 0) : ℝ :=
  let x := (1+t)*(1/2)
  let y := (1-t)*(1/2)
  let a := s*x
  let b := s*y
  let U := 1+a*P a
  let V := 1+b*P b
  let D := x*y
  let z := s^2*D
  let J := 1+s*D*(1+s*P s)
  let B := J-2*s*D
  let H := (x*V+y*U)*J^2+z*B*U*V
  let R := B^2*U*V+bonus*H
  let q := Q s
  let C := 1+s*D
  R-q*H-shapeWeight s*(s*t)^2*(C+z*q)*(C*H+z*R)

private theorem ratio_gap {z C H R q d K : ℝ} (hQ : 0 < C+z*q) (hR : 0 < C*H+z*R)
    (sign : 0 ≤ R-q*H-K*d^2*(C+z*q)*(C*H+z*R)) :
    z*H/(C*H+z*R) ≤ z/(C+z*q)-K*z^2*d^2 := by
  have diff : z/(C+z*q)-z*H/(C*H+z*R)=z^2*(R-q*H)/((C+z*q)*(C*H+z*R)) := by
    field_simp [hR.ne',hQ.ne']
    ring
  have main : K*z^2*d^2 ≤ z^2*(R-q*H)/((C+z*q)*(C*H+z*R)) := by
    apply (le_div_iff₀ (mul_pos hQ hR)).mpr
    nlinarith only [mul_nonneg (sq_nonneg z) sign]
  linarith only [diff,main]

set_option maxHeartbeats 2000000 in
private theorem ordered_shape_bound {P Q gain : ℝ → ℝ} (hu : UnitProfile P) (qu : UnitProfile Q)
    (gn : ∀ s ∈ Set.Icc (0:ℝ) 1, 0 ≤ gain s)
    (sign : ∀ s ∈ Set.Icc (0:ℝ) 1, ∀ t ∈ Set.Icc (0:ℝ) 1, 0 ≤ shapeValue P Q s t (gain s))
    {a b : ℝ} (pa : 0 < a) (pb : 0 < b) (small : a+b ≤ 1) (order : b ≤ a) :
    let M := profileBound P a b
    let L := (a+b-2*M)^2/(sideScale P a+sideScale P b+M*(a+b-2*M))
    rectangleCap a b (L+(a+b)*gain (a+b)) ≤ shapeBound Q a b := by
  let s := a+b
  let t := (a-b)/s
  let x := a/s
  let y := b/s
  let D := x*y
  let U := 1+a*P a
  let V := 1+b*P b
  let z := a*b
  let C := 1+s*D
  let J := 1+s*D*(1+s*P s)
  let B := J-2*s*D
  let R := B^2*U*V
  let H := (x*V+y*U)*J^2+z*B*U*V
  let Rg := R+gain s*H
  let M := profileBound P a b
  have sp : 0 < s := add_pos pa pb
  have zp : 0 < z := mul_pos pa pb
  have xp : 0 < x := div_pos pa sp
  have yp : 0 < y := div_pos pb sp
  have dp : 0 < D := mul_pos xp yp
  have tn : 0 ≤ t := div_nonneg (sub_nonneg.mpr order) sp.le
  have t1 : t ≤ 1 := (div_le_one sp).mpr (by dsimp only [s]; linarith)
  have xx : (1+t)*(1/2)=x := by dsimp only [t,x]; field_simp [sp.ne']; dsimp only [s]; ring
  have yy : (1-t)*(1/2)=y := by dsimp only [t,y]; field_simp [sp.ne']; dsimp only [s]; ring
  have sx : s*x=a := by dsimp only [x]; field_simp [sp.ne']
  have sy : s*y=b := by dsimp only [y]; field_simp [sp.ne']
  have offset : s*t=a-b := by dsimp only [t]; field_simp [sp.ne']
  have ab : z=s^2*D := by dsimp only [z,D]; rw [← sx,← sy]; ring
  have pp := (hu s ⟨sp.le,small⟩).1
  have qp := (qu s ⟨sp.le,small⟩).1
  have ppa := (hu a ⟨pa.le,by linarith⟩).1
  have ppb := (hu b ⟨pb.le,by linarith⟩).1
  have jp : 0 < J := by dsimp only [J]; positivity
  have up : 0 < U := by dsimp only [U]; positivity
  have vp : 0 < V := by dsimp only [V]; positivity
  have cp : 0 < C := by dsimp only [C]; positivity
  have mid : M = z/J := by
    unfold M
    rw [profileBound_eq_cap hu pa.le pb.le small sp]
    change z*s/(s+z*(1+s*P s))=_
    rw [show s+z*(1+s*P s)=s*J by rw [ab]; dsimp [J]; ring]
    field_simp [sp.ne',jp.ne']
  have gap : s-2*M = s*B/J := by rw [mid,ab]; unfold B; field_simp [jp.ne']
  have zsmall : 2*z ≤ s := by
    dsimp [z,s]
    nlinarith only [sq_nonneg (a-b),mul_nonneg sp.le (sub_nonneg.mpr small),sp.le]
  have msmall := (profileBound_range hu pa.le pb.le small).2
  have bp : 0 ≤ B := by
    have g : 0 ≤ s-2*M := by change M ≤ z at msmall; linarith
    rw [gap] at g
    have sg : 0 ≤ s*B := by simpa using (le_div_iff₀ jp).mp g
    exact nonneg_of_mul_nonneg_right sg sp
  have rp : 0 ≤ R := by dsimp [R]; positivity
  have hp : 0 < H := by dsimp only [H]; positivity
  have gp := gn s ⟨sp.le,small⟩
  have rg0 : 0 ≤ Rg := by dsimp only [Rg]; positivity
  have den : 0 < C*H+z*Rg := by positivity
  have denQ : 0 < C+z*Q s := by positivity
  have cert := sign s ⟨sp.le,small⟩ t ⟨tn,t1⟩
  unfold shapeValue at cert
  have ab' : s^2*(x*y)=z := ab.symm
  simp only [xx,yy,sx,sy,ab',offset] at cert
  change 0 ≤ Rg-Q s*H-shapeWeight s*(a-b)^2*(C+z*Q s)*(C*H+z*Rg) at cert
  have A : sideScale P a=s*x/U := by rw [sx]; rfl
  have E : sideScale P b=s*y/V := by rw [sy]; rfl
  have lden : sideScale P a+sideScale P b+M*(s-2*M)=s*H/(J^2*U*V) := by
    rw [A,E,gap,mid]
    dsimp only [H]
    field_simp [jp.ne',up.ne',vp.ne']
  have loss : (s-2*M)^2/(sideScale P a+sideScale P b+M*(s-2*M))=s*R/H := by
    rw [lden,gap]
    dsimp only [R]
    field_simp [jp.ne',up.ne',vp.ne',sp.ne',hp.ne']
  have gain_loss : (s-2*M)^2/(sideScale P a+sideScale P b+M*(s-2*M))+s*gain s=s*Rg/H := by
    rw [loss]
    dsimp only [Rg]
    field_simp [hp.ne']
    <;> ring
  have zdiv : (1/s)*z=s*D := by rw [ab]; field_simp [sp.ne']
  have cap : rectangleCap a b (s*Rg/H)=z*H/(C*H+z*Rg) := by
    change z*s/(s+z*(1+s*Rg/H))=_
    have id : (s+z*(1+s*Rg/H))*H=s*(C*H+z*Rg) := by
      dsimp only [C]
      field_simp [hp.ne']
      rw [ab]
      ring
    have pos : 0 < s+z*(1+s*Rg/H) := by positivity
    apply (div_eq_div_iff pos.ne' den.ne').mpr
    calc
      z*s*(C*H+z*Rg) = z*(s*(C*H+z*Rg)) := by ring
      _ = z*((s+z*(1+s*Rg/H))*H) := congrArg (z*·) id.symm
      _ = z*H*(s+z*(1+s*Rg/H)) := by ring
  have pq : profileBound Q a b=z/(C+z*Q s) := by
    change z/(1+(1/s+Q s)*z)=_
    rw [add_mul,zdiv]
    dsimp only [C]; ring
  change rectangleCap a b ((s-2*M)^2/(sideScale P a+sideScale P b+M*(s-2*M))+s*gain s) ≤ shapeBound Q a b
  rw [gain_loss,cap,shapeBound,pq]
  change z*H/(C*H+z*Rg) ≤ z/(C+z*Q s)-shapeWeight s*z^2*(a-b)^2
  exact ratio_gap denQ den cert

theorem valid_shape_bound_of_loss {P Q gain : ℝ → ℝ} (hu : UnitProfile P) (hc : Continuous P)
    (v : ValidProfile P) (qu : UnitProfile Q) (qc : Continuous Q)
    (gn : ∀ s ∈ Set.Icc (0:ℝ) 1, 0 ≤ gain s)
    (prior : ∀ T : RectangleLimit, 0 < T.m → T.m ≤ rectangleCap T.a T.b
      (sideLoss P T.a T.m+sideLoss P T.b T.m+(T.a+T.b)*gain (T.a+T.b)))
    (sign : ∀ s ∈ Set.Icc (0:ℝ) 1, ∀ t ∈ Set.Icc (0:ℝ) 1, 0 ≤ shapeValue P Q s t (gain s)) :
    SampleUpper (fun _ ↦ True) (shapeBound Q) := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨ha,hb,hs,_,_⟩ := H.range hn
    let a := H.a
    let b := H.b
    have a1 : a ≤ 1 := by dsimp [a]; linarith
    have b1 : b ≤ 1 := by dsimp [b]; linarith
    have z0 := mul_nonneg ha hb
    have z1 : a*b ≤ 1 := (mul_le_of_le_one_right ha b1).trans a1
    have diff : (a-b)^2 ≤ (a+b)^2 := by nlinarith only [z0]
    have k0 : 0 ≤ shapeWeight (a+b) := shapeWeight_nonneg ⟨add_nonneg ha hb,hs⟩
    have factor := (mul_le_mul_of_nonneg_left diff k0).trans (shapeWeight_sq (a+b))
    have q := qu _ ⟨add_nonneg ha hb,hs⟩
    have raw : 0 ≤ (1/(a+b)+Q (a+b))*(a*b) := by
      exact mul_nonneg (add_nonneg (one_div_nonneg.mpr (add_nonneg ha hb)) q.1) z0
    have zsum : (1/(a+b))*(a*b) ≤ 1 := by
      by_cases h : 0 < a+b
      · rw [one_div_mul_eq_div]; apply (div_le_iff₀ h).mpr
        linarith [mul_le_of_le_one_right ha b1]
      · have zero : a+b=0 := le_antisymm (le_of_not_gt h) (add_nonneg ha hb)
        simp [zero]
    have upper : 1+(1/(a+b)+Q (a+b))*(a*b) ≤ 3 := by
      nlinarith only [zsum,mul_le_mul q.2 z1 z0 zero_le_one]
    have fp : a*b/3 ≤ profileBound Q a b :=
      div_le_div_of_nonneg_left z0 (by linarith) upper
    have penalty : shapeWeight (a+b)*(a*b)^2*(a-b)^2 ≤ (4/15)*(a*b) := by
      nlinarith only [mul_le_mul_of_nonneg_left factor (sq_nonneg (a*b)),mul_le_mul_of_nonneg_left z1 z0]
    change 0 ≤ profileBound Q a b-shapeWeight (a+b)*(a*b)^2*(a-b)^2
    linarith
  · intro T hm
    obtain ⟨ha,hb,hs,_,_⟩ := T.range
    obtain ⟨pa,pb⟩ := T.positive_sides hm
    exact (profileBound_tendsto qc qu T.sideA T.sideB ha hb hs (add_pos pa pb)).sub
      (((shapeWeight_tendsto (T.sideA.add T.sideB) (add_pos pa pb)).mul ((T.sideA.mul T.sideB).pow 2)).mul
        ((T.sideA.sub T.sideB).pow 2))
  · intro T _ hm
    obtain ⟨ha,hb,hs,_,_⟩ := T.range
    obtain ⟨pa,pb⟩ := T.positive_sides hm
    let M := profileBound P T.a T.b
    have mM := T.of_valid hu hc v hm
    have mz := (profileBound_range hu ha hb hs).2
    have lo := two_loss_lower hu pa pb hs hm.le mM mz
    have Lpos : 0 ≤ (T.a+T.b-2*M)^2/(sideScale P T.a+sideScale P T.b+M*(T.a+T.b-2*M)) := by
      have fA := sideScale_pos hu pa (by linarith : T.a ≤ 1)
      have fB := sideScale_pos hu pb (by linarith : T.b ≤ 1)
      have ma := mz.trans (mul_le_of_le_one_right ha (show T.b ≤ 1 by linarith))
      have mb := mz.trans (mul_le_of_le_one_left hb (show T.a ≤ 1 by linarith))
      have g : 0 ≤ T.a+T.b-2*M := by change M ≤ T.a at ma; change M ≤ T.b at mb; linarith
      have pos : 0 ≤ M := hm.le.trans mM
      positivity
    have gn0 := mul_nonneg (add_nonneg ha hb) (gn (T.a+T.b) ⟨add_nonneg ha hb,hs⟩)
    refine ((prior T hm).trans (rectangleCap_antitone ha hb (add_pos pa pb) (add_nonneg Lpos gn0)
      (add_le_add_right lo ((T.a+T.b)*gain (T.a+T.b))))).trans ?_
    rcases le_total T.b T.a with o|o
    · exact ordered_shape_bound hu qu gn sign pa pb hs o
    · have h := ordered_shape_bound hu qu gn sign pb pa (by linarith) o
      dsimp only at h ⊢
      rw [profileBound_comm P T.b T.a,add_comm T.b T.a,add_comm (sideScale P T.b) _] at h
      unfold rectangleCap shapeBound at h ⊢
      rw [add_comm T.b T.a,mul_comm T.b T.a,profileBound_comm Q T.b T.a,sub_sq_comm T.b T.a] at h
      exact h

theorem valid_shape_bound {P Q : ℝ → ℝ} (hu : UnitProfile P) (hc : Continuous P) (v : ValidProfile P)
    (qu : UnitProfile Q) (qc : Continuous Q)
    (sign : ∀ s ∈ Set.Icc (0:ℝ) 1, ∀ t ∈ Set.Icc (0:ℝ) 1, 0 ≤ shapeValue P Q s t) :
    SampleUpper (fun _ ↦ True) (shapeBound Q) := by
  apply valid_shape_bound_of_loss (gain := fun _ ↦ 0) hu hc v qu qc (fun _ _ ↦ le_rfl) _ sign
  intro T hm
  simpa only [mul_zero,add_zero] using T.loss_bound hu hc v hm

theorem validProfile_of_shape {P : ℝ → ℝ} (v : SampleUpper (fun _ ↦ True) (shapeBound P)) :
    ValidProfile P := by
  intro ε he
  filter_upwards [v ε he,Filter.eventually_gt_atTop 0] with n est hn
  intro H _
  obtain ⟨a,b,s,_,_⟩ := H.range hn
  have K := shapeWeight_nonneg ⟨add_nonneg a b,s⟩
  have per := est H trivial
  unfold shapeBound at per
  nlinarith only [per,mul_nonneg (mul_nonneg K (sq_nonneg (H.a*H.b))) (sq_nonneg (H.a-H.b))]


end Erdos810
#assert_no_sorry Erdos810.valid_shape_bound
