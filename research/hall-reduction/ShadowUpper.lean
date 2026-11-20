import ShadowBlocks
import ShadowScatter

/-! # Upper missing-edge counts summed over all triples -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open ShadowFlags ShadowGap
variable {n : ℕ} {H : Finset (Finset (Fin n))} [Nonempty (Fin n)]

theorem q_formula (x y : Fin n) :
    q (W H) x y=pairDefect (hd H x) (hd H y) (common (W H) x y) := by
  have diff := codegree_diff (W H) x y
  unfold q equalPair pairDefect hd
  linarith only [diff]

theorem q_swap (x y : Fin n) : q (W H) x y=q (W H) y x := by
  rw [q_formula,q_formula,common_swap x y]
  unfold pairDefect
  ring

theorem hd_le_half (x : Fin n) : hd H x≤1/2 := by
  have low := avg_mono (fun y : Fin n ↦ W_le_one H x y)
  rw [avg_const] at low
  change avg (W H x)/2 ≤ 1/2
  linarith only [low]

theorem root_estimates_with {α β : ℝ} (ok : ScatterOK α β) (hn : 7≤n) (unif : ∀ t ∈ H, t.card=3) (free : SevenFourFree H)
    (hl : ∀ t ∈ H, IsLinearMember H t) {e : Finset (Fin n)} (he : e∈H) :
    0≤pairs e (q (W H)) ∧ pairs e (q (W H))≤defect H e ∧
    pairs e (fun x y ↦ common (W H) x y*q (W H) x y)≤(4/9)*defect H e ∧
    pairs e (fun x y ↦ common (W H) x y*q (W H) x y)≤
      (α+1/(n:ℝ))*defect H e+β*∑ x ∈ e, (dev (W H) x)^2 := by
  obtain ⟨x,y,z,xy,xz,yz,rfl⟩ := Finset.card_eq_three.mp (unif e he)
  have nr : 0<(n:ℝ) := by exact_mod_cast (show 0<n by omega)
  have rotate (a b c : Fin n) : ({a,b,c}:Finset _)={b,c,a} := by ext u; simp; tauto
  have he₂ : {y,z,x}∈H := rotate x y z ▸ he
  have he₃ : {z,x,y}∈H := rotate y z x ▸ he₂
  have lower {a b c : Fin n} (m : {a,b,c}∈H) (ac : a≠c) (bc : b≠c) :
      1/(n:ℝ)≤common (W H) a b := by
    rw [common_eq]
    exact div_le_div_of_nonneg_right (common_lower m ac bc) nr.le
  have upper {a b c : Fin n} (m : {a,b,c}∈H) (ab : a≠b) (ac : a≠c) (bc : b≠c) :
      common (W H) a b+common (W H) c a≤hd H a+1/(n:ℝ) := by
    rw [common_swap c a,common_eq,common_eq,hd,normalized_degree unif hl]
    have h := arm hn unif free hl m ab ac bc
    field_simp [nr.ne']
    linarith only [h]
  have nonneg : 0≤q (W H) x y+q (W H) y z+q (W H) z x := by
    rw [monochrome]
    have n₁ : 0≤zeroTriple (W H) x y z := avg_nonneg (fun u ↦ mul_nonneg
      (mul_nonneg (sub_nonneg.mpr (W_le_one H x u)) (sub_nonneg.mpr (W_le_one H y u)))
      (sub_nonneg.mpr (W_le_one H z u)))
    have n₂ : 0≤allTriple (W H) x y z := avg_nonneg (fun u ↦ mul_nonneg
      (mul_nonneg (W_nonneg H x u) (W_nonneg H y u)) (W_nonneg H z u))
    linarith only [n₁,n₂]
  have qa := nonneg
  simp only [q_formula] at qa
  have ax := upper he xy xz yz
  have ay := upper he₂ yz xy.symm xz.symm
  have az := upper he₃ xz.symm yz.symm xy
  rw [add_comm] at ay az
  have h0 : 0≤1/(n:ℝ) := by positivity
  have a := lower he xz yz
  have b := lower he₂ xy.symm xz.symm
  have c := lower he₃ yz.symm xy
  have simple := local_defect h0 a b c ax ay az qa
  have strong := local_scatter_with ok (r := density (W H)) h0 a b c ax ay az qa
  have df : defect H {x,y,z}=rootDefect (1/(n:ℝ)) (hd H x) (hd H y) (hd H z) := by
    simp [defect,rootDefect,xy,xz,yz]; ring
  have sQ := pairs_three (q (W H)) (q_swap (H := H)) xy xz yz
  have sC := pairs_three (fun a b ↦ common (W H) a b*q (W H) a b)
    (fun a b ↦ congrArg₂ (·*·) (common_swap (H := H) a b) (q_swap (H := H) a b)) xy xz yz
  rw [sQ,sC,df]
  refine ⟨nonneg,?_,?_,?_⟩
  · simpa only [q_formula] using simple.2.1
  · simpa only [q_formula] using simple.2.2
  · simpa [q_formula,xy,xz,yz,dev,hd,add_assoc] using strong

theorem root_estimates (hn : 7≤n) (unif : ∀ t ∈ H, t.card=3) (free : SevenFourFree H)
    (hl : ∀ t ∈ H, IsLinearMember H t) {e : Finset (Fin n)} (he : e∈H) :
    0≤pairs e (q (W H)) ∧ pairs e (q (W H))≤defect H e ∧
    pairs e (fun x y ↦ common (W H) x y*q (W H) x y)≤(4/9)*defect H e ∧
    pairs e (fun x y ↦ common (W H) x y*q (W H) x y)≤
      (5/17+1/(n:ℝ))*defect H e+(30/17)*∑ x ∈ e, (dev (W H) x)^2 := by
  exact root_estimates_with (α := 5/17) (β := 30/17) (by norm_num [ScatterOK]) hn unif free hl he

omit [Nonempty (Fin n)] in
/-- Integrating a function over ordered edges and dividing by two gives
r times its expectation at a uniform edge. -/
theorem scaled_mean (hr : 0<density (W H)) (f : Fin n → Fin n → ℝ) :
    density (W H)*edgeMean (W H) f=edge (W H) f/2 := by
  unfold edgeMean
  field_simp [hr.ne']

theorem upper_estimates_with {α β : ℝ} (ok : ScatterOK α β) (hn : 7≤n) (unif : ∀ t ∈ H, t.card=3) (free : SevenFourFree H)
    (hl : ∀ t ∈ H, IsLinearMember H t) (hr : 0<density (W H)) :
    0≤mass H (defect H) ∧ 1/3≤edgeMean (W H) (equalPair (W H)) ∧
    density (W H)*(edgeMean (W H) (equalPair (W H))-1/3)≤mass H (defect H) ∧
    edge (W H) (miss (W H))/2≤2*mass H (defect H)/3 ∧
    edge (W H) (miss (W H))/2≤(3/2)*((α+1/(n:ℝ))*mass H (defect H)+(β/2)*variance (W H)) := by
  let S := W H
  let F := fun x y ↦ common S x y*q S x y
  have all := fun e he ↦ root_estimates_with ok hn unif free hl (e := e) he
  have n₀ := mass_le (H := H) (fun e he ↦ (all e he).1)
  have n₁ := mass_le (H := H) (fun e he ↦ (all e he).2.1)
  have n₂ := mass_le (H := H) (fun e he ↦ (all e he).2.2.1)
  have n₃ := mass_le (H := H) (fun e he ↦ (all e he).2.2.2)
  rw [mass_const,zero_mul,mass_edges hl] at n₀
  rw [mass_edges hl] at n₁
  rw [mass_edges hl,mass_scale] at n₂
  rw [mass_edges hl,mass_add,mass_scale,mass_scale,mass_vertices (by omega) unif hl] at n₃
  have cap := avg_mono (fun x : Fin n ↦
    mul_le_mul_of_nonneg_right (hd_le_half (H := H) x) (sq_nonneg (dev S x)))
  rw [avg_scale] at cap
  change _ ≤ (1/2)*variance S at cap
  have count := missing_bound S (W_symm H) (W_nonneg H)
  have mq : edgeMean S (q S)=edgeMean S (equalPair S)-1/3 := by
    change edgeMean S (fun x y ↦ equalPair S x y-1/3)=_
    rw [em_sub,em_const S hr]
  have scale := scaled_mean hr (q S)
  rw [mq] at scale
  have mean : 0≤edgeMean S (equalPair S)-1/3 :=
    nonneg_of_mul_nonneg_right (by rw [scale]; exact n₀) hr
  refine ⟨n₀.trans n₁,by linarith only [mean],scale.trans_le n₁,?_,?_⟩
  · linarith only [count,n₂]
  · change edge S (miss S)/2 ≤ (3/2)*((α+1/(n:ℝ))*mass H (defect H)+(β/2)*variance S)
    change edge S F/2 ≤ _ at n₃
    change 2*edge S (miss S) ≤ 3*edge S F at count
    have lift := mul_le_mul_of_nonneg_left cap ok.2.1.le
    nlinarith only [count,n₃,lift]

theorem upper_estimates (hn : 7≤n) (unif : ∀ t ∈ H, t.card=3) (free : SevenFourFree H)
    (hl : ∀ t ∈ H, IsLinearMember H t) (hr : 0<density (W H)) :
    0≤mass H (defect H) ∧ 1/3≤edgeMean (W H) (equalPair (W H)) ∧
    density (W H)*(edgeMean (W H) (equalPair (W H))-1/3)≤mass H (defect H) ∧
    edge (W H) (miss (W H))/2≤2*mass H (defect H)/3 ∧
    edge (W H) (miss (W H))/2≤(3/2)*((5/17)*(mass H (defect H)+3*variance (W H))+
      (1/(n:ℝ))*mass H (defect H)) := by
  obtain ⟨a,b,c,d,e⟩ := upper_estimates_with (α := 5/17) (β := 30/17)
    (by norm_num [ScatterOK]) hn unif free hl hr
  exact ⟨a,b,c,d,by linarith only [e]⟩

end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.upper_estimates
