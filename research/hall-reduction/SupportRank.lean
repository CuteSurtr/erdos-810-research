import HubGraph
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Nat.Choose.Basic

/-! # A rank obstruction for monochromatic matchings in rainbow-four-cycle graphs -/

set_option autoImplicit false

open SimpleGraph Matrix

namespace Erdos810

variable {F I V K : Type*} [Field F] [Fintype I]

private abbrev PairIndex (r : ℕ) := (b : Fin r) × Fin b.val

private def pairFirst {r : ℕ} (p : PairIndex r) : Fin r := ⟨p.2, p.2.isLt.trans p.1.isLt⟩

private theorem card_pairIndex (r : ℕ) : Fintype.card (PairIndex r) = r.choose 2 := by
  simp only [PairIndex, Fintype.card_sigma, Fintype.card_fin]
  calc
    _ = ∑ i ∈ Finset.range r, i := Fin.sum_univ_eq_sum_range (fun n : ℕ ↦ n) r
    _ = _ := by rw [Finset.sum_range_id, Nat.choose_two_right]

/-- The minor in rows $u,v$ and columns $x,y$. -/
def edgePairMinor (A : Matrix V V F) (u v x y : V) : F := A u x * A v y - A u y * A v x

private theorem sum_minor {r : ℕ} (X : Matrix V (Fin r) F) (Y : Matrix (Fin r) V F)
    (u v x y : V) : edgePairMinor (X * Y) u v x y =
    ∑ a, ∑ b, (X u a * X v b) * (Y a x * Y b y - Y a y * Y b x) := by
  simp only [edgePairMinor, Matrix.mul_apply, Finset.sum_mul, Finset.mul_sum, ← Finset.sum_sub_distrib]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  ring

/-- A nonsingular diagonal matrix of these two-row, two-column minors needs one independent
alternating coordinate per diagonal entry. The field can have any characteristic. -/
theorem card_le_choose_of_diagonal_minors {r : ℕ} (X : Matrix V (Fin r) F) (Y : Matrix (Fin r) V F)
    (u v : I → V) (nonzero : ∀ i, edgePairMinor (X * Y) (u i) (v i) (u i) (v i) ≠ 0)
    (off : ∀ i j, i ≠ j → edgePairMinor (X * Y) (u i) (v i) (u j) (v j) = 0) :
    Fintype.card I ≤ r.choose 2 := by
  classical
  let alt := fun (i : I) (a b : Fin r) ↦ Y a (u i) * Y b (v i) - Y a (v i) * Y b (u i)
  let vec := fun (i : I) (p : PairIndex r) ↦ alt i (pairFirst p) p.1
  have independent : LinearIndependent F vec := by
    apply Fintype.linearIndependent_iff.mpr
    intro c hc i
    have small (a b : Fin r) (hab : a < b) : ∑ j, c j * alt j a b = 0 := by
      let p : PairIndex r := ⟨b, ⟨a.val, hab⟩⟩
      have h := congrFun hc p
      simpa [vec, pairFirst, p, Finset.sum_apply] using h
    have allpairs (a b : Fin r) : ∑ j, c j * alt j a b = 0 := by
      rcases lt_trichotomy a b with hab | rfl | hba
      · exact small _ _ hab
      · simp [alt, mul_comm]
      · have neg (j : I) : alt j a b = -alt j b a := by dsimp [alt]; ring
        simp_rw [neg, mul_neg, Finset.sum_neg_distrib, small b a hba, neg_zero]
    let A := X * Y
    have zero : ∑ j, c j * edgePairMinor A (u i) (v i) (u j) (v j) = 0 := by
      simp_rw [A, sum_minor, Finset.mul_sum]
      calc
        _ = ∑ a, ∑ b, ∑ j, (X (u i) a * X (v i) b) * (c j * alt j a b) := by
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro a _
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro b _
          apply Finset.sum_congr rfl
          intro j _
          dsimp [alt]
          ring
        _ = 0 := by simp_rw [← Finset.mul_sum, allpairs, mul_zero, Finset.sum_const_zero]
    have single : ∑ j, c j * edgePairMinor A (u i) (v i) (u j) (v j) =
        c i * edgePairMinor A (u i) (v i) (u i) (v i) := by
      apply Finset.sum_eq_single i
      · intro j _ hji
        rw [off i j hji.symm, mul_zero]
      · simp
    rw [single] at zero
    exact (mul_eq_zero.mp zero).resolve_right (nonzero i)
  simpa only [Module.finrank_fintype_fun_eq_card, card_pairIndex] using independent.fintype_card_le_finrank

