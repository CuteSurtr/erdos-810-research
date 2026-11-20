import RowAveraging

/-! # A finite weak cut approximation by splitting row classes -/

set_option autoImplicit false
namespace Erdos810.RowAverage
open ShadowFlags KernelCut
variable {V : Type*} [Fintype V] [Nonempty V]

noncomputable def cutMass (G : Kernel V) (X Y : Finset V) := mean (fun x y ↦ G x y*ind X x*ind Y y)
def Fits (P : V → ℕ) (K : ℕ) := ∀ x,P x<K
noncomputable def splitRow (P : V → ℕ) (X : Finset V) (x : V) :=
  by classical exact 2*P x+if x∈X then 1 else 0

theorem refine_trans {R Q P : V → ℕ} (hr : Refines R Q) (hq : Refines Q P) : Refines R P :=
  fun x z h ↦ hq x z (hr x z h)

private theorem split_facts (P : V → ℕ) (X : Finset V) (K : ℕ) (fits : Fits P K) :
    Refines (splitRow P X) P ∧ ConstantOn (splitRow P X) (ind X) ∧ Fits (splitRow P X) (2*K) := by
  classical
  constructor
  · intro x z h
    unfold splitRow at h
    split at h <;> split at h <;> omega
  constructor
  · intro x z h
    unfold splitRow at h
    by_cases hx : x∈X <;> by_cases hz : z∈X <;> simp [ind,hx,hz] at * <;> omega
  · intro x
    unfold splitRow
    split <;> have := fits x <;> omega

theorem avg_square (f : V → ℝ) : (avg f)^2≤avg (fun x ↦ (f x)^2) := by
  let p := avg f
  have var := avg_nonneg (fun x ↦ sq_nonneg (f x-p))
  have eq (x : V) : (f x-p)^2=(f x)^2-(2*p)*f x+p^2 := by ring
  simp only [eq,avg_add,avg_sub,avg_scale,avg_const] at var
  change 0≤avg (fun x ↦ f x^2)-2*p*p+p^2 at var
  change p^2≤_
  linarith only [var]

theorem square_mean (U : Kernel V) : (mean U)^2≤mean (fun x y ↦ (U x y)^2) :=
  (avg_square (fun x ↦ avg (U x))).trans (avg_mono (fun x ↦ avg_square (U x)))

theorem cut_square (G : Kernel V) (X Y : Finset V) : (cutMass G X Y)^2≤mean (fun x y ↦ (G x y)^2) := by
  apply (square_mean _).trans
  apply avg_mono
  intro x
  apply avg_mono
  intro y
  by_cases hx : x∈X <;> by_cases hy : y∈Y <;> simp [ind,hx,hy,sq_nonneg]

theorem cut_sub (A B : Kernel V) (X Y : Finset V) :
    cutMass (fun x y ↦ A x y-B x y) X Y=cutMass A X Y-cutMass B X Y := by
  simp only [cutMass,mean,sub_mul,avg_sub]

/-- A failed cut gains its squared discrepancy in the energy of one extra split. -/
theorem deficient (P : V → ℕ) (K : ℕ) (hp : Fits P K) (G : Kernel V)
    (X Y : Finset V) (γ : ℝ) (g0 : 0≤γ) (bad : γ < |cutMass (model P G) X Y-cutMass G X Y|) :
    let R := splitRow P X
    Refines R P ∧ Fits R (2*K) ∧ energy P G+γ^2≤energy R G := by
  obtain ⟨ref,cons,fits⟩ := split_facts P X K hp
  refine ⟨ref,fits,?_⟩
  have exactCut := multiply_fixed cons G (ind Y)
  change cutMass (model (splitRow P X) G) X Y = cutMass G X Y at exactCut
  have sq := cut_square (fun x y ↦ model (splitRow P X) G x y-model P G x y) X Y
  rw [cut_sub,exactCut,orthogonal ref] at sq
  have lower := pow_le_pow_left₀ g0 bad.le 2
  rw [sq_abs] at lower
  linarith only [sq,lower]

def BelowCuts (U G : Kernel V) (γ : ℝ) :=
  ∀ X Y : Finset V,cutMass U X Y≤cutMass G X Y+γ

def BothCuts (U G : Kernel V) (γ : ℝ) :=
  ∀ X Y : Finset V,|cutMass U X Y-cutMass G X Y|≤γ

theorem both_below {U G : Kernel V} {γ : ℝ} (h : BothCuts U G γ) : BelowCuts U G γ := by
  intro X Y
  linarith only [(abs_le.mp (h X Y)).2]

private theorem iterate (G : Kernel V) (γ : ℝ) (g0 : 0≤γ) (d : ℕ) (P : V → ℕ) (K : ℕ)
    (fits : Fits P K) : ∃ R : V → ℕ, Refines R P ∧ Fits R (K*2^d) ∧
    (BothCuts (model R G) G γ ∨ energy P G+(d:ℝ)*γ^2≤energy R G) := by
  classical
  induction d generalizing P K with
  | zero => exact ⟨P,fun _ _ h ↦ h,by simpa using fits,Or.inr (by simp)⟩
  | succ d ih =>
    by_cases okay : BothCuts (model P G) G γ
    · exact ⟨P,fun _ _ h ↦ h,fun x ↦ (fits x).trans_le
        (Nat.le_mul_of_pos_right K (pow_pos (by decide) _)),Or.inl okay⟩
    · unfold BothCuts at okay
      push_neg at okay
      obtain ⟨X,Y,h⟩ := okay
      obtain ⟨ref,fs,inc⟩ := deficient P K fits G X Y γ g0 (by linarith only [h])
      obtain ⟨R,rr,rf,rc⟩ := ih (splitRow P X) (2*K) fs
      refine ⟨R,refine_trans rr ref,?_,?_⟩
      · convert rf using 1
        ring
      · rcases rc with done | gain
        · exact Or.inl done
        · right
          rw [Nat.cast_succ]
          linarith only [gain,inc]

theorem weak (G : Kernel V) (hu : UnitKernel G) {γ : ℝ} (g0 : 0<γ) (P : V → ℕ)
    (K : ℕ) (fits : Fits P K) (d : ℕ) (enough : 1<(d:ℝ)*γ^2) :
    ∃ R : V → ℕ, Refines R P ∧ Fits R (K*2^d) ∧ BothCuts (model R G) G γ := by
  obtain ⟨R,hr,fs,path⟩ := iterate G γ g0.le d P K fits
  refine ⟨R,hr,fs,path.resolve_right ?_⟩
  have p := (energy_bounds P G hu).1
  have r := (energy_bounds R G hu).2
  linarith only [p,r,enough]

end Erdos810.RowAverage
assert_no_sorry Erdos810.RowAverage.weak
