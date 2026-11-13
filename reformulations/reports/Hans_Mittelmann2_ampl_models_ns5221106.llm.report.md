# Time-Dependent School-Bus Routing: Model and Reformulation

## 1. Problem background

The model appears to describe a **capacitated school-bus routing problem with time-dependent travel times**. This interpretation follows from the original comments referring to children, vehicles, and a school arrival window.

The supplied instance contains:
- **4 vehicles**, with capacities of 9, 21, 12, and 21 passengers;
- **39 pickup locations**, plus node `0`, representing the school or depot;
- **4 departure-time periods**, each with its own travel-time matrix;
- Passenger demands and service durations at pickup locations;
- A required return window of **540–550 time units** at node `0`.

Every pickup location must be assigned to exactly one vehicle. Each vehicle must leave node `0` once and return once, while respecting its capacity. Travel time depends on the period in which the vehicle leaves the origin of an arc.

The objective is to **minimize the longest vehicle-route duration**, measured from departure from node `0` to return there. This is different from minimizing total travel time or the latest absolute arrival time.

## 2. Original formulation

### Variables

| Variable | Interpretation | Type | Count |
|---|---|---|---:|
| `X[k,i,t,j]` | Vehicle `k` travels from `i` to `j`, departing in period `t` | Binary | 24,960 |
| `Y[k,i]` | Vehicle `k` visits node `i` | Binary | 160 |
| `TP[k,i]` | Departure time from node `i` | Nonnegative continuous | 160 |
| `TI[k,i]` | Arrival time at node `i` | Nonnegative continuous | 160 |
| `TRM[k]` | Vehicle-route duration | Nonnegative continuous | 4 |
| `TRMAX` | Maximum route duration | Nonnegative continuous | 1 |

Self-arcs are excluded. In total, the model has **25,120 binary variables and 325 continuous variables**.

### Constraints and objective

The original constraints enforce:

- **Customer coverage:** exactly one vehicle assignment, one outgoing arc, and one incoming arc per pickup location.
- **Vehicle routing:** one departure and return at node `0`, together with vehicle-specific flow conservation.
- **Capacity:** assigned passenger demand cannot exceed vehicle capacity.
- **School arrival window:** each vehicle returns between 540 and 550.
- **Travel-time consistency:** paired big-\(M\) inequalities impose
  \[
  TI_{k,j}=TP_{k,i}+tv_{i,t,j}
  \]
  when an arc is selected.
- **Service-time consistency:** paired big-\(M\) inequalities impose departure equal to arrival plus service duration at a visited pickup.
- **Period selection:** departure times lie within the interval associated with the selected outgoing arc.
- **Visit–time linking:** unvisited nodes have zero arrival and departure times.
- **Route duration:** `TRM[k] = TI[k,0] - TP[k,0]`, with `TRM[k] <= TRMAX`.

The objective is `minimize TRMAX`. The original big-\(M\) value is **2000**.

## 3. Reformulation and justification

### Exact service-time equations

The two conditional service constraints were replaced by
\[
TP_{k,i}=TI_{k,i}+at_iY_{k,i},\qquad i\ne0.
\]

For a visited customer, the original paired inequalities already impose this equality. For an unvisited customer, the original nonnegativity and bounds `TP <= mt*Y` and `TI <= mt*Y` force both times to zero. The original inactive service constraints also hold because every supplied service duration is at most `mt`.

Thus, the replacement preserves integer-feasible solutions and gives a stronger linear relaxation.

### Removal of redundant integrality and equations

`Y` was changed from binary to continuous on \([0,1]\). This is valid because the original linking equation makes each `Y[k,i]` equal to a sum of binary outgoing-arc variables. That sum is integral and, with the retained bounds, can only be zero or one.

The separate customer outgoing-degree equations were removed: summing the visit–arc linking equation over vehicles and using `sum Y = 1` already gives exactly one outgoing arc. Customer incoming-degree equations then follow from vehicle-specific flow conservation.

Depot flow conservation was also removed because the retained depot departure and return equations both specify exactly one arc per vehicle.

### Route-based time bounds and tighter big-\(M\) constraints

Every customer has **strictly positive service duration**. A disconnected customer cycle would, by summing the original selected-arc time equalities and service equalities around the cycle, require
\[
0=\text{total travel time}+\text{total service time}>0.
\]
Such a cycle is impossible.

The degree and flow constraints therefore imply that each vehicle’s visited customers belong to its route through node `0`. Since travel and service times are nonnegative, every customer departure precedes the return to node `0`. The return-window constraint consequently gives
\[
TP_{k,i}\le550,\qquad
TI_{k,i}\le550-at_i\quad(i\ne0).
\]
The depot departure is also at most 550 because route duration is nonnegative.

These bounds replace the much looser 2000-based time bounds. The travel-time implications were strengthened using **node-specific upper and lower bounds multiplied by visit indicators**. A selected arc still imposes the original exact travel-time equation; an unselected arc leaves an inequality implied by those bounds.

Conversely, the original inactive travel-time inequalities remain satisfied because all retained times lie between 0 and 550, well within the original big-\(M\) allowance of 2000.

### Locally infeasible arc fixing

Arc variables were retained but given upper bound zero when either:

- The demands of their two endpoints exceed the vehicle capacity; or
- No departure time can simultaneously satisfy the selected period interval, the origin’s departure bounds, and the destination’s arrival bounds after adding travel time.

A selected arc implies visits to both endpoints through the original linking and flow constraints. Capacity and time consistency therefore make these tests necessary conditions. This is **capacity-based and time-window-based preprocessing**, not a heuristic deletion of unattractive arcs.

### Exact route-duration accounting

The reformulation adds
\[
TRM_k=
\sum_{i,t,j:i\ne j}tv_{i,t,j}X_{k,i,t,j}
+\sum_{i\ne0}at_iY_{k,i}.
\]

This follows by summing the selected-arc time equalities and customer service equalities along the route: intermediate times cancel, leaving depot return minus depot departure. Unvisited times are zero. The identity exposes route cost directly to the linear relaxation, strengthening the connection between routing decisions and the minimax objective.

### Vehicle symmetry breaking

Route durations were ordered for vehicles with equal capacities. In this instance, vehicles 2 and 4 both have capacity 21 and otherwise have identical model data.

Swapping all decisions and times of these vehicles preserves feasibility and objective value. Hence, requiring one duration to be no smaller than the other removes equivalent labelings while retaining at least one representative of every solution class, including an optimum.

### Data representation and solution mapping

The supplied travel-time matrices are symmetric with zero diagonals. They were stored by upper triangles and reconstructed through the original `tv` indexing. This preserves the travel-time values and their meanings; it is a storage change rather than an optimization restriction.

All original decision-variable names and index domains were retained, including arcs fixed to zero. The solution mapping is therefore the **identity**.

## 4. Expected computational effect

The reformulation removes redundant equations and binary declarations, tightens time bounds, strengthens conditional timing constraints, exposes exact route costs, and reduces vehicle-label symmetry. These changes target weaknesses in the original linear relaxation and unnecessary search. Actual solution-time improvement remains solver- and instance-dependent and requires benchmarking.
