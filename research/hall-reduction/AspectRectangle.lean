import WidthContraction

/-! # A linear denominator recording the shape of the child rectangle -/

set_option autoImplicit false
set_option maxHeartbeats 1600000
open Filter Topology
namespace Erdos810.Aspect
noncomputable section

def intercept (s : ℝ) := 1+s/2-2*s^2/75-s^3/750
def decay (s : ℝ) := 7*s/60-s^2/75
def den (s k : ℝ) := intercept s-decay s*k
def cutValue (s k : ℝ) := k*(s-k)/den s k

theorem ranges {s : ℝ} (h : s∈Set.Icc (0:ℝ) 1) :
    1 ≤ intercept s ∧ intercept s≤3/2 ∧ 0≤decay s ∧ decay s≤1/8 := by
  obtain ⟨h0,h1⟩ := h
  have sq : s^2≤s := by nlinarith only [mul_nonneg h0 (sub_nonneg.mpr h1)]
  have cube : s^3≤s^2 := by nlinarith only [mul_nonneg (sq_nonneg s) (sub_nonneg.mpr h1)]
  have pos : 0≤s^3 := pow_nonneg h0 _
  unfold intercept decay
  exact ⟨by linarith,by linarith [sq_nonneg s],by linarith,by linarith [sq_nonneg s]⟩

theorem den_pos {s k : ℝ} (hs : s∈Set.Icc (0:ℝ) 1) (hk : k∈Set.Icc 0 s) : 0<den s k := by
  obtain ⟨ia,_,_,ub⟩ := ranges hs
  have loss := mul_le_mul ub (hk.2.trans hs.2) hk.1 (by norm_num)
  unfold den
  linarith

private theorem den_tendsto {ι : Type*} {l : Filter ι} {f g : ι → ℝ} {s k : ℝ}
    (hf : Tendsto f l (𝓝 s)) (hg : Tendsto g l (𝓝 k)) :
    Tendsto (fun i ↦ den (f i) (g i)) l (𝓝 (den s k)) := by
  have ca : Continuous intercept := by unfold intercept; fun_prop
  have cb : Continuous decay := by unfold decay; fun_prop
  exact ((ca.tendsto s).comp hf).sub (((cb.tendsto s).comp hf).mul hg)

private theorem lower_den {s k : ℝ} (hs : s∈Set.Icc (0:ℝ) 1) (hk : k∈Set.Icc 0 s) :
    den s k ≤ (s-k)+(1-(s-k)/2)*widthPoly 0 k := by
  have factor : 0≤1/6+s/24-(k+2*(2*s/5))/24 := by linarith [hs.2,hk.2]
  have prod := mul_nonneg (sq_nonneg (k-2*s/5)) factor
  unfold den intercept decay widthPoly
  nlinarith only [prod]

/-- In the rectangle k by s-k, applying the preceding profile from the second
side gives a lower denominator affine in k, tangent at k = 2s/5. -/
theorem child_valid : SampleUpper (fun _ ↦ True) (fun a b ↦ a*b/den (a+b) a) := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨a,b,s,_,_⟩ := H.range hn
    exact div_nonneg (mul_nonneg a b) (den_pos ⟨add_nonneg a b,s⟩ ⟨a,by linarith⟩).le
  · intro T _
    obtain ⟨a,b,s,_,_⟩ := T.range
    have P := den_pos ⟨add_nonneg a b,s⟩ (k := T.a) ⟨a,by linarith⟩
    exact (T.sideA.mul T.sideB).div (den_tendsto (T.sideA.add T.sideB) T.sideA) P.ne'
  · intro T _ hm
    obtain ⟨a,b,s,_,_⟩ := T.range
    have hs : T.a+T.b∈Set.Icc (0:ℝ) 1 := ⟨add_nonneg a b,s⟩
    have hk : T.a∈Set.Icc 0 (T.a+T.b) := ⟨a,by linarith⟩
    have row := T.transpose.proportional_row (widthPoly_continuous _) (widthPoly_range (e := 0) (by norm_num))
      quadratic_width_valid hm
    have d := lower_den hs hk
    rw [add_sub_cancel_left] at d
    apply (le_div_iff₀ (den_pos hs hk)).mpr
    exact (mul_le_mul_of_nonneg_left d hm.le).trans (by simpa only [RectangleLimit.transpose,mul_comm T.b T.a] using row)

