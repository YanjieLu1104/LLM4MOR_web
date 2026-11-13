# Reformulation Report: Capacitated Routing with Time Windows

## 1. Problem background

The model represents a **vehicle-routing and service-scheduling problem**. Vehicles travel from a starting depot, visit customers with specified demands, and finish at an ending depot. Each customer requires service within a time window, and each vehicle has a capacity limit.

The supplied instance contains:
- **15 customers**, numbered 1–15;
- a starting depot, node **0**, and an ending depot, node **35**;
- **10 vehicle indices**, split into two groups with different capacities and travel-cost coefficients.

Within each group, successive vehicle indices have ordered activation and nonoverlapping schedules: the next indexed vehicle cannot start before the previous one finishes. This suggests that the indices may represent successive trips of two physical vehicles or resources, rather than ten fully independent vehicles. That interpretation is inferred from the constraints; the model does not explicitly identify physical vehicles.

## 2. Original mathematical structure

### Variables and objective

The original model declares **3,070 variables**:

| Variable | Type and count | Meaning |
|---|---:|---|
| `X[i,j,k]` | 2,890 binary | Whether vehicle index `k` uses arc `(i,j)` |
| `Y[k]` | 10 binary | Whether vehicle index `k` is activated |
| `W[i,k]` | 170 continuous | Service-start time at node `i` for vehicle index `k` |

The objective **minimizes travel cost**, summing travel time multiplied by the vehicle-specific cost coefficient over all selected arcs. There is no separate fixed activation cost.

### Constraints

The original file generates **2,971 scalar constraints**, excluding variable-domain restrictions. They enforce:

- exactly one outgoing service arc across all vehicles for each customer;
- depot departure and arrival linked to vehicle activation;
- vehicle-specific customer flow balance;
- service and travel-time precedence through big-M inequalities;
- time windows for every node–vehicle pair, including unvisited nodes;
- vehicle capacity;
- an activation-linked bound of 1,000 on selected routing arcs;
- activation ordering and temporal sequencing within the two vehicle groups.

**Important data detail:** incoming and outgoing adjacency sets are not completely consistent. In particular, `DESTINO[15]` includes node 15 itself but excludes node 14, while `ORIGEN[14]` includes node 15. The reformulation preserves these entries and does not assume a conventional, consistent routing graph.

## 3. Reformulation and validity

### Objective-based fixing of unused arcs

An arc variable is fixed to zero if it appears in neither the outgoing nor incoming adjacency representation. Such variables occur only in the objective, whose coefficients are nonnegative. Setting them to zero therefore preserves feasibility and cannot increase cost. This preserves at least one optimum, although it can remove alternative optimal assignments of zero-cost, otherwise unused variables.

### Logical arc preprocessing

For arcs governed by the original time-precedence and capacity constraints, the reformulation fixes `X[i,j,k]` to zero when:

- **Time-window infeasibility:** `a[i] + s[i] + t[i,j] > b[j]`. Selecting the arc would contradict precedence and the endpoint time bounds.
- **Capacity infeasibility:** `d[i] > Q[k]`. Selecting the arc alone would exceed capacity because all other capacity contributions are nonnegative.
- **Positive-duration self-loop:** `i = j` and `s[i] + t[i,j] > 0`. Selecting it would require a service time to exceed itself by a positive amount.

Arcs used only in the incoming adjacency representation are not incorrectly subjected to these outgoing-arc tests.

### Bound-based big-M tightening

The replacement coefficient is

\[
\widehat M_{ij}
=\min\{M_{ij},\max(0,b_i+s_i+t_{ij}-a_j)\}.
\]

When an arc is selected, its precedence constraint is unchanged. When it is unselected, the time-window bounds imply the new bound whenever it is tighter. Taking the minimum with the original coefficient preserves any additional restrictions imposed by the supplied, rounded M values.

The original time-window inequalities are also represented directly as variable bounds.

### Activation strengthening

Capacity is strengthened from a right-hand side of `Q[k]` to `Q[k]Y[k]`. This is valid because the original arc-activation constraint forces every outgoing routing arc to zero when `Y[k]=0`; when `Y[k]=1`, capacity is unchanged.

Customer-specific inequalities also require each vehicle’s outgoing customer assignment to be at most `Y[k]`. The original exact-assignment constraint bounds that sum by one, and the original activation constraint forces it to zero for inactive vehicles.

### Arc-count bound reduction

The activation-linked arc limit decreases from **1,000 to 16**. Each of the 15 customers contributes at most one outgoing arc per vehicle by exact assignment and nonnegativity. The starting depot contributes at most one by its departure equation, and the ending depot has no outgoing arcs. Thus 16 is valid without assuming route connectivity.

### Two-customer capacity-cover cuts

If two customer demands sum to more than a vehicle’s capacity, their outgoing assignment indicators cannot both equal one for that vehicle. Their sum is therefore bounded by `Y[k]`. These **capacity-cover inequalities** follow from binary assignment, the original capacity constraint, and activation.

All original variables remain declared, allowing identity solution mapping. The changes target presolve reduction and a stronger linear relaxation; no measured runtime improvement is established here.
