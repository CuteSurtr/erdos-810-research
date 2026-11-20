import DiamondHub

/-! # The full two-shadow after recoloring its ordinary diamonds -/

set_option autoImplicit false

open SimpleGraph

namespace Erdos810

variable {n : ℕ} {H : Finset (Finset (Fin n))}

/-- A member of the triple system shares at most one point with every other member. -/
def IsLinearMember (H : Finset (Finset (Fin n))) (t : Finset (Fin n)) : Prop :=
  ∀ s ∈ H, s ≠ t → (t ∩ s).card ≤ 1

private theorem different_members {α : Type*} {A B : Finset α} {x : α}
    (hx : x ∈ A) (hx' : x ∉ B) : A ≠ B := fun he ↦ hx' (he ▸ hx)

/-- Opposite edges always have different omitted colors, including in a nonlinear
triple system. A common color would be outside all four cycle vertices. -/
theorem opposite_omitted_ne (hn : 7 ≤ n) (hf : SevenFourFree H) {a b c d p q r s : Fin n}
    (hv : [a, b, c, d].Nodup) (h₁ : IsOmitted H a b p) (h₂ : IsOmitted H b c q)
    (h₃ : IsOmitted H c d r) (h₄ : IsOmitted H d a s) : p ≠ r := by
  rintro rfl
  have ⟨⟨hab, hac, had⟩, ⟨hbc, hbd⟩, hcd⟩ :
      (a ≠ b ∧ a ≠ c ∧ a ≠ d) ∧ (b ≠ c ∧ b ≠ d) ∧ c ≠ d := by simpa using hv
  let A : Finset (Fin n) := {a, b, p}
  let B : Finset (Fin n) := {b, c, q}
  let C : Finset (Fin n) := {c, d, p}
  let D : Finset (Fin n) := {d, a, s}
  have nc : c ∉ A := by simp [A, hac.symm, hbc.symm, h₃.ne_left.symm]
  have nd : d ∉ A := by simp [A, had.symm, hbd.symm, h₃.ne_right.symm]
  have na : a ∉ C := by simp [C, hac, had, h₁.ne_left.symm]
  have nb : b ∉ C := by simp [C, hbc, hbd, h₁.ne_right.symm]
  have ab : A ≠ B := (different_members (by simp [B] : c ∈ B) nc).symm
  have ac : A ≠ C := different_members (by simp [A] : a ∈ A) na
  have ad : A ≠ D := (different_members (by simp [D] : d ∈ D) nd).symm
  have bc : B ≠ C := different_members (by simp [B] : b ∈ B) nb
  have cd : C ≠ D := (different_members (by simp [D] : a ∈ D) na).symm
  have bd : B ≠ D := by
    intro he
    have ha : a ∈ B := he ▸ (by simp [D] : a ∈ D)
    have hd : d ∈ B := he ▸ (by simp [D] : d ∈ D)
    simp [B, hab, hac] at ha
    simp [B, hbd.symm, hcd.symm] at hd
    exact had (ha.trans hd.symm)
  let S : Finset (Fin n) := {a, b, c, d, p, q, s}
  have hs : S.card ≤ 7 := (Finset.card_insert_le _ _).trans (Nat.succ_le_succ Finset.card_le_six)
  have hsub : {A, B, C, D} ⊆ H.filter (fun t ↦ t ⊆ S) := by
    simp only [Finset.insert_subset_iff, Finset.singleton_subset_iff, Finset.mem_filter]
    exact ⟨⟨h₁.mem, by simp [A, S, Finset.insert_subset_iff]⟩,
      ⟨h₂.mem, by simp [B, S, Finset.insert_subset_iff]⟩,
      ⟨h₃.mem, by simp [C, S, Finset.insert_subset_iff]⟩,
      ⟨h₄.mem, by simp [D, S, Finset.insert_subset_iff]⟩⟩
  have hcount := Finset.card_le_card hsub
  simp [ab, ac, ad, bc, bd, cd] at hcount
  exact (hf.card_filter_lt_four hn S hs).not_ge hcount

/-- At a linear member, two incident cycle edges cannot repeat an omitted color. -/
theorem adjacent_omitted_ne_of_linear {a b c p q : Fin n}
    (hab : a ≠ b) (hac : a ≠ c) (h₁ : IsOmitted H a b p) (h₂ : IsOmitted H b c q)
    (hl : IsLinearMember H {a, b, p}) : p ≠ q := by
  rintro rfl
  have he : ({b, c, p} : Finset _) ≠ {a, b, p} :=
    (different_members (Finset.mem_insert_self a {b, p}) (by simp [hab, hac, h₁.ne_left.symm])).symm
  exact h₁.ne_right (Finset.card_le_one.mp (hl _ h₂.mem he) p (by simp) b (by simp))

private theorem linear_cycle (hn : 7 ≤ n) (hf : SevenFourFree H) {a b c d p q r s : Fin n}
    (hv : [a, b, c, d].Nodup) (h₁ : IsOmitted H a b p) (h₂ : IsOmitted H b c q)
    (h₃ : IsOmitted H c d r) (h₄ : IsOmitted H d a s)
    (l₁ : IsLinearMember H {a,b,p}) (l₂ : IsLinearMember H {b,c,q})
    (l₃ : IsLinearMember H {c,d,r}) (l₄ : IsLinearMember H {d,a,s}) :
    [p, q, r, s].Nodup := by
  have pr := opposite_omitted_ne hn hf hv h₁ h₂ h₃ h₄
  have qs := opposite_omitted_ne hn hf (nodup_cycle_shift hv) h₂ h₃ h₄ h₁
  have ⟨⟨hab, hac, had⟩, ⟨hbc, hbd⟩, hcd⟩ :
      (a ≠ b ∧ a ≠ c ∧ a ≠ d) ∧ (b ≠ c ∧ b ≠ d) ∧ c ≠ d := by simpa using hv
  have pq := adjacent_omitted_ne_of_linear hab hac h₁ h₂ l₁
  have qr := adjacent_omitted_ne_of_linear hbc hbd h₂ h₃ l₂
  have rs := adjacent_omitted_ne_of_linear hcd hac.symm h₃ h₄ l₃
  have sp := adjacent_omitted_ne_of_linear had.symm hbd.symm h₄ h₁ l₄
  simp [pq, pr, sp.symm, qr, qs, rs]

variable {ι : Type*}

/-- Every nonlinear triple belongs to one of the given templates. -/
def CoversNonlinear (H : Finset (Finset (Fin n))) (D : ι → OrdinaryDiamond H) : Prop :=
  ∀ t ∈ H, IsLinearMember H t ∨ ∃ i, t ⊆ (D i).support

private def Interior (D : ι → OrdinaryDiamond H) (u v : Fin n) : Prop :=
  ∃ i, u ∈ (D i).support ∧ v ∈ (D i).support

private theorem cycle_with_interior_edge (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support))
    (C : (twoShadow H).EdgeLabeling (Fin n)) (hc : ∀ i, (D i).ColorRule C)
    (ho : ∀ u v (h : (twoShadow H).Adj u v), ¬Interior D u v → IsOmitted H u v (C.get u v h))
    {u v x y : Fin n} (hi : Interior D u v)
    (huv : (twoShadow H).Adj u v) (hvx : (twoShadow H).Adj v x)
    (hxy : (twoShadow H).Adj x y) (hyu : (twoShadow H).Adj y u) (hux : u ≠ x) (hvy : v ≠ y) :
    [C.get u v huv, C.get v x hvx, C.get x y hxy, C.get y u hyu].Nodup := by
  obtain ⟨i, hu, hv⟩ := hi
  by_cases hx : x ∈ (D i).support <;> by_cases hy : y ∈ (D i).support
  · rw [(hc i).inside huv hu hv, (hc i).inside hvx hv hx, (hc i).inside hxy hx hy,
      (hc i).inside hyu hy hu]
    exact (D i).inside_cycle hu hv hx hy huv hvx hxy hyu hux hvy
  · exact (hux ((D i).unique_neighbor hn hf hthree hy hu hx hyu hxy.symm)).elim
  · exact (hvy ((D i).unique_neighbor hn hf hthree hx hv hy hvx.symm hxy)).elim
  · have hk : C.get u v huv ∈ (D i).support := (hc i).inside huv hu hv ▸ (D i).paint_mem _ _
    have hp := (hc i).crossing hvx hv hx
    have hr := (hc i).crossing hyu.symm hu hy
    rw [← get_swap C hyu] at hr
    by_cases hmiddle : Interior D x y
    · obtain ⟨j, hxj, hyj⟩ := hmiddle
      have hij : i ≠ j := fun he ↦ hx (he ▸ hxj)
      have hdis := Finset.disjoint_left.mp (hd hij)
      have hvj : v ∉ (D j).support := fun he ↦ hdis hv he
      have huj : u ∉ (D j).support := fun he ↦ hdis hu he
      have hq : C.get x y hxy ∈ (D j).support := (hc j).inside hxy hxj hyj ▸ (D j).paint_mem _ _
      have pk := (D i).cross_color_outside hv hx hp
      have rk := (D i).cross_color_outside hu hy hr
      have pq := (D j).cross_color_outside hxj hvj hp.symm
      have rq := (D j).cross_color_outside hyj huj hr.symm
      have pr := (D i).crossing_colors_ne hn hf hv hu hx hy huv.ne.symm hp hr
      have hkp : C.get u v huv ≠ C.get v x hvx := fun e ↦ pk (e ▸ hk)
      have hkq : C.get u v huv ≠ C.get x y hxy := fun e ↦ hdis hk (e ▸ hq)
      have hkr : C.get u v huv ≠ C.get y u hyu := fun e ↦ rk (e ▸ hk)
      have hpq : C.get v x hvx ≠ C.get x y hxy := fun e ↦ pq (e ▸ hq)
      have hqr : C.get x y hxy ≠ C.get y u hyu := fun e ↦ rq (e ▸ hq)
      simp [hkp, hkq, hkr, hpq, pr, hqr]
    · exact (D i).mixed_cycle hn hf hthree hu hv hx hy huv.ne hk hp (ho _ _ hxy hmiddle) hr

