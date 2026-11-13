# Reformulation Report: Three-Dimensional Pipe Routing

## 1. Application and instance

The model represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, through a three-dimensional installation. The route consists of axis-aligned straight segments connected by bends.

Coordinates are integer-valued, with one coordinate unit representing **200 mm**. The supplied instance contains:

- One pipe with endpoints at **(153, 51, 13)** and **(168, 52, 76)**.
- Ten node positions, allowing up to nine straight segments.
- Fixed boxes representing equipment modules, existing pipe segments, support zones, a rack, and preferred rack levels.

The route must avoid relevant obstacles while respecting pipe clearance. Intermediate node positions must lie in permitted support zones. The objective balances pipe length, the number of bends, and support costs. The formulation does **not** require every point along a segment to lie within a support zone; support membership is imposed at nodes.

## 2. Original mathematical formulation

### Variables

The original model independently declares **151 integer variable entries**:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional positions; six endpoint coordinates are fixed |
| Lower and upper segment-box coordinates | 60 | Bounding boxes expanded by the pipe radius |
| Coordinate-wise segment lengths | 30 | Nonnegative lengths along each axis |
| Segment directions | 10 | Zero for an unused segment; six signed coordinate directions otherwise |
| Segment-existence indicators | 10 | Binary indicators |
| Last-segment indicators | 10 | Binary indicators |
| Objective | 1 | Total scaled cost |

The segment arrays have ten rows, but only nine represent possible connections. The final row is fixed to zero. Additional defined arrays represent obstacle separation, support membership, support costs, and flexibility expressions.

### Constraints

The main constraint groups are:

- **Rectilinear geometry:** Each existing segment moves along exactly one coordinate axis. Direction, coordinate differences, lengths, and radius-expanded bounding boxes are linked.
- **Route sequencing:** Existing segments form a contiguous prefix. At least three segments exist, and exactly one is designated as the last.
- **Bends:** Consecutive existing segments use different coordinate axes. This prohibits both immediate reversal and consecutive collinear segments.
- **Nozzle connections:** The first and last existing segments have prescribed directions and length limits. Although the nozzle-specific lower bound is three units, the general five-unit minimum also applies.
- **Obstacle avoidance:** A segment must be separated from each relevant obstacle along at least one axis. Specified exemptions permit connection to the starting and ending modules.
- **Support placement:** Nodes associated with possible segments, other than the first node, must belong to a support zone. This requirement is not conditional on segment existence.
- **Optional physical restrictions:** The source includes inter-pipe separation and flexibility constraints. They are inactive here because there is only one pipe and its flexibility coefficient is zero.

Unused actual segments have zero displacement, so their successive nodes coincide with the terminal endpoint. Their obstacle and support requirements are retained where the original imposes them.

### Objective

The model **minimizes** scaled pipe-length, bend, and support costs. The original integer scaling is preserved:

- **161** per coordinate unit of pipe length;
- **1,601** per existing segment after the first;
- **51** per charged support outside preferred rack levels;
- **1** per charged support within a preferred rack level in this instance.

## 3. Reformulation and validity

### Disaggregated signed-length formulation

Direction implications were replaced by positive- and negative-direction binary indicators and corresponding nonnegative lengths for each axis. Their sum equals the segment-existence indicator, ensuring that an existing segment selects exactly one signed direction.

The coordinate difference is expressed as positive length minus negative length. The expanded bounding-box endpoints follow directly from these lengths and the pipe radius.

**Why this is valid:** In the original model, bounding-box containment and the length equation imply that a coordinate-wise length is at least the absolute endpoint displacement. The selected-direction implication imposes the matching upper bound, forcing equality. Unselected axes have zero length and therefore zero displacement. Thus the original constraints already force exactly the geometry expressed by the new linear equations, including coincident endpoints for unused segments.

This formulation exposes the geometry directly to the mixed-integer solver instead of relying on multiple reified implications.

### Bound-based obstacle preprocessing and separation selectors

For every segment–obstacle pair, coordinate bounds are used to determine whether separation is guaranteed along some axis. Such a pair requires no further obstacle constraint. Individual separation directions that are impossible within those bounds are disabled.

Remaining obstacle disjunctions use binary selectors and bound-derived big-M inequalities. At least one applicable selector must be active unless the original ending-module exemption applies.

**Why this is valid:** Guaranteed separation satisfies the original disjunction for every permitted assignment. Conversely, an impossible separation direction cannot satisfy that disjunction and can be removed. For the remaining directions, an active selector enforces the original separation inequality; an inactive selector relaxes it only to a valid variable bound. Any originally feasible pair can select a satisfied separation direction.

The selectors need not record *every* true separation relation: the original feasibility condition only requires at least one.

### Exact support-cost linearization

Products between segment existence and preferred-level membership were replaced by auxiliary binary variables. Each auxiliary represents the logical AND of those two indicators through the standard three linear inequalities.

**Why this is valid:** For binary values \(e\) and \(b\), the inequalities
\[
w\le e,\qquad w\le b,\qquad w\ge e+b-1
\]
force \(w=eb\). Substitution into the original support-cost expression therefore preserves its value exactly. Support-membership definitions and the original restriction on preferred-level membership remain enforced.

### Endpoint-based direction-count cut

A valid cut requires both positive and negative movement along any axis whose nonzero endpoint displacement is smaller than the minimum segment length. Here it applies to the Y-axis: the endpoint displacement is one unit, while every existing segment is at least five units long.

**Why this is valid:** Coordinate differences telescope along the route. If all nonzero Y movements had the same sign, their total magnitude would be at least five units and could not equal one. At least one positive-Y and one negative-Y segment are therefore necessary. The cut makes an existing implication explicit without excluding feasible routes.

### Removal of inactive or implied constraints

- **Inter-pipe separation:** Every node belongs to the same pipe, so there are no distinct-pipe pairs requiring separation.
- **Flexibility:** The supplied coefficient is zero, causing the original flexibility expressions to evaluate to zero and their constraints to true.
- **Last-node endpoint equalities:** The sequence equations force all segments after the designated last segment to be unused. The geometry equations then force zero displacement along that suffix. Since the terminal node is fixed, the last existing segment necessarily ends at that same endpoint.

These removals follow from the supplied data or retained constraints, rather than additional routing assumptions.

## 4. Solution interface and expected effect

All original independent variables retain their names and meanings. The mapping script copies them into the original solution interface and reconstructs the six fixed endpoint coordinates from their original singleton domains if omitted by the solver. It reports missing nonfixed variables rather than inventing values.

The reformulation targets HiGHS by replacing logical and multiplicative expressions with explicit linear mixed-integer constraints, simplifying obstacle checks, and adding a valid direction-count cut. These changes are intended to improve the formulation presented to the solver; no measured speedup is established by the conversation.
