## Background and interpretation

The instance represents a **single-vehicle routing problem with seven pickup–delivery pairs**, inferred from its permutation, travel-time, and paired arrival-time constraints. A vehicle leaves a depot, visits 14 locations exactly once, and returns to the depot. For each pair, the first location must be reached no later than the second.

Travel costs are supplied by a fixed \(14\times14\) matrix, together with 14 depot-to-location costs, also used for the return journey. The objective is to **minimize total route cost**. The model contains no vehicle-capacity constraints, service durations, or explicit time windows; arrival times are cumulative travel costs without waiting.

## Original formulation

The source is an automatically generated MiniZinc model with extensive lookup machinery.

- **Visit positions:** Fourteen integer variables, `chooseOrder...`, have domain \(0,\ldots,13\). An `all_different` constraint makes them a permutation, assigning every location a unique visit position.
- **Route reconstruction:** The `listget...`, `chosenIndex...`, and `initialFieldValueslocationID...` variables recover the location visited at each position. Element constraints and implications implement these inverse lookups.
- **Travel costs:** The `mapget...` variables and their `X` lookup indices select depot costs and consecutive-location costs. The same 196-entry distance table is repeated for each internal route leg.
- **Arrival times:** The `binop...` variables accumulate travel costs along the route. Additional element constraints recover the arrival time of each named location.
- **Precedence:** Seven inequalities require the second member of each pair to arrive no earlier than the first.
- **Objective:** The model minimizes the cumulative cost through the final location plus its return-to-depot cost.

The generated lookup constraints include default entries and “last matching entry” implications. Here, the permutation guarantees that each requested position and each location occurs exactly once, so these lookups have unique, non-default results.

## Reformulation and justification

### 1. Consolidated data and simplified affine lookups

The repeated distance tables were replaced by one shared matrix, preserving every entry and its location correspondence. The depot-cost vector was likewise stored once.

Lookups into consecutive integer sequences were replaced by linear equalities. For example, the original tables imply
\[
\text{locationID}=\text{chosenIndex}+1,\qquad
\text{listget}=\text{locationID}+5.
\]
Similarly, row identifiers are location identifiers plus 30, and a flattened distance-table index is
\[
14(\text{originID}-1)+\text{destinationID}.
\]
These are exact substitutions justified by the original table contents, rather than additional assumptions.

### 2. Assignment-based inverse permutation

A binary assignment matrix now records whether a location occupies a visit position. Every location is assigned to exactly one position, and every position receives exactly one location.

This is equivalent to the original permutation: 14 distinct values drawn from a 14-value domain necessarily use every value once. Weighted sums of assignment entries recover both the original visit-position variables and the location at each position.

Consequently, the original lookup indices can also be recovered directly. A location’s arrival lookup index is its zero-based visit position plus two; a position’s list lookup index is its one-based location identifier plus one. The offsets account for the original default entries.

### 3. Directed route arcs and lifted MTZ constraints

Binary directed arcs describe travel between locations and the depot. Each vertex has exactly one incoming and one outgoing arc. Depot arcs are linked to the first and last assigned locations.

Degree constraints alone would permit disconnected cycles. Lifted Miller–Tucker–Zemlin (MTZ) inequalities therefore connect internal arcs to the original visit positions:
\[
u_i-u_j+n x_{ij}+(n-2)x_{ji}\le n-1,\qquad n=14.
\]

These are the standard lifted MTZ form associated with Desrochers and Laporte’s strengthening of the MTZ formulation. Their validity can also be checked directly here: if \(i\to j\) is selected, the inequalities for both ordered pairs force \(u_j=u_i+1\); if neither direction is selected, the inequality follows from the position bounds. Thus selected internal arcs follow consecutive positions, excluding customer-only subtours without removing any valid original route.

### 4. Linear arrival-time linking and precedence strengthening

Bounded linear constraints link each location’s arrival time to the cumulative time at its assigned position. Further conditional equalities enforce the supplied travel cost on each selected arc.

The big-\(M\) coefficients come from valid arrival bounds: every visited location has arrival time between 2 and 278. The lower bound follows from the minimum depot cost and nonnegative subsequent costs; the upper bound is inherited from the original cumulative-cost domains. The coefficients make unselected-arc constraints inactive throughout these bounds.

All off-diagonal matrix entries are strictly positive. Because the original permutation visits distinct locations, cumulative arrival times therefore increase strictly along the route. Each original paired arrival inequality consequently implies strict visit-position precedence. These position inequalities were added as valid strengthening constraints; the arrival inequalities were retained.

### 5. Objective and solution correspondence

A redundant arc-cost expression equates the objective to the sum of selected travel costs. It agrees with the original cumulative-cost objective because the arcs describe exactly the same depot-to-depot route.

All original scalar variables remain represented. The accompanying mapping script reconstructs every original independent variable from the emitted visit-position variables and the unchanged embedded data. It restores route identities, lookup indices, leg costs, and arrival times.

## Intended computational benefit

The reformulation replaces repeated variable-index lookups and generated implications with explicit assignment and arc-based linear structure suited to **HiGHS**. Data consolidation and affine substitutions simplify the encoding, while lifted MTZ and position-precedence constraints strengthen routing consistency. These changes are intended to improve solution time; no measured speedup was established in the conversation.
