## Problem background

The model describes a single vehicle visiting 12 locations and returning to a depot while minimizing total travel cost. The locations form six ordered pairs: locations \(1,2\), \(3,4\), through \(11,12\). Within each pair, the first location must be reached no later than the second. This suggests a pickup-and-delivery routing application, although the model contains no vehicle-capacity constraints, service durations, or time windows.

The instance supplies a \(12\times12\) inter-location travel-time matrix and 12 depot travel times, used for both departure and return. Arrival times are cumulative travel times; waiting is not modeled.

## Original formulation

The original file is automatically generated from Java and expresses a compact routing problem through numerous list and map lookups.

- **Visit order:** Twelve integer variables, `chooseOrder...`, have domain \(0,\ldots,11\). An `all_different` constraint makes them a permutation of visit positions.
- **Route and lookup variables:** Variables identify the location at each position, its list identifier, and indices into lookup tables. Location IDs are \(1,\ldots,12\), while corresponding list identifiers are \(6,\ldots,17\).
- **Travel and arrival times:** Map lookups select the depot departure cost, 11 consecutive-location costs, and the depot return cost. Eleven `binop...` variables accumulate travel times. Additional lookups recover each location’s arrival time.
- **Precedence:** Six inequalities require the second location in each pair to have an arrival time at least as large as the first.
- **Objective:** Minimize departure cost, all consecutive-location costs, and return cost.

The source contains 134 independently declared scalar integer variables, together with 11 defined cumulative-sum variables and the defined objective. Its constraint structure is dominated by repeated `element` constraints and implications implementing generated lookup semantics.

## Reformulation and justification

### 1. Simplify generated lookups

Identity and offset tables were replaced with affine equalities. For example, the original tables imply directly that

\[
\text{location ID}=\text{chosen index}+1,\qquad
\text{list identifier}=\text{location ID}+5.
\]

Likewise, the map-row identifier equals the location ID plus 28. A flattened travel-table index for consecutive locations \(i,j\) is \(12(i-1)+j\).

The more elaborate list lookups also simplify exactly. The 12 distinct order variables occupy all 12 available positions, so every position has exactly one matching location. The original implications exclude the fallback lookup entry whenever this match exists. Consequently, the lookup returns that unique location. Every location is therefore visited exactly once, and its arrival-time lookup similarly selects its unique visit position.

These substitutions remove unnecessary lookup machinery without changing entity correspondences or values.

### 2. Introduce assignment and route-arc variables

A binary location–position matrix represents the permutation. Each location occupies exactly one position, and each position contains exactly one location. Weighted sums recover the original order and location variables.

Binary directed arcs represent travel between locations and the depot. Each node has one incoming and one outgoing arc. Depot arcs are linked to the first and last assigned locations. For every selected inter-location arc \(i\to j\), linear constraints enforce

\[
\operatorname{order}(j)=\operatorname{order}(i)+1.
\]

Thus, arcs describe exactly the consecutive visits in the assignment. Disconnected customer cycles are impossible: following such a cycle would require visit positions to increase repeatedly and return to their starting value.

This replaces indirect routing logic with an explicit mixed-integer formulation suited to HiGHS.

### 3. Exploit strictly positive travel times

Every off-diagonal inter-location travel time is strictly positive. Since the permutation visits distinct locations, cumulative arrival times strictly increase along the route. Therefore, each original arrival-time precedence is equivalent to strict visit-order precedence.

This also justifies fixing several arcs to zero:

- A delivery cannot be visited directly from the depot, because its pickup must occur first.
- A pickup cannot return directly to the depot, because its delivery must occur later.
- A delivery cannot immediately precede its own pickup.

These restrictions follow from the supplied data and original constraints; they do not assume additional routing rules.

### 4. Linearize arrival-time relationships

Bound-based linear constraints make a selected arc enforce the corresponding travel-time increment. Selected depot departure arcs fix the first arrival time, and assignment variables connect location arrival times to the original cumulative sums.

The constants use the original arrival-time bounds \(0,\ldots,239\). When an arc or assignment is inactive, the corresponding inequalities are nonrestrictive over those bounds. When active, they enforce the required equality.

### 5. Add valid strengthening constraints

The formulation includes two additional routing strengthenings:

- **Two-cycle inequalities:** Both directions of an edge cannot be selected simultaneously. Such a two-node cycle cannot occur in a tour visiting all 12 locations.
- **Single-commodity flow:** The depot sends 12 units, and each location consumes one unit. Flow is allowed only on selected arcs. Every valid tour supports this flow by carrying the number of remaining unvisited locations, so these constraints exclude no valid tour.

These constraints strengthen the linear relaxation. A redundant arc-based objective equality also exposes travel costs directly to the mixed-integer solver.

## Preservation and interface

All original scalar variables remain in the model and retain their meanings. The supplied travel data, objective value, and minimization direction are unchanged. The mapping script copies only the original independent variables, checks that their values are present, and excludes reformulation-specific variables.

The changes aim to reduce generated lookup overhead and improve the mixed-integer relaxation. No measured runtime improvement is established by the conversation.
