import ProfilePartition

/-! # A strengthened rectangle transition with an explicit imbalance term -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
open Expr Partition

def shapeStep : Expr :=
  let x := (1+t)*rat (1/2)
  let y := (1-t)*rat (1/2)
  let a := s*x
  let b := s*y
  let U := 1+a*horner P₅ a
  let V := 1+b*horner P₅ b
  let D := x*y
  let z := s.sq*D
  let J := 1+s*D*(1+s*horner P₅ s)
  let B := J-2*s*D
  let R := B.sq*U*V
  let H := (x*V+y*U)*J.sq+z*B*U*V
  let q := horner P₆ s
  let C := 1+s*D
  R-q*H-rat (1/5)*(4-3*s)*s*t.sq*(C+z*q)*(C*H+z*R)

set_option maxRecDepth 1000000
set_option maxHeartbeats 0

theorem shapeStep_sign : OnSquare shapeStep :=
  checked leaf (by decide +kernel)

end Erdos810.PolynomialCertificate
assert_no_sorry Erdos810.PolynomialCertificate.shapeStep_sign
