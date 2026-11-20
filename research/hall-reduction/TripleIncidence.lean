import CensusLower
import Mathlib.Algebra.Order.Chebyshev

/-! # Incidences at the three points of a (7,4)-free triple -/

set_option autoImplicit false
namespace Erdos810
namespace TripleIncidence

variable {ι α : Type*} [DecidableEq ι] [DecidableEq α]

/-- In a graph in which three edges always span five vertices, a pair of
touching edges uses three vertices that no further edge can touch. -/
private theorem pair_packing (I : Finset ι) (V : Finset α) (f : ι → Finset α)
    (inside : ∀ i ∈ I, f i ⊆ V) (size : ∀ i ∈ I, (f i).card = 2)
    (two : ∀ i ∈ I, ∀ j ∈ I, i ≠ j → 3 ≤ (f i ∪ f j).card)
    (three : ∀ i ∈ I, ∀ j ∈ I, ∀ k ∈ I, i ≠ j → i ≠ k → j ≠ k →
      5 ≤ (f i ∪ f j ∪ f k).card) : 3 * I.card ≤ 2 * V.card := by
  classical
  by_cases meet : ∃ i ∈ I, ∃ j ∈ I, i ≠ j ∧ (f i ∪ f j).card ≤ 3
  · obtain ⟨i, hi, j, hj, ij, h⟩ := meet
    let U := f i ∪ f j
    have u : U.card = 3 := le_antisymm h (two i hi j hj ij)
    have sub : U ⊆ V := Finset.union_subset (inside i hi) (inside j hj)
    let R := (I.erase i).erase j
    have mem {k} (hk : k ∈ R) : k ∈ I ∧ i ≠ k ∧ j ≠ k := by
      obtain ⟨kj, ki, kI⟩ := (show k ≠ j ∧ k ≠ i ∧ k ∈ I by simpa [R] using hk)
      exact ⟨kI, ki.symm, kj.symm⟩
    have rin : ∀ k ∈ R, f k ⊆ V \ U := by
      intro k hk
      obtain ⟨kI, ik, jk⟩ := mem hk
      have large := three i hi j hj k kI ij ik jk
      have card := Finset.card_union_add_card_inter U (f k)
      change 5 ≤ (U ∪ f k).card at large
      have dj : Disjoint U (f k) := Finset.disjoint_iff_inter_eq_empty.mpr
        (Finset.card_eq_zero.mp (by have := size k kI; omega))
      exact fun x hx ↦ Finset.mem_sdiff.mpr ⟨inside k kI hx, fun hU ↦ Finset.disjoint_left.mp dj hU hx⟩
    have rc : R.card + 2 = I.card := by
      dsimp [R]
      rw [Finset.card_erase_of_mem (Finset.mem_erase.mpr ⟨ij.symm,hj⟩),Finset.card_erase_of_mem hi]
      have t := Finset.card_pos.mpr ⟨j,Finset.mem_erase.mpr ⟨ij.symm,hj⟩⟩
      rw [Finset.card_erase_of_mem hi] at t
      omega
    have remainder := pair_packing R (V \ U) f rin (fun k hk ↦ size k (mem hk).1)
      (fun k hk l hl ↦ two k (mem hk).1 l (mem hl).1)
      (fun k hk l hl m hm ↦ three k (mem hk).1 l (mem hl).1 m (mem hm).1)
    rw [Finset.card_sdiff_of_subset sub, u] at remainder
    have := Finset.card_le_card sub
    omega
  · have dj : I.toSet.PairwiseDisjoint f := by
      intro i hi j hj ij
      have big : 4 ≤ (f i ∪ f j).card := by
        by_contra! small
        exact meet ⟨i,hi,j,hj,ij,by omega⟩
      have eq := Finset.card_union_add_card_inter (f i) (f j)
      rw [size i hi,size j hj] at eq
      exact Finset.disjoint_iff_inter_eq_empty.mpr (Finset.card_eq_zero.mp (by omega))
    have sub : I.biUnion f ⊆ V := Finset.biUnion_subset_iff_forall_subset.mpr inside
    have hc := Finset.card_le_card sub
    rw [Finset.card_biUnion dj,Finset.sum_const_nat (m := 2) size] at hc
    omega
