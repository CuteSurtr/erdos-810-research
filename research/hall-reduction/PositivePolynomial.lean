import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Topology.Order.DenselyOrdered
import Mathlib.Tactic

/-! # Exact positivity certificates on rational rectangles

On a box [a,b] × [c,d], replace each variable by a Möbius parameter,
for example (a+bX)/(1+X). A nonnegative coefficient numerator proves
nonnegativity on the box, by continuity at its top and right boundaries.
-/

set_option autoImplicit false

namespace Erdos810.PolynomialCertificate

/-- Dense univariate coefficients, in increasing degree. Iterating this type
gives a bivariate representation with executable rational arithmetic. -/
structure Dense (α : Type*) where
  coeff : List α
deriving Inhabited

namespace Dense

variable {α : Type*}

def addList [Add α] : List α → List α → List α
  | [], ys => ys
  | xs, [] => xs
  | x::xs, y::ys => (x+y)::addList xs ys

def mulList [Zero α] [Add α] [Mul α] : List α → List α → List α
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => addList ((y::ys).map (x*·)) (0::mulList xs (y::ys))

instance [Zero α] : Zero (Dense α) := ⟨⟨[]⟩⟩
instance [One α] : One (Dense α) := ⟨⟨[1]⟩⟩
instance [Add α] : Add (Dense α) := ⟨fun p q ↦ ⟨addList p.coeff q.coeff⟩⟩
instance [Zero α] [Add α] [Mul α] : Mul (Dense α) := ⟨fun p q ↦ ⟨mulList p.coeff q.coeff⟩⟩

def evalList (f : α → ℝ) (v : ℝ) : List α → ℝ
  | [] => 0
  | x::xs => f x+v*evalList f v xs

end Dense

/-- The identities required of a coefficient evaluator. -/
structure Evaluator (α : Type*) [Zero α] [One α] [Add α] [Mul α] where
  val : α → ℝ
  zero : val 0 = 0
  one : val 1 = 1
  add : ∀ a b, val (a+b) = val a + val b
  mul : ∀ a b, val (a*b) = val a * val b

namespace Dense
variable {α : Type*} [Zero α] [One α] [Add α] [Mul α]
variable (f : Evaluator α) (v : ℝ)

private theorem eval_addList (p q : List α) :
    evalList f.val v (addList p q) = evalList f.val v p + evalList f.val v q := by
  induction p generalizing q with
  | nil => simp [addList, evalList]
  | cons a p ih =>
    cases q with
    | nil => simp [addList, evalList]
    | cons b q => simp only [addList, evalList, f.add, ih]; ring

private theorem eval_scale (a : α) (p : List α) :
    evalList f.val v (p.map (a*·)) = f.val a * evalList f.val v p := by
  induction p with
  | nil => simp [evalList]
  | cons b p ih => simp only [List.map_cons, evalList, f.mul, ih]; ring

private theorem eval_mulList (p q : List α) :
    evalList f.val v (mulList p q) = evalList f.val v p * evalList f.val v q := by
  induction p generalizing q with
  | nil => simp [mulList, evalList]
  | cons a p ih =>
    cases q with
    | nil => simp [mulList, evalList]
    | cons b q =>
      rw [mulList, eval_addList, eval_scale]
      simp only [evalList, f.zero, ih]
      ring

noncomputable def evaluator : Evaluator (Dense α) where
  val p := evalList f.val v p.coeff
  zero := rfl
  one := by change f.val 1+v*0=1; rw [f.one]; ring
  add p q := eval_addList f v p.coeff q.coeff
  mul p q := eval_mulList f v p.coeff q.coeff

omit [Zero α] [One α] [Add α] [Mul α] in
theorem eval_nonneg {f : α → ℝ} {v : ℝ} (hv : 0 ≤ v) {p : List α}
    (hp : ∀ a ∈ p, 0 ≤ f a) : 0 ≤ evalList f v p := by
  induction p with
  | nil => exact le_rfl
  | cons a p ih =>
    exact add_nonneg (hp a (List.mem_cons_self ..))
      (mul_nonneg hv (ih (fun x hx ↦ hp x (List.mem_cons_of_mem _ hx))))

end Dense

abbrev Bivar := Dense (Dense ℚ)
def constant (c : ℚ) : Bivar := ⟨[⟨[c]⟩]⟩
def varX : Bivar := ⟨[0,1]⟩
def varY : Bivar := ⟨[⟨[0,1]⟩]⟩

def power {α : Type*} [One α] [Mul α] (p : α) : ℕ → α
  | 0 => 1
  | k+1 => power p k * p

private noncomputable def rational : Evaluator ℚ where
  val q := (q:ℝ)
  zero := Rat.cast_zero
  one := Rat.cast_one
  add := Rat.cast_add
  mul := Rat.cast_mul

noncomputable def bival (X Y : ℝ) : Evaluator Bivar :=
  Dense.evaluator (Dense.evaluator rational Y) X

