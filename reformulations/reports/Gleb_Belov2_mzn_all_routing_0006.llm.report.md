# Pipe Routing with Obstacles and Support Zones

## 1. Background and interpretation

The instance models the routing of a single pipe through a three-dimensional industrial layout. The layout contains equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels. Coordinates are integer-valued, with each coordinate unit representing **200 mm**.

The pipe connects two fixed nozzles using axis-aligned straight segments. Its route must respect obstacle clearances, nozzle directions, segment-length limits, and support requirements. The objective balances pipe length, bends, and support costs.

Ten ordered nodes provide nine candidate segments. The model can use fewer segments by making the unused suffix zero-length. Consecutive active segments must follow different coordinate axes.

Two details are important when interpreting the instance:

- Although the input includes a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. Rack passage is therefore **not mandatory**.
- The original model does not impose collision avoidance between segments of the same pipe. The reformulation does not add this restriction.

## 2. Original mathematical structure

### Variables

The original model declares:

- **30 integer node coordinates**, of which six are fixed endpoint coordinates.
- **60 integer segment-envelope coordinates**: lower and upper bounds in three dimensions for each of ten array positions.
- **30 nonnegative integer segment-length components**.
- **10 direction variables**, taking values from 0 to 6: zero denotes an inactive segment, and the remaining values identify signed coordinate directions.
- **10 binary existence flags** and **10 binary last-segment flags**.
- An integer objective variable.

The segment arrays include a tenth, non-segment position whose entries are constrained to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

**Geometry and direction.** Each active segment follows exactly one signed coordinate direction. Its envelope includes the pipe radius, computed in the original model as the integer division of diameter by two. Direction-dependent constraints connect node displacement, segment length, and envelope coordinates.

**Route sequence.** Active segments form a prefix of the candidate sequence. The first three segments must exist, and exactly one segment is designated as the last. Inactive segments have zero length, so their endpoints coincide.

**Nozzle connections and bends.** The first segment has a fixed outgoing direction and restricted length. The last active segment has a fixed incoming direction, restricted length, and ends at the destination nozzle. Consecutive segments cannot use the same coordinate axis.

**Obstacle avoidance.** A segment and an obstacle must be separated along at least one coordinate axis, accounting for safety distance. The model makes specific exceptions for the source module and the destination module. Most obstacle checks remain applicable even to inactive segments; the reformulation preserves this behavior.

**Support coverage.** Nodes 2 through 9 must belong to at least one support zone, regardless of whether their outgoing segment is active. Membership uses the node center in the horizontal dimensions and the pipe’s bottom elevation vertically. Preferred rack levels affect support cost.

**Inactive constraint families.** There is only one pipe, so the inter-pipe collision constraints have no applicable pairs. The supplied flexibility coefficient is zero, so the flexibility inequalities are inactive and their defined length-cube sums are zero.

### Objective

The model minimizes the original scaled cost expression:

- **181 per unit of segment length**;
- **1,801 per active segment after the first**, representing bends;
- support costs at the corresponding active nodes: **51 outside preferred levels** and **1 within a preferred level**.

These values follow from the original integer division by 100 followed by addition of one. The reformulation preserves this objective exactly rather than replacing it with unscaled monetary costs.

## 3. Reformulation and validity

### Direct linear representation of segment geometry

The reformulation introduces positive- and negative-direction binary selectors for each segment and coordinate axis, together with nonnegative positive and negative length components.

For each segment:

- The sum of its six direction selectors equals its existence flag.
- Each signed length is bounded above and below by its associated selector.
- Node displacement equals positive length minus negative length.
- Total length equals positive length plus negative length.
- Envelope endpoints are computed directly from the starting node, signed lengths, and radius.

**Why this is equivalent.** In the original model, the envelope inequalities and length equation imply that length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality with the appropriate sign, forcing equality. Unselected dimensions have zero length, which forces equal endpoint coordinates in those dimensions. Consequently, the original envelope is already uniquely determined by the two endpoints and the radius.

The new equations express these consequences directly. They replace direction-conditioned geometry with a bounded linear formulation suited to HiGHS.

### Bound strengthening

Signed-length upper bounds are derived from the original coordinate domains. For example, positive displacement cannot exceed the upper bound of the next coordinate minus the lower bound of the current coordinate. This bound is intersected with the original segment-length limit.

Finite envelope domains are also derived from the node-coordinate domains and pipe radii.

**Why this is valid.** These bounds follow from the original coordinate domains and the exact segment geometry established above. They exclude no feasible original route and provide tighter bounds for the mixed-integer formulation.

### Bound-based obstacle preprocessing

An obstacle–segment check is skipped when the original endpoint bounds guarantee separation along at least one axis, including the radius and safety clearance.

**Why this is valid.** The segment’s minimum possible lower envelope coordinate and maximum possible upper envelope coordinate are determined by its endpoint domains. If an obstacle lies entirely beyond either envelope bound, one alternative of the original separation disjunction is always true. The entire obstacle constraint is therefore redundant for that pair.

### Support-zone containment preprocessing

The support-coverage disjunction uses only support zones that are not contained in another support zone. Identical zones are handled with a deterministic tie-break. Preferred-level membership and cost expressions remain intact.

**Why this is valid.** If one support box is contained in another in every coordinate, membership in the smaller box implies membership in the larger box. The same bottom-elevation adjustment applies to both membership tests. Removing the contained box from the coverage disjunction therefore leaves the union of admissible supported positions unchanged.

This reduction applies only to coverage; it does not remove cost-relevant membership information.

### Linearization of support costs

The product of an existence flag and a support-cost expression is replaced by weighted Boolean conjunctions: “segment exists and node is outside preferred levels,” and “segment exists and node belongs to this preferred level.”

**Why this is equivalent.** Existence and membership indicators are binary. Their product is exactly the indicator of their conjunction. Distributing the original product over its cost terms gives the reformulated expression without changing any cost.

### Instance-specific simplification and solution interface

The flexibility expressions are explicitly set to zero because the supplied coefficient makes every original summand zero and disables every flexibility inequality. No rack-passage or same-pipe collision constraint is introduced.

All original independent decision variables are retained. The mapping script copies their emitted values, restores the six fixed endpoint coordinates from the original singleton domains, and obtains the objective from the emitted variable or solver objective field. The final repair also restores the box-type literal to the original data.

These changes target formulation strength and compilation size. No measured runtime improvement is established by the conversation.
