# Vehicle Routing with Capacities and Service Time Windows

## 1. Problem background

The model represents a **capacitated vehicle-routing problem with time windows**, apparently for a transportation or service operation. Vehicles must visit demand locations while respecting vehicle capacities, customer service durations, and permitted service-start times.

The supplied instance contains:
- **34 customers**, numbered 1–34.
- **Two depot representations**: node 0 for departure and node 35 for return.
- **10 available vehicles**, divided into two groups of five. The groups have capacities of 15 and 84, respectively, and different travel-cost coefficients.

Each customer must be served exactly once. A used vehicle departs from node 0, visits customers, and returns to node 35. Travel and service times determine whether a sequence of visits is feasible. The application and measurement units are not explicitly documented, so a more specific interpretation—such as passenger transportation or goods delivery—cannot be established from the model alone.

## 2. Original mathematical formulation

### Variables

The original formulation declares **13,330 variables**:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k]` | Vehicle \(k\) selects the movement from \(i\) to \(j\) | Binary | 12,960 |
| `Y[k]` | Vehicle \(k\) operates | Binary | 10 |
| `W[i,k]` | Service-start time at node \(i\) for vehicle \(k\) | Nonnegative continuous | 360 |

Although `X` is declared for every node pair, the routing constraints use only the arcs specified by `DESTINO` and `ORIGEN`. In this instance, those sets consistently describe 1,190 directed routing arcs: depot-to-customer arcs, customer-to-customer arcs excluding self-loops, and customer-to-return-depot arcs.

### Constraints

The original model has **13,034 explicit constraint rows**, excluding variable bounds:

| Constraint family | Function | Count |
|---|---|---:|
| `R2` | Exactly one outgoing customer arc across all vehicles | 34 |
| `R3`, `R5` | One departure and one return for each operating vehicle | 20 |
| `R4` | Customer flow conservation for each vehicle | 340 |
| `R6` | Travel and service-time precedence | 11,900 |
| `R7`, `R8` | Service-start time windows | 720 |
| `R9` | Vehicle capacity | 10 |
| `R10` | Routing-arc selection requires vehicle activation | 10 |

For a selected routing arc, `R6` imposes
\[
W_{j,k}\ge W_{i,k}+s_i+t_{ij}.
\]
For an unselected arc, the supplied coefficient \(M_{ij}\) relaxes this inequality. Because every customer has positive service duration, summing selected-arc precedence inequalities around a customer cycle gives a contradiction. Thus, these time constraints also eliminate disconnected customer cycles in integer solutions.

Time-window constraints apply to **every node–vehicle pair**, including customers not served by that vehicle. This detail is part of the original semantics.

### Objective

The objective minimizes
\[
\sum_{i,j,k} c_k\,t_{ij}\,X_{i,j,k}.
\]

It is a travel-time-weighted operating cost. Despite the description attached to `c`, the formulation contains **no separate fixed charge for activating a vehicle**: `Y` does not appear in the objective.

## 3. Reformulation and justification

### 3.1 Nonrouting-arc fixing by objective dominance

The reformulation fixes **1,060 `X` variables** corresponding to node pairs outside `DESTINO` to zero.

For the supplied instance, these variables appear in none of `R2`–`R10`; the `ORIGEN` sets used in flow and return constraints are consistent with `DESTINO`. Their only occurrence is therefore in the objective, with nonnegative coefficient \(c_k t_{ij}\).

Setting them to zero preserves feasibility and cannot increase cost. Consequently, this reduction preserves at least one optimal solution, although it removes some feasible assignments of otherwise irrelevant variables.

### 3.2 Time-window and capacity preprocessing

Routing arcs are fixed to zero under either of two conditions:

- **Time incompatibility:** \(a_i+s_i+t_{ij}>b_j\). If `X[i,j,k] = 1`, `R6` requires \(W_{j,k}\ge W_{i,k}+s_i+t_{ij}\). Together with `R7`–`R8`, this would imply \(b_j\ge a_i+s_i+t_{ij}\), contradicting the condition.
- **Endpoint-demand incompatibility:** \(d_i+d_j>Q_k\). For a customer-to-customer arc, selecting it serves customer \(i\), while `R4` forces an outgoing arc from customer \(j\) on the same vehicle. Both demands then contribute to `R9`. For depot-adjacent arcs, the depot demand is zero and the same argument reduces to a single-customer capacity test.

These are implication-based variable fixings, not heuristic exclusions. Their usefulness depends on whether the corresponding incompatibilities occur in the supplied data.

### 3.3 Time windows as bounds and tighter big-\(M\) coefficients

The 720 explicit time-window rows are replaced by bounds
\[
a_i\le W_{i,k}\le b_i.
\]
This is exactly equivalent because the original data require \(a_i\ge0\).

For each routing arc, the reformulation uses
\[
\widehat M_{ij}
=
\min\!\left\{
M_{ij},
\max(0,b_i+s_i+t_{ij}-a_j)
\right\}.
\]

The time bounds imply that the left-hand side of `R6` cannot exceed \(b_i+s_i+t_{ij}-a_j\). Therefore, reducing an oversized coefficient to this bound does not exclude an integer-feasible assignment: when the arc is selected, the right-hand side remains zero; when it is unselected, the replacement bound is valid.

Crucially, the reformulation **does not increase the original coefficients or discard unused-arc timing constraints**. The supplied `M` values are rounded and can impose restrictions even when an arc is unselected. Retaining the smaller original value where applicable preserves those restrictions.

### 3.4 Stronger vehicle-activation inequalities

Three changes strengthen the continuous relaxation:

1. **Capacity activation:** `R9` becomes
   \[
   \sum_{i,j\in DESTINO[i]} d_iX_{i,j,k}\le Q_kY_k.
   \]
   If \(Y_k=1\), this is the original capacity constraint. If \(Y_k=0\), original `R10` already forces every routing arc for that vehicle to zero, so the strengthened inequality is valid.

2. **Smaller arc-count coefficient:** the coefficient 1,000 in `R10` becomes 35. By `R2`, each customer contributes at most one outgoing arc to a particular vehicle, giving at most 34 customer-origin arcs. By `R3`, the departure depot contributes exactly \(Y_k\) arcs, and `DESTINO[35]` is empty. A used vehicle therefore selects at most 35 routing arcs.

3. **Customer-level activation:** for each customer and vehicle,
   \[
   \sum_{j\in DESTINO[i]}X_{i,j,k}\le Y_k.
   \]
   `R2` bounds the left-hand side by one, while original `R10` forces it to zero for an unused vehicle.

These inequalities preserve integer feasibility while limiting fractional routing on weakly activated vehicles.

### 3.5 Capacity-cover and two-cycle cuts

**Capacity-incompatible customer pairs.** If \(d_i+d_j>Q_k\), the reformulation prevents vehicle \(k\) from serving both customers, even nonconsecutively. Each customer’s outgoing-arc sum is a binary service indicator by `R2` and integrality. Serving both would violate `R9`. The resulting pair-cover inequality is strengthened with `Y[k]` because original `R10` prohibits any service by an unused vehicle.

**Aggregated two-cycle cuts.** For customer pairs with positive total cycle duration,
\[
\sum_k\bigl(X_{i,j,k}+X_{j,i,k}\bigr)\le1.
\]
If both directions were selected, unique service and vehicle-specific flow conservation would force them onto the same vehicle. Adding their two `R6` inequalities would then require
\[
s_i+t_{ij}+s_j+t_{ji}\le0,
\]
which contradicts the cut’s positive-duration condition. These cuts expose an integer implication that the big-\(M\) relaxation expresses weakly.

### 3.6 Symmetry breaking for identical vehicles

Within consecutive vehicles having equal `c` and `Q`, the reformulation orders the index of the first customer visited, placing unused vehicles last.

This is valid because all other vehicle-dependent constraints are identical within each such group. Entire vehicle assignments—including `X`, `Y`, and `W`—can be permuted without changing feasibility or objective value. Every feasible solution therefore has an equivalent labeling satisfying the ordering. The constraints remove symmetric alternatives rather than distinct operational choices.

## 4. Preservation and expected computational effect

The reformulation retains all original variable names and domains, all embedded instance values, the minimization direction, and the original objective expression. Fixed variables remain declared, so the solution-mapping script simply copies the assignments.

The intended benefits are fewer effective binary decisions, tighter linear relaxations, and less branching over interchangeable vehicles. **No measured solve-time improvement is established here**; the additional cuts also increase the number of rows, so their net computational benefit requires benchmarking.
