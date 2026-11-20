import TripleTransfer
import Mathlib.Data.Finset.Preimage

/-! # Restrictions, deletion, and finite values of the (7,4) triple number -/

set_option autoImplicit false

namespace Erdos810

variable {n k : ℕ} {H : Finset (Finset (Fin n))}

/-- Any admissible triple system is bounded by the extremal value. -/
theorem card_le_sevenFourNumber (hthree : ∀ t ∈ H, t.card = 3) (hf : SevenFourFree H) :
    H.card ≤ sevenFourNumber n := by
  unfold sevenFourNumber
  apply le_csSup
  · refine ⟨Fintype.card (Finset (Fin n)), ?_⟩
    rintro m ⟨K, rfl, _, _⟩
    exact K.card_le_univ
  · exact ⟨H, rfl, hthree, hf⟩

/-- Restrict to a set of k vertices and use its increasing labeling by Fin k. -/
theorem SevenFourFree.card_restriction_le (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (U : Finset (Fin n)) (hU : U.card = k) :
    (H.filter (fun t ↦ t ⊆ U)).card ≤ sevenFourNumber k := by
  classical
  let f := (U.orderEmbOfFin hU).toEmbedding
  let K := Finset.univ.filter (fun t : Finset (Fin k) ↦ t.map f ∈ H)
  have member (t : Finset (Fin k)) : t ∈ K ↔ t.map f ∈ H := by simp [K]
  have range_eq : Finset.univ.map f = U := U.map_orderEmbOfFin_univ hU
  have uniform (t : Finset (Fin k)) (ht : t ∈ K) : t.card = 3 := by
    simpa using hthree _ ((member t).mp ht)
  have free : SevenFourFree K := by
    intro S hS
    apply lt_of_le_of_lt _ (hf (S.map f) (by simpa using hS))
    apply Finset.card_le_card_of_injOn (Finset.map f) _ (Finset.map_injective f).injOn
    intro t ht
    obtain ⟨htK, hsub⟩ := Finset.mem_filter.mp ht
    exact Finset.mem_filter.mpr ⟨(member t).mp htK, Finset.map_subset_map.mpr hsub⟩
  have cover : H.filter (fun t ↦ t ⊆ U) ⊆ K.image (Finset.map f) := by
    intro t ht
    obtain ⟨htH, htU⟩ := Finset.mem_filter.mp ht
    rw [← range_eq] at htU
    obtain ⟨u, _, rfl⟩ := Finset.subset_map_iff.mp htU
    exact Finset.mem_image.mpr ⟨u, (member u).mpr htH, rfl⟩
  exact (Finset.card_le_card cover).trans
    (Finset.card_image_le.trans (card_le_sevenFourNumber uniform free))

/-- Each triple survives exactly n-2 of the single-vertex deletions from n+1 points. -/
theorem sevenFourNumber_deletion (n : ℕ) :
    sevenFourNumber (n+1) * (n-2) ≤ (n+1) * sevenFourNumber n := by
  classical
  obtain ⟨H, hc, hthree, hf⟩ := exists_extremal_sevenFourNumber (n+1)
  let V : Finset (Fin (n+1)) := Finset.univ
  have hv : V.card = n+1 := by simp [V]
  have left (t : Finset (Fin (n+1))) (ht : t ∈ H) :
      n-2 ≤ (V.bipartiteAbove (fun u x ↦ x ∉ u) t).card := by
    have eq : V.bipartiteAbove (fun (u : Finset (Fin (n+1))) x ↦ x ∉ u) t = V \ t := by
      ext x
      rw [Finset.mem_bipartiteAbove, Finset.mem_sdiff]
    rw [eq, Finset.card_sdiff_of_subset (Finset.subset_univ _), hv, hthree t ht]
    omega
  have right (x : Fin (n+1)) (hx : x ∈ V) :
      (H.bipartiteBelow (fun u x ↦ x ∉ u) x).card ≤ sevenFourNumber n := by
    apply le_trans (Finset.card_le_card ?_) (hf.card_restriction_le hthree (V.erase x)
      (by rw [Finset.card_erase_of_mem hx, hv]; omega))
    intro t ht
    obtain ⟨htH, hxt⟩ := (Finset.mem_bipartiteBelow _).mp ht
    exact Finset.mem_filter.mpr ⟨htH, fun y hy ↦ Finset.mem_erase.mpr
      ⟨fun he ↦ hxt (he ▸ hy), Finset.mem_univ y⟩⟩
  have h := Finset.card_mul_le_card_mul (fun (t : Finset (Fin (n+1))) x ↦ x ∉ t) left right
  simpa only [hc, hv] using h

theorem sevenFourNumber_seven_le : sevenFourNumber 7 ≤ 3 := by
  obtain ⟨H, he, _, hf⟩ := exists_extremal_sevenFourNumber 7
  have h := hf Finset.univ (by decide)
  rw [← he]
  simpa using Nat.le_of_lt_succ h

theorem sevenFourNumber_eight_le : sevenFourNumber 8 ≤ 4 := by
  obtain ⟨H, he, ht, hf⟩ := exists_extremal_sevenFourNumber 8
  rw [← he]
  exact four_triples_on_eight hf ht

theorem sevenFourNumber_nine_le : sevenFourNumber 9 ≤ 6 := by
  have h := sevenFourNumber_deletion 8
  have he := sevenFourNumber_eight_le
  norm_num at h
  omega

/-- Eight triples on ten points would force at least six degree-two points.
Two such points cannot lie in one triple, since their deletion would leave five triples on eight. -/
theorem sevenFourNumber_ten_le : sevenFourNumber 10 ≤ 7 := by
  classical
  by_contra! hlt
  obtain ⟨H, hc, ht, hf⟩ := exists_extremal_sevenFourNumber 10
  have previous := sevenFourNumber_deletion 9
  norm_num at previous
  have h9 := sevenFourNumber_nine_le
  have h8 := sevenFourNumber_eight_le
  have hm : H.card = 8 := by omega
  let V : Finset (Fin 10) := Finset.univ
  let incident (x : Fin 10) := H.filter (fun t ↦ x ∈ t)
  let degree (x : Fin 10) := (incident x).card
  have hV : V.card = 10 := by decide
  have outside (x : Fin 10) : (H.filter (fun t ↦ x ∉ t)).card ≤ 6 := by
    apply le_trans (Finset.card_le_card ?_) ((hf.card_restriction_le ht (V.erase x)
      (by rw [Finset.card_erase_of_mem (Finset.mem_univ x), hV]) (k := 9)).trans h9)
    intro t h
    obtain ⟨htH, hxt⟩ := Finset.mem_filter.mp h
    exact Finset.mem_filter.mpr ⟨htH, fun y hy ↦ Finset.mem_erase.mpr
      ⟨fun eq ↦ hxt (eq ▸ hy), Finset.mem_univ y⟩⟩
  have min_degree (x : Fin 10) : 2 ≤ degree x := by
    have h := Finset.filter_card_add_filter_neg_card_eq_card (s := H) (fun t ↦ x ∈ t)
    change degree x + _ = H.card at h
    have := outside x
    omega
  have total : V.sum degree = 24 := by
    have h := Finset.sum_card_bipartiteAbove_eq_sum_card_bipartiteBelow
      (s := V) (t := H) (fun (x : Fin 10) (t : Finset (Fin 10)) ↦ x ∈ t)
    change V.sum degree = _ at h
    rw [h, Finset.sum_const_nat (m := 3), hm]
    · intro t htH
      have eq : V.bipartiteBelow (fun (x : Fin 10) (t : Finset (Fin 10)) ↦ x ∈ t) t = t := by
        ext x
        simp [V]
      rw [eq, ht t htH]
  let low := V.filter (fun x ↦ degree x = 2)
  let high := V.filter (fun x ↦ degree x ≠ 2)
  have parts : low.card + high.card = 10 := by
    exact (Finset.filter_card_add_filter_neg_card_eq_card _).trans hV
  have sum_low : low.sum degree = low.card * 2 :=
    Finset.sum_const_nat (fun x hx ↦ (Finset.mem_filter.mp hx).2)
  have sum_high : high.card * 3 ≤ high.sum degree := by
    rw [← Nat.nsmul_eq_mul]
    apply high.card_nsmul_le_sum
    intro x hx
    have hne := (Finset.mem_filter.mp hx).2
    have hmin := min_degree x
    omega
  have sums : low.sum degree + high.sum degree = 24 :=
    (V.sum_filter_add_sum_filter_not _ degree).trans total
  have hlow : 6 ≤ low.card := by omega
  have distinct (t : Finset (Fin 10)) (htH : t ∈ H) (x : Fin 10) (hx : x ∈ low)
      (y : Fin 10) (hy : y ∈ low) (hxt : x ∈ t) (hyt : y ∈ t) : x = y := by
    by_contra hxy
    have hyx := Ne.symm hxy
    have hx2 : (incident x).card = 2 := (Finset.mem_filter.mp hx).2
    have hy2 : (incident y).card = 2 := (Finset.mem_filter.mp hy).2
    have common : 1 ≤ (incident x ∩ incident y).card :=
      Finset.one_le_card.mpr ⟨t, Finset.mem_inter.mpr
        ⟨Finset.mem_filter.mpr ⟨htH, hxt⟩, Finset.mem_filter.mpr ⟨htH, hyt⟩⟩⟩
    have union_count := Finset.card_union_add_card_inter (incident x) (incident y)
    let U := (V.erase x).erase y
    have hU : U.card = 8 := by
      change ((V.erase x).erase y).card = _
      rw [Finset.card_erase_of_mem (Finset.mem_erase.mpr ⟨hyx, Finset.mem_univ y⟩),
        Finset.card_erase_of_mem (Finset.mem_univ x), hV]
    have remain := (hf.card_restriction_le ht U hU).trans h8
    have hs : incident x ∪ incident y ⊆ H :=
      Finset.union_subset (Finset.filter_subset _ _) (Finset.filter_subset _ _)
    have hd := Finset.card_sdiff_add_card_eq_card hs
    have hsub : H \ (incident x ∪ incident y) ⊆ H.filter (fun t ↦ t ⊆ U) := by
      intro u hu
      obtain ⟨huH, hnone⟩ := Finset.mem_sdiff.mp hu
      refine Finset.mem_filter.mpr ⟨huH, fun v hv ↦ ?_⟩
      have hnx : x ∉ u := fun h ↦ hnone (Finset.mem_union_left _ (Finset.mem_filter.mpr ⟨huH, h⟩))
      have hny : y ∉ u := fun h ↦ hnone (Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨huH, h⟩))
      exact Finset.mem_erase.mpr ⟨fun e ↦ hny (e ▸ hv), Finset.mem_erase.mpr
        ⟨fun e ↦ hnx (e ▸ hv), Finset.mem_univ v⟩⟩
    have hh := Finset.card_le_card hsub
    omega
  have low_per (t : Finset (Fin 10)) (htH : t ∈ H) :
      (low.bipartiteBelow (fun (x : Fin 10) (u : Finset (Fin 10)) ↦ x ∈ u) t).card ≤ 1 := by
    apply Finset.card_le_one.mpr
    intro x hx y hy
    obtain ⟨hx, hxt⟩ := (Finset.mem_bipartiteBelow _).mp hx
    obtain ⟨hy, hyt⟩ := (Finset.mem_bipartiteBelow _).mp hy
    exact distinct t htH x hx y hy hxt hyt
  have low_deg (x : Fin 10) (hx : x ∈ low) :
      2 ≤ (H.bipartiteAbove (fun (x : Fin 10) (u : Finset (Fin 10)) ↦ x ∈ u) x).card :=
    min_degree x
  have count := Finset.card_mul_le_card_mul (fun (x : Fin 10) (t : Finset (Fin 10)) ↦ x ∈ t)
    low_deg low_per
  omega

