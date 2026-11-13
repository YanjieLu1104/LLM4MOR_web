## Problem background

The model represents a **scenario-based vehicle-routing problem** with two vehicles, six customers, and three travel-time scenarios. Each customer requires a fixed service time. Travel times differ between scenarios, but each customer must be assigned to the same vehicle in every scenario; the order in which that vehicle visits its customers may change.

This structure can represent planning under uncertain traffic conditions: customer-to-vehicle assignments are chosen jointly, while routes adapt to the realized scenario. The model contains no vehicle-capacity or demand constraints. Instead, all arrival times must lie between 0 and 50.

The objective minimizes a weighted sum of scenario completion times, with weights **3, 2, and 2**. These weights express relative importance; the model does not explicitly define them as probabilities.

## Original formulation

### Variables

There are ten nodes: six customers, two start-depot copies, and two end-depot copies. The original model declares **101 integer decision variables**:

| Variable | Count | Meaning |
|---|---:|---|
| `successor` | 30 | Next node in each scenario |
| `predecessor` | 30 | Previous node in each scenario |
| `vehicle` | 10 | Vehicle associated with each node, shared across scenarios |
| `arrivalTime` | 30 | Arrival time at each node in each scenario |
| `objective` | 1 | Weighted scenario makespan |

### Constraints

For each scenario, successor and predecessor variables are mutual inverses, and both arrays satisfy a circuit constraint. Thus, the original formulation contains **six circuit constraints**.

The single circuit encodes two vehicle routes using fixed artificial connectors: each end depot connects to the next vehicle’s start depot, with the last end depot connecting back to the first start depot. Start and end depot copies have fixed vehicle labels.

For every customer, its predecessor and successor must have the same vehicle label as the customer. These constraints ensure consistent vehicle assignment along customer-containing routes.

All start-depot arrival times equal zero. On arcs leaving customers or start depots, arrival times satisfy
\[
a_j \ge a_i+s_i+d_{ij},
\]
where \(s_i\) is service time and \(d_{ij}\) is scenario-specific travel time. No time propagation is imposed on the artificial end-to-start connectors, so each vehicle’s route starts on its own clock. Waiting is permitted because these are inequalities rather than equalities.

### Objective

The model minimizes
\[
\sum_{s=1}^{3} w_s\max_{i\in NODES} a_{s,i}.
\]

This is a weighted sum of scenario makespans, not total travel distance or total vehicle operating time.

## Reformulation and justification

### 1. Binary-arc formulation and linear channeling

The reformulation introduces binary variables indicating whether each directed arc is selected. Every node has exactly one outgoing and one incoming arc.

The original successor and predecessor variables are retained and linked to these arcs by weighted sums of destination and origin indices. With binary arcs and unit degree constraints, these sums identify the unique successor and predecessor exactly. Consequently, the original inverse relationships are enforced without variable-index lookups.

This representation exposes the routing structure directly to the HiGHS mixed-integer programming backend.

### 2. Removal of impossible arcs

The allowed-arc structure excludes:

- **Self-loops**, which are forbidden by the original circuit constraints.
- **Nonfixed arcs leaving end depots or entering start depots**, because the original fixed connectors and inverse relationships already determine those connections.
- **Arcs directly from a start depot to the other vehicle’s end depot.** With the fixed two-vehicle connector pattern, such an arc would immediately return to the same start depot, creating a two-node cycle. That contradicts the original requirement for one circuit containing all ten nodes.

A start depot may still connect directly to its own end depot, preserving the possibility of an unused vehicle.

The last reduction relies specifically on the supplied model’s fixed two-vehicle structure; it is not asserted as a general rule for arbitrary fleet sizes.

### 3. Linear vehicle and time implications

Vehicle consistency is imposed on selected route arcs using linear big-\(M\) inequalities. Since vehicle labels lie in \(\{1,2\}\), the largest possible label difference is one, giving an exact deactivation bound.

Time propagation is also expressed using linear big-\(M\) inequalities. The constants follow from the original arrival-time bounds: customer arrival times are at most 50, destination arrival times are nonnegative, and start-depot arrival times are fixed at zero. Thus, selected arcs enforce the original timing inequality, while unselected arcs impose no additional restriction.

### 4. Elimination of explicit circuit constraints

The replacement preserves connectivity for this instance:

1. Unit incoming and outgoing degrees partition the nodes into directed cycles.
2. A customer-only cycle is impossible: summing its time inequalities would require a strictly positive total service-and-travel duration to be nonpositive. All customer service times are positive and all supplied travel times are nonnegative.
3. Every remaining route segment therefore runs from a start depot to an end depot.
4. Vehicle consistency forces every customer-containing segment to end at its own vehicle’s end depot. The allowed-arc preprocessing ensures the same for empty segments.
5. The original fixed end-to-start connectors join both vehicle segments into one circuit.

Therefore, explicit successor and predecessor circuit constraints are unnecessary in the reformulated integer model.

### 5. Customer-subset subtour cuts

For every customer subset \(S\) with at least two members, the reformulation adds
\[
\sum_{i\in S}\sum_{\substack{j\in S\\j\ne i}}x_{s,i,j}
\le |S|-1.
\]

These inequalities are valid because the original single circuit cannot contain a separate cycle entirely within a customer subset. They are redundant for integer solutions under the preceding connectivity argument, but can strengthen the linear relaxation by excluding fractional solutions with excessive internal customer arcs.

### 6. End-depot makespans and workload cuts

The scenario makespan is computed over end depots only. This is exact: every customer lies on a route ending at an end depot, and the timing inequalities ensure that arrival times do not decrease along that route. Start-depot times are zero. Hence, the maximum over all nodes equals the maximum over end depots.

An additional workload inequality requires
\[
2M_s \ge
\text{total service time}
+\text{total selected route travel time}.
\]
To justify it, sum the timing inequalities along each vehicle route. Since both routes start at time zero, each end-depot arrival bounds that route’s service and travel duration. Summing both bounds and using that each end-depot arrival is at most \(M_s\) yields the cut. Waiting does not invalidate it.

## Preservation and expected benefit

All embedded data, original decision-variable meanings, arrival-time bounds, objective values, and the minimization direction are preserved. The mapping script directly copies the five original variable fields, retaining their array indices.

The intended benefit is a more explicit MIP formulation with preprocessed arcs, bound-derived implication constants, and additional relaxation-strengthening inequalities. No measured runtime improvement is claimed; performance requires empirical comparison.
