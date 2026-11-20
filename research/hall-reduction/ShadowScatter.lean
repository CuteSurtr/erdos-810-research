import ShadowLocal

/-! # A quadratic tradeoff between the defect and the variance at one triple -/

set_option autoImplicit false
namespace Erdos810.ShadowGap

def ScatterOK (α β : ℝ) : Prop :=
  1/9≤α ∧ 0<β ∧ (2+2*β-9*α/2)^2≤4*β*(β+3*α)

private theorem centered_product {α β : ℝ} (ok : ScatterOK α β) (t u : ℝ) :
    2*t*u ≤ α*((9/2)*t*u+3*u^2)+β*(t-u)^2 := by
  let k := 2+2*β-9*α/2
  have slack : 0≤4*β*(β+3*α)-k^2 := sub_nonneg.mpr ok.2.2
  have square := sq_nonneg (2*β*t-k*u)
  have extra := mul_nonneg slack (sq_nonneg u)
  apply (mul_le_mul_iff_right₀ (show 0<4*β by linarith [ok.2.1])).mp
  dsimp [k] at square extra
  nlinarith only [square,extra]

/-- Center the three coordinates independently. The simplex constraint supplies
a budget for both their covariance and the variance of the unused arms. -/
private theorem scatter_core {α β : ℝ} (ok : ScatterOK α β) {t₁ t₂ t₃ u₁ u₂ u₃ D z : ℝ}
    (t1 : 0≤t₁) (t2 : 0≤t₂) (t3 : 0≤t₃) (u1 : 0≤u₁) (u2 : 0≤u₂) (u3 : 0≤u₃)
    (room : 3*(t₁+t₂+t₃)+2*(u₁+u₂+u₃)≤1) (deficit : u₁+u₂+u₃≤D) :
    t₁*(D/3-(u₁+u₂+u₃)+2*u₁)+t₂*(D/3-(u₁+u₂+u₃)+2*u₂)+
      t₃*(D/3-(u₁+u₂+u₃)+2*u₃) ≤ α*D+β*
      ((t₁-u₁-z)^2+(t₂-u₂-z)^2+(t₃-u₃-z)^2) := by
  let p := t₁+t₂+t₃
  let s := u₁+u₂+u₃
  let T₁ := t₁-p/3
  let T₂ := t₂-p/3
  let T₃ := t₃-p/3
  let U₁ := u₁-s/3
  let U₂ := u₂-s/3
  let U₃ := u₃-s/3
  change s≤D at deficit
  change 3*p+2*s≤1 at room
  have ss : 0≤s := by dsimp [s]; linarith
  have cov : T₁*U₁+T₂*U₂+T₃*U₃≤2*p*s/3 := by
    dsimp [T₁,T₂,T₃,U₁,U₂,U₃,p,s]
    nlinarith only [mul_nonneg t1 u2,mul_nonneg t1 u3,mul_nonneg t2 u1,
      mul_nonneg t2 u3,mul_nonneg t3 u1,mul_nonneg t3 u2]
  have usq : U₁^2+U₂^2+U₃^2≤(2/3)*s^2 := by
    dsimp [U₁,U₂,U₃,s]
    nlinarith only [mul_nonneg u1 u2,mul_nonneg u1 u3,mul_nonneg u2 u3]
  have budget : (9/2)*(T₁*U₁+T₂*U₂+T₃*U₃)+3*(U₁^2+U₂^2+U₃^2)≤s := by
    nlinarith only [cov,usq,mul_le_mul_of_nonneg_right room ss]
  have center : (T₁-U₁)^2+(T₂-U₂)^2+(T₃-U₃)^2 ≤
      (t₁-u₁-z)^2+(t₂-u₂-z)^2+(t₃-u₃-z)^2 := by
    dsimp [T₁,T₂,T₃,U₁,U₂,U₃,p,s]
    nlinarith only [sq_nonneg ((t₁+t₂+t₃-u₁-u₂-u₃)-3*z)]
  have pay := mul_le_mul_of_nonneg_left budget (show 0≤α by linarith [ok.1])
  have lift := mul_le_mul_of_nonneg_left center ok.2.1.le
  have part := mul_le_mul_of_nonneg_right (show p/3≤α by linarith [ok.1]) (sub_nonneg.mpr deficit)
  have identity : t₁*(D/3-s+2*u₁)+t₂*(D/3-s+2*u₂)+t₃*(D/3-s+2*u₃) =
      (p/3)*(D-s)+2*(T₁*U₁+T₂*U₂+T₃*U₃) := by dsimp [T₁,T₂,T₃,U₁,U₂,U₃,p,s]; ring
  change t₁*(D/3-s+2*u₁)+t₂*(D/3-s+2*u₂)+t₃*(D/3-s+2*u₃)≤_
  rw [identity]
  nlinarith only [part,pay,lift,centered_product ok T₁ U₁,centered_product ok T₂ U₂,centered_product ok T₃ U₃]

