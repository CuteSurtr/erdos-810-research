import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Union
import Mathlib.Data.Fintype.Fin
import Mathlib.Tactic
import HypergraphReduction

/-!
A stronger, fully finite separation example for the alleged hypergraph reduction.
The alternating 2-colored path on 5 vertices is bipartite and properly colored;
it is rainbow for C4, and its lifted triple system is linear. Nevertheless its
4 triples span exactly 7 points, so the actual (7,4)-free property fails.
-/

namespace Erdos810ProperLiftAudit
open Erdos810Structural
set_option maxRecDepth 10000

def pathAdj (u v : Fin 5) : Prop := u.val + 1 = v.val ∨ v.val + 1 = u.val

instance : DecidableRel pathAdj := fun _ _ => inferInstanceAs (Decidable (_ ∨ _))

def pathGraph : Graph (Fin 5) where
  Adj := pathAdj
  symm := fun h => h.elim Or.inr Or.inl
  loopless := by intro u; unfold pathAdj; omega

/-- The edge between i and i+1 has color i mod 2. -/
def pathColor (u v : Fin 5) : Fin 2 := ⟨min u.val v.val % 2, Nat.mod_lt _ (by decide)⟩

def IsProper {V K : Type*} (G : Graph V) (C : V → V → K) : Prop :=
  ∀ u v w, G.Adj u v → G.Adj u w → v ≠ w → C u v ≠ C u w

theorem pathColor_symmetric : ∀ u v : Fin 5, pathColor u v = pathColor v u := by
  decide

theorem pathColor_proper : IsProper pathGraph pathColor := by
  unfold IsProper pathGraph
  decide

theorem pathGraph_bipartite : ∀ u v : Fin 5, pathAdj u v →
    (u.val % 2 == 0) ≠ (v.val % 2 == 0) := by
  decide

theorem pathGraph_no_C4 : ∀ a b c d : Fin 5,
    pathAdj a b → pathAdj b c → pathAdj c d → pathAdj d a →
      a ≠ c → b ≠ d → False := by
  decide

theorem pathColor_rainbow_C4 : IsRainbowForC4 pathGraph pathColor := by
  refine ⟨pathColor_symmetric, ?_⟩
  intro a b c d hab hbc hcd hda hac hbd
  exact False.elim (pathGraph_no_C4 a b c d hab hbc hcd hda hac hbd)

/-- The actual triple associated with an edge, on a disjoint union of vertices and colors. -/
def liftTriple (u v : Fin 5) : Finset (Sum (Fin 5) (Fin 2)) :=
  {Sum.inl u, Sum.inl v, Sum.inr (pathColor u v)}

/-- Four lifted edges; these are all the edges of the underlying path. -/
def pathLift : Finset (Finset (Sum (Fin 5) (Fin 2))) :=
  {liftTriple 0 1, liftTriple 1 2, liftTriple 2 3, liftTriple 3 4}

/-- Actual global (7,4)-freeness: every four distinct triples span more than seven points. -/
def IsSevenFourFree {X : Type*} [DecidableEq X] (H : Finset (Finset X)) : Prop :=
  ∀ F : Finset (Finset X), F ⊆ H → F.card = 4 → 7 < (F.biUnion id).card

def IsLinear {X : Type*} [DecidableEq X] (H : Finset (Finset X)) : Prop :=
  ∀ e ∈ H, ∀ f ∈ H, e ≠ f → (e ∩ f).card ≤ 1

theorem pathLift_is_exact_lift : ∀ u v : Fin 5,
    pathAdj u v ↔ liftTriple u v ∈ pathLift := by
  decide

theorem pathLift_four_edges : pathLift.card = 4 := by decide

theorem pathLift_uniform : ∀ e ∈ pathLift, e.card = 3 := by decide

theorem pathLift_linear : IsLinear pathLift := by
  unfold IsLinear
  decide

theorem pathLift_spans_seven : (pathLift.biUnion id).card = 7 := by decide

theorem pathLift_not_seven_four_free : ¬ IsSevenFourFree pathLift := by
  intro h
  have hh := h pathLift (Finset.Subset.refl _) pathLift_four_edges
  rw [pathLift_spans_seven] at hh
  exact (Nat.lt_irrefl 7) hh

/-- Properness, bipartiteness, and even linearity of the lift do not repair the claimed equivalence. -/
theorem proper_bipartite_counterexample :
    IsProper pathGraph pathColor ∧
    (∀ u v : Fin 5, pathAdj u v → (u.val % 2 == 0) ≠ (v.val % 2 == 0)) ∧
    IsRainbowForC4 pathGraph pathColor ∧
    (∀ e ∈ pathLift, e.card = 3) ∧ IsLinear pathLift ∧ ¬ IsSevenFourFree pathLift :=
  ⟨pathColor_proper, pathGraph_bipartite, pathColor_rainbow_C4,
    pathLift_uniform, pathLift_linear, pathLift_not_seven_four_free⟩

end Erdos810ProperLiftAudit

#print axioms Erdos810ProperLiftAudit.pathLift_is_exact_lift
#print axioms Erdos810ProperLiftAudit.proper_bipartite_counterexample
