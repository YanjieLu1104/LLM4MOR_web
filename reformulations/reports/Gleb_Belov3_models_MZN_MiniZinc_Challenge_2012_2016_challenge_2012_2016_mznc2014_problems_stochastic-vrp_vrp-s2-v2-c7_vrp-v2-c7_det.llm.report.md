## Problem background

The model represents a **two-scenario vehicle-routing problem** with two vehicles and seven customers. Each customer requires a fixed service time, while travel times differ between scenarios. The vehicle assigned to each customer must be the same in both scenarios, but each vehicle’s visiting order may change.

This structure can be interpreted as planning customer assignments before travel conditions are known, then adapting routes to the realized scenario. The scenario weights are 3 and 2; the model does not explicitly define them as probabilities.

Each vehicle has a separate start-depot node and end-depot node, giving 11 nodes in total. Artificial links connect one vehicle’s end depot to the next vehicle’s start depot, forming a single circuit that encodes both routes. These linking arcs do not carry time-propagation constraints, allowing each vehicle to start at time zero. All arrival times must lie between 0 and 60. There are no capacity or customer-demand constraints.

## Original formulation

### Decision variables

The original model contains **78 integer decision variables**:

| Variable | Count | Meaning |
|---|---:|---|
| `successor` | 22 | Next node for each node and scenario |
| `predecessor` | 22 | Previous node for each node and scenario |
| `vehicle` | 11 | Vehicle associated with each node, shared across scenarios |
| `arrivalTime` | 22 | Arrival time at each node and scenario |
| `objective` | 1 | Weighted sum of scenario makespans |

### Constraints

The model imposes:

- **Fixed depot connections:** artificial end-to-start links join the two vehicle routes into a circuit.
- **Fixed depot assignments and departure times:** depot nodes belong to their corresponding vehicles, and start-depot arrival times are zero.
- **Inverse relationships:** successor and predecessor arrays must describe mutually inverse permutations.
- **Four circuit constraints:** one successor circuit and one predecessor circuit per scenario.
- **Vehicle consistency:** a customer and its predecessor and successor must have the same vehicle assignment.
- **Time propagation:** an arc leaving a customer or start depot must allow enough time for service at its source and travel to its destination.

Time propagation uses inequalities, so waiting is permitted.

### Objective

The model minimizes

\[
\sum_{s=1}^{2} w_s \max_{i\in NODES} a_{s,i},
\]

where \(a_{s,i}\) is the arrival time and \(w_1=3,\;w_2=2\). Thus, the objective measures weighted scenario completion times rather than total travel distance.

## Reformulation and justification

The reformulation replaces circuit and variable-index expressions with an explicit **mixed-integer linear arc formulation**, intended to suit the HiGHS backend. It retains the original decision variables, domains, fixed data, and exact objective.

### 1. Binary arcs and linear channeling

A binary variable \(x_{s,i,j}\) indicates whether scenario \(s\) uses arc \(i\to j\). Each node has exactly one outgoing and one incoming arc.

The original variables are connected to these arcs by

\[
successor_{s,i}=\sum_j jx_{s,i,j},
\qquad
predecessor_{s,j}=\sum_i ix_{s,i,j}.
\]

**Why this is valid:** the degree equations select exactly one destination and one source at each node. Consequently, the channeling equations define mutually inverse successor and predecessor permutations. They replace the original inverse constraints without changing their meaning.

### 2. Arc preprocessing

The formulation fixes the following arcs to zero:

- **Self-loops.** An original circuit visits all 11 nodes, so no node can be its own successor.
- **Arcs conflicting with fixed depot links.** A fixed successor at an end depot excludes every other outgoing arc there. A fixed predecessor at a start depot excludes every other incoming arc there.
- **Time-infeasible arcs.** For an arc subject to time propagation, if service time plus travel time exceeds 60, the arc is impossible: its source arrival is nonnegative, whereas its destination arrival cannot exceed 60.

These exclusions follow directly from the original circuit, fixed-link, and arrival-time constraints. They do not require additional routing assumptions.

### 3. Directed subtour-elimination cuts

Degree equations alone permit multiple disjoint cycles. The reformulation therefore adds directed connectivity cuts:

\[
\sum_{i\in S,\;j\notin S}x_{s,i,j}\ge 1.
\]

**Why this is valid:** a single circuit must leave every nonempty proper subset of nodes.

The cut enumeration omits three redundant classes:

- **Singleton subsets:** self-loop exclusion and the outgoing-degree equation already guarantee an outgoing arc.
- **Subsets containing one designated node:** any disconnected cycle cover has a cycle that does not contain that node, so the remaining cuts still detect disconnection.
- **Subsets already crossed by a fixed depot arc:** their outgoing-cut inequality is automatically satisfied.

Together with the degree equations, the retained cuts enforce one circuit per scenario. The predecessor circuit then follows because the predecessor permutation is the inverse of that circuit.

### 4. Linear vehicle-consistency constraints

For each admissible arc touching a customer, paired big-M inequalities enforce

\[
x_{s,i,j}=1 \;\Longrightarrow\; vehicle_i=vehicle_j.
\]

**Why this is valid:** these are exactly the original predecessor- and successor-based vehicle equalities expressed through arcs. When an arc is unused, the inequalities are redundant because vehicle identifiers differ by at most \(nbVehicles-1\).

### 5. Bound-derived time implications

For each admissible arc leaving a customer or start depot, time propagation becomes

\[
a_{s,i}+d_{s,i,j}
\le a_{s,j}+M_{s,i,j}(1-x_{s,i,j}),
\]

where \(d_{s,i,j}\) includes service and travel time. The formulation uses

\[
M_{s,i,j}=U_i+d_{s,i,j},
\]

with \(U_i=0\) at start depots and \(U_i=60\) elsewhere.

**Why this is valid:** a selected arc reproduces the original time inequality. For an unused arc, the inequality follows from \(a_{s,i}\le U_i\) and \(a_{s,j}\ge0\). Using the fixed zero departure times yields tighter coefficients for start-depot arcs.

## Solution compatibility and expected benefit

All five original decision-variable groups remain available under their original names. The mapping script copies these values unchanged and excludes auxiliary arc variables.

The intended benefit is a more explicit linear formulation: degree equations, connectivity cuts, and bound-derived implications replace global circuits and variable-index expressions. This may improve HiGHS performance, although no measured runtime improvement was established. Enumerating connectivity cuts is practical for this 11-node model; the approach would require reconsideration for substantially larger instances because the number of subsets grows exponentially.
