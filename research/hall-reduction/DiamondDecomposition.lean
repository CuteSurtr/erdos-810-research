import ShadowCount

/-! # Automatic diamond decomposition away from three-triple blocks -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

/-- No set of at most five points contains three members of the family. -/
def ThreeOnFiveFree (H : Finset (Finset (Fin n))) : Prop :=
  ∀ S : Finset (Fin n), S.card ≤ 5 → (H.filter (fun t ↦ t ⊆ S)).card < 3

private theorem complete_triple {t : Finset (Fin n)} (ht : t.card = 3) {a b : Fin n}
    (hab : a ≠ b) (ha : a ∈ t) (hb : b ∈ t) :
    ∃ c : Fin n, c ≠ a ∧ c ≠ b ∧ t = {a, b, c} := by
  let K : Finset (Finset (Fin n)) := {t}
  have hthree : ∀ s ∈ K, s.card = 3 := fun s hs ↦ Finset.mem_singleton.mp hs ▸ ht
  obtain ⟨c, hc⟩ := exists_omitted hthree
    (show (twoShadow K).Adj a b from ⟨hab, t, Finset.mem_singleton_self _, ha, hb⟩)
  exact ⟨c, hc.ne_left, hc.ne_right, (Finset.mem_singleton.mp hc.mem).symm⟩

namespace OrdinaryDiamond

variable (D : OrdinaryDiamond H)

theorem support_eq_union : D.support = diamondLeft.map D.point ∪ diamondRight.map D.point := by
  rw [← Finset.map_union, show diamondLeft ∪ diamondRight = Finset.univ by decide]
  rfl

theorem support_subset_of_sides_subset {S : Finset (Fin n)} (h : ∀ t ∈ D.sides, t ⊆ S) :
    D.support ⊆ S := by
  rw [D.support_eq_union, Finset.union_subset_iff]
  exact ⟨h _ (by simp [sides]), h _ (by simp [sides])⟩

private theorem inter_two_sides {t s : Finset (Fin n)} (ht : t ∈ D.sides) (hs : s ∈ D.sides)
    (hne : t ≠ s) : (s ∩ t).card = 2 := by
  simp only [sides, Finset.mem_insert, Finset.mem_singleton] at ht hs
  rcases ht with rfl | rfl <;> rcases hs with rfl | rfl <;> try contradiction
  · rw [Finset.inter_comm]; exact D.card_side_inter
  · exact D.card_side_inter

