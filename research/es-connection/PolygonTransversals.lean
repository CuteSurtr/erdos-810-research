import Mathlib.Data.Finset.Card
import Mathlib.Combinatorics.Enumerative.DoubleCounting
import Mathlib.Tactic.Ring

/-! Finite deductions for polygon hitting sets. The geometric deletion lemma
from the 18 November ES record is an explicit hypothesis wherever used. -/

namespace PolygonTransversals

variable {α : Type*}

def Has (P : Finset α → Prop) (k : ℕ) (S : Finset α) : Prop :=
  ∃ Q ⊆ S, Q.card = k ∧ P Q

theorem has_mono {P : Finset α → Prop} {k : ℕ} {S T : Finset α}
    (h : S ⊆ T) : Has P k S → Has P k T := by
  rintro ⟨Q, hQ, hc, hp⟩
  exact ⟨Q, hQ.trans h, hc, hp⟩

variable [DecidableEq α]

/-- Lemma I from THEORY_1118, with convexity replaced by a predicate. -/
def LocalDeletion (P : Finset α → Prop) : Prop :=
  ∀ (k : ℕ) (S : Finset α), 6 ≤ k → S.card = k + 1 → ¬ Has P k S →
    ∃ v ∈ S, ¬ Has P (k - 1) (S.erase v)

theorem transversal_bound {P : Finset α → Prop} (step : LocalDeletion P)
    {n : ℕ} {W : Finset α} (hn : 6 ≤ n) (hsize : n + 1 ≤ W.card)
    (hnone : ¬ Has P n W) :
    ∃ D ⊆ W, D.card = W.card - n ∧ ¬ Has P (n - 1) (W \ D) := by
  obtain ⟨S, hS, hs⟩ := Finset.exists_subset_card_eq hsize
  obtain ⟨v, hv, h⟩ := step n S hn hs (fun x => hnone (has_mono hS x))
  have ht : S.erase v ⊆ W := (Finset.erase_subset v S).trans hS
  have hc : (S.erase v).card = n := by rw [Finset.card_erase_of_mem hv, hs]; omega
  refine ⟨W \ S.erase v, Finset.sdiff_subset, ?_, ?_⟩
  · rw [Finset.card_sdiff_of_subset ht, hc]
  · rwa [Finset.sdiff_sdiff_eq_self ht]

/-- Iterate the local deletion step down to a six-point obstruction. -/
theorem six_core {P : Finset α → Prop} (step : LocalDeletion P) (t : ℕ)
    {S : Finset α} (hc : S.card = 6 + t) (hn : ¬ Has P (5 + t) S) :
    ∃ C ⊆ S, C.card = 6 ∧ ¬ Has P 5 C := by
  induction t generalizing S with
  | zero => exact ⟨S, Finset.Subset.rfl, by simpa using hc, by simpa using hn⟩
  | succ t ih =>
    have hn' : ¬ Has P (6 + t) S := by rwa [show 6 + t = 5 + (t + 1) by omega]
    obtain ⟨v, hv, h⟩ := step (6 + t) S (by omega) (by omega) hn'
    have hs : (S.erase v).card = 6 + t := by rw [Finset.card_erase_of_mem hv]; omega
    rw [show 6 + t - 1 = 5 + t by omega] at h
    obtain ⟨C, hC, hsize, hbad⟩ := ih hs h
    exact ⟨C, hC.trans (Finset.erase_subset v S), hsize, hbad⟩

/-- Soundness of an explicit six-point certificate only needs heredity. -/
theorem six_core_blocks {P : Finset α → Prop}
    (hered : ∀ {A B : Finset α}, A ⊆ B → P B → P A) {C S : Finset α}
    (hCS : C ⊆ S) (hc : C.card = 6) (hbad : ¬ Has P 5 C) {k : ℕ}
    (hs : S.card = k + 1) : ¬ Has P k S := by
  rintro ⟨Q, hQ, hq, hp⟩
  have hdiff := Finset.card_le_card
    (Finset.sdiff_subset_sdiff hCS (show Q ⊆ Q from Finset.Subset.rfl))
  rw [Finset.card_sdiff_of_subset hQ, hs, hq] at hdiff
  have hsum := Finset.card_sdiff_add_card_inter C Q
  have hlarge : 5 ≤ (C ∩ Q).card := by omega
  obtain ⟨A, hA, ha⟩ := Finset.exists_subset_card_eq hlarge
  exact hbad ⟨A, hA.trans Finset.inter_subset_left, ha,
    hered (hA.trans Finset.inter_subset_right) hp⟩

/-- Every point outside the same six-element set completes a prescribed prefix. -/
theorem six_exceptions {P : Finset α → Prop} (step : LocalDeletion P)
    (hered : ∀ {A B : Finset α}, A ⊆ B → P B → P A) {R : Finset α} {n : ℕ}
    (hn : 6 ≤ n) (hs : R.card = n + 1) (hbad : ¬ Has P n R) :
    ∃ C ⊆ R, C.card = 6 ∧ ∀ v ∈ R, v ∉ C → ¬ Has P (n - 1) (R.erase v) := by
  have h' : ¬ Has P (5 + (n - 5)) R := by rwa [show 5 + (n - 5) = n by omega]
  obtain ⟨C, hCR, hc, hb⟩ := six_core step (n - 5) (S := R) (by omega) h'
  refine ⟨C, hCR, hc, ?_⟩
  intro v hv hvc
  apply six_core_blocks hered (C := C) _ hc hb
  · rw [Finset.card_erase_of_mem hv]; omega
  · intro x hx
    exact Finset.mem_erase.mpr ⟨fun he => hvc (he ▸ hx), hCR hx⟩

omit [DecidableEq α] in
/-- Each outside omission has two core neighbors; a core vertex has at most four
outside neighbors. The geometric derivation of the degree bounds is in the note. -/
theorem outside_bound {A B : Finset α} (r : α → α → Prop) [DecidableRel r]
    (hc : A.card = 6)
    (hout : ∀ x ∈ B, 2 ≤ (A.bipartiteAbove r x).card)
    (hin : ∀ a ∈ A, (B.bipartiteBelow r a).card ≤ 4) : B.card ≤ 12 := by
  have h : B.card • (2 : ℕ) ≤ A.card • (4 : ℕ) :=
    Finset.card_nsmul_le_card_nsmul r hout hin
  have hn : B.card * 2 ≤ 24 := by simpa [nsmul_eq_mul, hc] using h
  omega

/-- Determinant for the two raised points of the explicit parabola family.
The three offsets are the differences from y = 2x². -/
theorem lifted_det (i j k u v w : ℤ) :
    (j-i) * ((2*k^2+w) - (2*j^2+v)) - (k-j) * ((2*j^2+v) - (2*i^2+u)) =
    (k-i) * (2*(j-i)*(k-j)-v) + (k-j)*u + (j-i)*w := by ring

end PolygonTransversals