@[simp] theorem bival_constant (c : ℚ) (X Y : ℝ) :
    (bival X Y).val (constant c) = c := by
  simp [bival, Dense.evaluator, Dense.evalList, constant, rational]

@[simp] theorem bival_X (X Y : ℝ) : (bival X Y).val varX = X := by
  change (0+X*((((1:ℚ):ℝ)+Y*0)+X*0))=X
  norm_num

@[simp] theorem bival_Y (X Y : ℝ) : (bival X Y).val varY = Y := by
  change (((0:ℚ):ℝ)+Y*(((1:ℚ):ℝ)+Y*0)+X*0)=Y
  norm_num

theorem val_power {α : Type*} [Zero α] [One α] [Add α] [Mul α]
    (f : Evaluator α) (p : α) (n : ℕ) : f.val (power p n) = (f.val p)^n := by
  induction n with
  | zero => simp [power,f.one]
  | succ k ih => rw [power,f.mul,ih,pow_succ]

def positiveCoefficients (p : Bivar) : Bool :=
  p.coeff.all (fun row ↦ row.coeff.all (fun c ↦ decide (0 ≤ c)))

theorem positiveCoefficients_sound {p : Bivar} (h : positiveCoefficients p = true)
    {X Y : ℝ} (hx : 0 ≤ X) (hy : 0 ≤ Y) : 0 ≤ (bival X Y).val p := by
  apply Dense.eval_nonneg hx
  intro row hr
  apply Dense.eval_nonneg hy
  intro c hc
  have hrow := (List.all_eq_true.mp h) row hr
  have hc' := of_decide_eq_true ((List.all_eq_true.mp hrow) c hc)
  change (0:ℝ) ≤ (c:ℝ)
  exact_mod_cast hc'

/-- The numerator, together with the powers of 1+X and 1+Y in its denominator. -/
structure Homogeneous where
  dx : ℕ
  dy : ℕ
  num : Bivar

namespace Homogeneous

def const (c : ℚ) : Homogeneous := ⟨0,0,constant c⟩
def x (lo hi : ℚ) : Homogeneous := ⟨1,0,constant lo+constant hi*varX⟩
def y (lo hi : ℚ) : Homogeneous := ⟨0,1,constant lo+constant hi*varY⟩

def liftTo (p : Homogeneous) (i j : ℕ) : Bivar :=
  p.num * power (1+varX) (i-p.dx) * power (1+varY) (j-p.dy)

def add (p q : Homogeneous) : Homogeneous :=
  let i := max p.dx q.dx
  let j := max p.dy q.dy
  ⟨i,j,p.liftTo i j + q.liftTo i j⟩

def mul (p q : Homogeneous) : Homogeneous := ⟨p.dx+q.dx,p.dy+q.dy,p.num*q.num⟩

noncomputable def val (p : Homogeneous) (X Y : ℝ) : ℝ :=
  (bival X Y).val p.num / ((1+X)^p.dx*(1+Y)^p.dy)

theorem lift_correct (p : Homogeneous) {i j : ℕ} (hi : p.dx ≤ i) (hj : p.dy ≤ j)
    {X Y : ℝ} (hX : 0 ≤ X) (hY : 0 ≤ Y) :
    (bival X Y).val (p.liftTo i j) = p.val X Y * ((1+X)^i*(1+Y)^j) := by
  simp only [liftTo, (bival X Y).mul, val_power, (bival X Y).add, (bival X Y).one, bival_X, bival_Y]
  rw [show i = p.dx+(i-p.dx) from (Nat.add_sub_of_le hi).symm,
    show j = p.dy+(j-p.dy) from (Nat.add_sub_of_le hj).symm]
  simp only [Nat.add_sub_cancel_left,pow_add,val]
  have ax : 1+X ≠ 0 := by linarith
  have ay : 1+Y ≠ 0 := by linarith
  field_simp

theorem val_add (p q : Homogeneous) {X Y : ℝ} (hx : 0 ≤ X) (hy : 0 ≤ Y) :
    (p.add q).val X Y = p.val X Y+q.val X Y := by
  let i := max p.dx q.dx
  let j := max p.dy q.dy
  change ((bival X Y).val (p.liftTo i j+q.liftTo i j)) / _ = _
  rw [(bival X Y).add, lift_correct p (le_max_left ..) (le_max_left ..) hx hy,
    lift_correct q (le_max_right ..) (le_max_right ..) hx hy]
  change _ / ((1+X)^i*(1+Y)^j) = _
  have d : (1+X)^i*(1+Y)^j ≠ 0 := by positivity
  field_simp
  dsimp [i,j]
  ring

theorem val_mul (p q : Homogeneous) (X Y : ℝ) :
    (p.mul q).val X Y = p.val X Y*q.val X Y := by
  simp only [mul,val,(bival X Y).mul,pow_add]
  ring

end Homogeneous

