## Overview

The model represents **three-dimensional pipe routing in an industrial installation**. A pipe must connect two fixed nozzles while avoiding equipment and existing pipes. Its route consists of axis-aligned straight segments, with bends located in permitted support zones.

The supplied instance contains one pipe, 10 ordered route nodes, and 190 fixed boxes. Box types distinguish equipment modules, existing pipe segments, module support zones, a rack, and preferred rack support levels. Coordinates use a discretization unit of 200 mm.

## Original formulation

### Variables

The original independent variables comprise:

- **30 integer node coordinates**, including six fixed coordinates for the two endpoints.
- Two **10 × 3 integer arrays** describing each leg’s lower and upper bounding-box coordinates.
- One **10 × 3 nonnegative integer array** of coordinate-wise leg lengths.
- Three **10-element integer arrays** for direction, existence, and last-leg indicators.
- One integer objective variable.

There are nine possible connecting legs. The tenth position in the leg arrays is a dummy position fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The routing constraints enforce:

- **Axis-aligned geometry:** an existing leg moves along exactly one coordinate axis; its direction determines the sign of that movement.
- **A contiguous active prefix:** at least the first three legs exist, exactly one active leg is designated last, and subsequent legs have zero length.
- **Orthogonal consecutive legs:** adjacent active legs cannot use the same axis, preventing both straight continuation and immediate reversal.
- **Nozzle requirements:** the first leg has a prescribed direction and length range; the designated last leg has its own prescribed direction and length range.
- **Obstacle clearance:** a leg must be separated from each relevant obstacle along at least one axis, including the specified safety distance. The original nozzle-module exceptions are retained.
- **Support availability:** every intermediate node covered by the original support constraint must lie in a support zone, including nodes associated with inactive trailing legs.

The source also contains inter-pipe separation and flexibility constraints. Neither imposes an active restriction in this instance: there is only one pipe, and its flexibility coefficient is zero. A requirement to pass through a rack is commented out in the original source and therefore is not part of the problem.

### Objective

The model **minimizes pipe length, bend charges, and support charges**. It uses the original integer-scaled coefficients, including the added unit after division by 100:

- 51 per unit of pipe length;
- 501 per active leg after the first, representing a bend charge;
- 51 per supported bend outside preferred rack levels, or 1 inside a preferred level.

The objective’s values and minimization direction are unchanged.

## Reformulation and validity

### 1. Linear signed-length representation

Each leg-axis pair receives positive- and negative-direction indicators and corresponding nonnegative lengths. Their sum gives the original length, while their difference gives the displacement between consecutive nodes. The sum of all direction indicators equals the original existence indicator.

This is equivalent to the original geometry because its bounding-box inequalities imply that each coordinate-wise length is at least the absolute endpoint displacement. The direction constraints then bound that length above by the selected signed displacement, forcing equality. Unselected axes have zero length and therefore zero displacement.

The reformulation expresses these relationships directly as linear equations and indicator-dependent bounds, avoiding the original collection of direction-dependent geometry implications.

### 2. Exact linear bounding-box equations

The leg bounds are connected to endpoint coordinates and lengths through
\[
2\,\text{lower}
=
\text{start}+\text{end}-\text{length}-2r,
\qquad
\text{upper}
=
\text{lower}+\text{length}+2r.
\]

These equations are valid because the preceding geometry establishes that length equals absolute displacement. They therefore reproduce the endpoint minimum and maximum, expanded by the pipe radius, rather than imposing a new geometric restriction.

All original independent bounding-box variables are retained.

### 3. Bound-based preprocessing

Positive and negative length limits are derived from the declared endpoint-coordinate domains and the original maximum leg length. For example, positive displacement cannot exceed the next node’s upper bound minus the current node’s lower bound.

Obstacle checks are omitted only when these declared bounds prove that **every possible position of the entire leg is already separated from the obstacle** along some axis. Thus, each removed check is a tautology over the original domains; no potentially intersecting obstacle is discarded.

### 4. Linearized support costs

The original support cost multiplies the existence indicator by a membership-dependent charge. Using the original identity
\[
\text{not-preferred}
=
1-\sum_z \text{in-preferred-zone}_z,
\]
the reformulation rewrites the cost as a default charge for an active leg plus adjustments for preferred-zone membership. Each adjustment uses a Boolean conjunction of activity and membership.

This is an exact algebraic reformulation. The original binary domain of the not-preferred variable is retained, so its restriction against simultaneous membership in multiple preferred levels is preserved rather than assumed.

### 5. Inactive constraints and solution interface

The inter-pipe and flexibility expressions remain in the model but generate no effective restrictions for this fixed instance. The former require a pair of different pipes, which does not exist; the latter explicitly evaluate to inactive when the flexibility coefficient is nonpositive.

The mapping script exports only original independent variables. It copies retained solution values and can restore omitted fixed endpoint coordinates from the unchanged instance data. It does not introduce a new route interpretation or objective scaling.

These changes target a more direct mixed-integer linear formulation for HiGHS. **No measured runtime improvement is claimed**; the expected benefit comes from simpler geometry, tighter bounds, and fewer unnecessary obstacle checks.
