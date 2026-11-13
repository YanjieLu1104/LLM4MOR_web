# Pipe-Routing Model and Reformulation

## 1. Application and physical interpretation

The instance represents routing a pipe through a three-dimensional industrial installation. Fixed boxes describe equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels.

The pipe connects two fixed nozzle locations, \((65,114,80)\) and \((64,41,5)\), using an orthogonal polyline: every nonzero segment runs parallel to one coordinate axis. Coordinates are discretized in units of 200 mm. The model includes pipe thickness, obstacle clearances, minimum and maximum segment lengths, prescribed nozzle directions, and support requirements.

There are 10 available route nodes and nine possible segments. The route may use fewer segments, but existing segments must form a prefix of the sequence. Consecutive existing segments must use different axes.

The model does **not** enforce every feature suggested by its input names or comments. In particular, the rack-traversal constraint is commented out, self-intersection is not prohibited, and flexibility constraints are inactive because the supplied flexibility coefficient is zero. The reformulation preserves these distinctions.

## 2. Original mathematical structure

### Variables

The original model declares the following independent integer variables:

| Variable group | Number | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional nodes; six coordinates are fixed endpoints |
| Lower and upper segment-box coordinates | 60 | Bounding boxes incorporating the discretized pipe radius |
| Component lengths | 30 | Segment lengths along each axis |
| Direction codes | 10 | Zero for an absent segment; six signed axis directions otherwise |
| Existence and last-segment flags | 20 | Binary indicators defining the active route prefix |
| Objective | 1 | Total scaled routing cost |

The segment arrays include a tenth, non-segment entry that is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The main constraint families are:

- **Segment geometry:** bounding boxes contain both endpoints and include the pipe radius. Direction-dependent inequalities connect component lengths to coordinate differences and force unused components to zero.
- **Route sequence:** the first three segments exist, exactly one segment is last, and no segment exists after the last one.
- **Nozzle connections:** the first and last segments have prescribed directions and length limits. The last segment reaches the fixed destination.
- **Orthogonality:** consecutive existing segments cannot use the same axis.
- **Obstacle avoidance:** a segment must be separated from each applicable obstacle along at least one axis. Specific exceptions permit connection to the source and destination modules.
- **Support membership:** each indexed internal node must lie in a support zone, including nodes associated with an inactive route suffix.
- **Inter-pipe clearance and flexibility:** these have no active effect in this instance, respectively because there is only one pipe and its flexibility coefficient is zero.

### Objective

The model minimizes scaled pipe-length, bend, and support costs. The original integer scaling and added unit offsets are preserved:

- **741** per unit of segment length;
- **7,401** per existing segment after the first;
- **51** for an active internal node outside preferred support levels, or **1** within a preferred level for this instance.

The cost expression charges each existing segment after the first, including the final nozzle segment.

## 3. Reformulation and its justification

### Linear signed-length geometry

Each direction code is linked to six binary direction indicators. Their sum equals the original segment-existence flag, so exactly one direction is selected for an existing segment and none for an absent segment.

For each axis, nonnegative positive and negative length variables satisfy
\[
x_{i+1,k}-x_{i,k}=p_{i,k}-m_{i,k},
\qquad
L_{i,k}=p_{i,k}+m_{i,k}.
\]
Direction indicators activate the appropriate signed component and enforce the original length bounds.

This is equivalent to the original geometry. Originally, box containment and the box-width equation imply
\[
L_{i,k}\ge |x_{i+1,k}-x_{i,k}|.
\]
The selected-direction constraint supplies the reverse inequality with the required sign. For an unselected axis, the component length is zero, forcing equal endpoint coordinates. Consequently, the original boxes are already exact endpoint bounding boxes, allowing their coordinates to be expressed by linear equalities.

This formulation exposes the geometry directly to the mixed-integer solver rather than through several interacting implications.

### Bound tightening and obstacle preprocessing

Signed lengths receive upper bounds derived from endpoint coordinate domains, intersected with the original segment-length limits. A positive displacement, for example, cannot exceed the next endpoint’s upper bound minus the current endpoint’s lower bound.

Exact segment geometry also gives tighter box bounds. The lower box corner is the smaller endpoint coordinate minus the radius; the upper corner is the larger endpoint coordinate plus the radius.

These bounds support two safe obstacle reductions:

1. **Remove a segment–obstacle test when separation is guaranteed.** If an entire possible segment box lies on one side of the obstacle, the original separation disjunction is always true.
2. **Remove an impossible separation alternative.** If even the most favorable box position cannot satisfy a particular separation inequality, that alternative cannot contribute to feasibility.

All remaining separation alternatives and both nozzle-module exceptions are retained. The reformulation also avoids the original intermediate per-axis obstacle-disjointness array, expressing the required disjunctions directly.

### Linear support-cost expression

The original support cost multiplies an existence flag by a membership-dependent cost. The reformulation instead uses the default cost times existence, plus a cost adjustment for each Boolean conjunction of existence and preferred-level membership.

This identity follows from the original constraint
\[
f_{\mathrm{not\ preferred}}
=1-\sum_z b_{\mathrm{preferred},z}.
\]
Its binary domain ensures that at most one preferred-level membership is counted at each relevant node. Thus, the rewritten expression preserves the cost without requiring a product of two general integer expressions. The membership and support constraints remain unchanged.

### Valid endpoint cuts

Additional inequalities strengthen the formulation using fixed endpoint displacement:

- Total length on an axis is at least the absolute endpoint displacement, by summing signed segment displacements.
- If a positive displacement \(d\) is smaller than the minimum nonzero segment length \(L_{\min}\), one segment cannot realize it. Both signs must occur, requiring at least two segments and total axis length at least \(2L_{\min}-d\).
- The first and last segments both follow the prescribed vertical nozzle axis. If endpoint displacement on that axis exceeds the sum of their maximum lengths, at least one additional segment must use that axis.

These are consequences of existing direction, length, and endpoint constraints; they introduce no new routing assumptions.

### Inactive expressions and solution interface

The flexibility expressions are replaced by zero expressions because the original conditional definitions evaluate to zero for the supplied coefficient. Inter-pipe separation remains vacuous for the single pipe.

All original independent variables are retained. The mapping script returns only those variables, preserves their array encodings, and can restore omitted fixed endpoint coordinates from the unchanged embedded data. It does not require reformulation auxiliaries.

## 4. Expected computational effect

The changes target a stronger and more explicit mixed-integer formulation: linear geometry, tighter bounds, fewer obstacle alternatives, linearized support costs, and endpoint-based cuts. They preserve the original objective and feasible routes. No solve-time measurements were supplied, so any performance improvement remains to be established experimentally.
