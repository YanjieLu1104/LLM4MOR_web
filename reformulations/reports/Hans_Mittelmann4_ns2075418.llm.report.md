# Truck Maintenance Scheduling Reformulation

## Background and operational meaning

The instance represents maintenance scheduling for **147 medium-sized trucks over 208 half-week periods**. The model seeks a minimum-cost schedule while limiting the number of trucks unavailable for service and respecting maintenance capacity.

Three repair indicators represent routine, transmission, and engine maintenance. They are nested: engine maintenance requires the transmission indicator to be active, and transmission maintenance requires the routine indicator to be active. Consequently, their costs accumulate rather than representing mutually exclusive repair choices.

A truck may also enter a maintenance queue. Queue membership counts toward satisfying the model’s repair-frequency requirements and makes the truck unavailable. A queued truck must either remain queued or undergo routine maintenance in the next period. These are the mathematical rules of the supplied model; in particular, queue membership is not equivalent to completed maintenance.

## Original formulation

### Variables and objective

The original model contains **122,304 binary variables**:

- **91,728 repair indicators**, \(x_{i,t,k}\), for each truck, period, and repair type.
- **30,576 queue indicators**, \(v_{i,t}\), for each truck and period.

The objective **minimizes total repair cost**, summed across all active repair indicators. Queue membership has no direct objective cost.

### Constraints

The original model has **349,602 constraints**, excluding variable bounds. Its principal components are:

- **Initial maintenance requirements:** each truck must have a corresponding repair indicator or queue indicator active within a truck-specific initial interval.
- **Rolling maintenance requirements:** every specified window must contain a corresponding repair or queue indicator. The inclusive window lengths are 31, 101, and 181 periods.
- **Queue continuity and exclusion:** queued trucks must remain queued or receive routine maintenance next period; queue membership and routine maintenance cannot occur simultaneously.
- **Repair dependencies:** engine maintenance implies transmission maintenance, which implies routine maintenance.
- **Availability and capacity:** at most 13 trucks may be under routine maintenance or queued in each period; at most four may have routine maintenance active and at most two may have transmission maintenance active.
- **Maintenance duration:** transmission and engine repairs that start after period 1 must remain active for two and six periods, respectively, subject to the remaining planning horizon.

The data include additional capacity and fleet-requirement parameters that are not used by the active constraints. The reformulation preserves these data without adding restrictions based on them.

## Reformulation and its justification

### Continuous start indicators

The reformulation retains every original binary variable and replaces the duration constraints with a **minimum-run extended formulation**.

For transmission and engine maintenance, it introduces a continuous auxiliary variable \(s_{i,t,k}\in[0,1]\) for each period \(t=2,\ldots,208\), together with
\[
s_{i,t,k}\ge x_{i,t,k}-x_{i,t-1,k}.
\]
Thus, whenever a binary repair indicator changes from zero to one, its start indicator must equal one.

For a minimum duration \(L_k\), where \(L_2=2\) and \(L_3=6\), the replacement requires
\[
\sum_{\tau=\max(2,t-L_k+1)}^t s_{i,\tau,k}\le x_{i,t,k}.
\]
A start therefore forces maintenance to remain active throughout the required duration, up to the horizon.

### Why the replacement is valid

The original transmission constraint directly forces the period following a zero-to-one transition to remain active.

For engine maintenance, the original duration inequalities have the form
\[
\frac{1}{d-1}\sum_{h=1}^{d-1}x_{i,j+h,3}
\le x_{i,j,3}+x_{i,j+d,3},
\qquad d=2,\ldots,6.
\]
If \(x_{i,j,3}=0\) and any intervening indicator is one, binary integrality forces the endpoint indicator to one. Applied immediately before a repair starts, these inequalities enforce a six-period run.

Conversely, a schedule satisfying those minimum runs satisfies every original duration inequality: when the first endpoint is zero and an intervening period is active, a subsequent repair start forces the last endpoint to be active. Otherwise, the inequality is automatically satisfied. Thus, the original and replacement duration constraints admit exactly the same binary schedules.

No start indicator is introduced for period 1, preserving the original exemption for initially ongoing repairs. No requirements extend beyond period 208.

### Size and expected benefit

The reformulation introduces **60,858 continuous auxiliary variables** and reduces the constraint count to **291,096**, a reduction of **58,506 constraints**.

This is a **minimum-run extended formulation**, not data pruning or heuristic fixing. It replaces averaged duration inequalities with start-based restrictions that strengthen the duration relaxation and may reduce branch-and-bound effort. Actual runtime improvement remains solver-dependent.

All original data, feasible binary schedules, objective values, and the minimization direction are preserved. Solution mapping simply discards the auxiliary start indicators and retains the original repair and queue variables.
