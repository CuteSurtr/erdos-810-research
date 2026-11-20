import MatchingRectangle

/-! # A one-sided bound on a rectangle, including thin rectangles -/

set_option autoImplicit false
open SimpleGraph
namespace Erdos810

theorem rectangle_transpose {V : Type*} [Fintype V] (G : SimpleGraph V) (L R : Finset V) :
    (rectangle G L R).card = (rectangle G R L).card := by
  classical
  rw [← sum_rectangle_rows,← sum_rectangle_cols]

/-- With q colors, a rectangle of a rows and b columns has at most
qa(2b+1)/(2q+a) edges when the denominator is positive. -/
theorem thin_rectangle {V K : Type*} [Fintype V] [Fintype K] {G : SimpleGraph V}
    (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4))
    (L R : Finset V) :
    (2*Fintype.card K+L.card)*(rectangle G L R).card ≤ L.card*Fintype.card K*(2*R.card+1) := by
  classical
  let k := fun c ↦ (rectClass C L R c).card
  let X := fun c ↦ (rectangle G (matchedRows C L R c) (R \ matchedCols C L R c)).card
  let m := (rectangle G L R).card
  let q := Fintype.card K
  let total := ∑ c, (k c*(k c+1)+2*X c)
  let squares := ∑ c, (k c)^2
  have sk : (∑ c, k c) = m := rectClass_sum C L R
  have each (c : K) : (k c*(k c+1)+2*X c)+(k c)^2 ≤ (2*R.card+1)*k c := by
    obtain ⟨hA,hB⟩ := matched_cards C hp L R c
    have split := Finset.card_sdiff_add_card_eq_card (matched_subsets C L R c).2
    rw [hB] at split
    change (R \ matchedCols C L R c).card+k c=R.card at split
    have cap := rectangle_card_le_product (G := G) (matchedRows C L R c) (R \ matchedCols C L R c)
    rw [hA] at cap
    change X c ≤ k c*(R \ matchedCols C L R c).card at cap
    nlinarith only [cap,congrArg (fun a ↦ k c*a) split]
  have bound := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ each c)
  simp only [Finset.sum_add_distrib,← Finset.mul_sum,sk] at bound
  have plain : total+squares ≤ (2*R.card+1)*m := by
    simpa only [total,squares,Finset.sum_add_distrib,← Finset.mul_sum] using bound
  have row : 2*m^2 ≤ L.card*total := rectangle_row_energy C hp hr L R
  have cs := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := k)
  rw [sk,Finset.card_univ] at cs
  change m^2 ≤ q*squares at cs
  change (2*q+L.card)*m ≤ L.card*q*(2*R.card+1)
  by_cases hm : m=0
  · simp [hm]
  apply Nat.le_of_mul_le_mul_right _ (Nat.pos_of_ne_zero hm)
  nlinarith only [Nat.mul_le_mul_left q row,Nat.mul_le_mul_left L.card cs,
    Nat.mul_le_mul_left (L.card*q) plain]

end Erdos810
#assert_no_sorry Erdos810.thin_rectangle Erdos810.rectangle_transpose
