# Pipe-Routing Model: Background and Reformulation

## 1. Application and interpretation

The instance represents the routing of a pipe through a three-dimensional industrial layout containing equipment modules, existing pipe segments, and designated support regions. Coordinates use a discretization unit of **200 mm**.

One pipe connects two fixed endpoints, \((176,44,27)\) and \((210,83,45)\). The route has ten node positions and at most nine connecting legs. Each existing leg must follow a coordinate axis, and consecutive existing legs must use different axes. The model also imposes obstacle clearance, nozzle approach directions, leg-length limits, and support-region membership for intermediate nodes.

Unused trailing legs have zero length, so their nodes coincide with the destination. The pipe radius used in clearance calculations is the original integer expression `nDiam div 2`, which equals one coordinate unit here.

Although the data include a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. Neither formulation enforces that requirement. Likewise, the original model does not impose self-intersection avoidance between this pipe’s nonadjacent legs.

## 2. Original mathematical structure

### Variables

The original model explicitly declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-box boundary entries**, describing lower and upper corners.
- **30 nonnegative integer coordinate-wise leg lengths**.
- **10 integer direction codes**, with zero denoting an unused leg and codes 1–6 denoting signed coordinate directions.
- **20 binary-valued integer flags** for leg existence and identification of the last leg.
- An integer objective variable.

The leg arrays include a tenth, non-leg entry that is fixed to zero. Additional defined arrays represent obstacle separation, support-region membership, support costs, and flexibility expressions. These are derived quantities rather than additional independent routing choices.

### Constraints

The main constraint groups are:

1. **Geometry and direction.** Leg boxes enclose both endpoints, including the pipe radius. Their widths determine coordinate-wise lengths. Direction implications permit movement along only one signed axis.
2. **Route sequence.** Existing legs form a contiguous prefix. Exactly one leg is marked last, and the first three legs must exist.
3. **Bends and nozzle connections.** Consecutive legs cannot use the same axis. The first and last legs obey specified nozzle directions and length bounds.
4. **Obstacle avoidance.** A leg must be separated from each applicable obstacle along at least one axis. The starting module has a first-leg exemption; the destination module has exemptions for the last and unused legs.
5. **Supports.** Every intermediate node covered by the original support constraint must belong to a support zone. Membership uses the node center horizontally and the pipe bottom vertically. This requirement also applies to relevant nodes of the unused suffix.
6. **Optional general-model features.** Inter-pipe separation applies only to different pipes. Flexibility constraints are active only for positive flexibility coefficients.

### Objective

The model minimizes scaled construction costs:

- **141 per unit of total leg length**;
- **1,401 per existing leg after the first**, representing bend cost;
- support cost at the associated intermediate nodes.

For this instance, the support charge is **51 outside preferred rack levels** and **1 inside a preferred level**, provided the associated leg exists. These coefficients preserve the original integer division by 100 and subsequent addition of one; the reformulation does not reinterpret or rescale the objective.

## 3. Reformulation and validity

### One-hot directions and signed displacements

The reformulation introduces six binary direction indicators per leg and nonnegative positive/negative displacements for each coordinate. Their sum equals the leg-existence flag, while their weighted sum reproduces the original direction code.

This replaces the original direction implications with linear linking equations. Its validity follows directly from the original geometry:

- The enclosing-box constraints imply that a coordinate-wise leg length is at least the absolute endpoint displacement.
- In the selected direction, the original direction constraint bounds that length above by the corresponding signed displacement.
- In every unselected coordinate, the length is forced to zero.

Consequently, the original constraints already force exact axis-aligned displacement and exact radius-expanded leg boxes. The new equations express those same relationships directly, including zero displacement for unused legs.

### Bound tightening from coordinate domains

Each signed displacement receives a separate upper bound derived from its endpoint domains. For example, positive movement is bounded by

\[
\min\!\left\{U_{\text{leg}},
\max(0,\overline{x}_{i+1}-\underline{x}_i)\right\}.
\]

These bounds are valid because no feasible endpoint assignment can exceed the stated domain difference, and the original model already imposes the leg-length limit. Linking these bounds to direction indicators strengthens the mixed-integer relaxation without excluding feasible routes. The original nozzle-specific restrictions are retained separately.

### Linearized support costs

The original support expression multiplies a leg-existence variable by a variable support charge. The reformulation expresses this as a default charge for an existing leg plus preferred-level adjustments, activated by Boolean conjunctions of existence and membership.

This is an exact algebraic transformation. For an intermediate node, the original definition

\[
f_{\text{not preferred}}=1-\sum_z b_z,
\qquad f_{\text{not preferred}}\in\{0,1\},
\]

ensures that at most one preferred-level membership can hold. That restriction is retained. The rewritten expression therefore preserves the charge both for existing legs and for unused legs, whose charge remains zero.

### Instance-specific removal of inactive expressions

Two general-model components are omitted:

- **Inter-pipe separation:** every node belongs to the same pipe, so the original constraint generator produces no different-pipe pairs. Its associated comparison array is constant.
- **Flexibility:** the sole flexibility coefficient is zero. The original conditional expressions therefore yield zero orthogonal cubic-length sums and impose no flexibility restriction.

These reductions follow from the supplied fixed data and the original conditional definitions—not from additional assumptions about acceptable routes.

### Solution interface and expected benefit

All original independent variables remain in the reformulated model. The mapping script returns only those variables, preserves their array encodings, and can restore omitted fixed endpoint coordinates from the original embedded data.

The intended computational benefit is a more explicit linear formulation with tighter displacement bounds and less reliance on implication-based geometry and variable products. **No solve-time improvement was measured in the reported interaction.**
