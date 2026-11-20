import ProfileIteration
import ProfileFormula

/-! # Interpreting the polynomial certificates as rectangle inequalities -/

set_option autoImplicit false
namespace Erdos810
namespace PolynomialCertificate
open Expr

noncomputable def realPoly : List ℚ → ℝ → ℝ
  | [],_ => 0
  | c::cs,x => c+x*realPoly cs x

theorem realPoly_continuous (P : List ℚ) : Continuous (realPoly P) := by
  induction P with
  | nil => exact continuous_const
  | cons c cs ih => exact continuous_const.add (continuous_id.mul ih)

@[simp] theorem horner_eval (P : List ℚ) (v : Expr) (x y : ℝ) :
    (horner P v).eval x y = realPoly P (v.eval x y) := by
  induction P, v using horner.induct with
  | case1 => simp [horner,realPoly]
  | case2 => simp [horner,realPoly]
  | case3 c d cs v ih => simp [horner,realPoly,ih]

theorem bounded_of_signs {P : List ℚ}
    (lo : ∀ x ∈ Set.Icc (0:ℝ) 1, 0 ≤ (horner P s).eval x 0)
    (hi : ∀ x ∈ Set.Icc (0:ℝ) 1, 0 ≤ (1-horner P s).eval x 0) : UnitProfile (realPoly P) := by
  intro x hx
  exact ⟨by simpa using lo x hx, by simpa using hi x hx⟩

private noncomputable def stepValue (P Q : ℝ → ℝ) (s t : ℝ) : ℝ :=
  let x := (1+t)*(1/2)
  let y := (1-t)*(1/2)
  let a := s*x
  let b := s*y
  let U := 1+a*P a
  let V := 1+b*P b
  let D := x*y
  let J := 1+s*D*(1+s*P s)
  let B := J-2*s*D
  B^2*U*V-Q s*((x*V+y*U)*J^2+s^2*D*B*U*V)

theorem stepExpr_eval (P Q : List ℚ) (x y : ℝ) :
    (stepExpr P Q).eval x y = stepValue (realPoly P) (realPoly Q) x y := by
  simp only [stepExpr,stepValue,eval_add,eval_sub,eval_mul,eval_nat,eval_s,eval_t,eval_rat,
    eval_sq,horner_eval,Rat.cast_div,Rat.cast_one,Rat.cast_ofNat,Nat.cast_ofNat,Nat.cast_one]

/-- A polynomial sign on the unit square implies the transition for all side sizes. -/
theorem transition_of_sign {P Q : List ℚ} (hu : UnitProfile (realPoly P))
    (sign : ∀ x ∈ Set.Icc (0:ℝ) 1, ∀ y ∈ Set.Icc (0:ℝ) 1, 0 ≤ (stepExpr P Q).eval x y) :
    ProfileTransition (realPoly P) (realPoly Q) := by
  intro a b ha hb hs
  have ordered (a b : ℝ) (pa : 0 < a) (pb : 0 < b) (small : a+b ≤ 1) (order : b ≤ a) :
      let M := profileBound (realPoly P) a b
      (a+b)*realPoly Q (a+b)*(sideScale (realPoly P) a+sideScale (realPoly P) b+M*(a+b-2*M))
        ≤ (a+b-2*M)^2 := by
    let s := a+b
    let t := (a-b)/s
    let x := a/s
    let y := b/s
    let D := x*y
    let U := 1+a*realPoly P a
    let V := 1+b*realPoly P b
    let J := 1+s*D*(1+s*realPoly P s)
    let B := J-2*s*D
    let M := profileBound (realPoly P) a b
    have sp : 0 < s := add_pos pa pb
    have tn : 0 ≤ t := div_nonneg (sub_nonneg.mpr order) sp.le
    have t1 : t ≤ 1 := (div_le_one sp).mpr (by dsimp only [s]; linarith)
    have xx : (1+t)*(1/2)=x := by dsimp only [t,x]; field_simp [sp.ne']; dsimp only [s]; ring
    have yy : (1-t)*(1/2)=y := by dsimp only [t,y]; field_simp [sp.ne']; dsimp only [s]; ring
    have sx : s*x=a := by dsimp only [x]; field_simp [sp.ne']
    have sy : s*y=b := by dsimp only [y]; field_simp [sp.ne']
    have cert := sign s ⟨sp.le,small⟩ t ⟨tn,t1⟩
    rw [stepExpr_eval] at cert
    unfold stepValue at cert
    simp only [xx,yy,sx,sy] at cert
    change 0 ≤ B^2*U*V-realPoly Q s*((x*V+y*U)*J^2+s^2*D*B*U*V) at cert
    have pp := (hu s ⟨sp.le,small⟩).1
    have ppa := (hu a ⟨pa.le,by linarith⟩).1
    have ppb := (hu b ⟨pb.le,by linarith⟩).1
    have dp : 0 ≤ D := mul_nonneg (div_nonneg pa.le sp.le) (div_nonneg pb.le sp.le)
    have jp : 0 < J := by dsimp only [J]; positivity
    have up : 0 < U := by dsimp only [U]; positivity
    have vp : 0 < V := by dsimp only [V]; positivity
    have ab : a*b = s^2*D := by dsimp only [D]; rw [← sx,← sy]; ring
    have mid : M = s^2*D/J := by
      unfold M
      rw [profileBound_eq_cap hu pa.le pb.le small sp]
      change a*b*s/(s+a*b*(1+s*realPoly P s))=_
      rw [ab,show s+s^2*D*(1+s*realPoly P s)=s*J by dsimp [J]; ring]
      field_simp [sp.ne',jp.ne']
    have gap : s-2*M = s*B/J := by rw [mid]; unfold B; field_simp [jp.ne']
    have A : sideScale (realPoly P) a=s*x/U := by rw [sx]; rfl
    have B' : sideScale (realPoly P) b=s*y/V := by rw [sy]; rfl
    change s*realPoly Q s*(sideScale (realPoly P) a+sideScale (realPoly P) b+M*(s-2*M)) ≤ (s-2*M)^2
    rw [A,B',gap,mid]
    have id :
        (s*B/J)^2-s*realPoly Q s*(s*x/U+s*y/V+s^2*D/J*(s*B/J)) =
        s^2/(J^2*U*V)*(B^2*U*V-realPoly Q s*((x*V+y*U)*J^2+s^2*D*B*U*V)) := by
      field_simp [jp.ne',up.ne',vp.ne']
    exact sub_nonneg.mp (id ▸ (mul_nonneg (by positivity) cert))
  rcases le_total b a with o|o
  · exact ordered a b ha hb hs o
  · have h := ordered b a hb ha (by linarith) o
    dsimp only at h ⊢
    rw [add_comm b a,profileBound_comm (realPoly P) b a,
      add_comm (sideScale (realPoly P) b) (sideScale (realPoly P) a)] at h
    exact h

end PolynomialCertificate
end Erdos810
#assert_no_sorry Erdos810.PolynomialCertificate.transition_of_sign
