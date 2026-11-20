import QuarterDensity
import KernelShadowModel
import ShadowCuts
import LinearCleanup

/-! # Half-bounded symmetric models for the shadow and the one-eighteenth theorem -/

set_option autoImplicit false
open Filter SimpleGraph
namespace Erdos810.RowAverage
open ShadowFlags KernelCut
variable {V : Type*} [Fintype V]

private theorem cut_le_mean (D : Kernel V) (pos : ∀ x y,0≤D x y) (X Y : Finset V) :
    cutMass D X Y ≤ mean D := by
  apply avg_mono
  intro x
  apply avg_mono
  intro y
  by_cases hx : x∈X <;> by_cases hy : y∈Y <;> simp [ind,hx,hy,pos]

private theorem transpose_cut (D : Kernel V) (X Y : Finset V) :
    cutMass (fun x y ↦ D y x) X Y=cutMass D Y X := by
  unfold cutMass mean
  rw [avg_swap]
  exact avg_congr (fun y ↦ avg_congr (fun x ↦ by ring))

private theorem sym_cut (D : Kernel V) (X Y : Finset V) :
    cutMass (fun x y ↦ (D x y+D y x)/2) X Y=(cutMass D X Y+cutMass D Y X)/2 := by
  calc
    _ = (cutMass D X Y+cutMass (fun x y ↦ D y x) X Y)/2 := by
      unfold cutMass mean
      simp only [div_eq_inv_mul,add_mul,mul_assoc,avg_add,avg_scale]
    _ = _ := congrArg (fun r ↦ (cutMass D X Y+r)/2) (transpose_cut D X Y)

variable [Nonempty V]

