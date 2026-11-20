import ShadowUpper
import ShadowCuts

/-! # A finite upper density theorem for linear (7,4)-free triples -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open ShadowFlags ShadowGap
variable {n : ℕ} {H : Finset (Finset (Fin n))}

private theorem common_mean [Nonempty (Fin n)] (hr : 0<density (W H)) :
    2*edgeMean (W H) (common (W H)) =
      edgeMean (W H) (equalPair (W H))+(4*density (W H)-1)+4*variance (W H)/density (W H) := by
  let S := W H
  have pt := em_congr S (fun x y : Fin n ↦ show 2*common S x y =
      equalPair S x y+(4*density S-1)+2*(dev S x+dev S y) by
    have h := codegree_diff S x y
    unfold equalPair dev
    linarith only [h])
  simp only [em_scale,em_add,em_const S hr,end_dev S (W_symm H) hr] at pt
  change 2*edgeMean S (common S)=_
  rw [pt]
  ring

/-- The order threshold is explicit. The kernel checks the forbidden-configuration
count, the cut estimate, the moments, and the final rational separation. -/
theorem linear_sevenFour_density (hn : 1000000≤n) (uniform : ∀ t∈H,t.card=3)
    (free : SevenFourFree H) (hl : ∀ t∈H,IsLinearMember H t) :
    (H.card:ℝ)<(7354/100000)*(n:ℝ)^2 := by
  have n0 : 0<n := by omega
  have nr : 0<(n:ℝ) := by exact_mod_cast n0
  have n7 : 7≤n := by omega
  letI : NeZero n := ⟨n0.ne'⟩
  let S := W H
  let r := density S
  let D := mass H (defect H)
  let P := r*edgeMean S (fun x y ↦ common S x y*neither S x y)
  let C := r*edgeMean S (common S)
  let L := edge S (miss S)/2
  let v := variance S
  have scale := density_count n0 uniform hl
  change r=3*((H.card:ℝ)/(n:ℝ)^2) at scale
  by_cases empty : H.card=0
  · rw [empty,Nat.cast_zero]; positivity
  have hr : 0<r := by rw [scale]; positivity
  obtain ⟨Dn,mean,meanCap,up1,up2⟩ := upper_estimates n7 uniform free hl hr
  have vc : 0≤v := avg_nonneg (fun _ ↦ sq_nonneg _)
  have h : (1/(n:ℝ))≤1/1000000 := (div_le_iff₀ nr).mpr (by
    have nr' : (1000000:ℝ)≤n := by exact_mod_cast hn
    linarith only [nr'])
  have cod : 2*C≤r*(4*r-2/3)+D+4*v := by
    have eq := common_mean hr
    change 2*edgeMean S (common S)=edgeMean S (equalPair S)+(4*r-1)+4*v/r at eq
    have scaled := congrArg (fun w : ℝ ↦ r*w) eq
    have cancel : r*(4*v/r)=4*v := by field_simp
    change r*(edgeMean S (equalPair S)-1/3)≤D at meanCap
    change 2*(r*edgeMean S (common S))≤_
    dsimp only at scaled
    nlinarith only [scaled,cancel,meanCap]
  have product (quarter : r≤1/4) : r*(1/9-(1-4*r)^2)-8*v≤4*P := by
    have bound := product_lower S (W_symm H) (W_nonneg H)
      (fun x ↦ by have b := hd_le_half (H := H) x; unfold hd at b; linarith) hr quarter mean
    have mul := mul_le_mul_of_nonneg_left bound hr.le
    change r*(1/9-(1-4*r)^2-8*v/r)≤r*(4*edgeMean S (fun x y ↦ common S x y*neither S x y)) at mul
    have cancel : r*(8*v/r)=8*v := by field_simp
    change _≤4*(r*edgeMean S (fun x y ↦ common S x y*neither S x y))
    rw [mul_sub,cancel] at mul
    linarith only [mul]
  obtain ⟨col,hp,rain⟩ := linear_coloring n7 uniform free hl
  have low := em_mono S (W_nonneg H) hr (fun x y ↦ cut_lower n0 col hp rain x y cutSlope)
  simp only [em_sub,em_scale,em_const S hr] at low
  have cut : (2*cutSlope-cutSlope^2)*P-2*cutSlope^2*C-r*(1/(n:ℝ))/2≤L := by
    calc
      _ = r*((2*cutSlope-cutSlope^2)*edgeMean S (fun x y ↦ common S x y*neither S x y)-
          2*cutSlope^2*edgeMean S (common S)-(1/(n:ℝ))/2) := by dsimp [P,C]; ring
      _ ≤ r*edgeMean S (miss S) := mul_le_mul_of_nonneg_left low hr.le
      _ = L := scaled_mean hr _
  have bound := density_of_refined_moments hr Dn vc (by positivity) h (density_balance n0 uniform hl)
    product cod up1 up2 cut
  change r<3*(7354/100000) at bound
  have div : (H.card:ℝ)/(n:ℝ)^2<7354/100000 := by linarith only [scale,bound]
  exact (div_lt_iff₀ (sq_pos_of_pos nr)).mp div

end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.linear_sevenFour_density
