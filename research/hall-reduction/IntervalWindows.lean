import HubGraph
import Mathlib.Combinatorics.Enumerative.DoubleCounting

/-! # Complete rectangles and consecutive windows in rainbow-four-cycle graphs -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {V K : Type*} {G : SimpleGraph V}

private theorem rectangle_first (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4))
    {a b c d : V} (ab : G.Adj a b) (cb : G.Adj c b) (cd : G.Adj c d) (ad : G.Adj a d)
    (ac : a ≠ c) (bd : b ≠ d) :
    C.get a b ab ≠ C.get c b cb ∧ C.get a b ab ≠ C.get c d cd ∧ C.get a b ab ≠ C.get a d ad := by
  have h := (List.nodup_cons.mp (EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr
    a b c d ab cb.symm cd ad.symm ac bd)).1
  rw [← get_swap C cb, ← get_swap C ad] at h
  simpa using h

/-- All edges of a complete rectangle with both sides of size at least two have distinct colors. -/
theorem rectangle_palette_bound [Fintype K] (C : G.EdgeLabeling K)
    (hr : C.IsRainbowFor (cycleGraph 4)) (A B : Finset V) (hA : 1 < A.card) (hB : 1 < B.card)
    (adj : ∀ a ∈ A, ∀ b ∈ B, G.Adj a b) : A.card * B.card ≤ Fintype.card K := by
  classical
  let paint : A × B → K := fun p ↦ C.get _ _ (adj p.1 p.1.2 p.2 p.2.2)
  have inj : Function.Injective paint := by
    rintro ⟨⟨a, ha⟩, ⟨b, hb⟩⟩ ⟨⟨c, hc⟩, ⟨d, hd⟩⟩ he
    change C.get a b _ = C.get c d _ at he
    by_cases ac : a = c
    · subst c
      by_cases bd : b = d
      · subst d; rfl
      obtain ⟨x, hx, hxa⟩ := A.exists_mem_ne hA a
      exact ((rectangle_first C hr (adj a ha b hb) (adj x hx b hb) (adj x hx d hd)
        (adj a ha d hd) hxa.symm bd).2.2 he).elim
    · by_cases bd : b = d
      · subst d
        obtain ⟨y, hy, hyb⟩ := B.exists_mem_ne hB b
        exact ((rectangle_first C hr (adj a ha b hb) (adj c hc b hb) (adj c hc y hy)
          (adj a ha y hy) ac hyb.symm).1 he).elim
      exact ((rectangle_first C hr (adj a ha b hb) (adj c hc b hb) (adj c hc d hd)
        (adj a ha d hd) ac bd).2.1 he).elim
  simpa using Fintype.card_le_of_injective paint inj

/-- Starts of windows with width `t+1` in a finite row of occupied natural-number columns. -/
def windowStarts (B : Finset ℕ) : ℕ → Finset ℕ
  | 0 => B
  | t + 1 => (windowStarts B t).filter (fun j ↦ j + (t + 1) ∈ B)

/-- Every nonempty consecutive run has exactly one last column. -/
def runEnds (B : Finset ℕ) : Finset ℕ := B.filter (fun j ↦ j + 1 ∉ B)

theorem mem_windowStarts {B : Finset ℕ} {j t : ℕ} :
    j ∈ windowStarts B t ↔ ∀ d ≤ t, j + d ∈ B := by
  induction t with
  | zero => simp [windowStarts]
  | succ t ih =>
    rw [windowStarts, Finset.mem_filter, ih]
    constructor
    · rintro ⟨h, hlast⟩ d hd
      rcases Nat.lt_or_eq_of_le hd with hd | rfl
      · exact h d (by omega)
      · exact hlast
    · exact fun h ↦ ⟨fun d hd ↦ h d (by omega), h _ le_rfl⟩

/-- Extending a window by one column loses at most one start per run. -/
theorem card_le_windows_add_runs (B : Finset ℕ) (t : ℕ) :
    B.card ≤ (windowStarts B t).card + t * (runEnds B).card := by
  induction t with
  | zero => simp [windowStarts]
  | succ t ih =>
    let lost := (windowStarts B t).filter (fun j ↦ j + (t + 1) ∉ B)
    have inject : Function.Injective (fun j : ℕ ↦ j + t) := fun _ _ h ↦ Nat.add_right_cancel h
    have sub : lost.image (fun j ↦ j + t) ⊆ runEnds B := by
      intro x hx
      obtain ⟨j, hj, rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨hw, hm⟩ := Finset.mem_filter.mp hj
      exact Finset.mem_filter.mpr ⟨mem_windowStarts.mp hw t le_rfl, by simpa [Nat.add_assoc] using hm⟩
    have hl : lost.card ≤ (runEnds B).card := by
      simpa only [Finset.card_image_of_injective _ inject] using Finset.card_le_card sub
    have split : (windowStarts B (t+1)).card + lost.card = (windowStarts B t).card :=
      Finset.filter_card_add_filter_neg_card_eq_card _
    rw [Nat.succ_mul]
    omega

