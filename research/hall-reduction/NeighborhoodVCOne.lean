import IntervalWindows
import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-! # Local structure at open-neighborhood VC dimension one -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {V : Type*} {G : SimpleGraph V}

/-- No pair of vertices realizes all four membership patterns in open neighborhoods. -/
def OpenVCAtMostOne (G : SimpleGraph V) : Prop :=
  ∀ a b, ¬ ((∃ x, ¬G.Adj a x ∧ ¬G.Adj b x) ∧ (∃ x, G.Adj a x ∧ ¬G.Adj b x) ∧
    (∃ x, ¬G.Adj a x ∧ G.Adj b x) ∧ (∃ x, G.Adj a x ∧ G.Adj b x))

/-- Nonadjacent vertices with a common neighbor have comparable neighborhoods. -/
theorem vcOne_nested (h : OpenVCAtMostOne G) {a b : V} (hab : ¬G.Adj a b)
    (common : ∃ x, G.Adj a x ∧ G.Adj b x) :
    (∀ x, G.Adj a x → G.Adj b x) ∨ (∀ x, G.Adj b x → G.Adj a x) := by
  classical
  by_contra! H
  obtain ⟨⟨x,hax,hbx⟩,⟨y,hby,hay⟩⟩ := H
  exact h a b ⟨⟨b,hab,G.loopless b⟩,⟨x,hax,hbx⟩,⟨y,hay,hby⟩,common⟩

/-- An edge on a triangle dominates all vertices. -/
theorem vcOne_dominating (h : OpenVCAtMostOne G) {a b c : V}
    (ab : G.Adj a b) (ac : G.Adj a c) (bc : G.Adj b c) (x : V) : G.Adj a x ∨ G.Adj b x := by
  by_contra! hn
  exact h a b ⟨⟨x,hn⟩,⟨b,ab,G.loopless b⟩,⟨a,G.loopless a,ab.symm⟩,⟨c,ac,bc⟩⟩

/-- In the presence of a triangle, every pair of vertices has a common neighbor. -/
theorem vcOne_triangle_common (h : OpenVCAtMostOne G) {a b c : V}
    (ab : G.Adj a b) (ac : G.Adj a c) (bc : G.Adj b c) (u v : V) :
    ∃ x, G.Adj u x ∧ G.Adj v x := by
  have cover (t : V) : (G.Adj a t ∨ G.Adj b t) ∧ (G.Adj a t ∨ G.Adj c t) ∧
      (G.Adj b t ∨ G.Adj c t) :=
    ⟨vcOne_dominating h ab ac bc t, vcOne_dominating h ac ab bc.symm t,
      vcOne_dominating h bc ab.symm ac.symm t⟩
  have ucover := cover u
  have vcover := cover v
  have H : (G.Adj a u ∧ G.Adj a v) ∨ (G.Adj b u ∧ G.Adj b v) ∨
      (G.Adj c u ∧ G.Adj c v) := by tauto
  rcases H with ⟨hu,hv⟩ | ⟨hu,hv⟩ | ⟨hu,hv⟩
  · exact ⟨a,hu.symm,hv.symm⟩
  · exact ⟨b,hu.symm,hv.symm⟩
  · exact ⟨c,hu.symm,hv.symm⟩

/-- Nonadjacency gives the parts of the complete multipartite graph. -/
theorem vcOne_triangle_multipartite (h : OpenVCAtMostOne G) {a b c : V}
    (ab : G.Adj a b) (ac : G.Adj a c) (bc : G.Adj b c) :
    Equivalence (fun u v ↦ ¬G.Adj u v) := by
  refine ⟨G.loopless, fun H H' ↦ H H'.symm, ?_⟩
  intro u v w huv hvw huw
  obtain ⟨z,huz,hwz⟩ := vcOne_triangle_common h ab ac bc u w
  rcases vcOne_dominating h huw huz hwz v with H | H
  · exact huv H
  · exact hvw H.symm

/-- The exact forbidden local pattern behind the induced-path argument. -/
theorem vcOne_no_crossing_neighborhoods (h : OpenVCAtMostOne G) {a b x y z : V}
    (ab : ¬G.Adj a b) (ax : G.Adj a x) (bx : ¬G.Adj b x) (ay : ¬G.Adj a y) (by' : G.Adj b y)
    (az : G.Adj a z) (bz : G.Adj b z) : False := by
  rcases vcOne_nested h ab ⟨z,az,bz⟩ with H | H
  · exact bx (H x ax)
  · exact ay (H y by')

/-- This is the one-variable estimate determining the optimum hyperbola area. -/
theorem ferrers_log_envelope (z : ℝ) (hz : 0 < z) :
    1 + Real.log z ≤ 2 * Real.sqrt (z / Real.exp 1) := by
  have h := Real.add_one_le_exp ((Real.log z - 1) / 2)
  rw [Real.exp_half, Real.exp_sub, Real.exp_log hz] at h
  linarith

end Erdos810

#assert_no_sorry Erdos810.vcOne_triangle_multipartite Erdos810.vcOne_no_crossing_neighborhoods
#assert_no_sorry Erdos810.ferrers_log_envelope
