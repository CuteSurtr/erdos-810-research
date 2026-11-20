import RowGainProof

/-! # The one-quarter upper bound for unrestricted Erdős problem 810 -/

set_option autoImplicit false
open Filter SimpleGraph
namespace Erdos810.RowAverage
open KernelCut
variable {V : Type*} [Fintype V]

def LowModel (G : Kernel V) (δ ζ : ℝ) := ∃ (P : V → ℕ) (K : ℕ) (fs : Fits P K),
  highArea P K fs (model P G) δ < δ ∧ BothCuts (model P G) G ζ

private theorem steps {ε : ℝ} (ep : 0<ε) : ∃ d : ℕ, 1<(d:ℝ)*ε := by
  obtain ⟨d,hd⟩ := exists_nat_gt (1/ε)
  exact ⟨d,(div_lt_iff₀ ep).mp hd⟩

private theorem stage (δ ζ : ℝ) (dp : 0<δ) (zp : 0<ζ) (d K : ℕ) (kp0 : 0<K) :
    ∀ᶠ n : ℕ in atTop, ∀ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
    ProperAtVertices C → C.IsRainbowFor (cycleGraph 4) →
    ∀ (P : Fin n → ℕ) (fs : Fits P K), BothCuts (model P (board G)) (board G) ζ →
    LowModel (board G) δ ζ ∨ energy P (board G)+(d:ℝ)*(δ^3/32)^2≤1 := by
  induction d generalizing K with
  | zero =>
    filter_upwards [eventually_gt_atTop (0:ℕ)] with n hn
    letI : Nonempty (Fin n) := ⟨⟨0,hn⟩⟩
    intro G C hp hr P fs cuts
    exact Or.inr (by simpa using (energy_bounds P (board G) (board_unit G)).2)
  | succ d ih =>
    let γ := accuracy δ K
    have gp : 0<γ := by unfold γ accuracy; positivity
    have hmin : 0<min γ ζ := lt_min gp zp
    obtain ⟨w,hw⟩ := steps (sq_pos_of_pos hmin)
    let L := K*2^w
    have lp : 0<L := Nat.mul_pos kp0 (pow_pos (by decide) _)
    obtain ⟨N,hN⟩ := exists_nat_gt (1/γ)
    filter_upwards [ih L lp,eventually_ge_atTop N,eventually_gt_atTop (0:ℕ)] with n next hn n0
    letI : Nonempty (Fin n) := ⟨⟨0,n0⟩⟩
    have np : (0:ℝ)<n := by exact_mod_cast n0
    have nb : 1/γ<(n:ℝ) := hN.trans_le (by exact_mod_cast hn)
    have small : 1/(2*(n:ℝ))≤γ := by
      apply (div_le_iff₀ (show 0<2*(n:ℝ) by positivity)).mpr
      have bound := (div_lt_iff₀ gp).mp nb
      nlinarith only [bound]
    intro G C hp hr P fs cuts
    by_cases high : δ≤highArea P K fs (model P (board G)) δ
    · obtain ⟨R,ref,rf,cr⟩ := weak (board G) (board_unit G) hmin P K fs w hw
      have reg : BelowCuts (model R (board G)) (board G) γ := fun X Y ↦
        (both_below cr X Y).trans (add_le_add_left (min_le_left _ _) _)
      have remain : BothCuts (model R (board G)) (board G) ζ :=
        fun X Y ↦ (cr X Y).trans (min_le_right _ _)
      have gain := refinement_gain n0 G C hp hr P R K fs ref δ dp high small reg
      rcases next G C hp hr R rf remain with good | last
      · exact Or.inl good
      · right
        rw [Nat.cast_succ]
        linarith only [gain,last]
    · exact Or.inl ⟨P,K,fs,lt_of_not_ge high,cuts⟩

theorem low_models (δ ζ : ℝ) (dp : 0<δ) (zp : 0<ζ) :
    ∀ᶠ n : ℕ in atTop, ∀ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
    ProperAtVertices C → C.IsRainbowFor (cycleGraph 4) → LowModel (board G) δ ζ := by
  obtain ⟨w,hw⟩ := steps (sq_pos_of_pos zp)
  obtain ⟨d,hd⟩ := steps (show 0<(δ^3/32)^2 by positivity)
  filter_upwards [stage δ ζ dp zp d (1*2^w) (by positivity),eventually_gt_atTop (0:ℕ)] with n deep hn
  letI : Nonempty (Fin n) := ⟨⟨0,hn⟩⟩
  intro G C hp hr
  have fits : Fits (fun _ : Fin n ↦ 0) 1 := fun _ ↦ Nat.zero_lt_one
  obtain ⟨R,_,rf,reg⟩ := weak (board G) (board_unit G) zp _ 1 fits w hw
  apply (deep G C hp hr R rf reg).resolve_right
  have pos := (energy_bounds R (board G) (board_unit G)).1
  linarith only [hd,pos]

theorem mean_low [Nonempty V] {G : Kernel V} (hu : UnitKernel G) {δ ζ : ℝ} (dp : 0<δ)
    (low : LowModel G δ ζ) : mean G<1/2+2*δ := by
  obtain ⟨P,K,fs,small,_⟩ := low
  by_contra! high
  have h : (1/2+δ)+δ≤mean (model P G) := by rw [model_mean]; linarith only [high]
  have area := marked_area (fun x ↦ (⟨P x,fs x⟩:Fin K)) (model P G) (model_unit P G hu)
    (show 0≤1/2+δ by linarith) h
  exact (not_lt_of_ge area) small

end Erdos810.RowAverage
namespace Erdos810
open RowAverage

theorem maxRainbowC4Edges_eventually_one_quarter (ε : ℝ) (ep : 0<ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ)≤(1/4+ε)*(n:ℝ)^2 := by
  filter_upwards [low_models (ε/2) 1 (by positivity) (by norm_num),
    proper_subgraph_sparse_loss (ε/2) (by positivity),eventually_gt_atTop (0:ℕ)] with n models remove hn
  letI : Nonempty (Fin n) := ⟨⟨0,hn⟩⟩
  obtain ⟨G,hm,C,hr⟩ := le_maxRainbowC4Edges_iff.mp (le_refl (maxRainbowC4Edges n))
  obtain ⟨F,sub,hp,rainbow,count⟩ := remove (Fin n) G C hr
  have cap := mean_low (board_unit F) (show 0<ε/2 by positivity) (models F (C.pullback (Hom.ofLE sub)) hp rainbow)
  rw [full_board,Fintype.card_fin] at cap
  have nr : (0:ℝ)<n := by exact_mod_cast hn
  have ub := (div_lt_iff₀ (sq_pos_of_pos nr)).mp cap
  have lower : (maxRainbowC4Edges n:ℝ)≤G.edgeSet.ncard := by exact_mod_cast hm
  linarith only [count,ub,lower]

end Erdos810
#assert_no_sorry Erdos810.maxRainbowC4Edges_eventually_one_quarter