termination_by I.card
decreasing_by exact lt_of_le_of_lt Finset.card_erase_le (Finset.card_erase_lt_of_mem hi)

/-- A singleton footprint comes from a triple sharing two points with the
fixed triple. In that case the other footprints must all be disjoint pairs. -/
private theorem footprint_packing (I : Finset ι) (V : Finset α) (f : ι → Finset α)
    (room : 9 ≤ V.card) (inside : ∀ i ∈ I, f i ⊆ V)
    (size : ∀ i ∈ I, 1 ≤ (f i).card ∧ (f i).card ≤ 2)
    (three : ∀ i ∈ I, ∀ j ∈ I, ∀ k ∈ I, i ≠ j → i ≠ k → j ≠ k →
      5 ≤ (f i ∪ f j ∪ f k).card) :
    3 * (∑ i ∈ I, (3 - (f i).card)) ≤ 2 * V.card := by
  classical
  by_cases few : I.card ≤ 2
  · have h := Finset.sum_le_sum (s := I) (g := fun _ ↦ (2:ℕ))
        (fun i hi ↦ show 3 - (f i).card ≤ 2 by have := size i hi; omega)
    simp at h
    omega
  have two (i) (hi : i ∈ I) (j) (hj : j ∈ I) (ij : i ≠ j) : 3 ≤ (f i ∪ f j).card := by
    obtain ⟨k, hk, kj⟩ := (I.erase i).exists_mem_ne (by rw [Finset.card_erase_of_mem hi]; omega) j
    obtain ⟨ki,kI⟩ := Finset.mem_erase.mp hk
    have := three i hi j hj k kI ij ki.symm kj.symm
    have := Finset.card_union_le (f i ∪ f j) (f k)
    have := size k kI
    omega
  by_cases single : ∃ i ∈ I, (f i).card = 1
  · obtain ⟨i,hi,one⟩ := single
    have pairs (j) (hj : j ∈ I.erase i) : (f j).card = 2 := by
      obtain ⟨ji,jI⟩ := Finset.mem_erase.mp hj
      have := two i hi j jI ji.symm
      have := Finset.card_union_le (f i) (f j)
      have := size j jI
      omega
    have dj : I.toSet.PairwiseDisjoint f := by
      intro j hj k hk jk
      have hu := Finset.card_union_add_card_inter (f j) (f k)
      apply Finset.disjoint_iff_inter_eq_empty.mpr
      apply Finset.card_eq_zero.mp
      have sj := size j hj
      have sk := size k hk
      have low := two j hj k hk jk
      by_cases ji : j = i
      · subst j; omega
      by_cases ki : k = i
      · subst k; omega
      have := three j hj k hk i hi jk ji ki
      have := Finset.card_union_le (f j ∪ f k) (f i)
      omega
    have cap := Finset.card_le_card (Finset.biUnion_subset_iff_forall_subset.mpr inside)
    rw [Finset.card_biUnion dj, ← Finset.sum_erase_add _ _ hi,
      Finset.sum_const_nat (m := 2) pairs, one] at cap
    rw [← Finset.sum_erase_add _ _ hi, one, Finset.sum_const_nat (m := 1)
      (fun j hj ↦ by rw [pairs j hj])]
    omega
  · have pairs (i) (hi : i ∈ I) : (f i).card = 2 := by
      have := size i hi
      have : (f i).card ≠ 1 := fun h ↦ single ⟨i,hi,h⟩
      omega
    rw [Finset.sum_const_nat (m := 1) (fun i hi ↦ by rw [pairs i hi]), Nat.mul_one]
    exact pair_packing I V f inside pairs two three

variable {n : ℕ} {H : Finset (Finset (Fin n))}

