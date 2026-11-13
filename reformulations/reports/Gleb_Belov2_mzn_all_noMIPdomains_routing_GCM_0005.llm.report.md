# Pipe Routing with Clearance, Support, and Flexibility Requirements

## 1. Application background

The model represents the routing of a single industrial pipe between two fixed connection points in a three-dimensional installation. The environment contains equipment modules, existing pipe segments, support zones, and a rack with preferred support levels.

Coordinates are integer-valued on a grid with a spacing of **200 mm**. The pipe follows axis-aligned straight segments, with perpendicular bends between consecutive active segments. The model accounts for pipe radius, obstacle clearance, permissible nozzle directions and lengths, support availability, and a cubic-length flexibility criterion.

The connection points are `(246, 52, 200)` and `(309, 96, 80)` in grid units. Both nozzle directions are positive vertical. Consequently, the pipe must initially rise, descend somewhere along its route, and rise again into the destination.

Although the input includes a flag suggesting that the pipe should pass through a rack, the corresponding constraint is commented out in the original model. The reformulation does **not** impose that requirement.

## 2. Original mathematical structure

### Variables and route representation

There are **10 ordered nodes** and **30 integer coordinate variables**. Six coordinates fix the two endpoints; the remaining 24 describe intermediate nodes.

The leg arrays contain 10 entries: nine candidate segments joining consecutive nodes and one dummy entry fixed to zero. The original independent leg variables comprise:

- 60 integers for the lower and upper corners of segment bounding boxes;
- 30 nonnegative integers for segment lengths along the three axes;
- 10 integer direction codes;
- 10 binary-valued existence flags;
- 10 binary-valued last-segment flags.

An additional integer variable, `obj`, records the objective. Other arrays—such as support-membership indicators and orthogonal sums of cubed lengths—are defined expressions rather than independent decisions.

### Constraints

The principal constraint groups are:

- **Route sequencing:** active segments form a prefix, with exactly one designated last segment. At least the first three segments exist; the first two cannot be last.
- **Axis alignment and geometry:** a direction code selects one signed coordinate direction. All other directional lengths are zero. Bounding boxes enclose the segment endpoints with the pipe radius added.
- **Length restrictions:** active segments have a general minimum length of 6 grid units. Nozzle-specific bounds additionally restrict the first and last segments.
- **Orthogonality:** consecutive active segments cannot use the same coordinate axis.
- **Endpoint connection:** the last active segment ends at the fixed destination. Subsequent zero-length segments repeat that position.
- **Obstacle clearance:** each applicable segment must be separated from each obstacle along at least one axis. Specific exceptions allow connection through the source and destination modules.
- **Support membership:** intermediate nodes must belong to a support zone, using the node centre horizontally and the pipe bottom vertically. This condition also applies to intermediate entries representing an inactive route suffix.
- **Flexibility:** for each coordinate axis, a coefficient times every individual orthogonal segment length must not exceed the sum of the cubes of all lengths orthogonal to that axis.

The source also contains inter-pipe clearance constraints, but these generate no relevant pairwise restrictions for this single-pipe instance.

### Objective

The model **minimizes** pipe-length, bend, and support costs. It uses the original integer scaling rule, `cost div 100 + 1`, giving:

- **181** per grid unit of pipe length;
- **1,801** per active segment other than the first;
- **51** for a supported active bend outside preferred rack levels, or **1** within a preferred level.

These are the model’s scaled objective coefficients, not unscaled monetary amounts.

## 3. Reformulation and justification

### Exact linear encoding of cubic lengths

Variable expressions of the form \(l^3\) were replaced by finite-domain selection encodings. For each relevant segment-axis pair, binary selectors choose exactly one admissible integer length \(v\), enforcing
\[
l=\sum_v v\,y_v,\qquad c=\sum_v v^3y_v,\qquad \sum_v y_v=1.
\]

This is an **exact discrete reformulation**, not a piecewise approximation: exactly one selector is active, so \(c=l^3\). The original flexibility inequalities are retained using these cube values. Linking the zero-length selector to the direction indicators also strengthens the connection between geometry and the encoding.

This removes variable powers from the formulation presented to HiGHS, at the expense of additional binary variables.

### Valid length-domain preprocessing

The selector domains retain zero and positive lengths starting at the original general lower bound of 6. Values between 1 and 5 are impossible: the direction constraints require either a selected axis with length at least 6 or an unselected axis with length zero.

Upper bounds are tightened using endpoint-coordinate domains and nozzle restrictions. This is valid because:

1. The bounding-box enclosure and length equations imply that each directional length is at least the absolute endpoint displacement.
2. The selected-direction inequality provides the reverse bound.
3. Therefore, each directional length equals the absolute displacement.

Its upper bound can consequently be limited by the largest displacement allowed by the endpoint domains. The original first- and final-candidate nozzle restrictions supply further bounds, including zero for forbidden axes.

### Linearization of support costs

Products involving segment existence and support membership were replaced with Boolean conjunctions. For binary-valued indicators \(a\) and \(b\),
\[
ab=\operatorname{bool2int}(a=1\land b=1).
\]

Distributing the existence indicator over the original support-cost expression therefore preserves its value exactly. Support-membership definitions and the restriction that `fNodeNotInPref` lies in `0..1` remain in place.

### Valid route-length and segment-count cuts

Three types of redundant inequalities strengthen the formulation:

- **Coordinate-wise travel bounds:** total length along each axis must be at least the absolute endpoint displacement. This follows from the triangle inequality applied to successive node displacements.
- **At least five active segments:** the first and last segments are distinct positive-vertical segments. Because the destination is lower than the source, at least one negative-vertical segment is necessary between them. Consecutive segments cannot share an axis, so a nonvertical segment must separate each adjacent pair of these three vertical segments.
- **At least 144 units of vertical travel:** let \(U\) and \(D\) denote total upward and downward travel. The endpoint elevations imply \(D-U=120\). The two upward nozzle segments each have length at least 6, giving \(U\ge12\). Hence
  \[
  U+D=120+2U\ge144.
  \]

The latter two cuts are specific to the supplied endpoint elevations, nozzle directions, and minimum-length constraints.

### Simplification and solution interface

Obstacle-separation expressions are used directly rather than through their original defined Boolean arrays. This preserves the same disjunctions and module exceptions without requiring those intermediate arrays.

All original independent decision variables remain available under their original names. The mapping script copies them back, preserves array index metadata, and reconstructs omitted fixed endpoint coordinates from the unchanged instance constants. The data-array transcription error encountered during compilation was repaired by restoring the original size array.

The reformulation preserves the original objective and minimization direction. Its intended benefit is a solver-compatible linear representation with tighter domains and additional valid inequalities; no measured solve-time improvement is established here.
