import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Tactic.Push

/-! A color class on distinct row and column indices has at most 2h+1
members if each selected column omits at most h entries and every pair
has a missing cross entry. -/

set_option autoImplicit false
open scoped BigOperators

namespace Erdos810.CrownColorBudget

theorem class_size {I : Type*} [Fintype I] [DecidableEq I]
    (holes : I → I → ℕ) (h : ℕ)
    (columns : ∀ j, ∑ i, holes i j ≤ h)
    (cross : ∀ i j, i ≠ j → 1 ≤ holes i j + holes j i) :
    Fintype.card I ≤ 2 * h + 1 := by
  classical
  have point (i j : I) : 1 ≤ (if i = j then 1 else 0) + holes i j + holes j i := by
    by_cases e : i = j
    · simp only [e, if_true]
      omega
    · simpa [e] using cross i j e
  have total : (∑ j, ∑ i, holes i j) ≤ Fintype.card I * h := by
    simpa using Finset.sum_le_sum (s := (Finset.univ : Finset I)) (fun j _ ↦ columns j)
  have p : Fintype.card I * Fintype.card I ≤
      Fintype.card I + (∑ j, ∑ i, holes i j) + (∑ j, ∑ i, holes i j) := by
    calc
      Fintype.card I * Fintype.card I = ∑ i : I, ∑ j : I, (1 : ℕ) := by simp
      _ ≤ ∑ i : I, ∑ j : I, ((if i = j then 1 else 0) + holes i j + holes j i) :=
        Finset.sum_le_sum fun i _ ↦ Finset.sum_le_sum fun j _ ↦ point i j
      _ = Fintype.card I + (∑ j, ∑ i, holes i j) + (∑ j, ∑ i, holes i j) := by
        simp only [Finset.sum_add_distrib, Finset.sum_ite_eq, Finset.mem_univ, if_true,
          Finset.sum_const, Finset.card_univ, Nat.nsmul_eq_mul, mul_one]
        rw [Finset.sum_comm (f := fun i j ↦ holes i j)]
  by_contra! big
  have positive : 0 < Fintype.card I := by omega
  have strict := Nat.mul_lt_mul_of_pos_left big positive
  have b : Fintype.card I * Fintype.card I ≤ Fintype.card I * (2 * h + 1) := by
    rw [Nat.mul_add, Nat.mul_one, Nat.mul_comm 2 h, ← Nat.mul_assoc, Nat.mul_two]
    omega
  exact (Nat.not_lt_of_ge b) strict

theorem es_copies (t : ℕ) (ht : 0 < t)
    (star_budget : 17 * t * (t - 1) ≤ 152 * t * 3) : t ≤ 27 := by
  have h : t * (17 * (t - 1)) ≤ t * 456 := by
    simpa only [Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using star_budget
  have := Nat.le_of_mul_le_mul_left h ht
  omega

end Erdos810.CrownColorBudget
