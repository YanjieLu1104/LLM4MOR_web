# Reformulation Report: Capacitated Vehicle Routing

## 1. Real-world interpretation

The model represents a transportation service in which vehicles visit customer stops to satisfy demand. Its structure is consistent with a **heterogeneous-fleet capacitated vehicle-routing problem**:

- There are **34 customer nodes**, numbered 1–34.
- Node **0** is the departure depot and node **35** is the return depot. They have identical travel-time profiles, suggesting two representations of the same physical depot.
- There are **10 vehicles**: five with capacity 15 and five with capacity 84. Each group also shares a common operating-cost coefficient.
- Each customer has a demand and a service duration.

Every customer must be served exactly once, and **every vehicle must operate a nonempty route**. The objective minimizes travel time weighted by the operating-cost coefficient of the assigned vehicle.

Although earliest and latest service-time parameters are supplied, their associated constraints are commented out. Thus, **the original model does not enforce explicit customer time windows**. Its active timing constraints nevertheless restrict routes, including through inequalities for unselected arcs.

## 2. Original mathematical structure

### Variables

The original formulation declares **13,330 variables**:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k]` | Vehicle \(k\) travels from node \(i\) to node \(j\) | Binary | 12,960 |
| `Y[k]` | Vehicle \(k\) is activated | Binary | 10 |
| `W[i,k]` | Service-start time at node \(i\) for vehicle \(k\) | Nonnegative continuous | 360 |

`X` is declared over all ordered node pairs, although only 1,190 pairs belong to the routing adjacency sets. The activation variables `Y` do not appear in any active constraint or in the objective.

### Objective

The model minimizes
\[
\sum_{i,j,k} c_k\,t_{ij}\,X_{ijk},
\]
where \(t_{ij}\) is travel time and \(c_k\) is the vehicle-specific cost coefficient. There is no active fixed vehicle-activation cost.

### Constraints

There are **12,304 active constraints**, excluding variable bounds:

| Family | Function | Count |
|---|---|---:|
| `R2` | Exactly one outgoing selected arc across all vehicles for each customer | 34 |
| `R3` | Exactly one departure from node 0 per vehicle | 10 |
| `R4` | Vehicle-specific flow conservation at each customer | 340 |
| `R5` | Exactly one arrival at node 35 per vehicle | 10 |
| `R6` | Service-time propagation on permitted arcs | 11,900 |
| `R9` | Vehicle capacity | 10 |

Together, `R2` and `R4` ensure that each customer has one incoming and one outgoing selected routing arc, both belonging to the same vehicle. On a selected arc, `R6` requires
\[
W_{jk}\ge W_{ik}+s_i+t_{ij}.
\]
Summing these inequalities around a customer cycle would require its total service and travel time to be nonpositive. Since customer service durations are strictly positive in this instance, such cycles are impossible. Consequently, the selected routing arcs form depot-to-depot routes rather than disconnected customer tours.

## 3. Reformulation and validity

### 3.1 Compact representation of the fixed adjacency sets

The enumerated predecessor and successor sets were replaced by equivalent set expressions. These reproduce exactly the supplied memberships: departures go from node 0 to customers, customers connect to other customers or node 35, and node 35 has no outgoing routing arcs.

This is a representation change only. It preserves node identities, permitted arcs, and all instance values.

### 3.2 Fixing unused arc variables: objective-dominance preprocessing

The **1,060 `X` variables outside the routing adjacency** were retained but given upper bounds of zero.

For the supplied adjacency sets, these variables appear in none of `R2`–`R6` or `R9`. Their only possible contribution is to the objective, with nonnegative coefficient \(c_k t_{ij}\). Therefore, changing any such variable from one to zero:

1. leaves every original constraint unchanged; and
2. cannot increase the minimization objective.

This reduction preserves at least one optimum. It can remove alternative optimal assignments on zero-cost unused arcs, but those assignments have no routing effect.

### 3.3 Capacity-based arc fixing

A permitted arc \((i,j)\) for vehicle \(k\) was fixed to zero whenever
\[
d_i+d_j>Q_k.
\]

For a customer-to-customer arc, selecting `X[i,j,k]` makes vehicle \(k\) serve both endpoints: the arc contributes an outgoing visit at \(i\), and `R4` requires an outgoing visit at \(j\). Hence `R9` must count both customer demands. Because all other demand contributions are nonnegative, exceeding \(Q_k\) with these two customers alone makes the arc impossible.

For depot-adjacent arcs, the same test is valid because both depot demands are zero. This is **capacity-based variable fixing**, not a time-window inference.

### 3.4 Customer-pair capacity cuts

For each vehicle and each customer pair whose combined demand exceeds its capacity, the reformulation adds
\[
\sum_{h\in DESTINO[i]}X_{ihk}
+
\sum_{h\in DESTINO[j]}X_{jhk}
\le 1.
\]

By `R2` and binary `X`, each sum indicates whether that vehicle serves the corresponding customer. If both indicators were one, their contribution alone would violate `R9`. These are **two-customer knapsack-cover inequalities**.

Unlike arc fixing, these cuts prohibit assigning the incompatible customers to the same vehicle even when they are not consecutive. They can strengthen the linear relaxation.

### 3.5 Aggregated two-cycle elimination cuts

For every unordered customer pair, the reformulation adds
\[
\sum_k\left(X_{ijk}+X_{jik}\right)\le 1.
\]

Both directions cannot be selected by different vehicles: `R2` and vehicle-specific flow conservation `R4` would force each customer’s incoming and outgoing arcs onto the same vehicle. Selecting both directions on that vehicle is also impossible, because summing the two corresponding `R6` inequalities gives
\[
s_i+t_{ij}+s_j+t_{ji}\le 0,
\]
contradicting the positive total duration.

The resulting **561 two-cycle cuts** express a consequence of the integer model directly, strengthening a relaxation in which the big-\(M\) timing constraints may enforce it weakly.

### 3.6 Symmetry breaking among identical vehicles

Eight ordering constraints require increasing first-customer indices between adjacent vehicles within each identical-vehicle group.

Vehicles in a group have the same capacity and cost coefficient, and all other model coefficients are vehicle-independent. Permuting their complete `X`, `W`, and `Y` assignments therefore preserves feasibility and objective value.

Moreover, `R3` selects exactly one first customer per vehicle, and `R2`–`R4` prevent two vehicles from sharing that customer. Thus, routes within each group can always be relabeled into strictly increasing first-customer order. This **vehicle-label symmetry breaking** retains an optimal representative while reducing equivalent search branches.

## 4. Preservation and expected impact

All original variables remain, so the solution-mapping script copies their values unchanged. Every original timing inequality and supplied big-\(M\) value is retained; the inactive time-window constraints are not introduced.

The intended improvements are fewer effective binary choices, a stronger linear relaxation, and less branching over interchangeable vehicles. These are formulation-based expectations; **no measured runtime improvement or solver benchmark was established in the conversation**.
