# Pipe-Routing Model and Reformulation Report

## 1. Application background

The model represents **three-dimensional industrial pipe routing** between two fixed equipment connections, or nozzles. It seeks an economical, axis-aligned route that avoids equipment and existing pipes while placing bends in designated support regions.

The supplied instance contains one pipe with endpoints at \((308,25,3)\) and \((308,47,48)\). Coordinates use a discretization of 200 mm per unit. Ten ordered nodes provide nine possible segments; unused trailing segments collapse to zero length.

Fixed boxes represent equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels. Obstacle clearances, prescribed nozzle directions, and nozzle-segment length limits constrain the route. The objective balances pipe length, bends, and support costs.

The formulation is an abstraction of physical routing. In particular, it uses integer-divided pipe radii and does not impose self-collision avoidance between segments of the same pipe. The reformulation preserves these choices.

## 2. Original formulation

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two segment-boundary arrays, `nXLeg1` and `nXLeg2`, with **30 integer entries each**.
- **30 nonnegative integer component lengths** in `nLLeg`.
- **10 direction variables**, encoded as zero for an absent segment and six values for signed coordinate directions.
- **10 binary existence flags** and **10 binary last-segment flags**.
- One integer objective variable.

The segment arrays include a dummy tenth slot, fixed to zero. Additional defined arrays describe obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The principal constraints enforce:

1. **Axis-aligned geometry.** Each existing segment moves along exactly one coordinate axis. Its component lengths and bounding box agree with its endpoint coordinates.
2. **Route sequencing.** Existing segments form a prefix of the available segments. At least the first three exist, and exactly one is marked as the last segment.
3. **Perpendicular consecutive segments.** Adjacent existing segments cannot use the same coordinate axis.
4. **Nozzle connections.** The first segment points in positive Z; the last existing segment points in positive Y. Both nozzle segments have lengths between 2 and 15 units.
5. **Obstacle avoidance.** A segment must be separated from an obstacle along at least one axis, including the specified clearance. The first segment is exempt from its starting module; the last segment and absent segments have the specified exemption from the destination module.
6. **Support availability.** Nodes 2–9 must lie in a support region, even when they belong to the collapsed trailing portion of the route.
7. **Support charging.** Existing bends incur a support charge depending on membership in preferred rack levels.

The source also contains inter-pipe separation and flexibility constraints. Neither restricts this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes the original scaled integer cost:

- **61 per unit of segment length**;
- **601 per existing segment after the first**, representing bend cost;
- **51 per charged support outside preferred levels**, or **1 within a preferred level**.

These coefficients follow the source’s division by 100 followed by addition of one. The reformulation preserves this objective, rather than replacing it with unscaled engineering costs.

## 3. Reformulation and validity

### Explicit directional-length formulation

Each segment now has binary positive- and negative-direction indicators for each axis, together with nonnegative forward and backward lengths.

The indicators sum to the segment-existence flag. Directional lengths are bounded by their corresponding indicators, and coordinate differences equal forward length minus backward length. This replaces the original implication-based geometry with an explicit mixed-integer linear formulation.

**Why it is valid:** In the original model, segment bounds enclose both endpoints, so each component length is at least the absolute coordinate difference. The selected-direction implication supplies the reverse inequality, while unselected components are forced to zero. Thus the original constraints already require exact axis-aligned lengths and endpoint minima and maxima. The new linear equations express those same relationships directly.

### Nozzle-based bound propagation

The second node is restricted to
\[
X_2=308,\qquad Y_2=25,\qquad 5\le Z_2\le18.
\]

The ninth node is restricted to
\[
X_9=308,\qquad 32\le Y_9\le47,\qquad Z_9=48.
\]

**Why it is valid:** The first segment starts at the fixed first endpoint and moves only in positive Z by 2–15 units. The ninth segment is either absent or points in positive Y with length at most 15 and ends at the fixed destination. These facts directly imply the tightened bounds.

The model also derives component-specific directional-length bounds from endpoint coordinate domains and the original segment-length limit.

### Obstacle preprocessing and bounded separation inequalities

For each segment–obstacle pair, coordinate bounds determine whether:

- separation is already guaranteed along some axis; or
- a particular separating side is impossible.

Guaranteed pairs need no separation decision. Impossible sides are fixed off. Remaining alternatives use binary separation selectors and individually bounded big-M inequalities.

**Why it is valid:** A pair can be removed only when its entire possible segment box is already on a permitted side of the obstacle. A side can be excluded only when no coordinate value within the segment bounds can satisfy that separation. Each big-M value relaxes its inequality over the complete bounded domain.

Selecting exactly one valid separating side does not restrict the route: whenever the original disjunction holds, at least one such side can be selected. The original nozzle-module exemptions are retained.

### Support-zone selection

Mandatory support availability is expressed by selecting one feasible support zone for each required node. Weighted lower and upper coordinate bounds enforce membership in the selected zone.

**Why it is valid:** The original requirement is membership in at least one support zone. A node satisfying that requirement can select any containing zone; conversely, selecting a zone forces the node inside it. Zones are excluded from a node’s candidate list only when their coordinate bounds do not intersect the node’s domain.

Preferred-level membership remains exact because it determines objective costs.

### Linearized support discounts

The product between segment existence and preferred-level membership is replaced by a binary conjunction and its standard three linear inequalities. Support cost becomes a linear expression in existence and this conjunction.

**Why it is valid:** All preferred levels have the same support cost in the supplied data. Moreover, the original binary domain of `fNodeNotInPref`, together with its defining equation, ensures that the sum of preferred-level memberships is at most one. The conjunction therefore reproduces the original support-cost product exactly.

### Valid direction-count cuts

The reformulation requires at least two positive-Z segments and at least two positive-Y segments.

**Why it is valid:** The route’s net Z displacement is 45 units, but its prescribed initial positive-Z segment contributes at most 15. Another positive-Z segment is therefore necessary. Similarly, the net Y displacement is 22 units, while the prescribed final positive-Y segment contributes at most 15. Negative movement cannot remove either requirement; it increases the positive movement needed.

### Inactive constraint families and solution mapping

Inter-pipe collision constraints are omitted because no pair of distinct pipes exists. Flexibility expressions reduce to zero because the original coefficient is zero, making the associated constraints inactive.

All original independent variables remain represented. The mapping script returns only those variables, reconstructing omitted geometric auxiliaries from node coordinates when necessary and using the original self-contained data for fixed values.

## 4. Expected computational effect

The reformulation targets HiGHS by exposing linear geometry, tightening bounds, reducing obstacle disjunctions, and replacing variable products with explicit binary linearizations. The direction-count cuts additionally strengthen the relaxation.

These changes are intended to reduce solution time without changing the routing problem or objective. No measured runtime improvement is established by the conversation.
