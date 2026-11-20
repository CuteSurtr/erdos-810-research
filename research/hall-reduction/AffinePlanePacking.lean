import StarRestriction
import RestrictionMap
import Mathlib.Data.ZMod.Basic

/-! # A finite-field incidence example with a sharp proper-restriction count -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810.AffinePlanePacking

variable (F : Type*) [Field F]

/-- Each line supplies one monochromatic star, with one point for every horizontal coordinate. -/
def board : StarBoard (F × F) Unit F F (F × F) where
  coordinate line _ x := line.1*x+line.2
  label line _ := line
  distinguish _ _ := fun _ _ _ ↦ Subsingleton.elim _ _

theorem rectangles : (board F).RainbowRectangles := by
  intro p q _ _ _ _ x y pq different first second
  have xy : x ≠ y := by rintro rfl; exact different rfl
  change p.1*x+p.2=q.1*x+q.2 at first
  change p.1*y+p.2=q.1*y+q.2 at second
  have eq : (p.1-q.1)*(x-y)=0 := by linear_combination first-second
  have slope := sub_eq_zero.mp ((mul_eq_zero.mp eq).resolve_right (sub_ne_zero.mpr xy))
  rw [slope] at first
  have intercept := add_left_cancel first
  exact False.elim (pq (Prod.ext slope intercept))

/-- On 2p² vertices the graph has p³ edges, and its largest proper restriction has exactly p². -/
theorem prime_example (p : ℕ) [Fact p.Prime] :
    ∃ (G : SimpleGraph (Fin (2*p^2))) (C : G.EdgeLabeling (Fin (2*p^2))),
      C.IsRainbowFor (cycleGraph 4) ∧ G.edgeSet.ncard=p^3 ∧ ProperRestrictionSize C (p^2) ∧
      ∀ q, ProperRestrictionSize C q → q ≤ p^2 := by
  let F := ZMod p
  let B := board F
  let V := StarBoard.Vertex (F × F) F F
  have size : Fintype.card V=2*p^2 := by simp [V,StarBoard.Vertex,F,ZMod.card]; ring
  have pal : Fintype.card (F×F)=p^2 := by simp [F,ZMod.card,pow_two]
  let f := (Fintype.equivFinOfCardEq size).toEmbedding
  let g := (Fintype.equivFinOfCardEq pal).toEmbedding.trans (Fin.castLEEmb (by omega : p^2 ≤ 2*p^2))
  obtain ⟨C,hr,eq⟩ := map_proper_restriction_sizes f g B.coloring (B.rainbow (rectangles F))
  refine ⟨B.graph.map f,C,hr,?_,?_,?_⟩
  · rw [map_edge_count,B.count_all,pal]
    simp [F,ZMod.card,pow_succ]
  · apply (eq _).mpr
    let t : F := 0
    refine ⟨B.oneTag t,B.oneTag_le t,B.oneTag_proper t (fun _ _ _ _ ↦ Subsingleton.elim _ _) (fun _ _ _ _ _ h ↦ h),?_⟩
    simp [B.oneTag_count,pal]
  · intro q hh
    obtain ⟨H,sub,hp,rfl⟩ := (eq q).mp hh
    simpa [pal] using B.count_proper H sub hp

end Erdos810.AffinePlanePacking
#assert_no_sorry Erdos810.AffinePlanePacking.prime_example
