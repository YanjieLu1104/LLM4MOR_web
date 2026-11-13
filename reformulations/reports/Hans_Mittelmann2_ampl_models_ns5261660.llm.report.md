# Reformulation Report: Capacitated Routing with Time Windows and Sequential Trips

## 1. Problem background

The model represents a **capacitated vehicle-routing problem with customer time windows**. Its apparent purpose is to assign customer visits to routes and minimize travel-related operating costs.

The supplied instance contains:
- **25 customers**, numbered 1–25;
- a departure depot, node **0**, and a return depot, node **35**;
- **10 indexed vehicle or trip slots**, with capacities of 15 for slots 1–5 and 84 for slots 6–10.

Each customer has a demand, service duration, and permitted service-start interval. A selected route must respect vehicle capacity and allow enough time for service and travel between consecutive stops.

The slot structure suggests that the model may represent **successive trips by two vehicle resources**, rather than ten fully independent vehicles. Within groups 1–5 and 6–10, a later slot cannot operate unless its predecessor operates, and its departure cannot precede the predecessor’s return. This interpretation is inferred from the constraints; the source does not explicitly identify the application.

## 2. Original mathematical formulation

### Variables

The original model declares **7,570 variables**:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k]` | Whether slot `k` uses the directed connection from `i` to `j` | Binary | 7,290 |
| `Y[k]` | Whether slot `k` operates | Binary | 10 |
| `W[i,k]` | Service-start time at node `i` for slot `k` | Continuous, nonnegative | 270 |

`X` is declared for every ordered node pair, although routing constraints primarily use arcs specified by `DESTINO` and `ORIGEN`. The reformulation retains this full variable domain, including entries outside the routing network.

### Objective

The model minimizes

\[
\sum_{i,j,k} c_k\,t_{ij}\,X_{ijk},
\]

where \(t_{ij}\) is travel time and \(c_k\) is the corresponding operating-cost coefficient. Despite the comment describing `c` as an operating cost, the implemented objective is **travel-time-weighted cost**, not a fixed charge for activating a slot.

### Constraints

The original model has **7,371 explicit constraints**, excluding variable bounds:

- **Customer assignment (`R2`):** each customer has exactly one selected outgoing routing arc across all slots.
- **Depot departure and return (`R3`, `R5`):** each active slot leaves the departure depot once and enters the return depot once.
- **Customer flow conservation (`R4`):** incoming and outgoing routing flow balance separately for each customer and slot.
- **Time propagation (`R6`):** selecting an arc requires the destination’s service start to follow service and travel at its origin. Supplied big-\(M\) coefficients relax this requirement when the arc is unused.
- **Time windows (`R7`, `R8`):** every `W[i,k]` lies between `a[i]` and `b[i]`, including times associated with unvisited customers.
- **Capacity (`R9`):** demand charged to selected outgoing routing arcs cannot exceed the slot capacity.
- **Activation (`R10`):** the number of selected routing arcs cannot exceed \(1000Y_k\).
- **Slot ordering and sequencing (`R11A`, `R11b`, `R12A`, `R12B`):** activation is ordered within the two groups, and consecutive trips cannot overlap.

## 3. Reformulation and validity

The reformulation retains all original decision variables, the supplied data, and the minimization objective. Its changes strengthen the formulation without excluding original integer-feasible solutions.

### Time-window constraints replaced by bounds

The inequalities in `R7` and `R8` are incorporated directly into the declaration of `W`.

This is equivalent because they impose exactly those lower and upper bounds. Since every `a[i]` is nonnegative, the original nonnegativity requirement is also preserved. This removes **540 explicit rows**, before counting newly added cuts.

### Bound-based big-\(M\) tightening

For each routing arc, the coefficient is replaced by

\[
\widehat M_{ij}
=
\min\left\{
M_{ij},
\max\{0,b_i+s_i+t_{ij}-a_j\}
\right\}.
\]

The time-window bounds imply

\[
W_{ik}+s_i+t_{ij}-W_{jk}
\le b_i+s_i+t_{ij}-a_j.
\]

Therefore, when `X[i,j,k] = 0`, any reduction to the bound-derived coefficient introduces no restriction beyond the variable bounds. When `X[i,j,k] = 1`, the right-hand side remains zero.

Importantly, the reformulation **never increases the original coefficient**. Some supplied coefficients are rounded and can impose restrictions even on unused arcs; replacing them unconditionally with a larger textbook coefficient could change the original feasible set.

### Infeasible-arc preprocessing

Routing arcs are fixed to zero when either:

- \(a_i+s_i+t_{ij}>b_j\): selecting the arc would contradict `R6` and the time windows; or
- \(d_i+d_j>Q_k\): selecting a customer-to-customer arc requires serving both endpoints in the same slot. By `R4`, the destination also has a selected outgoing arc, so `R9` charges both demands. Depot demands are zero, making the test valid for depot-adjacent arcs as well.

Only arcs in `DESTINO` receive these fixings.

### Stronger activation and capacity inequalities

Three related strengthenings are applied:

1. **Capacity becomes \(Q_kY_k\).**  
   When \(Y_k=1\), this is the original capacity constraint. When \(Y_k=0\), original `R10` already forces every routing arc to zero.

2. **The activation coefficient falls from 1000 to 26.**  
   `R2` permits at most one outgoing arc per customer in any slot, giving at most 25 customer-origin arcs. `R3` permits at most one departure-depot arc, and `DESTINO[35]` is empty. Thus an active slot uses at most 26 routing arcs.

3. **Customer-level activation inequalities are added.**  
   Each customer’s outgoing flow in a slot is bounded by `Y[k]`. For an active slot, this follows from `R2`; for an inactive slot, it follows from `R10`.

These inequalities more tightly link fractional route decisions to fractional activation values.

### Incompatible-customer cuts

If two customers’ combined demand exceeds a slot’s capacity, the sum of their visit indicators is bounded by `Y[k]`.

For an active slot, serving both would violate `R9`; for an inactive slot, `R10` prohibits either visit. These are **pairwise capacity-conflict cuts**.

### Two-customer subtour cuts

For each customer pair, the total selection of the two opposite arcs across all slots is bounded by one.

If both arcs belonged to different slots, `R4` and the unique-service requirement `R2` would be violated. If both belonged to the same slot, summing their `R6` inequalities would require

\[
s_i+t_{ij}+s_j+t_{ji}\le 0,
\]

which is impossible for the supplied positive customer service durations. The cuts therefore explicitly exclude two-customer cycles already forbidden by the original integer model.

## 4. Expected effect and solution correspondence

The reformulation targets a stronger linear relaxation through tighter coefficients, infeasible-arc fixings, activation inequalities, and small valid cuts. These changes may reduce branch-and-bound effort, although **no runtime improvement has been measured**.

All original variables remain present, so solution mapping is the identity: the supplied mapping script copies their values unchanged.
