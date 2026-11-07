## Symmetry (step 2)

Take row map x ↦ x' = ux + v and column map y ↦ y' = sy + t with u, s ∈ F_p^×, v, t ∈ F_p.
An edge (x, ax + β(a)) of colour a goes to

    y' = s(a x + β(a)) + t = (sa/u)·x' + (sβ(a) + t − (sa/u)·v).

So the colour class of slope a becomes the colour class of slope a' = λa with λ = s/u, and

    β'(λa) = s·β(a) + t − λ a v,      D'_{λa} = u·D_a + v.

The map is a bijection of the edge set that preserves 4-cycles and colour classes (it only
renames colours a ↦ λa, which is a permutation of F_p^×), so simplicity, the rainbow property
and m = Σ|D_a| are preserved. On the coefficient plane, (a, β) ↦ (λa, sβ + t − λ a v) is an
invertible affine map, so it sends non-vertical lines to non-vertical lines and preserves the
number of points (a, β(a)) on each line. (Transposing rows and columns gives a' = 1/a,
β'(a') = −β(a)/a; this is also a symmetry, but it is not used in the canonical form.)

**Canonical form used in the exact runs** (`model.py`, `sym=True, symL=True`):

1. the line β = 0 carries the maximum number L of points (a, β(a)), a ∈ F_p^×, over all
   lines β = ua + v;
2. β(1) = 0;
3. the first slope a ∈ {2, 3, …} with β(a) ≠ 0 (if any) has β(a) = 1.

*Soundness.* Start from any valid configuration and let β = ua + v be a line with the maximum
number L ≥ 1 of points (vertical lines carry at most one point, and a non-vertical line through
any point exists). Apply λ = 1, s = 1 (so u = 1, i.e. the row map is x ↦ x + v₀), with
v₀ = u, t = −v: then β'(a) = β(a) − ua − v, which vanishes exactly on that line; occupancies
are preserved, so (1) holds. Pick a₀ with β'(a₀) = 0 and apply λ = 1/a₀ with s = 1, t = v = 0:
β''(a/a₀) = β'(a), so β''(1) = 0 and the zero line keeps L points, giving (1)–(2). Finally,
the scaling u = s, λ = 1, t = v = 0 multiplies β by s and keeps every zero; choose s to make
the first non-zero value equal to 1, giving (3). m is unchanged throughout, so the maximum
over canonical configurations equals the unrestricted maximum. Empty D_a are allowed, and β
on an unused slope is arbitrary, so the normalisation never constrains the supports.

The model with only β(1) = β(2) = 0, β(3) ∈ {0, 1} (an earlier, weaker canonical form; sound by
the same argument with the line through (1, β(1)), (2, β(2))) and the model with no symmetry
breaking at all give the same optima for p = 3, 5, 7.
