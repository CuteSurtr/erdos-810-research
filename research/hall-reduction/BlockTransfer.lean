import VertexDeletion
import SmallTripleNumbers

/-! # Exact three-for-one transfer with a spare vertex or an isolated block -/

set_option autoImplicit false
open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

private theorem delete_isolated {V : Type*} [Fintype V] (hV : Fintype.card V = n+1)
    (G : SimpleGraph V) (C : G.EdgeLabeling (Fin n)) (hr : C.IsRainbowFor (cycleGraph 4))
    (v : V) (hv : v ∉ G.support) : G.edgeSet.ncard ≤ maxRainbowC4Edges n := by
  have he : G.neighborSet v = ∅ := Set.eq_empty_iff_forall_notMem.mpr (fun x hx ↦ hv ⟨x, hx⟩)
  simpa only [he, Set.ncard_empty, Nat.sub_zero] using delete_vertex_bound hV G C hr v

/-- An unused point can take the role of the additional vertex at zero cost. -/
theorem three_per_triple_of_unused (hn : 7 ≤ n) (hf : SevenFourFree H)
    (ht : ∀ t ∈ H, t.card = 3) (x : Fin n) (hx : ∀ t ∈ H, x ∉ t) :
    3 * H.card ≤ maxRainbowC4Edges n := by
  by_cases hs : H.card ≤ 4
  · have lb := le_maxRainbowC4Edges_iff.mpr (hasRainbowC4_seven_fourteen.pad hn)
    omega
  have h9 : 9 ≤ n := by
    by_contra! h
    exact hs (few_triples_when_n_lt_nine hn h hf ht)
  obtain ⟨W⟩ := exists_transfer_witness h9 hf ht (threeOnFourFree_of_four_members hn hf ht (by omega))
  have isolated : some x ∉ W.graph.support := by
    intro h
    obtain ⟨t, htH, hxt⟩ := W.supported h
    exact hx t htH hxt
  have count := delete_isolated (show Fintype.card (Option (Fin n)) = n+1 by simp)
    W.graph W.coloring W.rainbow (some x) isolated
  rw [W.total_count] at count
  omega

private def cliqueFive : List ((Fin 5 × Fin 5) × Fin 10) :=
  [((0,1),0),((0,2),1),((0,3),2),((0,4),3),((1,2),4),
   ((1,3),5),((1,4),6),((2,3),7),((2,4),8),((3,4),9)]

private theorem cliqueFive_rainbow : (labelingOfCert cliqueFive).IsRainbowFor (cycleGraph 4) := by
  rw [EdgeLabeling.isRainbowFor_cycleGraph_four_iff]
  simp only [labelingOfCert_get]
  decide

private theorem embed_clique_five (hn : 10 ≤ n) (U : Finset (Option (Fin n))) (hu : U.card = 5) :
    ∃ (F : SimpleGraph (Option (Fin n))) (A : F.EdgeLabeling (Fin n)), F.edgeSet.ncard = 10 ∧
      F.support ⊆ U ∧ A.IsRainbowFor (cycleGraph 4) := by
  classical
  let e := (Fintype.equivFinOfCardEq (show Fintype.card ↥U = 5 by simpa using hu)).symm
  let f := e.toEmbedding.trans (Function.Embedding.subtype (fun v ↦ v ∈ U))
  let palette := Fin.castLEEmb hn
  obtain ⟨A, hr⟩ := exists_map_rainbow f ((labelingOfCert cliqueFive).compRight palette)
    (cliqueFive_rainbow.compRight palette.injective)
  refine ⟨_, A, ?_, ?_, hr⟩
  · rw [map_edge_count, ← (graphOfCert cliqueFive).coe_edgeFinset, Set.ncard_coe_finset]
    decide
  · rw [support_map]
    rintro _ ⟨z, _, rfl⟩
    exact (e z).property

/-- Identify the hub with a point of the isolated block. Its five points can carry
a complete graph with ten distinct colors, yielding one extra edge at the original order. -/
theorem three_per_triple_add_one_of_block (hn : 7 ≤ n) (hf : SevenFourFree H)
    (ht : ∀ t ∈ H, t.card = 3) (B : IsolatedBlock H) :
    3 * H.card + 1 ≤ maxRainbowC4Edges n := by
  classical
  by_cases hs : H.card ≤ 4
  · have lb := le_maxRainbowC4Edges_iff.mpr (hasRainbowC4_seven_fourteen.pad hn)
    omega
  have h9 : 9 ≤ n := by
    by_contra! h
    exact hs (few_triples_when_n_lt_nine hn h hf ht)
  by_cases h10 : 10 ≤ n
  · let K := H \ B.triples
    obtain ⟨W⟩ := exists_transfer_witness h9 (hf.mono (show K ⊆ H from Finset.sdiff_subset))
      (fun t h ↦ ht t (Finset.sdiff_subset h)) ((threeOnFourFree_of_four_members hn hf ht (by omega)).mono Finset.sdiff_subset)
    obtain ⟨x, hx⟩ := Finset.card_pos.mp (show 0 < B.support.card by rw [B.five]; decide)
    let U := insert none ((B.support.erase x).map Function.Embedding.some)
    have old (y : Fin n) : some y ∈ U ↔ y ≠ x ∧ y ∈ B.support := by simp [U]
    have hnmem : none ∉ (B.support.erase x).map Function.Embedding.some := by simp
    have hu : U.card = 5 := by
      rw [show U = _ from rfl, Finset.card_insert_of_notMem hnmem, Finset.card_map,
        Finset.card_erase_of_mem hx, B.five]
    obtain ⟨F, A, hcount, hsup, hr⟩ := embed_clique_five h10 U hu
    have off {y : Fin n} (hy : y ∈ B.support) : some y ∉ W.graph.support := by
      intro h
      obtain ⟨t, htk, hy'⟩ := W.supported h
      exact Finset.disjoint_left.mp (B.isolated t htk) hy' hy
    have at_hub {v : Option (Fin n)} (hv : v ∈ W.graph.support ∩ F.support) : v = none := by
      cases v with
      | none => rfl
      | some y => exact (off ((old y).mp (hsup hv.2)).2 hv.1).elim
    have sep : (W.graph.support ∩ F.support).Subsingleton :=
      fun _ h₁ _ h₂ ↦ (at_hub h₁).trans (at_hub h₂).symm
    obtain ⟨he, A', hr'⟩ := glue_rainbow sep W.coloring A W.rainbow hr
    have isolated : some x ∉ (W.graph ⊔ F).support := by
      rintro ⟨v, hw | hF⟩
      · exact off hx ⟨v, hw⟩
      · exact ((old x).mp (hsup ⟨v, hF⟩)).1 rfl
    have bound := delete_isolated (show Fintype.card (Option (Fin n)) = n+1 by simp)
      _ A' hr' (some x) isolated
    have size := Finset.card_sdiff_add_card_eq_card B.subset
    rw [B.three] at size
    change K.card + 3 = H.card at size
    rw [he, W.total_count, hcount] at bound
    omega
  · obtain rfl : n = 9 := by omega
    have upper := (card_le_sevenFourNumber ht hf).trans sevenFourNumber_nine_le
    have lower := le_maxRainbowC4Edges_iff.mpr hasRainbowC4_nine_twentyThree
    omega

end Erdos810

#assert_no_sorry Erdos810.three_per_triple_of_unused Erdos810.three_per_triple_add_one_of_block
