## Background and interpretation

The model represents **three-dimensional industrial pipe routing** between two fixed equipment nozzles. Coordinates are integer multiples of a 200 mm length unit. The route uses axis-aligned straight segments, with bends between consecutive active segments.

This instance contains one pipe, ten ordered nodes, and nine possible segments. Its 114 fixed boxes describe equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack-support levels. A feasible route must maintain obstacle clearance, respect nozzle connection directions and segment-length limits, and place intermediate nodes in permitted support zones. Additional cubic constraints represent a pipe-flexibility requirement.

Although the data include a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation therefore does **not** impose mandatory rack traversal.

## Original model

### Variables and route structure

The original independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two **10 × 3 integer arrays** describing the lower and upper corners of segment bounding boxes.
- A **10 × 3 nonnegative integer array** of coordinate-wise segment lengths.
- Three **10-element integer arrays** for segment direction, existence, and last-segment status.
- An integer objective variable.

These declarations contain 151 scalar variable entries before fixing or presolve. The tenth segment-array position is a dummy entry fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

Active segments form a contiguous prefix of the route. At least three segments must exist, and exactly one is designated the last segment. Inactive segments have zero length, so their nodes coincide with the terminal nozzle.

### Constraints

The principal constraint groups are:

1. **Segment geometry:** Each active segment moves along exactly one coordinate axis. Its bounding box includes the pipe radius.
2. **Route sequencing and bends:** Existence and last-segment flags determine the active prefix. Consecutive active segments must use different axes.
3. **Nozzle connections:** The initial and final active segments have specified directions and length limits.
4. **Obstacle clearance:** Each applicable segment–obstacle pair must be separated along at least one axis. The original connection-module exemptions are retained.
5. **Support availability:** Intermediate nodes must lie in a support zone, using the pipe’s bottom elevation for the vertical membership test. This requirement applies even to intermediate nodes associated with inactive segments.
6. **Flexibility:** For each coordinate direction, a sum of cubed lengths in the other two directions must exceed specified multiples of individual segment lengths.

The source also contains inter-pipe clearance constraints, but they generate no pairs in this single-pipe instance. It does not impose self-collision constraints between segments of this pipe.

### Objective

The objective minimizes the sum of:

- Total pipe length;
- A charge for every active segment after the first;
- Support costs at the corresponding intermediate nodes.

The original integer coefficient transformation—division by 100 followed by addition of one—is preserved exactly.

## Reformulation and its justification

### 1. Explicit signed-length geometry

Each segment and coordinate receives positive- and negative-direction indicators, together with nonnegative positive and negative travel lengths. Their difference equals the coordinate displacement, and their sum equals the original segment length.

This is equivalent to the original geometry. Originally, the bounding-box inequalities imply that segment length is at least the absolute endpoint displacement. The direction implications impose the reverse inequality in the selected direction and force zero length in every other direction. Consequently, length equals absolute displacement, and the bounding-box corners are uniquely determined by the endpoints and radius.

The reformulation expresses these consequences directly as linear equalities. Shared direction indicators also express segment existence, direction codes, and consecutive-axis restrictions.

### 2. Exact linear encoding of cubic lengths

The variable cubic expressions are replaced by **one-hot encodings of positive integer lengths**. For each segment-coordinate pair:

- No length is selected when that coordinate is inactive;
- Exactly one admissible positive length is selected when it is active;
- Length and its cube are weighted sums of the same selection indicators.

This is exact, rather than a piecewise-linear approximation: selecting length \(v\) contributes precisely \(v\) and \(v^3\). It converts the flexibility constraints into linear expressions suitable for HiGHS, at the expense of additional binary variables.

### 3. Domain-based preprocessing

Impossible length selections are fixed to false using:

- The original minimum active-segment length;
- The original maximum segment length;
- Coordinate-domain bounds;
- First-segment and last-possible-segment nozzle restrictions.

These exclusions are valid because exact segment geometry makes length equal to endpoint displacement. It cannot exceed the span permitted by the endpoint domains. The original direction constraints also require every active coordinate length to satisfy the ordinary minimum length, including nozzle segments. First and last-possible segments inherit their additional axis and upper-length restrictions directly from the original model.

### 4. Displacement and parity strengthening

For each coordinate, the reformulation adds
\[
\text{total coordinate travel}
=
\lvert\text{endpoint displacement}\rvert
+2\,\text{detour},
\]
where the detour is a nonnegative integer.

To see validity, let \(P\) and \(N\) be total positive and negative travel along that coordinate. The endpoint equations give \(P-N=\Delta\), while total travel is \(P+N\). Therefore,
\[
P+N=|\Delta|+2\min(P,N).
\]
The added equation is thus a redundant consequence of integer axis-aligned routing. It exposes a global displacement and parity relation to the solver.

### 5. Compilation, data, and solution-interface repairs

Endpoint distances are computed from singleton-domain lower bounds instead of calling `fix` on coordinate-array expressions. Assertions check that the endpoint domains are indeed singletons, as they are in the supplied instance.

An accidental extra entry introduced into the box-type array during transcription was removed, restoring the original 114 entries and their correspondence with the 342 coordinate and size entries.

The final mapping script returns only the original independent variables. It copies retained solution variables, restores fixed endpoint coordinates from the original embedded data, and obtains the objective from the emitted variable or solver objective field. Missing required solution fields produce explicit errors rather than fabricated values.

## Expected effect

The reformulation replaces nonlinear cubic expressions and implicit geometric relationships with an explicit mixed-integer linear formulation. Domain pruning limits the length-selection encoding, while displacement equations provide additional global structure. These changes are intended to improve HiGHS compatibility and solving efficiency; no measured runtime improvement is established by the reported compilation checks.
