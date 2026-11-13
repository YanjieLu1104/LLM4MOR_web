# Rectilinear Pipe Routing: Model and Reformulation

## 1. Real-world interpretation

The model describes routing a pipe through a three-dimensional industrial installation containing equipment modules, existing pipe segments, and support structures. Coordinates are discretized in units of **200 mm**.

The supplied instance contains one pipe with fixed connections at \((309,54,101)\) and \((153,51,38)\). Its route uses ten ordered nodes and at most nine axis-aligned legs. Obstacles must be avoided with allowances for pipe radius and specified safety distances. Intermediate nodes must lie in support zones, with cheaper support available at preferred rack levels.

The model also provides machinery for multiple pipes and pipe-flexibility requirements, but neither is active in this instance. Although a “through rack” input flag is set, the corresponding constraint is commented out in the original model; the reformulation does not activate it.

## 2. Original mathematical structure

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two **\(10\times3\)** integer arrays defining lower and upper leg-box coordinates.
- A **\(10\times3\)** nonnegative integer array of coordinate-wise leg lengths.
- Ten integer direction variables, with values representing inactivity or one of six signed coordinate directions.
- Ten binary-valued leg-existence variables and ten binary-valued last-leg indicators.
- An integer objective variable.

The leg arrays include a final dummy entry, which is fixed to zero. Additional defined expressions represent obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The constraints enforce:

1. **A contiguous route:** at least three legs exist, exactly one is designated as the last leg, and all later legs are inactive.
2. **Rectilinear geometry:** an active leg moves along exactly one coordinate axis. Consecutive active legs use different axes, preventing straight continuation or immediate reversal.
3. **Nozzle requirements:** the first and last active legs have prescribed directions and length limits.
4. **Obstacle clearance:** radius-expanded leg boxes must be separated from obstacle boxes along at least one axis, subject to the original nozzle-module exceptions.
5. **Support availability:** intermediate nodes must belong to at least one support zone, using the pipe’s bottom elevation for the vertical membership test.

Two details are important: support requirements also apply to inactive trailing intermediate nodes, and obstacle constraints are not universally disabled for inactive legs. Both behaviors are preserved.

### Objective

The model **minimizes** pipe-length cost, bend cost, and node-support cost. It uses coefficients obtained by integer division by 100 followed by adding one—not merely a uniform rescaling.

For this instance, the resulting costs are:

- **201** per unit of pipe length;
- **2,001** per active leg after the first;
- **51** per active supported intermediate node outside preferred rack levels, or **1** at a preferred level.

These objective values and the optimization direction are unchanged.

## 3. Reformulation and justification

### Disaggregated directional formulation

Each leg and coordinate receives positive- and negative-direction activation variables and corresponding nonnegative travel lengths. Their sum determines the coordinate-wise length, while their difference determines the endpoint displacement. Exactly one direction is selected for an active leg.

This replaces the original direction-dependent implications with linear equalities and activation bounds, giving HiGHS a more explicit mixed-integer linear formulation.

**Why it is valid:** the original bounding-box constraints imply that each coordinate-wise length is at least the absolute endpoint displacement. When a direction is selected, the original directional constraint supplies the reverse inequality. Thus length equals signed displacement on the selected axis. On every other axis, length is zero, forcing equal endpoint coordinates. The new formulation expresses precisely these consequences.

### Exact linear leg-box geometry

Lower and upper leg-box coordinates are expressed directly using the start coordinate, negative or positive travel, and pipe radius.

**Why it is valid:** the original boxes contain both endpoints expanded by the radius, and their width equals leg length plus twice the radius. Since the original constraints already force leg length to equal absolute displacement, there is no room for additional box slack. The direct equations therefore preserve the original box values.

### Bound-based preprocessing

Directional travel upper bounds are derived from the declared endpoint-coordinate bounds and the original maximum leg length. Intermediate-node bounds are also tightened to the coordinate-wise envelope of all support zones, with the required vertical radius adjustment.

**Why it is valid:** positive travel cannot exceed the destination upper bound minus the source lower bound; negative travel has the analogous limit. Likewise, a node required to belong to some support zone must lie inside the envelope containing all such zones. These bounds exclude no originally feasible route.

### Linearized support costs

Products involving leg existence and support cost are replaced by weighted Boolean conjunctions between existence and the relevant support-membership condition.

**Why it is valid:** leg existence is binary, as are preferred-level membership and the “not in preferred level” indicator. Multiplication by a binary existence variable is therefore exactly equivalent to charging the corresponding coefficient when both conditions hold. The original preferred-level indicator relation is retained.

### Directional-coverage cuts

For each nonzero endpoint displacement, the formulation requires at least one leg traveling in that displacement’s direction.

**Why it is valid:** summing leg displacements telescopes to the fixed endpoint difference. A negative total displacement cannot be achieved without negative travel, and similarly for a positive total. Here, all three endpoint differences are negative. These are redundant strengthening inequalities, not restrictions to monotone routes.

### Removal of inactive model components

- **Inter-pipe separation:** omitted because every node belongs to the same pipe. The original inter-pipe constraint index set is therefore empty.
- **Flexibility constraints:** omitted because the supplied flexibility coefficient is zero. The original conditional expressions consequently produce zero flexibility sums and impose no restrictions.
- **Unused derived separation arrays:** replaced by direct obstacle-separation disjunctions. These arrays were defined expressions, not independent decisions.
- **Search annotation:** omitted because the original finite-domain branching annotation is not needed for the HiGHS MIP formulation.

All original independent decision variables remain available for checking. The accompanying mapping returns only those variables and restores any omitted fixed endpoint coordinates from their unchanged original constants. No measured runtime improvement is claimed; the changes target a stronger and more explicit linear formulation.
