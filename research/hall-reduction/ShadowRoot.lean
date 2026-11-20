import ShadowFlags
import ShadowCount
import TripleTransfer

/-! # A pair of intersecting triples permits only one cross adjacency -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot

open ShadowFlags
variable {n : ℕ} {H : Finset (Finset (Fin n))}

noncomputable def W (H : Finset (Finset (Fin n))) (x y : Fin n) : ℝ := by
  classical exact if (twoShadow H).Adj x y then 1 else 0

theorem W_symm (H : Finset (Finset (Fin n))) (x y : Fin n) : W H x y = W H y x := by
  classical simp only [W,SimpleGraph.adj_comm (G := twoShadow H) y x]

theorem W_nonneg (H : Finset (Finset (Fin n))) (x y : Fin n) : 0 ≤ W H x y := by
  classical unfold W; split <;> norm_num

theorem W_le_one (H : Finset (Finset (Fin n))) (x y : Fin n) : W H x y ≤ 1 := by
  classical unfold W; split <;> norm_num

def inc (H : Finset (Finset (Fin n))) (x : Fin n) := H.filter (fun t ↦ x ∈ t)

theorem overlap_unique (hl : ∀ t ∈ H, IsLinearMember H t) {a b : Finset (Fin n)}
    (ha : a ∈ H) (hb : b ∈ H) {x y : Fin n} (xy : x ≠ y)
    (xa : x ∈ a) (ya : y ∈ a) (xb : x ∈ b) (yb : y ∈ b) : a = b := by
  by_contra ne
  exact xy (Finset.card_le_one.mp (hl a ha b hb (Ne.symm ne)) x (Finset.mem_inter.mpr ⟨xa,xb⟩)
    y (Finset.mem_inter.mpr ⟨ya,yb⟩))

theorem link_sum (hl : ∀ t ∈ H, IsLinearMember H t) (x : Fin n) (f : Fin n → ℝ) :
    (∑ y, W H x y*f y) = ∑ t ∈ inc H x, ∑ y ∈ t.erase x, f y := by
  classical
  let I := inc H x
  have disj : I.toSet.PairwiseDisjoint (fun t ↦ t.erase x) := by
    intro a ha b hb ne
    obtain ⟨ha,xa⟩ := Finset.mem_filter.mp ha
    obtain ⟨hb,xb⟩ := Finset.mem_filter.mp hb
    apply Finset.disjoint_left.mpr
    intro y hy hz
    obtain ⟨yx,ya⟩ := Finset.mem_erase.mp hy
    exact ne (overlap_unique hl ha hb yx.symm xa ya xb (Finset.mem_erase.mp hz).2)
  have eq : Finset.univ.filter ((twoShadow H).Adj x) = I.biUnion (fun t ↦ t.erase x) := by
    ext y
    simp only [I,inc,Finset.mem_filter,Finset.mem_univ,true_and,Finset.mem_biUnion,Finset.mem_erase]
    change (x ≠ y ∧ ∃ t ∈ H, x ∈ t ∧ y ∈ t) ↔ _
    grind
  calc
    _ = ∑ y ∈ Finset.univ.filter ((twoShadow H).Adj x), f y := by
      rw [Finset.sum_filter]
      apply Finset.sum_congr rfl
      intro y _
      by_cases h : (twoShadow H).Adj x y <;> simp [W,h]
    _ = _ := by rw [eq,Finset.sum_biUnion disj]

private theorem outside_one (U g : Finset (Fin n)) (three : g.card = 3)
    {u v : Fin n} (ne : u ≠ v) (ug : u ∈ g) (vg : v ∈ g) (uU : u ∈ U) (vU : v ∈ U) :
    (g \ U).card ≤ 1 := by
  have sub : ({u,v} : Finset _) ⊆ g ∩ U := by simp [Finset.insert_subset_iff,ug,vg,uU,vU]
  have size := Finset.card_le_card sub
  simp [ne] at size
  have part := Finset.card_sdiff_add_card_inter g U
  omega

attribute [local instance] Classical.propDecidable

