import BruteForce
import Mathlib.Combinatorics.Hall.Finite
import Mathlib.Combinatorics.Enumerative.DoubleCounting
import Mathlib.Data.Sym.Card

/-!
# A Hall reduction for Erdős #810

The graph and rainbow predicates come from the archive's Lean 4.24 finite model.
The triple-system convention counts triples in sets of exactly seven vertices.
For `n ≥ 7` we construct one distinct graph edge per triple, colored by its omitted point.
-/

set_option autoImplicit false

open Filter SimpleGraph

namespace Erdos810

variable {n : ℕ}

/-- Every seven vertices contain at most three members of the family. -/
def SevenFourFree (H : Finset (Finset (Fin n))) : Prop :=
  ∀ S : Finset (Fin n), S.card = 7 → (H.filter (fun t ↦ t ⊆ S)).card < 4

/-- The specialization `g(n;7,4)` of the archive's `brownErdosSosTripleNumber`. -/
noncomputable def sevenFourNumber (n : ℕ) : ℕ :=
  sSup {m | ∃ H : Finset (Finset (Fin n)), H.card = m ∧
    (∀ t ∈ H, t.card = 3) ∧ SevenFourFree H}

variable {H : Finset (Finset (Fin n))}

/-- Pad a set of at most seven points to apply the archive's exact-seven convention. -/
theorem SevenFourFree.card_filter_lt_four (hfree : SevenFourFree H) (hn : 7 ≤ n)
    (S : Finset (Fin n)) (hs : S.card ≤ 7) : (H.filter (fun t ↦ t ⊆ S)).card < 4 := by
  obtain ⟨U, hSU, _, hU⟩ := Finset.exists_subsuperset_card_eq (Finset.subset_univ S) hs
    (by simpa using hn)
  apply lt_of_le_of_lt (Finset.card_le_card ?_) (hfree U hU)
  exact Finset.monotone_filter_right _ (fun _ ht ↦ ht.trans hSU)

private theorem few_triples_on (hn : 7 ≤ n) (hfree : SevenFourFree H)
    (F : Finset ↥H) (S : Finset (Fin n)) (hs : S.card ≤ 7)
    (hsub : ∀ t ∈ F, t.val ⊆ S) : F.card < 4 := by
  apply lt_of_le_of_lt _ (hfree.card_filter_lt_four hn S hs)
  exact Finset.card_le_card_of_injOn Subtype.val
    (fun t ht ↦ Finset.mem_filter.mpr ⟨t.property, hsub t ht⟩)
    Subtype.val_injective.injOn

/-- The unordered pairs of distinct vertices in a triple. -/
def shadowPairs (t : Finset (Fin n)) : Finset (Sym2 (Fin n)) :=
  t.offDiag.image Sym2.mk

theorem shadowPair_endpoints {t : Finset (Fin n)} {p : Sym2 (Fin n)} (hp : p ∈ shadowPairs t) :
    ¬p.IsDiag ∧ p.toFinset ⊆ t := by
  obtain ⟨⟨x, y⟩, hxy, rfl⟩ := Finset.mem_image.mp hp
  obtain ⟨hx, hy, hne⟩ := Finset.mem_offDiag.mp hxy
  exact ⟨hne, by simpa only [Sym2.toFinset_mk_eq, Finset.insert_subset_iff,
    Finset.singleton_subset_iff] using And.intro hx hy⟩

