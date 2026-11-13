# Time-Dependent Visit Routing: Model and Reformulation

## Problem background

The model represents a **time-dependent traveling-salesperson scheduling problem**. A possible application is planning a technician’s visits when travel times change during the day and some visits cannot overlap specified unavailable periods.

The route starts at node `1`, visits all intermediate nodes exactly once, and finishes at node `n+1`. Nodes `1..n` have service durations `D`; the final node has no modeled service duration. A fixed link from the final node back to the start closes the successor permutation, but this link carries no travel-time or scheduling constraint.

Travel time depends on the departure node, destination, and the time bin containing the departure node’s service-start time. Specifically, the original model uses `tvar[i] div l` to select the travel-time entry. Although physical applications commonly use nonnegative durations and travel times, the declarations do not require this, and the reformulation does not assume it.

Additional requirements include temporal precedences and unavailable intervals. Waiting is allowed because travel constraints impose lower bounds on arrival times rather than equalities.

## Original formulation

### Variables and objective

The model declares five arrays of \(n+1\) bounded integer variables:

| Variable | Meaning |
|---|---|
| `position[i]` | Position of node \(i\) in the route |
| `next[i]` | Successor of node \(i\) |
| `prev[i]` | Predecessor of node \(i\) |
| `tvar[i]` | Service-start or arrival time at node \(i\) |
| `atposition[p]` | Node occupying route position \(p\) |

There are therefore **\(5(n+1)\) independent integer variables**, before any external assignments or solver preprocessing. The objective is an alias for `tvar[n+1]`, which is minimized.

All times lie in `0..H`, where \(H=\texttt{steps}\times l-1\), and the start time is fixed to zero.

### Constraints

The original formulation combines:

- **Route consistency:** `next` and `prev` are inverse permutations, self-links are forbidden, and the final-to-start link is fixed.
- **Route order:** positions increase by one along every nonclosing route arc. The start and finish occupy positions `1` and `n+1`.
- **Travel and service timing:** each selected arc \(i\to j\) requires
  \[
  t_j\ge t_i+D_i+T_{i,j,\lfloor t_i/l\rfloor}.
  \]
  This relationship is expressed twice, using successors and predecessors.
- **Temporal precedences:** each specified pair \(a,b\) satisfies \(t_a+D_a\le t_b\). These are timing constraints, not explicit route-position precedences.
- **Unavailable intervals:** a visit must finish by an interval’s lower endpoint or start at or after its upper endpoint.
- **Redundant strengthening and search channeling:** total-duration inequalities bound the finishing time, while inverse and adjacency constraints connect `atposition` to the route.

## Reformulation for HiGHS

### Binary arc and time-bin representation

The reformulation introduces binary arc variables \(x_{ij}\) and binary arc/bin variables \(y_{ijk}\). Their meanings are:

- \(x_{ij}=1\): the route uses arc \(i\to j\);
- \(y_{ijk}=1\): that arc is used and \(t_i\) belongs to time bin \(k\).

The equation
\[
x_{ij}=\sum_k y_{ijk}
\]
connects these representations. Each nonfinal node has one outgoing arc, and each nonstart node has one incoming arc.

Original `next` and `prev` variables are retained and linked to the selected arc endpoints by weighted sums. Linear position constraints enforce a one-unit position increase on selected arcs. Consequently, a cycle among nonclosing arcs is impossible: summing the required increases around such a cycle would give \(0\) equal to a positive integer. Together with the degree constraints, this leaves one path through all nodes from the start to the finish. Adding the retained fixed closing link recovers the original successor/predecessor permutation.

The inverse relationship between `position` and `atposition` is retained. The original adjacency constraints involving `atposition` then follow from the selected-arc position equations.

### Linear time-bin and travel constraints

For bin \(k\), the departure time must lie between
\[
L_k=kl,\qquad U_k=\min(H,(k+1)l-1).
\]
Weighted lower and upper bounds select this interval using the \(y\) variables. Since exactly one outgoing arc/bin combination is selected, these bounds reproduce the original integer-division lookup.

Travel constraints become
\[
t_j\ge t_i+
\sum_k(D_i+T_{ijk})y_{ijk}
-H(1-x_{ij}).
\]

When the arc is selected, this is exactly the original timing inequality. When it is not selected, all associated \(y\) variables are zero, and the constraint reduces to \(t_j\ge t_i-H\), which follows from \(0\le t_i,t_j\le H\). Thus, the deactivation constant is justified directly by the original time domains, without assuming nonnegative travel or service times.

This replaces variable-indexed travel expressions and duplicate predecessor/successor timing constraints with an explicit mixed-integer linear representation.

### Problem-specific preprocessing

The formulation fixes impossible arc/bin choices to zero:

| Removed choice | Validity argument |
|---|---|
| Self-arcs | Explicitly forbidden in the original model. |
| Nonclosing arcs into the start | The original inverse permutation and `prev[1] = n+1` reserve the start’s incoming arc for the finish. |
| Empty time bins | No time in `0..H` can belong to such a bin. |
| Nonzero departure bins at the start | `tvar[1] = 0` fixes its bin to zero when \(l>0\). |
| Choices with \(L_k+D_i+T_{ijk}>H\) | Even the earliest departure in that bin would force the successor beyond its original upper time bound. |
| Bins wholly excluded by a visit’s unavailable interval | If \(L_k+D_i>a\) and \(U_k<b\), every time in the bin violates both alternatives \(t_i+D_i\le a\) and \(t_i\ge b\). |

The unavailable-interval constraints themselves remain in the model; this preprocessing removes only bins proven impossible.

The explicit conditions `n >= 1`, `steps >= 1`, and `l >= 1` are necessary for a feasible original instance. With `n = 0`, the sole node’s required closing link contradicts the self-link prohibition. For a nonempty route, travel indexing requires a nonempty `0..steps` domain, while the fixed start time requires \(H\ge0\); together these imply positive `steps` and `l`.

### Total-duration strengthening

One linear total-duration inequality is retained:
\[
t_{n+1}\ge
\sum_i D_i+\sum_{i,j,k}T_{ijk}y_{ijk}.
\]

It follows by summing the selected-arc timing inequalities along the path: intermediate times cancel, and the start time is zero. This argument remains valid for signed durations and travel times. The two original versions are equivalent because successors and predecessors describe the same path.

## Interface and solution preservation

All original external parameters, index domains, and five decision-variable arrays are retained. The mapping script copies only those original arrays from the solver output, preserving their encoded indices and reporting missing fields explicitly.

The intended benefit is a more direct linear formulation for HiGHS, with fewer dynamic lookups and stronger early exclusion of impossible choices. No runtime measurements were supplied, so an actual speed improvement remains to be established experimentally.
