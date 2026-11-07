import HypergraphReduction

/-!
Independent semantic checks for HypergraphReduction.lean.
These prove that the hypothesis named `h74` there is exactly the rainbow-C4
condition (when symmetry is supplied), and demonstrate a rainbow-C4 graph
whose lifted triples violate actual (7,4)-freeness.
-/

namespace Erdos810SemanticAudit
open Erdos810Structural

theorem numDistinctFour_eq_four_of_nodup {V : Type u} [DecidableEq V]
    {a b c d : V} (h : NodupFour a b c d) : numDistinctFour a b c d = 4 := by
  obtain ⟨hab, hac, had, hbc, hbd, hcd⟩ := h
  simp [numDistinctFour, hab, hac, had, hbc, hbd, hcd]

theorem cycle_vertices_nodup {V : Type u} (G : Graph V) {a b c d : V}
    (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d) (hda : G.Adj d a)
    (hac : a ≠ c) (hbd : b ≠ d) : NodupFour a b c d := by
  refine ⟨?_, hac, ?_, ?_, hbd, ?_⟩
  · intro h; subst b; exact G.loopless a hab
  · intro h; subst d; exact G.loopless a hda
  · intro h; subst c; exact G.loopless b hbc
  · intro h; subst d; exact G.loopless c hcd

/-- The local `h74` condition contains no more information than rainbow C4. -/
theorem rainbow_iff_local_span {V : Type u} {K : Type v}
    [DecidableEq V] [DecidableEq K] (G : Graph V) (C : V → V → K)
    (hsym : ∀ u v, C u v = C v u) :
    IsRainbowForC4 G C ↔
      ∀ a b c d, G.Adj a b → G.Adj b c → G.Adj c d → G.Adj d a →
        a ≠ c → b ≠ d → 7 < cycleTripleSpan C a b c d := by
  constructor
  · intro hr a b c d hab hbc hcd hda hac hbd
    have hv := numDistinctFour_eq_four_of_nodup
      (cycle_vertices_nodup G hab hbc hcd hda hac hbd)
    have hc := numDistinctFour_eq_four_of_nodup
      (hr.2 a b c d hab hbc hcd hda hac hbd)
    simp [cycleTripleSpan, hv, hc]
  · exact isRainbowForC4_of_seven_four_free G C hsym

/-- The monochromatic star K1,4, with vertex 0 as its center. -/
def star : Graph (Fin 5) where
  Adj u v := (u = 0 ∧ v ≠ 0) ∨ (v = 0 ∧ u ≠ 0)
  symm := by intro u v h; exact h.elim Or.inr Or.inl
  loopless := by intro u h; exact h.elim (fun h => h.2 h.1) (fun h => h.2 h.1)

theorem star_no_C4 :
    ∀ a b c d : Fin 5, star.Adj a b → star.Adj b c → star.Adj c d →
      star.Adj d a → a ≠ c → b ≠ d → False := by
  intro a b c d hab hbc _hcd hda hac hbd
  apply Or.elim hab
  · intro hab
    apply Or.elim hbc
    · intro hbc; exact hab.2 hbc.1
    · intro hbc; exact hac (hab.1.trans hbc.1.symm)
  · intro hab
    apply Or.elim hda
    · intro hda; exact hbd (hab.1.trans hda.1.symm)
    · intro hda; exact hab.2 hda.1

theorem monochromatic_star_rainbow : IsRainbowForC4 star (fun _ _ => (0 : Nat)) := by
  refine ⟨fun _ _ => rfl, ?_⟩
  intro a b c d hab hbc hcd hda hac hbd
  exact False.elim (star_no_C4 a b c d hab hbc hcd hda hac hbd)

/-- Four distinct lifted edges of the star, written as vertex/color-tagged lists. -/
def starTriples : List (List (Sum (Fin 5) Nat)) :=
  [[.inl 0, .inl 1, .inr 0], [.inl 0, .inl 2, .inr 0],
   [.inl 0, .inl 3, .inr 0], [.inl 0, .inl 4, .inr 0]]

theorem star_four_distinct_triples : starTriples.length = 4 ∧ starTriples.Nodup := by
  decide

theorem star_triples_each_three_points : ∀ t ∈ starTriples, t.length = 3 ∧ t.Nodup := by
  decide

theorem star_triples_span_six : (starTriples.flatten.eraseDups).length = 6 := by
  decide

end Erdos810SemanticAudit

#print axioms Erdos810SemanticAudit.rainbow_iff_local_span
#print axioms Erdos810SemanticAudit.monochromatic_star_rainbow
#print axioms Erdos810SemanticAudit.star_four_distinct_triples
#print axioms Erdos810SemanticAudit.star_triples_each_three_points
#print axioms Erdos810SemanticAudit.star_triples_span_six
