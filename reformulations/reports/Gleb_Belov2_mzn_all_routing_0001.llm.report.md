# Pipe-Routing Model: Structure and Reformulation

## 1. Real-world interpretation

The model describes routing a pipe through a three-dimensional industrial installation containing equipment modules, existing pipe segments, and supporting structures. The route connects two fixed nozzle locations using axis-aligned straight segments.

Coordinates are integer multiples of a **200 mm discretization unit**. The supplied instance contains one pipe, ten route-node positions, and nine possible connecting legs. The endpoints are fixed at `(348, 142, 20)` and `(302, 60, 88)`; the eight intermediate nodes are decision variables.

The model accounts for:

- Pipe diameter and clearance from equipment and existing pipe segments.
- Prescribed directions and length limits at the two nozzles.
- Minimum straight-leg lengths and perpendicular successive legs.
- Support-zone membership at intermediate nodes.
- Lower support costs at preferred rack levels.

These requirements should be interpreted literally. In particular, the model checks support at nodes, not continuously along each leg. It does not prohibit intersections between different legs of this same pipe. Although a “through-rack” input flag is present, its corresponding constraint is commented out and is therefore not enforced.

## 2. Original mathematical structure

### Variables

The original independent declarations contain **151 integer scalar entries**, before presolve:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional positions; six coordinates are fixed |
| Lower and upper leg-box coordinates | 60 | Radius-expanded bounding boxes |
| Coordinate-wise leg lengths | 30 | Nonnegative lengths along each axis |
| Leg directions | 10 | Zero for an inactive leg; six signed axis directions otherwise |
| Leg-existence indicators | 10 | Binary indicators of active legs |
| Last-leg indicators | 10 | Binary indicators identifying the final active leg |
| Objective variable | 1 | Total scaled cost |

The leg arrays include a tenth, dummy row, which is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

**Geometry and direction.** Each active leg moves along exactly one coordinate axis. The direction constraints, bounding-box inequalities, and length equations jointly force its length to equal the corresponding endpoint displacement. The bounding box is therefore the segment’s exact coordinate-wise envelope, expanded by the pipe radius.

**Route sequence.** Active legs form a prefix of the nine available legs. Exactly one is designated the last leg, and at least the first three are active. Inactive legs have zero length, so trailing nodes coincide with the terminal endpoint.

**Nozzle and bend requirements.** The first leg travels in the negative X direction; the final active leg travels in the positive X direction. Both nozzle legs have nominal length bounds of 3–15 units, but the general active-leg minimum of 8 units also applies, making their effective range 8–15. Consecutive active legs must use different axes.

**Obstacle avoidance.** A leg’s radius-expanded box must be separated from each applicable obstacle along at least one axis, including the specified safety distance. Exceptions apply to the starting module for the first leg and the ending module for the final or inactive legs.

**Support.** Nodes 2–9 must lie in at least one support zone, even when their outgoing legs are inactive. Membership uses the node center in X and Y and the pipe bottom in Z. Support costs, however, are charged only for active outgoing legs.

**Inactive constraint families.** Inter-pipe separation generates no constraints because there is only one pipe. Flexibility constraints are inactive because the supplied flexibility coefficient is zero.

### Objective

The model minimizes pipe-length, bend, and support costs. It uses the original transformation `cost div 100 + 1`, rather than merely dividing the objective by 100. Consequently, the supplied instance charges:

- **201** per unit of total leg length;
- **2,001** per active leg other than the first;
- **51** for an active nonpreferred support location, or **1** at a preferred rack level.

The reformulation preserves these coefficients and the minimization direction exactly.

## 3. Reformulation and justification

### Direct linear formulation of leg geometry

The reformulation introduces nonnegative positive- and negative-direction lengths, together with binary signed-direction indicators, for each leg and axis.

Their sum equals the leg-existence indicator, so an active leg selects exactly one signed axis. Selected lengths obey the original minimum and maximum bounds; unselected lengths are zero. Endpoint displacement is expressed directly as positive length minus negative length.

This is equivalent to the original geometry: the original box constraints imply that coordinate-wise length is at least the absolute endpoint displacement, while the direction constraints impose the opposite inequality on the selected axis and zero length elsewhere. Together they force equality.

The new formulation therefore expresses explicitly what the original constraints already implied. It also defines both bounding-box corners linearly from the starting node and directional lengths, reducing reliance on reified direction implications.

### Bound-based directional-length tightening

Each directional length receives an upper bound derived from the two endpoint-coordinate domains, intersected with the original leg-length limit.

For example, positive displacement cannot exceed the destination’s coordinate upper bound minus the origin’s coordinate lower bound. This follows directly from the coordinate domains and excludes no feasible route.

### Obstacle preprocessing

Two forms of domain-based filtering reduce obstacle disjunctions:

1. **Remove an entire check when separation is guaranteed.** If both endpoint domains place the radius-expanded leg wholly on one side of an obstacle, the original separation disjunction is always true.
2. **Remove impossible separation alternatives.** If the bounds on a leg-box corner make a particular separating inequality unattainable, that alternative cannot satisfy the original disjunction.

The tests include pipe radius and obstacle safety distance. No check is removed merely because a leg is inactive: the original model still checks inactive legs against most obstacles.

### Support-zone containment preprocessing

The support-coverage disjunction retains only support boxes not contained in another support box. Identical boxes are resolved deterministically.

This is valid because a node satisfying the membership inequalities of a contained box necessarily satisfies those of its containing box. The same pipe-bottom adjustment is used for both boxes in Z, so containment is preserved under the membership definition.

Only the coverage disjunction is reduced. Preferred-level membership remains exact and available for cost calculations; overlapping membership is not replaced by an arbitrary support assignment.

### Linearization of support costs

The original support cost multiplies leg existence by a membership-dependent charge. The reformulation writes the cost as:

- The default charge multiplied by leg existence; plus
- A cost adjustment for each preferred level, activated when both leg existence and membership hold.

This is algebraically equivalent because the original definition of `fNodeNotInPref` is one minus the sum of preferred-level memberships. Its binary domain also retains the original restriction against multiple preferred memberships at a charged node. Boolean conjunctions replace the integer product while preserving the cost of every feasible solution.

### Valid directional-count cuts

Two redundant constraint families strengthen the formulation:

- **Endpoint-displacement cuts:** a net positive displacement along an axis requires at least one positive leg on that axis, and similarly for negative displacement. This follows by summing the leg displacement equations.
- **Nozzle-direction count cuts:** the route must contain the prescribed starting and ending directions, counting both occurrences if they coincide. The sequence constraints make the first and final active legs distinct, since the final leg cannot be either of the first two.

These cuts do not eliminate feasible routes; they expose consequences that otherwise require combining several constraints.

## 4. Preservation and expected benefit

All fixed instance data and original independent decision variables are retained. The accompanying mapping script copies those variables, restores fixed endpoint coordinates if omitted from solver output, and supplies the original objective variable.

The intended benefit for HiGHS is a more explicit linear geometry formulation, tighter directional bounds, fewer obstacle and support alternatives, and additional valid inequalities. These changes are mathematically justified, but no measured runtime improvement is established by the conversation.
