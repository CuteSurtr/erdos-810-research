import GraphGluing

/-! # Nine old edges and two spokes for each isolated five-point block -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

/-- Vertex 0 is the shared hub. The five old vertices induce a complete graph
minus the pair 45. Its nine edges have distinct labels. -/
def blockCert : List ((Fin 6 × Fin 6) × Fin 9) :=
  [((0, 4), 0), ((0, 5), 1), ((1, 2), 0), ((1, 3), 1), ((2, 3), 2),
   ((1, 4), 3), ((2, 4), 4), ((3, 4), 5), ((1, 5), 6), ((2, 5), 7), ((3, 5), 8)]

private theorem block_rainbow : (labelingOfCert blockCert).IsRainbowFor (cycleGraph 4) := by
  rw [EdgeLabeling.isRainbowFor_cycleGraph_four_iff]
  simp only [labelingOfCert_get]
  decide

private def blockBase : SimpleGraph (Option (Fin 5)) :=
  (graphOfCert blockCert).comap (finSuccEquiv 5).symm

private theorem base_total : blockBase.edgeSet.ncard = 11 := by
  let iso := Iso.comap (finSuccEquiv 5).symm (graphOfCert blockCert)
  calc
    _ = (graphOfCert blockCert).edgeSet.ncard := Nat.card_congr iso.mapEdgeSet
    _ = 11 := by rw [← (graphOfCert blockCert).coe_edgeFinset, Set.ncard_coe_finset]; decide

private theorem base_old : (blockBase.comap some).edgeSet.ncard = 9 := by
  let G := (graphOfCert blockCert).comap (Fin.succ : Fin 5 → Fin 6)
  change G.edgeSet.ncard = 9
  rw [← G.coe_edgeFinset, Set.ncard_coe_finset]
  decide

/-- Embed the six-vertex construction on five specified old vertices plus the hub.
Every other old vertex is isolated. The nine labels may be reused by other blocks. -/
theorem exists_block_gadget {n : ℕ} (hn : 9 ≤ n) (U : Finset (Fin n)) (hU : U.card = 5) :
    ∃ (F : SimpleGraph (Option (Fin n))) (C : F.EdgeLabeling (Fin n)),
      F.edgeSet.ncard = 11 ∧ (F.comap some).edgeSet.ncard = 9 ∧
      (∀ x : Fin n, some x ∈ F.support → x ∈ U) ∧ C.IsRainbowFor (cycleGraph 4) := by
  let f := (U.orderEmbOfFin hU).toEmbedding
  let F := blockBase.map f.optionMap
  let palette := Fin.castLEEmb hn
  let iso := Iso.comap (finSuccEquiv 5).symm (graphOfCert blockCert)
  have hr := (block_rainbow.pullback iso.toCopy).compRight palette.injective
  obtain ⟨C, hC⟩ := exists_map_rainbow f.optionMap
    (((labelingOfCert blockCert).pullback iso.toHom).compRight palette) hr
  refine ⟨F, C, (map_edge_count _ _).trans base_total, ?_, ?_, hC⟩
  · rw [show F.comap some = (blockBase.comap some).map f from old_map_option _ _, map_edge_count, base_old]
  · intro v hv
    rw [show F.support = f.optionMap '' blockBase.support from support_map _ _] at hv
    obtain ⟨x, _, he⟩ := hv
    cases x with
    | none => contradiction
    | some i =>
      have hv' : f i = v := Option.some.inj he
      exact hv' ▸ U.orderEmbOfFin_mem hU i

end Erdos810

#assert_no_sorry Erdos810.exists_block_gadget
