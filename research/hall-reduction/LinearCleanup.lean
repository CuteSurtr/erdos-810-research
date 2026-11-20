import ShadowCount

/-! # Removing intersecting pairs until a triple family is linear -/

set_option autoImplicit false
namespace Erdos810
variable {n : ℕ} {H : Finset (Finset (Fin n))}

private theorem overlap_four {a b : Finset (Fin n)} (ca : a.card=3) (cb : b.card=3)
    (ne : a≠b) (two : 2≤(a∩b).card) : (a∪b).card=4 := by
  have count := Finset.card_union_add_card_inter a b
  have low : 4≤(a∪b).card := by
    by_contra! small
    have u : a=a∪b := Finset.eq_of_subset_of_card_le Finset.subset_union_left (by omega)
    have v : b=a∪b := Finset.eq_of_subset_of_card_le Finset.subset_union_right (by omega)
    exact ne (u.trans v.symm)
  omega

private theorem distinct_overlaps_disjoint (free : SevenFourFree H) (hn : 7≤n)
    {a b c d : Finset (Fin n)} (ha : a∈H) (hb : b∈H) (hc : c∈H) (hd : d∈H)
    (ab : a≠b) (ac : a≠c) (ad : a≠d) (bc : b≠c) (bd : b≠d) (cd : c≠d)
    (l : (a∪b).card=4) (r : (c∪d).card=4) : Disjoint (a∪b) (c∪d) := by
  classical
  apply Finset.disjoint_left.mpr
  intro x xl xr
  let U := (a∪b)∪(c∪d)
  have count := Finset.card_union_add_card_inter (a∪b) (c∪d)
  have pos := Finset.card_pos.mpr (show ((a∪b)∩(c∪d)).Nonempty from ⟨x,Finset.mem_inter.mpr ⟨xl,xr⟩⟩)
  have small : U.card≤7 := by dsimp [U]; omega
  have inside : ({a,b,c,d}:Finset _) ⊆ H.filter (fun e ↦ e⊆U) := by
    simp only [Finset.insert_subset_iff,Finset.singleton_subset_iff,Finset.mem_filter]
    exact ⟨⟨ha,Finset.subset_union_left.trans Finset.subset_union_left⟩,
      ⟨hb,Finset.subset_union_right.trans Finset.subset_union_left⟩,
      ⟨hc,Finset.subset_union_left.trans Finset.subset_union_right⟩,
      ⟨hd,Finset.subset_union_right.trans Finset.subset_union_right⟩⟩
  have count' := Finset.card_le_card inside
  have four : ({a,b,c,d}:Finset _).card=4 := by simp [ab,ac,ad,bc,bd,cd]
  have small' := free.card_filter_lt_four hn U small
  omega

private theorem cleanup_aux (hn : 7≤n) (free : SevenFourFree H) (uniform : ∀ t∈H,t.card=3)
    (A : Finset (Finset (Fin n))) (sub : A⊆H) (U : Finset (Fin n))
    (room : ∀ a∈A, ∀ b∈A, a≠b → 2≤(a∩b).card → a∪b⊆U) :
    ∃ R⊆A, (∀ t∈R,IsLinearMember R t) ∧ 2*A.card≤2*R.card+U.card := by
  classical
  by_cases bad : ∃ a∈A, ∃ b∈A, a≠b ∧ 2≤(a∩b).card
  · obtain ⟨a,ha,b,hb,ab,two⟩ := bad
    let T := (A.erase a).erase b
    have desc {c} (hc : c∈T) : c≠b ∧ c≠a ∧ c∈A := by simpa [T] using hc
    have below : T⊆A := fun _ hc ↦ (desc hc).2.2
    have size := overlap_four (uniform a (sub ha)) (uniform b (sub hb)) ab two
    have charge := room a ha b hb ab two
    have rest (c) (hc : c∈T) (d) (hd : d∈T) (cd : c≠d) (many : 2≤(c∩d).card) :
        c∪d⊆U \ (a∪b) := by
      have sz := overlap_four (uniform c (sub (below hc))) (uniform d (sub (below hd))) cd many
      have dis := distinct_overlaps_disjoint free hn (sub ha) (sub hb) (sub (below hc)) (sub (below hd))
        ab (desc hc).2.1.symm (desc hd).2.1.symm (desc hc).1.symm (desc hd).1.symm cd size sz
      exact fun x hx ↦ Finset.mem_sdiff.mpr ⟨room c (below hc) d (below hd) cd many hx,
        fun h ↦ Finset.disjoint_left.mp dis h hx⟩
    obtain ⟨R,RT,lin,cnt⟩ := cleanup_aux hn free uniform T (below.trans sub) (U \ (a∪b)) rest
    have bmem : b∈A.erase a := Finset.mem_erase.mpr ⟨ab.symm,hb⟩
    have one := Finset.card_erase_add_one ha
    have two' := Finset.card_erase_add_one bmem
    have diff := Finset.card_sdiff_add_card_eq_card charge
    rw [size] at diff
    change 2*((A.erase a).erase b).card ≤ _ at cnt
    exact ⟨R,RT.trans below,lin,by omega⟩
  · refine ⟨A,Finset.Subset.rfl,?_,by omega⟩
    intro t ht s hs ne
    by_contra! large
    exact bad ⟨t,ht,s,hs,ne.symm,by omega⟩
termination_by A.card
decreasing_by exact lt_of_le_of_lt Finset.card_erase_le (Finset.card_erase_lt_of_mem ha)

theorem exists_linear_rest (hn : 7≤n) (free : SevenFourFree H) (uniform : ∀ t∈H,t.card=3) :
    ∃ R⊆H, (∀ t∈R,IsLinearMember R t) ∧ 2*H.card≤2*R.card+n := by
  simpa only [Finset.card_univ,Fintype.card_fin] using
    cleanup_aux hn free uniform H Finset.Subset.rfl Finset.univ
      (fun _ _ _ _ _ _ ↦ Finset.subset_univ _)

theorem sevenFourFree_of_subset {A : Finset (Finset (Fin n))} (free : SevenFourFree H) (sub : A⊆H) :
    SevenFourFree A := by
  intro s hs
  exact lt_of_le_of_lt (Finset.card_le_card (Finset.filter_subset_filter _ sub)) (free s hs)

end Erdos810
#assert_no_sorry Erdos810.exists_linear_rest Erdos810.sevenFourFree_of_subset
