# Pipe-Routing Model and Reformulation

## 1. Real-world background

The model represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, through a three-dimensional plant layout. The pipe follows an orthogonal route: each straight segment runs parallel to the X, Y, or Z axis.

The supplied instance contains one pipe, ten ordered route nodes, and nine candidate segments. The first and last nodes are fixed; intermediate nodes determine the route. Coordinates use a discretization unit of 200 mm.

Fixed boxes describe equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. The route must avoid applicable obstacles with diameter-dependent clearance, place intermediate nodes in support zones, and respect nozzle directions and segment-length limits. Additional cubic constraints represent a simplified piping-flexibility requirement.

Although the data contain a flag indicating rack traversal, the corresponding constraint is commented out in the original model. The reformulation therefore does **not** require traversal of the rack.

## 2. Original model structure

### Variables

The original model declares:

- **30 integer node coordinates**, including six coordinates fixed at the two endpoints.
- **60 integer segment-envelope coordinates**, representing lower and upper corners of radius-expanded segment boxes.
- **30 nonnegative integer coordinatewise segment lengths**.
- **10 integer direction variables**, with values zero for an absent segment and six signed coordinate directions otherwise.
- **20 binary-valued integer flags**, identifying existing segments and the final active segment.
- An integer objective variable.

The segment arrays contain ten slots: nine candidate segments and a dummy final slot fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint groups are:

1. **Segment geometry:** Each segment is axis-aligned. Its length, endpoint displacement, direction, and radius-expanded envelope must agree.
2. **Route sequence:** Existing segments form a prefix, the first three segments exist, and exactly one segment is designated as the last.
3. **Turns and nozzle connections:** Consecutive active segments use different axes. Initial and final segments obey prescribed nozzle directions and length limits.
4. **Obstacle clearance:** A segment must lie entirely on an allowable side of each applicable obstacle in at least one coordinate. Explicit exceptions permit connection to the endpoint modules.
5. **Support membership:** Every intermediate node covered by the original support requirement must belong to at least one support zone. Vertical membership is checked at the pipe bottom; horizontal membership uses the node center. This requirement also applies to nodes associated with inactive trailing segments.
6. **Flexibility:** For each coordinate, a coefficient based on nozzle separation and the supplied flexibility factor multiplies individual orthogonal segment lengths. Each resulting quantity is bounded by the sum of cubed lengths in the other two coordinates.

The original formulation also includes clearance between different pipes. This constraint family has no applicable pairs in the supplied single-pipe instance.

### Objective

The model minimizes the sum of pipe-length, bend, and support charges. It uses the original integer scaling rule, `cost div 100 + 1`, rather than unscaled monetary costs.

For this instance, the resulting charges are:

- **131** per discretized unit of pipe length;
- **1,301** for each active segment after the first;
- **51** for an active charged node outside preferred rack levels, or **1** inside a preferred level.

The reformulation preserves these objective values and the minimization direction.

## 3. Reformulation and validity

### Linear signed-displacement formulation

Direction-dependent implications were replaced with positive and negative direction indicators and corresponding nonnegative displacement variables.

This is valid because the original constraints already force each segment to have at most one nonzero coordinate length. In its selected direction, the envelope constraints imply that length is at least the endpoint displacement magnitude, while the direction constraint imposes the reverse inequality. Thus length equals the displacement magnitude. In every unselected coordinate, length is zero, forcing equal endpoint coordinates.

The original envelope variables are consequently determined exactly by the smaller and larger endpoint coordinates, minus and plus the pipe radius. The new linear equations express these same relationships directly.

### Bound-based preprocessing

Coordinatewise length bounds are derived from endpoint coordinate domains and intersected with the original segment and nozzle limits.

For example, the largest possible absolute displacement in a coordinate is bounded by the maximum of the two endpoint-domain differences. A segment cannot exceed this bound because its length equals its endpoint displacement. Nozzle restrictions further set unselected coordinate lengths to zero and cap the selected length.

These bounds tighten the linear formulation and reduce the admissible values in the cubic lookup.

### Exact binary-encoded cubic lookup

Variable powers were replaced with an exact finite-domain formulation using continuous convex-combination weights and binary length-code variables.

For each segment:

- Nonnegative weights sum to one over candidate integer lengths.
- Binary-code equations force all positive weight onto a single candidate length.
- Weighted sums determine both the length and its cube.

This is **not** a piecewise-linear approximation: with integral code bits, precisely one integer length is selected.

Only one cubic lookup is needed per segment. The original axis-alignment constraints ensure that at most one coordinate length is nonzero, so the cube of total segment length equals the cube of that active coordinate length. Bounded linear linking constraints assign the resulting cube to the selected axis and zero to the others. The original flexibility inequalities then use the reconstructed coordinatewise cubes unchanged.

### Obstacle-disjunction simplification

Obstacle separation is expressed directly as a disjunction of allowable sides, avoiding the intermediate defined array of coordinatewise separation expressions.

A side is removed only when the endpoint-domain envelope bounds prove it impossible. For example, separation requiring a segment’s lower envelope coordinate to exceed an obstacle boundary is impossible if even that envelope coordinate’s valid upper bound is below the boundary.

Removing an impossible disjunct cannot remove a feasible route. All original obstacle exceptions remain in place.

### Linear support-cost calculation

Products of an existence flag and a support charge were replaced by weighted Boolean conjunctions.

The original existence and nonpreferred-support flags are binary. Therefore, charging a node only when it both exists and belongs to a particular cost category is exactly equivalent to the original multiplication. The original support-membership definitions and restrictions remain unchanged.

### Valid Manhattan-distance cuts

For each coordinate, the reformulation adds a lower bound requiring total coordinatewise segment length to cover the absolute endpoint separation.

These inequalities follow from the original geometry: signed displacements telescope to the endpoint displacement, and the sum of their absolute values cannot be smaller than the absolute value of their sum. They therefore strengthen the continuous relaxation without excluding any original feasible solution.

## 4. Solution interface and expected effect

All original independent decision variables are retained. The mapping script returns only those original variables, preserves array index domains, and restores singleton endpoint coordinates from the embedded original data if they are not emitted by the solver. It reports missing required solution fields rather than inventing values.

The reformulation targets the HiGHS mixed-integer linear backend by replacing nonlinear expressions with exact linear formulations, tightening bounds, and simplifying disjunctions. These changes are intended to improve compilation and relaxation quality. No measured runtime improvement or solver-validation result is established by the conversation.
