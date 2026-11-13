## Problem background

The model describes a single vehicle visiting 16 locations and returning to a depot while minimizing total travel cost. The locations form eight ordered pairs: location 1 must be visited before location 2, location 3 before location 4, and so on. This structure is consistent with a pickup-and-delivery routing problem, although the model does not include vehicle capacities, service durations, or time windows.

The instance provides a 16-by-16 travel-cost matrix and a vector of depot travel costs, used for both departure and return. Travel between distinct locations has strictly positive cost. The model also treats these costs as elapsed travel times.

## Original formulation

### Variables and constraints

The original model is an automatically generated integer formulation with several layers of lookup variables:

- **Visit positions:** Sixteen `chooseOrder...` variables have domain `0..15`. An `all_different` constraint makes them a permutation of the visit positions.
- **Locations at each position:** The `listget...`, `chosenIndex...`, and `initialFieldValueslocationID...` variables recover the location occupying each position. Location identifiers `1..16` correspond to list identifiers `6..21`.
- **Travel costs:** The `mapget...` variables select depot costs and costs between consecutive locations through repeated element constraints. Additional `...X` variables identify entries in those lookup tables.
- **Cumulative times:** The `binop...` variables accumulate travel costs along the route. The `expectedArrivalTime...` variables recover these cumulative times by location.
- **Precedence:** Eight inequalities require each second member of a pair to have an arrival time no earlier than its first member.

The generated lookup constraints include default entries and implications enforcing last-write lookup behavior. Here, the permutation constraint guarantees that every location and every position occurs exactly once, making those general-purpose mechanisms unnecessarily elaborate.

### Objective

The model minimizes the sum of the depot-to-first-location cost, the 15 consecutive-location costs, and the last-location-to-depot cost. There are no waiting-time decisions: arrival times are exact cumulative travel costs.

## Reformulation and justification

### 1. Replace generated inverse lookups with an assignment matrix

A binary assignment matrix records whether location \(i\) occupies visit position \(k\). Each position contains exactly one location, and each location occupies exactly one position. Weighted sums recover the original visit-position and location-at-position variables.

This is equivalent to the original permutation: 16 distinct integers drawn from `0..15` use every position exactly once. Consequently, every inverse lookup has a unique matching entry, and its default entry cannot be selected under the original last-write implications.

The remaining identifier conversions become linear equalities. For example, a list identifier equals its location identifier plus five, and a flattened travel-table index equals
\[
16(\text{previous location}-1)+\text{next location}.
\]
These equations follow directly from the original lookup tables and preserve their entity correspondences.

### 2. Introduce a directed-arc routing formulation

Binary arc variables represent travel between locations and the depot. Every node has exactly one incoming and one outgoing arc. Depot arcs are linked to the first and last rows of the assignment matrix.

Degree equations alone would allow disconnected cycles. The reformulation therefore adds **lifted Miller–Tucker–Zemlin-type subtour-elimination inequalities**, together with inequalities enforcing a one-position increase on every selected customer-to-customer arc.

Their validity follows from the original route positions: if the vehicle travels directly from \(i\) to \(j\), then \(j\)'s position is exactly one greater than \(i\)'s. A customer-only cycle would require positions to increase around a closed loop, which is impossible. Thus, the degree equations and position constraints describe one depot-to-depot tour.

Two-node subtour inequalities are also included. They are valid because a tour visiting all 16 locations cannot simultaneously use both \(i\to j\) and \(j\to i\).

### 3. Convert arrival precedence into position precedence

The original model visits every location once, and all off-diagonal travel costs are positive. Its cumulative arrival times therefore increase strictly along the route.

Accordingly, requiring a delivery arrival to be no earlier than its pickup arrival is equivalent to requiring its visit position to be later. The reformulation adds these explicit position inequalities while retaining the arrival-time inequalities.

This also justifies fixing several impossible arcs to zero:

- A delivery cannot be the first visited location.
- A pickup cannot be the last visited location.
- A delivery cannot immediately precede its own pickup.

These exclusions follow from the existing precedence requirements, not from additional operational assumptions.

### 4. Linearize and tighten arrival-time relationships

Assignment-controlled linear inequalities equate each location’s arrival time with the cumulative time at its assigned position. Arc-controlled inequalities enforce exact travel-time increments on selected arcs. Their big-\(M\) constants are derived from the declared time bounds and fixed travel costs.

Additional bounds follow from the instance data. At one-based position \(k\), the arrival time is at least
\[
2+(k-1),
\]
because depot travel costs at least two and each preceding customer-to-customer leg costs at least one. It is at most
\[
18+20(k-1),
\]
using the maximum depot and inter-location costs. The final-arrival upper bound of 318 also bounds earlier arrivals after accounting for the remaining positive-cost legs.

### 5. Expose the objective as a linear arc-cost sum

The original cumulative-cost objective is retained and equated to a direct weighted sum of selected arcs. Both expressions charge exactly the same route legs. The explicit arc-cost equation gives HiGHS a conventional linear routing objective and an additional connection between the routing and timing formulations.

## Preservation and expected benefit

The fixed travel data, minimization direction, and original independent variables are preserved. The mapping script copies those original variables from the default solution output and excludes newly introduced auxiliaries and originally defined expressions.

The reformulation replaces repeated element-based lookup encodings with explicit assignment, routing, and timing constraints. Its intended benefit is a more structured MILP with stronger routing relationships and tighter bounds for HiGHS. No measured runtime improvement is established by the supplied conversation.
