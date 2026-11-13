## Problem background

The model represents **three-dimensional, axis-aligned pipe routing in an industrial installation**. A pipe must connect two fixed nozzles while avoiding equipment and existing pipes and placing its bends in permitted support regions.

This self-contained instance contains one pipe, ten ordered routing nodes, nine possible connecting legs, and 102 fixed boxes. Box types distinguish equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels. Coordinates use a discretization of 200 mm per unit.

The pipe starts at \((246,52,200)\) and ends at \((309,96,80)\). Both nozzle connections require a positive vertical leg. Consequently, the route must initially rise, descend elsewhere, and rise again into the destination. The collision calculations use the original integer radius convention, `diameter div 2`, which gives one coordinate unit for this instance.

## Original formulation

### Variables and route structure

The original independent declarations contain **151 scalar integer entries**:

- 30 node coordinates, including six fixed endpoint coordinates;
- 60 lower and upper leg-box coordinates;
- 30 coordinate-wise leg lengths;
- 10 direction variables;
- 10 leg-existence indicators;
- 10 last-leg indicators;
- one objective variable.

The leg arrays include a tenth, unused slot that is fixed to zero. Additional defined arrays represent geometric predicates, support membership, support costs, and flexibility expressions.

Each existing leg has one of six signed coordinate directions. The sequence constraints make existing legs a contiguous prefix, require at least three legs, and identify exactly one final leg. Subsequent zero-length legs repeat the destination coordinate. Consecutive existing legs must use different coordinate axes.

### Geometric and engineering constraints

The model imposes:

- **Leg geometry:** endpoint displacement, direction, length, and radius-expanded bounding boxes must agree.
- **Length restrictions:** ordinary legs have a minimum length of six units; nozzle legs also satisfy their own bounds, giving an effective range of six to fifteen units here.
- **Obstacle avoidance:** every checked leg must be separated from each equipment or existing-pipe box along at least one coordinate axis, including its prescribed safety distance.
- **Nozzle exceptions:** the first leg may intersect its source module; the last leg and inactive trailing legs receive the specified destination-module exception.
- **Support requirements:** nodes 2 through 9 must lie in at least one support region, even when they belong to the inactive trailing portion. Horizontal membership uses the node centre; vertical membership uses the bottom of the pipe.
- **Support pricing:** active bends receive either the default support cost or the cost associated with a preferred rack level.

The source also contains inter-pipe separation and flexibility constraints. Inter-pipe separation has no applicable pairs because this instance has only one pipe. Flexibility is inactive because its coefficient is zero. A proposed requirement to traverse the rack is commented out in the original and is not enforced.

### Objective

The objective minimizes the original scaled sum of pipe length, bends, and supports. Its coefficients are computed as `cost div 100 + 1`, giving:

- 181 per unit of pipe length;
- 1,801 per existing leg after the first;
- 51 for a default support, or 1 at a preferred rack level.

These coefficients and the minimization direction are preserved exactly.

## Reformulation and justification

### 1. Explicit signed-direction formulation

Each leg and coordinate receives positive- and negative-direction binary indicators and corresponding nonnegative lengths. The sum of the six indicators equals the original existence indicator, so an existing leg selects exactly one signed axis. The original direction variable is recovered by a linear weighted sum.

Each signed length is bounded above by its direction indicator times a valid maximum, and below by the ordinary minimum length times that indicator. Endpoint displacement is then expressed as:

\[
x_{i+1,k}-x_{i,k}=\ell^+_{i,k}-\ell^-_{i,k}.
\]

This replaces the original direction-dependent implications with an explicit mixed-integer linear formulation.

**Validity:** in the original model, the bounding-box inequalities imply that a coordinate-wise leg length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality in that direction, forcing equality. Unselected coordinates have zero length and therefore equal endpoint coordinates. The signed-length formulation expresses precisely these same relationships.

### 2. Exact linear bounding-box equations

The lower and upper leg-box coordinates are written as:

\[
L_{i,k}=x_{i,k}-\ell^-_{i,k}-r,\qquad
U_{i,k}=x_{i,k}+\ell^+_{i,k}+r.
\]

**Validity:** the original length equality and endpoint-containment inequalities, together with the direction constraints, force the box to be the exact radius-expanded interval between the endpoints. It cannot contain additional slack. These equations therefore replace an implied equality structure without changing feasible geometry.

### 3. Bound tightening and obstacle preprocessing

Signed-length upper bounds combine the original maximum leg length, applicable nozzle maximum, and maximum displacement allowed by endpoint domains.

Bounds on the exact lower and upper leg-box coordinates are also derived from the endpoint domains. They are used to:

- omit an obstacle test when separation is guaranteed along some axis;
- remove a separation alternative when it is impossible under those bounds.

**Validity:** these tests use bounds that contain every feasible endpoint and leg-box value. Removing an always-false alternative does not change a disjunction; removing an already-satisfied obstacle constraint does not restrict the feasible set. The original nozzle exceptions remain intact.

### 4. Linear support-cost expression

The product of leg existence and support cost is replaced by weighted Boolean conjunctions: an active node outside preferred levels incurs the default cost, while an active node inside a preferred level incurs that level’s cost.

**Validity:** for binary values, multiplication is equivalent to conjunction. The original preferred-level membership equation and its binary domain are retained, so the replacement preserves the exact cost, including zero cost for inactive legs.

### 5. Valid route-length and direction-count cuts

The reformulation adds three families of redundant inequalities:

- Total length along each axis is at least the absolute endpoint displacement.
- A positive or negative net displacement requires at least one leg in that signed direction.
- When both nozzle legs point opposite the net displacement along their axis, their travel requires additional compensating length and additional legs.

**Validity:** summing the endpoint-displacement equations telescopes to the fixed endpoint difference. The first two cuts follow directly from that identity and nonnegative signed lengths. For the third, the first and last legs are distinct under the original sequence constraints. Their combined mandatory travel opposite the net displacement must be offset by equal additional travel in the other direction.

Here the net displacement is \((63,44,-120)\). The two positive vertical nozzle legs each have length at least six, so total vertical travel is at least \(120+2(6+6)=144\). Positive horizontal movement on both axes and negative vertical movement require three further distinct legs, giving at least five existing legs.

## Interface and expected effect

All original independent variables remain available, and the mapping script returns only those variables. It can restore omitted fixed endpoint coordinates from their original singleton domains. The array-dimension repairs restored accidentally duplicated entries to the original data; they did not alter the instance.

The reformulation targets HiGHS by exposing linear geometric relationships, tightening bounds, reducing unnecessary disjunctions, and strengthening the relaxation with valid cuts. These changes are intended to improve solving time; no measured speedup is established by compilation checks alone.
