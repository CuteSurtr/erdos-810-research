import IntegerChart
import ProfilePartition

/-! # A degree-24 sign certificate for the full-cut fixed point -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
open IntegerChart Expr

def fixedWidth : ℚ := 1190169/2000000
def fixedSlope : ℚ := 4754683/10000000
def fixedCap : Expr := (rat fixedWidth).sq+rat fixedSlope*(s-rat fixedWidth)-s.sq*rat (1/2)
def fixedTest : Expr :=
  let pair := cutExpr P₆ (fixedCap,1)
  fixedCap*pair.2-pair.1

set_option maxRecDepth 1000000
set_option maxHeartbeats 0

private theorem leaf0 : check fixedTest (1/16) (1/2)=true := by decide +kernel
private theorem leaf1 : check fixedTest (1/2) (71/128)=true := by decide +kernel
private theorem leaf2 : check fixedTest (71/128) (149/256)=true := by decide +kernel
private theorem leaf3 : check fixedTest (149/256) (603/1024)=true := by decide +kernel
private theorem leaf4 : check fixedTest (603/1024) (1213/2048)=true := by decide +kernel
private theorem leaf5 : check fixedTest (1213/2048) (2433/4096)=true := by decide +kernel
private theorem leaf6 : check fixedTest (2433/4096) (305/512)=true := by decide +kernel
private theorem leaf7 : check fixedTest (305/512) (39/64)=true := by decide +kernel
private theorem leaf8 : check fixedTest (39/64) (23/32)=true := by decide +kernel
private theorem leaf9 : check fixedTest (23/32) (15/16)=true := by decide +kernel

theorem fixedTest_nonnegative {x : ℝ} (hx : x ∈ Set.Icc (1/16:ℝ) (15/16)) :
    0 ≤ fixedTest.eval x 0 := by
  by_cases limit0 : x ≤ (1/2)
  · apply sound (by norm_num) leaf0 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit1 : x ≤ (71/128)
  · apply sound (by norm_num) leaf1 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit2 : x ≤ (149/256)
  · apply sound (by norm_num) leaf2 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit3 : x ≤ (603/1024)
  · apply sound (by norm_num) leaf3 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit4 : x ≤ (1213/2048)
  · apply sound (by norm_num) leaf4 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit5 : x ≤ (2433/4096)
  · apply sound (by norm_num) leaf5 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit6 : x ≤ (305/512)
  · apply sound (by norm_num) leaf6 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit7 : x ≤ (39/64)
  · apply sound (by norm_num) leaf7 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit8 : x ≤ (23/32)
  · apply sound (by norm_num) leaf8 x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  apply sound (by norm_num) leaf9 x
  constructor <;> norm_num <;> linarith [hx.1,hx.2]

end Erdos810.PolynomialCertificate
assert_no_sorry Erdos810.PolynomialCertificate.fixedTest_nonnegative
