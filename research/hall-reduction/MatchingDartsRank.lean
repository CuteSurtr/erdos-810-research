import FoolingSetSpecialization

/-! # Applying the characteristic-zero fooling-set bound to both orientations of a matching -/

set_option autoImplicit false

open Matrix SimpleGraph

namespace Erdos810

variable {I V F K : Type*} [Fintype I] [Fintype V] [Field F] [CharZero F]
variable {G : SimpleGraph V}

/-- A set of equally labeled oriented edges, with distinct starts and distinct ends, is a fooling set. -/
theorem mono_darts_charZero (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4))
    (A : Matrix V V F) (support : ∀ a b, A a b ≠ 0 ↔ G.Adj a b)
    (u v : I → V) (hu : Function.Injective u) (hv : Function.Injective v)
    (edge : ∀ i, G.Adj (u i) (v i)) (color : ∀ i j, C.get _ _ (edge i) = C.get _ _ (edge j)) :
    Fintype.card I ≤ (A.rank+1).choose 2 := by
  let B : Matrix I I F := fun i j ↦ A (u i) (v j)
  have ok (i j : I) (hij : i ≠ j) : B i j * B j i = 0 := by
    by_contra hn
    have h1 := (support (u i) (v j)).mp (left_ne_zero_of_mul hn)
    have h2 := (support (u j) (v i)).mp (right_ne_zero_of_mul hn)
    have h := (List.nodup_cons.mp (EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mp hr
      _ _ _ _ (edge i) h2.symm (edge j) h1.symm (hu.ne hij) (hv.ne hij))).1
    exact h (by simp [color i j])
  have rank_le : B.rank ≤ A.rank := by
    obtain ⟨X, Y, hXY⟩ := exists_rank_factorization A
    let X' : Matrix I (Fin A.rank) F := fun i a ↦ X (u i) a
    let Y' : Matrix (Fin A.rank) I F := fun a i ↦ Y a (v i)
    have hB : B = X' * Y' := by
      ext i j
      exact (congrFun (congrFun hXY (u i)) (v j)).symm
    rw [hB]
    exact (Matrix.rank_mul_le_left _ _).trans (by simpa using X'.rank_le_card_width)
  exact (foolingSet_charZero_card_le_choose B (fun i ↦ (support _ _).mpr (edge i)) ok).trans
    (Nat.choose_le_choose 2 (Nat.succ_le_succ rank_le))

/-- Two orientations per edge improve the characteristic-zero bound for undirected matchings. -/
theorem twice_mono_matching_charZero (C : G.EdgeLabeling K) (hr : C.IsRainbowFor (cycleGraph 4))
    (A : Matrix V V F) (support : ∀ a b, A a b ≠ 0 ↔ G.Adj a b) (u v : I → V)
    (edge : ∀ i, G.Adj (u i) (v i)) (color : ∀ i j, C.get _ _ (edge i) = C.get _ _ (edge j))
    (disjoint : ∀ i j, i ≠ j → u i ≠ u j ∧ u i ≠ v j ∧ v i ≠ u j ∧ v i ≠ v j) :
    2 * Fintype.card I ≤ (A.rank+1).choose 2 := by
  let start : Bool × I → V := fun p ↦ if p.1 then v p.2 else u p.2
  let flip : Bool × I → Bool × I := fun p ↦ (!p.1, p.2)
  have hflip : Function.Injective flip := by
    rintro ⟨a,i⟩ ⟨b,j⟩ he
    have h := congrArg flip he
    simpa [flip] using h
  have inj : Function.Injective start := by
    rintro ⟨a,i⟩ ⟨b,j⟩ he
    by_cases hij : i = j
    · subst j
      cases a <;> cases b <;> simp_all [start, (edge i).ne, (edge i).ne.symm]
    · obtain ⟨h1,h2,h3,h4⟩ := disjoint i j hij
      cases a <;> cases b <;> simp_all [start]
  have dart (p : Bool × I) : G.Adj (start p) ((start ∘ flip) p) := by
    rcases p with ⟨b,i⟩
    cases b <;> simp [start, flip, edge, (edge i).symm]
  have label (p : Bool × I) : C.get _ _ (dart p) = C.get _ _ (edge p.2) := by
    rcases p with ⟨b,i⟩
    cases b
    · rfl
    · exact (get_swap C (edge i)).symm
  have h := mono_darts_charZero C hr A support start (start ∘ flip) inj (inj.comp hflip) dart
    (fun i j ↦ (label i).trans ((color i.2 j.2).trans (label j).symm))
  simpa only [Fintype.card_prod, Fintype.card_bool] using h

end Erdos810

#assert_no_sorry Erdos810.twice_mono_matching_charZero
