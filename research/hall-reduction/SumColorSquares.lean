import Mathlib.Tactic

/-! # Opposite color collisions on an additive board -/

set_option autoImplicit false
namespace Erdos810
variable {G : Type*} [AddCommGroup G]

/-- Every supported rectangle has unequal colors on its crossed cells.
Swapping its two columns gives the other opposite-edge inequality. -/
def SumBoardSafe (f : G →+ G) (S : Set G) : Prop :=
  ∀ x x' y y' : G, x ≠ x' → y ≠ y' →
    x + f y ∈ S → x' + f y ∈ S → x + f y' ∈ S → x' + f y' ∈ S →
    x + y' ≠ x' + y

/-- The whole additive group is allowed, including torsion and noninvertible slopes. -/
theorem sumBoardSafe_iff (f : G →+ G) (S : Set G) :
    SumBoardSafe f S ↔ ∀ z h : G, h ≠ 0 → z ∈ S → z+h ∈ S →
      z+f h ∈ S → z+h+f h ∉ S := by
  constructor
  · intro safe z h hn hz hz₁ hz₂ hz₃
    have ne : z ≠ z+h := by simpa using hn
    exact safe z (z+h) 0 h ne hn.symm (by simpa using hz) (by simpa using hz₁)
      hz₂ hz₃ (by simp)
  · intro free x x' y y' hx _ h₀ h₁ h₂ h₃ equal
    have hd : y' = y + (x' - x) := calc
      y' = (x+y') - x := by abel
      _ = y + (x'-x) := by rw [equal]; abel
    subst y'
    apply free (x+f y) (x'-x) (sub_ne_zero.mpr hx.symm) h₀
    · convert h₁ using 1
      abel
    · simpa only [map_add, add_assoc] using h₂
    · rw [map_add] at h₃
      convert h₃ using 1
      abel

/-- Slope two prohibits precisely four equally spaced values with nonzero step. -/
theorem sumBoardSafe_double_iff (S : Set G) :
    SumBoardSafe (AddMonoidHom.id G + AddMonoidHom.id G) S ↔
      ∀ z h : G, h ≠ 0 → z ∈ S → z+h ∈ S → z+h+h ∈ S → z+h+h+h ∉ S := by
  rw [sumBoardSafe_iff]
  simp only [AddMonoidHom.add_apply, AddMonoidHom.id_apply, add_assoc]

end Erdos810
#print axioms Erdos810.sumBoardSafe_iff
#print axioms Erdos810.sumBoardSafe_double_iff
