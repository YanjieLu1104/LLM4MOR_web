# Pipe-Routing Model: Structure and Reformulation

## 1. Application and physical interpretation

The model represents the routing of a single pipe through an industrial installation containing equipment modules, existing pipe segments, and supporting structures. A route connects two fixed nozzle locations through a sequence of axis-aligned straight legs.

The supplied instance provides **10 route nodes and 9 candidate legs**. The two endpoint coordinates are fixed; the eight intermediate nodes can move within prescribed integer-coordinate bounds. Each coordinate unit represents **200 mm**.

The route must satisfy several engineering requirements:

- Clearance from equipment and existing pipes, accounting for pipe radius and specified safety distances.
- Prescribed directions and length limits at the two nozzle connections.
- Perpendicular consecutive active legs.
- Membership of intermediate nodes in permissible support zones.
- Flexibility inequalities involving sums of cubed leg lengths, apparently intended to represent piping flexibility or thermal-expansion requirements.

Support costs distinguish preferred rack levels from other locations. Although a parameter indicates a preference for routing through a rack, the corresponding mandatory rack-visit constraint is commented out in the original model and is therefore **not enforced**.

## 2. Original optimization model

### Variables

Before presolve, the original model declares **151 independent integer variable entries**:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each node, including six fixed endpoint coordinates |
| Leg-box bounds | 60 | Lower and upper bounding-box coordinates |
| Coordinatewise leg lengths | 30 | Nonnegative extent along each axis |
| Leg directions | 10 | Zero for an inactive leg; six signed axis directions otherwise |
| Leg-existence indicators | 10 | Binary indicators |
| Last-leg indicators | 10 | Binary indicators |
| Objective | 1 | Total scaled cost |

The leg arrays include one padding position that is fixed to zero. Additional defined arrays represent geometric relations, support-zone membership, costs, and cubic sums; these are not additional independent top-level decisions.

### Constraints

The constraints organize active legs into a contiguous prefix, require at least three active legs, and select exactly one final leg. Inactive trailing legs have zero displacement, so their nodes coincide with the destination.

Direction and length constraints enforce axis-aligned movement. Consecutive active legs must use different axes. Separate conditions restrict the first and final nozzle legs.

Obstacle avoidance uses disjunctions: a leg’s expanded bounding box must be separated from an obstacle along at least one coordinate. The original exceptions for the starting and destination modules are important and are retained.

Intermediate nodes must belong to at least one support zone. This requirement also applies to intermediate nodes associated with inactive trailing legs. Zone membership tests the node center horizontally and the pipe bottom vertically.

For each coordinate, flexibility constraints compare a coefficient times each orthogonal leg length against the sum of cubes of all orthogonal leg lengths.

### Objective

The model **minimizes** the sum of:

1. Pipe-length costs.
2. Costs for active legs after the first, representing bends.
3. Support costs at the corresponding nodes.

The original coefficient scaling—integer division by 100 followed by addition of one—is preserved exactly.

## 3. Reformulation and its justification

### Explicit signed-displacement formulation

Positive and negative direction indicators and nonnegative displacement components replace the original reified direction–length relationships.

This is exact because the original bounding-box constraints imply that each coordinatewise leg length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality, while unselected axes have zero length. Consequently, an active coordinate’s length equals its signed displacement, and the bounding-box endpoints are uniquely determined.

The reformulation expresses these consequences directly through linear equations, while retaining the original variables for solution compatibility.

### Bound-based preprocessing

Upper bounds on positive and negative displacement are derived from the declared endpoint-coordinate bounds and the original leg-length limits. No feasible movement can exceed the difference between its destination’s upper bound and its origin’s lower bound, or the corresponding reverse-direction difference.

Nozzle limits further tighten these bounds. Impossible values in the flexibility encoding are fixed out using these bounds and the original minimum active-leg length.

### Exact capped flexibility encoding

Variable cubes are replaced by a finite binary encoding of capped lengths. Let \(a\) be any original flexibility coefficient and choose \(C\) such that

\[
C^2 \ge \max a.
\]

For this instance, the derived cap is **83**. The reformulation uses \(y_i=\min(\ell_i,C)\) and encodes \(y_i^3\) with constant coefficients.

To see why this is exact, consider one orthogonal group of lengths:

- If every length is below \(C\), neither the lengths nor their cubes change.
- Otherwise, let \(M\ge C\) be the largest original length. The original cubic sum is at least \(M^3\), and
  \[
  M^3\ge aM\ge a\ell_i
  \]
  for every length in the group. Thus all original inequalities hold.
- In the capped formulation, the cubic sum is at least \(C^3\), which is at least \(aC\), and hence at least \(ay_i\) for every capped length.

Therefore, both systems accept exactly the same routes. The encoding avoids general variable-power expressions and substantially reduces the represented length range.

### Valid linear strengthening and support-cost reformulation

Signed-displacement balance equations are added for each axis. They follow by summing consecutive node-displacement equations: intermediate coordinates cancel, leaving the fixed endpoint difference. Coordinatewise total-length lower bounds follow from the triangle inequality.

Support-cost products are rewritten using Boolean conjunctions. This is exact because leg existence and preferred-level membership are binary: a charge contributes precisely when both relevant indicators hold.

Finally, the mapping script returns only the original independent variables. Retained values are copied directly; omitted fixed endpoint coordinates are restored from the original embedded data. No measured runtime improvement is claimed—the changes target a more explicit, bounded mixed-integer linear formulation for HiGHS.
