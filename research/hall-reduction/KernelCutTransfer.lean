import ShadowMoments

/-! # Finite cut-distance transfer for edges, wedges, and triangles -/

set_option autoImplicit false
namespace Erdos810.KernelCut
open ShadowFlags
variable {V : Type*} [Fintype V] [Nonempty V]
abbrev Kernel (V : Type*) := V → V → ℝ

def UnitVal (f : V → ℝ) := ∀ x, f x∈Set.Icc (0:ℝ) 1
def UnitKernel (A : Kernel V) := ∀ x y, A x y∈Set.Icc (0:ℝ) 1
noncomputable def bil (A : Kernel V) (f g : V → ℝ) :=
  avg (fun x ↦ avg (fun y ↦ A x y*f x*g y))
noncomputable def ind (S : Finset V) (x : V) : ℝ := by classical exact if x∈S then 1 else 0

def Close (A B : Kernel V) (η : ℝ) := ∀ S T : Finset V,
  |bil (fun x y ↦ A x y-B x y) (ind S) (ind T)|≤η

private theorem maximize (K : Kernel V) (f g : V → ℝ) (hf : UnitVal f) :
    ∃ S : Finset V, bil K f g ≤ bil K (ind S) g := by
  classical
  let h := fun x ↦ avg (fun y ↦ K x y*g y)
  let S := Finset.univ.filter (fun x ↦ 0≤h x)
  refine ⟨S,?_⟩
  have factor (w : V → ℝ) : bil K w g=avg (fun x ↦ w x*h x) := by
    unfold bil
    apply avg_congr
    intro x
    rw [show (fun y ↦ K x y*w x*g y)=(fun y ↦ w x*(K x y*g y)) by funext y; ring,avg_scale]
  rw [factor,factor]
  apply avg_mono
  intro x
  by_cases hx : 0≤h x
  · simp [ind,S,hx]
    exact mul_le_of_le_one_left hx (hf x).2
  · simp [ind,S,hx]
    exact mul_nonpos_of_nonneg_of_nonpos (hf x).1 (le_of_not_ge hx)

private theorem bil_swap (K : Kernel V) (f g : V → ℝ) :
    bil K f g=bil (fun x y ↦ K y x) g f := by
  unfold bil
  rw [avg_swap]
  exact avg_congr (fun y ↦ avg_congr (fun x ↦ by ring))

private theorem maximize_both (K : Kernel V) (f g : V → ℝ) (hf : UnitVal f) (hg : UnitVal g) :
    ∃ S T : Finset V, bil K f g≤bil K (ind S) (ind T) := by
  obtain ⟨S,hs⟩ := maximize K f g hf
  obtain ⟨T,ht⟩ := maximize (fun x y ↦ K y x) g (ind S) hg
  rw [← bil_swap K (ind S) g,← bil_swap K (ind S) (ind T)] at ht
  exact ⟨S,T,hs.trans ht⟩

theorem weighted {A B : Kernel V} {η : ℝ} (close : Close A B η) (f g : V → ℝ)
    (hf : UnitVal f) (hg : UnitVal g) : |bil (fun x y ↦ A x y-B x y) f g|≤η := by
  let H := fun x y ↦ A x y-B x y
  have neg (f g : V → ℝ) : bil (fun x y ↦ -H x y) f g = (-1)*bil H f g := by
    unfold bil
    simp only [show ∀ x y, -H x y*f x*g y=(-1)*(H x y*f x*g y) by intros; ring,avg_scale]
  obtain ⟨S,T,plus⟩ := maximize_both H f g hf hg
  obtain ⟨S',T',minus⟩ := maximize_both (fun x y ↦ -H x y) f g hf hg
  rw [neg,neg] at minus
  change |bil H f g|≤η
  have p := (abs_le.mp (close S T)).2
  have m := (abs_le.mp (close S' T')).1
  change _≤bil H (ind S') (ind T') at m
  exact abs_le.mpr ⟨by linarith only [m,minus],plus.trans p⟩

noncomputable def cycle (A B C : Kernel V) :=
  avg (fun z ↦ avg (fun x ↦ avg (fun y ↦ A x y*B y z*C z x)))

theorem rotate (A B C : Kernel V) : cycle A B C=cycle B C A := by
  unfold cycle
  rw [avg_swap (fun z x ↦ avg (fun y ↦ A x y*B y z*C z x))]
  apply avg_congr
  intro x
  rw [avg_swap (fun z y ↦ A x y*B y z*C z x)]
  exact avg_congr (fun y ↦ avg_congr (fun z ↦ by ring))

