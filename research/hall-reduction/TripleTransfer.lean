import BlockGadget
import DiamondDegree
import IsolatedBlocks

/-! # A three-for-one transfer with one extra vertex -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

/-- Old vertices used by a family, together with the common new vertex. -/
def familyVertices (H : Finset (Finset (Fin n))) : Set (Option (Fin n))
  | none => True
  | some x => ∃ t ∈ H, x ∈ t

theorem familyVertices_mono {K : Finset (Finset (Fin n))} (hk : K ⊆ H) :
    familyVertices K ⊆ familyVertices H := by
  intro v hv
  cases v with
  | none => trivial
  | some x =>
    obtain ⟨t, ht, hx⟩ := hv
    exact ⟨t, hk ht, hx⟩

/-- The old graph and its one-vertex extension are recorded together, allowing
one to compare deletion of the hub with deletion of any original vertex. -/
structure TransferWitness (H : Finset (Finset (Fin n))) where
  graph : SimpleGraph (Option (Fin n))
  coloring : graph.EdgeLabeling (Fin n)
  diamonds : ℕ
  blocks : ℕ
  old_count : (graph.comap some).edgeSet.ncard + diamonds = 3 * H.card
  total_count : graph.edgeSet.ncard = 3 * H.card + diamonds + 2 * blocks
  supported : graph.support ⊆ familyVertices H
  low_vertex : 0 < diamonds → ∃ v : Fin n, some v ∈ graph.support ∧
    (graph.neighborSet (some v)).ncard ≤ (n + 8) / 4
  rainbow : coloring.IsRainbowFor (cycleGraph 4)