def degree (H : Finset (Finset (Fin n))) (x : Fin n) : ℕ :=
  (H.filter (fun t ↦ x ∈ t)).card

private theorem sum_degrees (S : Finset (Fin n)) :
    ∑ x ∈ S, degree H x = ∑ t ∈ H, (S ∩ t).card := by
  have h := Finset.sum_card_bipartiteAbove_eq_sum_card_bipartiteBelow (s := S) (t := H)
    (fun (x : Fin n) (t : Finset (Fin n)) ↦ x ∈ t)
  exact h.trans (Finset.sum_congr rfl (fun t _ ↦ congrArg Finset.card (by ext x; simp)))

/-- At a triple the sum of its three vertex degrees is at most 1 + floor(2n/3). -/
theorem degree_sum_on_triple (hn : 12 ≤ n) (uniform : ∀ t ∈ H, t.card = 3)
    (hf : SevenFourFree H) {e : Finset (Fin n)} (he : e ∈ H) :
    ∑ x ∈ e, degree H x ≤ 1 + 2*n/3 := by
  classical
  let V := Finset.univ \ e
  let I := (H.erase e).filter (fun t ↦ (e ∩ t).Nonempty)
  let f := fun t : Finset (Fin n) ↦ t \ e
  have ec := uniform e he
  have vc : V.card = n-3 := by simp [V, Finset.card_sdiff_of_subset, ec]
  have mem {t} (ht : t ∈ I) : t ≠ e ∧ t ∈ H ∧ (e ∩ t).Nonempty := by
    simpa [I, and_assoc] using ht
  have inside (t) (_ : t ∈ I) : f t ⊆ V := fun _ hx ↦
    Finset.mem_sdiff.mpr ⟨Finset.mem_univ _,(Finset.mem_sdiff.mp hx).2⟩
  have parts (t) (ht : t ∈ I) : (f t).card + (e ∩ t).card = 3 := by
    simpa only [f, Finset.inter_comm e t, uniform t (mem ht).2.1] using
      Finset.card_sdiff_add_card_inter t e
  have size (t) (ht : t ∈ I) : 1 ≤ (f t).card ∧ (f t).card ≤ 2 := by
    have pos := Finset.card_pos.mpr (mem ht).2.2
    have neq : (f t).Nonempty := by
      by_contra! empty
      have sub : t ⊆ e := Finset.sdiff_eq_empty_iff_subset.mp (Finset.not_nonempty_iff_eq_empty.mp empty)
      exact (mem ht).1 (Finset.eq_of_subset_of_card_le sub (by rw [ec,uniform t (mem ht).2.1]))
    have := Finset.card_pos.mpr neq
    have := parts t ht
    omega
  have three (a) (ha : a ∈ I) (b) (hb : b ∈ I) (c) (hc : c ∈ I)
      (ab : a ≠ b) (ac : a ≠ c) (bc : b ≠ c) : 5 ≤ (f a ∪ f b ∪ f c).card := by
    by_contra! small
    let U := e ∪ (f a ∪ f b ∪ f c)
    have usmall : U.card ≤ 7 := (Finset.card_union_le e (f a ∪ f b ∪ f c)).trans (by omega)
    have extend (t : Finset (Fin n)) (h : f t ⊆ f a ∪ f b ∪ f c) : t ⊆ U := by
      intro x hx
      by_cases hxe : x ∈ e
      · exact Finset.mem_union_left _ hxe
      · exact Finset.mem_union_right _ (h (Finset.mem_sdiff.mpr ⟨hx,hxe⟩))
    have included : ({e,a,b,c} : Finset _) ⊆ H.filter (fun t ↦ t ⊆ U) := by
      simp only [Finset.insert_subset_iff,Finset.singleton_subset_iff,Finset.mem_filter]
      exact ⟨⟨he,Finset.subset_union_left⟩,⟨(mem ha).2.1,extend a (Finset.subset_union_left.trans
          Finset.subset_union_left)⟩,⟨(mem hb).2.1,extend b (Finset.subset_union_right.trans
          Finset.subset_union_left)⟩,⟨(mem hc).2.1,extend c Finset.subset_union_right⟩⟩
    have four : ({e,a,b,c} : Finset _).card = 4 := by
      simp [(mem ha).1.symm,(mem hb).1.symm,(mem hc).1.symm,ab,ac,bc]
    have := Finset.card_le_card included
    have := hf.card_filter_lt_four (by omega) U usmall
    omega
  have bound := footprint_packing I V f (by omega) inside size three
  have eq : ∑ t ∈ I, (3 - (f t).card) = ∑ t ∈ H.erase e, (e ∩ t).card := by
    calc
      _ = ∑ t ∈ I, (e ∩ t).card := Finset.sum_congr rfl (fun t ht ↦ by have := parts t ht; omega)
      _ = _ := by
        apply Finset.sum_subset (Finset.filter_subset ..)
        intro t ht out
        apply Finset.card_eq_zero.mpr
        exact Finset.not_nonempty_iff_eq_empty.mp (fun h ↦ out (Finset.mem_filter.mpr ⟨ht,h⟩))
  rw [eq, vc] at bound
  rw [sum_degrees, ← Finset.sum_erase_add _ _ he, Finset.inter_self, ec]
  omega

