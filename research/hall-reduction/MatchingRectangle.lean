import RectangleBound

/-! # The color matching inside a bipartite rectangle -/

set_option autoImplicit false
open SimpleGraph

namespace Erdos810

variable {V K : Type*} [Fintype V] {G : SimpleGraph V}

noncomputable def rectClass (C : G.EdgeLabeling K) (L R : Finset V) (c : K) : Finset G.Dart := by
  classical exact (rectangle G L R).filter (fun d ↦ dartColor C d = c)

noncomputable def matchedRows (C : G.EdgeLabeling K) (L R : Finset V) (c : K) : Finset V := by
  classical exact (rectClass C L R c).image (fun d ↦ d.fst)

noncomputable def matchedCols (C : G.EdgeLabeling K) (L R : Finset V) (c : K) : Finset V := by
  classical exact (rectClass C L R c).image (fun d ↦ d.snd)

theorem matched_subsets (C : G.EdgeLabeling K) (L R : Finset V) (c : K) :
    matchedRows C L R c ⊆ L ∧ matchedCols C L R c ⊆ R := by
  classical
  constructor <;> rintro _ h <;> obtain ⟨d, hd, rfl⟩ := Finset.mem_image.mp h
  · exact ((mem_rectangle L R d).mp (Finset.mem_filter.mp hd).1).1
  · exact ((mem_rectangle L R d).mp (Finset.mem_filter.mp hd).1).2

theorem matched_cards (C : G.EdgeLabeling K) (hp : ProperAtVertices C) (L R : Finset V) (c : K) :
    (matchedRows C L R c).card = (rectClass C L R c).card ∧
    (matchedCols C L R c).card = (rectClass C L R c).card := by
  classical
  have labels : ∀ d ∈ rectClass C L R c, dartColor C d = c := fun _ hd ↦ (Finset.mem_filter.mp hd).2
  exact ⟨Finset.card_image_of_injOn (first_inj_color C hp c labels),
    Finset.card_image_of_injOn (second_inj_color C hp c labels)⟩

theorem sum_rectangle_cols [DecidableRel G.Adj] (L R : Finset V) :
    (∑ y ∈ R, (L.filter (G.Adj y)).card) = (rectangle G L R).card := by
  classical
  have maps : Set.MapsTo (fun d : G.Dart ↦ d.snd) (rectangle G L R) R :=
    fun d hd ↦ ((mem_rectangle L R d).mp hd).2
  rw [Finset.card_eq_sum_card_fiberwise maps]
  exact Finset.sum_congr rfl (fun y hy ↦ (rectangle_snd_card L R hy).symm)

theorem rectangle_card_le_product (L R : Finset V) : (rectangle G L R).card ≤ L.card*R.card := by
  classical
  rw [← sum_rectangle_rows]
  simpa using Finset.sum_le_sum (s := L) (fun x _ ↦ Finset.card_le_card (R.filter_subset (G.Adj x)))

theorem rectClass_sum [Fintype K] (C : G.EdgeLabeling K) (L R : Finset V) :
    ∑ c, (rectClass C L R c).card = (rectangle G L R).card := by
  classical
  exact (Finset.card_eq_sum_card_fiberwise (f := dartColor C) (s := rectangle G L R)
    (t := Finset.univ) (fun _ _ ↦ Finset.mem_univ _)).symm

private theorem class_endpoints_sum {M : Type*} [AddCommMonoid M] (C : G.EdgeLabeling K)
    (hp : ProperAtVertices C) (L R : Finset V) (c : K) (f g : V → M) :
    (∑ d ∈ rectClass C L R c, (f d.fst+g d.snd)) =
      (∑ x ∈ matchedRows C L R c, f x) + ∑ y ∈ matchedCols C L R c, g y := by
  classical
  have labels : ∀ d ∈ rectClass C L R c, dartColor C d = c := fun _ hd ↦ (Finset.mem_filter.mp hd).2
  rw [Finset.sum_add_distrib, matchedRows, matchedCols,
    Finset.sum_image (first_inj_color C hp c labels), Finset.sum_image (second_inj_color C hp c labels)]

