import RowWeakRegularity

/-! # Areas, sums, and high-density rectangles in a row partition -/

set_option autoImplicit false
namespace Erdos810.RowAverage
open ShadowFlags KernelCut
variable {V ι : Type*} [Fintype V] [Nonempty V] [Fintype ι]
noncomputable def portion (X : Finset V) := (X.card:ℝ)/(Fintype.card V:ℝ)
noncomputable def rows (code : V → ι) (i : ι) : Finset V := by
  classical exact Finset.univ.filter (fun x ↦ code x=i)
noncomputable def marked (code : V → ι) (A : Kernel V) (t : ℝ) (i : ι) : Finset V := by
  classical exact Finset.univ.filter (fun y ↦ ∃ x,code x=i ∧ t<A x y)

theorem ind_avg (X : Finset V) : avg (ind X)=portion X := by
  classical
  simp [avg_div_card,ind,portion,←Finset.sum_filter]

theorem portion_range (X : Finset V) : portion X∈Set.Icc (0:ℝ) 1 := by
  rw [← ind_avg]
  constructor
  · exact avg_nonneg (fun _ ↦ by unfold ind; split <;> norm_num)
  · exact (avg_mono (fun x ↦ show ind X x≤1 by unfold ind; split <;> norm_num)).trans (avg_const 1).le

theorem cut_constant (s : ℝ) (X Y : Finset V) : cutMass (fun _ _ ↦ s) X Y=s*portion X*portion Y := by
  simp only [cutMass,mean,avg_scale,ind_avg,mul_assoc]
  rw [show (fun x ↦ ind X x*portion Y)=(fun x ↦ portion Y*ind X x) by funext x; ring,avg_scale,ind_avg]
  ring

theorem cut_mono_on (F G : Kernel V) (X Y : Finset V) (le : ∀ x∈X,∀ y∈Y,F x y≤G x y) :
    cutMass F X Y≤cutMass G X Y := by
  apply avg_mono
  intro x
  apply avg_mono
  intro y
  by_cases hx : x∈X <;> by_cases hy : y∈Y <;> simp [ind,hx,hy,le]

private theorem sum_avg (f : ι → V → ℝ) :
    (∑ i,avg (f i))=avg (fun x ↦ ∑ i,f i x) := by
  simp only [avg_div_card,← Finset.sum_div]
  rw [Finset.sum_comm]

theorem sum_cuts (code : V → ι) (Y : ι → Finset V) (F : Kernel V) :
    (∑ i,cutMass F (rows code i) (Y i))=mean (fun x y ↦ F x y*ind (Y (code x)) y) := by
  classical
  unfold cutMass mean
  simp only [sum_avg]
  apply avg_congr
  intro x
  apply avg_congr
  intro y
  rw [Finset.sum_eq_single (code x)]
  · simp [rows,ind]
  · intro i _ hi
    simp [rows,ind,Ne.symm hi]
  · simp

theorem portion_sum (code : V → ι) : (∑ i,portion (rows code i))=1 := by
  have h := sum_cuts code (fun _ ↦ Finset.univ) (fun _ _ ↦ (1:ℝ))
  simp only [cut_constant,one_mul,portion,Finset.card_univ,div_self (by positivity : (Fintype.card V:ℝ)≠0),mul_one,
    ind,Finset.mem_univ,if_true,mean,avg_const] at h
  exact h

theorem sum_cuts_le (code : V → ι) (Y : ι → Finset V) (F : Kernel V) (pos : ∀ x y,0≤F x y) :
    (∑ i,cutMass F (rows code i) (Y i))≤mean F := by
  rw [sum_cuts]
  apply avg_mono
  intro x
  apply avg_mono
  intro y
  by_cases h : y∈Y (code x) <;> simp [ind,h,pos]

theorem marked_area (code : V → ι) (A : Kernel V) (hu : UnitKernel A) {t δ : ℝ}
    (t0 : 0≤t) (high : t+δ≤mean A) :
    δ ≤ ∑ i, portion (rows code i)*portion (marked code A t i) := by
  classical
  let Y := marked code A t
  have atCell (x y : V) : A x y≤t+ind (Y (code x)) y := by
    by_cases h : A x y≤t
    · exact h.trans (le_add_of_nonneg_right (by unfold ind; split <;> norm_num))
    · have member : y∈Y (code x) := Finset.mem_filter.mpr ⟨Finset.mem_univ _,x,rfl,lt_of_not_ge h⟩
      simp [ind,member]
      linarith only [(hu x y).2,t0]
  have integrated := avg_mono (fun x ↦ avg_mono (atCell x))
  simp only [avg_add,avg_const] at integrated
  change mean A ≤ t+mean (fun x y ↦ ind (Y (code x)) y) at integrated
  have a := sum_cuts code Y (fun _ _ ↦ (1:ℝ))
  simp only [cut_constant,one_mul] at a
  change δ≤∑ i, portion (rows code i)*portion (Y i)
  linarith only [high,integrated,a]

theorem model_mean (P : V → ℕ) (G : Kernel V) : mean (model P G)=mean G := by
  have h := multiply_fixed (P := P) (f := fun _ ↦ (1:ℝ)) (fun _ _ _ ↦ rfl) G (fun _ ↦ 1)
  simpa only [mul_one] using h

theorem row_exact (P : V → ℕ) (G : Kernel V) (K : ℕ) (fs : Fits P K) (i : Fin K)
    (B : Finset V) : let X := rows (fun x ↦ (⟨P x,fs x⟩:Fin K)) i
      cutMass (model P G) X B=cutMass G X B := by
  classical
  have cons : ConstantOn P (ind (rows (fun x ↦ (⟨P x,fs x⟩:Fin K)) i)) := by
    intro x z h
    simp [ind,rows,Fin.ext_iff,h]
  exact multiply_fixed cons G (ind B)

theorem on_marked (P : V → ℕ) (G : Kernel V) (K : ℕ) (fs : Fits P K) (i : Fin K)
    (t : ℝ) : let code := fun x ↦ (⟨P x,fs x⟩:Fin K)
      ∀ x∈rows code i,∀ y∈marked code (model P G) t i, t≤model P G x y := by
  classical
  intro code x hx y hy
  simp only [marked,Finset.mem_filter,Finset.mem_univ,true_and] at hy
  obtain ⟨z,hz,val⟩ := hy
  have xc : code x=i := by simpa only [rows,Finset.mem_filter,Finset.mem_univ,true_and] using hx
  have eq : P x=P z := congrArg Fin.val (xc.trans hz.symm)
  have same := project_constant P (fun u ↦ G u y) z x eq
  exact val.le.trans same.ge

end Erdos810.RowAverage
assert_no_sorry Erdos810.RowAverage.marked_area
assert_no_sorry Erdos810.RowAverage.row_exact
