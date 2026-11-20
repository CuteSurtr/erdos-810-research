import Mathlib.Combinatorics.SimpleGraph.Basic
import BouquetPacking

/-! # Disjoint edges sharing four-cycles

The nonisolated vertices of a simple graph form a complete multipartite graph
exactly when every two vertex-disjoint edges lie on a four-cycle.
-/

set_option autoImplicit false

namespace Erdos810.MultipartiteSquares

variable {V : Type*} (G : SimpleGraph V)

abbrev Active := {v : V // ∃ w, G.Adj v w}

/-- The two ways to complete a matching of size two to a square. -/
def CompletePair (a b c d : V) : Prop :=
  (G.Adj a c ∧ G.Adj b d) ∨ (G.Adj a d ∧ G.Adj b c)

def DisjointOnSquare : Prop :=
  ∀ {a b c d : V}, G.Adj a b → G.Adj c d →
    a ≠ c → a ≠ d → b ≠ c → b ≠ d → CompletePair G a b c d

/-- For incident input edges one completion uses the input edges themselves. -/
theorem complete_all (h : DisjointOnSquare G) {a b c d : V}
    (ab : G.Adj a b) (cd : G.Adj c d) : CompletePair G a b c d := by
  by_cases hac : a = c
  · subst c
    exact Or.inr ⟨cd, ab.symm⟩
  by_cases had : a = d
  · subst d
    exact Or.inl ⟨cd.symm, ab.symm⟩
  by_cases hbc : b = c
  · subst c
    exact Or.inl ⟨ab, cd⟩
  by_cases hbd : b = d
  · subst d
    exact Or.inr ⟨ab, cd.symm⟩
  exact h ab cd hac had hbc hbd

theorem multipartite_iff : DisjointOnSquare G ↔
    Equivalence (fun (u v : Active G) ↦ ¬G.Adj u.1 v.1) := by
  constructor
  · intro h
    refine ⟨fun u ↦ G.loopless u.1, fun h₁ h₂ ↦ h₁ h₂.symm, ?_⟩
    intro u v w huv hvw huw
    obtain ⟨y, hvy⟩ := v.property
    rcases complete_all G h huw hvy with ⟨huv', _⟩ | ⟨_, hwv⟩
    · exact huv huv'
    · exact hvw hwv.symm
  · intro h a b c d ab cd _ _ _ _
    let u : Active G := ⟨a, b, ab⟩
    let v : Active G := ⟨b, a, ab.symm⟩
    let w : Active G := ⟨c, d, cd⟩
    let x : Active G := ⟨d, c, cd.symm⟩
    let r (i j : Active G) := ¬G.Adj i.1 j.1
    have hab : ¬r u v := fun H ↦ H ab
    have hcd : ¬r w x := fun H ↦ H cd
    by_cases ac : r u w
    · right
      exact ⟨Classical.byContradiction (fun ad ↦ hcd (h.trans (h.symm ac) ad)),
        Classical.byContradiction (fun bc ↦ hab (h.trans ac (h.symm bc)))⟩
    by_cases bd : r v x
    · right
      exact ⟨Classical.byContradiction (fun ad ↦ hab (h.trans ad (h.symm bd))),
        Classical.byContradiction (fun bc ↦ hcd (h.trans (h.symm bc) bd))⟩
    exact Or.inl ⟨Classical.byContradiction ac, Classical.byContradiction bd⟩

/-- A repeated-color wedge has no common neighbor of its ends except its center.
In a complete multipartite graph this puts every other vertex in an end part. -/
theorem wedge_parts {P : Type*} (part : V → P) {x y z : V}
    (sole : ∀ w, part w ≠ part y → part w ≠ part z → w = x) (v : V) :
    v = x ∨ part v = part y ∨ part v = part z := by
  by_cases hy : part v = part y
  · exact Or.inr (Or.inl hy)
  by_cases hz : part v = part z
  · exact Or.inr (Or.inr hz)
  exact Or.inl (sole v hy hz)

open Erdos810.BouquetPacking

/-- An independent dense component costs at least two vertices per forced deletion,
plus one vertex for the component. -/
theorem disjoint_vertex_cost {n a b : ℕ} (ordered : a ≤ b) (feasible : b*(a+1) ≤ n) :
    2*loss n a b+1 ≤ 1+a+b := by
  let r := n-b*(a+1)
  have eqn : n=b*(a+1)+r := by dsimp [r]; omega
  rw [eqn, loss_with_slack]
  omega

theorem total_disjoint_vertex_cost {I : Type*} [Fintype I]
    (n : ℕ) (a b : I → ℕ) (ordered : ∀ i, a i ≤ b i)
    (feasible : ∀ i, b i*(a i+1) ≤ n) :
    2*(∑ i, loss n (a i) (b i)) + Fintype.card I ≤ ∑ i, (1+a i+b i) := by
  calc
    _ = ∑ i, (2*loss n (a i) (b i)+1) := by simp [Finset.sum_add_distrib, Finset.mul_sum]
    _ ≤ _ := Finset.sum_le_sum fun i _ ↦ disjoint_vertex_cost (ordered i) (feasible i)

/-- Increasing the longer side to its largest feasible value maximizes the edge count. -/
theorem fixed_short_side {n s t : ℕ} (feasible : t*(s+1) ≤ n) :
    s*t+s+t ≤ n/(s+1)*(s+1)+s := by
  have bound : t ≤ n/(s+1) := (Nat.le_div_iff_mul_le (by omega)).mpr feasible
  have prod := Nat.mul_le_mul_right (s+1) bound
  simpa [Nat.mul_add, Nat.mul_comm s t, Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using
    Nat.add_le_add_right prod s

theorem remainder_formula (n s : ℕ) :
    n/(s+1)*(s+1)+s+n%(s+1) = n+s := by
  have partition := Nat.mod_add_div n (s+1)
  rw [Nat.mul_comm (s+1)] at partition
  omega

end Erdos810.MultipartiteSquares