/-- Distinct ordinary diamonds cannot share a triple, regardless of the other triples. -/
theorem support_eq_of_common_side (E : OrdinaryDiamond H) {t : Finset (Fin n)}
    (ht : t ∈ D.sides) (ht' : t ∈ E.sides) : D.support = E.support := by
  apply Eq.symm
  apply Finset.eq_of_subset_of_card_le _ (by simp)
  apply E.support_subset_of_sides_subset
  intro s hs
  by_cases he : s = t
  · exact he ▸ D.subset_of_mem_sides ht
  by_cases hl : s = diamondLeft.map D.point
  · exact hl ▸ D.side_subset _
  by_cases hr : s = diamondRight.map D.point
  · exact hr ▸ D.side_subset _
  have hsize := E.inter_two_sides ht' hs (Ne.symm he)
  have hsmall := D.external s (E.sides_subset hs) hl hr
  change (s ∩ D.support).card ≤ 1 at hsmall
  have hh := Finset.card_le_card (Finset.inter_subset_inter (Finset.Subset.refl s)
    (D.subset_of_mem_sides ht))
  omega

/-- Different supports are vertex-disjoint, because four distinct sides on
intersecting four-point supports would span at most seven points. -/
theorem disjoint_of_ne_support (E : OrdinaryDiamond H) (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hne : D.support ≠ E.support) : Disjoint D.support E.support := by
  classical
  have hside : Disjoint D.sides E.sides := Finset.disjoint_left.mpr
    (fun _ h₁ h₂ ↦ hne (D.support_eq_of_common_side E h₁ h₂))
  apply Finset.disjoint_left.mpr
  intro v hv hv'
  let U := D.support ∪ E.support
  have hU : U.card ≤ 7 := by
    have hu := Finset.card_union_add_card_inter D.support E.support
    have hp : 0 < (D.support ∩ E.support).card :=
      Finset.card_pos.mpr ⟨v, Finset.mem_inter.mpr ⟨hv, hv'⟩⟩
    rw [D.card_support, E.card_support] at hu
    change (D.support ∪ E.support).card ≤ 7
    omega
  have hh : D.sides ∪ E.sides ⊆ H.filter (fun t ↦ t ⊆ U) := by
    intro t ht
    rcases Finset.mem_union.mp ht with ht | ht
    · exact Finset.mem_filter.mpr ⟨D.sides_subset ht, (D.subset_of_mem_sides ht).trans
        Finset.subset_union_left⟩
    · exact Finset.mem_filter.mpr ⟨E.sides_subset ht, (E.subset_of_mem_sides ht).trans
        Finset.subset_union_right⟩
  have hfour := Finset.card_le_card hh
  rw [Finset.card_union_of_disjoint hside, D.card_sides, E.card_sides] at hfour
  exact (hf.card_filter_lt_four hn U hU).not_ge hfour

end OrdinaryDiamond

/-- Two triples that share a pair form an ordinary diamond if three triples on
five or fewer vertices have already been removed. -/
theorem ordinary_of_overlap (hthree : ∀ t ∈ H, t.card = 3) (hfree : ThreeOnFiveFree H)
    {t s : Finset (Fin n)} (ht : t ∈ H) (hs : s ∈ H) (hne : t ≠ s)
    (hover : 1 < (t ∩ s).card) : ∃ D : OrdinaryDiamond H, t ⊆ D.support ∧ s ⊆ D.support := by
  obtain ⟨a, ha, b, hb, hab⟩ := Finset.one_lt_card.mp hover
  obtain ⟨c, hca, hcb, htc⟩ := complete_triple (hthree t ht) hab
    (Finset.mem_inter.mp ha).1 (Finset.mem_inter.mp hb).1
  obtain ⟨d, hda, hdb, hsd⟩ := complete_triple (hthree s hs) hab
    (Finset.mem_inter.mp ha).2 (Finset.mem_inter.mp hb).2
  have hcd : c ≠ d := fun he ↦ hne (htc.trans (he ▸ hsd.symm))
  let f : Fin 4 ↪ Fin n := ⟨![a, b, c, d], by
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all [Fin.isValue, Matrix.cons_val_one,
      Matrix.cons_val_zero, ne_comm]⟩
  have hl : diamondLeft.map f = t := by simp [diamondLeft, f, htc]
  have hr : diamondRight.map f = s := by simp [diamondRight, f, hsd]
  have hu : Finset.univ.map f = t ∪ s := by
    rw [← hl, ← hr, ← Finset.map_union, show diamondLeft ∪ diamondRight = Finset.univ by decide]
  have hfour : (Finset.univ.map f).card = 4 := by simp
  have hext (r : Finset (Fin n)) (her : r ∈ H) (hrt : r ≠ diamondLeft.map f)
      (hrs : r ≠ diamondRight.map f) : (r ∩ Finset.univ.map f).card ≤ 1 := by
    by_contra! hbig
    let U := r ∪ Finset.univ.map f
    have hU : U.card ≤ 5 := by
      have heq := Finset.card_union_add_card_inter r (Finset.univ.map f)
      rw [hfour, hthree r her] at heq
      change (r ∪ Finset.univ.map f).card ≤ 5
      omega
    have hh : {t, s, r} ⊆ H.filter (fun k ↦ k ⊆ U) := by
      simp only [Finset.insert_subset_iff, Finset.singleton_subset_iff, Finset.mem_filter]
      rw [show U = r ∪ (t ∪ s) from congrArg (r ∪ ·) hu]
      exact ⟨⟨ht, Finset.subset_union_left.trans Finset.subset_union_right⟩,
        ⟨hs, Finset.subset_union_right.trans Finset.subset_union_right⟩, her, Finset.subset_union_left⟩
    rw [hl] at hrt
    rw [hr] at hrs
    have hcount := Finset.card_le_card hh
    simp [hne, hrt.symm, hrs.symm] at hcount
    exact (hfree U hU).not_ge hcount
  let D : OrdinaryDiamond H := ⟨f, hl ▸ ht, hr ▸ hs, hext⟩
  refine ⟨D, ?_, ?_⟩
  · change t ⊆ Finset.univ.map f
    rw [hu]; exact Finset.subset_union_left
  · change s ⊆ Finset.univ.map f
    rw [hu]; exact Finset.subset_union_right

/-- The support is a canonical index even though a diamond admits several labelings. -/
noncomputable def diamondSupports (H : Finset (Finset (Fin n))) : Finset (Finset (Fin n)) := by
  classical exact Finset.univ.filter (fun S ↦ ∃ D : OrdinaryDiamond H, D.support = S)

noncomputable def diamondOn (i : ↥(diamondSupports H)) : OrdinaryDiamond H := by
  classical exact (Finset.mem_filter.mp i.property).2.choose

@[simp] theorem diamondOn_support (i : ↥(diamondSupports H)) : (diamondOn i).support = i.val := by
  classical exact (Finset.mem_filter.mp i.property).2.choose_spec

theorem diamondSupports_pairwise (hn : 7 ≤ n) (hf : SevenFourFree H) :
    Pairwise (fun i j : ↥(diamondSupports H) ↦ Disjoint (diamondOn i).support (diamondOn j).support) :=
  fun i j hne ↦ (diamondOn i).disjoint_of_ne_support (diamondOn j) hn hf (by simpa using
    (fun h ↦ hne (Subtype.ext h) : i.val ≠ j.val))

theorem diamondSupports_cover (hthree : ∀ t ∈ H, t.card = 3) (hfree : ThreeOnFiveFree H) :
    CoversNonlinear H (diamondOn (H := H)) := by
  classical
  intro t ht
  by_cases hl : IsLinearMember H t
  · exact Or.inl hl
  · change ¬∀ s ∈ H, s ≠ t → (t ∩ s).card ≤ 1 at hl
    push_neg at hl
    obtain ⟨s, hs, hne, ho⟩ := hl
    obtain ⟨E, he, _⟩ := ordinary_of_overlap hthree hfree ht hs hne.symm ho
    have hi : E.support ∈ diamondSupports H := Finset.mem_filter.mpr ⟨Finset.mem_univ _, E, rfl⟩
    exact Or.inr ⟨⟨E.support, hi⟩, by simpa using he⟩

/-- A block-free (7,4)-free triple system needs no supplied decomposition.
One new vertex gives three edges per triple plus one for each diamond. -/
theorem extended_shadow_of_threeOnFiveFree (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (hfree : ThreeOnFiveFree H) :
    ∃ (G : SimpleGraph (Fin (n + 1))) (C : G.EdgeLabeling (Fin n)),
      G.edgeSet.ncard = 3 * H.card + (diamondSupports H).card ∧ C.IsRainbowFor (cycleGraph 4) := by
  simpa using three_per_triple_plus_diamonds hn hf hthree diamondOn (diamondSupports_pairwise hn hf)
    (diamondSupports_cover hthree hfree)

end Erdos810

#assert_no_sorry
  Erdos810.OrdinaryDiamond.disjoint_of_ne_support
  Erdos810.ordinary_of_overlap
  Erdos810.diamondSupports_cover
  Erdos810.extended_shadow_of_threeOnFiveFree
