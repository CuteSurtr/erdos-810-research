import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Union
import Mathlib.Tactic
import HypergraphReduction

/-!
An actual global hypergraph-to-rainbow extraction statement.
Unlike the source theorem's local hypothesis, `IsSevenFourFree` quantifies over
arbitrary four distinct triples. Vertex classes and colors are disjoint by type.
This is a structural implication, not an extremal density or novelty claim.
-/

namespace Erdos810GlobalExtraction
open Erdos810Structural

def IsSevenFourFree {X : Type*} [DecidableEq X] (H : Finset (Finset X)) : Prop :=
  ∀ F : Finset (Finset X), F ⊆ H → F.card = 4 → 7 < (F.biUnion id).card

def triple {L R K : Type*} [DecidableEq L] [DecidableEq R] [DecidableEq K]
    (x : L) (y : R) (k : K) : Finset (Sum (Sum L R) K) :=
  {Sum.inl (Sum.inl x), Sum.inl (Sum.inr y), Sum.inr k}

theorem triple_injective {L R K : Type*} [DecidableEq L] [DecidableEq R] [DecidableEq K]
    {x x' : L} {y y' : R} {k k' : K} (h : triple x y k = triple x' y' k') :
    x = x' ∧ y = y' ∧ k = k' := by
  have hx : Sum.inl (Sum.inl x) ∈ triple x' y' k' := h ▸ (by simp [triple])
  have hy : Sum.inl (Sum.inr y) ∈ triple x' y' k' := h ▸ (by simp [triple])
  have hk : Sum.inr k ∈ triple x' y' k' := h ▸ (by simp [triple])
  exact ⟨by simpa [triple] using hx, by simpa [triple] using hy,
    by simpa [triple] using hk⟩

theorem card_four_eq_numDistinctFour {X : Type*} [DecidableEq X] (a b c d : X) :
    ({a, b, c, d} : Finset X).card = numDistinctFour a b c d := by
  simp only [Finset.card_insert_eq_ite, Finset.card_singleton,
    Finset.mem_insert, Finset.mem_singleton, numDistinctFour]
  split_ifs <;> omega

/-- Every rectangle extracted from a global (7,4)-free triple family has four different colors.
The family need not be linear, and neither proper coloring nor cancellation is assumed. -/
theorem rectangle_rainbow_of_global_seven_four_free
    {L R K : Type*} [DecidableEq L] [DecidableEq R] [DecidableEq K]
    (H : Finset (Finset (Sum (Sum L R) K))) (h74 : IsSevenFourFree H)
    {a c : L} {b d : R} {k₁ k₂ k₃ k₄ : K}
    (hac : a ≠ c) (hbd : b ≠ d)
    (h₁ : triple a b k₁ ∈ H) (h₂ : triple c b k₂ ∈ H)
    (h₃ : triple c d k₃ ∈ H) (h₄ : triple a d k₄ ∈ H) :
    NodupFour k₁ k₂ k₃ k₄ := by
  let F : Finset (Finset (Sum (Sum L R) K)) :=
    {triple a b k₁, triple c b k₂, triple c d k₃, triple a d k₄}
  have h12 : triple a b k₁ ≠ triple c b k₂ := fun h => hac (triple_injective h).1
  have h13 : triple a b k₁ ≠ triple c d k₃ := fun h => hac (triple_injective h).1
  have h14 : triple a b k₁ ≠ triple a d k₄ := fun h => hbd (triple_injective h).2.1
  have h23 : triple c b k₂ ≠ triple c d k₃ := fun h => hbd (triple_injective h).2.1
  have h24 : triple c b k₂ ≠ triple a d k₄ := fun h => hbd (triple_injective h).2.1
  have h34 : triple c d k₃ ≠ triple a d k₄ := fun h => hac (triple_injective h).1.symm
  have hFcard : F.card = 4 := by simp [F, h12, h13, h14, h23, h24, h34]
  have hFsub : F ⊆ H := by
    intro e he
    simp only [F, Finset.mem_insert, Finset.mem_singleton] at he
    rcases he with rfl | rfl | rfl | rfl <;> assumption
  have hspan := h74 F hFsub hFcard
  by_contra hnd
  let V : Finset (Sum (Sum L R) K) :=
    {Sum.inl (Sum.inl a), Sum.inl (Sum.inl c), Sum.inl (Sum.inr b), Sum.inl (Sum.inr d)}
  let C : Finset (Sum (Sum L R) K) :=
    {Sum.inr k₁, Sum.inr k₂, Sum.inr k₃, Sum.inr k₄}
  have hV : V.card ≤ 4 := Finset.card_le_four
  have hC : C.card ≤ 3 := by
    dsimp only [C]
    rw [card_four_eq_numDistinctFour]
    apply numDistinctFour_le_three_of_not_nodupFour
    simpa [NodupFour] using hnd
  have hsub : F.biUnion id ⊆ V ∪ C := by
    intro z hz
    simp only [Finset.mem_biUnion, Finset.mem_insert, Finset.mem_singleton, F] at hz
    obtain ⟨e, he, hz⟩ := hz
    rcases he with rfl | rfl | rfl | rfl <;>
      simp only [triple, Finset.mem_insert, Finset.mem_singleton, id_eq] at hz <;>
      rcases hz with rfl | rfl | rfl <;> simp [V, C]
  have hle := (Finset.card_le_card hsub).trans (Finset.card_union_le V C)
  omega

