import Mathlib.Data.Prod.Basic

/-! Coordinatewise products of properly labeled partial matrices with
rainbow rectangles. A symmetric matrix can have diagonal entries. Erasing
them keeps the rectangle property on the resulting simple graph. -/

set_option autoImplicit false

namespace Erdos810.ColorMatrixProduct

structure Board (R C K : Type*) where
  cell : R → C → Prop
  label : R → C → K

variable {R C K R' C' K' : Type*}

def RowProper (A : Board R C K) : Prop :=
  ∀ r c d, A.cell r c → A.cell r d → A.label r c = A.label r d → c = d

def ColProper (A : Board R C K) : Prop :=
  ∀ r s c, A.cell r c → A.cell s c → A.label r c = A.label s c → r = s

def Opposite (A : Board R C K) : Prop :=
  ∀ r s c d, A.cell r c → A.cell r d → A.cell s c → A.cell s d →
    r ≠ s → c ≠ d → A.label r c ≠ A.label s d

def Collapse (A : Board R C K) : Prop :=
  ∀ r s c d, A.cell r c → A.cell r d → A.cell s c → A.cell s d →
    A.label r c = A.label s d → r = s ∧ c = d

theorem collapse_iff (A : Board R C K) :
    Collapse A ↔ RowProper A ∧ ColProper A ∧ Opposite A := by
  constructor
  · intro h
    refine ⟨fun r c d hc hd he ↦ (h r r c d hc hd hc hd he).2,
      fun r s c hr hs he ↦ (h r s c c hr hr hs hs he).1, ?_⟩
    intro r s c d hrc hrd hsc hsd hrs _ h
    exact hrs ((‹Collapse A› r s c d hrc hrd hsc hsd h).1)
  · rintro ⟨hr, hc, ho⟩ r s c d hrc hrd hsc hsd he
    by_cases h : r = s
    · subst s
      exact ⟨rfl, hr r c d hrc hrd he⟩
    by_cases h' : c = d
    · subst d
      exact ⟨hc r s c hrc hsc he, rfl⟩
    exact False.elim (ho r s c d hrc hrd hsc hsd h h' he)

def product (A : Board R C K) (B : Board R' C' K') :
    Board (R × R') (C × C') (K × K') where
  cell r c := A.cell r.1 c.1 ∧ B.cell r.2 c.2
  label r c := (A.label r.1 c.1, B.label r.2 c.2)

theorem product_collapse {A : Board R C K} {B : Board R' C' K'}
    (hA : Collapse A) (hB : Collapse B) : Collapse (product A B) := by
  intro r s c d hrc hrd hsc hsd he
  have a := hA r.1 s.1 c.1 d.1 hrc.1 hrd.1 hsc.1 hsd.1 (congrArg Prod.fst he)
  have b := hB r.2 s.2 c.2 d.2 hrc.2 hrd.2 hsc.2 hsd.2 (congrArg Prod.snd he)
  exact ⟨Prod.ext a.1 b.1, Prod.ext a.2 b.2⟩

theorem restrict_collapse {A B : Board R C K} (hA : Collapse A)
    (sub : ∀ r c, B.cell r c → A.cell r c) (labels : B.label = A.label) : Collapse B := by
  intro r s c d hrc hrd hsc hsd he
  rw [labels] at he
  exact hA r s c d (sub _ _ hrc) (sub _ _ hrd) (sub _ _ hsc) (sub _ _ hsd) he

end Erdos810.ColorMatrixProduct
