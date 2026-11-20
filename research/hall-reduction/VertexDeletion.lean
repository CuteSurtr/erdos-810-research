import TripleTransfer
import Mathlib.Combinatorics.SimpleGraph.DeleteEdges

/-! # A three-for-one comparison on the original number of vertices -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ}

/-- A rainbow graph on any finite vertex type of size n gives the usual
extremal lower bound, with exactly the given palette. -/
theorem edge_count_le_max_of_card {V : Type*} [Fintype V] (hV : Fintype.card V = n)
    (G : SimpleGraph V) (C : G.EdgeLabeling (Fin n)) (hr : C.IsRainbowFor (cycleGraph 4)) :
    G.edgeSet.ncard ≤ maxRainbowC4Edges n := by
  let e := (Fintype.equivFinOfCardEq hV).symm
  let iso := Iso.comap e G
  exact le_maxRainbowC4Edges_iff.mpr ⟨_, (Nat.card_congr iso.mapEdgeSet).ge,
    C.pullback iso.toHom, hr.pullback iso.toCopy⟩

private theorem deletion_count_le {V : Type*} [Fintype V] [DecidableEq V] (hV : Fintype.card V = n + 1)
    (G : SimpleGraph V) [DecidableRel G.Adj] (C : G.EdgeLabeling (Fin n))
    (hr : C.IsRainbowFor (cycleGraph 4)) (v : V) :
    (G.deleteIncidenceSet v).edgeFinset.card ≤ maxRainbowC4Edges n := by
  classical
  let U : Set V := {v}ᶜ
  have hU : Fintype.card U = n := by
    dsimp only [U]
    rw [Fintype.card_compl_set, hV, Fintype.card_unique]
    omega
  let emb := SimpleGraph.Embedding.comap (Function.Embedding.subtype (· ∈ U)) G
  have hbound := edge_count_le_max_of_card hU (G.induce U)
    (C.pullback emb.toHom) (hr.pullback emb.toCopy)
  rw [← (G.induce U).coe_edgeFinset, Set.ncard_coe_finset] at hbound
  change (G.induce {v}ᶜ).edgeFinset.card ≤ _ at hbound
  rwa [G.card_edgeFinset_induce_compl_singleton] at hbound

