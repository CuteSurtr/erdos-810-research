import SmallTripleNumbers
import IsolatedBlocks

/-! # A recurrence for nonlinear triple systems from packing the outside pairs -/

set_option autoImplicit false
namespace Erdos810
variable {n : ℕ} {H : Finset (Finset (Fin n))}

namespace OrdinaryDiamond
variable (D : OrdinaryDiamond H)

private def touching := H.filter (fun t ↦ ¬t ⊆ D.supportᶜ)
private def crossing := D.touching \ D.sides

private theorem side_touches : D.sides ⊆ D.touching := by
  intro t ht
  refine Finset.mem_filter.mpr ⟨D.sides_subset ht,?_⟩
  intro h
  have nonempty : t.Nonempty := Finset.card_pos.mp (by
    rcases (by simpa only [sides,Finset.mem_insert,Finset.mem_singleton] using ht :
      t=diamondLeft.map D.point ∨ t=diamondRight.map D.point) with rfl|rfl <;>
      simp [diamondLeft,diamondRight])
  obtain ⟨x,hx⟩ := nonempty
  exact (Finset.mem_compl.mp (h hx)) (D.subset_of_mem_sides ht hx)

private theorem outside_pair (hthree : ∀ t ∈ H, t.card=3) {t : Finset (Fin n)} (ht : t ∈ D.crossing) :
    (t \ D.support).card=2 := by
  obtain ⟨touch,external⟩ := Finset.mem_sdiff.mp ht
  obtain ⟨mem,meet⟩ := Finset.mem_filter.mp touch
  have side : t≠diamondLeft.map D.point ∧ t≠diamondRight.map D.point := by simpa [sides] using external
  have one := D.external t mem side.1 side.2
  change (t ∩ D.support).card ≤ 1 at one
  have pos : 0<(t ∩ D.support).card := by
    apply Finset.card_pos.mpr
    by_contra bad
    apply meet
    intro x hx
    exact Finset.mem_compl.mpr (fun e ↦ bad ⟨x,Finset.mem_inter.mpr ⟨hx,e⟩⟩)
  have total := Finset.card_sdiff_add_card_inter t D.support
  rw [hthree t mem] at total
  omega

private theorem outside_disjoint (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card=3) :
    (D.crossing : Set (Finset (Fin n))).PairwiseDisjoint (fun t ↦ t \ D.support) := by
  intro t ht s hs ts
  apply Finset.disjoint_left.mpr
  intro x hxt hxs
  let A := t \ D.support
  let B := s \ D.support
  let U := D.support ∪ (A ∪ B)
  have ap : 0 < (A ∩ B).card := Finset.card_pos.mpr ⟨x,Finset.mem_inter.mpr ⟨hxt,hxs⟩⟩
  have pairs := Finset.card_union_add_card_inter A B
  have atwo : A.card=2 := D.outside_pair hthree ht
  have btwo : B.card=2 := D.outside_pair hthree hs
  have maxU : U.card ≤ 7 := by
    have cap := Finset.card_union_le D.support (A ∪ B)
    rw [D.card_support] at cap
    change (D.support ∪ (A ∪ B)).card ≤ 7
    omega
  obtain ⟨tm,tn⟩ := Finset.mem_sdiff.mp ht
  obtain ⟨sm,sn⟩ := Finset.mem_sdiff.mp hs
  have tu : t ⊆ U := by
    intro z hz
    by_cases d : z ∈ D.support
    · exact Finset.mem_union_left _ d
    · exact Finset.mem_union_right _ (Finset.mem_union_left _ (Finset.mem_sdiff.mpr ⟨hz,d⟩))
  have su : s ⊆ U := by
    intro z hz
    by_cases d : z ∈ D.support
    · exact Finset.mem_union_left _ d
    · exact Finset.mem_union_right _ (Finset.mem_union_right _ (Finset.mem_sdiff.mpr ⟨hz,d⟩))
  have inc : insert t (insert s D.sides) ⊆ H.filter (fun e ↦ e ⊆ U) := by
    intro e he
    rcases Finset.mem_insert.mp he with rfl|h
    · exact Finset.mem_filter.mpr ⟨(Finset.mem_filter.mp tm).1,tu⟩
    rcases Finset.mem_insert.mp h with rfl|h
    · exact Finset.mem_filter.mpr ⟨(Finset.mem_filter.mp sm).1,su⟩
    exact Finset.mem_filter.mpr ⟨D.sides_subset h,(D.subset_of_mem_sides h).trans Finset.subset_union_left⟩
  have cnt := Finset.card_le_card inc
  rw [Finset.card_insert_of_notMem (by simpa [ts] using tn),Finset.card_insert_of_notMem sn,D.card_sides] at cnt
  exact (hf.card_filter_lt_four hn U maxU).not_ge cnt

