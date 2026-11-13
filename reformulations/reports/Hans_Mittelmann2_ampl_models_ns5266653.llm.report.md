# Reformulation Report: Multi-Day Vehicle Routing with Time Windows

## 1. Problem background

The model represents a **capacitated vehicle-routing and service-scheduling problem over three days**. Vehicles travel from a departure depot, serve customers, and return to an arrival depot. Each customer must be served exactly once across the entire planning horizon.

The instance contains:
- **34 customers**, indexed 1–34;
- departure and arrival depot nodes, indexed 0 and 35;
- **six vehicle/trip indices**, grouped as `(1, 2, 3)` and `(6, 7, 8)`;
- **three days**.

Customer data specify demand, service duration, and a permissible service-start interval. Vehicle data specify capacity and a travel-time cost coefficient. The two index groups have capacities of 15 and 84, respectively, and different operating costs.

The interpretation of the six indices deserves care: the model requires successive indices within each group to operate sequentially within a day. Thus, they may represent successive trips of a physical vehicle rather than six independently operating vehicles. This interpretation is inferred from the constraints; the source does not explicitly identify the application or physical fleet.

## 2. Original formulation

### Decision variables

The original model declares:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k,l]` | Travel from node `i` to node `j` using vehicle/trip `k` on day `l` | Binary | 23,328 |
| `Y[k,l]` | Activate vehicle/trip `k` on day `l` | Binary | 18 |
| `W[i,k,l]` | Service-start time at node `i` for vehicle/trip `k` on day `l` | Continuous, nonnegative | 648 |

Although `X` is declared for every ordered node pair, route constraints use only the arcs specified by `DESTINO` and `ORIGEN`.

### Objective

The objective **minimizes total travel cost**:

\[
\sum_{i,j,k,l} c_k\,t_{ij}\,X_{ijkl}.
\]

There is no separate fixed activation cost for `Y`.

### Constraints

- **Customer assignment (`R2`):** each customer has exactly one selected outgoing arc across all vehicles and days.
- **Depot connections (`R3`, `R5`):** an activated trip has one departure from node 0 and one arrival at node 35.
- **Flow conservation (`R4`):** each customer’s incoming and outgoing flow balance separately for each vehicle and day.
- **Time propagation (`R6`):** a selected arc requires the next service to start after the current service and travel time.
- **Time windows (`R7`, `R8`):** all service-time variables, including those for unvisited nodes, lie within their prescribed windows.
- **Capacity (`R9`):** total demand assigned to each trip cannot exceed its capacity.
- **Activation (`R10`):** no route arcs may be selected for an inactive trip.
- **Trip ordering (`R11A`, `R11b`, `R12A`, `R12B`):** later trips require earlier trips to be activated and cannot depart before the preceding trip returns.

Positive customer service durations make directed customer cycles incompatible with time propagation.

## 3. Reformulation and validity

### Algebraic representation of adjacency sets

The explicit adjacency lists were replaced with set expressions having **exactly the same memberships**: depot-to-customer arcs, arcs between distinct customers, and customer-to-arrival-depot arcs. This simplifies the file without changing the network or numerical data.

### Arc preprocessing

All original variables and indices were retained, but selected `X` variables received an upper bound of zero:

- **Unused arcs:** arcs outside `DESTINO` appear only in the objective for this instance. Their objective coefficients are nonnegative, so setting them to zero cannot damage feasibility or increase cost. This preserves at least one optimum, although it removes some irrelevant feasible assignments.
- **Time-infeasible arcs:** if \(a_i+s_i+t_{ij}>b_j\), selecting the arc contradicts `R6` and the time windows.
- **Capacity-infeasible arcs:** if \(d_i+d_j>Q_k\), the arc cannot be selected. For customer-to-customer arcs, `R4` forces the destination customer to have outgoing flow on the same trip, so `R9` counts both demands. Depot demands are zero, making the test valid for depot-adjacent arcs as well.

### Time-window bounds and big-M tightening

`R7` and `R8` were replaced by equivalent bounds on `W`. Each time-propagation coefficient became

\[
\widehat M_{ij}
=
\min\!\left\{
M_{ij},
\max(0,b_i+s_i+t_{ij}-a_j)
\right\}.
\]

The window bounds provide the stated upper bound on the time-propagation left-hand side. Consequently, reducing an oversized coefficient to this bound preserves every feasible binary solution while potentially strengthening the LP relaxation.

Importantly, the reformulation **never increases the supplied coefficient**. Some original coefficients are rounded and may impose restrictions even when an arc is unselected; those restrictions are preserved.

### Activation and capacity strengthening

- The activation multiplier was reduced from **1,000 to 35**. By `R2`, at most 34 customer departures can occur on one trip, while `R3` permits at most one depot departure. An inactive trip still has no selected arcs.
- Customer-level linking inequalities enforce outgoing flow at each customer to be at most `Y`. These follow from `R2` when `Y=1` and from original `R10` when `Y=0`.
- Capacity was strengthened from a right-hand side of \(Q_k\) to \(Q_kY_{kl}\). For active trips this is unchanged; for inactive trips, original `R10` already forces all capacity-consuming arcs to zero.

These inequalities mainly strengthen fractional solutions.

### Valid cutting planes

- **Incompatible-customer-pair cuts:** customers whose combined demand exceeds capacity cannot share a trip, directly by `R9`. Their combined visit indicators are therefore bounded by `Y`.
- **Two-customer subtour cuts:** both directions between two customers cannot be selected. Assignment and flow conservation would place both arcs on the same trip; summing their `R6` inequalities would then contradict positive total service and travel time.

### Day-symmetry breaking

Daily travel costs were constrained to be nonincreasing across days. All days have identical data, and the sequencing constraints operate only within a day. Therefore, any feasible solution can be relabeled by whole-day permutations to satisfy this ordering without changing total cost. At least one optimal representative is retained.

## 4. Expected effect and solution mapping

The reformulation targets unnecessary binary choices, weak activation constraints, fractional short cycles, and equivalent day permutations. These changes are intended to reduce search effort; **no measured runtime improvement was established in the conversation**.

The original independent variable set is unchanged, so the solution-mapping script copies `X`, `Y`, and `W` values directly.
