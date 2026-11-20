import NearQuadratic
import Mathlib.Combinatorics.SimpleGraph.Triangle.Removal
import Mathlib.Combinatorics.SimpleGraph.DeleteEdges

/-! # Making a rainbow-four-cycle coloring proper by deleting few edges

Maximal edge-disjoint monochromatic two-edge paths index the triangles of a
locally linear tripartite graph. The triangle removal lemma bounds their number.
-/

set_option autoImplicit false

open SimpleGraph SimpleGraph.TripartiteFromTriangles Filter

namespace Erdos810

universe u

variable {V K : Type*} {G : SimpleGraph V}

/-- Incident edges at each vertex have different labels. -/
def ProperAtVertices (C : G.EdgeLabeling K) : Prop :=
  ∀ {a b c : V} (hab : G.Adj a b) (hbc : G.Adj b c), a ≠ c → C.get a b hab ≠ C.get b c hbc

private def MonoPath (C : G.EdgeLabeling K) (p : V × V × V) : Prop :=
  p.1 ≠ p.2.2 ∧ ∃ (h₁ : G.Adj p.1 p.2.1) (h₂ : G.Adj p.2.1 p.2.2),
    C.get _ _ h₁ = C.get _ _ h₂

/-- The endpoints of a monochromatic two-edge path have just one common neighbor. -/
theorem mono_path_unique_middle (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4))
    {a b c x : V} (hab : G.Adj a b) (hbc : G.Adj b c) (hac : a ≠ c)
    (hcolor : C.get a b hab = C.get b c hbc) (hax : G.Adj a x) (hcx : G.Adj c x) : b = x := by
  by_contra hn
  have h := EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr a b c x hab hbc hcx hax.symm hac hn
  simp [hcolor] at h

private def pathEdges [DecidableEq V] (p : V × V × V) : Finset (Sym2 V) :=
  {s(p.1, p.2.1), s(p.2.1, p.2.2)}

private structure PathPacking [DecidableEq V] (C : G.EdgeLabeling K) (T : Finset (V × V × V)) :
    Prop where
  paths : ∀ p ∈ T, MonoPath C p
  disjoint : (T : Set (V × V × V)).PairwiseDisjoint pathEdges

