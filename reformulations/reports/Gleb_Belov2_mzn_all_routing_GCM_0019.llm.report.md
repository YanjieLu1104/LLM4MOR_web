# Pipe Routing with Clearance, Support, and Flexibility Requirements

## Application background

The model describes the routing of a pipe through a three-dimensional industrial layout. The pipe connects two fixed nozzles and must avoid equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined by right-angle bends.

The layout also contains support zones, a pipe rack, and preferred rack support levels. Intermediate route nodes must lie in a support zone, with membership measured at the pipe’s bottom in the vertical direction. Preferred levels reduce support costs.

Coordinates use a discretization of **200 mm per unit**. The pipe diameter is two units, giving a modeled radius of one unit. Additional “GCM” constraints use sums of cubed leg lengths to represent a flexibility requirement. The source identifies these as flexibility constraints; it does not provide enough information to assess their engineering accuracy independently.

## Original formulation

### Variables and route structure

There is one pipe with **10 nodes**, providing nine potential legs between consecutive nodes. The model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two \(10 \times 3\) integer arrays for expanded leg-box bounds.
- A \(10 \times 3\) array of nonnegative directional leg lengths.
- Three length-10 arrays for leg direction, existence, and last-leg indicators.
- An integer objective variable.

The tenth entry in each leg array is a dummy entry fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and cubic flexibility sums.

Direction values distinguish positive and negative movement along each coordinate axis, with zero denoting a nonexistent leg. Existence and last-leg constraints require a contiguous prefix of active legs, with at least three active legs.

### Constraints

The principal constraint groups are:

1. **Geometry and directions.** Each active leg moves along exactly one axis. Successive active legs use different axes, preventing both straight continuation and immediate reversal. Leg lengths obey lower and upper bounds.

2. **Nozzle connections.** The first leg has a prescribed direction and length range. The dynamically selected last leg has its own prescribed direction and length range and terminates at the fixed destination.

3. **Obstacle clearance.** Radius-expanded leg boxes must be separated from each obstacle along at least one coordinate. Specified exceptions allow connection to the source and destination modules.

4. **Support availability.** Nodes indexed 2 through 9 must belong to at least one support zone. Importantly, this condition also applies to nodes associated with unused trailing legs.

5. **Flexibility.** For each coordinate axis, the model sums cubed lengths in the other two axes. That sum must exceed a coefficient times each relevant leg length. The coefficient depends on the fixed nozzle displacement, discretization scale, and supplied flexibility factor.

The source also contains inter-pipe separation constraints, but they generate no restrictions in this single-pipe instance. Likewise, the commented rack-traversal condition is not part of the enforced model.

### Objective

The model **minimizes** pipe-length, bend, and support costs. After the original integer scaling:

- Total leg length has coefficient **131**.
- Each active leg after the first incurs **1,301**, corresponding to a bend.
- Each charged support costs **51** outside preferred rack levels or **1** within a preferred level.

The reformulation preserves these coefficients and the minimization direction.

## Reformulation and its justification

### Exact signed-length formulation

Each coordinate component receives positive- and negative-direction indicators and nonnegative forward and backward lengths. Their difference equals the coordinate displacement; their sum equals the original leg length.

This is equivalent to the original geometry constraints. Originally, the expanded leg box implies that the length is at least the absolute endpoint displacement. The selected direction then bounds it above by the corresponding signed displacement. Together, these force equality. In an unselected coordinate, the length is zero, forcing equal endpoint coordinates.

The reformulation expresses these consequences directly and computes the expanded leg-box endpoints from the signed lengths. This exposes linear structure rather than relying on multiple direction implications.

### Bound-based preprocessing of length alternatives

Possible active lengths are restricted using:

- The original minimum leg length.
- The largest displacement allowed by endpoint coordinate bounds.
- The original maximum leg length.
- The first-nozzle and last-possible-leg bounds and permitted axes.

These restrictions are valid because an axis-aligned leg’s length equals its endpoint displacement. No such displacement can exceed the coordinate-domain limits. Nozzle restrictions further limit the affected legs. The first leg’s effective lower bound is the maximum of its nozzle-specific lower bound and the general active-leg lower bound, since the original model enforces both.

### Exact finite-domain linearization of cubic terms

Binary selectors represent the admissible positive integer lengths of each leg component. Their sum equals that component’s direction-activation indicator. Thus:

- An inactive component selects nothing and has length zero.
- An active component selects exactly one admissible length.

Both length and cubed length are weighted sums over the same selectors, using weights \(t\) and \(t^3\), respectively. This is an **exact finite-domain reformulation**, not a piecewise approximation.

It replaces variable powers with linear expressions supported by HiGHS. The trade-off is additional binary variables; runtime improvement remains an empirical question.

### Linear support-cost expressions

The original support cost multiplies the existence indicator by a membership-dependent charge. The reformulation distributes this product and represents each binary product as a Boolean conjunction.

This is exact because existence and non-preferred-membership indicators are binary, and preferred-level membership is Boolean. The original domain restriction on non-preferred membership is retained, including its restriction against simultaneous membership in multiple preferred levels at a charged node.

### Removal of vacuous inter-pipe logic

All nodes belong to the same pipe. Therefore, the original condition selecting pairs of different pipes is false for every pair, and the associated separation tests are constants. Removing this logic cannot eliminate a constraint on the route. No self-intersection prohibition is added.

### Valid displacement inequalities

For each axis, the reformulation adds a lower bound on total component length equal to the absolute nozzle displacement.

This follows from the triangle inequality: consecutive signed displacements telescope to the fixed endpoint displacement, while each component length is the absolute value of its displacement. These redundant linear inequalities can strengthen the optimization relaxation.

## Preservation and solution mapping

The final model retains all original independent decision variables and preserves obstacle exceptions, support requirements for unused trailing nodes, and the exact flexibility conditions.

The accompanying mapping script returns only original independent variables. It copies retained solution values, restores fixed endpoint coordinates when omitted from output, and can restore several coordinates implied by the prescribed nozzle directions. In particular, the first leg fixes the second node’s unchanged coordinates; the final potential leg is either destination-directed or zero, fixing the ninth node’s corresponding unchanged coordinates. Missing non-reconstructible values produce an error rather than a guessed assignment.

No solver-performance measurements or successful compilation results were supplied, so the changes should be understood as a HiGHS-oriented exact reformulation rather than a demonstrated speedup.
