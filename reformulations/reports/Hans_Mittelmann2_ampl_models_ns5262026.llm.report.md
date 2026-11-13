# Vehicle Routing with Time Windows and Sequenced Trips

## 1. Background and interpretation

The model represents a capacitated vehicle-routing problem with customer service time windows. Its Spanish annotations describe nodes, available vehicles, customer demand, travel times, and service durations.

The supplied instance contains:

- **15 customer nodes**, numbered 1–15.
- **Two depot-related nodes**: node 0 is the departure node and node 35 is the return node.
- **10 vehicle or trip indices**, divided into two groups of five. The first group has capacity 15 and the second capacity 84, with different operating-cost coefficients.

Within each group, a later-indexed trip cannot be activated unless the preceding trip is activated, and its departure must follow the preceding trip’s return. This suggests successive trips by two vehicle resources, although the original annotations call all ten indices vehicles.

The objective is to serve customers while minimizing travel-time-weighted operating cost. Service durations affect scheduling feasibility but are not charged directly in the objective.

## 2. Original formulation

### Decision variables

The original model declares:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k]` | Whether index `k` uses movement from node `i` to node `j` | Binary | 2,890 |
| `Y[k]` | Whether vehicle/trip `k` operates | Binary | 10 |
| `W[i,k]` | Service-start time at node `i` for index `k` | Continuous, nonnegative | 170 |

`X` is declared for **every ordered node pair**, not only pairs appearing in the routing incidence sets.

### Objective and constraints

The minimization objective is
\[
\sum_{i,j,k} c_k t_{ij}X_{ijk}.
\]

Before presolve, the original model contains **2,971 scalar constraints**, excluding variable-domain restrictions. These enforce:

- One outgoing service assignment per customer across all indices.
- Departure from node 0 and arrival at node 35 when an index is activated.
- Customer flow balance using the supplied `ORIGEN` and `DESTINO` sets.
- Conditional travel-and-service time propagation through big-\(M\) inequalities.
- Lower and upper service-time windows.
- Per-index demand capacity.
- Activation of any index using a modeled routing arc.
- Ordered activation and chronological sequencing within each group.

Two details matter for equivalence. First, the original `M` values are rounded and can impose restrictions even on unselected arcs. Second, `DESTINO[15]` includes node 15 but excludes node 14, while the incoming incidence sets are not correspondingly symmetric. The reformulation preserves these data rather than replacing them with conventional routing assumptions.

## 3. Reformulation and justification

### Time windows represented as variable bounds

The separate inequalities `W[i,k] >= a[i]` and `W[i,k] <= b[i]` were moved into the declaration of `W`.

This is an exact reformulation: the permitted interval remains unchanged. Since the original parameters satisfy \(a_i\ge0\), the lower bound also preserves the original nonnegativity restriction. It removes 340 explicit constraint rows and exposes the bounds directly to the solver.

### Bound-based big-\(M\) tightening

For each arc governed by a timing constraint, the coefficient becomes
\[
\widehat M_{ij}
=\min\!\left(M_{ij},\max\{0,b_i+s_i+t_{ij}-a_j\}\right).
\]

The time windows imply
\[
W_{ik}+s_i+t_{ij}-W_{jk}
\le b_i+s_i+t_{ij}-a_j.
\]

Therefore, when \(X_{ijk}=0\), replacing an oversized coefficient by this bound excludes no feasible timing assignment. When \(X_{ijk}=1\), the right-hand side remains zero. Taking the minimum with the **original** coefficient preserves any tighter restriction already imposed by the rounded data. This strengthens the linear relaxation without changing integer feasibility.

### Stronger activation constraints

Three related strengthenings were applied:

- **Customer-visit activation:**  
  \[
  \sum_{j\in DESTINO[i]}X_{ijk}\le Y_k.
  \]
  If \(Y_k=0\), original constraint `R10` forces every outgoing routing variable for that index to zero. If \(Y_k=1\), `R2` already bounds this sum by one because all customer outgoing assignments across all indices sum to one.

- **Activated capacity:** The capacity right-hand side changes from \(Q_k\) to \(Q_kY_k\). For \(Y_k=1\), this is the original capacity constraint. For \(Y_k=0\), `R10` already makes every term in its left-hand side zero.

- **Tighter total arc bound:** The activation coefficient 1,000 becomes **16**. For an active index, `R2` permits at most 15 customer outgoing arcs, `R3` permits exactly one depot departure, and `DESTINO[35]` is empty. For an inactive index, the original `R10` already requires zero arcs.

These inequalities make fractional activation more restrictive while retaining every original integer-feasible solution.

### Capacity-based arc fixing

An arc is fixed to zero when its selection necessarily serves two distinct endpoints whose combined demand exceeds capacity.

Specifically, selecting \(X_{ijk}=1\) counts demand \(d_i\) in `R9`. If \(j\) is a customer and \(i\in ORIGEN[j]\), flow balance `R4` requires at least one outgoing arc from \(j\), additionally counting \(d_j\). Nonnegative demands therefore imply a load of at least \(d_i+d_j\). If this exceeds \(Q_k\), the arc cannot occur.

The incidence-membership condition is essential: it makes this preprocessing valid despite the supplied incidence-set asymmetry.

## 4. Preservation and expected benefit

All original variables, fixed data, objective coefficients, and trip-sequencing constraints were retained. Consequently, solution mapping is the identity.

The intended computational benefits are tighter linear relaxations, stronger activation links, explicit variable bounds, and early removal of capacity-incompatible arc choices. No solve-time improvement has been measured in the reported reformulation.
