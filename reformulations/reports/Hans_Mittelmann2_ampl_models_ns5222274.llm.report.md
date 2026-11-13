# Reformulation Report: Time-Dependent School-Bus Routing

## Problem background

The model appears to represent a **school-bus routing problem with time-dependent travel times**. This interpretation follows from the school arrival-window comments, the passenger-demand data, and the routing structure.

The instance contains three vehicles, 39 pickup nodes, and a depot or school represented by node `0`. Every pickup node must be assigned to exactly one vehicle. Each vehicle leaves node `0` once and returns once, respecting its passenger capacity. Travel times depend on which of four time periods contains the departure from a node.

Vehicles must return to the school between times 540 and 550. The objective is to minimize the longest vehicle route duration—not total distance or total travel time. At a visited pickup node, departure occurs exactly after the specified service time; the model does not provide an additional waiting-time decision there.

## Original formulation

Before presolve, the supplied instance has **18,840 binary variables, 244 continuous variables, and 10,452 constraints**.

### Variables

| Variable | Meaning | Count |
|---|---|---:|
| `X[k,i,t,j]` | Vehicle `k` travels from `i` to `j`, departing during period `t` | 18,720 binary |
| `Y[k,i]` | Vehicle `k` visits node `i` | 120 binary |
| `TP[k,i]` | Departure time from node `i` | 120 continuous |
| `TI[k,i]` | Arrival time at node `i` | 120 continuous |
| `TRM[k]` | Vehicle route duration | 3 continuous |
| `TRMAX` | Maximum route duration | 1 continuous |

All continuous variables are nonnegative.

### Constraints and objective

The constraints enforce:

- Unique customer assignment and unique incoming and outgoing customer arcs.
- One departure from and one return to node `0` per vehicle.
- Vehicle-specific flow conservation and passenger capacity.
- The school return-time window.
- Arrival–departure consistency along selected arcs, using paired big-\(M\) inequalities with `mt = 2000`.
- Service-time consistency at visited customers.
- Departure-time membership in the selected travel period.
- Links between visits, outgoing arcs, and time variables. In particular, `r19`–`r20` force both times to zero at unvisited nodes.

Constraints `r3` define each route duration as school return time minus depot departure time. Constraints `r2` bound these durations by `TRMAX`, which is minimized.

## Reformulation and justification

### 1. Exact activated service-time equalities

The paired service constraints `r14`–`r15` were replaced by
\[
TP_{ki}=TI_{ki}+at_iY_{ki},\qquad i\ne0.
\]

When `Y[k,i] = 1`, the original pair already imposes this equality. When `Y[k,i] = 0`, `r19`–`r20` and nonnegativity force both times to zero. The original service inequalities then hold because every supplied service time is at most `mt`.

Thus, the replacement preserves all integer-feasible solutions while strengthening the relaxation and replacing two inequalities per vehicle–customer pair with one equality.

### 2. Bound tightening and lifted timing inequalities

The reformulation derives node-specific time bounds:

- From `r18` and binary `Y`, a visited node has exactly one outgoing arc. Consequently, `r17` bounds departure time by the largest period endpoint, while `r19` also bounds it by `mt`.
- At node `0`, nonnegative `TRM`, `r3`, and `r11b` additionally imply that departure time cannot exceed `tar0`.
- At a visited customer, the service equality implies that arrival time cannot exceed its departure upper bound minus its service time. It also implies that departure time is at least its service time.
- At node `0`, `r11a` supplies the return-time lower bound.

These bounds replace the uniform big-\(M\) terms in `r12`–`r13` with **lifted, visit-dependent bounds**. If an arc is selected, both endpoints are visited and the inequalities enforce the original exact travel-time equation. If it is not selected, they follow from the endpoint time bounds.

The original inactive-arc inequalities remain satisfied: the derived time bounds do not exceed `mt`, so the difference between two nonnegative endpoint times cannot exceed the original allowance.

### 3. Arc-period preprocessing

An arc-period choice is fixed to zero if its feasible departure interval is empty. For an arc from \(i\) to \(j\) in period \(t\), this interval intersects:

- The selected period’s departure window.
- The origin’s departure bounds.
- The destination’s arrival bounds shifted backward by `tv[i,t,j]`.

These conditions follow directly from `r16`–`r17` and the selected-arc timing equation. An empty intersection therefore certifies impossibility.

A second test excludes an arc when its nondepot endpoints’ combined demand exceeds vehicle capacity. A selected arc forces both endpoints to be visited through `r18` and flow conservation; nonnegative demands and `r10` then justify the exclusion.

### 4. Route-duration accounting equalities

For each vehicle, the reformulation adds
\[
TRM_k
=
\sum_{i\ne j,t}tv_{itj}X_{kitj}
+\sum_{i\ne0}at_iY_{ki}.
\]

Summing the selected-arc timing equations and using flow conservation cancels customer arrival and departure terms except for their service times. Unvisited-node times are zero, and `r3` supplies the remaining depot time difference.

This is a **redundant valid equality** that directly connects the objective to routing decisions, strengthening the linear relaxation.

### 5. Redundant constraint removal and data representation

Customer outgoing-degree constraints `r5` were removed because summing `r18` over vehicles and applying `r4` already gives exactly one outgoing arc. Customer incoming-degree constraints `r6` then follow by summing vehicle flow conservation `r9`.

The supplied symmetric, zero-diagonal travel-time matrices were stored by their upper triangles and reconstructed under the original `tv` indices. This is lossless data compression, not a change to travel times or an additional routing assumption.

All original independent variables and the minimization objective were retained, so solution mapping is the identity. The changes target a tighter relaxation and less redundant structure; actual solve-time gains require computational benchmarking.
