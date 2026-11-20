import CutRayleigh

/-! # Stability of the spectral obstruction under sparse deletion -/

set_option autoImplicit false
open Filter SimpleGraph
namespace Erdos810.SupportSpectrum
variable {n : ℕ}
attribute [local instance] Classical.propDecidable

private noncomputable def bit (G : SimpleGraph (Fin n)) (p : Fin n × Fin n) : ℝ :=
  if G.Adj p.1 p.2 then 1 else 0

private theorem form_pairs (G : SimpleGraph (Fin n)) (f : Fin n → ℝ) :
    form G f = ∑ p : Fin n × Fin n,bit G p*(f p.1*f p.2) := by
  classical
  unfold form
  calc
    _ = ∑ p ∈ Finset.univ.filter (fun p : Fin n × Fin n ↦ G.Adj p.1 p.2), f p.1*f p.2 := by
      apply Finset.sum_bij (fun d _ ↦ d.toProd)
      · intro d _; simp
      · intro d _ e _ eq; exact Dart.ext _ _ eq
      · intro p hp; exact ⟨⟨p,(Finset.mem_filter.mp hp).2⟩,Finset.mem_univ _,rfl⟩
      · intro d _; rfl
    _ = _ := by rw [Finset.sum_filter]; simp only [bit,ite_mul,one_mul,zero_mul]

private theorem sum_bit (G : SimpleGraph (Fin n)) : (∑ p,bit G p)=2*(G.edgeSet.ncard:ℝ) := by
  have h := form_pairs G (fun _ ↦ 1)
  simp only [mul_one,form,Finset.sum_const,Finset.card_univ,nsmul_eq_mul,
    G.dart_card_eq_twice_card_edges,Nat.cast_mul,Nat.cast_ofNat] at h
  simpa only [← G.coe_edgeFinset,Set.ncard_coe_finset] using h.symm

theorem rate_range (hn : 0<n) (G : SimpleGraph (Fin n)) : rate G∈Set.Icc (0:ℝ) 1 := by
  unfold rate
  refine ⟨by positivity,(div_le_one (sq_pos_of_pos (show 0<(n:ℝ) by exact_mod_cast hn))).mpr ?_⟩
  rw [← sum_bit]
  have cap := Finset.sum_le_sum (s := Finset.univ) (fun p _ ↦ show bit G p≤1 by unfold bit; split <;> norm_num)
  simpa [sq] using cap

/-- Deleting at most (θn)²/2 edges changes every normalized Rayleigh quotient by at most θ. -/
theorem spectral_delete {G F : SimpleGraph (Fin n)} (sub : F≤G) {η θ : ℝ} (θ0 : 0≤θ)
    (loss : 2*((G.edgeSet.ncard:ℝ)-F.edgeSet.ncard)≤(θ*(n:ℝ))^2)
    (low : spectralLower G η) : spectralLower F (η+θ) := by
  intro f
  let d (p : Fin n × Fin n) := bit G p-bit F p
  let z (p : Fin n × Fin n) := f p.1*f p.2
  let v := ∑ x,f x^2
  have id (p : Fin n × Fin n) : d p^2=d p := by
    by_cases a : F.Adj p.1 p.2
    · simp [d,bit,a,sub a]
    · by_cases b : G.Adj p.1 p.2 <;> simp [d,bit,a,b]
  have count : (∑ p,d p^2)=2*((G.edgeSet.ncard:ℝ)-F.edgeSet.ncard) := by
    simp only [id,d,Finset.sum_sub_distrib,sum_bit]; ring
  have norm : (∑ p,z p^2)=v^2 := by
    dsimp [z,v]
    rw [Fintype.sum_prod_type]
    simp_rw [mul_pow]
    rw [← Finset.sum_mul_sum, sq]
  have delta : (∑ p,d p*z p)=form G f-form F f := by
    simp only [form_pairs,d,z,sub_mul,Finset.sum_sub_distrib]
  have cs := Finset.sum_mul_sq_le_sq_mul_sq Finset.univ d z
  rw [count,norm,delta] at cs
  have sq : (form G f-form F f)^2≤(θ*(n:ℝ)*v)^2 :=
    (cs.trans (mul_le_mul_of_nonneg_right loss (sq_nonneg v))).trans_eq (mul_pow ..).symm
  have v0 : 0≤v := Finset.sum_nonneg (fun _ _ ↦ sq_nonneg _)
  have ab : |form G f-form F f|≤θ*(n:ℝ)*v := (sq_le_sq₀ (abs_nonneg _) (by positivity)).mp
    (by simpa only [sq_abs] using sq)
  have diff := (le_abs_self _).trans ab
  have h := low f
  change -η*(n:ℝ)*v ≤ _ at h
  change -(η+θ)*(n:ℝ)*v ≤ _
  linarith only [diff,h]

