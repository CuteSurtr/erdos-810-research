import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Card
import Mathlib.Algebra.Field.Defs
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-! # Shared affine columns with several repair hubs -/

set_option autoImplicit false
namespace Erdos810.MatchingHubs

/-- Two affine lines of distinct slopes cannot meet at different abscissae. -/
theorem intersection_abscissa {F : Type*} [Field F] {i j b d x y : F}
    (different : i ≠ j) (at_x : i*x+b=j*x+d) (at_y : i*y+b=j*y+d) : x=y := by
  have prod : (i-j)*(x-y)=0 := by linear_combination at_x-at_y
  exact sub_eq_zero.mp ((mul_eq_zero.mp prod).resolve_left (sub_ne_zero.mpr different))

/-- At a point shared by two directions their grid colors come from different buckets. -/
theorem separate_buckets {F : Type*} [Field F] {i j : F} (different : i ≠ j) (x : F) :
    x+i ≠ x+j := fun eq => different (add_left_cancel eq)

/-- Fewer than half as many removed edges as hubs leave some hub untouched. -/
theorem untouched {H E : Type*} [Fintype H] [DecidableEq H]
    (removed : Finset E) (a b : E → H) (few : 2*removed.card < Fintype.card H) :
    ∃ i : H, i ∉ removed.image a ∧ i ∉ removed.image b := by
  classical
  have ha := Finset.card_image_le (s := removed) (f := a)
  have hb := Finset.card_image_le (s := removed) (f := b)
  have hc := Finset.card_union_le (removed.image a) (removed.image b)
  by_contra! all
  have full : removed.image a ∪ removed.image b = Finset.univ := by
    apply Finset.eq_univ_of_forall
    intro i
    by_cases cond : i ∈ removed.image a
    · exact Finset.mem_union_left _ cond
    · exact Finset.mem_union_right _ (all i cond)
  rw [full, Finset.card_univ] at hc
  omega

/-- Each removed edge can spoil at most one part in a fixed partition. -/
theorem intact_part {P E : Type*} [Fintype P] [DecidableEq P] (removed : Finset E)
    (blame : E → P) (few : removed.card < Fintype.card P) :
    ∃ p : P, p ∉ removed.image blame := by
  classical
  by_contra! all
  have h := Finset.card_image_le (s := removed) (f := blame)
  rw [Finset.eq_univ_of_forall all, Finset.card_univ] at h
  omega

/-- The bucket sizes give exactly the requested number of colors. -/
theorem bucket_total (h q : ℕ) (s : ℕ) (hs : s=(h+1)*q) :
    q*(s*(h+1)+h*(h+1))+h = s*(s+h)+h := by subst s; ring

/-- The combined number of forced pairs is h/(h+1) of the leading s² vertices. -/
theorem forced_ratio (h q s : ℕ) (hs : s=(h+1)*q) :
    (h*q*s)*(h+1)=h*s^2 := by subst s; ring

end Erdos810.MatchingHubs
