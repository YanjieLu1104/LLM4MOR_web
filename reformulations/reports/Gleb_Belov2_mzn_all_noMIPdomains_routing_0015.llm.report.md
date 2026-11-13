# Three-Dimensional Pipe Routing: Model and Reformulation

## 1. Application background

The model describes routing a single pipe through an industrial installation represented by axis-aligned boxes. It connects two fixed nozzles using straight segments parallel to the coordinate axes, while avoiding equipment and existing pipework.

The instance provides ten ordered route nodes, allowing up to nine segments. The endpoints are fixed at `(212, 36, 100)` and `(245, 43, 58)`. Coordinates use a discretization of 200 mm per unit. Box types distinguish equipment modules, existing pipe segments, module support zones, a rack, and preferred rack support levels.

The route must respect pipe thickness, obstacle clearances, nozzle directions, segment-length limits, and support availability. Its cost combines pipe length, bends, and supports.

## 2. Original formulation

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer segment-envelope coordinates**, representing lower and upper corners of the thickness-expanded segment boxes.
- **30 nonnegative integer coordinate-wise segment lengths**.
- **10 direction variables**, with zero meaning an unused segment and six values encoding signed coordinate directions.
- **10 binary existence flags** and **10 binary last-segment flags**.
- An integer objective variable, `obj`.

Segment arrays have ten positions, although only the first nine represent candidate segments. The final position is fixed to zero.

Additional defined arrays describe obstacle separation, support-zone membership, preferred-level membership, support costs, and flexibility expressions. These are derived quantities rather than additional independent routing decisions.

### Constraints

The main constraint groups are:

1. **Axis-aligned geometry.** Segment envelopes contain both endpoint cross-sections. Their widths determine segment lengths. Direction implications allow movement along only one coordinate axis.

2. **Route sequencing.** Existing segments form a prefix of the candidate sequence. Exactly one existing segment is marked last, and the first three segments must exist. Successive existing segments must use different axes.

3. **Nozzle connections.** The first segment travels in the negative Z direction; the last travels in the positive Y direction. Both have nozzle-specific length limits. Although their stated nozzle lower bounds are two units, the general direction constraints also impose a four-unit minimum on every existing segment.

4. **Obstacle avoidance.** A segment’s expanded box must be separated from each applicable obstacle along at least one axis. The first segment is exempt from its own source module. The destination module has exemptions for the last segment and unused segments.

5. **Support coverage and costs.** Every intermediate candidate node must lie in a support zone, including nodes associated with unused trailing segments. Membership uses the node center in X and Y and the pipe’s bottom in Z. Existing bends incur support costs, with discounts at preferred rack levels.

The source also contains inter-pipe separation and flexibility machinery. Neither imposes an active restriction here: there is only one pipe, and its flexibility coefficient is zero. The rack-traversal requirement is commented out in the original and remains unenforced.

### Objective

The model minimizes the original scaled cost:

- **131** per unit of segment length;
- **1,301** per existing segment after the first, representing a bend;
- **51** per ordinary support, or **1** at a preferred rack level.

These coefficients include the original integer division by 100 and subsequent addition of one. The reformulation preserves this objective exactly.

## 3. Reformulation and justification

### Signed-length extended formulation

The direction implications were replaced by binary positive- and negative-direction indicators and corresponding nonnegative length variables for each segment and axis.

Their sum equals the segment-existence flag, so an existing segment selects exactly one signed axis. Coordinate differences equal positive length minus negative length. The original direction code and coordinate-wise length are linked linearly to these variables.

This is equivalent to the original geometry. In the original model, envelope containment implies that each length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality, while unselected axes have zero length. Thus lengths equal absolute displacements and the envelopes are exact. The reformulation expresses these consequences directly through linear equalities.

This extended formulation is intended to give HiGHS stronger and more explicit links between route geometry and discrete choices.

### Direction-specific bound tightening

Each signed length receives an upper bound derived from endpoint coordinate domains, the general segment-length limit, and any applicable nozzle limit. Directions incompatible with the fixed first-nozzle direction or the final candidate’s permitted direction receive a zero upper bound.

These bounds are valid because a displacement cannot exceed the difference between the destination’s upper bound and the origin’s lower bound, or the corresponding reverse difference. The nozzle restrictions are already present in the original model.

### Obstacle-pair preprocessing

An obstacle–segment constraint is omitted when coordinate-domain bounds prove that the entire possible expanded segment envelope is separated from the obstacle along some axis.

For example, if an obstacle’s upper face plus clearance lies below the smallest possible lower face of the segment, that separation holds for every feasible assignment. Its disjunction is therefore always true. All pairs not certified this way retain the original avoidance requirement and module exemptions.

### Support-zone containment preprocessing

Support zones contained in other support zones are removed **only from the support-coverage disjunction**. Any point covered by a contained box is necessarily covered by its containing box, so this removal preserves the union of allowable support locations. Duplicate boxes are resolved deterministically.

Membership expressions for all original support zones remain available. In particular, preferred-level membership and support-cost calculations are unchanged.

### Boolean linearization of support costs

The original support cost multiplies an existence flag by a membership-dependent cost. The reformulation distributes this expression into weighted Boolean conjunctions: an existing segment with ordinary support, or an existing segment whose node belongs to a particular preferred level.

This is exact because existence and membership indicators are binary. The original binary-domain restriction on `fNodeNotInPref` is retained, preserving its restriction on simultaneous preferred-level memberships.

### Removal of inactive machinery

Inter-pipe separation constraints are vacuous because every node belongs to the same pipe. Flexibility expressions evaluate to zero, and their associated constraints evaluate to true, because the supplied flexibility coefficient is zero. Omitting this inactive machinery therefore removes no feasible-solution restriction.

## 4. Solution interface and scope

All original independent decision variables retain their names and meanings. The accompanying mapping script returns only those variables, excludes reformulation auxiliaries, and restores fixed endpoint coordinates from the unchanged embedded data if they are absent from solver output.

The reformulation adds no route-monotonicity, self-avoidance, or rack-traversal assumptions. Its expected benefit comes from a more explicit linear formulation and certified geometric preprocessing; no measured solve-time improvement is established by the conversation.
