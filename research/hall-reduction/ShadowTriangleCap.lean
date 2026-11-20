import ShadowBlocks

/-! # Triangle counts for the shadow and for a kernel bounded by one half -/

set_option autoImplicit false
namespace Erdos810.ShadowRoot
open ShadowFlags
variable {n : ℕ} {H : Finset (Finset (Fin n))}

/-- Counts ordered shadow triangles. The degree in the shadow is twice the
hyperdegree, and each pair of arms through one point allows one cross edge. -/
theorem shadow_triangle_upper (hn : 7≤n) (uniform : ∀ e∈H,e.card=3) (free : SevenFourFree H)
    (hl : ∀ e∈H,IsLinearMember H e) :
    edge (W H) (common (W H))≤avg (fun x ↦ (deg (W H) x)^2)/4+
      (3*((H.card:ℝ)/(n:ℝ)^2))/(n:ℝ) := by
  classical
  have n0 : 0<n := by omega
  have nr : 0<(n:ℝ) := by exact_mod_cast n0
  have pt (e : Finset (Fin n)) (he : e∈H) :
      2*pairs e (common (W H))≤(∑ x∈e,hd H x)+3/(n:ℝ) := by
    obtain ⟨x,y,z,xy,xz,yz,rfl⟩ := Finset.card_eq_three.mp (uniform e he)
    have rotate (a b c : Fin n) : ({a,b,c}:Finset _)={b,c,a} := by ext u; simp; tauto
    have h₂ : {y,z,x}∈H := rotate x y z ▸ he
    have h₃ : {z,x,y}∈H := rotate y z x ▸ h₂
    have atPoint {a b c : Fin n} (h : {a,b,c}∈H) (ab : a≠b) (ac : a≠c) (bc : b≠c) :
        common (W H) a b+common (W H) c a ≤ hd H a+1/(n:ℝ) := by
      rw [common_swap c a,common_eq,common_eq,hd,normalized_degree uniform hl]
      have lim := arm hn uniform free hl h ab ac bc
      field_simp [nr.ne']
      linarith only [lim]
    have ax := atPoint he xy xz yz
    have ay := atPoint h₂ yz xy.symm xz.symm
    have az := atPoint h₃ xz.symm yz.symm xy
    rw [pairs_three (common (W H)) (fun a b ↦ common_swap a b) xy xz yz]
    simp only [Finset.sum_insert (by simpa [xz] using xy : x ∉ ({y,z}:Finset _)),
      Finset.sum_insert (by simpa using yz : y ∉ ({z}:Finset _)),Finset.sum_singleton]
    simp only [div_eq_mul_inv,one_mul] at ax ay az ⊢
    linarith only [ax,ay,az]
  have summed := mass_le (H := H) pt
  rw [mass_scale,mass_edges hl,mass_add,mass_vertices n0 uniform hl,mass_const] at summed
  have sqr := avg_congr (fun x : Fin n ↦ show hd H x*hd H x=(1/4)*(deg (W H) x)^2 by unfold hd; ring)
  rw [avg_scale] at sqr
  rw [sqr] at summed
  convert summed using 1 <;> ring

end Erdos810.ShadowRoot
namespace Erdos810.ShadowFlags
variable {V : Type*} [Fintype V] [Nonempty V]

/-- A weighted Goodman inequality in the normalization needed for the shadow. -/
theorem half_triangle_lower (W : V → V → ℝ) (sym : ∀ x y,W x y=W y x)
    (nonneg : ∀ x y,0≤W x y) (half : ∀ x y,W x y≤1/2) :
    avg (fun x ↦ (deg W x)^2) - density W/2 ≤ edge W (common W) := by
  have pair (x y : V) : (deg W x+deg W y)/2-1/4 ≤ common W x y := by
    have h := avg_mono (fun z : V ↦ show (1/2)*W x z+(1/2)*W y z-1/4≤W x z*W y z by
      nlinarith only [mul_nonneg (sub_nonneg.mpr (half x z)) (sub_nonneg.mpr (half y z))])
    simp only [avg_sub,avg_add,avg_scale,avg_const] at h
    change (avg (W x)+avg (W y))/2-1/4≤avg (fun z ↦ W x z*W y z)
    linarith only [h]
  have h := edge_mono W nonneg (f := fun x y ↦ (1/2)*(deg W x+deg W y)-(1/4)*1)
    (g := common W) (fun x y ↦ by linarith only [pair x y])
  rw [edge_sub,edge_scale,edge_scale,edge_add,edge_fst,edge_snd W sym,edge_one] at h
  simp only [sq] at *
  linarith only [h]

/-- The limiting density consequence uses only the two triangle estimates and degree variance. -/
theorem one_eighteenth_of_moments {p T d g : ℝ} (scale : p=6*g) (square : p^2≤d)
    (upper : T≤d/4) (lower : d-p/4≤T) : g≤1/18 := by
  have cap : 3*p^2≤p := by linarith only [square,upper,lower]
  by_contra! high
  have pbig : 1/3<p := by linarith only [scale,high]
  nlinarith only [cap,mul_pos (show 0<p by linarith only [pbig]) (sub_pos.mpr pbig)]

end Erdos810.ShadowFlags
#assert_no_sorry Erdos810.ShadowRoot.shadow_triangle_upper Erdos810.ShadowFlags.half_triangle_lower
#assert_no_sorry Erdos810.ShadowFlags.one_eighteenth_of_moments
