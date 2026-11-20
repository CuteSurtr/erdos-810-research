import ShapeAlgebra
import ShapeCurvature

/-! # The corrected limiting endpoint inequality -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810

private theorem shape_cut (P : ℝ → ℝ) (v k : ℝ) :
    shapeBound P k (v-k)=matchingCut P v k-shapeWeight v*(shapeCubic v k)^2 := by
  rw [shapeBound,profileBound_cut,show k+(v-k)=v by ring]
  dsimp only [shapeCubic]
  ring

private theorem shape_comm (P : ℝ → ℝ) (a b : ℝ) : shapeBound P a b=shapeBound P b a := by
  simp only [shapeBound,profileBound_comm P a b,mul_comm a b,add_comm a b,sub_sq_comm a b]

theorem RectangleSample.shape_average {n : ℕ} (H : RectangleSample n) {P : ℝ → ℝ}
    (hP : UnitProfile P) (hn : 0 < n) (ε : ℝ)
    (prior : ∀ J : RectangleSample n, J.mass ≤ shapeBound P J.a J.b+ε) :
    H.mass^2*(H.a+H.b) ≤ H.a*H.b*(shapeIntegrand P H.a H.b H.mass+H.mass/n+2*ε) := by
  obtain ⟨ha,hb,hs,hm,_⟩ := H.range hn
  obtain ⟨hma,hmb⟩ := H.mass_le_sides hn
  obtain ⟨j,tan⟩ := shapeIntegrand_tangent hP ha hb hs ⟨hm,hma⟩ hmb
  apply H.endpoint_average_of_affine hn _ j ε
  intro c
  obtain ⟨ra,rb,sa,sb⟩ := H.cut_coordinates c
  have lef := prior (H.leftCut c)
  have rig := prior (H.rightCut c)
  rw [ra,rb,shape_cut] at lef
  rw [sa,sb,shape_comm,shape_cut] at rig
  obtain ⟨hk,ka,kb⟩ := H.k_range c
  have h := tan (H.k c) ⟨hk,ka⟩ kb
  unfold shapeIntegrand matchingIntegrand at h ⊢
  linarith

noncomputable def shapeExtra (a b k : ℝ) : ℝ :=
  shapeWeight a*(a-k)^2*(a-2*k)^2+shapeWeight b*(b-k)^2*(b-2*k)^2

theorem scaled_shapeExtra {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (h : ℝ) :
    (a*b)*shapeExtra a b h=(1/5)*(b*(4-3*a)*(a-h)^2*(a-2*h)^2+a*(4-3*b)*(b-h)^2*(b-2*h)^2) := by
  unfold shapeExtra shapeWeight
  field_simp [ha.ne',hb.ne']

theorem RectangleLimit.shape_loss_bound {P : ℝ → ℝ} (T : RectangleLimit) (hu : UnitProfile P)
    (hc : Continuous P) (v : SampleUpper (fun _ ↦ True) (shapeBound P)) (hm : 0 < T.m) :
    T.m ≤ rectangleCap T.a T.b (sideLoss P T.a T.m+sideLoss P T.b T.m+shapeExtra T.a T.b T.m) := by
  obtain ⟨ha,hb,hs,hn,hab⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have ha1 : T.a ≤ 1 := by linarith
  have hb1 : T.b ≤ 1 := by linarith
  have ma := hab.trans (mul_le_of_le_one_right ha hb1)
  have mb := hab.trans (mul_le_of_le_one_left hb ha1)
  have ca := matchingCut_tendsto hc hu T.sideA T.edges pa ha1 hn ma
  have cb := matchingCut_tendsto hc hu T.sideB T.edges pb hb1 hn mb
  have ac : Tendsto (fun i ↦ shapeCubic (T.sample i).a (T.sample i).mass) atTop
      (𝓝 (shapeCubic T.a T.m)) := (T.edges.mul (T.sideA.sub T.edges)).mul
        (T.sideA.sub (tendsto_const_nhds.mul T.edges))
  have bc : Tendsto (fun i ↦ shapeCubic (T.sample i).b (T.sample i).mass) atTop
      (𝓝 (shapeCubic T.b T.m)) := (T.edges.mul (T.sideB.sub T.edges)).mul
        (T.sideB.sub (tendsto_const_nhds.mul T.edges))
  have integ : Tendsto (fun i ↦ shapeIntegrand P (T.sample i).a (T.sample i).b (T.sample i).mass)
      atTop (𝓝 (shapeIntegrand P T.a T.b T.m)) :=
    (((T.edges.pow 2).add ca).add cb).sub (((shapeWeight_tendsto T.sideA pa).mul (ac.pow 2)).add
      ((shapeWeight_tendsto T.sideB pb).mul (bc.pow 2)))
  have decay : Tendsto (fun i ↦ (T.sample i).mass/(T.orders i:ℝ)) atTop (𝓝 0) := by
    simpa only [one_div,div_eq_mul_inv,one_mul,mul_zero] using T.edges.mul T.inv_order_zero
  have prodle : T.a*T.b ≤ 1 := (mul_le_of_le_one_right ha hb1).trans ha1
  have endpoint : T.m^2*(T.a+T.b) ≤ T.a*T.b*shapeIntegrand P T.a T.b T.m := by
    apply le_of_forall_pos_le_add
    intro ε hε
    have large := T.orders_top.eventually (v (ε/2) (by positivity))
    have le := (large.and T.positive_orders).mono (fun i h ↦
      (T.sample i).shape_average hu h.2 (ε/2) (fun J ↦ h.1 J trivial))
    have bound := le_of_tendsto_of_tendsto ((T.edges.pow 2).mul (T.sideA.add T.sideB))
      ((T.sideA.mul T.sideB).mul ((integ.add decay).add (tendsto_const_nhds (x := 2*(ε/2))))) le
    nlinarith only [bound,mul_nonneg (sub_nonneg.mpr prodle) hε.le]
  have la := sideLoss_nonneg hu pa ha1 hn ma
  have lb := sideLoss_nonneg hu pb hb1 hn mb
  have wa := shapeWeight_nonneg ⟨ha,ha1⟩
  have wb := shapeWeight_nonneg ⟨hb,hb1⟩
  have extra : 0 ≤ shapeExtra T.a T.b T.m := by unfold shapeExtra; positivity
  unfold shapeIntegrand matchingIntegrand at endpoint
  rw [matchingCut_loss_identity hu pa ha1 hn ma,matchingCut_loss_identity hu pb hb1 hn mb] at endpoint
  unfold rectangleCap
  apply (le_div_iff₀ (add_pos_of_pos_of_nonneg (add_pos pa pb) (by positivity))).mpr
  apply (mul_le_mul_iff_of_pos_left hm).mp
  unfold shapeCubic at endpoint
  unfold shapeExtra
  nlinarith only [endpoint]

end Erdos810
#assert_no_sorry Erdos810.RectangleLimit.shape_loss_bound