/-- Recoloring all the nonlinear pieces produces a rainbow coloring of the entire
two-shadow. Its colors are the original vertices. -/
theorem rainbow_twoShadow_of_cover (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support)) (hcover : CoversNonlinear H D) :
    ∃ C : (twoShadow H).EdgeLabeling (Fin n),
      (∀ i, (D i).ColorRule C) ∧ C.IsRainbowFor (cycleGraph 4) := by
  obtain ⟨C, hc, hother⟩ := exists_diamond_coloring hthree D hd
  have ho (u v : Fin n) (h : (twoShadow H).Adj u v) (hi : ¬Interior D u v) :
      IsOmitted H u v (C.get u v h) := hother u v h (fun i he ↦ hi ⟨i, he⟩)
  have hl {u v p : Fin n} (hi : ¬Interior D u v) (h : IsOmitted H u v p) :
      IsLinearMember H {u, v, p} := by
    rcases hcover _ h.mem with lin | ⟨i, hsub⟩
    · exact lin
    · exact (hi ⟨i, hsub (by simp), hsub (by simp)⟩).elim
  refine ⟨C, hc, EdgeLabeling.isRainbowFor_cycleGraph_four_iff.mpr ?_⟩
  intro a b c d hab hbc hcd hda hac hbd
  by_cases h₁ : Interior D a b
  · exact cycle_with_interior_edge hn hf hthree D hd C hc ho h₁ hab hbc hcd hda hac hbd
  by_cases h₂ : Interior D b c
  · exact nodup_cycle_shift (nodup_cycle_shift (nodup_cycle_shift
      (cycle_with_interior_edge hn hf hthree D hd C hc ho h₂ hbc hcd hda hab hbd hac.symm)))
  by_cases h₃ : Interior D c d
  · exact nodup_cycle_shift (nodup_cycle_shift
      (cycle_with_interior_edge hn hf hthree D hd C hc ho h₃ hcd hda hab hbc hac.symm hbd.symm))
  by_cases h₄ : Interior D d a
  · exact nodup_cycle_shift
      (cycle_with_interior_edge hn hf hthree D hd C hc ho h₄ hda hab hbc hcd hbd.symm hac)
  have hv : [a, b, c, d].Nodup := by simp [hab.ne, hac, hda.ne.symm, hbc.ne, hbd, hcd.ne]
  have o₁ := ho _ _ hab h₁
  have o₂ := ho _ _ hbc h₂
  have o₃ := ho _ _ hcd h₃
  have o₄ := ho _ _ hda h₄
  exact linear_cycle hn hf hv o₁ o₂ o₃ o₄ (hl h₁ o₁) (hl h₂ o₂) (hl h₃ o₃) (hl h₄ o₄)

/-- The rainbow extension adds exactly two spokes per marked diamond. -/
theorem extended_shadow_of_cover [Fintype ι] (hn : 7 ≤ n) (hf : SevenFourFree H)
    (hthree : ∀ t ∈ H, t.card = 3) (D : ι → OrdinaryDiamond H)
    (hd : Pairwise (fun i j ↦ Disjoint (D i).support (D j).support)) (hcover : CoversNonlinear H D) :
    ∃ (G : SimpleGraph (Fin (n + 1))) (C : G.EdgeLabeling (Fin n)),
      G.edgeSet.ncard = (twoShadow H).edgeSet.ncard + 2 * Fintype.card ι ∧
      C.IsRainbowFor (cycleGraph 4) := by
  obtain ⟨C, hc, hr⟩ := rainbow_twoShadow_of_cover hn hf hthree D hd hcover
  exact two_spokes_per_diamond hn hf hthree D hd C hc hr

end Erdos810

#assert_no_sorry
  Erdos810.opposite_omitted_ne
  Erdos810.rainbow_twoShadow_of_cover
  Erdos810.extended_shadow_of_cover
