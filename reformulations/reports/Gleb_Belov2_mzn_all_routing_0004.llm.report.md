# Reformulation Report: Three-Dimensional Pipe Routing

## 1. Real-world interpretation

The model represents the routing of a pipe between two fixed connection points in an industrial installation. The route consists of straight, axis-aligned segments in three dimensions. Fixed boxes describe equipment modules, existing pipes, support zones, a pipe rack, and preferred rack levels.

Coordinates use a discretized length unit of 200 mm. The supplied instance contains one pipe, 10 route nodes, and therefore 9 candidate segments. Its endpoints are fixed at `(212, 58, 115)` and `(245, 43, 113)`. The remaining nodes determine the route.

A feasible route must respect obstacle clearances, nozzle connection directions, segment-length limits, and support-zone requirements. Its cost combines pipe length, bends, and bend supports. Although the input includes a flag suggesting passage through a rack, the corresponding constraint is commented out in the original model; the reformulation does not activate it.

## 2. Original model structure

### Variables

The original model declares:

- **30 integer coordinate variables**, including 6 fixed endpoint coordinates and 24 intermediate-node coordinates.
- **60 integer segment-bound variables**, representing lower and upper corners of radius-expanded segment boxes.
- **30 nonnegative integer component-length variables**.
- **10 direction variables**, with values representing an unused segment or one of six signed coordinate directions.
- **20 binary integer flags**, indicating segment existence and the last active segment.
- An integer objective variable, `obj`.

The segment arrays include a tenth, non-segment position whose entries are constrained to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The principal constraint groups are:

1. **Segment geometry.** Each segment joins consecutive nodes and can move along only one coordinate axis. Its bounding box includes the pipe radius.
2. **Route sequencing.** Active segments form a prefix of the candidate sequence. Exactly one is marked last, and at least the first three exist.
3. **Nozzle connections.** The first segment has a prescribed direction and length range. The last active segment has its own prescribed direction and length range and ends at the fixed destination.
4. **Orthogonality.** Consecutive active segments use different axes, excluding both straight continuation and immediate reversal.
5. **Obstacle avoidance.** A segment’s expanded box must be separated from each applicable obstacle along at least one axis. Specific exemptions permit connection to the endpoint modules.
6. **Support availability.** Intermediate node positions must lie in at least one support zone. Membership uses the node center horizontally and the pipe bottom vertically.
7. **Preferred-support accounting.** Preferred rack-level membership determines support cost.

Some constraints apply even to unused trailing segments or their nodes. In particular, the original does not generally disable obstacle and support requirements when a segment is unused. These requirements were preserved.

### Objective

The model minimizes the original scaled cost:

- **181** per unit of segment length;
- **1,801** per active segment after the first, representing a bend;
- **51** per ordinary supported bend, or **1** at a preferred rack level.

These coefficients follow the original rule `cost div 100 + 1`. The reformulation preserves that rule and the minimization direction rather than substituting unscaled physical costs.

## 3. Reformulation and validity

### Linear extended formulation for segment geometry

The reformulation introduces binary selectors for the six signed directions and nonnegative forward and reverse lengths for each coordinate. Their sum gives the component length; their difference gives the displacement between consecutive nodes.

This is equivalent to the original geometry constraints. Originally, the segment box contains both radius-expanded endpoints, so its component length is at least the absolute endpoint displacement. The selected-direction constraint supplies the matching upper bound. Together they force equality. On an unselected axis, the component length is zero, forcing equal endpoint coordinates and exact box boundaries.

The new formulation expresses these consequences directly through linear equations and selector-dependent length bounds. It avoids much of the original reified direction logic and provides a more explicit mixed-integer formulation for HiGHS.

### Nozzle-based bound propagation

Bounds are tightened for the node immediately after the starting nozzle and the node immediately before the final endpoint.

- The first segment’s fixed direction and length limits constrain its successor’s coordinates directly. Its effective minimum length is the maximum of the general and nozzle-specific lower bounds.
- The final candidate segment is either absent or follows the destination nozzle direction. If absent, its endpoints coincide; otherwise, its length is bounded by the destination nozzle limit. Both possibilities therefore lie within a short interval adjacent to the fixed destination.

These bounds follow from the original constraints and exclude no feasible route. They also provide tighter upper bounds for the new forward and reverse length variables.

### Bound-based obstacle preprocessing

An obstacle–segment check is omitted only when the propagated endpoint bounds prove separation along at least one coordinate axis.

For example, if both endpoints must remain beyond an obstacle’s upper face by at least the required radius and safety distance, the entire axis-aligned segment is necessarily separated from that obstacle. The analogous argument applies below an obstacle’s lower face.

Because the original geometry forces exact radius-expanded segment boxes, these tests establish that the omitted disjunctions are always satisfied. Checks not proved redundant remain, including the original endpoint-module exemptions and treatment of unused segments.

### Linearized support costs

The original support cost multiplies a segment-existence variable by a membership-dependent expression. The reformulation replaces these products with weighted Boolean conjunctions: a cost is charged precisely when the segment exists and the applicable support condition holds.

This replacement is exact because existence and ordinary-support indicators are binary, while preferred-zone membership is Boolean. The original membership definitions and the domain restriction on the non-preferred indicator are retained.

### Required-direction cuts

The reformulation adds inequalities requiring at least one segment in the signed direction of each nonzero endpoint displacement.

Their validity follows by summing segment displacements: consecutive node differences telescope to the fixed endpoint difference. Since a segment can contribute positive displacement on an axis only when its positive-direction selector is active, a positive net displacement requires at least one such selector; the negative case is analogous.

These inequalities are redundant for integer feasible routes but can strengthen the linear relaxation.

### Removal of inactive components

Two original model components have no effect in this instance:

- **Flexibility:** the pipe’s flexibility coefficient is zero. The original conditional expressions consequently make all flexibility constraints true and all associated cubic-length sums zero. The reformulation retains those sums as zero without generating nonlinear expressions.
- **Inter-pipe separation:** every node belongs to the same pipe. The original constraints are generated only for pairs belonging to different pipes, so their index set is empty. Removing this component introduces no new feasible routes. No self-avoidance constraint was added, since the original does not impose one.

### Data and solution interface

An accidental extra entry in the reformulated box-type array was corrected, restoring the original **97 boxes** and their correspondence with the **291 coordinate and size entries**.

All original independent decision variables remain represented. The supplied mapping script copies the retained variables, restores fixed endpoint coordinates from the unchanged self-contained data, and excludes auxiliary variables. It reports missing required values rather than inventing replacements.

## 4. Expected effect

The changes target a tighter, more explicit linear mixed-integer formulation and fewer unnecessary obstacle disjunctions. They preserve the original feasible-route semantics and objective values. No measured solve-time improvement is established by the reported compilation and mapping checks alone.
