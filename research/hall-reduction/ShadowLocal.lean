import ShadowGap

/-! # Converting the three arm bounds at a triple into a weighted defect -/

set_option autoImplicit false
namespace Erdos810.ShadowGap

def rootDefect (h x y z : ℝ) : ℝ := 2+3*h-3*(x+y+z)
noncomputable def pairDefect (x y c : ℝ) : ℝ := 2/3-2*x-2*y+2*c

/-- x,y,z are the normalized hyperdegrees. The codegrees a,b,c follow cyclic order. -/
theorem local_defect {h x y z a b c : ℝ} (hh : 0 ≤ h)
    (ha : h ≤ a) (hb : h ≤ b) (hc : h ≤ c)
    (armx : a+c ≤ x+h) (army : a+b ≤ y+h) (armz : b+c ≤ z+h)
    (nonneg : 0 ≤ pairDefect x y a + pairDefect y z b + pairDefect z x c) :
    0 ≤ rootDefect h x y z ∧
    pairDefect x y a + pairDefect y z b + pairDefect z x c ≤ rootDefect h x y z ∧
    a*pairDefect x y a+b*pairDefect y z b+c*pairDefect z x c ≤ (4/9)*rootDefect h x y z := by
  let D := rootDefect h x y z
  let u := x+h-a-c
  let v := y+h-a-b
  let w := z+h-b-c
  let s := u+v+w
  have nu : 0 ≤ u := by dsimp [u]; linarith
  have nv : 0 ≤ v := by dsimp [v]; linarith
  have nw : 0 ≤ w := by dsimp [w]; linarith
  have iden : pairDefect x y a+pairDefect y z b+pairDefect z x c = D-s := by
    dsimp [D,s,u,v,w,rootDefect,pairDefect]; ring
  have ns : 0 ≤ s := by dsimp [s]; linarith
  have nsD : s ≤ D := by linarith only [iden,nonneg]
  have nD : 0 ≤ D := ns.trans nsD
  have total : x+y+z ≤ 2/3+h := by dsimp [D,rootDefect] at nD; linarith
  have qa : pairDefect x y a ≤ (D-s)/3+4*w/3 := by
    dsimp [D,s,u,v,w,pairDefect,rootDefect] at *
    linarith only [armx,army]
  have qb : pairDefect y z b ≤ (D-s)/3+4*u/3 := by
    dsimp [D,s,u,v,w,pairDefect,rootDefect] at *
    linarith only [army,armz]
  have qc : pairDefect z x c ≤ (D-s)/3+4*v/3 := by
    dsimp [D,s,u,v,w,pairDefect,rootDefect] at *
    linarith only [armz,armx]
  have mult {k q j : ℝ} (nk : 0 ≤ k) (small : k ≤ 1/3) (nj : 0 ≤ j)
      (ineq : q ≤ (D-s)/3+4*j/3) : k*q ≤ (1/3)*((D-s)/3+4*j/3) := by
    exact (mul_le_mul_of_nonneg_left ineq nk).trans (mul_le_mul_of_nonneg_right small (by linarith))
  have ma := mult (hh.trans ha) (by linarith only [total,armx,army,armz,hb,hc]) nw qa
  have mb := mult (hh.trans hb) (by linarith only [total,armx,army,armz,ha,hc]) nu qb
  have mc := mult (hh.trans hc) (by linarith only [total,armx,army,armz,ha,hb]) nv qc
  refine ⟨nD,by linarith only [iden,ns],?_⟩
  change _ ≤ (4/9)*D
  change u+v+w ≤ D at nsD
  dsimp only [s] at ma mb mc
  linarith only [ma,mb,mc,nsD]

end Erdos810.ShadowGap
assert_no_sorry Erdos810.ShadowGap.local_defect
