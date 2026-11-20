import ProfilePartition

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate
open Partition Expr

set_option maxRecDepth 1000000
set_option maxHeartbeats 0

def BoundedPoly (P : List ℚ) : Prop := OnSquare (horner P s) ∧ OnSquare (1-horner P s)

theorem range₁ : BoundedPoly P₁ := ⟨checked leaf (by decide +kernel), checked leaf (by decide +kernel)⟩
theorem range₂ : BoundedPoly P₂ := ⟨checked leaf (by decide +kernel), checked leaf (by decide +kernel)⟩
theorem range₃ : BoundedPoly P₃ := ⟨checked leaf (by decide +kernel), checked leaf (by decide +kernel)⟩
theorem range₄ : BoundedPoly P₄ := ⟨checked leaf (by decide +kernel), checked leaf (by decide +kernel)⟩
theorem range₅ : BoundedPoly P₅ := ⟨checked leaf (by decide +kernel), checked leaf (by decide +kernel)⟩
theorem range₆ : BoundedPoly P₆ := ⟨checked leaf (by decide +kernel), checked leaf (by decide +kernel)⟩

theorem step₁ : OnSquare (stepExpr P₀ P₁) := checked initialBoxes (by decide +kernel)
theorem step₂ : OnSquare (stepExpr P₁ P₂) := checked halves (by decide +kernel)
theorem step₃ : OnSquare (stepExpr P₂ P₃) := checked halves (by decide +kernel)
theorem step₄ : OnSquare (stepExpr P₃ P₄) := checked halves (by decide +kernel)
theorem step₅ : OnSquare (stepExpr P₄ P₅) := checked halves (by decide +kernel)
theorem step₆ : OnSquare (stepExpr P₅ P₆) := checked halves (by decide +kernel)

end Erdos810.PolynomialCertificate
assert_no_sorry Erdos810.PolynomialCertificate.step₆