/-- Each cross pair is an ordered point of (a - x) × (b - x). -/
theorem cross_card (hn : 7 ≤ n) (uniform : ∀ t ∈ H, t.card = 3) (free : SevenFourFree H)
    (hl : ∀ t ∈ H, IsLinearMember H t) {a b : Finset (Fin n)} {x : Fin n}
    (ha : a ∈ H) (hb : b ∈ H) (ab : a ≠ b) (xa : x ∈ a) (xb : x ∈ b) :
    (((a.erase x) ×ˢ (b.erase x)).filter (fun uv : Fin n × Fin n ↦ (twoShadow H).Adj uv.1 uv.2)).card ≤ 1 := by
  classical
  apply Finset.card_le_one.mpr
  rintro ⟨u,v⟩ h₁ ⟨w,z⟩ h₂
  obtain ⟨p₁,adj₁⟩ := Finset.mem_filter.mp h₁
  obtain ⟨p₂,adj₂⟩ := Finset.mem_filter.mp h₂
  obtain ⟨up,vp⟩ := Finset.mem_product.mp p₁
  obtain ⟨wp,zp⟩ := Finset.mem_product.mp p₂
  obtain ⟨ux,ua⟩ := Finset.mem_erase.mp up
  obtain ⟨vx,vb⟩ := Finset.mem_erase.mp vp
  obtain ⟨wx,wa⟩ := Finset.mem_erase.mp wp
  obtain ⟨zx,zb⟩ := Finset.mem_erase.mp zp
  obtain ⟨uv,g,hg,ug,vg⟩ := adj₁
  obtain ⟨wz,k,hk,wk,zk⟩ := adj₂
  have split {y : Fin n} (yx : y ≠ x) (ya : y ∈ a) (yb : y ∈ b) : False :=
    ab (overlap_unique hl ha hb yx.symm xa ya xb yb)
  have ag : a ≠ g := fun e ↦ split vx (e ▸ vg) vb
  have bg : b ≠ g := fun e ↦ split ux ua (e ▸ ug)
  have ak : a ≠ k := fun e ↦ split zx (e ▸ zk) zb
  have bk : b ≠ k := fun e ↦ split wx wa (e ▸ wk)
  by_cases gk : g = k
  · subst k
    apply Prod.ext
    · exact not_not.mp (fun uw ↦ ag (overlap_unique hl ha hg uw ua wa ug wk))
    · exact not_not.mp (fun vz ↦ bg (overlap_unique hl hb hg vz vb zb vg zk))
  let U := a ∪ b
  have sizeU : U.card ≤ 5 := by
    have c := Finset.card_union_add_card_inter a b
    have one := Finset.card_pos.mpr (show (a ∩ b).Nonempty from ⟨x,Finset.mem_inter.mpr ⟨xa,xb⟩⟩)
    dsimp [U]
    have := uniform a ha
    have := uniform b hb
    omega
  have eg := outside_one U g (uniform g hg) uv ug vg (Finset.mem_union_left _ ua) (Finset.mem_union_right _ vb)
  have ek := outside_one U k (uniform k hk) wz wk zk (Finset.mem_union_left _ wa) (Finset.mem_union_right _ zb)
  let S := U ∪ (g \ U) ∪ (k \ U)
  have small : S.card ≤ 7 := by
    have c₁ := Finset.card_union_le U (g \ U)
    have c₂ := Finset.card_union_le (U ∪ (g \ U)) (k \ U)
    dsimp only [S]
    omega
  have incl : ({a,b,g,k} : Finset _) ⊆ H.filter (fun t ↦ t ⊆ S) := by
    simp only [Finset.insert_subset_iff,Finset.singleton_subset_iff,Finset.mem_filter]
    exact ⟨⟨ha,by dsimp [S,U]; grind⟩,⟨hb,by dsimp [S,U]; grind⟩,
      ⟨hg,by dsimp [S]; grind⟩,⟨hk,by dsimp [S]; grind⟩⟩
  have cnt := Finset.card_le_card incl
  have four : ({a,b,g,k} : Finset _).card=4 := by simp [ab,ag,ak,bg,bk,gk]
  have bad := free.card_filter_lt_four hn S small
  omega

end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.cross_card Erdos810.ShadowRoot.link_sum
