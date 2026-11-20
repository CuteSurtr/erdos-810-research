import ProfileFormula

/-! # Integer arithmetic for checking a univariate polynomial on a rational interval

Each intermediate polynomial has one common positive denominator. Homogenizing
only the first variable avoids a rational normalization for every coefficient.
-/

set_option autoImplicit false
namespace Erdos810.PolynomialCertificate.IntegerChart

noncomputable def integer : Evaluator ℤ where
  val n := n
  zero := Int.cast_zero
  one := Int.cast_one
  add := Int.cast_add
  mul := Int.cast_mul

abbrev Coeff := Dense ℤ
def con (v : ℤ) : Coeff := ⟨[v]⟩
def linear : Coeff := ⟨[1,1]⟩

noncomputable def eval (x : ℝ) := Dense.evaluator integer x

@[simp] theorem eval_con (v : ℤ) (x : ℝ) : (eval x).val (con v)=v := by
  simp [eval,Dense.evaluator,integer,con,Dense.evalList]

@[simp] theorem eval_linear (x : ℝ) : (eval x).val linear=1+x := by
  simp [eval,Dense.evaluator,integer,linear,Dense.evalList]

def raiseDegree (p : Coeff) : ℕ → Coeff
  | 0 => p
  | k+1 => let q := raiseDegree p k; ⟨Dense.addList q.coeff (0::q.coeff)⟩

theorem raiseDegree_correct (p : Coeff) (k : ℕ) (x : ℝ) :
    (eval x).val (raiseDegree p k)=(eval x).val p*(1+x)^k := by
  induction k with
  | zero => simp [raiseDegree]
  | succ k ih =>
    let q := raiseDegree p k
    have eq : (eval x).val (⟨0::q.coeff⟩ : Coeff)=x*(eval x).val q := by
      simp [eval,Dense.evaluator,Dense.evalList,integer]
    change (eval x).val (q+(⟨0::q.coeff⟩ : Coeff))=_
    rw [(eval x).add,eq]
    change (eval x).val (raiseDegree p k)+x*(eval x).val (raiseDegree p k)=_
    rw [ih,pow_succ]; ring

structure Value where
  deg : ℕ
  den : ℕ
  num : Coeff
  pos : 0 < den

def scalar (c : ℚ) : Value := ⟨0,c.den,con c.num,c.den_pos⟩
def variableOn (a b : ℚ) : Value :=
  ⟨1,a.den*b.den,⟨[a.num*b.den,b.num*a.den]⟩,Nat.mul_pos a.den_pos b.den_pos⟩

def add (p q : Value) : Value :=
  let k := max p.deg q.deg
  let d := p.den.lcm q.den
  let a := con ((d/p.den : ℕ):ℤ) * raiseDegree p.num (k-p.deg)
  let b := con ((d/q.den : ℕ):ℤ) * raiseDegree q.num (k-q.deg)
  ⟨k,d,a+b,Nat.lcm_pos p.pos q.pos⟩

def mul (p q : Value) : Value := ⟨p.deg+q.deg,p.den*q.den,p.num*q.num,Nat.mul_pos p.pos q.pos⟩

noncomputable def Value.val (p : Value) (x : ℝ) := (eval x).val p.num/((p.den:ℝ)*(1+x)^p.deg)

theorem val_scalar (c : ℚ) (x : ℝ) : (scalar c).val x=c := by
  simp only [Value.val,scalar,eval_con,pow_zero,mul_one,Rat.cast_def]

theorem val_variable (a b : ℚ) (x : ℝ) : (variableOn a b).val x=((a:ℝ)+b*x)/(1+x) := by
  have ha : (a.den:ℝ) ≠ 0 := by exact_mod_cast a.den_pos.ne'
  have hb : (b.den:ℝ) ≠ 0 := by exact_mod_cast b.den_pos.ne'
  simp only [Value.val,variableOn,eval,Dense.evaluator,Dense.evalList,integer,Int.cast_mul,
    Int.cast_natCast,Nat.cast_mul,pow_one,mul_zero,add_zero,Rat.cast_def]
  field_simp

