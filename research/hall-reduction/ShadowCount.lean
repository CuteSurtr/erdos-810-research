import ShadowReduction

/-! # Exact shadow counts for a family covered by ordinary diamonds -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

theorem pair_mem_shadowPairs {x y : Fin n} {t : Finset (Fin n)} :
    s(x, y) ∈ shadowPairs t ↔ x ≠ y ∧ x ∈ t ∧ y ∈ t := by
  constructor
  · intro h
    have ⟨hne, hs⟩ := shadowPair_endpoints h
    exact ⟨hne, hs (by simp), hs (by simp)⟩
  · rintro ⟨hne, hx, hy⟩
    exact Finset.mem_image.mpr ⟨(x, y), Finset.mem_offDiag.mpr ⟨hx, hy, hne⟩, rfl⟩

theorem card_shadowPairs (t : Finset (Fin n)) : (shadowPairs t).card = t.card.choose 2 :=
  Sym2.card_image_offDiag t

private theorem shadowPairs_inter (t s : Finset (Fin n)) :
    shadowPairs (t ∩ s) = shadowPairs t ∩ shadowPairs s := by
  ext e
  induction e using Sym2.ind with
  | _ x y => simp only [pair_mem_shadowPairs, Finset.mem_inter]; tauto

theorem shadow_edge_count (H : Finset (Finset (Fin n))) :
    (twoShadow H).edgeSet.ncard = (H.biUnion shadowPairs).card := by
  classical
  have he : (twoShadow H).edgeSet = ↑(H.biUnion shadowPairs) := by
    ext e
    induction e using Sym2.ind with
    | _ x y =>
      change (x ≠ y ∧ ∃ t ∈ H, x ∈ t ∧ y ∈ t) ↔ _
      simp only [Finset.mem_coe, Finset.mem_biUnion, pair_mem_shadowPairs]
      grind
  rw [he, Set.ncard_coe_finset]

namespace OrdinaryDiamond

variable (D : OrdinaryDiamond H)

def sides : Finset (Finset (Fin n)) := {diamondLeft.map D.point, diamondRight.map D.point}

@[simp] theorem card_sides : D.sides.card = 2 := by simp [sides, D.left_ne_right]

theorem sides_subset : D.sides ⊆ H := by
  simp [sides, Finset.insert_subset_iff, D.left_mem, D.right_mem]

theorem subset_of_mem_sides {t : Finset (Fin n)} (ht : t ∈ D.sides) : t ⊆ D.support := by
  rcases Finset.mem_insert.mp ht with rfl | he
  · exact D.side_subset _
  · exact (Finset.mem_singleton.mp he) ▸ D.side_subset _

theorem card_side_inter : ((diamondLeft.map D.point) ∩ (diamondRight.map D.point)).card = 2 := by
  rw [← Finset.map_inter, Finset.card_map]
  decide

theorem nonlinear_side {t : Finset (Fin n)} (ht : t ∈ D.sides) : ¬ IsLinearMember H t := by
  intro hl
  rcases Finset.mem_insert.mp ht with rfl | he
  · have h := hl _ D.right_mem D.left_ne_right.symm
    rw [D.card_side_inter] at h
    omega
  · obtain rfl := Finset.mem_singleton.mp he
    have h := hl _ D.left_mem D.left_ne_right
    rw [Finset.inter_comm, D.card_side_inter] at h
    omega

theorem mem_sides_of_subset (hthree : ∀ t ∈ H, t.card = 3) {t : Finset (Fin n)}
    (ht : t ∈ H) (hs : t ⊆ D.support) : t ∈ D.sides := by
  by_contra hn
  simp only [sides, Finset.mem_insert, Finset.mem_singleton, not_or] at hn
  have hh := D.external t ht hn.1 hn.2
  change (t ∩ D.support).card ≤ 1 at hh
  rw [Finset.inter_eq_left.mpr hs, hthree t ht] at hh
  omega

