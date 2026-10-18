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
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.Copy
import Mathlib.Combinatorics.SimpleGraph.Bipartite
import Mathlib.Combinatorics.SimpleGraph.CompleteMultipartite
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.Combinatorics.SimpleGraph.Maps
import Mathlib.Combinatorics.SimpleGraph.Subgraph
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Nat.Choose.Cast
import Mathlib.Data.List.Sublists
import Mathlib.Order.Filter.AtTopBot.Basic
import Mathlib.Tactic

/-!
# Erdős Problem 810: Formalization, Conflict Graph, and Brute-Force Finite Bounds

This module is a self-contained, locally kernel-verified development (compatible with Lean 4.24.0
and Mathlib v4.24.0) of Erdős Problem #810, its finite extremal function $M(n)$, the $C_4$-conflict
graph characterization, and brute-force proved finite values and certificates.

## Main Definitions

* `SimpleGraph.EdgeLabeling.IsRainbowFor`: an edge labeling of $G$ is rainbow for $H$ if every
  subgraph copy of $H$ receives pairwise distinct colors on its edges.
* `SimpleGraph.maxAntiRamseyNumber n e H`: the maximal anti-Ramsey number $\chi_S(n, e, H)$ of
  Burr, Erdős, Graham, and Sós [BEGS89].
* `SimpleGraph.c4ConflictGraph G`: the conflict graph $Q(G)$ on $E(G)$ where two distinct edges
  are adjacent iff they belong to a common 4-cycle $C_4$ in $G$.
* `Erdos810.maxRainbowC4Edges n`: the finite extremal function $M(n)$, the maximum number of edges
  in an $n$-vertex simple graph admitting a rainbow-$C_4$ edge labeling with $n$ colors.

## Main Proved Results

* `SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff_c4ConflictGraph`: an edge labeling of
  $G$ is rainbow for $C_4$ iff it is a proper vertex coloring of $Q(G)$.
* `Erdos810.erdos_810_iff_maxRainbowC4Edges`: Erdős Problem #810 is equivalent to asking whether
  $\exists \varepsilon > 0$ such that $M(n) \ge \varepsilon n^2$ for all sufficiently large $n$.
* Exact values of $M(n)$ for $0 \le n \le 6$ proved by kernel evaluation (`decide`):
  * $M(0) = 0$, $M(1) = 0$, $M(2) = 1$, $M(3) = 3$
  * $M(4) = 5$ (`maxRainbowC4Edges_four`, $\chi_S(4, 6, C_4) = 5$)
  * $M(5) = 7$ (`maxRainbowC4Edges_five`, $\chi_S(5, 8, C_4) > 5$)
  * $M(6) = 11$ (`maxRainbowC4Edges_six`, $\chi_S(6, 12, C_4) > 6$)
* Explicit rainbow-$C_4$ lower-bound certificates proved by kernel evaluation (`decide`) for
  $7 \le n \le 12$:
  * $M(7) \ge 14$, $M(8) \ge 17$, $M(9) \ge 23$, $M(10) \ge 30$, $M(11) \ge 34$, $M(12) \ge 40$.
-/

open Filter SimpleGraph

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

variable {V V' W K K' : Type*} {G : SimpleGraph V} {G' : SimpleGraph V'} {H : SimpleGraph W}

/-- An edge labeling of `G` with labels in `K`. -/
abbrev EdgeLabeling (G : SimpleGraph V) (K : Type*) := G.edgeSet → K

namespace EdgeLabeling

/-- Retrieve the label of an edge given by two adjacent vertices. -/
def get (C : G.EdgeLabeling K) (u v : V) (h : G.Adj u v) : K :=
  C ⟨s(u, v), h⟩

