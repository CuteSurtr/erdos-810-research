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

public import AntiRamsey
public import FormalConjecturesUtil.Answer
public import FormalConjecturesUtil.Attributes.Basic
public import Mathlib.Combinatorics.SimpleGraph.Star
public import Mathlib.Order.Filter.AtTopBot.Basic

/-!
# Erdős Problem 810

*References:*
- [erdosproblems.com/810](https://www.erdosproblems.com/810)
- [BEGS89] Burr, S. A., Erdős, P., Graham, R. L. and Sós, V. T., *Maximal anti-Ramsey graphs and
  the strong chromatic number*. J. Graph Theory 13 (1989), 263-282.
- [SaSe06] Sárközy, G. N. and Selkow, S. M., *On an anti-Ramsey problem of Burr, Erdős, Graham,
  and T. Sós*. J. Graph Theory 52 (2006), 147-156.
-/

@[expose] public section

open Filter SimpleGraph

namespace Erdos810

/--
Does there exist some $\epsilon>0$ such that, for all sufficiently large $n$, there exists a graph
$G$ on $n$ vertices with at least $\epsilon n^2$ many edges such that the edges can be coloured
with $n$ colours so that every $C_4$ receives $4$ distinct colours?

Burr, Erdős, Graham and Sós [BEGS89] believed that the answer is no.
-/
@[category research open, AMS 5]
theorem erdos_810 : answer(sorry) ↔
    ∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ∃ G : SimpleGraph (Fin n), ε * n ^ 2 ≤ G.edgeSet.ncard ∧
      ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4) := by
  sorry

/--
In terms of the maximal anti-Ramsey number $\chi_S(n, e, G)$ of [BEGS89] (see
`SimpleGraph.maxAntiRamseyNumber`), the question asks whether there is some $\epsilon > 0$ such
that $\chi_S(n, \epsilon n^2, C_4) \le n$ for all large $n$. The condition $\epsilon < 1/2$
excludes the degenerate case where no graph on $n$ vertices has $\epsilon n^2$ edges.
`erdos_810.test.max_anti_ramsey_iff` shows that this is equivalent to `erdos_810`.
-/
@[category research open, AMS 5]
theorem erdos_810.variants.max_anti_ramsey : answer(sorry) ↔
    ∃ ε > (0 : ℝ), ε < 1 / 2 ∧ ∀ᶠ n in atTop,
      maxAntiRamseyNumber n ⌈ε * n ^ 2⌉₊ (cycleGraph 4) ≤ n := by
  sorry

/-- The statements in `erdos_810` and `erdos_810.variants.max_anti_ramsey` are equivalent. -/
@[category test, AMS 5]
theorem erdos_810.test.max_anti_ramsey_iff :
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

/-- `HasRainbowC4 n e` holds if some simple graph on `n` vertices with at least `e` edges admits an
`n`-edge-labeling that is rainbow for $C_4$. -/
def HasRainbowC4 (n e : ℕ) : Prop :=
  ∃ G : SimpleGraph (Fin n), e ≤ G.edgeSet.ncard ∧
    ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4)

/-- The finite extremal function $M(n)$ for Erdős Problem #810: the maximum number of edges in a
simple graph on `n` vertices admitting an `n`-edge-labeling in which every $C_4$ is rainbow. -/
noncomputable def maxRainbowC4Edges (n : ℕ) : ℕ :=
  sSup {e | HasRainbowC4 n e}

lemma hasRainbowC4_zero (n : ℕ) : HasRainbowC4 n 0 := by
  refine ⟨⊥, Nat.zero_le _, fun e ↦ False.elim (by simpa using e.2), ?_⟩
  refine EdgeLabeling.isRainbowFor_of_free ?_ _
  rintro ⟨f⟩
  exact f.toHom.map_adj (by decide : (cycleGraph 4).Adj 0 1)

lemma bddAbove_hasRainbowC4 (n : ℕ) : BddAbove {e | HasRainbowC4 n e} := by
  refine ⟨n.choose 2, fun e ⟨G, hG, -⟩ ↦ ?_⟩
  have := ncard_edgeSet_le_choose_two G
  simp only [Fintype.card_fin] at this
  exact hG.trans this

lemma le_maxRainbowC4Edges_iff {n e : ℕ} :
    e ≤ maxRainbowC4Edges n ↔ HasRainbowC4 n e := by
  constructor
  · intro he
    obtain ⟨G, hG, C, hC⟩ := Nat.sSup_mem ⟨0, hasRainbowC4_zero n⟩ (bddAbove_hasRainbowC4 n)
    exact ⟨G, he.trans hG, C, hC⟩
  · intro h
    exact le_csSup (bddAbove_hasRainbowC4 n) h

