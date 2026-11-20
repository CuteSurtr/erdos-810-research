import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-! # Color counts for two partitions of a shared set

An anchored grid omits at most δ labels. Every constrained spoke whose color
belongs to its anchor yields a monochromatic incident pair. The accompanying
graph proof verifies the incidence assumptions for all four grids in each group.
-/

set_option autoImplicit false
open scoped BigOperators
namespace Erdos810.CrossedRectangles

/-- Any constrained spoke outside the supply of collision partners also lies
outside the anchor. The palette slack therefore bounds the number of exceptions. -/
theorem forced_card {K : Type*} [Fintype K] [DecidableEq K]
    (spokes anchor partners : Finset K) (δ : ℕ)
    (blocked : spokes ∩ anchor ⊆ partners)
    (slack : Fintype.card K ≤ anchor.card + δ) :
    spokes.card ≤ (spokes ∩ partners).card + δ := by
  have hsub : spokes \ partners ⊆ Finset.univ \ anchor := by
    intro x hx
    obtain ⟨hs, hp⟩ := Finset.mem_sdiff.mp hx
    exact Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, fun ha =>
      hp (blocked (Finset.mem_inter.mpr ⟨hs, ha⟩))⟩
  have h := Finset.card_le_card hsub
  rw [Finset.card_sdiff_of_subset (Finset.subset_univ anchor), Finset.card_univ] at h
  have parts := Finset.card_sdiff_add_card_inter spokes partners
  have ha := Finset.card_le_univ anchor
  omega

/-- Distinct selected pairs have disjoint edge sets. Every proper restriction
hits them all, even if the one distinguished hub edge is used as a partner. -/
theorem aggregate_forced {I K E : Type*} [Fintype I] [Fintype K]
    [DecidableEq K] [DecidableEq E]
    (spokes anchors partners : I → Finset K) (s δ : ℕ)
    (size : ∀ i, (spokes i).card = s)
    (blocked : ∀ i, spokes i ∩ anchors i ⊆ partners i)
    (slack : ∀ i, Fintype.card K ≤ (anchors i).card + δ)
    (pairs : (g : Σ i, ↥(spokes i ∩ partners i)) → Finset E)
    (separate : ∀ a b, a ≠ b → Disjoint (pairs a) (pairs b))
    (removed : Finset E) (hit : ∀ a, ∃ e ∈ pairs a, e ∈ removed) :
    Fintype.card I * (s-δ) ≤ removed.card := by
  classical
  choose edge he hr using hit
  let pick (a : Σ i, ↥(spokes i ∩ partners i)) : ↥removed := ⟨edge a, hr a⟩
  have inj : Function.Injective pick := by
    intro a b eq
    by_contra ne
    have same : edge a = edge b := congrArg Subtype.val eq
    exact Finset.disjoint_left.mp (separate a b ne) (he a) (same ▸ he b)
  have upper := Fintype.card_le_of_injective pick inj
  simp only [Fintype.card_sigma, Fintype.card_coe] at upper
  have bound : ∀ i, s-δ ≤ (spokes i ∩ partners i).card := by
    intro i
    have h := forced_card (spokes i) (anchors i) (partners i) δ (blocked i) (slack i)
    rw [size i] at h
    omega
  simpa using (Finset.sum_le_sum (s := Finset.univ) (fun i _ => bound i)).trans upper

/-- A palette of 2m labels splits into two equal lists avoiding the respective
forbidden sets when those sets are disjoint and each has at most m labels. -/
theorem half_grid {K : Type*} [DecidableEq K] (pool left right : Finset K) (m : ℕ)
    (total : pool.card = 2*m) (hl : left.card ≤ m) (hr : right.card ≤ m)
    (apart : Disjoint left right) :
    ∃ take ⊆ pool, take.card = m ∧ (pool \ take).card = m ∧
      Disjoint take left ∧ Disjoint (pool \ take) right := by
  have sub : pool ∩ right ⊆ pool \ left := by
    intro x hx
    obtain ⟨hp, hright⟩ := Finset.mem_inter.mp hx
    exact Finset.mem_sdiff.mpr ⟨hp, fun hleft => Finset.disjoint_left.mp apart hleft hright⟩
  have small := (Finset.card_le_card (Finset.inter_subset_right (s₁:=pool) (s₂:=right))).trans hr
  have hc := Finset.card_le_card (Finset.inter_subset_right (s₁:=pool) (s₂:=left))
  have parts := Finset.card_sdiff_add_card_inter pool left
  obtain ⟨take, covered, allowed, sized⟩ := Finset.exists_subsuperset_card_eq sub small
    (show m ≤ (pool \ left).card by omega)
  have fits := allowed.trans Finset.sdiff_subset
  refine ⟨take, fits, sized, ?_, ?_, ?_⟩
  · rw [Finset.card_sdiff_of_subset fits, total, sized]; omega
  · apply Finset.disjoint_left.mpr
    intro x hx hleft
    exact (Finset.mem_sdiff.mp (allowed hx)).2 hleft
  · apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (Finset.mem_sdiff.mp hx).2 (covered (Finset.mem_inter.mpr ⟨(Finset.mem_sdiff.mp hx).1, hy⟩))

/-- The square sequence uses s = 6q, q groups and (6q+1)^2 vertices. -/
theorem square_sequence (q : ℕ) (hq : 1 ≤ q) :
    2 + q*(6*(6*q)) ≤ (6*q+1)^2 ∧
    (6*q+1)^2 < 2+(q+1)*(6*(6*q)) ∧
    3*(4*q*(6*q)) = 2*(6*q)^2 := by
  constructor
  · nlinarith
  constructor
  · nlinarith
  · ring

end Erdos810.CrossedRectangles
