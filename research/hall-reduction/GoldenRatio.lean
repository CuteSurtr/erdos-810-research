import RectangleBound

/-! # The golden-ratio upper coefficient for the rainbow-four-cycle problem -/

set_option autoImplicit false
open SimpleGraph Filter

namespace Erdos810

private noncomputable def endpointProfile (A u : ℝ) : ℝ :=
  u^2/2 + A*(u*(1-u))/(1+u*(1-u))

private noncomputable def endpointSlope (A r : ℝ) : ℝ :=
  1/2 + (A/(1+r*(1-r))^2-1/2)*(1-2*r)

/-- An explicit supporting line gives Jensen's inequality without differentiation. -/
private theorem profile_tangent {A r u : ℝ} (hA : 1 ≤ A) (hr : r ∈ Set.Icc (0:ℝ) 1)
    (hu : u ∈ Set.Icc (0:ℝ) 1) :
    endpointProfile A u ≤ endpointProfile A r + endpointSlope A r*(u-r) := by
  let z := u*(1-u)
  let t := r*(1-r)
  let p := A/(1+t)^2-1/2
  have zpos : 0 ≤ z := mul_nonneg hu.1 (sub_nonneg.mpr hu.2)
  have tpos : 0 ≤ t := mul_nonneg hr.1 (sub_nonneg.mpr hr.2)
  have tsmall : t ≤ 1/4 := by dsimp only [t]; nlinarith only [sq_nonneg (r-1/2)]
  have zd : 0 < 1+z := by linarith
  have td : 0 < 1+t := by linarith
  have slope : 0 ≤ p := by
    apply sub_nonneg.mpr
    apply (le_div_iff₀ (sq_pos_of_pos td)).mpr
    nlinarith only [hA, mul_nonneg (sub_nonneg.mpr tsmall) (show 0 ≤ 1/4+t+2 by linarith)]
  have exactGap : t/(1+t) + (z-t)/(1+t)^2 - z/(1+z) =
      (z-t)^2/((1+z)*(1+t)^2) := by field_simp [ne_of_gt zd, ne_of_gt td]; ring
  have hgap := div_nonneg (sq_nonneg (z-t)) (mul_nonneg zd.le (sq_nonneg (1+t)))
  have conc : z/(1+z) ≤ t/(1+t)+(z-t)/(1+t)^2 := by linarith
  have parabola : z-t ≤ (1-2*r)*(u-r) := by dsimp only [z,t]; nlinarith only [sq_nonneg (u-r)]
  calc
    endpointProfile A u = u/2 + (A*z/(1+z)-z/2) := by unfold endpointProfile z; ring
    _ ≤ u/2 + (A*t/(1+t)-t/2) + p*(z-t) := by
      calc
        _ = u/2+(A*(z/(1+z))-z/2) := by ring
        _ ≤ u/2+(A*(t/(1+t)+(z-t)/(1+t)^2)-z/2) :=
          add_le_add_left (sub_le_sub_right (mul_le_mul_of_nonneg_left conc (by linarith)) _) _
        _ = _ := by dsimp only [p]; ring
    _ ≤ u/2 + (A*t/(1+t)-t/2) + p*((1-2*r)*(u-r)) :=
      add_le_add_left (mul_le_mul_of_nonneg_left parabola slope) _
    _ = endpointProfile A r + endpointSlope A r*(u-r) := by unfold endpointProfile endpointSlope p t; ring

private theorem profile_rescale {N s : ℝ} (hN : 0 < N) (hs : 0 ≤ s) (hle : s ≤ N) :
    N^2 * endpointProfile (1+1/N) (s/N) =
      s^2/2 + N*(N+1)*s*(N-s)/(N^2+s*(N-s)) := by
  have h₁ : 0 < N^2+s*(N-s) := add_pos_of_pos_of_nonneg (sq_pos_of_pos hN) (mul_nonneg hs (sub_nonneg.mpr hle))
  have h₂ : 0 < 1+(s/N)*(1-s/N) := by
    have a := div_nonneg hs hN.le
    have b : s/N ≤ 1 := (div_le_one hN).mpr hle
    linarith only [mul_nonneg a (sub_nonneg.mpr b)]
  unfold endpointProfile
  field_simp [ne_of_gt hN, ne_of_gt h₁, ne_of_gt h₂]

