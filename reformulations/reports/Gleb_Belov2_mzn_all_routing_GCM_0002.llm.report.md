# Reformulation Report: Three-Dimensional Pipe Routing

## 1. Application and instance background

The model represents the routing of an industrial pipe between two fixed nozzle connections in a three-dimensional plant layout. Coordinates are integer multiples of a 200 mm length unit. The route must avoid equipment and existing pipework, respect prescribed nozzle directions, and place intermediate nodes in regions where the pipe can be supported.

The supplied instance contains:

- One pipe with diameter four coordinate units.
- Ten ordered route nodes, with fixed endpoints at \((309,54,101)\) and \((153,51,38)\).
- Nine possible connecting legs, of which an initial contiguous sequence is active.
- 87 fixed boxes representing equipment, existing pipe legs, support zones, a rack, and preferred rack support levels.

Each active leg is parallel to a coordinate axis. Consecutive active legs must use different axes. The pipe also satisfies algebraic flexibility conditions involving cubed leg lengths, apparently intended to provide sufficient flexibility to accommodate nozzle displacement or thermal expansion.

Some declared data describe features that are not enforced by the original model. In particular, the requirement to pass through a rack is commented out. The reformulation does not activate it or introduce self-intersection restrictions absent from the original.

## 2. Original mathematical structure

### Variables

Before compilation and elimination of fixed values, the original independent declarations comprise:

| Variable group | Number of scalar entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three integer coordinates for each node; six endpoint coordinates are fixed |
| Leg bounding-box coordinates | 60 | Lower and upper bounds in three dimensions |
| Coordinate-wise leg lengths | 30 | Nonnegative integer lengths |
| Leg directions | 10 | Zero for inactive legs; six signed axis directions otherwise |
| Existence and last-leg flags | 20 | Binary route-sequence indicators |
| Objective variable | 1 | Total scaled cost |

The leg arrays include a tenth, non-leg entry, which is fixed to zero. Additional defined arrays express obstacle separation, support membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint groups are:

1. **Geometry and direction.** Leg boxes contain both endpoints, enlarged by the pipe radius. Their widths define the coordinate-wise lengths. Direction implications force movement along one signed coordinate axis and zero movement along the others.

2. **Route sequence and nozzle connections.** The first three legs exist. Exactly one leg is marked last, and existence flags form an active prefix. Starting and final legs obey specified nozzle directions and length limits.

3. **Bends.** Adjacent legs cannot use the same coordinate axis, ruling out both straight continuation and immediate reversal between active legs.

4. **Obstacle avoidance.** Each relevant leg box must be separated from each obstacle along at least one axis, including prescribed clearance. Explicit exceptions permit connection through the relevant nozzle equipment boxes.

5. **Support.** Nodes 2 through 9 must lie in at least one support region. Membership uses the node center horizontally and the pipe bottom vertically. Preferred rack levels determine support charges.

6. **Flexibility.** For each axis, a coefficient times each orthogonal leg length is bounded by the sum of cubed lengths in the two orthogonal axes. Coefficients are calculated from the fixed endpoint separations and supplied physical factor.

The original model applies some support and obstacle constraints even to inactive route entries. These requirements are retained. Inter-pipe separation constraints have no applicable pairs in this one-pipe instance.

### Objective

The model minimizes the original scaled cost:
\[
201\sum_{i,k} L_{ik}
+2001\sum_{i\text{ not first}} e_i
+\sum_{i\text{ not first}} C_i.
\]

Here \(e_i\) is the existence flag. An active charged node incurs support cost 51 outside preferred levels and 1 within a preferred level. These coefficients retain the original integer division by 100 and subsequent addition of one; they are not replaced by unscaled monetary costs.

## 3. Reformulation and justification

### Linear signed-length geometry

The reformulation introduces six binary direction selectors and six nonnegative signed-direction lengths for each leg. At most one selector is active, and their sum equals the original existence flag. Endpoint displacement is expressed as positive length minus negative length.

This is exact because the original constraints already force the leg geometry. For an axis, endpoint containment and the box-width equation imply
\[
L_{ik}\geq |x_{i+1,k}-x_{i,k}|.
\]
For the selected direction, the original direction implication gives the reverse inequality with the appropriate sign. Thus equality holds. For every unselected axis, the original model forces \(L_{ik}=0\), which also forces equal endpoint coordinates.

Consequently, the original leg boxes are precisely the endpoint minimum and maximum, expanded by the radius. Explicit linear equations can replace their indirect construction without removing feasible original solutions. The original geometry variables remain available for checking and mapping.

### Bound preprocessing

Direction-specific upper bounds are derived from the original coordinate domains. For example, positive movement along an axis cannot exceed
\[
\operatorname{ub}(x_{i+1,k})-\operatorname{lb}(x_{i,k}).
\]
These bounds are combined with the applicable original leg and nozzle limits.

Active starting and final-possible-leg lower bounds use the maximum of the general minimum length and the relevant nozzle minimum. This is valid because both restrictions apply simultaneously in the original model. Inactive legs remain allowed to have zero length.

This preprocessing tightens the mixed-integer formulation without assuming any additional geometric restriction.

### Exact discrete formulation of cubic lengths

Variable powers are replaced by binary selection among feasible positive integer total lengths. For each leg:

- The number of selected lengths equals its existence flag.
- The selected value equals its total length.
- The selected value cubed equals the sum of its axis-specific cubic variables.

Axis-specific cubic variables are forced to zero on inactive axes. Since the direction formulation permits only one active axis, the entire selected cube belongs to that axis. Therefore each axis-specific value equals \(L_{ik}^{3}\), exactly.

This is an **exact finite-domain extended formulation**, not a piecewise-linear approximation. It preserves every original flexibility inequality while avoiding variable powers in the HiGHS formulation. The trade-off is additional binary variables; no runtime improvement is claimed without benchmarking.

### Valid strengthening inequalities

Several redundant inequalities strengthen the formulation:

- **Conditional cubic bounds:** an axis cube is bounded above by the cube of its direction-specific maximum, multiplied by its selector.
- **Length–cube bounds:** for an active length \(a\leq L\leq U\),
  \[
  a^2L\leq L^3\leq U^2L.
  \]
  The same inequalities hold at \(L=0\), so they also cover inactive legs.
- **Length–direction compatibility:** a selected length exceeding a direction’s maximum excludes that direction.
- **Endpoint-distance bounds:** total length along each axis is at least the absolute endpoint displacement. This follows from the triangle inequality applied to successive node displacements.

These inequalities follow from existing domains, axis alignment, and endpoint connectivity; they do not impose new routing assumptions.

### Linear support costs

The product of an existence flag and a support-category indicator is replaced by the integer value of their Boolean conjunction. This is exact because both factors are binary. Preferred-level membership and the original restriction on its sum are retained, so the support-cost semantics are unchanged.

### Solution mapping and preserved interface

All original independent decision variables are retained. The mapping script exports only those variables, excluding reformulation auxiliaries.

If default DZN output omits a coordinate scalar, the script reconstructs it from the retained leg box and direction: the starting coordinate is the lower face plus the radius, except on a negative-moving axis, where it is the upper face minus the radius. This follows directly from the exact geometry equations above. Fixed endpoint coordinates come from the unchanged embedded instance.

The reformulation preserves the original data, minimization direction, cost coefficients, and feasible-route requirements, including constraints on inactive entries.
