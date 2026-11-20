import RowBoard
import RowClasses
import PartitionGain

/-! # Every row partition with many above-half cells has an energy increment -/

set_option autoImplicit false
namespace Erdos810.RowAverage
open ShadowFlags KernelCut SimpleGraph

noncomputable def highArea {V : Type*} [Fintype V] (P : V → ℕ) (K : ℕ) (fs : Fits P K) (A : Kernel V) (δ : ℝ) :=
  let code := fun x ↦ (⟨P x,fs x⟩:Fin K)
  ∑ i,portion (rows code i)*portion (marked code A (1/2+δ) i)

noncomputable def accuracy (δ : ℝ) (K : ℕ) := δ^4/(128*(K:ℝ)^2)

theorem refinement_gain {n : ℕ} (n0 : 0<n) (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n))
    (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) (P R : Fin n → ℕ)
    (K : ℕ) (fs : Fits P K) (ref : Refines R P) (δ : ℝ) (dp : 0<δ)
    (many : δ≤highArea P K fs (model P (board G)) δ)
    (sizeN : 1/(2*(n:ℝ))≤accuracy δ K)
    (reg : BelowCuts (model R (board G)) (board G) (accuracy δ K)) :
    energy P (board G)+(δ^3/32)^2≤energy R (board G) := by
  classical
  letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
  have np : (0:ℝ)<n := by exact_mod_cast n0
  have kp0 : 0<K := Nat.zero_lt_of_lt (fs ⟨0,n0⟩)
  have kp : (0:ℝ)<K := by exact_mod_cast kp0
  let code := fun x ↦ (⟨P x,fs x⟩:Fin K)
  let G₀ := board G
  let U := model P G₀
  let V := model R G₀
  let X := rows code
  let Y := marked code U (1/2+δ)
  let a := fun i ↦ portion (X i)
  let b := fun i ↦ portion (Y i)
  let e := fun i ↦ cutMass G₀ (X i) (Y i)
  let D := fun x y ↦ |V x y-U x y|
  let loss := fun i ↦ cutMass D (X i) (Y i)
  let S := Finset.univ.filter (fun i ↦ δ/(2*(K:ℝ))≤a i)
  have apos (i : Fin K) : 0≤a i := (portion_range (X i)).1
  have bpos (i : Fin K) : 0≤b i := (portion_range (Y i)).1
  have keep (i : Fin K) (hi : i∈S) : δ/(2*(K:ℝ))≤a i := (Finset.mem_filter.mp hi).2
  have allArea : δ≤∑ i,a i*b i := many
  have area := kept_area a b (K:ℝ) δ kp dp (by simp) apos (fun i ↦ (portion_range (Y i)).2) allArea
  have mass : (∑ i∈S,a i)≤1 := (Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ S)
    (fun i _ _ ↦ apos i)).trans (portion_sum code).le
  have edges (i : Fin K) (_ : i∈S) : a i*b i/2≤e i := by
    have tile := cut_mono_on (fun _ _ ↦ (1/2:ℝ)) U (X i) (Y i) (fun x hx y hy ↦
      (show 1/2≤1/2+δ by linarith).trans (on_marked P G₀ K fs i _ x hx y hy))
    rw [cut_constant,row_exact P G₀ K fs i (Y i)] at tile
    change (1/2)*a i*b i≤e i at tile
    linarith only [tile]
  have detect (i : Fin K) (_ : i∈S) :
      δ*(e i)^2≤δ^4/(64*(K:ℝ)^2)+1*a i*loss i := by
    have raw := normalized n0 G C hp hr V δ (accuracy δ K) dp.le reg (X i) (Y i)
    have deficit := cut_mono_on (fun x y ↦ max (1/2+δ-V x y) 0) D (X i) (Y i)
      (fun x hx y hy ↦ max_le (by
        have h := on_marked P G₀ K fs i _ x hx y hy
        have d : U x y-V x y≤D x y := by simpa only [D,abs_sub_comm] using le_abs_self (U x y-V x y)
        linarith only [h,d]) (abs_nonneg _))
    have cap := cut_mono_on G₀ (fun _ _ ↦ (1:ℝ)) (X i) (Y i) (fun x _ y _ ↦ (board_unit G x y).2)
    rw [cut_constant,one_mul] at cap
    have ab := mul_le_of_le_one_right (apos i) (portion_range (Y i)).2
    have boundE : e i≤1 := (cap.trans ab).trans (portion_range (X i)).2
    have rate := div_le_div_of_nonneg_right boundE (show 0≤2*(n:ℝ) by positivity)
    have z := mul_le_mul_of_nonneg_left deficit (apos i)
    have ratio : (X i).card/(n:ℝ)=a i := by simp [a,portion]
    rw [ratio] at raw
    change δ*(e i)^2≤e i/(2*n)+accuracy δ K+a i*cutMass _ (X i) (Y i) at raw
    change _≤a i*loss i at z
    have twice : accuracy δ K+accuracy δ K=δ^4/(64*(K:ℝ)^2) := by unfold accuracy; ring
    linarith only [raw,z,rate,sizeN,twice]
  have sc : (S.card:ℝ)≤K := by exact_mod_cast (Finset.card_le_univ S).trans (Fintype.card_fin K).le
  have gain := model_gain S a b e loss δ K 1 dp kp sc keep (fun i _ ↦ bpos i) mass area edges detect
  have lpos (i : Fin K) : 0≤loss i := by
    have h := cut_mono_on (fun _ _ ↦ (0:ℝ)) D (X i) (Y i) (fun _ _ _ _ ↦ abs_nonneg _)
    simpa [cut_constant,loss] using h
  have coverage := (Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ S) (fun i _ _ ↦ lpos i)).trans
    (sum_cuts_le code Y D (fun _ _ ↦ abs_nonneg _))
  have g : δ^3/32≤mean D := (by simpa using gain : δ^3/32≤∑ i∈S,loss i).trans coverage
  have sq := (pow_le_pow_left₀ (show 0≤δ^3/32 by positivity) g 2).trans (square_mean D)
  simp only [D,sq_abs] at sq
  change _≤mean (fun x y ↦ (model R G₀ x y-model P G₀ x y)^2) at sq
  rw [orthogonal ref] at sq
  linarith only [sq]

end Erdos810.RowAverage
#assert_no_sorry Erdos810.RowAverage.refinement_gain
