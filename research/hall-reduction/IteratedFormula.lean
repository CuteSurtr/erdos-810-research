import ProfileFormula

/-! # The iterated imbalance correction -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
open Expr

def P7 : List ℚ := profile [999866,-496052,-274156,340952,-93166,-4677]
def P8 : List ℚ := profile [999874,-496301,-271699,348470,-109475,2786]

def iteratedShapeStep (P Q : List ℚ) : Expr :=
  let x := (1+t)*rat (1/2)
  let y := (1-t)*rat (1/2)
  let a := s*x
  let b := s*y
  let U := 1+a*horner P a
  let V := 1+b*horner P b
  let D := x*y
  let z := s.sq*D
  let J := 1+s*D*(1+s*horner P s)
  let B := J-2*s*D
  let H := (x*V+y*U)*J.sq+z*B*U*V
  let A := 4-3*s
  let gain := s.sq*A.sq*A*(4-s).sq*(9-4*s)*rat (1/62500)
  let R := B.sq*U*V+gain*H
  let q := horner Q s
  let C := 1+s*D
  R-q*H-rat (1/5)*(4-3*s)*s*t.sq*(C+z*q)*(C*H+z*R)

end Erdos810.PolynomialCertificate
