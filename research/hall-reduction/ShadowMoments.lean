import ShadowFlags

/-! # Degree moments seen from a uniformly sampled shadow edge -/

set_option autoImplicit false
namespace Erdos810.ShadowFlags
variable {V : Type*} [Fintype V] (W : V → V → ℝ)

noncomputable def deg (x : V) : ℝ := avg (W x)
noncomputable def density : ℝ := avg (fun x ↦ deg W x/2)
noncomputable def dev (x : V) : ℝ := deg W x/2-density W
noncomputable def variance : ℝ := avg (fun x ↦ (dev W x)^2)
noncomputable def edgeMean (f : V → V → ℝ) : ℝ := edge W f/(2*density W)

theorem edge_congr {f g : V → V → ℝ} (h : ∀ x y, f x y = g x y) : edge W f = edge W g :=
  congrArg (edge W) (funext (fun x ↦ funext (h x)))
theorem edge_mono (wn : ∀ x y, 0 ≤ W x y) {f g : V → V → ℝ}
    (h : ∀ x y, f x y ≤ g x y) : edge W f ≤ edge W g :=
  avg_mono (fun x ↦ avg_mono (fun y ↦ mul_le_mul_of_nonneg_left (h x y) (wn x y)))
theorem edge_add (f g : V → V → ℝ) : edge W (fun x y ↦ f x y+g x y) = edge W f+edge W g := by
  simp only [edge,mul_add,avg_add]
theorem edge_sub (f g : V → V → ℝ) : edge W (fun x y ↦ f x y-g x y) = edge W f-edge W g := by
  simp only [edge,mul_sub,avg_sub]
theorem edge_scale (a : ℝ) (f : V → V → ℝ) : edge W (fun x y ↦ a*f x y) = a*edge W f := by
  simp only [edge,mul_left_comm (W _ _) a,avg_scale]
theorem edge_fst (g : V → ℝ) : edge W (fun x _ ↦ g x) = avg (fun x ↦ g x*deg W x) := by
  unfold edge deg
  apply avg_congr
  intro x
  simp only [mul_comm (W x _) (g x),avg_scale]
theorem edge_snd (sym : ∀ x y, W x y = W y x) (g : V → ℝ) :
    edge W (fun _ y ↦ g y) = avg (fun x ↦ g x*deg W x) := by
  rw [← edge_fst]
  unfold edge
  rw [avg_swap]
  apply avg_congr
  intro y
  apply avg_congr
  intro x
  rw [sym x y]

variable [Nonempty V]

theorem edge_one : edge W (fun _ _ ↦ 1) = 2*density W := by
  rw [edge_fst]
  unfold density
  simp only [one_mul,div_eq_inv_mul,avg_scale]
  ring
theorem em_congr {f g : V → V → ℝ} (h : ∀ x y, f x y = g x y) : edgeMean W f = edgeMean W g := by
  unfold edgeMean
  rw [edge_congr W h]
theorem em_mono (wn : ∀ x y, 0 ≤ W x y) (hr : 0 < density W) {f g : V → V → ℝ}
    (h : ∀ x y, f x y ≤ g x y) : edgeMean W f ≤ edgeMean W g :=
  div_le_div_of_nonneg_right (edge_mono W wn h) (by positivity)
theorem em_add (f g : V → V → ℝ) :
    edgeMean W (fun x y ↦ f x y+g x y) = edgeMean W f+edgeMean W g := by
  simp only [edgeMean,edge_add,add_div]
theorem em_sub (f g : V → V → ℝ) :
    edgeMean W (fun x y ↦ f x y-g x y) = edgeMean W f-edgeMean W g := by
  simp only [edgeMean,edge_sub,sub_div]
theorem em_scale (a : ℝ) (f : V → V → ℝ) : edgeMean W (fun x y ↦ a*f x y) = a*edgeMean W f := by
  simp only [edgeMean,edge_scale,mul_div_assoc]
