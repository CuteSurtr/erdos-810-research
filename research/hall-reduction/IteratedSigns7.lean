import IteratedFormula
import ProfileSigns
import IntegerBox

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
open Expr Partition
set_option maxRecDepth 1000000
set_option maxHeartbeats 0

theorem range7 : BoundedPoly P7 := ⟨checked leaf (by decide +kernel),checked leaf (by decide +kernel)⟩
theorem iterated_sign7 : OnSquare (iteratedShapeStep P₆ P7) :=
  IntegerBox.halves (by decide +kernel) (by decide +kernel)

end Erdos810.PolynomialCertificate
assert_no_sorry Erdos810.PolynomialCertificate.iterated_sign7
