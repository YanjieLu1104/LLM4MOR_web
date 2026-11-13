# Orthogonal Pipe Routing with Obstacles and Support Zones

## Application and instance

The model represents the routing of an industrial pipe between two fixed nozzles in a three-dimensional installation. The route must use axis-aligned straight segments, avoid equipment and existing pipework, and place intermediate nodes within permitted support regions.

Coordinates are integer multiples of a 200 mm discretization unit. This instance contains one pipe, 10 ordered nodes, and 178 fixed boxes describing equipment, existing pipe segments, support zones, a rack, and preferred rack levels. The endpoints are fixed at `(315, 54, 73)` and `(335, 53, 8)`.

There are nine possible connecting legs. Used legs form a contiguous prefix, with at least three used legs; subsequent nodes coincide with the destination. Consecutive used legs must follow different coordinate axes.

## Original mathematical structure

### Variables

The original model declares 151 independent integer-variable entries before counting defined views:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 leg-boundary coordinates**, representing lower and upper corners of each leg’s bounding box.
- **30 coordinate-wise leg lengths**.
- **10 direction variables**, with zero denoting an unused leg and six values denoting signed coordinate directions.
- **10 existence flags** and **10 last-leg flags**.
- **One objective variable**.

The leg arrays include a dummy entry associated with the terminal node, fixed to zero. Additional defined expressions represent obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The main constraint families are:

1. **Leg geometry and direction.** Bounding boxes contain the two endpoint nodes, expanded by the integer pipe radius. Lengths equal box extents minus the diameter contribution. Direction implications permit movement along only one signed axis.

2. **Route sequencing.** Exactly one leg is last. Existence flags enforce a contiguous prefix of used legs, and the first three legs exist.

3. **Nozzle connections.** The first and last used legs have prescribed directions and length ranges. The last used leg terminates at the fixed destination.

4. **Orthogonality.** Consecutive legs cannot use the same coordinate axis, excluding both straight continuation and immediate reversal.

5. **Obstacle avoidance.** Each applicable leg must be separated from each obstacle along at least one axis, including safety clearance. Specific exceptions permit connections to the designated nozzle equipment boxes.

6. **Support requirements.** Every intermediate node indexed by a possible leg must belong to a support zone. Importantly, this requirement also applies to nodes associated with unused legs.

The source also contains inter-pipe separation and flexibility constraints. Neither imposes an additional restriction in this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes its original scaled cost:

- **61 per unit of pipe length**;
- **601 per used leg after the first**, representing bend cost;
- **51 per chargeable node outside preferred rack levels**, or **1 inside a preferred level**.

These coefficients come from integer division of the input costs by 100 followed by addition of one. The reformulation preserves these coefficients and the minimization direction.

## Reformulation and validity

### Signed-direction extended formulation

The direction implications were replaced by positive- and negative-direction binary indicators and corresponding nonnegative lengths for each axis.

The indicators sum to the leg-existence flag, so a used leg has exactly one signed direction and an unused leg has none. Coordinate displacement equals positive length minus negative length, while total axis length equals their sum.

This is equivalent to the original geometry: endpoint containment implies that an axis length is at least the absolute endpoint displacement. The selected-direction inequality supplies the reverse bound, forcing equality. Nonselected axes have zero length and therefore zero displacement.

### Exact leg bounding boxes

Lower and upper leg coordinates are now expressed directly using the starting node and signed lengths.

This does not restrict the original feasible set. In the original formulation, the bounding box contains both endpoints, and its extent is forced to equal their absolute displacement plus twice the radius. Consequently, its boundaries must already be the endpoint minimum and maximum, expanded by the radius.

### Bound-based preprocessing and separation certificates

Obstacle avoidance now uses binary **separation certificates**: activating a certificate enforces separation on a particular side of an obstacle. At least one certificate is required unless an original nozzle-box exception applies.

Full equivalence between each certificate and its geometric inequality is unnecessary. The original condition requires only that some separating inequality hold; any separated leg can select a corresponding certificate.

Coordinate bounds also support two valid preprocessing steps:

- Remove a leg–obstacle check when one separating inequality holds throughout the leg’s entire coordinate domain.
- Fix a certificate to zero when its separating inequality cannot hold anywhere in that domain.

The remaining implications use bound-derived big-M coefficients. Signed-length upper bounds are likewise tightened using the maximum possible displacement between endpoint domains. These changes aim to reduce redundant binary decisions and strengthen the linear relaxation.

### Linear support costs

The product between leg existence and support cost was rewritten as a baseline cost for an existing leg plus preferred-level adjustments activated by Boolean conjunctions.

This follows algebraically from the original definition
`fNodeNotInPref = 1 − sum(preferred-level memberships)`.
That definition and its binary domain are retained, preserving the original restriction on simultaneous preferred-level memberships. Support requirements are also retained for unused intermediate nodes.

### Inactive constraints and valid length cuts

Inter-pipe separation is omitted because the original constraint ranges over pairs belonging to different pipes, and no such pair exists here. Flexibility constraints are omitted because the original conditional makes them true when the supplied coefficient is nonpositive; the corresponding defined sums remain zero.

For each coordinate axis, an additional valid inequality requires total routed length to be at least the absolute endpoint displacement. This follows from summing consecutive displacements and applying the triangle inequality.

## Implementation and solution correspondence

All original independent variables remain available under their original names. The mapping script returns only those variables, recovering omitted fixed endpoint coordinates from their original singleton domains and, when necessary, recovering `obj` from the reported objective.

The reported array-dimension error was repaired by restoring the original box-size literal, removing an accidentally duplicated entry rather than changing the instance geometry.

The reformulation targets a smaller, stronger mixed-integer representation for HiGHS. No measured runtime improvement or optimal objective was established in the conversation.