theorem em_const (hr : 0 < density W) (a : ℝ) : edgeMean W (fun _ _ ↦ a) = a := by
  have iden := edge_scale W a (fun _ _ ↦ 1)
  simp only [mul_one,edge_one] at iden
  unfold edgeMean
  rw [iden]
  field_simp [hr.ne']
theorem em_sq (wn : ∀ x y, 0 ≤ W x y) (hr : 0 < density W) (f : V → V → ℝ) :
    (edgeMean W f)^2 ≤ edgeMean W (fun x y ↦ (f x y)^2) := by
  let m := edgeMean W f
  have h := em_mono W wn hr (f := fun _ _ ↦ 0)
    (g := fun x y ↦ (f x y)^2-(2*m)*f x y+m^2) (fun x y ↦ by nlinarith only [sq_nonneg (f x y-m)])
  simp only [em_add,em_sub,em_scale,em_const W hr] at h
  dsimp only [m] at h
  nlinarith only [h]

theorem dev_mean : avg (dev W) = 0 := by
  change avg (fun x ↦ deg W x/2-density W) = 0
  rw [avg_sub,avg_const]
  exact sub_self _

theorem end_dev (sym : ∀ x y, W x y = W y x) (hr : 0 < density W) :
    edgeMean W (fun x y ↦ dev W x+dev W y) = 2*variance W/density W := by
  have iden := avg_congr (fun x : V ↦ show dev W x*deg W x =
    2*(dev W x)^2 + (2*density W)*dev W x by unfold dev; ring)
  simp only [avg_add,avg_scale,dev_mean,mul_zero,add_zero] at iden
  unfold edgeMean
  rw [edge_add,edge_fst,edge_snd W sym,iden]
  unfold variance
  field_simp [hr.ne']
  ring

theorem end_dev_sq (sym : ∀ x y, W x y = W y x) (wn : ∀ x y, 0 ≤ W x y)
    (wo : ∀ x, deg W x ≤ 1) (hr : 0 < density W) :
    edgeMean W (fun x y ↦ (dev W x+dev W y)^2) ≤ 2*variance W/density W := by
  have bound := edge_mono W wn (f := fun x y ↦ (dev W x+dev W y)^2)
    (g := fun x y ↦ 2*((dev W x)^2+(dev W y)^2))
    (fun x y ↦ by nlinarith only [sq_nonneg (dev W x-dev W y)])
  have small := avg_mono (fun x : V ↦ show (dev W x)^2*deg W x ≤ (dev W x)^2 from
    (mul_le_mul_of_nonneg_left (wo x) (sq_nonneg _)).trans_eq (mul_one _))
  rw [edge_scale,edge_add,edge_fst,edge_snd W sym] at bound
  unfold edgeMean variance
  field_simp [hr.ne']
  linarith only [bound,small]

theorem codegree_diff (x y : V) : common W x y-neither W x y=deg W x+deg W y-1 := by
  have eq := avg_congr (fun u : V ↦ show W x u*W y u-(1-W x u)*(1-W y u)=W x u+W y u-1 by ring)
  simpa only [common,neither,deg,avg_add,avg_sub,avg_const] using eq

theorem product_lower (sym : ∀ x y, W x y = W y x) (wn : ∀ x y, 0 ≤ W x y)
    (wo : ∀ x, deg W x ≤ 1) (hr : 0 < density W) (quarter : density W ≤ 1/4)
    (mean : 1/3 ≤ edgeMean W (equalPair W)) :
    1/9-(1-4*density W)^2-8*variance W/density W ≤
       4*edgeMean W (fun x y ↦ common W x y*neither W x y) := by
  let r := density W
  let X := fun x y ↦ dev W x+dev W y
  let a := equalPair W
  have form := em_congr W (fun x y : V ↦ show 4*(common W x y*neither W x y) =
      (a x y)^2-((4*r-1)^2+(4*(4*r-1))*X x y+4*(X x y)^2) by
    have d := codegree_diff W x y
    have eq : 4*r-1+2*X x y = common W x y-neither W x y := by
      change 4*density W-1+2*((deg W x/2-density W)+(deg W y/2-density W)) = _
      linarith
    calc
      _ = (a x y)^2-(common W x y-neither W x y)^2 := by dsimp [a,equalPair]; ring
      _ = _ := by rw [← eq]; ring)
  simp only [em_scale,em_sub,em_add,em_const W hr] at form
  have variance_nonneg : 0 ≤ variance W := avg_nonneg (fun _ ↦ sq_nonneg _)
  have first : edgeMean W X = 2*variance W/r := end_dev W sym hr
  have second : edgeMean W (fun x y ↦ (X x y)^2) ≤ 2*variance W/r := end_dev_sq W sym wn wo hr
  have cross : (4*(4*r-1))*edgeMean W X ≤ 0 := mul_nonpos_of_nonpos_of_nonneg
    (by dsimp [r]; linarith) (by rw [first]; exact div_nonneg (by positivity) hr.le)
  have square := em_sq W wn hr a
  change 1/3 ≤ edgeMean W a at mean
  have minSq : 1/9 ≤ (edgeMean W a)^2 := by nlinarith only [sq_nonneg (edgeMean W a-1/3),mean]
  change 1/9-(1-4*r)^2-8*variance W/r ≤ _
  have opp : (1-4*r)^2 = (4*r-1)^2 := by ring
  have total : 8*variance W/r = 4*(2*variance W/r) := by ring
  rw [opp,total,form]
  linarith only [square,minSq,cross,second]

end Erdos810.ShadowFlags
assert_no_sorry Erdos810.ShadowFlags.product_lower
