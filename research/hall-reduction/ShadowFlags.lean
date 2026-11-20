import Mathlib.Algebra.Order.BigOperators.Expect
import Mathlib.Data.Real.Basic
import Mathlib.Tactic
import Mathlib.Util.AssertNoSorry

/-! # Counting missing cut edges by the triangles they complete -/

set_option autoImplicit false
namespace Erdos810.ShadowFlags

variable {V : Type*} [Fintype V]

noncomputable def avg (f : V → ℝ) : ℝ := Finset.univ.expect f

theorem avg_congr {f g : V → ℝ} (h : ∀ x, f x = g x) : avg f = avg g :=
  congrArg avg (funext h)
theorem avg_mono {f g : V → ℝ} (h : ∀ x, f x ≤ g x) : avg f ≤ avg g :=
  Finset.expect_le_expect (fun x _ ↦ h x)
theorem avg_nonneg {f : V → ℝ} (h : ∀ x, 0 ≤ f x) : 0 ≤ avg f :=
  Finset.expect_nonneg (fun x _ ↦ h x)
@[simp] theorem avg_const [Nonempty V] (a : ℝ) : avg (fun _ : V ↦ a) = a :=
  Fintype.expect_const a
theorem avg_add (f g : V → ℝ) : avg (fun x ↦ f x+g x) = avg f + avg g :=
  Finset.expect_add_distrib _ _ _
theorem avg_sub (f g : V → ℝ) : avg (fun x ↦ f x-g x) = avg f - avg g :=
  Finset.expect_sub_distrib _ _ _
theorem avg_scale (a : ℝ) (f : V → ℝ) : avg (fun x ↦ a*f x) = a * avg f :=
  (Finset.mul_expect _ _ _).symm
theorem avg_swap (f : V → V → ℝ) :
    avg (fun x ↦ avg (fun y ↦ f x y)) = avg (fun y ↦ avg (fun x ↦ f x y)) :=
  Finset.expect_comm _ _ _
theorem avg_div_card (f : V → ℝ) : avg f = (∑ x, f x) / Fintype.card V :=
  Fintype.expect_eq_sum_div_card f

variable (W : V → V → ℝ)

/-- Integrate a function against the ordered edge or triangle density. -/
noncomputable def edge (f : V → V → ℝ) : ℝ :=
  avg (fun x ↦ avg (fun y ↦ W x y*f x y))
noncomputable def tri (f : V → V → V → ℝ) : ℝ :=
  avg (fun x ↦ avg (fun y ↦ avg (fun z ↦ W x y*W y z*W z x*f x y z)))

noncomputable def common (x y : V) : ℝ := avg (fun u ↦ W x u * W y u)
noncomputable def neither (x y : V) : ℝ := avg (fun u ↦ (1-W x u)*(1-W y u))
noncomputable def equalPair (x y : V) : ℝ := common W x y + neither W x y
noncomputable def q (x y : V) : ℝ := equalPair W x y-1/3
noncomputable def zeroTriple (x y z : V) : ℝ :=
  avg (fun u ↦ (1-W x u)*(1-W y u)*(1-W z u))
noncomputable def allTriple (x y z : V) : ℝ := avg (fun u ↦ W x u*W y u*W z u)
noncomputable def miss (x y : V) : ℝ :=
  avg (fun z ↦ W x z*W y z*zeroTriple W x y z)

theorem tri_rotate (f : V → V → V → ℝ) :
    tri W f = tri W (fun x y z ↦ f z x y) := by
  unfold tri
  rw [avg_swap (fun x y ↦ avg (fun z ↦ W x y*W y z*W z x*f x y z))]
  apply avg_congr
  intro y
  rw [avg_swap (fun x z ↦ W x y*W y z*W z x*f x y z)]
  apply avg_congr
  intro z
  apply avg_congr
  intro x
  ring

theorem tri_add (f g : V → V → V → ℝ) :
    tri W (fun x y z ↦ f x y z+g x y z) = tri W f + tri W g := by
  simp only [tri,mul_add,avg_add]

