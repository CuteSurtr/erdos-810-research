import FoolingSetRank
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.RingTheory.Jacobson.Ring

/-! # Specializing finite rank factorizations to the complex numbers

Keep all entries of both factors and the inverses of the prescribed nonzero
diagonal entries in a finite-type rational algebra. A maximal ideal has a
number field as residue field, so it gives a specialization to the complex numbers.
-/

set_option autoImplicit false

open Matrix

namespace Erdos810

private theorem complex_point (S : Type*) [CommRing S] [Nontrivial S] [Algebra ℚ S]
    [Algebra.FiniteType ℚ S] : Nonempty (S →ₐ[ℚ] ℂ) := by
  obtain ⟨m, hm⟩ := Ideal.exists_maximal S
  letI := Ideal.Quotient.field m
  letI := finite_of_finite_type_of_isJacobsonRing ℚ (S ⧸ m)
  exact ⟨(IsAlgClosed.lift (R := ℚ) (S := S ⧸ m) (M := ℂ)).comp (Ideal.Quotient.mkₐ ℚ m)⟩

/-- The sharp complex upper bound holds over every characteristic-zero field. -/
theorem foolingSet_charZero_card_le_choose {I F : Type*} [Fintype I] [Field F] [CharZero F]
    (A : Matrix I I F) (diag : ∀ i, A i i ≠ 0) (cross : ∀ i j, i ≠ j → A i j * A j i = 0) :
    Fintype.card I ≤ (A.rank+1).choose 2 := by
  classical
  let r := A.rank
  obtain ⟨X, Y, hXY⟩ := exists_rank_factorization A
  let gen : (I × Fin r) ⊕ ((Fin r × I) ⊕ I) → F :=
    Sum.elim (fun p ↦ X p.1 p.2) (Sum.elim (fun p ↦ Y p.1 p.2) (fun i ↦ (A i i)⁻¹))
  let S := Algebra.adjoin ℚ (Set.range gen)
  letI : Algebra.FiniteType ℚ S := Algebra.FiniteType.adjoin_of_finite (Set.finite_range gen)
  obtain ⟨φ⟩ := complex_point S
  have mem (p) : gen p ∈ S := Algebra.subset_adjoin ⟨p, rfl⟩
  let X' : Matrix I (Fin r) S := fun i a ↦ ⟨X i a, mem (.inl (i,a))⟩
  let Y' : Matrix (Fin r) I S := fun a i ↦ ⟨Y a i, mem (.inr (.inl (a,i)))⟩
  let inv' (i : I) : S := ⟨(A i i)⁻¹, mem (.inr (.inr i))⟩
  let A' := X' * Y'
  have coeA (i j : I) : S.val (A' i j) = A i j := by
    simpa [A', Matrix.mul_apply, X', Y'] using congrFun (congrFun hXY i) j
  have hinj : Function.Injective S.val := Subtype.val_injective
  let B : Matrix I I ℂ := fun i j ↦ φ (A' i j)
  have dB (i : I) : B i i ≠ 0 := by
    have unit : A' i i * inv' i = 1 := by
      apply hinj
      rw [map_mul, map_one, coeA]
      exact mul_inv_cancel₀ (diag i)
    have h := congrArg φ unit
    rw [map_mul, map_one] at h
    exact left_ne_zero_of_mul (ne_zero_of_eq_one h)
  have cB (i j : I) (hne : i ≠ j) : B i j * B j i = 0 := by
    have h : A' i j * A' j i = 0 := by
      apply hinj
      rw [map_mul, coeA, coeA, map_zero, cross i j hne]
    exact (map_mul φ _ _).symm.trans ((congrArg φ h).trans (map_zero φ))
  let XC : Matrix I (Fin r) ℂ := fun i a ↦ φ (X' i a)
  let YC : Matrix (Fin r) I ℂ := fun a i ↦ φ (Y' a i)
  have eqB : B = XC * YC := by
    ext i j
    simp [B, A', XC, YC, Matrix.mul_apply]
  have rankB : B.rank ≤ r := by
    rw [eqB]
    exact (Matrix.rank_mul_le_left _ _).trans (by simpa using XC.rank_le_card_width)
  exact (foolingSet_complex_card_le_choose B dB cB).trans
    (Nat.choose_le_choose 2 (Nat.succ_le_succ rankB))

end Erdos810

#assert_no_sorry Erdos810.foolingSet_charZero_card_le_choose