/-- The two triples in a diamond contribute five distinct pairs. -/
theorem five_shadow_pairs : (D.sides.biUnion shadowPairs).card = 5 := by
  simp only [sides, Finset.biUnion_insert, Finset.singleton_biUnion]
  have hh := Finset.card_union_add_card_inter (shadowPairs (diamondLeft.map D.point))
    (shadowPairs (diamondRight.map D.point))
  rw [← shadowPairs_inter, card_shadowPairs, D.card_side_inter, card_shadowPairs,
    card_shadowPairs, Finset.card_map, Finset.card_map,
    show diamondLeft.card = 3 by decide, show diamondRight.card = 3 by decide] at hh
  norm_num [Nat.choose] at hh
  omega

end OrdinaryDiamond

private theorem disjoint_linear_pairs {t s : Finset (Fin n)} (hs : s ∈ H) (hne : s ≠ t)
    (hl : IsLinearMember H t) : Disjoint (shadowPairs t) (shadowPairs s) := by
  apply Finset.disjoint_left.mpr
  intro e he hf
  have hsize := Finset.card_le_card (Finset.subset_inter (shadowPair_endpoints he).2
    (shadowPair_endpoints hf).2)
  rw [Sym2.card_toFinset_of_not_isDiag e (shadowPair_endpoints he).1] at hsize
  have hsmall := hl s hs hne
  omega

/-- In the full two-shadow each linear triple contributes three edges, and each
pair of diamond triples contributes five. -/
theorem shadow_count_of_cover {ι : Type*} [Fintype ι]
    (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support)) (hcover : CoversNonlinear H D) :
    (twoShadow H).edgeSet.ncard + Fintype.card ι = 3 * H.card := by
  classical
  let L := H.filter (IsLinearMember H)
  let S := Finset.univ.biUnion (fun i ↦ (D i).sides)
  let P := L.biUnion shadowPairs
  let Q := Finset.univ.biUnion (fun i ↦ (D i).sides.biUnion shadowPairs)
  have apart {i j : ι} (hne : i ≠ j) {t s : Finset (Fin n)}
      (ht : t ∈ (D i).sides) (hs : s ∈ (D j).sides) : Disjoint t s :=
    (hd hne).mono ((D i).subset_of_mem_sides ht) ((D j).subset_of_mem_sides hs)
  have hparts : H = L ∪ S := by
    ext t
    constructor
    · intro ht
      rcases hcover t ht with lin | ⟨i, hs⟩
      · exact Finset.mem_union_left _ (Finset.mem_filter.mpr ⟨ht, lin⟩)
      · exact Finset.mem_union_right _ (Finset.mem_biUnion.mpr
          ⟨i, Finset.mem_univ _, (D i).mem_sides_of_subset hthree ht hs⟩)
    · intro he
      rcases Finset.mem_union.mp he with hl | hs
      · exact (Finset.mem_filter.mp hl).1
      · obtain ⟨i, _, hi⟩ := Finset.mem_biUnion.mp hs
        exact (D i).sides_subset hi
  have hLS : Disjoint L S := by
    apply Finset.disjoint_left.mpr
    intro t hl hs
    obtain ⟨i, _, hi⟩ := Finset.mem_biUnion.mp hs
    exact (D i).nonlinear_side hi (Finset.mem_filter.mp hl).2
  have hS : S.card = Fintype.card ι * 2 := by
    dsimp only [S]
    rw [Finset.card_biUnion]
    · simp
    · intro i _ j _ hij
      apply Finset.disjoint_left.mpr
      intro t hi hj
      have ht := hthree t ((D i).sides_subset hi)
      obtain ⟨v, hv⟩ := Finset.card_pos.mp (show 0 < t.card by omega)
      exact Finset.disjoint_left.mp (apart hij hi hj) hv hv
  have hH : H.card = L.card + Fintype.card ι * 2 := by
    calc
      _ = (L ∪ S).card := congrArg Finset.card hparts
      _ = _ := by rw [Finset.card_union_of_disjoint hLS, hS]
  have hP : P.card = L.card * 3 := by
    dsimp only [P]
    rw [Finset.card_biUnion]
    · apply Finset.sum_const_nat
      intro t ht
      rw [card_shadowPairs, hthree t (Finset.mem_filter.mp ht).1]
      decide
    · intro t ht s hs hne
      exact disjoint_linear_pairs (Finset.mem_filter.mp hs).1 hne.symm (Finset.mem_filter.mp ht).2
  have hQ : Q.card = Fintype.card ι * 5 := by
    dsimp only [Q]
    rw [Finset.card_biUnion]
    · simp [(D _).five_shadow_pairs]
    · intro i _ j _ hij
      apply Finset.disjoint_left.mpr
      intro e he hf
      obtain ⟨t, ht, et⟩ := Finset.mem_biUnion.mp he
      obtain ⟨s, hs, es⟩ := Finset.mem_biUnion.mp hf
      have hsize := Sym2.card_toFinset_of_not_isDiag e (shadowPair_endpoints et).1
      obtain ⟨v, hv⟩ := Finset.card_pos.mp (show 0 < e.toFinset.card by omega)
      exact Finset.disjoint_left.mp (apart hij ht hs) ((shadowPair_endpoints et).2 hv)
        ((shadowPair_endpoints es).2 hv)
  have hedge : H.biUnion shadowPairs = P ∪ Q := by
    ext e
    rw [hparts]
    simp only [P, Q, S, Finset.mem_union, Finset.mem_biUnion, Finset.mem_univ, true_and]
    grind
  have hPQ : Disjoint P Q := by
    apply Finset.disjoint_left.mpr
    intro e hp hq
    obtain ⟨t, ht, et⟩ := Finset.mem_biUnion.mp hp
    obtain ⟨i, _, hi⟩ := Finset.mem_biUnion.mp hq
    obtain ⟨s, hs, es⟩ := Finset.mem_biUnion.mp hi
    have hl := (Finset.mem_filter.mp ht).2
    have hne : s ≠ t := fun he ↦ (D i).nonlinear_side hs (he ▸ hl)
    exact Finset.disjoint_left.mp (disjoint_linear_pairs ((D i).sides_subset hs) hne hl) et es
  rw [shadow_edge_count, hedge, Finset.card_union_of_disjoint hPQ, hP, hQ, hH]
  omega