private theorem class_degree_upper {n : ℕ} (hn : 0 < n) (G : SimpleGraph (Fin n))
    [DecidableRel G.Adj] (C : G.EdgeLabeling (Fin n)) (hp : ProperAtVertices C)
    (hr : C.IsRainbowFor (cycleGraph 4)) (c : Fin n) :
    ((∑ v ∈ colorSupport C c, G.degree v : ℕ) : ℝ) ≤
      (n:ℝ)^2 * endpointProfile (1+1/(n:ℝ)) ((colorSupport C c).card/(n:ℝ)) := by
  classical
  let S := colorSupport C c
  let T := Finset.univ \ S
  let s := S.card
  let I := (rectangle G S S).card
  let X := (rectangle G S T).card
  have hsn : s ≤ n := by simpa [s] using S.card_le_univ
  have hT : T.card = n-s := by simp [T,s,Finset.card_sdiff_of_subset (Finset.subset_univ _)]
  have hi : 2*I ≤ s^2 := internal_color_support C hp hr c
  have hx := rectangle_bound C hp hr S T
  rw [Fintype.card_fin, hT] at hx
  change (n*(s+(n-s))+s*(n-s))*X ≤ n*s*(n-s)*(s+(n-s)+1) at hx
  rw [Nat.add_sub_of_le hsn] at hx
  have hxr : ((n:ℝ)*n+(s:ℝ)*((n-s:ℕ):ℝ))*(X:ℝ) ≤
      (n:ℝ)*s*((n-s:ℕ):ℝ)*(n+1) := by exact_mod_cast hx
  rw [Nat.cast_sub hsn] at hxr
  have hnr : 0 < (n:ℝ) := by exact_mod_cast hn
  have hsr : (s:ℝ) ≤ n := by exact_mod_cast hsn
  have den : 0 < (n:ℝ)^2+(s:ℝ)*(n-s) :=
    add_pos_of_pos_of_nonneg (sq_pos_of_pos hnr) (mul_nonneg (by positivity) (sub_nonneg.mpr hsr))
  have cross : (X:ℝ) ≤ (n:ℝ)*(n+1)*s*(n-s)/(n^2+(s:ℝ)*(n-s)) := by
    apply (le_div_iff₀ den).mpr
    nlinarith only [hxr]
  have inner : 2*(I:ℝ) ≤ (s:ℝ)^2 := by exact_mod_cast hi
  have count := degree_sum_on_subset (G := G) S
  change (∑ v ∈ S, G.degree v) = I+X at count
  change ((∑ v ∈ S, G.degree v : ℕ):ℝ) ≤ (n:ℝ)^2*endpointProfile _ ((s:ℝ)/n)
  rw [count, Nat.cast_add, profile_rescale hnr (by positivity) hsr]
  linarith

