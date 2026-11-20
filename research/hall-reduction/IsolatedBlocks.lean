import DiamondDecomposition

/-! # Removing an isolated three-triple block on five vertices -/

set_option autoImplicit false

namespace Erdos810

variable {n : ℕ} {H K : Finset (Finset (Fin n))}

/-- Three distinct triples never lie on at most four vertices. -/
def ThreeOnFourFree (H : Finset (Finset (Fin n))) : Prop :=
  ∀ S : Finset (Fin n), S.card ≤ 4 → (H.filter (fun t ↦ t ⊆ S)).card < 3

theorem SevenFourFree.mono (h : SevenFourFree H) (hk : K ⊆ H) : SevenFourFree K :=
  fun S hs ↦ lt_of_le_of_lt (Finset.card_le_card (Finset.filter_subset_filter _ hk)) (h S hs)

theorem ThreeOnFourFree.mono (h : ThreeOnFourFree H) (hk : K ⊆ H) : ThreeOnFourFree K :=
  fun S hs ↦ lt_of_le_of_lt (Finset.card_le_card (Finset.filter_subset_filter _ hk)) (h S hs)

private theorem fourth_needs_eight (hn : 7 ≤ n) (hf : SevenFourFree H)
    {F : Finset (Finset (Fin n))} (hF : F ⊆ H) (hsize : F.card = 3)
    {r : Finset (Fin n)} (hr : r ∈ H) (hout : r ∉ F) {U : Finset (Fin n)}
    (hsub : ∀ t ∈ F, t ⊆ U) (hs : r ⊆ U) : 8 ≤ U.card := by
  by_contra! h
  have hall : insert r F ⊆ H.filter (fun t ↦ t ⊆ U) := by
    intro t ht
    rcases Finset.mem_insert.mp ht with rfl | ht
    · exact Finset.mem_filter.mpr ⟨hr, hs⟩
    · exact Finset.mem_filter.mpr ⟨hF ht, hsub t ht⟩
  have hcount := Finset.card_le_card hall
  rw [Finset.card_insert_of_notMem hout, hsize] at hcount
  exact (hf.card_filter_lt_four hn U (by omega)).not_ge hcount

/-- A three-on-four family can only occur when the entire system has at most three triples. -/
theorem threeOnFourFree_of_four_members (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (hfour : 4 ≤ H.card) : ThreeOnFourFree H := by
  intro S hS
  by_contra! h
  obtain ⟨F, hF, hsiz⟩ := Finset.exists_subset_card_eq h
  have hFH := hF.trans (Finset.filter_subset _ _)
  have hd := Finset.card_sdiff_of_subset hFH
  obtain ⟨r, hr⟩ := Finset.card_pos.mp (show 0 < (H \ F).card by omega)
  obtain ⟨hr, hout⟩ := Finset.mem_sdiff.mp hr
  have h8 := fourth_needs_eight hn hf hFH hsiz hr hout (U := S ∪ r)
    (fun t ht ↦ (Finset.mem_filter.mp (hF ht)).2.trans Finset.subset_union_left)
    Finset.subset_union_right
  have hmax := Finset.card_union_le S r
  rw [hthree r hr] at hmax
  omega

/-- The block includes all three member triples. Its support is disjoint from every
remaining triple, including a remainder that is itself nonlinear. -/
structure IsolatedBlock (H : Finset (Finset (Fin n))) where
  triples : Finset (Finset (Fin n))
  support : Finset (Fin n)
  subset : triples ⊆ H
  three : triples.card = 3
  five : support.card = 5
  union_eq : triples.biUnion id = support
  isolated : ∀ r ∈ H \ triples, Disjoint r support

/-- A family with a three-on-five configuration and no three-on-four configuration
has a removable isolated block. -/
theorem exists_isolated_block (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (hfour : ThreeOnFourFree H) (hbad : ¬ThreeOnFiveFree H) :
    Nonempty (IsolatedBlock H) := by
  classical
  change ¬∀ S : Finset (Fin n), S.card ≤ 5 → (H.filter (fun t ↦ t ⊆ S)).card < 3 at hbad
  push_neg at hbad
  obtain ⟨S, hS, hm⟩ := hbad
  obtain ⟨F, hF, hsize⟩ := Finset.exists_subset_card_eq hm
  have hFH := hF.trans (Finset.filter_subset _ _)
  let U := F.biUnion id
  have contained {t : Finset (Fin n)} (ht : t ∈ F) : t ⊆ U :=
    fun _ hx ↦ Finset.mem_biUnion.mpr ⟨t, ht, hx⟩
  have hU5 : U.card = 5 := by
    have hu : U ⊆ S := by
      intro v hv
      obtain ⟨t, ht, hvt⟩ := Finset.mem_biUnion.mp hv
      exact (Finset.mem_filter.mp (hF ht)).2 hvt
    have upper := (Finset.card_le_card hu).trans hS
    by_contra ne
    have hh : F ⊆ H.filter (fun t ↦ t ⊆ U) :=
      fun t ht ↦ Finset.mem_filter.mpr ⟨hFH ht, contained ht⟩
    have hcount := Finset.card_le_card hh
    have hsmall := hfour U (by omega)
    omega
  refine ⟨⟨F, U, hFH, hsize, hU5, rfl, ?_⟩⟩
  intro r hr
  obtain ⟨hr, hout⟩ := Finset.mem_sdiff.mp hr
  apply Finset.disjoint_left.mpr
  intro x hxr hxu
  have h8 := fourth_needs_eight hn hf hFH hsize hr hout (U := r ∪ U)
    (fun _ ht ↦ (contained ht).trans Finset.subset_union_right) Finset.subset_union_left
  have heq := Finset.card_union_add_card_inter r U
  have hp : 0 < (r ∩ U).card := Finset.card_pos.mpr ⟨x, Finset.mem_inter.mpr ⟨hxr, hxu⟩⟩
  rw [hthree r hr, hU5] at heq
  omega

end Erdos810

#assert_no_sorry Erdos810.threeOnFourFree_of_four_members Erdos810.exists_isolated_block
