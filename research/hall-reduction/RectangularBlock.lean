import SharedEdgeBlock
import Mathlib.Tactic.Ring

/-! # A proper rainbow coloring of a punctured rectangular block

The injection pairs private left indices with distinct private right indices.
The two distinguished indices are represented by none in both parts. -/

set_option autoImplicit false
namespace Erdos810.SharedEdgeBlock
namespace Rectangular

variable {I J : Type*}

def Present (a : Option I) (b : Option J) : Prop := a ≠ none ∨ b ≠ none

abbrev Color (I J : Type*) := (Option I × J) ⊕ (Option I ⊕ Option J)

def labels (e : I ↪ J) : Labels (Option I) (Option J) (Color I J) where
  cross a b := match a,b with
    | a, some j => .inl (a,j)
    | some i, none => .inl (none,e i)
    | none, none => .inr (.inl none)
  left a := .inr (.inl a)
  right b := .inr (.inr b)

variable (e : I ↪ J)

theorem rectangle (a a' : Option I) (b b' : Option J) (ha : a ≠ a') (hb : b ≠ b')
    (p : Present a b) (q : Present a' b) (r : Present a' b') (s : Present a b') :
    DistinctFour ((labels e).cross a b) ((labels e).cross a' b)
      ((labels e).cross a' b') ((labels e).cross a b') := by
  cases a <;> cases a' <;> cases b <;> cases b' <;>
    simp_all [Present, labels] <;> constructor <;> simp_all <;> aesop

theorem left_cycle (a a' : Option I) (b : Option J) (ha : a ≠ a')
    (p : Present a b) (q : Present a' b) :
    DistinctFour ((labels e).left a) ((labels e).cross a b)
      ((labels e).cross a' b) ((labels e).left a') := by
  cases a <;> cases a' <;> cases b <;>
    simp_all [Present, labels] <;> constructor <;> simp_all

theorem right_cycle (a : Option I) (b b' : Option J) (hb : b ≠ b')
    (p : Present a b) (q : Present a b') :
    DistinctFour ((labels e).right b) ((labels e).cross a b)
      ((labels e).cross a b') ((labels e).right b') := by
  cases a <;> cases b <;> cases b' <;>
    simp_all [Present, labels] <;> constructor <;> simp_all

theorem proper_apex :
    Function.Injective (Sum.elim (labels e).left (labels e).right) := by
  rintro (a | a) (b | b) eq <;> simp_all [labels]

theorem row_column (a a' : Option I) (b b' : Option J)
    (p : Present a b) (q : Present a' b')
    (incident : (a=a' ∧ b≠b') ∨ (b=b' ∧ a≠a')) :
    (labels e).cross a b ≠ (labels e).cross a' b' := by
  cases a <;> cases a' <;> cases b <;> cases b' <;> simp_all [Present, labels]
  all_goals aesop

theorem spoke_ne_cross (a x : Option I) (b : Option J) (y : Option J) (p : Present a b) :
    (labels e).left x ≠ (labels e).cross a b ∧
    (labels e).right y ≠ (labels e).cross a b := by
  cases a <;> cases b <;> simp_all [Present, labels]

theorem palette_card [Fintype I] [Fintype J] :
    Fintype.card (Color I J) = (Fintype.card I + 2)*(Fintype.card J + 1) := by
  simp [Color]
  ring

end Rectangular
end Erdos810.SharedEdgeBlock