/-- A finite polynomial inequality for twice the edge density of a proper coloring. -/
theorem proper_density_quadratic {n : ℕ} (hn : 0 < n) (G : SimpleGraph (Fin n))
    (C : G.EdgeLabeling (Fin n)) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) :
    let r := 2*(G.edgeSet.ncard:ℝ)/(n:ℝ)^2
    r^2+r ≤ 1+2/(n:ℝ) := by
  classical
  let N := (n:ℝ)
  let m := (G.edgeSet.ncard:ℝ)
  let r := 2*m/N^2
  let A := 1+1/N
  let s (c : Fin n) := ((colorSupport C c).card:ℝ)
  let u (c : Fin n) := s c / N
  let D (c : Fin n) := ((∑ v ∈ colorSupport C c, G.degree v : ℕ):ℝ)
  have pos : 0 < N := by dsimp only [N]; exact_mod_cast hn
  have nonzero : N ≠ 0 := ne_of_gt pos
  have upper (c : Fin n) : s c ≤ N := by
    have h := (colorSupport C c).card_le_univ
    rw [Fintype.card_fin] at h
    dsimp only [s,N]
    exact_mod_cast h
  have nonneg (c : Fin n) : 0 ≤ s c := by dsimp [s]; positivity
  have es : (∑ c, s c) = 2*m := by
    dsimp only [s,m]
    exact_mod_cast sum_color_support_sizes C hp
  have esBound := Finset.sum_le_sum (s := (Finset.univ : Finset (Fin n))) (fun c _ ↦ upper c)
  change (∑ c, s c) ≤ ∑ _c : Fin n, N at esBound
  rw [es, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at esBound
  have rangeR : r ∈ Set.Icc (0:ℝ) 1 := by
    constructor
    · dsimp [r,m]; positivity
    · apply (div_le_one (sq_pos_of_pos pos)).mpr
      simpa only [sq, N] using esBound
  have rangeU (c : Fin n) : u c ∈ Set.Icc (0:ℝ) 1 :=
    ⟨div_nonneg (nonneg c) pos.le, (div_le_one pos).mpr (upper c)⟩
  have mean : (∑ c, u c) = N*r := by
    unfold u
    rw [← Finset.sum_div, es]
    unfold r
    field_simp [nonzero]
  have cen : (∑ c, (u c-r)) = 0 := by
    rw [Finset.sum_sub_distrib, mean, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    exact sub_self _
  have Aone : 1 ≤ A := by dsimp [A]; linarith only [one_div_pos.mpr pos]
  have localBound (c : Fin n) :
      D c ≤ N^2*(endpointProfile A r + endpointSlope A r*(u c-r)) :=
    (class_degree_upper hn G C hp hr c).trans
      (mul_le_mul_of_nonneg_left (profile_tangent Aone rangeR (rangeU c)) (sq_nonneg N))
  have averaged := Finset.sum_le_sum (s := (Finset.univ : Finset (Fin n))) (fun c _ ↦ localBound c)
  rw [← Finset.mul_sum, Finset.sum_add_distrib, ← Finset.mul_sum, cen, mul_zero, add_zero,
    Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at averaged
  change (∑ c, D c) ≤ N^2*(N*endpointProfile A r) at averaged
  have hand := G.sum_degrees_eq_twice_card_edges
  have energy : (2*m)^2 ≤ N*(∑ c, D c) := by
    have h := sq_sum_le_card_mul_sum_sq (s := Finset.univ) (f := fun v ↦ G.degree v)
    rw [hand, Finset.card_univ, Fintype.card_fin, ← sum_degree_on_color_supports C hp] at h
    have hh : (2*G.edgeSet.ncard)^2 ≤ n*(∑ c, ∑ v ∈ colorSupport C c, G.degree v) := by
      rwa [← G.coe_edgeFinset, Set.ncard_coe_finset]
    dsimp only [m,N,D]
    exact_mod_cast hh
  have averaged' := energy.trans (mul_le_mul_of_nonneg_left averaged pos.le)
  have scale : 2*m = r*N^2 := by unfold r; field_simp [nonzero]
  rw [scale] at averaged'
  have bound : r^2 ≤ endpointProfile A r := by
    apply (mul_le_mul_iff_of_pos_left (pow_pos pos 4)).mp
    nlinarith only [averaged']
  have tpos : 0 ≤ r*(1-r) := mul_nonneg rangeR.1 (sub_nonneg.mpr rangeR.2)
  have denom : 0 < 1+r*(1-r) := by linarith
  have half : r^2/2 ≤ A*(r*(1-r))/(1+r*(1-r)) := by
    unfold endpointProfile at bound
    linarith
  have comp := (le_div_iff₀ denom).mp half
  change r^2+r ≤ 1+2/N
  by_cases hz : r = 0
  · rw [hz]
    linarith only [div_pos (by norm_num : (0:ℝ)<2) pos]
  have rpos : 0 < r := lt_of_le_of_ne rangeR.1 (Ne.symm hz)
  have poly : (2-r)*(r^2+r-1) ≤ (2/N)*(1-r) := by
    apply (mul_le_mul_iff_of_pos_left rpos).mp
    dsimp only [A] at comp
    simp only [div_eq_mul_inv] at comp ⊢
    nlinarith only [comp]
  have hconst : 0 ≤ 2/N := by positivity
  have right : (2/N)*(1-r) ≤ 2/N := by nlinarith only [mul_nonneg hconst rangeR.1]
  by_cases neg : r^2+r-1 ≤ 0
  · linarith
  · have hprod := mul_nonneg (sub_nonneg.mpr rangeR.2) (le_of_not_ge neg)
    nlinarith only [poly, right, hprod]

/-- For proper colorings the square-root coefficient has an explicit linear error. -/
theorem proper_golden_upper {n : ℕ} (hn : 0 < n) (G : SimpleGraph (Fin n))
    (C : G.EdgeLabeling (Fin n)) (hp : ProperAtVertices C) (hr : C.IsRainbowFor (cycleGraph 4)) :
    (G.edgeSet.ncard:ℝ) ≤ ((Real.sqrt 5-1)/4)*(n:ℝ)^2+n := by
  let N := (n:ℝ)
  let m := (G.edgeSet.ncard:ℝ)
  let r := 2*m/N^2
  let β := (Real.sqrt 5-1)/2
  have pos : 0 < N := by dsimp only [N]; exact_mod_cast hn
  have b := proper_density_quadratic hn G C hp hr
  change r^2+r ≤ 1+2/N at b
  have sqrtSq := Real.sq_sqrt (show (0:ℝ) ≤ 5 by norm_num)
  have root : β^2+β = 1 := by unfold β; nlinarith only [sqrtSq]
  have beta : 0 ≤ β := by
    have hs := Real.sqrt_nonneg (5:ℝ)
    dsimp only [β]
    nlinarith only [sqrtSq, hs]
  have rn : 0 ≤ r := by dsimp [r,m]; positivity
  have bound : r ≤ β+2/N := by
    by_cases below : r ≤ β
    · linarith only [below, div_pos (by norm_num : (0:ℝ)<2) pos]
    · have h := mul_nonneg (show 0 ≤ r-β by linarith) (add_nonneg rn beta)
      nlinarith only [b, root, h]
  have res := mul_le_mul_of_nonneg_right bound (sq_nonneg N)
  have scale : r*N^2 = 2*m := by unfold r; field_simp [ne_of_gt pos]
  rw [scale] at res
  have error : (2/N)*N^2 = 2*N := by field_simp [ne_of_gt pos]
  change m ≤ (Real.sqrt 5-1)/4*N^2+N
  dsimp only [β] at res
  nlinarith only [res, error]

/-- The golden-ratio coefficient for the original, unrestricted rainbow-C4 graph. -/
theorem maxRainbowC4Edges_eventually_golden (ε : ℝ) (he : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, (maxRainbowC4Edges n:ℝ) ≤ ((Real.sqrt 5-1)/4+ε)*(n:ℝ)^2 := by
  obtain ⟨k,hk⟩ := exists_nat_gt (2/ε)
  filter_upwards [proper_subgraph_sparse_loss (ε/2) (by positivity), eventually_ge_atTop k] with n cut hn
  have hn' : 2/ε < (n:ℝ) := hk.trans_le (by exact_mod_cast hn)
  have pos : 0 < (n:ℝ) := (div_pos (by norm_num) he).trans hn'
  have scale := (div_lt_iff₀ he).mp hn'
  have err := mul_le_mul_of_nonneg_right scale.le pos.le
  obtain ⟨G, hm, C, hr⟩ := le_maxRainbowC4Edges_iff.mp (le_refl (maxRainbowC4Edges n))
  obtain ⟨F, hFG, hp, hF, hcard⟩ := cut (Fin n) G C hr
  have bound := proper_golden_upper (show 0 < n by exact_mod_cast pos) F (C.pullback (Hom.ofLE hFG)) hp hF
  have hM : (maxRainbowC4Edges n:ℝ) ≤ (G.edgeSet.ncard:ℝ) := by exact_mod_cast hm
  nlinarith only [bound, hcard, hM, err]

end Erdos810

#assert_no_sorry Erdos810.proper_density_quadratic Erdos810.proper_golden_upper
  Erdos810.maxRainbowC4Edges_eventually_golden
