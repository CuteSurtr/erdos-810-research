import IntegerChart
import ProfilePartition

/-! # Exact sign of the degree-114 polynomial on five rational intervals -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
open IntegerChart

set_option maxRecDepth 1000000
set_option maxHeartbeats 0

private theorem lowerHalf : check terminal 0 (1/2)=true := by decide +kernel
private theorem nextSixteenth : check terminal (1/2) (9/16)=true := by decide +kernel
private theorem followingSixteenth : check terminal (9/16) (5/8)=true := by decide +kernel
private theorem nextEighth : check terminal (5/8) (3/4)=true := by decide +kernel
private theorem lastQuarter : check terminal (3/4) 1=true := by decide +kernel

theorem terminal_sign_integer : OnSquare terminal := by
  intro x hx y _
  change 0 ≤ terminal.eval x 0
  by_cases limit0 : x ≤ (1/2)
  · apply sound (by norm_num) lowerHalf x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit1 : x ≤ (9/16)
  · apply sound (by norm_num) nextSixteenth x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit2 : x ≤ (5/8)
  · apply sound (by norm_num) followingSixteenth x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  by_cases limit3 : x ≤ (3/4)
  · apply sound (by norm_num) nextEighth x
    constructor <;> norm_num <;> linarith [hx.1,hx.2]
  apply sound (by norm_num) lastQuarter x
  constructor <;> norm_num <;> linarith [hx.1,hx.2]

end Erdos810.PolynomialCertificate
assert_no_sorry Erdos810.PolynomialCertificate.terminal_sign_integer
