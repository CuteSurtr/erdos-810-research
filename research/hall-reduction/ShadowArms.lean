import ShadowRoot
import ShadowMoments
import ShadowLocal

/-! # The shadow cut defect at an actual member of a linear triple system -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open ShadowFlags ShadowGap
variable {n : ℕ} {H : Finset (Finset (Fin n))}

theorem W_mem {t : Finset (Fin n)} (ht : t ∈ H) {x y : Fin n}
    (xy : x ≠ y) (hx : x ∈ t) (hy : y ∈ t) : W H x y = 1 := by
  classical exact if_pos (show (twoShadow H).Adj x y from ⟨xy,t,ht,hx,hy⟩)

@[simp] theorem W_diag (x : Fin n) : W H x x = 0 := by
  classical simp [W]

theorem normalized_degree (uniform : ∀ t ∈ H, t.card = 3) (hl : ∀ t ∈ H, IsLinearMember H t)
    (x : Fin n) : deg (W H) x = 2*((inc H x).card:ℝ)/n := by
  have eq := link_sum hl x (fun _ ↦ 1)
  have card (t : Finset (Fin n)) (ht : t ∈ inc H x) : (t.erase x).card=2 := by
    obtain ⟨ht,xt⟩ := Finset.mem_filter.mp ht
    rw [Finset.card_erase_of_mem xt,uniform t ht]
  simp only [mul_one,Finset.sum_const, nsmul_eq_mul,mul_one] at eq
  have count := Finset.sum_congr (s₁ := inc H x) rfl (fun t ht ↦
    show ((t.erase x).card:ℝ) = 2 by rw [card t ht]; norm_num)
  rw [deg,avg_div_card,Fintype.card_fin,eq,count]
  simp [mul_comm]

noncomputable def rawCommon (H : Finset (Finset (Fin n))) (x y : Fin n) : ℝ :=
  ∑ v, W H x v*W H y v

theorem common_eq (x y : Fin n) : common (W H) x y = rawCommon H x y/n := by
  simp only [common,rawCommon,avg_div_card,Fintype.card_fin]

theorem common_swap (x y : Fin n) : common (W H) x y=common (W H) y x :=
  avg_congr (fun u ↦ mul_comm _ _)

theorem cross_sum (hn : 7 ≤ n) (uniform : ∀ t ∈ H, t.card = 3) (free : SevenFourFree H)
    (hl : ∀ t ∈ H, IsLinearMember H t) {a b : Finset (Fin n)} {x : Fin n}
    (ha : a ∈ H) (hb : b ∈ H) (ab : a ≠ b) (xa : x ∈ a) (xb : x ∈ b) :
    (∑ u ∈ a.erase x, ∑ v ∈ b.erase x, W H u v) ≤ 1 := by
  classical
  have card := cross_card hn uniform free hl ha hb ab xa xb
  let F := (a.erase x) ×ˢ (b.erase x)
  have count : (∑ uv ∈ F, W H uv.1 uv.2) =
      ((F.filter (fun uv : Fin n × Fin n ↦ (twoShadow H).Adj uv.1 uv.2)).card:ℝ) := by
    simp [W,Finset.sum_boole]
  rw [← Finset.sum_product' (a.erase x) (b.erase x) (fun u v ↦ W H u v)]
  change (∑ uv ∈ F, W H uv.1 uv.2) ≤ 1
  rw [count]
  exact_mod_cast card

theorem common_lower {x y z : Fin n} (he : {x,y,z} ∈ H) (xz : x ≠ z) (yz : y ≠ z) :
    1 ≤ rawCommon H x y := by
  have h := Finset.single_le_sum (f := fun u ↦ W H x u*W H y u)
    (fun u _ ↦ mul_nonneg (W_nonneg H x u) (W_nonneg H y u)) (Finset.mem_univ z)
  change W H x z*W H y z ≤ rawCommon H x y at h
  rw [W_mem he xz (by simp) (by simp),W_mem he yz (by simp) (by simp),one_mul] at h
  exact h

theorem arm (hn : 7 ≤ n) (uniform : ∀ t ∈ H, t.card = 3) (free : SevenFourFree H)
    (hl : ∀ t ∈ H, IsLinearMember H t) {x y z : Fin n} (he : {x,y,z} ∈ H)
    (xy : x ≠ y) (xz : x ≠ z) (yz : y ≠ z) :
    rawCommon H x y+rawCommon H x z ≤ (inc H x).card+1 := by
  classical
  let e : Finset (Fin n) := {x,y,z}
  have xe : x ∈ e := by simp [e]
  have ie : e ∈ inc H x := Finset.mem_filter.mpr ⟨he,xe⟩
  have er : e.erase x = {y,z} := by ext u; simp [e]; grind
  let F := fun t : Finset (Fin n) ↦ ∑ u ∈ t.erase x, (W H y u+W H z u)
  have yzedge : W H y z=1 := W_mem he yz (by simp) (by simp)
  have zyedge : W H z y=1 := W_mem he yz.symm (by simp) (by simp)
  have base : F e=2 := by simp [F,er,yz,yzedge,zyedge]; norm_num
  have bound (t : Finset (Fin n)) (ht : t ∈ (inc H x).erase e) : F t ≤ 1 := by
    obtain ⟨te,ti⟩ := Finset.mem_erase.mp ht
    obtain ⟨mem,xt⟩ := Finset.mem_filter.mp ti
    have b := cross_sum hn uniform free hl he mem te.symm xe xt
    change (∑ u ∈ e.erase x, ∑ v ∈ t.erase x, W H u v) ≤ 1 at b
    simpa only [er,Finset.sum_insert (by simpa using yz : y ∉ ({z} : Finset _)),
      Finset.sum_singleton,F,Finset.sum_add_distrib] using b
  have tail := Finset.sum_le_sum bound
  simp only [Finset.sum_const,nsmul_eq_mul,mul_one] at tail
  have cnt : ((inc H x).erase e).card+1=(inc H x).card := Finset.card_erase_add_one ie
  have realcnt : (((inc H x).erase e).card:ℝ)+1=(inc H x).card := by exact_mod_cast cnt
  have eq := link_sum hl x (fun u ↦ W H y u+W H z u)
  simp only [mul_add,Finset.sum_add_distrib] at eq
  change rawCommon H x y+rawCommon H x z = _ at eq
  have all : rawCommon H x y+rawCommon H x z=∑ t ∈ inc H x, F t := by
    simpa only [F,Finset.sum_add_distrib] using eq
  rw [all,← Finset.sum_erase_add _ F ie,base]
  linarith only [tail,realcnt]

end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.arm Erdos810.ShadowRoot.normalized_degree
