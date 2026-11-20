import Mathlib.Data.Finset.Card
import Mathlib.Data.Real.Sqrt
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-! # Counting the four-cycles spoiled by inserting an edge

The two maps send a repeated boundary color to its neighbors at each hub.
Both are injective by properness. An endpoint in both images is a common
neighbor, while no bad path has two common neighbors.
-/

set_option autoImplicit false

namespace Erdos810.EdgeInsertion

variable {I V : Type*} [Fintype I] [Fintype V] [DecidableEq V]

theorem split_bound (x y : I → V) (W : Finset V)
    (hx : Function.Injective x) (hy : Function.Injective y)
    (overlap : ∀ i j, x i = y j → x i ∈ W)
    (outside : ∀ i, x i ∈ W → y i ∉ W) :
    3 * Fintype.card I ≤ 2 * Fintype.card V := by
  classical
  let f (i : I) := if x i ∈ W then y i else x i
  have hf : Function.Injective f := by
    intro i j eq
    by_cases hi : x i ∈ W <;> by_cases hj : x j ∈ W
    · apply hy
      simpa [f, hi, hj] using eq
    · have same : y i = x j := by simpa [f, hi, hj] using eq
      exact False.elim (hj (overlap j i same.symm))
    · have same : x i = y j := by simpa [f, hi, hj] using eq
      exact False.elim (hi (overlap i j same))
    · apply hx
      simpa [f, hi, hj] using eq
  have range_f : Finset.univ.image f ⊆ Finset.univ \ W := by
    intro v hv
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hv
    refine Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, ?_⟩
    by_cases hi : x i ∈ W
    · simpa [f, hi] using outside i hi
    · simp [f, hi]
  have one := Finset.card_le_card range_f
  rw [Finset.card_image_of_injective _ hf, Finset.card_sdiff_of_subset (Finset.subset_univ W),
    Finset.card_univ, Finset.card_univ] at one
  let X := Finset.univ.image x
  let Y := Finset.univ.image y
  have joint : X ∩ Y ⊆ W := by
    intro v hv
    obtain ⟨vx, vy⟩ := Finset.mem_inter.mp hv
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp vx
    obtain ⟨j, _, eq⟩ := Finset.mem_image.mp vy
    exact overlap i j eq.symm
  have cx : X.card = Fintype.card I := by simp [X, Finset.card_image_of_injective _ hx]
  have cy : Y.card = Fintype.card I := by simp [Y, Finset.card_image_of_injective _ hy]
  have two := Finset.card_union_add_card_inter X Y
  have hu := Finset.card_le_univ (X ∪ Y)
  have hw := Finset.card_le_card joint
  have wc := Finset.card_le_univ W
  omega

omit [Fintype I] [Fintype V] [DecidableEq V] in
/-- Reversing the endpoints of two bad paths would put both ends in the common set. -/
theorem no_reversed_middle (x y : I → V) (W : Finset V)
    (overlap : ∀ i j, x i = y j → x i ∈ W) (outside : ∀ i, x i ∈ W → y i ∉ W)
    {i j : I} (first : x i = y j) (second : y i = x j) : False := by
  exact outside i (overlap i j first) (second ▸ overlap j i second.symm)

/-- Disjoint paths need separate deletions in every transversal. -/
theorem disjoint_paths_bound {E : Type*} [DecidableEq E] (paths : I → Finset E)
    (separate : ∀ i j, i ≠ j → Disjoint (paths i) (paths j)) (removed : Finset E)
    (hit : ∀ i, ∃ e ∈ paths i, e ∈ removed) : Fintype.card I ≤ removed.card := by
  classical
  choose e he hremoved using hit
  let chosen (i : I) : ↥removed := ⟨e i, hremoved i⟩
  have inj : Function.Injective chosen := by
    intro i j eq
    by_contra h
    have equal : e i = e j := congrArg Subtype.val eq
    exact Finset.disjoint_left.mp (separate i j h) (he i) (equal ▸ he j)
  simpa using Fintype.card_le_of_injective chosen inj

/-- Exact tradeoff for h square blocks and r groups of three vertices. -/
theorem tradeoff_identity (t h r pad : ℕ) :
    3*(2*r+h*t)+h*(t+1)+h+2*pad = 2*(h*(2*t+1)+3*r+pad) := by ring

/-- Combine deletion of the smaller boundary star with random choice of an
insertion label after deleting all spokes outside the common neighborhood.
Here N counts vertices other than the two hubs. -/
theorem within_palette_bound {n N w cost inside : ℕ} (small : 2*cost ≤ N+w)
    (exclusive : n*cost ≤ n*(N-w)+inside+2*w) (fit : w ≤ N) :
    3*n*cost ≤ 2*n*N+inside+2*w := by
  have bound := Nat.mul_le_mul_left n small
  have partition : n*(N-w)+n*w=n*N := by
    rw [← Nat.mul_add, Nat.sub_add_cancel fit]
  nlinarith

/-- The two same-palette strategies meet at normalized common-neighborhood
size 3-sqrt(7), using the uniform quarter bound on internal edges. -/
theorem insertion_envelope {x cost : ℝ} (unit : x ≤ 1)
    (first : cost ≤ (1+x)/2) (second : cost ≤ 1-x+x^2/4) :
    cost ≤ 2-Real.sqrt 7/2 := by
  have hs := Real.sq_sqrt (show (0:ℝ) ≤ 7 by norm_num)
  have hpos := Real.sqrt_nonneg (7:ℝ)
  by_cases h : x ≤ 3-Real.sqrt 7
  · linarith
  · have signs : 0 ≤ (x-(3-Real.sqrt 7))*(4-x-(3-Real.sqrt 7)) :=
      mul_nonneg (by linarith) (by linarith)
    nlinarith

end Erdos810.EdgeInsertion
