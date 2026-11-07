import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Finset.Union
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic

/-!
Finite certificate used in the extremal-only replacement argument.
Two isolated three-edge components on five vertices each can be replaced by
this seven-edge, linear, (7,4)-free triple system on the same ten vertices.
The extremal replacement argument itself is given separately in prose.
-/

namespace Erdos810ExtremalReplacement

set_option maxRecDepth 20000
set_option maxHeartbeats 1000000

def gadget : Finset (Finset (Fin 10)) :=
  {{4, 5, 7}, {3, 4, 9}, {2, 4, 8}, {1, 8, 9}, {3, 6, 7}, {0, 5, 8}, {0, 1, 6}}

theorem gadget_card : gadget.card = 7 := by decide

theorem gadget_uniform : ∀ e ∈ gadget, e.card = 3 := by decide

theorem gadget_linear : ∀ e ∈ gadget, ∀ f ∈ gadget, e ≠ f → (e ∩ f).card ≤ 1 := by
  decide

def indexedTriple : Fin 7 → Finset (Fin 10) :=
  ![{4, 5, 7}, {3, 4, 9}, {2, 4, 8}, {1, 8, 9}, {3, 6, 7}, {0, 5, 8}, {0, 1, 6}]

theorem indexedTriple_image : Finset.univ.image indexedTriple = gadget := by decide

theorem indexedTriple_injective : Function.Injective indexedTriple := by decide

/-- All 35 increasing quadruples of distinct indexed triples satisfy the union bound. -/
theorem gadget_all_increasing_quadruples : ∀ a b c d : Fin 7,
    a < b → b < c → c < d →
      7 < (indexedTriple a ∪ indexedTriple b ∪ indexedTriple c ∪ indexedTriple d).card := by
  intro a b c d hab hbc hcd
  fin_cases a <;> fin_cases b <;> norm_num at hab
  all_goals fin_cases c <;> norm_num at hbc
  all_goals fin_cases d <;> norm_num at hcd
  all_goals decide

end Erdos810ExtremalReplacement

#print axioms Erdos810ExtremalReplacement.gadget_card
#print axioms Erdos810ExtremalReplacement.gadget_uniform
#print axioms Erdos810ExtremalReplacement.gadget_linear
#print axioms Erdos810ExtremalReplacement.indexedTriple_image
#print axioms Erdos810ExtremalReplacement.indexedTriple_injective
#print axioms Erdos810ExtremalReplacement.gadget_all_increasing_quadruples
