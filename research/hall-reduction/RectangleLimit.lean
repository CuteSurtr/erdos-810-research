import RectangleSample

/-! # Compactness and uniform error terms for the rectangle iteration -/

set_option autoImplicit false
open Filter Topology SimpleGraph
namespace Erdos810

/-- A converging sequence of normalized rectangles with palette sizes tending to infinity. -/
structure RectangleLimit where
  orders : ℕ → ℕ
  sample : ∀ i, RectangleSample (orders i)
  orders_top : Tendsto orders atTop atTop
  a : ℝ
  b : ℝ
  m : ℝ
  sideA : Tendsto (fun i ↦ (sample i).a) atTop (𝓝 a)
  sideB : Tendsto (fun i ↦ (sample i).b) atTop (𝓝 b)
  edges : Tendsto (fun i ↦ (sample i).mass) atTop (𝓝 m)

def SampleUpper (D : ∀ {n : ℕ}, RectangleSample n → Prop) (F : ℝ → ℝ → ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∀ᶠ n : ℕ in atTop, ∀ H : RectangleSample n, D H → H.mass ≤ F H.a H.b+ε

def ValidProfile (P : ℝ → ℝ) : Prop := SampleUpper (fun _ ↦ True) (profileBound P)

theorem profileBound_tendsto {ι : Type*} {l : Filter ι} {P : ℝ → ℝ} (hP : Continuous P)
    (hu : UnitProfile P) {A B : ι → ℝ} {a b : ℝ} (hA : Tendsto A l (𝓝 a))
    (hB : Tendsto B l (𝓝 b)) (ha : 0 ≤ a) (hb : 0 ≤ b) (hs : a+b ≤ 1) (hp : 0 < a+b) :
    Tendsto (fun i ↦ profileBound P (A i) (B i)) l (𝓝 (profileBound P a b)) := by
  have pv := (hu _ ⟨hp.le,hs⟩).1
  have pos : 0 < 1+(1/(a+b)+P (a+b))*(a*b) := by positivity
  exact (hA.mul hB).div (tendsto_const_nhds.add (((tendsto_const_nhds.div (hA.add hB) hp.ne').add
    ((hP.tendsto _).comp (hA.add hB))).mul (hA.mul hB))) pos.ne'

theorem matchingCut_tendsto {ι : Type*} {l : Filter ι} {P : ℝ → ℝ} (hP : Continuous P)
    (hu : UnitProfile P) {V K : ι → ℝ} {v k : ℝ} (hV : Tendsto V l (𝓝 v))
    (hK : Tendsto K l (𝓝 k)) (hv : 0 < v) (hv1 : v ≤ 1) (hk : 0 ≤ k) (hkv : k ≤ v) :
    Tendsto (fun i ↦ matchingCut P (V i) (K i)) l (𝓝 (matchingCut P v k)) := by
  have z := hK.mul (hV.sub hK)
  have pv := (hu _ ⟨hv.le,hv1⟩).1
  have kz := sub_nonneg.mpr hkv
  have pos : 0 < 1+(1/v+P v)*(k*(v-k)) := by positivity
  exact z.div (tendsto_const_nhds.add (((tendsto_const_nhds.div hV hv.ne').add
    ((hP.tendsto _).comp hV)).mul z)) pos.ne'

namespace RectangleLimit

theorem positive_orders (T : RectangleLimit) : ∀ᶠ i : ℕ in atTop, 0 < T.orders i :=
  T.orders_top.eventually (eventually_gt_atTop 0)

theorem range (T : RectangleLimit) : 0 ≤ T.a ∧ 0 ≤ T.b ∧ T.a+T.b ≤ 1 ∧
    0 ≤ T.m ∧ T.m ≤ T.a*T.b := by
  have fin := T.positive_orders.mono (fun i hn ↦ (T.sample i).range hn)
  exact ⟨le_of_tendsto_of_tendsto tendsto_const_nhds T.sideA (fin.mono (fun _ h ↦ h.1)),
    le_of_tendsto_of_tendsto tendsto_const_nhds T.sideB (fin.mono (fun _ h ↦ h.2.1)),
    le_of_tendsto_of_tendsto (T.sideA.add T.sideB) tendsto_const_nhds (fin.mono (fun _ h ↦ h.2.2.1)),
    le_of_tendsto_of_tendsto tendsto_const_nhds T.edges (fin.mono (fun _ h ↦ h.2.2.2.1)),
    le_of_tendsto_of_tendsto T.edges (T.sideA.mul T.sideB) (fin.mono (fun _ h ↦ h.2.2.2.2))⟩

theorem positive_sides (T : RectangleLimit) (hm : 0 < T.m) : 0 < T.a ∧ 0 < T.b := by
  obtain ⟨ha,hb,_,_,hprod⟩ := T.range
  have prod := hm.trans_le hprod
  rcases (mul_pos_iff.mp prod) with h|h
  · exact h
  · exact (not_lt_of_ge ha h.1).elim

theorem inv_order_zero (T : RectangleLimit) : Tendsto (fun i ↦ 1/(T.orders i:ℝ)) atTop (𝓝 0) := by
  simpa only [one_div] using tendsto_inv_atTop_zero.comp (tendsto_natCast_atTop_atTop.comp T.orders_top)

theorem of_valid (T : RectangleLimit) {P : ℝ → ℝ} (hu : UnitProfile P) (hc : Continuous P)
    (v : ValidProfile P) (hm : 0 < T.m) : T.m ≤ profileBound P T.a T.b := by
  obtain ⟨ha,hb,hs,_,_⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have conv := profileBound_tendsto hc hu T.sideA T.sideB ha hb hs (add_pos pa pb)
  apply le_of_forall_pos_le_add
  intro ε hε
  apply le_of_tendsto_of_tendsto T.edges (conv.add tendsto_const_nhds)
  exact (T.orders_top.eventually (v ε hε)).mono (fun i h ↦ h (T.sample i) trivial)

/-- The two-cut endpoint inequality in the limit, with the previous profile still available. -/
theorem endpoint (T : RectangleLimit) {P : ℝ → ℝ} (hu : UnitProfile P) (hc : Continuous P)
    (v : ValidProfile P) (hm : 0 < T.m) :
    T.m^2*(T.a+T.b) ≤ T.a*T.b*matchingIntegrand P T.a T.b T.m := by
  obtain ⟨ha,hb,hs,hn,hab⟩ := T.range
  obtain ⟨pa,pb⟩ := T.positive_sides hm
  have ha1 : T.a ≤ 1 := by linarith
  have hb1 : T.b ≤ 1 := by linarith
  have ma := hab.trans (mul_le_of_le_one_right ha hb1)
  have mb := hab.trans (mul_le_of_le_one_left hb ha1)
  have ca := matchingCut_tendsto hc hu T.sideA T.edges pa ha1 hn ma
  have cb := matchingCut_tendsto hc hu T.sideB T.edges pb hb1 hn mb
  have integ : Tendsto (fun i ↦ matchingIntegrand P (T.sample i).a (T.sample i).b (T.sample i).mass)
      atTop (𝓝 (matchingIntegrand P T.a T.b T.m)) := ((T.edges.pow 2).add ca).add cb
  have decay : Tendsto (fun i ↦ (T.sample i).mass/(T.orders i:ℝ)) atTop (𝓝 0) := by
    simpa only [one_div,div_eq_mul_inv,one_mul,mul_zero] using T.edges.mul T.inv_order_zero
  have prodle : T.a*T.b ≤ 1 := (mul_le_of_le_one_right ha hb1).trans ha1
  apply le_of_forall_pos_le_add
  intro ε hε
  have large := T.orders_top.eventually (v (ε/2) (by positivity))
  have le := (large.and T.positive_orders).mono (fun i h ↦
    (T.sample i).endpoint_average hu h.2 (ε/2) (fun J ↦ h.1 J trivial))
  have bound := le_of_tendsto_of_tendsto ((T.edges.pow 2).mul (T.sideA.add T.sideB))
    ((T.sideA.mul T.sideB).mul ((integ.add decay).add (tendsto_const_nhds (x := 2*(ε/2))))) le
  nlinarith only [bound,mul_nonneg (sub_nonneg.mpr prodle) hε.le]

end RectangleLimit

set_option maxHeartbeats 2000000 in
/-- A limit bound gives a uniform error on all finite rectangles of the specified kind. -/
theorem sampleUpper_of_limits {D : ∀ {n : ℕ}, RectangleSample n → Prop} {F : ℝ → ℝ → ℝ}
    (nonneg : ∀ {n} (H : RectangleSample n), 0 < n → D H → 0 ≤ F H.a H.b)
    (conv : ∀ (T : RectangleLimit), 0 < T.m → Tendsto (fun i ↦ F (T.sample i).a (T.sample i).b)
      atTop (𝓝 (F T.a T.b)))
    (bound : ∀ (T : RectangleLimit), (∀ i, D (T.sample i)) → 0 < T.m → T.m ≤ F T.a T.b) :
    SampleUpper D F := by
  classical
  intro ε hε
  rw [eventually_atTop]
  by_contra! fail
  choose orders hlarge H hD hbad using fun i : ℕ ↦ fail (i+1)
  have top : Tendsto orders atTop atTop := tendsto_atTop.mpr (fun k ↦
    (eventually_ge_atTop k).mono (fun i hi ↦ by have := hlarge i; omega))
  let point (i : ℕ) := ((H i).a,(H i).b,(H i).mass)
  let I := Set.Icc (0:ℝ) 1
  have compact : IsCompact (I ×ˢ I ×ˢ I) := isCompact_Icc.prod (isCompact_Icc.prod isCompact_Icc)
  have positive (i : ℕ) : 0 < orders i := by have := hlarge i; omega
  have inside (i : ℕ) : point i ∈ I ×ˢ I ×ˢ I := by
    obtain ⟨ha,hb,hs,hm,hp⟩ := (H i).range (positive i)
    have a1 : (H i).a ≤ 1 := by linarith
    have b1 : (H i).b ≤ 1 := by linarith
    exact ⟨⟨ha,a1⟩,⟨hb,b1⟩,hm,hp.trans ((mul_le_of_le_one_right ha b1).trans a1)⟩
  obtain ⟨⟨a,b,m⟩,_,φ,hφ,lim⟩ := compact.tendsto_subseq inside
  let T : RectangleLimit := ⟨orders ∘ φ, (fun i ↦ H (φ i)), top.comp hφ.tendsto_atTop, a,b,m,
    continuous_fst.continuousAt.tendsto.comp lim,
    continuous_fst.continuousAt.tendsto.comp (continuous_snd.continuousAt.tendsto.comp lim),
    continuous_snd.continuousAt.tendsto.comp (continuous_snd.continuousAt.tendsto.comp lim)⟩
  have low : ε ≤ T.m := by
    apply le_of_tendsto_of_tendsto tendsto_const_nhds T.edges
    exact Eventually.of_forall (fun i ↦ by
      have hp := nonneg (H (φ i)) (positive _) (hD _)
      have hb := hbad (φ i)
      change ε ≤ (H (φ i)).mass
      linarith)
  have hm := hε.trans_le low
  have high := bound T (fun i ↦ hD (φ i)) hm
  have violated := le_of_tendsto_of_tendsto ((conv T hm).add (tendsto_const_nhds (x := ε))) T.edges
    (Eventually.of_forall (fun i ↦ (hbad (φ i)).le))
  linarith

theorem validProfile_of_limits {P : ℝ → ℝ} (hu : UnitProfile P) (hc : Continuous P)
    (bound : ∀ T : RectangleLimit, 0 < T.m → T.m ≤ profileBound P T.a T.b) : ValidProfile P := by
  apply sampleUpper_of_limits _ _ (fun T _ h ↦ bound T h)
  · intro n H hn _
    obtain ⟨ha,hb,hs,_,_⟩ := H.range hn
    exact (profileBound_range hu ha hb hs).1
  · intro T hm
    obtain ⟨ha,hb,hs,_,_⟩ := T.range
    obtain ⟨pa,pb⟩ := T.positive_sides hm
    exact profileBound_tendsto hc hu T.sideA T.sideB ha hb hs (add_pos pa pb)

end Erdos810
#assert_no_sorry Erdos810.RectangleLimit.endpoint Erdos810.sampleUpper_of_limits