include D in
/-- Deleting the four diamond vertices removes its two sides and at most (n−4)/2 other triples. -/
theorem packing_bound (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card=3) :
    H.card ≤ sevenFourNumber (n-4)+2+(n-4)/2 := by
  classical
  have comp : D.supportᶜ.card=n-4 := by simp [Finset.card_compl,D.card_support]
  have rest := hf.card_restriction_le hthree _ comp
  have packed : D.crossing.biUnion (fun t ↦ t \ D.support) ⊆ D.supportᶜ := by
    intro x hx
    obtain ⟨_,_,h⟩ := Finset.mem_biUnion.mp hx
    exact Finset.mem_compl.mpr (Finset.mem_sdiff.mp h).2
  have cnt := Finset.card_le_card packed
  rw [Finset.card_biUnion (D.outside_disjoint hn hf hthree),comp] at cnt
  have pairs : (∑ i ∈ D.crossing, (i \ D.support).card)=D.crossing.card*2 :=
    Finset.sum_const_nat (fun i hi ↦ D.outside_pair hthree hi)
  rw [pairs] at cnt
  have split := Finset.filter_card_add_filter_neg_card_eq_card (fun t ↦ t ⊆ D.supportᶜ) (s := H)
  change _+D.touching.card=H.card at split
  have touched : D.crossing.card=D.touching.card-2 := by
    rw [crossing,Finset.card_sdiff_of_subset D.side_touches,D.card_sides]
  omega

end OrdinaryDiamond

theorem IsolatedBlock.packing_bound (B : IsolatedBlock H) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card=3) :
    H.card ≤ 3+sevenFourNumber (n-5) := by
  have comp : B.supportᶜ.card=n-5 := by simp [Finset.card_compl,B.five]
  have remained := hf.card_restriction_le hthree _ comp
  have inc : H \ B.triples ⊆ H.filter (fun t ↦ t ⊆ B.supportᶜ) := by
    intro t ht
    exact Finset.mem_filter.mpr ⟨(Finset.mem_sdiff.mp ht).1,
      fun x hx ↦ Finset.mem_compl.mpr (Finset.disjoint_left.mp (B.isolated t ht) hx)⟩
  have small := (Finset.card_le_card inc).trans remained
  rw [Finset.card_sdiff_of_subset B.subset,B.three] at small
  omega

/-- Above this explicit threshold the entire triple family must be linear. -/
theorem linear_of_above_packing_threshold (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card=3)
    (block : 3+sevenFourNumber (n-5)<H.card) (diamond : sevenFourNumber (n-4)+2+(n-4)/2<H.card) :
    ∀ t ∈ H, IsLinearMember H t := by
  intro t ht s hs ne
  by_contra! overlap
  by_cases free : ThreeOnFiveFree H
  · obtain ⟨D,_,_⟩ := ordinary_of_overlap hthree free ht hs (Ne.symm ne) overlap
    exact diamond.not_ge (D.packing_bound hn hf hthree)
  · obtain ⟨B⟩ := exists_isolated_block hn hf hthree (threeOnFourFree_of_four_members hn hf hthree (by omega)) free
    exact block.not_ge (B.packing_bound hf hthree)

/-- In this range the full shadow gives three edges per triple on the original vertex set. -/
theorem same_order_of_above_packing_threshold (hn : 7 ≤ n) (hf : SevenFourFree H) (hthree : ∀ t ∈ H, t.card=3)
    (block : 3+sevenFourNumber (n-5)<H.card) (diamond : sevenFourNumber (n-4)+2+(n-4)/2<H.card) :
    3*H.card ≤ maxRainbowC4Edges n := by
  have lin := linear_of_above_packing_threshold hn hf hthree block diamond
  exact three_per_linear_triple hn hf hthree lin

end Erdos810
#assert_no_sorry Erdos810.OrdinaryDiamond.packing_bound Erdos810.linear_of_above_packing_threshold
  Erdos810.same_order_of_above_packing_threshold
