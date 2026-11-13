# Pipe-Routing Model and MILP Reformulation

## 1. Application and instance

The model represents the routing of an industrial pipe between two fixed equipment connections in a three-dimensional plant layout. Coordinates use a grid with **200 mm per unit**. The pipe must avoid equipment and existing pipe segments, maintain specified clearances, and place intermediate nodes in permitted support regions.

This instance contains one pipe with **10 node positions and up to nine axis-aligned legs**. The endpoints are fixed at \((309,106,80)\) and \((302,60,54)\). Intermediate coordinates are integer-valued. Fixed boxes represent equipment modules, existing pipe legs, module support zones, a rack, and preferred rack levels.

The model also imposes a cubic-length flexibility condition, apparently intended to represent a piping flexibility or thermal-expansion requirement. This interpretation follows from the model’s comments and coefficients; the formulation is not a full mechanical stress analysis.

Although a parameter indicates routing through a rack, the corresponding constraint is commented out in the original model. The reformulation does not activate it.

## 2. Original mathematical structure

### Variables

The original model declares **151 independent scalar integer-variable entries**:

- **30 node coordinates**, including six fixed endpoint coordinates;
- **60 leg-box boundary coordinates**, describing lower and upper corners in three dimensions;
- **30 nonnegative directional leg lengths**;
- **10 direction variables**, with zero indicating an unused leg;
- **10 binary leg-existence flags**;
- **10 binary last-leg flags**;
- **One objective variable**.

The leg arrays include a tenth, nonactual leg position, whose entries are fixed to zero. Additional defined arrays describe obstacle separation, support membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint families are:

- **Axis-aligned geometry:** each active leg moves along exactly one coordinate axis. Its bounding box includes the pipe radius.
- **Route sequencing:** active legs form a prefix, at least three legs exist, and exactly one active leg is designated last.
- **Bend restrictions:** consecutive active legs use different axes, preventing immediate continuation or reversal along the same axis.
- **Nozzle conditions:** the first and last active legs have prescribed directions and length restrictions.
- **Obstacle avoidance:** a leg must be separated from each relevant obstacle along at least one axis, subject to specific endpoint-module exemptions.
- **Support placement:** intermediate nodes must belong to at least one permitted support zone. Membership is measured at the node center horizontally and at the pipe bottom vertically.
- **Flexibility:** sums of cubed leg lengths in the two axes orthogonal to each coordinate must exceed coefficient-weighted individual lengths.

The original formulation includes inter-pipe separation logic, but it imposes no restrictions in this single-pipe instance. It also imposes some obstacle and support conditions on unused route positions; these conditions remain in the reformulation.

### Objective

The model minimizes the original scaled cost:

\[
161\sum_{\ell,k} L_{\ell k}
+1601\sum_{\ell\text{ other than first}} e_\ell
+\sum_{\ell\text{ other than first}} C^{\mathrm{support}}_\ell.
\]

The coefficients follow the original integer division by 100 and subsequent addition of one. An active intermediate node costs 51 support units outside preferred rack levels and one unit inside a preferred level. Neither this scaling nor the minimization direction was changed.

## 3. Reformulation and its justification

### Linear signed-length geometry

Each directional length is split into nonnegative positive- and negative-direction components, selected by binary direction indicators. Their difference equals the coordinate displacement, while their sum equals the original length.

This is an exact replacement because the original constraints already force:

1. the leg box to contain both endpoints, implying that its length is at least the absolute displacement;
2. the selected direction’s length to be no greater than the corresponding signed displacement; and
3. all unselected coordinate lengths to be zero.

Together, these conditions force equality with the absolute displacement and uniquely determine the bounding-box endpoints. The reformulation expresses those equalities directly, replacing direction-dependent implications with linear equations and bounded binary-linked lengths.

### Bound preprocessing

Each length receives an upper bound derived from:

- the original pipe-leg maximum;
- the largest possible endpoint displacement permitted by the coordinate domains; and
- the original first-nozzle or last-possible-leg restrictions, where applicable.

These bounds are valid because the geometry constraints make length equal to absolute endpoint displacement. No bound relies on an assumed route or an unverified incumbent solution.

Finite global bounds are also supplied for leg-box coordinates using the original coordinate domains and pipe radius.

### Exact MILP representation of cubes

Variable cubing is replaced by a binary-expansion formulation. For a bounded integer length \(x\),

\[
x=\sum_j 2^j b_j.
\]

Auxiliary variables represent \(xb_j\), yielding \(s=x^2\), and then \(sb_j\), yielding \(y=x^3\). Each binary–bounded-variable product is enforced with the standard exact linear inequalities.

Thus, the flexibility constraints use the **exact integer cubes**, not a piecewise approximation. The reformulation makes this nonlinear portion explicitly compatible with a linear mixed-integer solver such as HiGHS.

### Valid relaxation-strengthening cuts

Two types of redundant inequalities strengthen the MILP relaxation:

- **Square and cube bounds:** for \(0\le x\le U\), inequalities such as \(x^2\le Ux\) and \(x^3\le Ux^2\) hold. Additional lines through consecutive integer points of the square and cube functions provide lower bounds at every integer length. Their validity follows from convexity on the nonnegative domain.
- **Endpoint-distance cuts:** total travel along each axis is at least the absolute endpoint displacement along that axis. This follows by summing leg displacements and applying the triangle inequality.

These cuts exclude fractional relaxation points, but no feasible original route.

### Linear support-cost calculation

The original support cost multiplies a binary existence flag by a membership-dependent cost. The reformulation distributes this expression into constant-weighted Boolean conjunctions.

For binary values \(a,b\), \(ab\) equals the indicator of \(a\land b\), so this transformation preserves the cost exactly. The original preferred-level membership definition and its binary-domain restriction remain enforced.

## 4. Preservation and solution mapping

All fixed instance data, original independent variables, objective coefficients, and necessary constraints are retained. The mapping script returns the original coordinate variables, geometry arrays, sequencing arrays, and objective. If MiniZinc omits the fixed endpoint coordinates from its output, the script restores them from the unchanged, self-contained instance data.

The reformulation is intended to improve HiGHS performance through explicit linearization, tighter bounds, and stronger relaxations. No measured speedup is established by the conversation.
