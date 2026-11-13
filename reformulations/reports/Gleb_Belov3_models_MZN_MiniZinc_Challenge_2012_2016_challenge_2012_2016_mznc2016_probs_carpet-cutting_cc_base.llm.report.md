# Carpet Cutting: Model and Reformulation Report

## Real-world background

The model describes cutting room and stair carpets from a roll of fixed width. It minimizes the length of roll consumed, thereby reducing material use.

Room carpets are represented as collections of rectangles with fixed relative offsets. Each room has a prescribed set of allowed orientations among 0°, 90°, 180°, and 270°. Choosing an orientation determines the component rectangles’ dimensions and their offsets from the room’s origin.

Stair carpets are represented by sequences of rectangular step units. These units may form several pieces, subject to limits on the number of breaks and minimum piece sizes. All carpet rectangles must fit within the roll and avoid overlap.

## Original model structure

### Variables and objective

The original independent top-level variables are:

- An integer roll length, `objective`.
- For each room, two integer origin coordinates, an integer orientation, and two Boolean orientation indicators.
- For each room rectangle, two integer origin coordinates.
- For each stair-step rectangle, two integer origin coordinates.

Thus, the model declares
\[
1+3n_{\rm rm}+2n_{\rm rm\_rec}+2n_{\rm st\_rec}
\]
independent top-level integer variables and \(2n_{\rm rm}\) top-level Boolean variables. Room-rectangle lengths and widths are derived variable expressions. Stair constraints also introduce one local Boolean `last_part` per step.

The objective is to **minimize roll length**. Its declared lower bound is the ceiling of the model’s total-area expression divided by roll width. Its upper bound is the smaller of the externally supplied maximum length and a length estimate derived from room and stair dimensions.

### Constraints

The formulation combines:

1. **Containment:** Room bounding boxes, room rectangles, and stair-step rectangles must fit within the selected roll length and fixed width.
2. **Orientation consistency:** Each room chooses an allowed orientation, and the two Boolean indicators encode its orientation class.
3. **Rigid room geometry:** Each room rectangle’s origin equals its room origin plus the offset associated with the selected orientation.
4. **Stair ordering and partitioning:** Symmetry-breaking constraints order steps by vertical position and then horizontal position. Local Booleans identify piece endings, restrict their number, and enforce minimum piece sizes.
5. **Cumulative capacity constraints:** Two cumulative constraints limit occupied capacity along the roll’s length and width.
6. **Rectangle non-overlap:** A `diffn` constraint applies to all room and stair rectangles.

The model also supplies a search annotation that prioritizes orientation indicators, coordinates, and finally roll length. Its usefulness depends on the solver backend.

## Reformulation

The reformulation targets the HiGHS mixed-integer backend. It retains all original independent variables and preserves the original packing, stair, objective, and search structures.

### Shared one-hot orientation encoding

Four binary selectors are introduced per room, one for each orientation. Exactly one selector is active. The original orientation variable is linked to their weighted sum:
\[
v_i=\sum_{o=1}^{4}o\,z_{io},
\qquad
\sum_{o=1}^{4}z_{io}=1.
\]

The original orientation indicators are linked to the relevant selector sums:
\[
b_i^{0/180}=z_{i1}+z_{i3},
\qquad
b_i^{0/90}=z_{i1}+z_{i2}.
\]

Each variable-index offset lookup is replaced by a linear expression. For example,
\[
x_j=x_i+\sum_o \operatorname{offsetX}_{jo}z_{io}.
\]

**Why this is equivalent:** Exactly one selector is active, and its index equals the original orientation variable. Consequently, each weighted offset sum returns precisely the offset selected by the original array lookup. Fixing selectors for prohibited orientations to zero enforces the original allowed-orientation restriction. Conversely, every original orientation assignment determines a unique feasible selector vector.

This is a shared binary encoding of a finite choice. It exposes the offset relationships as linear equations and allows all rectangles belonging to a room to use the same orientation selectors, rather than relying on separate translations of repeated variable-index lookups.

### Orientation-dependent bound preprocessing

For each room and orientation, the reformulation computes necessary lower and upper bounds on the room’s origin.

For a component rectangle \(j\), the original relationship
\[
x_j=x_i+\operatorname{offsetX}_{jo}
\]
and coordinate domain \(0\le x_j\le L_{\max}\) imply
\[
-\operatorname{offsetX}_{jo}\le x_i
\le L_{\max}-\operatorname{offsetX}_{jo}.
\]

The original room-origin domain and room bounding-box containment additionally imply
\[
0\le x_i,\qquad
x_i\le L_{\max},\qquad
x_i\le L_{\max}-\operatorname{boxLength}_{io},
\]
because the selected roll length cannot exceed \(L_{\max}\).

Taking the maximum of the lower bounds and the minimum of the upper bounds gives an orientation-specific interval. The same calculation is performed vertically using roll width, vertical offsets, and the oriented room bounding-box width.

**Why pruning is valid:** If either interval is empty, that orientation cannot satisfy the original coordinate domains, offset equations, and room containment constraints simultaneously. Its selector can therefore be fixed to zero without removing any feasible original solution.

The bounds are also imposed through selector-weighted linear inequalities. For example,
\[
x_i\ge\sum_o \underline{x}_{io}z_{io},
\qquad
x_i\le\sum_o \overline{x}_{io}z_{io}.
\]
For an integral selector assignment, these inequalities impose only bounds already implied by the original model. They may also strengthen the mixed-integer relaxation.

### Preserved semantics and solution mapping

No rectangles, stair units, or necessary constraints are removed. In particular, the cumulative constraints, `diffn`, original stair-part expressions, derived objective bounds, and external data interface remain unchanged. No additional geometric assumptions are introduced.

The mapping script copies only the original independent decision variables from the solver output, preserving their encoded values and index sets. The new orientation selectors are internal and are omitted. Missing required fields produce an explicit error rather than fabricated values.

## Expected effect and limitations

The intended benefit is a more explicit linear representation of room orientations, supplemented by inexpensive geometric bound propagation and infeasible-orientation elimination. These changes may improve presolve and relaxation strength for HiGHS.

They do not reduce the number of modeled carpet rectangles or eliminate the main packing difficulty. No solve-time measurements were supplied, so an empirical speedup has not been established.