/-- On one extra vertex, the full construction gains one edge over three per triple
for each ordinary diamond. It keeps the original palette of n colors. -/
theorem three_per_triple_plus_diamonds {ι : Type*} [Fintype ι] (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support)) (hcover : CoversNonlinear H D) :
    ∃ (G : SimpleGraph (Fin (n + 1))) (C : G.EdgeLabeling (Fin n)),
      G.edgeSet.ncard = 3 * H.card + Fintype.card ι ∧ C.IsRainbowFor (cycleGraph 4) := by
  obtain ⟨G, C, hg, hr⟩ := extended_shadow_of_cover hn hf hthree D hd hcover
  have hs := shadow_count_of_cover hthree D hd hcover
  exact ⟨G, C, by omega, hr⟩

/-- A linear triple family gives all three edges per triple on the original vertices. -/
theorem three_per_linear_triple (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (hlinear : ∀ t ∈ H, IsLinearMember H t) :
    3 * H.card ≤ maxRainbowC4Edges n := by
  let D : Fin 0 → OrdinaryDiamond H := Fin.elim0
  have hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support) := fun i ↦ i.elim0
  have hcov : CoversNonlinear H D := fun t ht ↦ Or.inl (hlinear t ht)
  obtain ⟨C, _, hr⟩ := rainbow_twoShadow_of_cover hn hf hthree D hd hcov
  have hs := shadow_count_of_cover hthree D hd hcov
  simp at hs
  exact le_maxRainbowC4Edges_iff.mpr ⟨twoShadow H, hs.ge, C, hr⟩

end Erdos810

#assert_no_sorry
  Erdos810.shadow_count_of_cover
  Erdos810.three_per_triple_plus_diamonds
  Erdos810.three_per_linear_triple
