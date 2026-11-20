import WeightedSphere

/-! # Optimizing the dimension in the sphere construction for bounded weighted averages -/

set_option autoImplicit false
open Filter Topology Real
namespace Erdos810

private theorem rounding_ratio {a : ℝ} (ha : 0 < a) {X : ℕ → ℝ} (hx : Tendsto X atTop atTop) :
    Tendsto (fun n ↦ (⌈a*X n⌉₊:ℝ)/X n) atTop (𝓝 a) := by
  have bnd : Tendsto (fun n ↦ a+(X n)⁻¹) atTop (𝓝 a) := by
    simpa using (tendsto_const_nhds (x := a)).add (tendsto_inv_atTop_zero.comp hx)
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds bnd
  · filter_upwards [hx.eventually (eventually_gt_atTop 0)] with n xn
    exact (le_div_iff₀ xn).mpr (Nat.le_ceil _)
  · filter_upwards [hx.eventually (eventually_gt_atTop 0)] with n xn
    apply (div_le_iff₀ xn).mpr
    rw [add_mul,inv_mul_cancel₀ xn.ne']
    exact (Nat.ceil_lt_add_one (mul_nonneg ha.le xn.le)).le

private theorem sqrt_log_grows : Tendsto (fun n : ℕ ↦ sqrt (log (n:ℝ))) atTop atTop := by
  have logs : Tendsto (fun n : ℕ ↦ log (n:ℝ)) atTop atTop := tendsto_log_atTop.comp tendsto_natCast_atTop_atTop
  apply tendsto_atTop.mpr
  intro z
  filter_upwards [logs.eventually (eventually_ge_atTop (z^2))] with n hn
  have h := Real.sqrt_le_sqrt hn
  rw [Real.sqrt_sq_eq_abs] at h
  exact (le_abs_self z).trans h

/-- U bounds the radix loss per digit, and a√log N is the chosen dimension. -/
theorem average_rigid_offsets_of_parameters (K : ℕ) (hK : 1 ≤ K) {U a c : ℝ} (hU : (K:ℝ)<U)
    (ha : 0<a) (budget : a*log U+2/a<c) :
    ∀ᶠ N : ℕ in atTop, ∃ S : Finset ℕ, (∀ x ∈ S, x<N) ∧ AverageRigid K S ∧
      (N:ℝ)*exp (-c*sqrt (log N)) ≤ S.card := by
  let X (n : ℕ) := sqrt (log (n:ℝ))
  let R (n : ℕ) := ⌈a*X n⌉₊
  let Q (n : ℕ) := exp (X n*((X n)/(R n:ℝ)))
  have Kp : (0:ℝ)< K := by exact_mod_cast (by omega : 0<K)
  have Up := Kp.trans hU
  have hx : Tendsto X atTop atTop := sqrt_log_grows
  have ratio : Tendsto (fun n ↦ (R n:ℝ)/X n) atTop (𝓝 a) := rounding_ratio ha hx
  have invratio : Tendsto (fun n ↦ X n/(R n:ℝ)) atTop (𝓝 (1/a)) := by
    simpa only [inv_div,one_div] using ratio.inv₀ ha.ne'
  have rtop : Tendsto (fun n ↦ (R n:ℝ)) atTop atTop :=
    tendsto_atTop_mono (fun n ↦ Nat.le_ceil (a*X n)) (hx.const_mul_atTop ha)
  have qtop : Tendsto Q atTop atTop := Real.tendsto_exp_atTop.comp (hx.atTop_mul_pos (by positivity) invratio)
  have lr : Tendsto (fun z : ℝ ↦ log z/z) atTop (𝓝 0) := by
    simpa using tendsto_pow_log_div_mul_add_atTop 1 0 1 one_ne_zero
  have logR : Tendsto (fun n ↦ log (R n:ℝ)/X n) atTop (𝓝 0) := by
    have h := (lr.comp rtop).mul ratio
    rw [zero_mul] at h
    apply h.congr'
    filter_upwards [rtop.eventually (eventually_gt_atTop 0)] with n rn
    change log (R n:ℝ)/(R n:ℝ)*((R n:ℝ)/X n)=_
    field_simp [rn.ne']
  have asym : Tendsto (fun n ↦ ((R n:ℝ)/X n)*log U+log (R n:ℝ)/X n+2*(X n/(R n:ℝ)))
      atTop (𝓝 (a*log U+2/a)) := by
    simpa only [add_zero,one_div,div_eq_mul_inv,one_mul] using ((ratio.mul_const (log U)).add logR).add (invratio.const_mul 2)
  filter_upwards [asym.eventually_lt_const budget, hx.eventually (eventually_gt_atTop 0),
    rtop.eventually (eventually_gt_atTop 0), qtop.eventually (eventually_ge_atTop (U*(K:ℝ)/(U-K))),
    eventually_ge_atTop (2:ℕ)] with N expense xn rn qlarge large
  let d := ⌊Q N/K⌋₊
  let r := R N
  let q := Q N
  have Np : 0 < (N:ℝ) := by exact_mod_cast (by omega : 0<N)
  have qp : 0 < q := exp_pos _
  have powq : q^r=(N:ℝ) := by
    change (exp (X N*(X N/(R N:ℝ))))^(R N)=(N:ℝ)
    rw [← exp_nat_mul]
    have sq : (X N)^2=log (N:ℝ) := Real.sq_sqrt (Real.log_nonneg (by exact_mod_cast (by omega : 1≤N)))
    rw [show (R N:ℝ)*(X N*(X N/(R N:ℝ)))=(X N)^2 by field_simp [rn.ne'],sq,exp_log Np]
  have floorlo : q/(K:ℝ)-1 ≤ (d:ℝ) := (Nat.sub_one_lt_floor _).le
  have floorhi : (d:ℝ) ≤ q/(K:ℝ) := Nat.floor_le (div_nonneg qp.le Kp.le)
  have bound : (K:ℝ)*d ≤ q := by simpa [mul_comm] using (le_div_iff₀ Kp).mp floorhi
  have rounded : q ≤ U*d := by
    have h := (div_le_iff₀ (sub_pos.mpr hU)).mp qlarge
    have floor := mul_le_mul_of_nonneg_right floorlo Kp.le
    rw [sub_mul,div_mul_cancel₀ _ Kp.ne',one_mul] at floor
    apply (le_of_mul_le_mul_right (a := (K:ℝ)) _ Kp)
    nlinarith only [h,mul_le_mul_of_nonneg_left floor Up.le]
  have dp : 0<(d:ℝ) := pos_of_mul_pos_right (qp.trans_le rounded) Up.le
  have small : (d:ℝ) ≤ q := by
    have k : (1:ℝ) ≤ K := by exact_mod_cast hK
    exact (le_mul_of_one_le_left dp.le k).trans bound
  have fit : (K*d)^r ≤ N := by
    have h := pow_le_pow_left₀ (mul_nonneg Kp.le dp.le) bound r
    rw [powq] at h
    exact_mod_cast h
  obtain ⟨S,range,rigid,many⟩ := exists_many_average_rigid K r d (by omega)
  refine ⟨S,fun i hi ↦ (range i hi).trans_le fit,rigid,?_⟩
  let D := U^r*(r:ℝ)*q^2
  have posD : 0<D := by dsimp only [D,r]; positivity
  have logD : log D ≤ c*X N := by
    change log (U^r*(r:ℝ)*q^2) ≤ _
    rw [log_mul (mul_pos (pow_pos Up _) rn).ne' (sq_pos_of_pos qp).ne',
      log_mul (pow_pos Up _).ne' rn.ne',log_pow,log_pow]
    change r*(log U)+log (r:ℝ)+(2:ℕ)*(log (exp (X N*(X N/(r:ℝ))))) ≤ _
    rw [log_exp]
    have h := mul_le_mul_of_nonneg_right expense.le xn.le
    change (((r:ℝ)/X N)*log U+log (r:ℝ)/X N+2*(X N/(r:ℝ)))*X N ≤ c*X N at h
    convert h using 1
    field_simp [xn.ne',rn.ne']
    ring
  have numer : (N:ℝ) ≤ U^r*(d:ℝ)^r := by simpa only [powq,mul_pow] using pow_le_pow_left₀ qp.le rounded r
  change (N:ℝ)*exp (-c*X N) ≤ _
  calc
    _ = (N:ℝ)/exp (c*X N) := by rw [neg_mul,Real.exp_neg,div_eq_mul_inv]
    _ ≤ (N:ℝ)/D := div_le_div_of_nonneg_left Np.le posD ((Real.log_le_iff_le_exp posD).mp logD)
    _ ≤ (d:ℝ)^r/((r:ℝ)*(d:ℝ)^2) := by
      apply (div_le_div_iff₀ posD (mul_pos rn (sq_pos_of_pos dp))).mpr
      have h := mul_le_mul numer (mul_le_mul_of_nonneg_left (pow_le_pow_left₀ dp.le small 2) rn.le)
        (mul_nonneg rn.le (sq_nonneg _)) (by positivity)
      dsimp only [D]; nlinarith only [h]
    _ ≤ S.card := many

/-- The usual Behrend constant for a radix large enough to handle all weights up to K. -/
theorem average_rigid_offsets_sharp (K : ℕ) (hK : 1<K) {c : ℝ} (hc : 2*sqrt (2*log K)<c) :
    ∀ᶠ N : ℕ in atTop, ∃ S : Finset ℕ, (∀ x ∈ S, x<N) ∧ AverageRigid K S ∧
      (N:ℝ)*exp (-c*sqrt (log N)) ≤ S.card := by
  have kp : (0:ℝ)<K := by exact_mod_cast (by omega : 0<K)
  have lp : 0<log (K:ℝ) := log_pos (by exact_mod_cast hK)
  let y := sqrt (2*log K)
  have yp : 0<y := sqrt_pos.2 (by positivity)
  have ys : y^2=2*log K := sq_sqrt (by positivity)
  let a := 2/y
  have ap : 0<a := by dsimp only [a]; positivity
  have optimal : a*log K+2/a=2*y := by dsimp [a]; field_simp [yp.ne']; nlinarith only [ys]
  let t := (c-2*y)/(2*a)
  have tp : 0<t := div_pos (sub_pos.mpr hc) (by positivity)
  let U := (K:ℝ)*exp t
  have ku : (K:ℝ)<U := lt_mul_of_one_lt_right kp ((one_lt_exp_iff).mpr tp)
  apply average_rigid_offsets_of_parameters K hK.le ku ap
  rw [show log U=log K+t by dsimp only [U]; rw [log_mul kp.ne' (exp_pos _).ne',log_exp]]
  have eq : 2*a*t=c-2*y := by dsimp only [t]; field_simp [ap.ne']
  nlinarith only [optimal,eq,hc]

end Erdos810
#assert_no_sorry Erdos810.average_rigid_offsets_sharp
