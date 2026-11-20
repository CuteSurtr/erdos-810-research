import DirectionalRectangle
import ThinRectangle

/-! # Iteration of proportional bounds on matching cuts -/

set_option autoImplicit false
open Filter Topology
namespace Erdos810

def Proportional (U : ℝ → ℝ) : Prop :=
  SampleUpper (fun _ ↦ True) (fun a b ↦ a*b/U (a+b))

def RectangleSample.transpose {n : ℕ} (H : RectangleSample n) : RectangleSample n where
  G := H.G
  C := H.C
  proper := H.proper
  rainbow := H.rainbow
  L := H.R
  R := H.L
  fits := by rw [add_comm]; exact H.fits

theorem RectangleSample.mass_transpose {n : ℕ} (H : RectangleSample n) :
    H.transpose.mass = H.mass := by
  unfold RectangleSample.mass
  rw [rectangle_transpose H.G H.L H.R]
  rfl

def RectangleLimit.transpose (T : RectangleLimit) : RectangleLimit where
  orders := T.orders
  sample := fun i ↦ (T.sample i).transpose
  orders_top := T.orders_top
  a := T.b
  b := T.a
  m := T.m
  sideA := T.sideB
  sideB := T.sideA
  edges := by simpa only [RectangleSample.mass_transpose] using T.edges

def WidthRange (U : ℝ → ℝ) : Prop :=
  ∀ s ∈ Set.Icc (0:ℝ) 1, 0 < U s ∧ U s ≤ 2

theorem proportional_of_limits {U : ℝ → ℝ} (hc : Continuous U) (hr : WidthRange U)
    (bound : ∀ T : RectangleLimit, 0 < T.m → T.m * U (T.a+T.b) ≤ T.a*T.b) :
    Proportional U := by
  apply sampleUpper_of_limits
  · intro n H hn _
    obtain ⟨ha,hb,hs,_,_⟩ := H.range hn
    exact div_nonneg (mul_nonneg ha hb) (hr _ ⟨add_nonneg ha hb,hs⟩).1.le
  · intro T _
    obtain ⟨ha,hb,hs,_,_⟩ := T.range
    exact (T.sideA.mul T.sideB).div ((hc.tendsto _).comp (T.sideA.add T.sideB))
      (hr _ ⟨add_nonneg ha hb,hs⟩).1.ne'
  · intro T _ hm
    obtain ⟨ha,hb,hs,_,_⟩ := T.range
    exact (le_div_iff₀ (hr _ ⟨add_nonneg ha hb,hs⟩).1).mpr (bound T hm)

theorem RectangleLimit.proportional (T : RectangleLimit) {U : ℝ → ℝ} (hc : Continuous U)
    (hr : WidthRange U) (v : Proportional U) : T.m*U (T.a+T.b) ≤ T.a*T.b := by
  obtain ⟨ha,hb,hs,_,_⟩ := T.range
  have pos := (hr _ ⟨add_nonneg ha hb,hs⟩).1
  apply (le_div_iff₀ pos).mp
  apply le_of_forall_pos_le_add
  intro ε hε
  apply le_of_tendsto_of_tendsto T.edges
    (((T.sideA.mul T.sideB).div ((hc.tendsto _).comp (T.sideA.add T.sideB)) pos.ne').add
      (tendsto_const_nhds (x := ε)))
  exact (T.orders_top.eventually (v ε hε)).mono (fun i h ↦ h (T.sample i) trivial)

private theorem tangent {k m b u : ℝ} (hu : 0 < u) (hu2 : u ≤ 2) :
    k^2+2*(k*(b-k)/u) ≤ m^2+2*(m*(b-m)/u)+(2*m+2*(b-2*m)/u)*(k-m) := by
  field_simp [hu]
  nlinarith only [mul_nonneg (sub_nonneg.mpr hu2) (sq_nonneg (k-m))]

/-- A proportional child bound gives a one-sided rational bound on its parent. -/
theorem RectangleLimit.proportional_row (T : RectangleLimit) {U : ℝ → ℝ}
    (hc : Continuous U) (hr : WidthRange U) (v : Proportional U) (hm : 0 < T.m) :
    T.m*(T.a+(1-T.a/2)*U T.b) ≤ T.a*T.b := by
  obtain ⟨ha,hb,hs,_,_⟩ := T.range
  have a1 : T.a ≤ 1 := by linarith
  have pb := (hr T.b ⟨hb, by linarith⟩).1
  have decay : Tendsto (fun i ↦ (T.sample i).mass/(T.orders i:ℝ)) atTop (𝓝 0) := by
    simpa only [one_div,div_eq_mul_inv,one_mul,mul_zero] using T.edges.mul T.inv_order_zero
  have cut := (T.edges.mul (T.sideB.sub T.edges)).div ((hc.tendsto _).comp T.sideB) pb.ne'
  have energy : 2*T.m^2 ≤ T.a*(T.m^2+2*(T.m*(T.b-T.m)/U T.b)) := by
    apply le_of_forall_pos_le_add
    intro ε hε
    have large := T.orders_top.eventually (v (ε/2) (by positivity))
    have finite := (large.and T.positive_orders).mono (fun i ⟨v0,hn⟩ ↦ by
      let H := T.sample i
      obtain ⟨aa,bb,ss,_,_⟩ := H.range hn
      obtain ⟨up,u2⟩ := hr H.b ⟨bb,by linarith⟩
      apply H.row_average hn (H.mass^2+2*(H.mass*(H.b-H.mass)/U H.b))
        (2*H.mass+2*(H.b-2*H.mass)/U H.b) ε
      intro c
      have hbnd := v0 (H.leftCut c) trivial
      obtain ⟨row,col,_,_⟩ := H.cut_coordinates c
      change (H.leftCut c).mass ≤ (H.leftCut c).a*(H.leftCut c).b/U ((H.leftCut c).a+(H.leftCut c).b)+ε/2 at hbnd
      rw [row,col,add_sub_cancel] at hbnd
      linarith only [hbnd,tangent (k := H.k c) (m := H.mass) (b := H.b) up u2])
    have lhs := (tendsto_const_nhds (x := (2:ℝ))).mul (T.edges.pow 2)
    have rhs := T.sideA.mul ((((T.edges.pow 2).add ((tendsto_const_nhds (x := (2:ℝ))).mul cut)).add decay).add
      (tendsto_const_nhds (x := ε)))
    have result := le_of_tendsto_of_tendsto lhs rhs finite
    nlinarith only [result,mul_nonneg (sub_nonneg.mpr a1) hε.le]
  field_simp [pb] at energy
  nlinarith only [energy]

end Erdos810
#assert_no_sorry Erdos810.RectangleLimit.proportional_row
