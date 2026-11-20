import IntegerChart
import ProfilePartition

/-! # A two-sided sign certificate for the full-cut fixed point -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
open IntegerChart Expr

def shapeWidth : ℚ := 148677/250000
def shapeSlope : ℚ := 14777/31250
def shapeCap : Expr := (rat shapeWidth).sq+rat shapeSlope*(s-rat shapeWidth)-s.sq*rat (1/2)
def shapeTest : Expr :=
  let pair := cutExpr P₆ (shapeCap,1)
  let h := shapeCap
  let b := 1-s
  let W := b*(4-3*s)*(s-h).sq*(s-2*h).sq+s*(4-3*b)*(b-h).sq*(b-2*h).sq
  s*b*(h*pair.2-pair.1)+h*(rat (1/5)*W)*pair.1

set_option maxRecDepth 1000000
set_option maxHeartbeats 0

private theorem leaf0 : check shapeTest (1/16) (1/2)=true := by decide +kernel
private theorem leaf1 : check shapeTest (1/2) (71/128)=true := by decide +kernel
private theorem leaf2 : check shapeTest (71/128) (149/256)=true := by decide +kernel
private theorem leaf3 : check shapeTest (149/256) (305/512)=true := by decide +kernel
private theorem leaf4 : check shapeTest (305/512) (39/64)=true := by decide +kernel
private theorem leaf5 : check shapeTest (39/64) (23/32)=true := by decide +kernel
private theorem leaf6 : check shapeTest (23/32) (15/16)=true := by decide +kernel

theorem shapeTest_nonnegative {x : ℝ} (hx : x ∈ Set.Icc (1/16:ℝ) (15/16)) :
    0 ≤ shapeTest.eval x 0 := by
  by_cases limit0 : x ≤ (1/2)
  · apply sound (by norm_num) leaf0 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit1 : x ≤ (71/128)
  · apply sound (by norm_num) leaf1 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit2 : x ≤ (149/256)
  · apply sound (by norm_num) leaf2 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit3 : x ≤ (305/512)
  · apply sound (by norm_num) leaf3 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit4 : x ≤ (39/64)
  · apply sound (by norm_num) leaf4 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit5 : x ≤ (23/32)
  · apply sound (by norm_num) leaf5 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  apply sound (by norm_num) leaf6 x
  constructor <;> norm_num <;> linarith [hx.1,hx.2]

end Erdos810.PolynomialCertificate
assert_no_sorry Erdos810.PolynomialCertificate.shapeTest_nonnegative
