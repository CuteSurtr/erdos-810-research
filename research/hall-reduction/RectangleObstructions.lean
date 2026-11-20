import ThinRectangle

/-! # Finite obstructions to homogeneous and nearly complete neighborhoods -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810
variable {V K : Type*} [Fintype V] [Fintype K] {G : SimpleGraph V}

/-- Every rectangle contains a square of order at least e/q whose density is at
most 1/2+1/(2k). The two sides may overlap in the underlying undirected graph. -/
theorem exists_sparse_square [Nonempty K] (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (L R : Finset V) :
    ∃ A ⊆ L, ∃ B ⊆ R, A.card=B.card ∧ (rectangle G L R).card≤Fintype.card K*A.card ∧
      2*(rectangle G A B).card≤A.card*(A.card+1) := by
  classical
  let k (c : K) := (rectClass C L R c).card
  obtain ⟨c,_,greatest⟩ := Finset.exists_max_image (Finset.univ : Finset K) k Finset.univ_nonempty
  have total := Finset.sum_le_sum (s := (Finset.univ : Finset K)) (fun j hj ↦ greatest j hj)
  change (∑ j,(rectClass C L R j).card)≤∑ _ : K,k c at total
  rw [rectClass_sum,Finset.sum_const,Finset.card_univ,smul_eq_mul] at total
  obtain ⟨left,right⟩ := matched_subsets C L R c
  obtain ⟨lc,rc⟩ := matched_cards C hp L R c
  exact ⟨_,left,_,right,lc.trans rc.symm,lc ▸ total,lc ▸ matched_rectangle_internal C hp hr L R c⟩

/-- The sum of the excess degrees into B over the threshold 2qb/(2q+b)
is at most qb/(2q+b), expressed without divisions. -/
theorem rectangle_excess [DecidableRel G.Adj] (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (B : Finset V) :
    (∑ x : V, ((2*Fintype.card K+B.card)*(B.filter (G.Adj x)).card-2*Fintype.card K*B.card))
      ≤ Fintype.card K*B.card := by
  classical
  let q := Fintype.card K
  let b := B.card
  let d (x : V) := (B.filter (G.Adj x)).card
  let A := Finset.univ.filter (fun x : V ↦ 2*q*b≤(2*q+b)*d x)
  have raw := thin_rectangle C hp hr B A
  rw [rectangle_transpose G B A,← sum_rectangle_rows] at raw
  change (2*q+b)*(∑ x∈A,d x)≤b*q*(2*A.card+1) at raw
  have split : (∑ x : V, ((2*q+b)*d x-2*q*b))=∑ x∈A, ((2*q+b)*d x-2*q*b) := by
    apply (Finset.sum_subset (Finset.subset_univ A) _).symm
    intro x _ hx
    have bad : ¬2*q*b≤(2*q+b)*d x := by simpa [A] using hx
    omega
  change (∑ x : V, ((2*q+b)*d x-2*q*b))≤q*b
  rw [split]
  have eq := Finset.sum_congr (s₁ := A) rfl (fun x hx ↦
    Nat.sub_add_cancel (show 2*q*b≤(2*q+b)*d x from (Finset.mem_filter.mp hx).2))
  rw [Finset.sum_add_distrib,Finset.sum_const,smul_eq_mul,← Finset.mul_sum] at eq
  nlinarith only [raw,eq]

end Erdos810
#assert_no_sorry Erdos810.exists_sparse_square Erdos810.rectangle_excess
