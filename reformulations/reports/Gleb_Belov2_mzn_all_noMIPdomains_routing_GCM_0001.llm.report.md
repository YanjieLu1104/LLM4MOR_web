# Pipe Routing with Obstacle Clearance and Flexibility Requirements

## 1. Application background

The model represents three-dimensional routing of an industrial pipe between two fixed equipment connections, or **nozzles**. Coordinates are integer multiples of a 200 mm length unit.

The supplied instance contains one pipe, 10 ordered routing nodes, and 83 fixed boxes. Boxes represent equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. Consecutive routing nodes form axis-aligned pipe legs. The model permits unused trailing legs, so the route need not use all nine available segments.

A feasible route must respect obstacle clearances, nozzle connection directions, leg-length limits, support availability, and a cubic-length flexibility condition. The latter appears to approximate piping flexibility or thermal-expansion accommodation; it is not a full mechanical stress analysis.

Although the data contain a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation therefore does not enforce rack traversal.

## 2. Original mathematical structure

### Variables

Before fixing and propagation, the original model declares **151 independent integer-variable entries**:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Coordinates of 10 nodes; six endpoint coordinates are fixed |
| Lower and upper leg-box coordinates | 60 | Radius-expanded bounding boxes of the legs |
| Axis-specific leg lengths | 30 | Nonnegative length in each coordinate direction |
| Leg directions | 10 | Zero for an unused leg; six signed axis directions otherwise |
| Leg-existence flags | 10 | Whether a leg belongs to the route |
| Last-leg flags | 10 | Which leg terminates the route |
| Objective variable | 1 | Total scaled cost |

The leg arrays include a tenth, nonactual leg entry, which the constraints fix to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint families are:

- **Axis-aligned geometry:** Each existing leg moves along exactly one axis. Its length and radius-expanded bounding box are linked to its endpoint coordinates.
- **Route sequence:** Existing legs form a contiguous prefix, exactly one is the last leg, and the first three legs must exist. Consecutive existing legs must use different axes.
- **Nozzle connections:** The first leg has a prescribed direction and length range. The selected last leg has its own direction and length limits and ends at the fixed destination.
- **Obstacle avoidance:** Each relevant leg must be separated from an obstacle along at least one axis, accounting for pipe radius and safety distance. The original nozzle-module exemptions are significant and are retained.
- **Support availability:** Nodes 2–9 must lie in at least one support zone. Membership uses the node centre horizontally and the pipe bottom vertically. This requirement applies even to inactive trailing nodes.
- **Flexibility:** For each coordinate direction, a coefficient based on nozzle separation bounds individual orthogonal leg lengths by the sum of cubed orthogonal lengths.
- **Inter-pipe clearance:** The source includes this constraint family, but it produces no pairwise constraints for this single-pipe instance.

### Objective

The model minimizes scaled pipe-length, bend, and support costs. For this instance:

- Length costs **201 per coordinate unit**.
- Each existing leg after the first incurs a **2,001 bend charge**.
- Each corresponding supported node costs **51 outside preferred rack levels** or **1 within a preferred level**.

These coefficients include the original integer division by 100 and subsequent addition of one. The reformulation preserves this objective exactly.

## 3. Reformulation and its justification

### Exact discrete linearization of cubic lengths

The variable powers \(L^3\) were replaced by binary selectors for feasible positive integer lengths. For each leg and axis,

\[
L=\sum_t t\,y_t,
\qquad
L^3=\sum_t t^3y_t.
\]

The selector sum equals the axis-activity indicator. Consequently, an inactive axis has length zero, while an active axis selects exactly one positive length.

This is an **exact finite-domain reformulation**, not a piecewise-linear approximation: original lengths are integer-valued and bounded, and every admissible length retains its exact cube. It removes variable powers from the formulation presented to HiGHS, at the cost of additional binary variables.

### Bound-based preprocessing of length choices

The selector domains exclude lengths that cannot occur:

- The coordinate bounds limit the maximum possible endpoint displacement.
- The original general leg-length limit supplies another upper bound.
- First-leg and last-possible-leg nozzle constraints further restrict their permitted axes and maximum lengths.
- An active axis must meet the original minimum leg length; the first leg must also meet its nozzle-specific minimum.

These restrictions follow directly from the original geometry and length constraints, so they do not remove feasible routes.

### Signed directional lengths and linear bounding boxes

Each axis now has positive- and negative-direction indicators and corresponding nonnegative movement amounts. Their sum gives the axis length; their difference gives the endpoint displacement. At most one signed direction is active on a leg.

This also gives linear expressions for the leg-box endpoints. The replacement is valid because the original constraints already force those boxes to be tight: containment implies that the represented length is at least the absolute endpoint displacement, while the selected direction imposes the reverse inequality. Thus the original bounds equal the endpoint minimum and maximum, expanded by the pipe radius.

The original coordinate, length, direction, existence, and bounding-box variables remain available for solution checking.

### Boolean linearization of support costs

The original support-cost expression multiplies a leg-existence flag by a sum of support-class indicators. The reformulation distributes this product and uses Boolean conjunctions.

For binary indicators, multiplication is exactly logical conjunction. The existing preferred-level membership constraint is retained, including its restriction against multiple simultaneous preferred-level memberships. Support costs therefore remain unchanged.

### Nozzle-displacement cuts

Additional valid inequalities strengthen the formulation using fixed endpoint displacement and nozzle-leg bounds.

For the X direction, the required net displacement is \(-46\). The first leg moves negatively and the last positively; both have effective lengths between 8 and 15. Their combined displacement can therefore only lie between \(-7\) and \(7\). At least one additional X-directed leg is necessary.

The Y and Z displacements are nonzero, while both nozzle legs are X-directed. Hence at least one Y-directed and one Z-directed leg are also necessary. Together, these facts imply at least five existing legs.

Further cuts lower-bound positive movement, negative movement, and total length on each axis. They follow from the displacement identity

\[
P-N=\Delta
\]

and the minimum positive or negative movement forced by the nozzle legs. They strengthen the relaxation without excluding any originally feasible solution.

### Instance simplification and solution interface

The inter-pipe clearance family is vacuous because all nodes belong to the same pipe. Obstacle separation is expressed directly rather than through the original intermediate separation arrays. Neither change removes a required physical restriction.

The mapping script restores every original independent variable and excludes reformulation-only auxiliaries. It uses the unchanged fixed endpoint coordinates when those constants are omitted from solver output and reports missing nonfixed values explicitly.

## 4. Expected computational effect

The reformulation replaces nonlinear expressions with an exact mixed-integer linear representation, exposes directional geometry directly, and strengthens bounds using nozzle information. These changes target HiGHS, although the discrete cubic representation adds many binary variables. No measured runtime improvement or optimality result was established in the conversation.
