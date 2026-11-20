import RectangleLimit

/-! # Bounding a cut from the degrees at its row endpoints -/

set_option autoImplicit false
open Filter Topology SimpleGraph
namespace Erdos810
namespace RectangleSample
variable {n : ℕ} (H : RectangleSample n)

/-- Unlike the sum of the two endpoint inequalities, this only uses the row cut. -/
theorem normalized_row_energy (hn : 0 < n) :
    2*H.mass^2 ≤ H.a * ((∑ c, (H.k c^2 + H.k c/n + 2*(H.leftCut c).mass))/n) := by
  let K (c : Fin n) := (rectClass H.C H.L H.R c).card
  let X (c : Fin n) :=
    (rectangle H.G (matchedRows H.C H.L H.R c) (H.R \ matchedCols H.C H.L H.R c)).card
  let M := (rectangle H.G H.L H.R).card
  have N : 0 < (n:ℝ) := by exact_mod_cast hn
  have count : 2*M^2 ≤ H.L.card * ∑ c, (K c*(K c+1)+2*X c) :=
    rectangle_row_energy H.C H.proper H.rainbow H.L H.R
  have cast : 2*(M:ℝ)^2 ≤ (H.L.card:ℝ) * ∑ c, ((K c:ℝ)*(K c+1)+2*X c) := by
    exact_mod_cast count
  have per (c : Fin n) : H.k c^2 + H.k c/n + 2*(H.leftCut c).mass =
      ((K c:ℝ)*(K c+1)+2*X c)/(n:ℝ)^2 := by
    change ((K c:ℝ)/n)^2 + (K c:ℝ)/n/n + 2*((X c:ℝ)/(n:ℝ)^2) = _
    field_simp [N.ne']
  simp_rw [per]
  rw [← Finset.sum_div]
  change 2*((M:ℝ)/(n:ℝ)^2)^2 ≤ ((H.L.card:ℝ)/n)*(_/(n:ℝ)^2/n)
  field_simp [N.ne']
  nlinarith only [cast]

/-- Summing an affine upper bound removes its term centered at the mean matching size. -/
theorem row_average (hn : 0 < n) (v j ε : ℝ)
    (per : ∀ c : Fin n, H.k c^2 + 2*(H.leftCut c).mass ≤ v+j*(H.k c-H.mass)+ε) :
    2*H.mass^2 ≤ H.a*(v+H.mass/n+ε) := by
  have N : 0 < (n:ℝ) := by exact_mod_cast hn
  have sum := H.sum_k hn
  have centered : (∑ c, (H.k c-H.mass))=0 := by
    rw [Finset.sum_sub_distrib,sum,Finset.sum_const,Finset.card_univ,Fintype.card_fin,nsmul_eq_mul]
    ring
  have total := Finset.sum_le_sum (s := Finset.univ) (fun c _ ↦ per c)
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum,centered,mul_zero,add_zero,
    Finset.sum_const,Finset.card_univ,Fintype.card_fin,nsmul_eq_mul] at total
  refine (H.normalized_row_energy hn).trans (mul_le_mul_of_nonneg_left ?_ (H.range hn).1)
  apply (div_le_iff₀ N).mpr
  simp only [Finset.sum_add_distrib, ← Finset.sum_div, ← Finset.mul_sum,sum]
  field_simp [N.ne'] at *
  nlinarith only [total]

end RectangleSample

/-- Passing the directional inequality to a limiting sequence preserves the larger row side. -/
theorem RectangleLimit.row_profile (T : RectangleLimit) {P : ℝ → ℝ}
    (hu : UnitProfile P) (hc : Continuous P) (valid : ValidProfile P) (hm : 0 < T.m)
    (short : T.b < 4/5) :
    2*T.m^2 ≤ T.a*(T.m^2 + 2*matchingCut P T.b T.m) := by
  obtain ⟨ha,hb,hs,_,mz⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have a1 : T.a ≤ 1 := by linarith
  have b1 : T.b ≤ 1 := by linarith
  have mb := mz.trans (mul_le_of_le_one_left hb a1)
  have limitCut := matchingCut_tendsto hc hu T.sideB T.edges pb b1 hm.le mb
  have decay : Tendsto (fun i ↦ (T.sample i).mass/(T.orders i:ℝ)) atTop (𝓝 0) := by
    simpa only [one_div,div_eq_mul_inv,one_mul,mul_zero] using T.edges.mul T.inv_order_zero
  have eventuallyShort : ∀ᶠ i in atTop, (T.sample i).b < 4/5 :=
    T.sideB.eventually (gt_mem_nhds short)
  apply le_of_forall_pos_le_add
  intro ε hε
  have large := T.orders_top.eventually (valid (ε/2) (by positivity))
  have finite := ((large.and T.positive_orders).and eventuallyShort).mono (fun i ⟨⟨v,hn⟩,small⟩ ↦ by
    let H := T.sample i
    obtain ⟨_,b0,_,m0,_⟩ := H.range hn
    obtain ⟨j,tan⟩ := rowCut_tangent hu ⟨b0,small.le⟩ ⟨m0,(H.mass_le_sides hn).2⟩
    apply H.row_average hn (H.mass^2 + 2*matchingCut P H.b H.mass) j ε
    intro c
    have bound := v (H.leftCut c) trivial
    obtain ⟨row,col,_,_⟩ := H.cut_coordinates c
    rw [row,col,profileBound_cut] at bound
    obtain ⟨k0,_,kb⟩ := H.k_range c
    linarith only [tan _ ⟨k0,kb⟩, bound])
  have lhs := tendsto_const_nhds (x := (2:ℝ)) |>.mul (T.edges.pow 2)
  have rhs := T.sideA.mul ((((T.edges.pow 2).add ((tendsto_const_nhds (x := (2:ℝ))).mul limitCut)).add decay).add
    (tendsto_const_nhds (x := ε)))
  have result := le_of_tendsto_of_tendsto lhs rhs finite
  nlinarith only [result,mul_nonneg (sub_nonneg.mpr a1) hε.le]

/-- The one-sided cut test expressed with positive polynomial denominators. -/
theorem RectangleLimit.row_polynomial (T : RectangleLimit) {P : ℝ → ℝ}
    (hu : UnitProfile P) (hc : Continuous P) (valid : ValidProfile P)
    (hm : 0 < T.m) (short : T.b < 4/5) :
    (2-T.a)*T.m*(T.b+(1+T.b*P T.b)*T.m*(T.b-T.m)) ≤ 2*T.a*T.b*(T.b-T.m) := by
  obtain ⟨ha,hb,hs,_,mz⟩ := T.range
  obtain ⟨_,pb⟩ := T.positive_sides hm
  have a1 : T.a ≤ 1 := by linarith
  have pv := (hu T.b ⟨hb,by linarith⟩).1
  have tail := sub_nonneg.mpr (mz.trans (mul_le_of_le_one_left hb a1))
  let D := T.b+(1+T.b*P T.b)*T.m*(T.b-T.m)
  have pos : 0 < D := by dsimp only [D]; positivity
  have eq : matchingCut P T.b T.m = T.b*T.m*(T.b-T.m)/D := by
    have padded : 1+(1/T.b+P T.b)*(T.m*(T.b-T.m))=D/T.b := by
      dsimp only [D]; field_simp [pb.ne']
    dsimp only [matchingCut]
    rw [padded]
    field_simp [pos.ne',pb.ne']
  have h := T.row_profile hu hc valid hm short
  rw [eq] at h
  have multiplied := mul_le_mul_of_nonneg_right h pos.le
  field_simp [pos.ne'] at multiplied
  change (2-T.a)*T.m*D ≤ _
  nlinarith only [multiplied]

/-- Testing a proposed upper bound works because the cleared equation is increasing after
division by the unused part of the column side. -/
theorem RectangleLimit.row_cap (T : RectangleLimit) {P : ℝ → ℝ}
    (hu : UnitProfile P) (hc : Continuous P) (valid : ValidProfile P)
    (hm : 0 < T.m) (short : T.b < 4/5) {h : ℝ} (nonneg : 0 ≤ h)
    (cert : 2*T.a*T.b*(T.b-h) ≤ (2-T.a)*h*(T.b+(1+T.b*P T.b)*h*(T.b-h))) :
    T.m ≤ h := by
  obtain ⟨ha,hb,hs,_,mz⟩ := T.range
  obtain ⟨_,pb⟩ := T.positive_sides hm
  have a1 : T.a ≤ 1 := by linarith
  have mb := mz.trans (mul_le_of_le_one_left hb a1)
  have scale : 0 < 2-T.a := by linarith
  let U := 1+T.b*P T.b
  have pos : 0 < U := by dsimp [U]; have := (hu T.b ⟨hb,by linarith⟩).1; positivity
  have count := T.row_polynomial hu hc valid hm short
  change (2-T.a)*T.m*(T.b+U*T.m*(T.b-T.m)) ≤ _ at count
  change _ ≤ (2-T.a)*h*(T.b+U*h*(T.b-h)) at cert
  by_contra! bigger
  have tail : 0 < T.b-T.m := by
    by_contra! bad
    have eq : T.m=T.b := by linarith
    rw [eq,sub_self,mul_zero,mul_zero,add_zero] at count
    nlinarith only [count,mul_pos (mul_pos scale pb) pb]
  have tailH : 0 < T.b-h := by linarith
  have strong : h/(T.b-h) < T.m/(T.b-T.m) := by
    apply (div_lt_div_iff₀ tailH tail).mpr
    nlinarith only [mul_pos pb (sub_pos.mpr bigger)]
  have inc := add_lt_add_of_lt_of_le (mul_lt_mul_of_pos_left strong pb)
    (mul_le_mul_of_nonneg_left (pow_le_pow_left₀ nonneg bigger.le 2) pos.le)
  have bound : (2-T.a)*(T.b*(T.m/(T.b-T.m))+U*T.m^2) ≤ 2*T.a*T.b := by
    apply le_of_mul_le_mul_right (a := T.b-T.m) _ tail
    field_simp [tail.ne']
    nlinarith only [count]
  have reverse : 2*T.a*T.b ≤ (2-T.a)*(T.b*(h/(T.b-h))+U*h^2) := by
    apply le_of_mul_le_mul_right (a := T.b-h) _ tailH
    field_simp [tailH.ne']
    nlinarith only [cert]
  exact (not_lt_of_ge (bound.trans reverse)) (mul_lt_mul_of_pos_left inc scale)

end Erdos810
#assert_no_sorry Erdos810.RectangleLimit.row_cap
