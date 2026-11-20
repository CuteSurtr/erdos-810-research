import FoolingSetDefects

/-! # Reciprocal entry products and ordered support errors over arbitrary fields -/

set_option autoImplicit false
open Matrix SimpleGraph
namespace Erdos810

/-- The reciprocal entry products of a rank-r matrix factor through r² coordinates. -/
theorem reciprocal_product_rank {I F : Type*} [Fintype I] [Field F] (A : Matrix I I F) :
    Matrix.rank (fun i j ↦ A i j * A j i) ≤ A.rank^2 := by
  classical
  obtain ⟨X, Y, eqA⟩ := exists_rank_factorization A
  let P := Fin A.rank × Fin A.rank
  let U : Matrix I P F := fun i p ↦ X i p.2 * Y p.1 i
  let V : Matrix P I F := fun p j ↦ Y p.2 j * X j p.1
  have factor : U * V = (fun i j ↦ A i j * A j i : Matrix I I F) := by
    ext i j
    change (U*V) i j = A i j * A j i
    rw [← congrFun (congrFun eqA i) j, ← congrFun (congrFun eqA j) i]
    simp only [Matrix.mul_apply, U, V, P, Fintype.sum_prod_type, Finset.sum_mul, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro a _
    apply Finset.sum_congr rfl
    intro b _
    ring
  rw [← factor]
  exact (Matrix.rank_mul_le_left _ _).trans (by simpa [P,sq] using U.rank_le_card_width)

/-- The classical field-independent square bound for a fooling-set matrix. -/
theorem foolingSet_field_card_le_square {I F : Type*} [Fintype I] [Field F] (A : Matrix I I F)
    (diag : ∀ i, A i i ≠ 0) (cross : ∀ i j, i ≠ j → A i j * A j i = 0) :
    Fintype.card I ≤ A.rank^2 := by
  classical
  have diagonal : (fun i j ↦ A i j * A j i : Matrix I I F) =
      Matrix.diagonal (fun i ↦ A i i * A i i) := by
    ext i j
    by_cases h : i = j
    · subst j
      simp
    · simp [Matrix.diagonal_apply_ne _ h, cross i j h]
  have rank := reciprocal_product_rank A
  rw [diagonal, Matrix.rank_diagonal] at rank
  simpa [diag] using rank

/-- Charge an unordered reciprocal defect to a distinct false positive entry of the matrix. -/
theorem off_support_charge {I V F : Type*} [Fintype I] [LinearOrder I] [Fintype V] [Field F]
    (R : V → V → Prop) [DecidableRel R] (A : Matrix V V F) [DecidableEq F]
    (u v : I → V) (hu : Function.Injective u) (hv : Function.Injective v)
    (cross : ∀ i j, i ≠ j → ¬(R (u i) (v j) ∧ R (u j) (v i))) :
    (Finset.univ.filter (fun p : I × I ↦ p.1 < p.2 ∧
      A (u p.1) (v p.2) ≠ 0 ∧ A (u p.2) (v p.1) ≠ 0)).card ≤
    (Finset.univ.filter (fun p : V × V ↦ ¬R p.1 p.2 ∧ A p.1 p.2 ≠ 0)).card := by
  classical
  let bad := Finset.univ.filter (fun p : I × I ↦ p.1 < p.2 ∧
    A (u p.1) (v p.2) ≠ 0 ∧ A (u p.2) (v p.1) ≠ 0)
  let errors := Finset.univ.filter (fun p : V × V ↦ ¬R p.1 p.2 ∧ A p.1 p.2 ≠ 0)
  let pick (p : I × I) := if R (u p.1) (v p.2) then p.swap else p
  have recover (p : bad) : (min (pick p).1 (pick p).2, max (pick p).1 (pick p).2) = p.val := by
    have h := (Finset.mem_filter.mp p.2).2.1.le
    change (min (pick p).1 (pick p).2, max (pick p).1 (pick p).2) = (p.val.1,p.val.2)
    by_cases hR : R (u p.val.1) (v p.val.2) <;>
      simp [pick, hR, min_eq_left h, max_eq_right h, min_eq_right h, max_eq_left h]
  let send (p : bad) : errors := ⟨(u (pick p).1, v (pick p).2), by
    have hp := (Finset.mem_filter.mp p.2).2
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _, ?_⟩
    by_cases hR : R (u p.val.1) (v p.val.2)
    · have hn := fun h ↦ cross _ _ hp.1.ne ⟨hR,h⟩
      simpa [pick, hR] using And.intro hn hp.2.2
    · simpa [pick, hR] using And.intro hR hp.2.1⟩
  have inj : Function.Injective send := by
    intro p q eq
    have eq' : pick p = pick q := Prod.ext
      (hu (congrArg (fun z : errors ↦ z.val.1) eq)) (hv (congrArg (fun z : errors ↦ z.val.2) eq))
    exact Subtype.ext (by rw [← recover p, ← recover q, eq'])
  change bad.card ≤ errors.card
  simpa only [Fintype.card_coe] using Fintype.card_le_of_injective send inj

end Erdos810
#assert_no_sorry Erdos810.reciprocal_product_rank Erdos810.foolingSet_field_card_le_square
  Erdos810.off_support_charge