/-- A matching of size k spans at most k(k+1)/2 entries in its rectangular submatrix. -/
theorem matched_rectangle_internal (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (L R : Finset V) (c : K) :
    2*(rectangle G (matchedRows C L R c) (matchedCols C L R c)).card ≤
      (rectClass C L R c).card*((rectClass C L R c).card+1) := by
  classical
  let T := rectClass C L R c
  let A := matchedRows C L R c
  let B := matchedCols C L R c
  let k := T.card
  obtain ⟨rsize,csize⟩ := matched_cards C hp L R c
  have rs : A.card = k := rsize
  have cs : B.card = k := csize
  have inside (d : G.Dart) (hd : d ∈ T) : d ∈ rectangle G A B :=
    (mem_rectangle A B d).mpr ⟨Finset.mem_image.mpr ⟨d,hd,rfl⟩,Finset.mem_image.mpr ⟨d,hd,rfl⟩⟩
  have each (d : G.Dart) (hd : d ∈ T) :
      (B.filter (G.Adj d.fst)).card + (A.filter (G.Adj d.snd)).card ≤ k+1 := by
    have lab : dartColor C d = c := (Finset.mem_filter.mp hd).2
    have sub : T ⊆ (rectangle G A B).filter (fun e ↦ dartColor C e = dartColor C d) :=
      fun e he ↦ Finset.mem_filter.mpr ⟨inside e he, ((Finset.mem_filter.mp he).2).trans lab.symm⟩
    have cnt := Finset.card_le_card sub
    have h := rectangle_endpoint C hp hr A B d
    rw [rs,cs] at h
    change k ≤ _ at cnt
    omega
  have tot := Finset.sum_le_sum each
  have eq := class_endpoints_sum C hp L R c (fun x ↦ (B.filter (G.Adj x)).card)
    (fun y ↦ (A.filter (G.Adj y)).card)
  change (∑ d ∈ T, _) = (∑ x ∈ A, _) + ∑ y ∈ B, _ at eq
  rw [sum_rectangle_rows, sum_rectangle_cols] at eq
  rw [eq, Finset.sum_const, smul_eq_mul] at tot
  simpa only [two_mul] using tot

private theorem rectangle_partition_right [DecidableEq V] (L R A : Finset V) (h : A ⊆ R) :
    (rectangle G L R).card = (rectangle G L A).card + (rectangle G L (R \ A)).card := by
  classical
  have eq : rectangle G L R = rectangle G L A ∪ rectangle G L (R \ A) := by
    ext d
    simp only [mem_rectangle, Finset.mem_union, Finset.mem_sdiff]
    by_cases hd : d.snd ∈ A <;> aesop
  rw [eq, Finset.card_union_of_disjoint]
  exact Finset.disjoint_left.mpr (fun d h₁ h₂ ↦ (Finset.mem_sdiff.mp ((mem_rectangle _ _ d).mp h₂).2).2
    ((mem_rectangle _ _ d).mp h₁).2)

private theorem rectangle_partition_left [DecidableEq V] (L R A : Finset V) (h : A ⊆ L) :
    (rectangle G L R).card = (rectangle G A R).card + (rectangle G (L \ A) R).card := by
  classical
  have eq : rectangle G L R = rectangle G A R ∪ rectangle G (L \ A) R := by
    ext d
    simp only [mem_rectangle, Finset.mem_union, Finset.mem_sdiff]
    by_cases hd : d.fst ∈ A <;> aesop
  rw [eq, Finset.card_union_of_disjoint]
  exact Finset.disjoint_left.mpr (fun d h₁ h₂ ↦ (Finset.mem_sdiff.mp ((mem_rectangle _ _ d).mp h₂).1).2
    ((mem_rectangle _ _ d).mp h₁).1)

/-- Counting degrees only at matched rows keeps the size of the row side in the bound. -/
theorem rectangle_row_energy [Fintype K] [DecidableEq V] (C : G.EdgeLabeling K) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (L R : Finset V) :
    2 * (rectangle G L R).card^2 ≤ L.card * ∑ c,
      ((rectClass C L R c).card * ((rectClass C L R c).card + 1) +
       2 * (rectangle G (matchedRows C L R c) (R \ matchedCols C L R c)).card) := by
  classical
  let E := rectangle G L R
  let row (x : V) := (R.filter (G.Adj x)).card
  obtain ⟨energy, cauchy⟩ := fiber_squares E L (fun d ↦ d.fst) row
    (fun d hd ↦ ((mem_rectangle _ _ d).mp hd).1) (fun x hx ↦ rectangle_fst_card L R hx)
  have each (c : K) :
      2 * (∑ d ∈ rectClass C L R c, row d.fst) ≤
      (rectClass C L R c).card * ((rectClass C L R c).card + 1) +
      2 * (rectangle G (matchedRows C L R c) (R \ matchedCols C L R c)).card := by
    let A := matchedRows C L R c
    let B := matchedCols C L R c
    have hb : B ⊆ R := (matched_subsets C L R c).2
    have split := class_endpoints_sum C hp L R c row (fun _ ↦ 0)
    simp only [add_zero, Finset.sum_const_zero] at split
    rw [split]
    change 2 * (∑ x ∈ A, (R.filter (G.Adj x)).card) ≤ _
    rw [sum_rectangle_rows, rectangle_partition_right A R B hb]
    have inside := matched_rectangle_internal C hp hr L R c
    change 2 * (rectangle G A B).card ≤ _ at inside
    change _ ≤ _ + 2 * (rectangle G A (R \ B)).card
    omega
  have total := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ each c)
  rw [← Finset.mul_sum] at total
  change 2 * (∑ c, ∑ d ∈ E.filter (fun e ↦ dartColor C e = c), row d.fst) ≤ _ at total
  rw [Finset.sum_fiberwise E (dartColor C) (fun d ↦ row d.fst), energy] at total
  change 2 * E.card^2 ≤ _
  nlinarith only [cauchy, Nat.mul_le_mul_left L.card total]

