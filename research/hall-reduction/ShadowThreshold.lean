import ShadowScatter

/-! # An exact rational separation using the one-sided rectangle bound -/

set_option autoImplicit false
namespace Erdos810.ShadowGap
noncomputable section
abbrev cutSlope : ℝ := 93/1000
local notation "lo" => (3*(7354/100000) : ℝ)
local notation "eps" => (1/1000000 : ℝ)
local notation "hi" => (2/9+eps/3 : ℝ)
local notation "budget" => (hi*(2/3+eps-3*lo) : ℝ)

/-- P and C are the edge averages of the cut product and common-neighbor
fraction, each multiplied by the shadow edge density r. -/
theorem density_of_refined_moments {r D v P C L h : ℝ}
    (hr : 0<r) (hD : 0≤D) (hv : 0≤v) (hh : 0≤h) (hn : h≤1/1000000)
    (balance : D+3*v=r*(2/3+h-3*r))
    (product : r≤1/4 → r*(1/9-(1-4*r)^2)-8*v≤4*P)
    (common : 2*C≤r*(4*r-2/3)+D+4*v)
    (upper₁ : L≤2*D/3) (upper₂ : L≤(3/2)*((5/17)*(D+3*v)+h*D))
    (lower : (2*cutSlope-cutSlope^2)*P-2*cutSlope^2*C-r*h/2≤L) :
    r < 3*(7354/100000) := by
  by_contra! low
  change lo≤r at low
  have room : 0≤2/3+h-3*r := nonneg_of_mul_nonneg_right (by linarith only [balance,hD,hv]) hr
  have high : r≤hi := by linarith only [room,hn]
  have cap : D+3*v≤budget := by
    rw [balance]
    exact mul_le_mul high (by change 2/3+h-3*r ≤ 2/3+eps-3*lo; linarith only [hn,low]) room (by norm_num)
  have capD : D≤budget := by linarith only [cap,hv]
  have capHD : h*D≤eps*budget := mul_le_mul hn capD hD (by norm_num)
  have capH : r*h≤hi*eps := mul_le_mul high hn hh (by norm_num)
  have quarter : r≤1/4 := high.trans (by norm_num)
  have sq : (1-4*r)^2≤(1-4*lo)^2 := by
    apply sq_le_sq' <;> linarith only [low,quarter,show (lo:ℝ)≤1/4 by norm_num]
  have lowerProd : lo*(1/9-(1-4*lo)^2)≤r*(1/9-(1-4*r)^2) :=
    mul_le_mul low (by linarith only [sq]) (by norm_num) hr.le
  have upperC : r*(4*r-2/3)≤hi*(4*hi-2/3) :=
    mul_le_mul high (by linarith only [high]) (by linarith only [low,show (1:ℝ)/6≤lo by norm_num]) (by norm_num)
  have prod : lo*(1/9-(1-4*lo)^2)-8*v≤4*P := by
    linarith only [lowerProd,product quarter]
  have count : 2*C≤hi*(4*hi-2/3)+budget+v := by
    linarith only [cap,upperC,common]
  have up1 : L≤(2/3)*budget-2*v := by linarith only [cap,upper₁]
  have up2 : L≤(3/2)*((5/17)+eps)*budget := by
    linarith only [upper₂,cap,capHD]
  dsimp [cutSlope] at prod count up1 up2 lower capH
  linarith only [prod,count,up1,up2,lower,capH]

end
end Erdos810.ShadowGap
assert_no_sorry Erdos810.ShadowGap.density_of_refined_moments
