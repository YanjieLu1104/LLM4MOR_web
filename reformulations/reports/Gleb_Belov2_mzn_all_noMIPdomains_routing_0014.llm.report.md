# Rectilinear Pipe Routing: Model and Reformulation

## 1. Background and physical interpretation

The instance represents routing a pipe between two fixed equipment connections in a three-dimensional industrial layout. The route must avoid equipment and existing pipework while providing suitable support locations.

Coordinates are integer-valued on a grid with a **200 mm unit length**. The pipe has diameter two grid units and is represented by up to nine axis-aligned segments connecting ten nodes. Its endpoints are fixed at \((245,43,122)\) and \((212,52,100)\).

The fixed boxes describe equipment modules, existing pipe segments, module support zones, a rack, and preferred rack support levels. Clearance constraints account for pipe radius and box-specific safety distances. Support-zone membership tests the node center horizontally and the pipe’s bottom vertically.

The model includes a parameter suggesting that the pipe should pass through a rack, but its corresponding constraint is commented out. Consequently, mandatory rack traversal is **not** part of the enforced problem.

## 2. Original formulation

### Variables

The original independent decision variables comprise:

- **30 node coordinates**, including six fixed endpoint coordinates;
- **60 segment-envelope coordinates** in `nXLeg1` and `nXLeg2`;
- **30 nonnegative coordinate-wise segment lengths**;
- **10 direction variables**, with zero indicating an absent segment and six values representing signed coordinate directions;
- **20 binary-valued integer flags** identifying existing and final segments;
- One integer objective variable.

The segment arrays contain ten slots, but only nine represent candidate segments. The remaining slot is fixed to zero.

Additional defined arrays represent obstacle separation, support-zone membership, preferred-support status, support costs, and flexibility expressions.

### Constraints

The main constraint groups enforce:

1. **Rectilinear geometry.** Each existing segment moves along exactly one coordinate axis. Consecutive existing segments must use different axes, excluding straight continuation and immediate reversal.
2. **Route sequencing.** Existing segments form a prefix, the first three exist, and exactly one is designated as the final segment. Absent trailing segments have zero length.
3. **Nozzle conditions.** The first segment has a prescribed direction and length bounds. The final segment has its own prescribed direction and length bounds and reaches the fixed destination. The general minimum segment length also applies to nozzle segments.
4. **Obstacle clearance.** Radius-expanded segment envelopes must be separated from obstacle boxes along at least one axis, subject to the original equipment-connection exceptions.
5. **Support requirements.** Nodes indexed by nonfirst candidate segments must lie in a support zone. This requirement applies even when the corresponding segment is absent.
6. **Optional physical constraints.** The source contains inter-pipe separation and flexibility constraints, although neither imposes an additional restriction in this instance.

### Objective

The model minimizes scaled pipe-length, bend, and support costs. After applying the original coefficient transformation, each unit of segment length costs **131**, and each existing nonfirst segment incurs a bend charge of **1,301**. Support costs are **51** outside preferred rack levels and **1** within a preferred level.

These coefficients, including the original integer division and added unit charges, were preserved exactly.

## 3. Reformulation and its justification

### Linear signed-displacement formulation

Direction-dependent geometric implications were replaced by positive and negative displacement variables and binary direction selectors.

For each segment and coordinate, the formulation enforces:

- coordinate displacement = positive length − negative length;
- total coordinate-wise length = positive length + negative length;
- exactly one signed direction is selected when the segment exists;
- selected lengths satisfy the original minimum and maximum bounds.

This is equivalent to the original geometry. Originally, the segment envelope contains both endpoint coordinates, so its width minus twice the radius is at least the absolute endpoint displacement. The selected-direction constraint supplies the reverse inequality. Together, they force equality and make the envelope the exact radius-expanded bounding box of the endpoints. Unselected coordinates have zero length and therefore equal endpoint coordinates.

The reformulation writes these relationships directly as linear equations. It retains the original independent variables and their meanings.

### Bound strengthening

Each signed displacement receives an upper bound derived from both:

- the original maximum segment length; and
- the greatest possible displacement allowed by its endpoint coordinate domains.

For example, positive movement cannot exceed the next node’s upper bound minus the current node’s lower bound. These bounds cannot exclude a feasible original route and strengthen the mixed-integer formulation.

### Direction-cover cuts

The reformulation adds valid inequalities requiring at least one segment in each direction forced by:

- the prescribed first and final nozzle directions; or
- strictly ordered endpoint coordinate bounds.

The justification is telescoping: summing segment displacements yields the endpoint displacement. A strictly positive net displacement requires at least one positive segment in that coordinate, and similarly for negative displacement.

Here, the endpoints require negative X, positive Y, and negative Z movement. The nozzle directions additionally require negative Y and positive Z movement. Thus five distinct signed directions are necessary. Since one existing segment can realize only one direction, **at least five segments must exist**.

The cuts use coordinate bounds rather than `fix()` calls, avoiding the reported compile-time evaluation failure without weakening their validity.

### Linearized support costs

The original support-cost expression multiplies an existence flag by a variable support charge. The reformulation distributes this expression into constant-weighted Boolean conjunctions:

- segment exists and node is outside preferred levels;
- segment exists and node belongs to a particular preferred level.

For binary indicators, conjunction is exactly their product. The original preferred-level membership and exclusivity conditions remain enforced, so all support costs are unchanged.

### Instance-specific preprocessing

Two inactive components were removed:

- **Inter-pipe separation:** every node belongs to the same pipe. The original separation constraints are generated only for pairs belonging to different pipes, so there are no applicable constraints.
- **Flexibility expressions:** the sole flexibility coefficient is zero. The original conditional definition therefore makes every associated cubic-length sum zero and every flexibility constraint true.

These reductions follow directly from the supplied fixed data; they do not introduce new routing assumptions.

### Solution mapping

The mapping returns only the original independent variables. All nonfixed original variables remain in the reformulated model and are copied from the solver output. If omitted by the solver, the six fixed endpoint coordinates are restored from their original singleton domains. The objective is taken from its emitted variable or the supplied objective field.

The intended computational benefit is a more explicit linear formulation, tighter displacement bounds, and stronger route-length structure. No solve-time improvement was established by benchmarking in this exchange.
