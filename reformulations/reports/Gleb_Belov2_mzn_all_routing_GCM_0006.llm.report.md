# Pipe Routing with Clearance, Support, and Flexibility Requirements

## Background

This instance represents three-dimensional routing of an industrial pipe between two fixed equipment nozzles. The pipe is modeled as a sequence of axis-aligned straight segments connected by bends. Coordinates use discrete units of 200 mm.

The supplied instance contains one pipe, ten node positions, and 107 fixed boxes. Box types distinguish equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. A feasible route must respect obstacle clearances, prescribed nozzle directions, segment-length limits, and support requirements. Additional cubic-length inequalities represent a flexibility requirement associated with accommodating displacement between the nozzle positions.

The model does **not** require the pipe to visit the rack: although a rack-use input flag is supplied, the corresponding constraint is commented out. It also does not impose self-intersection avoidance between segments of the same pipe.

## Original Model

### Variables and route representation

The original independent decision variables comprise:

- **30 integer node coordinates**, of which six fix the two endpoints.
- **60 integer segment-box coordinates**, describing lower and upper corners for ten segment slots in three dimensions.
- **30 nonnegative integer directional lengths**.
- **Ten direction variables**, with zero denoting an unused segment and six values denoting signed coordinate directions.
- **Ten existence flags and ten last-segment flags**.
- **One integer objective variable**.

There are nine actual candidate segments. The tenth segment slot is a dummy whose segment variables are fixed to zero. Additional defined arrays represent obstacle separation, support membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint groups are:

1. **Segment geometry.** Each segment is parallel to one coordinate axis. Its bounding box includes the pipe radius, and its length agrees with the displacement between adjacent nodes.
2. **Route sequencing.** Existing segments form a prefix of the candidate sequence. At least three segments exist, and exactly one is designated as the last segment.
3. **Bends and nozzle connections.** Consecutive existing segments use different axes. The first and last segments satisfy specified nozzle directions and length bounds. The last segment terminates at the fixed destination.
4. **Obstacle clearance.** A segment must be separated from each applicable obstacle along at least one axis. Specified exceptions allow connection to the endpoint modules.
5. **Support membership.** Intermediate candidate nodes must belong to at least one support zone, using the node center horizontally and the pipe bottom vertically. These requirements are not conditional on segment existence.
6. **Flexibility.** For each coordinate direction, a coefficient times an individual orthogonal segment length is bounded by the sum of cubed segment lengths in the other two directions.

Inter-pipe separation constraints are present in the general formulation, but generate no restrictions in this single-pipe instance.

### Objective

The model minimizes a scaled sum of pipe length, bends, and node-support costs. The original integer division and “plus one” adjustments are preserved. For this instance, the resulting length coefficient is 181, the bend coefficient is 1,801, and an existing supported bend costs either 51 outside preferred rack levels or 1 within them.

## Reformulation

### Disaggregated signed segment lengths

The implication-based direction formulation was replaced by positive- and negative-direction indicators with associated nonnegative lengths. Linear equations now connect node displacement, total length, and segment-box coordinates.

This is an exact reformulation of the original geometry. Originally, the bounding-box inequalities imply that each directional length is at least the absolute endpoint displacement. The direction implications supply the matching upper bound on the selected axis and force all other lengths to zero. Therefore, the segment box must equal the endpoint-wise minimum and maximum, expanded by the pipe radius. The new equations express these consequences directly.

Directional upper bounds are also tightened using endpoint coordinate bounds and applicable nozzle or ordinary-segment limits. These bounds are valid because no endpoint displacement can exceed the corresponding maximum possible coordinate difference.

### Bounded linear encoding of cubic flexibility

Variable powers were replaced by a one-hot length encoding and linear constraints assigning the resulting contribution to the active coordinate axis.

To reduce the number of length choices and the size of coefficients, individual cubes are capped at a derived bound \(C\) on every flexibility inequality’s left-hand side. Length values below the saturation threshold are represented exactly; all lengths at or above that threshold share one saturated category.

This preserves feasibility. For nonnegative contributions \(a_j\) and any target \(t\le C\),

\[
\sum_j a_j\ge t
\quad\Longleftrightarrow\quad
\sum_j \min(a_j,C)\ge t.
\]

If no contribution exceeds \(C\), the sum is unchanged. If one does, its capped value alone meets every possible target. The bound \(C\) follows from the original flexibility coefficients and the original maximum segment length.

Because each segment uses at most one axis, its scalar length cube can be assigned to that axis using bounded linear indicator constraints. Thus, HiGHS receives a mixed-integer linear formulation rather than variable-power expressions.

### Compile-time preprocessing

Two additional reductions use only original data and bounds:

- **Impossible support memberships are fixed to false.** If a node’s coordinate domain cannot intersect a support box in any required dimension, the original conjunction defining membership cannot hold. The vertical test includes the original pipe-radius adjustment.
- **Unavailable length categories are disabled.** Categories above a segment’s valid upper bound, and positive exact categories below its required minimum length, cannot occur under the original length constraints.

The support-cost product was also expressed conditionally on the binary existence flag. This is equivalent to the original multiplication: an unused segment contributes zero, while an existing segment incurs its defined support cost.

## Preservation and Expected Benefit

The final model preserves the original data, independent variable meanings, objective value, and minimization direction. It retains the original obstacle exceptions and support requirements, including those applying to unused candidate nodes. A mapping script returns only the original independent variables and restores fixed endpoint values if they are absent from solver output.

The intended benefit is a more explicit, bounded MILP formulation with fewer nonlinear encoding choices. Compilation feedback also identified a duplicated size triple introduced during transcription; this was corrected to restore the original box-size data. No measured solve-time improvement is established by the conversation.