/-- A board with at most `cap` rows covering each window obeys the run bound. -/
theorem window_board_bound {I : Type*} (rows : Finset I) (board : I → Finset ℕ) (b t cap : ℕ)
    (bounded : ∀ i ∈ rows, board i ⊆ Finset.range b)
    (capacity : ∀ j ∈ Finset.range (b-t), (rows.filter (fun i ↦ j ∈ windowStarts (board i) t)).card ≤ cap) :
    ∑ i ∈ rows, (board i).card ≤ t * (∑ i ∈ rows, (runEnds (board i)).card) + (b-t) * cap := by
  classical
  let starts := Finset.range (b-t)
  let rel := fun i : I ↦ fun j : ℕ ↦ j ∈ windowStarts (board i) t
  have inside (i : I) (hi : i ∈ rows) : starts.bipartiteAbove rel i = windowStarts (board i) t := by
    ext j
    change (j ∈ starts.filter (fun j ↦ j ∈ windowStarts (board i) t)) ↔ _
    rw [Finset.mem_filter]
    refine ⟨And.right, fun hj ↦ ⟨?_, hj⟩⟩
    have hjt := Finset.mem_range.mp (bounded i hi (mem_windowStarts.mp hj t le_rfl))
    exact Finset.mem_range.mpr (by omega)
  have count : ∑ i ∈ rows, (windowStarts (board i) t).card ≤ (b-t) * cap := calc
    _ = ∑ i ∈ rows, (starts.bipartiteAbove rel i).card := by
      apply Finset.sum_congr rfl; intro i hi; rw [inside i hi]
    _ = ∑ j ∈ starts, (rows.bipartiteBelow rel j).card :=
      Finset.sum_card_bipartiteAbove_eq_sum_card_bipartiteBelow rel
    _ ≤ ∑ _j ∈ starts, cap := Finset.sum_le_sum (fun j hj ↦ capacity j hj)
    _ = _ := by simp [starts]
  calc
    _ ≤ ∑ i ∈ rows, ((windowStarts (board i) t).card + t * (runEnds (board i)).card) :=
      Finset.sum_le_sum (fun i _ ↦ card_le_windows_add_runs (board i) t)
    _ = (∑ i ∈ rows, (windowStarts (board i) t).card) + t * ∑ i ∈ rows, (runEnds (board i)).card := by
      rw [Finset.sum_add_distrib, Finset.mul_sum]
    _ ≤ _ := by omega

/-- Finite run inequality in the adjacency matrix. The column ordering is the natural ordering. -/
theorem graph_window_bound [Fintype K] {H : SimpleGraph ℕ} (C : H.EdgeLabeling K)
    (hr : C.IsRainbowFor (cycleGraph 4)) (A : Finset ℕ) (board : ℕ → Finset ℕ)
    (b t : ℕ) (ht : 0 < t) (bounded : ∀ i ∈ A, board i ⊆ Finset.range b)
    (support : ∀ i ∈ A, ∀ j ∈ board i, H.Adj i j) :
    ∑ i ∈ A, (board i).card ≤ t * (∑ i ∈ A, (runEnds (board i)).card) +
      (b-t) * max 1 (Fintype.card K / (t+1)) := by
  classical
  apply window_board_bound A board b t _ bounded
  intro j _
  let R := A.filter (fun i ↦ j ∈ windowStarts (board i) t)
  change R.card ≤ _
  by_cases hR : R.card ≤ 1
  · exact hR.trans (le_max_left _ _)
  let S := (Finset.range (t+1)).image (fun d ↦ j+d)
  have inj : Function.Injective (fun d : ℕ ↦ j+d) := fun _ _ h ↦ Nat.add_left_cancel h
  have hS : S.card = t+1 := by simp [S, Finset.card_image_of_injective _ inj]
  have hc := rectangle_palette_bound C hr R S (by omega) (by omega) (by
    intro i hi u hu
    obtain ⟨hi, hw⟩ := Finset.mem_filter.mp hi
    obtain ⟨d, hd, rfl⟩ := Finset.mem_image.mp hu
    exact support i hi _ (mem_windowStarts.mp hw d (by have := Finset.mem_range.mp hd; omega)))
  rw [hS] at hc
  exact (Nat.le_div_iff_mul_le (by omega : 0 < t+1)).mpr hc |>.trans (le_max_right _ _)

end Erdos810
