import IntegerChart
import ProfilePartition

/-! # A common denominator for the coefficients of a bivariate box certificate -/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate.IntegerBox

abbrev Coeff := Dense (Dense ℤ)

def constant (z : ℤ) : Coeff := ⟨[⟨[z]⟩]⟩
def xVar : Coeff := ⟨[0,1]⟩
def yVar : Coeff := ⟨[⟨[0,1]⟩]⟩

noncomputable def eval (x y : ℝ) := Dense.evaluator (IntegerChart.eval y) x

@[simp] theorem val_constant (z : ℤ) (x y : ℝ) : (eval x y).val (constant z) = z := by
  simp [eval,IntegerChart.eval,IntegerChart.integer,Dense.evaluator,Dense.evalList,constant]

@[simp] theorem val_x (x y : ℝ) : (eval x y).val xVar = x := by
  change 0+x*((((1:ℤ):ℝ)+y*0)+x*0)=x
  norm_num

@[simp] theorem val_y (x y : ℝ) : (eval x y).val yVar = y := by
  change (((0:ℤ):ℝ)+y*(((1:ℤ):ℝ)+y*0)+x*0)=y
  norm_num

structure Value where
  dx : ℕ
  dy : ℕ
  den : ℕ
  num : Coeff
  pos : 0 < den

def scalar (c : ℚ) : Value := ⟨0,0,c.den,constant c.num,c.den_pos⟩
def xOn (lo hi : ℚ) : Value :=
  ⟨1,0,lo.den*hi.den,constant (lo.num*hi.den) + constant (hi.num*lo.den)*xVar,
    Nat.mul_pos lo.den_pos hi.den_pos⟩
def yOn (lo hi : ℚ) : Value :=
  ⟨0,1,lo.den*hi.den,constant (lo.num*hi.den) + constant (hi.num*lo.den)*yVar,
    Nat.mul_pos lo.den_pos hi.den_pos⟩

noncomputable def Value.val (p : Value) (x y : ℝ) :=
  (eval x y).val p.num / ((p.den:ℝ)*(1+x)^p.dx*(1+y)^p.dy)

def liftTo (p : Value) (den dx dy : ℕ) :=
  constant ((den/p.den : ℕ):ℤ) * p.num * power (1+xVar) (dx-p.dx) * power (1+yVar) (dy-p.dy)

def add (p q : Value) : Value :=
  let dx := max p.dx q.dx
  let dy := max p.dy q.dy
  let den := p.den.lcm q.den
  ⟨dx,dy,den,liftTo p den dx dy + liftTo q den dx dy,Nat.lcm_pos p.pos q.pos⟩

def mul (p q : Value) : Value :=
  ⟨p.dx+q.dx,p.dy+q.dy,p.den*q.den,p.num*q.num,Nat.mul_pos p.pos q.pos⟩

