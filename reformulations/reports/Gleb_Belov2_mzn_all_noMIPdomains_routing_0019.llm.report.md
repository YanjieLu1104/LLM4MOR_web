# Orthogonal Industrial Pipe Routing: Model and Reformulation

## 1. Application background

The model represents the routing of a pipe through a three-dimensional industrial layout containing equipment modules, existing pipe segments, and pipe-support structures. Coordinates are integer-valued, with one coordinate unit representing **200 mm**.

The supplied instance has one pipe connecting the fixed points **(245, 86, 100)** and **(245, 62, 58)**. Its route is represented by ten ordered nodes, allowing up to nine straight segments. Each active segment follows a coordinate axis, and consecutive active segments must be perpendicular. The first and final segments must follow specified nozzle directions and satisfy nozzle-length limits.

The model accounts for pipe radius and safety clearance when avoiding obstacles. Intermediate nodes must lie in permitted support zones, measured using the pipe’s bottom elevation. Preferred rack levels offer lower support costs. These conditions also apply to intermediate nodes left in the representation after the route terminates; the reformulation preserves that detail.

## 2. Original formulation

### Variables

The explicitly declared independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates;
- **60 integer segment-box bounds**, representing lower and upper corners in three dimensions;
- **30 nonnegative integer component lengths**;
- **10 integer direction variables**, encoding an inactive segment or one of six signed coordinate directions;
- **20 binary integer flags**, indicating segment existence and the final active segment;
- one integer objective variable.

The segment arrays have ten rows, although only the first nine represent possible segments. The final row is fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The principal constraint groups are:

1. **Segment geometry.** Bounding boxes contain both segment endpoints, expanded by the pipe radius. Their widths determine component lengths. Direction-dependent constraints force movement along exactly one axis.

2. **Route sequencing.** Active segments form a prefix, exactly one is marked final, and at least the first three segments exist. Inactive segments have zero length.

3. **Nozzle connections and bends.** The initial and final active segments obey specified directions and length limits. Consecutive active segments cannot use the same axis, excluding both straight continuations and immediate reversals.

4. **Obstacle clearance.** Each segment must be separated from each relevant obstacle along at least one coordinate. Exceptions permit the first segment to leave its own module and the final segment to enter the destination module. The destination-module exception also covers inactive segments.

5. **Support requirements.** Intermediate nodes must belong to at least one support zone. Preferred rack-level membership determines discounted support costs.

6. **Conditional physical constraints.** The source includes inter-pipe separation and flexibility constraints. Neither is active here: the instance contains only one pipe, and its flexibility coefficient is zero.

### Objective

The model **minimizes total scaled routing cost**, combining pipe length, active bends, and support charges.

The original coefficient transformation—integer division by 100, followed by addition of one—is preserved. For this instance, the resulting coefficients are **131 per length unit**, **1,301 per counted bend**, and support charges of **51 outside preferred levels** or **1 within them**. These are the model’s transformed costs, not an unscaled monetary total.

## 3. Reformulation and justification

### One-hot directions and signed movement variables

The reformulation introduces six binary direction indicators per segment and nonnegative positive/negative movement variables for each coordinate. Their sum equals the segment-existence flag, so an active segment selects exactly one signed axis.

This is equivalent to the original geometry. Originally, endpoint containment and the bounding-box width equation imply that each component length is at least the absolute endpoint displacement. The selected-direction constraint supplies the reverse inequality, while unselected coordinates have zero length. Consequently, the bounds are necessarily the endpoint minimum and maximum, expanded by the radius.

The reformulation expresses these consequences directly through linear equations. Movement bounds are linked to direction indicators using the original coordinate domains and segment-length limits. This replaces several reified geometric relations with a more explicit mixed-integer formulation.

### Tighter segment-box bounds

For each coordinate, the lower box corner cannot exceed the smaller of the two endpoint upper bounds, minus the radius. Likewise, the upper corner cannot be below the larger endpoint lower bound, plus the radius.

These bounds follow directly from the exact endpoint-minimum/maximum interpretation established above. They strengthen the formulation without excluding feasible routes.

### Linearized nozzle and support-cost constraints

The final-segment direction is enforced directly through its one-hot indicator. A linear upper bound combines the ordinary segment-length limit with the tighter final-nozzle limit, using the existence and final-segment flags.

For support costs, products of binary conditions are expressed as Boolean conjunctions. The original preferred-membership equation and binary domain ensure that a relevant node belongs to at most one preferred level. Therefore, charging for “active and outside preferred levels” and “active and inside a particular preferred level” reproduces the original cost exactly.

### Bound-based obstacle preprocessing

An obstacle check is omitted only when the original endpoint domains prove that the entire segment box must already lie on one side of that obstacle, including radius and clearance.

For example, if the larger endpoint upper bound plus the radius is no greater than the obstacle’s lower boundary minus clearance, separation is guaranteed. The original disjunction is then always true, so removing it does not change feasibility. All remaining checks retain the original module exceptions.

### Inactive constraints and implied endpoint conditions

No inter-pipe separation constraints are generated because there are no pairs of segments belonging to different pipes. Flexibility expressions reduce to zero because the supplied flexibility coefficient is zero; an assertion records this specialization.

The explicit condition placing the end of the final active segment at the destination is implied by the retained sequencing and movement equations. After the final segment, every existence flag is zero; every subsequent displacement is therefore zero. Those nodes must coincide with the fixed terminal node.

### Remaining-distance inequalities

For every route suffix and coordinate, the reformulation requires the remaining component length to be at least both signs of the displacement to the destination.

These are valid triangle-inequality cuts: signed segment displacements telescope to the endpoint displacement, whereas component lengths sum their absolute magnitudes. They can strengthen the linear relaxation without changing the feasible integer solutions.

## 4. Solution interface

All original independent variables remain in the reformulated model. The mapping script returns only those variables, preserves array index encodings, and reconstructs omitted fixed endpoint coordinates from the unchanged embedded instance. Missing nonfixed values are reported explicitly.

The reformulation preserves the minimization direction and objective values. Its changes target formulation strength and unnecessary reification; no measured runtime improvement is claimed.
