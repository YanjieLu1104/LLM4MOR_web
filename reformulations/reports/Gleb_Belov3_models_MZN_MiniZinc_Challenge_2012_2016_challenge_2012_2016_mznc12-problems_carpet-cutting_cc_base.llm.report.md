## Background and practical meaning

The model describes a **carpet-cutting and two-dimensional packing problem**. Carpets must be cut from a roll of fixed width while minimizing the length of roll consumed.

Two types of carpet are represented:

- **Room carpets:** Rectilinear shapes assembled from rectangles. Each room has a set of permitted orientations among 0°, 90°, 180°, and 270°. Its component rectangles move together through orientation-dependent offsets from the room’s origin.
- **Stair carpets:** Rectangular strips represented as individual steps. Steps may form several contiguous pieces, subject to limits on the number of cuts and minimum numbers of steps per piece.

All component rectangles must fit within the roll and satisfy non-overlap constraints.

## Original model structure

### Variables

The original model contains the following independent top-level decision variables:

| Variables | Meaning | Number of scalar variables |
|---|---|---:|
| `RollLen` | Length of roll used | 1 |
| `rm_x`, `rm_y` | Room origins | \(2n_{\mathrm{rm}}\) |
| `rm_vori` | Room orientations | \(n_{\mathrm{rm}}\) |
| `rm_ori_0_or_180`, `rm_ori_0_or_90` | Boolean orientation indicators | \(2n_{\mathrm{rm}}\) |
| `rm_rec_x`, `rm_rec_y` | Room-rectangle origins | \(2n_{\mathrm{rm\_rec}}\) |
| `st_rec_x`, `st_rec_y` | Stair-step origins | \(2n_{\mathrm{st\_rec}}\) |

Coordinates are bounded integers. The model additionally defines two orientation-dependent dimension arrays for room rectangles and introduces local Boolean `last_part` variables for stair-piece boundaries.

These are source-level counts; the number of variables generated during solver translation depends on the data and backend.

### Constraints

The principal constraint groups are:

1. **Containment:** Room bounding boxes, room rectangles, and stair rectangles must fit within the selected roll length and fixed width.
2. **Orientation consistency:** Each room selects an allowed orientation, and its two Boolean orientation indicators agree with that selection.
3. **Rigid room geometry:** Each component rectangle’s origin equals its room origin plus its orientation-dependent offset.
4. **Stair ordering:** Steps are ordered by their vertical coordinates; steps at the same vertical coordinate are ordered horizontally.
5. **Stair partitioning:** Local boundary indicators identify piece endings. Constraints limit the number of pieces, enforce minimum piece sizes, and require a piece to end when another step would extend beyond the roll.
6. **Packing:** Two `cumulative` constraints impose aggregate capacity restrictions in the two coordinate directions. A `diffn` constraint enforces rectangle non-overlap.

The objective is to **minimize `RollLen`**. Its original bounds include an area-based lower bound and an upper bound derived from the supplied maximum roll length and carpet dimensions.

## Reformulation and justification

### Shared one-hot orientation encoding

The reformulation introduces four binary variables per room, one for each orientation, with exactly one selected. Linear equations express:

- the orientation number as the weighted sum of these binaries;
- each original Boolean orientation indicator as the sum of its corresponding orientation binaries;
- each rectangle offset as a weighted sum of the four fixed offset values.

This replaces variable-indexed offset expressions and orientation-membership equivalences with a shared linear representation suited to the **HiGHS mixed-integer backend**.

**Why it is valid:** Selecting exactly one binary reproduces exactly one original orientation. The weighted offset sum therefore equals the original array lookup at that orientation. The indicator equations reproduce membership in `{1, 3}` and `{1, 2}`, respectively. Binaries for disallowed orientations are fixed to zero, preserving the original permitted-orientation restriction.

### Orientation-specific origin-bound preprocessing

For each room and orientation, the reformulation computes necessary bounds on the room origin.

For example, the original equations and coordinate domains imply
\[
x_j=x_i+o^x_{j,q},\qquad 0\le x_j\le \mathrm{MaxRollLen}.
\]
Consequently,
\[
-o^x_{j,q}\le x_i\le \mathrm{MaxRollLen}-o^x_{j,q}.
\]
These bounds are intersected over the room’s rectangles and with the original domain of \(x_i\). The room bounding-box constraint also gives
\[
x_i\le \mathrm{MaxRollLen}-L_{i,q},
\]
because `RollLen` cannot exceed `MaxRollLen`. Corresponding bounds are computed vertically using the fixed roll width.

**Why it is valid:** Every bound follows from an existing coordinate domain, offset equality, or bounding-box containment constraint. If a lower bound exceeds its corresponding upper bound, that orientation cannot occur in any original feasible solution, so its binary can safely be fixed to zero.

The bounds are also imposed through weighted sums of the orientation binaries. For an integer one-hot selection, these inequalities enforce precisely the selected orientation’s necessary bounds. They can additionally tighten the linear relaxation.

### Preserved semantics and solution mapping

No original independent decision variable is eliminated. All containment, cumulative, non-overlap, stair-ordering, and stair-partition constraints are retained, including the original stair-length indexing expressions. The external data interface and minimization objective are unchanged.

The mapping script therefore performs an identity mapping of the ten original independent variable declarations, excluding auxiliary orientation binaries and preserving encoded array indices. Missing required values produce an explicit error rather than fabricated output.

The expected benefit is a more explicit linear orientation formulation and stronger bounds before search. **No measured runtime improvement is established here**; performance remains instance-dependent.
