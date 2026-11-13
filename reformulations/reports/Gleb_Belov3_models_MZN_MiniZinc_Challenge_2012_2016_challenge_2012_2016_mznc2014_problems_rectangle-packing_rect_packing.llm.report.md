# Square-Packing Model and MILP Reformulation

## 1. Problem background

The model places squares of side lengths \(1,2,\ldots,n\) inside an axis-aligned rectangle without overlap. This is an idealized layout problem relevant to material cutting, component placement, and space allocation. Squares may touch each other or the rectangle boundary.

The rectangle’s width and height are variable, with `Height <= Width`. Their domains and the area domain are calculated from \(n\). An input flag determines whether the unit square participates in containment and non-overlap constraints. When excluded, its coordinates are fixed to \((0,0)\); nevertheless, the original lower bound on rectangle area still includes its area.

Although the source comments describe finding a minimum-area rectangle, the actual solve item is **`satisfy`**, not `minimize Area`. Its search annotations prioritize small values of area and height, but do not declare an optimization objective. The reformulation preserves satisfaction semantics.

## 2. Original model structure

### Variables

The model has \(2n+3\) primary integer variables:

- `X[i]`, `Y[i]`: lower-left coordinates of square \(i\);
- `Width`, `Height`: rectangle dimensions;
- `Area`: rectangle area.

Four additional arrays, `X_div`, `X_rem`, `Y_div`, and `Y_rem`, support the original search strategy. Their entries are aliases, constants, or auxiliary integer variables, depending on the square’s size. For applicable squares, quotient/remainder equations connect them to the coordinates.

### Constraints

The original formulation includes:

- **Containment:** each considered square lies inside the rectangle.
- **Non-overlap:** a `diffn` global constraint separates all considered squares.
- **Cumulative constraints:** horizontal and vertical projections must not overload the corresponding rectangle dimension.
- **Dimension and area relations:** `Height <= Width` and `Area = Height * Width`, together with declared bounds.
- **Reflection symmetry restrictions:** the largest square’s origin lies in the lower-left half of its available placement range.
- **Forbidden-gap restrictions:** a fixed table controls allowable distances between square edges and rectangle boundaries. These restrictions have different branches depending on the available coordinate range.
- **Excluded-unit-square handling:** when the unit square is ignored geometrically, its coordinates are fixed to zero.

The forbidden-gap restrictions are part of the supplied model’s feasible set. The reformulation retains them rather than assuming that they can be removed or strengthened.

## 3. Reformulation and justification

### Explicit linear non-overlap

The `diffn` constraint was replaced by binary-controlled separation inequalities for every pair of considered squares. Each pair selects one of four directions: left, right, below, or above.

This is exact because two positive-size, axis-aligned squares have disjoint interiors precisely when at least one of these separations holds. Selecting exactly one direction does not exclude placements satisfying multiple directions: any one valid direction can serve as the selected certificate.

The inequalities use `max_width` or `max_height` as big-\(M\) constants. These values are sufficient because containment implies
\[
X_i+i\leq \texttt{max\_width},
\qquad
Y_i+i\leq \texttt{max\_height},
\]
and all coordinates are nonnegative. Consequently, every unselected separation inequality is automatically satisfied.

### Removal of redundant cumulative constraints

The two cumulative constraints were omitted.

Their validity already follows from containment and non-overlap. At any horizontal coordinate, the squares whose horizontal projections cover that coordinate must have disjoint vertical interiors. Their total heights therefore cannot exceed `Height`. The corresponding argument at a vertical coordinate bounds the sum of widths by `Width`.

Thus, explicit non-overlap and containment imply both cumulative constraints. Removing them preserves feasible placements while avoiding their additional MILP decompositions.

### Exact linearization of rectangle area

The nonlinear equality
\[
\texttt{Area}=\texttt{Height}\times\texttt{Width}
\]
was replaced by a disaggregated formulation over the possible positive integer heights.

For each height \(h\), a binary selector indicates whether that height is chosen, and a width contribution \(w_h\) is forced to zero unless its selector is active. Exactly one height is selected, with
\[
\texttt{Height}=\sum_h h z_h,\qquad
\texttt{Width}=\sum_h w_h,\qquad
\texttt{Area}=\sum_h h w_h.
\]

Because only one selector is active, its width contribution equals `Width`, making the area equation exact. Conversely, any original feasible rectangle can activate its own height alternative and assign its width to that alternative.

### Height-dependent bounds and packing cuts

Each height alternative receives tighter width bounds derived from existing constraints:

- `Height <= Width` gives \(W\geq h\).
- The area lower bound gives \(W\geq\lceil\texttt{min\_area}/h\rceil\).
- The area upper bound gives \(W\leq\lfloor\texttt{max\_area}/h\rfloor\).
- The original width bounds remain in effect.

A problem-specific packing bound is also included:
\[
W\geq
\sum_{\substack{i\text{ considered}\\2i>h}} i.
\]

To justify it, any two squares taller than \(h/2\) have combined heights greater than \(h\), so containment prevents them from being vertically separated. Non-overlap therefore requires their horizontal projections to be mutually disjoint. Their widths must consequently sum to at most \(W\).

These are derived bounds, not additional assumptions about the instance.

### Pairwise separation strengthening

If a pair selects horizontal separation, containment implies \(W\geq i+j\). Similarly, vertical separation implies \(H\geq i+j\). The reformulation adds these implications as linear inequalities.

It also disables horizontal separation when \(i+j>\texttt{max\_width}\), and vertical separation when \(i+j>\texttt{max\_height}\). Such directions cannot occur in any contained placement. These bounds and fixed binary values strengthen the formulation without eliminating feasible original solutions.

## 4. Interface and solution preservation

The external data interface, fixed tables, original coordinate variables, dimension variables, and quotient/remainder definitions are retained. The original symmetry and forbidden-gap restrictions are unchanged.

The final mapping script copies `X`, `Y`, `Width`, `Height`, and `Area` from the default DZN solution, preserving array index encodings and omitting reformulation-specific auxiliaries.

The changes target HiGHS by replacing geometric globals and a variable product with explicit mixed-integer linear constraints. They are intended to improve formulation strength and avoid costly generic decompositions; no instance-specific runtime improvement has been established here.
