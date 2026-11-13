# Three-Scenario Vehicle Routing Reformulation

## Problem background

The model describes a small vehicle-routing problem with **two vehicles, seven customers, and three travel-time scenarios**. Each customer has a fixed service duration, while travel times depend on the scenario.

The structure represents a two-stage decision:

- Each customer is assigned to one vehicle, consistently across all scenarios.
- Each vehicle’s visiting order and arrival times may adapt to the scenario.

Each vehicle has a separate start-depot node and end-depot node, giving 11 nodes in total. Arrival times lie between 0 and 60, and both vehicles start at time zero. There are no vehicle-capacity constraints or customer-specific time windows.

The objective minimizes the weighted sum of scenario completion times, with weights **3, 2, and 2**. These are supplied weights, not explicitly normalized probabilities.

## Original formulation

### Variables

The original model declares **111 scalar integer decision variables**:

| Variable | Count | Meaning |
|---|---:|---|
| `successor` | 33 | Next node in each scenario |
| `predecessor` | 33 | Previous node in each scenario |
| `vehicle` | 11 | Vehicle associated with each node, shared across scenarios |
| `arrivalTime` | 33 | Arrival time at each node in each scenario |
| `objective` | 1 | Weighted sum of scenario makespans |

### Constraints

Each scenario is represented by one circuit containing all customer and depot nodes. Fixed artificial links connect the end depot of vehicle 1 to the start depot of vehicle 2, and the end depot of vehicle 2 back to the start depot of vehicle 1. Removing these links leaves the two vehicle routes.

The original constraints:

- Fix the artificial depot links and depot vehicle identities.
- Set start-depot arrival times to zero.
- Make predecessor and successor arrays mutual inverses.
- Require both arrays to describe Hamiltonian circuits.
- Enforce equal vehicle identities across every arc incident to a customer.
- Propagate arrival times along customer and start-depot departures, allowing waiting.

Timing constraints do not apply to the artificial end-to-start links, so the single circuit does not impose an impossible circular time progression.

The objective is
\[
\min \sum_{s=1}^{3} w_s\max_{i\in NODES} A_{s,i},
\]
where \(A_{s,i}\) denotes arrival time.

## Reformulation and validity

### Explicit binary arcs and linear channeling

The reformulation introduces binary variables \(x_{s,i,j}\) indicating whether scenario \(s\) uses arc \(i\to j\). Each node has exactly one outgoing and one incoming arc.

The original variables remain present and are connected by
\[
successor_{s,i}=\sum_j jx_{s,i,j},
\qquad
predecessor_{s,j}=\sum_i ix_{s,i,j}.
\]

Because each sum selects exactly one node, these equations preserve the original meanings and imply the inverse relationships. They replace variable-indexed expressions with linear constraints suitable for HiGHS.

### Structural arc preprocessing

The permitted arcs are restricted to:

- Customer-to-customer arcs between distinct customers.
- Start-depot-to-customer arcs.
- Customer-to-end-depot arcs.
- Direct start-to-end arcs for the same vehicle.
- The original fixed artificial end-to-start links.

These restrictions follow from the original constraints:

- Fixed end-depot successors and start-depot predecessors already exclude other departures from end depots and arrivals at start depots.
- Customer self-loops contradict the positive service durations and timing inequalities.
- A direct start-to-end arc for the *other* vehicle is impossible in this two-vehicle instance: the fixed artificial link immediately returns to that same start node, forming a separate two-node cycle and violating the original circuit constraint.

The last argument specifically uses the fixed two-vehicle structure.

### Circuit elimination through timing and vehicle consistency

Degree equations alone normally allow multiple cycles. Here, the remaining constraints rule them out:

1. A customer-only cycle is impossible. Summing its timing inequalities would require zero to be at least the sum of positive service durations and nonnegative travel times.
2. Consequently, every customer belongs to a path from a start depot to an end depot.
3. Vehicle-equality constraints along customer arcs force each nonempty path to end at the depot of its starting vehicle.
4. Empty routes also connect matching depots, by the arc preprocessing above.
5. The fixed artificial links join these two paths into one circuit.

Thus, both original circuit constraints can be removed without losing their required effect.

### Linear timing and vehicle implications

For each permitted routing arc, big-\(M\) inequalities enforce timing and vehicle consistency when the arc is selected. The constants follow from the original domains:

- Vehicle differences are bounded by \(nbVehicles-1\).
- Arrival times range from 0 to 60.
- Start-depot arrival times are fixed to zero, permitting smaller timing constants there.

When an arc is unselected, these bounds make its inequalities nonrestrictive.

### Valid strengthening inequalities

Two families of redundant inequalities strengthen the relaxation:

- **Aggregate route duration:** the sum of end-depot arrival times is at least total customer service time plus selected travel time. This follows by summing timing inequalities along both routes; intermediate arrival times cancel.
- **Per-vehicle service workload:** each vehicle’s end-depot arrival time is at least the service-time sum of its assigned customers. Travel and waiting are nonnegative. Since vehicle labels are exactly 1 and 2, assignment indicators can be expressed linearly as \(2-vehicle_i\) and \(vehicle_i-1\).

### Objective preservation and solution mapping

The maximum arrival time is taken only over end depots. This is exact: every customer precedes an end depot along a route with increasing arrival times, while start-depot times are zero.

All original decision variables, fixed data, and the minimization direction are retained. The mapping script copies the five original variable declarations from the solution and excludes auxiliary arc variables.

The intended benefit is a more direct and stronger MIP formulation for HiGHS; no measured runtime improvement is established here.
