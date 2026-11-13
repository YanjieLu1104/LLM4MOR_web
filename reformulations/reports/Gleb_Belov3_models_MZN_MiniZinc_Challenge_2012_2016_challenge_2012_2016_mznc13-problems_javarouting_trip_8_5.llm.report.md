# Reformulation Report: Pickup-and-Delivery Routing

## Problem background

The model represents a single route visiting 16 locations and returning to a depot. Its structure suggests eight pickup-and-delivery requests: locations are paired as \((1,2), (3,4), \ldots, (15,16)\), and each first location must be reached no later than its partner.

The route visits every location exactly once. Travel costs are specified by a fixed \(16 \times 16\) matrix, with a separate vector giving travel costs between the depot and each location. The objective is to minimize the complete route cost, including departure from and return to the depot.

This interpretation follows from the permutation, cumulative travel-time calculations, and eight arrival-time comparisons. The model does **not** specify vehicle capacity, service durations, time windows, or multiple vehicles.

## Original formulation

The original, automatically generated MiniZinc file declares **194 bounded integer variables**, including **16 variables defined by cumulative sums or the objective expression**.

Its principal components are:

- **Visit positions:** Sixteen `chooseOrder...` variables have domain \(0,\ldots,15\). An `all_different` constraint makes them a permutation, assigning each location a unique position.
- **Route reconstruction:** `listget...`, `chosenIndex...`, and `initialFieldValueslocationID...` variables recover the location visited at each position. These represent the same entity using different offsets.
- **Travel-cost lookup:** `mapget...` variables and their `...X` indices implement depot-cost and inter-location-cost lookups through repeated `element` constraints.
- **Cumulative travel:** Fifteen `binop...` variables accumulate the initial depot leg and successive inter-location legs.
- **Arrival-time lookup:** Sixteen arrival variables recover the cumulative travel time associated with each location. Additional lookup indices and implications implement the generated program’s “last matching entry” semantics.
- **Request precedence:** Eight inequalities require the second location of each pair to have an arrival time at least as large as the first.

The minimized objective is

\[
d_{0,v_1}
+\sum_{p=1}^{15}d_{v_p,v_{p+1}}
+d_{v_{16},0},
\]

where \(v_p\) denotes the location visited at position \(p\).

Most of the formulation’s complexity comes from implementing program-level lookups rather than expressing routing decisions directly.

## Reformulation and justification

### 1. Simplification of generated lookups

The repeated lookup structures were replaced by arithmetic equalities and explicit location–position assignments.

This is valid because the original 16 distinct position variables occupy a domain containing exactly 16 values. Consequently, every position occurs exactly once. For each route-position lookup, the unique matching entry exists, and the original implications exclude the initial fallback entry. The recovered route therefore contains every location exactly once.

The arrival-time lookups likewise have exactly one genuine matching visit. Their fallback entries cannot be selected because the corresponding visit’s implication requires a later lookup index.

These facts justify replacing the generated lookup logic with direct relationships, including:

- chosen index = location identifier minus one;
- list value = location identifier plus five;
- list lookup index = location identifier plus one;
- arrival lookup index = visit position plus two;
- flattened distance-table index = \(16(i-1)+j\).

Every original variable remains in the model and retains its original meaning.

### 2. Binary assignment formulation

A binary matrix indicates whether location \(i\) occupies route position \(p\). Each position contains exactly one location, and each location occupies exactly one position.

These row and column equations express the same permutation enforced by the original `all_different` constraint. Weighted sums recover both the original location positions and the location identifiers at each position.

### 3. Directed-arc routing formulation

A second binary matrix represents directed route arcs, including the depot. Each vertex has exactly one incoming and one outgoing arc.

Degree equations alone would allow disconnected cycles. To exclude them, selected customer-to-customer arcs force the destination’s position to equal the source’s position plus one. Selected depot-departure and depot-return arcs identify the first and last positions. A customer-only cycle would require positions to increase around a closed loop, which is impossible.

Selected arcs also enforce exact arrival-time increments using the unchanged travel costs. Assignment-based linking equates each location’s arrival time with the cumulative total at its route position. Thus, the original leg costs and cumulative sums remain consistent with the arc route.

### 4. Precedence preprocessing

Every off-diagonal entry of the supplied travel matrix is strictly positive. Since the route visits distinct locations, cumulative arrival times strictly increase along it.

Therefore, each original arrival-time inequality is equivalent to strict visit-order precedence. This permits the following deductions:

- a delivery cannot be the first visit;
- a pickup cannot be the last visit;
- a delivery cannot immediately precede its own pickup.

The corresponding arcs are fixed to zero. These deductions use positivity and the original pairing constraints; they do not assume a triangle inequality.

### 5. Bound tightening and linearization

The initial depot leg costs between 5 and 19, while every inter-location leg costs between 1 and 20. Hence, at one-based route position \(p\), cumulative arrival time satisfies

\[
5+(p-1)\le T_p\le19+20(p-1).
\]

These valid bounds tighten the cumulative and location-arrival variables and support finite big-\(M\) linearizations of conditional equalities. When an arc or assignment is selected, the associated equality holds exactly; otherwise, the chosen constants make the inequalities nonrestrictive over the established bounds.

### 6. Small-subtour cutting planes

Two- and three-vertex subtour inequalities strengthen the linear relaxation. For such a vertex subset \(S\),

\[
\sum_{i,j\in S,\ i\ne j}x_{ij}\le |S|-1.
\]

These inequalities are valid because a single tour through all 17 vertices cannot contain a closed tour within a proper subset. They are redundant for integer solutions satisfying the position constraints, but can exclude fractional solutions admitted by the weaker relaxation.

## Interface and expected benefit

The reformulation preserves the original costs, location correspondences, objective value, and minimization direction. The supplied mapping script copies the original independent variables from the default DZN solution, excluding new auxiliaries and originally defined expressions; missing required fields are reported explicitly.

The intended benefit for HiGHS is a more direct mixed-integer linear formulation with fewer generated lookup mechanisms, explicit routing structure, tighter bounds, and additional valid inequalities. No measured runtime improvement was established in the conversation.
