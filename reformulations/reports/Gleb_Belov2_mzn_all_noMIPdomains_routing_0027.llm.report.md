# Orthogonal Pipe Routing: Model and Reformulation

## Real-world background

The model represents the routing of one industrial pipe between two fixed connection points in a three-dimensional facility. The pipe must follow axis-aligned straight segments, avoid equipment and existing pipework, and place its intermediate nodes in permitted support regions.

Coordinates are integer multiples of a 200 mm length unit. The fixed endpoints are `(335, 43, 8)` and `(315, 54, 93)`. The data distinguish equipment modules, existing pipe segments, module support zones, a rack region, and preferred rack support levels. The objective balances pipe length, bends, and support costs.

The routing rules are those actually implemented, rather than every feature suggested by comments: self-intersection is not prohibited, and the requirement to pass through a rack is commented out.

## Original formulation

### Variables

The pipe has 10 ordered nodes and up to 9 physical legs. Arrays include a tenth, padded leg entry that is fixed to zero.

The original independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-bound variables**, representing the lower and upper corners of each leg’s bounding box.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, encoding an inactive leg or one of six signed coordinate directions.
- **20 binary-valued integer flags**, indicating leg existence and the last active leg.
- **One integer objective variable**.

Additional defined arrays describe obstacle separation, support-zone membership, support charges, and flexibility expressions.

### Constraints

The main constraint groups enforce:

1. **Axis-aligned geometry.** Each active leg moves along exactly one coordinate axis. Bounding-box inequalities, component-length equations, and direction implications together make its component lengths equal the corresponding absolute endpoint displacements.
2. **An active prefix of legs.** The first three legs exist. Existence and last-leg equations ensure that active legs form a consecutive prefix, followed by zero-length legs.
3. **Orthogonal consecutive legs.** Adjacent active legs cannot use the same axis, excluding both straight continuation and immediate reversal.
4. **Nozzle conditions.** The first leg points in positive Z; the last active leg points in negative X. Both nozzle legs have length bounds of 2–15 units.
5. **Obstacle avoidance.** Each checked leg must be separated from an obstacle along at least one axis, using the supplied safety distances. Specific exemptions apply at the two connected modules.
6. **Support availability.** Nodes 2–9 must belong to at least one support zone, including nodes belonging to an inactive trailing portion of the route. Preferred-level membership affects support charges.

Inter-pipe separation imposes no constraints in this single-pipe instance. Flexibility constraints are also inactive because the supplied flexibility coefficient is zero.

### Objective

The model minimizes the original scaled cost expression:

- **51 per unit of pipe length**;
- **501 per active leg after the first**, representing bend cost;
- **51 per charged node outside preferred levels**, or **1 within a preferred level**.

These coefficients arise from the original integer division by 100 followed by addition of 1. The reformulation preserves this expression rather than replacing it with unscaled monetary costs.

## Reformulation and justification

### 1. Linear signed-length formulation

Each leg and axis now has positive- and negative-direction indicators and corresponding nonnegative lengths. Their sum selects exactly one direction for an existing leg; their difference gives the endpoint displacement. The original direction, length, and bounding-box variables remain linked to these quantities by linear equations.

This is equivalent to the original geometry. Originally, the bounding box makes a component length at least the absolute endpoint displacement. A selected direction imposes the reverse inequality with the appropriate sign, forcing equality; an unselected axis has zero length. The new equations express these consequences directly and avoid much of the original implication-based formulation.

### 2. Geometric bound tightening

Directional lengths are bounded by the maximum displacement permitted by the two endpoint domains, additionally capped by the applicable leg-length limit.

Bounding-box bounds are also tightened. The lower endpoint of a segment cannot exceed the smaller of its endpoint upper bounds, and the upper endpoint cannot fall below the larger of its endpoint lower bounds. Pipe radius is included with the original signs.

These are consequences of the exact segment geometry, so they remove no feasible routes. They also provide tighter bounds for the mixed-integer linearization.

### 3. Domain-based obstacle preprocessing

Obstacle checks are simplified before solving:

- A check is omitted when coordinate domains guarantee separation along some axis for every possible realization of that leg.
- A particular separation alternative is omitted when endpoint domains make that alternative impossible.

Both tests use necessary bounds on the leg’s exact bounding box. Thus, a removed check is already satisfied, while a removed alternative could never satisfy the original disjunction. The original nozzle-module exemptions remain unchanged.

### 4. Support-membership preprocessing and cost linearization

A node–support membership expression is fixed to false when the node’s coordinate domain cannot intersect the support box, accounting for the original bottom-of-pipe test in Z.

Support charges are rewritten as a default charge for an existing leg plus preferred-level adjustments activated by Boolean conjunctions. This follows by substituting the original definition
\(f_{\text{not preferred}}=1-\sum_z b_z\)
into the original support-cost expression and distributing the existence flag. The original membership and cardinality restrictions are retained, including support requirements for inactive trailing nodes.

### 5. Endpoint-based valid inequalities

Two families of redundant inequalities strengthen the formulation:

- Total component length on each axis is at least the absolute endpoint displacement, by the triangle inequality.
- A positive or negative net displacement requires at least one leg in that signed direction.

A stronger instance-specific cut requires **at least two positive-Z legs**. The net Z displacement is \(93-8=85\), but the mandatory first positive-Z leg has length at most 15. Without another positive-Z leg, the total net upward displacement could not reach 85.

### 6. Inactive-feature elimination and solution mapping

The flexibility expressions reduce to zero because their original definitions explicitly select zero when the flexibility coefficient is nonpositive. Cross-pipe separation is vacuous because there is only one pipe. Removing their inactive machinery therefore does not remove a feasible-set restriction.

All original independent variables are retained. The supplied mapping script exports only those variables and can restore omitted fixed endpoint coordinates from the unchanged embedded data.

Overall, the reformulation targets a tighter, more explicitly linear model for HiGHS. It preserves the feasible routing semantics and objective values; no measured runtime improvement was established in the conversation.