/--
In terms of the finite extremal function $M(n)$ (`maxRainbowC4Edges n`), Erdős Problem #810 asks
whether $M(n) \ge \epsilon n^2$ for some $\epsilon > 0$ and all sufficiently large $n$.
-/
@[category research open, AMS 5]
theorem erdos_810.variants.max_rainbow_edges : answer(sorry) ↔
    ∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ε * n ^ 2 ≤ maxRainbowC4Edges n := by
  sorry

/-- The statements in `erdos_810` and `erdos_810.variants.max_rainbow_edges` are equivalent. -/
@[category test, AMS 5]
theorem erdos_810.test.max_rainbow_edges_iff :
    (∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ∃ G : SimpleGraph (Fin n), ε * n ^ 2 ≤ G.edgeSet.ncard ∧
      ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (cycleGraph 4)) ↔
    ∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ε * n ^ 2 ≤ maxRainbowC4Edges n := by
  refine exists_congr fun ε ↦ and_congr_right fun _ ↦ Filter.eventually_congr <|
    Eventually.of_forall fun n ↦ ?_
  rw [← Nat.ceil_le, le_maxRainbowC4Edges_iff]
  simp only [HasRainbowC4, Nat.ceil_le]

/--
The Brown–Erdős–Sós extremal function $g(n; k, e)$: the maximum number of $3$-element subsets of
`Fin n` such that no $k$-element subset of `Fin n` contains at least $e$ of the chosen triples.
-/
noncomputable def brownErdosSosTripleNumber (n k e : ℕ) : ℕ :=
  sSup {m | ∃ H : Finset (Finset (Fin n)), H.card = m ∧ (∀ t ∈ H, t.card = 3) ∧
    ∀ S : Finset (Fin n), S.card = k → (H.filter (fun t ↦ t ⊆ S)).card < e}

