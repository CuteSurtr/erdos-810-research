import PositivePolynomial

/-! # The polynomials used for the six rectangle bounds -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
namespace Expr

instance (n : ℕ) : OfNat Expr n := ⟨.rat n⟩
instance : Add Expr := ⟨.add⟩
instance : Mul Expr := ⟨.mul⟩
instance : Neg Expr := ⟨fun e ↦ .mul (.rat (-1)) e⟩
instance : Sub Expr := ⟨fun p q ↦ p + -q⟩
def sq (e : Expr) := e*e

@[simp] theorem eval_nat (n : ℕ) (x y : ℝ) :
    (ofNat(n) : Expr).eval x y = n := by simp [eval]
@[simp] theorem eval_rat (k : ℚ) (x y : ℝ) : (rat k).eval x y = k := rfl
@[simp] theorem eval_s (x y : ℝ) : s.eval x y = x := rfl
@[simp] theorem eval_t (x y : ℝ) : t.eval x y = y := rfl
@[simp] theorem eval_add (p q : Expr) (x y : ℝ) : (p+q).eval x y = p.eval x y+q.eval x y := rfl
@[simp] theorem eval_mul (p q : Expr) (x y : ℝ) : (p*q).eval x y = p.eval x y*q.eval x y := rfl
@[simp] theorem eval_sub (p q : Expr) (x y : ℝ) : (p-q).eval x y = p.eval x y-q.eval x y := by
  change p.eval x y+((-1:ℚ):ℝ)*q.eval x y=_
  push_cast
  ring
@[simp] theorem eval_sq (p : Expr) (x y : ℝ) : p.sq.eval x y = (p.eval x y)^2 := by rw [sq,eval_mul,pow_two]

end Expr
open Expr

def horner : List ℚ → Expr → Expr
  | [], _ => 0
  | [c], _ => .rat c
  | c::d::cs, v => rat c+v*horner (d::cs) v

def profile (coeffs : List ℤ) : List ℚ := coeffs.map (fun k ↦ (k:ℚ)/1000000)

def P₀ : List ℚ := [0]
def P₁ := profile [999982,-1000908,260051,211655,-207088,57719]
def P₂ := profile [999976,-500632,-497000,802099,-489786,121804]
def P₃ := profile [999973,-499097,-390702,667511,-414504,102855]
def P₄ := profile [999972,-499094,-390068,676897,-418799,102409]
def P₅ := profile [999973,-499129,-389683,675471,-415911,101306]
def P₆ := profile [999973,-499133,-389642,675359,-415825,101377]

def stepExpr (P Q : List ℚ) : Expr :=
  let x := (1+t)*rat (1/2)
  let y := (1-t)*rat (1/2)
  let a := s*x
  let b := s*y
  let U := 1+a*horner P a
  let V := 1+b*horner P b
  let D := x*y
  let J := 1+s*D*(1+s*horner P s)
  let B := J-2*s*D
  B.sq*U*V - horner Q s*((x*V+y*U)*J.sq+s.sq*D*B*U*V)

def cutExpr (P : List ℚ) (pq : Expr × Expr) : Expr × Expr :=
  let (p,q) := pq
  let a := s
  let b := 1-s
  let U := 1+a*horner P a
  let V := 1+b*horner P b
  let A := a*q-p
  let B := b*q-p
  let na := A.sq*U
  let nb := B.sq*V
  let da := a*q.sq+p*A*U
  let db := b*q.sq+p*B*V
  let z := a*b
  (z*da*db, da*db+z*(da*db+na*db+nb*da))

def initialCut (P : List ℚ) : Expr × Expr :=
  let z := s*(1-s)
  (z,1+z*(1+rat P.sum))

def w : ℚ := 5951/10000
def slope : ℚ := 4756/10000
def cap : Expr := (rat w).sq+rat slope*(s-rat w)-s.sq*rat (1/2)
def terminal : Expr :=
  let (p,q) := cutExpr P₆ (cutExpr P₆ (initialCut P₆))
  cap*q-p

end Erdos810.PolynomialCertificate