/-- A finite certificate can be checked on all four-triple subfamilies. -/
theorem sevenFourFree_of_four_unions (H : Finset (Finset (Fin n)))
    (test : ((H.powersetCard 4).filter (fun F ↦ (F.biUnion id).card < 8)).card = 0) : SevenFourFree H := by
  intro S hS
  by_contra! many
  obtain ⟨F, hF, h4⟩ := Finset.exists_subset_card_eq many
  have hFH : F ⊆ H := hF.trans (Finset.filter_subset _ _)
  have member := Finset.mem_powersetCard.mpr ⟨hFH, h4⟩
  have sub : F.biUnion id ⊆ S :=
    Finset.biUnion_subset_iff_forall_subset.mpr (fun t ht ↦ (Finset.mem_filter.mp (hF ht)).2)
  have hsmall := Finset.card_le_card sub
  have bad : F ∈ (H.powersetCard 4).filter (fun F ↦ (F.biUnion id).card < 8) :=
    Finset.mem_filter.mpr ⟨member, by omega⟩
  exact (Finset.card_ne_zero_of_mem bad) test

private def gridNine : Finset (Finset (Fin 9)) :=
  {{0, 1, 2}, {3, 4, 5}, {6, 7, 8}, {0, 3, 6}, {1, 4, 7}, {2, 5, 8}}