/-- A rank factorization through coordinates in a basis of the column space. -/
theorem exists_rank_factorization {J : Type*} [Fintype V] [Fintype J] (A : Matrix V J F) :
    ∃ (X : Matrix V (Fin A.rank) F) (Y : Matrix (Fin A.rank) J F), X * Y = A := by
  classical
  rw [A.rank_eq_finrank_span_cols]
  let W := Submodule.span F (Set.range A.col)
  let basis := Module.finBasis F W
  let col (j : J) : W := ⟨A.col j, Submodule.subset_span ⟨j, rfl⟩⟩
  refine ⟨fun i t ↦ (basis t).1 i, fun t j ↦ (basis.repr (col j)) t, ?_⟩
  ext i j
  have h := congrArg (fun v : W ↦ v.1 i) (basis.sum_repr (col j))
  simpa only [Submodule.coe_sum, Finset.sum_apply, SetLike.val_smul, Pi.smul_apply, smul_eq_mul,
    mul_comm, Matrix.mul_apply] using h

/-- The support itself is prescribed on both orientations. The two matrix entries at an edge
may differ. A single-color matching has at most `choose r 2` members in a width-`r` factorization. -/
theorem mono_matching_support_rank {r : ℕ} {G : SimpleGraph V} (C : G.EdgeLabeling K)
    (hr : C.IsRainbowFor (cycleGraph 4)) (X : Matrix V (Fin r) F) (Y : Matrix (Fin r) V F)
    (support : ∀ a b, (X * Y) a b ≠ 0 ↔ G.Adj a b) (u v : I → V)
    (edge : ∀ i, G.Adj (u i) (v i)) (color : ∀ i j, C.get _ _ (edge i) = C.get _ _ (edge j))
    (disjoint : ∀ i j, i ≠ j → u i ≠ u j ∧ u i ≠ v j ∧ v i ≠ u j ∧ v i ≠ v j) :
    Fintype.card I ≤ r.choose 2 := by
  let A := X * Y
  have diag (a : V) : A a a = 0 := by
    by_contra h
    exact G.loopless a ((support a a).mp h)
  apply card_le_choose_of_diagonal_minors X Y u v
  · intro i
    change edgePairMinor A _ _ _ _ ≠ 0
    simpa [edgePairMinor, diag] using And.intro ((support _ _).mpr (edge i)) ((support _ _).mpr (edge i).symm)
  · intro i j hij
    obtain ⟨huu, huv, hvu, hvv⟩ := disjoint i j hij
    have exclude (a b x y : V) (ab : G.Adj a b) (xy : G.Adj x y) (ax : a ≠ x) (by' : b ≠ y)
        (same : C.get a b ab = C.get x y xy) :
        A b x * A a y = 0 := by
      by_contra hn
      have hbx := (support b x).mp (left_ne_zero_of_mul hn)
      have hay := (support a y).mp (right_ne_zero_of_mul hn)
      have h := (List.nodup_cons.mp (EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr
        a b x y ab hbx xy hay.symm ax by')).1
      exact h (by simp [same])
    have first := exclude (u i) (v i) (v j) (u j) (edge i) (edge j).symm huv hvu
      ((color i j).trans (get_swap C (edge j)))
    have second := exclude (u i) (v i) (u j) (v j) (edge i) (edge j) huu hvv (color i j)
    change edgePairMinor A _ _ _ _ = 0
    simp only [edgePairMinor, mul_comm (A (u i) (u j)), mul_comm (A (u i) (v j)), first, second, sub_self]

/-- A support-fitting matrix of any rank and any characteristic bounds every single-color matching. -/
theorem mono_matching_le_choose_rank [Fintype V] {G : SimpleGraph V} (C : G.EdgeLabeling K)
    (hr : C.IsRainbowFor (cycleGraph 4)) (A : Matrix V V F)
    (support : ∀ a b, A a b ≠ 0 ↔ G.Adj a b) (u v : I → V)
    (edge : ∀ i, G.Adj (u i) (v i)) (color : ∀ i j, C.get _ _ (edge i) = C.get _ _ (edge j))
    (disjoint : ∀ i j, i ≠ j → u i ≠ u j ∧ u i ≠ v j ∧ v i ≠ u j ∧ v i ≠ v j) :
    Fintype.card I ≤ A.rank.choose 2 := by
  obtain ⟨X, Y, hXY⟩ := exists_rank_factorization A
  exact mono_matching_support_rank C hr X Y (by simpa only [hXY] using support) u v edge color disjoint

end Erdos810

#assert_no_sorry Erdos810.mono_matching_le_choose_rank
