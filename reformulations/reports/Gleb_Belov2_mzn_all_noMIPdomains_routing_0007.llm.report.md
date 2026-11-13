## Pipe Routing with Obstacles and Support Zones

### Background

The model represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, in a three-dimensional plant layout. Coordinates are integer multiples of a 200 mm length unit. A route consists of axis-aligned straight segments joined by right-angle bends.

The layout contains equipment modules, existing pipe segments, and regions where supports can be installed. The new pipe must avoid solid obstacles with the specified clearance, except for explicit exemptions at its nozzle connections. Intermediate nodes must lie in permitted support regions, and preferred rack levels offer lower support costs.

This instance contains one pipe, ten route nodes, and nine potential segments. Unused segments collapse to zero length at the destination. The model does not impose self-intersection avoidance for segments belonging to the same pipe.

### Original Model

#### Variables

The original independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two **10 × 3 integer arrays** describing the lower and upper corners of segment bounding boxes.
- A **10 × 3 nonnegative integer array** of coordinate-wise segment lengths.
- Ten direction variables, each taking a value from 0 to 6: zero means absent; the remaining values identify the positive and negative coordinate directions.
- Ten binary existence indicators and ten binary last-segment indicators.
- An integer objective variable.

The segment arrays include a tenth, non-segment position fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

#### Constraints

The main constraint groups enforce:

1. **Route geometry.** Each existing segment changes exactly one coordinate. Its bounding box includes the pipe radius, and its length equals the corresponding endpoint displacement.
2. **Segment sequencing.** Existing segments form a prefix of the potential-segment sequence. Exactly one segment is designated last, and at least the first three segments exist.
3. **Bend geometry.** Consecutive existing segments use different coordinate axes, excluding straight continuation and immediate reversal.
4. **Nozzle conditions.** The first and last existing segments have prescribed directions and length limits. The last segment reaches the fixed destination.
5. **Obstacle avoidance.** A segment’s radius-expanded bounding box must be separated from each applicable obstacle along at least one axis. The starting and destination modules have specific exemptions.
6. **Support availability.** Intermediate node positions must belong to at least one support zone. These requirements also apply to the relevant collapsed trailing nodes.
7. **Optional physical restrictions.** The source includes separation between different pipes and flexibility constraints, but neither is active in this instance.

#### Objective

The model **minimizes** pipe length, bend-related costs, and support costs. It uses the original integer scaling rule, `cost div 100 + 1`, rather than unscaled monetary costs.

For this instance, the resulting coefficients are:

- 161 per unit of pipe length;
- 1,601 per existing segment after the first;
- 51 for ordinary support, or 1 at a preferred rack level.

The reformulation preserves these objective values exactly.

### Reformulation and Validity

#### One-hot signed-direction formulation

Each potential segment now has positive- and negative-direction binary indicators for each coordinate axis, together with nonnegative lengths for those directions. Their binary sum equals the segment’s existence indicator, so an existing segment selects exactly one signed direction.

This replaces the original implication-based direction encoding with linear relationships. Its validity follows from the original constraints: bounding-box containment gives a length at least as large as the absolute endpoint displacement; the selected direction gives the reverse inequality; and unselected axes have zero length. Consequently, the original formulation already forces exact axis-aligned displacement.

The original direction and length variables remain present and are linked to the new representation.

#### Exact linear bounding-box equations

For each axis, the segment’s lower bound is its starting coordinate minus the negative-direction length and pipe radius. Its upper bound is the starting coordinate plus the positive-direction length and radius.

These equations are equivalent to the original bounding-box constraints. Once the segment length equals the absolute endpoint displacement, the original containment inequalities and box-width equation leave no slack: the box must be the endpoint interval expanded by the radius.

#### Domain-based length bounds

Positive and negative lengths receive separate upper bounds derived from endpoint coordinate domains. For example, positive displacement cannot exceed the successor coordinate’s upper bound minus the predecessor coordinate’s lower bound.

These bounds are intersected with the original segment-length limits and, where applicable, nozzle-length limits. They exclude only displacements already impossible under the original domains and constraints, while tightening the mixed-integer relaxation.

#### Linearized support costs

The original support expression multiplies a binary existence indicator by a variable support charge. The reformulation expresses each charge as a constant times a Boolean conjunction: the segment exists **and** the node belongs to the relevant support category.

This is exact because multiplying two binary indicators is equivalent to their conjunction. The original preferred-level membership equation and its binary domain are retained, including their restriction on simultaneous preferred-level memberships.

#### Displacement and segment-count cuts

Additional valid inequalities strengthen the formulation:

- Total length along an axis is at least the absolute endpoint displacement, by the triangle inequality.
- If a nonzero endpoint displacement \(d\) is smaller than the minimum nonzero segment length \(L\), movement in both directions is necessary. The movement opposing the net displacement is at least \(L\), so total axis length is at least \(2L+d\), and at least two segments use that axis.
- The first and last existing segments are distinct and have prescribed axes. Their required axis counts can therefore be combined with displacement-based counts, taking the maximum rather than adding potentially overlapping requirements.

Here, the Y-displacement is 1 and every nonzero segment is at least 5 units long. Thus Y-length is at least 11 and requires at least two Y-segments. The two prescribed X-directed nozzle segments and nonzero Z-displacement together imply at least five existing segments.

#### Instance-specific simplification

Two constraint families are vacuous:

- **Inter-pipe separation:** every node belongs to the same pipe, so there are no distinct-pipe segment pairs to constrain.
- **Flexibility:** the supplied flexibility coefficient is zero, causing the original conditional constraints to evaluate to true and their associated expressions to zero.

The reformulation specializes these families accordingly, with assertions documenting the conditions that justify the simplification.

### Interface and Expected Effect

All original independent variables are retained. The mapping script copies their solution values, restores any omitted singleton endpoint coordinates from the original fixed data, and obtains the objective from the emitted variable or solver objective. Derived original arrays need not be mapped.

The changes target a stronger, more explicitly linear formulation for HiGHS. They preserve the original obstacle exemptions, trailing-node support requirements, fixed instance data, and optimization direction. No measured runtime improvement is established by the reported compilation and interface repairs alone.