theorem tri_scale (t : ℝ) (f : V → V → V → ℝ) :
    tri W (fun x y z ↦ t * f x y z) = t * tri W f := by
  simp only [tri, mul_left_comm (W _ _ * W _ _ * W _ _) t,avg_scale]

theorem tri_mono (wn : ∀ x y, 0 ≤ W x y) {f g : V → V → V → ℝ}
    (h : ∀ x y z, f x y z ≤ g x y z) : tri W f ≤ tri W g := by
  apply avg_mono
  intro x
  apply avg_mono
  intro y
  apply avg_mono
  intro z
  exact mul_le_mul_of_nonneg_left (h x y z) (mul_nonneg (mul_nonneg (wn x y) (wn y z)) (wn z x))

theorem tri_pair (sym : ∀ x y, W x y = W y x) (f : V → V → ℝ) :
    tri W (fun x y _ ↦ f x y) = edge W (fun x y ↦ common W x y*f x y) := by
  unfold tri edge common
  apply avg_congr
  intro x
  apply avg_congr
  intro y
  calc
    _ = avg (fun z ↦ (W x y*f x y)*(W x z*W y z)) := by
      apply avg_congr
      intro z
      rw [sym z x]
      ring
    _ = _ := by rw [avg_scale]; ring

theorem monochrome [Nonempty V] (x y z : V) :
    q W x y + q W y z + q W z x = 2*(zeroTriple W x y z+allTriple W x y z) := by
  have point := avg_congr (fun u : V ↦ show
    (W x u*W y u+(1-W x u)*(1-W y u)-1/3)+
    (W y u*W z u+(1-W y u)*(1-W z u)-1/3)+
    (W z u*W x u+(1-W z u)*(1-W x u)-1/3) =
    2*((1-W x u)*(1-W y u)*(1-W z u)+W x u*W y u*W z u) by ring)
  simpa only [avg_add,avg_sub,avg_const,avg_scale,q,equalPair,common,neither,zeroTriple,allTriple] using point

/-- Counts use ordered pairs. An ordered missing pair contributes one triangle
with an external point having zero neighbors among its three vertices. -/
theorem missing_bound [Nonempty V] (sym : ∀ x y, W x y = W y x) (wn : ∀ x y, 0 ≤ W x y) :
    2*edge W (miss W) ≤ 3*edge W (fun x y ↦ common W x y*q W x y) := by
  have hm : edge W (miss W) = tri W (zeroTriple W) := by
    unfold edge miss tri
    apply avg_congr
    intro x
    apply avg_congr
    intro y
    rw [← avg_scale]
    apply avg_congr
    intro z
    rw [sym z x]
    ring
  let f : V → V → V → ℝ := fun x y _ ↦ q W x y
  have r₁ := tri_rotate W f
  have r₂ := tri_rotate W (fun x y z ↦ f z x y)
  have eq : (fun x y z ↦ f x y z + f y z x + f z x y) =
      fun x y z ↦ 2*(zeroTriple W x y z+allTriple W x y z) :=
    funext (fun x ↦ funext (fun y ↦ funext (monochrome W x y)))
  have ident := congrArg (tri W) eq
  simp only [tri_add,tri_scale] at ident
  have nonneg : 0 ≤ tri W (allTriple W) := by
    apply avg_nonneg
    intro x
    apply avg_nonneg
    intro y
    apply avg_nonneg
    intro z
    exact mul_nonneg (mul_nonneg (mul_nonneg (wn _ _) (wn _ _)) (wn _ _))
      (avg_nonneg (fun _ ↦ mul_nonneg (mul_nonneg (wn _ _) (wn _ _)) (wn _ _)))
  have edge_eq := tri_pair W sym (q W)
  change tri W f = _ at edge_eq
  linarith only [hm,ident,r₁,r₂,edge_eq,nonneg]

end Erdos810.ShadowFlags
assert_no_sorry Erdos810.ShadowFlags.missing_bound