inductive Expr where
  | rat (c : ℚ)
  | s | t
  | add (p q : Expr) | mul (p q : Expr)

namespace Expr

def compile (s₀ s₁ t₀ t₁ : ℚ) : Expr → Homogeneous
  | rat c => .const c
  | s => .x s₀ s₁
  | t => .y t₀ t₁
  | add p q => (compile s₀ s₁ t₀ t₁ p).add (compile s₀ s₁ t₀ t₁ q)
  | mul p q => (compile s₀ s₁ t₀ t₁ p).mul (compile s₀ s₁ t₀ t₁ q)

noncomputable def eval (s₀ t₀ : ℝ) : Expr → ℝ
  | rat c => c
  | s => s₀
  | t => t₀
  | add p q => eval s₀ t₀ p+eval s₀ t₀ q
  | mul p q => eval s₀ t₀ p*eval s₀ t₀ q

theorem eval_continuous (E : Expr) : Continuous (fun z : ℝ×ℝ ↦ E.eval z.1 z.2) := by
  induction E with
  | rat c => exact continuous_const
  | s => exact continuous_fst
  | t => exact continuous_snd
  | add p q hp hq => exact hp.add hq
  | mul p q hp hq => exact hp.mul hq

theorem compile_correct (E : Expr) (a b c d : ℚ) {X Y : ℝ} (hx : 0 ≤ X) (hy : 0 ≤ Y) :
    (compile a b c d E).val X Y = E.eval ((a+b*X)/(1+X)) ((c+d*Y)/(1+Y)) := by
  induction E with
  | rat k => simp [compile,eval,Homogeneous.const,Homogeneous.val]
  | s => simp [compile,eval,Homogeneous.x,Homogeneous.val,(bival X Y).add,(bival X Y).mul]
  | t => simp [compile,eval,Homogeneous.y,Homogeneous.val,(bival X Y).add,(bival X Y).mul]
  | add p q hp hq => exact (Homogeneous.val_add _ _ hx hy).trans (congrArg₂ (·+·) hp hq)
  | mul p q hp hq => exact (Homogeneous.val_mul _ _ X Y).trans (congrArg₂ (·*·) hp hq)

def checkBox (E : Expr) (a b c d : ℚ) := positiveCoefficients (compile a b c d E).num

theorem box_sound (E : Expr) {a b c d : ℚ} (hab : a < b) (hcd : c < d)
    (cert : E.checkBox a b c d = true) {s₀ t₀ : ℝ}
    (hs : s₀ ∈ Set.Icc (a:ℝ) b) (ht : t₀ ∈ Set.Icc (c:ℝ) d) : 0 ≤ E.eval s₀ t₀ := by
  let F := fun z : ℝ×ℝ ↦ E.eval z.1 z.2
  let B := (Set.Ico (a:ℝ) b) ×ˢ (Set.Ico (c:ℝ) d)
  have inside : B ⊆ {z | 0 ≤ F z} := by
    rintro ⟨x,y⟩ ⟨⟨ax,xb⟩,⟨cy,yd⟩⟩
    let X := (x-a)/(b-x)
    let Y := (y-c)/(d-y)
    have hx : 0 ≤ X := div_nonneg (sub_nonneg.mpr ax) (sub_nonneg.mpr xb.le)
    have hy : 0 ≤ Y := div_nonneg (sub_nonneg.mpr cy) (sub_nonneg.mpr yd.le)
    have chart {i j z : ℝ} (hz : i ≤ z) (hj : z < j) :
        (i+j*((z-i)/(j-z)))/(1+(z-i)/(j-z)) = z := by
      have dz : 0 < j-z := sub_pos.mpr hj
      have pos : 0 < 1+(z-i)/(j-z) := by linarith only [div_nonneg (sub_nonneg.mpr hz) dz.le]
      apply (div_eq_iff (ne_of_gt pos)).mpr
      field_simp [ne_of_gt dz]
      ring
    have val := compile_correct E a b c d hx hy
    rw [show ((a:ℝ)+b*X)/(1+X)=x from chart ax xb,
      show ((c:ℝ)+d*Y)/(1+Y)=y from chart cy yd] at val
    change 0 ≤ E.eval x y
    rw [← val]
    exact div_nonneg (positiveCoefficients_sound cert hx hy) (by positivity)
  have closed : IsClosed {z | 0 ≤ F z} := isClosed_le continuous_const E.eval_continuous
  change (s₀,t₀) ∈ {z | 0 ≤ F z}
  apply (closure_minimal inside closed)
  change (s₀,t₀) ∈ closure (Set.Ico (a:ℝ) b ×ˢ Set.Ico (c:ℝ) d)
  rw [closure_prod_eq, closure_Ico (by exact_mod_cast hab.ne), closure_Ico (by exact_mod_cast hcd.ne)]
  exact ⟨hs,ht⟩

end Expr
end Erdos810.PolynomialCertificate
