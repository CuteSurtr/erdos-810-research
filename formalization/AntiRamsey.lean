/-
Copyright 2026 The Formal Conjectures Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-/
module

public import FormalConjecturesForMathlib.Combinatorics.SimpleGraph.Coloring.Vertex
public import Mathlib.Algebra.Order.Archimedean.Real.Basic
public import Mathlib.Combinatorics.SimpleGraph.CycleGraph
public import Mathlib.Data.Fin.VecNotation
public import Mathlib.Data.Nat.Choose.Cast
public import Mathlib.Order.Filter.AtTopBot.Defs

/-!
# Rainbow copies and maximal anti-Ramsey numbers

An edge labeling `C` of a graph `G` is *rainbow for* `H` (`C.IsRainbowFor H`) if every copy of
`H` in `G` is rainbow in the sense of `SimpleGraph.IsRainbow`, that is, gets pairwise distinct
labels on its edges. Burr, Erdős, Graham and Sós [BEGS89] call such a copy *totally multicolored*.
A copy is a subgraph, not necessarily induced.

The *maximal anti-Ramsey number* `maxAntiRamseyNumber n e H`, written $\chi_S(n, e, H)$ in
[BEGS89], is the least number of labels `r` such that some graph on `n` vertices with exactly `e`
edges has an edge labeling with `r` labels that is rainbow for `H`. It is `0` when no graph on `n`
vertices has `e` edges, see `maxAntiRamseyNumber_eq_zero_of_choose_two_lt`. It is not the
anti-Ramsey number `SimpleGraph.antiRamseyNum`, which is the largest number of colours on the
edges of $K_n$ with no rainbow copy of `H`.

## Main statements

* `SimpleGraph.maxAntiRamseyNumber_le_iff`: for `e ≤ n.choose 2`, $\chi_S(n, e, H) \le r$ if and
  only if some graph on `n` vertices with at least `e` edges has a labeling with `r` labels that
  is rainbow for `H`.
* `SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff`: a labeling is rainbow for $C_4$ if
  and only if every $4$-cycle gets four distinct labels.
* `SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff_c4ConflictGraph`: a labeling is
  rainbow for $C_4$ if and only if it is a proper vertex coloring of the $C_4$-conflict graph
  `c4ConflictGraph G`.

## References

* [BEGS89] Burr, S. A., Erdős, P., Graham, R. L. and Sós, V. T., *Maximal anti-Ramsey graphs and
  the strong chromatic number*. J. Graph Theory 13 (1989), 263-282.
-/

@[expose] public section

open Filter

/-- Some graph on `n` vertices has at least `⌈ε n ^ 2⌉` edges once `n` is large, if `ε < 1 / 2`. -/
lemma eventually_ceil_mul_sq_le_choose_two {ε : ℝ} (hε : ε < 1 / 2) :
    ∀ᶠ n : ℕ in atTop, ⌈ε * n ^ 2⌉₊ ≤ n.choose 2 := by
  have h₁ : (0 : ℝ) < 1 - 2 * ε := by linarith
  obtain ⟨N, hN⟩ := exists_nat_gt (1 / (1 - 2 * ε))
  filter_upwards [eventually_ge_atTop N] with n hn
  have hn' : 1 / (1 - 2 * ε) < n := hN.trans_le (by exact_mod_cast hn)
  have h₂ : 1 < n * (1 - 2 * ε) := by rwa [div_lt_iff₀ h₁] at hn'
  have h₃ : (0 : ℝ) < n := lt_of_le_of_lt (by positivity) hn'
  rw [Nat.ceil_le, Nat.cast_choose_two]
  nlinarith [mul_lt_mul_of_pos_left h₂ h₃]

namespace SimpleGraph

