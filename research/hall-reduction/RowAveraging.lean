import KernelCutTransfer

/-! # Orthogonal averaging on finite row classes, including unequal class sizes -/

set_option autoImplicit false
namespace Erdos810.RowAverage
open ShadowFlags KernelCut
variable {V : Type*} [Fintype V] [Nonempty V]

noncomputable def fiber (P : V → ℕ) (x : V) := Finset.univ.filter (fun z ↦ P z=P x)
noncomputable def weight (P : V → ℕ) (x z : V) : ℝ :=
  if P z=P x then (Fintype.card V:ℝ)/(fiber P x).card else 0
noncomputable def project (P : V → ℕ) (f : V → ℝ) (x : V) :=
  avg (fun z ↦ weight P x z*f z)
def ConstantOn (P : V → ℕ) (f : V → ℝ) := ∀ x z, P z=P x → f z=f x
def Refines (Q P : V → ℕ) := ∀ x z, Q z=Q x → P z=P x
noncomputable def model (P : V → ℕ) (G : Kernel V) (x y : V) := project P (fun z ↦ G z y) x
noncomputable def mean (G : Kernel V) := avg (fun x ↦ avg (G x))
noncomputable def energy (P : V → ℕ) (G : Kernel V) := mean (fun x y ↦ (model P G x y)^2)

private theorem same_fiber {P : V → ℕ} {x z : V} (h : P z=P x) : fiber P z=fiber P x := by simp [fiber,h]

theorem weight_symm (P : V → ℕ) (x z : V) : weight P x z=weight P z x := by
  by_cases h : P z=P x
  · simp [weight,h,same_fiber h]
  · simp [weight,h,Ne.symm h]

theorem weight_nonneg (P : V → ℕ) (x z : V) : 0≤weight P x z := by unfold weight; split <;> positivity

theorem weight_sum (P : V → ℕ) (x : V) : avg (weight P x)=1 := by
  classical
  have n0 : (Fintype.card V:ℝ)≠0 := by exact_mod_cast Fintype.card_ne_zero
  have fx : x∈fiber P x := Finset.mem_filter.mpr ⟨Finset.mem_univ _,rfl⟩
  have f0 : ((fiber P x).card:ℝ)≠0 := by exact_mod_cast (Finset.card_pos.mpr ⟨x,fx⟩).ne'
  rw [avg_div_card]
  simp only [weight,←Finset.sum_filter,Finset.sum_const,nsmul_eq_mul]
  change ((fiber P x).card:ℝ)*((Fintype.card V:ℝ)/(fiber P x).card)/(Fintype.card V:ℝ)=1
  field_simp

theorem project_constant (P : V → ℕ) (f : V → ℝ) : ConstantOn P (project P f) := by
  intro x z h
  unfold project
  exact avg_congr (fun y ↦ by simp [weight,h,same_fiber h])

theorem fixed {P : V → ℕ} {f : V → ℝ} (h : ConstantOn P f) (x : V) : project P f x=f x := by
  have eq (z : V) : weight P x z*f z=f x*weight P x z := by
    by_cases same : P z=P x
    · rw [h x z same,mul_comm]
    · simp [weight,same]
  simp only [project,eq,avg_scale,weight_sum,mul_one]

theorem adjoint (P : V → ℕ) (f g : V → ℝ) :
    avg (fun x ↦ project P f x*g x)=avg (fun x ↦ f x*project P g x) := by
  unfold project
  calc
    _ = avg (fun x ↦ avg (fun z ↦ g x*(weight P x z*f z))) :=
      avg_congr (fun x ↦ by rw [avg_scale]; ring)
    _ = _ := avg_swap _
    _ = _ := by
      apply avg_congr
      intro z
      rw [← avg_scale]
      exact avg_congr (fun x ↦ by rw [weight_symm P x z]; ring)

theorem multiply_fixed {P : V → ℕ} {f : V → ℝ} (h : ConstantOn P f) (G : Kernel V) (g : V → ℝ) :
    mean (fun x y ↦ model P G x y*f x*g y)=mean (fun x y ↦ G x y*f x*g y) := by
  unfold mean
  rw [avg_swap (fun x y ↦ model P G x y*f x*g y),avg_swap (fun x y ↦ G x y*f x*g y)]
  apply avg_congr
  intro y
  have left := adjoint P (fun x ↦ G x y) f
  simp only [fixed h] at left
  simp only [mul_comm _ (g y),avg_scale]
  exact congrArg (fun r ↦ g y*r) left

theorem model_unit (P : V → ℕ) (G : Kernel V) (hu : UnitKernel G) : UnitKernel (model P G) := by
  intro x y
  constructor
  · exact avg_nonneg (fun z ↦ mul_nonneg (weight_nonneg P x z) (hu z y).1)
  · exact (avg_mono (fun z ↦ mul_le_of_le_one_right (weight_nonneg P x z) (hu z y).2)).trans (weight_sum P x).le

theorem energy_bounds (P : V → ℕ) (G : Kernel V) (hu : UnitKernel G) : energy P G ∈ Set.Icc (0:ℝ) 1 := by
  have hm := model_unit P G hu
  refine ⟨avg_nonneg (fun x ↦ avg_nonneg (fun y ↦ sq_nonneg _)),?_⟩
  have sqr (x y : V) : (model P G x y)^2≤1 := (sq_le_one_iff₀ (hm x y).1).mpr (hm x y).2
  exact (avg_mono (fun x ↦ (avg_mono (sqr x)).trans (avg_const 1).le)).trans (avg_const 1).le

private theorem common_factor {R P : V → ℕ} (ref : Refines R P) (G : Kernel V) (y : V) :
    avg (fun x ↦ model R G x y*model P G x y)=avg (fun x ↦ (model P G x y)^2) := by
  have constantP := project_constant P (fun x ↦ G x y)
  have constantR : ConstantOn R (fun x ↦ model P G x y) := fun x z h ↦ constantP x z (ref x z h)
  have a := adjoint R (fun x ↦ G x y) (fun x ↦ model P G x y)
  have b := adjoint P (fun x ↦ G x y) (fun x ↦ model P G x y)
  simp only [fixed constantR] at a
  have fixedP : ∀ x, project P (fun z ↦ model P G z y) x = model P G x y := fixed constantP
  simp only [fixedP] at b
  simpa only [model,sq] using a.trans b.symm

theorem orthogonal {R P : V → ℕ} (ref : Refines R P) (G : Kernel V) :
    mean (fun x y ↦ (model R G x y-model P G x y)^2) = energy R G-energy P G := by
  unfold energy mean
  rw [avg_swap (fun x y ↦ (model R G x y-model P G x y)^2),
    avg_swap (fun x y ↦ (model R G x y)^2),avg_swap (fun x y ↦ (model P G x y)^2),← avg_sub]
  apply avg_congr
  intro y
  have eq (x : V) : (model R G x y-model P G x y)^2 =
      (model R G x y)^2-2*(model R G x y*model P G x y)+(model P G x y)^2 := by ring
  rw [show (fun x ↦ (model R G x y-model P G x y)^2)=_ from funext eq,avg_add,avg_sub,avg_scale,common_factor ref]
  ring

end Erdos810.RowAverage
assert_no_sorry Erdos810.RowAverage.orthogonal
assert_no_sorry Erdos810.RowAverage.energy_bounds