/-- Clip the row approximation and average with its transpose. This gives a
symmetric finite kernel with every entry at most one half. -/
theorem symmetric_half_model (G : Kernel V) (sg : ∀ x y,G x y=G y x) (hu : UnitKernel G)
    {δ ζ : ℝ} (dp : 0<δ) (low : LowModel G δ ζ) :
    ∃ W : Kernel V, (∀ x y,W x y=W y x) ∧ (∀ x y,0≤W x y) ∧
      (∀ x y,W x y≤1/2) ∧ Close G W (ζ+2*δ) := by
  classical
  obtain ⟨P,K,fs,small,cuts⟩ := low
  let code := fun x ↦ (⟨P x,fs x⟩:Fin K)
  let A := model P G
  let B := fun x y ↦ min (A x y) (1/2)
  let Y := marked code A (1/2+δ)
  let M := fun x y ↦ ind (Y (code x)) y
  let D := fun x y ↦ A x y-B x y
  have au := model_unit P G hu
  have positive (x y : V) : 0≤D x y := sub_nonneg.mpr (min_le_left ..)
  have bm (x y : V) : 0≤B x y := le_min (au x y).1 (by norm_num)
  have bh (x y : V) : B x y≤1/2 := min_le_right ..
  have markedMass := sum_cuts code Y (fun _ _ ↦ (1:ℝ))
  simp only [cut_constant,one_mul] at markedMass
  change highArea P K fs A δ=mean M at markedMass
  have atCell (x y : V) : D x y ≤ δ+M x y := by
    by_cases large : 1/2+δ<A x y
    · have mem : y∈Y (code x) := by
        simp only [Y,marked,Finset.mem_filter,Finset.mem_univ,true_and]
        exact ⟨x,rfl,large⟩
      have one : M x y=1 := by simp [M,ind,mem]
      have diff : D x y≤1 := by change A x y-B x y≤1; linarith only [(au x y).2,bm x y]
      rw [one]
      linarith only [diff,dp]
    · have mp : 0≤M x y := by unfold M ind; split <;> norm_num
      have d : D x y≤δ := by
        unfold D B
        rw [min_def]
        split <;> linarith only [dp,le_of_not_gt large]
      linarith only [d,mp]
  have total := avg_mono (fun x ↦ avg_mono (atCell x))
  simp only [avg_add,avg_const] at total
  change mean D ≤ δ+mean M at total
  have cost : mean D≤2*δ := by linarith only [total,markedMass,small]
  have clip (X Y' : Finset V) : |cutMass G X Y'-cutMass B X Y'|≤ζ+2*δ := by
    have diff := cut_sub A B X Y'
    have lo := cut_mono_on B A X Y' (fun _ _ _ _ ↦ min_le_left ..)
    have hi := cut_le_mean D positive X Y'
    change cutMass D X Y'=cutMass A X Y'-cutMass B X Y' at diff
    have hc := abs_le.mp (cuts X Y')
    change _ ≤ cutMass A X Y'-cutMass G X Y' ∧ _ at hc
    exact abs_le.mpr ⟨by linarith only [hc.2,lo,dp],by linarith only [hc.1,hi,diff,cost]⟩
  refine ⟨fun x y ↦ (B x y+B y x)/2,fun x y ↦ by ring,
    fun x y ↦ by linarith only [bm x y,bm y x],fun x y ↦ by linarith only [bh x y,bh y x],?_⟩
  intro X Y'
  change |cutMass (fun x y ↦ G x y-(B x y+B y x)/2) X Y'|≤_
  rw [cut_sub,sym_cut]
  have gs : cutMass G X Y'=cutMass G Y' X := by
    simpa only [show (fun x y ↦ G y x)=G from funext (fun x ↦ funext (fun y ↦ sg y x))] using transpose_cut G X Y'
  have c₁ := abs_le.mp (clip X Y')
  have c₂ := abs_le.mp (clip Y' X)
  exact abs_le.mpr ⟨by linarith only [c₁.1,c₂.1,gs],by linarith only [c₁.2,c₂.2,gs]⟩

end Erdos810.RowAverage
namespace Erdos810
open RowAverage KernelCut ShadowRoot

theorem sevenFourNumber_eventually_one_eighteenth (ε : ℝ) (ep : 0<ε) :
    ∀ᶠ n : ℕ in atTop, (sevenFourNumber n:ℝ)≤(1/18+ε)*(n:ℝ)^2 := by
  obtain ⟨N,hN⟩ := exists_nat_ge (2/ε)
  filter_upwards [low_models (ε/20) (ε/20) (by positivity) (by positivity),
    eventually_ge_atTop (max 7 N)] with n models large
  have hn : 7≤n := (le_max_left ..).trans large
  have n0 : 0<n := by omega
  letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
  have nr : 0<(n:ℝ) := by exact_mod_cast n0
  obtain ⟨H,card,uniform,free⟩ := exists_extremal_sevenFourNumber n
  obtain ⟨R,sub,lin,loss⟩ := exists_linear_rest hn free uniform
  have ur := fun t ht ↦ uniform t (sub ht)
  have fr := sevenFourFree_of_subset free sub
  obtain ⟨C,hp,hr⟩ := linear_coloring hn ur fr lin
  have good : LowModel (W R) (ε/20) (ε/20) := models _ C hp hr
  obtain ⟨U,us,u0,uh,close⟩ := symmetric_half_model (W R) (W_symm R)
    (fun x y ↦ ⟨W_nonneg R x y,W_le_one R x y⟩) (show 0<ε/20 by positivity) good
  have bound := finite_shadow_of_model hn ur fr lin U us u0 uh _ close
  have main := (div_le_iff₀ (sq_pos_of_pos nr)).mp bound
  have edge : 2*(H.card:ℝ)≤2*(R.card:ℝ)+n := by exact_mod_cast loss
  have big : (2/ε:ℝ)≤n := hN.trans (by exact_mod_cast (le_max_right 7 N).trans large)
  have budget := mul_le_mul_of_nonneg_right ((div_le_iff₀ ep).mp big) nr.le
  have iden : (1/(3*(n:ℝ)))*(n:ℝ)^2=(n:ℝ)/3 := by field_simp
  rw [← card]
  linarith only [main,edge,budget,iden]

end Erdos810
#assert_no_sorry Erdos810.sevenFourNumber_eventually_one_eighteenth