/-- Graph-coloring corollary: every C4 of a bipartite graph extracted from H is rainbow. -/
theorem coloring_rainbow_of_global_seven_four_free
    {L R K : Type*} [DecidableEq L] [DecidableEq R] [DecidableEq K]
    (H : Finset (Finset (Sum (Sum L R) K))) (h74 : IsSevenFourFree H)
    (E : L → R → Prop) (C : L → R → K)
    (hlift : ∀ x y, E x y → triple x y (C x y) ∈ H)
    {a c : L} {b d : R} (hac : a ≠ c) (hbd : b ≠ d)
    (hab : E a b) (hcb : E c b) (hcd : E c d) (had : E a d) :
    NodupFour (C a b) (C c b) (C c d) (C a d) :=
  rectangle_rainbow_of_global_seven_four_free H h74 hac hbd
    (hlift a b hab) (hlift c b hcb) (hlift c d hcd) (hlift a d had)

/-- Global (7,4)-freeness also excludes alternating two-color paths on five vertices.
This is an obstruction beyond rainbow-C4, as the finite P5 counterexample demonstrates. -/
theorem no_alternating_path_of_global_seven_four_free
    {L R K : Type*} [DecidableEq L] [DecidableEq R] [DecidableEq K]
    (H : Finset (Finset (Sum (Sum L R) K))) (h74 : IsSevenFourFree H)
    {a c e : L} {b d : R} {p q : K}
    (hac : a ≠ c) (hae : a ≠ e) (hce : c ≠ e) (hbd : b ≠ d)
    (h₁ : triple a b p ∈ H) (h₂ : triple c b q ∈ H)
    (h₃ : triple c d p ∈ H) (h₄ : triple e d q ∈ H) : False := by
  let F : Finset (Finset (Sum (Sum L R) K)) :=
    {triple a b p, triple c b q, triple c d p, triple e d q}
  have h12 : triple a b p ≠ triple c b q := fun h => hac (triple_injective h).1
  have h13 : triple a b p ≠ triple c d p := fun h => hac (triple_injective h).1
  have h14 : triple a b p ≠ triple e d q := fun h => hae (triple_injective h).1
  have h23 : triple c b q ≠ triple c d p := fun h => hbd (triple_injective h).2.1
  have h24 : triple c b q ≠ triple e d q := fun h => hce (triple_injective h).1
  have h34 : triple c d p ≠ triple e d q := fun h => hce (triple_injective h).1
  have hFcard : F.card = 4 := by simp [F, h12, h13, h14, h23, h24, h34]
  have hFsub : F ⊆ H := by
    intro t ht
    simp only [F, Finset.mem_insert, Finset.mem_singleton] at ht
    rcases ht with rfl | rfl | rfl | rfl <;> assumption
  have hspan := h74 F hFsub hFcard
  let S : Finset (Sum (Sum L R) K) :=
    {Sum.inl (Sum.inl a), Sum.inl (Sum.inl c), Sum.inl (Sum.inl e),
      Sum.inl (Sum.inr b), Sum.inl (Sum.inr d), Sum.inr p, Sum.inr q}
  have hScard : S.card ≤ 7 :=
    (Finset.card_insert_le _ _).trans (Nat.succ_le_succ Finset.card_le_six)
  have hsub : F.biUnion id ⊆ S := by
    intro z hz
    simp only [Finset.mem_biUnion, Finset.mem_insert, Finset.mem_singleton, F] at hz
    obtain ⟨t, ht, hz⟩ := hz
    rcases ht with rfl | rfl | rfl | rfl <;>
      simp only [triple, Finset.mem_insert, Finset.mem_singleton, id_eq] at hz <;>
      rcases hz with rfl | rfl | rfl <;> simp [S]
  have hle := (Finset.card_le_card hsub).trans hScard
  omega

end Erdos810GlobalExtraction

#print axioms Erdos810GlobalExtraction.rectangle_rainbow_of_global_seven_four_free
#print axioms Erdos810GlobalExtraction.coloring_rainbow_of_global_seven_four_free
#print axioms Erdos810GlobalExtraction.no_alternating_path_of_global_seven_four_free
