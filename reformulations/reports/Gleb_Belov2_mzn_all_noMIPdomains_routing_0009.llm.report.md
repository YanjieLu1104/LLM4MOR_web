## Background and interpretation

This instance models **three-dimensional pipe routing through an industrial installation**. A single pipe connects two fixed nozzles while avoiding equipment modules and existing pipe segments represented by rectangular boxes. Coordinates are integer-valued on a grid with a spacing of 200 mm.

The route has ten node positions and up to nine axis-aligned legs. Intermediate nodes represent bends and must lie in permitted support regions. Some rack levels offer cheaper support. The pipe’s modeled radius is `nDiam div 2 = 1` grid unit; obstacle clearance also includes the specified safety distance.

The model does not prohibit intersections between legs of the same pipe. Although the data include a flag requesting passage through a rack, the corresponding constraint is commented out in the original source and therefore is not enforced.

## Original model structure

### Variables

Before flattening, the original model declares **151 independent integer variable entries**:

- 30 node coordinates, including six fixed endpoint coordinates;
- 60 lower and upper leg-envelope coordinates;
- 30 coordinate-wise leg lengths;
- 10 direction variables;
- 10 leg-existence indicators;
- 10 last-leg indicators;
- one objective variable.

The leg arrays include a dummy entry at the final node, fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, and support costs.

### Constraints

The main constraint groups enforce:

- **Axis-aligned geometry:** an existing leg moves along exactly one coordinate axis. Its envelope includes the pipe radius.
- **Route sequencing:** existing legs form a contiguous prefix, with exactly one last leg and at least three existing legs.
- **Orthogonal bends:** consecutive existing legs use different axes, excluding immediate reversal.
- **Nozzle connections:** the first and last existing legs have prescribed directions and restricted lengths.
- **Obstacle clearance:** each leg must be separated from each applicable obstacle along at least one axis. Specified exceptions permit connection to the endpoint modules.
- **Support membership:** intermediate node slots must belong to at least one support region. This requirement also applies to slots whose outgoing legs do not exist.
- **Preferred-level accounting:** membership in preferred rack levels determines support costs.

The source also contains inter-pipe separation and flexibility constraints, but neither restricts this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes the sum of scaled pipe-length, bend, and support costs. The original coefficient transformation—integer division by 100, followed by adding one—is preserved exactly.

For this instance:

- pipe length costs 161 per grid unit;
- each existing leg after the first contributes a bend cost of 1,601;
- an active intermediate node costs 51 for ordinary support or 1 in a preferred rack level.

## Reformulation and justification

### 1. Disaggregated directional displacement

The implication-based direction formulation was replaced by positive and negative displacement variables and binary direction selectors for each leg and axis.

The new equations directly enforce:

- coordinate change = positive displacement − negative displacement;
- leg length = positive displacement + negative displacement;
- exactly one signed axis is selected for an existing leg;
- no displacement is possible for a nonexistent leg.

This is equivalent to the original geometry. Originally, the envelope constraints make each coordinate-wise length at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality, while unselected axes have zero length. Together, these constraints force exact axis-aligned displacement and exact leg envelopes. The new formulation states those relationships explicitly as linear equations and binary-linked bounds, making them more accessible to HiGHS.

### 2. Coordinate-bound strengthening

Directional displacement limits are derived from endpoint coordinate domains. For example, positive displacement cannot exceed the next node’s upper bound minus the current node’s lower bound, or the original leg-length limit.

Leg-envelope bounds are also tightened using their exact minimum/maximum interpretation. These bounds are valid consequences of the original geometry, not restrictions on the allowable routing region. They strengthen the mixed-integer formulation without removing feasible routes.

### 3. Support-zone feasibility preprocessing

A node–zone membership is fixed to false when the node’s coordinate domain cannot intersect that zone on at least one axis. The vertical test includes the original radius adjustment because support membership is measured at the pipe’s bottom.

Such membership is impossible under the original coordinate bounds and zone inequalities. Removing it therefore preserves the support requirement while avoiding unnecessary membership logic. Membership remains exact for all surviving node–zone pairs.

### 4. Linearized support-cost accounting

The original support-cost expression multiplies a leg-existence indicator by a variable support charge. The reformulation distributes that product into Boolean conjunctions:

- the leg exists **and** the node requires ordinary support;
- the leg exists **and** the node belongs to a particular preferred level.

For binary indicators, conjunction is exactly their product. Retaining the original preferred-level accounting makes this an exact reformulation rather than an objective approximation.

### 5. Removal of inactive instance-specific components

Two components were simplified using the supplied data:

- **Inter-pipe separation:** the original constraints apply only to pairs belonging to different pipes. All nodes belong to pipe 1, so there are no applicable pairs.
- **Flexibility:** the original expressions return zero and the associated constraints return true when the flexibility coefficient is nonpositive. Here it is exactly zero, so replacing the defined flexibility sums with zero preserves their values.

No active rack-passage or self-intersection constraint was removed; neither was enforced by the original model.

## Solution interface and expected effect

All original independent variables, their meanings, and their indices are retained. The mapping script copies those variables, restores any omitted fixed endpoint coordinates from the unchanged embedded data, and obtains the original objective from `obj` or the identical reported objective value.

The reformulation targets faster mixed-integer optimization through explicit linear geometry, stronger bounds, support-membership preprocessing, and simpler cost expressions. **No measured speedup is established here**; the intended benefit is a formulation better suited to HiGHS while preserving the original feasible routes and objective values.
