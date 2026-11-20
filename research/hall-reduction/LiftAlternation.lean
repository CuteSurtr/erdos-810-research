import LiftRectangles

/-! # The alternating four-edge path is the remaining obstruction to the tripartite lift -/

set_option autoImplicit false
namespace Erdos810.TripartiteLift
variable {X A B C : Type*} {H : Finset X} {a : X → A} {b : X → B} {c : X → C}

/-- A path starts on side B, crosses two distinct points of A and visits three distinct
points of B. Its four edge labels may not alternate between two colors. -/
def NoAlternatingPath (H : Finset X) (a : X → A) (b : X → B) (c : X → C) : Prop :=
  ∀ x ∈ H, ∀ y ∈ H, ∀ z ∈ H, ∀ w ∈ H,
    a x=a y → a z=a w → a x ≠ a z → b y=b z → b x ≠ b y → b x ≠ b w → b z ≠ b w →
    c x=c z → c y=c w → False

private theorem first_third {x y z w : C} (h : [x,y,z,w].Nodup) : x ≠ z := by
  have ne := (List.nodup_cons.mp h).1
  exact fun eq ↦ ne (by simp [eq])

private theorem second_fourth {x y z w : C} (h : [x,y,z,w].Nodup) : y ≠ w := by
  have ne := (List.nodup_cons.mp (List.nodup_cons.mp h).2).1
  exact fun eq ↦ ne (by simp [eq])

theorem Rainbow.swap (h : Rainbow H a b c) : Rainbow H b a c := by
  intro x hx y hy z hz w hw bxw byz axy azw bd ad
  have r := h x hx w hw z hz y hy axy azw.symm bxw byz.symm (fun eq ↦ ad (eq.trans azw.symm))
    (fun eq ↦ bd (eq.trans byz.symm))
  simp only [List.nodup_cons,List.mem_cons,List.not_mem_nil,List.nodup_nil,not_false_eq_true,and_true,not_or] at r ⊢
  obtain ⟨⟨xw,xz,xy⟩,⟨wz,wy⟩,zy⟩ := r
  exact ⟨⟨xy,xz,xw⟩,⟨Ne.symm zy,Ne.symm wy⟩,Ne.symm wz⟩

theorem noAlternating_of_projection (ac : PairInjective H a c) (project : Rainbow H a c b) :
    NoAlternatingPath H a b c := by
  intro x hx y hy z hz w hw axy azw ad byz bxy _ _ cxz cyw
  have cd : c x ≠ c w := by
    intro eq
    have same := ac hx hy (Prod.ext axy (eq.trans cyw.symm))
    exact bxy (congrArg b same)
  have r := project x hx z hz w hw y hy axy azw cxz cyw.symm ad cd
  exact second_fourth r byz.symm

theorem projection_of_noAlternating (ab : PairInjective H a b) (bc : PairInjective H b c)
    (rain : Rainbow H a b c) (path : NoAlternatingPath H a b c) : Rainbow H a c b := by
  intro x hx y hy z hz w hw axw ayz cxy czw ad cd
  have bxy : b x ≠ b y := fun h ↦ ad (congrArg a (bc hx hy (Prod.ext h cxy)))
  have bzw : b z ≠ b w := fun h ↦ ad (axw.trans ((congrArg a (bc hz hw (Prod.ext h czw))).symm.trans ayz.symm))
  have bxw : b x ≠ b w := fun h ↦ cd ((congrArg c (ab hx hw (Prod.ext axw h))).trans czw.symm)
  have byz : b y ≠ b z := fun h ↦ cd (cxy.trans (congrArg c (ab hy hz (Prod.ext ayz h))))
  have both (xz : b x=b z) (yw : b y=b w) : False := by
    have r := rain x hx z hz y hy w hw axw ayz.symm xz yw (fun e ↦ ad (e.trans ayz.symm)) bxy
    exact first_third r cxy
  have bxz : b x ≠ b z := by
    intro eq
    by_cases yw : b y=b w
    · exact both eq yw
    exact path y hy z hz x hx w hw ayz axw ad.symm eq.symm byz yw bxw cxy.symm czw
  have byw : b y ≠ b w := by
    intro eq
    exact path x hx w hw y hy z hz axw ayz ad eq.symm bxw bxz byz cxy czw.symm
  simp only [List.nodup_cons,List.mem_cons,List.not_mem_nil,List.nodup_nil,not_false_eq_true,and_true,not_or]
  exact ⟨⟨bxy,bxz,bxw⟩,⟨byz,byw⟩,bzw⟩

/-- For any finite properly colored simple bipartite graph, the actual lifted triples
are (7,4)-free precisely when all original rectangles are rainbow and there is no
alternating four-edge path starting in either side of the bipartition. -/
theorem free_iff_rainbow_and_no_alternating [DecidableEq X] [DecidableEq A] [DecidableEq B] [DecidableEq C]
    (ab : PairInjective H a b) (ac : PairInjective H a c) (bc : PairInjective H b c) :
    FourTriplesFree (H.image (triple a b c)) ↔ Rainbow H a b c ∧
      NoAlternatingPath H a b c ∧ NoAlternatingPath H b a c := by
  rw [free_iff_three_rainbow ab ac bc]
  constructor
  · rintro ⟨r,p,q⟩
    exact ⟨r,noAlternating_of_projection ac p,noAlternating_of_projection bc q⟩
  · rintro ⟨r,p,q⟩
    exact ⟨r,projection_of_noAlternating ab bc r p,projection_of_noAlternating ab.swap ac r.swap q⟩

end Erdos810.TripartiteLift
#assert_no_sorry Erdos810.TripartiteLift.free_iff_rainbow_and_no_alternating
