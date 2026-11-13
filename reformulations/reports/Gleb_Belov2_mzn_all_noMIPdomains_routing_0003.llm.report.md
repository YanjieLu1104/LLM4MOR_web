# Pipe-Routing Model and Reformulation

## 1. Real-world interpretation

The model represents three-dimensional routing of a pipe through an industrial installation. The pipe connects two fixed nozzles while avoiding equipment and existing pipework. Its route consists of axis-aligned straight segments joined by right-angle bends.

Coordinates use a discretized length unit of **200 mm**. The instance contains one pipe with diameter four coordinate units, ten ordered route nodes, and therefore at most nine straight legs. The first and last nodes are fixed at `(139, 51, 167)` and `(1, 88, 36)`.

Fixed boxes describe equipment modules, existing pipe segments, support zones, a rack, and preferred rack levels. Clearance constraints use a radius-expanded bounding box around each routed leg. Support-zone membership is tested at the node center horizontally and at the bottom of the pipe vertically.

Although the input includes a flag indicating routing through a rack, the corresponding constraint is commented out in the original model. The reformulation does not activate it.

## 2. Original mathematical structure

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-box coordinates**, representing lower and upper corners for ten indexed leg slots.
- **30 nonnegative integer coordinate-wise leg lengths**.
- **10 integer direction codes**, with zero denoting an inactive leg and codes 1–6 denoting signed coordinate directions.
- **20 binary integer flags**, recording whether each leg exists and whether it is the last active leg.
- An integer objective variable.

Only nine leg slots can connect consecutive nodes; the tenth slot is fixed to zero. Additional defined arrays represent geometric separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The principal constraint groups are:

1. **Leg geometry and direction.** Bounding boxes enclose both endpoints with pipe-radius expansion. Direction implications restrict each active leg to one coordinate axis and connect its length to endpoint displacement.

2. **Active-leg sequence.** Active legs form a contiguous prefix. Exactly one is designated the last active leg, and the first three legs must exist.

3. **Nozzle connections.** The first leg has the prescribed departure direction. The last active leg has the prescribed arrival direction, satisfies nozzle-length limits, and ends at the fixed destination.

4. **Orthogonal bends.** Consecutive active legs cannot use the same coordinate axis, excluding both straight continuation and immediate reversal.

5. **Obstacle avoidance.** Each applicable leg–obstacle pair must be separated along at least one axis, with the specified clearance. The original nozzle-module exceptions are retained.

6. **Support requirements.** Nodes indexed 2–9 must belong to at least one support zone. Importantly, this condition is not conditional on their outgoing legs being active.

7. **Inter-pipe clearance and flexibility.** These groups are present in the general formulation but impose no restrictions in this instance.

### Objective

The model minimizes the original scaled sum of pipe length, bends, and support costs. After integer division by 100 and the original “plus one” adjustment:

- Pipe length costs **201 per coordinate unit**.
- Each active leg after the first incurs a **2,001 bend charge**.
- Each charged node incurs support cost **51 outside preferred levels** or **1 within a preferred level**.

These coefficients and the minimization direction were preserved.

## 3. Reformulation and its justification

### Disaggregated linear leg geometry

The direction-dependent geometric implications were replaced by positive and negative movement variables for each leg and axis, together with binary direction selectors. Their sums determine leg length, their differences determine endpoint displacement, and the selectors sum to the leg-existence flag.

This is equivalent to the original geometry. Originally, box enclosure and the length equation imply that a leg’s coordinate-wise length is at least the absolute endpoint displacement. On the selected axis, a direction implication supplies the reverse inequality, forcing equality. On every other axis, length is zero, forcing equal endpoint coordinates. Consequently, each original leg box is exactly the radius-expanded bounding box of its endpoints.

The reformulation expresses that result directly through linear equalities. It retains the original geometry variables and direction codes, while making their relationship more explicit for the MIP solver.

Movement upper bounds also use the original endpoint domains. For example, positive movement cannot exceed the next node’s upper bound minus the current node’s lower bound. These are valid bounds for every feasible endpoint assignment.

### Bound-based obstacle preprocessing

A leg–obstacle constraint is omitted only when the original endpoint domains prove separation along some axis for **every** possible position of that leg.

For example, if the greatest possible endpoint coordinate plus the pipe radius is no larger than the obstacle’s lower face minus clearance, the entire leg box must lie on that side of the obstacle. The original disjunction is therefore always satisfied. Constraints without such a certificate remain in the model, with the original nozzle exceptions.

### Explicit support-cost linearization

The original support cost multiplies a leg-existence flag by a location-dependent charge. The reformulation writes it as a baseline charge for an active leg plus a cost adjustment for each preferred-level membership that coincides with activity.

This follows algebraically from the retained definition
\(f_{\text{not preferred}}=1-\sum_z b_z\).
Because this variable has domain \(0..1\), the original model already permits at most one preferred-level membership at each charged node. Boolean conjunctions express the remaining binary products in a form suitable for MIP linearization. The resulting support charge is identical.

### Prefix and suffix distance cuts

For every node and coordinate, the reformulation adds inequalities requiring the accumulated length before that node to cover its coordinate displacement from the starting nozzle. Analogous inequalities apply between that node and the destination.

These cuts follow from the triangle inequality: a sum of absolute segment displacements cannot be smaller than the absolute net displacement. They do not remove feasible integer routes, but can strengthen the linear relaxation.

### Removal of instance-vacuous components

Two general-purpose constraint groups were omitted:

- **Inter-pipe clearance:** every node belongs to pipe 1, so the original constraint generator has no pairs belonging to different pipes.
- **Flexibility:** the sole `dGCM_Cpp` value is zero. The original conditional expressions therefore make all associated sums zero and all flexibility constraints true.

These removals depend on the supplied fixed data, not on additional assumptions.

### Solution interface

All original independent routing variables and the objective were retained. The mapping script copies their solution values and supplies the six fixed endpoint coordinates from their original singleton domains. Defined auxiliary arrays need not be mapped because the original model recomputes them.

The changes aim to improve MIP relaxation strength and reduce unnecessary logical structure. No measured runtime improvement is established by the conversation.
