# Rectilinear Pipe Routing with Obstacles and Support Costs

## Problem background

The model represents the routing of a single industrial pipe between two fixed equipment connections, or **nozzles**, in a three-dimensional plant layout. Coordinates are integer-valued, with one coordinate unit representing 200 mm.

The route consists of axis-aligned straight legs joined by perpendicular bends. Fixed boxes represent equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels. The route must maintain the specified obstacle clearances and place intermediate nodes in permitted support zones. Preferred rack levels provide cheaper support.

Although the data contain a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. Consequently, neither formulation requires a rack visit.

## Original mathematical formulation

### Variables and route structure

The route has ten node positions and nine possible connecting legs. Its original independent variables comprise:

- **30 integer coordinate variables**, including six fixed endpoint coordinates.
- **60 integer leg-bound variables**, describing lower and upper corners of radius-expanded leg boxes.
- **30 nonnegative integer component-length variables**.
- **Ten direction variables**, with zero indicating an absent leg and six values representing signed coordinate directions.
- **Ten binary existence flags** and **ten binary final-leg flags**.
- An integer objective variable.

The leg arrays contain ten positions; the final position is a dummy entry whose variables are fixed to zero. Additional defined arrays represent obstacle separation, support membership, support costs, and flexibility expressions.

### Constraints

The principal constraint groups are:

1. **Geometry and direction.** Each active leg changes exactly one coordinate. Its component lengths and bounding box are linked to its endpoints and the pipe radius. Active legs have a minimum length of four coordinate units.

2. **Route sequencing.** Active legs form a prefix of the available legs. Exactly one is designated as the final leg, and at least the first three legs must exist. Consecutive active legs use different coordinate axes.

3. **Nozzle connections.** The first leg follows the prescribed departure direction. The final active leg follows the prescribed arrival direction and ends at the fixed destination. Both nozzle legs have additional length bounds.

4. **Obstacle clearance.** Each applicable leg box must be separated from every equipment or existing-pipe obstacle along at least one axis. Specific exceptions permit connection to the source and destination modules. Absent legs are not universally exempt from obstacle checks.

5. **Support membership.** Intermediate node positions must lie in at least one support zone. Membership uses the node center horizontally and the pipe bottom vertically. These requirements also apply to unused intermediate node positions.

The original file also contains inter-pipe separation and flexibility constraints. For this instance, the former have no applicable pairs because there is only one pipe, and the latter are inactive because the flexibility coefficient is zero.

### Objective

The model **minimizes** the sum of pipe-length, bend, and support costs. After the original integer scaling, the coefficients are:

- **131** per coordinate unit of pipe length;
- **1,301** per active leg after the first;
- **51** per supported bend outside preferred rack levels, or **1** inside a preferred level.

These scaled values—including the original “divide by 100, then add one” convention—are preserved.

## Reformulation and justification

### 1. Signed-length, one-hot geometry

For each leg and coordinate, the reformulation introduces positive- and negative-direction indicators and corresponding nonnegative lengths. The sum of the six indicators equals the original existence flag, so an active leg selects exactly one signed direction.

Endpoint displacement is expressed directly as positive length minus negative length. The original component length is their sum, and the original bounding-box variables are linked by linear equalities.

This replacement is exact. In the original model, the bounding-box inequalities imply that each component length is at least the absolute endpoint displacement. The direction constraints impose the matching upper bound on the selected component and force all other components to zero. Together, these constraints force the length to equal the absolute displacement and force the box to be the endpoint envelope expanded by the radius. The new equations encode those same relationships directly.

### 2. Domain-based directional bounds

Each signed length receives an upper bound derived from the endpoint coordinate domains and the original maximum leg length. For example, positive movement cannot exceed the next node’s upper coordinate bound minus the current node’s lower bound.

These bounds are valid for every original feasible route. Multiplying them by the associated binary direction indicator gives a standard **disaggregated mixed-integer linear formulation**, intended to strengthen the relaxation relative to direction-dependent implications.

Finite global bounds are also assigned to the leg-box variables using the original coordinate domains and pipe radius. Zero is included to accommodate the dummy leg.

### 3. Linearized support costs

The original support-cost expression multiplies a binary existence flag by a membership-dependent integer cost. The reformulation distributes this product into weighted Boolean conjunctions: a charge applies exactly when the leg exists and the relevant support category applies.

This is algebraically equivalent because existence and membership indicators are binary. The original preferred-level membership restriction is retained, rather than assuming that overlapping memberships are harmless.

### 4. Remaining-distance inequalities

For each route position and coordinate, two redundant inequalities require the remaining component lengths to cover both signs of the displacement to the destination.

Their validity follows from telescoping endpoint displacements and the triangle inequality: the sum of absolute movements cannot be smaller than the absolute net movement. These inequalities do not exclude any original feasible route; they provide explicit lower bounds that may help the MIP solver.

### 5. Instance-specific simplification and solution mapping

The reformulation omits inter-pipe separation because every node belongs to the same pipe, making the original pair-selection condition false. It also omits the flexibility expressions and constraints because the original conditional definitions evaluate to zero and true, respectively, when the supplied coefficient is zero.

All original independent decision variables are retained under their original names. The mapping script copies their solution values and reconstructs the six fixed endpoint coordinates from the unchanged embedded data. It excludes auxiliary variables and reports missing required fields.

These changes target a stronger, more explicit linear formulation for HiGHS. No measured runtime improvement is established by the supplied conversation.
