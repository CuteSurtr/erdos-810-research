import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.Sum
import Mathlib.Data.Fintype.Prod
import Mathlib.Data.Fintype.Option
import Mathlib.Data.Fintype.Powerset

/-! # Colors retained on a complete tripartite block with a singleton part

Cross edges join the two large parts. Left and right spokes meet at the apex.
The three cycle assumptions enumerate the possible part patterns of a four-cycle.
-/

set_option autoImplicit false

namespace Erdos810.SharedEdgeBlock

variable {A B K : Type*}

abbrev Edge (A B : Type*) := (A × B) ⊕ (A ⊕ B)

structure Labels (A B K : Type*) where
  cross : A → B → K
  left : A → K
  right : B → K

def Labels.value (f : Labels A B K) : Edge A B → K
  | .inl (a,b) => f.cross a b
  | .inr (.inl a) => f.left a
  | .inr (.inr b) => f.right b

structure DistinctFour (i j k l : K) : Prop where
  one_two : i ≠ j
  one_three : i ≠ k
  one_four : i ≠ l
  two_three : j ≠ k
  two_four : j ≠ l
  three_four : k ≠ l

structure Rainbow (f : Labels A B K) : Prop where
  rectangle : ∀ a a' b b', a ≠ a' → b ≠ b' →
    DistinctFour (f.cross a b) (f.cross a' b) (f.cross a' b') (f.cross a b')
  leftCycle : ∀ a a' b, a ≠ a' →
    DistinctFour (f.left a) (f.cross a b) (f.cross a' b) (f.left a')
  rightCycle : ∀ a b b', b ≠ b' →
    DistinctFour (f.right b) (f.cross a b) (f.cross a b') (f.right b')

variable {f : Labels A B K}