private theorem frac_tangent {a d b k m : ℝ} (one : 1≤a) (upper : a≤3/2)
    (d0 : 0≤d) (d1 : d≤1/8) (b1 : b≤1) (km : k∈Set.Icc (0:ℝ) b) (mm : m∈Set.Icc (0:ℝ) b) :
    k^2+2*(k*(b-k)/(a-d*k)) ≤ m^2+2*(m*(b-m)/(a-d*m))+
      (2*m+2*((b-2*m)*a+d*m^2)/(a-d*m)^2)*(k-m) := by
  have b0 := km.1.trans km.2
  have dm := mul_le_mul d1 (mm.2.trans b1) mm.1 (by norm_num)
  have dk := mul_le_mul d1 (km.2.trans b1) km.1 (by norm_num)
  have pm : 0<a-d*m := by linarith
  have pk : 0<a-d*k := by linarith
  have da : 0≤a := by linarith
  have db := mul_le_mul d1 b1 b0 (by norm_num)
  have bound : a^2 ≤ 2*(a-d*b) := by
    nlinarith only [db,one,mul_nonneg (sub_nonneg.mpr one) (sub_nonneg.mpr upper)]
  have dm' : a-d*m≤a := by linarith [mul_nonneg d0 mm.1]
  have dk' : a-d*k≤a := by linarith [mul_nonneg d0 km.1]
  have small := mul_le_mul dk' (pow_le_pow_left₀ pm.le dm' 2) (sq_nonneg _) da
  have nonneg : 0 ≤ 2*a*(a-d*b)-(a-d*k)*(a-d*m)^2 := by
    nlinarith only [small,mul_le_mul_of_nonneg_left bound da]
  have square := mul_nonneg nonneg (sq_nonneg (k-m))
  apply sub_nonneg.mp
  have eq : (m^2+2*(m*(b-m)/(a-d*m))+(2*m+2*((b-2*m)*a+d*m^2)/(a-d*m)^2)*(k-m))-
      (k^2+2*(k*(b-k)/(a-d*k))) =
      (2*a*(a-d*b)-(a-d*k)*(a-d*m)^2)*(k-m)^2/((a-d*k)*(a-d*m)^2) := by
    generalize hk : a-d*k = v at pk ⊢
    generalize hm : a-d*m = w at pm ⊢
    field_simp [pk.ne',pm.ne']
    subst v w
    ring
  rw [eq]
  exact div_nonneg square (mul_nonneg pk.le (sq_nonneg _))

theorem row (T : RectangleLimit) (hm : 0<T.m) :
    T.m*(T.a+(1-T.a/2)*den T.b T.m) ≤ T.a*T.b := by
  obtain ⟨a,b,s,m0,mz⟩ := T.range
  have a1 : T.a≤1 := by linarith
  have b1 : T.b≤1 := by linarith
  have mb := mz.trans (mul_le_of_le_one_left b a1)
  have pd := den_pos ⟨b,b1⟩ ⟨m0,mb⟩
  have dv := den_tendsto T.sideB T.edges
  have cut := (T.edges.mul (T.sideB.sub T.edges)).div dv pd.ne'
  have vanish : Tendsto (fun i ↦ (T.sample i).mass/(T.orders i:ℝ)) atTop (𝓝 0) := by
    simpa only [one_div,div_eq_mul_inv,one_mul,mul_zero] using T.edges.mul T.inv_order_zero
  have energy : 2*T.m^2≤T.a*(T.m^2+2*cutValue T.b T.m) := by
    apply le_of_forall_pos_le_add
    intro ε hε
    have large := T.orders_top.eventually (child_valid (ε/2) (by positivity))
    have finite := (large.and T.positive_orders).mono (fun i ⟨v,hn⟩ ↦ by
      let H := T.sample i
      obtain ⟨aa,bb,ss,mm,_⟩ := H.range hn
      obtain ⟨ra,rb,rd,re⟩ := ranges (s := H.b) ⟨bb,by linarith⟩
      apply H.row_average hn (H.mass^2+2*cutValue H.b H.mass)
        (2*H.mass+2*((H.b-2*H.mass)*intercept H.b+decay H.b*H.mass^2)/(den H.b H.mass)^2) ε
      intro c
      have vb := v (H.leftCut c) trivial
      obtain ⟨row,col,_,_⟩ := H.cut_coordinates c
      change (H.leftCut c).mass ≤ (H.leftCut c).a*(H.leftCut c).b/den ((H.leftCut c).a+(H.leftCut c).b) (H.leftCut c).a+ε/2 at vb
      rw [row,col,add_sub_cancel] at vb
      obtain ⟨k0,_,kb⟩ := H.k_range c
      have tan := frac_tangent ra rb rd re (show H.b≤1 by linarith) ⟨k0,kb⟩ ⟨mm,(H.mass_le_sides hn).2⟩
      dsimp only [cutValue,den] at vb ⊢
      linarith only [vb,tan])
    have lhs := (tendsto_const_nhds (x := (2:ℝ))).mul (T.edges.pow 2)
    have rhs := T.sideA.mul ((((T.edges.pow 2).add ((tendsto_const_nhds (x := (2:ℝ))).mul cut)).add vanish).add
      (tendsto_const_nhds (x := ε)))
    have result := le_of_tendsto_of_tendsto lhs rhs finite
    unfold cutValue
    nlinarith only [result,mul_nonneg (sub_nonneg.mpr a1) hε.le]
  unfold cutValue at energy
  field_simp [pd] at energy
  nlinarith only [energy]

end
end Erdos810.Aspect
#assert_no_sorry Erdos810.Aspect.row