private theorem first {A B : Kernel V} {η : ℝ} (close : Close A B η)
    (P Q : Kernel V) (hp : UnitKernel P) (hq : UnitKernel Q) :
    |cycle A P Q-cycle B P Q|≤η := by
  have eq : cycle A P Q-cycle B P Q =
      avg (fun z ↦ bil (fun x y ↦ A x y-B x y) (fun x ↦ Q z x) (fun y ↦ P y z)) := by
    unfold cycle bil
    simp only [← avg_sub]
    apply avg_congr
    intro z
    apply avg_congr
    intro x
    exact avg_congr (fun y ↦ by ring)
  rw [eq]
  calc
    _ ≤ _ := Finset.abs_expect_le _ _
    _ ≤ avg (fun _ : V ↦ η) := avg_mono (fun z ↦ weighted close _ _ (hq z) (fun y ↦ hp y z))
    _ = _ := avg_const η

theorem triangle {A B : Kernel V} {η : ℝ} (close : Close A B η)
    (ha : UnitKernel A) (hb : UnitKernel B) : |cycle A A A-cycle B B B|≤3*η := by
  have h₁ := abs_le.mp (first close A A ha ha)
  have h₂ := abs_le.mp (first close A B ha hb)
  have h₃ := abs_le.mp (first close B B hb hb)
  rw [← rotate B A A,← rotate B B A] at h₂
  rw [rotate A B B] at h₃
  exact abs_le.mpr ⟨by linarith [h₁.1,h₂.1,h₃.1],by linarith [h₁.2,h₂.2,h₃.2]⟩

private theorem wedge_eq (A : Kernel V) (sym : ∀ x y,A x y=A y x) :
    cycle (fun _ _ ↦ 1) A A=avg (fun x ↦ (deg A x)^2) := by
  unfold cycle deg
  apply avg_congr
  intro z
  simp only [one_mul]
  have atX (x : V) : avg (fun y ↦ A y z*A z x) = A z x*avg (A z) := by
    rw [← avg_scale]
    exact avg_congr (fun y ↦ by rw [sym y z]; ring)
  simp only [atX]
  rw [show (fun x ↦ A z x*avg (A z))=(fun x ↦ avg (A z)*A z x) by funext x; ring,avg_scale]
  ring

theorem wedge {A B : Kernel V} {η : ℝ} (close : Close A B η) (ha : UnitKernel A)
    (hb : UnitKernel B) (sa : ∀ x y,A x y=A y x) (sb : ∀ x y,B x y=B y x) :
    |avg (fun x ↦ (deg A x)^2)-avg (fun x ↦ (deg B x)^2)|≤2*η := by
  let I : Kernel V := fun _ _ ↦ 1
  have hi : UnitKernel I := fun _ _ ↦ ⟨by norm_num [I],by norm_num [I]⟩
  rw [← wedge_eq A sa,← wedge_eq B sb]
  change |cycle I A A-cycle I B B|≤_
  have h₁ := abs_le.mp (first close A I ha hi)
  have h₂ := abs_le.mp (first close I B hi hb)
  rw [← rotate I A A,← rotate I B A] at h₁
  rw [rotate A I B,rotate B I B] at h₂
  exact abs_le.mpr ⟨by linarith [h₁.1,h₂.1],by linarith [h₁.2,h₂.2]⟩

theorem cycle_tri (A : Kernel V) (sym : ∀ x y,A x y=A y x) :
    cycle A A A=edge A (common A) := by
  unfold cycle edge common
  rw [avg_swap (fun z x ↦ avg (fun y ↦ A x y*A y z*A z x))]
  apply avg_congr
  intro x
  rw [avg_swap (fun z y ↦ A x y*A y z*A z x)]
  apply avg_congr
  intro y
  rw [← avg_scale]
  exact avg_congr (fun z ↦ by rw [sym z x]; ring)

theorem edge_difference {A B : Kernel V} {η : ℝ} (close : Close A B η) :
    |2*density A-2*density B|≤η := by
  have u : UnitVal (fun _ : V ↦ (1:ℝ)) := fun _ ↦ ⟨zero_le_one,le_rfl⟩
  have h := weighted close _ _ u u
  simp only [bil,mul_one,avg_sub] at h
  simpa only [← edge_one,edge,mul_one] using h

end Erdos810.KernelCut
assert_no_sorry Erdos810.KernelCut.weighted
assert_no_sorry Erdos810.KernelCut.triangle
assert_no_sorry Erdos810.KernelCut.wedge