theorem cross_injective (h : Rainbow f) :
    Function.Injective (fun p : A × B => f.cross p.1 p.2) := by
  rintro ⟨a,b⟩ ⟨a',b'⟩ eq
  by_cases ha : a=a'
  · subst a'
    by_cases hb : b=b'
    · subst b'
      rfl
    · exact False.elim ((h.rightCycle a b b' hb).two_three eq)
  · by_cases hb : b=b'
    · subst b'
      exact False.elim ((h.leftCycle a a' b ha).two_three eq)
    · exact False.elim ((h.rectangle a a' b b' ha hb).one_three eq)

theorem left_injective [Nonempty B] (h : Rainbow f) : Function.Injective f.left := by
  intro a a' eq
  by_contra ne
  exact (h.leftCycle a a' (Classical.choice ‹Nonempty B›) ne).one_four eq

theorem right_injective [Nonempty A] (h : Rainbow f) : Function.Injective f.right := by
  intro b b' eq
  by_contra ne
  exact (h.rightCycle (Classical.choice ‹Nonempty A›) b b' ne).one_four eq

theorem left_ne_cross [Nontrivial A] (h : Rainbow f) (a x : A) (b : B) :
    f.left a ≠ f.cross x b := by
  by_cases same : a=x
  · subst x
    obtain ⟨y,hy⟩ := exists_ne a
    exact (h.leftCycle a y b hy.symm).one_two
  · exact (h.leftCycle a x b same).one_three

theorem right_ne_cross [Nontrivial B] (h : Rainbow f) (b y : B) (a : A) :
    f.right b ≠ f.cross a y := by
  by_cases same : b=y
  · subst y
    obtain ⟨z,hz⟩ := exists_ne b
    exact (h.rightCycle a b z hz.symm).one_two
  · exact (h.rightCycle a b y same).one_three

/-- On a proper restriction the two kinds of retained apex spokes have different colors. -/
def ApexProperOn (f : Labels A B K) (S : Finset (Edge A B)) : Prop :=
  ∀ a b, Sum.inr (Sum.inl a) ∈ S → Sum.inr (Sum.inr b) ∈ S → f.left a ≠ f.right b

theorem retained_injective [Nontrivial A] [Nontrivial B] (h : Rainbow f)
    (S : Finset (Edge A B)) (p : ApexProperOn f S) :
    Function.Injective (fun e : S => f.value e.val) := by
  rintro ⟨x,hx⟩ ⟨y,hy⟩ eq
  apply Subtype.ext
  cases x with
  | inl x =>
    cases y with
    | inl y => exact congrArg Sum.inl (cross_injective h eq)
    | inr y =>
      cases y with
      | inl a => exact False.elim (left_ne_cross h a x.1 x.2 eq.symm)
      | inr b => exact False.elim (right_ne_cross h b x.2 x.1 eq.symm)
  | inr x =>
    cases x with
    | inl a =>
      cases y with
      | inl y => exact False.elim (left_ne_cross h a y.1 y.2 eq)
      | inr y =>
        cases y with
        | inl a' => exact congrArg (fun z : A => Sum.inr (Sum.inl z)) (left_injective h eq)
        | inr b => exact False.elim (p a b hx hy eq)
    | inr b =>
      cases y with
      | inl y => exact False.elim (right_ne_cross h b y.2 y.1 eq)
      | inr y =>
        cases y with
        | inl a => exact False.elim (p a b hy hx eq.symm)
        | inr b' => exact congrArg (fun z : B => Sum.inr (Sum.inr z)) (right_injective h eq)

theorem retained_le_palette [Fintype K] [Nontrivial A] [Nontrivial B] (h : Rainbow f)
    (S : Finset (Edge A B)) (p : ApexProperOn f S) : S.card ≤ Fintype.card K := by
  simpa using Fintype.card_le_of_injective _ (retained_injective h S p)

/-- Every inherited proper restriction loses at least the excess over the palette. -/
theorem edge_excess_le_deletions [Fintype A] [Fintype B] [Fintype K]
    [Nontrivial A] [Nontrivial B] [DecidableEq A] [DecidableEq B] (h : Rainbow f)
    (S : Finset (Edge A B)) (p : ApexProperOn f S) :
    Fintype.card A * Fintype.card B + Fintype.card A + Fintype.card B ≤
      Fintype.card K + (Finset.univ \ S).card := by
  have bound := retained_le_palette h S p
  have sub : S ⊆ (Finset.univ : Finset (Edge A B)) := Finset.subset_univ S
  rw [Finset.card_sdiff_of_subset sub]
  have total : (Finset.univ : Finset (Edge A B)).card =
      Fintype.card A * Fintype.card B + Fintype.card A + Fintype.card B := by
    simp [Edge, Nat.add_assoc]
  rw [total]
  omega


/-- The excess deletions must fall on private apex edges, even if every cross edge is removed. -/
theorem apex_excess_le_deletions [Fintype A] [Fintype B] [Fintype K]
    [Nontrivial A] [Nontrivial B] [DecidableEq A] [DecidableEq B] (h : Rainbow f)
    (T : Finset (A ⊕ B))
    (p : ∀ a b, Sum.inl a ∈ T → Sum.inr b ∈ T → f.left a ≠ f.right b) :
    Fintype.card A * Fintype.card B + Fintype.card A + Fintype.card B ≤
      Fintype.card K + (Finset.univ \ T).card := by
  let S : Finset (Edge A B) := (Finset.univ : Finset (A × B)).disjSum T
  have apex : ApexProperOn f S := by
    intro a b ha hb
    exact p a b (by simpa [S] using ha) (by simpa [S] using hb)
  have bound := retained_le_palette h S apex
  simp [S] at bound
  have sub : T ⊆ (Finset.univ : Finset (A ⊕ B)) := Finset.subset_univ T
  rw [Finset.card_sdiff_of_subset sub]
  simp only [Finset.card_univ, Fintype.card_sum]
  omega

/-- Add the losses over the blocks. An apex edge belongs to only one block in the gluing. -/
theorem sum_apex_excess {J : Type*} [Fintype J] [Fintype A] [Fintype B] [Fintype K]
    [Nontrivial A] [Nontrivial B] [DecidableEq A] [DecidableEq B]
    (labels : J → Labels A B K) (T : J → Finset (A ⊕ B))
    (rainbow : ∀ i, Rainbow (labels i))
    (proper : ∀ i a b, Sum.inl a ∈ T i → Sum.inr b ∈ T i →
      (labels i).left a ≠ (labels i).right b) :
    Fintype.card J * (Fintype.card A * Fintype.card B + Fintype.card A + Fintype.card B) ≤
      Fintype.card J * Fintype.card K + ∑ i, (Finset.univ \ T i).card := by
  classical
  have summed := Finset.sum_le_sum (s := Finset.univ) fun i _ =>
    apex_excess_le_deletions (rainbow i) (T i) (proper i)
  simpa [Finset.sum_add_distrib] using summed

/-- The missing row-column corner is represented by the pair of `none` indices. -/
def Present {I : Type*} (a b : Option I) : Prop := a ≠ none ∨ b ≠ none

abbrev PuncturedColor (I : Type*) := (Option I × I) ⊕ (Option I ⊕ Option I)

/-- The value on the missing corner is arbitrary. The incidence conditions exclude it. -/
def puncturedLabels (I : Type*) : Labels (Option I) (Option I) (PuncturedColor I) where
  cross a b := match a,b with
    | a, some j => .inl (a,j)
    | some i, none => .inl (none,i)
    | none, none => .inr (.inl none)
  left a := .inr (.inl a)
  right b := .inr (.inr b)

section Punctured

variable {I : Type*}

/-- Each of the four surviving edges of a rectangular cycle has a different label. -/
theorem punctured_rectangle (a a' b b' : Option I) (ha : a ≠ a') (hb : b ≠ b')
    (p : Present a b) (q : Present a' b) (r : Present a' b') (s : Present a b') :
    DistinctFour ((puncturedLabels I).cross a b) ((puncturedLabels I).cross a' b)
      ((puncturedLabels I).cross a' b') ((puncturedLabels I).cross a b') := by
  cases a <;> cases a' <;> cases b <;> cases b' <;>
    simp_all [Present, puncturedLabels] <;> constructor <;> simp_all <;> aesop

theorem punctured_left_cycle (a a' b : Option I) (ha : a ≠ a')
    (p : Present a b) (q : Present a' b) :
    DistinctFour ((puncturedLabels I).left a) ((puncturedLabels I).cross a b)
      ((puncturedLabels I).cross a' b) ((puncturedLabels I).left a') := by
  cases a <;> cases a' <;> cases b <;>
    simp_all [Present, puncturedLabels] <;> constructor <;> simp_all

theorem punctured_right_cycle (a b b' : Option I) (hb : b ≠ b')
    (p : Present a b) (q : Present a b') :
    DistinctFour ((puncturedLabels I).right b) ((puncturedLabels I).cross a b)
      ((puncturedLabels I).cross a b') ((puncturedLabels I).right b') := by
  cases a <;> cases b <;> cases b' <;>
    simp_all [Present, puncturedLabels] <;> constructor <;> simp_all

/-- Properness at the apex, including between spokes to opposite parts. -/
theorem punctured_spokes_injective :
    Function.Injective (Sum.elim (puncturedLabels I).left (puncturedLabels I).right) := by
  rintro (a | a) (b | b) eq <;> simp_all [puncturedLabels]

/-- Cross edges at a shared row or column have distinct labels. -/
theorem punctured_row_column (a a' b b' : Option I)
    (p : Present a b) (q : Present a' b')
    (incident : (a=a' ∧ b≠b') ∨ (b=b' ∧ a≠a')) :
    (puncturedLabels I).cross a b ≠ (puncturedLabels I).cross a' b' := by
  cases a <;> cases a' <;> cases b <;> cases b' <;>
    simp_all [Present, puncturedLabels]
  all_goals aesop

theorem punctured_spoke_ne_cross (a b x : Option I) (p : Present a b) :
    (puncturedLabels I).left x ≠ (puncturedLabels I).cross a b ∧
    (puncturedLabels I).right x ≠ (puncturedLabels I).cross a b := by
  cases a <;> cases b <;> simp_all [Present, puncturedLabels]

theorem punctured_palette_card [Fintype I] :
    Fintype.card (PuncturedColor I) =
      (Fintype.card I + 1) * (Fintype.card I + 2) := by
  simp [PuncturedColor, Nat.mul_add, Nat.add_assoc, Nat.mul_two]

end Punctured

end Erdos810.SharedEdgeBlock
