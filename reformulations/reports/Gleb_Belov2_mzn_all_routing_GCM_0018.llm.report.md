# Reformulation Report: Three-Dimensional Pipe Routing

## Background

The model represents the routing of a pipe through an industrial installation containing equipment modules, existing pipe segments, and designated support regions. Coordinates are integer-valued, with one coordinate unit representing **200 mm**.

The pipe connects fixed endpoints at \((245,62,122)\) and \((245,102,100)\). Its route consists of axis-aligned straight legs joined by orthogonal bends. The model accounts for pipe radius, obstacle clearances, nozzle connection directions, support availability, and a cubic-length flexibility condition.

Although the input includes a flag suggesting that the pipe should pass through a rack, the corresponding constraint is commented out. Rack traversal is therefore **not required** by either the original or reformulated model. Likewise, the original model does not prohibit intersections between nonadjacent legs of the same pipe.

## Original Model Structure

### Decision variables

The instance contains one pipe and ten ordered nodes:

- **30 integer coordinate variables**, including six fixed endpoint coordinates and 24 intermediate coordinates.
- Nine candidate connecting legs, with a tenth padded array entry fixed to zero.
- Two three-dimensional bounding-box corners for each leg: **60 integer entries** in total.
- **30 nonnegative integer length entries**, one per leg-array entry and coordinate direction.
- Ten direction variables, ten binary existence indicators, and ten binary last-leg indicators.
- An integer objective variable.

Additional defined arrays describe obstacle separation, support-zone membership, support costs, and sums of cubed lengths. These are derived quantities rather than independent routing choices.

### Constraints

The main constraint groups are:

1. **Leg geometry and directions.**  
   Each existing leg moves along exactly one coordinate axis. Its bounding box includes the pipe radius, and its length matches the displacement between consecutive nodes.

2. **Route sequencing.**  
   Existing legs form a prefix of the candidate sequence. At least the first three legs exist, exactly one leg is designated as last, and subsequent legs have zero length.

3. **Nozzle connections and bends.**  
   The first leg has a prescribed direction and length range. The dynamically selected final leg has a prescribed incoming direction and length range. Consecutive existing legs must use different axes.

4. **Obstacle avoidance.**  
   A leg must lie entirely on one side of an obstacle along at least one axis, allowing boundary contact at the specified clearance. Specific exemptions allow connection to the endpoint modules.

5. **Support requirements.**  
   Intermediate node positions must belong to a support region, using the node center horizontally and the pipe bottom vertically. These requirements also apply to intermediate nodes associated with inactive trailing legs.

6. **Flexibility requirements.**  
   For each coordinate direction, a coefficient derived from endpoint separation, unit conversion, and the supplied flexibility factor multiplies each orthogonal leg length. This product must not exceed the sum of cubed leg lengths in the orthogonal directions.

The source also contains inter-pipe separation constraints, but they generate no restrictions for this single-pipe instance.

### Objective

The model minimizes the original scaled sum of:

- Total pipe length;
- Bend-related charges for existing legs other than the first;
- Support charges at the corresponding nodes.

The coefficients use integer division by 100 followed by addition of one. The reformulation preserves this arithmetic exactly, rather than replacing it with unscaled physical costs.

## Reformulation and Validity

### Exact signed-length formulation

Each coordinate displacement is represented as a positive length minus a negative length. Binary indicators select at most one signed axis for an existing leg. The original direction variable is linked to these indicators by a linear equation.

This replaces the original direction-dependent implications without changing feasible geometry. In the original formulation, the bounding-box inequalities imply that each coordinate length is at least the absolute endpoint displacement. The selected-direction implication provides the reverse inequality. For an unselected axis, the length is forced to zero, which also forces equal endpoint coordinates on that axis.

Consequently, the original constraints already determine the exact leg bounds:
\[
\text{lower corner}
=\text{start coordinate}-\text{negative length}-\text{radius},
\]
\[
\text{upper corner}
=\text{start coordinate}+\text{positive length}+\text{radius}.
\]

The reformulation states these equalities directly, providing a more explicit linear representation for HiGHS.

### Coordinate- and nozzle-based length bounds

Each coordinate length receives an upper bound derived from the maximum possible endpoint displacement and the original pipe-length limit.

For the first leg, the prescribed nozzle axis and nozzle upper bound further restrict the domain. For the last candidate leg, the original restriction to either zero direction or the final nozzle direction provides analogous bounds.

These bounds are valid because the geometry constraints establish that coordinate length equals absolute displacement. They exclude no length that can occur within the original coordinate domains.

### Exact finite-domain linearization of cubes

Variable cubing is replaced by a multiple-choice formulation. For each relevant leg-axis pair, binary selectors represent the admissible positive integer lengths. Their sum equals the axis-activity indicator, and weighted sums define both length and its cube:
\[
L=\sum_v v z_v,\qquad C=\sum_v v^3z_v.
\]

An inactive axis selects no value and has \(L=C=0\). An active axis selects exactly one admissible value.

This is **exact, not a piecewise approximation**. The original direction constraints require every active leg length to be at least the general lower bound, and the tightened upper bounds retain every feasible value. Thus the selectors represent precisely the original finite length domain while eliminating nonlinear decision-variable powers.

### Obstacle-disjunction preprocessing

Coordinate bounds are used to simplify obstacle avoidance:

- A leg–obstacle constraint is omitted when separation is guaranteed along some axis for every possible endpoint position.
- An individual separating face is removed when the coordinate bounds prove that it cannot hold.

These reductions follow from bounds on the radius-expanded leg corners. A guaranteed separating face makes the entire disjunction true; an impossible face can never satisfy it.

The endpoint-module exemptions are retained. Obstacle constraints are **not** generally disabled for inactive legs, because the original model still imposes most of them on those degenerate segments.

### Support-membership preprocessing and cost linearization

A node’s membership in a support zone is fixed to false when its coordinate domain cannot intersect that zone, including the original vertical radius adjustment. Such membership is impossible under the original inequalities.

Products involving binary existence and support-membership indicators are replaced by Boolean conjunction indicators. This is exact because multiplication of two zero–one values equals the indicator that both are one. The original restriction on preferred-level memberships is retained.

### Redundant endpoint-balance constraints

For each coordinate, the reformulation adds:
\[
\sum_{\text{legs}}(L^+-L^-)
=\text{final endpoint}-\text{initial endpoint},
\]
together with a lower bound on total coordinate length equal to the absolute endpoint displacement.

The equality follows by summing consecutive-node displacement equations: intermediate coordinates cancel. The lower bound follows from the triangle inequality. Both are therefore valid consequences of the original geometry and can strengthen the linear relaxation.

## Interface Preservation and Expected Effect

All original independent variables remain available under their original names. The mapping script copies the unchanged nonfixed variables and restores the six singleton-domain endpoint coordinates from the self-contained instance data. Auxiliary reformulation variables are not returned as original decisions.

The principal intended benefit is a **fully linear mixed-integer representation** with explicit geometry, tighter length domains, and simplified geometric disjunctions. The exact cube representation introduces additional binary variables, so its computational benefit involves a size-versus-formulation trade-off. No measured runtime improvement is established by the conversation.