private theorem core_witness (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (hclean : ThreeOnFiveFree H) : Nonempty (TransferWitness H) := by
  classical
  letI : NeZero n := ⟨by omega⟩
  let D := diamondOn (H := H)
  have hd := diamondSupports_pairwise hn hf
  have hc := diamondSupports_cover hthree hclean
  obtain ⟨C, hC, hr⟩ := rainbow_twoShadow_of_cover hn hf hthree D hd hc
  obtain ⟨A, L, hA, hsites, hlocal, hnew⟩ := exists_diamond_spokes hn hf hthree D hd C hC hr
  have hcount := shadow_count_of_cover hthree D hd hc
  let G := hubGraph (twoShadow H) A
  refine ⟨⟨G, hubLabel C A L, Fintype.card ↥(diamondSupports H), 0, hcount, ?_, ?_, ?_, hnew⟩⟩
  · dsimp only [G]
    rw [hubGraph_edge_count, hA]
    omega
  · intro v hv
    cases v with
    | none => trivial
    | some v =>
      obtain ⟨w, hw⟩ := hv
      cases w with
      | none =>
        obtain ⟨i, hi⟩ := hsites v hw
        rw [(D i).support_eq_union] at hi
        rcases Finset.mem_union.mp hi with hi | hi
        · exact ⟨_, (D i).left_mem, hi⟩
        · exact ⟨_, (D i).right_mem, hi⟩
      | some w =>
        obtain ⟨_, t, ht, hv, _⟩ := hw
        exact ⟨t, ht, hv⟩
  · intro hpos
    obtain ⟨i⟩ := Fintype.card_pos_iff.mp hpos
    exact (D i).exists_low_degree hn hf hthree A (hlocal i)

private theorem add_block_to_witness (hn : 9 ≤ n) (B : IsolatedBlock H)
    (W : TransferWitness (H \ B.triples)) : Nonempty (TransferWitness H) := by
  classical
  obtain ⟨F, C, htotal, hold, hsup, hr⟩ := exists_block_gadget hn B.support B.five
  have small {v : Option (Fin n)} (hv : v ∈ W.graph.support ∩ F.support) : v = none := by
    cases v with
    | none => rfl
    | some x =>
      obtain ⟨t, ht, hx⟩ := W.supported hv.1
      exact (Finset.disjoint_left.mp (B.isolated t ht) hx (hsup x hv.2)).elim
  have sep : (W.graph.support ∩ F.support).Subsingleton := fun _ hx _ hy ↦ (small hx).trans (small hy).symm
  obtain ⟨ht, C', hC'⟩ := glue_rainbow sep W.coloring C W.rainbow hr
  have he := separated_edge_count (separated_comap (f := Function.Embedding.some) sep)
  have hparts : (H \ B.triples).card + 3 = H.card := (B.three ▸ Finset.card_sdiff_add_card_eq_card B.subset)
  refine ⟨⟨W.graph ⊔ F, C', W.diamonds, W.blocks + 1, ?_, ?_, ?_, ?_, hC'⟩⟩
  · have eo := W.old_count
    change ((W.graph.comap some) ⊔ (F.comap some)).edgeSet.ncard + W.diamonds = _
    change ((W.graph.comap some) ⊔ (F.comap some)).edgeSet.ncard = _ at he
    rw [he]
    change (W.graph.comap some).edgeSet.ncard + (F.comap some).edgeSet.ncard + W.diamonds = _
    omega
  · have ew := W.total_count
    omega
  · intro v hv
    obtain ⟨w, hw⟩ := hv
    rcases hw with hg | hf'
    · exact familyVertices_mono Finset.sdiff_subset (W.supported ⟨w, hg⟩)
    · cases v with
      | none => trivial
      | some x =>
        have hx := hsup x ⟨w, hf'⟩
        rw [← B.union_eq] at hx
        obtain ⟨t, ht, hxt⟩ := Finset.mem_biUnion.mp hx
        exact ⟨t, B.subset ht, hxt⟩
  · intro hd
    obtain ⟨v, hv, hlow⟩ := W.low_vertex hd
    have hvF : some v ∉ F.support := fun h ↦ Option.some_ne_none v (small ⟨hv, h⟩)
    have same : (W.graph ⊔ F).neighborSet (some v) = W.graph.neighborSet (some v) := by
      ext x
      change W.graph.Adj (some v) x ∨ F.Adj (some v) x ↔ W.graph.Adj (some v) x
      exact ⟨fun h ↦ h.elim id (fun e ↦ (hvF ⟨x, e⟩).elim), Or.inl⟩
    exact ⟨v, SimpleGraph.support_mono le_sup_left hv, same ▸ hlow⟩

/-- Iteratively remove isolated five-point blocks, then use the diamond construction
on the remaining family. The nine-color block palette fits once n is at least nine. -/
theorem exists_transfer_witness (hn : 9 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (hfour : ThreeOnFourFree H) : Nonempty (TransferWitness H) := by
  classical
  induction H using Finset.strongInductionOn with
  | _ H ih =>
    by_cases hclean : ThreeOnFiveFree H
    · exact core_witness (by omega) hf hthree hclean
    · obtain ⟨B⟩ := exists_isolated_block (by omega) hf hthree hfour hclean
      have hs : H \ B.triples ⊂ H := by
        apply Finset.ssubset_iff_subset_ne.mpr ⟨Finset.sdiff_subset, ?_⟩
        have ht := Finset.card_sdiff_add_card_eq_card B.subset
        rw [B.three] at ht
        intro he
        rw [he] at ht
        omega
      obtain ⟨W⟩ := ih _ hs (hf.mono Finset.sdiff_subset)
        (fun t h ↦ hthree t (Finset.sdiff_subset h)) (hfour.mono Finset.sdiff_subset)
      exact add_block_to_witness hn B W

/-- On eight vertices each triple is omitted by five vertex deletions, and
each of the eight deletions leaves at most three triples. -/
theorem four_triples_on_eight {H : Finset (Finset (Fin 8))} (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) : H.card ≤ 4 := by
  classical
  let S : Finset (Fin 8) := Finset.univ
  have hleft (t : Finset (Fin 8)) (ht : t ∈ H) :
      5 ≤ (S.bipartiteAbove (fun u x ↦ x ∉ u) t).card := by
    have he : S.bipartiteAbove (fun (u : Finset (Fin 8)) x ↦ x ∉ u) t = S \ t := by
      ext x
      rw [Finset.mem_bipartiteAbove, Finset.mem_sdiff]
    rw [he, Finset.card_sdiff_of_subset (Finset.subset_univ t), hthree t ht]
    decide
  have hright (x : Fin 8) (hx : x ∈ S) :
      (H.bipartiteBelow (fun u x ↦ x ∉ u) x).card ≤ 3 := by
    have hh := hf (S.erase x) (by rw [Finset.card_erase_of_mem hx]; decide)
    apply Nat.le_of_lt_succ (lt_of_le_of_lt (Finset.card_le_card ?_) hh)
    intro t ht
    obtain ⟨htH, hxt⟩ := (Finset.mem_bipartiteBelow _).mp ht
    exact Finset.mem_filter.mpr ⟨htH, fun y hy ↦ Finset.mem_erase.mpr
      ⟨fun he ↦ hxt (he ▸ hy), Finset.mem_univ y⟩⟩
  have hh := Finset.card_mul_le_card_mul (fun (t : Finset (Fin 8)) x ↦ x ∉ t) hleft hright
  change H.card * 5 ≤ S.card * 3 at hh
  rw [show S.card = 8 by decide] at hh
  omega

theorem few_triples_when_n_lt_nine (hn : 7 ≤ n) (hn' : n < 9) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) : H.card ≤ 4 := by
  obtain rfl | rfl : n = 7 ∨ n = 8 := by omega
  · have h := hf Finset.univ (by decide)
    simpa using h.le
  · exact four_triples_on_eight hf hthree

private theorem extend_small_family (hn : 7 ≤ n) (hsize : H.card ≤ 4) :
    ∃ (G : SimpleGraph (Fin (n + 1))) (C : G.EdgeLabeling (Fin n)),
      3 * H.card ≤ G.edgeSet.ncard ∧ C.IsRainbowFor (cycleGraph 4) := by
  obtain ⟨G, he, C, hr⟩ := hasRainbowC4_seven_fourteen
  let f := Fin.castLEEmb (show 7 ≤ n + 1 by omega)
  let palette := Fin.castLEEmb hn
  obtain ⟨C', hr'⟩ := exists_map_rainbow f (C.compRight palette) (hr.compRight palette.injective)
  refine ⟨G.map f, C', ?_, hr'⟩
  rw [map_edge_count]
  omega

/-- Every admissible triple family gives at least three edges per triple on
one extra vertex, with the original n colors. No decomposition hypothesis is needed. -/
theorem exists_three_edges_per_triple (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) :
    ∃ (G : SimpleGraph (Fin (n + 1))) (C : G.EdgeLabeling (Fin n)),
      3 * H.card ≤ G.edgeSet.ncard ∧ C.IsRainbowFor (cycleGraph 4) := by
  by_cases hs : H.card ≤ 4
  · exact extend_small_family hn hs
  by_cases h9 : 9 ≤ n
  · obtain ⟨W⟩ := exists_transfer_witness h9 hf hthree
      (threeOnFourFree_of_four_members hn hf hthree (by omega))
    let iso := Iso.comap (finSuccEquiv n) W.graph
    refine ⟨_, W.coloring.pullback iso.toHom, ?_, W.rainbow.pullback iso.toCopy⟩
    have he := Nat.card_congr iso.mapEdgeSet
    change (W.graph.comap (finSuccEquiv n).toEmbedding).edgeSet.ncard = W.graph.edgeSet.ncard at he
    rw [he, W.total_count]
    omega
  · exact (hs (few_triples_when_n_lt_nine hn (by omega) hf hthree)).elim

theorem exists_extremal_sevenFourNumber (n : ℕ) :
    ∃ H : Finset (Finset (Fin n)), H.card = sevenFourNumber n ∧
      (∀ t ∈ H, t.card = 3) ∧ SevenFourFree H := by
  let A : Set ℕ := {m | ∃ H : Finset (Finset (Fin n)), H.card = m ∧
    (∀ t ∈ H, t.card = 3) ∧ SevenFourFree H}
  have hn : A.Nonempty := ⟨0, ∅, by simp, by simp, by simp [SevenFourFree]⟩
  have hb : BddAbove A := by
    refine ⟨Fintype.card (Finset (Fin n)), ?_⟩
    rintro m ⟨H, rfl, _, _⟩
    exact H.card_le_univ
  exact Nat.sSup_mem hn hb

/-- The finite shifted extremal comparison for Erdős problem 810. -/
theorem three_mul_sevenFourNumber_le_succ (hn : 7 ≤ n) :
    3 * sevenFourNumber n ≤ maxRainbowC4Edges (n + 1) := by
  obtain ⟨H, he, hthree, hf⟩ := exists_extremal_sevenFourNumber n
  obtain ⟨G, C, hg, hr⟩ := exists_three_edges_per_triple hn hf hthree
  refine le_maxRainbowC4Edges_iff.mpr ⟨G, he ▸ hg, C.compRight Fin.castSucc, ?_⟩
  exact hr.compRight (Fin.castSucc_injective n)

end Erdos810

#assert_no_sorry
  Erdos810.exists_transfer_witness
  Erdos810.exists_three_edges_per_triple
  Erdos810.three_mul_sevenFourNumber_le_succ