/-- Removing a particular vertex costs its degree and keeps the n-color palette. -/
theorem delete_vertex_bound {V : Type*} [Fintype V] (hV : Fintype.card V = n + 1)
    (G : SimpleGraph V) (C : G.EdgeLabeling (Fin n)) (hr : C.IsRainbowFor (cycleGraph 4)) (v : V) :
    G.edgeSet.ncard - (G.neighborSet v).ncard ≤ maxRainbowC4Edges n := by
  classical
  have h := deletion_count_le hV G C hr v
  rw [G.card_edgeFinset_deleteIncidenceSet] at h
  rw [← G.coe_edgeFinset, Set.ncard_coe_finset, Set.ncard_eq_toFinset_card']
  exact h

/-- Each edge survives exactly n−1 of the n+1 one-vertex deletions. The
n-color hypothesis allows every deletion to be compared with M(n). -/
theorem deletion_average {V : Type*} [Fintype V] (hV : Fintype.card V = n + 1)
    (G : SimpleGraph V) (C : G.EdgeLabeling (Fin n)) (hr : C.IsRainbowFor (cycleGraph 4)) :
    G.edgeSet.ncard * (n - 1) ≤ (n + 1) * maxRainbowC4Edges n := by
  classical
  have survivors (e : Sym2 V) (he : e ∈ G.edgeFinset) :
      n - 1 ≤ (Finset.univ.bipartiteBelow (fun (v : V) (p : Sym2 V) ↦ v ∉ p) e).card := by
    simp_rw [← Sym2.mem_toFinset, Finset.bipartiteBelow, Finset.filter_not,
      Finset.filter_mem_eq_inter, Finset.univ_inter, ← Finset.compl_eq_univ_sdiff,
      Finset.card_compl, hV, G.card_toFinset_mem_edgeFinset ⟨e, he⟩]
    omega
  have each (v : V) (_ : v ∈ (Finset.univ : Finset V)) :
      (G.edgeFinset.bipartiteAbove (fun (v : V) (p : Sym2 V) ↦ v ∉ p) v).card ≤
        maxRainbowC4Edges n := by
    simpa [Finset.bipartiteAbove, G.edgeFinset_deleteIncidenceSet_eq_filter] using
      deletion_count_le hV G C hr v
  have hcount := Finset.card_mul_le_card_mul' (fun (v : V) (p : Sym2 V) ↦ v ∉ p) survivors each
  rw [Finset.card_univ, hV] at hcount
  rwa [← G.coe_edgeFinset, Set.ncard_coe_finset]

private theorem combine_counts {x old b a M n : ℕ} (hn : 0 < n)
    (hcount : old + b = x) (hold : old ≤ M) (hdel : (x + b + 2 * a) * (n - 1) ≤ (n + 1) * M) :
    (n - 1) * (x + a) ≤ n * M := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hn.ne'
  simp only [Nat.succ_sub_one] at hdel ⊢
  rw [← hcount] at hdel ⊢
  nlinarith [Nat.mul_le_mul_left k hold]

/-- Compare the original shadow with an average deletion from its extension.
The diamond loss in one count cancels the diamond gain in the other. -/
theorem TransferWitness.bound {H : Finset (Finset (Fin n))} (W : TransferWitness H) (hn : 0 < n) :
    (n - 1) * (3 * H.card + W.blocks) ≤ n * maxRainbowC4Edges n := by
  let emb := SimpleGraph.Embedding.comap (Function.Embedding.some (α := Fin n)) W.graph
  have hold := edge_count_le_max_of_card (Fintype.card_fin n) (W.graph.comap some)
    (W.coloring.pullback emb.toHom) (W.rainbow.pullback emb.toCopy)
  have hdel := deletion_average (show Fintype.card (Option (Fin n)) = n + 1 by simp)
    W.graph W.coloring W.rainbow
  rw [W.total_count] at hdel
  exact combine_counts hn W.old_count hold hdel

/-- The same-order comparison in multiplicative form. -/
theorem three_per_triple_same_order {H : Finset (Finset (Fin n))} (hn : 7 ≤ n)
    (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3) :
    (n - 1) * (3 * H.card) ≤ n * maxRainbowC4Edges n := by
  by_cases hs : H.card ≤ 4
  · have he := le_maxRainbowC4Edges_iff.mpr (hasRainbowC4_seven_fourteen.pad hn)
    exact Nat.mul_le_mul (Nat.sub_le _ _) (by omega)
  by_cases h9 : 9 ≤ n
  · obtain ⟨W⟩ := exists_transfer_witness h9 hf hthree
      (threeOnFourFree_of_four_members hn hf hthree (by omega))
    exact (Nat.mul_le_mul_left (n - 1) (Nat.le_add_right (3 * H.card) W.blocks)).trans
      (W.bound (by omega))
  · have he : n = 7 ∨ n = 8 := by omega
    rcases he with rfl | rfl
    · have h := hf Finset.univ (by decide)
      simp at h
      omega
    · exact (hs (four_triples_on_eight hf hthree)).elim

private theorem rounded_transfer {n x M : ℕ} (hn : 0 < n) (h : (n - 1) * x ≤ n * M) :
    x - x / n ≤ M := by
  by_cases hx : x ≤ M
  · exact (Nat.sub_le _ _).trans hx
  have hsplit : M + (x - M) = x := by omega
  have hdiff : (x - M) * n ≤ x := by
    have hn1 : n - 1 + 1 = n := by omega
    nlinarith [congrArg (· * x) hn1, congrArg (n * ·) hsplit]
  have hq := (Nat.le_div_iff_mul_le hn).mpr hdiff
  omega

/-- The integer lower bound uses floor division and applies on the same n vertices. -/
theorem three_mul_sevenFourNumber_sub_div_le (hn : 7 ≤ n) :
    3 * sevenFourNumber n - (3 * sevenFourNumber n) / n ≤ maxRainbowC4Edges n := by
  obtain ⟨H, he, hthree, hf⟩ := exists_extremal_sevenFourNumber n
  rw [← he]
  exact rounded_transfer (by omega) (three_per_triple_same_order hn hf hthree)

/-- The support of any ordinary diamond supplies a vertex of degree at most
floor((n+8)/4). Choosing between that deletion and deleting the hub halves the
worst possible loss compared to the earlier floor(n/4) estimate. -/
theorem three_per_triple_sub_eighth {H : Finset (Finset (Fin n))} (hn : 7 ≤ n)
    (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card = 3) :
    3 * H.card - (n + 8) / 8 ≤ maxRainbowC4Edges n := by
  by_cases hs : H.card ≤ 4
  · have he := le_maxRainbowC4Edges_iff.mpr (hasRainbowC4_seven_fourteen.pad hn)
    omega
  have h9 : 9 ≤ n := by
    by_contra! h
    exact hs (few_triples_when_n_lt_nine hn h hf hthree)
  obtain ⟨W⟩ := exists_transfer_witness h9 hf hthree (threeOnFourFree_of_four_members hn hf hthree (by omega))
  let emb := SimpleGraph.Embedding.comap (Function.Embedding.some (α := Fin n)) W.graph
  have hold := edge_count_le_max_of_card (Fintype.card_fin n) (W.graph.comap some)
    (W.coloring.pullback emb.toHom) (W.rainbow.pullback emb.toCopy)
  have he := W.old_count
  by_cases hd : W.diamonds = 0
  · omega
  obtain ⟨v, _, hsmall⟩ := W.low_vertex (by omega)
  have hdel := delete_vertex_bound (show Fintype.card (Option (Fin n)) = n + 1 by simp)
    W.graph W.coloring W.rainbow (some v)
  rw [W.total_count] at hdel
  omega

theorem three_mul_sevenFourNumber_sub_eighth_le (hn : 7 ≤ n) :
    3 * sevenFourNumber n - (n + 8) / 8 ≤ maxRainbowC4Edges n := by
  obtain ⟨H, he, hthree, hf⟩ := exists_extremal_sevenFourNumber n
  rw [← he]
  exact three_per_triple_sub_eighth hn hf hthree

end Erdos810

#assert_no_sorry
  Erdos810.deletion_average
  Erdos810.three_per_triple_same_order
  Erdos810.three_mul_sevenFourNumber_sub_div_le
  Erdos810.three_mul_sevenFourNumber_sub_eighth_le
