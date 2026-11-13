## Background and interpretation

The model represents three-dimensional pipe routing through an industrial installation. A single pipe connects fixed nozzles at coordinates \((139,51,167)\) and \((1,88,36)\). Coordinates are discretized in units of 200 mm, and the pipe has a modeled diameter of four units.

The route consists of axis-aligned straight segments. Fixed boxes describe equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. The route must clear obstacle boxes, respect prescribed nozzle directions, and place intermediate nodes in support zones. The objective balances pipe length, bends, and support costs.

Some features mentioned in the source are not enforced: the rack-traversal constraint is commented out, and separation between nonadjacent segments of the same pipe is not required. The reformulation does not introduce either restriction.

## Original model structure

### Variables

The original model declares:

- **30 integer node coordinates**, six fixed at the two endpoints and 24 initially variable.
- Two **\(10 \times 3\)** integer arrays representing expanded segment bounding-box corners.
- One **\(10 \times 3\)** nonnegative integer array of segment lengths by coordinate.
- Three length-10 integer arrays representing segment direction, existence, and whether a segment is the last active segment.
- An integer objective variable.

There are nine possible connecting segments. The tenth entry in each segment array is a dummy entry fixed to zero. Additional defined arrays encode obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The principal constraint groups enforce:

1. **Segment geometry.** Each active segment moves along exactly one coordinate axis. Its bounding box includes the pipe radius.
2. **Route continuity and termination.** Active segments form a prefix, at least the first three segments exist, and exactly one segment is marked last. Subsequent zero-length segments leave the remaining nodes at the destination.
3. **Nozzle conditions.** The first segment follows the prescribed starting direction; the last active segment follows the prescribed incoming destination direction. Both have nozzle-specific length limits. The general minimum segment length also applies.
4. **Orthogonal bends.** Consecutive active segments cannot use the same coordinate axis, excluding both straight continuation and immediate reversal.
5. **Obstacle clearance.** Each relevant segment box must be separated from each obstacle along at least one axis. Specified exemptions allow connection to the starting and destination modules.
6. **Support membership.** Intermediate nodes must lie in a support zone, measured using their horizontal center coordinates and the bottom of the pipe vertically. This requirement also applies to intermediate nodes following route termination.
7. **Optional physical restrictions.** The source contains inter-pipe separation and flexibility constraints, but neither imposes an additional restriction in this instance.

### Objective

The model minimizes the original integer-scaled cost, retaining the source’s division by 100 and subsequent addition of one:

- **201** per unit of pipe length;
- **2,001** per active segment after the first, representing bend cost;
- **51** per active intermediate support outside preferred rack levels, or **1** within a preferred level.

These are the modeled objective coefficients, rather than an unscaled monetary objective.

## Reformulation and justification

### One-hot directions and signed segment lengths

The direction implications were replaced by six binary direction indicators per segment, together with nonnegative positive- and negative-direction length components. Their sum equals the segment-existence indicator, so an active segment selects exactly one direction and an inactive segment selects none.

For each coordinate, endpoint displacement is expressed as positive length minus negative length, while the original coordinate-length variable equals their sum. Indicator-dependent lower and upper bounds ensure that only the selected component can be positive.

This is an exact reformulation. In the original model, endpoint-enclosure constraints and the bounding-box width equation imply that coordinate length is at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality. For unselected axes, length is zero, forcing equal endpoint coordinates. Thus the original constraints already require precisely the signed-length geometry used in the new formulation.

### Exact linear bounding-box equations

The segment corners are now linked directly to the starting node and signed lengths:

- lower corner = starting coordinate − negative length − radius;
- upper corner = starting coordinate + positive length + radius.

These equalities preserve the original feasible geometry. Once coordinate length equals absolute endpoint displacement, the original box must both contain the radius-expanded endpoints and have exactly their expanded width. It therefore cannot contain additional slack.

The original bounding-box variables remain available for obstacle constraints and solution checking.

### Bound-based preprocessing

Positive and negative length caps are derived from the original endpoint-coordinate bounds and the original segment-length upper bound. For example, positive displacement cannot exceed the next node’s upper bound minus the current node’s lower bound.

These are valid bounds for every original feasible route. They tighten the MILP formulation without imposing a preferred routing direction or excluding detours.

Support membership is also preprocessed. If a node’s coordinate domain cannot intersect a support box in any coordinate—after accounting for the vertical radius offset—membership in that box is fixed false. This is valid because the original membership definition requires all coordinate intervals to overlap.

### Linearized support costs

The original support-cost expression multiplies segment existence by a variable support category. The reformulation instead uses Boolean conjunctions between existence and each category condition.

This preserves costs exactly: an inactive segment contributes zero, and an active segment contributes the cost of its original membership category. The original `fNodeNotInPref` definition and its binary domain are retained, preserving the restriction on simultaneous preferred-level memberships.

### Removal of instance-vacuous expressions

Two source components need no constraints in the reformulated instance:

- **Inter-pipe separation:** every node belongs to pipe 1. The original constraint generator selects only pairs belonging to different pipes, so it generates no such constraints.
- **Flexibility:** the sole flexibility coefficient is zero. The original conditional definitions therefore produce zero flexibility expressions and constraints that evaluate to true.

Unused derived separation arrays were also omitted; the required obstacle-separation disjunctions remain explicitly enforced.

### Solution interface and scope

All original independent decision variables are retained. The mapping script returns those variables, excludes reformulation auxiliaries, and can restore omitted fixed endpoint coordinates from the unchanged embedded instance data.

The changes target a tighter, more explicitly linear formulation for HiGHS. No additional routing assumptions, symmetry-breaking restrictions, or objective changes were introduced. No measured runtime improvement is claimed.
