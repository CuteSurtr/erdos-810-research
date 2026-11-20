import ProfileInterpretation
import ProfileSigns

/-! # Six certified profiles for the asymptotic rectangle inequalities -/

set_option autoImplicit false
namespace Erdos810
open PolynomialCertificate

private def CertifiedProfile (P : List ℚ) : Prop := UnitProfile (realPoly P) ∧ ValidProfile (realPoly P)

private theorem certified_next {P Q : List ℚ} (h : CertifiedProfile P) (r : BoundedPoly Q)
    (positive : OnSquare (stepExpr P Q)) : CertifiedProfile Q := by
  have zero_mem : (0:ℝ) ∈ Set.Icc (0:ℝ) 1 := ⟨le_rfl,zero_le_one⟩
  have qu := bounded_of_signs (fun x hx ↦ r.1 x hx 0 zero_mem) (fun x hx ↦ r.2 x hx 0 zero_mem)
  exact ⟨qu,validProfile_step h.2 h.1 (realPoly_continuous P) qu (realPoly_continuous Q)
    (transition_of_sign h.1 positive)⟩

/-- The fifth polynomial supplies the input to the strengthened transition. -/
theorem fifth_profile_valid : UnitProfile (realPoly P₅) ∧ ValidProfile (realPoly P₅) := by
  have base : CertifiedProfile P₀ := by
    have eq : realPoly P₀ = fun _ ↦ 0 := by funext x; simp [P₀,realPoly]
    unfold CertifiedProfile; rw [eq]; exact ⟨zero_unit,zero_valid⟩
  have a := certified_next base range₁ step₁
  have b := certified_next a range₂ step₂
  have c := certified_next b range₃ step₃
  have d := certified_next c range₄ step₄
  exact certified_next d range₅ step₅

/-- The sixth rational polynomial bounds all asymptotic rectangle densities uniformly. -/
theorem sixth_profile_valid : UnitProfile (realPoly P₆) ∧ ValidProfile (realPoly P₆) :=
  certified_next fifth_profile_valid range₆ step₆

end Erdos810
#assert_no_sorry Erdos810.fifth_profile_valid Erdos810.sixth_profile_valid
