import ShadowDensity
import LinearCleanup

/-! # A strict improvement on the 2/27 coefficient for the (7,4) problem -/

set_option autoImplicit false
open Filter
namespace Erdos810

theorem sevenFourNumber_density (n : ℕ) (hn : 1000000≤n) :
    (sevenFourNumber n:ℝ)<(7354/100000)*(n:ℝ)^2+n/2 := by
  obtain ⟨H,card,uniform,free⟩ := exists_extremal_sevenFourNumber n
  obtain ⟨R,sub,lin,charge⟩ := exists_linear_rest (by omega) free uniform
  have res := ShadowRoot.linear_sevenFour_density hn (fun t ht ↦ uniform t (sub ht))
    (sevenFourFree_of_subset free sub) lin
  have compare : 2*(H.card:ℝ)≤2*(R.card:ℝ)+n := by exact_mod_cast charge
  rw [← card]
  linarith only [compare,res]

theorem sevenFourNumber_eventually_07354 (ε : ℝ) (he : 0<ε) :
    ∀ᶠ n : ℕ in atTop, (sevenFourNumber n:ℝ)≤(7354/100000+ε)*(n:ℝ)^2 := by
  obtain ⟨N,hN⟩ := exists_nat_ge (1/(2*ε))
  filter_upwards [eventually_ge_atTop (max 1000000 N)] with n hn
  have order : 1000000≤n := (le_max_left ..).trans hn
  have after : N≤n := (le_max_right ..).trans hn
  have nreal : (1/(2*ε):ℝ)≤n := hN.trans (by exact_mod_cast after)
  have room := (div_le_iff₀ (show 0<2*ε by positivity)).mp nreal
  have margin := mul_le_mul_of_nonneg_right room (Nat.cast_nonneg n : 0≤(n:ℝ))
  nlinarith only [sevenFourNumber_density n order,margin]

end Erdos810
#assert_no_sorry Erdos810.sevenFourNumber_density Erdos810.sevenFourNumber_eventually_07354
