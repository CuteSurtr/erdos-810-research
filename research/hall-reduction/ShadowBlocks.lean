import ShadowArms

/-! # Changing between vertex, edge, and triple sums in a linear system -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open ShadowFlags ShadowGap
variable {n : ℕ} {H : Finset (Finset (Fin n))}

noncomputable def hd (H : Finset (Finset (Fin n))) (x : Fin n) : ℝ := deg (W H) x/2
noncomputable def mass (H : Finset (Finset (Fin n))) (g : Finset (Fin n) → ℝ) : ℝ :=
  (∑ e ∈ H, g e)/(n:ℝ)^2
noncomputable def pairs (e : Finset (Fin n)) (f : Fin n → Fin n → ℝ) : ℝ :=
  (∑ x ∈ e, ∑ y ∈ e.erase x, f x y)/2
noncomputable def defect (H : Finset (Finset (Fin n))) (e : Finset (Fin n)) : ℝ :=
  2+3/(n:ℝ)-3*(∑ x ∈ e, hd H x)

theorem mass_le {f g : Finset (Fin n) → ℝ} (rel : ∀ e ∈ H, f e ≤ g e) :
    mass H f ≤ mass H g := div_le_div_of_nonneg_right (Finset.sum_le_sum rel) (sq_nonneg _)
theorem mass_const (c : ℝ) : mass H (fun _ ↦ c) = c*((H.card:ℝ)/(n:ℝ)^2) := by
  simp [mass]; ring
theorem mass_scale (c : ℝ) (f : Finset (Fin n) → ℝ) : mass H (fun e ↦ c*f e) = c*mass H f := by
  simp only [mass,← Finset.mul_sum,mul_div_assoc]
theorem mass_add (f g : Finset (Fin n) → ℝ) : mass H (fun e ↦ f e+g e) = mass H f+mass H g := by
  simp only [mass,Finset.sum_add_distrib,add_div]
theorem mass_sub (f g : Finset (Fin n) → ℝ) : mass H (fun e ↦ f e-g e) = mass H f-mass H g := by
  simp only [mass,Finset.sum_sub_distrib,sub_div]

theorem incidence_exchange (g : Finset (Fin n) → Fin n → ℝ) :
    (∑ x, ∑ e ∈ inc H x, g e x) = ∑ e ∈ H, ∑ x ∈ e, g e x := by
  classical
  simp only [inc,Finset.sum_filter]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro e _
  rw [← Finset.sum_filter]
  simp

theorem mass_edges (hl : ∀ t ∈ H, IsLinearMember H t) (f : Fin n → Fin n → ℝ) :
    mass H (fun e ↦ pairs e f) = edge (W H) f/2 := by
  have allpairs : (∑ x, ∑ y, W H x y*f x y) =
      ∑ e ∈ H, ∑ x ∈ e, ∑ y ∈ e.erase x, f x y := by
    calc
      _ = ∑ x, ∑ e ∈ inc H x, ∑ y ∈ e.erase x, f x y :=
        Finset.sum_congr rfl (fun x _ ↦ link_sum hl x (f x))
      _ = _ := incidence_exchange _
  simp only [mass,pairs,edge,avg_div_card,Fintype.card_fin,← Finset.sum_div,allpairs]
  ring

theorem pairs_three (f : Fin n → Fin n → ℝ) (sym : ∀ x y, f x y=f y x)
    {x y z : Fin n} (xy : x≠y) (xz : x≠z) (yz : y≠z) :
    pairs {x,y,z} f = f x y + f y z + f z x := by
  classical
  have ex : ({x,y,z} : Finset _).erase x = {y,z} := by ext u; simp; grind
  have ey : ({x,y,z} : Finset _).erase y = {x,z} := by ext u; simp; grind
  have ez : ({x,y,z} : Finset _).erase z = {x,y} := by ext u; simp; grind
  simp [pairs,xy,xz,yz,ex,ey,ez,sym y x,sym z y,sym x z]
  ring

theorem mass_vertices (hn : 0 < n) (uniform : ∀ t ∈ H, t.card=3)
    (hl : ∀ t ∈ H, IsLinearMember H t) (f : Fin n → ℝ) :
    mass H (fun e ↦ ∑ x ∈ e, f x) = avg (fun x ↦ hd H x*f x) := by
  have nn : (n:ℝ) ≠ 0 := by exact_mod_cast hn.ne'
  have nd (x : Fin n) : ((inc H x).card:ℝ)=(n:ℝ)*hd H x := by
    rw [hd,normalized_degree uniform hl x]; field_simp
  have exchange := incidence_exchange (H := H) (fun _ x ↦ f x)
  simp only [Finset.sum_const,nsmul_eq_mul] at exchange
  rw [mass,← exchange,avg_div_card,Fintype.card_fin]
  simp_rw [nd,mul_assoc]
  rw [← Finset.mul_sum]
  field_simp

theorem density_count (hn : 0<n) (uniform : ∀ t ∈ H, t.card=3)
    (hl : ∀ t ∈ H, IsLinearMember H t) :
    density (W H) = 3*((H.card:ℝ)/(n:ℝ)^2) := by
  have m := mass_vertices hn uniform hl (fun _ ↦ 1)
  have ex : (fun e : Finset (Fin n) ↦ ∑ _x ∈ e, (1:ℝ)) = fun e ↦ (e.card:ℝ) := by simp
  rw [ex] at m
  simp only [mul_one] at m
  have eq : mass H (fun e ↦ (e.card:ℝ)) = mass H (fun _ ↦ 3) := by
    unfold mass
    congr 1
    exact Finset.sum_congr rfl (fun e he ↦ by change (e.card:ℝ) = 3; exact_mod_cast uniform e he)
  rw [eq,mass_const] at m
  exact m.symm

theorem density_balance [Nonempty (Fin n)] (hn : 0<n) (uniform : ∀ t ∈ H, t.card=3)
    (hl : ∀ t ∈ H, IsLinearMember H t) :
    mass H (defect H)+3*variance (W H)=density (W H)*(2/3+1/(n:ℝ)-3*density (W H)) := by
  let r := density (W H)
  have sq' := avg_congr (fun x : Fin n ↦ show (dev (W H) x)^2 =
      hd H x*hd H x-(2*r)*hd H x+r^2 by dsimp [r,hd,dev]; ring)
  simp only [avg_add,avg_sub,avg_scale,avg_const] at sq'
  change variance (W H) = _-2*r*r+r^2 at sq'
  have count := density_count hn uniform hl
  change r = _ at count
  change mass H (fun e ↦ (2+3/(n:ℝ))-3*(∑ x ∈ e, hd H x))+3*variance (W H) =
    r*(2/3+1/(n:ℝ)-3*r)
  rw [mass_sub,mass_const,mass_scale,mass_vertices hn uniform hl]
  have cm : (H.card:ℝ)/(n:ℝ)^2=r/3 := by linarith only [count]
  rw [cm]
  rw [sq']
  ring

end Erdos810.ShadowRoot
#assert_no_sorry Erdos810.ShadowRoot.mass_edges Erdos810.ShadowRoot.density_balance
