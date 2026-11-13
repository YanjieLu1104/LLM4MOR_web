# Reformulation Report: Multi-Day Vehicle Routing with Time Windows

## 1. Problem background

The model represents a small distribution or collection operation in which customers must be visited over several days. Each customer has a demand, a service duration, and an allowable interval for starting service. A vehicle must respect its capacity and travel between customers while meeting these time windows.

The supplied instance contains:

- **25 customers**, numbered 1–25;
- **Two depot nodes**: node 0 represents route departure, and node 35 represents route arrival;
- **One vehicle**, indexed by 6, with capacity 84;
- **Three available days**.

Each customer must be served exactly once across all vehicle–day combinations. The model minimizes travel time multiplied by a vehicle-specific cost coefficient. Although the parameter description refers to vehicle operating cost, the actual objective charges selected travel arcs—not a fixed cost for activating a vehicle.

The general formulation also includes ordering and sequencing constraints for certain vehicle groups. These constraints are inactive in this instance because the only vehicle index is 6.

## 2. Original mathematical structure

### Decision variables

The original model declares **2,271 variables**:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `X[i,j,k,l]` | Whether vehicle `k` travels directly from node `i` to node `j` on day `l` | Binary | 2,187 |
| `Y[k,l]` | Whether vehicle `k` operates on day `l` | Binary | 3 |
| `W[i,k,l]` | Service-start time at node `i` for vehicle `k` on day `l` | Continuous, nonnegative | 81 |

The arc variables are declared for **every ordered pair of nodes**, even though the routing constraints use only arcs identified by the adjacency sets.

### Objective

The objective is to minimize total travel cost:

\[
\min \sum_{i,j,k,l} c_k\,t_{ij}\,X_{ijkl}.
\]

All objective coefficients are nonnegative.

### Constraints

The original instance generates **2,224 constraint rows**, excluding variable-domain restrictions:

| Constraint family | Purpose | Rows |
|---|---|---:|
| `R2` | Exactly one outgoing customer arc across all days and vehicles | 25 |
| `R3`, `R5` | Match depot departure and arrival to vehicle activation | 6 |
| `R4` | Customer flow conservation for each vehicle–day | 75 |
| `R6` | Propagate service times along selected arcs | 1,950 |
| `R7`, `R8` | Enforce service-start time windows | 162 |
| `R9` | Limit demand served by each vehicle–day | 3 |
| `R10` | Prohibit routing when the vehicle is inactive | 3 |
| `R11A`, `R11b`, `R12A`, `R12B` | Vehicle ordering and sequencing | 0 |

The timing constraints use a supplied arc-specific big-\(M\) matrix. Service-start variables remain subject to their time windows even when the corresponding customer is not visited on that day. Moreover, inactive-arc timing constraints can still restrict those variables if a supplied \(M\) is smaller than the conventional time-window-derived value.

For the supplied adjacency sets, customer service times are strictly positive. Consequently, a selected customer cycle is impossible: summing its timing constraints would require a strictly positive sum of service and travel times to be nonpositive. Together with assignment, flow conservation, and depot constraints, this ensures that selected routing arcs form depot-to-depot routes.

## 3. Reformulation techniques and validity

### 3.1 Fixing unused arc variables by objective dominance

The reformulation fixes **237 arc variables** to zero.

These correspond to ordered node pairs that appear in neither the outgoing adjacency sets nor the incoming adjacency sets. Thus, they occur in the objective but not in any original constraint.

Because their objective coefficients are nonnegative, setting them to zero:

- Cannot violate an original constraint;
- Cannot increase the minimization objective.

This is **objective-dominance preprocessing**. It preserves at least one optimal solution, although it removes alternative assignments of unconstrained zero-cost variables. The variables remain declared, so no reconstruction is needed.

### 3.2 Replacing time-window rows with variable bounds

The inequalities in `R7` and `R8` are represented directly as

\[
a_i \le W_{ikl} \le b_i.
\]

This removes **162 explicit constraint rows** without changing the feasible region. Since every supplied \(a_i\) is nonnegative, these bounds also imply the original nonnegativity restriction.

This is a standard **bound reformulation**, allowing the solver to handle the time windows directly through its variable-bound machinery.

### 3.3 Tightening big-\(M\) coefficients without relaxing the original model

For every routing arc, the reformulation uses

\[
\widehat M_{ij}
=
\min\!\left\{
M_{ij},
\max\!\left(0,b_i+s_i+t_{ij}-a_j\right)
\right\}.
\]

