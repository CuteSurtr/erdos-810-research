import IntervalWindows
import Mathlib.Combinatorics.Pigeonhole

/-! # Combinatorial consequences of rank-two halfspace charts -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810

/-- A single chart of a rank-two strict sign realization consists of prefixes and suffixes. -/
structure RayNeighborhoods {V : Type*} [LinearOrder V] (G : SimpleGraph V) where
  isPrefix : V → Bool
  lower : ∀ v, isPrefix v = true → ∀ x y, x ≤ y → G.Adj v y → G.Adj v x
  upper : ∀ v, isPrefix v = false → ∀ x y, x ≤ y → G.Adj v x → G.Adj v y

/-- The lower vertex of an edge has a suffix and the upper one a prefix. -/
theorem RayNeighborhoods.edge_direction {V : Type*} [LinearOrder V] {G : SimpleGraph V}
    (C : RayNeighborhoods G) {u v : V} (huv : u < v) (edge : G.Adj u v) :
    C.isPrefix u = false ∧ C.isPrefix v = true := by
  constructor
  · cases h : C.isPrefix u with
    | false => rfl
    | true => exact (G.loopless u (C.lower u h u v huv.le edge)).elim
  · cases h : C.isPrefix v with
    | true => rfl
    | false => exact (G.loopless v (C.upper v h u v huv.le edge.symm)).elim

/-- Prefix vertices on the same side have comparable neighborhoods. -/
theorem RayNeighborhoods.nested_prefixes {V : Type*} [LinearOrder V] {G : SimpleGraph V}
    (C : RayNeighborhoods G) {u v : V} (hu : C.isPrefix u = true) (hv : C.isPrefix v = true) :
    G.neighborSet u ⊆ G.neighborSet v ∨ G.neighborSet v ⊆ G.neighborSet u := by
  classical
  by_contra! h
  obtain ⟨x, hx, hnx⟩ := Set.not_subset.mp h.1
  obtain ⟨y, hy, hny⟩ := Set.not_subset.mp h.2
  rcases le_total x y with hxy | hyx
  · exact hnx (C.lower v hv x y hxy hy)
  · exact hny (C.lower u hu y x hyx hx)

/-- A large class among four nested lists forces a full rectangle of the given sizes. -/
theorem four_chart_palette {V K : Type*} [Fintype K] {G : SimpleGraph V}
    (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4)) (cols : Finset V)
    (tag : V → Fin 4) (rows : V → Finset V) (a b : ℕ) (ha : 1 < a) (hb : 1 < b)
    (number : 4*(b-1) < cols.card) (large : ∀ x ∈ cols, a ≤ (rows x).card)
    (full : ∀ x ∈ cols, ∀ y ∈ rows x, G.Adj x y)
    (nested : ∀ x ∈ cols, ∀ y ∈ cols, tag x = tag y → rows x ⊆ rows y ∨ rows y ⊆ rows x) :
    a*b ≤ Fintype.card K := by
  classical
  obtain ⟨t, _, ht⟩ := Finset.exists_lt_card_fiber_of_mul_lt_card_of_maps_to
    (s := cols) (t := Finset.univ) (f := tag) (n := b-1)
    (fun _ _ ↦ Finset.mem_univ _) (by simpa using number)
  let S := cols.filter (fun x ↦ tag x = t)
  have cardS : b ≤ S.card := by change b-1 < S.card at ht; omega
  obtain ⟨x, hx, least⟩ := S.exists_min_image (fun y ↦ (rows y).card)
    (Finset.card_pos.mp (by omega))
  have hx' := Finset.mem_filter.mp hx
  have contain (y : V) (hy : y ∈ S) : rows x ⊆ rows y := by
    have hy' := Finset.mem_filter.mp hy
    rcases nested x hx'.1 y hy'.1 (hx'.2.trans hy'.2.symm) with h | h
    · exact h
    · have eq := Finset.eq_of_subset_of_card_le h (least y hy)
      rw [eq]
  have hw := rectangle_palette_bound C hr (rows x) S (ha.trans_le (large x hx'.1))
    (hb.trans_le cardS) (fun z hz y hy ↦ (full y (Finset.mem_filter.mp hy).1 _ (contain y hy hz)).symm)
  exact (Nat.mul_le_mul (large x hx'.1) cardS).trans hw

end Erdos810
#assert_no_sorry Erdos810.RayNeighborhoods.edge_direction Erdos810.RayNeighborhoods.nested_prefixes
  Erdos810.four_chart_palette
