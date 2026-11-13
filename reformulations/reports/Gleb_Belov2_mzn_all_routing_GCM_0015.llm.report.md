# Pipe Routing with Clearance, Support, and Flexibility Constraints

## Background and physical interpretation

The model describes the routing of a single pipe through a three-dimensional industrial layout. The layout contains equipment modules, existing pipe segments, support zones, a rack, and preferred rack-support levels.

The pipe connects two fixed nozzle locations, \((212,36,100)\) and \((245,43,58)\), using up to nine axis-aligned segments. Coordinates are discretized in units of 200 mm. Eight intermediate nodes determine the route; unused trailing segments have zero length.

A feasible route must respect obstacle clearances, prescribed nozzle directions, segment-length limits, and support requirements. It must also satisfy cubic flexibility inequalities, identified in the source as GCM constraints. These represent a simplified engineering flexibility requirement rather than a full structural analysis.

Although the input includes a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation does not activate it.

## Original model structure

### Decision variables

The original model declares **151 independent integer variables**:

- **30 node-coordinate variables**, including six fixed endpoint coordinates.
- **60 segment-boundary variables**, representing lower and upper corners of radius-expanded segment boxes.
- **30 coordinate-wise segment lengths**.
- **10 segment-direction variables**, using zero for an unused segment and six codes for signed coordinate directions.
- **10 segment-existence flags** and **10 last-segment flags**.
- **One objective variable**.

The segment arrays include a tenth, non-segment entry that is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths. These are derived expressions, not additional independent decisions.

### Constraints

The principal constraint groups are:

1. **Segment geometry and direction.**  
   Each nonzero segment moves along exactly one coordinate axis. Its expanded bounding box contains both endpoint cross-sections, and its length is linked to the box extent.

2. **Route sequencing.**  
   Existing segments form a prefix, with exactly one marked as last. The first three segments must exist. Consecutive existing segments use different axes, preventing both straight continuation and immediate reversal.

3. **Nozzle connections.**  
   The first segment has a prescribed direction and length range. The last existing segment has the prescribed incoming direction, satisfies its nozzle-length limits, and ends at the fixed destination. The general minimum segment length also applies; the nozzle lower bound does not override it.

4. **Obstacle clearance.**  
   Each relevant segment box must be separated from an obstacle along at least one coordinate axis. Specific exceptions allow connection to the source and destination modules. Importantly, obstacle checks are not universally disabled for unused segments.

5. **Support-zone membership.**  
   Every intermediate node covered by the original support constraint must lie in at least one support zone, including nodes belonging to the unused suffix. Membership uses the node center horizontally and the pipe bottom vertically. Preferred rack levels affect support cost.

6. **Flexibility.**  
   For each coordinate axis, the model sums cubed segment lengths along the other two axes. This sum must exceed a coefficient times each relevant segment length. The coefficients depend on endpoint separation, discretization, and the supplied pipe flexibility factor.

The source also contains inter-pipe separation constraints. They generate no restrictions for this instance because there is only one pipe.

### Objective

The model minimizes the sum of:

- Total pipe length multiplied by a scaled unit-length cost.
- A bend charge for each existing segment after the first.
- Support charges at the corresponding intermediate nodes.

The original integer scaling is preserved exactly, including the `div 100 + 1` transformation. Thus, the length and bend coefficients are respectively **131** and **1301**; default and preferred-level support charges are **51** and **1**.

## Reformulation and justification

### 1. Linear signed-displacement formulation

The reformulation introduces nonnegative positive and negative displacements for each segment and coordinate. Direction indicators permit at most one of these displacements to be positive. Their difference equals endpoint displacement, and their sum equals segment length. The expanded segment-box boundaries are then expressed by linear equalities.

This is equivalent to the original geometry. Originally, endpoint containment and the box-length equation imply that segment length is at least the absolute endpoint displacement. The selected-direction constraint supplies the opposite inequality. Therefore, equality is forced. For an inactive coordinate, zero length forces coincident endpoint coordinates and exact radius-expanded boundaries. The new formulation states these consequences directly rather than recovering them through several inequalities.

### 2. Bound-based length preprocessing

A separate upper bound is derived for each segment-coordinate pair using:

- The original maximum segment length.
- The maximum possible endpoint separation from the declared coordinate bounds.
- The first- and last-possible-segment nozzle restrictions.

Non-segment entries and coordinates prohibited by those nozzle restrictions receive an upper bound of zero.

These bounds are valid because the original geometry forces length to equal absolute endpoint displacement, while the original nozzle constraints already impose the additional restrictions. No feasible original length is removed.

### 3. Exact discrete linearization of cubic terms

Variable powers are replaced by Boolean selectors for admissible positive integer lengths. For each segment-coordinate pair:

- The selector sum equals the indicator that this coordinate is active.
- The selected value determines segment length.
- The same selector determines its cube using a constant coefficient.

Selectors outside the derived upper bound or below the original general minimum length are fixed false. An inactive coordinate selects no positive length and consequently has both length and cube equal to zero.

This is an **exact finite-domain linearization**, not a piecewise approximation: integer lengths have finite domains, and every permitted value is represented with its exact cube. It makes the flexibility requirements linear in the expanded formulation, at the cost of additional Boolean variables.

### 4. Direct obstacle disjunctions

The reformulation places the original axis-separation expressions directly inside the obstacle constraints instead of retaining the intermediate obstacle-disjointness array.

This is substitution of a defined expression: each removed array entry was exactly the corresponding separation test. The disjunctions, clearances, and module exceptions remain unchanged. No obstacle is discarded.

### 5. Boolean linearization of support costs

Products involving segment existence and support-category indicators are replaced by Boolean conjunctions.

For example, because both existence and non-preferred-support flags are binary, their product equals the indicator that both equal one. Distributing the original expression and applying this identity preserves support costs exactly. The original support-membership definitions and the domain restriction on the non-preferred flag are retained.

### 6. Valid suffix-distance inequalities

For each segment position and coordinate, the reformulation adds inequalities requiring the remaining coordinate-wise route length to cover the positive and negative displacement to the destination.

These follow from telescoping endpoint differences and the triangle inequality:

\[
\sum_{j=i}^{\text{last possible}} L_{j,k}
\;\ge\;
\left|x_{\text{destination},k}-x_{i,k}\right|.
\]

The original geometry establishes \(L_{j,k}=|x_{j+1,k}-x_{j,k}|\), and the fixed final node supplies the destination. Hence these inequalities remove no feasible route but may strengthen the linear relaxation.

## Solution interface and expected effect

All original independent variables are retained. The accompanying mapping script copies their solution values, restores the six fixed endpoint coordinates from the unchanged embedded data, and obtains the original objective variable from its emitted value or the unchanged solver objective. It does not require auxiliary selectors or displacement variables.

The reformulation is intended to improve HiGHS performance through explicit linear geometry, exact linear treatment of cubic terms, tighter domains, and redundant distance cuts. It preserves the original feasible routes and objective values. **No measured runtime improvement is available**; the additional length-selection variables create a formulation-size trade-off that requires empirical evaluation.