theorem lift_correct (p : Value) {d i j : ℕ} (hd : p.den ∣ d) (hi : p.dx ≤ i) (hj : p.dy ≤ j)
    {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) :
    (eval x y).val (liftTo p d i j) = p.val x y * ((d:ℝ)*(1+x)^i*(1+y)^j) := by
  have denpos : 0 < (p.den:ℝ) := by exact_mod_cast p.pos
  have xpos : 0 < 1+x := by linarith
  have ypos : 0 < 1+y := by linarith
  have scale : ((d/p.den:ℕ):ℝ)*(p.den:ℝ)=d := by exact_mod_cast Nat.div_mul_cancel hd
  simp only [liftTo,(eval x y).mul,val_power,(eval x y).add,(eval x y).one,val_constant,
    Int.cast_natCast,val_x,val_y,Value.val]
  set num := (eval x y).val p.num
  conv_rhs => rw [← Nat.add_sub_of_le hi,← Nat.add_sub_of_le hj]
  simp only [pow_add]
  rw [← scale]
  field_simp [denpos.ne',xpos.ne',ypos.ne']

theorem val_add (p q : Value) {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) :
    (add p q).val x y = p.val x y + q.val x y := by
  let d := p.den.lcm q.den
  let i := max p.dx q.dx
  let j := max p.dy q.dy
  change (eval x y).val (liftTo p d i j + liftTo q d i j) / ((d:ℝ)*(1+x)^i*(1+y)^j) = _
  rw [(eval x y).add,lift_correct p (Nat.dvd_lcm_left ..) (le_max_left ..) (le_max_left ..) hx hy,
    lift_correct q (Nat.dvd_lcm_right ..) (le_max_right ..) (le_max_right ..) hx hy]
  have hd : 0 < (d:ℝ) := by exact_mod_cast Nat.lcm_pos p.pos q.pos
  change (_*_+_*_)/((d:ℝ)*(1+x)^i*(1+y)^j)=_
  field_simp [(show (d:ℝ)*(1+x)^i*(1+y)^j ≠ 0 by positivity)]
  ring

theorem val_mul (p q : Value) (x y : ℝ) : (mul p q).val x y = p.val x y*q.val x y := by
  simp only [Value.val,mul,(eval x y).mul,Nat.cast_mul,pow_add]
  ring

def compile (a b c d : ℚ) : Expr → Value
  | .rat k => scalar k
  | .s => xOn a b
  | .t => yOn c d
  | .add p q => add (compile a b c d p) (compile a b c d q)
  | .mul p q => mul (compile a b c d p) (compile a b c d q)

theorem compile_correct (a b c d : ℚ) (e : Expr) {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) :
    (compile a b c d e).val x y = e.eval ((a+b*x)/(1+x)) ((c+d*y)/(1+y)) := by
  have pos (r : ℚ) : (r.den:ℝ) ≠ 0 := by exact_mod_cast r.den_pos.ne'
  induction e with
  | rat k => simp [compile,scalar,Expr.eval,Value.val,Rat.cast_def]
  | s =>
    simp only [compile,xOn,Expr.eval,Value.val,(eval x y).add,(eval x y).mul,val_constant,val_x,
      Int.cast_mul,Int.cast_natCast,Nat.cast_mul,pow_one,pow_zero,mul_one,Rat.cast_def]
    field_simp [pos a,pos b]
  | t =>
    simp only [compile,yOn,Expr.eval,Value.val,(eval x y).add,(eval x y).mul,val_constant,val_y,
      Int.cast_mul,Int.cast_natCast,Nat.cast_mul,pow_one,pow_zero,mul_one,Rat.cast_def]
    field_simp [pos c,pos d]
  | add p q hp hq => exact (val_add _ _ hx hy).trans (congrArg₂ (·+·) hp hq)
  | mul p q hp hq => exact (val_mul _ _ x y).trans (congrArg₂ (·*·) hp hq)

def check (e : Expr) (a b c d : ℚ) :=
  (compile a b c d e).num.coeff.all (fun row ↦ row.coeff.all (fun k ↦ decide (0 ≤ k)))

theorem sound {e : Expr} {a b c d : ℚ} (ab : a < b) (cd : c < d)
    (cert : check e a b c d=true) {s t : ℝ} (hs : s ∈ Set.Icc (a:ℝ) b)
    (ht : t ∈ Set.Icc (c:ℝ) d) : 0 ≤ e.eval s t := by
  let F := fun z : ℝ×ℝ ↦ e.eval z.1 z.2
  have inside : Set.Ico (a:ℝ) b ×ˢ Set.Ico (c:ℝ) d ⊆ {z | 0 ≤ F z} := by
    rintro ⟨s,t⟩ ⟨⟨as,sb⟩,⟨ct,td⟩⟩
    let x := (s-a)/(b-s)
    let y := (t-c)/(d-t)
    have hx : 0 ≤ x := div_nonneg (sub_nonneg.mpr as) (sub_nonneg.mpr sb.le)
    have hy : 0 ≤ y := div_nonneg (sub_nonneg.mpr ct) (sub_nonneg.mpr td.le)
    have chart {u v z : ℝ} (h : u ≤ z) (k : z < v) :
        (u+v*((z-u)/(v-z)))/(1+(z-u)/(v-z))=z := by
      have dv := sub_pos.mpr k
      have den : 0 < 1+(z-u)/(v-z) := by linarith only [div_nonneg (sub_nonneg.mpr h) dv.le]
      apply (div_eq_iff den.ne').mpr
      field_simp [dv.ne']
      ring
    have eq := compile_correct a b c d e hx hy
    rw [show ((a:ℝ)+b*x)/(1+x)=s from chart as sb,
      show ((c:ℝ)+d*y)/(1+y)=t from chart ct td] at eq
    change 0 ≤ e.eval s t
    rw [← eq]
    have den : 0 < ((compile a b c d e).den:ℝ) := by exact_mod_cast (compile a b c d e).pos
    apply div_nonneg _ (by positivity)
    apply Dense.eval_nonneg hx
    intro row hr
    apply Dense.eval_nonneg hy
    intro k hk
    change 0 ≤ (k:ℝ)
    exact_mod_cast of_decide_eq_true (List.all_eq_true.mp (List.all_eq_true.mp cert row hr) k hk)
  have closed : IsClosed {z | 0 ≤ F z} := isClosed_le continuous_const e.eval_continuous
  change (s,t) ∈ {z | 0 ≤ F z}
  apply closure_minimal inside closed
  rw [closure_prod_eq,closure_Ico (by exact_mod_cast ab.ne),closure_Ico (by exact_mod_cast cd.ne)]
  exact ⟨hs,ht⟩

theorem halves {e : Expr} (left : check e 0 (1/2) 0 1=true) (right : check e (1/2) 1 0 1=true) :
    OnSquare e := by
  intro x hx y hy
  by_cases h : x ≤ 1/2
  · exact sound (by norm_num) (by norm_num) left (by norm_num; exact ⟨hx.1,h⟩) (by simpa using hy)
  · exact sound (by norm_num) (by norm_num) right (by norm_num; exact ⟨le_of_not_ge h,hx.2⟩)
      (by simpa using hy)

end Erdos810.PolynomialCertificate.IntegerBox
