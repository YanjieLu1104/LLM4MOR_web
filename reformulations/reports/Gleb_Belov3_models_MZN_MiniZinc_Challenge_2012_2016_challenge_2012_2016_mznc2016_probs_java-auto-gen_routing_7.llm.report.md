# Routing with Seven Pickup–Delivery Pairs

## Problem background

The model represents a single vehicle that starts at a depot, visits 14 distinct stops, and returns to the depot. The stops form seven pickup–delivery pairs: `(40, 43)`, `(46, 49)`, …, `(76, 79)`. Each pickup must be visited before its corresponding delivery.

Travel times are supplied for every pair of stops and between the depot and each stop. The objective is to **minimize the total route duration**. The model contains no vehicle-capacity constraints, service durations, waiting decisions, or explicit time windows. Thus, it is a precedence-constrained traveling-salesperson problem rather than a capacitated vehicle-routing problem.

## Original formulation

### Variables and constraints

The main routing decisions are:

- `chooseOrderIndex_2`: 14 integer variables in `1..14`, constrained by `alldifferent` to form a permutation.
- `chooseOrderVal_2`: 14 stop identifiers, obtained by indexing the fixed array `valuesToOrder_2` with that permutation.

The remaining formulation is largely automatically generated lookup machinery:

- Stop identifiers are translated into location indices.
- Location indices are translated into row identifiers for the travel-time table.
- Consecutive locations select travel times through flattened table indices.
- Cumulative-time variables add the initial depot leg and each subsequent travel leg.
- Arrival-time lookups recover the cumulative time at each pickup and delivery.
- Numerous selector variables have singleton domain `1..1`, so their associated lookups simply copy another variable.

Seven Boolean variables, named `Greater_...`, indicate whether a pickup arrival time exceeds its delivery arrival time. Their negations are conditionally enforced through an eight-element integer permutation, `prev`.

### Objective

The integer variable `objective` equals the final cumulative travel time plus the return-to-depot travel time. It has declared domain `2..300` and is minimized.

The original search annotation repeatedly searches the route arrays and then searches the lookup auxiliaries. These annotations do not change the feasible set or objective.

## Preprocessing and its justification

### Resolving the control permutation

The original constraints force `prev` to a unique value:

\[
[8,7,1,6,3,2,5,4].
\]

This follows directly from `prev[1] = 8`, the restricted domains of the other entries, and `alldifferent(prev)`:

1. Value 8 is already used, so `prev[8] ∈ {4,8}` forces `prev[8] = 4`.
2. This forces `prev[4] = 6`, then `prev[6] = 2`.
3. In turn, `prev[2] = 7`, `prev[7] = 5`, and `prev[5] = 3`.
4. Finally, `prev[3] = 1`.

Consequently, all seven conditional pickup–delivery constraints are active. The reformulation enforces them directly.

### Eliminating deterministic lookups

The stop identifiers are distinct, and the route permutation visits each identifier exactly once. Therefore, each stop-to-location lookup has a unique result. Likewise, each location pair uniquely determines its flattened travel-table index and travel time.

The fallback entries appended to these tables cannot be selected: the original selector domains end before those entries. Singleton selectors are always 1 and therefore introduce no choice.

The arrival-time lookups are also deterministic. Each requested stop appears once in the route. The original lower-bound implications force the selector past its initial default entry to that stop’s route occurrence, and the lookup equality identifies that occurrence uniquely.

These facts permit removal of the lookup variables from the optimization model. The mapping script reconstructs their original values and indices from the selected route.

### Replacing time precedence with position precedence

Every travel time between distinct customer stops is strictly positive. Since the route is a permutation, consecutive stops are distinct, so cumulative arrival times strictly increase along the route.

It follows that the original condition

\[
\text{arrival at pickup}\leq \text{arrival at delivery}
\]

is equivalent to placing the pickup strictly earlier in the route. This justifies using visit positions instead of arrival-time comparisons.

## Reformulated MILP

### Arc representation

The new model introduces a depot node numbered 0 and binary variables \(x_{ij}\) indicating whether the vehicle travels directly from node \(i\) to node \(j\).

There are 225 declared binary arc entries for the 15 nodes, including diagonal entries fixed to zero. Each node has exactly one incoming and one outgoing selected arc. Fourteen bounded integer variables represent customer visit positions.

The objective is the linear expression

\[
\min \sum_{i,j} c_{ij}x_{ij},
\]

using the original travel-time data. A depot-rooted tour selects exactly the initial leg, the 13 customer-to-customer legs, and the return leg counted by the original objective.

### Subtour elimination and strengthening

Degree constraints alone allow disconnected cycles. The reformulation adds **lifted Miller–Tucker–Zemlin (MTZ) inequalities** for customer nodes:

\[
u_i-u_j+n x_{ij}+(n-2)x_{ji}\leq n-1,
\qquad i\ne j,\quad n=14.
\]

A selected customer arc forces an increase in visit position. Summing these inequalities around a customer-only cycle gives a contradiction, eliminating disconnected subtours. The reverse-arc term strengthens the standard MTZ formulation while remaining valid for consecutive positions on a tour.

Depot-linking bounds anchor the first customer at position 1 and the last customer at position 14. Additional bounds prevent other customers from taking those endpoint positions.

The model also includes **two-node and three-node subtour cuts**. A Hamiltonian tour cannot contain a closed cycle within a proper subset of nodes; hence, at most \(|S|-1\) arcs may have both endpoints in such a subset \(S\). These cuts strengthen the linear relaxation without excluding any valid route.

### Precedence-based arc fixing

For each pickup \(p\) and delivery \(d\), the model imposes \(u_p<u_d\) and fixes three incompatible arcs to zero:

- \(x_{0d}=0\): a delivery cannot be first, because its pickup must already have been visited.
- \(x_{p0}=0\): a pickup cannot be last, because its delivery must follow it.
- \(x_{dp}=0\): directly visiting a pickup after its own delivery violates precedence.

These are logical consequences of the original active precedence conditions, not additional routing assumptions.

## Expected effect and semantic preservation

The reformulation replaces repeated element lookups, implications, and auxiliary search variables with a compact linear mixed-integer formulation suited to HiGHS. Arc fixing reduces the search space, while lifted MTZ inequalities and small-subset cuts strengthen the relaxation.

Every feasible original route defines a feasible arc tour with the same objective value. Conversely, every feasible reformulated tour determines the original permutation, travel times, cumulative times, arrival lookups, and forced `prev` values. The supplied mapping script performs this reconstruction.

No shortest-path replacement or triangle-inequality assumption is used. The changes are intended to reduce solution time; no measured speedup was established in the conversation.
