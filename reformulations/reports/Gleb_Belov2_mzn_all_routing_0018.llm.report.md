# Pipe Routing with Obstacles and Support Zones

## Background

The model represents three-dimensional pipe routing in an industrial installation. A pipe connects two fixed nozzles while avoiding equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined at bends. Pipe diameter and safety clearances determine the space occupied by each leg.

Support zones represent locations where bends can be supported, including areas around modules, a rack, and preferred rack levels. Preferred levels can reduce support costs. Coordinates use discrete units of 200 mm.

This instance contains one pipe, ten ordered nodes, and up to nine legs. Unused legs form a trailing suffix of zero-length segments. Although the data contain a rack-traversal flag, the corresponding constraint is commented out in the original model; the reformulation therefore does not require rack traversal.

## Original Model

### Variables

The original independent decision variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-envelope coordinates**, describing lower and upper corners of radius-expanded leg boxes.
- **30 nonnegative coordinate-wise leg lengths**.
- **10 direction variables**, with zero denoting an inactive leg and six values denoting signed coordinate directions.
- **20 binary-valued integer flags**, identifying existing and final legs.
- **One integer objective variable**.

The leg arrays include a tenth, nonactual leg slot fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The principal constraints enforce:

1. **Axis-aligned geometry.** Each active leg moves along exactly one coordinate axis. Its length and radius-expanded envelope are linked to its endpoint coordinates.
2. **Route sequencing.** Existing legs form a prefix, exactly one leg is marked final, and the first three legs exist. All subsequent inactive legs have coincident endpoints.
3. **Nozzle connections.** The first and final active legs have prescribed directions and nozzle-specific length limits.
4. **Orthogonal consecutive legs.** Adjacent active legs cannot use the same axis, ruling out both straight continuation and immediate reversal.
5. **Obstacle clearance.** Each applicable leg box must be separated from each obstacle along at least one axis. Specific exemptions permit entry into or exit from the endpoint modules.
6. **Support availability.** Nodes 2–9 must belong to at least one support zone, even when their associated legs are inactive. Membership uses the pipe bottom vertically and its center horizontally.
7. **Inter-pipe separation and flexibility.** The inter-pipe constraints have no applicable pairs in this single-pipe instance. Flexibility constraints are inactive because the supplied flexibility coefficient is zero.

### Objective

The model minimizes the sum of pipe-length, bend, and support costs. It uses the original coefficient transformation, `cost div 100 + 1`, rather than the unscaled monetary values.

For this instance, the length coefficient is 131, the bend coefficient is 1,301, and the default support coefficient is 51. Bend and support charges apply to existing legs other than the first.

## Reformulation and Its Justification

### Disaggregated linear motion

The main change replaces reified direction–length relations with direction-selection binaries and nonnegative positive and negative movements for each axis.

For each leg, the direction binaries sum to its existence flag. Each movement is bounded above by its selected direction binary times a valid movement limit, and below by the original minimum leg length times that binary. Endpoint displacement equals positive movement minus negative movement; length equals their sum.

This is equivalent to the original geometry. Originally, the envelope constraints imply that each coordinate-wise length is at least the absolute endpoint displacement. The selected-direction constraint bounds that length above by the corresponding signed displacement. Together, these force equality. On an unselected axis, the original length is zero, which forces the endpoint coordinates to coincide.

The new formulation expresses these consequences directly as linear constraints, providing a more explicit mixed-integer formulation for HiGHS.

### Exact linear leg envelopes

The reformulation defines each lower envelope coordinate as the starting coordinate minus negative movement and radius, and each upper coordinate as the starting coordinate plus positive movement and radius.

These equalities introduce no geometric restriction. In the original model, the lower envelope cannot exceed either endpoint minus radius, the upper envelope cannot fall below either endpoint plus radius, and their difference equals length plus twice the radius. Once length equals absolute displacement, both envelope inequalities must be tight.

The original envelope variables remain available under their original names.

### Bound-based preprocessing

Two forms of preprocessing use declared coordinate bounds:

- **Directional movement limits:** Positive movement cannot exceed the next node’s upper bound minus the current node’s lower bound; negative movement satisfies the reverse bound. These limits are combined with the original maximum leg length.
- **Geometric filtering:** An obstacle check is omitted only if an entire possible radius-expanded leg envelope is already separated from that obstacle along some axis. A support membership is fixed false only if the node’s coordinate domain cannot intersect the support zone on at least one axis, accounting for the vertical radius offset.

These are logical consequences of the original domains and geometry, not heuristic exclusions of routes.

### Boolean support-cost linearization

The original support expression multiplies the existence flag by a membership-dependent cost. The reformulation distributes that product and represents each binary product by a Boolean conjunction.

This preserves the cost exactly: a support charge contributes only when the associated leg exists and the relevant membership condition holds. The original binary domain on the “not in a preferred level” expression is retained, including its restriction on simultaneous preferred-level memberships.

### Instance-specific simplification and solution mapping

The flexibility sums are replaced by zero because every summand in the original definition is zero when the supplied flexibility coefficient is nonpositive. The associated flexibility constraints are also vacuous under that same condition.

All original independent variables are retained. The mapping script returns only those variables, preserves encoded array indices, and reconstructs omitted fixed endpoint coordinates from the original embedded constants. It reports missing nonfixed values rather than inventing them.

The reformulation preserves the original objective, obstacle exemptions, and support requirements for inactive trailing nodes. Its intended benefit is a stronger and more directly linear solver representation; no measured runtime improvement was established in the conversation.