/--
Burr, Erdős, Graham and Sós [BEGS89, p. 273] observed that there exists a constant $c > 0$ such
that $\chi_S(n, \lceil c \cdot g(n; 7, 4) \rceil, C_4) \le n$ for all sufficiently large $n$,
equivalently $M(n) \ge c \cdot g(n; 7, 4)$, linking Erdős Problem #810 to the $(7, 4)$-problem
(Erdős Problem #1178).
-/
@[category research solved, AMS 5]
theorem erdos_810.variants.brown_erdos_sos_seven_four :
    ∃ c > (0 : ℝ), ∀ᶠ n in atTop,
      c * brownErdosSosTripleNumber n 7 4 ≤ maxRainbowC4Edges n := by
  sorry

/--
Burr, Erdős, Graham and Sós [BEGS89] proved that the answer is no if $C_4$ is replaced by the
path $P_4$ on four vertices.
-/
@[category research solved, AMS 5]
theorem erdos_810.variants.path_four : answer(False) ↔
    ∃ ε > (0 : ℝ), ∀ᶠ n in atTop, ∃ G : SimpleGraph (Fin n), ε * n ^ 2 ≤ G.edgeSet.ncard ∧
      ∃ C : G.EdgeLabeling (Fin n), C.IsRainbowFor (pathGraph 4) := by
  sorry

/--
Burr, Erdős, Graham and Sós [BEGS89, Theorem 6.3] proved that
$\chi_S(n, \epsilon n^2, P_4) / n \to \infty$ for every fixed $\epsilon > 0$, where $P_4$ is the
path on four vertices. We assume $\epsilon < 1/2$, since otherwise no graph on $n$ vertices has
$\epsilon n^2$ edges.
-/
@[category research solved, AMS 5]
theorem erdos_810.variants.path_four_tendsto (ε : ℝ) (hε : 0 < ε) (hε' : ε < 1 / 2) :
    Tendsto (fun n : ℕ ↦ (maxAntiRamseyNumber n ⌈ε * n ^ 2⌉₊ (pathGraph 4) : ℝ) / n)
      atTop atTop := by
  sorry

/--
Burr, Erdős, Graham and Sós [BEGS89, Section 8] asked the stronger question: is it true that
$\chi_S(n, \epsilon n^2, L) / n \to \infty$ for every fixed $\epsilon > 0$ and every connected
bipartite graph $L$ which is not a star? For $L = C_4$ a positive answer gives a negative answer to
`erdos_810`. We assume $\epsilon < 1/2$, since otherwise no graph on $n$ vertices has
$\epsilon n^2$ edges.
-/
@[category research open, AMS 5]
theorem erdos_810.variants.connected_bipartite : answer(sorry) ↔
    ∀ (V : Type) [Finite V] (L : SimpleGraph V), L.Connected → L.IsBipartite →
      (∀ v, L ≠ starGraph v) → ∀ ε : ℝ, 0 < ε → ε < 1 / 2 →
        Tendsto (fun n : ℕ ↦ (maxAntiRamseyNumber n ⌈ε * n ^ 2⌉₊ L : ℝ) / n) atTop atTop := by
  sorry

/--
Sárközy and Selkow [SaSe06, Theorem 4] proved that $\chi_S(n, \epsilon n^2, L) / n \to \infty$
for every fixed $\epsilon > 0$ and every connected bipartite graph $L$ which is not a complete
bipartite graph. The question is still open for complete bipartite graphs which are not stars,
such as $C_4$ (see `erdos_810.test.cycleGraph_four`). We assume $\epsilon < 1/2$, since otherwise
no graph on $n$ vertices has $\epsilon n^2$ edges.
-/
@[category research solved, AMS 5]
theorem erdos_810.variants.sarkozy_selkow (V : Type) [Finite V] (L : SimpleGraph V)
    (hL : L.Connected) (hL' : L.IsBipartite)
    (hL'' : ∀ s t : ℕ, IsEmpty (L ≃g completeBipartiteGraph (Fin s) (Fin t)))
    (ε : ℝ) (hε : 0 < ε) (hε' : ε < 1 / 2) :
    Tendsto (fun n : ℕ ↦ (maxAntiRamseyNumber n ⌈ε * n ^ 2⌉₊ L : ℝ) / n) atTop atTop := by
  sorry

/--
$C_4$ is a connected bipartite graph which is not a star, so it is covered by
`erdos_810.variants.connected_bipartite`. It is the complete bipartite graph $K_{2,2}$, so it is
not covered by `erdos_810.variants.sarkozy_selkow`.
-/
@[category test, AMS 5]
theorem erdos_810.test.cycleGraph_four :
    (cycleGraph 4).Connected ∧ (cycleGraph 4).IsBipartite ∧ (∀ v, cycleGraph 4 ≠ starGraph v) ∧
      Nonempty (cycleGraph 4 ≃g completeBipartiteGraph (Fin 2) (Fin 2)) := by
  refine ⟨cycleGraph_connected, ⟨.mk (fun i ↦ ⟨i.val % 2, by omega⟩) (by decide)⟩, ?_, ?_⟩
  · intro v hv
    have key : ∀ a b, (cycleGraph 4).Adj a b ↔ (starGraph v).Adj a b := fun a b ↦ by rw [hv]
    fin_cases v <;> revert key <;> decide
  · refine ⟨⟨⟨![.inl 0, .inr 0, .inl 1, .inr 1], Sum.elim ![0, 2] ![1, 3], by decide, by decide⟩,
      ?_⟩⟩
    intro a b
    fin_cases a <;> fin_cases b <;> simp [completeBipartiteGraph] <;> decide

/--
The path $P_4$ on four vertices is a connected bipartite graph which is not complete bipartite, so
`erdos_810.variants.sarkozy_selkow` applies to it and gives
`erdos_810.variants.path_four_tendsto`.
-/
@[category test, AMS 5]
theorem erdos_810.test.pathGraph_four :
    (pathGraph 4).Connected ∧ (pathGraph 4).IsBipartite ∧
      ∀ s t : ℕ, IsEmpty (pathGraph 4 ≃g completeBipartiteGraph (Fin s) (Fin t)) := by
  refine ⟨pathGraph_connected 3, ⟨.mk (fun i ↦ ⟨i.val % 2, by omega⟩) ?_⟩, fun s t ↦ ⟨fun f ↦ ?_⟩⟩
  · intro a b h
    fin_cases a <;> fin_cases b <;> simp_all [pathGraph_adj]
  · -- `f 2` and `f 3` are adjacent, but `f 0` is adjacent to neither of them.
    have h₀₂ : ¬ (completeBipartiteGraph (Fin s) (Fin t)).Adj (f 2) (f 0) := by
      rw [f.map_adj_iff]; simp [pathGraph_adj]
    have h₀₃ : ¬ (completeBipartiteGraph (Fin s) (Fin t)).Adj (f 0) (f 3) := by
      rw [f.map_adj_iff]; simp [pathGraph_adj]
    have h₂₃ : (completeBipartiteGraph (Fin s) (Fin t)).Adj (f 2) (f 3) := by
      rw [f.map_adj_iff]; simp [pathGraph_adj]
    generalize f 0 = x at h₀₂ h₀₃
    generalize f 2 = y at h₀₂ h₂₃
    generalize f 3 = z at h₀₃ h₂₃
    rcases x with x | x <;> rcases y with y | y <;> rcases z with z | z <;>
      simp_all [completeBipartiteGraph]

end Erdos810
