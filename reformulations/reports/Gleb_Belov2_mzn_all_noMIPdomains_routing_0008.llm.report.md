# Orthogonal Pipe Routing with Obstacles and Support Zones

## Background

The instance models the routing of a single pipe between two fixed equipment connections in a three-dimensional industrial layout. Coordinates are integer-valued, with one coordinate unit representing **200 mm**.

The pipe follows axis-aligned segments and must avoid equipment modules and existing pipe segments, allowing for its radius and specified safety clearances. Intermediate nodes must lie in designated support zones, which include areas around modules, a rack, and preferred rack levels. The model balances pipe length, the number of bends, and support costs.

The supplied instance allows ten route nodes and nine candidate segments. Unused trailing segments collapse to zero length. The first segment leaves its connection in the negative \(Y\) direction, and the final active segment approaches the destination in the negative \(Z\) direction.

## Original Model

### Variables

The original independent decision variables comprise:

- **30 integer node coordinates**, six fixed by the endpoint coordinate domains.
- **60 integer segment-box coordinates**, representing lower and upper corners in three dimensions.
- **30 nonnegative integer component lengths**.
- **10 integer direction codes**, with zero indicating an absent segment and six codes representing signed coordinate directions.
- **10 binary existence flags** and **10 binary final-segment flags**.
- An integer objective variable.

The segment arrays include a tenth, non-segment entry that is fixed to zero. Derived expressions represent obstacle separation, support-zone membership, preferred-level membership, and support costs.

### Constraints

The main constraint groups enforce:

1. **Segment geometry.** Each segment box encloses both endpoints, expanded by the pipe radius. Component lengths equal box widths minus twice that radius. Direction-dependent constraints restrict movement to one signed coordinate axis.

2. **Route sequencing.** Active segments form a prefix, the first three segments exist, and exactly one segment is marked as final. Consecutive active segments use different axes, excluding both straight continuation and immediate reversal.

3. **Connection requirements.** The first and final segments obey prescribed directions and length limits. The final active segment ends at the fixed destination.

4. **Obstacle avoidance.** Every applicable segment box must be separated from each obstacle along at least one axis. Specific exceptions permit connection to the starting and destination modules. Importantly, most obstacle tests remain applicable even to zero-length trailing segments.

5. **Support requirements.** Intermediate node positions must belong to at least one support zone. Membership tests use the node centre horizontally and the pipe bottom vertically. These requirements also apply to intermediate nodes associated with inactive trailing segments.

The source also defines inter-pipe separation and optional flexibility constraints. Neither restricts this instance: all nodes belong to one pipe, and its flexibility coefficient is zero. A rack-traversal requirement appears only in commented code and is therefore not part of the problem.

### Objective

The model minimizes the original scaled cost:
\[
861\,L + 8601\,B + C_{\mathrm{support}},
\]
where \(L\) is total segment length in coordinate units and \(B\) is the number of active segments after the first.

An active intermediate node costs **51** outside preferred rack levels and **1** inside a preferred level. These coefficients preserve the original integer division by 100 followed by addition of one; they are not an unscaled monetary objective.

## Reformulation and Validity

### Signed-direction disaggregation

The reformulation introduces binary positive/negative direction indicators and corresponding nonnegative travel lengths for each segment and coordinate. Their sum equals the segment’s existence flag, so an active segment selects exactly one signed direction.

Coordinate displacement and component length are expressed linearly:
\[
x_{i+1,k}-x_{i,k}=p_{i,k}-m_{i,k},
\qquad
\ell_{i,k}=p_{i,k}+m_{i,k}.
\]

This is equivalent to the original geometry. Originally, endpoint enclosure implies
\[
\ell_{i,k}\ge |x_{i+1,k}-x_{i,k}|.
\]
For the selected direction, the direction constraint supplies the matching upper bound, forcing equality. For every unselected axis, the original constraints force the component length—and consequently displacement—to zero.

The segment-box corners can therefore be written exactly as
\[
a_{i,k}=x_{i,k}-m_{i,k}-r,
\qquad
b_{i,k}=x_{i,k}+p_{i,k}+r.
\]
These equations replace the enclosing-box inequalities without changing feasible geometry.

### Bound strengthening

Each signed travel length is bounded by its direction indicator multiplied by the smaller of:

- the original maximum segment length; and
- the largest possible displacement in that direction, calculated from the endpoint coordinate domains.

These bounds are valid because no feasible displacement can exceed either limit. This disaggregated formulation is intended to give HiGHS a stronger linear relaxation than the original reified direction–length constraints.

### Direct obstacle disjunctions

Obstacle avoidance is written directly as a disjunction of lower-side and upper-side separation inequalities across the three axes. This removes the named intermediate separation array while preserving its logical meaning and both module-connection exceptions.

No obstacle constraint is removed merely because a segment is inactive.

### Linear support-cost formulation

Products of an existence flag with support-category indicators are replaced by integer-valued Boolean conjunctions:
\[
e\,b=\operatorname{bool2int}(e=1\land b).
\]

This identity is exact for binary indicators. Preferred-level membership and the original restriction on their sum remain unchanged, preserving support costs without a general variable-product expression.

### Instance-specific preprocessing

- **Inter-pipe separation is omitted:** the original constraint is generated only for segments with different pipe identifiers. Since every node has pipe identifier 1, its index set is empty.
- **Flexibility constraints are omitted:** the original conditional returns `true` when the flexibility coefficient is nonpositive. The supplied coefficient is zero, and the associated derived sums remain zero.
- **Rack traversal is not imposed:** its source constraint was commented out, so activating it would change the problem.

## Solution Interface and Expected Effect

All original independent variables are retained under their original names. The mapping script copies their values and array indices, excludes reformulation-specific auxiliaries, and restores fixed endpoint coordinates from the original embedded data if solver output omits them.

The changes target a more explicit linear MIP formulation, tighter travel bounds, and fewer unnecessary intermediate expressions. The objective and optimization direction are unchanged. These changes are intended to improve solution time, but no measured runtime improvement is established here.
