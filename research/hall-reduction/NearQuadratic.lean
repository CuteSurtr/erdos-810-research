import DiamondRecoloring
import Mathlib.Combinatorics.Extremal.RuzsaSzemeredi

/-! # The Behrend–Ruzsa–Szemerédi lower bound for Erdős problem 810

Mathlib's Ruzsa–Szemerédi number counts triangles in graphs where every
edge belongs to a unique triangle. Coloring each edge by the third vertex
of that triangle yields the required rainbow-four-cycle coloring.
-/

set_option autoImplicit false

open Filter Asymptotics Real SimpleGraph

namespace Erdos810

variable {V : Type*} [DecidableEq V] {G : SimpleGraph V}

/-- On a graph with edge-disjoint triangles, an edge has at most one common neighbor. -/
theorem unique_triangle_vertex (hG : G.EdgeDisjointTriangles) {u v a b : V}
    (huv : G.Adj u v) (hua : G.Adj u a) (hva : G.Adj v a) (hub : G.Adj u b) (hvb : G.Adj v b) :
    a = b := by
  by_contra hab
  have ha := is3Clique_triple_iff.mpr ⟨huv, hua, hva⟩
  have hb := is3Clique_triple_iff.mpr ⟨huv, hub, hvb⟩
  have hne : ({u, v, a} : Finset V) ≠ {u, v, b} := by
    intro he
    have hm := he ▸ (by simp : a ∈ ({u, v, a} : Finset V))
    simp [hua.ne.symm, hva.ne.symm, hab] at hm
  have hs := hG (mem_cliqueSet_iff.mpr ha) (mem_cliqueSet_iff.mpr hb) hne
  exact huv.ne (hs (x := u) ⟨by simp, by simp⟩ (y := v) ⟨by simp, by simp⟩)

private theorem labels_ne (hG : G.EdgeDisjointTriangles) {a b c p q : V}
    (hab : G.Adj a b) (hbc : G.Adj b c) (hac : a ≠ c)
    (hap : G.Adj a p) (hbp : G.Adj b p) (hcq : G.Adj c q) : p ≠ q := by
  rintro rfl
  exact hac (unique_triangle_vertex hG hbp hab.symm hap.symm hbc hcq.symm)

/-- Every graph whose edges each lie in a unique triangle admits a rainbow
four-cycle coloring by its own vertex set. -/
theorem rainbow_of_locallyLinear {n : ℕ} (G : SimpleGraph (Fin n)) (hG : G.LocallyLinear) :
    ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4) := by
  classical
  let H := G.cliqueFinset 3
  have hthree : ∀ t ∈ H, t.card = 3 := fun _ ht ↦ (mem_cliqueFinset_iff.mp ht).card_eq
  have same : twoShadow H = G := by
    ext a b
    constructor
    · rintro ⟨hne, t, ht, ha, hb⟩
      exact (mem_cliqueFinset_iff.mp ht).isClique ha hb hne
    · intro hab
      obtain ⟨t, ht, ha, hb⟩ := hG.2 hab
      exact ⟨hab.ne, t, mem_cliqueFinset_iff.mpr ht, ha, hb⟩
  obtain ⟨C, hC⟩ := exists_omitted_labeling hthree
  have hr : C.IsRainbowFor (cycleGraph 4) := by
    apply EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr
    intro a b c d ab bc cd da hac hbd
    have adj {u v : Fin n} (h : (twoShadow H).Adj u v) : G.Adj u v := same ▸ h
    have old {u v : Fin n} (h : (twoShadow H).Adj u v) :
        G.Adj u (C.get u v h) ∧ G.Adj v (C.get u v h) :=
      ⟨adj (hC u v h).left_adj, adj (hC u v h).right_adj⟩
    have h₁ := old ab
    have h₂ := old bc
    have h₃ := old cd
    have h₄ := old da
    have h12 := labels_ne hG.1 (adj ab) (adj bc) hac h₁.1 h₁.2 h₂.2
    have h13 := labels_ne hG.1 (adj ab) (adj bc) hac h₁.1 h₁.2 h₃.1
    have h23 := labels_ne hG.1 (adj bc) (adj cd) hbd h₂.1 h₂.2 h₃.2
    have h24 := labels_ne hG.1 (adj bc) (adj cd) hbd h₂.1 h₂.2 h₄.1
    have h34 := labels_ne hG.1 (adj cd) (adj da) hac.symm h₃.1 h₃.2 h₄.2
    have h41 := labels_ne hG.1 (adj da) (adj ab) hbd.symm h₄.1 h₄.2 h₁.2
    simp [h12, h13, h41.symm, h23, h24, h34]
  exact same ▸ ⟨C, hr⟩

/-- Mathlib maximizes the triangle count; each such triangle contributes three graph edges. -/
theorem three_mul_ruzsaSzemerediNumber_le (n : ℕ) :
    3 * ruzsaSzemerediNumberNat n ≤ maxRainbowC4Edges n := by
  obtain ⟨G, inst, hcount, hlin⟩ := ruzsaSzemerediNumber_spec (α := Fin n)
  letI := inst
  obtain ⟨C, hr⟩ := rainbow_of_locallyLinear G hlin
  refine le_maxRainbowC4Edges_iff.mpr ⟨G, ?_, C, hr⟩
  rw [← G.coe_edgeFinset, Set.ncard_coe_finset, hlin.card_edgeFinset, hcount]
  rfl

/-- An explicit lower bound using Mathlib's formal Behrend construction. -/
theorem behrend_lower_bound (n : ℕ) :
    3 * ((n / 3 - 2 : ℝ) * (((n - 3) / 6 : ℕ) : ℝ) *
      exp (-4 * √(log (((n - 3) / 6 : ℕ) : ℝ)))) ≤ (maxRainbowC4Edges n : ℝ) := by
  have h : 3 * (ruzsaSzemerediNumberNat n : ℝ) ≤ (maxRainbowC4Edges n : ℝ) := by
    exact_mod_cast three_mul_ruzsaSzemerediNumber_le n
  linarith only [h, ruzsaSzemerediNumberNat_lower_bound n]

/-- A machine-checked near-quadratic lower bound on the unrestricted extremal function. -/
theorem near_quadratic_lower_bound :
    (fun n : ℕ ↦ (n : ℝ) ^ 2 * exp (-4 * √(log n))) =O[atTop]
      fun n ↦ (maxRainbowC4Edges n : ℝ) := by
  apply ruzsaSzemerediNumberNat_asymptotic_lower_bound.trans
  apply IsBigO.of_norm_eventuallyLE
  apply Filter.Eventually.of_forall
  intro n
  simp only [Real.norm_natCast]
  exact_mod_cast (show ruzsaSzemerediNumberNat n ≤ maxRainbowC4Edges n by
    have := three_mul_ruzsaSzemerediNumber_le n
    omega)

end Erdos810

#assert_no_sorry
  Erdos810.rainbow_of_locallyLinear
  Erdos810.behrend_lower_bound
  Erdos810.near_quadratic_lower_bound