private def configurationTwelve : Finset (Finset (Fin 12)) :=
  {{1,3,6}, {2,3,7}, {0,6,7}, {2,5,8}, {4,6,8}, {2,4,9},
   {1,4,10}, {5,7,10}, {0,9,10}, {1,5,11}, {0,8,11}, {3,9,11}}

set_option maxRecDepth 12000 in
theorem six_le_sevenFourNumber_nine : 6 ≤ sevenFourNumber 9 := by
  have hc : gridNine.card = 6 := by decide
  rw [← hc]
  apply card_le_sevenFourNumber
  · intro t ht
    simp only [gridNine, Finset.mem_insert, Finset.mem_singleton] at ht
    rcases ht with rfl | rfl | rfl | rfl | rfl | rfl <;> decide
  · exact sevenFourFree_of_four_unions gridNine (by decide +kernel)

set_option maxRecDepth 20000 in
set_option maxHeartbeats 2000000 in
theorem twelve_le_sevenFourNumber_twelve : 12 ≤ sevenFourNumber 12 := by
  have hc : configurationTwelve.card = 12 := by decide
  rw [← hc]
  apply card_le_sevenFourNumber
  · intro t ht
    simp only [configurationTwelve, Finset.mem_insert, Finset.mem_singleton] at ht
    rcases ht with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide
  · exact sevenFourFree_of_four_unions configurationTwelve (by decide +kernel)

/-- Exact values of the unrestricted (7,4) hypergraph number from 7 to 12 points. -/
theorem sevenFourNumber_small :
    sevenFourNumber 7 = 3 ∧ sevenFourNumber 8 = 4 ∧ sevenFourNumber 9 = 6 ∧
    sevenFourNumber 10 = 7 ∧ sevenFourNumber 11 = 9 ∧ sevenFourNumber 12 = 12 := by
  have u7 := sevenFourNumber_seven_le
  have u8 := sevenFourNumber_eight_le
  have u9 := sevenFourNumber_nine_le
  have u10 := sevenFourNumber_ten_le
  have l9 := six_le_sevenFourNumber_nine
  have l12 := twelve_le_sevenFourNumber_twelve
  have d7 := sevenFourNumber_deletion 7
  have d8 := sevenFourNumber_deletion 8
  have d10 := sevenFourNumber_deletion 10
  have d11 := sevenFourNumber_deletion 11
  norm_num at d7 d8 d10 d11
  omega

end Erdos810

#assert_no_sorry Erdos810.sevenFourNumber_deletion Erdos810.sevenFourNumber_small
