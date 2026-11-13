# Filter Scheduling and Resource Assignment

## Problem background

The model represents the scheduling of arithmetic operations in a computational filter, plausibly during hardware synthesis. Operations are classified as additions or multiplications, each with a fixed execution duration. A limited number of resources—such as adders and multipliers—can execute operations concurrently.

The task is to choose each operation’s start time and resource assignment while respecting data dependencies and preventing simultaneous use of the same resource. The objective is to minimize the latest completion time among the operations designated by `Last`. The model does **not** explicitly require `Last` to contain every terminal operation, so this objective need not be the makespan of all operations.

## Original formulation

For \(n\) operations, the model has **\(2n+1\) independent integer variables**:

- `t[i]`: operation start time, between 0 and 100.
- `r[i]`: resource identifier, between 1 and 10.
- `objective`: latest completion time over `Last`, between 0 and 1000.

The duration array `d` is fixed by operation type, with its declared domain requiring every operation’s duration to lie between 1 and 10. The arrays `t_add` and `t_mul` are views of the start-time variables, not independent decisions.

The constraints enforce:

1. **Operation-type consistency:** `add` and `mul` are disjoint and their cardinalities sum to \(n\).
2. **Precedence:** for each \(j\in\texttt{dependencies[i]}\),
   \[
   t_i+d_i\le t_j.
   \]
   Thus, despite the array’s name, its entries specify successors of operation \(i\).
3. **Resource availability:** each resource identifier is bounded by the number of available resources of its type, as well as the original upper bound of 10.
4. **Non-overlap:** separate `diffn` constraints for additions and multiplications prevent two operations of the same type from overlapping in time on the same resource.
5. **Exact objective definition:**
   \[
   \texttt{objective}=\max_{i\in\texttt{Last}}(t_i+d_i).
   \]

The original search annotation branches on start times and then resource assignments. Instance-specific counts of precedence constraints and conflicting operation pairs cannot be determined without external data.

## Reformulation and justification

### Bounded-depth precedence preprocessing

The reformulation computes successor relationships reachable through paths of up to four dependency edges, together with corresponding predecessor sets.

Every such relationship follows from the original precedence inequalities. Because operation durations are strictly positive in any feasible solution, a detected path from an operation back to itself makes the instance infeasible. The added cycle checks therefore exclude no feasible schedule.

This is a **partial reachability computation**, not a complete transitive closure. Longer paths remain enforced by the unchanged original dependency constraints.

### Resource-workload bounds

For an operation type with available-resource count \(m\), the effective resource capacity in a feasible nonempty class is
\[
C=\min(10,m),
\]
because both the original resource domain and the type-specific availability constraint apply.

Suppose an operation has \(k\) identified predecessors of one type, each with duration \(p\). All must finish before that operation starts. Since at most \(C\) resources can execute them, at least one resource must process \(\lceil k/C\rceil\) of these operations. Their non-overlap and nonnegative start times imply the valid lower bound
\[
t_i\ge \left\lceil\frac{k}{C}\right\rceil p.
\]

Similarly, if \(k>0\) identified successors have duration \(p\), they must start after operation \(i\) finishes, and every successor must start by time 100. At least one resource processes \(\lceil k/C\rceil\) successors, giving
\[
t_i\le
100+p-d_i-\left\lceil\frac{k}{C}\right\rceil p.
\]

These bounds are computed separately for additions and multiplications. They are then strengthened using precedence: a predecessor’s earliest completion bounds an operation’s start from below, while a successor’s latest start bounds it from above.

The implementation uses a denominator of at least one to avoid division by zero. This does not make unavailable resources usable: the original resource constraints remain and make any nonempty class with nonpositive availability infeasible.

### Elimination of redundant non-overlap disjunctions

A same-type operation pair needs no explicit resource-conflict disjunction when:

- a known precedence path already orders the pair; or
- the derived time bounds guarantee that one operation finishes before the other starts.

In either case, temporal overlap is impossible under retained constraints. Removing that pair’s disjunction therefore preserves feasibility, including when both operations use the same resource.

### Explicit mixed-integer non-overlap formulation

For each remaining same-type pair, the two-dimensional `diffn` condition is replaced by four binary-selected alternatives:

- the first operation finishes before the second starts;
- the second finishes before the first starts;
- the first resource identifier is strictly smaller;
- the second resource identifier is strictly smaller.

These alternatives exactly describe non-overlap of the original rectangles: duration along the time axis and unit height along the integer resource axis.

Exactly one binary is selected as a witness. This does **not** require the other inequalities to be false; any schedule satisfying multiple alternatives can select one of them.

The implications use big-\(M\) constants derived from the tightened start-time bounds and effective resource limits. Consequently, inactive alternatives impose no additional restriction, while the formulation exposes explicit linear constraints to HiGHS. There are four auxiliary binary variables per retained pair.

### Preserved interface and solution mapping

All original external parameters and independent decision variables are retained, as is the exact maximum defining the objective. The solver-specific branching annotation is removed in favor of HiGHS’s mixed-integer search.

The mapping script copies `t`, `r`, and `objective` without reconstruction and excludes auxiliary variables. It reports missing required solution fields rather than supplying defaults.

These changes aim to reduce unnecessary disjunctions and strengthen the mixed-integer formulation. No instance-specific solve-time improvement has been established from the supplied source alone.