theorem local_scatter_with {α β : ℝ} (ok : ScatterOK α β) {h x y z a b c r : ℝ} (hh : 0≤h)
    (ha : h≤a) (hb : h≤b) (hc : h≤c)
    (armx : a+c≤x+h) (army : a+b≤y+h) (armz : b+c≤z+h)
    (nonneg : 0≤pairDefect x y a+pairDefect y z b+pairDefect z x c) :
    a*pairDefect x y a+b*pairDefect y z b+c*pairDefect z x c ≤
      (α+h)*rootDefect h x y z+β*((x-r)^2+(y-r)^2+(z-r)^2) := by
  let ta := a-h
  let tb := b-h
  let tc := c-h
  let u := z+h-b-c
  let v := x+h-a-c
  let w := y+h-a-b
  let D := rootDefect h x y z
  have nu : 0≤u := by dsimp [u]; linarith
  have nv : 0≤v := by dsimp [v]; linarith
  have nw : 0≤w := by dsimp [w]; linarith
  have identity : pairDefect x y a+pairDefect y z b+pairDefect z x c=D-(u+v+w) := by
    dsimp [D,u,v,w,rootDefect,pairDefect]; ring
  have ds : u+v+w≤D := by linarith only [identity,nonneg]
  have room : 3*(ta+tb+tc)+2*(u+v+w)≤1 := by
    dsimp [D,ta,tb,tc,u,v,w,rootDefect] at *
    linarith only [ds,hh]
  have key := scatter_core ok (t₁ := ta) (t₂ := tb) (t₃ := tc) (z := h+ta+tb+tc-r)
    (sub_nonneg.mpr ha) (sub_nonneg.mpr hb) (sub_nonneg.mpr hc) nu nv nw room ds
  have pay := mul_nonneg hh (show 0≤u+v+w by linarith)
  dsimp [D,ta,tb,tc,u,v,w,rootDefect,pairDefect] at key pay ⊢
  nlinarith only [key,pay]

theorem local_scatter {h x y z a b c r : ℝ} (hh : 0≤h)
    (ha : h≤a) (hb : h≤b) (hc : h≤c)
    (armx : a+c≤x+h) (army : a+b≤y+h) (armz : b+c≤z+h)
    (nonneg : 0≤pairDefect x y a+pairDefect y z b+pairDefect z x c) :
    a*pairDefect x y a+b*pairDefect y z b+c*pairDefect z x c ≤
      (5/17+h)*rootDefect h x y z+(30/17)*((x-r)^2+(y-r)^2+(z-r)^2) := by
  exact local_scatter_with (α := 5/17) (β := 30/17) (by norm_num [ScatterOK]) hh ha hb hc armx army armz nonneg

end Erdos810.ShadowGap
assert_no_sorry Erdos810.ShadowGap.local_scatter_with
assert_no_sorry Erdos810.ShadowGap.local_scatter
