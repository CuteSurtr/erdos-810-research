import SupportRank
import Mathlib.Data.Complex.Basic

/-! # A symmetric-coordinate bound for complex fooling-set matrices

The Hermitian form `(H,L) ↦ trace (H * conj L)` is positive on the span of
the rank-one matrices indexed by a fooling set and nonpositive on alternating
matrices. Symmetrizing their upper-triangular entries is therefore injective.
-/

set_option autoImplicit false

open Matrix ComplexConjugate

noncomputable section

namespace Erdos810

variable {I : Type*} [Fintype I]

private abbrev Upper (r : ℕ) := (b : Fin r) × Fin (b.val+1)

private def upperFirst {r : ℕ} (p : Upper r) : Fin r :=
  ⟨p.2, (Nat.le_of_lt_succ p.2.isLt).trans_lt p.1.isLt⟩

private theorem card_upper (r : ℕ) : Fintype.card (Upper r) = (r+1).choose 2 := by
  simp only [Upper, Fintype.card_sigma, Fintype.card_fin, Finset.sum_add_distrib, Finset.sum_const,
    Finset.card_univ, nsmul_eq_mul, mul_one]
  calc
    _ = (∑ i ∈ Finset.range r, i) + r := by
      rw [← Fin.sum_univ_eq_sum_range (fun n : ℕ ↦ n) r]
      rfl
    _ = ∑ i ∈ Finset.range (r+1), i := (Finset.sum_range_succ _ _).symm
    _ = _ := by rw [Finset.sum_range_id, Nat.choose_two_right]

private def swapForm {r : ℕ} (H L : Matrix (Fin r) (Fin r) ℂ) : ℂ :=
  ∑ a, ∑ b, H a b * conj (L b a)

private theorem swapForm_combo_left {r : ℕ} (M : I → Matrix (Fin r) (Fin r) ℂ)
    (c : I → ℂ) (N : Matrix (Fin r) (Fin r) ℂ) :
    swapForm (fun a b ↦ ∑ i, c i * M i a b) N = ∑ i, c i * swapForm (M i) N := by
  simp only [swapForm, Finset.sum_mul, Finset.mul_sum, mul_assoc]
  calc
    _ = ∑ a, ∑ i, ∑ b, c i * (M i a b * conj (N b a)) :=
      Finset.sum_congr rfl (fun _ _ ↦ Finset.sum_comm)
    _ = _ := Finset.sum_comm

private theorem swapForm_combo_right {r : ℕ} (M : I → Matrix (Fin r) (Fin r) ℂ)
    (c : I → ℂ) (N : Matrix (Fin r) (Fin r) ℂ) :
    swapForm N (fun a b ↦ ∑ i, c i * M i a b) = ∑ i, conj (c i) * swapForm N (M i) := by
  simp only [swapForm, map_sum, map_mul, Finset.mul_sum, mul_left_comm (N _ _) (conj (c _))]
  calc
    _ = ∑ a, ∑ i, ∑ b, conj (c i) * (N a b * conj (M i b a)) :=
      Finset.sum_congr rfl (fun _ _ ↦ Finset.sum_comm)
    _ = _ := Finset.sum_comm

private def coordinateMatrix {r : ℕ} (X : Matrix I (Fin r) ℂ) (Y : Matrix (Fin r) I ℂ)
    (i : I) : Matrix (Fin r) (Fin r) ℂ :=
  fun a b ↦ X i a * conj (Y b i)