/-- Endpoint energy inside a rectangle, bounded by its two cuts for every color. -/
theorem rectangle_matching_energy [Fintype K] [DecidableEq V] (C : G.EdgeLabeling K)
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) (L R : Finset V) :
    (rectangle G L R).card^2*(L.card+R.card) ≤ L.card*R.card*(∑ c, (
      (rectClass C L R c).card*((rectClass C L R c).card+1) +
      (rectangle G (matchedRows C L R c) (R \ matchedCols C L R c)).card +
      (rectangle G (L \ matchedRows C L R c) (matchedCols C L R c)).card)) := by
  classical
  let E := rectangle G L R
  let row (x : V) := (R.filter (G.Adj x)).card
  let col (y : V) := (L.filter (G.Adj y)).card
  obtain ⟨s₁,h₁⟩ := fiber_squares E L (fun d ↦ d.fst) row
    (fun d hd ↦ ((mem_rectangle _ _ d).mp hd).1) (fun x hx ↦ rectangle_fst_card L R hx)
  obtain ⟨s₂,h₂⟩ := fiber_squares E R (fun d ↦ d.snd) col
    (fun d hd ↦ ((mem_rectangle _ _ d).mp hd).2) (fun y hy ↦ rectangle_snd_card L R hy)
  have each (c : K) :
      (∑ d ∈ rectClass C L R c, (row d.fst+col d.snd)) ≤
      (rectClass C L R c).card*((rectClass C L R c).card+1) +
      (rectangle G (matchedRows C L R c) (R \ matchedCols C L R c)).card +
      (rectangle G (L \ matchedRows C L R c) (matchedCols C L R c)).card := by
    let A := matchedRows C L R c
    let B := matchedCols C L R c
    obtain ⟨ha,hb⟩ := matched_subsets C L R c
    rw [class_endpoints_sum C hp L R c row col]
    change (∑ x ∈ A, (R.filter (G.Adj x)).card) + (∑ y ∈ B, (L.filter (G.Adj y)).card) ≤ _
    rw [sum_rectangle_rows, sum_rectangle_cols, rectangle_partition_right A R B hb, rectangle_partition_left L B A ha]
    have h := matched_rectangle_internal C hp hr L R c
    change 2*(rectangle G A B).card ≤ _ at h
    change _ ≤ _ + (rectangle G A (R \ B)).card + (rectangle G (L \ A) B).card
    omega
  have total := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ each c)
  change (∑ c, ∑ d ∈ E.filter (fun e ↦ dartColor C e = c), (row d.fst+col d.snd)) ≤ _ at total
  rw [Finset.sum_fiberwise E (dartColor C) (fun d ↦ row d.fst+col d.snd), Finset.sum_add_distrib, s₁,s₂] at total
  change E.card^2*(_+_) ≤ _
  nlinarith only [Nat.mul_le_mul_left R.card h₁, Nat.mul_le_mul_left L.card h₂,
    Nat.mul_le_mul_left (L.card*R.card) total]

end Erdos810

#assert_no_sorry Erdos810.matched_rectangle_internal Erdos810.rectangle_matching_energy
