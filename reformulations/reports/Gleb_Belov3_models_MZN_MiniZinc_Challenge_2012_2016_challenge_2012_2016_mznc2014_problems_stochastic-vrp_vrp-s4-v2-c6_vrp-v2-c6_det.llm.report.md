# Scenario-Based Vehicle Routing Reformulation

## Problem background

The model represents a small vehicle-routing problem with uncertain travel times: **two vehicles serve six customers under four travel-time scenarios**. Each customer has a fixed service duration, and each scenario supplies a different travel-time matrix.

Customer-to-vehicle assignments are shared across scenarios, while route order and arrival times may differ. This suggests a two-stage planning interpretation: decide which vehicle serves each customer before the scenario is known, then adapt each vehicle’s route afterward. The model does not impose vehicle capacities or customer-specific time windows; all arrival times must lie between 0 and 50.

Scenario weights are `[3, 2, 2, 1]`. The objective minimizes the weighted sum of scenario completion times, where completion time is the latest arrival at any node. These weights need not be interpreted as probabilities.

## Original formulation

### Variables and route representation

The model contains **131 scalar integer decision variables**:

| Variable | Count | Meaning |
|---|---:|---|
| `successor` | 40 | Next node in each scenario |
| `predecessor` | 40 | Previous node in each scenario |
| `vehicle` | 10 | Vehicle associated with each node, shared across scenarios |
| `arrivalTime` | 40 | Arrival time at each node in each scenario |
| `objective` | 1 | Weighted sum of scenario makespans |

Each scenario has ten nodes: six customers, two vehicle-specific start depots, and two vehicle-specific end depots.

The two physical vehicle routes are represented as one artificial circuit. Fixed links connect vehicle 1’s end depot to vehicle 2’s start depot, and vehicle 2’s end depot to vehicle 1’s start depot. These connecting links are not subject to travel-time propagation.

### Constraints and objective

The original formulation uses:

- Fixed predecessor and successor relations for the artificial depot links.
- Fixed vehicle identities at start and end depots.
- Zero arrival times at start depots.
- Two inverse-channeling constraint families linking successors and predecessors.
- Eight circuit constraints: one successor circuit and one predecessor circuit per scenario.
- Vehicle-consistency constraints on both sides of every customer.
- Travel and service-time propagation from customers and start depots.
- An equality defining the weighted makespan objective.

For a selected physical arc \(i\to j\) in scenario \(s\), timing requires
\[
t_{s,j}\ge t_{s,i}+\operatorname{serviceTime}_i+d_{s,i,j}.
\]
Waiting is allowed because this is an inequality.

The minimization objective is
\[
\sum_{s=1}^{4}w_s\max_{i\in NODES}t_{s,i}.
\]

## Reformulation and validity

### 1. Binary arc formulation and linear channeling

The reformulation introduces binary arc variables \(x_{s,i,j}\), indicating whether scenario \(s\) uses arc \(i\to j\). Every node has exactly one incoming and one outgoing arc.

The original successor and predecessor variables are retained and linked by
\[
\operatorname{successor}_{s,i}=\sum_j jx_{s,i,j},
\qquad
\operatorname{predecessor}_{s,j}=\sum_i ix_{s,i,j}.
\]

Because each sum selects exactly one node, these equations preserve the original meanings and make the two arrays inverse permutations. This replaces variable-index channeling with linear equations more directly suited to HiGHS.

### 2. Structural arc preprocessing

Impossible arcs are fixed to zero:

- Each end depot can use only its original fixed link to a start depot.
- No other arc may enter a start depot, because its incoming arc is already fixed.
- Customer self-loops are forbidden by the original circuit requirement.
- A start depot may connect directly only to its corresponding end depot, or to a customer.

The last restriction is specific to this two-vehicle instance. A direct arc from one vehicle’s start depot to the other vehicle’s end depot would combine with a fixed end-to-start link to form a two-node cycle. The original circuit constraint forbids such a proper subcycle. Thus the restriction does not remove an originally feasible route.

### 3. Linear vehicle and timing implications

Vehicle equality along selected physical arcs is enforced by linear inequalities with coefficient `nbVehicles - 1`. This coefficient is sufficient because it bounds the difference between any two vehicle labels.

For arcs incident to a customer, equality follows directly from the original customer predecessor/successor constraints. For the remaining permitted start-to-end arcs, both depots already have the same fixed vehicle label.

Timing implications use
\[
t_{s,j}\ge t_{s,i}+q_{s,i,j}
 -(50+q_{s,i,j})(1-x_{s,i,j}),
\]
where \(q_{s,i,j}=\operatorname{serviceTime}_i+d_{s,i,j}\).

When the arc is selected, this is the original timing constraint. Otherwise, its right-hand side becomes \(t_{s,i}-50\), which is nonpositive, so it is redundant given the original arrival-time bounds.

### 4. Removal of circuit globals and addition of subtour cuts

Degree constraints alone permit several disjoint cycles. Here, the remaining original structure excludes them:

1. Every customer has strictly positive service time, and all supplied travel times are nonnegative. Summing timing inequalities around a customer-only cycle would imply that an arrival time is strictly greater than itself.
2. Consequently, each path leaving a start depot must eventually reach an end depot.
3. Vehicle consistency forces a path containing customers to reach the end depot of the same vehicle. The arc preprocessing also ensures this for empty routes.
4. The fixed artificial depot links join the two physical routes into one circuit.

Therefore, explicit successor and predecessor circuit globals are unnecessary.

The reformulation also adds **customer-subset subtour-elimination inequalities**:
\[
\sum_{i,j\in S,\ i\ne j}x_{s,i,j}\le |S|-1
\qquad(S\subseteq CUSTOMER,\ |S|\ge2).
\]
These are valid because a customer subset cannot contain a closed cycle in the original circuit. Although redundant for integer feasibility, they strengthen the linear relaxation.

### 5. Aggregate route-duration inequality

For each scenario, the total selected travel-plus-service duration is bounded above by the sum of arrival times at the two end depots.

This follows by summing timing inequalities along each physical route: intermediate arrival times cancel, and the start-depot arrival time is zero. Summing over both vehicles gives the added inequality. It remains valid when schedules contain waiting.

### 6. Smaller makespan expression

The maximum arrival time is computed over end depots rather than all nodes. Every customer lies on a path to an end depot, and timing propagation ensures that its arrival time is no greater than that end depot’s arrival time. Start-depot arrival times are zero.

Thus the maximum over all nodes equals the maximum over end depots for every feasible solution—not merely at optimality. The objective value and minimization direction are preserved exactly.

## Solution compatibility and expected benefit

All fixed instance data and original decision-variable names are preserved. The mapping script copies the five original variable fields without reconstructing routes or changing array indices; auxiliary arc variables are omitted.

The reformulation targets HiGHS by replacing circuit globals and variable-index expressions with an explicit mixed-integer linear representation, supplemented by structural arc fixing and valid inequalities. These changes are intended to improve relaxation strength and simplify compilation. No measured runtime improvement is established by the conversation.
