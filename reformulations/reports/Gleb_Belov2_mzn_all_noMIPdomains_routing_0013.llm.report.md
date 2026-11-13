# Rectilinear Pipe Routing with Obstacles and Support Zones

## Application and instance

The model represents a pipe-routing problem in an industrial facility. A pipe must connect two fixed nozzles using axis-aligned straight segments while avoiding equipment and existing pipework. Intermediate nodes must lie in permitted support regions, and bends incur construction and support costs.

Coordinates are integer multiples of a **200 mm length unit**. The supplied instance contains one pipe with ten ordered nodes, giving nine candidate segments. The endpoints are fixed at `(210, 77, 52)` and `(236, 62, 181)`. The pipe diameter is two coordinate units.

Fixed boxes represent equipment modules, existing pipe segments, module support zones, a rack, and preferred rack-support levels. Their types determine whether they act as obstacles or support regions. Although the input includes a “through rack” flag, the corresponding constraint is commented out in the original model; the reformulation does not activate it.

## Original mathematical model

### Variables

The original independent decision variables comprise:

- **30 node-coordinate variables**, including six fixed endpoint coordinates.
- **60 segment-bound variables**, describing lower and upper corners of radius-expanded segment boxes.
- **30 nonnegative segment-length components**.
- **10 direction variables**, with zero denoting an unused segment and values 1–6 denoting signed coordinate directions.
- **20 binary-valued existence and last-segment flags**.
- **One objective variable**.

Segment arrays have ten positions, although only the first nine represent candidate segments; the final position is fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The principal constraint groups are:

1. **Rectilinear geometry.** An active segment moves along exactly one coordinate axis. Its expanded bounding box contains both endpoint cross-sections, and its length is linked to that box and its direction.

2. **Route sequencing.** Active segments form a contiguous prefix. Exactly one is designated the last active segment, and the first three must exist.

3. **Nozzle restrictions.** The first and last active segments follow prescribed directions and satisfy nozzle-length limits. The last active segment ends at the fixed destination. Inactive trailing segments have zero length.

4. **Bend restrictions.** Consecutive active segments use different axes, excluding both straight continuation and immediate reversal.

5. **Obstacle avoidance.** Each applicable segment box must be separated from each obstacle along at least one axis, including the specified safety clearance. The first segment is exempt from its source module; the last active segment and inactive segments are exempt from the destination module.

6. **Support requirements.** Intermediate node positions must belong to at least one support zone. Membership uses the node centre horizontally and the pipe bottom vertically. These requirements also apply to intermediate array positions after route termination.

7. **Conditional extensions.** The source includes inter-pipe separation and flexibility constraints. Inter-pipe separation has no applicable pairs in this single-pipe instance. Flexibility constraints are inactive because the supplied flexibility coefficient is zero.

### Objective

The model **minimizes construction cost**, combining segment length, active segments after the first, and support charges at their starting nodes.

The original coefficient transformation—integer division by 100 followed by addition of one—is preserved. Consequently, the objective charges:

- 131 per coordinate unit of pipe length;
- 1,301 per active segment after the first;
- 51 for an ordinary active support location, or 1 at a preferred rack level.

These are the model’s scaled objective values, not an independently reconstructed monetary estimate.

## Reformulation and validity

### One-hot direction and signed-length formulation

The direction implications were replaced by positive- and negative-direction indicators for each axis, together with corresponding nonnegative length components. Their indicator sum equals segment existence, and their weighted sum reproduces the original direction code.

This is equivalent to the original geometry: the original box-containment constraints imply that each length component is at least the absolute endpoint displacement. The selected-direction constraint supplies the matching upper bound, while unselected axes have zero length. Therefore, the original segment boxes are already forced to be the exact radius-expanded endpoint bounding boxes.

The reformulation expresses these consequences directly through linear equalities. Coordinate-domain bounds also bound each signed length: positive displacement cannot exceed the next node’s upper bound minus the current node’s lower bound, and conversely for negative displacement. These bounds are combined with the original segment-length limit.

### Safety-expanded obstacle dominance preprocessing

An obstacle check is removed when another applicable obstacle contains its safety-expanded box.

This is valid because separation from the containing box along any axis implies separation from the contained box along that same axis. Containment is tested using each obstacle’s lower coordinates minus its safety distance and upper coordinates plus that distance.

The preprocessing also compares exemption rules. An unconditionally enforced obstacle may dominate a conditionally enforced one, but a destination-module check cannot replace an unconditional check. Source-module exemptions are excluded from the candidate dominating checks. Equal boxes are ordered deterministically to prevent mutual removal.

### Exact support-cost linearization

The original support cost multiplies segment existence by a membership-dependent charge. The reformulation writes it as a default charge for an existing segment plus adjustments for Boolean conjunctions of existence and preferred-level membership.

The equality follows directly from the original definition
\(fNodeNotInPref = 1-\sum_z bInSZ_z\).
That definition and its binary domain are retained, including their restriction against multiple simultaneous preferred-level memberships at a charged node. The transformation therefore preserves support costs without relying on minimization to enforce correctness.

### Minimum-active-segment inequality

A valid lower bound on the number of active segments was added. The original sequence constraints require distinct first and last active segments. Any axis used by neither nozzle segment, but having nonzero endpoint displacement, requires at least one additional segment: axis-aligned segments on other axes cannot provide that displacement.

Both nozzle segments use the X axis in this instance, while the endpoints differ in Y and Z. Thus at least four active segments are necessary. The inequality makes this existing geometric consequence explicit to strengthen the relaxation.

### Solution interface

All original independent decision variables remain in the reformulated model. The accompanying mapping script copies them, restores omitted fixed endpoint coordinates from the unchanged instance data, and uses the reported objective when `obj` is not emitted separately. It reports missing nonfixed values rather than inventing them.

These changes target a stronger and more explicit mixed-integer formulation for HiGHS. No measured runtime improvement is established by the conversation.
