# Reformulation Report: Capacitated Routing with Time Windows

## 1. Problem background

The model represents a **vehicle-routing problem with customer time windows and sequential trips**. It contains 30 customers, a departure depot labeled **0**, an arrival depot labeled **35**, and 10 vehicle/trip indices.

Each customer has a demand, service duration, and allowable service-start interval. A selected route must respect vehicle capacity and travel-time-dependent scheduling constraints. The objective is to minimize travel time weighted by vehicle-specific operating costs.

The indices form two chains, **1–5** and **6–10**. Within each chain, a later trip cannot be activated unless its predecessor is active, and its departure cannot precede the predecessor’s arrival. This suggests repeated trips by two physical vehicles or two sequentially operated resources, although the source describes all 10 indices as vehicles. The first chain has capacity 15 per trip; the second has capacity 84.

No specific industry or geographic setting is established by the source.

## 2. Original mathematical formulation

### Variables and objective

The original model declares:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k]` | Vehicle/trip \(k\) selects arc \(i\to j\) | Binary | 10,240 |
| `Y[k]` | Vehicle/trip \(k\) is activated | Binary | 10 |
| `W[i,k]` | Service-start time at node \(i\) for vehicle/trip \(k\) | Nonnegative continuous | 320 |

Although `X` is declared for all ordered node pairs, the routing constraints use only the **930 arcs** specified by `DESTINO`.

The minimization objective is
\[
\sum_{i,j,k} c_k t_{ij}X_{ijk}.
\]
Thus, `Y` does not incur a separate fixed activation charge.

### Constraints

There are **10,326 explicit constraints** before presolve, excluding variable-domain restrictions:

- **Customer assignment (`R2`):** exactly one outgoing arc is selected across all trips for each customer.
- **Depot departure and arrival (`R3`, `R5`):** each active trip leaves node 0 once and reaches node 35 once.
- **Customer flow conservation (`R4`):** arrivals equal departures for each customer and trip.
- **Time propagation (`R6`):** selecting an arc requires enough time for service at its origin and travel to its destination.
- **Time windows (`R7`, `R8`):** every `W[i,k]` lies between `a[i]` and `b[i]`, including for unvisited customers.
- **Capacity (`R9`):** the demand assigned to each trip cannot exceed its capacity.
- **Activation (`R10`):** an inactive trip cannot select routing arcs.
- **Trip ordering (`R11A`, `R11b`, `R12A`, `R12B`):** activation and depot times are linked within the two trip chains.

All customers have strictly positive service durations. Consequently, a selected customer cycle is impossible: summing `R6` around that cycle would require a strictly positive total service-and-travel duration to be at most zero. Together with assignment, flow conservation, and depot constraints, this means each active trip forms a depot-to-depot path.

## 3. Reformulation and validity

### Arc preprocessing

**Arcs outside `DESTINO` are fixed to zero.** In the supplied instance, `ORIGEN` and `DESTINO` describe the same routing network. Variables outside that network therefore occur only in the objective. Their coefficients are nonnegative, so setting them to zero cannot worsen the objective or violate a constraint. This preserves at least one optimum, although it removes irrelevant alternative assignments on zero-cost arcs.

**Capacity-incompatible arcs are fixed to zero.** Selecting a customer-to-customer arc assigns both endpoints to the same trip: its origin has a selected departure, and `R4` forces its destination to have a departure as well. Therefore, `R9` requires \(d_i+d_j\le Q_k\). The same test applies to depot arcs because depot demand is zero.

**Time-incompatible arcs are fixed to zero.** If
\[
a_i+s_i+t_{ij}>b_j,
\]
the time windows and selected-arc version of `R6` cannot hold simultaneously.

### Time-window bounds and big-M tightening

The explicit time-window rows are replaced by bounds on `W`, preserving their meaning.

Each time-propagation coefficient becomes
\[
\widehat M_{ij}
=\min\!\left\{M_{ij},\max(0,b_i+s_i+t_{ij}-a_j)\right\}.
\]

For an unselected arc, the time-window-derived quantity bounds the largest possible left-hand side. For a selected arc, the right-hand side remains zero. Taking the minimum with the supplied coefficient is important: the original rounded `M` values can impose restrictions even on unselected arcs, and those restrictions must not be relaxed.

### Stronger activation inequalities

The reformulation adds
\[
\sum_{j\in DESTINO[i]}X_{ijk}\le Y_k
\]
for each customer and trip. If `Y[k]=0`, original `R10` already forces all routing arcs to zero. If `Y[k]=1`, original `R2` bounds that customer’s departures on any one trip by one. The inequalities are therefore valid and strengthen fractional solutions.

The capacity bound becomes \(Q_kY_k\). This is equivalent for binary activation: inactive trips already carry no demand, while active trips retain the original capacity.

The coefficient **1,000** in `R10` is reduced to **31**. An active trip has one depot departure by `R3`, and at most 30 customer departures by `R2`. An inactive trip still has no selected routing arcs.

### Capacity-flow extended formulation

Auxiliary nonnegative flows represent remaining customer demand carried along selected arcs. Flow is consumed at each visited customer, with arc bounds
\[
d_jX_{ijk}\le f_{ijk}\le (Q_k-d_i)X_{ijk}.
\]

Every original feasible route admits these flows: assign each arc the total demand of customers remaining downstream. Customer flow balances then hold, and route capacity guarantees the upper bounds. These constraints strengthen the relaxation by linking fractional routing decisions to demand movement.

### Route-duration inequalities

For an active trip, the total selected service and travel duration is bounded by
\[
W_{35,k}-W_{0,k}.
\]
This follows by summing `R6` along its depot-to-depot path; intermediate times cancel. An activation-dependent allowance makes the inequality redundant for inactive trips, using the original depot time bounds.

## 4. Expected computational effect

The reformulation targets a stronger linear relaxation through arc fixing, tighter activation and timing constraints, and capacity-flow strengthening. The auxiliary flows increase model size, so a net runtime improvement requires computational testing rather than being guaranteed.

All original decision variables, instance data, and the minimization objective are retained. The solution mapping returns `X`, `Y`, and `W` unchanged and discards only the auxiliary flow variables.