private theorem squared_degrees :
    (∑ t ∈ H, ∑ x ∈ t, degree H x) = ∑ x, degree H x ^ 2 := by
  classical
  calc
    _ = ∑ t ∈ H, ∑ x : Fin n, if x ∈ t then degree H x else 0 := by
      apply Finset.sum_congr rfl
      intro t _
      rw [← Finset.sum_filter]
      simp
    _ = _ := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro x _
      rw [← Finset.sum_filter]
      simp [degree,pow_two]

theorem sevenFourNumber_incidence_bound (n : ℕ) (hn : 12 ≤ n) :
    9 * sevenFourNumber n ≤ n * (1 + 2*n/3) := by
  classical
  obtain ⟨H,card,uniform,hf⟩ := exists_extremal_sevenFourNumber n
  let m := H.card
  let D := 1 + 2*n/3
  have total : ∑ x, degree H x = 3*m := by
    rw [sum_degrees]
    simp only [Finset.univ_inter]
    rw [Finset.sum_const_nat uniform, Nat.mul_comm]
  have squares : (∑ x, degree H x ^ 2) ≤ m*D := by
    rw [← squared_degrees]
    exact (Finset.sum_le_sum (fun t ht ↦ degree_sum_on_triple hn uniform hf ht)).trans_eq
      (Finset.sum_const_nat (fun _ _ ↦ rfl))
  have cauchy := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := degree H)
  rw [total,Finset.card_univ,Fintype.card_fin] at cauchy
  rw [← card]
  change 9*m ≤ n*D
  by_cases h : m = 0
  · simp [h]
  apply Nat.le_of_mul_le_mul_right _ (Nat.pos_of_ne_zero h)
  nlinarith only [cauchy,Nat.mul_le_mul_left n squares]

theorem sevenFourNumber_thirteen : sevenFourNumber 13 = 13 := by
  have upper := sevenFourNumber_incidence_bound 13 (by decide)
  have lower := triple_lower_bound_13
  omega

theorem sevenFourNumber_fourteen : sevenFourNumber 14 = 15 := by
  have upper := sevenFourNumber_incidence_bound 14 (by decide)
  have lower := triple_lower_bound_14
  omega

theorem sevenFourNumber_fifteen : sevenFourNumber 15 = 18 := by
  have upper := sevenFourNumber_incidence_bound 15 (by decide)
  have lower := triple_lower_bound_15
  omega

end TripleIncidence
end Erdos810

#assert_no_sorry Erdos810.TripleIncidence.sevenFourNumber_incidence_bound
  Erdos810.TripleIncidence.sevenFourNumber_thirteen
  Erdos810.TripleIncidence.sevenFourNumber_fourteen
  Erdos810.TripleIncidence.sevenFourNumber_fifteen
