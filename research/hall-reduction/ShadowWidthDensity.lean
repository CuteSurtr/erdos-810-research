import ShadowWidth
import SevenFourDensity

/-! # The width contraction applied to the unrestricted (7,4) problem -/

set_option autoImplicit false
open Filter
namespace Erdos810.ShadowRoot
open ShadowFlags ShadowGap
noncomputable section
local notation "weightA" => (28141/100000 : ℝ)
local notation "weightB" => (1217/1000 : ℝ)
local notation "hmax" => (1/1000000 : ℝ)
local notation "δmax" => (1/10000000 : ℝ)
local notation "lo" => (3*(73272/1000000) : ℝ)
local notation "hi" => (2/9+hmax/3 : ℝ)
local notation "budget" => (hi*(2/3+hmax-3*lo) : ℝ)

private theorem separation {r D v P L h : ℝ} (hr : 0<r) (hD : 0≤D) (hv : 0≤v)
    (hn : h≤hmax) (balance : D+3*v=r*(2/3+h-3*r))
    (product : r≤1/4 → r*(1/9-(1-4*r)^2)-8*v≤4*P)
    (upper : L≤(3/2)*((weightA+h)*D+(weightB/2)*v))
    (lower : widthSlope*P-(widthIntercept+δmax)*r≤L) : r<lo := by
  by_contra! low
  have room : 0≤2/3+h-3*r := nonneg_of_mul_nonneg_right (by linarith only [balance,hD,hv]) hr
  have high : r≤hi := by linarith only [room,hn]
  have cap : D+3*v≤budget := by
    rw [balance]
    exact mul_le_mul high (by change 2/3+h-3*r≤2/3+hmax-3*lo; linarith only [hn,low]) room (by norm_num)
  have capD : D≤budget := by linarith only [cap,hv]
  have capHD : h*D≤hmax*budget := mul_le_mul hn capD hD (by norm_num)
  have quarter : r≤1/4 := high.trans (by norm_num)
  have sq : (1-4*r)^2≤(1-4*lo)^2 := by
    apply sq_le_sq' <;> linarith only [low,quarter,show (lo:ℝ)≤1/4 by norm_num]
  have minProd : lo*(1/9-(1-4*lo)^2)≤r*(1/9-(1-4*r)^2) :=
    mul_le_mul low (by linarith only [sq]) (by norm_num) hr.le
  have prod : lo*(1/9-(1-4*lo)^2)-8*v≤4*P := by linarith only [minProd,product quarter]
  have up : L≤(3/2)*(weightA+hmax)*budget+(3/2)*(weightB/2-3*weightA)*v := by
    nlinarith only [cap,upper,capHD]
  dsimp [widthSlope,widthIntercept] at lower
  linarith only [prod,up,lower,high,hv]

theorem eventual_linear_width :
    ∀ᶠ n : ℕ in atTop, ∀ H : Finset (Finset (Fin n)), (∀ t∈H,t.card=3) →
      SevenFourFree H → (∀ t∈H,IsLinearMember H t) →
      (H.card:ℝ)<(73272/1000000)*(n:ℝ)^2 := by
  filter_upwards [quadratic_width_valid δmax (by norm_num),eventually_ge_atTop (1000000:ℕ)] with n bounds hn
  intro H uniform free hl
  have n0 : 0<n := by omega
  have nr : 0<(n:ℝ) := by exact_mod_cast n0
  have n7 : 7≤n := by omega
  letI : NeZero n := ⟨n0.ne'⟩
  let S := W H
  let r := density S
  let D := mass H (defect H)
  let P := r*edgeMean S (fun x y ↦ common S x y*neither S x y)
  let L := edge S (miss S)/2
  let v := variance S
  have scale := density_count n0 uniform hl
  change r=3*((H.card:ℝ)/(n:ℝ)^2) at scale
  by_cases empty : H.card=0
  · rw [empty,Nat.cast_zero]; positivity
  have hr : 0<r := by rw [scale]; positivity
  obtain ⟨Dn,mean,_,_,up⟩ := upper_estimates_with (α := weightA) (β := weightB)
    (by norm_num [ScatterOK]) n7 uniform free hl hr
  have vc : 0≤v := avg_nonneg (fun _ ↦ sq_nonneg _)
  have h : (1/(n:ℝ))≤hmax := (div_le_iff₀ nr).mpr (by
    have nr' : (1000000:ℝ)≤n := by exact_mod_cast hn
    linarith only [nr'])
  have product (quarter : r≤1/4) : r*(1/9-(1-4*r)^2)-8*v≤4*P := by
    have p := product_lower S (W_symm H) (W_nonneg H)
      (fun x ↦ by have b := hd_le_half (H := H) x; unfold hd at b; linarith) hr quarter mean
    have mul := mul_le_mul_of_nonneg_left p hr.le
    change r*(1/9-(1-4*r)^2-8*v/r)≤r*(4*edgeMean S (fun x y ↦ common S x y*neither S x y)) at mul
    have cancel : r*(8*v/r)=8*v := by field_simp
    change _≤4*(r*edgeMean S (fun x y ↦ common S x y*neither S x y))
    rw [mul_sub,cancel] at mul
    linarith only [mul]
  obtain ⟨col,hp,rain⟩ := linear_coloring n7 uniform free hl
  have low := em_mono S (W_nonneg H) hr (fun x y ↦ width_cut_lower n0 bounds col hp rain x y)
  simp only [em_sub,em_scale,em_const S hr] at low
  have cut : widthSlope*P-(widthIntercept+δmax)*r≤L := by
    calc
      _ = r*(widthSlope*edgeMean S (fun x y ↦ common S x y*neither S x y)-(widthIntercept+δmax)) := by dsimp [P]; ring
      _ ≤ r*edgeMean S (miss S) := mul_le_mul_of_nonneg_left low hr.le
      _ = L := scaled_mean hr _
  have bound := separation hr Dn vc h (density_balance n0 uniform hl) product up cut
  have div : (H.card:ℝ)/(n:ℝ)^2<73272/1000000 := by linarith only [scale,bound]
  exact (div_lt_iff₀ (sq_pos_of_pos nr)).mp div

end
end Erdos810.ShadowRoot
namespace Erdos810

theorem sevenFourNumber_eventually_073272 (ε : ℝ) (he : 0<ε) :
    ∀ᶠ n : ℕ in atTop, (sevenFourNumber n:ℝ)≤(73272/1000000+ε)*(n:ℝ)^2 := by
  obtain ⟨N,hN⟩ := exists_nat_ge (1/(2*ε))
  filter_upwards [ShadowRoot.eventual_linear_width,eventually_ge_atTop (max 7 N)] with n main hn
  obtain ⟨H,card,uniform,free⟩ := exists_extremal_sevenFourNumber n
  obtain ⟨R,sub,lin,charge⟩ := exists_linear_rest ((le_max_left ..).trans hn) free uniform
  have res := main R (fun t ht ↦ uniform t (sub ht)) (sevenFourFree_of_subset free sub) lin
  have compare : 2*(H.card:ℝ)≤2*(R.card:ℝ)+n := by exact_mod_cast charge
  have nreal : (1/(2*ε):ℝ)≤n := hN.trans (by exact_mod_cast (le_max_right 7 N).trans hn)
  have room := (div_le_iff₀ (show 0<2*ε by positivity)).mp nreal
  have margin := mul_le_mul_of_nonneg_right room (Nat.cast_nonneg n : 0≤(n:ℝ))
  rw [← card]
  nlinarith only [res,compare,margin]

end Erdos810
#assert_no_sorry Erdos810.sevenFourNumber_eventually_073272
