import DiamondHub

/-! # A low-degree vertex among the four vertices of an ordinary diamond -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

/-- A diamond contributes ten internal degree incidences and two new spokes.
Every other original vertex contributes at most one boundary incidence. -/
theorem OrdinaryDiamond.exists_low_degree (D : OrdinaryDiamond H) (hn : 7 ≤ n)
    (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3) (A : Finset (Fin n))
    (hA : ∀ j, D.point j ∈ A ↔ j ∈ spokeSites) :
    let G := hubGraph (twoShadow H) A
    ∃ v : Fin n, some v ∈ G.support ∧ (G.neighborSet (some v)).ncard ≤ (n + 8) / 4 := by
  classical
  let G := hubGraph (twoShadow H) A
  let r (i : Fin 4) (x : Option (Fin n)) := G.Adj (some (D.point i)) x
  let N (v : Option (Fin n)) := Finset.univ.bipartiteBelow r v
  have hub : (N none).card = 2 := by
    have he : N none = spokeSites := by
      ext i
      simpa only [N, Finset.mem_bipartiteBelow, Finset.mem_univ, true_and] using hA i
    rw [he]; decide
  have inside (j : Fin 4) : N (some (D.point j)) = (graphOfCert diamondTemplate).neighborFinset j := by
    ext i
    simp only [N, Finset.mem_bipartiteBelow, Finset.mem_univ, true_and, mem_neighborFinset]
    exact (D.adj_point_iff i j).trans ((graphOfCert diamondTemplate).adj_comm i j)
  have outside (x : Fin n) (hx : x ∉ D.support) : (N (some x)).card ≤ 1 := by
    apply Finset.card_le_one.mpr
    intro i hi j hj
    have hi' : (twoShadow H).Adj (D.point i) x := (Finset.mem_bipartiteBelow _).mp hi |>.2
    have hj' : (twoShadow H).Adj (D.point j) x := (Finset.mem_bipartiteBelow _).mp hj |>.2
    exact D.point.injective (D.unique_neighbor hn hf hthree hx (D.point_mem i) (D.point_mem j)
      hi'.symm hj'.symm)
  have innerSum : (∑ x ∈ D.support, (N (some x)).card) = 10 := by
    rw [OrdinaryDiamond.support, Finset.sum_map]
    simp only [inside]
    decide
  have outerSum : (∑ x ∈ (Finset.univ \ D.support), (N (some x)).card) ≤ n - 4 := calc
    _ ≤ ∑ _x ∈ (Finset.univ \ D.support), 1 :=
      Finset.sum_le_sum fun x hx ↦ outside x (Finset.mem_sdiff.mp hx).2
    _ = n - 4 := by simp [Finset.card_sdiff_of_subset (Finset.subset_univ _)]
  have oldSum : (∑ x : Fin n, (N (some x)).card) ≤ n + 6 := by
    have hs := Finset.sum_sdiff (f := fun x ↦ (N (some x)).card) (Finset.subset_univ D.support)
    rw [innerSum] at hs
    have he : (∑ x ∈ (Finset.univ \ D.support), (N (some x)).card) + 10 =
        ∑ x : Fin n, (N (some x)).card := hs
    omega
  have sumN : (∑ v : Option (Fin n), (N v).card) ≤ n + 8 := by
    rw [Fintype.sum_option, hub]
    omega
  have getNeighbors (i : Fin 4) : Finset.univ.bipartiteAbove r i = G.neighborFinset (some (D.point i)) := by
    ext x
    simp [Finset.mem_bipartiteAbove, mem_neighborFinset, r]
  have hcount := Finset.sum_card_bipartiteAbove_eq_sum_card_bipartiteBelow
    (s := (Finset.univ : Finset (Fin 4))) (t := Finset.univ) r
  change (∑ i : Fin 4, (Finset.univ.bipartiteAbove r i).card) = ∑ v : Option (Fin n), (N v).card at hcount
  simp only [getNeighbors] at hcount
  have low : ∃ i : Fin 4, (G.neighborFinset (some (D.point i))).card ≤ (n + 8) / 4 := by
    by_contra! hall
    have hsum := Finset.sum_le_sum (s := (Finset.univ : Finset (Fin 4)))
      (fun i _ ↦ show (n + 8) / 4 + 1 ≤ (G.neighborFinset (some (D.point i))).card from hall i)
    simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul] at hsum
    omega
  obtain ⟨i, hi⟩ := low
  have nab : ∀ i : Fin 4, ∃ j : Fin 4, (graphOfCert diamondTemplate).Adj i j := by decide
  obtain ⟨j, hj⟩ := nab i
  refine ⟨D.point i, ⟨some (D.point j), (D.adj_point_iff i j).mpr hj⟩, ?_⟩
  change (G.neighborSet (some (D.point i))).ncard ≤ _
  rw [Set.ncard_eq_toFinset_card']
  exact hi

end Erdos810

#assert_no_sorry Erdos810.OrdinaryDiamond.exists_low_degree
