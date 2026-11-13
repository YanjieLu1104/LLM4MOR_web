# Rectilinear Pipe Routing with Obstacles and Support Zones

## Problem background

The model represents the routing of an industrial pipe between two fixed connection points in a three-dimensional plant layout. Coordinates are integer multiples of a 200 mm length unit. Fixed boxes describe equipment modules, existing pipe segments, support zones, a large pipe rack, and preferred rack levels.

The route has ten ordered nodes and up to nine axis-aligned legs. Its endpoints are fixed at `(308, 47, 43)` and `(298, 25, 3)`. The model chooses intermediate coordinates, the number of active legs, and their directions while enforcing obstacle clearance, nozzle connection requirements, and support availability.

Some features suggested by the data are not active constraints. In particular, the requirement to pass through a rack is commented out, even though its input flag is set. The reformulation does not activate it.

## Original model structure

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates and 24 unfixed intermediate coordinates.
- **60 integer leg-envelope coordinates**, representing lower and upper corners in three dimensions for ten leg slots.
- **30 nonnegative dimensional leg lengths**.
- **10 direction variables**, taking values from zero to six.
- **20 binary integer flags**, indicating whether each leg exists and whether it is the final active leg.
- An integer objective variable, `obj`.

Only nine leg slots connect consecutive nodes; the tenth is a dummy slot fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions. These are not additional independent routing choices.

### Constraints

The principal constraint groups are:

1. **Rectilinear geometry.** An active leg moves in exactly one signed coordinate direction. Its other dimensional lengths are zero. Envelope bounds and direction-dependent inequalities jointly force its dimensional lengths to equal the absolute coordinate differences.

2. **Route sequence.** Active legs form a prefix, with exactly one final active leg. At least the first three legs exist. Consecutive active legs use different coordinate axes, excluding straight continuation and immediate reversal.

3. **Nozzle connections.** The first leg points in the negative Y direction; the last active leg points in the negative Z direction. Both have lengths between two and fifteen units. The final active leg reaches the fixed destination.

4. **Obstacle avoidance.** A leg must be separated from each applicable obstacle along at least one coordinate axis, including the specified clearance. Explicit exceptions allow the first leg to connect through its source module and the final leg to enter its destination module.

5. **Support membership.** Intermediate nodes must belong to at least one support zone. This requirement also applies to intermediate nodes associated with inactive trailing legs; the reformulation preserves that detail.

6. **Optional interaction and flexibility constraints.** Inter-pipe separation has no applicable pairs because the instance contains only one pipe. Flexibility constraints are inactive because the supplied flexibility coefficient is zero.

The effective pipe radius is computed as integer division of diameter by two. Here, diameter one therefore gives radius zero; this original discretization is preserved.

### Objective

The model minimizes a scaled sum of pipe length, bend, and support costs. Its coefficients are computed using integer division by 100 followed by adding one. For this instance:

- Pipe length costs **51 per length unit**.
- Each active leg after the first incurs a **501 bend cost**.
- An active intermediate node incurs **51 support cost** outside preferred rack levels or **1** within a preferred level.

The reformulation retains these coefficients and the minimization direction.

## Reformulation and justification

### Signed-length, one-hot linear formulation

The direction implications were replaced with positive and negative direction indicators and corresponding nonnegative lengths for each coordinate.

For each leg, the sum of its six direction indicators equals its existence flag. Thus an active leg selects exactly one signed axis, while an inactive leg selects none. The coordinate displacement equals positive length minus negative length, and total dimensional length equals their sum.

This is equivalent to the original geometry: the original envelope inequalities imply that dimensional length is at least the absolute endpoint displacement, while the selected direction imposes the matching upper bound. Together they force equality. The new formulation expresses that equality directly and reconstructs the same envelope coordinates.

This is a **disaggregated mixed-integer linear formulation**, intended to give HiGHS a more explicit linear representation with fewer direction-dependent logical relations.

### Bound-derived length limits and obstacle preprocessing

Each signed length receives an upper bound derived from the endpoint coordinate domains and the original maximum leg length. These bounds are valid because a displacement cannot exceed the largest difference permitted by those domains.

Obstacle avoidance is expressed directly as a disjunction of the possible separating sides, rather than through a full array of axis-separation definitions. Two bound-based simplifications are applied:

- An obstacle–leg constraint is omitted only when a separating side holds throughout the leg’s entire possible envelope range.
- A separating alternative is omitted only when it cannot hold anywhere within that range.

These are **domain-based redundancy and impossibility tests**. They preserve the clearance distances and all module exceptions. In particular, obstacle constraints are not generally disabled merely because a leg is inactive.

### Boolean linearization of support costs

The original support cost multiplies an existence flag by a sum of membership-dependent costs. The reformulation distributes this product and represents each binary product as a Boolean conjunction.

This is exact because both existence and membership indicators are binary. The original preferred-level membership sum and its domain restriction are retained, so the reformulation does not introduce a new assumption about overlapping preferred levels.

### Inactive features and solution correspondence

The inter-pipe and flexibility expressions remain in conditional form, but their supplied data make them empty or constant during compilation. This follows respectively from the single-pipe instance and the zero flexibility coefficient, not from an additional modeling assumption.

All original independent variables remain available under their original names. The mapping script copies those variables, excludes reformulation auxiliaries, and can reconstruct omitted fixed endpoint coordinates from the original embedded constants.

These changes aim to reduce logical overhead and improve the mixed-integer formulation. No measured runtime improvement or optimality result was established in the conversation.