variable {V V' W : Type*} {G : SimpleGraph V} {G' : SimpleGraph V'} {H : SimpleGraph W}
  {K K' : Type*}

namespace EdgeLabeling

/-! ### Rainbow labelings -/

/-- An edge labeling `C` of `G` is rainbow for `H` if every copy of `H` in `G` is rainbow, that is,
gets pairwise distinct labels on its edges. -/
def IsRainbowFor (C : G.EdgeLabeling K) (H : SimpleGraph W) : Prop :=
  ∀ f : H.Copy G, IsRainbow f.toHom C

lemma isRainbowFor_iff {C : G.EdgeLabeling K} :
    C.IsRainbowFor H ↔
      ∀ f : H.Copy G, ∀ e₁ e₂, C (f.mapEdgeSet e₁) = C (f.mapEdgeSet e₂) → e₁ = e₂ :=
  Iff.rfl

lemma pullback_pullback (C : G.EdgeLabeling K) (g : G' →g G) (f : H →g G') :
    (C.pullback g).pullback f = C.pullback (g.comp f) := by
  funext e
  simp only [pullback_apply]
  congr 1
  ext
  simp [Hom.mapEdgeSet, Sym2.map_map]

/-- Being rainbow is preserved by pulling back along a copy. -/
lemma IsRainbowFor.pullback {C : G.EdgeLabeling K} (hC : C.IsRainbowFor H) (g : G'.Copy G) :
    (C.pullback g.toHom).IsRainbowFor H := by
  intro f
  unfold IsRainbow
  rw [pullback_pullback]
  exact hC (g.comp f)

/-- The restriction of a labeling which is rainbow for `H` to a subgraph is rainbow for `H`. -/
lemma IsRainbowFor.pullback_ofLE {G₁ : SimpleGraph V} {C : G.EdgeLabeling K}
    (hC : C.IsRainbowFor H) (h : G₁ ≤ G) : (C.pullback (Hom.ofLE h)).IsRainbowFor H :=
  hC.pullback (Copy.ofLE G₁ G h)

/-- Relabeling along an injective map preserves being rainbow. -/
lemma IsRainbowFor.compRight {C : G.EdgeLabeling K} (hC : C.IsRainbowFor H) {g : K → K'}
    (hg : Function.Injective g) : (C.compRight g).IsRainbowFor H :=
  fun f ↦ hg.comp (hC f)

/-- An injective labeling is rainbow for every graph. -/
lemma isRainbowFor_of_injective {C : G.EdgeLabeling K} (hC : Function.Injective C) :
    C.IsRainbowFor H :=
  fun f ↦ hC.comp f.mapEdgeSet.injective

/-- If `G` contains no copy of `H`, then every labeling of `G` is rainbow for `H`. -/
lemma isRainbowFor_of_free (hH : H.Free G) (C : G.EdgeLabeling K) : C.IsRainbowFor H :=
  fun f ↦ (hH ⟨f⟩).elim

/-- A labeling is rainbow for $C_4$ if and only if every $4$-cycle `a b c d` of `G` gets four
distinct labels. -/
lemma isRainbowFor_cycleGraph_four_iff {C : G.EdgeLabeling K} :
    C.IsRainbowFor (cycleGraph 4) ↔
      ∀ a b c d (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d) (hda : G.Adj d a),
        a ≠ c → b ≠ d → [C.get a b hab, C.get b c hbc, C.get c d hcd, C.get d a hda].Nodup := by
  -- The edges of the cycle `0 - 1 - 2 - 3 - 0`.
  let e : Fin 4 → (cycleGraph 4).edgeSet :=
    ![⟨s(0, 1), by decide⟩, ⟨s(1, 2), by decide⟩, ⟨s(2, 3), by decide⟩, ⟨s(3, 0), by decide⟩]
  have he : Function.Injective e := by decide
  have he' : Function.Surjective e := by decide
  constructor
  · intro hC a b c d hab hbc hcd hda hac hbd
    let f : Fin 4 → V := ![a, b, c, d]
    have hf : ∀ {i j}, (cycleGraph 4).Adj i j → G.Adj (f i) (f j) := by
      intro i j h
      fin_cases i <;> fin_cases j <;> first
        | exact absurd h (by decide)
        | simpa [f] using hab | simpa [f] using hab.symm
        | simpa [f] using hbc | simpa [f] using hbc.symm
        | simpa [f] using hcd | simpa [f] using hcd.symm
        | simpa [f] using hda | simpa [f] using hda.symm
    have hinj : Function.Injective f := by
      have := G.ne_of_adj hab
      have := G.ne_of_adj hbc
      have := G.ne_of_adj hcd
      have := G.ne_of_adj hda
      intro i j h
      fin_cases i <;> fin_cases j <;> simp_all [f, eq_comm]
    exact List.nodup_ofFn.mpr (Function.Injective.comp (hC ⟨⟨f, hf⟩, hinj⟩) he)
  · intro h f
    have hL := h (f 0) (f 1) (f 2) (f 3) (f.toHom.map_adj (by decide))
      (f.toHom.map_adj (by decide)) (f.toHom.map_adj (by decide)) (f.toHom.map_adj (by decide))
      (f.injective.ne (by decide)) (f.injective.ne (by decide))
    exact Function.Injective.of_comp_right (g := e) (List.nodup_ofFn.mp hL) he'

end EdgeLabeling

/-! ### Conflict graph $Q(G)$ for $C_4$ -/

/-- The $C_4$-conflict graph $Q(G)$ on the edges of `G`: two distinct edges are adjacent iff they
occur together in at least one copy of $C_4$ in `G`. -/
def c4ConflictGraph (G : SimpleGraph V) : SimpleGraph G.edgeSet where
  Adj e₁ e₂ := e₁ ≠ e₂ ∧ ∃ f : (cycleGraph 4).Copy G,
    e₁ ∈ Set.range f.mapEdgeSet ∧ e₂ ∈ Set.range f.mapEdgeSet
  symm _ _ := fun ⟨hne, f, h₁, h₂⟩ ↦ ⟨hne.symm, f, h₂, h₁⟩
  loopless _ := fun ⟨hne, _⟩ ↦ hne rfl

/-- An edge labeling `C` of `G` is rainbow for $C_4$ iff `C` is a proper vertex coloring of the
$C_4$-conflict graph `c4ConflictGraph G`. -/
lemma EdgeLabeling.isRainbowFor_cycleGraph_four_iff_c4ConflictGraph {C : G.EdgeLabeling K} :
    C.IsRainbowFor (cycleGraph 4) ↔
      ∀ ⦃e₁ e₂ : G.edgeSet⦄, (c4ConflictGraph G).Adj e₁ e₂ → C e₁ ≠ C e₂ := by
  constructor
  · intro hC e₁ e₂ ⟨hne, f, ⟨x₁, hx₁⟩, ⟨x₂, hx₂⟩⟩ heq
    apply hne
    rw [← hx₁, ← hx₂] at heq ⊢
    exact congrArg f.mapEdgeSet (hC f heq)
  · intro h f x₁ x₂ heq
    by_contra hne
    have hfe : f.mapEdgeSet x₁ ≠ f.mapEdgeSet x₂ := f.mapEdgeSet.injective.ne hne
    exact h ⟨hfe, f, ⟨x₁, rfl⟩, ⟨x₂, rfl⟩⟩ heq

/-! ### Edge counts -/

lemma ncard_edgeSet_le_choose_two [Fintype V] (G : SimpleGraph V) :
    G.edgeSet.ncard ≤ (Fintype.card V).choose 2 := by
  classical
  rw [← coe_edgeFinset, Set.ncard_coe_finset]
  exact G.card_edgeFinset_le_card_choose_two

lemma ncard_edgeSet_top [Fintype V] :
    (⊤ : SimpleGraph V).edgeSet.ncard = (Fintype.card V).choose 2 := by
  classical
  rw [← coe_edgeFinset, Set.ncard_coe_finset, card_edgeFinset_top_eq_card_choose_two]

/-- A graph with at least `e` edges has a subgraph with exactly `e` edges. -/
lemma exists_le_ncard_edgeSet_eq {e : ℕ} (he : e ≤ G.edgeSet.ncard) :
    ∃ G₁ ≤ G, G₁.edgeSet.ncard = e := by
  obtain ⟨s, hs, rfl⟩ := Set.exists_subset_card_eq he
  refine ⟨fromEdgeSet s, (fromEdgeSet_mono hs).trans_eq (fromEdgeSet_edgeSet G), ?_⟩
  have : s \ Sym2.diagSet = s :=
    sdiff_eq_left.mpr (Set.disjoint_left.mpr fun x hx ↦ G.not_isDiag_of_mem_edgeSet (hs hx))
  rw [edgeSet_fromEdgeSet, this]

/-- A graph with exactly `e` edges has an injective labeling with `e` labels. -/
lemma exists_injective_edgeLabeling [Finite V] {e : ℕ} (he : G.edgeSet.ncard = e) :
    ∃ C : G.EdgeLabeling (Fin e), Function.Injective C := by
  have := Fintype.ofFinite G.edgeSet
  have h : Fintype.card G.edgeSet = e := by rw [← Nat.card_eq_fintype_card, Nat.card_coe_set_eq, he]
  exact ⟨⇑((Fintype.equivFin G.edgeSet).trans (finCongr h)), Equiv.injective _⟩

/-- No graph on `n ≥ 1` vertices has `ε n ^ 2` edges if `ε ≥ 1 / 2`. -/
lemma lt_half_of_mul_sq_le_ncard {n : ℕ} {ε : ℝ} (hn : 0 < n) (G : SimpleGraph (Fin n))
    (h : ε * n ^ 2 ≤ G.edgeSet.ncard) : ε < 1 / 2 := by
  have h₁ : (G.edgeSet.ncard : ℝ) ≤ n.choose 2 := by
    exact_mod_cast (ncard_edgeSet_le_choose_two G).trans_eq (by simp)
  rw [Nat.cast_choose_two] at h₁
  have h₂ : (0 : ℝ) < n := by exact_mod_cast hn
  by_contra! hε
  nlinarith [mul_le_mul_of_nonneg_right hε (sq_nonneg (n : ℝ))]

/-! ### Maximal anti-Ramsey numbers -/

/-- The maximal anti-Ramsey number $\chi_S(n, e, H)$ of [BEGS89]: the least number of labels `r`
such that some graph on `n` vertices with exactly `e` edges has an edge labeling with `r` labels
that is rainbow for `H`. It is `0` if no graph on `n` vertices has `e` edges. -/
noncomputable def maxAntiRamseyNumber (n e : ℕ) (H : SimpleGraph W) : ℕ :=
  sInf {r | ∃ G : SimpleGraph (Fin n), G.edgeSet.ncard = e ∧
    ∃ C : G.EdgeLabeling (Fin r), C.IsRainbowFor H}

variable {n e r : ℕ}

private lemma self_mem_maxAntiRamseyNumber_set (he : e ≤ n.choose 2) :
    e ∈ {r | ∃ G : SimpleGraph (Fin n), G.edgeSet.ncard = e ∧
      ∃ C : G.EdgeLabeling (Fin r), C.IsRainbowFor H} := by
  have htop : e ≤ (⊤ : SimpleGraph (Fin n)).edgeSet.ncard := by
    rw [ncard_edgeSet_top, Fintype.card_fin]
    exact he
  obtain ⟨G, -, hG⟩ := exists_le_ncard_edgeSet_eq htop
  obtain ⟨C, hC⟩ := exists_injective_edgeLabeling hG
  exact ⟨G, hG, C, EdgeLabeling.isRainbowFor_of_injective hC⟩

/-- For `e ≤ n.choose 2`, $\chi_S(n, e, H) \le r$ if and only if some graph on `n` vertices with
at least `e` edges has a labeling with `r` labels that is rainbow for `H`. -/
lemma maxAntiRamseyNumber_le_iff (he : e ≤ n.choose 2) :
    maxAntiRamseyNumber n e H ≤ r ↔ ∃ G : SimpleGraph (Fin n), e ≤ G.edgeSet.ncard ∧
      ∃ C : G.EdgeLabeling (Fin r), C.IsRainbowFor H := by
  constructor
  · intro hr
    obtain ⟨G, hG, C, hC⟩ := Nat.sInf_mem ⟨e, self_mem_maxAntiRamseyNumber_set he⟩
    exact ⟨G, hG.ge, C.compRight (Fin.castLE hr), hC.compRight (Fin.castLE_injective hr)⟩
  · rintro ⟨G, hG, C, hC⟩
    obtain ⟨G₁, hle, hG₁⟩ := exists_le_ncard_edgeSet_eq hG
    exact Nat.sInf_le ⟨G₁, hG₁, C.pullback (Hom.ofLE hle), hC.pullback_ofLE hle⟩

/-- The junk value: if no graph on `n` vertices has `e` edges, then $\chi_S(n, e, H) = 0$. -/
lemma maxAntiRamseyNumber_eq_zero_of_choose_two_lt (he : n.choose 2 < e) :
    maxAntiRamseyNumber n e H = 0 := by
  refine Nat.sInf_eq_zero.mpr (Or.inr (Set.eq_empty_of_forall_notMem fun r ⟨G, hG, _⟩ ↦ ?_))
  have := ncard_edgeSet_le_choose_two G
  simp at this
  omega

/-- Labeling the edges injectively shows $\chi_S(n, e, H) \le e$. -/
lemma maxAntiRamseyNumber_le_self : maxAntiRamseyNumber n e H ≤ e := by
  rcases le_or_gt e (n.choose 2) with he | he
  · exact Nat.sInf_le (self_mem_maxAntiRamseyNumber_set he)
  · simp [maxAntiRamseyNumber_eq_zero_of_choose_two_lt he]

/-- Away from the junk value, at least one label is needed. -/
lemma maxAntiRamseyNumber_pos (he₀ : 0 < e) (he : e ≤ n.choose 2) :
    0 < maxAntiRamseyNumber n e H := by
  refine Nat.pos_of_ne_zero fun h ↦ ?_
  obtain ⟨G, hG, C, -⟩ := (maxAntiRamseyNumber_le_iff (H := H) he).mp h.le
  obtain ⟨x, hx⟩ := Set.nonempty_of_ncard_ne_zero (s := G.edgeSet) (by omega)
  exact (C ⟨x, hx⟩).elim0

end SimpleGraph