theorem val_add (p q : Value) {x : ℝ} (hx : 0 ≤ x) : (add p q).val x=p.val x+q.val x := by
  let k := max p.deg q.deg
  let d := p.den.lcm q.den
  have hd : 0<(d:ℝ) := by exact_mod_cast Nat.lcm_pos p.pos q.pos
  have xx : 0 < 1+x := by linarith
  have lift (v : Value) (divides : v.den ∣ d) (degree : v.deg ≤ k) :
      (eval x).val (con ((d/v.den:ℕ):ℤ)*raiseDegree v.num (k-v.deg))=
        v.val x*((d:ℝ)*(1+x)^k) := by
    rw [(eval x).mul,eval_con,raiseDegree_correct]
    have scale : ((d/v.den:ℕ):ℝ)*(v.den:ℝ)=d := by exact_mod_cast Nat.div_mul_cancel divides
    have pow : (1+x)^v.deg*(1+x)^(k-v.deg)=(1+x)^k := by rw [← pow_add,Nat.add_sub_of_le degree]
    have vd : (v.den:ℝ) ≠ 0 := by exact_mod_cast v.pos.ne'
    simp only [Int.cast_natCast,Value.val]
    field_simp [vd,ne_of_gt xx]
    linear_combination ((eval x).val v.num*(1+x)^k)*scale + ((d/v.den:ℕ):ℝ)*(v.den:ℝ)*(eval x).val v.num*pow
  change (eval x).val (_+_) / ((d:ℝ)*(1+x)^k)=_
  rw [(eval x).add,lift p (Nat.dvd_lcm_left ..) (le_max_left ..),lift q (Nat.dvd_lcm_right ..) (le_max_right ..)]
  have nz : (d:ℝ)*(1+x)^k ≠ 0 := by positivity
  field_simp

theorem val_mul (p q : Value) (x : ℝ) : (mul p q).val x=p.val x*q.val x := by
  simp only [Value.val,mul,(eval x).mul,Nat.cast_mul,pow_add]
  ring

def compile (a b : ℚ) : Expr → Value
  | .rat c => scalar c
  | .s => variableOn a b
  | .t => scalar 0
  | .add p q => add (compile a b p) (compile a b q)
  | .mul p q => mul (compile a b p) (compile a b q)

theorem compile_correct (a b : ℚ) (e : Expr) {x : ℝ} (hx : 0 ≤ x) :
    (compile a b e).val x=e.eval (((a:ℝ)+b*x)/(1+x)) 0 := by
  induction e with
  | rat v => exact val_scalar _ _
  | s => exact val_variable ..
  | t => simp [compile,val_scalar,Expr.eval]
  | add p q hp hq => exact (val_add _ _ hx).trans (congrArg₂ (·+·) hp hq)
  | mul p q hp hq => exact (val_mul _ _ _).trans (congrArg₂ (·*·) hp hq)

def check (e : Expr) (a b : ℚ) := (compile a b e).num.coeff.all (fun k ↦ decide (0 ≤ k))

theorem sound {e : Expr} {a b : ℚ} (ab : a < b) (cert : check e a b=true) :
    ∀ z ∈ Set.Icc (a:ℝ) b, 0 ≤ e.eval z 0 := by
  have inside : Set.Ico (a:ℝ) b ⊆ {z : ℝ | 0 ≤ e.eval z 0} := by
    intro z hz
    let x := (z-a)/(b-z)
    have x0 : 0 ≤ x := div_nonneg (sub_nonneg.mpr hz.1) (sub_nonneg.mpr hz.2.le)
    have xx : 0 < 1+x := by linarith
    have eq : ((a:ℝ)+b*x)/(1+x)=z := by
      apply (div_eq_iff xx.ne').mpr
      dsimp [x]
      field_simp [(sub_pos.mpr hz.2).ne']
      ring
    have identity := compile_correct a b e x0
    rw [eq] at identity
    change 0 ≤ e.eval z 0
    rw [← identity]
    apply div_nonneg _ (by positivity)
    apply Dense.eval_nonneg x0
    intro k hk
    change 0 ≤ (k:ℝ)
    exact_mod_cast of_decide_eq_true (List.all_eq_true.mp cert k hk)
  have cont : Continuous (fun z : ℝ ↦ e.eval z 0) := e.eval_continuous.comp (continuous_id.prodMk continuous_const)
  have closed : IsClosed {z : ℝ | 0 ≤ e.eval z 0} := isClosed_le continuous_const cont
  have onClosure := closure_minimal inside closed
  rw [closure_Ico (by exact_mod_cast ab.ne)] at onClosure
  exact fun z hz ↦ onClosure hz

end Erdos810.PolynomialCertificate.IntegerChart
