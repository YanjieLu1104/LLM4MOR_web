## Problem background

The supplied model describes a single-vehicle route that starts at a depot, visits 14 locations exactly once, and returns to the depot. Seven pairs of locations have an ordering requirement: the first member must be reached no later than the second. This structure is consistent with a pickup-and-delivery routing problem, although the model does not include vehicle capacity, service times, or delivery time windows.

The fixed instance contains a 14-by-14 travel-time matrix and 14 depot travel times. The objective is to minimize total travel time, including departure from and return to the depot.

## Original model

The automatically generated MiniZinc formulation represents the route through several layers of integer variables and lookups:

- **Visit positions:** The 14 `chooseOrder...` variables have domain `0..13` and satisfy one `all_different` constraint. They therefore assign every location a unique visit position.
- **Locations at each position:** The `listget...`, `chosenIndex...`, and `initialFieldValueslocationID...` variables recover the location occupying each position. Additional lookup-index variables implement the generated list-access operations.
- **Travel costs:** The `mapget...` variables retrieve depot costs and consecutive-location costs from fixed tables. Further index variables identify the corresponding table entries.
- **Accumulated travel time:** Thirteen `binop...` expressions accumulate travel costs after the first visit.
- **Arrival times:** Fourteen `expectedArrivalTime...` variables recover the accumulated travel time at each location. Seven inequalities require the second member of each pair to have an arrival time at least as large as the first.

The model contains 156 independently declared scalar integer variables and 14 additional scalar variables defined by expressions, including the objective. Most constraints implement `element` lookups and implications governing lookup indices. The objective minimizes the final accumulated arrival time plus the return-to-depot cost.

## Reformulation and justification

### 1. Simplify generated lookups

The reformulation replaces identity and offset tables with affine equalities. For example, the original tables imply that, at each route position,

- the list identifier equals the location identifier plus 5;
- the chosen index equals the location identifier minus 1;
- the mapped row identifier equals the location identifier plus 30.

These are exact replacements because the original tables contain consecutive integers with those offsets.

The more complicated list lookups also simplify exactly. The `all_different` constraint on 14 variables with 14 possible values makes the visit-position assignment a permutation. Thus each requested position occurs exactly once. The original lookup implications exclude the fallback entry and force selection of that unique occurrence. Consequently, the list lookup index is the selected location identifier plus 1.

Every location likewise appears exactly once in the resulting route. Its arrival-time lookup index is therefore its zero-based visit position plus 2, accounting for the initial fallback entry. Finally, the row-major travel-table index is exactly
\[
14(\text{origin location}-1)+\text{destination location}.
\]

These substitutions remove unnecessary lookup machinery without changing its meaning.

### 2. Introduce a binary assignment formulation

A binary node–position matrix now assigns each location to one route position. Every row and every column sums to one. Weighted sums recover both the original `chooseOrder...` variables and the location at each position.

This is equivalent to the original permutation: every original route produces one such assignment matrix, and every integral assignment matrix produces a unique route.

### 3. Introduce directed arcs and eliminate subtours

Binary directed-arc variables indicate consecutive visits, including depot departure and return. Each vertex has exactly one incoming and one outgoing arc; self-arcs are prohibited. Depot arcs are linked to the first and last assigned locations.

For a selected arc between two locations, linear big-M constraints require the destination’s visit position to equal the origin’s position plus one. These constraints eliminate customer-only subtours: following a cycle would require positions to increase strictly and then return to their starting value. Together with the degree constraints, this yields one depot-to-depot route through all locations.

This replaces much of the generated lookup structure with explicit MILP constraints suitable for HiGHS.

### 4. Preserve travel times through linear linking constraints

Selected customer arcs enforce the corresponding travel-time difference between arrival times. Assignment-based linking constraints equate each location’s arrival time with the original cumulative expression at its assigned position.

The first cumulative time is the selected depot departure cost. Therefore, these equalities force every subsequent cumulative increment—and hence every original inter-location `mapget...` variable—to equal the correct matrix entry.

The big-M constants use the valid arrival-time upper bound of 279: at most 19 units for departure and thirteen customer-to-customer legs of at most 20 units each.

### 5. Add valid precedence and objective strengthening

All off-diagonal customer travel times are strictly positive. Since each location is visited exactly once and cumulative times contain only travel, arrival times increase strictly along the route. The original arrival-time ordering for each pair therefore implies strict visit-position ordering.

This justifies the added position inequalities and the exclusion of:

- a direct arc from a pair’s second member to its first;
- depot departure directly to a second member;
- return to the depot directly from a first member.

Additional arrival-time bounds follow from the number of preceding legs and the minimum and maximum fixed travel times.

An arc-weighted expression for total route cost is also equated to the original objective. Both expressions sum the same departure, consecutive-visit, and return costs, so this is a redundant equality intended to strengthen the MILP relaxation.

## Interface preservation

All original independent scalar variables remain in the model, with their original meanings and names. The mapping script copies exactly those variables from the solver’s default DZN solution, excludes reformulation auxiliaries and originally defined expressions, and reports missing fields rather than supplying defaults.

The reformulation preserves the fixed travel data and minimization objective. Its intended benefit is a more explicit linear formulation for HiGHS; no measured runtime improvement is established here.
