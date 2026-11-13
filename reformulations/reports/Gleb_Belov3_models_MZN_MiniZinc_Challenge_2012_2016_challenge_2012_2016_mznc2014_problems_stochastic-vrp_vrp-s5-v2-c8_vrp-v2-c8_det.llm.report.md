## Problem background

The model represents a small **scenario-based vehicle-routing problem** with two vehicles, eight customers, and five travel-time scenarios. Each customer requires a fixed service time. Travel times vary by scenario, but customer-to-vehicle assignments must remain the same across scenarios; each vehicle’s visiting order may adapt to the scenario.

Each vehicle has separate start- and end-depot nodes, giving 12 nodes in total. Start times are zero, and all arrival times must lie between 0 and 70. Waiting is permitted because travel-time constraints are inequalities rather than equalities.

The objective minimizes the weighted sum of scenario completion times, using weights \([3,2,2,1,1]\). These are unnormalized scenario weights; the model does not explicitly declare probabilities.

## Original formulation

### Variables

The original model contains **193 integer decision variables**:

| Variables | Count | Meaning |
|---|---:|---|
| `successor` | 60 | Next node in each scenario |
| `predecessor` | 60 | Previous node in each scenario |
| `vehicle` | 12 | Vehicle associated with each node, shared across scenarios |
| `arrivalTime` | 60 | Scenario-specific arrival times |
| `objective` | 1 | Weighted sum of scenario makespans |

### Constraints

For every scenario, successor and predecessor arrays are mutually inverse. Both arrays also satisfy a circuit constraint, giving ten circuit constraints overall.

Fixed artificial connections join the first vehicle’s end depot to the second vehicle’s start depot, and the second vehicle’s end depot to the first vehicle’s start depot. Thus, one circuit encodes both vehicle routes. Travel-time inequalities do **not** apply to these artificial connections, allowing each vehicle to start at time zero independently.

Depot vehicle labels are fixed. Each customer must have the same vehicle label as its predecessor and successor. Consequently, vehicle labels propagate along customer-containing routes.

For every customer and start depot, the successor’s arrival time must be at least the current arrival time plus service time and travel time. The objective is constrained to equal
\[
\sum_{s=1}^{5} w_s \max_{i\in NODES} t_{s,i},
\]
and is minimized. Its original domain, \(0\ldots1050\), is retained.

## Reformulation and justification

The reformulation replaces variable-indexed routing constraints with a **binary-arc mixed-integer linear formulation** intended for HiGHS. All original decision variables remain available through explicit constraints, preserving their meanings and allowing direct solution mapping.

### 1. Arc preprocessing

A binary variable represents whether an arc is selected in a scenario. Impossible arcs are fixed to zero:

- **Self-arcs are excluded** because the original circuit constraints require one circuit through all 12 nodes.
- **End-depot outgoing arcs are restricted to their original fixed connections.**
- **Customer and start-depot arcs cannot enter start depots.** In the original model, each start depot already has its predecessor fixed to a particular end depot. The inverse and circuit constraints guarantee exactly one incoming arc, excluding every other incoming connection.

These exclusions follow from the original routing constraints, not from additional geographic or travel-time assumptions.

### 2. Degree equations and successor/predecessor channeling

Every node receives exactly one selected incoming arc and one selected outgoing arc. The original successor variable equals the destination index of its selected outgoing arc; the predecessor variable equals the origin index of its selected incoming arc.

The degree equations define a permutation, and these channeling equations make the predecessor and successor arrays its two inverse representations. They therefore replace the original variable-indexed inverse constraints exactly.

### 3. Single-circuit enforcement using order variables

Degree equations alone permit disconnected cycles. To exclude them, the reformulation introduces bounded node-order variables, fixes one start depot as the root, and requires order to increase along every selected arc except an arc entering the root.

A cycle that avoids the root would require a strict increase all the way around that cycle, which is impossible. Since the degree equations partition the nodes into cycles, only one cycle can remain.

Conversely, any original circuit admits feasible order values by numbering its nodes from the root. This standard **Miller–Tucker–Zemlin-style subtour-elimination construction** therefore replaces both circuit constraints in each scenario without excluding original routes.

### 4. Linear travel-time and vehicle-continuity constraints

Variable-indexed constraints are replaced by arc-conditional linear inequalities.

For a potential timed arc \(i\to j\), the travel-time constraint uses
\[
t_{s,j}\ge t_{s,i}+q_i+d_{s,i,j}
-\bigl(70+q_i+d_{s,i,j}\bigr)(1-x_{s,i,j}).
\]

When the arc is selected, this is the original timing inequality. Otherwise, its right-hand side becomes \(t_{s,i}-70\le0\), so the arrival-time bounds make it redundant.

For arcs incident to a customer, paired inequalities impose equal vehicle labels when selected. Their relaxation constant is the full vehicle-label range, \(2-1=1\), so unselected arcs impose no additional restriction. These constraints reproduce the original customer predecessor/successor label equalities.

### 5. End-depot makespan representation

The scenario makespan is computed only over end-depot arrival times.

This is exact for the supplied fixed data: service and travel times are nonnegative, and every customer lies on a path terminating at an end depot. The timing inequalities therefore make that end depot’s arrival time at least the customer’s arrival time. Start depots have arrival time zero, while end-depot times are nonnegative. Hence the maximum over all nodes equals the maximum over end depots.

The objective remains an **equality** to the weighted makespans, not merely a lower bound. This preserves its value even for feasible solutions that are not optimal.

### 6. Route-duration strengthening cut

For each scenario, an additional inequality bounds total selected travel and service time by the sum of end-depot arrival times.

To see its validity, sum the original timing inequalities along each start-to-end route. Intermediate arrival times cancel, and the start time is zero. Each route’s accumulated travel and service duration is therefore at most its end-depot arrival time. Summing over both routes gives the added inequality.

This is a redundant valid cut: it preserves feasible solutions while potentially strengthening the linear relaxation.

## Interface and computational intent

The fixed instance data, original variable domains, objective direction, and external binding interface are preserved. No vehicle-symmetry restriction or assumption of shortest-path travel times is introduced.

The accompanying mapping script copies only the five original variable declarations from the emitted solution, preserving their array encodings and rejecting missing values.

The intended benefit is a more explicit, constant-coefficient MILP formulation with fewer variable-indexed operations and stronger aggregate timing information. No measured runtime improvement was established in this exchange.