/-- Pull back an edge labeling along a graph homomorphism. -/
def pullback (C : G.EdgeLabeling K) (f : G' →g G) : G'.EdgeLabeling K :=
  fun e ↦ C (f.mapEdgeSet e)

@[simp] lemma pullback_apply (C : G.EdgeLabeling K) (f : G' →g G) (e : G'.edgeSet) :
    C.pullback f e = C (f.mapEdgeSet e) := rfl

/-- Post-compose an edge labeling with a map on labels. -/
def compRight (C : G.EdgeLabeling K) (g : K → K') : G.EdgeLabeling K' :=
  g ∘ C

end EdgeLabeling

/-- A homomorphism `f : H →g G` is rainbow under `C` if the pulled-back labeling is injective. -/
def IsRainbow (f : H →g G) (C : G.EdgeLabeling K) : Prop :=
  Function.Injective (C.pullback f)

/-- The cycle graph $C_n$ on `Fin n`. -/
def cycleGraph (n : ℕ) : SimpleGraph (Fin n) where
  Adj i j := i ≠ j ∧ (i.val + 1 ≡ j.val [MOD n] ∨ j.val + 1 ≡ i.val [MOD n])
  symm _ _ h := ⟨h.1.symm, h.2.symm⟩
  loopless _ h := h.1 rfl

instance (n : ℕ) : DecidableRel (cycleGraph n).Adj := fun i j ↦
  inferInstanceAs (Decidable (i ≠ j ∧ (i.val + 1 ≡ j.val [MOD n] ∨ j.val + 1 ≡ i.val [MOD n])))

namespace EdgeLabeling

/-- An edge labeling `C` of `G` is rainbow for `H` if every copy of `H` in `G` is rainbow. -/
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

lemma IsRainbowFor.pullback {C : G.EdgeLabeling K} (hC : C.IsRainbowFor H) (g : G'.Copy G) :
    (C.pullback g.toHom).IsRainbowFor H := by
  intro f
  unfold IsRainbow
  rw [pullback_pullback]
  exact hC (g.comp f)

lemma IsRainbowFor.pullback_ofLE {G₁ : SimpleGraph V} {C : G.EdgeLabeling K}
    (hC : C.IsRainbowFor H) (h : G₁ ≤ G) : (C.pullback (Hom.ofLE h)).IsRainbowFor H :=
  hC.pullback (Copy.ofLE G₁ G h)

lemma IsRainbowFor.compRight {C : G.EdgeLabeling K} (hC : C.IsRainbowFor H) {g : K → K'}
    (hg : Function.Injective g) : (C.compRight g).IsRainbowFor H :=
  fun f ↦ hg.comp (hC f)

lemma isRainbowFor_of_injective {C : G.EdgeLabeling K} (hC : Function.Injective C) :
    C.IsRainbowFor H :=
  fun f ↦ hC.comp f.mapEdgeSet.injective

lemma isRainbowFor_of_free (hH : H.Free G) (C : G.EdgeLabeling K) : C.IsRainbowFor H :=
  fun f ↦ (hH ⟨f⟩).elim

/-- A labeling is rainbow for $C_4$ if and only if every $4$-cycle `a b c d` of `G` gets four
distinct labels. -/
lemma isRainbowFor_cycleGraph_four_iff {C : G.EdgeLabeling K} :
    C.IsRainbowFor (cycleGraph 4) ↔
      ∀ a b c d (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d) (hda : G.Adj d a),
        a ≠ c → b ≠ d → [C.get a b hab, C.get b c hbc, C.get c d hcd, C.get d a hda].Nodup := by
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

/-! ### Conflict Graph $Q(G)$ for $C_4$ -/

/-- The $C_4$-conflict graph $Q(G)$ on the edges of $G$: two distinct edges of $G$ are adjacent
in $Q(G)$ iff they occur together in at least one copy of $C_4$ in $G$. -/
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

/-! ### Edge counts and maximal anti-Ramsey numbers -/

lemma ncard_edgeSet_le_choose_two [Fintype V] (G : SimpleGraph V) :
    G.edgeSet.ncard ≤ (Fintype.card V).choose 2 := by
  classical
  rw [← coe_edgeFinset, Set.ncard_coe_finset]
  exact G.card_edgeFinset_le_card_choose_two

lemma ncard_edgeSet_top [Fintype V] :
    (⊤ : SimpleGraph V).edgeSet.ncard = (Fintype.card V).choose 2 := by
  classical
  rw [← coe_edgeFinset, Set.ncard_coe_finset, card_edgeFinset_top_eq_card_choose_two]

lemma exists_le_ncard_edgeSet_eq {e : ℕ} (he : e ≤ G.edgeSet.ncard) :
    ∃ G₁ ≤ G, G₁.edgeSet.ncard = e := by
  obtain ⟨s, hs, rfl⟩ := Set.exists_subset_card_eq he
  refine ⟨fromEdgeSet s, (fromEdgeSet_mono hs).trans_eq (fromEdgeSet_edgeSet G), ?_⟩
  have : s \ {e : Sym2 V | e.IsDiag} = s :=
    sdiff_eq_left.mpr (Set.disjoint_left.mpr fun x hx ↦ G.not_isDiag_of_mem_edgeSet (hs hx))
  rw [edgeSet_fromEdgeSet, this]

lemma exists_injective_edgeLabeling [Finite V] {e : ℕ} (he : G.edgeSet.ncard = e) :
    ∃ C : G.EdgeLabeling (Fin e), Function.Injective C := by
  have := Fintype.ofFinite G.edgeSet
  have h : Fintype.card G.edgeSet = e := by rw [← Nat.card_eq_fintype_card, Nat.card_coe_set_eq, he]
  exact ⟨⇑((Fintype.equivFin G.edgeSet).trans (finCongr h)), Equiv.injective _⟩

lemma lt_half_of_mul_sq_le_ncard {n : ℕ} {ε : ℝ} (hn : 0 < n) (G : SimpleGraph (Fin n))
    (h : ε * n ^ 2 ≤ G.edgeSet.ncard) : ε < 1 / 2 := by
  have h₁ : (G.edgeSet.ncard : ℝ) ≤ n.choose 2 := by
    exact_mod_cast (ncard_edgeSet_le_choose_two G).trans_eq (by simp)
  rw [Nat.cast_choose_two] at h₁
  have h₂ : (0 : ℝ) < n := by exact_mod_cast hn
  by_contra! hε
  nlinarith [mul_le_mul_of_nonneg_right hε (sq_nonneg (n : ℝ))]

/-- The maximal anti-Ramsey number $\chi_S(n, e, H)$ of [BEGS89]. -/
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

lemma maxAntiRamseyNumber_eq_zero_of_choose_two_lt (he : n.choose 2 < e) :
    maxAntiRamseyNumber n e H = 0 := by
  refine Nat.sInf_eq_zero.mpr (Or.inr (Set.eq_empty_of_forall_notMem fun r ⟨G, hG, _⟩ ↦ ?_))
  have := ncard_edgeSet_le_choose_two G
  simp at this
  omega

lemma maxAntiRamseyNumber_le_self : maxAntiRamseyNumber n e H ≤ e := by
  rcases le_or_gt e (n.choose 2) with he | he
  · exact Nat.sInf_le (self_mem_maxAntiRamseyNumber_set he)
  · simp [maxAntiRamseyNumber_eq_zero_of_choose_two_lt he]

lemma maxAntiRamseyNumber_pos (he₀ : 0 < e) (he : e ≤ n.choose 2) :
    0 < maxAntiRamseyNumber n e H := by
  refine Nat.pos_of_ne_zero fun h ↦ ?_
  obtain ⟨G, hG, C, -⟩ := (maxAntiRamseyNumber_le_iff (H := H) he).mp h.le
  obtain ⟨x, hx⟩ := Set.nonempty_of_ncard_ne_zero (s := G.edgeSet) (by omega)
  exact (C ⟨x, hx⟩).elim0

end SimpleGraph

namespace Erdos810

/-! ### Finite Extremal Function $M(n)$ (`maxRainbowC4Edges`) -/

/-- `HasRainbowC4 n e` holds if there exists a graph on `n` vertices with at least `e` edges and an
`n`-edge-labeling in which every $C_4$ is rainbow. -/
def HasRainbowC4 (n e : ℕ) : Prop :=
  ∃ G : SimpleGraph (Fin n), e ≤ G.edgeSet.ncard ∧
    ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4)

lemma HasRainbowC4.mono {n e₁ e₂ : ℕ} (hle : e₁ ≤ e₂) (h : HasRainbowC4 n e₂) :
    HasRainbowC4 n e₁ := by
  rcases h with ⟨G, hG, C, hC⟩
  exact ⟨G, hle.trans hG, C, hC⟩

lemma HasRainbowC4.le_choose_two {n e : ℕ} (h : HasRainbowC4 n e) : e ≤ n.choose 2 := by
  rcases h with ⟨G, hG, -⟩
  have := ncard_edgeSet_le_choose_two G
  simp only [Fintype.card_fin] at this
  exact hG.trans this

lemma hasRainbowC4_zero (n : ℕ) : HasRainbowC4 n 0 := by
  refine ⟨⊥, Nat.zero_le _, fun e ↦ False.elim (by simpa using e.2), ?_⟩
  refine EdgeLabeling.isRainbowFor_of_free ?_ _
  rintro ⟨f⟩
  exact f.toHom.map_adj (by decide : (cycleGraph 4).Adj 0 1)

lemma hasRainbowC4_iff_maxAntiRamseyNumber_le {n e : ℕ} (he : e ≤ n.choose 2) :
    HasRainbowC4 n e ↔ maxAntiRamseyNumber n e (cycleGraph 4) ≤ n :=
  (maxAntiRamseyNumber_le_iff he).symm

/-- The finite extremal function $M(n)$ for Erdős Problem #810: the maximum number of edges in a
graph on `n` vertices that can be colored with `n` colors so that every $C_4$ is rainbow. -/
noncomputable def maxRainbowC4Edges (n : ℕ) : ℕ :=
  sSup {e | HasRainbowC4 n e}

lemma bddAbove_hasRainbowC4 (n : ℕ) : BddAbove {e | HasRainbowC4 n e} :=
  ⟨n.choose 2, fun _ h ↦ h.le_choose_two⟩

lemma le_maxRainbowC4Edges_iff {n e : ℕ} :
    e ≤ maxRainbowC4Edges n ↔ HasRainbowC4 n e := by
  constructor
  · intro he
    have hmem : maxRainbowC4Edges n ∈ {e | HasRainbowC4 n e} :=
      Nat.sSup_mem ⟨0, hasRainbowC4_zero n⟩ (bddAbove_hasRainbowC4 n)
    exact hmem.mono he
  · intro h
    exact le_csSup (bddAbove_hasRainbowC4 n) h

lemma maxRainbowC4Edges_le_choose_two (n : ℕ) : maxRainbowC4Edges n ≤ n.choose 2 :=
  ((le_maxRainbowC4Edges_iff).mp le_rfl).le_choose_two

lemma maxRainbowC4Edges_le_iff_not_hasRainbowC4 {n m : ℕ} :
    maxRainbowC4Edges n ≤ m ↔ ¬ HasRainbowC4 n (m + 1) := by
  rw [← le_maxRainbowC4Edges_iff]
  omega

lemma maxRainbowC4Edges_eq_of_bounds {n m : ℕ}
    (h_low : HasRainbowC4 n m) (h_high : ¬ HasRainbowC4 n (m + 1)) :
    maxRainbowC4Edges n = m := by
  have h₁ : m ≤ maxRainbowC4Edges n := le_maxRainbowC4Edges_iff.mpr h_low
  have h₂ : maxRainbowC4Edges n ≤ m := maxRainbowC4Edges_le_iff_not_hasRainbowC4.mpr h_high
  omega

/-- Erdős Problem #810 is equivalent to the statement that $M(n) \ge \varepsilon n^2$ for some
$\varepsilon > 0$ and all sufficiently large $n$. -/
theorem erdos_810_iff_maxRainbowC4Edges :
    (∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ∃ G : SimpleGraph (Fin n), ε * n ^ 2 ≤ G.edgeSet.ncard ∧
      ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4)) ↔
    ∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ε * n ^ 2 ≤ maxRainbowC4Edges n := by
  refine exists_congr fun ε ↦ and_congr_right fun _ ↦ Filter.eventually_congr <|
    Eventually.of_forall fun n ↦ ?_
  rw [← Nat.ceil_le, le_maxRainbowC4Edges_iff]
  simp only [HasRainbowC4, Nat.ceil_le]

/-- Equivalence between `erdos_810` and the `maxAntiRamseyNumber` formulation. -/
theorem erdos_810_iff_max_anti_ramsey :
    (∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ∃ G : SimpleGraph (Fin n), ε * n ^ 2 ≤ G.edgeSet.ncard ∧
      ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4)) ↔
    ∃ ε > (0 : ℝ), ε < 1 / 2 ∧ ∀ᶠ n in atTop,
      maxAntiRamseyNumber n ⌈ε * n ^ 2⌉₊ (cycleGraph 4) ≤ n := by
  constructor
  · rintro ⟨ε, hε, h⟩
    obtain ⟨n, ⟨G, hG, -⟩, hn⟩ := (h.and (eventually_gt_atTop 0)).exists
    have hε' := lt_half_of_mul_sq_le_ncard hn G hG
    refine ⟨ε, hε, hε', ?_⟩
    filter_upwards [h, eventually_ceil_mul_sq_le_choose_two hε'] with n ⟨G, hG, C, hC⟩ hn
    exact (maxAntiRamseyNumber_le_iff hn).mpr ⟨G, Nat.ceil_le.mpr hG, C, hC⟩
  · rintro ⟨ε, hε, hε', h⟩
    refine ⟨ε, hε, ?_⟩
    filter_upwards [h, eventually_ceil_mul_sq_le_choose_two hε'] with n hn hle
    obtain ⟨G, hG, C, hC⟩ := (maxAntiRamseyNumber_le_iff hle).mp hn
    exact ⟨G, Nat.ceil_le.mp hG, C, hC⟩

/-! ### Exact values for $n \le 3$ -/

lemma cycleGraph_four_free_of_le_three {n : ℕ} (hn : n ≤ 3) (G : SimpleGraph (Fin n)) :
    (cycleGraph 4).Free G := by
  rintro ⟨f⟩
  have hcard := Fintype.card_le_of_injective f f.injective
  simp only [Fintype.card_fin] at hcard
  omega

theorem maxRainbowC4Edges_eq_choose_two_of_le_three {n : ℕ} (hn : n ≤ 3) :
    maxRainbowC4Edges n = n.choose 2 := by
  refine le_antisymm (maxRainbowC4Edges_le_choose_two n) (le_maxRainbowC4Edges_iff.mpr ?_)
  rcases Nat.eq_zero_or_pos n with rfl | hn_pos
  · exact hasRainbowC4_zero 0
  · refine ⟨⊤, by rw [ncard_edgeSet_top, Fintype.card_fin], fun _ ↦ ⟨0, hn_pos⟩, ?_⟩
    exact EdgeLabeling.isRainbowFor_of_free (cycleGraph_four_free_of_le_three hn ⊤) _

theorem maxRainbowC4Edges_zero : maxRainbowC4Edges 0 = 0 :=
  maxRainbowC4Edges_eq_choose_two_of_le_three (by decide)

theorem maxRainbowC4Edges_one : maxRainbowC4Edges 1 = 0 :=
  maxRainbowC4Edges_eq_choose_two_of_le_three (by decide)

theorem maxRainbowC4Edges_two : maxRainbowC4Edges 2 = 1 :=
  maxRainbowC4Edges_eq_choose_two_of_le_three (by decide)

theorem maxRainbowC4Edges_three : maxRainbowC4Edges 3 = 3 :=
  maxRainbowC4Edges_eq_choose_two_of_le_three (by decide)

/-! ### Computable Verification Bridge for Lower Bounds (Certificates) -/

/-- Ordered vertex pairs `(u, v)` with `u < v` in `Fin n`. -/
def orderedPairsList (n : ℕ) : List (Fin n × Fin n) :=
  ((List.finRange n).product (List.finRange n)).filter (fun p ↦ decide (p.1 < p.2))

def orderedPairs (n : ℕ) : Finset (Fin n × Fin n) :=
  (Finset.univ : Finset (Fin n × Fin n)).filter (fun p ↦ p.1 < p.2)

lemma nodup_orderedPairsList (n : ℕ) : (orderedPairsList n).Nodup :=
  ((List.nodup_finRange n).product (List.nodup_finRange n)).filter _

lemma mem_orderedPairsList {n : ℕ} {p : Fin n × Fin n} :
    p ∈ orderedPairsList n ↔ p.1 < p.2 := by
  rcases p with ⟨u, v⟩
  simp [orderedPairsList]

lemma length_filter_orderedPairsList {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj] :
    ((orderedPairsList n).filter (fun p ↦ decide (G.Adj p.1 p.2))).length = G.edgeSet.ncard := by
  classical
  have hnodup : ((orderedPairsList n).filter (fun p ↦ decide (G.Adj p.1 p.2))).Nodup :=
    (nodup_orderedPairsList n).filter _
  rw [← List.toFinset_card_of_nodup hnodup]
  have hfin : ((orderedPairsList n).filter (fun p ↦ decide (G.Adj p.1 p.2))).toFinset =
      (orderedPairs n).filter (fun p ↦ G.Adj p.1 p.2) := by
    ext p
    simp [orderedPairs, mem_orderedPairsList]
  rw [hfin, ← G.coe_edgeFinset, Set.ncard_coe_finset]
  refine Finset.card_bij (fun p _ ↦ s(p.1, p.2)) ?_ ?_ ?_
  · intro p hp
    simp only [orderedPairs, Finset.mem_filter, Finset.mem_univ, true_and] at hp
    exact G.mem_edgeFinset.mpr hp.2
  · intro p₁ hp₁ p₂ hp₂ h
    simp only [orderedPairs, Finset.mem_filter, Finset.mem_univ, true_and] at hp₁ hp₂
    rw [Sym2.eq_iff] at h
    rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · exact Prod.ext h1 h2
    · exact (lt_asymm (h1 ▸ hp₁.1) (h2 ▸ hp₂.1)).elim
  · intro e he
    rw [G.mem_edgeFinset] at he
    induction e using Sym2.ind with
    | _ u v =>
      rw [G.mem_edgeSet] at he
      rcases lt_trichotomy u v with hlt | rfl | hgt
      · exact ⟨(u, v), by simp [orderedPairs, hlt, he], rfl⟩
      · exact (G.loopless u he).elim
      · exact ⟨(v, u), by simp [orderedPairs, hgt, he.symm], Sym2.eq_swap⟩

def certLookup {n : ℕ} {K : Type*} (L : List ((Fin n × Fin n) × K)) (u v : Fin n) : Option K :=
  if u == v then none
  else
    let p := if u < v then (u, v) else (v, u)
    (L.find? (fun x ↦ x.1 == p)).map Prod.snd

lemma certLookup_symm {n : ℕ} {K : Type*} (L : List ((Fin n × Fin n) × K)) (u v : Fin n) :
    certLookup L u v = certLookup L v u := by
  unfold certLookup
  rcases lt_trichotomy u v with hlt | rfl | hgt
  · have hne : (u == v) = false := beq_eq_false_iff_ne.mpr hlt.ne
    have hne' : (v == u) = false := beq_eq_false_iff_ne.mpr hlt.ne'
    have hnot : ¬ v < u := not_lt_of_gt hlt
    simp [hne, hne', hlt, hnot]
  · rfl
  · have hne : (u == v) = false := beq_eq_false_iff_ne.mpr hgt.ne'
    have hne' : (v == u) = false := beq_eq_false_iff_ne.mpr hgt.ne
    have hnot : ¬ u < v := not_lt_of_gt hgt
    simp [hne, hne', hgt, hnot]

lemma certLookup_self {n : ℕ} {K : Type*} (L : List ((Fin n × Fin n) × K)) (u : Fin n) :
    certLookup L u u = none := by
  simp [certLookup]

def graphOfCert {n : ℕ} {K : Type*} (L : List ((Fin n × Fin n) × K)) : SimpleGraph (Fin n) where
  Adj u v := (certLookup L u v).isSome
  symm u v h := by dsimp at h ⊢; rwa [certLookup_symm]
  loopless u h := by dsimp at h; simp [certLookup_self] at h

instance {n : ℕ} {K : Type*} (L : List ((Fin n × Fin n) × K)) :
    DecidableRel (graphOfCert L).Adj := fun u v ↦
  inferInstanceAs (Decidable ((certLookup L u v).isSome = true))

def certColor {n : ℕ} {K : Type*} [Inhabited K] (L : List ((Fin n × Fin n) × K)) (u v : Fin n) : K :=
  (certLookup L u v).getD default

lemma certColor_symm {n : ℕ} {K : Type*} [Inhabited K]
    (L : List ((Fin n × Fin n) × K)) (u v : Fin n) :
    certColor L u v = certColor L v u := by
  simp [certColor, certLookup_symm]

def labelingOfCert {n : ℕ} {K : Type*} [Inhabited K] (L : List ((Fin n × Fin n) × K)) :
    (graphOfCert L).EdgeLabeling K :=
  fun e ↦ Sym2.lift ⟨certColor L, certColor_symm L⟩ e.1

@[simp] lemma labelingOfCert_get {n : ℕ} {K : Type*} [Inhabited K]
    (L : List ((Fin n × Fin n) × K)) (u v : Fin n) (h : (graphOfCert L).Adj u v) :
    (labelingOfCert L).get u v h = certColor L u v := rfl

def checkCert {n : ℕ} {K : Type*} [Inhabited K] [DecidableEq K]
    (L : List ((Fin n × Fin n) × K)) (m : ℕ) : Bool :=
  decide (m ≤ ((orderedPairsList n).filter (fun p ↦ decide ((graphOfCert L).Adj p.1 p.2))).length) &&
  (List.finRange n).all fun a ↦
  (List.finRange n).all fun b ↦
  (List.finRange n).all fun c ↦
  (List.finRange n).all fun d ↦
    a == c || b == d ||
    !(graphOfCert L).Adj a b || !(graphOfCert L).Adj b c ||
    !(graphOfCert L).Adj c d || !(graphOfCert L).Adj d a ||
    decide ([certColor L a b, certColor L b c, certColor L c d, certColor L d a].Nodup)

lemma hasRainbowC4_of_checkCert {n m : ℕ} [NeZero n]
    {L : List ((Fin n × Fin n) × Fin n)} (h : checkCert L m = true) :
    HasRainbowC4 n m := by
  unfold checkCert at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true, List.mem_finRange,
    forall_true_left] at h
  rcases h with ⟨hcard, hrainbow⟩
  rw [length_filter_orderedPairsList] at hcard
  refine ⟨graphOfCert L, hcard, labelingOfCert L, ?_⟩
  rw [EdgeLabeling.isRainbowFor_cycleGraph_four_iff]
  intro a b c d hab hbc hcd hda hac hbd
  have hd := hrainbow a b c d
  have hac' : (a == c) = false := beq_eq_false_iff_ne.mpr hac
  have hbd' : (b == d) = false := beq_eq_false_iff_ne.mpr hbd
  simp only [hac', hbd', hab, hbc, hcd, hda, decide_true, Bool.not_true,
    Bool.false_or, decide_eq_true_eq] at hd
  exact hd

/-! ### Computable Verification Bridge for Upper Bounds (Conflict-Clique Covers) -/

def sublistsOfLength {α : Type*} : ℕ → List α → List (List α)
  | 0, _ => [[]]
  | _ + 1, [] => []
  | k + 1, x :: xs => (sublistsOfLength k xs).map (fun l ↦ x :: l) ++ sublistsOfLength (k + 1) xs

lemma mem_sublistsOfLength {α : Type*} {M L : List α} (h : List.Sublist M L) :
    M ∈ sublistsOfLength M.length L := by
  induction h with
  | slnil => simp [sublistsOfLength]
  | @cons M xs x _ ih =>
    cases hlen : M.length with
    | zero =>
      rw [List.length_eq_zero_iff.mp hlen]
      simp [sublistsOfLength]
    | succ k =>
      rw [hlen] at ih
      simp [sublistsOfLength, ih]
  | @cons₂ M xs x _ ih =>
    simp [sublistsOfLength, ih]

lemma length_filter_add_length_filter_not {α : Type*} (L : List α) (p : α → Bool) :
    (L.filter p).length + (L.filter (fun x ↦ !p x)).length = L.length := by
  induction L with
  | nil => rfl
  | cons x xs ih =>
    cases hp : p x <;> simp [ hp] <;> omega

def complAdj {n : ℕ} (M : List (Fin n × Fin n)) (u v : Fin n) : Bool :=
  if u == v then false
  else
    let p := if u < v then (u, v) else (v, u)
    !(M.elem p)

lemma complAdj_symm {n : ℕ} (M : List (Fin n × Fin n)) (u v : Fin n) :
    complAdj M u v = complAdj M v u := by
  unfold complAdj
  rcases lt_trichotomy u v with hlt | rfl | hgt
  · have hne : (u == v) = false := beq_eq_false_iff_ne.mpr hlt.ne
    have hne' : (v == u) = false := beq_eq_false_iff_ne.mpr hlt.ne'
    have hnot : ¬ v < u := not_lt_of_gt hlt
    simp [hne, hne', hlt, hnot]
  · rfl
  · have hne : (u == v) = false := beq_eq_false_iff_ne.mpr hgt.ne'
    have hne' : (v == u) = false := beq_eq_false_iff_ne.mpr hgt.ne
    have hnot : ¬ u < v := not_lt_of_gt hgt
    simp [hne, hne', hgt, hnot]

def complGraph {n : ℕ} (M : List (Fin n × Fin n)) : SimpleGraph (Fin n) where
  Adj u v := complAdj M u v = true
  symm u v h := by dsimp at h ⊢; rwa [complAdj_symm]
  loopless u h := by dsimp at h; simp [complAdj] at h

instance {n : ℕ} (M : List (Fin n × Fin n)) : DecidableRel (complGraph M).Adj := fun u v ↦
  inferInstanceAs (Decidable (complAdj M u v = true))

lemma complGraph_le_of_missing {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj] :
    complGraph ((orderedPairsList n).filter (fun p ↦ !decide (G.Adj p.1 p.2))) ≤ G := by
  intro u v h
  dsimp [complGraph, complAdj] at h
  by_cases huv : u = v
  · subst huv; simp at h
  · have hbeq : (u == v) = false := beq_eq_false_iff_ne.mpr huv
    rw [if_neg (by simp [hbeq])] at h
    rcases lt_or_gt_of_ne huv with hlt | hgt
    · simp only [hlt, ↓reduceIte, Bool.not_eq_true', List.elem_eq_mem, decide_eq_false_iff_not,
        List.mem_filter, mem_orderedPairsList, not_and, not_not] at h
      exact h trivial
    · have hnot : ¬ u < v := not_lt_of_gt hgt
      simp only [hnot, ↓reduceIte, Bool.not_eq_true', List.elem_eq_mem, decide_eq_false_iff_not,
        List.mem_filter, mem_orderedPairsList, not_and, not_not] at h
      exact (h hgt).symm

def isC4Bool {n : ℕ} (adj : Fin n → Fin n → Bool)
    (q : Fin n × Fin n × Fin n × Fin n) : Bool :=
  let (a, b, c, d) := q
  a != c && b != d && adj a b && adj b c && adj c d && adj d a

def sameEdge {n : ℕ} (p : Fin n × Fin n) (u v : Fin n) : Bool :=
  (p.1 == u && p.2 == v) || (p.1 == v && p.2 == u)

lemma sym2_eq_of_sameEdge {n : ℕ} {p : Fin n × Fin n} {u v : Fin n}
    (h : sameEdge p u v = true) : (s(p.1, p.2) : Sym2 (Fin n)) = s(u, v) := by
  unfold sameEdge at h
  simp only [Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq] at h
  rw [Sym2.eq_iff]
  exact h

def inC4Edges {n : ℕ} (p : Fin n × Fin n) (q : Fin n × Fin n × Fin n × Fin n) : Bool :=
  let (a, b, c, d) := q
  sameEdge p a b || sameEdge p b c || sameEdge p c d || sameEdge p d a

def isConflictCliqueFast {n : ℕ} (adj : Fin n → Fin n → Bool)
    (active : List (Fin n × Fin n × Fin n × Fin n)) (clq : List (Fin n × Fin n)) : Bool :=
  clq.all (fun p ↦ adj p.1 p.2) &&
  clq.all (fun p₁ ↦ clq.all (fun p₂ ↦
    p₁ == p₂ || active.any (fun q ↦ inC4Edges p₁ q && inC4Edges p₂ q)))

def checkCover (n k : ℕ) (cycles : List (Fin n × Fin n × Fin n × Fin n))
    (cliques : List (List (Fin n × Fin n))) : Bool :=
  cliques.all (fun clq ↦ decide (n < clq.length) && decide clq.Nodup &&
    clq.all (fun p ↦ decide (p.1 < p.2))) &&
  (sublistsOfLength k (orderedPairsList n)).all (fun M ↦
    let adj := complAdj M
    let active := cycles.filter (isC4Bool adj)
    cliques.any (fun clq ↦ isConflictCliqueFast adj active clq))

lemma not_isRainbowFor_complGraph_of_clique {n : ℕ} {M : List (Fin n × Fin n)}
    {cycles : List (Fin n × Fin n × Fin n × Fin n)} {clq : List (Fin n × Fin n)}
    (hlen : n < clq.length) (hnodup : clq.Nodup) (hlt : ∀ p ∈ clq, p.1 < p.2)
    (hclq : isConflictCliqueFast (complAdj M) (cycles.filter (isC4Bool (complAdj M))) clq = true)
    (C : (complGraph M).EdgeLabeling (Fin n)) :
    ¬ C.IsRainbowFor (cycleGraph 4) := by
  intro hC
  rw [EdgeLabeling.isRainbowFor_cycleGraph_four_iff] at hC
  unfold isConflictCliqueFast at hclq
  simp only [Bool.and_eq_true, List.all_eq_true] at hclq
  rcases hclq with ⟨hadj, hpair⟩
  have hedg : ∀ p ∈ clq, (complGraph M).Adj p.1 p.2 := fun p hp ↦ hadj p hp
  let f : Fin clq.length → Fin n := fun i ↦
    let p := clq.get i
    C ⟨s(p.1, p.2), hedg p (clq.get_mem i)⟩
  have hf : Function.Injective f := by
    intro i j hij
    by_contra hne
    have hpne : clq.get i ≠ clq.get j := (List.nodup_iff_injective_get.mp hnodup).ne hne
    have hp := hpair (clq.get i) (clq.get_mem i) (clq.get j) (clq.get_mem j)
    have hbeq : (clq.get i == clq.get j) = false := beq_eq_false_iff_ne.mpr hpne
    simp only [hbeq, Bool.false_or, List.any_eq_true, List.mem_filter, Bool.and_eq_true] at hp
    rcases hp with ⟨⟨a, b, c, d⟩, ⟨_, hc4⟩, ⟨hin1, hin2⟩⟩
    unfold isC4Bool at hc4
    simp only [Bool.and_eq_true, bne_iff_ne, ne_eq] at hc4
    rcases hc4 with ⟨⟨⟨⟨⟨hac, hbd⟩, hab⟩, hbc⟩, hcd⟩, hda⟩
    have hnodup4 := hC a b c d hab hbc hcd hda hac hbd
    let L4 : List (complGraph M).edgeSet :=
      [⟨s(a, b), hab⟩, ⟨s(b, c), hbc⟩, ⟨s(c, d), hcd⟩, ⟨s(d, a), hda⟩]
    have hmap : L4.map C = [C.get a b hab, C.get b c hbc, C.get c d hcd, C.get d a hda] := rfl
    rw [← hmap] at hnodup4
    let e₁ : (complGraph M).edgeSet := ⟨s((clq.get i).1, (clq.get i).2), hedg _ (clq.get_mem i)⟩
    let e₂ : (complGraph M).edgeSet := ⟨s((clq.get j).1, (clq.get j).2), hedg _ (clq.get_mem j)⟩
    have he₁ : e₁ ∈ L4 := by
      unfold inC4Edges at hin1
      simp only [Bool.or_eq_true] at hin1
      simp only [L4, List.mem_cons, List.not_mem_nil, or_false, Subtype.ext_iff]
      rcases hin1 with ((h1 | h2) | h3) | h4
      · exact Or.inl (sym2_eq_of_sameEdge h1)
      · exact Or.inr (Or.inl (sym2_eq_of_sameEdge h2))
      · exact Or.inr (Or.inr (Or.inl (sym2_eq_of_sameEdge h3)))
      · exact Or.inr (Or.inr (Or.inr (sym2_eq_of_sameEdge h4)))
    have he₂ : e₂ ∈ L4 := by
      unfold inC4Edges at hin2
      simp only [Bool.or_eq_true] at hin2
      simp only [L4, List.mem_cons, List.not_mem_nil, or_false, Subtype.ext_iff]
      rcases hin2 with ((h1 | h2) | h3) | h4
      · exact Or.inl (sym2_eq_of_sameEdge h1)
      · exact Or.inr (Or.inl (sym2_eq_of_sameEdge h2))
      · exact Or.inr (Or.inr (Or.inl (sym2_eq_of_sameEdge h3)))
      · exact Or.inr (Or.inr (Or.inr (sym2_eq_of_sameEdge h4)))
    have heq : e₁ = e₂ :=
      (List.nodup_map_iff_inj_on (hnodup4.of_map C)).mp hnodup4 e₁ he₁ e₂ he₂ hij
    have hsym : s((clq.get i).1, (clq.get i).2) = s((clq.get j).1, (clq.get j).2) :=
      Subtype.ext_iff.mp heq
    rw [Sym2.eq_iff] at hsym
    rcases hsym with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · exact hpne (Prod.ext h1 h2)
    · exact lt_asymm (h1 ▸ hlt _ (clq.get_mem i)) (h2 ▸ hlt _ (clq.get_mem j))
  have hcard := Fintype.card_le_of_injective f hf
  simp only [Fintype.card_fin] at hcard
  omega

lemma not_hasRainbowC4_of_checkCover {n m k : ℕ}
    {cycles : List (Fin n × Fin n × Fin n × Fin n)}
    {cliques : List (List (Fin n × Fin n))}
    (hmk : m + k = (orderedPairsList n).length)
    (hcov : checkCover n k cycles cliques = true) :
    ¬ HasRainbowC4 n m := by
  rintro ⟨G₀, hG₀, C₀, hC₀⟩
  obtain ⟨G, hGle, hGcard⟩ := exists_le_ncard_edgeSet_eq hG₀
  have hC : (C₀.pullback (Hom.ofLE hGle)).IsRainbowFor (cycleGraph 4) :=
    hC₀.pullback_ofLE hGle
  classical
  let M := (orderedPairsList n).filter (fun p ↦ !decide (G.Adj p.1 p.2))
  have hM_sub : List.Sublist M (orderedPairsList n) := List.filter_sublist
  have hM_len : M.length = k := by
    have hsum := length_filter_add_length_filter_not (orderedPairsList n)
      (fun p ↦ decide (G.Adj p.1 p.2))
    rw [length_filter_orderedPairsList G, hGcard] at hsum
    dsimp [M]
    omega
  have hM_mem : M ∈ sublistsOfLength k (orderedPairsList n) := by
    rw [← hM_len]
    exact mem_sublistsOfLength hM_sub
  unfold checkCover at hcov
  simp only [Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at hcov
  rcases hcov with ⟨hclq_props, hM_all⟩
  have hM_any := hM_all M hM_mem
  simp only [List.any_eq_true] at hM_any
  rcases hM_any with ⟨clq, hclq_mem, hclq_fast⟩
  rcases hclq_props clq hclq_mem with ⟨⟨hlen, hnodup⟩, hlt⟩
  have hle_compl : complGraph M ≤ G := complGraph_le_of_missing G
  have hC_compl : ((C₀.pullback (Hom.ofLE hGle)).pullback (Hom.ofLE hle_compl)).IsRainbowFor
      (cycleGraph 4) := hC.pullback_ofLE hle_compl
  exact not_isRainbowFor_complGraph_of_clique hlen hnodup hlt hclq_fast _ hC_compl

/-! ### Proved Lower-Bound Certificates for $4 \le n \le 12$ -/

def cert4 : List ((Fin 4 × Fin 4) × Fin 4) :=
  [((0, 1), 0), ((0, 2), 0), ((0, 3), 1), ((1, 2), 2), ((1, 3), 3)]

def cert5 : List ((Fin 5 × Fin 5) × Fin 5) :=
  [((0, 1), 4), ((0, 2), 3), ((0, 3), 2), ((0, 4), 0), ((1, 2), 1), ((1, 4), 4), ((2, 3), 0)]

def cert6 : List ((Fin 6 × Fin 6) × Fin 6) :=
  [((0, 1), 2), ((0, 2), 0), ((0, 3), 1), ((0, 5), 4), ((1, 2), 3), ((1, 3), 5),
   ((1, 4), 3), ((1, 5), 2), ((2, 3), 4), ((2, 4), 1), ((4, 5), 5)]

def cert7 : List ((Fin 7 × Fin 7) × Fin 7) :=
  [((0, 1), 6), ((0, 2), 0), ((0, 3), 6), ((0, 4), 1), ((0, 6), 4), ((1, 3), 0),
   ((1, 5), 3), ((1, 6), 5), ((2, 4), 5), ((2, 5), 1), ((2, 6), 2), ((3, 4), 2),
   ((4, 6), 3), ((5, 6), 2)]

def cert8 : List ((Fin 8 × Fin 8) × Fin 8) :=
  [((0, 1), 2), ((0, 2), 6), ((0, 3), 0), ((0, 4), 7), ((0, 5), 6), ((0, 6), 2),
   ((1, 4), 3), ((1, 5), 0), ((1, 6), 1), ((2, 3), 1), ((2, 5), 3), ((2, 6), 4),
   ((3, 4), 4), ((3, 6), 5), ((4, 5), 5), ((5, 7), 7), ((6, 7), 5)]

def cert9 : List ((Fin 9 × Fin 9) × Fin 9) :=
  [((0, 1), 0), ((0, 2), 6), ((0, 4), 7), ((0, 5), 5), ((0, 6), 2), ((0, 8), 0),
   ((1, 3), 1), ((1, 4), 8), ((1, 6), 6), ((1, 8), 3), ((2, 4), 1), ((2, 5), 2),
   ((2, 7), 3), ((2, 8), 4), ((3, 4), 4), ((3, 5), 6), ((3, 6), 3), ((3, 7), 0),
   ((4, 6), 5), ((5, 7), 1), ((5, 8), 8), ((6, 7), 8), ((7, 8), 7)]

def cert10 : List ((Fin 10 × Fin 10) × Fin 10) :=
  [((0, 3), 9), ((0, 4), 3), ((0, 5), 0), ((0, 6), 5), ((0, 7), 2), ((0, 9), 1),
   ((1, 2), 1), ((1, 3), 5), ((1, 5), 3), ((1, 7), 8), ((1, 8), 2), ((1, 9), 6),
   ((2, 5), 7), ((2, 6), 3), ((2, 7), 4), ((2, 8), 5), ((2, 9), 9), ((3, 4), 7),
   ((3, 5), 2), ((3, 6), 4), ((3, 9), 8), ((4, 5), 6), ((4, 6), 8), ((4, 7), 1),
   ((4, 8), 9), ((5, 9), 4), ((6, 7), 0), ((6, 8), 6), ((7, 8), 7), ((8, 9), 0)]

def cert11 : List ((Fin 11 × Fin 11) × Fin 11) :=
  [((0, 1), 2), ((0, 2), 10), ((0, 4), 6), ((0, 5), 8), ((0, 7), 5), ((0, 9), 0),
   ((1, 3), 9), ((1, 4), 4), ((1, 6), 3), ((1, 9), 5), ((1, 10), 10), ((2, 4), 1),
   ((2, 5), 2), ((2, 6), 8), ((2, 7), 10), ((2, 8), 0), ((2, 9), 9), ((3, 5), 1),
   ((3, 7), 7), ((3, 8), 8), ((3, 9), 3), ((3, 10), 0), ((4, 5), 3), ((4, 6), 9),
   ((4, 8), 7), ((5, 8), 4), ((5, 9), 7), ((6, 7), 4), ((6, 8), 6), ((6, 10), 2),
   ((7, 8), 3), ((7, 10), 1), ((8, 10), 5), ((9, 10), 6)]

def cert12 : List ((Fin 12 × Fin 12) × Fin 12) :=
  [((0, 1), 0), ((0, 3), 4), ((0, 5), 1), ((0, 6), 3), ((0, 9), 8), ((0, 10), 11),
   ((1, 2), 10), ((1, 3), 9), ((1, 4), 8), ((1, 6), 6), ((1, 8), 2), ((1, 9), 7),
   ((2, 4), 3), ((2, 6), 4), ((2, 7), 8), ((2, 9), 1), ((2, 11), 6), ((3, 4), 7),
   ((3, 6), 5), ((3, 7), 6), ((3, 8), 3), ((4, 5), 5), ((4, 6), 11), ((4, 8), 0),
   ((4, 11), 9), ((5, 7), 10), ((5, 9), 4), ((5, 10), 6), ((5, 11), 2), ((6, 9), 2),
   ((6, 10), 10), ((7, 8), 1), ((7, 9), 3), ((7, 10), 9), ((7, 11), 11), ((8, 10), 8),
   ((8, 11), 4), ((9, 10), 5), ((9, 11), 0), ((10, 11), 7)]

theorem hasRainbowC4_four_five : HasRainbowC4 4 5 :=
  hasRainbowC4_of_checkCert (L := cert4) (by decide)

theorem hasRainbowC4_five_seven : HasRainbowC4 5 7 :=
  hasRainbowC4_of_checkCert (L := cert5) (by decide)

theorem hasRainbowC4_six_eleven : HasRainbowC4 6 11 :=
  hasRainbowC4_of_checkCert (L := cert6) (by decide)

theorem hasRainbowC4_seven_fourteen : HasRainbowC4 7 14 :=
  hasRainbowC4_of_checkCert (L := cert7) (by decide)

theorem hasRainbowC4_eight_seventeen : HasRainbowC4 8 17 :=
  hasRainbowC4_of_checkCert (L := cert8) (by decide)

theorem hasRainbowC4_nine_twentyThree : HasRainbowC4 9 23 :=
  hasRainbowC4_of_checkCert (L := cert9) (by decide)

set_option maxHeartbeats 400000 in
theorem hasRainbowC4_ten_thirty : HasRainbowC4 10 30 :=
  hasRainbowC4_of_checkCert (L := cert10) (by decide)

set_option maxHeartbeats 600000 in
theorem hasRainbowC4_eleven_thirtyFour : HasRainbowC4 11 34 :=
  hasRainbowC4_of_checkCert (L := cert11) (by decide)

set_option maxHeartbeats 800000 in
theorem hasRainbowC4_twelve_forty : HasRainbowC4 12 40 :=
  hasRainbowC4_of_checkCert (L := cert12) (by decide)

theorem fourteen_le_maxRainbowC4Edges_seven : 14 ≤ maxRainbowC4Edges 7 :=
  le_maxRainbowC4Edges_iff.mpr hasRainbowC4_seven_fourteen

theorem seventeen_le_maxRainbowC4Edges_eight : 17 ≤ maxRainbowC4Edges 8 :=
  le_maxRainbowC4Edges_iff.mpr hasRainbowC4_eight_seventeen

theorem twentyThree_le_maxRainbowC4Edges_nine : 23 ≤ maxRainbowC4Edges 9 :=
  le_maxRainbowC4Edges_iff.mpr hasRainbowC4_nine_twentyThree

theorem thirty_le_maxRainbowC4Edges_ten : 30 ≤ maxRainbowC4Edges 10 :=
  le_maxRainbowC4Edges_iff.mpr hasRainbowC4_ten_thirty

theorem thirtyFour_le_maxRainbowC4Edges_eleven : 34 ≤ maxRainbowC4Edges 11 :=
  le_maxRainbowC4Edges_iff.mpr hasRainbowC4_eleven_thirtyFour

theorem forty_le_maxRainbowC4Edges_twelve : 40 ≤ maxRainbowC4Edges 12 :=
  le_maxRainbowC4Edges_iff.mpr hasRainbowC4_twelve_forty

/-! ### Proved Upper Bounds and Exact Values for $n = 4, 5, 6$ -/

def cycles4 : List (Fin 4 × Fin 4 × Fin 4 × Fin 4) :=
  [(0, 1, 2, 3), (0, 1, 3, 2), (0, 2, 1, 3)]
def cliques4 : List (List (Fin 4 × Fin 4)) :=
  [[(0, 1), (0, 2), (0, 3), (1, 2), (1, 3)]]

def cycles5 : List (Fin 5 × Fin 5 × Fin 5 × Fin 5) :=
  [(0, 1, 2, 3), (0, 1, 2, 4), (0, 1, 3, 2), (0, 1, 3, 4), (0, 1, 4, 2), (0, 1, 4, 3),
   (0, 2, 1, 3), (0, 2, 1, 4), (0, 2, 3, 4), (0, 2, 4, 3), (0, 3, 1, 4), (0, 3, 2, 4),
   (1, 2, 3, 4), (1, 2, 4, 3), (1, 3, 2, 4)]
def cliques5 : List (List (Fin 5 × Fin 5)) :=
  [[(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)],
   [(0, 1), (0, 2), (0, 3), (1, 4), (2, 4), (3, 4)],
   [(0, 1), (0, 4), (1, 2), (1, 3), (2, 4), (3, 4)],
   [(0, 2), (0, 4), (1, 2), (1, 4), (2, 3), (3, 4)],
   [(0, 3), (0, 4), (1, 3), (1, 4), (2, 3), (2, 4)],
   [(0, 1), (0, 2), (0, 4), (1, 2), (1, 4), (2, 4)],
   [(0, 1), (0, 2), (0, 4), (1, 3), (2, 3), (3, 4)],
   [(0, 1), (0, 3), (1, 2), (1, 4), (2, 3), (3, 4)],
   [(0, 2), (0, 3), (1, 2), (1, 3), (2, 4), (3, 4)],
   [(0, 1), (0, 2), (1, 3), (1, 4), (2, 3), (2, 4)],
   [(0, 1), (0, 3), (0, 4), (1, 2), (2, 3), (2, 4)],
   [(0, 1), (0, 3), (0, 4), (1, 3), (1, 4), (3, 4)]]

def cycles6 : List (Fin 6 × Fin 6 × Fin 6 × Fin 6) :=
  [(0, 1, 2, 3), (0, 1, 2, 4), (0, 1, 2, 5), (0, 1, 3, 2), (0, 1, 3, 4), (0, 1, 3, 5),
   (0, 1, 4, 2), (0, 1, 4, 3), (0, 1, 4, 5), (0, 1, 5, 2), (0, 1, 5, 3), (0, 1, 5, 4),
   (0, 2, 1, 3), (0, 2, 1, 4), (0, 2, 1, 5), (0, 2, 3, 4), (0, 2, 3, 5), (0, 2, 4, 3),
   (0, 2, 4, 5), (0, 2, 5, 3), (0, 2, 5, 4), (0, 3, 1, 4), (0, 3, 1, 5), (0, 3, 2, 4),
   (0, 3, 2, 5), (0, 3, 4, 5), (0, 3, 5, 4), (0, 4, 1, 5), (0, 4, 2, 5), (0, 4, 3, 5),
   (1, 2, 3, 4), (1, 2, 3, 5), (1, 2, 4, 3), (1, 2, 4, 5), (1, 2, 5, 3), (1, 2, 5, 4),
   (1, 3, 2, 4), (1, 3, 2, 5), (1, 3, 4, 5), (1, 3, 5, 4), (1, 4, 2, 5), (1, 4, 3, 5),
   (2, 3, 4, 5), (2, 3, 5, 4), (2, 4, 3, 5)]
def cliques6 : List (List (Fin 6 × Fin 6)) :=
  [[(0, 1), (0, 2), (0, 3), (0, 4), (1, 2), (1, 3), (1, 4)],
   [(0, 2), (0, 3), (0, 4), (0, 5), (2, 3), (2, 4), (2, 5)],
   [(0, 3), (0, 4), (0, 5), (1, 3), (1, 4), (1, 5), (3, 4)],
   [(0, 1), (0, 2), (0, 5), (1, 2), (1, 3), (1, 5), (2, 3)],
   [(0, 1), (0, 4), (0, 5), (1, 2), (1, 4), (1, 5), (2, 4)],
   [(0, 1), (0, 2), (0, 3), (0, 4), (1, 5), (2, 5), (3, 5)],
   [(0, 1), (0, 5), (1, 2), (1, 3), (1, 4), (2, 5), (3, 5)],
   [(0, 2), (0, 3), (1, 2), (1, 3), (2, 4), (2, 5), (3, 4)],
   [(0, 2), (0, 4), (1, 2), (1, 4), (2, 3), (2, 5), (3, 4)],
   [(0, 1), (0, 3), (1, 2), (1, 4), (1, 5), (2, 3), (3, 4)],
   [(0, 1), (0, 2), (1, 3), (1, 4), (1, 5), (2, 3), (2, 4)],
   [(0, 1), (0, 4), (1, 2), (1, 3), (1, 5), (2, 4), (3, 4)],
   [(0, 3), (0, 4), (1, 3), (1, 4), (2, 3), (2, 4), (3, 5)],
   [(0, 1), (0, 2), (0, 3), (0, 5), (1, 4), (2, 4), (3, 4)],
   [(0, 2), (0, 5), (1, 2), (1, 5), (2, 3), (2, 4), (3, 5)],
   [(0, 3), (0, 5), (1, 3), (1, 5), (2, 3), (2, 5), (3, 4)],
   [(0, 1), (0, 2), (0, 4), (0, 5), (1, 3), (2, 3), (3, 4)],
   [(0, 4), (0, 5), (1, 4), (1, 5), (2, 4), (2, 5), (3, 4)],
   [(0, 1), (0, 3), (0, 4), (0, 5), (1, 2), (2, 3), (2, 4)],
   [(0, 2), (0, 3), (0, 4), (0, 5), (1, 2), (1, 3), (1, 4)]]

theorem not_hasRainbowC4_four_six : ¬ HasRainbowC4 4 6 :=
  not_hasRainbowC4_of_checkCover (k := 0) (cycles := cycles4) (cliques := cliques4)
    (by decide) (by decide)

theorem not_hasRainbowC4_five_eight : ¬ HasRainbowC4 5 8 :=
  not_hasRainbowC4_of_checkCover (k := 2) (cycles := cycles5) (cliques := cliques5)
    (by decide) (by decide)

set_option maxHeartbeats 2000000 in
set_option maxRecDepth 20000 in
theorem not_hasRainbowC4_six_twelve : ¬ HasRainbowC4 6 12 :=
  not_hasRainbowC4_of_checkCover (k := 3) (cycles := cycles6) (cliques := cliques6)
    (by decide) (by decide)

/-- Exact value $M(4) = 5$. -/
theorem maxRainbowC4Edges_four : maxRainbowC4Edges 4 = 5 :=
  maxRainbowC4Edges_eq_of_bounds hasRainbowC4_four_five not_hasRainbowC4_four_six

/-- Exact value $M(5) = 7$. -/
theorem maxRainbowC4Edges_five : maxRainbowC4Edges 5 = 7 :=
  maxRainbowC4Edges_eq_of_bounds hasRainbowC4_five_seven not_hasRainbowC4_five_eight

/-- Exact value $M(6) = 11$. -/
theorem maxRainbowC4Edges_six : maxRainbowC4Edges 6 = 11 :=
  maxRainbowC4Edges_eq_of_bounds hasRainbowC4_six_eleven not_hasRainbowC4_six_twelve

/-- In terms of $\chi_S$, $\chi_S(4, 6, C_4) > 4$. -/
theorem four_lt_maxAntiRamseyNumber_four_six :
    4 < maxAntiRamseyNumber 4 6 (cycleGraph 4) := by
  by_contra! h
  exact not_hasRainbowC4_four_six
    ((hasRainbowC4_iff_maxAntiRamseyNumber_le (by decide)).mpr h)

/-- In terms of $\chi_S$, $\chi_S(5, 8, C_4) > 5$. -/
theorem five_lt_maxAntiRamseyNumber_five_eight :
    5 < maxAntiRamseyNumber 5 8 (cycleGraph 4) := by
  by_contra! h
  exact not_hasRainbowC4_five_eight
    ((hasRainbowC4_iff_maxAntiRamseyNumber_le (by decide)).mpr h)

/-- In terms of $\chi_S$, $\chi_S(6, 12, C_4) > 6$. -/
theorem six_lt_maxAntiRamseyNumber_six_twelve :
    6 < maxAntiRamseyNumber 6 12 (cycleGraph 4) := by
  by_contra! h
  exact not_hasRainbowC4_six_twelve
    ((hasRainbowC4_iff_maxAntiRamseyNumber_le (by decide)).mpr h)

end Erdos810

/-! ### Axiom Audit -/

open Lean Elab Command in
elab "#assert_no_sorry " ids:ident* : command => do
  for id in ids do
    let name ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
    let axioms ← liftCoreM <| collectAxioms name
    if axioms.contains ``sorryAx then
      throwErrorAt id "{name} depends on sorryAx"

#assert_no_sorry
  SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff
  SimpleGraph.EdgeLabeling.isRainbowFor_cycleGraph_four_iff_c4ConflictGraph
  Erdos810.erdos_810_iff_maxRainbowC4Edges
  Erdos810.erdos_810_iff_max_anti_ramsey
  Erdos810.maxRainbowC4Edges_zero
  Erdos810.maxRainbowC4Edges_one
  Erdos810.maxRainbowC4Edges_two
  Erdos810.maxRainbowC4Edges_three
  Erdos810.maxRainbowC4Edges_four
  Erdos810.maxRainbowC4Edges_five
  Erdos810.maxRainbowC4Edges_six
  Erdos810.fourteen_le_maxRainbowC4Edges_seven
  Erdos810.seventeen_le_maxRainbowC4Edges_eight
  Erdos810.twentyThree_le_maxRainbowC4Edges_nine
  Erdos810.thirty_le_maxRainbowC4Edges_ten
  Erdos810.thirtyFour_le_maxRainbowC4Edges_eleven
  Erdos810.forty_le_maxRainbowC4Edges_twelve
  Erdos810.four_lt_maxAntiRamseyNumber_four_six
  Erdos810.five_lt_maxAntiRamseyNumber_five_eight
  Erdos810.six_lt_maxAntiRamseyNumber_six_twelve