The time-window bounds imply

\[
W_{ikl}+s_i+t_{ij}-W_{jkl}
\le b_i+s_i+t_{ij}-a_j.
\]

Therefore:

- If \(X_{ijkl}=0\), replacing an unnecessarily large coefficient by this bound does not exclude any feasible service times.
- If \(X_{ijkl}=1\), the right-hand side remains zero, so the selected-arc timing requirement is unchanged.
- If the supplied \(M_{ij}\) is already smaller, it is retained.

The final point matters because some supplied coefficients are slightly below the conventional bound. Increasing them could relax original inactive-arc restrictions and change the problem. The reformulation instead uses **bound-based big-\(M\) tightening** that preserves the original integer-feasible solutions.

### 3.4 Strengthening vehicle activation

The coefficient 1,000 in `R10` is replaced by **26**.

For any vehicle–day:

1. `R2` and nonnegativity imply that each of the 25 customers contributes at most one selected outgoing arc.
2. `R3` permits at most one depot-departure arc because `Y` is binary.
3. `DESTINO[35]` is empty, so the arrival depot contributes no outgoing routing arcs.

Hence, at most 26 routing arcs can be selected. The tighter activation inequality preserves every original integer-feasible solution while strengthening the linear relaxation.

The reformulation also adds

\[
\sum_{j\in DESTINO[i]}X_{ijkl}\le Y_{kl}
\]

for each customer and vehicle–day. These **disaggregated activation inequalities** are valid because:

- When \(Y_{kl}=0\), original `R10` forces every routing arc for that vehicle–day to zero.
- When \(Y_{kl}=1\), original `R2` already bounds each customer's outgoing sum by one.

They prevent a fractional vehicle activation from supporting an excessively large fractional customer visit.

### 3.5 Adding two-cycle inequalities

For each customer pair, the reformulation adds

\[
X_{ijkl}+X_{jikl}\le 1.
\]

If both arcs were selected, adding their original `R6` inequalities would give

\[
s_i+s_j+t_{ij}+t_{ji}\le 0.
\]

This contradicts the positive customer service times and nonnegative travel times in the supplied instance.

These **two-cycle elimination cuts** make an implication of the timing constraints explicit, strengthening the relaxation without adding integer variables.

### 3.6 Adding aggregate route-duration inequalities

For each vehicle–day, the reformulation bounds the total service and travel duration between the first and last customers:

\[
\sum_{\substack{i,j\text{ customers}\\j\in DESTINO[i]}}
(s_i+t_{ij})X_{ijkl}
\le
\sum_{i\in ORIGEN[35]} b_iX_{i,35,k,l}
-
\sum_{j\in DESTINO[0]} a_jX_{0,j,k,l}.
\]

To establish validity, consider a selected route whose first and last customers are \(f\) and \(h\). Summing the original timing constraints along the customer-to-customer portion gives

\[
\sum_{\text{internal route arcs}}(s_i+t_{ij})
\le W_{hkl}-W_{fkl}
\le b_h-a_f.
\]

The depot-adjacent arc variables identify these endpoints. The route structure follows from the original degree, flow, activation, and positive-duration timing constraints. If the vehicle is inactive, both sides are zero.

These are **aggregate timing cuts**: they expose a route-level consequence of several original constraints directly to the relaxation.

### 3.7 Breaking interchangeable-day symmetry

The reformulation orders the total demand served on consecutive days in nonincreasing order.

This is valid because all three days have identical vehicle availability, costs, capacities, time windows, and routing rules. No original constraint links different days or assigns a distinct operational meaning to a particular day. Consequently, the complete daily assignments of `X`, `Y`, and `W` can be permuted without changing feasibility or objective value.

Every feasible solution therefore has a day-permuted representative satisfying the load ordering. This **symmetry-breaking reformulation** preserves an optimal solution while reducing equivalent day assignments explored during search.

## 4. Preservation and expected computational effect

All original instance data, variable names, and variable index domains are retained. The mapping script copies `X`, `Y`, and `W` unchanged.

The reformulation targets three sources of computational difficulty: unnecessary arc variables, weak activation and timing relaxations, and interchangeable-day symmetry. The added cuts may improve lower bounds and reduce branching, while bound conversion simplifies the explicit constraint system. However, no solver benchmark was performed in the conversation, so a reduction in solution time is an intended benefit rather than a measured result.
