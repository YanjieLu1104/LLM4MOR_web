# Vehicle-Routing Model: Structure and Reformulation Report

## 1. Real-world interpretation

The model represents a **capacitated vehicle-routing problem with service-time restrictions**. A fleet of ten vehicles serves 34 customers, starting at node 0 and returning through node 35. The identical travel times associated with these two depot nodes suggest that they represent departure and return copies of the same physical location.

Each customer has a demand and a service duration. Vehicles have capacity limits and travel-cost coefficients: five vehicles have capacity 15, and five have capacity 84. The objective is to minimize total travel cost while serving every customer.

The implemented formulation differs from a conventional optional-fleet routing model in several important respects:

- **Every vehicle must operate:** each must leave node 0 and enter node 35 exactly once.
- Upper service-time bounds are imposed only at nodes 0–10, despite upper-bound data being supplied for all nodes.
- Time-propagation inequalities remain active, in relaxed form, even when an arc is not selected. Their supplied big-\(M\) values therefore affect feasibility.

These features were preserved rather than replaced with presumed intended behavior.

## 2. Original mathematical structure

### Variables

The original model declares:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k]` | Vehicle \(k\) travels from node \(i\) to node \(j\) | Binary | 12,960 |
| `Y[k]` | Vehicle \(k\) is used | Binary | 10 |
| `W[i,k]` | Service-start time at node \(i\) for vehicle \(k\) | Nonnegative continuous | 360 |

`X` is declared for every ordered node pair, although routing constraints use only the supplied adjacency sets. `Y` has no effect because its linking constraint is commented out.

### Objective

The model minimizes
\[
\sum_{i,j,k} c_k\,t_{ij}\,X_{ijk},
\]
where \(c_k\) is a vehicle-specific cost coefficient and \(t_{ij}\) is travel time. There is no active fixed vehicle-use charge.

### Constraints

The original model contains **12,774 active indexed constraints**, excluding variable bounds and integrality restrictions:

- **R2 — Customer assignment:** 34 constraints requiring exactly one departure from each customer across all vehicles.
- **R3 and R5 — Depot departures and returns:** 20 constraints requiring every vehicle to depart and return once.
- **R4 — Customer flow conservation:** 340 constraints balancing arrivals and departures by vehicle.
- **R6 — Time propagation:** 11,900 inequalities of the form
  \[
  W_{ik}+s_i+t_{ij}-W_{jk}\le M_{ij}(1-X_{ijk}).
  \]
- **R7 — Conditional earliest service times:** 360 constraints.
- **R8 — Conditional latest service times:** 110 constraints, applying only to nodes 0–10.
- **R9 — Vehicle capacities:** 10 constraints limiting total assigned demand.

In particular, R8 forces an unvisited customer among nodes 1–10 to have service time zero.

## 3. Reformulation and its justification

### Time-implication preprocessing

The reformulation derives mandatory customer-assignment implications directly from R6–R8.

For explanation, let
\[
z_{ik}=\sum_{j\in DESTINO[i]}X_{ijk}.
\]
This is not a new decision variable. For a customer, R2 and binary nonnegative `X` imply \(z_{ik}\in\{0,1\}\).

If vehicle \(k\) serves customer \(i\), R7 gives \(W_{ik}\ge a_i\). Since \(M_{ij}\ge0\), R6 implies
\[
W_{jk}\ge W_{ik}+s_i+t_{ij}-M_{ij}
          \ge a_i+s_i+t_{ij}-M_{ij}.
\]

Consequently, whenever
\[
a_i+s_i+t_{ij}>M_{ij},
\]
the same vehicle must have \(W_{jk}>0\). For a customer \(j\le10\), R8 makes this impossible unless that vehicle also serves \(j\).

The introduced set `ns5260836_forced[i]` records precisely these directly implied customers.

### Capacity-based assignment elimination

If customer \(i\) and its implied customers have combined demand exceeding \(Q_k\), vehicle \(k\) cannot serve \(i\). Otherwise, the implications above would force demand exceeding R9’s capacity limit.

The added constraints therefore impose
\[
\sum_{j\in DESTINO[i]}X_{ijk}=0
\]
for each such customer–vehicle combination. This is **logical implication preprocessing followed by a capacity infeasibility test**. It introduces no assumption about omitted time windows or intended routing behavior.

### Infeasibility certificate for this instance

For customer 34, \(a_{34}=6\) and \(s_{34}=0.5\). For every customer \(j=1,\ldots,10\), the supplied data satisfy
\[
6+0.5+t_{34,j}>M_{34,j}.
\]

Thus, any vehicle serving customer 34 must also serve all ten of those customers. Their demand totals 92; customer 34 adds another unit, giving **93**, above the largest vehicle capacity of **84**.

The preprocessing consequently prohibits every vehicle from serving customer 34, contradicting R2. This proves that **the supplied original model is infeasible**. The reformulation exposes that contradiction through simple assignment constraints, allowing presolve to detect it without a routing search.

### Representation and preservation

The explicitly enumerated adjacency sets were replaced by compact set expressions with exactly the same membership for the supplied instance. All numerical data, original variables, objective terms, and original constraints were retained, including inactive-arc time restrictions. No additional upper time bounds were imposed.

Because the variable set is unchanged, the accompanying solution mapping is an identity mapping. The infeasibility conclusion follows from the mathematical argument above, not from a reported solver run.
