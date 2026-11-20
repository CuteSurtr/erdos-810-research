import WeightedSphere

/-! # An explicit near-linear lower bound for the offset sets -/

set_option autoImplicit false
open Filter Topology Real
namespace Erdos810

/-- For every sufficiently large interval there are at least
N exp(-8√log N) offsets avoiding both midpoint and weighted-third averages. -/
theorem rigid_offsets_eventually :
    ∀ᶠ N : ℕ in atTop, ∃ S : Finset ℕ, (∀ a ∈ S, a < N) ∧ RigidOffsets S ∧
      (N:ℝ)*Real.exp (-8*Real.sqrt (Real.log N)) ≤ S.card := by
  have logs : Tendsto (fun n : ℕ ↦ Real.log (n:ℝ)) atTop atTop :=
    Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop
  filter_upwards [logs.eventually (eventually_ge_atTop (16:ℝ)),eventually_gt_atTop (0:ℕ)] with N large pos
  change 16 ≤ Real.log (N:ℝ) at large
  let X := Real.sqrt (Real.log N)
  let r := ⌈X⌉₊
  let q := (N:ℝ)^((r:ℝ)⁻¹)
  let d := ⌊q/3⌋₊
  have Npos : 0 < (N:ℝ) := by exact_mod_cast pos
  have Xsq : X^2=Real.log N := Real.sq_sqrt (by linarith)
  have Xn : 0 ≤ X := Real.sqrt_nonneg _
  have X4 : 4 ≤ X := by nlinarith only [Xn,Xsq,large]
  have rlo : X ≤ (r:ℝ) := Nat.le_ceil _
  have rhi : (r:ℝ) ≤ 2*X := by have h : (r:ℝ)<X+1 := Nat.ceil_lt_add_one (by linarith); linarith
  have rp : 0 < (r:ℝ) := by linarith
  have qp : 0 < q := Real.rpow_pos_of_pos Npos _
  have powq : q^r=(N:ℝ) := by
    dsimp only [q]; rw [← Real.rpow_natCast,← Real.rpow_mul Npos.le,inv_mul_cancel₀ rp.ne',Real.rpow_one]
  have logq : Real.log q=Real.log N/(r:ℝ) := by
    dsimp only [q]; rw [Real.log_rpow Npos]; ring
  have lo : X/2 ≤ Real.log q := by
    rw [logq,le_div_iff₀ rp]
    nlinarith only [mul_nonneg Xn (sub_nonneg.mpr rhi),Xsq]
  have hi : Real.log q ≤ X := by
    rw [logq,div_le_iff₀ rp]
    nlinarith only [mul_nonneg Xn (sub_nonneg.mpr rlo),Xsq]
  have exp2 : (6:ℝ) < Real.exp 2 := by
    rw [show (2:ℝ)=1+1 by norm_num,Real.exp_add]
    have h : (27/10:ℝ) < Real.exp 1 := by linarith only [Real.exp_one_gt_d9]
    nlinarith only [h,sq_nonneg (Real.exp 1-27/10)]
  have log6 : Real.log 6 ≤ 2 := (Real.log_le_iff_le_exp (by norm_num)).mpr exp2.le
  have q6 : 6 ≤ q := by
    apply (Real.log_le_log_iff (by norm_num) qp).mp
    linarith only [log6,lo,X4]
  have floorlo : q/3-1 ≤ (d:ℝ) := (Nat.sub_one_lt_floor _).le
  have dupper : (d:ℝ) ≤ q/3 := Nat.floor_le (by positivity)
  have dlo : q ≤ 6*d := by linarith
  have dp : 0 < (d:ℝ) := by linarith
  have dnat : 0 < d := by exact_mod_cast dp
  have dsmall : (d:ℝ) ≤ q := by linarith
  have cap : (3*d)^r ≤ N := by
    have h := pow_le_pow_left₀ (show 0 ≤ 3*(d:ℝ) by positivity) (show 3*(d:ℝ) ≤ q by linarith) r
    rw [powq] at h
    exact_mod_cast h
  obtain ⟨S,hS,rigid,size⟩ := exists_many_rigid_offsets r d dnat
  refine ⟨S,fun a ha ↦ (hS a ha).trans_le cap,rigid,?_⟩
  let D := (6:ℝ)^r*(r:ℝ)*q^2
  have Dpos : 0 < D := by dsimp [D]; positivity
  have L : Real.log D ≤ 8*X := by
    rw [show D=(6:ℝ)^r*(r:ℝ)*q^2 from rfl,
      Real.log_mul (mul_pos (by positivity) rp).ne' (sq_pos_of_pos qp).ne',
      Real.log_mul (pow_pos (by norm_num : (0:ℝ)<6) _).ne' rp.ne',Real.log_pow,Real.log_pow]
    have logR := Real.log_le_sub_one_of_pos rp
    have p := mul_le_mul_of_nonneg_left log6 rp.le
    norm_num only [Nat.cast_ofNat] at *
    linarith only [hi,rhi,logR,p]
  have dExp := (Real.log_le_iff_le_exp Dpos).mp L
  have numer : (N:ℝ) ≤ (6:ℝ)^r*(d:ℝ)^r := by
    simpa only [powq,mul_pow] using pow_le_pow_left₀ qp.le dlo r
  have dSq := pow_le_pow_left₀ dp.le dsmall 2
  change (N:ℝ)*Real.exp (-8*X) ≤ _
  calc
    _ = (N:ℝ)/Real.exp (8*X) := by rw [show -8*X=-(8*X) by ring,Real.exp_neg,div_eq_mul_inv]
    _ ≤ (N:ℝ)/D := div_le_div_of_nonneg_left Npos.le Dpos dExp
    _ ≤ (d:ℝ)^r/((r:ℝ)*(d:ℝ)^2) := by
      apply (div_le_div_iff₀ Dpos (mul_pos rp (sq_pos_of_pos dp))).mpr
      have h := mul_le_mul numer (mul_le_mul_of_nonneg_left dSq rp.le)
        (mul_nonneg rp.le (sq_nonneg _)) (by positivity)
      dsimp only [D]; nlinarith only [h]
    _ ≤ S.card := size

end Erdos810
#assert_no_sorry Erdos810.rigid_offsets_eventually