/-- Four triples through one pair would use at most six vertices. -/
private theorem pair_degree_le_three (hn : 7 ≤ n) (hfree : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (F : Finset ↥H) (p : Sym2 (Fin n)) :
    (F.filter (fun t ↦ p ∈ shadowPairs t.val)).card ≤ 3 := by
  classical
  by_contra! h
  obtain ⟨B, hB, hfour⟩ := Finset.exists_subset_card_eq (show 4 ≤ _ from h)
  have contains (t : ↥H) (ht : t ∈ B) := shadowPair_endpoints (Finset.mem_filter.mp (hB ht)).2
  obtain ⟨t₀, ht₀⟩ := Finset.card_pos.mp (show 0 < B.card by omega)
  have hp := Sym2.card_toFinset_of_not_isDiag p (contains t₀ ht₀).1
  let extra (t : ↥H) := t.val \ p.toFinset
  have hone (t : ↥H) (ht : t ∈ B) : (extra t).card = 1 := by
    dsimp only [extra]
    rw [Finset.card_sdiff_of_subset (contains t ht).2, hthree t t.property, hp]
  have hextra : (B.biUnion extra).card ≤ 4 := calc
    _ ≤ ∑ t ∈ B, (extra t).card := Finset.card_biUnion_le
    _ = ∑ _t ∈ B, 1 := Finset.sum_congr rfl hone
    _ = 4 := by simp [hfour]
  have hspan : (p.toFinset ∪ B.biUnion extra).card ≤ 7 := by
    have := Finset.card_union_le p.toFinset (B.biUnion extra)
    omega
  have := few_triples_on hn hfree B _ hspan (by
    intro t ht x hx
    by_cases hxp : x ∈ p.toFinset
    · exact Finset.mem_union_left _ hxp
    · exact Finset.mem_union_right _ (Finset.mem_biUnion.mpr
        ⟨t, ht, Finset.mem_sdiff.mpr ⟨hx, hxp⟩⟩))
  omega

/-- Hall's theorem chooses a different contained pair for every triple. -/
private theorem distinct_pairs (hn : 7 ≤ n) (hfree : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) :
    ∃ pair : ↥H → Sym2 (Fin n), Function.Injective pair ∧ ∀ t, pair t ∈ shadowPairs t.val := by
  classical
  apply (Finset.all_card_le_biUnion_card_iff_existsInjective' (fun t : ↥H ↦ shadowPairs t.val)).mp
  intro F
  let P := F.biUnion (fun t ↦ shadowPairs t.val)
  have hleft (t : ↥H) (ht : t ∈ F) :
      3 ≤ (P.bipartiteAbove (fun u : ↥H ↦ fun p ↦ p ∈ shadowPairs u.val) t).card := by
    have heq : P.bipartiteAbove (fun u : ↥H ↦ fun p ↦ p ∈ shadowPairs u.val) t = shadowPairs t.val := by
      ext p
      rw [Finset.mem_bipartiteAbove]
      exact ⟨And.right, fun hp ↦ ⟨Finset.mem_biUnion.mpr ⟨t, ht, hp⟩, hp⟩⟩
    rw [heq, shadowPairs, Sym2.card_image_offDiag, hthree t t.property]
    decide
  have hcount := Finset.card_mul_le_card_mul (fun (t : ↥H) p ↦ p ∈ shadowPairs t.val)
    hleft (fun p _ ↦ pair_degree_le_three hn hfree hthree F p)
  change F.card ≤ P.card
  omega

private theorem rainbow_of_triple_labels (hn : 7 ≤ n) (hfree : SevenFourFree H)
    {G : SimpleGraph (Fin n)} (C : G.EdgeLabeling (Fin n)) (owner : G.edgeSet → ↥H)
    (hinj : Function.Injective owner)
    (htriple : ∀ e : G.edgeSet, (owner e).val = insert (C e) e.val.toFinset) :
    C.IsRainbowFor (cycleGraph 4) := by
  have hfour : Fintype.card (cycleGraph 4).edgeSet = 4 := by decide
  classical
  intro f
  let color (e : (cycleGraph 4).edgeSet) := C (f.mapEdgeSet e)
  change Function.Injective color
  by_contra hdup
  let vertices := Finset.univ.image (fun i : Fin 4 ↦ f i)
  let colors := Finset.univ.image color
  have hv : vertices.card ≤ 4 := by
    simpa using (Finset.card_image_le : vertices.card ≤ (Finset.univ : Finset (Fin 4)).card)
  have hc : colors.card < Fintype.card (cycleGraph 4).edgeSet := by
    apply lt_of_le_of_ne (Finset.card_image_le.trans_eq Finset.card_univ)
    intro heq
    apply hdup
    have hi := Finset.card_image_iff.mp (heq.trans Finset.card_univ.symm)
    exact fun a b hab ↦ hi (Finset.mem_univ a) (Finset.mem_univ b) hab
  have hspan : (vertices ∪ colors).card ≤ 7 := by
    have := Finset.card_union_le vertices colors
    omega
  let family := Finset.univ.image (owner ∘ f.mapEdgeSet)
  have hfamily : family.card = 4 := by
    dsimp only [family]
    rw [Finset.card_image_of_injective _ (hinj.comp f.mapEdgeSet.injective),
      Finset.card_univ, hfour]
  have := few_triples_on hn hfree family _ hspan (by
    intro t ht
    obtain ⟨e, _, rfl⟩ := Finset.mem_image.mp ht
    rw [Function.comp_apply, htriple]
    intro x hx
    rcases Finset.mem_insert.mp hx with rfl | hx
    · exact Finset.mem_union_right _ (Finset.mem_image_of_mem color (Finset.mem_univ e))
    · change x ∈ (Sym2.map (fun i ↦ f i) e.val).toFinset at hx
      obtain ⟨i, _, rfl⟩ := Sym2.mem_map.mp (Sym2.mem_toFinset.mp hx)
      exact Finset.mem_union_left _ (Finset.mem_image_of_mem _ (Finset.mem_univ i)))
  omega

/-- Assign one edge to each triple, using its third vertex as an edge color. -/
theorem exists_rainbowGraph_of_sevenFourFree (hn : 7 ≤ n) (hthree : ∀ t ∈ H, t.card = 3)
    (hfree : SevenFourFree H) :
    ∃ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      G.edgeSet.ncard = H.card ∧ C.IsRainbowFor (cycleGraph 4) := by
  classical
  obtain ⟨pair, hinj, hpair⟩ := distinct_pairs hn hfree hthree
  let G := fromEdgeSet (Set.range pair)
  have edges : G.edgeSet = Set.range pair := by
    change (fromEdgeSet _).edgeSet = _
    rw [edgeSet_fromEdgeSet]
    apply Set.Subset.antisymm (fun _ h ↦ h.1)
    rintro _ ⟨t, rfl⟩
    exact ⟨⟨t, rfl⟩, (shadowPair_endpoints (hpair t)).1⟩
  have rep (e : G.edgeSet) : ∃ t, pair t = e.val := edges.subset e.property
  let owner (e : G.edgeSet) : ↥H := (rep e).choose
  have owner_spec (e : G.edgeSet) : pair (owner e) = e.val := (rep e).choose_spec
  have owner_inj : Function.Injective owner := by
    intro e e' he
    exact Subtype.ext ((owner_spec e).symm.trans ((congrArg pair he).trans (owner_spec e')))
  have omitted (t : ↥H) : ∃ z, t.val = insert z (pair t).toFinset := by
    obtain ⟨hne, hsub⟩ := shadowPair_endpoints (hpair t)
    have hone : (t.val \ (pair t).toFinset).card = 1 := by
      rw [Finset.card_sdiff_of_subset hsub, hthree t t.property,
        Sym2.card_toFinset_of_not_isDiag _ hne]
    obtain ⟨z, hz⟩ := Finset.card_eq_one.mp hone
    exact ⟨z, by simpa [hz] using (Finset.sdiff_union_of_subset hsub).symm⟩
  let C : G.EdgeLabeling (Fin n) := fun e ↦ (omitted (owner e)).choose
  refine ⟨G, C, ?_, rainbow_of_triple_labels hn hfree C owner owner_inj ?_⟩
  · rw [edges, Set.ncard_range_of_injective hinj, Nat.card_eq_fintype_card, Fintype.card_coe]
  · intro e
    calc
      (owner e).val = insert (C e) (pair (owner e)).toFinset := (omitted (owner e)).choose_spec
      _ = _ := by rw [owner_spec e]

/-- The finite lower bound has constant one and applies to every `n ≥ 7`. -/
theorem sevenFourNumber_le_maxRainbowC4Edges (hn : 7 ≤ n) :
    sevenFourNumber n ≤ maxRainbowC4Edges n := by
  apply csSup_le'
  rintro m ⟨H, rfl, hthree, hfree⟩
  obtain ⟨G, C, hcard, hrainbow⟩ := exists_rainbowGraph_of_sevenFourFree hn hthree hfree
  exact le_maxRainbowC4Edges_iff.mpr ⟨G, hcard.ge, C, hrainbow⟩

/-- The eventual constant-factor formulation in the standalone problem statement. -/
theorem sevenFour_eventual_lower_bound :
    ∃ c > (0 : ℝ), ∀ᶠ n : ℕ in atTop, c * sevenFourNumber n ≤ maxRainbowC4Edges n := by
  refine ⟨1, zero_lt_one, ?_⟩
  filter_upwards [eventually_ge_atTop 7] with n hn
  simpa only [one_mul, Nat.cast_le] using sevenFourNumber_le_maxRainbowC4Edges hn

/-- The Ruzsa–Szemerédi lower-bound construction passes through the Hall reduction.
On seven vertices each triple misses four points. If every six vertices contain at most
two triples, there are at most fourteen missing incidences, too few for four triples. -/
theorem sevenFourFree_of_sixThreeFree (hthree : ∀ t ∈ H, t.card = 3)
    (h63 : ∀ U : Finset (Fin n), U.card = 6 → (H.filter (fun t ↦ t ⊆ U)).card < 3) :
    SevenFourFree H := by
  classical
  intro S hS
  let F := H.filter (fun t ↦ t ⊆ S)
  have hleft (t : Finset (Fin n)) (ht : t ∈ F) :
      4 ≤ (S.bipartiteAbove (fun u x ↦ x ∉ u) t).card := by
    obtain ⟨htH, hsub⟩ := Finset.mem_filter.mp ht
    have hdiff : S.bipartiteAbove (fun (u : Finset (Fin n)) x ↦ x ∉ u) t = S \ t := by
      ext x
      rw [Finset.mem_bipartiteAbove, Finset.mem_sdiff]
    rw [hdiff, Finset.card_sdiff_of_subset hsub, hS, hthree t htH]
  have hright (x : Fin n) (hx : x ∈ S) :
      (F.bipartiteBelow (fun u x ↦ x ∉ u) x).card ≤ 2 := by
    have herase : (S.erase x).card = 6 := by rw [Finset.card_erase_of_mem hx, hS]
    apply Nat.le_of_lt_succ (lt_of_le_of_lt (Finset.card_le_card ?_) (h63 _ herase))
    intro t ht
    obtain ⟨htF, hxt⟩ := (Finset.mem_bipartiteBelow _).mp ht
    obtain ⟨htH, hsub⟩ := Finset.mem_filter.mp htF
    refine Finset.mem_filter.mpr ⟨htH, fun y hy ↦ Finset.mem_erase.mpr ⟨?_, hsub hy⟩⟩
    exact fun heq ↦ hxt (heq ▸ hy)
  have hcount := Finset.card_mul_le_card_mul (fun (t : Finset (Fin n)) x ↦ x ∉ t) hleft hright
  change F.card < 4
  omega

/-- Below seven vertices the exact-seven condition is vacuous. -/
theorem sevenFourNumber_of_lt_seven (hn : n < 7) : sevenFourNumber n = n.choose 3 := by
  let triples := (Finset.univ : Finset (Fin n)).powersetCard 3
  have hcard : triples.card = n.choose 3 := by simp [triples, Finset.card_powersetCard]
  apply IsGreatest.csSup_eq
  constructor
  · refine ⟨triples, hcard, fun _ ht ↦ (Finset.mem_powersetCard.mp ht).2, ?_⟩
    intro S hS
    have hle := Finset.card_le_card (Finset.subset_univ S)
    simp only [Finset.card_univ, Fintype.card_fin] at hle
    omega
  · rintro m ⟨F, rfl, hthree, _⟩
    apply le_trans _ hcard.le
    exact Finset.card_le_card (fun t ht ↦ Finset.mem_powersetCard.mpr
      ⟨Finset.subset_univ _, hthree t ht⟩)

/-- The finite reduction fails at six under the archive's exact-seven convention. -/
theorem six_vertex_boundary : sevenFourNumber 6 = 20 ∧ maxRainbowC4Edges 6 = 11 := by
  exact ⟨(sevenFourNumber_of_lt_seven (by decide)).trans (by decide), maxRainbowC4Edges_six⟩

/-- The affirmative statement of unrestricted #810. -/
def PositiveDensity : Prop :=
  ∃ ε > (0 : ℝ), ∀ᶠ n : ℕ in atTop, ∃ G : SimpleGraph (Fin n),
    ε * n ^ 2 ≤ G.edgeSet.ncard ∧ ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4)

/-- A uniform positive density of admissible triples suffices for a positive answer to #810. -/
theorem positiveDensity_of_dense_sevenFour
    (h : ∃ ε > (0 : ℝ), ∀ᶠ n : ℕ in atTop, ε * n ^ 2 ≤ sevenFourNumber n) : PositiveDensity := by
  apply erdos_810_iff_maxRainbowC4Edges.mpr
  obtain ⟨ε, hε, hdense⟩ := h
  refine ⟨ε, hε, ?_⟩
  filter_upwards [hdense, eventually_ge_atTop 7] with n hd hn
  exact hd.trans (by exact_mod_cast sevenFourNumber_le_maxRainbowC4Edges hn)

end Erdos810

#assert_no_sorry
  Erdos810.exists_rainbowGraph_of_sevenFourFree
  Erdos810.sevenFourNumber_le_maxRainbowC4Edges
  Erdos810.sevenFour_eventual_lower_bound
  Erdos810.sevenFourFree_of_sixThreeFree
  Erdos810.sevenFourNumber_of_lt_seven
  Erdos810.six_vertex_boundary
  Erdos810.positiveDensity_of_dense_sevenFour
