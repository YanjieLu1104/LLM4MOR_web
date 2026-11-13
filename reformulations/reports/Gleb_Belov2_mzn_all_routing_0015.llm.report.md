## Problem background

This instance models **three-dimensional pipe routing in an industrial installation**. A pipe must connect two fixed nozzles while avoiding equipment and existing pipework. Routes consist of axis-aligned straight segments, with consecutive active segments meeting at right angles.

The geometry is discretized in units of **200 mm**. The supplied instance contains one pipe, 10 ordered route nodes, and 147 fixed boxes representing equipment modules, existing pipe segments, support zones, a rack, and preferred rack levels. The endpoint coordinates are `(212, 36, 100)` and `(245, 43, 58)`.

The model seeks a low-cost route that respects nozzle orientations, segment-length limits, obstacle clearance, and support requirements. Although a rack-traversal flag is supplied, the constraint enforcing traversal is commented out in the original model; the reformulation does not activate it.

## Original formulation

### Variables and route representation

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two **10 × 3 integer arrays**, `nXLeg1` and `nXLeg2`, describing radius-expanded segment bounding boxes.
- A **10 × 3 nonnegative integer array**, `nLLeg`, describing segment length along each coordinate axis.
- **10 direction variables**, with values zero for an inactive segment and 1–6 for the signed coordinate directions.
- **10 binary existence flags** and **10 binary last-segment flags**.
- An integer objective variable.

There are nine potential segments between consecutive nodes. The tenth array position is a dummy segment whose geometry, length, direction, and flags are fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The main constraint groups are:

1. **Segment geometry and direction.** Each active segment varies along exactly one coordinate axis. Its bounding box includes the pipe radius, and its length agrees with the endpoint displacement. The general minimum active-segment length is four units.

2. **Route sequencing.** Active segments form a prefix of the potential segments. At least the first three segments exist, and exactly one active segment is marked as last. Inactive segments have zero length, so subsequent nodes coincide with the terminal nozzle.

3. **Nozzle conditions.** The first segment points in the negative vertical direction. The last active segment points in the positive Y direction. Both nozzle segments have a maximum length of 15 units; the general four-unit minimum also applies.

4. **Orthogonal bends.** Consecutive active segments cannot use the same coordinate axis, ruling out both straight continuation and immediate reversal.

5. **Obstacle avoidance.** Each relevant radius-expanded segment box must be separated from an obstacle along at least one axis, including the specified clearance. The original exceptions for entering and leaving the nozzle modules are retained.

6. **Support requirements.** Nodes 2–9 must lie in at least one support zone, including nodes corresponding to inactive trailing segments. Membership is tested at the node center in X and Y and at the pipe bottom in Z.

The source also contains inter-pipe separation and flexibility constraints, but neither restricts this particular instance.

### Objective

The model minimizes the original scaled cost:
\[
131L + 1301B + C_{\mathrm{support}},
\]
where \(L\) is total segment length and \(B\) counts active segments other than the first. Each such segment contributes a support cost of **1** when its starting node belongs to a preferred rack level and **51** otherwise.

These coefficients include the original integer division by 100 and subsequent addition of one. They were preserved exactly, rather than replaced by unscaled monetary costs.

## Reformulation and justification

### 1. Signed-length linear formulation

The direction implications were replaced by six binary direction selectors per segment and nonnegative positive/negative displacement variables for each axis. Their sum equals the segment-existence flag, so an active segment selects exactly one signed direction.

For each axis, the formulation enforces
\[
x_{i+1}-x_i=p_i-m_i,\qquad
\ell_i=p_i+m_i,
\]
with each displacement bounded by its direction selector.

This is equivalent to the original geometry. Originally, the bounding-box constraints imply that the length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality, while all other axis lengths are zero. Consequently, the original bounds are exact:
\[
\text{lower}=x_i-m_i-r,\qquad
\text{upper}=x_i+p_i+r.
\]
The reformulation expresses these equalities directly, avoiding several reified comparisons and giving HiGHS a more explicit linear formulation.

### 2. Nozzle-based bound tightening

Two node domains were tightened using existing constraints:

- **Node 2:** The first segment points downward, so X and Y remain 212 and 36. Its length is between 4 and 15, placing Z between 85 and 96.
- **Node 9:** The ninth potential segment is either inactive or points in positive Y toward the fixed endpoint. Hence X is 245, Z is 58, and Y lies between 28 and 43.

No feasible route is excluded: these bounds follow from the original direction, length, and endpoint constraints.

Directional displacement upper bounds were also computed from endpoint coordinate bounds and intersected with the original segment-length limit.

### 3. Bound-based obstacle preprocessing

An obstacle–segment check is omitted only when coordinate bounds prove separation for every possible placement of that segment. For example, separation is guaranteed if an obstacle’s upper face plus clearance lies below the smallest possible lower face of the segment.

The segment-face bounds follow from the exact geometry established above. Thus, every removed check is already satisfied throughout the remaining variable domains. All other obstacle disjunctions and nozzle-module exceptions remain enforced.

### 4. Support-zone preprocessing and selection

A node–zone pair is ruled out when the node’s coordinate domain cannot intersect the zone in at least one dimension. The vertical test includes the pipe-radius offset required by the original bottom-of-pipe convention.

For each support-required node, binary selectors choose one feasible supporting zone. A selected zone implies membership. This is equivalent to the original existential requirement: a node belonging to one or more zones can select any one of them, and a selected zone certifies support.

Actual membership predicates are retained for cost calculations. Therefore, choosing a support witness does not change whether a node receives a preferred-level discount.

### 5. Linearized support costs

The product of segment existence and support cost was replaced by weighted Boolean conjunctions:

- active segment **and** no preferred-level membership;
- active segment **and** membership in each preferred level.

This is an exact expansion of the original expression because the relevant indicators are binary. The original constraint on preferred-level membership remains present through `fNodeNotInPref`.

### 6. Axis-count strengthening cut

The reformulation adds lower bounds on the number of active segments using each axis. A nonzero endpoint displacement requires at least one segment on that axis.

For the vertical axis, at least **two** segments are necessary. The endpoints differ vertically by 42 units, whereas the mandatory first vertical segment can cover at most 15 units. Since the first segment cannot supply the entire vertical displacement, another vertical segment is required. This cut follows directly from the endpoint coordinates, first-segment direction, and nozzle-length limit.

### 7. Removal of inactive instance-specific machinery

Inter-pipe separation constraints impose no restriction because all nodes belong to the same pipe: the original constraint generator has no pair of distinct pipes to compare.

The flexibility coefficient is zero. The original conditional expressions therefore make all flexibility sums zero and all flexibility inequalities true. Replacing these sums by zero and omitting the inactive inequalities preserves the supplied instance.

## Data and solution preservation

The repair process corrected accidental extra entries in the transcribed box-type and box-size arrays, restoring the original data and its 147-box correspondence.

All original independent decision variables remain represented. The mapping script returns their original names and array encodings, excludes new auxiliary variables, and reconstructs omitted fixed coordinates from the embedded instance and the justified nozzle deductions. The objective value and minimization direction are unchanged.

The changes are intended to improve mixed-integer optimization through explicit linear structure, tighter bounds, and fewer unnecessary checks. No measured runtime improvement is established by the reported compilation and mapping repairs.
