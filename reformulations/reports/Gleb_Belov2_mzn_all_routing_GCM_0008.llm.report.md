# Industrial Pipe-Routing Model and Reformulation

## 1. Background and interpretation

The model describes the routing of a pipe through a three-dimensional industrial layout. Fixed rectangular boxes represent equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels.

The supplied instance contains one pipe represented by ten ordered nodes and up to nine axis-aligned legs. Its two endpoint coordinates are fixed. The route must respect nozzle directions and length limits, avoid obstacles with prescribed clearances, and place intermediate nodes in admissible support zones. A flexibility condition, expressed through sums of cubed leg lengths, models the benefit of perpendicular pipe runs in accommodating displacement.

The goal is to minimize installation-related costs: pipe length, bends, and supports.

Two details distinguish the implemented model from a more general routing problem:

- Although a rack-traversal flag is supplied, the corresponding constraint is commented out. Visiting the rack is therefore not mandatory.
- Collision constraints apply between different pipes, not between nonadjacent legs of the same pipe. With only one pipe, the inter-pipe constraints impose no restrictions.

The reformulation preserves these details.

## 2. Original mathematical structure

### Variables

The original independent declarations contain **151 integer-valued entries**:

| Group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each of ten nodes; six endpoint coordinates are fixed |
| Leg-box boundaries | 60 | Lower and upper bounds in three dimensions for ten indexed leg slots |
| Coordinate-wise lengths | 30 | Nonnegative length components |
| Direction codes | 10 | Zero for an absent leg, or one of six signed axis directions |
| Existence and last-leg flags | 20 | Binary indicators controlling the route’s active prefix |
| Objective variable | 1 | Total scaled cost |

Only nine leg slots connect consecutive nodes. The tenth is a dummy slot whose geometry, lengths, direction, and flags are fixed to zero.

Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The constraints enforce:

- **Axis-aligned geometry:** Each active leg changes exactly one coordinate. Its bounding box includes the pipe radius.
- **Route sequencing:** Active legs form a prefix, at least three legs exist, and exactly one is designated the last leg.
- **Orthogonal consecutive legs:** Adjacent active legs cannot use the same axis, excluding both immediate reversal and collinear continuation.
- **Nozzle connections:** The first and last active legs obey prescribed directions and length bounds. The last active leg reaches the fixed destination.
- **Obstacle avoidance:** Each relevant leg must be separated from each obstacle along at least one coordinate. Specific exemptions permit connection to the endpoint modules.
- **Support membership:** Every intermediate indexed node must lie in at least one support zone. This condition also applies to trailing nodes associated with absent legs.
- **Flexibility:** For each coordinate direction, a coefficient derived from the fixed endpoint separation bounds perpendicular leg lengths against a sum of perpendicular cubed lengths.

### Objective

The model minimizes pipe-length costs, bend costs, and support costs. It uses the original integer scaling rule, `cost div 100 + 1`, rather than simply dividing every cost by a common factor. The reformulation retains that rule and hence preserves objective values exactly.

## 3. Reformulation and justification

### Linear signed-displacement geometry

Each leg and axis receives positive- and negative-direction indicators and corresponding nonnegative displacement variables. Their difference equals the change in node coordinate; their sum equals the coordinate-wise leg length. At most one signed direction is active.

This replaces the original direction-dependent geometric implications with linear equations and bounds.

**Why it is valid:** In the original model, endpoint containment and the bounding-box width equation imply that a length component is at least the absolute endpoint displacement. The selected direction imposes the opposite inequality, forcing equality. An unselected axis has zero length and therefore equal endpoint coordinates. Consequently, the original constraints already force exact axis-aligned geometry and exact radius-expanded bounding boxes. The new equations describe those same relationships directly.

### Domain-based length preprocessing

Positive displacement is bounded by the next node’s coordinate upper bound minus the current node’s lower bound. Negative displacement uses the reverse difference. These bounds are intersected with the original leg-length limits.

First-leg and last-possible-leg bounds additionally use nozzle limits, and axes prohibited by their nozzle directions receive zero bounds.

**Why it is valid:** No displacement between two bounded coordinates can exceed the corresponding difference of domain extremes. The original direction and nozzle constraints already impose the additional restrictions. Thus, preprocessing excludes only values that were impossible in the original formulation.

### Exact finite-domain linearization of cubic terms

For each leg, binary selectors choose its total integer length from zero and the admissible positive lengths. Linear weighted sums then produce both the length and its cube. Additional bounded variables allocate that cube to the selected axis.

**Why it is valid:**

1. The original direction constraints permit at most one nonzero length component.
2. An active component satisfies the original minimum-length bound.
3. Each length has a finite integer upper bound.
4. Selecting exactly one admissible length therefore gives its cube exactly.
5. Inactive axes receive zero cube contribution, while the active axis receives the entire leg cube.

The resulting flexibility constraints are exact, not piecewise-linear approximations. This removes variable powers from the formulation presented to HiGHS, at the expense of introducing length-selection binaries.

### Boolean linearization of support costs

Products involving leg existence and support classification are replaced by Boolean conjunctions multiplied by constant costs.

**Why it is valid:** For binary indicators, multiplication equals the indicator of their conjunction. The original support-membership definitions and the domain of the “not in a preferred level” flag are retained, preserving both the cost calculation and its associated restrictions.

### Redundant endpoint-distance inequalities

For each coordinate, the sum of leg-length components is constrained to be at least the absolute separation of the fixed endpoints.

**Why it is valid:** The signed displacements telescope to the endpoint displacement. Because each length component equals the absolute displacement of its leg, the triangle inequality gives the stated bound. These inequalities remove no feasible integer routes and can strengthen the relaxation.

### Output and solution mapping

All original independent variables remain in the reformulated model. The mapping script returns only those variables, preserves their original array indices, restores fixed endpoint coordinates from the embedded instance when necessary, and accepts the reported objective as a fallback for `obj`. Auxiliary reformulation variables are excluded.

Overall, the changes aim to expose a bounded mixed-integer linear formulation more suitable for HiGHS while preserving the original routing semantics. No runtime improvement is claimed without comparative solver measurements.
