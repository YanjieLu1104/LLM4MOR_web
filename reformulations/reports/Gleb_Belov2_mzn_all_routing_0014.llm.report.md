# Pipe Routing with Obstacle Avoidance and Support Costs

## 1. Application and instance

The model represents routing a pipe through a three-dimensional industrial layout. The route connects two fixed equipment nozzles and consists of axis-aligned straight segments. Fixed boxes describe equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels.

This instance contains one pipe, ten ordered route nodes, and up to nine segments. The endpoints are fixed at `(245, 43, 122)` and `(212, 52, 100)`; the eight intermediate nodes are integer decision variables. One coordinate unit represents 200 mm. The pipe diameter is two coordinate units, so its modeled radius is one unit.

The route must avoid obstacles with prescribed clearance, turn orthogonally between consecutive active segments, satisfy nozzle direction and length restrictions, and place intermediate nodes in support zones. Its cost combines pipe length, bends, and support provision.

Two distinctions matter when interpreting the instance:

- Although a rack-traversal flag is supplied, the constraint requiring traversal is commented out in the original model. Rack traversal is therefore **not mandatory**.
- The flexibility coefficient is zero, so the original flexibility constraints impose no restriction in this instance.

## 2. Original formulation

### Variables

The independently declared variables comprise:

| Variables | Number of scalar entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each node; six entries are fixed |
| Lower and upper segment-box corners | 60 | Radius-expanded bounding boxes |
| Coordinatewise segment lengths | 30 | Nonnegative length in each axis |
| Segment directions | 10 | Zero for inactive segments; six signed axial directions otherwise |
| Segment-existence flags | 10 | Binary active/inactive indicators |
| Last-segment flags | 10 | Binary indicators identifying the final active segment |
| Objective | 1 | Total scaled cost |

The segment arrays include a tenth, non-segment row that is fixed to zero. Additional arrays defined by expressions represent obstacle separation, support-zone membership, preferred-level membership, support cost, and flexibility quantities. These source-level counts are not counts of the flattened HiGHS model.

### Constraints

The principal constraint groups are:

- **Segment geometry:** bounding boxes contain both endpoint cross-sections, and their extents determine coordinatewise lengths.
- **Direction and length:** an active segment moves along exactly one axis, with the sign specified by its direction. Active lengths satisfy the general minimum of four units.
- **Route sequence:** active segments form a prefix, exactly one is marked last, and the first three segments must exist.
- **Turns:** consecutive active segments cannot use the same axis, excluding both straight continuation and immediate reversal.
- **Nozzle connections:** the first segment has the prescribed departure direction; the last active segment has the prescribed arrival direction and reaches the fixed terminal node. Nozzle-specific length bounds apply in addition to the general minimum.
- **Obstacle avoidance:** each constrained segment box must be separated from an obstacle on at least one axis. The original start- and end-module exceptions are retained.
- **Support:** intermediate nodes must lie in a support zone, using the pipe bottom for the vertical membership test.
- **Inter-pipe separation and flexibility:** these are part of the general formulation but are inactive for this particular instance.

Notably, the original formulation still imposes support membership on intermediate nodes associated with inactive trailing segments. It also retains most obstacle checks for inactive segments. The reformulation preserves these details.

### Objective

The model minimizes the original scaled cost, not an unscaled monetary estimate. Coefficients are calculated using integer division by 100, followed by addition of one:

- Pipe length: **131 per coordinate unit**.
- Each active segment after the first: **1,301**.
- Support at the corresponding node: **51 outside preferred rack levels**, or **1 within a preferred level** in this instance.

## 3. Reformulation and justification

### Linear signed-length formulation

The direction-dependent geometric implications were replaced by a one-hot representation of the six signed directions, together with nonnegative positive- and negative-direction length components.

This replacement is exact. In the original model, for one coordinate, the segment-box containment constraints and length equation imply
\[
\ell \geq |x_{i+1}-x_i|.
\]
For the selected positive direction, the original direction constraint additionally gives
\[
\ell \leq x_{i+1}-x_i;
\]
the negative-direction case is analogous. Unselected axes have zero length. Consequently, the original constraints already force exact axial displacement and exact radius-expanded bounding boxes.

The reformulation expresses those consequences directly:
\[
x_{i+1}-x_i=p_i-m_i,\qquad
\ell_i=p_i+m_i,
\]
\[
L_i=x_i-m_i-r,\qquad U_i=x_i+p_i+r.
\]
Direction indicators permit at most one signed component to be positive and enforce its minimum length. Thus, no geometric freedom present in a feasible original solution is removed.

Component upper bounds are tightened using endpoint coordinate domains. For example, positive displacement cannot exceed the next node’s upper bound minus the current node’s lower bound. These bounds are intersected with the original segment-length limit.

This gives HiGHS a direct linear representation instead of relying on repeated direction-dependent implications.

### Bound-based obstacle preprocessing

Obstacle disjunctions are simplified using bounds derived from the original coordinate domains and pipe radius:

- If a separating inequality holds for every possible position of a segment box, the entire obstacle–segment constraint is redundant and is omitted.
- If a separating inequality cannot hold anywhere within those bounds, that candidate separating face is removed.

These tests use conservative bounds on the exact segment-box corners. Therefore, an omitted constraint is already guaranteed, and an omitted face could never certify a feasible separation. All nozzle-module exceptions remain unchanged.

### Linear support-cost expression

The original support cost multiplies an existence flag by a sum of membership-dependent charges. The reformulation distributes this multiplication and represents each term through a Boolean conjunction: a charge applies precisely when the segment exists **and** the corresponding membership condition holds.

For binary indicators, multiplication equals conjunction. This transformation therefore preserves support costs exactly while making the binary structure explicit.

### Valid route-length inequalities

Additional inequalities strengthen the formulation without excluding original feasible routes:

- **Required-direction inequalities:** a positive net endpoint displacement requires at least one positive-direction segment on that axis; a negative displacement requires the opposite. Prescribed nozzle directions also require their corresponding direction to occur.
- **Nozzle-detour bounds:** the first and last segments are distinct because the original sequence constraints require at least three active segments. Their prescribed directions and minimum lengths therefore impose mandatory signed travel. Combining this with net endpoint displacement gives lower bounds on positive travel, negative travel, and total travel along each axis.
- **Prefix and suffix bounds:** accumulated coordinatewise length before or after any node must be at least the absolute coordinate displacement to the relevant endpoint. These follow directly from the triangle inequality applied to the original segment displacements.

For this instance, departure in negative \(Y\) conflicts with the positive net \(Y\) displacement, while arrival in positive \(Z\) conflicts with the negative net \(Z\) displacement. The nozzle-detour inequalities expose the resulting unavoidable extra travel.

### Solution interface and expected effect

All original independent variables are retained. The mapping script returns only those variables, preserves array indexing, and reconstructs omitted fixed endpoint coordinates from their original singleton domains. Missing nonfixed solution values produce explicit errors rather than fabricated values.

The changes target a stronger, more explicit mixed-integer linear formulation and fewer unnecessary obstacle-disjunction terms. The objective values, minimization direction, fixed data, and original routing requirements are preserved. No solve-time measurements were supplied, so performance improvement remains an intended benefit rather than an experimentally established result.
