import FoolingSetSpecialization
import Mathlib.Combinatorics.SimpleGraph.Extremal.Turan

/-! # Counting off-diagonal defects in a characteristic-zero fooling-set matrix -/

set_option autoImplicit false
open Matrix SimpleGraph
namespace Erdos810

/-- Edges are index pairs that satisfy the off-diagonal fooling-set identity. -/
def zeroCrossGraph {I F : Type*} [Field F] (A : Matrix I I F) : SimpleGraph I where
  Adj i j := i ≠ j ∧ A i j * A j i = 0
  symm i j h := ⟨h.1.symm, by rw [mul_comm]; exact h.2⟩
  loopless i h := h.1 rfl

noncomputable instance {I F : Type*} [Field F] (A : Matrix I I F) :
    DecidableRel (zeroCrossGraph A).Adj := Classical.decRel _

theorem zeroCrossGraph_cliqueFree {I F : Type*} [Fintype I] [Field F] [CharZero F]
    (A : Matrix I I F) (diag : ∀ i, A i i ≠ 0) :
    (zeroCrossGraph A).CliqueFree ((A.rank+1).choose 2 + 1) := by
  classical
  intro s hs
  let B : Matrix s s F := fun i j ↦ A i j
  have good (i j : s) (hij : i ≠ j) : B i j * B j i = 0 :=
    (hs.isClique i.2 j.2 (Subtype.val_injective.ne hij)).2
  have size := foolingSet_charZero_card_le_choose B (fun i ↦ diag i) good
  obtain ⟨X, Y, hXY⟩ := exists_rank_factorization A
  let U : Matrix s (Fin A.rank) F := fun i j ↦ X i j
  let V : Matrix (Fin A.rank) s F := fun i j ↦ Y i j
  have prod : U * V = B := by
    ext i j
    exact congrFun (congrFun hXY i.val) j.val
  have small : B.rank ≤ A.rank := by
    rw [← prod]
    exact (Matrix.rank_mul_le_left _ _).trans (by simpa using U.rank_le_card_width)
  have bound := size.trans (Nat.choose_le_choose 2 (Nat.succ_le_succ small))
  rw [Fintype.card_coe, hs.card_eq] at bound
  exact (Nat.not_succ_le_self _) bound

/-- A Turán estimate that keeps the number of missing ordered pairs, including the diagonal. -/
theorem order_sq_le_missing {I : Type*} [Fintype I] (G : SimpleGraph I) [DecidableRel G.Adj]
    (s : ℕ) (cf : G.CliqueFree (s+1)) :
    (Fintype.card I)^2 + 2*s*G.edgeFinset.card ≤ s*(Fintype.card I)^2 := by
  classical
  cases s with
  | zero =>
    have c : Fintype.card I = 0 := Fintype.card_eq_zero_iff.mpr (cliqueFree_one.mp cf)
    simp [c]
  | succ s =>
    obtain ⟨H, _, maxH⟩ := exists_isTuranMaximal (V := I) (Nat.succ_pos s)
    have le := maxH.2 _ cf
    rw [((isTuranMaximal_iff_nonempty_iso_turanGraph (Nat.succ_pos s)).mp maxH).some.card_edgeFinset_eq] at le
    have bound := (Nat.mul_le_mul_left (2*(s+1)) le).trans mul_card_edgeFinset_turanGraph_le
    simp only [Nat.add_sub_cancel] at bound
    nlinarith only [bound]

/-- A matrix with a nonzero diagonal and few symmetric nonzero pairs needs large rank. -/
theorem foolingSet_charZero_turan_bound {I F : Type*} [Fintype I] [Field F] [CharZero F]
    (A : Matrix I I F) (diag : ∀ i, A i i ≠ 0) :
    let s := (A.rank+1).choose 2
    let n := Fintype.card I
    (zeroCrossGraph A).edgeFinset.card ≤
      (n^2-(n%s)^2)*(s-1)/(2*s) + (n%s).choose 2 :=
  (zeroCrossGraph_cliqueFree A diag).card_edgeFinset_le

/-- Retain the leading quadratic terms of the exact Turán bound. -/
theorem foolingSet_charZero_defect_bound {I F : Type*} [Fintype I] [Field F] [CharZero F]
    (A : Matrix I I F) (diag : ∀ i, A i i ≠ 0) :
    let s := (A.rank+1).choose 2
    (Fintype.card I)^2 + 2*s*(zeroCrossGraph A).edgeFinset.card ≤ s*(Fintype.card I)^2 :=
  order_sq_le_missing _ _ (zeroCrossGraph_cliqueFree A diag)

end Erdos810

#assert_no_sorry Erdos810.foolingSet_charZero_defect_bound Erdos810.foolingSet_charZero_turan_bound
