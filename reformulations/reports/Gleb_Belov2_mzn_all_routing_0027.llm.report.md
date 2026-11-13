## Overview and practical interpretation

The model describes **three-dimensional industrial pipe routing** among fixed equipment and existing pipework. A single pipe connects two fixed nozzles, using straight, axis-aligned segments joined by right-angle bends. Coordinates are integer-valued, with one unit representing **200 mm**.

The instance contains 196 fixed boxes, classified as equipment modules, existing pipe segments, module support zones, a rack region, or preferred rack support levels. The route must maintain the specified obstacle clearances, satisfy nozzle connection requirements, and place intermediate nodes in permitted support zones.

The pipe diameter is one coordinate unit. Importantly, the original model computes radius using integer division, so its modeled radius is `1 div 2 = 0`. The reformulation preserves this convention rather than changing the physical interpretation.

## Original formulation

### Decision variables

The route has 10 ordered nodes and at most nine nonzero legs. Its independent variables are:

| Variable group | Number of scalar entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates per node; the two endpoints are fixed |
| Lower and upper leg-envelope coordinates | 60 | Axis-aligned bounding box of each leg |
| Component lengths | 30 | Nonnegative leg length along each coordinate |
| Leg directions | 10 | Zero for an absent leg; six signed coordinate directions otherwise |
| Existence and last-leg flags | 20 | Identify the active prefix and its final leg |
| Objective | 1 | Total scaled routing cost |

The leg arrays include a tenth, unused slot, whose entries are constrained to zero. Additional defined arrays represent obstacle separation, support membership, support costs, and flexibility expressions.

### Constraints

The main constraint groups are:

- **Axis-aligned geometry.** Each existing leg moves in exactly one signed coordinate direction. Its envelope contains both endpoints, and its component lengths equal the envelope widths minus twice the pipe radius.
- **Route sequence.** Existing legs form a consecutive prefix. Exactly one is marked as the final leg, and the first three legs must exist. Absent legs have zero length, so subsequent nodes coincide with the terminal nozzle.
- **Bends and nozzles.** Consecutive existing legs use different coordinate axes. The first leg travels in positive \(Z\), and the final leg travels in negative \(X\). Both nozzle legs have lengths between 2 and 15 units.
- **Obstacle avoidance.** A leg must be separated from each relevant obstacle along at least one coordinate, allowing equality at the clearance boundary. Specific exemptions apply to the starting module and the terminal module.
- **Support membership.** Intermediate nodes must lie in at least one eligible support box. This requirement applies even to intermediate node slots belonging to the collapsed, inactive suffix.
- **Additional capabilities.** The source includes inter-pipe separation and flexibility constraints. Inter-pipe separation has no applicable pairs in this one-pipe instance, while flexibility is inactive because its coefficient is zero. The rack-traversal requirement is commented out and therefore is not enforced.

### Objective

The model minimizes pipe length, bends, and support costs. It uses the original coefficient transformation
\[
c \longmapsto \left\lfloor c/100\right\rfloor+1,
\]
which is not merely uniform scaling and is preserved exactly.

For this instance, the objective charges:

- **51** per unit of pipe length;
- **501** per existing leg after the first, representing a bend;
- **51** per active intermediate node outside preferred rack levels, or **1** inside a preferred level.

## Reformulation and validity

### 1. Nozzle-based bound tightening

The second node is restricted to
\[
X_2=335,\qquad Y_2=43,\qquad 10\le Z_2\le23.
\]
This follows directly from the fixed starting point \((335,43,8)\), the required positive-\(Z\) first-leg direction, and its length interval \([2,15]\).

The ninth node is restricted to
\[
315\le X_9\le330,\qquad Y_9=54,\qquad Z_9=93.
\]
If leg 9 exists, it is the final negative-\(X\) nozzle leg of length at most 15, ending at \((315,54,93)\). If it does not exist, its zero length makes node 9 coincide with node 10. These bounds therefore exclude no originally feasible route.

### 2. Disaggregated direction and length formulation

For each leg and coordinate, the reformulation introduces positive- and negative-direction binary indicators and corresponding nonnegative lengths. Linear constraints enforce:

- exactly one signed direction for an existing leg;
- zero movement for an absent leg;
- the original minimum and maximum leg lengths;
- coordinate displacement equal to positive length minus negative length.

This replaces direction-dependent geometric implications with a **disaggregated mixed-integer linear formulation**.

The leg envelopes are expressed through linear identities:
\[
2L_{ik}=x_{ik}+x_{i+1,k}-\ell_{ik}-2r,\qquad
2U_{ik}=x_{ik}+x_{i+1,k}+\ell_{ik}+2r.
\]
These identities are valid because the original containment constraints imply
\(\ell_{ik}\ge |x_{i+1,k}-x_{ik}|\), while the direction constraints force the reverse inequality on the active coordinate and zero movement on other coordinates. Thus the original envelopes already equal the endpoint minima and maxima, expanded by the radius.

Consecutive-leg orthogonality becomes a simple linear inequality on the direction indicators.

### 3. Bound-based obstacle preprocessing and separation witnesses

Obstacle avoidance is reformulated using **one-way separation witnesses**: selecting a witness requires the leg to lie on a particular side of the obstacle. At least one witness is required whenever the original obstacle constraint applies.

This is equivalent to the original disjunction because a feasible separation supplies a witness, and any selected witness guarantees a valid separation. The witnesses need not record every separation that happens to hold.

Coordinate bounds provide individual big-M constants rather than a single global constant. They also justify two preprocessing steps:

- An obstacle–leg check is omitted when the entire possible leg envelope is already separated from that obstacle on some axis.
- A particular separation witness is fixed to zero when endpoint bounds make that separation impossible.

The original module exemptions are retained, including the distinction between terminal-module checks and ordinary obstacle checks for absent legs.

### 4. Exact support-cost linearization

The original support cost multiplies a binary existence flag by a support-category expression. The reformulation distributes this product and represents each binary product as a Boolean conjunction—for example, “the leg exists and the node is outside preferred levels.”

This is exact for binary factors and avoids a general integer product. Support membership remains an equivalence with the geometric conditions, so a node cannot claim a cheaper support category without actually belonging to it.

### 5. Preservation and implementation repairs

All original independent variables, their entity correspondences, and the objective are retained. The accompanying mapping script copies these variables, restores omitted fixed coordinates from the self-contained instance, and obtains the objective from either its emitted variable or the solver objective field.

The array-dimension repair restored the original box-size data by removing an accidentally duplicated entry; it did not modify the instance geometry. Necessary sequence, terminal-node, support, and clearance constraints remain present.

## Expected computational effect

The changes target a stronger and more explicit linear formulation for HiGHS: tighter coordinate bounds, bounded directional lengths, direct envelope equations, and smaller obstacle-separation constants. They are intended to reduce unnecessary logical machinery and improve the relaxation. **No measured runtime improvement or optimality result was established in the conversation.**