omit [Fintype I] in
private theorem swapForm_coordinate {r : ℕ} (X : Matrix I (Fin r) ℂ) (Y : Matrix (Fin r) I ℂ)
    (i j : I) : swapForm (coordinateMatrix X Y i) (coordinateMatrix X Y j) =
      (X * Y) i j * conj ((X * Y) j i) := by
  simp only [swapForm, coordinateMatrix, Matrix.mul_apply, map_mul, map_sum, RingHomCompTriple.comp_apply,
    RingHom.id_apply, Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  ring

private theorem swapForm_skew_nonpos {r : ℕ} (M : Matrix (Fin r) (Fin r) ℂ)
    (skew : ∀ a b, M b a = -M a b) : (swapForm M M).re ≤ 0 := by
  have h : swapForm M M = ∑ a, ∑ b, -((Complex.normSq (M a b) : ℝ) : ℂ) := by
    apply Finset.sum_congr rfl
    intro a _
    apply Finset.sum_congr rfl
    intro b _
    rw [skew a b, map_neg, mul_neg, Complex.mul_conj]
  rw [h]
  simp only [Complex.re_sum, Complex.neg_re, Complex.ofReal_re]
  exact Finset.sum_nonpos (fun _ _ ↦ Finset.sum_nonpos (fun _ _ ↦ neg_nonpos.mpr (Complex.normSq_nonneg _)))

/-- A complex fooling-set matrix of rank `r` has size at most `r(r+1)/2`. -/
theorem foolingSet_complex_card_le_choose (A : Matrix I I ℂ)
    (diag : ∀ i, A i i ≠ 0) (cross : ∀ i j, i ≠ j → A i j * A j i = 0) :
    Fintype.card I ≤ (A.rank+1).choose 2 := by
  classical
  let r := A.rank
  obtain ⟨X, Y, hXY⟩ := exists_rank_factorization A
  let H := coordinateMatrix X Y
  let sym := fun (i : I) (p : Upper r) ↦ H i (upperFirst p) p.1 + H i p.1 (upperFirst p)
  have independent : LinearIndependent ℂ sym := by
    apply Fintype.linearIndependent_iff.mpr
    intro c hc i
    let M : Matrix (Fin r) (Fin r) ℂ := fun a b ↦ ∑ j, c j * H j a b
    have sym_zero (a b : Fin r) (hab : a ≤ b) : M a b + M b a = 0 := by
      let p : Upper r := ⟨b, ⟨a.val, Nat.lt_succ_of_le hab⟩⟩
      have h := congrFun hc p
      simpa [sym, upperFirst, p, M, Finset.sum_apply, mul_add, Finset.sum_add_distrib] using h
    have skew (a b : Fin r) : M b a = -M a b := by
      rcases le_total a b with hab | hba
      · linear_combination sym_zero a b hab
      · linear_combination sym_zero b a hba
    have diagonalize (j : I) : ∑ k, conj (c k) * swapForm (H j) (H k) =
        conj (c j) * (Complex.normSq (A j j) : ℂ) := by
      rw [Finset.sum_eq_single j]
      · simp [H, swapForm_coordinate, hXY, Complex.mul_conj]
      · intro k _ hkj
        rcases mul_eq_zero.mp (cross j k hkj.symm) with hk | hk
        · simp [H, swapForm_coordinate, hXY, hk]
        · simp [H, swapForm_coordinate, hXY, hk]
      · simp
    have pos : swapForm M M = ∑ j, ((Complex.normSq (c j) * Complex.normSq (A j j) : ℝ) : ℂ) := by
      rw [show M = (fun a b ↦ ∑ j, c j * H j a b) from rfl, swapForm_combo_left]
      simp_rw [swapForm_combo_right H c, diagonalize, ← mul_assoc, Complex.mul_conj, Complex.ofReal_mul]
    have hn := swapForm_skew_nonpos M skew
    rw [pos] at hn
    simp only [Complex.re_sum, Complex.ofReal_re] at hn
    have hi : Complex.normSq (c i) * Complex.normSq (A i i) ≤ 0 :=
      (Finset.single_le_sum (fun j _ ↦ mul_nonneg (Complex.normSq_nonneg (c j))
        (Complex.normSq_nonneg (A j j))) (Finset.mem_univ i)).trans hn
    by_contra hc'
    exact (not_lt_of_ge hi) (mul_pos (Complex.normSq_pos.mpr hc') (Complex.normSq_pos.mpr (diag i)))
  simpa only [Module.finrank_fintype_fun_eq_card, card_upper] using independent.fintype_card_le_finrank

end Erdos810

#assert_no_sorry Erdos810.foolingSet_complex_card_le_choose
