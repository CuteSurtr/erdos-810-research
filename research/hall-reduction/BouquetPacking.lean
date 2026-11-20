import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Zify
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset

/-! # Counting the private vertices needed for forced deletions

A block with part sizes 1, a, b shares one cross edge with the other blocks.
It uses a+b-1 private vertices. Its unavoidable inherited loss with palette n
is a*b+a+b-n, with natural subtraction. The graph construction and gluing
are described in the accompanying proof. -/

set_option autoImplicit false
open scoped BigOperators
namespace Erdos810.BouquetPacking

def loss (n a b : ℕ) : ℕ := a*b+a+b-n
def privateVertices (a b : ℕ) : ℕ := a+b-1

theorem loss_with_slack (a b r : ℕ) :
    loss (b*(a+1)+r) a b = a-r := by
  simp only [loss, Nat.mul_add, Nat.mul_one, Nat.mul_comm b a]
  omega

/-- Only a square block using its entire minimum palette can cost more
than one deletion per two private vertices. -/
theorem double_loss_le_private {n a b : ℕ} (ha : 2 ≤ a) (hab : a ≤ b)
    (feasible : b*(a+1) ≤ n) (nonsquare : n ≠ a*(a+1)) :
    2*loss n a b ≤ privateVertices a b := by
  let r := n-b*(a+1)
  have eqn : n=b*(a+1)+r := by dsimp [r]; omega
  have alternative : a<b ∨ 0<r := by
    by_contra! h
    have e : a=b := by omega
    subst b
    exact nonsquare (by omega)
  rw [eqn, loss_with_slack]
  unfold privateVertices
  omega

theorem sum_double_loss_le_private {I : Type*} [Fintype I]
    (n : ℕ) (a b : I → ℕ) (ha : ∀ i, 2 ≤ a i) (hab : ∀ i, a i ≤ b i)
    (hf : ∀ i, b i*(a i+1) ≤ n) (hn : ∀ i, n ≠ a i*(a i+1)) :
    2*(∑ i, loss n (a i) (b i)) ≤ ∑ i, privateVertices (a i) (b i) := by
  rw [Finset.mul_sum]
  exact Finset.sum_le_sum (fun i _ => double_loss_le_private (ha i) (hab i) (hf i) (hn i))

/-- On a square-palette order, a block with positive loss needs at least
2s-1 private vertices, even when the two parts of that block are unequal. -/
theorem dense_block_private {s a b : ℕ} (hs : 2 ≤ s)
    (dense : s*(s+1) < a*b+a+b) :
    2*s-1 ≤ privateVertices a b := by
  unfold privateVertices
  by_contra! h
  have hsum : a+b+2 ≤ 2*s+1 := by omega
  have hp := Nat.pow_le_pow_left hsum 2
  zify at dense hp
  nlinarith [sq_nonneg ((a:ℤ)-(b:ℤ))]

theorem square_loss_le_side {s a b : ℕ} (hab : a ≤ b)
    (feasible : b*(a+1) ≤ s*(s+1)) : loss (s*(s+1)) a b ≤ s := by
  have hs : a ≤ s := by
    by_contra! h
    have h₁ : (s+1)*(s+2) ≤ a*(a+1) :=
      Nat.mul_le_mul (by omega) (by omega)
    have h₂ : a*(a+1) ≤ b*(a+1) := Nat.mul_le_mul_right (a+1) hab
    nlinarith
  let r := s*(s+1)-b*(a+1)
  have eqn : s*(s+1)=b*(a+1)+r := by dsimp [r]; omega
  rw [eqn, loss_with_slack]
  omega

/-- Exact integer rounding recipe for the initial range of the all-orders proof. -/
def roundingFeasible (n : ℕ) : Bool :=
  let L := ((List.range (n+1)).find? fun L => 4*n ≤ L*L).getD n
  let p := L/2
  let q := L-p
  let j := ((List.range (p+1)).find? fun j => (p-j)*(q+j) ≤ n).getD p
  let s := p-j-1
  let t := q+j
  let h := (n-2)/L
  decide (2 ≤ s ∧ s ≤ t ∧ t*(s+1) ≤ n ∧ n-t*(s+1)<s ∧
    1 ≤ h ∧ 2+h*(s+t-1) ≤ n ∧ 1+h*(s+t) ≤ n ∧ s+t+1=L)

set_option maxRecDepth 8192 in
set_option maxHeartbeats 2000000 in
theorem initial_rounding_feasible : ∀ i : Fin 144, roundingFeasible (112+i.val)=true := by
  decide +kernel

theorem rounding_fails_at_111 : roundingFeasible 111 = false := by decide +kernel

end Erdos810.BouquetPacking