private theorem packing_bound [DecidableEq V] [Fintype V]
    (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4))
    (T : Finset (V × V × V)) (P : PathPacking C T) :
    T.card ≤ ruzsaSzemerediNumberNat (3 * Fintype.card V) := by
  classical
  have same {p q : V × V × V} (hp : p ∈ T) (hq : q ∈ T) {e : Sym2 V}
      (ep : e ∈ pathEdges p) (eq : e ∈ pathEdges q) : p = q := by
    by_contra hn
    exact Finset.disjoint_left.mp (P.disjoint hp hq hn) ep eq
  letI : ExplicitDisjoint T := {
    inj₀ := fun {a b c a'} h h' ↦ congrArg Prod.fst
      (same h h' (e := s(b, c)) (by simp [pathEdges]) (by simp [pathEdges]))
    inj₁ := by
      intro a b c b' h h'
      obtain ⟨hac, hab, hbc, he⟩ := P.paths _ h
      obtain ⟨_, hab', hbc', _⟩ := P.paths _ h'
      exact mono_path_unique_middle C hr hab hbc hac he hab' hbc'.symm
    inj₂ := fun {a b c c'} h h' ↦ congrArg (fun p : V × V × V ↦ p.2.2)
      (same h h' (e := s(a, b)) (by simp [pathEdges]) (by simp [pathEdges])) }
  letI : NoAccidental T := {
    eq_or_eq_or_eq := by
      intro a a' b b' c c' ha hb hc
      obtain ⟨_, _, hbc, _⟩ := P.paths _ ha
      obtain ⟨hac, hab', hbc', he⟩ := P.paths _ hb
      obtain ⟨_, hab, _, _⟩ := P.paths _ hc
      exact Or.inr (Or.inl (mono_path_unique_middle C hr hab' hbc' hac he hab hbc.symm).symm) }
  have hbound := (locallyLinear T).le_ruzsaSzemerediNumber
  rw [card_triangles, ← ruzsaSzemerediNumberNat_card] at hbound
  simpa [Fintype.card_sum, Nat.mul_comm, Nat.mul_succ, two_mul, Nat.add_assoc] using hbound

private theorem maximal_packing [DecidableEq V] [Fintype V] (C : G.EdgeLabeling K) :
    ∃ T : Finset (V × V × V), PathPacking C T ∧
      ∀ p, MonoPath C p → ¬Disjoint (pathEdges p) (T.biUnion pathEdges) := by
  classical
  let choices := Finset.univ.filter (PathPacking C)
  have empty : (∅ : Finset (V × V × V)) ∈ choices := by simp [choices, PathPacking.mk]
  obtain ⟨T, ht, hmax⟩ := choices.exists_max_image Finset.card ⟨∅, empty⟩
  have P := (Finset.mem_filter.mp ht).2
  refine ⟨T, P, ?_⟩
  intro p hp hd
  have against {q : V × V × V} (hq : q ∈ T) : Disjoint (pathEdges p) (pathEdges q) :=
    hd.mono_right (fun _ he ↦ Finset.mem_biUnion.mpr ⟨q, hq, he⟩)
  have hn : p ∉ T := fun h ↦ Finset.disjoint_left.mp (against h)
    (Finset.mem_insert_self _ _) (Finset.mem_insert_self _ _)
  have larger : PathPacking C (insert p T) := by
    constructor
    · intro q hq
      rcases Finset.mem_insert.mp hq with rfl | hq
      · exact hp
      · exact P.paths q hq
    · intro u hu v hv hne
      by_cases hup : u = p
      · subst u
        exact against ((Finset.mem_insert.mp hv).resolve_left (Ne.symm hne))
      · have hut := (Finset.mem_insert.mp hu).resolve_left hup
        by_cases hvp : v = p
        · exact hvp ▸ (against hut).symm
        · exact P.disjoint hut ((Finset.mem_insert.mp hv).resolve_left hvp) hne
  have := hmax _ (Finset.mem_filter.mpr ⟨Finset.mem_univ _, larger⟩)
  rw [Finset.card_insert_of_notMem hn] at this
  omega

/-- The coloring on the subgraph is the restriction of the original coloring.
The loss bound is uniform in the palette. -/
theorem proper_subgraph [Fintype V] (G : SimpleGraph V) (C : G.EdgeLabeling K)
    (hr : C.IsRainbowFor (cycleGraph 4)) :
    ∃ (F : SimpleGraph V) (hFG : F ≤ G), ProperAtVertices (C.pullback (Hom.ofLE hFG)) ∧
      (C.pullback (Hom.ofLE hFG)).IsRainbowFor (cycleGraph 4) ∧
      G.edgeSet.ncard ≤ F.edgeSet.ncard + 2 * ruzsaSzemerediNumberNat (3 * Fintype.card V) := by
  classical
  obtain ⟨T, P, hit⟩ := maximal_packing C
  let D := T.biUnion pathEdges
  let F := G.deleteEdges D
  have hFG : F ≤ G := G.deleteEdges_le _
  have bound := packing_bound C hr T P
  have hD : D.card ≤ 2 * T.card := calc
    _ ≤ ∑ p ∈ T, (pathEdges p).card := Finset.card_biUnion_le
    _ ≤ ∑ _p ∈ T, 2 := Finset.sum_le_sum (fun _ _ ↦ Finset.card_le_two)
    _ = _ := by simp [Nat.mul_comm]
  refine ⟨F, hFG, ?_, hr.pullback_ofLE hFG, ?_⟩
  · intro a b c hab hbc hac he
    obtain ⟨ab, hab'⟩ := deleteEdges_adj.mp hab
    obtain ⟨bc, hbc'⟩ := deleteEdges_adj.mp hbc
    have hp : MonoPath C (a, b, c) := ⟨hac, ab, bc, he⟩
    apply hit _ hp
    apply Finset.disjoint_left.mpr
    intro e he' hd
    simp only [pathEdges, Finset.mem_insert, Finset.mem_singleton] at he'
    rcases he' with rfl | rfl
    · exact hab' hd
    · exact hbc' hd
  · rw [← G.coe_edgeFinset, ← F.coe_edgeFinset, Set.ncard_coe_finset, Set.ncard_coe_finset]
    change G.edgeFinset.card ≤ (G.deleteEdges D).edgeFinset.card + _
    rw [G.edgeFinset_deleteEdges]
    have hpart := Finset.card_sdiff_add_card_inter G.edgeFinset D
    have hinter := Finset.card_le_card (Finset.inter_subset_right : G.edgeFinset ∩ D ⊆ D)
    omega

/-- The triangle removal lemma makes the triangle extremal number subquadratic. -/
theorem ruzsaSzemeredi_eventually_small (ε : ℝ) (hε : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (ruzsaSzemerediNumberNat n : ℝ) < ε * (n : ℝ) ^ 2 := by
  classical
  let δ := triangleRemovalBound ε
  have hd : 0 < δ := triangleRemovalBound_pos hε
  obtain ⟨N, hN⟩ := exists_nat_gt (1 / δ)
  filter_upwards [eventually_ge_atTop N] with n hn
  have hn' : 1 / δ < (n : ℝ) := hN.trans_le (by exact_mod_cast hn)
  have scale : 1 < (n : ℝ) * δ := (div_lt_iff₀ hd).mp hn'
  have np : 0 < (n : ℝ) := (div_pos zero_lt_one hd).trans hn'
  by_contra! large
  obtain ⟨G, inst, hcount, hlin⟩ := ruzsaSzemerediNumber_spec (α := Fin n)
  letI := inst
  have far : G.FarFromTriangleFree ε := hlin.1.farFromTriangleFree (by
    rw [hcount]
    simpa using large)
  have many := far.le_card_cliqueFinset
  rw [hcount] at many
  change triangleRemovalBound ε * (Fintype.card (Fin n) : ℝ) ^ 3 ≤ (ruzsaSzemerediNumberNat n : ℝ) at many
  rw [Fintype.card_fin] at many
  have upper : ruzsaSzemerediNumberNat n ≤ n ^ 2 := by
    have hM := (le_maxRainbowC4Edges_iff.mp (le_refl (maxRainbowC4Edges n))).le_choose_two
    have hs := three_mul_ruzsaSzemerediNumber_le n
    have hN := Nat.choose_le_pow n 2
    omega
  have bound : (ruzsaSzemerediNumberNat n : ℝ) ≤ (n : ℝ) ^ 2 := by exact_mod_cast upper
  have bigger := mul_lt_mul_of_pos_right scale (sq_pos_of_pos np)
  change δ * (n : ℝ) ^ 3 ≤ _ at many
  nlinarith

/-- Uniform over palettes of any size, at most εn² edges have to be deleted
for all sufficiently large n. The restricted original labeling is proper and rainbow. -/
theorem proper_subgraph_sparse_loss (ε : ℝ) (hε : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, ∀ (K : Type u) (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling K),
      C.IsRainbowFor (cycleGraph 4) → ∃ (F : SimpleGraph (Fin n)) (hFG : F ≤ G),
      ProperAtVertices (C.pullback (Hom.ofLE hFG)) ∧ (C.pullback (Hom.ofLE hFG)).IsRainbowFor (cycleGraph 4) ∧
      (G.edgeSet.ncard : ℝ) ≤ (F.edgeSet.ncard : ℝ) + ε * (n : ℝ) ^ 2 := by
  obtain ⟨N, hN⟩ := eventually_atTop.mp (ruzsaSzemeredi_eventually_small (ε / 18) (by positivity))
  filter_upwards [eventually_ge_atTop N] with n hn
  intro K G C hr
  obtain ⟨F, hFG, hp, hF, hcount⟩ := proper_subgraph G C hr
  refine ⟨F, hFG, hp, hF, ?_⟩
  rw [Fintype.card_fin] at hcount
  have realCount : (G.edgeSet.ncard : ℝ) ≤ (F.edgeSet.ncard : ℝ) +
      2 * (ruzsaSzemerediNumberNat (3 * n) : ℝ) := by exact_mod_cast hcount
  have small := hN (3 * n) (by omega)
  simp only [Nat.cast_mul, Nat.cast_ofNat] at small
  linarith

/-- The original positive-density question is equivalent to its proper-coloring version. -/
theorem positiveDensity_iff_proper : PositiveDensity ↔
    ∃ ε > (0 : ℝ), ∀ᶠ n : ℕ in atTop, ∃ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      ε * (n : ℝ) ^ 2 ≤ G.edgeSet.ncard ∧ ProperAtVertices C ∧ C.IsRainbowFor (cycleGraph 4) := by
  constructor
  · rintro ⟨ε, hε, hdense⟩
    refine ⟨ε / 2, by positivity, ?_⟩
    filter_upwards [hdense, proper_subgraph_sparse_loss (ε / 2) (by positivity)] with n hn hproper
    obtain ⟨G, hm, C, hr⟩ := hn
    obtain ⟨F, hFG, hp, hF, he⟩ := hproper (Fin n) G C hr
    exact ⟨F, C.pullback (Hom.ofLE hFG), by linarith, hp, hF⟩
  · rintro ⟨ε, hε, hdense⟩
    refine ⟨ε, hε, ?_⟩
    filter_upwards [hdense] with n hn
    obtain ⟨G, C, he, _, hr⟩ := hn
    exact ⟨G, he, C, hr⟩

end Erdos810

#assert_no_sorry
  Erdos810.mono_path_unique_middle
  Erdos810.proper_subgraph
  Erdos810.ruzsaSzemeredi_eventually_small
  Erdos810.proper_subgraph_sparse_loss
  Erdos810.positiveDensity_iff_proper