/-- Includes improper colorings. The error tends uniformly to zero for fixed η. -/
theorem unrestricted_spectral (η ε : ℝ) (hη : 0≤η) (hε : 0<ε) :
    ∀ᶠ n : ℕ in atTop, ∀ (G : SimpleGraph (Fin n)) (C : G.EdgeLabeling (Fin n)),
      C.IsRainbowFor (cycleGraph 4) → spectralLower G η →
      rate G*(rate G-1/2)≤η*(1-rate G)+ε := by
  let θ := min 1 (ε/(4+η))
  have den : 0<4+η := by linarith
  have tp : 0<θ := lt_min (by norm_num) (div_pos hε den)
  have t1 : θ≤1 := min_le_left ..
  have small : θ*(4+η)≤ε := (le_div_iff₀ den).mp (min_le_right ..)
  filter_upwards [proper_subgraph_sparse_loss (θ^2/2) (by positivity),eventually_gt_atTop (0:ℕ)] with n del hn
  intro G C rain low
  obtain ⟨F,sub,hp,rainF,count⟩ := del (Fin n) G C rain
  have N : 0<(n:ℝ) := by exact_mod_cast hn
  have loss : 2*((G.edgeSet.ncard:ℝ)-F.edgeSet.ncard)≤(θ*(n:ℝ))^2 := by nlinarith only [count]
  have lowerF := spectral_delete sub tp.le loss low
  have u := proper_spectral hn F (C.pullback (Hom.ofLE sub)) hp rainF (add_nonneg hη tp.le) lowerF
  let r := rate G
  let t := rate F
  have rg := rate_range hn G
  have rf := rate_range hn F
  have diff : r-t≤θ^2 := by
    dsimp [r,t,rate]
    rw [← sub_div]
    apply (div_le_iff₀ (sq_pos_of_pos N)).mpr
    nlinarith only [loss]
  have d0 : 0≤r-t := by
    have le : F.edgeSet.ncard≤G.edgeSet.ncard := Set.ncard_le_ncard (edgeSet_mono sub)
    dsimp [r,t,rate]
    rw [← sub_div]
    have cast : (F.edgeSet.ncard:ℝ)≤G.edgeSet.ncard := by exact_mod_cast le
    exact div_nonneg (by linarith only [cast]) (sq_nonneg _)
  have diff' : r-t≤θ := diff.trans (by nlinarith only [mul_nonneg tp.le (sub_nonneg.mpr t1)])
  have square : r*r-t*t≤2*θ := by
    have cap : r+t≤2 := by linarith [rg.2,rf.2]
    nlinarith only [mul_le_mul_of_nonneg_left cap d0,diff']
  have changeη := mul_le_mul_of_nonneg_left diff' hη
  have outside : θ*(1-t)≤θ := mul_le_of_le_one_right tp.le (by linarith [rf.1])
  change t*(t-1/2)≤(η+θ)*(1-t) at u
  change r*(r-1/2)≤η*(1-r)+ε
  nlinarith only [u,square,changeη,outside,d0,small,tp.le]

end Erdos810.SupportSpectrum
#assert_no_sorry Erdos810.SupportSpectrum.unrestricted_spectral
